-- Advanced Object Spawner - Client
-- Built with OX Lib | By CoreyJB247

--------------------------
--[[ State Variables ]]--
--------------------------

local GlobalData        = ""
local spawnedObjects    = {}
local inPlacementMode   = false
local inRemoveMode      = false
local inEditMode        = false
local previewHandle     = nil

--------------------------
--[[ Helper Utilities ]]--
--------------------------

local OpenMainMenu
local openCategoryMenu
local openObjectListMenu
local openSpawnedMenu
local openEditMenu

local function getNearbyOwned(coords, radius)
    local found = {}
    for i = #spawnedObjects, 1, -1 do
        local entry = spawnedObjects[i]
        if DoesEntityExist(entry.handle) then
            local dist = #(GetEntityCoords(entry.handle) - coords)
            if dist <= radius then
                found[#found + 1] = { index = i, entry = entry, dist = dist }
            end
        else
            table.remove(spawnedObjects, i)
        end
    end
    table.sort(found, function(a, b) return a.dist < b.dist end)
    return found
end

local function deleteTrackedObject(handle)
    for i, entry in ipairs(spawnedObjects) do
        if entry.handle == handle then
            if DoesEntityExist(handle) then
                SetEntityAsMissionEntity(handle, false, true)
                DeleteObject(handle)
            end
            table.remove(spawnedObjects, i)
            return true
        end
    end
    if DoesEntityExist(handle) then
        SetEntityAsMissionEntity(handle, false, true)
        DeleteObject(handle)
        return true
    end
    return false
end

--------------------------
--[[ Placement Loop   ]]--
--------------------------

--[[
    Controls:
      E          — confirm placement (places one object and returns to menu)
      G          — rotate 90°
      LEFT/RIGHT — fine-rotate
      X          — cancel and return to object list
]]--
local function startPlacementLoop(objectName, displayname, categoryIndex)
    if inPlacementMode then return end
    inPlacementMode = true

    CreateThread(function()
        local modelHash = joaat(objectName)

        -- Fast pre-check: if the hash isn't in the game's content index at all,
        -- skip the stream request entirely and report it as truly invalid.
        if not IsModelInCdimage(modelHash) then
            inPlacementMode = false
            lib.notify({
                title       = 'Object Spawner',
                description = '"' .. objectName .. '" was not found in the game files',
                type        = 'error',
                duration    = 4000
            })
            if categoryIndex then
                openObjectListMenu(categoryIndex)
            else
                openCategoryMenu()
            end
            return
        end

        -- Use a generous timeout (10 s) so large/DLC props have time to stream in
        -- without being incorrectly flagged as invalid.
        local ok, err = pcall(lib.requestModel, modelHash, 10000)
        if not ok then
            inPlacementMode = false
            lib.notify({
                title       = 'Object Spawner',
                description = '"' .. objectName .. '" could not be streamed — try again',
                type        = 'error',
                duration    = 4000
            })
            if categoryIndex then
                openObjectListMenu(categoryIndex)
            else
                openCategoryMenu()
            end
            return
        end

        -- Preview object is local-only (no network sync needed)
        previewHandle = CreateObject(modelHash, GetEntityCoords(cache.ped), false, false, false)
        SetEntityAlpha(previewHandle, 180, false)
        SetEntityCollision(previewHandle, false, false)
        FreezeEntityPosition(previewHandle, true)

        lib.showTextUI(
            '[E] Place  |  [G] Rotate 90°  |  [←/→] Rotate  |  [SHIFT+←/→] Fast Rotate  |  [X] Cancel',
            { position = 'left-center' }
        )

        local placed     = false
        local cancelled  = false
        local lastCoords = nil
        local ePressed   = false
        local xPressed   = false

        local keyThread = CreateThread(function()
            while inPlacementMode and not placed and not cancelled do
                if IsControlJustPressed(0, 38) then ePressed = true end
                if IsControlJustPressed(0, 73) then xPressed = true end
                Wait(0)
            end
        end)

        while inPlacementMode do
            local hit, _, coords, _, _ = lib.raycast.cam(1, 4)

            if hit then
                lastCoords = coords
                SetEntityCoords(previewHandle, coords.x, coords.y, coords.z)
                PlaceObjectOnGroundProperly(previewHandle)
            end

            local rotSpeed = IsControlPressed(0, 21) and 3.5 or 0.5
            if IsControlPressed(0, 174) then
                SetEntityHeading(previewHandle, GetEntityHeading(previewHandle) - rotSpeed)
            end
            if IsControlPressed(0, 175) then
                SetEntityHeading(previewHandle, GetEntityHeading(previewHandle) + rotSpeed)
            end
            if IsControlJustPressed(0, 47) then
                SetEntityHeading(previewHandle, GetEntityHeading(previewHandle) + 90.0)
            end

            if xPressed then
                cancelled = true
                inPlacementMode = false
                break
            end

            if ePressed and lastCoords then
                -- Grab position/heading from preview before deleting it
                local finalCoords  = GetEntityCoords(previewHandle)
                local finalHeading = GetEntityHeading(previewHandle)

                -- Delete the local-only preview ghost
                SetEntityAsMissionEntity(previewHandle, false, true)
                DeleteObject(previewHandle)
                previewHandle = nil

                -- Spawn a networked object so ALL players can see it
                local netObj = CreateObjectNoOffset(
                    modelHash,
                    finalCoords.x, finalCoords.y, finalCoords.z,
                    true,   -- networked
                    true,   -- mission entity
                    false   -- doorFlag
                )
                SetEntityHeading(netObj, finalHeading)
                SetEntityAlpha(netObj, 255, false)
                SetEntityCollision(netObj, true, true)
                FreezeEntityPosition(netObj, Config.FreezeObjects)

                -- Request network control so we own it
                NetworkRequestControlOfEntity(netObj)

                spawnedObjects[#spawnedObjects + 1] = {
                    handle      = netObj,
                    displayname = displayname,
                    object      = objectName,
                }

                if Config.AnnounceSpawn then
                    TriggerServerEvent('ObjSpawner:Announce', GetPlayerName(PlayerId()), displayname)
                end

                lib.notify({
                    title       = 'Object Placed',
                    description = displayname .. ' placed.',
                    type        = 'success',
                    duration    = 2000
                })

                placed          = true
                inPlacementMode = false
                break
            end

            ePressed = false
            Wait(0)
        end

        if not placed then
            if previewHandle and DoesEntityExist(previewHandle) then
                SetEntityAsMissionEntity(previewHandle, false, true)
                DeleteObject(previewHandle)
                previewHandle = nil
            end
        end

        inPlacementMode = false
        lib.hideTextUI()
        if categoryIndex then
            openObjectListMenu(categoryIndex)
        else
            openCategoryMenu()
        end
    end)
end

--------------------------
--[[ Remove Mode Loop ]]--
--------------------------

--[[
    Walk around — owned objects within range highlight with a marker.
    E  — delete highlighted object
    X  — exit remove mode
]]--
local function startRemoveMode()
    if inRemoveMode then return end
    inRemoveMode = true

    lib.showTextUI('[E] Delete highlighted object  |  [X] Exit remove mode', { position = 'left-center' })

    CreateThread(function()
        while inRemoveMode do
            if IsControlJustPressed(0, 73) then
                inRemoveMode = false
                break
            end

            local coords  = GetEntityCoords(cache.ped)
            local nearest = getNearbyOwned(coords, Config.DeleteRadius)

            if nearest[1] then
                local handle    = nearest[1].entry.handle
                local objCoords = GetEntityCoords(handle)

                DrawMarker(28,
                    objCoords.x, objCoords.y, objCoords.z + 1.2,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    0.4, 0.4, 0.4,
                    220, 30, 30, 160,
                    false, false, 2, false, nil, nil, false)

                if IsControlJustPressed(0, 38) then
                    local name = nearest[1].entry.displayname
                    if deleteTrackedObject(handle) then
                        lib.notify({
                            title       = 'Object Spawner',
                            description = name .. ' removed',
                            type        = 'success',
                            duration    = 2000
                        })
                    end
                end
            end

            Wait(0)
        end

        lib.hideTextUI()
        OpenMainMenu()
    end)
end

--------------------------
--[[ Edit Mode Loop   ]]--
--------------------------

--[[
    Controls:
      MOUSE      — move on X/Y axis (camera raycast)
      Q / E      — nudge up / down on Z axis
      LEFT/RIGHT — rotate heading
      SHIFT+←/→  — fast rotate
      G          — rotate 90°
      ENTER      — confirm
      X          — cancel and restore original position
]]--
local function startEditMode(handle, displayname, returnIndex)
    if inEditMode then return end
    inEditMode = true

    local origCoords  = GetEntityCoords(handle)
    local origHeading = GetEntityHeading(handle)

    FreezeEntityPosition(handle, false)
    SetEntityCollision(handle, false, false)
    SetEntityAlpha(handle, 180, false)

    lib.showTextUI(
        '[MOUSE] Move  |  [Q/E] Up/Down  |  [G] Rotate 90°  |  [←/→] Rotate  |  [SHIFT+←/→] Fast Rotate  |  [ENTER] Confirm  |  [X] Cancel',
        { position = 'left-center' }
    )

    CreateThread(function()
        local lockedZ = origCoords.z

        while inEditMode do
            local coords  = GetEntityCoords(handle)
            local heading = GetEntityHeading(handle)

            -- Follow camera raycast, identical to placement loop
            local hit, _, rayCoords, _, _ = lib.raycast.cam(1, 4)
            if hit then
                SetEntityCoords(handle, rayCoords.x, rayCoords.y, lockedZ, false, false, false, false)
                PlaceObjectOnGroundProperly(handle)
                lockedZ = GetEntityCoords(handle).z
            end

            -- Q / E — fine Z nudge
            if IsControlPressed(0, 44) then  -- Q up
                lockedZ = lockedZ + 0.02
                SetEntityCoords(handle, coords.x, coords.y, lockedZ, false, false, false, false)
            end
            if IsControlPressed(0, 38) then  -- E down
                lockedZ = lockedZ - 0.02
                SetEntityCoords(handle, coords.x, coords.y, lockedZ, false, false, false, false)
            end

            -- Rotation with Shift boost and 90° snap
            local rotSpeed = IsControlPressed(0, 21) and 4.0 or 0.8
            if IsControlPressed(0, 174) then
                SetEntityHeading(handle, heading - rotSpeed)
            end
            if IsControlPressed(0, 175) then
                SetEntityHeading(handle, heading + rotSpeed)
            end
            if IsControlJustPressed(0, 47) then  -- G
                SetEntityHeading(handle, heading + 90.0)
            end

            if IsControlJustPressed(0, 201) then
                FreezeEntityPosition(handle, Config.FreezeObjects)
                SetEntityCollision(handle, true, true)
                SetEntityAlpha(handle, 255, false)
                inEditMode = false
                lib.notify({
                    title       = 'Object Spawner',
                    description = displayname .. ' position saved',
                    type        = 'success',
                    duration    = 2000
                })
                break
            end

            if IsControlJustPressed(0, 73) then
                SetEntityCoords(handle,
                    origCoords.x, origCoords.y, origCoords.z,
                    false, false, false, false)
                SetEntityHeading(handle, origHeading)
                FreezeEntityPosition(handle, Config.FreezeObjects)
                SetEntityCollision(handle, true, true)
                SetEntityAlpha(handle, 255, false)
                inEditMode = false
                lib.notify({
                    title       = 'Object Spawner',
                    description = 'Edit cancelled — position restored',
                    type        = 'error',
                    duration    = 2000
                })
                break
            end

            Wait(0)
        end

        lib.hideTextUI()
        openSpawnedMenu(returnIndex)
    end)
end

--------------------------
--[[ Menu: Spawned    ]]--
--------------------------

openSpawnedMenu = function()
    for i = #spawnedObjects, 1, -1 do
        if not DoesEntityExist(spawnedObjects[i].handle) then
            table.remove(spawnedObjects, i)
        end
    end

    if #spawnedObjects == 0 then
        lib.notify({
            title       = 'Object Spawner',
            description = 'You have no active spawned objects',
            type        = 'error'
        })
        OpenMainMenu()
        return
    end

    local menuOptions = {}

    for i, entry in ipairs(spawnedObjects) do
        local handle = entry.handle
        local dname  = entry.displayname
        local idx    = i
        local coords = GetEntityCoords(handle)

        menuOptions[#menuOptions + 1] = {
            title       = dname,
            description = string.format('X: %.1f  Y: %.1f  Z: %.1f', coords.x, coords.y, coords.z),
            icon        = 'fa-solid fa-cube',
            onSelect    = function()
                lib.registerContext({
                    id      = 'objspawner_object_actions',
                    title   = dname,
                    menu    = 'objspawner_spawned_menu',
                    options = {
                        {
                            title       = 'Edit Position',
                            description = 'Reposition and rotate this object',
                            icon        = 'fa-solid fa-arrows-up-down-left-right',
                            iconColor   = '#3498db',
                            onSelect    = function()
                                startEditMode(handle, dname, idx)
                            end
                        },
                        {
                            title       = 'Delete This Object',
                            description = 'Permanently remove this object',
                            icon        = 'fa-solid fa-trash',
                            iconColor   = '#e74c3c',
                            onSelect    = function()
                                if deleteTrackedObject(handle) then
                                    lib.notify({
                                        title       = 'Object Spawner',
                                        description = dname .. ' deleted',
                                        type        = 'success'
                                    })
                                end
                                openSpawnedMenu()
                            end
                        },
                    }
                })
                lib.showContext('objspawner_object_actions')
            end
        }
    end

    lib.registerContext({
        id      = 'objspawner_spawned_menu',
        title   = 'My Spawned Objects (' .. #spawnedObjects .. ')',
        menu    = 'objspawner_main_menu',
        options = menuOptions
    })

    lib.showContext('objspawner_spawned_menu')
end

--------------------------
--[[ Menu: Object List ]]--
--------------------------

openObjectListMenu = function(categoryIndex)
    local category = Config.Categories[categoryIndex]
    if not category then
        openCategoryMenu()
        return
    end

    local menuOptions = {}

    for _, v in ipairs(category.Objects) do
        local obj   = v.Object
        local dname = v.Displayname
        menuOptions[#menuOptions + 1] = {
            title       = dname,
            description = 'Place ' .. dname,
            icon        = 'fa-solid fa-box',
            onSelect    = function()
                startPlacementLoop(obj, dname, categoryIndex)
            end
        }
    end

    lib.registerContext({
        id      = 'objspawner_list_' .. categoryIndex,
        title   = category.Label,
        menu    = 'objspawner_category_menu',
        options = menuOptions
    })

    lib.showContext('objspawner_list_' .. categoryIndex)
end

--------------------------
--[[ Spawn by Name     ]]--
--------------------------

--[[
    Opens an input dialog so the user can type any raw prop/object name.
    Validates the model exists before entering the placement loop.
]]--
local function spawnByName()
    local input = lib.inputDialog('Spawn by Name', {
        {
            type        = 'input',
            label       = 'Object / Prop Name',
            description = 'e.g. prop_worklight_03b or hei_prop_heist_iso_screen',
            placeholder = 'Enter object name...',
            required    = true,
            min         = 3,
        }
    })

    -- User cancelled the dialog
    if not input or not input[1] or input[1] == '' then
        openCategoryMenu()
        return
    end

    local objectName = string.lower(string.gsub(input[1], '%s+', ''))
    local modelHash  = joaat(objectName)

    --[[
        IsModelValid() is unreliable — it returns false for many legitimate
        streamed/DLC objects that don't start with "prop_" (e.g. hei_prop_,
        v_prop_, ch_prop_, ex_prop_, etc.). Instead we attempt to actually
        request the model stream and check IsModelInCdimage, which covers
        the full game asset pool.
    ]]--
    if not IsModelInCdimage(modelHash) then
        lib.notify({
            title       = 'Object Spawner',
            description = '"' .. objectName .. '" was not found in the game files',
            type        = 'error',
            duration    = 3000
        })
        openCategoryMenu()
        return
    end

    local displayname = objectName
    startPlacementLoop(objectName, displayname, nil)
