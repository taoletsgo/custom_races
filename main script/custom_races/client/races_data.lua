local previewVehicle = 0
local previewCamera = 0
local isQueryingInProgress = false
local vehicleList = {
	["Favorite"] = {},
	["Personal"] = {}
}
favoriteVehicles = {}
personalVehicles = {}
races_data_front = {}

speedUpObjects = {
	[GetHashKey("stt_prop_track_speedup")] = true,
	[GetHashKey("stt_prop_track_speedup_t1")] = true,
	[GetHashKey("stt_prop_track_speedup_t2")] = true,
	[GetHashKey("stt_prop_stunt_tube_speed")] = true,
	[GetHashKey("stt_prop_stunt_tube_speedb")] = true,
	[GetHashKey("ar_prop_ar_speed_ring")] = true,
	[GetHashKey("ar_prop_ar_tube_speed")] = true,
	[GetHashKey("ar_prop_ar_tube_2x_speed")] = true,
	[GetHashKey("ar_prop_ar_tube_4x_speed")] = true
}

slowDownObjects = {
	[GetHashKey("gr_prop_gr_target_1_01a")] = true,
	[GetHashKey("gr_prop_gr_target_2_04a")] = true,
	[GetHashKey("gr_prop_gr_target_3_03a")] = true,
	[GetHashKey("gr_prop_gr_target_4_01a")] = true,
	[GetHashKey("gr_prop_gr_target_5_01a")] = true,
	[GetHashKey("gr_prop_gr_target_small_01a")] = true,
	[GetHashKey("gr_prop_gr_target_small_03a")] = true,
	[GetHashKey("gr_prop_gr_target_small_02a")] = true,
	[GetHashKey("gr_prop_gr_target_small_06a")] = true,
	[GetHashKey("gr_prop_gr_target_small_07a")] = true,
	[GetHashKey("gr_prop_gr_target_small_04a")] = true,
	[GetHashKey("gr_prop_gr_target_small_05a")] = true,
	[GetHashKey("gr_prop_gr_target_long_01a")] = true,
	[GetHashKey("gr_prop_gr_target_large_01a")] = true,
	[GetHashKey("gr_prop_gr_target_trap_01a")] = true,
	[GetHashKey("gr_prop_gr_target_trap_02a")] = true,
	[GetHashKey("stt_prop_track_slowdown")] = true,
	[GetHashKey("stt_prop_track_slowdown_t1")] = true,
	[GetHashKey("stt_prop_track_slowdown_t2")] = true
}

