Config = {}

Config.Debug = false

Config.Default = {
	SpawnPos = {x = -427.4890, y = 1116.4507, z = 326.7827, heading = 343.0162},
	MaxSlots = {
		Vehicle = 50,
		Skin = 10
	},
	Preferences = {
		AdvancedTeleport = false,
		Traffic = false,
		EnableAmbientSound = false,
		SimulateAltF4 = true,
		DisableMotoMelee = true,
		FixBmxFloat = true,
		EnableOnlineMap = true,
		EnableVanillaMinimap = false,
		DeleteWhenSpawnVehicle = true,
		KeepVehicleInvincible = false,
		RepairVehicleWhenTp = false,
		WeaponLoaded = false,
		InfiniteAmmo = false,
		ObjectLowerAlphaChecked = true,
		EnableWeaponInTest = false
	},
	Convar = {
		["chat_showJoins"] = "0",
		["chat_showQuits"] = "0"
	},
	ConvarReplicated = {
		["game_originalBikeJump"] = "true",
		["game_enableFrameRateIndependentWheelPhysics"] = "false"
	}
}

Config.ServerInfo = {
	Discord = "discord.gg/example",
	Web = "racing.example.com",
	Welcome = {
		["en"] = "Welcome to FiveM racing server",
		["fr"] = "",
		["de"] = "",
		["it"] = "",
		["es"] = "",
		["br"] = "",
		["pl"] = "",
		["ru"] = "",
		["ko"] = "",
		["zh"] = "",
		["jp"] = "",
		["mx"] = "",
		["cn"] = ""
	},
	Title = "FiveM racing server"
}

Config.AddOnModels = {
	Vehicle = {
		--"vehicle_model_name_1",
		--"vehicle_model_name_2",
		--"vehicle_model_name_3"
	},
	Ped = {
		--"ped_model_name_1",
		--"ped_model_name_2",
		--"ped_model_name_3"
	}
}

Config.Discord = {
	Enable = false,
	Api = "https://discord.com/api/v10",
	Token = "",
	GuildId = "",
	Webhook = {
		Notification = {
			Url = "",
			PlayerJoining = {
				Title = {
					["join"] = ":joystick: **%s** is joining the server"
				},
				Description = "Current player count: %s/%s",
				Color = 3066993
			},
			PlayerDropped = {
				Title = {
					["timed-out"] = ":face_with_raised_eyebrow: **%s** left (Timed out)",
					["crashed"] = ":sob: **%s** left (Game crashed)",
					["unknown-reason"] = ":face_with_spiral_eyes: **%s** left (Unknown reason)",
					["left"] = ":wave: **%s** left (%s)"
				},
				Description = "Current player count: %s/%s",
				Color = 15158332
			}
		},
		ExportTrack = {
			Url = ""
		}
	}
}

Config.Permission = {
	SpawnVanillaVehicles = {
		Default = true,
		Discord = {"", ""},
		Group = {"admin", "vip", "creator", "racer"}
	},
	SpawnAddOnVehicles = {
		Default = true,
		Discord = {"", ""},
		Group = {"admin", "vip", "creator", "racer"}
	},
	CustomVehicle = {
		Default = true,
		Discord = {"", ""},
		Group = {"admin", "vip", "creator", "racer"}
	},
	SpawnPedAsPlayerModel = {
		Default = true,
		Discord = {"", ""},
		Group = {"admin", "vip", "creator", "racer"}
	},
	Weapon = {
		Default = true,
		Discord = {"", ""},
		Group = {"admin", "vip", "creator", "racer"}
	},
	TeleportInRace = {
		Default = true,
		Discord = {"", ""},
		Group = {"admin", "vip", "creator", "racer"}
	},
	SetConvar = {
		Default = true,
		Discord = {"", ""},
		Group = {"admin"}
	}
}

Config.Chat = {
	{RoleName = "admin", RoleId = "", Color = {255, 255, 255}},
	{RoleName = "vip", RoleId = "", Color = {255, 255, 255}},
	{RoleName = "creator", RoleId = "", Color = {255, 255, 255}},
	{RoleName = "racer", RoleId = "", Color = {255, 255, 255}}
}