end

--------------------------
--[[ Menu: Categories  ]]--
--------------------------

openCategoryMenu = function()
    local menuOptions = {}

    -- "Spawn by Name" always appears as the first option
    menuOptions[#menuOptions + 1] = {
        title       = 'Spawn by Name',
        description = 'Type any prop name to spawn it directly',
        icon        = 'fa-solid fa-keyboard',
        iconColor   = '#9b59b6',
        onSelect    = function()
            spawnByName()
        end
    }

    for i, cat in ipairs(Config.Categories) do
        local idx = i
        menuOptions[#menuOptions + 1] = {
            title       = cat.Label,
            description = #cat.Objects .. ' object(s) available',
            icon        = 'fa-solid fa-layer-group',
            onSelect    = function()
                openObjectListMenu(idx)
            end
        }
    end

    lib.registerContext({
        id      = 'objspawner_category_menu',
        title   = 'Spawn Object',
        menu    = 'objspawner_main_menu',
        options = menuOptions
    })

    lib.showContext('objspawner_category_menu')
end

--------------------------
--[[ Select to Edit   ]]--
--------------------------

local function selectObjectToEdit()
    -- Clean up stale handles first
    for i = #spawnedObjects, 1, -1 do
        if not DoesEntityExist(spawnedObjects[i].handle) then
            table.remove(spawnedObjects, i)
        end
    end

    if #spawnedObjects == 0 then
        lib.notify({
            title       = 'Object Spawner',
            description = 'You have no active spawned objects to edit',
            type        = 'error'
        })
        OpenMainMenu()
        return
    end

    local menuOptions = {}
    for i, entry in ipairs(spawnedObjects) do
        local handle = entry.handle
        local dname  = entry.displayname
        local idx    = i
        local coords = GetEntityCoords(handle)
        menuOptions[#menuOptions + 1] = {
            title       = dname,
            description = string.format('X: %.1f  Y: %.1f  Z: %.1f', coords.x, coords.y, coords.z),
            icon        = 'fa-solid fa-cube',
            onSelect    = function()
                startEditMode(handle, dname, idx)
            end
        }
    end

    lib.registerContext({
        id      = 'objspawner_select_edit',
        title   = 'Select Object to Edit',
        menu    = 'objspawner_main_menu',
        options = menuOptions
    })

    lib.showContext('objspawner_select_edit')