arenaObjects = {
	[GetHashKey("xs_prop_arena_flipper_small_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_flipper_xl_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_flipper_large_01a")] = true,
	[GetHashKey("xs_prop_arena_flipper_xl_01a")] = true,
	[GetHashKey("xs_prop_arena_flipper_large_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_flipper_small_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_flipper_xl_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_flipper_large_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_flipper_small_01a")] = true,
	[GetHashKey("xs_prop_arena_wall_rising_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_wall_rising_01a")] = true,
	[GetHashKey("xs_prop_arena_wall_rising_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_wall_01b")] = true,
	[GetHashKey("xs_prop_arena_wall_02a")] = true,
	[GetHashKey("xs_prop_arena_wall_01c")] = true,
	[GetHashKey("xs_prop_arena_wall_01a")] = true,
	[GetHashKey("xs_prop_arena_wall_rising_02a_sf")] = true,
	[GetHashKey("xs_prop_arena_wall_rising_02a_wl")] = true,
	[GetHashKey("xs_prop_arena_wall_02a_wl")] = true,
	[GetHashKey("xs_prop_arena_wall_02c_wl")] = true,
	[GetHashKey("xs_prop_arena_wall_02b_wl")] = true,
	[GetHashKey("xs_prop_arena_wall_02a_sf")] = true,
	[GetHashKey("xs_prop_arena_wall_rising_02a")] = true,
	[GetHashKey("xs_prop_arena_bollard_side_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_bollard_side_01a")] = true,
	[GetHashKey("xs_prop_arena_bollard_side_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_bollard_rising_01a")] = true,
	[GetHashKey("xs_prop_arena_bollard_rising_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_bollard_rising_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_bollard_rising_01b")] = true,
	[GetHashKey("xs_prop_arena_bollard_rising_01b_sf")] = true,
	[GetHashKey("xs_prop_arena_bollard_rising_01b_wl")] = true,
	[GetHashKey("xs_prop_arena_turntable_03a")] = true,
	[GetHashKey("xs_prop_arena_turntable_02a")] = true,
	[GetHashKey("xs_prop_arena_turntable_01a")] = true,
	[GetHashKey("xs_prop_arena_turntable_b_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_turntable_b_01a")] = true,
	[GetHashKey("xs_prop_arena_turntable_03a_sf")] = true,
	[GetHashKey("xs_prop_arena_turntable_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_turntable_02a_wl")] = true,
	[GetHashKey("xs_prop_arena_turntable_03a_wl")] = true,
	[GetHashKey("xs_prop_arena_turntable_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_turntable_02a_sf")] = true,
	[GetHashKey("xs_prop_arena_turntable_b_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_01a_wl")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_02a")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_03a_sf")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_04a")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_02a_sf")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_03a_wl")] = true,
	[GetHashKey("xs_prop_arena_pit_double_01b_wl")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_01a")] = true,
	[GetHashKey("xs_prop_arena_pit_double_01b")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_03a")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_04a_sf")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_04a_wl")] = true,
	[GetHashKey("xs_prop_arena_pit_fire_02a_wl")] = true,
	[GetHashKey("xs_prop_arena_pit_double_01a_sf")] = true,
	[GetHashKey("xs_prop_arena_pit_double_01b_sf")] = true,
	[GetHashKey("xs_prop_arena_pit_double_01a_wl")] = true
}

noCollisionObjects = {
	[GetHashKey("ar_prop_ar_checkpoint_xxs")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_xs")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_s")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_m")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_l")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_crn")] = true,
	[GetHashKey("ar_prop_ar_checkpoints_crn_5d")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_crn_15d")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_crn_30d")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_crn02")] = true,
	[GetHashKey("ar_prop_ar_checkpoint_fork")] = true
}

