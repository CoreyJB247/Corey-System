-- Unified Menu System - Client (ox_lib Context Menu)

-- Function to open scene menu
local function openSceneMenu()
    ExecuteCommand('+scenemenu')
    Wait(50)
    ExecuteCommand('-scenemenu')
end

local _lastContextId = nil

local function ShowContext(id)
    _lastContextId = id
    lib.showContext(id)
end

-- Main Unified Menu
local function OpenUnifiedMenu()
    lib.registerContext({
        id = 'unified_main_menu',
        title = 'Corey Menu',
        options = {
            {
                title = 'Player Options',
                description = 'Open player management menu',
                icon = 'user',
                iconColor = '#3498db',
                onSelect = function()
                    ExecuteCommand('appearance_menu')
                end
            },
            {
                title = 'Vehicle Options',
                description = 'Open vehicle management menu',
                icon = 'car',
                iconColor = '#5bdb34',
                onSelect = function()
                    ExecuteCommand('vehmanager')
                end
            },
            {
                title = 'Weapon Options',
                description = 'Open weapon management menu',
                icon = 'gun',
                iconColor = '#e72c2c',
                onSelect = function()
                    ExecuteCommand('weaponmenu')
                end
            },
            {
                title = 'Scene Menu',
                description = 'Speed zones and object placement',
                icon = 'box',
                iconColor = '#bf34db',
                onSelect = function()
                    openSceneMenu()
                end
            },
            {
                title = 'Tools',
                description = 'Player list, teleport, hud and Rockstar Recording',
                icon = 'wrench',
                iconColor = '#f18913',
                onSelect = function()
                    ExecuteCommand('misc')
                end
            },
            { title = '', disabled = true },
            {
                title = 'Object Spawner',
                description = 'Place objects',
                icon = 'plus',
                iconColor = '#24ad09',
                onSelect = function()
                    ExecuteCommand('objspawner')
                end
            },
        }
    })

    lib.showContext('unified_main_menu')
    SetNuiFocus(true, false)
end

-- Register command to open unified menu
RegisterCommand('menu', function()
    OpenUnifiedMenu()
end, false)

-- Register keybind (M by default)
RegisterKeyMapping('menu', 'Open Main Menu', 'keyboard', 'M')

-- Reopen last menu (useful if a sub-menu changes model)
function ReopenLastUnifiedMenu()
    if _lastContextId then
        lib.showContext(_lastContextId)
    else
        OpenUnifiedMenu()
    end
end

exports('ReopenLastMenu', ReopenLastUnifiedMenu)