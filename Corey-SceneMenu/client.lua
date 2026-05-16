-- Scene Menu - Client
-- Object spawning and speed zones using ox_lib CONTEXT menu

local speedZoneActive = false
local blip
local speedZone
local speedzones = {}
local GlobalData = ""

-- Speed zone settings
local selectedRadius = 25
local selectedSpeed = 0

-- Placement state
local inObjectPreview = false
local previewHandle = nil

------------------------
--[[ Placement Loop ]]--
------------------------

--[[
    Raycast-based placement loop.
    Mouse moves the ghost object, E confirms a placement (loops for another),
    G rotates 90°, Left/Right arrow fine-rotates, X cancels the whole session.
    When the session ends the object menu re-opens automatically.
]]
local function startPlacementLoop(objectName, displayname)
    if inObjectPreview then return end
    inObjectPreview = true

    CreateThread(function()
        while inObjectPreview do
            lib.requestModel(joaat(objectName), 1000)

            previewHandle = CreateObject(objectName, GetEntityCoords(cache.ped), false, true, true)
            SetEntityAlpha(previewHandle, 200, false)
            SetEntityCollision(previewHandle, false, false)
            FreezeEntityPosition(previewHandle, true)

            lib.showTextUI(
                '[E] Place  |  [G] Rotate 90°  |  [←/→] Fine Rotate  |  [X] Cancel',
                { position = 'left-center' }
            )

            local placed    = false
            local cancelled = false
            local lastCoords = nil

            local ePressed = false
            local qPressed = false
            local keyThread = CreateThread(function()
                while inObjectPreview and not placed and not cancelled do
                    if IsControlJustPressed(0, 38) then ePressed = true end
                    if IsControlJustPressed(0, 73) then qPressed = true end
                    Wait(0)
                end
            end)

            while inObjectPreview do
                local hit, _, coords, _, _ = lib.raycast.cam(1, 4)

                if hit then
                    lastCoords = coords
                    SetEntityCoords(previewHandle, coords.x, coords.y, coords.z)
                    PlaceObjectOnGroundProperly(previewHandle)
                end

                if IsControlPressed(0, 174) then
                    SetEntityHeading(previewHandle, GetEntityHeading(previewHandle) - 0.3)
                end
                if IsControlPressed(0, 175) then
                    SetEntityHeading(previewHandle, GetEntityHeading(previewHandle) + 0.3)
                end
                if IsControlJustPressed(0, 47) then
                    SetEntityHeading(previewHandle, GetEntityHeading(previewHandle) + 90.0)
                end

                if qPressed then
                    cancelled = true
                    inObjectPreview = false
                    break
                end

                if ePressed and lastCoords then
                    local heading = GetEntityHeading(previewHandle)

                    SetEntityAsMissionEntity(previewHandle, false, true)
                    DeleteObject(previewHandle)
                    previewHandle = nil

                    TriggerServerEvent('SpawnObject', objectName, lastCoords.x, lastCoords.y, lastCoords.z, heading)

                    lib.notify({
                        title = 'Object Placed',
                        description = displayname .. ' placed. [X] to stop.',
                        type = 'success',
                        duration = 2000
                    })

                    placed = true
                    break
                end

                ePressed = false
                Wait(0)
            end

            if previewHandle and DoesEntityExist(previewHandle) then
                SetEntityAsMissionEntity(previewHandle, false, true)
                DeleteObject(previewHandle)
                previewHandle = nil
            end

            if cancelled then break end
        end

        inObjectPreview = false
        lib.hideTextUI()
        openObjectMenu()
    end)
end

------------------------
--[[ Menu Functions ]]--
------------------------

function openObjectMenu()
    local options = {}

    for _, v in pairs(Config.Objects) do
        options[#options + 1] = {
            title = v.Displayname,
            description = 'Place ' .. v.Displayname .. ' — loops until [X]',
            icon = 'box',
            onSelect = function()
                lib.hideContext()
                startPlacementLoop(v.Object, v.Displayname)
            end
        }
    end

    options[#options + 1] = {
        title = 'Delete Nearest Object',
        description = 'Remove the closest prop within 5m',
        icon = 'trash',
        iconColor = 'red',
        onSelect = function()
            local coords = GetEntityCoords(PlayerPedId(), true)
            local deleted = false

            for _, v in pairs(Config.Objects) do
                local hash = GetHashKey(v.Object)
                if DoesObjectOfTypeExistAtCoords(coords.x, coords.y, coords.z, 5.0, hash, true) then
                    local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, hash, false, false, false)
                    DeleteObject(object)
                    deleted = true
                    break
                end
            end

            if deleted then
                lib.notify({ title = 'Scene Menu', description = 'Nearest object removed', type = 'success' })
            else
                lib.notify({ title = 'Scene Menu', description = 'No objects nearby to delete', type = 'error' })
            end

            openObjectMenu()
        end
    }

    lib.registerContext({
        id = 'object_menu',
        title = 'Objects Menu',
        menu = 'scene_main_menu',   -- back button → main menu
        options = options
    })

    lib.showContext('object_menu')
