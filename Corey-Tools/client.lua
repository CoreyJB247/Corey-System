-- client.lua
local noclipEnabled = false
local noclipSpeedIndex = 3 -- Default to Normal speed
local hudHidden = false
local radarHidden = false
local isRecording = false

-- Noclip Variables
local heading = 0.0
local coords = vector3(0, 0, 0)

-- Noclip Speed Settings
-- Values are units/second; delta time scaling is applied in the movement thread
local noclipSpeeds = {
    {name = "Very Slow",      speed = 5.0},
    {name = "Slow",           speed = 15.0},
    {name = "Normal",         speed = 50.0},
    {name = "Fast",           speed = 100.0},
    {name = "Very Fast",      speed = 175.0},
    {name = "Extremely Fast", speed = 250.0},
    {name = "Max Speed",      speed = 350.0}
}

-- Noclip Keybind
local noclipKeybind = lib.addKeybind({
    name = 'noclip_toggle',
    description = 'Toggle Noclip',
    defaultKey = 'F2',
    onPressed = function()
        ToggleNoclip()
    end,
})

-- Teleport to Waypoint Keybind
local tpWaypointKeybind = lib.addKeybind({
    name = 'tp_waypoint',
    description = 'Teleport to Waypoint',
    defaultKey = 'F7',
    onPressed = function()
        TeleportToWaypoint()
    end,
})

-- Noclip Speed Change Keybind (Shift key while in noclip)
local shiftPressed = false

-- Change Noclip Speed
function ChangeNoclipSpeed(direction)
    noclipSpeedIndex = noclipSpeedIndex + direction

    -- Loop around if exceeding bounds
    if noclipSpeedIndex > #noclipSpeeds then
        noclipSpeedIndex = 1
    elseif noclipSpeedIndex < 1 then
        noclipSpeedIndex = #noclipSpeeds
    end

    local currentSpeed = noclipSpeeds[noclipSpeedIndex]
    lib.notify({
        title = 'Noclip Speed',
        description = currentSpeed.name,
        type = 'info',
        duration = 4000,
        position = 'top-right'
    })
end

