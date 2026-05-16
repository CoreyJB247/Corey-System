-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

author 'CoreyJB247'
description 'Police Menu'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib'
}