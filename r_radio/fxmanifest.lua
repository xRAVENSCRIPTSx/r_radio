fx_version 'cerulean'
game 'gta5'

author 'RAVEN'
description 'FiveM [ESX] radio script (no ui)'

shared_script 'config.lua'

client_script 'c_main.lua'
server_script 's_main.lua'

files {
    'locales/hu.lua'
    'locales/en.lua'
}

dependencies {
    'ox_inventory',
    'SY_Notify'
}