-- Noclip System
function ToggleNoclip()
    noclipEnabled = not noclipEnabled

    if not noclipEnabled then
        lib.notify({
            title = 'Noclip',
            description = 'Disabled',
            type = 'error'
        })
        return
    end

    -- All Wait() calls must be inside a thread
    CreateThread(function()
        local ped = PlayerPedId()

        -- Noclip HUD bar using INSTRUCTIONAL_BUTTONS scaleform
        local scaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(0)
        end

        CreateThread(function()
            while noclipEnabled do
                Wait(0)

                local speedName = noclipSpeeds[noclipSpeedIndex].name

                BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
                ScaleformMovieMethodAddParamInt(200)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
                ScaleformMovieMethodAddParamInt(0)
                ScaleformMovieMethodAddParamInt(0)
                ScaleformMovieMethodAddParamInt(0)
                ScaleformMovieMethodAddParamInt(80)
                EndScaleformMovieMethod()

                local slot = 0
                local function AddButton(label, ...)
                    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(slot)
                    for _, controlId in ipairs({...}) do
                        ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(0, controlId, true))
                    end
                    ScaleformMovieMethodAddParamPlayerNameString(label)
                    EndScaleformMovieMethod()
                    slot = slot + 1
                end

                -- Control IDs for keyboard keys used in noclip
                AddButton("Change Speed (" .. speedName .. ")", 21)   -- SHIFT
                AddButton("Slow Mode", 36)                             -- CTRL
                AddButton("Move", 33, 32)                             -- S, W
                AddButton("Down", 48)                                  -- Z
                AddButton("Up", 85)                                    -- Q

                BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
                EndScaleformMovieMethod()

                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            end

            SetScaleformMovieAsNoLongerNeeded(scaleform)
        end)

        CreateThread(function()
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            local entity = vehicle > 0 and vehicle or ped
            local lastVehicle = vehicle

            local function RestoreEntity(e)
                if e and e > 0 and DoesEntityExist(e) then
                    FreezeEntityPosition(e, false)
                    SetEntityCollision(e, true, true)
                    SetEntityInvincible(e, false)
                    SetEntityVisible(e, true, false)
                    NetworkSetEntityInvisibleToNetwork(e, false)
                    ResetEntityAlpha(e)
                end
            end

            while noclipEnabled do
                Wait(0)

                ped = PlayerPedId()
                vehicle = GetVehiclePedIsIn(ped, false)
                entity = vehicle > 0 and vehicle or ped

                if vehicle > 0 then
                    lastVehicle = vehicle
                end

                local currentCoords = GetEntityCoords(entity)

                -- Disable controls
                DisableControlAction(0, 30, true) -- MoveLeftRight
                DisableControlAction(0, 31, true) -- MoveUpDown
                DisableControlAction(0, 32, true) -- W
                DisableControlAction(0, 33, true) -- S
                DisableControlAction(0, 34, true) -- A
                DisableControlAction(0, 35, true) -- D
                DisableControlAction(0, 21, true) -- Shift
                DisableControlAction(0, 36, true) -- Ctrl
                DisableControlAction(0, 44, true) -- Q

                -- Set entity properties
                SetEntityVelocity(entity, 0.0, 0.0, 0.0)

                SetEntityVisible(entity, false, false)
                SetLocalPlayerVisibleLocally(true)
                SetEntityAlpha(entity, 150, false)

                FreezeEntityPosition(entity, true)
                SetEntityCollision(entity, false, false)
                SetEntityInvincible(entity, true)

                NetworkSetEntityInvisibleToNetwork(entity, true)

                if IsDisabledControlJustPressed(0, 21) then -- Left Shift
                    if not shiftPressed then
                        shiftPressed = true
                        ChangeNoclipSpeed(1)
                    end
                elseif IsDisabledControlJustReleased(0, 21) then
                    shiftPressed = false
                end

                -- Get camera rotation
                local camRot = GetGameplayCamRot(2)
                local camHeading = camRot.z

                -- Movement speed scaled by delta time
                local speed = noclipSpeeds[noclipSpeedIndex].speed * GetFrameTime()

                -- Ctrl for slow mode (0.3x)
                if IsDisabledControlPressed(0, 36) then -- Left Ctrl
                    speed = speed * 0.3
                end

                local moveX, moveY, moveZ = 0.0, 0.0, 0.0

                local radHeading = math.rad(camHeading)

                -- Forward/Backward (W/S)
                if IsDisabledControlPressed(0, 32) then -- W
                    moveX = moveX + (-math.sin(radHeading) * speed)
                    moveY = moveY + (math.cos(radHeading) * speed)
                end
                if IsDisabledControlPressed(0, 33) then -- S
                    moveX = moveX - (-math.sin(radHeading) * speed)
                    moveY = moveY - (math.cos(radHeading) * speed)
                end

                -- Up/Down (Q/Z)
                if IsDisabledControlPressed(0, 20) then -- Z (Down)
                    moveZ = moveZ - speed
                end
                if IsDisabledControlPressed(0, 44) then -- Q (Up)
                    moveZ = moveZ + speed
                end

                -- Apply movement
                local newX = currentCoords.x + moveX
                local newY = currentCoords.y + moveY
                local newZ = currentCoords.z + moveZ

                SetEntityCoordsNoOffset(entity, newX, newY, newZ, true, true, true)
                SetEntityRotation(entity, 0.0, 0.0, camHeading, 2, true)
                SetEntityHeading(entity, camHeading)
            end

            -- Cleanup when noclip is disabled
            RestoreEntity(PlayerPedId())
            if lastVehicle > 0 then
                RestoreEntity(lastVehicle)
            end
        end)
    end) -- end CreateThread
end

-- Toggle HUD
local function ToggleHUD()
    hudHidden = not hudHidden
    DisplayHud(not hudHidden)

    lib.notify({
        title = 'HUD',
        description = hudHidden and 'HUD hidden' or 'HUD shown',
        type = hudHidden and 'error' or 'success'
    })

    OpenMiscMenu()
end

-- Toggle Radar
local function ToggleRadar()
    radarHidden = not radarHidden
    DisplayRadar(not radarHidden)

    lib.notify({
        title = 'Radar',
        description = radarHidden and 'Radar hidden' or 'Radar shown',
        type = radarHidden and 'error' or 'success'
    })

    OpenMiscMenu()
end

-- Rockstar Editor Recording Functions
function StartEditorRecording()
    if IsRecording() then
        lib.notify({
            title = 'Rockstar Editor',
            description = 'Already recording',
            type = 'error'
        })
        OpenMiscMenu()
        return
    end

    StartRecording(1)
    isRecording = true

    lib.notify({
        title = 'Rockstar Editor',
        description = 'Recording started',
        type = 'success'
    })

    OpenMiscMenu()
end

function StopAndSaveClip()
    if not IsRecording() then
        lib.notify({
            title = 'Rockstar Editor',
            description = 'Not currently recording',
            type = 'error'
        })
        OpenMiscMenu()
        return
    end

    StopRecordingAndSaveClip()
    isRecording = false

    lib.notify({
        title = 'Rockstar Editor',
        description = 'Recording stopped and clip saved',
        type = 'success'
    })

    OpenMiscMenu()
