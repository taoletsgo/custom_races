function Client.Function.Tuning.GetWheels(currentMods, str)
	local ModFrontWheels = str == "motorcycle"
	local ModBackWheels = str == "motorcycle2"
	local modCount = GetNumVehicleMods(Client.Vehicle.Tuning.Entity, ModBackWheels and 24 or 23) or 0
	local list, index = {{Name = Client.Function.Translate.Get("tuning-default"), Value = -1}}, 1
	for i = 0, modCount - 1, 1 do
		local modName = GetModTextLabel(Client.Vehicle.Tuning.Entity, ModBackWheels and 24 or 23, i)
		if modName then
			local labelName = GetLabelText(modName)
			list[#list + 1] = {Name = labelName ~= "NULL" and labelName or modName, Value = #list - 1}
		end
	end
	for i = 1, #list do
		if (ModFrontWheels and list[i].Value == currentMods.modFrontWheels) or (ModBackWheels and list[i].Value == currentMods.modBackWheels) or (not ModFrontWheels and not ModBackWheels and list[i].Value == currentMods.modFrontWheels) then
			index = i
			break
		end
	end
	return list, index
end

function Client.Function.Tuning.GetColors()
	local colors = {}
	-- black
	colors[#colors + 1] = {Value = 0, Name = Client.Function.Translate.Get("tuning-default")}
	colors[#colors + 1] = {Value = 1, Name = Client.Function.Translate.Get("color-graphite")}
	colors[#colors + 1] = {Value = 2, Name = Client.Function.Translate.Get("color-black_metallic")}
	colors[#colors + 1] = {Value = 3, Name = Client.Function.Translate.Get("color-caststeel")}
	colors[#colors + 1] = {Value = 11, Name = Client.Function.Translate.Get("color-black_anth")}
	colors[#colors + 1] = {Value = 12, Name = Client.Function.Translate.Get("color-matteblack")}
	colors[#colors + 1] = {Value = 15, Name = Client.Function.Translate.Get("color-darknight")}
	colors[#colors + 1] = {Value = 16, Name = Client.Function.Translate.Get("color-deepblack")}
	colors[#colors + 1] = {Value = 21, Name = Client.Function.Translate.Get("color-oil")}
	colors[#colors + 1] = {Value = 147, Name = Client.Function.Translate.Get("color-carbon")}
	-- white
	colors[#colors + 1] = {Value = 111, Name = Client.Function.Translate.Get("color-white")}
	colors[#colors + 1] = {Value = 106, Name = Client.Function.Translate.Get("color-vanilla")}
	colors[#colors + 1] = {Value = 107, Name = Client.Function.Translate.Get("color-creme")}
	colors[#colors + 1] = {Value = 112, Name = Client.Function.Translate.Get("color-polarwhite")}
	colors[#colors + 1] = {Value = 113, Name = Client.Function.Translate.Get("color-beige")}
	colors[#colors + 1] = {Value = 121, Name = Client.Function.Translate.Get("color-mattewhite")}
	colors[#colors + 1] = {Value = 122, Name = Client.Function.Translate.Get("color-snow")}
	colors[#colors + 1] = {Value = 131, Name = Client.Function.Translate.Get("color-cotton")}
	colors[#colors + 1] = {Value = 132, Name = Client.Function.Translate.Get("color-alabaster")}
	colors[#colors + 1] = {Value = 134, Name = Client.Function.Translate.Get("color-purewhite")}
	-- grey
	colors[#colors + 1] = {Value = 156, Name = Client.Function.Translate.Get("color-grey")}
	colors[#colors + 1] = {Value = 4, Name = Client.Function.Translate.Get("color-silver")}
	colors[#colors + 1] = {Value = 5, Name = Client.Function.Translate.Get("color-metallicgrey")}
	colors[#colors + 1] = {Value = 6, Name = Client.Function.Translate.Get("color-laminatedsteel")}
	colors[#colors + 1] = {Value = 7, Name = Client.Function.Translate.Get("color-darkgray")}
	colors[#colors + 1] = {Value = 8, Name = Client.Function.Translate.Get("color-rockygray")}
	colors[#colors + 1] = {Value = 9, Name = Client.Function.Translate.Get("color-graynight")}
	colors[#colors + 1] = {Value = 10, Name = Client.Function.Translate.Get("color-aluminum")}
	colors[#colors + 1] = {Value = 13, Name = Client.Function.Translate.Get("color-graymat")}
	colors[#colors + 1] = {Value = 14, Name = Client.Function.Translate.Get("color-lightgrey")}
	colors[#colors + 1] = {Value = 17, Name = Client.Function.Translate.Get("color-asphaltgray")}
	colors[#colors + 1] = {Value = 18, Name = Client.Function.Translate.Get("color-grayconcrete")}
	colors[#colors + 1] = {Value = 19, Name = Client.Function.Translate.Get("color-darksilver")}
	colors[#colors + 1] = {Value = 20, Name = Client.Function.Translate.Get("color-magnesite")}
	colors[#colors + 1] = {Value = 22, Name = Client.Function.Translate.Get("color-nickel")}
	colors[#colors + 1] = {Value = 23, Name = Client.Function.Translate.Get("color-zinc")}
	colors[#colors + 1] = {Value = 24, Name = Client.Function.Translate.Get("color-dolomite")}
	colors[#colors + 1] = {Value = 25, Name = Client.Function.Translate.Get("color-bluesilver")}
	colors[#colors + 1] = {Value = 26, Name = Client.Function.Translate.Get("color-titanium")}
	colors[#colors + 1] = {Value = 66, Name = Client.Function.Translate.Get("color-steelblue")}
	colors[#colors + 1] = {Value = 93, Name = Client.Function.Translate.Get("color-champagne")}
	colors[#colors + 1] = {Value = 144, Name = Client.Function.Translate.Get("color-grayhunter")}
	-- red
	colors[#colors + 1] = {Value = 27, Name = Client.Function.Translate.Get("color-red")}
	colors[#colors + 1] = {Value = 28, Name = Client.Function.Translate.Get("color-torino_red")}
	colors[#colors + 1] = {Value = 29, Name = Client.Function.Translate.Get("color-poppy")}
	colors[#colors + 1] = {Value = 30, Name = Client.Function.Translate.Get("color-copper_red")}
	colors[#colors + 1] = {Value = 31, Name = Client.Function.Translate.Get("color-cardinal")}
	colors[#colors + 1] = {Value = 32, Name = Client.Function.Translate.Get("color-brick")}
	colors[#colors + 1] = {Value = 33, Name = Client.Function.Translate.Get("color-garnet")}
	colors[#colors + 1] = {Value = 34, Name = Client.Function.Translate.Get("color-cabernet")}
	colors[#colors + 1] = {Value = 35, Name = Client.Function.Translate.Get("color-candy")}
	colors[#colors + 1] = {Value = 39, Name = Client.Function.Translate.Get("color-matte_red")}
	colors[#colors + 1] = {Value = 40, Name = Client.Function.Translate.Get("color-dark_red")}
	colors[#colors + 1] = {Value = 43, Name = Client.Function.Translate.Get("color-red_pulp")}
	colors[#colors + 1] = {Value = 44, Name = Client.Function.Translate.Get("color-bril_red")}
	colors[#colors + 1] = {Value = 46, Name = Client.Function.Translate.Get("color-pale_red")}
	colors[#colors + 1] = {Value = 143, Name = Client.Function.Translate.Get("color-wine_red")}
	colors[#colors + 1] = {Value = 150, Name = Client.Function.Translate.Get("color-volcano")}
	-- pink
	colors[#colors + 1] = {Value = 135, Name = Client.Function.Translate.Get("color-electricpink")}
	colors[#colors + 1] = {Value = 136, Name = Client.Function.Translate.Get("color-salmon")}
	colors[#colors + 1] = {Value = 137, Name = Client.Function.Translate.Get("color-sugarplum")}
	-- blue
	colors[#colors + 1] = {Value = 54, Name = Client.Function.Translate.Get("color-topaz")}
	colors[#colors + 1] = {Value = 60, Name = Client.Function.Translate.Get("color-light_blue")}
	colors[#colors + 1] = {Value = 61, Name = Client.Function.Translate.Get("color-galaxy_blue")}
	colors[#colors + 1] = {Value = 62, Name = Client.Function.Translate.Get("color-dark_blue")}
	colors[#colors + 1] = {Value = 63, Name = Client.Function.Translate.Get("color-azure")}
	colors[#colors + 1] = {Value = 64, Name = Client.Function.Translate.Get("color-navy_blue")}
	colors[#colors + 1] = {Value = 65, Name = Client.Function.Translate.Get("color-lapis")}
	colors[#colors + 1] = {Value = 67, Name = Client.Function.Translate.Get("color-blue_diamond")}
	colors[#colors + 1] = {Value = 68, Name = Client.Function.Translate.Get("color-surfer")}
	colors[#colors + 1] = {Value = 69, Name = Client.Function.Translate.Get("color-pastel_blue")}
	colors[#colors + 1] = {Value = 70, Name = Client.Function.Translate.Get("color-celeste_blue")}
	colors[#colors + 1] = {Value = 73, Name = Client.Function.Translate.Get("color-rally_blue")}
	colors[#colors + 1] = {Value = 74, Name = Client.Function.Translate.Get("color-blue_paradise")}
	colors[#colors + 1] = {Value = 75, Name = Client.Function.Translate.Get("color-blue_night")}
	colors[#colors + 1] = {Value = 77, Name = Client.Function.Translate.Get("color-cyan_blue")}
	colors[#colors + 1] = {Value = 78, Name = Client.Function.Translate.Get("color-cobalt")}
	colors[#colors + 1] = {Value = 79, Name = Client.Function.Translate.Get("color-electric_blue")}
	colors[#colors + 1] = {Value = 80, Name = Client.Function.Translate.Get("color-horizon_blue")}
	colors[#colors + 1] = {Value = 82, Name = Client.Function.Translate.Get("color-metallic_blue")}
	colors[#colors + 1] = {Value = 83, Name = Client.Function.Translate.Get("color-aquamarine")}
	colors[#colors + 1] = {Value = 84, Name = Client.Function.Translate.Get("color-blue_agathe")}
	colors[#colors + 1] = {Value = 85, Name = Client.Function.Translate.Get("color-zirconium")}
	colors[#colors + 1] = {Value = 86, Name = Client.Function.Translate.Get("color-spinel")}
	colors[#colors + 1] = {Value = 87, Name = Client.Function.Translate.Get("color-tourmaline")}
	colors[#colors + 1] = {Value = 127, Name = Client.Function.Translate.Get("color-paradise")}
	colors[#colors + 1] = {Value = 140, Name = Client.Function.Translate.Get("color-bubble_gum")}
	colors[#colors + 1] = {Value = 141, Name = Client.Function.Translate.Get("color-midnight_blue")}
	colors[#colors + 1] = {Value = 146, Name = Client.Function.Translate.Get("color-forbidden_blue")}
	colors[#colors + 1] = {Value = 157, Name = Client.Function.Translate.Get("color-glacier_blue")}
	-- yellow
	colors[#colors + 1] = {Value = 42, Name = Client.Function.Translate.Get("color-yellow")}
	colors[#colors + 1] = {Value = 88, Name = Client.Function.Translate.Get("color-wheat")}
	colors[#colors + 1] = {Value = 89, Name = Client.Function.Translate.Get("color-raceyellow")}
	colors[#colors + 1] = {Value = 91, Name = Client.Function.Translate.Get("color-paleyellow")}
	colors[#colors + 1] = {Value = 126, Name = Client.Function.Translate.Get("color-lightyellow")}
	-- green
	colors[#colors + 1] = {Value = 49, Name = Client.Function.Translate.Get("color-met_dark_green")}
	colors[#colors + 1] = {Value = 50, Name = Client.Function.Translate.Get("color-rally_green")}
	colors[#colors + 1] = {Value = 51, Name = Client.Function.Translate.Get("color-pine_green")}
	colors[#colors + 1] = {Value = 52, Name = Client.Function.Translate.Get("color-olive_green")}
	colors[#colors + 1] = {Value = 53, Name = Client.Function.Translate.Get("color-light_green")}
	colors[#colors + 1] = {Value = 55, Name = Client.Function.Translate.Get("color-lime_green")}
	colors[#colors + 1] = {Value = 56, Name = Client.Function.Translate.Get("color-forest_green")}
	colors[#colors + 1] = {Value = 57, Name = Client.Function.Translate.Get("color-lawn_green")}
	colors[#colors + 1] = {Value = 58, Name = Client.Function.Translate.Get("color-imperial_green")}
	colors[#colors + 1] = {Value = 59, Name = Client.Function.Translate.Get("color-green_bottle")}
	colors[#colors + 1] = {Value = 92, Name = Client.Function.Translate.Get("color-citrus_green")}
	colors[#colors + 1] = {Value = 125, Name = Client.Function.Translate.Get("color-green_anis")}
	colors[#colors + 1] = {Value = 128, Name = Client.Function.Translate.Get("color-khaki")}
	colors[#colors + 1] = {Value = 133, Name = Client.Function.Translate.Get("color-army_green")}
	colors[#colors + 1] = {Value = 151, Name = Client.Function.Translate.Get("color-dark_green")}
	colors[#colors + 1] = {Value = 152, Name = Client.Function.Translate.Get("color-hunter_green")}
	colors[#colors + 1] = {Value = 155, Name = Client.Function.Translate.Get("color-matte_foilage_green")}
	-- orange
	colors[#colors + 1] = {Value = 38, Name = Client.Function.Translate.Get("color-orange")}
	colors[#colors + 1] = {Value = 36, Name = Client.Function.Translate.Get("color-tangerine")}
	colors[#colors + 1] = {Value = 41, Name = Client.Function.Translate.Get("color-matteorange")}
	colors[#colors + 1] = {Value = 123, Name = Client.Function.Translate.Get("color-lightorange")}
	colors[#colors + 1] = {Value = 124, Name = Client.Function.Translate.Get("color-peach")}
	colors[#colors + 1] = {Value = 130, Name = Client.Function.Translate.Get("color-pumpkin")}
	colors[#colors + 1] = {Value = 138, Name = Client.Function.Translate.Get("color-orangelambo")}
	-- brown
	colors[#colors + 1] = {Value = 108, Name = Client.Function.Translate.Get("color-brown")}
	colors[#colors + 1] = {Value = 45, Name = Client.Function.Translate.Get("color-copper")}
	colors[#colors + 1] = {Value = 47, Name = Client.Function.Translate.Get("color-lightbrown")}
	colors[#colors + 1] = {Value = 48, Name = Client.Function.Translate.Get("color-darkbrown")}
	colors[#colors + 1] = {Value = 90, Name = Client.Function.Translate.Get("color-bronze")}
	colors[#colors + 1] = {Value = 94, Name = Client.Function.Translate.Get("color-brownmetallic")}
	colors[#colors + 1] = {Value = 95, Name = Client.Function.Translate.Get("color-expresso")}
	colors[#colors + 1] = {Value = 96, Name = Client.Function.Translate.Get("color-chocolate")}
	colors[#colors + 1] = {Value = 97, Name = Client.Function.Translate.Get("color-terracotta")}
	colors[#colors + 1] = {Value = 98, Name = Client.Function.Translate.Get("color-marble")}
	colors[#colors + 1] = {Value = 99, Name = Client.Function.Translate.Get("color-sand")}
	colors[#colors + 1] = {Value = 100, Name = Client.Function.Translate.Get("color-sepia")}
	colors[#colors + 1] = {Value = 101, Name = Client.Function.Translate.Get("color-bison")}
	colors[#colors + 1] = {Value = 102, Name = Client.Function.Translate.Get("color-palm")}
	colors[#colors + 1] = {Value = 103, Name = Client.Function.Translate.Get("color-caramel")}
	colors[#colors + 1] = {Value = 104, Name = Client.Function.Translate.Get("color-rust")}
	colors[#colors + 1] = {Value = 105, Name = Client.Function.Translate.Get("color-chestnut")}
	colors[#colors + 1] = {Value = 109, Name = Client.Function.Translate.Get("color-hazelnut")}
	colors[#colors + 1] = {Value = 110, Name = Client.Function.Translate.Get("color-shell")}
	colors[#colors + 1] = {Value = 114, Name = Client.Function.Translate.Get("color-mahogany")}
	colors[#colors + 1] = {Value = 115, Name = Client.Function.Translate.Get("color-cauldron")}
	colors[#colors + 1] = {Value = 116, Name = Client.Function.Translate.Get("color-blond")}
	colors[#colors + 1] = {Value = 129, Name = Client.Function.Translate.Get("color-gravel")}
	colors[#colors + 1] = {Value = 153, Name = Client.Function.Translate.Get("color-darkearth")}
	colors[#colors + 1] = {Value = 154, Name = Client.Function.Translate.Get("color-desert")}
	-- purple
	colors[#colors + 1] = {Value = 71, Name = Client.Function.Translate.Get("color-indigo")}
	colors[#colors + 1] = {Value = 72, Name = Client.Function.Translate.Get("color-deeppurple")}
	colors[#colors + 1] = {Value = 76, Name = Client.Function.Translate.Get("color-darkviolet")}
	colors[#colors + 1] = {Value = 81, Name = Client.Function.Translate.Get("color-amethyst")}
	colors[#colors + 1] = {Value = 142, Name = Client.Function.Translate.Get("color-mysticalviolet")}
	colors[#colors + 1] = {Value = 145, Name = Client.Function.Translate.Get("color-purplemetallic")}
	colors[#colors + 1] = {Value = 148, Name = Client.Function.Translate.Get("color-matteviolet")}
	colors[#colors + 1] = {Value = 149, Name = Client.Function.Translate.Get("color-mattedeeppurple")}
	-- chrome
	colors[#colors + 1] = {Value = 120, Name = Client.Function.Translate.Get("color-chrome")}
	colors[#colors + 1] = {Value = 117, Name = Client.Function.Translate.Get("color-brushedchrome")}
	colors[#colors + 1] = {Value = 118, Name = Client.Function.Translate.Get("color-blackchrome")}
	colors[#colors + 1] = {Value = 119, Name = Client.Function.Translate.Get("color-brushedaluminum")}
	-- gold
	colors[#colors + 1] = {Value = 37, Name = Client.Function.Translate.Get("color-gold")}
	colors[#colors + 1] = {Value = 158, Name = Client.Function.Translate.Get("color-puregold")}
	colors[#colors + 1] = {Value = 159, Name = Client.Function.Translate.Get("color-brushedgold")}
	colors[#colors + 1] = {Value = 160, Name = Client.Function.Translate.Get("color-lightgold")}
	-- chameleon
	for i = 161, 242 do
		colors[#colors + 1] = {Value = i, Name = tostring(i)}
	end
	return colors
end

function Client.Function.Tuning.GetNeonColors()
	local neons = {
		{Name = Client.Function.Translate.Get("tuning-default"), 		Value = {R = 0,		G = 0,		B = 0}},
		{Name = Client.Function.Translate.Get("color-white"), 			Value = {R = 255,	G = 255,	B = 255}},
		{Name = Client.Function.Translate.Get("color-lightgrey"), 		Value = {R = 112,	G = 128,	B = 144}},
		{Name = Client.Function.Translate.Get("color-blue"), 			Value = {R = 0,		G = 0,		B = 255}},
		{Name = Client.Function.Translate.Get("color-light_blue"), 		Value = {R = 0,		G = 150,	B = 255}},
		{Name = Client.Function.Translate.Get("color-navy_blue"), 		Value = {R = 0,		G = 0,		B = 128}},
		{Name = Client.Function.Translate.Get("color-azure"), 			Value = {R = 135,	G = 206,	B = 235}},
		{Name = Client.Function.Translate.Get("color-celeste_blue"), 	Value = {R = 0,		G = 245,	B = 255}},
		{Name = Client.Function.Translate.Get("color-mintgreen"), 		Value = {R = 50,	G = 255,	B = 155}},
		{Name = Client.Function.Translate.Get("color-lime_green"), 		Value = {R = 0,		G = 255,	B = 0}},
		{Name = Client.Function.Translate.Get("color-olive_green"), 	Value = {R = 128,	G = 128,	B = 0}},
		{Name = Client.Function.Translate.Get("color-yellow"), 			Value = {R = 255,	G = 255,	B = 0}},
		{Name = Client.Function.Translate.Get("color-gold"), 			Value = {R = 255,	G = 215,	B = 0}},
		{Name = Client.Function.Translate.Get("color-orange"), 			Value = {R = 255,	G = 165,	B = 0}},
		{Name = Client.Function.Translate.Get("color-wheat"), 			Value = {R = 245,	G = 222,	B = 179}},
		{Name = Client.Function.Translate.Get("color-red"), 			Value = {R = 255,	G = 0,		B = 0}},
		{Name = Client.Function.Translate.Get("color-pink"), 			Value = {R = 255,	G = 161,	B = 211}},
		{Name = Client.Function.Translate.Get("color-brightpink"), 		Value = {R = 255,	G = 0,		B = 255}},
		{Name = Client.Function.Translate.Get("color-purple"), 			Value = {R = 153,	G = 0,		B = 153}},
		{Name = Client.Function.Translate.Get("color-sepia"), 			Value = {R = 41,	G = 36,		B = 33}}
	}
	return neons
end

function Client.Function.Tuning.GetXenonColors()
	local colors = {
		{Name = Client.Function.Translate.Get("tuning-default"), 	Value = nil},
		{Name = GetLabelText("CMOD_LGT_1"), 						Value = 255},
		{Name = GetLabelText("CMOD_LGT_2"), 						Value = 0},
		{Name = GetLabelText("CMOD_LGT_3"), 						Value = 1},
		{Name = GetLabelText("CMOD_LGT_4"), 						Value = 2},
		{Name = GetLabelText("CMOD_LGT_5"), 						Value = 3},
		{Name = GetLabelText("CMOD_LGT_6"), 						Value = 4},
		{Name = GetLabelText("CMOD_LGT_7"), 						Value = 5},
		{Name = GetLabelText("CMOD_LGT_8"), 						Value = 6},
		{Name = GetLabelText("CMOD_LGT_9"), 						Value = 7},
		{Name = GetLabelText("CMOD_LGT_10"), 						Value = 8},
		{Name = GetLabelText("CMOD_LGT_11"), 						Value = 9},
		{Name = GetLabelText("CMOD_LGT_12"), 						Value = 10},
		{Name = GetLabelText("CMOD_LGT_13"), 						Value = 11},
		{Name = GetLabelText("CMOD_LGT_14"), 						Value = 12}
	}
	return colors
end

function Client.Function.Tuning.GetWindows()
	local windows = {
		{Name = Client.Function.Translate.Get("tuning-default"), 	Value = 0},
		{Name = GetLabelText("CMOD_WIN_5"), 						Value = 1},
		{Name = GetLabelText("CMOD_WIN_2"), 						Value = 2},
		{Name = GetLabelText("CMOD_WIN_1"), 						Value = 3},
		{Name = GetLabelText("CMOD_WIN_0"), 						Value = 4},
		{Name = GetLabelText("CMOD_WIN_3"), 						Value = 5}
	}
	return windows
end

function Client.Function.Tuning.GetHorns()
	local horns = {
		{Name = Client.Function.Translate.Get("tuning-default"), 	Value = -1},
		{Name = GetLabelText("CMOD_HRN_TRK"), 						Value = 0},
		{Name = GetLabelText("CMOD_HRN_COP"), 						Value = 1},
		{Name = GetLabelText("CMOD_HRN_CLO"), 						Value = 2},
		{Name = GetLabelText("CMOD_HRN_MUS1"), 						Value = 3},
		{Name = GetLabelText("CMOD_HRN_MUS2"), 						Value = 4},
		{Name = GetLabelText("CMOD_HRN_MUS3"), 						Value = 5},
		{Name = GetLabelText("CMOD_HRN_MUS4"), 						Value = 6},
		{Name = GetLabelText("CMOD_HRN_MUS5"), 						Value = 7},
		{Name = GetLabelText("CMOD_HRN_SAD"), 						Value = 8},
		{Name = GetLabelText("HORN_CLAS1"), 						Value = 9},
		{Name = GetLabelText("HORN_CLAS2"), 						Value = 10},
		{Name = GetLabelText("HORN_CLAS3"), 						Value = 11},
		{Name = GetLabelText("HORN_CLAS4"), 						Value = 12},
		{Name = GetLabelText("HORN_CLAS5"), 						Value = 13},
		{Name = GetLabelText("HORN_CLAS6"), 						Value = 14},
		{Name = GetLabelText("HORN_CLAS7"), 						Value = 15},
		{Name = GetLabelText("HORN_LUXE1"), 						Value = 33},
		{Name = "Classical Horn 8", 								Value = 36},
		{Name = GetLabelText("HORN_LUXE2"), 						Value = 32},
		{Name = "Classical Horn Loop 1", 							Value = 35},
		{Name = GetLabelText("HORN_LUXE3"), 						Value = 34},
		{Name = "Classical Horn Loop 2", 							Value = 37},
		{Name = GetLabelText("HORN_CNOTE_C0"), 						Value = 16},
		{Name = GetLabelText("HORN_CNOTE_D0"), 						Value = 17},
		{Name = GetLabelText("HORN_CNOTE_E0"), 						Value = 18},
		{Name = GetLabelText("HORN_CNOTE_F0"), 						Value = 19},
		{Name = GetLabelText("HORN_CNOTE_G0"), 						Value = 20},
		{Name = GetLabelText("HORN_CNOTE_A0"), 						Value = 21},
		{Name = GetLabelText("HORN_CNOTE_B0"), 						Value = 22},
		{Name = GetLabelText("HORN_CNOTE_C1"), 						Value = 23},
		{Name = GetLabelText("HORN_HIPS1"), 						Value = 24},
		{Name = GetLabelText("HORN_HIPS2"), 						Value = 25},
		{Name = GetLabelText("HORN_HIPS3"), 						Value = 26},
		{Name = GetLabelText("HORN_HIPS4"), 						Value = 27},
		{Name = GetLabelText("HORN_INDI_1"), 						Value = 28},
		{Name = GetLabelText("HORN_INDI_2"), 						Value = 29},
		{Name = GetLabelText("HORN_INDI_3"), 						Value = 30},
		{Name = GetLabelText("HORN_INDI_4"), 						Value = 31},
		{Name = GetLabelText("HORN_HWEEN1"), 						Value = 38},
		{Name = "Halloween 1", 										Value = 39},
		{Name = GetLabelText("HORN_HWEEN2"), 						Value = 40},
		{Name = "Halloween 2", 										Value = 41},
		{Name = GetLabelText("HORN_LOWRDER1"), 						Value = 42},
		{Name = "San Andreas", 										Value = 43},
		{Name = GetLabelText("HORN_LOWRDER2"), 						Value = 44},
		{Name = "Liberty City", 									Value = 45},
		{Name = GetLabelText("HORN_XM15_1"), 						Value = 46},
		{Name = GetLabelText("HORN_XM15_2"), 						Value = 48},
		{Name = GetLabelText("HORN_XM15_3"), 						Value = 50},
		{Name = GetLabelText("CMOD_AIRHORN_01"), 					Value = 52},
		{Name = "Air Horn 1", 										Value = 53},
		{Name = GetLabelText("CMOD_AIRHORN_02"), 					Value = 54},
		{Name = "Air Horn 2", 										Value = 55},
		{Name = GetLabelText("CMOD_AIRHORN_03"), 					Value = 56},
		{Name = "Air Horn 3", 										Value = 57}
	}
	return horns
end

function Client.Function.Tuning.GetPlates()
	if GetGameBuildNumber() >= 3095 then
		return {
			{Name = GetLabelText("CMOD_PLA_0"), 	Value = 0},
			{Name = GetLabelText("CMOD_PLA_4"), 	Value = 1},
			{Name = GetLabelText("CMOD_PLA_3"), 	Value = 2},
			{Name = GetLabelText("CMOD_PLA_1"), 	Value = 3},
			{Name = GetLabelText("CMOD_PLA_2"), 	Value = 4},
			{Name = "North Yankton", 				Value = 5},
			{Name = GetLabelText("CMOD_PLA_6"), 	Value = 6},
			{Name = GetLabelText("CMOD_PLA_7"), 	Value = 7},
			{Name = GetLabelText("CMOD_PLA_8"), 	Value = 8},
			{Name = GetLabelText("CMOD_PLA_9"), 	Value = 9},
			{Name = GetLabelText("CMOD_PLA_10"), 	Value = 10},
			{Name = GetLabelText("CMOD_PLA_11"), 	Value = 11},
			{Name = GetLabelText("CMOD_PLA_12"), 	Value = 12}
		}
	else
		return {
			{Name = GetLabelText("CMOD_PLA_0"), 	Value = 0},
			{Name = GetLabelText("CMOD_PLA_4"), 	Value = 1},
			{Name = GetLabelText("CMOD_PLA_3"), 	Value = 2},
			{Name = GetLabelText("CMOD_PLA_1"), 	Value = 3},
			{Name = GetLabelText("CMOD_PLA_2"), 	Value = 4},
			{Name = "North Yankton", 				Value = 5}
		}
	end
end

function Client.Function.Tuning.GetRandomMaxUpgrade(vehicle)
	local values = {}
	SetVehicleModKit(vehicle, 0)
	local colors = Client.Function.Tuning.GetColors()
	local neonColors = Client.Function.Tuning.GetNeonColors()
	local xenonColors = Client.Function.Tuning.GetXenonColors()
	local windows = Client.Function.Tuning.GetWindows()
	local horns = Client.Function.Tuning.GetHorns()
	local plates = Client.Function.Tuning.GetPlates()
	values["color1"] = colors[math.random(#colors)].Value
	values["color2"] = colors[math.random(#colors)].Value
	values["pearlescentColor"] = colors[math.random(#colors)].Value
	values["wheelColor"] = colors[math.random(#colors)].Value
	values["tyreSmokeColor"] = neonColors[math.random(#neonColors)].Value
	values["neonColor"] = neonColors[math.random(#neonColors)].Value
	values["modHorns"] = horns[math.random(#horns)].Value
	values["xenonColor"] = xenonColors[math.random(#xenonColors)].Value
	values["plateIndex"] = plates[math.random(#plates)].Value
	values["windowTint"] = windows[math.random(#windows)].Value
	local function GetRandomUpgradeForMod(modType)
		local modCount = GetNumVehicleMods(vehicle, modType) or 0
		if modType == 11 or modType == 12 or modType == 13 or modType == 15 or modType == 16 then
			return modCount - 1
		else
			local list = {{Value = -1}}
			if modType == 48 and modCount == 0 then
				local liveryCount = GetVehicleLiveryCount(vehicle) or 0
				for i = 0, liveryCount - 1, 1 do
					local liveryName = GetLiveryName(vehicle, i)
					if liveryName then
						list[#list + 1] = {Value = #list - 1}
					end
				end
			else
				for i = 0, modCount - 1, 1 do
					local modName = GetModTextLabel(vehicle, modType, i)
					if modName then
						list[#list + 1] = {Value = #list - 1}
					end
				end
			end
			return list[math.random(#list)].Value
		end
	end
	if GetVehicleClass(vehicle) == 8 then
		values["wheels"] = 6
		SetVehicleWheelType(vehicle, values["wheels"])
		values["modFrontWheels"] = GetRandomUpgradeForMod(23)
		values["modBackWheels"] = GetRandomUpgradeForMod(24)
	else
		local frontWheelTypes = {{Value = 0}, {Value = 1}, {Value = 2}, {Value = 3}, {Value = 4}, {Value = 5}, {Value = 7}, {Value = 10}, {Value = 11}, {Value = 8}, {Value = 9}, {Value = 12}}
		values["wheels"] = frontWheelTypes[math.random(#frontWheelTypes)].Value
		SetVehicleWheelType(vehicle, values["wheels"])
		values["modFrontWheels"] = GetRandomUpgradeForMod(23)
		values["modBackWheels"] = nil
	end
	return {
		modEngine = GetRandomUpgradeForMod(11),
		modBrakes = GetRandomUpgradeForMod(12),
		modTransmission = GetRandomUpgradeForMod(13),
		modSuspension = GetRandomUpgradeForMod(15),
		modArmor = GetRandomUpgradeForMod(16),
		modTurbo = true,
		modSpoilers = GetRandomUpgradeForMod(0),
		modFrontBumper = GetRandomUpgradeForMod(1),
		modRearBumper = GetRandomUpgradeForMod(2),
		modSideSkirt = GetRandomUpgradeForMod(3),
		modExhaust = GetRandomUpgradeForMod(4),
		modFrame = GetRandomUpgradeForMod(5),
		modGrille = GetRandomUpgradeForMod(6),
		modHood = GetRandomUpgradeForMod(7),
		modFender = GetRandomUpgradeForMod(8),
		modRightFender = GetRandomUpgradeForMod(9),
		modRoof = GetRandomUpgradeForMod(10),
		color1 = values["color1"],
		color2 = values["color2"],
		pearlescentColor = values["pearlescentColor"],
		wheels = values["wheels"],
		modFrontWheels = values["modFrontWheels"],
		modCustomFrontWheels = math.random(2) > 1 and true or false,
		modBackWheels = values["modBackWheels"],
		modCustomBackWheels = math.random(2) > 1 and true or false,
		wheelColor = values["wheelColor"],
		modSmokeEnabled = true,
		tyreSmokeColor = {values["tyreSmokeColor"].R, values["tyreSmokeColor"].G, values["tyreSmokeColor"].B},
		modHorns = values["modHorns"],
		neonEnabled = values["neonColor"].R == 0 and values["neonColor"].G == 0 and values["neonColor"].B == 0 and {false, false, false, false} or {true, true, true, true},
		neonColor = {values["neonColor"].R, values["neonColor"].G, values["neonColor"].B},
		modXenon = values["xenonColor"] and true or false,
		xenonColor = values["xenonColor"],
		plateIndex = values["plateIndex"],
		windowTint = values["windowTint"],
		modPlateHolder = GetRandomUpgradeForMod(25),
		modVanityPlate = GetRandomUpgradeForMod(26),
		modTrimA = GetRandomUpgradeForMod(27),
		modOrnaments = GetRandomUpgradeForMod(28),
		modDashboard = GetRandomUpgradeForMod(29),
		modDial = GetRandomUpgradeForMod(30),
		modDoorSpeaker = GetRandomUpgradeForMod(31),
		modSeats = GetRandomUpgradeForMod(32),
		modSteeringWheel = GetRandomUpgradeForMod(33),
		modShifterLeavers = GetRandomUpgradeForMod(34),
		modAPlate = GetRandomUpgradeForMod(35),
		modSpeakers = GetRandomUpgradeForMod(36),
		modTrunk = GetRandomUpgradeForMod(37),
		modHydrolic = GetRandomUpgradeForMod(38),
		modEngineBlock = GetRandomUpgradeForMod(39),
		modAirFilter = GetRandomUpgradeForMod(40),
		modStruts = GetRandomUpgradeForMod(41),
		modArchCover = GetRandomUpgradeForMod(42),
		modAerials = GetRandomUpgradeForMod(43),
		modTrimB = GetRandomUpgradeForMod(44),
		modTank = GetRandomUpgradeForMod(45),
		modWindows = GetRandomUpgradeForMod(46),
		modLivery = GetRandomUpgradeForMod(48)
	}
end

function Client.Function.Tuning.GetProperties(vehicle, ignoreBroken)
	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local hasCustomPrimaryColor = GetIsVehiclePrimaryColourCustom(vehicle)
	local dashboardColor = GetVehicleDashboardColor(vehicle)
	local interiorColor = GetVehicleInteriorColour(vehicle)
	local customPrimaryColor = nil
	if hasCustomPrimaryColor then
		customPrimaryColor = {GetVehicleCustomPrimaryColour(vehicle)}
	end

	local hasCustomXenonColor, customXenonColorR, customXenonColorG, customXenonColorB = GetVehicleXenonLightsCustomColor(vehicle)
	local customXenonColor = nil
	if hasCustomXenonColor then
		customXenonColor = {customXenonColorR, customXenonColorG, customXenonColorB}
	end

	local hasCustomSecondaryColor = GetIsVehicleSecondaryColourCustom(vehicle)
	local customSecondaryColor = nil
	if hasCustomSecondaryColor then
		customSecondaryColor = {GetVehicleCustomSecondaryColour(vehicle)}
	end

	local extras = {}
	for extraId = 0, 20 do
		if DoesExtraExist(vehicle, extraId) then
			extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
		end
	end

	local doorsBroken, windowsBroken, tyreBurst = {}, {}, {}
	local numWheels = tostring(GetVehicleNumberOfWheels(vehicle))

	local TyresIndex = {-- Wheel index list according to the number of vehicle wheels.
		["2"] = {0, 4}, -- Bike and cycle.
		["3"] = {0, 1, 4, 5}, -- Vehicle with 3 wheels (get for wheels because some 3 wheels vehicles have 2 wheels on front and one rear or the reverse).
		["4"] = {0, 1, 4, 5}, -- Vehicle with 4 wheels.
		["6"] = {0, 1, 2, 3, 4, 5} -- Vehicle with 6 wheels.
	}

	if TyresIndex[numWheels] then
		for _, idx in pairs(TyresIndex[numWheels]) do
			tyreBurst[tostring(idx)] = IsVehicleTyreBurst(vehicle, idx, false)
		end
	end

	for windowId = 0, 7 do -- 13
		RollUpWindow(vehicle, windowId) --fix when you put the car away with the window down
		windowsBroken[tostring(windowId)] = not IsVehicleWindowIntact(vehicle, windowId)
	end

	local numDoors = GetNumberOfVehicleDoors(vehicle)
	if numDoors and numDoors > 0 then
		for doorsId = 0, numDoors do
			doorsBroken[tostring(doorsId)] = IsVehicleDoorDamaged(vehicle, doorsId)
		end
	end

	local props = {
		model = GetEntityModel(vehicle),
		doorsBroken = doorsBroken,
		windowsBroken = windowsBroken,
		tyreBurst = tyreBurst,
		tyresCanBurst = GetVehicleTyresCanBurst(vehicle),
		plate = Client.Function.Math.TrimedValue(GetVehicleNumberPlateText(vehicle)) or "",
		plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

		bodyHealth = Client.Function.Math.RoundedValue(GetVehicleBodyHealth(vehicle), 1),
		engineHealth = Client.Function.Math.RoundedValue(GetVehicleEngineHealth(vehicle), 1),
		tankHealth = Client.Function.Math.RoundedValue(GetVehiclePetrolTankHealth(vehicle), 1),

		fuelLevel = Client.Function.Math.RoundedValue(GetVehicleFuelLevel(vehicle), 1),
		dirtLevel = Client.Function.Math.RoundedValue(GetVehicleDirtLevel(vehicle), 1),
		color1 = colorPrimary,
		color2 = colorSecondary,
		customPrimaryColor = customPrimaryColor,
		customSecondaryColor = customSecondaryColor,

		pearlescentColor = pearlescentColor,
		wheelColor = wheelColor,

		dashboardColor = dashboardColor,
		interiorColor = interiorColor,

		wheels = GetVehicleWheelType(vehicle),
		windowTint = GetVehicleWindowTint(vehicle),
		xenonColor = GetVehicleXenonLightsColor(vehicle),
		customXenonColor = customXenonColor,

		neonEnabled = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
		extras = extras,
		tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers = GetVehicleMod(vehicle, 0),
		modFrontBumper = GetVehicleMod(vehicle, 1),
		modRearBumper = GetVehicleMod(vehicle, 2),
		modSideSkirt = GetVehicleMod(vehicle, 3),
		modExhaust = GetVehicleMod(vehicle, 4),
		modFrame = GetVehicleMod(vehicle, 5),
		modGrille = GetVehicleMod(vehicle, 6),
		modHood = GetVehicleMod(vehicle, 7),
		modFender = GetVehicleMod(vehicle, 8),
		modRightFender = GetVehicleMod(vehicle, 9),
		modRoof = GetVehicleMod(vehicle, 10),
		modRoofLivery = GetVehicleRoofLivery(vehicle),

		modEngine = GetVehicleMod(vehicle, 11),
		modBrakes = GetVehicleMod(vehicle, 12),
		modTransmission = GetVehicleMod(vehicle, 13),
		modHorns = GetVehicleMod(vehicle, 14),
		modSuspension = GetVehicleMod(vehicle, 15),
		modArmor = GetVehicleMod(vehicle, 16),

		modTurbo = IsToggleModOn(vehicle, 18),
		modSmokeEnabled = IsToggleModOn(vehicle, 20),
		modXenon = IsToggleModOn(vehicle, 22),

		modFrontWheels = GetVehicleMod(vehicle, 23),
		modCustomFrontWheels = GetVehicleModVariation(vehicle, 23),
		modBackWheels = GetVehicleMod(vehicle, 24),
		modCustomBackWheels = GetVehicleModVariation(vehicle, 24),

		modPlateHolder = GetVehicleMod(vehicle, 25),
		modVanityPlate = GetVehicleMod(vehicle, 26),
		modTrimA = GetVehicleMod(vehicle, 27),
		modOrnaments = GetVehicleMod(vehicle, 28),
		modDashboard = GetVehicleMod(vehicle, 29),
		modDial = GetVehicleMod(vehicle, 30),
		modDoorSpeaker = GetVehicleMod(vehicle, 31),
		modSeats = GetVehicleMod(vehicle, 32),
		modSteeringWheel = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate = GetVehicleMod(vehicle, 35),
		modSpeakers = GetVehicleMod(vehicle, 36),
		modTrunk = GetVehicleMod(vehicle, 37),
		modHydrolic = GetVehicleMod(vehicle, 38),
		modEngineBlock = GetVehicleMod(vehicle, 39),
		modAirFilter = GetVehicleMod(vehicle, 40),
		modStruts = GetVehicleMod(vehicle, 41),
		modArchCover = GetVehicleMod(vehicle, 42),
		modAerials = GetVehicleMod(vehicle, 43),
		modTrimB = GetVehicleMod(vehicle, 44),
		modTank = GetVehicleMod(vehicle, 45),
		modWindows = GetVehicleMod(vehicle, 46),
		modLivery = GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) or GetVehicleMod(vehicle, 48),
		modLightbar = GetVehicleMod(vehicle, 49)
	}
	if ignoreBroken then
		props.doorsBroken = nil
		props.windowsBroken = nil
		props.tyreBurst = nil
		props.tyresCanBurst = nil
		props.bodyHealth = nil
		props.engineHealth = nil
		props.tankHealth = nil
		props.fuelLevel = nil
		props.dirtLevel = nil
	end
	return props
end

function Client.Function.Tuning.SetProperties(vehicle, props)
	if not DoesEntityExist(vehicle) or (type(props) ~= "table") then
		return
	end
	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	SetVehicleModKit(vehicle, 0)

	if props.tyresCanBurst ~= nil then
		SetVehicleTyresCanBurst(vehicle, props.tyresCanBurst)
	end
	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end
	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end
	if props.bodyHealth ~= nil then
		SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
	end
	if props.engineHealth ~= nil then
		SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
	end
	if props.tankHealth ~= nil then
		SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
	end
	if props.fuelLevel ~= nil then
		SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
	end
	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
	end
	if props.customPrimaryColor ~= nil then
		SetVehicleCustomPrimaryColour(vehicle, props.customPrimaryColor[1], props.customPrimaryColor[2], props.customPrimaryColor[3])
	end
	if props.customSecondaryColor ~= nil then
		SetVehicleCustomSecondaryColour(vehicle, props.customSecondaryColor[1], props.customSecondaryColor[2], props.customSecondaryColor[3])
	end
	if props.color1 ~= nil then
		SetVehicleColours(vehicle, props.color1, colorSecondary)
	end
	if props.color2 ~= nil then
		SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
	end
	if props.pearlescentColor ~= nil then
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end
	if props.interiorColor ~= nil then
		SetVehicleInteriorColor(vehicle, props.interiorColor)
	end
	if props.dashboardColor ~= nil then
		SetVehicleDashboardColor(vehicle, props.dashboardColor)
	end
	if props.wheelColor ~= nil then
		SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
	end
	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end
	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end
	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end
	if props.extras ~= nil then
		for extraId, enabled in pairs(props.extras) do
			SetVehicleExtra(vehicle, tonumber(extraId), enabled and 0 or 1)
		end
	end
	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end
	if props.xenonColor ~= nil then
		SetVehicleXenonLightsColor(vehicle, props.xenonColor)
	end
	if props.customXenonColor ~= nil then
		SetVehicleXenonLightsCustomColor(vehicle, props.customXenonColor[1], props.customXenonColor[2], props.customXenonColor[3])
	end
	if props.modSmokeEnabled ~= nil then
		ToggleVehicleMod(vehicle, 20, true)
	end
	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end
	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end
	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end
	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end
	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end
	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end
	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end
	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end
	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end
	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end
	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end
	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end
	if props.modRoofLivery ~= nil then
		SetVehicleRoofLivery(vehicle, props.modRoofLivery)
	end
	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end
	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end
	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end
	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end
	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end
	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end
	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle, 18, props.modTurbo)
	end
	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle, 22, props.modXenon)
	end
	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomFrontWheels)
	end
	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomBackWheels)
	end
	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end
	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end
	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end
	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end
	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end
	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end
	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end
	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end
	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end
	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end
	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end
	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end
	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end
	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end
	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end
	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end
	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end
	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end
	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end
	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end
	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end
	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end
	if props.modLivery ~= nil then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end
	if props.windowsBroken ~= nil then
		for k, v in pairs(props.windowsBroken) do
			if v then
				RemoveVehicleWindow(vehicle, tonumber(k))
			end
		end
	end
	if props.doorsBroken ~= nil then
		for k, v in pairs(props.doorsBroken) do
			if v then
				SetVehicleDoorBroken(vehicle, tonumber(k), true)
			end
		end
	end
	if props.tyreBurst ~= nil then
		for k, v in pairs(props.tyreBurst) do
			if v then
				SetVehicleTyreBurst(vehicle, tonumber(k), true, 1000.0)
			end
		end
	end
end