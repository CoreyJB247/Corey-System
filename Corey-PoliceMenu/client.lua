-- ============================================================
--  Police Menu | ox_lib Context Menu
--  Requires: ox_lib
-- ============================================================

local isDragging         = false
local isDragged          = false
local dragTargetServerId = nil
local dragTargetName     = nil
local dragTargetLocalId  = nil

-- ============================================================
--  Spike Strip Config
-- ============================================================
local SPIKE_MODEL    = `p_ld_stinger_s`
local deployedSpikes = {}  -- each entry is a table of 3 objects

-- ============================================================
--  Utility: nearest player within radius
-- ============================================================
local function getClosestPlayer(radius)
    radius = radius or 3.0
    local myPed    = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closest, closestDist = -1, radius

    for _, id in ipairs(GetActivePlayers()) do
        if id ~= PlayerId() then
            local dist = #(myCoords - GetEntityCoords(GetPlayerPed(id)))
            if dist < closestDist then
                closest     = id
                closestDist = dist
            end
        end
    end

    return closest
end

-- ============================================================
--  DRAG — Attachment-based (fixes desync / physics fighting)
-- ============================================================
local function attachSuspect(targetLocalId)
    local myPed      = PlayerPedId()
    local suspectPed = GetPlayerPed(targetLocalId)
    if not DoesEntityExist(suspectPed) then return end

    AttachEntityToEntity(
        suspectPed, myPed,
        GetPedBoneIndex(myPed, 0),
        0.0, 0.8, 0.0,
        0.0, 0.0, 0.0,
        true, true, false, true, 1, true
    )
end

local function detachSuspect(targetLocalId)
    if not targetLocalId then return end
    local suspectPed = GetPlayerPed(targetLocalId)
    if DoesEntityExist(suspectPed) and IsEntityAttached(suspectPed) then
        DetachEntity(suspectPed, true, true)
    end
end

-- ============================================================
--  Spike Strip Logic
-- ============================================================
local function deploySpikeStrip()
    RequestModel(SPIKE_MODEL)
    local timeout = 0
    while not HasModelLoaded(SPIKE_MODEL) do
        Wait(10)
        timeout = timeout + 10
        if timeout > 3000 then
            lib.notify({ title = 'Police', description = 'Failed to load spike model.', type = 'error' })
            return
        end
    end

    local myPed   = PlayerPedId()
    local heading = GetEntityHeading(myPed)
    local pos     = GetEntityCoords(myPed)

    local fwdX = -math.sin(math.rad(heading))
    local fwdY =  math.cos(math.rad(heading))

    local sx = pos.x + fwdX * 2.0
    local sy = pos.y + fwdY * 2.0

    local found, groundZ = GetGroundZFor_3dCoord(sx, sy, pos.z + 1.0, false)
    local sz = found and groundZ or pos.z

    local obj   = CreateObject(SPIKE_MODEL, sx, sy, sz, true, true, true)
    local netId = NetworkGetNetworkIdFromEntity(obj)

    -- Force the object onto all clients and lock ownership to the officer who placed it.
    -- This is exactly how SEM_InteractionMenu does it — without these two calls
    -- the entity can migrate to another client and SetVehicleTyreBurst silently fails.
    SetNetworkIdExistsOnAllMachines(netId, true)
    SetNetworkIdCanMigrate(netId, false)

    SetEntityHeading(obj, heading)
    PlaceObjectOnGroundProperly(obj)
    SetEntityAsMissionEntity(obj, true, true)
    FreezeEntityPosition(obj, true)
    SetEntityInvincible(obj, true)

    SetModelAsNoLongerNeeded(SPIKE_MODEL)
    table.insert(deployedSpikes, { obj })

    -- Since we locked ownership with SetNetworkIdCanMigrate(false), we always own
    -- this entity and SetVehicleTyreBurst will always work without needing to
    -- request control first.
    local stripObj    = obj
    local hitVehicles = {}
    CreateThread(function()
        while DoesEntityExist(stripObj) do
            Wait(0)
            local stripCoords = GetEntityCoords(stripObj)
            local veh = GetClosestVehicle(stripCoords.x, stripCoords.y, stripCoords.z, 4.0, 0, 71)
            if DoesEntityExist(veh) and not hitVehicles[veh] and GetEntitySpeed(veh) > 1.0 then
                if #(stripCoords - GetEntityCoords(veh)) < 2.0 then
                    hitVehicles[veh] = true
                    for wheel = 0, 7 do
                        SetVehicleTyreBurst(veh, wheel, true, 1000.0)
                    end
                end
            end
        end
    end)

    lib.notify({ title = 'Police', description = 'Spike strip deployed.', type = 'success' })
