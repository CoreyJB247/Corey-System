-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

author 'CoreyJB247'
description 'Elevator Teleport Script'
version '1.0.0'

lua54 'yes'

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",      -- loaded on both client and server
}
 
client_scripts {
    "client.lua",
}
 
server_scripts {
    "server.lua",
}
 
dependencies {
    "ox_lib",
    "ox_target",
}
 