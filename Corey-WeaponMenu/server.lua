-- Weapon Menu - Server
-- Handles saved loadouts persistence via oxmysql → corey_weaponloadouts

-- Ensure table exists on resource start
CreateThread(function()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `corey_weaponloadouts` (
            `id`         INT AUTO_INCREMENT PRIMARY KEY,
            `identifier` VARCHAR(60)   NOT NULL,
            `loadouts`   LONGTEXT      NOT NULL DEFAULT '[]',
            UNIQUE KEY `identifier` (`identifier`)
        )
    ]])
end)

-- Helper: get player license identifier
local function getIdentifier(source)
    return GetPlayerIdentifierByType(source, 'license') or
           GetPlayerIdentifier(source, 0)
end

-- Callback: return this player's saved loadouts
lib.callback.register('corey_weaponmenu:getSavedLoadouts', function(source)
    local identifier = getIdentifier(source)
    if not identifier then return {} end

    local result = MySQL.scalar.await(
        'SELECT loadouts FROM `corey_weaponloadouts` WHERE identifier = ?',
        { identifier }
    )

    if result then
        return json.decode(result) or {}
    end

    return {}
end)

-- Event: persist loadouts for this player
RegisterNetEvent('corey_weaponmenu:saveLoadouts', function(loadoutsJson)
    local src        = source
    local identifier = getIdentifier(src)
    if not identifier then return end

    local decoded = json.decode(loadoutsJson)
    if type(decoded) ~= 'table' then return end

    MySQL.query(
        'INSERT INTO `corey_weaponloadouts` (identifier, loadouts) VALUES (?, ?) ON DUPLICATE KEY UPDATE loadouts = VALUES(loadouts)',
        { identifier, loadoutsJson }
    )
end)