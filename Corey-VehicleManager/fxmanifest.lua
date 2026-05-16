fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'CoreyJB247'
description 'Corey Vehicle Manager with custom Control Script'
version '1.0.0'

ox_lib 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    'control/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'control/html/index.html'

files {
    'control/html/index.html'
}

dependencies {
    'ox_lib',
    'oxmysql'
}