-- ============================================================
--  Police Menu | Server Events
--  Requires: ox_lib
-- ============================================================

local cuffState = {}

RegisterNetEvent('police:server:cuffPlayer', function(targetId)
    local src = source
    cuffState[targetId] = not cuffState[targetId]
    local state = cuffState[targetId]
    TriggerClientEvent('police:client:setCuffed', targetId, state)
    TriggerClientEvent('ox_lib:notify', src, {
        title       = 'Police',
        description = state and 'Suspect cuffed.' or 'Suspect un-cuffed.',
        type        = 'inform',
    })
end)

RegisterNetEvent('police:server:requestSearch', function(targetId, officerServerId, targetName)
    local src         = source
    local officerName = GetPlayerName(src) or 'Officer'
    TriggerClientEvent('police:client:openSearchInput', targetId, officerServerId, officerName)
end)

RegisterNetEvent('police:server:searchResult', function(officerServerId, declaration)
    local src         = source
    local suspectName = GetPlayerName(src) or 'Suspect'
    TriggerClientEvent('police:client:receiveSearchResult', officerServerId, suspectName, declaration)
end)

RegisterNetEvent('police:server:startDrag', function(targetId)
    local src = source

    -- Give the OFFICER network ownership of the suspect's ped
    -- This is what allows SetEntityCoords to work from the officer's client
    local suspectPed = GetPlayerPed(targetId)
    if suspectPed and suspectPed ~= 0 then
        NetworkSetEntityOwner(suspectPed, src)
    end

    -- Notify suspect client to play anim and block movement
    TriggerClientEvent('police:client:startDrag', targetId)
end)

RegisterNetEvent('police:server:stopDrag', function(targetId)
    -- Return ownership to the suspect
    local suspectPed = GetPlayerPed(targetId)
    if suspectPed and suspectPed ~= 0 then
        NetworkSetEntityOwner(suspectPed, targetId)
    end

    TriggerClientEvent('police:client:stopDrag', targetId)
end)

RegisterNetEvent('police:server:seatInVehicle', function(targetId, vehicleNetId)
    TriggerClientEvent('police:client:seatInVehicle', targetId, vehicleNetId)
end)

RegisterNetEvent('police:server:removeFromVehicle', function(targetId)
    TriggerClientEvent('police:client:removeFromVehicle', targetId)
end)