end

local function removeLastSpikeStrip()
    if #deployedSpikes == 0 then
        lib.notify({ title = 'Police', description = 'No spike strips deployed.', type = 'error' })
        return
    end
    local group = table.remove(deployedSpikes)
    for _, obj in ipairs(group) do
        if DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    lib.notify({ title = 'Police', description = 'Spike strip removed.', type = 'inform' })
end


-- ============================================================
--  Context Menu
-- ============================================================
local function openPoliceMenu()
    local targetId       = getClosestPlayer(3.0)
    local targetServerId = isDragging and dragTargetServerId or (targetId ~= -1 and GetPlayerServerId(targetId) or nil)
    local targetName     = isDragging and dragTargetName     or (targetId ~= -1 and (GetPlayerName(targetId) or 'Unknown') or 'Unknown')
    local targetCoords   = targetId ~= -1 and GetEntityCoords(GetPlayerPed(targetId)) or GetEntityCoords(PlayerPedId())
    local hasTarget      = targetServerId ~= nil

    lib.registerContext({
        id          = 'police_menu',
        title       = '🚔  Police Actions',
        description = hasTarget and ('Target: ' .. targetName) or 'No player nearby.',
        options     = {
            {
                title       = '🔗  Cuff / Un-cuff',
                description = 'Handcuff or release the suspect.',
                icon        = 'handcuffs',
                onSelect    = function()
                    if not hasTarget then
                        lib.notify({ title = 'Police', description = 'No player within 3m.', type = 'error' })
                        return
                    end
                    TriggerServerEvent('police:server:cuffPlayer', targetServerId)
                    lib.showContext('police_menu')
                end,
            },
            {
                title       = '🔍  Search Player',
                description = "Search the suspect's pockets.",
                icon        = 'magnifying-glass',
                onSelect    = function()
                    if not hasTarget then
                        lib.notify({ title = 'Police', description = 'No player within 3m.', type = 'error' })
                        return
                    end
                    local officerServerId = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('police:server:requestSearch', targetServerId, officerServerId, targetName)
                    lib.notify({
                        title       = 'Police',
                        description = targetName .. ' is declaring their items...',
                        type        = 'inform',
                        duration    = 5000,
                    })
                    lib.showContext('police_menu')
                end,
            },
            {
                title       = isDragging and '✋  Stop Dragging' or '👊  Drag Suspect',
                description = isDragging and 'Release the suspect.' or 'Grab and drag the suspect with you.',
                icon        = isDragging and 'hand' or 'person-walking-arrow-right',
                onSelect    = function()
                    if isDragging then
                        detachSuspect(dragTargetLocalId)
                        isDragging         = false
                        TriggerServerEvent('police:server:stopDrag', dragTargetServerId)
                        dragTargetServerId = nil
                        dragTargetName     = nil
                        dragTargetLocalId  = nil
                        lib.notify({ title = 'Police', description = 'Suspect released.', type = 'inform' })
                    else
                        if not hasTarget then
                            lib.notify({ title = 'Police', description = 'No player within 3m.', type = 'error' })
                            return
                        end
                        isDragging         = true
                        dragTargetServerId = targetServerId
                        dragTargetName     = targetName
                        dragTargetLocalId  = targetId

                        TriggerServerEvent('police:server:startDrag', targetServerId)
                        lib.notify({ title = 'Police', description = 'Dragging ' .. targetName .. '. Open menu to stop.', type = 'inform' })

                        CreateThread(function()
                            Wait(300)
                            if isDragging then attachSuspect(targetId) end
                        end)
                    end
                end,
            },
            {
                title       = '🚗  Seat in Vehicle',
                description = 'Place suspect into the nearest vehicle.',
                icon        = 'car',
                onSelect    = function()
                    if not hasTarget then
                        lib.notify({ title = 'Police', description = 'No player within 3m.', type = 'error' })
                        return
                    end
                    local veh = GetClosestVehicle(
                        targetCoords.x, targetCoords.y, targetCoords.z,
                        5.0, 0, 71
                    )
                    if not DoesEntityExist(veh) then
                        lib.notify({ title = 'Police', description = 'No vehicle found nearby.', type = 'error' })
                        return
                    end
                    local netId = NetworkGetNetworkIdFromEntity(veh)
                    TriggerServerEvent('police:server:seatInVehicle', targetServerId, netId)
                    lib.notify({ title = 'Police', description = 'Seating suspect in vehicle.', type = 'inform' })
                    lib.showContext('police_menu')
                end,
            },
            {
                title       = '🚪  Remove from Vehicle',
                description = 'Drag the suspect out of their vehicle.',
                icon        = 'door-open',
                onSelect    = function()
                    if not hasTarget then
                        lib.notify({ title = 'Police', description = 'No player within 3m.', type = 'error' })
                        return
                    end
                    TriggerServerEvent('police:server:removeFromVehicle', targetServerId)
                    lib.notify({ title = 'Police', description = 'Removing suspect from vehicle.', type = 'inform' })
                    lib.showContext('police_menu')
                end,
            },
            {
                title       = '🪤  Deploy Spike Strip',
                description = 'Place a spike strip in front of you.',
                icon        = 'road-barrier',
                onSelect    = function()
                    deploySpikeStrip()
                    lib.showContext('police_menu')
                end,
            },
            {
                title       = '🗑️  Remove Last Spike Strip',
                description = ('Remove the most recently deployed strip. (%d deployed)'):format(#deployedSpikes),
                icon        = 'trash',
                onSelect    = function()
                    removeLastSpikeStrip()
                    lib.showContext('police_menu')
                end,
            },

        },
    })

    lib.showContext('police_menu')
end

-- ============================================================
--  Command + Keybind
-- ============================================================
RegisterCommand('pmenu', function()
    openPoliceMenu()
end, false)

RegisterKeyMapping('pmenu', 'Open Police Menu', 'keyboard', 'F6')

RegisterCommand('spikes', function()
    deploySpikeStrip()
end, false)

RegisterCommand('removespikes', function()
    removeLastSpikeStrip()
end, false)

-- ============================================================
--  CLIENT receivers
-- ============================================================

RegisterNetEvent('police:client:setCuffed', function(state)
    local ped = PlayerPedId()
    if state then
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do Wait(10) end
        TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)
        lib.notify({ title = 'Detained', description = 'You have been handcuffed.', type = 'error' })
    else
        ClearPedTasks(ped)
        lib.notify({ title = 'Released', description = 'You have been un-cuffed.', type = 'success' })
    end
end)

