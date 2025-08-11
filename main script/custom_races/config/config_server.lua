Config = {}

Config.MaxPlayers = 48 -- default: 48 players

Config.PredefinedVehicle = "bmx" -- default: bmx | https://forge.plebmasters.de/vehicles

Config.Whitelist = {
	-- Same configuration as txAdmin, or ask AI for help
	Discord = {
		enable = false,
		api_url = "https://discord.com/api/v10",
		bot_token = "",
		guild_id = "",
		role_ids = {"", ""}
	},

	-- Player license in identifiers
	-- Only license, not steam! not fivem! not discord! not license2! not live! not xbl! not ip!
	License = {"license:", "license:"},

	-- Command "setgroup_creator_permission license group" to give player permission
	-- Example (in server console, not client console!):
	-- setgroup_creator_permission 527da3929c52c0e443805fb668s686s7a0d admin
	-- setgroup_creator_permission 527da3929c52c0e443805fb668s686s7a0d racer
	-- setgroup_creator_permission license:527da3929c52c0e443805fb668s686s7a0d vip
	Group = {"admin", "vip", "creator", "racer", --[[other group in custom_race_users SQL]]}
}