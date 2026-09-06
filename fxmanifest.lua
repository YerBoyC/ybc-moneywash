fx_version 'cerulean'
game 'gta5'

author 'YerBoyC'
description 'Convert Marked Bills into Clean Cash'
version '2.0.0'


server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    "server.lua",
}

client_scripts { 
    "client.lua",
    '@qbx_core/modules/playerdata.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

lua54 'yes'

-- All source files are intentionally left unencrypted for this free/open-source resource.
escrow_ignore {
    'config.lua',
    'client.lua',
    'server.lua',
}