RegisterNetEvent('police:client:seatInVehicle', function(vehicleNetId)
    local ped     = PlayerPedId()
    local vehicle = NetToVeh(vehicleNetId)
    if not DoesEntityExist(vehicle) then return end
    local seat = 1
    for s = 0, GetVehicleMaxNumberOfPassengers(vehicle) do
        if IsVehicleSeatFree(vehicle, s) then
            seat = s
            break
        end
    end
    SetPedIntoVehicle(ped, vehicle, seat)
    lib.notify({ title = 'Detained', description = 'You were placed in a vehicle.', type = 'error' })
end)

RegisterNetEvent('police:client:removeFromVehicle', function()
    local ped     = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        TaskLeaveVehicle(ped, vehicle, 16)
        lib.notify({ title = 'Detained', description = 'You were removed from the vehicle.', type = 'error' })
    end
end)

RegisterNetEvent('police:client:openSearchInput', function(officerServerId, officerName)
    lib.notify({
        title       = '🔍 Being Searched',
        description = 'Officer ' .. officerName .. ' is searching you. Declare your items.',
        type        = 'inform',
        duration    = 6000,
    })
    Wait(1000)
    local input = lib.inputDialog('Police Search — Declare Items', {
        {
            type        = 'textarea',
            label       = 'What do you have on you?',
            description = 'List everything in your pockets honestly.',
            placeholder = 'e.g. Wallet, phone, pocket knife...',
            required    = true,
            min         = 1,
            max         = 300,
        },
    })
    local declaration = (input and input[1] and input[1] ~= '') and input[1] or '(No response — suspect refused to declare)'
    TriggerServerEvent('police:server:searchResult', officerServerId, declaration)
end)

