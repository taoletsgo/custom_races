fx_version "cerulean"
games {"gta5", "gta5enhanced"}

author "taoletsgo"
description "Racing server core"
version "5.0.0"

client_scripts {
	"client/variable.lua",
	"client/locale.lua",
	"client/menu/RageUI.lua",
	"client/menu/Menu.lua",
	"client/menu/MenuController.lua",
	"client/menu/components/*.lua",
	"client/menu/elements/*.lua",
	"client/menu/items/*.lua",
	"client/function/*.lua",
	"client/mode/creator/*.lua",
	"client/mode/race/*.lua",
	"client/command.lua",
	"client/event.lua",
	"client/menu.lua",
	"client/noclip.lua",
	"client/nui.lua",
	"client/main.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"config.lua",
	"server/variable.lua",
	"server/function/*.lua",
	"server/mode/creator/*.lua",
	"server/mode/race/*.lua",
	"server/event.lua",
	"server/main.lua",
	"server/sql.lua",
	"server/update.lua"
}

ui_page "html/index.html"

files {
	"html/index.html",
	"html/css/*.*",
	"html/flags/*.*",
	"html/fonts/*.*",
	"html/img/*.*",
	"html/js/*.*",
	"html/sounds/*.*",
	"data/chameleon/carcols_gen9.meta",
	"data/chameleon/carmodcols_gen9.meta",
	"data/chameleon/carmodcols.ymt",
	"data/label.json",
	"data/object.json",
	"data/tattoo.json",
	"data/weapon.json",
	"stream/vehicle_paint_ramps.ytd"
}

data_file "CARCOLS_GEN9_FILE" "data/chameleon/carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "data/chameleon/carmodcols_gen9.meta"
data_file "FIVEM_LOVES_YOU_447B37BE29496FA0" "data/chameleon/carmodcols.ymt"