fx_version 'cerulean'
game 'gta5'

author 'RockstarGames'
description 'Races system'
version '2.2.7'

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
	'html/css/animate.min.css',
	'html/css/bootstrap.min.css',
	'html/css/style.css',
	'html/fonts/*.ttf',
	'html/fonts/*.otf',
	'html/js/app.js',
	'html/js/jquery-3.6.0.min.js',
	'html/js/vehicles.js',
	'html/img/*.svg',
	'html/img/*.webp',
	'html/img/*.gif',
	'html/img/*.png',
	'html/sounds/*.mp3',
	'html/sounds/*.wav',
	'html/sounds/*.ogg',
	--'local_files/**/*.json',
	--'local_files/**/*.jpg'
}