RegisterNetEvent('police:client:receiveSearchResult', function(suspectName, declaration)
    lib.notify({
        title       = '🔍 Search Result — ' .. suspectName,
        description = declaration,
        type        = 'inform',
        duration    = 12000,
    })
end)

RegisterNetEvent('police:client:startDrag', function()
    isDragged = true
    local ped = PlayerPedId()

    RequestAnimDict('mp_arresting')
    while not HasAnimDictLoaded('mp_arresting') do Wait(10) end
    TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)

    lib.notify({ title = 'Detained', description = 'You are being dragged.', type = 'error' })

    CreateThread(function()
        while isDragged do
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 21, true)
            Wait(0)
        end
        if IsEntityAttached(ped) then
            DetachEntity(ped, true, true)
        end
        ClearPedTasks(ped)
        lib.notify({ title = 'Released', description = 'You are no longer being dragged.', type = 'inform' })
    end)
end)

RegisterNetEvent('police:client:stopDrag', function()
    isDragged = false
end)

-- ============================================================
--  ox_target — Per-player ped zones
--  Adds Cuff, Search, Drag, Seat in Vehicle, Remove from Vehicle
--  options directly onto nearby player peds.
-- ============================================================

-- Tracked target zones so we can add/remove cleanly
local targetZones = {}  -- [playerId] = zoneName

