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