end

function DiscardRecording()
    if not IsRecording() then
        lib.notify({
            title = 'Rockstar Editor',
            description = 'Not currently recording',
            type = 'error'
        })
        OpenMiscMenu()
        return
    end

    StopRecording()
    isRecording = false

    lib.notify({
        title = 'Rockstar Editor',
        description = 'Recording discarded',
        type = 'error'
    })

    OpenMiscMenu()
end

function ToggleRecording()
    if IsRecording() then
        StopAndSaveClip()
    else
        StartEditorRecording()
    end
end

-- Rockstar Editor Chat Commands
RegisterCommand('record', function()
    if IsRecording() then
        lib.notify({
            title = 'Rockstar Editor',
            description = 'Already recording — use /saveclip to save or /discardclip to discard',
            type = 'error'
        })
    else
        StartEditorRecording()
    end
end, false)

RegisterCommand('saveclip', function()
    StopAndSaveClip()
end, false)

RegisterCommand('discardclip', function()
    DiscardRecording()
end, false)

-- Teleport to Waypoint
function TeleportToWaypoint()
    local waypoint = GetFirstBlipInfoId(8)

    if not DoesBlipExist(waypoint) then
        lib.notify({
            title = 'Error',
            description = 'No waypoint set',
            type = 'error'
        })
        return
    end

    local pos = GetBlipCoords(waypoint)

    CreateThread(function()
        local ped       = PlayerPedId()
        local vehHandle = GetVehiclePedIsIn(ped, false)
        local inVeh     = vehHandle > 0
        local entity    = inVeh and vehHandle or ped

        -- 1. Fade out
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Wait(0) end

        -- 2. Stream the destination area
        NewLoadSceneStart(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z, 50.0, 0)

        -- 3. Move entity up high at waypoint XY
        FreezeEntityPosition(entity, true)
        SetEntityCoords(entity, pos.x, pos.y, 1000.0, false, false, false, true)

        -- 4. Wait for scene to load (max ~3 s)
        local timeout = 0
        while not IsNewLoadSceneLoaded() and timeout < 300 do
            Wait(10)
            timeout = timeout + 1
        end
        NewLoadSceneStop()

        -- 5. Per-frame ground detection loop
        local groundFound = false
        local groundZ     = 0.0
        local maxTries    = 300
        local tries       = 0

        while not groundFound and tries < maxTries do
            groundFound, groundZ = GetGroundZFor_3dCoord(pos.x, pos.y, 1000.0, false)
            tries = tries + 1
            if not groundFound then
                SetEntityCoords(entity, pos.x, pos.y, 1000.0 - (tries * 2.5), false, false, false, true)
                Wait(0)
            end
        end

        -- 6. Place on found ground, or fall back to nearest road node
        if groundFound then
            SetEntityCoords(entity, pos.x, pos.y, groundZ + 0.5, false, false, false, true)
        else
            local nodeFound, nodeX, nodeY, nodeZ = GetNthClosestVehicleNode(pos.x, pos.y, pos.z, 0, 1, 0, 0)
            if nodeFound then
                SetEntityCoords(entity, nodeX, nodeY, nodeZ, false, false, false, true)
            else
                SetEntityCoords(entity, pos.x, pos.y, pos.z, false, false, false, true)
            end
            lib.notify({
                title = 'Teleport',
                description = 'Could not find ground — placed on nearest road',
                type = 'warning'
            })
        end

        -- 7. For vehicles: align wheels/chassis
        FreezeEntityPosition(entity, false)
        if inVeh then
            SetVehicleOnGroundProperly(vehHandle)
        end

        -- 8. Fade back in
        DoScreenFadeIn(500)

        if groundFound then
            lib.notify({
                title = 'Teleported',
                description = 'Teleported to waypoint',
                type = 'success'
            })
        end
    end)
end

-- Copy Coordinates Functions
local function CopyVec3()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local formattedCoords = string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)

    lib.setClipboard(formattedCoords)
    lib.notify({
        title = 'Coordinates Copied',
        description = formattedCoords,
        type = 'success',
        duration = 5000
    })

    OpenCoordsMenu()
end

local function CopyVec4()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local formattedCoords = string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, heading)

    lib.setClipboard(formattedCoords)
    lib.notify({
        title = 'Coordinates Copied',
        description = formattedCoords,
        type = 'success',
        duration = 5000
    })

    OpenCoordsMenu()
end

