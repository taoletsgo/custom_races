Config = {}

Config.RespawnHoldTime = 500 -- default: 500ms / 0.5s

Config.GetRandomRaceById = true -- default: true

Config.DNFCountdownTime = 30000 -- default: 30000ms / 1000 = 30s

Config.ReplaceInvalidVehicle = 1131912276 -- default: 1131912276 = bmx

Config.BlacklistedVehicles = {
	[-376434238] = true
}

Config.addOnVehiclesForRandomRaces = {
	--[GetHashKey("bmx")] = true
	-- Or add models to vanilla list (client_vehicle.lua / races_data.lua), but considering that GTA is still being updated, data conflicts are likely
}