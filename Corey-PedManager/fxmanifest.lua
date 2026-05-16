fx_version 'cerulean'
game 'gta5'

author 'CoreyJB247'
description 'Appearance Menu - vMenu Character System Replacement'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
}

client_scripts {
    'client/menu.lua',   -- defines OpenEditor, GetAppearance, SetAppearance first
    'client/main.lua',   -- uses those helpers
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/database.lua',
}

dependencies {
    'ox_lib',
    'oxmysql',
    'fivem-appearance',
}
