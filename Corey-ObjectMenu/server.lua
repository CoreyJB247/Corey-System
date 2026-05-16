-- Advanced Object Spawner - Server

--[[
    Provides identity lookups for IP / Steam whitelisting,
    identical to the Scene Menu pattern.
]]--

RegisterServerEvent('ObjSpawner:GetData')
AddEventHandler('ObjSpawner:GetData', function(mode)
    local identifiers = GetPlayerIdentifiers(source)
    if mode == "IP" then
        for _, v in pairs(identifiers) do
            if string.sub(v, 0, 3) == "ip:" then
                TriggerClientEvent('ObjSpawner:ReturnData', source, v)
            end
        end
    else
        for _, v in pairs(identifiers) do
            if string.sub(v, 0, 6) == "steam:" then
                TriggerClientEvent('ObjSpawner:ReturnData', source, v)
            end
        end
    end
end)

--[[
    Optional: broadcast to all players when someone places an object.
    Config.AnnounceSpawn must be true on the client for this to fire.
]]--
RegisterServerEvent('ObjSpawner:Announce')
AddEventHandler('ObjSpawner:Announce', function(playerName, objectName)
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 100, 180, 255 },
        multiline = false,
        args = { "Object Spawner", playerName .. " placed a " .. objectName }
    })
end)