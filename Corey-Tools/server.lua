-- server.lua
-- GetPlayerPing and GetPlayerName are server-side only in FiveM.
-- We return both so the client can display all players regardless of stream distance.
-- Keys are server IDs (strings), values are tables with name + ping.

lib.callback.register('miscmenu:getPlayerPings', function(source)
    local players = {}
    for _, serverId in ipairs(GetPlayers()) do
        players[tostring(serverId)] = {
            name = GetPlayerName(serverId),
            ping = GetPlayerPing(serverId)
        }
    end
    return players
end)
-- miscmenu:clearArea
-- Receives a list of network IDs from the requesting client, validates that they
-- are real networked entities, then broadcasts the confirmed list to ALL clients
-- so every player deletes the same entities (full session sync).
RegisterNetEvent('miscmenu:clearArea', function(netIds, coords, radius)
    local source = source
    if type(netIds) ~= 'table' then return end

    local confirmed = {}
    for _, netId in ipairs(netIds) do
        if type(netId) == 'number' and NetworkGetEntityFromNetworkId(netId) ~= 0 then
            confirmed[#confirmed + 1] = netId
        end
    end

    if #confirmed > 0 then
        TriggerClientEvent('miscmenu:clearAreaSync', -1, confirmed)
    end
end)