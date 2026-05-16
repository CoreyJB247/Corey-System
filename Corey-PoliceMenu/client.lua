-- ============================================================
--  Police Menu | ox_lib Context Menu
--  Requires: ox_lib
-- ============================================================

local isDragging         = false
local isDragged          = false
local dragTargetServerId = nil
local dragTargetName     = nil
local dragThread         = nil

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
--  DRAG — runs on OFFICER's client
--  Server sets network owner to officer first, then we move the ped
-- ============================================================
local function startDragThread(targetLocalId)
    if dragThread then return end

    dragThread = CreateThread(function()
        local myPed      = PlayerPedId()
        local suspectPed = GetPlayerPed(targetLocalId)

        while isDragging do
            suspectPed = GetPlayerPed(targetLocalId) -- refresh each tick

            if DoesEntityExist(suspectPed) then
                local heading = GetEntityHeading(myPed)
                local rad     = math.rad(heading)
                local pos     = GetEntityCoords(myPed)

                local bx = pos.x + math.sin(rad) * 1.0
                local by = pos.y - math.cos(rad) * 1.0

                SetEntityCoords(suspectPed, bx, by, pos.z, false, false, false, false)
            end

            Wait(0)
        end

        dragThread = nil
    end)
end

-- ============================================================
--  Context Menu
-- ============================================================
local function openPoliceMenu()
    local targetId = getClosestPlayer(3.0)

    if targetId == -1 and not isDragging then
        lib.notify({ title = 'Police', description = 'No player within 3m.', type = 'error' })
        return
    end

    local targetServerId = isDragging and dragTargetServerId or (targetId ~= -1 and GetPlayerServerId(targetId) or nil)
    local targetName     = isDragging and dragTargetName     or (targetId ~= -1 and (GetPlayerName(targetId) or 'Unknown') or 'Unknown')
    local targetCoords   = targetId ~= -1 and GetEntityCoords(GetPlayerPed(targetId)) or GetEntityCoords(PlayerPedId())

    if not targetServerId then
        lib.notify({ title = 'Police', description = 'No player within 3m.', type = 'error' })
        return
    end

    lib.registerContext({
        id          = 'police_menu',
        title       = '🚔  Police Actions',
        description = 'Target: ' .. targetName,
        options     = {
            {
                title       = '🔗  Cuff / Un-cuff',
                description = 'Handcuff or release the suspect.',
                icon        = 'handcuffs',
                onSelect    = function()
                    TriggerServerEvent('police:server:cuffPlayer', targetServerId)
                    lib.showContext('police_menu')
                end,
            },
            {
                title       = '🔍  Search Player',
                description = "Search the suspect's pockets.",
                icon        = 'magnifying-glass',
                onSelect    = function()
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
                        isDragging         = false
                        TriggerServerEvent('police:server:stopDrag', dragTargetServerId)
                        dragTargetServerId = nil
                        dragTargetName     = nil
                        lib.notify({ title = 'Police', description = 'Suspect released.', type = 'inform' })
                    else
                        isDragging         = true
                        dragTargetServerId = targetServerId
                        dragTargetName     = targetName

                        -- Ask server to give us network ownership of suspect ped
                        -- then start the drag loop once confirmed
                        TriggerServerEvent('police:server:startDrag', targetServerId)
                        lib.notify({ title = 'Police', description = 'Dragging ' .. targetName .. '. Open menu to stop.', type = 'inform' })

                        -- Start drag thread with the local player id
                        startDragThread(targetId)
                    end
                end,
            },
            {
                title       = '🚗  Seat in Vehicle',
                description = 'Place suspect into the nearest vehicle.',
                icon        = 'car',
                onSelect    = function()
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
                    TriggerServerEvent('police:server:removeFromVehicle', targetServerId)
                    lib.notify({ title = 'Police', description = 'Removing suspect from vehicle.', type = 'inform' })
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

-- Suspect side: freeze in place and play anim while being dragged
RegisterNetEvent('police:client:startDrag', function()
    isDragged = true
    local ped = PlayerPedId()

    RequestAnimDict('mp_arresting')
    while not HasAnimDictLoaded('mp_arresting') do Wait(10) end
    TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)

    lib.notify({ title = 'Detained', description = 'You are being dragged.', type = 'error' })

    -- Block movement while dragged so they don't fight the position
    CreateThread(function()
        while isDragged do
            DisableControlAction(0, 30, true)  -- Move LR
            DisableControlAction(0, 31, true)  -- Move UD
            DisableControlAction(0, 21, true)  -- Sprint
            Wait(0)
        end
        ClearPedTasks(PlayerPedId())
        lib.notify({ title = 'Released', description = 'You are no longer being dragged.', type = 'inform' })
    end)
end)

RegisterNetEvent('police:client:stopDrag', function()
    isDragged = false
end)