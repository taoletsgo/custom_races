Config = {}

Config.OpenMenuKey = 167 -- default: 167 | F6 https://docs.fivem.net/docs/game-references/controls/

Config.CheckInvitationKey = "F7" -- default: F7 https://docs.fivem.net/docs/game-references/controls/

Config.QuitRaceKey = "ESCAPE" -- default: ESC https://docs.fivem.net/docs/game-references/controls/

Config.MaxPlayers = 48 -- default: 48 players

Config.EnableStartNFCountdown = false -- default: disable not finish countdown

Config.NFCountdownTime = 30000 -- default: 30000ms / 1000 = 30s

Config.EnableDefaultRandomVehicle = false -- default: disable random vehicle at first checkpoint

Config.RandomVehicle = {
	"t20",
	"xa21",
	"bmx"
}

Config.Weapons = {
	[GetHashKey("WEAPON_PISTOL")] = 999,
	[GetHashKey("WEAPON_APPISTOL")] = 999,
	[GetHashKey("WEAPON_STUNGUN")] = 999,
	[GetHashKey("WEAPON_PISTOL50")] = 999,
	[GetHashKey("WEAPON_FLAREGUN")] = 20,
	[GetHashKey("WEAPON_MARKSMANPISTOL")] = 999,
	[GetHashKey("WEAPON_REVOLVER_MK2")] = 999,
	[GetHashKey("WEAPON_DOUBLEACTION")] = 999,
	[GetHashKey("WEAPON_RAYPISTOL")] = 1,
	[GetHashKey("WEAPON_MICROSMG")] = 999,
	[GetHashKey("WEAPON_RAYCARBINE")] = 999,
	[GetHashKey("WEAPON_PUMPSHOTGUN")] = 999,
	[GetHashKey("WEAPON_ASSAULTSHOTGUN")] = 999,
	[GetHashKey("WEAPON_MUSKET")] = 999,
	[GetHashKey("WEAPON_AUTOSHOTGUN")] = 999,
	[GetHashKey("WEAPON_ASSAULTRIFLE")] = 999,
	[GetHashKey("WEAPON_SPECIALCARBINE")] = 999,
	[GetHashKey("WEAPON_COMBATMG")] = 999,
	[GetHashKey("WEAPON_GUSENBERG")] = 999,
	[GetHashKey("WEAPON_HEAVYSNIPER")] = 999,
	[GetHashKey("WEAPON_MARKSMANRIFLE")] = 999,
	[GetHashKey("WEAPON_RPG")] = 20,
	[GetHashKey("WEAPON_GRENADELAUNCHER")] = 20,
	[GetHashKey("WEAPON_MINIGUN")] = 999,
	[GetHashKey("WEAPON_RAYMINIGUN")] = 999,
	[GetHashKey("WEAPON_FIREWORK")] = 20,
	[GetHashKey("WEAPON_STICKYBOMB")] = 25,
	[GetHashKey("WEAPON_GRENADE")] = 25,
	[GetHashKey("WEAPON_MOLOTOV")] = 25,
	[GetHashKey("WEAPON_PROXIME")] = 25,
}

Config.VehsClass = {
	[0] = "Compact",
	[1] = "Sedan",
	[2] = "SUV",
	[3] = "Coupe",
	[4] = "Muscle",
	[5] = "Classic",
	[6] = "Sport",
	[7] = "Super",
	[8] = "Motorcycle",
	[9] = "Off-road",
	[10] = "Industrial",
	[11] = "Utility",
	[12] = "Van",
	[13] = "Cycle",
	[14] = "Boat",
	[15] = "Helicopter",
	[16] = "Plane",
	[17] = "Service",
	[18] = "Emergency",
	[19] = "Military",
	[20] = "Commercial",
	[22] = "OpenWheel"
}

Config.BlacklistedVehs = {}

Config.PreviewVehs = {
	Spawn = vector4(-74.9068, -819.0542, 326.1751, 250.0),
	PedHidden = vector4(-75.1623, -818.9494, 332.9547, 139.5274),
	CamPos = vector3(-66.3730, -818.9483, 330.1423),
	CamRot = vector3(-20.0, 0.0, 90.0)
}
