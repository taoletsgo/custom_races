fx_version "cerulean"
game "gta5"

author "Rockstar Games"
description "Races system"
version "3.6.3"

client_scripts {
	"config/config_client.lua",
	"client/xbox_controller.lua",
	"client/translate_client.lua",
	"client/function_client.lua",
	"client/callback_client.lua",
	"client/main_client.lua",
	"client/races_data.lua",
	"client/races_room.lua"
}

server_scripts {
	"config/config_server.lua",
	"@oxmysql/lib/MySQL.lua",
	"server/sql_server.lua",
	"server/callback_server.lua",
	"server/main_server.lua",
	"server/races_data.lua",
	"server/races_room.lua"
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/css/*.css",
	"html/js/*.js",
	"html/fonts/*.*",
	"html/img/*.*",
	"html/sounds/*.*"
}