local function CopyCoords()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local formattedCoords = string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z)

    lib.setClipboard(formattedCoords)
    lib.notify({
        title = 'Coordinates Copied',
        description = formattedCoords,
        type = 'success',
        duration = 5000
    })

    OpenCoordsMenu()
end

local function CopyHeading()
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    local formattedHeading = string.format("%.2f", heading)

    lib.setClipboard(formattedHeading)
    lib.notify({
        title = 'Heading Copied',
        description = formattedHeading,
        type = 'success',
        duration = 5000
    })

    OpenCoordsMenu()
end

-- Coords Context Menu
function OpenCoordsMenu()
    lib.registerContext({
        id = 'coords_menu',
        title = 'Copy Coordinates',
        menu = 'misc_menu',  -- back button returns to misc menu
        options = {
            {
                title = 'Copy vec3',
                description = 'Copy as vector3(x, y, z)',
                icon = 'copy',
                onSelect = function()
                    CopyVec3()
                end
            },
            {
                title = 'Copy vec4',
                description = 'Copy as vector4(x, y, z, heading)',
                icon = 'copy',
                onSelect = function()
                    CopyVec4()
                end
            },
            {
                title = 'Copy x, y, z',
                description = 'Copy as x, y, z',
                icon = 'copy',
                onSelect = function()
                    CopyCoords()
                end
            },
            {
                title = 'Copy Heading',
                description = 'Copy heading only',
                icon = 'compass',
                onSelect = function()
                    CopyHeading()
                end
            }
        }
    })

    lib.showContext('coords_menu')
end

function OpenAopMenu()
    lib.registerContext({
        id = 'aop_menu',
        title = 'Set AOP - Area of Patrol',
        menu = 'misc_menu',  -- back button returns to misc menu
        options = {
            {
                title = 'Los Santos',
                description = 'Set AOP to Los Santos',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop Los Santos')
                    OpenAopMenu()
                end
            },
            {
                title = 'Blaine County',
                description = 'Set AOP to Blaine County',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop Blaine County')
                    OpenAopMenu()
                end
            },
            { title = '', disabled = true },
            {
                title = 'Paleto Bay',
                description = 'Set AOP to Paleto Bay',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop Paleto Bay')
                    OpenAopMenu()
                end
            },
            {
                title = 'Sandy Shores',
                description = 'Set AOP to Sandy Shores',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop Sandy Shores')
                    OpenAopMenu()
                end
            },
            {
                title = 'Grapeseed',
                description = 'Set AOP to Sandy Shores',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop Grapeseed')
                    OpenAopMenu()
                end
            },
            { title = '', disabled = true },
            {
                title = 'Vespucci',
                description = 'Set AOP to Vespucci',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop Vespucci')
                    OpenAopMenu()
                end
            },
            {
                title = 'North Los Santos',
                description = 'Set AOP to North Los Santos',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop North Los Santos')
                    OpenAopMenu()
                end
            },
            {
                title = 'South Los Santos',
                description = 'Set AOP to South Los Santos',
                icon = 'map',
                onSelect = function()
                    ExecuteCommand('aop South Los Santos')
                    OpenAopMenu()
                end
            },
        }
    })

    lib.showContext('aop_menu')
end

-- Online Players Context Menu
-- Ping is server-side only, so we fetch it via callback.
-- We also use the server-side player list so ALL players are shown,
-- not just nearby ones.
function OpenPlayersMenu()
    lib.callback('miscmenu:getPlayerPings', false, function(pingData)
        local options = {}
        local playerCount = 0

        for serverIdStr, data in pairs(pingData) do
            local serverId = tonumber(serverIdStr)
            local name = data.name or ('Player ' .. serverIdStr)
            local ping = data.ping or 0

            -- Colour-code ping indicator
            local pingColor
            if ping < 80 then
                pingColor = '#2ecc71'  -- green
            elseif ping < 150 then
                pingColor = '#f39c12'  -- orange
            else
                pingColor = '#e74c3c'  -- red
            end

            options[#options + 1] = {
                title = name,
                description = string.format('Server ID: %d  |  Ping: %d ms', serverId, ping),
                icon = 'circle',
                iconColor = pingColor,
            }
            playerCount = playerCount + 1
        end

        -- Sort by server ID for a consistent order
        table.sort(options, function(a, b)
            local idA = tonumber(a.description:match('Server ID: (%d+)'))
            local idB = tonumber(b.description:match('Server ID: (%d+)'))
            return idA < idB
        end)

        lib.registerContext({
            id = 'players_menu',
            title = string.format('Online Players (%d)', playerCount),
            menu = 'misc_menu',  -- back button returns to misc menu
            options = options
        })

        lib.showContext('players_menu')
    end)
