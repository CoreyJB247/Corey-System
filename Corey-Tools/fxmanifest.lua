-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

author 'CoreyJB247'
description 'Misc Menu Script + Corey-Resources'
version '0.0.1'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua',
    'smallresources/**/**.lua'
}

server_scripts {
    'server.lua',
    'smallresources/blip_server.lua'
}

shared_scripts {
    'smallresources/config.lua'
}

dependencies {
    'ox_lib'
}