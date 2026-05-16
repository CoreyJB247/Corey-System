-- server/database.lua
-- Handles all oxmysql interactions for character appearance storage
--
-- MIGRATION: Run this SQL on your database to add the category column:
--
--   ALTER TABLE corey_appearance_characters
--   ADD COLUMN category VARCHAR(32) NOT NULL DEFAULT 'other';
--

---@param source number Player server id
---@param cb function Callback with table of saved characters
function DB_GetSavedCharacters(source, cb)
    local identifier = GetPlayerIdentifierByType(source, 'license')
    if not identifier then return cb({}) end

    MySQL.query(
        'SELECT id, name, model, category, appearance_data, created_at FROM corey_appearance_characters WHERE identifier = ? ORDER BY name ASC',
        { identifier },
        function(rows)
            cb(rows or {})
        end
    )
end

---@param source number
---@param name string Character slot name
---@param model string Ped model
---@param category string Category id (e.g. 'law_enforcement')
---@param appearanceData string JSON string from fivem-appearance
---@param cb function Callback(success, message)
function DB_SaveCharacter(source, name, model, category, appearanceData, cb)
    local identifier = GetPlayerIdentifierByType(source, 'license')
    if not identifier then return cb(false, 'No identifier') end

    MySQL.insert(
        'INSERT INTO corey_appearance_characters (identifier, name, model, category, appearance_data) VALUES (?, ?, ?, ?, ?)',
        { identifier, name, model, category, appearanceData },
        function(insertId)
            if insertId then
                cb(true, 'Character saved successfully.', insertId)
            else
                cb(false, 'Database insert failed.')
            end
        end
    )
end

---@param source number
---@param charId number Database row id
---@param name string New display name
---@param model string Ped model
---@param category string Category id
---@param appearanceData string JSON string
---@param cb function
function DB_UpdateCharacter(source, charId, name, model, category, appearanceData, cb)
    local identifier = GetPlayerIdentifierByType(source, 'license')
    if not identifier then return cb(false, 'No identifier') end

    MySQL.update(
        'UPDATE corey_appearance_characters SET name = ?, model = ?, category = ?, appearance_data = ? WHERE id = ? AND identifier = ?',
        { name, model, category, appearanceData, charId, identifier },
        function(affected)
            if affected and affected > 0 then
                cb(true, 'Character updated.')
            else
                cb(false, 'Update failed or character not found.')
            end
        end
    )
end

---@param source number
---@param charId number
---@param cb function
function DB_DeleteCharacter(source, charId, cb)
    local identifier = GetPlayerIdentifierByType(source, 'license')
    if not identifier then return cb(false, 'No identifier') end

    MySQL.update(
        'DELETE FROM corey_appearance_characters WHERE id = ? AND identifier = ?',
        { charId, identifier },
        function(affected)
            cb(affected and affected > 0, affected and affected > 0 and 'Character deleted.' or 'Delete failed.')
        end
    )
end

---@param source number
---@param charId number
---@param cb function Callback with row or nil
function DB_LoadCharacter(source, charId, cb)
    local identifier = GetPlayerIdentifierByType(source, 'license')
    if not identifier then return cb(nil) end

    MySQL.single(
        'SELECT id, name, model, category, appearance_data FROM corey_appearance_characters WHERE id = ? AND identifier = ?',
        { charId, identifier },
        function(row)
            cb(row)
        end
    )
end