end

--------------------------------------------------------------------

local function openRadiusMenu()
    local options = {}

    for _, v in pairs(Config.SpeedZone.Radius) do
        local val = tonumber(v)
        local isSelected = val == selectedRadius
        options[#options + 1] = {
            title = v .. 'm' .. (isSelected and '  ✓' or ''),
            description = isSelected and 'Currently selected' or 'Select this radius',
            icon = isSelected and 'circle-check' or 'circle',
            iconColor = isSelected and '#2ecc71' or nil,
            onSelect = function()
                selectedRadius = val
                lib.notify({ title = 'Radius Set', description = 'Radius set to ' .. val .. 'm', type = 'success' })
                openRadiusMenu()
            end
        }
    end

    lib.registerContext({
        id = 'radius_menu',
        title = 'Select Radius',
        menu = 'speedzone_menu',    -- back button → speed zone menu
        options = options
    })

    lib.showContext('radius_menu')
end

--------------------------------------------------------------------

local function openSpeedMenu()
    local options = {}

    for _, v in pairs(Config.SpeedZone.Speed) do
        local val = tonumber(v)
        local isSelected = val == selectedSpeed
        options[#options + 1] = {
            title = v .. ' mph' .. (isSelected and '  ✓' or ''),
            description = isSelected and 'Currently selected' or 'Select this speed',
            icon = isSelected and 'circle-check' or 'circle',
            iconColor = isSelected and '#2ecc71' or nil,
            onSelect = function()
                selectedSpeed = val
                lib.notify({ title = 'Speed Limit Set', description = 'Speed set to ' .. val .. ' mph', type = 'success' })
                openSpeedMenu()
            end
        }
    end

    lib.registerContext({
        id = 'speed_menu',
        title = 'Select Speed Limit',
        menu = 'speedzone_menu',    -- back button → speed zone menu
        options = options
    })

    lib.showContext('speed_menu')
end

--------------------------------------------------------------------

local function openSpeedZoneMenu()
    lib.registerContext({
        id = 'speedzone_menu',
        title = 'Speed Zone',
        menu = 'scene_main_menu',   -- back button → main menu
        options = {
            {
                title = 'Speed Zone Radius',
                description = 'Selected: ' .. selectedRadius .. 'm — Click to change',
                icon = 'arrows-left-right',
                iconColor = '#3498db',
                onSelect = function()
                    openRadiusMenu()
                end
            },
            {
                title = 'Speed Zone Limit',
                description = 'Selected: ' .. selectedSpeed .. ' mph — Click to change',
                icon = 'gauge',
                iconColor = '#e74c3c',
                onSelect = function()
                    openSpeedMenu()
                end
            },
            {
                title = 'Create Speed Zone',
                description = 'Radius: ' .. selectedRadius .. 'm | Speed: ' .. selectedSpeed .. ' mph',
                icon = 'circle-plus',
                iconColor = '#2ecc71',
                onSelect = function()
                    speedZoneActive = true
                    local coords = GetEntityCoords(PlayerPedId())
                    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
                    local streetName = GetStreetNameFromHashKey(streetHash)

                    local message = "^* ^1Traffic Announcement: ^r^*^7Police have ordered that traffic on ^2"
                        .. streetName .. " ^7is to travel at a speed of ^2" .. selectedSpeed .. "mph ^7due to an incident."

                    TriggerServerEvent('ZoneActivated', message, selectedSpeed + 0.0, selectedRadius + 0.0, coords.x, coords.y, coords.z)

                    lib.notify({
                        title = 'Speed Zone Created',
                        description = 'Speed limit: ' .. selectedSpeed .. 'mph, Radius: ' .. selectedRadius .. 'm',
                        type = 'success'
                    })

                    openSpeedZoneMenu()
                end
            },
            {
                title = 'Delete Nearest Speed Zone',
                description = 'Remove the closest speed zone',
                icon = 'circle-xmark',
                iconColor = '#e74c3c',
                onSelect = function()
                    TriggerServerEvent('Disable')
                    lib.notify({ title = 'Scene Menu', description = 'Speed Zones Disabled', type = 'success' })
                    openSpeedZoneMenu()
                end
            }
        }
    })

    lib.showContext('speedzone_menu')
end

--------------------------------------------------------------------