end

--------------------------
--[[ Menu: Main        ]]--
--------------------------

OpenMainMenu = function()
    local spawnCount = #spawnedObjects

    lib.registerContext({
        id      = 'objspawner_main_menu',
        title   = 'Corey Object Spawner',
        menu = 'unified_main_menu',
        options = {
            {
                title       = 'Spawn Object',
                description = 'Browse categories and place objects',
                icon        = 'fa-solid fa-circle-plus',
                onSelect    = function()
                    openCategoryMenu()
                end
            },
            {
                title       = 'Edit Object Position',
                description = 'Select one of your objects and reposition it',
                icon        = 'fa-solid fa-arrows-up-down-left-right',
                onSelect    = function()
                    selectObjectToEdit()
                end
            },
            {
                title       = 'Remove Mode',
                description = 'Walk around and press [E] to delete nearby objects',
                icon        = 'fa-solid fa-crosshairs',
                onSelect    = function()
                    startRemoveMode()
                end
            },
            {
                title       = 'Remove Nearest Object',
                description = 'Instantly delete the closest object within ' .. Config.DeleteRadius .. 'm',
                icon        = 'fa-solid fa-trash',
                onSelect    = function()
                    local coords  = GetEntityCoords(cache.ped)
                    local nearest = getNearbyOwned(coords, Config.DeleteRadius)
                    if nearest[1] then
                        local name = nearest[1].entry.displayname
                        if deleteTrackedObject(nearest[1].entry.handle) then
                            lib.notify({
                                title       = 'Object Spawner',
                                description = name .. ' removed',
                                type        = 'success'
                            })
                        end
                    else
                        lib.notify({
                            title       = 'Object Spawner',
                            description = 'No objects within ' .. Config.DeleteRadius .. 'm',
                            type        = 'error'
                        })
                    end
                    OpenMainMenu()
                end
            },
            {
                title       = 'Remove All Nearby Objects',
                description = 'Delete all your objects within ' .. Config.DeleteAllRadius .. 'm',
                icon        = 'fa-solid fa-trash-can',
                onSelect    = function()
                    local coords = GetEntityCoords(cache.ped)
                    local nearby = getNearbyOwned(coords, Config.DeleteAllRadius)
                    local count  = 0
                    for _, item in ipairs(nearby) do
                        if deleteTrackedObject(item.entry.handle) then
                            count = count + 1
                        end
                    end
                    if count > 0 then
                        lib.notify({
                            title       = 'Object Spawner',
                            description = count .. ' object(s) removed',
                            type        = 'success'
                        })
                    else
                        lib.notify({
                            title       = 'Object Spawner',
                            description = 'No objects within ' .. Config.DeleteAllRadius .. 'm',
                            type        = 'error'
                        })
                    end
                    OpenMainMenu()
                end
            },
            {
                title       = 'My Spawned Objects',
                description = spawnCount > 0 and (spawnCount .. ' active object(s)') or 'No objects spawned yet',
                icon        = 'fa-solid fa-list',
                onSelect    = function()
                    openSpawnedMenu()
                end
            },
        }
    })

    lib.showContext('objspawner_main_menu')