local function buildTargetOptions(targetLocalId)
    local targetServerId = GetPlayerServerId(targetLocalId)
    local targetName     = GetPlayerName(targetLocalId) or 'Unknown'

    return {
        -- ── Cuff / Un-cuff ──────────────────────────────────────
        {
            name        = 'police_cuff_' .. targetServerId,
            icon        = 'fas fa-handcuffs',
            label       = 'Cuff / Un-cuff',
            groups      = {},           -- remove or populate with job checks e.g. { police = 0 }
            distance    = 2.5,
            onSelect    = function()
                TriggerServerEvent('police:server:cuffPlayer', targetServerId)
            end,
        },
        -- ── Search Player ────────────────────────────────────────
        {
            name        = 'police_search_' .. targetServerId,
            icon        = 'fas fa-magnifying-glass',
            label       = 'Search ' .. targetName,
            groups      = {},
            distance    = 2.5,
            onSelect    = function()
                local officerServerId = GetPlayerServerId(PlayerId())
                TriggerServerEvent('police:server:requestSearch', targetServerId, officerServerId, targetName)
                lib.notify({
                    title       = 'Police',
                    description = targetName .. ' is declaring their items...',
                    type        = 'inform',
                    duration    = 5000,
                })
            end,
        },
        -- ── Drag / Stop Drag ─────────────────────────────────────
        {
            name        = 'police_drag_' .. targetServerId,
            icon        = 'fas fa-person-walking-arrow-right',
            label       = isDragging and 'Stop Dragging' or ('Drag ' .. targetName),
            groups      = {},
            distance    = 2.5,
            onSelect    = function()
                if isDragging then
                    detachSuspect(dragTargetLocalId)
                    isDragging = false
                    TriggerServerEvent('police:server:stopDrag', dragTargetServerId)
                    dragTargetServerId = nil
                    dragTargetName     = nil
                    dragTargetLocalId  = nil
                    lib.notify({ title = 'Police', description = 'Suspect released.', type = 'inform' })
                else
                    isDragging         = true
                    dragTargetServerId = targetServerId
                    dragTargetName     = targetName
                    dragTargetLocalId  = targetLocalId
                    TriggerServerEvent('police:server:startDrag', targetServerId)
                    lib.notify({ title = 'Police', description = 'Dragging ' .. targetName .. '.', type = 'inform' })
                    CreateThread(function()
                        Wait(300)
                        if isDragging then attachSuspect(targetLocalId) end
                    end)
                end
            end,
        },
        -- ── Seat in Vehicle ──────────────────────────────────────
        {
            name        = 'police_seat_' .. targetServerId,
            icon        = 'fas fa-car',
            label       = 'Seat ' .. targetName .. ' in Vehicle',
            groups      = {},
            distance    = 5.0,
            onSelect    = function()
                local targetCoords = GetEntityCoords(GetPlayerPed(targetLocalId))
                local veh = GetClosestVehicle(
                    targetCoords.x, targetCoords.y, targetCoords.z,
                    5.0, 0, 71
                )
                if not DoesEntityExist(veh) then
                    lib.notify({ title = 'Police', description = 'No vehicle found nearby.', type = 'error' })
                    return
                end
                local netId = NetworkGetNetworkIdFromEntity(veh)
                TriggerServerEvent('police:server:seatInVehicle', targetServerId, netId)
                lib.notify({ title = 'Police', description = 'Seating suspect in vehicle.', type = 'inform' })
            end,
        },
        -- ── Remove from Vehicle ──────────────────────────────────
        {
            name        = 'police_removeveh_' .. targetServerId,
            icon        = 'fas fa-door-open',
            label       = 'Remove ' .. targetName .. ' from Vehicle',
            groups      = {},
            distance    = 5.0,
            onSelect    = function()
                TriggerServerEvent('police:server:removeFromVehicle', targetServerId)
                lib.notify({ title = 'Police', description = 'Removing suspect from vehicle.', type = 'inform' })
            end,
        },
    }
end

-- Register an ox_target entity zone on a player's ped
local function addPlayerTarget(targetLocalId)
    if targetLocalId == PlayerId() then return end
    if targetZones[targetLocalId] then return end  -- already registered

    local ped      = GetPlayerPed(targetLocalId)
    local serverId = GetPlayerServerId(targetLocalId)

    if not DoesEntityExist(ped) then return end

    exports.ox_target:addLocalEntity(ped, buildTargetOptions(targetLocalId))
    targetZones[targetLocalId] = serverId
end

-- Remove the target zone from a player's ped
local function removePlayerTarget(targetLocalId)
    if not targetZones[targetLocalId] then return end

    local ped      = GetPlayerPed(targetLocalId)
    local serverId = targetZones[targetLocalId]

    if DoesEntityExist(ped) then
        exports.ox_target:removeLocalEntity(ped, {
            'police_cuff_'      .. serverId,
            'police_search_'    .. serverId,
            'police_drag_'      .. serverId,
            'police_seat_'      .. serverId,
            'police_removeveh_' .. serverId,
        })
    end

    targetZones[targetLocalId] = nil
end

-- ── Tick: keep target zones synced with active players ─────────────────────
CreateThread(function()
    while true do
        Wait(2000)

        local activePlayers = GetActivePlayers()
        local activeSet     = {}

        for _, id in ipairs(activePlayers) do
            if id ~= PlayerId() then
                activeSet[id] = true
                addPlayerTarget(id)
            end
        end

        -- Clean up zones for players who have left
        for id in pairs(targetZones) do
            if not activeSet[id] then
                removePlayerTarget(id)
            end
        end
    end
end)