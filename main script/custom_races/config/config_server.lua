Config = {}

Config.Framework = "standalone" -- "esx" / "qb" / "standalone"

Config.MaxPlayers = 48 -- default: 48 players

Config.EnableDefaultRandomVehicle = false -- default: disable random vehicle at first checkpoint

Config.RandomVehicle = {
	"t20",
	"xa21",
	"bmx"
}

Config.Discord = {
	enable = false,
	api_url = "https://discord.com/api/v10",
	bot_token = "",
	guild_id = "",
	role_ids = {"", ""},
	whitelist_license = {"license:", ""}
}