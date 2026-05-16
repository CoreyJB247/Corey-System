-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

author 'CoreyJB247'
description 'Unified Menu System - Links all menu scripts together'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua'
}

dependencies {
    'ox_lib'
}