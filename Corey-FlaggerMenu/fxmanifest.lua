-- Resource Metadata
fx_version 'cerulean'
games { 'gta5' }

author 'CoreyJB247'
description 'Flagger Menu for Ebu Flagger script'
version '0.0.1'

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