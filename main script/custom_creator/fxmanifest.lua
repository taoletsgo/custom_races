fx_version 'cerulean'
game 'gta5'

author 'Rockstar Games'
description 'Races Creator (GTA Online Style)'
version '1.3.13'

client_scripts {
	'client/menu/RageUI.lua',
	'client/menu/Menu.lua',
	'client/menu/MenuController.lua',
	'client/menu/components/*.lua',
	'client/menu/elements/*.lua',
	'client/menu/items/*.lua',
	'config/client_config.lua',
	'client/client_translate.lua',
	'client/client_object.lua',
	'client/client_json.lua',
	'client/client_function.lua',
	'client/client_callback.lua',
	'client/client_event.lua',
	'client/client_menu.lua',
	'client/client_main.lua'
}

server_scripts {
	'config/server_config.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/server_callback.lua',
	'server/server_function.lua',
	'server/server_event.lua',
	'server/server_main.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/jquery-3.6.0.min.js'
}