end

----------------------------
--[[ Permission Checks  ]]--
----------------------------

local function checkPermission()
    local function inArrayPed(val, arr)
        for _, v in pairs(arr) do if GetHashKey(v) == val then return true end end
        return false
    end
    local function inArray(val, arr)
        for _, v in pairs(arr) do if v == val then return true end end
        return false
    end
    local function getSteamId(sid)
        if string.sub(sid, 0, 6) == "steam:" then return string.lower(sid) end
        return "steam:" .. string.format("%x", tonumber(sid))
    end
    local function inArraySteam(val, arr)
        for _, v in pairs(arr) do if getSteamId(v) == val then return true end end
        return false
    end

    if Config.UsageMode == "Ped" then
        if inArrayPed(GetEntityModel(PlayerPedId()), Config.WhitelistedPeds) then
            return true
        end
        lib.notify({ title = 'Access Denied', description = 'You are not in the correct ped', type = 'error' })
        return false

    elseif Config.UsageMode == "IP" then
        TriggerServerEvent("ObjSpawner:GetData", "IP")
        Wait(100)
        if inArray(GlobalData, Config.WhitelistedIPs) then return true end
        lib.notify({ title = 'Access Denied', description = 'Your IP is not whitelisted', type = 'error' })
        return false

    elseif Config.UsageMode == "Steam" then
        TriggerServerEvent("ObjSpawner:GetData", "Steam")
        Wait(100)
        if inArraySteam(GlobalData, Config.WhitelistedSteam) then return true end
        lib.notify({ title = 'Access Denied', description = 'Your Steam ID is not whitelisted', type = 'error' })
        return false

    elseif Config.UsageMode == "Everyone" then
        return true
    end

    return false
end

----------------------------
--[[ Activation         ]]--
----------------------------

if Config.ActivationMode == "Key" then
    RegisterCommand('+objspawner', function()
        if checkPermission() then OpenMainMenu() end
    end)
    RegisterCommand('-objspawner', function() end)
    RegisterKeyMapping('+objspawner', 'Open Object Spawner', 'keyboard', Config.ActivationKey)

elseif Config.ActivationMode == "Command" then
    RegisterCommand(Config.ActivationCommand, function()
        if checkPermission() then OpenMainMenu() end
    end, false)
end

----------------------------
--[[ Network Events     ]]--
----------------------------

RegisterNetEvent('ObjSpawner:ReturnData')
AddEventHandler('ObjSpawner:ReturnData', function(data)
    GlobalData = data
end)