fx_version 'cerulean'
game 'gta5'

author 'RockstarGames'
description 'Races system'
version '2.6.2'

shared_scripts {
	'config.lua'
}

server_script {
	'@oxmysql/lib/MySQL.lua',
	'server/main_server.lua',
	'server/races_data.lua',
	'server/races_room.lua'
}

client_script {
	'client/main_client.lua',
	'client/races_data.lua',
	'client/races_room.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/css/*.css',
	'html/js/*.js',
	'html/fonts/*.*',
	'html/img/*.*',
	'html/sounds/*.*',
	--'local_files/**/*.json',
	--'local_files/**/*.jpg'
}