-- copyright @ JoraEmin52's modTool
-- After the game update, we can find new vehicles from modTool and manually add them here
vanilla = {
	[0] = {
		class = "Compacts",
		aveh = {"blista", "dilettante", "issi2", "prairie"},
		adlc = {"rhapsody", "panto", "brioso", "issi3", "kanjo", "asbo", "club", "brioso2", "weevil", "brioso3"}
	},
	[1] = {
		class = "Sedans",
		aveh = {"asea", "asterope", "fugitive", "premier", "primo", "schafter2", "stanier", "superd", "surge", "tailgater", "washington"},
		adlc = {"glendale", "warrener", "primo2", "schafter3", "schafter5", "schafter4", "schafter6", "cog55", "cog552", "cognoscenti", "cognoscenti2", "stafford", "glendale2", "warrener2", "tailgater2", "deity", "cinquemila", "rhinehart", "asterope2", "vorschlaghammer", "chavosv6"}
	},
	[2] = {
		class = "SUV",
		aveh = {"baller", "baller2", "bjxl", "cavalcade2", "crusader", "dubsta", "granger", "gresley", "landstalker", "mesa", "pranger", "radi", "seminole", "serrano", "dubsta3"},
		adlc = {"huntley", "baller3", "baller4", "baller5", "baller6", "xls", "xls2", "contender", "patriot2", "fq2", "habanero", "toros", "novak", "rebla", "landstalker2", "seminole2", "squaddie", "granger2", "astron", "baller7", "jubilee", "iwagen", "issi8", "aleutian", "cavalcade3", "baller8", "dorado", "vivanite", "castigator"}
	},
	[3] = {
		class = "Coupes",
		aveh = {"cogcabrio", "exemplar", "f620", "felon2", "jackal", "oracle2", "sentinel2"},
		adlc = {"windsor", "windsor2", "previon", "kanjosj", "postlude", "fr36", "eurosx32"}
	},
	[4] = {
		class = "Mucle",
		aveh = {"buccaneer", "dominator", "gauntlet", "phoenix", "picador", "ruiner", "sabregt", "vigero", "hotknife"},
		adlc = {"blade", "ratloader2", "slamvan", "dukes", "stalion", "virgo", "coquette3", "chino", "faction", "faction2", "moonbeam2", "chino2", "voodoo", "buccaneer2", "nightshade", "faction3", "slamvan3", "virgo3", "virgo2", "sabregt2", "dominator2", "gauntlet2", "stalion2", "dukes2", "yosemite", "hermes", "hustler", "ellie", "dominator3", "vamos", "impaler", "deviant", "tulip", "clique", "gauntlet3", "gauntlet4", "peyote2", "yosemite2", "dukes3", "gauntlet5", "manana2", "dominator7", "dominator8", "buffalo4", "weevil2", "vigero2", "ruiner4", "greenwood", "eudora", "tulip2", "tahoma", "broadway", "brigham", "clique2", "buffalo5", "dominator9", "impaler6", "vigero3", "dominator10", "impaler5"}
	},
	[5] = {
		class = "Classics",
		aveh = {"jb700", "monroe", "stinger", "ztype"},
		adlc = {"btype", "pigalle", "coquette2", "casco", "feltzer3", "mamba", "tornado5", "tornado6", "infernus2", "turismo2", "cheetah2", "torero", "retinue", "rapidgt3", "savestra", "viseris", "gt500", "z190", "fagaloa", "cheburek", "michelli", "jester3", "swinger", "zion3", "dynasty", "nebula", "retinue2", "btype2", "peyote3", "ardent", "jb7002", "coquette5", "uranus"}
	},
	[6] = {
		class = "Sports",
		aveh = {"ninef2", "banshee", "carbonizzare", "comet2", "coquette", "feltzer2", "fusilade", "futo", "rapidgt2", "sultan", "khamelion"},
		adlc = {"alpha", "jester", "massacro", "furoregt", "jester2", "massacro2", "blista2", "kuruma", "kuruma2", "verlierer2", "bestiagts", "seven70", "omnis", "tropos", "lynx", "tampa2", "buffalo3", "raptor", "elegy2", "elegy", "comet3", "specter", "specter2", "ruston", "raiden", "pariah", "comet4", "sentinel3", "streiter", "revolter", "neon", "comet5", "hotring", "gb200", "flashgt", "schlagen", "italigto", "drafter", "issi7", "neo", "locust", "jugular", "paragon", "schwarzer", "imorgon", "sugoi", "vstr", "komoda", "sultan2", "penumbra2", "coquette4", "italirsx", "calico", "jester4", "zr350", "remus", "vectre", "cypher", "comet6", "rt3000", "sultan3", "futo2", "euros", "growler", "comet7", "paragon2", "corsita", "tenf", "tenf2", "sm722", "sentinel4", "omnisegt", "panthere", "everon2", "r300", "gauntlet6", "stingertt", "coureur", "envisage", "niobe", "paragon3", "jester5", "coquette6", "banshee3"}
	},
	[7] = {
		class = "Super",
		aveh = {"adder", "bullet", "cheetah", "entityxf", "infernus", "vacca", "voltic"},
		adlc = {"turismor", "zentorno", "osiris", "t20", "banshee2", "sultanrs", "reaper", "fmj", "prototipo", "pfister811", "le7b", "tyrus", "sheava", "penetrator", "tempesta", "italigtb", "italigtb2", "nero", "nero2", "gp1", "vagner", "xa21", "visione", "cyclone", "sc1", "autarch", "taipan", "entity2", "tezeract", "tyrant", "deveste", "thrax", "zorrusso", "krieger", "emerus", "s80", "furia", "tigon", "ignus", "zeno", "champion", "lm87", "torero2", "entity3", "virtue", "turismo3", "pipistrello"}
	},
	[8] = {
		class = "Bikes",
		aveh = {"akuma", "bagger", "bati", "bati2", "blazer", "daemon", "double", "nemesis", "pcj", "ruffian", "sanchez2", "sanchez", "vader", "carbonrs"},
		adlc = {"thrust", "sovereign", "innovation", "hakuchou", "enduro", "lectro", "vindicator", "bf400", "gargoyle", "cliffhanger", "hakuchou2", "defiler", "chimera", "zombieb", "avarus", "nightblade", "zombiea", "wolfsbane", "manchez", "ratbike", "faggio3", "faggio", "daemon2", "vortex", "shotaro", "esskey", "diablous", "diablous2", "fcr", "fcr2", "sanctus", "rrocket", "stryder", "manchez2", "shinobi", "reever", "powersurge", "sanchez2", "pizzaboy"}
	},
	[9] = {
		class = "OffRoad",
		aveh = {"bfinjection", "baller", "blazer", "dloader", "dune", "patriot", "sanchez2", "sandking", "bodhi2", "dubsta", "mesa", "rebel", "sandking2", "tornado4", "sanchez", "dubsta3"},
		adlc = {"bifta", "kalahari", "paradise", "monster", "marshall", "insurgent2", "guardian", "brawler", "trophytruck", "trophytruck2", "bf400", "rallytruck", "blazer4", "riata", "kamacho", "freecrawler", "menacer", "hellion", "caracara2", "rancherxl", "outlaw", "everon", "zhaba", "vagrant", "yosemite3", "rebel2", "winky", "verus", "manchez2", "nightshark", "patriot3", "draugur", "boor", "l35", "ratel", "monstrociti", "terminus", "yosemite1500", "firebolt"}
	},
	[10] = {
		class = "Industrial",
		aveh = {"bulldozer", "cutter", "dump", "handler", "mixer"}
	},
	[11] = {
		class = "Utility",
		aveh = {"airtug", "caddy", "faggio2", "tractor2", "mower"},
		adlc = {"slamtruck"}
	},
	[12] = {
		class = "Vans",
		aveh = {"boxville", "burrito2", "camper", "speedo2", "journey", "pony", "minivan", "rumpo", "surfer", "taco", "youga", "mule3", "surfer3"},
		adlc = {"gburrito2", "minivan2", "rumpo3", "youga2", "speedo4", "mule4", "bison3", "boxville", "burrito", "burrito2", "pony", "youga3", "speedo2", "journey2", "surfer3", "benson2", "boxville6"}
	},
	[13] = {
		class = "Cycles",
		aveh = {"bmx", "cruiser", "scorcher", "tribike", "tribike2", "tribike3"},
		adlc = {"inductor", "inductor2"}
	},
	[14] = {
		class = ""
	},
	[15] = {
		class = "Special",
		adlc = {"blazer5", "ruiner2", "voltic2", "deluxo", "stromberg", "thruster", "oppressor", "vigilante", "oppressor2", "scramjet", "rcbandito", "toreador", "dune2"}
	},
	[16] = {
		class = "Weaponised",
		adlc = {"technical2", "technical3", "technical", "dune3", "boxville5", "limo2", "barrage", "halftrack", "apc", "caracara", "insurgent3", "insurgent", "menacer"}
	},
	[17] = {
		class = "Contender",
		adlc = {"bruiser", "brutus", "cerberus", "deathbike", "dominator4", "impaler2", "imperator", "issi4", "monster3", "scarab", "slamvan4", "zr380"}
	},
	[18] = {
		class = "Open Wheel",
		adlc = {"formula", "formula2", "openwheel1", "openwheel2"}
	},
	[19] = {
		class = "Go-Kart",
		adlc = {"veto", "veto2"}
	},
	[20] = {
		class = "Car Club",
		adlc = {"calico", "jester4", "zr350", "remus", "vectre", "cypher", "dominator7", "comet6", "warrener2", "rt3000", "tailgater2", "sultan3", "futo2", "dominator8", "previon", "euros", "growler", "kanjosj", "postlude", "jester5"}
	},
	-- ==============================================================================================================
	-- Since BMX was broken when game build > 2699, I did not continue researching above game build 3095
	-- Perhaps you can find the correct names from modTool and add them here
	[21] = {
		class = "HSW"
	},
	[22] = {
		class = "HSWT1"
	},
	[23] = {
		class = "HSWT2"
	},
	[24] = {
		class = "HSWT3"
	},
	-- ==============================================================================================================
	[25] = {
		class = "Drift",
		adlc = {"drifttampa", "driftyosemite", "drifteuros", "driftfuto", "driftjester", "driftremus", "driftzr350", "driftfr36", "driftcypher", "driftvorschlag", "driftsentinel", "driftnebula", "driftfuto2", "driftcheburek", "driftjester3"}
	},
	[26] = {
		class = ""
	},
	[27] = {
		class = ""
	}
}

