-- Resource Metadata
fx_version 'cerulean'
games {'gta5'}

author 'Scorpio686'
description 'ESX Christmas Tree'
version '1.0.0'

shared_script '@es_extended/imports.lua'

-- What to run
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/fr.lua',
    'config.lua',
    'server/*.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/fr.lua',
    'config.lua',
    'client/*.lua'
}