end

--------------------------------------------------------
-- Clear Area
--------------------------------------------------------

local CLEAR_AREA_RADIUS = 150.0

-- Triggered by the server once it has validated the request.
-- Deletes all entities matching the provided network IDs on this client.
RegisterNetEvent('miscmenu:clearAreaSync')
AddEventHandler('miscmenu:clearAreaSync', function(networkIds)
    for _, netId in ipairs(networkIds) do
        if NetworkDoesEntityExistWithNetworkId(netId) then
            local entity = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
        end
    end
end)

local function DoClearArea()
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local myVeh  = GetVehiclePedIsIn(ped, false)

    local netIds = {}

    local function tryAdd(entity)
        if not DoesEntityExist(entity) then return end
        if IsEntityAMissionEntity(entity) then return end
        if entity == ped then return end
        if myVeh > 0 and entity == myVeh then return end
        if #(coords - GetEntityCoords(entity)) <= CLEAR_AREA_RADIUS
            and NetworkGetEntityIsNetworked(entity)
        then
            netIds[#netIds + 1] = NetworkGetNetworkIdFromEntity(entity)
        end
    end

    for _, e in ipairs(GetGamePool('CPed'))     do tryAdd(e) end
    for _, e in ipairs(GetGamePool('CVehicle')) do tryAdd(e) end
    for _, e in ipairs(GetGamePool('CObject'))  do tryAdd(e) end

    TriggerServerEvent('miscmenu:clearArea', netIds, coords, CLEAR_AREA_RADIUS)

    lib.notify({
        title       = 'Clear Area',
        description = string.format('Clearing everything within %.0f m…', CLEAR_AREA_RADIUS),
        type        = 'success',
        duration    = 4000
    })

    lib.showContext('misc_menu')
end

-- Main Misc Context Menu
function OpenMiscMenu()
    lib.registerContext({
        id = 'misc_menu',
        title = 'Corey Tools',
        menu = 'unified_main_menu',
        options = {
            {
                title = 'Teleport to Waypoint',
                description = 'Teleport to your map waypoint',
                icon = 'location-crosshairs',
                onSelect = function()
                    TeleportToWaypoint()
                end
            },
            {
                title = 'Online Players',
                description = 'View all connected players and their ping',
                icon = 'users',
                onSelect = function()
                    OpenPlayersMenu()
                end
            },
            { title = '', disabled = true },
            {
                title = 'Toggle HUD',
                description = hudHidden and 'Show HUD' or 'Hide HUD',
                icon = 'eye',
                onSelect = function()
                    ToggleHUD()
                end
            },
            {
                title = 'Toggle Radar',
                description = radarHidden and 'Show Radar' or 'Hide Radar',
                icon = 'map',
                onSelect = function()
                    ToggleRadar()
                end
            },
            {
                title = 'Toggle RHUD',
                description = 'Toggle the hud system',
                icon = 'eye',
                onSelect = function()
                    ExecuteCommand('rhud')
                    OpenMiscMenu()
                end
            },
            { title = '', disabled = true },
            {
                title = 'Start Recording',
                description = isRecording and '🔴 Already recording' or 'Begin a Rockstar Editor recording (/record)',
                icon = 'circle',
                onSelect = function()
                    StartEditorRecording()
                end
            },
            {
                title = 'Save Clip',
                description = 'Stop recording and save the clip (/saveclip)',
                icon = 'floppy-disk',
                onSelect = function()
                    StopAndSaveClip()
                end
            },
            {
                title = 'Discard Recording',
                description = 'Stop recording and discard the clip (/discardclip)',
                icon = 'trash',
                onSelect = function()
                    DiscardRecording()
                end
            },
            { title = '', disabled = true },
            {
                title = 'Copy Coordinates',
                description = 'Open coordinates menu',
                icon = 'location-dot',
                onSelect = function()
                    OpenCoordsMenu()
                end
            },
            {
                title = 'Set AOP',
                description = 'Set Area Of Patrol Location (Must be mutally agreed or set by admin)',
                icon = 'map',
                onSelect = function()
                    OpenAopMenu()
                end
            },
            {
                title = 'Clear Area',
                description = string.format('Delete all peds, vehicles & objects within %.0f m (synced)', CLEAR_AREA_RADIUS),
                icon = 'trash',
                iconColor = '#c0392b',
                onSelect = function()
                    DoClearArea()
                end
            }
        }
    })

    lib.showContext('misc_menu')
end

-- Command to open menu
RegisterCommand('misc', function()
    OpenMiscMenu()
end, false)