function OpenSceneMainMenu()
    lib.registerContext({
        id = 'scene_main_menu',
        title = 'Corey Scene Menu',
        menu = 'unified_main_menu',
        options = {
            {
                title = 'Object Menu',
                description = 'Spawn and manage scene objects',
                icon = 'box',
                onSelect = function()
                    openObjectMenu()
                end
            },
            {
                title = 'Speed Zone',
                description = 'Create and manage speed zones',
                icon = 'gauge',
                iconColor = '#eff158',
                onSelect = function()
                    openSpeedZoneMenu()
                end
            }
        }
    })

    lib.showContext('scene_main_menu')
end

------------------------
--[[ Menu Activation ]]--
------------------------

local function checkPermission()
    if Config.UsageMode == "Ped" then
        local pmodel = GetEntityModel(PlayerPedId())
        if inArrayPed(pmodel, Config.WhitelistedPeds) then
            return true
        else
            lib.notify({ title = 'Access Denied', description = 'You are not in the correct ped to use this', type = 'error' })
            return false
        end
    elseif Config.UsageMode == "IP" then
        TriggerServerEvent("GetData", "IP")
        Wait(100)
        if inArray(GlobalData, Config.WhitelistedIPs) then
            return true
        else
            lib.notify({ title = 'Access Denied', description = 'You are not whitelisted to use this', type = 'error' })
            return false
        end
    elseif Config.UsageMode == "Steam" then
        TriggerServerEvent("GetData", "Steam")
        Wait(100)
        if inArraySteam(GlobalData, Config.WhitelistedSteam) then
            return true
        else
            lib.notify({ title = 'Access Denied', description = 'You are not whitelisted to use this', type = 'error' })
            return false
        end
    elseif Config.UsageMode == "Everyone" then
        return true
    end
    return false
end

if Config.ActivationMode == "Key" then
    RegisterCommand('+scenemenu', function()
        if checkPermission() then
            OpenSceneMainMenu()
        end
    end)

    RegisterCommand('-scenemenu', function() end)

    RegisterKeyMapping('+scenemenu', 'Open Scene Menu', 'keyboard', Config.ActivationKey)
elseif Config.ActivationMode == "Command" then
    RegisterCommand(Config.ActivationCommand, function()
        if checkPermission() then
            OpenSceneMainMenu()
        end
    end, false)
end

------------------------
--[[ Network Events ]]--
------------------------

RegisterNetEvent('ReceiveObject')
AddEventHandler('ReceiveObject', function(objectName, x, y, z, heading)
    lib.requestModel(joaat(objectName), 5000)
    local obj = CreateObject(objectName, x, y, z, true, true, true)
    SetEntityHeading(obj, heading)
    PlaceObjectOnGroundProperly(obj)
    SetEntityCollision(obj, true, true)
    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, true)
end)

RegisterNetEvent('ReturnData')
AddEventHandler('ReturnData', function(data)
    GlobalData = data
end)

RegisterNetEvent('Zone')
AddEventHandler('Zone', function(speed, radius, x, y, z)
    blip = AddBlipForRadius(x, y, z, radius)
    SetBlipColour(blip, 1)
    SetBlipAlpha(blip, 80)
    SetBlipSprite(blip, 9)
    speedZone = AddSpeedZoneForCoord(x, y, z, radius, speed, false)
    table.insert(speedzones, { x, y, z, speedZone, blip })
end)

RegisterNetEvent('RemoveBlip')
AddEventHandler('RemoveBlip', function()
    if speedzones == nil or #speedzones == 0 then return end

    local coords = GetEntityCoords(PlayerPedId(), true)
    local closestSpeedZone = 0
    local closestDistance = 1000

    for i = 1, #speedzones do
        local distance = #(vector3(speedzones[i][1], speedzones[i][2], speedzones[i][3]) - coords)
        if distance < closestDistance then
            closestDistance = distance
            closestSpeedZone = i
        end
    end

    if closestSpeedZone > 0 then
        RemoveSpeedZone(speedzones[closestSpeedZone][4])
        RemoveBlip(speedzones[closestSpeedZone][5])
        table.remove(speedzones, closestSpeedZone)
    end
end)

--------------------------
--[[ Useful Functions ]]--
--------------------------

function inArrayPed(value, array)
    for _, v in pairs(array) do
        if GetHashKey(v) == value then return true end
    end
    return false
end

function inArray(value, array)
    for _, v in pairs(array) do
        if v == value then return true end
    end
    return false
end

function inArraySteam(value, array)
    for _, v in pairs(array) do
        v = getSteamId(v)
        if v == value then return true end
    end
    return false
end

function isNativeSteamId(steamId)
    return string.sub(steamId, 0, 6) == "steam:"
end

function getSteamId(steamId)
    if not isNativeSteamId(steamId) then
        steamId = "steam:" .. string.format("%x", tonumber(steamId))
    else
        steamId = string.lower(steamId)
    end
    return steamId
end