vehicleClasses = {
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

availableWeapons = {
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

Citizen.CreateThread(function()
	while not hasNUILoaded do Citizen.Wait(0) end
	TriggerServerCallback("custom_races:server:getRacesData", function(result)
		local valid = false
		if type(result) == "table" then
			for k, v in pairs(result) do
				if #v > 0 then
					valid = true
					break
				end
			end
			if not valid then
				print("Error: Contact the server admin to add/create the race tracks")
				dataOutdated = true
			end
		end
		races_data_front = valid and result or {}
		status = "freemode"
	end)
end)

RegisterNetEvent("custom_races:client:dataOutdated", function()
	while status == "" do Citizen.Wait(0) end
	dataOutdated = true
end)

RegisterNUICallback("custom_races:nui:getCategoryList", function(data, cb)
	local list = {
		translatedText = {
			["Favorite"] = GetTranslate("Favorite"),
			["Personal"] = GetTranslate("Personal")
		},
		CategoryList = {}
	}
	for i = 0, 22 do
		if vehicleClasses[i] then
			table.insert(list.CategoryList, GetTranslate(vehicleClasses[i]))
		end
	end
	cb(list)
end)

RegisterNUICallback("custom_races:nui:getCategory", function(data, cb)
	local category = GetOriginalText(data.category)
	cb(vehicleList[category])
end)

RegisterNUICallback("custom_races:nui:addToFavorite", function(data, cb)
	table.insert(vehicleList["Favorite"], { model = tonumber(data.model) or data.model, label = data.label, category = data.category })
	local category = GetOriginalText(data.category)
	for k, v in pairs(vehicleList[category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = true
		end
	end
	favoriteVehicles[tonumber(data.model) or data.model] = true
	TriggerServerEvent("custom_races:server:setFavorite", favoriteVehicles)
end)

RegisterNUICallback("custom_races:nui:removeFromFavorite", function(data, cb)
	for k, v in pairs(vehicleList["Favorite"]) do
		if v.model == (tonumber(data.model) or data.model) then
			table.remove(vehicleList["Favorite"], k)
		end
	end
	local category = GetOriginalText(data.category)
	for k, v in pairs(vehicleList[category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = false
		end
	end
	favoriteVehicles[tonumber(data.model) or data.model] = nil
	TriggerServerEvent("custom_races:server:setFavorite", favoriteVehicles)
end)

RegisterNUICallback("custom_races:nui:previewVeh", function(data, cb)
	local ped = PlayerPedId()
	if DoesEntityExist(previewVehicle) then
		DeleteVehicle(previewVehicle)
	end
	if tonumber(data.model) then
		-- hash
		RequestModel(tonumber(data.model))
		while not HasModelLoaded(tonumber(data.model)) do
			Citizen.Wait(0)
		end
		previewVehicle = CreateVehicle(tonumber(data.model), -74.9068, -819.0542, 326.1751, 250.0, false, false)
		SetModelAsNoLongerNeeded(tonumber(data.model))
	else
		-- plate
		local mods = personalVehicles[data.model]
		RequestModel(tonumber(mods.model))
		while not HasModelLoaded(tonumber(mods.model)) do
			Citizen.Wait(0)
		end
		previewVehicle = CreateVehicle(tonumber(mods.model), -74.9068, -819.0542, 326.1751, 250.0, false, false)
		SetModelAsNoLongerNeeded(tonumber(mods.model))
		SetVehicleProperties(previewVehicle, mods)
	end
	SetEntityHeading(previewVehicle, 250.0)
	SetPedIntoVehicle(ped, previewVehicle, -1)
	SetVehicleHandbrake(previewVehicle, true)
	FreezeEntityPosition(previewVehicle, true)
	SetEntityCoords(previewVehicle, -74.9068, -819.0542, 326.1751)
	-- Calculate vehicle stats for the preview
	local vehicleData = {
		traction = math.ceil(10 * GetVehicleMaxTraction(previewVehicle) * 1.6),
		maxSpeed = math.ceil(GetVehicleEstimatedMaxSpeed(previewVehicle) * 0.9650553 * 1.4),
		acceleration = math.ceil(GetVehicleAcceleration(previewVehicle) * 2.6 * 100),
		breaking = math.ceil(GetVehicleMaxBraking(previewVehicle) * 0.9650553 * 100),
	}
	if vehicleData.traction > 100.0 then
		vehicleData.traction = 100.0
	end
	if vehicleData.maxSpeed > 70.0 then
		vehicleData.maxSpeed = 70.0
	end
	if vehicleData.acceleration > 100.0 then
		vehicleData.acceleration = 100.0
	end
	if vehicleData.breaking > 100.0 then
		vehicleData.breaking = 100.0
	end
	cb(vehicleData)
end)

RegisterNUICallback("custom_races:nui:selectVehicleCam", function(data, cb)
	inVehicleUI = true
	local ped = PlayerPedId()
	SetEntityCoords(ped, -75.1623, -818.9494, 332.9547)
	SetEntityHeading(ped, 139.5274)
	FreezeEntityPosition(ped, true)
	SetEntityVisible(ped, false, false)
	if DoesEntityExist(joinRaceVehicle) then
		SetEntityVisible(joinRaceVehicle, false)
		SetEntityCollision(joinRaceVehicle, false, false)
		FreezeEntityPosition(joinRaceVehicle, true)
	end
	-- Get player latest vehicles
	favoriteVehicles = {}
	personalVehicles = {}
	vehicleList = {
		["Favorite"] = {},
		["Personal"] = {}
	}
	for k, v in pairs(vehicleClasses) do
		vehicleList[v] = {}
	end
	local querying = true
	TriggerServerCallback("custom_races:server:getVehicles", function(favorites, personals)
		local allVehModels = GetAllVehicleModels()
		for k, v in pairs(personals) do
			if v.plate then
				personalVehicles[v.plate] = v
			end
		end
		for k, v in pairs(favorites) do
			if tonumber(k) then
				local hash = tonumber(k)
				local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
				local class = GetVehicleClassFromName(hash)
				local category = vehicleClasses[class] and GetTranslate(vehicleClasses[class])
				if not Config.BlacklistedVehicles[hash] and IsModelInCdimage(hash) and IsModelValid(hash) and (label ~= "NULL") and category then
					table.insert(vehicleList["Favorite"], { model = hash, label = label:gsub("µ", " "), category = category })
					favoriteVehicles[hash] = v
				end
			elseif personalVehicles[k] then
				local hash = personalVehicles[k].model
				local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
				if not Config.BlacklistedVehicles[hash] and IsModelInCdimage(hash) and IsModelValid(hash) and (label ~= "NULL") then
					table.insert(vehicleList["Favorite"], { model = k, label = label:gsub("µ", " "), category = GetTranslate("Personal") })
					favoriteVehicles[k] = v
				end
			end
		end
		for k, v in pairs(personals) do
			local hash = v.model
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			if not Config.BlacklistedVehicles[hash] and IsModelInCdimage(hash) and IsModelValid(hash) and (label ~= "NULL") then
				table.insert(vehicleList["Personal"], { model = v.plate, label = label:gsub("µ", " "), favorite = favoriteVehicles[v.plate] or false })
			end
		end
		for k, v in pairs(allVehModels) do
			local hash = GetHashKey(v)
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			local class = GetVehicleClassFromName(hash)
			if not Config.BlacklistedVehicles[hash] and (label ~= "NULL") and vehicleClasses[class] then
				table.insert(vehicleList[vehicleClasses[class]], { model = hash, label = label:gsub("µ", " "), favorite = favoriteVehicles[hash] or false })
			end
		end
		for k, v in pairs(vehicleList) do
			table.sort(v, function(a, b)
				return string.lower(a.label) < string.lower(b.label)
			end)
		end
		querying = false
	end)
	Citizen.Wait(1000)
	while querying do Citizen.Wait(0) end
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(ped)
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -66.3730, -818.9483, 330.1423, -20.0, 0.0, 90.0, GetGameplayCamFov())
	SetCamActive(previewCamera, true)
	RenderScriptCams(true, true, 1000, true, false)
	SetCamAffectsAiming(previewCamera, false)
	cb({})
end)

RegisterNUICallback("custom_races:nui:selectVeh", function(data, cb)
	cb({inRoom = inRoom})
	inVehicleUI = false
	local ped = PlayerPedId()
	local vehicle = {}
	if tonumber(data.model) then
		-- hash
		vehicle.label = tonumber(data.model)
		vehicle.mods = tonumber(data.model)
	else
		-- plate
		vehicle.label = tonumber(personalVehicles[data.model].model)
		vehicle.mods = personalVehicles[data.model]
	end
	TriggerServerEvent("custom_races:server:setPlayerVehicle", vehicle)
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(previewCamera, false)
	Citizen.Wait(1000)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	Citizen.Wait(1000)
	if DoesEntityExist(previewVehicle) then
		DeleteVehicle(previewVehicle)
	end
	SetEntityVisible(ped, true, true)
	if joinRaceVehicle ~= 0 then
		if DoesEntityExist(joinRaceVehicle) then
			SetEntityCoords(joinRaceVehicle, joinRacePoint)
			SetEntityHeading(joinRaceVehicle, joinRaceHeading)
			SetEntityVisible(joinRaceVehicle, true)
			SetEntityCollision(joinRaceVehicle, true, true)
			SetPedIntoVehicle(ped, joinRaceVehicle, -1)
		else
			SetEntityCoords(ped, joinRacePoint)
			SetEntityHeading(ped, joinRaceHeading)
		end
	else
		SetEntityCoordsNoOffset(ped, joinRacePoint)
		SetEntityHeading(ped, joinRaceHeading)
	end
	SetGameplayCamRelativeHeading(0)
	FreezeEntityPosition(ped, false)
	if DoesEntityExist(joinRaceVehicle) then
		FreezeEntityPosition(joinRaceVehicle, false)
		ActivatePhysics(joinRaceVehicle)
	end
end)

RegisterNUICallback("custom_races:nui:getBestTimes", function(data, cb)
	TriggerServerCallback("custom_races:server:getBestTimes",function(besttimes)
		for k, v in pairs(besttimes) do
			v.vehicle = (v.vehicle == "parachute" and GetTranslate("transform-parachute")) or (v.vehicle == "beast" and GetTranslate("transform-beast")) or (GetLabelText(v.vehicle) ~= "NULL" and GetLabelText(v.vehicle):gsub("µ", " ")) or GetTranslate("unknown-vehicle")
		end
		cb(besttimes)
	end, data.raceid)
end)

RegisterNUICallback("custom_races:nui:getRandomRace", function(data, cb)
	if Config.GetRandomRaceById then
		-- Random by id (The probability is more average)
		local races = {}
		local raceIds = {}
		for k, v in pairs(races_data_front) do
			for i = 1, #v do
				races[v[i].raceid] = v[i]
				table.insert(raceIds, v[i].raceid)
			end
		end
		if #raceIds > 0 then
			local randomIndex = math.random(#raceIds)
			local randomRaceId = raceIds[randomIndex]
			local randomRace = races[randomRaceId]
			cb({randomRace})
		else
			cb({})
		end
	else
		-- Random by category
		local categories = {}
		for category, _ in pairs(races_data_front) do
			table.insert(categories, category)
		end
		if #categories > 0 then
			local randomCategory = categories[math.random(#categories)]
			local randomRace = races_data_front[randomCategory][math.random(#races_data_front[randomCategory])]
			cb({randomRace})
		else
			cb({})
		end
	end
end)

RegisterNUICallback("custom_races:nui:searchRaces", function(data, cb)
	if isQueryingInProgress then
		cb(nil)
		return
	end
	isQueryingInProgress = true
	local text = data and data.text or ""
	if #text > 0 then
		if string.find(text, "^https://prod.cloud.rockstargames.com/ugc/gta5mission/") and (string.find(text, "jpg$") or string.find(text, "json$")) then
			local ugc_img = string.find(text, "jpg$")
			local ugc_json = string.find(text, "json$")
			TriggerServerCallback("custom_races:server:searchUGC", function(name, maxplayers, reason)
				if name and maxplayers then
					cb({
						createRoom = true,
						img = ugc_img and text or (ugc_json and ((text:match("(.-)/[^/]+$")) .. "/2_0.jpg")) or "",
						name = name,
						maxplayers = maxplayers
					})
					Citizen.Wait(3000)
					isQueryingInProgress = false
				else
					if reason == "cancel" then
						SendNUIMessage({
							action = "nui_msg:showNotification",
							message = GetTranslate("msg-search-cancel")
						})
					elseif reason == "failed" then
						SendNUIMessage({
							action = "nui_msg:showNotification",
							message = GetTranslate("msg-search-failed")
						})
					elseif reason == "timed-out" then
						SendNUIMessage({
							action = "nui_msg:showNotification",
							message = GetTranslate("msg-search-timed-out")
						})
					end
					cb(nil)
					isQueryingInProgress = false
				end
			end, text, ugc_img, ugc_json)
		else
			local str = string.lower(text)
			local races = {}
			for k, v in pairs(races_data_front) do
				for i = 1, #v do
					if string.find(string.lower(v[i].name), str) then
						table.insert(races, v[i])
						if #races >= 200 then
							break
						end
					end
				end
				if #races >= 200 then
					break
				end
			end
			if #races >= 200 then
				SendNUIMessage({
					action = "nui_msg:showNotification",
					message = GetTranslate("msg-result-limit")
				})
			end
			cb(races)
			isQueryingInProgress = false
		end
	else
		cb(nil)
		isQueryingInProgress = false
	end
end)

RegisterNUICallback("custom_races:nui:cancelSearch", function(data, cb)
	TriggerServerEvent("custom_races:server:cancelSearch")
end)