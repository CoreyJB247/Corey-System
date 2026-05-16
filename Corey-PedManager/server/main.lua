-- server/main.lua
-- Server-side event handlers bridging client <-> database

RegisterNetEvent('appearance_menu:server:getSaved', function()
    local src = source
    DB_GetSavedCharacters(src, function(rows)
        TriggerClientEvent('appearance_menu:client:receiveSaved', src, rows)
    end)
end)

RegisterNetEvent('appearance_menu:server:saveCharacter', function(name, model, category, appearanceJson)
    local src = source
    if type(name) ~= 'string' or #name < 1 or #name > 32 then
        TriggerClientEvent('appearance_menu:client:notify', src, 'error', 'Invalid character name.')
        return
    end
    if type(category) ~= 'string' or #category < 1 then
        category = 'other'
    end
    if type(appearanceJson) ~= 'string' then
        TriggerClientEvent('appearance_menu:client:notify', src, 'error', 'Invalid appearance data.')
        return
    end

    DB_SaveCharacter(src, name, model, category, appearanceJson, function(ok, msg, id)
        if ok then
            TriggerClientEvent('appearance_menu:client:notify', src, 'success', msg)
            DB_GetSavedCharacters(src, function(rows)
                TriggerClientEvent('appearance_menu:client:receiveSaved', src, rows)
            end)
        else
            TriggerClientEvent('appearance_menu:client:notify', src, 'error', msg)
        end
    end)
end)

RegisterNetEvent('appearance_menu:server:updateCharacter', function(charId, name, model, category, appearanceJson)
    local src = source
    charId = tonumber(charId)
    if not charId then return end
    if type(category) ~= 'string' or #category < 1 then
        category = 'other'
    end

    DB_UpdateCharacter(src, charId, name, model, category, appearanceJson, function(ok, msg)
        TriggerClientEvent('appearance_menu:client:notify', src, ok and 'success' or 'error', msg)
        if ok then
            DB_GetSavedCharacters(src, function(rows)
                TriggerClientEvent('appearance_menu:client:receiveSaved', src, rows)
            end)
        end
    end)
end)

RegisterNetEvent('appearance_menu:server:deleteCharacter', function(charId)
    local src = source
    charId = tonumber(charId)
    if not charId then return end

    DB_DeleteCharacter(src, charId, function(ok, msg)
        TriggerClientEvent('appearance_menu:client:notify', src, ok and 'success' or 'error', msg)
        if ok then
            DB_GetSavedCharacters(src, function(rows)
                TriggerClientEvent('appearance_menu:client:receiveSaved', src, rows)
            end)
        end
    end)
end)

RegisterNetEvent('appearance_menu:server:loadCharacter', function(charId)
    local src = source
    charId = tonumber(charId)
    if not charId then return end

    DB_LoadCharacter(src, charId, function(row)
        if row then
            TriggerClientEvent('appearance_menu:client:applyCharacter', src, row)
        else
            TriggerClientEvent('appearance_menu:client:notify', src, 'error', 'Character not found.')
        end
    end)
end)