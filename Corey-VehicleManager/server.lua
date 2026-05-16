-- server.lua
local oxmysql = exports.oxmysql

-- Get saved vehicles
lib.callback.register('corey_vehiclemenu:getSavedVehicles', function(source)
    local citizenid = GetPlayerIdentifierByType(source, 'license')
                 or GetPlayerIdentifierByType(source, 'fivem')
                 or GetPlayerIdentifierByType(source, 'discord')

    if not citizenid then return {} end

    local result = oxmysql:query_async(
        'SELECT * FROM corey_saved_vehicles WHERE citizenid = ? ORDER BY name ASC',
        { citizenid }
    )
    if not result then return {} end

    -- Re-shape DB rows into the {name, data} format the client expects.
    -- The `data` column is a JSON string so we decode it here on the server
    -- before sending across the network.
    local out = {}
    for _, row in ipairs(result) do
        local vehicleData = json.decode(row.data)
        if vehicleData then
            table.insert(out, {
                name = row.name,
                data = vehicleData   -- decoded table, not a raw string
            })
        end
    end
    return out
end)

-- Save a single vehicle (called right after SaveCurrentVehicle on the client)
RegisterNetEvent('corey_vehiclemenu:saveVehicle', function(name, vehicleData)
    local src = source
    local citizenid = GetPlayerIdentifierByType(src, 'license')
                 or GetPlayerIdentifierByType(src, 'fivem')
                 or GetPlayerIdentifierByType(src, 'discord')

    if not citizenid or not vehicleData then return end

    oxmysql:insert(
        'INSERT INTO corey_saved_vehicles (citizenid, name, model, category, data) VALUES (?, ?, ?, ?, ?)',
        {
            citizenid,
            name,
            vehicleData.model,
            vehicleData.category or 'other',
            json.encode(vehicleData)
        }
    )
end)

-- Rename vehicle
RegisterNetEvent('corey_vehiclemenu:renameVehicle', function(oldName, newName)
    local src = source
    local citizenid = GetPlayerIdentifierByType(src, 'license')
                 or GetPlayerIdentifierByType(src, 'fivem')
                 or GetPlayerIdentifierByType(src, 'discord')

    if not citizenid then return end

    oxmysql:execute(
        'UPDATE corey_saved_vehicles SET name = ? WHERE citizenid = ? AND name = ? LIMIT 1',
        { newName, citizenid, oldName }
    )
end)

-- Delete a single vehicle by name (keeps other saves intact)
RegisterNetEvent('corey_vehiclemenu:deleteVehicle', function(name)
    local src = source
    local citizenid = GetPlayerIdentifierByType(src, 'license')
                 or GetPlayerIdentifierByType(src, 'fivem')
                 or GetPlayerIdentifierByType(src, 'discord')

    if not citizenid then return end

    oxmysql:execute(
        'DELETE FROM corey_saved_vehicles WHERE citizenid = ? AND name = ? LIMIT 1',
        { citizenid, name }
    )
end)