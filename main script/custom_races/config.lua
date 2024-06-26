Config = {}

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
	[0] = "Compacts",
	[1] = "Sedans",
	[2] = "SUVs",
	[3] = "Coupes",
	[4] = "Muscle",
	[5] = "Classics",
	[6] = "Sports",
	[7] = "Super",
	[8] = "Motorbikes",
	[9] = "4x4",
	[12] = "Vans",
	[13] = "Bikes",
	[16] = "Planes",
	[17] = "Service",
	[20] = "Commercials",
	[22] = "Formula",
}

Config.BlacklistedVehs = {}

Config.PreviewVehs = {
	Spawn = vector4(-74.9068, -819.0542, 326.1751, 250.0),
	PedHidden = vector4(-75.1623, -818.9494, 332.9547, 139.5274),
	CamPos = vector3(-66.3730, -818.9483, 330.1423),
	CamRot = vector3(-20.0, 0.0, 90.0)
}

Config.PointsType = {
	Primary = {
		Round_Large = {
			[515] = true, [519] = true, [1035] = true, [1538] = true, [1539] = true, [8199] = true, [8711] = true, [57863] = true, [262659] = true, [279043] = true, [279115] = true, [281091] = true, [303691] = true, [320003] = true, [377419] = true, [442883] = true, [1065547] = true, [67109379] = true, [67110403] = true, [67174915] = true, [134219266] = true, [268435974] = true, [268435975] = true, [268444167] = true
		},
		Temporal = {
			[1024] = true, [1026] = true, [1027] = true
		},
		Round = {
			[2] = true, [3] = true, [5] = true, [7] = true, [11] = true, [1024] = true, [1026] = true, [1027] = true, [3079] = true, [8199] = true, [8711] = true, [16463] = true, [268435463] = true
		},
		Warp = {
			[134217728] = true, [134217730] = true, [134217731] = true, [134234115] = true, [134217735] = true, [134218754] = true, [134219266] = true, [268435975] = true, [268444167] = true, [402653191] = true
		}
	},
	Pair = {
		Round_Large = {
			[8199] = true, [268444167] = true
		},
		Temporal = {
			[1024] = true, [1026] = true, [1027] = true
		},
		Round = {
			[5] = true, [7] = true, [134217735] = true
		},
		Warp = {
			[268435975] = true, [268444167] = true
		}
	}
}