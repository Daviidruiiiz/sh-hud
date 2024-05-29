fx_version 'cerulean'
games { 'gta5' }

author 'Daviid <@daaviidruiiiz>'
description 'HUD sencillo con UI minimalista'
version '1.0.0'
lua54 'yes'
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/main.css',
    'html/js/index.js',
    'html/js/functions.js'
    -- Incluye otros archivos necesarios aquí
}

client_scripts {
    'client/*.lua'
}
