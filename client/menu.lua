Client.Menu.Main = RageUI.CreateMenu(Client.Function.Translate.Get("main-menu"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Race = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-race-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Player = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-player-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Spawn = {}
Client.Menu.Spawn.Main = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-spawn-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Spawn.Classes = {}
Client.Menu.Spawn.Classes["saved-vehicles"] = RageUI.CreateSubMenu(Client.Menu.Spawn.Main, Client.Function.Translate.Get("saved-vehicles"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Spawn.Classes["add-on-vehicles"] = RageUI.CreateSubMenu(Client.Menu.Spawn.Main, Client.Function.Translate.Get("add-on-vehicles"), Client.Function.Translate.Get("menu-items"), true)
for _, class in pairs(Client.Vehicle.Classes) do
	Client.Menu.Spawn.Classes[class] = RageUI.CreateSubMenu(Client.Menu.Spawn.Main, Client.Function.Translate.Get(class), Client.Function.Translate.Get("menu-items"), true)
end
Client.Menu.Spawn.SavedVehicles = {}
Client.Menu.Vehicle = {}
Client.Menu.Vehicle.Main = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-vehicle-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Vehicle.Custom = {}
Client.Menu.Vehicle.Custom.Main = RageUI.CreateSubMenu(Client.Menu.Vehicle.Main, "", Client.Function.Translate.Get("menu-vehicle-custom"), false)
Client.Menu.Vehicle.Custom.Upgrade = RageUI.CreateSubMenu(Client.Menu.Vehicle.Custom.Main, "", Client.Function.Translate.Get("menu-vehicle-custom-upgrades"), false)
Client.Menu.Vehicle.Custom.BodyPart = RageUI.CreateSubMenu(Client.Menu.Vehicle.Custom.Main, "", Client.Function.Translate.Get("menu-vehicle-custom-bodyparts"), false)
Client.Menu.Vehicle.Custom.Respray = RageUI.CreateSubMenu(Client.Menu.Vehicle.Custom.Main, "", Client.Function.Translate.Get("menu-vehicle-custom-respray"), false)
Client.Menu.Vehicle.Custom.Wheel = RageUI.CreateSubMenu(Client.Menu.Vehicle.Custom.Main, "", Client.Function.Translate.Get("menu-vehicle-custom-wheels"), false)
Client.Menu.Ped = {}
Client.Menu.Ped.Main = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-ped-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Ped.Skin = {}
Client.Menu.Ped.Skin.Main = RageUI.CreateSubMenu(Client.Menu.Ped.Main, "", Client.Function.Translate.Get("menu-ped-skin"), false)
Client.Menu.Ped.Skin.Face = RageUI.CreateSubMenu(Client.Menu.Ped.Skin.Main, "", Client.Function.Translate.Get("menu-ped-skin-face"), false)
Client.Menu.Ped.Skin.Component = RageUI.CreateSubMenu(Client.Menu.Ped.Skin.Main, "", Client.Function.Translate.Get("menu-ped-skin-component"), false)
Client.Menu.Ped.Skin.Prop = RageUI.CreateSubMenu(Client.Menu.Ped.Skin.Main, "", Client.Function.Translate.Get("menu-ped-skin-prop"), false)
Client.Menu.Ped.Skin.Overlay = RageUI.CreateSubMenu(Client.Menu.Ped.Skin.Main, "", Client.Function.Translate.Get("menu-ped-skin-overlay"), false)
Client.Menu.Ped.Skin.Tattoo = {}
Client.Menu.Ped.Skin.Tattoo.Main = RageUI.CreateSubMenu(Client.Menu.Ped.Skin.Main, "", Client.Function.Translate.Get("menu-ped-skin-tattoo"), false)
Client.Menu.Ped.Skin.Tattoo.Zones = {}
for _, zoneName in pairs(Client.Skin.Tattoo.Zones) do
	Client.Menu.Ped.Skin.Tattoo.Zones[zoneName] = RageUI.CreateSubMenu(Client.Menu.Ped.Skin.Tattoo.Main, "", Client.Function.Translate.Get("skin-tattoo-" .. zoneName:gsub("^ZONE_", ""):lower():gsub("_", "-")), false)
end
Client.Menu.Ped.Animal = RageUI.CreateSubMenu(Client.Menu.Ped.Main, Client.Function.Translate.Get("menu-ped-animal"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Ped.AddOn = RageUI.CreateSubMenu(Client.Menu.Ped.Main, Client.Function.Translate.Get("menu-ped-add-on"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Weapon = {}
Client.Menu.Weapon.Main = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-weapon-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Weapon.Category = RageUI.CreateSubMenu(Client.Menu.Weapon.Main, "", Client.Function.Translate.Get("menu-weapon-category"), false)
Client.Menu.Weapon.Categories = {}
Client.Menu.Weapon.All = {}
Client.Menu.World = {}
Client.Menu.World.Main = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-world-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.World.Weather = RageUI.CreateSubMenu(Client.Menu.World.Main, Client.Function.Translate.Get("menu-world-weather"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.World.Time = RageUI.CreateSubMenu(Client.Menu.World.Main, Client.Function.Translate.Get("menu-world-time"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.World.Teleport = RageUI.CreateSubMenu(Client.Menu.World.Main, Client.Function.Translate.Get("menu-world-teleport"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Record = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-record-options"), Client.Function.Translate.Get("menu-items"), true)
Client.Menu.Misc = RageUI.CreateSubMenu(Client.Menu.Main, Client.Function.Translate.Get("menu-misc-options"), Client.Function.Translate.Get("menu-items"), true)

Client.Menu.Vehicle.Custom.Main.WidthOffset = 200
Client.Menu.Vehicle.Custom.Upgrade.WidthOffset = 200
Client.Menu.Vehicle.Custom.BodyPart.WidthOffset = 200
Client.Menu.Vehicle.Custom.Respray.WidthOffset = 200
Client.Menu.Vehicle.Custom.Wheel.WidthOffset = 200
Client.Menu.Weapon.Category.WidthOffset = 120

function RageUI.PoolMenus:Client()
	Client.IsSkinMenuVisible = false
	Client.IsWeaponMenuVisible = false

	Client.Menu.Main:IsVisible(function(Items)
		if not Client.IsInRace and not Client.IsInCreator then
			Items:AddButton(Client.Function.Translate.Get("menu-race-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)

			end, Client.Menu.Race)
		end

		Items:AddButton(Client.Function.Translate.Get("menu-player-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.Player)

		if not Client.IsInRace then
			Items:AddButton(Client.Function.Translate.Get("menu-spawn-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)

			end, Client.Menu.Spawn.Main)

			Items:AddButton(Client.Function.Translate.Get("menu-vehicle-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)

			end, Client.Menu.Vehicle.Main)

			Items:AddButton(Client.Function.Translate.Get("menu-ped-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)
				if onSelected then
					if GetFollowPedCamViewMode() == 4 then
						SetFollowPedCamViewMode(2)
					end
				end
			end, Client.Menu.Ped.Main)

			Items:AddButton(Client.Function.Translate.Get("menu-weapon-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)
				if onSelected then
					if GetFollowPedCamViewMode() == 4 then
						SetFollowPedCamViewMode(2)
					end
				end
			end, Client.Menu.Weapon.Main)
		end

		Items:AddButton(Client.Function.Translate.Get("menu-world-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.World.Main)

		Items:AddButton(Client.Function.Translate.Get("menu-record-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.Record)

		Items:AddButton(Client.Function.Translate.Get("menu-misc-options"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.Misc)

		if not Client.IsInRace then
			Items:CheckBox(Client.Function.Translate.Get("menu-noclip"), nil, Client.Noclip.Enable, {Style = 1, IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning}, function(onSelected, IsChecked)
				if onSelected and IsChecked then
					CreateThread(function()
						RageUI.CloseAll(true)
						Wait(0)
						if not Client.IsInRace and not Client.IsInCreator and not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
							if not Client.Noclip.Enable then
								Client.Noclip.Enable = true
								Client.Function.Noclip.Enable()
							end
						else
							Client.Noclip.Enable = false
						end
					end)
				end
			end)
		else
			Items:AddButton(Client.Function.Translate.Get("menu-quit-race"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning or Client.IsPedSpawning, SoundOFF = true}, function(onSelected)
				if onSelected then
					CreateThread(function()
						RageUI.CloseAll()
						Wait(0)
						ExecuteCommand("leave")
					end)
				end
			end)
		end
	end, function(Panels)
	end)

	Client.Menu.Race:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-open-race"), nil, {IsDisabled = false, SoundOFF = true}, function(onSelected)
			if onSelected then
				CreateThread(function()
					RageUI.CloseAll()
					Wait(0)
					ExecuteCommand("race")
				end)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-check-invitation"), Client.Function.Translate.Get("menu-check-invitation-desc"), {IsDisabled = false, SoundOFF = true}, function(onSelected)
			if onSelected then
				CreateThread(function()
					RageUI.CloseAll()
					Wait(0)
					ExecuteCommand("inv")
				end)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-open-creator"), nil, {IsDisabled = false, SoundOFF = true}, function(onSelected)
			if onSelected then
				CreateThread(function()
					RageUI.CloseAll()
					Wait(0)
					ExecuteCommand("creator")
				end)
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Player:IsVisible(function(Items)
		local playerList = {}
		for _, player in pairs(Client.Player.List) do
			playerList[#playerList + 1] = {name = player[3], position = {x = player[2][1], y = player[2][2], z = player[2][3]}, canTp = player[1] ~= Client.ServerId}
		end
		table.sort(playerList, function(a, b)
			return string.lower(a.name) < string.lower(b.name)
		end)
		for i = 1, #playerList do
			Items:AddButton(playerList[i].name, not Client.IsInRace and playerList[i].canTp and Client.Function.Translate.Get("menu-tp-to-player"), {IsDisabled = Client.IsInRace or not playerList[i].canTp}, function(onSelected)
				if onSelected then
					SetPedCoordsKeepVehicle(PlayerPedId(), playerList[i].position.x + 0.0, playerList[i].position.y + 0.0, playerList[i].position.z + 20.0)
					SetGameplayCamRelativeHeading(0)
				end
			end)
		end
	end, function(Panels)
	end)

	Client.Menu.Spawn.Main:IsVisible(function(Items)
		Client.Vehicle.Preview.Model = nil
		Client.Vehicle.Preview.Props = nil

		Items:AddButton(Client.Function.Translate.Get("menu-spawn-vehicle-by-model-name"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = ""
				})
				Client.NUI.Callback = "spawn vehicle by model name"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-spawn-vehicle-by-plate-text"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = ""
				})
				Client.NUI.Callback = "spawn vehicle by plate"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-save-vehicle"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning}, function(onSelected)
			if onSelected then
				local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
				if DoesEntityExist(vehicle) then
					local props = Client.Function.Tuning.GetProperties(vehicle, false)
					local found = false
					props.fuelLevel = 100.0
					for key, savedVehicle in pairs(Client.Vehicle.SavedVehicles) do
						if savedVehicle.plate == props.plate then
							found = true
							Client.Vehicle.SavedVehicles[key] = props
							Client.Function.Message.Display(Client.Function.Translate.Get("save-vehicle-override"))
							TriggerServerEvent("server:core:saveVehicle", props, 2)
							break
						end
					end
					if not found then
						if #Client.Vehicle.SavedVehicles < Client.Vehicle.MaxSaves then
							table.insert(Client.Vehicle.SavedVehicles, props)
							Client.Function.Vehicle.SetSavedForMenu()
							Client.Function.Message.Display(Client.Function.Translate.Get("save-vehicle-success"))
							TriggerServerEvent("server:core:saveVehicle", props, 1)
						else
							Client.Function.Message.Display(string.format(Client.Function.Translate.Get("save-vehicle-max-limit"), Client.Vehicle.MaxSaves))
						end
					end
				else
					Client.Function.Message.Display(Client.Function.Translate.Get("save-vehicle-not-in"))
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("saved-vehicles"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.Spawn.Classes["saved-vehicles"])

		Items:AddButton(Client.Function.Translate.Get("add-on-vehicles"), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.Spawn.Classes["add-on-vehicles"])

		for i = 0, 22 do
			local class = Client.Vehicle.Classes[i]
			if class then
				Items:AddButton(Client.Function.Translate.Get(class), nil, {IsDisabled = IsNuiFocused() or Client.IsVehicleSpawning, RightLabel = "→→→"}, function(onSelected)

				end, Client.Menu.Spawn.Classes[class])
			end
		end
	end, function(Panels)
	end)

	Client.Menu.Spawn.Classes["saved-vehicles"]:IsVisible(function(Items)
		for i = 1, #Client.Vehicle.SavedVehicles do
			local savedVehicle = Client.Vehicle.SavedVehicles[i]
			local name = GetDisplayNameFromVehicleModel(savedVehicle.model)
			local label = GetLabelText(name)
			Items:AddButton((label ~= "NULL" and label or name) .. " (" .. savedVehicle.plate .. ")", nil, {IsDisabled = false, RightLabel = "→→→"}, function(onSelected)
				Client.Vehicle.Preview.Model = savedVehicle.model
				Client.Vehicle.Preview.Props = savedVehicle
			end, Client.Menu.Spawn.SavedVehicles[savedVehicle.plate])
		end
	end, function(Panels)
	end)

	for key, savedVehicle in pairs(Client.Vehicle.SavedVehicles) do
		if Client.Menu.Spawn.SavedVehicles[savedVehicle.plate] then
			Client.Menu.Spawn.SavedVehicles[savedVehicle.plate]:IsVisible(function(Items)
				Items:AddButton(Client.Function.Translate.Get("menu-spawn") .. " (" .. savedVehicle.plate .. ")", nil, {IsDisabled = Client.IsVehicleSpawning}, function(onSelected)
					if onSelected then
						Client.IsVehicleSpawning = true
						Client.Function.Vehicle.Spawn(savedVehicle.model, savedVehicle)
					end
				end)

				Items:AddButton(Client.Function.Translate.Get("menu-delete"), nil, {IsDisabled = false}, function(onSelected)
					if onSelected then
						RageUI.GoBack(false)
						TriggerServerEvent("server:core:saveVehicle", savedVehicle.plate, 0)
						table.remove(Client.Vehicle.SavedVehicles, key)
						Client.Function.Vehicle.SetSavedForMenu()
					end
				end)
			end, function(Panels)
			end)
		end
	end

	Client.Menu.Spawn.Classes["add-on-vehicles"]:IsVisible(function(Items)
		for i = 1, #Client.Vehicle.AddOnVehicles do
			local addOnVehicle = Client.Vehicle.AddOnVehicles[i]
			Items:AddButton(addOnVehicle.label, nil, {IsDisabled = Client.IsVehicleSpawning, RightLabel = addOnVehicle.rightLabel}, function(onSelected)
				Client.Vehicle.Preview.Model = addOnVehicle.model
				Client.Vehicle.Preview.Props = nil
				if onSelected then
					Client.IsVehicleSpawning = true
					Client.Function.Vehicle.Spawn(addOnVehicle.model, nil)
				end
			end)
		end
	end, function(Panels)
	end)

	for _, class in pairs(Client.Vehicle.Classes) do
		Client.Menu.Spawn.Classes[class]:IsVisible(function(Items)
			local vanillaVehicles = Client.Vehicle.List[class]
			for i = 1, #vanillaVehicles do
				local vanillaVehicle = vanillaVehicles[i]
				Items:AddButton(vanillaVehicle.label, nil, {IsDisabled = Client.IsVehicleSpawning, RightLabel = vanillaVehicle.rightLabel}, function(onSelected)
					Client.Vehicle.Preview.Model = vanillaVehicle.model
					Client.Vehicle.Preview.Props = nil
					if onSelected then
						Client.IsVehicleSpawning = true
						Client.Function.Vehicle.Spawn(vanillaVehicle.model, nil)
					end
				end)
			end
		end, function(Panels)
		end)
	end

	Client.Menu.Vehicle.Main:IsVisible(function(Items)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local lock = not DoesEntityExist(vehicle)

		Items:CheckBox(Client.Function.Translate.Get("menu-delete-when-spawn-vehicle"), nil, Client.Preference.DeleteWhenSpawnVehicle, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.DeleteWhenSpawnVehicle = IsChecked
				TriggerServerEvent("server:core:preferences", {DeleteWhenSpawnVehicle = Client.Preference.DeleteWhenSpawnVehicle})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-keep-vehicle-invincible"), nil, Client.Preference.KeepVehicleInvincible, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.KeepVehicleInvincible = IsChecked
				TriggerServerEvent("server:core:preferences", {KeepVehicleInvincible = Client.Preference.KeepVehicleInvincible})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-repair-vehicle-when-tp"), nil, Client.Preference.RepairVehicleWhenTp, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.RepairVehicleWhenTp = IsChecked
				TriggerServerEvent("server:core:preferences", {RepairVehicleWhenTp = Client.Preference.RepairVehicleWhenTp})
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-spawn-random-vehicle"), nil, {IsDisabled = Client.IsVehicleSpawning}, function(onSelected)
			if onSelected then
				Client.IsVehicleSpawning = true
				local success = false
				local allVehModels = GetAllVehicleModels()
				if #allVehModels > 0 then
					for i = 1, 10 do
						local randomModel = GetHashKey(allVehModels[math.random(#allVehModels)])
						local randomName = GetDisplayNameFromVehicleModel(randomModel)
						local randomLabel = GetLabelText(randomName)
						if IsModelAVehicle(randomModel) and GetVehicleModelNumberOfSeats(randomModel) >= 1 then
							Client.Function.Vehicle.Spawn(randomModel, nil, randomLabel ~= "NULL" and randomLabel or randomName)
							success = true
							break
						end
					end
				end
				if not success then
					Client.Function.Vehicle.Spawn(GetHashKey("bmx"), nil, "BMX")
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-random-max-upgrade"), nil, {IsDisabled = Client.IsVehicleSpawning or not Client.Permission.CustomVehicle or Client.Vehicle.Tuning.MenuLocked or lock}, function(onSelected)
			if onSelected then
				Client.Vehicle.Tuning.MenuLocked = true
				Client.Function.Vehicle.Fix(vehicle)
				Client.Function.Tuning.SetProperties(vehicle, Client.Function.Tuning.GetRandomMaxUpgrade(vehicle))
				CreateThread(function()
					Wait(3000)
					Client.Vehicle.Tuning.MenuLocked = false
				end)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-vehicle-custom"), nil, {IsDisabled = Client.IsVehicleSpawning or not Client.Permission.CustomVehicle or Client.Vehicle.Tuning.MenuLocked or lock, RightLabel = "→→→"}, function(onSelected)
			if onSelected then
				Client.Vehicle.Tuning.Entity = vehicle
				Client.Vehicle.Tuning.MenuLocked = true
				Client.Function.Vehicle.Fix(Client.Vehicle.Tuning.Entity)
				local currentMods = Client.Function.Tuning.GetProperties(Client.Vehicle.Tuning.Entity, false)
				SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
				Client.Vehicle.Menu["modHorns"].List, Client.Vehicle.Menu["modHorns"].Index = Client.Function.Tuning.GetHorns(), 1
				for i = 1, #Client.Vehicle.Menu["modHorns"].List do
					if Client.Vehicle.Menu["modHorns"].List[i].Value == currentMods.modHorns then
						Client.Vehicle.Menu["modHorns"].Index = i
						break
					end
				end
				Client.Vehicle.Menu["neonColor"].List, Client.Vehicle.Menu["neonColor"].Index = Client.Function.Tuning.GetNeonColors(), 1
				for i = 1, #Client.Vehicle.Menu["neonColor"].List do
					if (currentMods.neonEnabled and (currentMods.neonEnabled[1] or currentMods.neonEnabled[2] or currentMods.neonEnabled[3] or currentMods.neonEnabled[4]) and currentMods.neonColor and currentMods.neonColor[1] == Client.Vehicle.Menu["neonColor"].List[i].Value.R and currentMods.neonColor[2] == Client.Vehicle.Menu["neonColor"].List[i].Value.G and currentMods.neonColor[3] == Client.Vehicle.Menu["neonColor"].List[i].Value.B) then
						Client.Vehicle.Menu["neonColor"].Index = i
						break
					end
				end
				Client.Vehicle.Menu["xenonColor"].List, Client.Vehicle.Menu["xenonColor"].Index = Client.Function.Tuning.GetXenonColors(), 1
				for i = 1, #Client.Vehicle.Menu["xenonColor"].List do
					if currentMods.modXenon and (Client.Vehicle.Menu["xenonColor"].List[i].Value == currentMods.xenonColor) then
						Client.Vehicle.Menu["xenonColor"].Index = i
						break
					end
				end
				Client.Vehicle.Menu["plateIndex"].List, Client.Vehicle.Menu["plateIndex"].Index = Client.Function.Tuning.GetPlates(), 1
				for i = 1, #Client.Vehicle.Menu["plateIndex"].List do
					if Client.Vehicle.Menu["plateIndex"].List[i].Value == currentMods.plateIndex then
						Client.Vehicle.Menu["plateIndex"].Index = i
						break
					end
				end
				Client.Vehicle.Menu["windowTint"].List, Client.Vehicle.Menu["windowTint"].Index = Client.Function.Tuning.GetWindows(), 1
				for i = 1, #Client.Vehicle.Menu["windowTint"].List do
					if Client.Vehicle.Menu["windowTint"].List[i].Value == currentMods.windowTint then
						Client.Vehicle.Menu["windowTint"].Index = i
						break
					end
				end
				local function BuildModList(modType, currentValue)
					local list, index = {{Name = Client.Function.Translate.Get("tuning-default"), Value = -1}}, 1
					local modCount = GetNumVehicleMods(Client.Vehicle.Tuning.Entity, modType) or 0
					if modType == 48 and modCount == 0 then
						local liveryCount = GetVehicleLiveryCount(Client.Vehicle.Tuning.Entity) or 0
						for i = 0, liveryCount - 1, 1 do
							local liveryName = GetLiveryName(Client.Vehicle.Tuning.Entity, i)
							if liveryName then
								local labelName = GetLabelText(liveryName)
								list[#list + 1] = {Name = labelName ~= "NULL" and labelName or liveryName, Value = #list - 1}
							end
						end
					else
						for i = 0, modCount - 1, 1 do
							local modName = GetModTextLabel(Client.Vehicle.Tuning.Entity, modType, i)
							if modName then
								local labelName = GetLabelText(modName)
								list[#list + 1] = {Name = labelName ~= "NULL" and labelName or modName, Value = #list - 1}
							end
						end
					end
					for i = 1, #list do
						if list[i].Value == currentValue then
							index = i
							break
						end
					end
					return list, index
				end
				Client.Vehicle.Menu["modPlateHolder"].List, Client.Vehicle.Menu["modPlateHolder"].Index = BuildModList(25, currentMods.modPlateHolder)
				Client.Vehicle.Menu["modVanityPlate"].List, Client.Vehicle.Menu["modVanityPlate"].Index = BuildModList(26, currentMods.modVanityPlate)
				Client.Vehicle.Menu["modTrimA"].List, Client.Vehicle.Menu["modTrimA"].Index = BuildModList(27, currentMods.modTrimA)
				Client.Vehicle.Menu["modOrnaments"].List, Client.Vehicle.Menu["modOrnaments"].Index = BuildModList(28, currentMods.modOrnaments)
				Client.Vehicle.Menu["modDashboard"].List, Client.Vehicle.Menu["modDashboard"].Index = BuildModList(29, currentMods.modDashboard)
				Client.Vehicle.Menu["modDial"].List, Client.Vehicle.Menu["modDial"].Index = BuildModList(30, currentMods.modDial)
				Client.Vehicle.Menu["modDoorSpeaker"].List, Client.Vehicle.Menu["modDoorSpeaker"].Index = BuildModList(31, currentMods.modDoorSpeaker)
				Client.Vehicle.Menu["modSeats"].List, Client.Vehicle.Menu["modSeats"].Index = BuildModList(32, currentMods.modSeats)
				Client.Vehicle.Menu["modSteeringWheel"].List, Client.Vehicle.Menu["modSteeringWheel"].Index = BuildModList(33, currentMods.modSteeringWheel)
				Client.Vehicle.Menu["modShifterLeavers"].List, Client.Vehicle.Menu["modShifterLeavers"].Index = BuildModList(34, currentMods.modShifterLeavers)
				Client.Vehicle.Menu["modAPlate"].List, Client.Vehicle.Menu["modAPlate"].Index = BuildModList(35, currentMods.modAPlate)
				Client.Vehicle.Menu["modSpeakers"].List, Client.Vehicle.Menu["modSpeakers"].Index = BuildModList(36, currentMods.modSpeakers)
				Client.Vehicle.Menu["modTrunk"].List, Client.Vehicle.Menu["modTrunk"].Index = BuildModList(37, currentMods.modTrunk)
				Client.Vehicle.Menu["modHydrolic"].List, Client.Vehicle.Menu["modHydrolic"].Index = BuildModList(38, currentMods.modHydrolic)
				Client.Vehicle.Menu["modEngineBlock"].List, Client.Vehicle.Menu["modEngineBlock"].Index = BuildModList(39, currentMods.modEngineBlock)
				Client.Vehicle.Menu["modAirFilter"].List, Client.Vehicle.Menu["modAirFilter"].Index = BuildModList(40, currentMods.modAirFilter)
				Client.Vehicle.Menu["modStruts"].List, Client.Vehicle.Menu["modStruts"].Index = BuildModList(41, currentMods.modStruts)
				Client.Vehicle.Menu["modArchCover"].List, Client.Vehicle.Menu["modArchCover"].Index = BuildModList(42, currentMods.modArchCover)
				Client.Vehicle.Menu["modAerials"].List, Client.Vehicle.Menu["modAerials"].Index = BuildModList(43, currentMods.modAerials)
				Client.Vehicle.Menu["modTrimB"].List, Client.Vehicle.Menu["modTrimB"].Index = BuildModList(44, currentMods.modTrimB)
				Client.Vehicle.Menu["modTank"].List, Client.Vehicle.Menu["modTank"].Index = BuildModList(45, currentMods.modTank)
				Client.Vehicle.Menu["modWindows"].List, Client.Vehicle.Menu["modWindows"].Index = BuildModList(46, currentMods.modWindows)
				Client.Vehicle.Menu["modLivery"].List, Client.Vehicle.Menu["modLivery"].Index = BuildModList(48, currentMods.modLivery)
				CreateThread(function()
					Wait(3000)
					Client.Vehicle.Tuning.MenuLocked = false
				end)
			end
		end, Client.Menu.Vehicle.Custom.Main)

		Items:AddButton(Client.Function.Translate.Get("menu-repair-vehicle"), nil, {IsDisabled = Client.IsVehicleSpawning or Client.Vehicle.Tuning.MenuLocked or lock}, function(onSelected)
			if onSelected then
				Client.Vehicle.Tuning.MenuLocked = true
				Client.Function.Vehicle.Fix(vehicle)
				CreateThread(function()
					Wait(3000)
					Client.Vehicle.Tuning.MenuLocked = false
				end)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-freeze-vehicle"), nil, {IsDisabled = Client.IsVehicleSpawning or lock}, function(onSelected)
			if onSelected then
				if not IsEntityPositionFrozen(vehicle) then
					FreezeEntityPosition(vehicle, true)
					SetEntityInvincible(vehicle, true)
					Client.Function.Message.Display(Client.Function.Translate.Get("freeze-vehicle-yes"))
				else
					FreezeEntityPosition(vehicle, false)
					SetEntityInvincible(vehicle, false)
					Client.Function.Message.Display(Client.Function.Translate.Get("freeze-vehicle-no"))
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-delete-vehicle"), nil, {IsDisabled = Client.IsVehicleSpawning or lock}, function(onSelected)
			if onSelected then
				Client.Function.Vehicle.DeleteCurrent()
				Client.Function.Message.Display(Client.Function.Translate.Get("delete-vehicle-1"))
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-delete-all-vehicles"), nil, {IsDisabled = Client.IsVehicleSpawning or #Client.Vehicle.SpawnedEntitys == 0}, function(onSelected)
			if onSelected then
				Client.Stunt.Vehicle = nil
				Client.Stunt.VehicleNetId = nil
				Client.Function.Vehicle.DeleteAll()
				Client.Function.Message.Display(Client.Function.Translate.Get("delete-vehicle-2"))
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-set-as-tp-vehicle"), nil, {IsDisabled = Client.IsVehicleSpawning or lock}, function(onSelected)
			if onSelected then
				Client.Stunt.Vehicle = vehicle
				Client.Stunt.VehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
				Client.Function.Message.Display(Client.Function.Translate.Get("set-as-tp-vehicle"))
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Vehicle.Custom.Main:IsVisible(function(Items)
		local lock = not DoesEntityExist(Client.Vehicle.Tuning.Entity)
		if lock then
			CreateThread(function()
				RageUI.CloseAll()
			end)
		end

		Items:AddButton(Client.Function.Translate.Get("menu-vehicle-custom-upgrades"), nil, {IsDisabled = lock, RightLabel = "→→→"}, function(onSelected)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onSelected then
				local currentMods = Client.Function.Tuning.GetProperties(Client.Vehicle.Tuning.Entity, false)
				SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
				local function BuildModList(modType, currentValue)
					local list, index = {{Name = Client.Function.Translate.Get("tuning-default"), Value = -1}}, 1
					local modCount = GetNumVehicleMods(Client.Vehicle.Tuning.Entity, modType) or 0
					for i = 0, modCount - 1, 1 do
						list[#list + 1] = {Name = string.format(Client.Function.Translate.Get("tuning-level"), i + 1), Value = #list - 1}
					end
					for i = 1, #list do
						if list[i].Value == currentValue then
							index = i
							break
						end
					end
					return list, index
				end
				Client.Vehicle.Menu["modEngine"].List, Client.Vehicle.Menu["modEngine"].Index = BuildModList(11, currentMods.modEngine)
				Client.Vehicle.Menu["modBrakes"].List, Client.Vehicle.Menu["modBrakes"].Index = BuildModList(12, currentMods.modBrakes)
				Client.Vehicle.Menu["modTransmission"].List, Client.Vehicle.Menu["modTransmission"].Index = BuildModList(13, currentMods.modTransmission)
				Client.Vehicle.Menu["modSuspension"].List, Client.Vehicle.Menu["modSuspension"].Index = BuildModList(15, currentMods.modSuspension)
				Client.Vehicle.Menu["modArmor"].List, Client.Vehicle.Menu["modArmor"].Index = BuildModList(16, currentMods.modArmor)
				Client.Vehicle.Menu["modTurbo"].IsChecked = currentMods.modTurbo and true or false
			end
		end, Client.Menu.Vehicle.Custom.Upgrade)

		Items:AddButton(Client.Function.Translate.Get("menu-vehicle-custom-bodyparts"), nil, {IsDisabled = lock, RightLabel = "→→→"}, function(onSelected)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onSelected then
				local currentMods = Client.Function.Tuning.GetProperties(Client.Vehicle.Tuning.Entity, false)
				SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
				local function BuildModList(modType, currentValue)
					local list, index = {{Name = Client.Function.Translate.Get("tuning-default"), Value = -1}}, 1
					local modCount = GetNumVehicleMods(Client.Vehicle.Tuning.Entity, modType) or 0
					for i = 0, modCount - 1, 1 do
						local modName = GetModTextLabel(Client.Vehicle.Tuning.Entity, modType, i)
						if modName then
							local labelName = GetLabelText(modName)
							list[#list + 1] = {Name = labelName ~= "NULL" and labelName or modName, Value = #list - 1}
						end
					end
					for i = 1, #list do
						if list[i].Value == currentValue then
							index = i
							break
						end
					end
					return list, index
				end
				Client.Vehicle.Menu["modSpoilers"].List, Client.Vehicle.Menu["modSpoilers"].Index = BuildModList(0, currentMods.modSpoilers)
				Client.Vehicle.Menu["modFrontBumper"].List, Client.Vehicle.Menu["modFrontBumper"].Index = BuildModList(1, currentMods.modFrontBumper)
				Client.Vehicle.Menu["modRearBumper"].List, Client.Vehicle.Menu["modRearBumper"].Index = BuildModList(2, currentMods.modRearBumper)
				Client.Vehicle.Menu["modSideSkirt"].List, Client.Vehicle.Menu["modSideSkirt"].Index = BuildModList(3, currentMods.modSideSkirt)
				Client.Vehicle.Menu["modExhaust"].List, Client.Vehicle.Menu["modExhaust"].Index = BuildModList(4, currentMods.modExhaust)
				Client.Vehicle.Menu["modFrame"].List, Client.Vehicle.Menu["modFrame"].Index = BuildModList(5, currentMods.modFrame)
				Client.Vehicle.Menu["modGrille"].List, Client.Vehicle.Menu["modGrille"].Index = BuildModList(6, currentMods.modGrille)
				Client.Vehicle.Menu["modHood"].List, Client.Vehicle.Menu["modHood"].Index = BuildModList(7, currentMods.modHood)
				Client.Vehicle.Menu["modFender"].List, Client.Vehicle.Menu["modFender"].Index = BuildModList(8, currentMods.modFender)
				Client.Vehicle.Menu["modRightFender"].List, Client.Vehicle.Menu["modRightFender"].Index = BuildModList(9, currentMods.modRightFender)
				Client.Vehicle.Menu["modRoof"].List, Client.Vehicle.Menu["modRoof"].Index = BuildModList(10, currentMods.modRoof)
			end
		end, Client.Menu.Vehicle.Custom.BodyPart)

		Items:AddButton(Client.Function.Translate.Get("menu-vehicle-custom-respray"), nil, {IsDisabled = lock, RightLabel = "→→→"}, function(onSelected)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onSelected then
				local currentMods = Client.Function.Tuning.GetProperties(Client.Vehicle.Tuning.Entity, false)
				local list = Client.Function.Tuning.GetColors()
				Client.Vehicle.Menu["color1"].List, Client.Vehicle.Menu["color1"].Index = list, 1
				Client.Vehicle.Menu["color2"].List, Client.Vehicle.Menu["color2"].Index = list, 1
				Client.Vehicle.Menu["pearlescentColor"].List, Client.Vehicle.Menu["pearlescentColor"].Index = list, 1
				for i = 1, #Client.Vehicle.Menu["color1"].List do
					if Client.Vehicle.Menu["color1"].List[i].Value == currentMods.color1 then
						Client.Vehicle.Menu["color1"].Index = i
						break
					end
				end
				for i = 1, #Client.Vehicle.Menu["color2"].List do
					if Client.Vehicle.Menu["color2"].List[i].Value == currentMods.color2 then
						Client.Vehicle.Menu["color2"].Index = i
						break
					end
				end
				for i = 1, #Client.Vehicle.Menu["pearlescentColor"].List do
					if Client.Vehicle.Menu["pearlescentColor"].List[i].Value == currentMods.pearlescentColor then
						Client.Vehicle.Menu["pearlescentColor"].Index = i
						break
					end
				end
			end
		end, Client.Menu.Vehicle.Custom.Respray)

		Items:AddButton(Client.Function.Translate.Get("menu-vehicle-custom-wheels"), nil, {IsDisabled = lock, RightLabel = "→→→"}, function(onSelected)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onSelected then
				local currentMods = Client.Function.Tuning.GetProperties(Client.Vehicle.Tuning.Entity, false)
				SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
				if GetVehicleClass(Client.Vehicle.Tuning.Entity) ~= 8 then
					Client.Vehicle.Menu["modFrontWheelsTypes"].List = {
						{Value = 0, Name = Client.Function.Translate.Get("vehicle-wheel-sport")},
						{Value = 1, Name = Client.Function.Translate.Get("vehicle-wheel-muscle")},
						{Value = 2, Name = Client.Function.Translate.Get("vehicle-wheel-lowrider")},
						{Value = 3, Name = Client.Function.Translate.Get("vehicle-wheel-suv")},
						{Value = 4, Name = Client.Function.Translate.Get("vehicle-wheel-allterrain")},
						{Value = 5, Name = Client.Function.Translate.Get("vehicle-wheel-tuning")},
						{Value = 7, Name = Client.Function.Translate.Get("vehicle-wheel-highend")},
						{Value = 10, Name = Client.Function.Translate.Get("vehicle-wheel-dragster")},
						{Value = 11, Name = Client.Function.Translate.Get("vehicle-wheel-street")},
						{Value = 8, Name = Client.Function.Translate.Get("vehicle-wheel-bennys")},
						{Value = 9, Name = Client.Function.Translate.Get("vehicle-wheel-bennysv2")},
						{Value = 12, Name = Client.Function.Translate.Get("vehicle-wheel-rally")}
					}
				else
					Client.Vehicle.Menu["modFrontWheelsTypes"].List = {
						{Value = 6, Name = Client.Function.Translate.Get("vehicle-wheel-motorcycle"), str = "motorcycle"},
						{Value = 6, Name = Client.Function.Translate.Get("vehicle-wheel-motorcycle2"), str = "motorcycle2"}
					}
				end
				Client.Vehicle.Menu["modFrontWheelsTypes"].Index = 1
				for i = 1, #Client.Vehicle.Menu["modFrontWheelsTypes"].List do
					if Client.Vehicle.Menu["modFrontWheelsTypes"].List[i].Value == currentMods.wheels then
						Client.Vehicle.Menu["modFrontWheelsTypes"].Index = i
						break
					end
				end
				Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked = currentMods.modCustomFrontWheels
				Client.Vehicle.Menu["modCustomBackWheels"].IsChecked = currentMods.modCustomBackWheels
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value})
				Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List, Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index = Client.Function.Tuning.GetWheels(currentMods, Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str)
				if Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle" then
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked})
				elseif Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle2" then
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modBackWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
				else
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modBackWheels = GetVehicleClass(Client.Vehicle.Tuning.Entity) == 8 and Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value or nil, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
				end
				Client.Vehicle.Menu["wheelColor"].List, Client.Vehicle.Menu["wheelColor"].Index = Client.Function.Tuning.GetColors(), 1
				for i = 1, #Client.Vehicle.Menu["wheelColor"].List do
					if Client.Vehicle.Menu["wheelColor"].List[i].Value == currentMods.wheelColor then
						Client.Vehicle.Menu["wheelColor"].Index = i
						break
					end
				end
				Client.Vehicle.Menu["tyreSmokeColor"].List, Client.Vehicle.Menu["tyreSmokeColor"].Index = Client.Function.Tuning.GetNeonColors(), 1
				for i = 1, #Client.Vehicle.Menu["tyreSmokeColor"].List do
					if currentMods.tyreSmokeColor and currentMods.tyreSmokeColor[1] == Client.Vehicle.Menu["tyreSmokeColor"].List[i].Value.R and currentMods.tyreSmokeColor[2] == Client.Vehicle.Menu["tyreSmokeColor"].List[i].Value.G and currentMods.tyreSmokeColor[3] == Client.Vehicle.Menu["tyreSmokeColor"].List[i].Value.B then
						Client.Vehicle.Menu["tyreSmokeColor"].Index = i
						break
					end
				end
			end
		end, Client.Menu.Vehicle.Custom.Wheel)

		Items:AddList(Client.Function.Translate.Get("vehicle-horns") .. " (" .. Client.Vehicle.Menu["modHorns"].Index .. "/" .. #Client.Vehicle.Menu["modHorns"].List .. ")", Client.Vehicle.Menu["modHorns"].List, Client.Vehicle.Menu["modHorns"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modHorns"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modHorns"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modHorns = Client.Vehicle.Menu["modHorns"].List[Client.Vehicle.Menu["modHorns"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-neon-color") .. " (" .. Client.Vehicle.Menu["neonColor"].Index .. "/" .. #Client.Vehicle.Menu["neonColor"].List .. ")", Client.Vehicle.Menu["neonColor"].List, Client.Vehicle.Menu["neonColor"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["neonColor"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["neonColor"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {neonEnabled = Client.Vehicle.Menu["neonColor"].List[Client.Vehicle.Menu["neonColor"].Index].Value.R == 0 and Client.Vehicle.Menu["neonColor"].List[Client.Vehicle.Menu["neonColor"].Index].Value.G == 0 and Client.Vehicle.Menu["neonColor"].List[Client.Vehicle.Menu["neonColor"].Index].Value.B == 0 and {false, false, false, false} or {true, true, true, true}, neonColor = {Client.Vehicle.Menu["neonColor"].List[Client.Vehicle.Menu["neonColor"].Index].Value.R, Client.Vehicle.Menu["neonColor"].List[Client.Vehicle.Menu["neonColor"].Index].Value.G, Client.Vehicle.Menu["neonColor"].List[Client.Vehicle.Menu["neonColor"].Index].Value.B}})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-xenon-color") .. " (" .. Client.Vehicle.Menu["xenonColor"].Index .. "/" .. #Client.Vehicle.Menu["xenonColor"].List .. ")", Client.Vehicle.Menu["xenonColor"].List, Client.Vehicle.Menu["xenonColor"].Index, Client.Function.Translate.Get("vehicle-xenon-color-desc"), {IsDisabled = lock or #Client.Vehicle.Menu["xenonColor"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["xenonColor"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modXenon = Client.Vehicle.Menu["xenonColor"].List[Client.Vehicle.Menu["xenonColor"].Index].Value and true or false, xenonColor = Client.Vehicle.Menu["xenonColor"].List[Client.Vehicle.Menu["xenonColor"].Index].Value})
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("vehicle-plate-text"), nil, {IsDisabled = lock or IsNuiFocused(), RightLabel = "(" .. (Client.Function.Math.TrimedValue(GetVehicleNumberPlateText(Client.Vehicle.Tuning.Entity)) or "") .. ")"}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Client.Function.Math.TrimedValue(GetVehicleNumberPlateText(Client.Vehicle.Tuning.Entity)) or ""
				})
				Client.NUI.Callback = "plate text"
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-plate-index") .. " (" .. Client.Vehicle.Menu["plateIndex"].Index .. "/" .. #Client.Vehicle.Menu["plateIndex"].List .. ")", Client.Vehicle.Menu["plateIndex"].List, Client.Vehicle.Menu["plateIndex"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["plateIndex"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["plateIndex"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {plateIndex = Client.Vehicle.Menu["plateIndex"].List[Client.Vehicle.Menu["plateIndex"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-window-tint") .. " (" .. Client.Vehicle.Menu["windowTint"].Index .. "/" .. #Client.Vehicle.Menu["windowTint"].List .. ")", Client.Vehicle.Menu["windowTint"].List, Client.Vehicle.Menu["windowTint"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["windowTint"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["windowTint"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {windowTint = Client.Vehicle.Menu["windowTint"].List[Client.Vehicle.Menu["windowTint"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-plate-holder") .. " (" .. Client.Vehicle.Menu["modPlateHolder"].Index .. "/" .. #Client.Vehicle.Menu["modPlateHolder"].List .. ")", Client.Vehicle.Menu["modPlateHolder"].List, Client.Vehicle.Menu["modPlateHolder"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modPlateHolder"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modPlateHolder"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modPlateHolder = Client.Vehicle.Menu["modPlateHolder"].List[Client.Vehicle.Menu["modPlateHolder"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-vanity-plate") .. " (" .. Client.Vehicle.Menu["modVanityPlate"].Index .. "/" .. #Client.Vehicle.Menu["modVanityPlate"].List .. ")", Client.Vehicle.Menu["modVanityPlate"].List, Client.Vehicle.Menu["modVanityPlate"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modVanityPlate"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modVanityPlate"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modVanityPlate = Client.Vehicle.Menu["modVanityPlate"].List[Client.Vehicle.Menu["modVanityPlate"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-trimA") .. " (" .. Client.Vehicle.Menu["modTrimA"].Index .. "/" .. #Client.Vehicle.Menu["modTrimA"].List .. ")", Client.Vehicle.Menu["modTrimA"].List, Client.Vehicle.Menu["modTrimA"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modTrimA"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modTrimA"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modTrimA = Client.Vehicle.Menu["modTrimA"].List[Client.Vehicle.Menu["modTrimA"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-ornaments") .. " (" .. Client.Vehicle.Menu["modOrnaments"].Index .. "/" .. #Client.Vehicle.Menu["modOrnaments"].List .. ")", Client.Vehicle.Menu["modOrnaments"].List, Client.Vehicle.Menu["modOrnaments"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modOrnaments"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modOrnaments"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modOrnaments = Client.Vehicle.Menu["modOrnaments"].List[Client.Vehicle.Menu["modOrnaments"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-dash-board") .. " (" .. Client.Vehicle.Menu["modDashboard"].Index .. "/" .. #Client.Vehicle.Menu["modDashboard"].List .. ")", Client.Vehicle.Menu["modDashboard"].List, Client.Vehicle.Menu["modDashboard"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modDashboard"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modDashboard"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modDashboard = Client.Vehicle.Menu["modDashboard"].List[Client.Vehicle.Menu["modDashboard"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-dial") .. " (" .. Client.Vehicle.Menu["modDial"].Index .. "/" .. #Client.Vehicle.Menu["modDial"].List .. ")", Client.Vehicle.Menu["modDial"].List, Client.Vehicle.Menu["modDial"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modDial"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modDial"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modDial = Client.Vehicle.Menu["modDial"].List[Client.Vehicle.Menu["modDial"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-door-speaker") .. " (" .. Client.Vehicle.Menu["modDoorSpeaker"].Index .. "/" .. #Client.Vehicle.Menu["modDoorSpeaker"].List .. ")", Client.Vehicle.Menu["modDoorSpeaker"].List, Client.Vehicle.Menu["modDoorSpeaker"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modDoorSpeaker"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modDoorSpeaker"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modDoorSpeaker = Client.Vehicle.Menu["modDoorSpeaker"].List[Client.Vehicle.Menu["modDoorSpeaker"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-seats") .. " (" .. Client.Vehicle.Menu["modSeats"].Index .. "/" .. #Client.Vehicle.Menu["modSeats"].List .. ")", Client.Vehicle.Menu["modSeats"].List, Client.Vehicle.Menu["modSeats"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modSeats"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modSeats"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modSeats = Client.Vehicle.Menu["modSeats"].List[Client.Vehicle.Menu["modSeats"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-steering-wheel") .. " (" .. Client.Vehicle.Menu["modSteeringWheel"].Index .. "/" .. #Client.Vehicle.Menu["modSteeringWheel"].List .. ")", Client.Vehicle.Menu["modSteeringWheel"].List, Client.Vehicle.Menu["modSteeringWheel"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modSteeringWheel"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modSteeringWheel"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modSteeringWheel = Client.Vehicle.Menu["modSteeringWheel"].List[Client.Vehicle.Menu["modSteeringWheel"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-shifter-leavers") .. " (" .. Client.Vehicle.Menu["modShifterLeavers"].Index .. "/" .. #Client.Vehicle.Menu["modShifterLeavers"].List .. ")", Client.Vehicle.Menu["modShifterLeavers"].List, Client.Vehicle.Menu["modShifterLeavers"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modShifterLeavers"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modShifterLeavers"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modShifterLeavers = Client.Vehicle.Menu["modShifterLeavers"].List[Client.Vehicle.Menu["modShifterLeavers"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-a-plate") .. " (" .. Client.Vehicle.Menu["modAPlate"].Index .. "/" .. #Client.Vehicle.Menu["modAPlate"].List .. ")", Client.Vehicle.Menu["modAPlate"].List, Client.Vehicle.Menu["modAPlate"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modAPlate"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modAPlate"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modAPlate = Client.Vehicle.Menu["modAPlate"].List[Client.Vehicle.Menu["modAPlate"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-speakers") .. " (" .. Client.Vehicle.Menu["modSpeakers"].Index .. "/" .. #Client.Vehicle.Menu["modSpeakers"].List .. ")", Client.Vehicle.Menu["modSpeakers"].List, Client.Vehicle.Menu["modSpeakers"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modSpeakers"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modSpeakers"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modSpeakers = Client.Vehicle.Menu["modSpeakers"].List[Client.Vehicle.Menu["modSpeakers"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-trunk") .. " (" .. Client.Vehicle.Menu["modTrunk"].Index .. "/" .. #Client.Vehicle.Menu["modTrunk"].List .. ")", Client.Vehicle.Menu["modTrunk"].List, Client.Vehicle.Menu["modTrunk"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modTrunk"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 4, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 5, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modTrunk"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modTrunk = Client.Vehicle.Menu["modTrunk"].List[Client.Vehicle.Menu["modTrunk"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-hydrolic") .. " (" .. Client.Vehicle.Menu["modHydrolic"].Index .. "/" .. #Client.Vehicle.Menu["modHydrolic"].List .. ")", Client.Vehicle.Menu["modHydrolic"].List, Client.Vehicle.Menu["modHydrolic"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modHydrolic"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 4, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 5, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modHydrolic"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modHydrolic = Client.Vehicle.Menu["modHydrolic"].List[Client.Vehicle.Menu["modHydrolic"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-engine-block") .. " (" .. Client.Vehicle.Menu["modEngineBlock"].Index .. "/" .. #Client.Vehicle.Menu["modEngineBlock"].List .. ")", Client.Vehicle.Menu["modEngineBlock"].List, Client.Vehicle.Menu["modEngineBlock"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modEngineBlock"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 4, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 5, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modEngineBlock"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modEngineBlock = Client.Vehicle.Menu["modEngineBlock"].List[Client.Vehicle.Menu["modEngineBlock"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-air-filter") .. " (" .. Client.Vehicle.Menu["modAirFilter"].Index .. "/" .. #Client.Vehicle.Menu["modAirFilter"].List .. ")", Client.Vehicle.Menu["modAirFilter"].List, Client.Vehicle.Menu["modAirFilter"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modAirFilter"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 4, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 5, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modAirFilter"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modAirFilter = Client.Vehicle.Menu["modAirFilter"].List[Client.Vehicle.Menu["modAirFilter"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-struts") .. " (" .. Client.Vehicle.Menu["modStruts"].Index .. "/" .. #Client.Vehicle.Menu["modStruts"].List .. ")", Client.Vehicle.Menu["modStruts"].List, Client.Vehicle.Menu["modStruts"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modStruts"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 4, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 5, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modStruts"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modStruts = Client.Vehicle.Menu["modStruts"].List[Client.Vehicle.Menu["modStruts"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-arch-cover") .. " (" .. Client.Vehicle.Menu["modArchCover"].Index .. "/" .. #Client.Vehicle.Menu["modArchCover"].List .. ")", Client.Vehicle.Menu["modArchCover"].List, Client.Vehicle.Menu["modArchCover"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modArchCover"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modArchCover"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modArchCover = Client.Vehicle.Menu["modArchCover"].List[Client.Vehicle.Menu["modArchCover"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-aerials") .. " (" .. Client.Vehicle.Menu["modAerials"].Index .. "/" .. #Client.Vehicle.Menu["modAerials"].List .. ")", Client.Vehicle.Menu["modAerials"].List, Client.Vehicle.Menu["modAerials"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modAerials"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modAerials"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modAerials = Client.Vehicle.Menu["modAerials"].List[Client.Vehicle.Menu["modAerials"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-trimB") .. " (" .. Client.Vehicle.Menu["modTrimB"].Index .. "/" .. #Client.Vehicle.Menu["modTrimB"].List .. ")", Client.Vehicle.Menu["modTrimB"].List, Client.Vehicle.Menu["modTrimB"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modTrimB"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modTrimB"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modTrimB = Client.Vehicle.Menu["modTrimB"].List[Client.Vehicle.Menu["modTrimB"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-tank") .. " (" .. Client.Vehicle.Menu["modTank"].Index .. "/" .. #Client.Vehicle.Menu["modTank"].List .. ")", Client.Vehicle.Menu["modTank"].List, Client.Vehicle.Menu["modTank"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modTank"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modTank"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modTank = Client.Vehicle.Menu["modTank"].List[Client.Vehicle.Menu["modTank"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-windows") .. " (" .. Client.Vehicle.Menu["modWindows"].Index .. "/" .. #Client.Vehicle.Menu["modWindows"].List .. ")", Client.Vehicle.Menu["modWindows"].List, Client.Vehicle.Menu["modWindows"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modWindows"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modWindows"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modWindows = Client.Vehicle.Menu["modWindows"].List[Client.Vehicle.Menu["modWindows"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-livery") .. " (" .. Client.Vehicle.Menu["modLivery"].Index .. "/" .. #Client.Vehicle.Menu["modLivery"].List .. ")", Client.Vehicle.Menu["modLivery"].List, Client.Vehicle.Menu["modLivery"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modLivery"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modLivery"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modLivery = Client.Vehicle.Menu["modLivery"].List[Client.Vehicle.Menu["modLivery"].Index].Value})
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Vehicle.Custom.Upgrade:IsVisible(function(Items)
		local lock = not DoesEntityExist(Client.Vehicle.Tuning.Entity)
		if lock then
			CreateThread(function()
				RageUI.CloseAll()
			end)
		end

		Items:AddList(Client.Function.Translate.Get("vehicle-engine") .. " (" .. Client.Vehicle.Menu["modEngine"].Index .. "/" .. #Client.Vehicle.Menu["modEngine"].List .. ")", Client.Vehicle.Menu["modEngine"].List, Client.Vehicle.Menu["modEngine"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modEngine"].List == 0}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["modEngine"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modEngine = Client.Vehicle.Menu["modEngine"].List[Client.Vehicle.Menu["modEngine"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-brakes") .. " (" .. Client.Vehicle.Menu["modBrakes"].Index .. "/" .. #Client.Vehicle.Menu["modBrakes"].List .. ")", Client.Vehicle.Menu["modBrakes"].List, Client.Vehicle.Menu["modBrakes"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modBrakes"].List == 0}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["modBrakes"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modBrakes = Client.Vehicle.Menu["modBrakes"].List[Client.Vehicle.Menu["modBrakes"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-transmission") .. " (" .. Client.Vehicle.Menu["modTransmission"].Index .. "/" .. #Client.Vehicle.Menu["modTransmission"].List .. ")", Client.Vehicle.Menu["modTransmission"].List, Client.Vehicle.Menu["modTransmission"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modTransmission"].List == 0}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["modTransmission"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modTransmission = Client.Vehicle.Menu["modTransmission"].List[Client.Vehicle.Menu["modTransmission"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-suspension") .. " (" .. Client.Vehicle.Menu["modSuspension"].Index .. "/" .. #Client.Vehicle.Menu["modSuspension"].List .. ")", Client.Vehicle.Menu["modSuspension"].List, Client.Vehicle.Menu["modSuspension"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modSuspension"].List == 0}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["modSuspension"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modSuspension = Client.Vehicle.Menu["modSuspension"].List[Client.Vehicle.Menu["modSuspension"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-armor") .. " (" .. Client.Vehicle.Menu["modArmor"].Index .. "/" .. #Client.Vehicle.Menu["modArmor"].List .. ")", Client.Vehicle.Menu["modArmor"].List, Client.Vehicle.Menu["modArmor"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modArmor"].List == 0}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["modArmor"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modArmor = Client.Vehicle.Menu["modArmor"].List[Client.Vehicle.Menu["modArmor"].Index].Value})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("vehicle-turbo"), nil, Client.Vehicle.Menu["modTurbo"].IsChecked, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not lock then
				Client.Vehicle.Menu["modTurbo"].IsChecked = IsChecked
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modTurbo = Client.Vehicle.Menu["modTurbo"].IsChecked})
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Vehicle.Custom.BodyPart:IsVisible(function(Items)
		local lock = not DoesEntityExist(Client.Vehicle.Tuning.Entity)
		if lock then
			CreateThread(function()
				RageUI.CloseAll()
			end)
		end

		Items:AddList(Client.Function.Translate.Get("vehicle-spoilers") .. " (" .. Client.Vehicle.Menu["modSpoilers"].Index .. "/" .. #Client.Vehicle.Menu["modSpoilers"].List .. ")", Client.Vehicle.Menu["modSpoilers"].List, Client.Vehicle.Menu["modSpoilers"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modSpoilers"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modSpoilers"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modSpoilers = Client.Vehicle.Menu["modSpoilers"].List[Client.Vehicle.Menu["modSpoilers"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-front-bumper") .. " (" .. Client.Vehicle.Menu["modFrontBumper"].Index .. "/" .. #Client.Vehicle.Menu["modFrontBumper"].List .. ")", Client.Vehicle.Menu["modFrontBumper"].List, Client.Vehicle.Menu["modFrontBumper"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modFrontBumper"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modFrontBumper"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modFrontBumper = Client.Vehicle.Menu["modFrontBumper"].List[Client.Vehicle.Menu["modFrontBumper"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-rear-bumper") .. " (" .. Client.Vehicle.Menu["modRearBumper"].Index .. "/" .. #Client.Vehicle.Menu["modRearBumper"].List .. ")", Client.Vehicle.Menu["modRearBumper"].List, Client.Vehicle.Menu["modRearBumper"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modRearBumper"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modRearBumper"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modRearBumper = Client.Vehicle.Menu["modRearBumper"].List[Client.Vehicle.Menu["modRearBumper"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-side-skirt") .. " (" .. Client.Vehicle.Menu["modSideSkirt"].Index .. "/" .. #Client.Vehicle.Menu["modSideSkirt"].List .. ")", Client.Vehicle.Menu["modSideSkirt"].List, Client.Vehicle.Menu["modSideSkirt"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modSideSkirt"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modSideSkirt"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modSideSkirt = Client.Vehicle.Menu["modSideSkirt"].List[Client.Vehicle.Menu["modSideSkirt"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-exhaust") .. " (" .. Client.Vehicle.Menu["modExhaust"].Index .. "/" .. #Client.Vehicle.Menu["modExhaust"].List .. ")", Client.Vehicle.Menu["modExhaust"].List, Client.Vehicle.Menu["modExhaust"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modExhaust"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modExhaust"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modExhaust = Client.Vehicle.Menu["modExhaust"].List[Client.Vehicle.Menu["modExhaust"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-frame") .. " (" .. Client.Vehicle.Menu["modFrame"].Index .. "/" .. #Client.Vehicle.Menu["modFrame"].List .. ")", Client.Vehicle.Menu["modFrame"].List, Client.Vehicle.Menu["modFrame"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modFrame"].List == 0}, function(Index, onSelected, onListChange)
			if not Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 0, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 1, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 2, false)
				SetVehicleDoorOpen(Client.Vehicle.Tuning.Entity, 3, false)
				Client.Vehicle.Tuning.DoorOpened = true
			end
			if onListChange then
				Client.Vehicle.Menu["modFrame"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modFrame = Client.Vehicle.Menu["modFrame"].List[Client.Vehicle.Menu["modFrame"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-grille") .. " (" .. Client.Vehicle.Menu["modGrille"].Index .. "/" .. #Client.Vehicle.Menu["modGrille"].List .. ")", Client.Vehicle.Menu["modGrille"].List, Client.Vehicle.Menu["modGrille"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modGrille"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modGrille"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modGrille = Client.Vehicle.Menu["modGrille"].List[Client.Vehicle.Menu["modGrille"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-hood") .. " (" .. Client.Vehicle.Menu["modHood"].Index .. "/" .. #Client.Vehicle.Menu["modHood"].List .. ")", Client.Vehicle.Menu["modHood"].List, Client.Vehicle.Menu["modHood"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modHood"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modHood"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modHood = Client.Vehicle.Menu["modHood"].List[Client.Vehicle.Menu["modHood"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-fender") .. " (" .. Client.Vehicle.Menu["modFender"].Index .. "/" .. #Client.Vehicle.Menu["modFender"].List .. ")", Client.Vehicle.Menu["modFender"].List, Client.Vehicle.Menu["modFender"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modFender"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modFender"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modFender = Client.Vehicle.Menu["modFender"].List[Client.Vehicle.Menu["modFender"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-right-fender") .. " (" .. Client.Vehicle.Menu["modRightFender"].Index .. "/" .. #Client.Vehicle.Menu["modRightFender"].List .. ")", Client.Vehicle.Menu["modRightFender"].List, Client.Vehicle.Menu["modRightFender"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modRightFender"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modRightFender"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modRightFender = Client.Vehicle.Menu["modRightFender"].List[Client.Vehicle.Menu["modRightFender"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-roof") .. " (" .. Client.Vehicle.Menu["modRoof"].Index .. "/" .. #Client.Vehicle.Menu["modRoof"].List .. ")", Client.Vehicle.Menu["modRoof"].List, Client.Vehicle.Menu["modRoof"].Index, nil, {IsDisabled = lock or #Client.Vehicle.Menu["modRoof"].List == 0}, function(Index, onSelected, onListChange)
			if Client.Vehicle.Tuning.DoorOpened then
				SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				Client.Vehicle.Tuning.DoorOpened = false
			end
			if onListChange then
				Client.Vehicle.Menu["modRoof"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modRoof = Client.Vehicle.Menu["modRoof"].List[Client.Vehicle.Menu["modRoof"].Index].Value})
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Vehicle.Custom.Respray:IsVisible(function(Items)
		local lock = not DoesEntityExist(Client.Vehicle.Tuning.Entity)
		if lock then
			CreateThread(function()
				RageUI.CloseAll()
			end)
		end

		Items:AddButton(Client.Function.Translate.Get("menu-primary-rgb"), nil, {IsDisabled = lock, Color = {BackgroundColor = {255, 50, 50, 50}, HightLightColor = {255, 50, 50, 150}}}, function(onSelected)
			if onSelected then
				if not Client.NUI.Picker.Primary then
					local red, green, blue = GetVehicleCustomPrimaryColour(Client.Vehicle.Tuning.Entity)
					local colorString = string.format("rgb(%d, %d, %d)", red, green, blue)
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "show color picker",
						color = colorString
					})
					Client.NUI.Picker.Enable = true
					Client.NUI.Picker.Primary = true
					Client.NUI.Picker.Secondary = false
				else
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "close color picker"
					})
					Client.NUI.Picker.Enable = false
					Client.NUI.Picker.Primary = false
					Client.NUI.Picker.Secondary = false
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-secondary-rgb"), nil, {IsDisabled = lock, Color = {BackgroundColor = {50, 255, 50, 50}, HightLightColor = {50, 255, 50, 150}}}, function(onSelected)
			if onSelected then
				if not Client.NUI.Picker.Secondary then
					local red, green, blue = GetVehicleCustomSecondaryColour(Client.Vehicle.Tuning.Entity)
					local colorString = string.format("rgb(%d, %d, %d)", red, green, blue)
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "show color picker",
						color = colorString
					})
					Client.NUI.Picker.Enable = true
					Client.NUI.Picker.Primary = false
					Client.NUI.Picker.Secondary = true
				else
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "close color picker"
					})
					Client.NUI.Picker.Enable = false
					Client.NUI.Picker.Primary = false
					Client.NUI.Picker.Secondary = false
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-primary-respray") .. " (" .. Client.Vehicle.Menu["color1"].Index .. "/" .. #Client.Vehicle.Menu["color1"].List .. ")", Client.Vehicle.Menu["color1"].List, Client.Vehicle.Menu["color1"].Index, nil, {IsDisabled = lock}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["color1"].Index = Index
				ClearVehicleCustomPrimaryColour(Client.Vehicle.Tuning.Entity)
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {color1 = Client.Vehicle.Menu["color1"].List[Client.Vehicle.Menu["color1"].Index].Value})
				if Client.NUI.Picker.Enable then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "close color picker"
					})
					Client.NUI.Picker.Enable = false
					Client.NUI.Picker.Primary = false
					Client.NUI.Picker.Secondary = false
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-secondary-respray") .. " (" .. Client.Vehicle.Menu["color2"].Index .. "/" .. #Client.Vehicle.Menu["color2"].List .. ")", Client.Vehicle.Menu["color2"].List, Client.Vehicle.Menu["color2"].Index, nil, {IsDisabled = lock}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["color2"].Index = Index
				ClearVehicleCustomSecondaryColour(Client.Vehicle.Tuning.Entity)
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {color2 = Client.Vehicle.Menu["color2"].List[Client.Vehicle.Menu["color2"].Index].Value})
				if Client.NUI.Picker.Enable then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "close color picker"
					})
					Client.NUI.Picker.Enable = false
					Client.NUI.Picker.Primary = false
					Client.NUI.Picker.Secondary = false
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-pearlescent-color") .. " (" .. Client.Vehicle.Menu["pearlescentColor"].Index .. "/" .. #Client.Vehicle.Menu["pearlescentColor"].List .. ")", Client.Vehicle.Menu["pearlescentColor"].List, Client.Vehicle.Menu["pearlescentColor"].Index, nil, {IsDisabled = lock}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["pearlescentColor"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {pearlescentColor = Client.Vehicle.Menu["pearlescentColor"].List[Client.Vehicle.Menu["pearlescentColor"].Index].Value})
				if Client.NUI.Picker.Enable then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "close color picker"
					})
					Client.NUI.Picker.Enable = false
					Client.NUI.Picker.Primary = false
					Client.NUI.Picker.Secondary = false
				end
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Vehicle.Custom.Wheel:IsVisible(function(Items)
		local lock = not DoesEntityExist(Client.Vehicle.Tuning.Entity)
		if lock then
			CreateThread(function()
				RageUI.CloseAll()
			end)
		end

		Items:AddList(Client.Function.Translate.Get("vehicle-wheel-type") .. " (" .. Client.Vehicle.Menu["modFrontWheelsTypes"].Index .. "/" .. #Client.Vehicle.Menu["modFrontWheelsTypes"].List .. ")", Client.Vehicle.Menu["modFrontWheelsTypes"].List, Client.Vehicle.Menu["modFrontWheelsTypes"].Index, nil, {IsDisabled = lock}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["modFrontWheelsTypes"].Index = Index
				local currentMods = Client.Function.Tuning.GetProperties(Client.Vehicle.Tuning.Entity, false)
				SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value})
				Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List, Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index = Client.Function.Tuning.GetWheels(currentMods, Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str)
				if Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle" then
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked})
				elseif Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle2" then
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modBackWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
				else
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modBackWheels = GetVehicleClass(Client.Vehicle.Tuning.Entity) == 8 and Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value or nil, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
				end
			end
		end)

		if #Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List > 0 then
			Items:AddList(Client.Function.Translate.Get("menu-vehicle-custom-wheels") .. " (" .. Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index .. "/" .. #Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List .. ")", Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List, Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index, nil, {IsDisabled = lock}, function(Index, onSelected, onListChange)
				if onListChange then
					Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index = Index
					if Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle" then
						Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked})
					elseif Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle2" then
						Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modBackWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
					else
						Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modBackWheels = GetVehicleClass(Client.Vehicle.Tuning.Entity) == 8 and Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value or nil, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
					end
				end
			end)
		end

		if Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle" then
			Items:CheckBox(Client.Function.Translate.Get("vehicle-wheel-custom"), nil, Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked, {Style = 1}, function(onSelected, IsChecked)
				if onSelected and not lock then
					Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked = IsChecked
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked})
				end
			end)
		elseif Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].str == "motorcycle2" then
			Items:CheckBox(Client.Function.Translate.Get("vehicle-wheel-custom"), nil, Client.Vehicle.Menu["modCustomBackWheels"].IsChecked, {Style = 1}, function(onSelected, IsChecked)
				if onSelected and not lock then
					Client.Vehicle.Menu["modCustomBackWheels"].IsChecked = IsChecked
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modBackWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
				end
			end)
		else
			Items:CheckBox(Client.Function.Translate.Get("vehicle-wheel-custom"), nil, Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked, {Style = 1}, function(onSelected, IsChecked)
				if onSelected and not lock then
					Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked = IsChecked
					Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheels = Client.Vehicle.Menu["modFrontWheelsTypes"].List[Client.Vehicle.Menu["modFrontWheelsTypes"].Index].Value, modFrontWheels = Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value, modBackWheels = GetVehicleClass(Client.Vehicle.Tuning.Entity) == 8 and Client.Vehicle.Menu["modFrontWheelsTypes_Next"].List[Client.Vehicle.Menu["modFrontWheelsTypes_Next"].Index].Value or nil, modCustomFrontWheels = Client.Vehicle.Menu["modCustomFrontWheels"].IsChecked, modCustomBackWheels = Client.Vehicle.Menu["modCustomBackWheels"].IsChecked})
				end
			end)
		end

		Items:AddList(Client.Function.Translate.Get("vehicle-wheel-color") .. " (" .. Client.Vehicle.Menu["wheelColor"].Index .. "/" .. #Client.Vehicle.Menu["wheelColor"].List .. ")", Client.Vehicle.Menu["wheelColor"].List, Client.Vehicle.Menu["wheelColor"].Index, nil, {IsDisabled = lock}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["wheelColor"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {wheelColor = Client.Vehicle.Menu["wheelColor"].List[Client.Vehicle.Menu["wheelColor"].Index].Value})
			end
		end)

		Items:AddList(Client.Function.Translate.Get("vehicle-tyre-smoke-color") .. " (" .. Client.Vehicle.Menu["tyreSmokeColor"].Index .. "/" .. #Client.Vehicle.Menu["tyreSmokeColor"].List .. ")", Client.Vehicle.Menu["tyreSmokeColor"].List, Client.Vehicle.Menu["tyreSmokeColor"].Index, nil, {IsDisabled = lock}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Vehicle.Menu["tyreSmokeColor"].Index = Index
				Client.Function.Tuning.SetProperties(Client.Vehicle.Tuning.Entity, {modSmokeEnabled = true, tyreSmokeColor = {Client.Vehicle.Menu["tyreSmokeColor"].List[Client.Vehicle.Menu["tyreSmokeColor"].Index].Value.R, Client.Vehicle.Menu["tyreSmokeColor"].List[Client.Vehicle.Menu["tyreSmokeColor"].Index].Value.G, Client.Vehicle.Menu["tyreSmokeColor"].List[Client.Vehicle.Menu["tyreSmokeColor"].Index].Value.B}})
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Ped.Main:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin"), nil, {IsDisabled = (GetEntityModel(PlayerPedId()) ~= `mp_m_freemode_01` and GetEntityModel(PlayerPedId()) ~= `mp_f_freemode_01`) or Client.IsPedSpawning or Client.Skin.Camera.Handle ~= nil, RightLabel = "→→→"}, function(onSelected)
			if onSelected then
				Client.Function.Vehicle.DeleteCurrent()
				ClearPedTasksImmediately(PlayerPedId())
				SetEntityVisible(PlayerPedId(), true)
				Client.Function.Skin.GetDataForMenu()
				Client.Function.Skin.Editing()
			end
		end, Client.Menu.Ped.Skin.Main)

		Items:AddButton(Client.Function.Translate.Get("menu-reset-skin"), nil, {IsDisabled = Client.IsPedSpawning or Client.Skin.Camera.Handle ~= nil}, function(onSelected)
			if onSelected then
				Client.Function.Vehicle.DeleteCurrent()
				SetEntityVisible(PlayerPedId(), true)
				Client.Function.Skin.Set(Client.Skin.Saved.Data[Client.Skin.Saved.Index])
				TriggerServerEvent("server:core:saveSkin", nil, nil, 0)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-animal"), nil, {IsDisabled = not Client.Permission.SpawnPedAsPlayerModel or Client.IsPedSpawning or Client.Skin.Camera.Handle ~= nil, RightLabel = "→→→"}, function(onSelected)
			Client.Skin.Model.Animal.FilterCount = 0
			for k, v in pairs(Client.Skin.Model.Animal.Data) do
				if string.find(string.lower(v.label), Client.Skin.Model.Animal.FilterStr) then
					v.filtered = true
					Client.Skin.Model.Animal.FilterCount = Client.Skin.Model.Animal.FilterCount + 1
				else
					v.filtered = false
				end
			end
		end, Client.Menu.Ped.Animal)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-add-on"), nil, {IsDisabled = not Client.Permission.SpawnPedAsPlayerModel or Client.IsPedSpawning or Client.Skin.Camera.Handle ~= nil or #Client.Skin.Model.AddOn.Data == 0, RightLabel = "→→→"}, function(onSelected)
			Client.Skin.Model.AddOn.FilterCount = 0
			for k, v in pairs(Client.Skin.Model.AddOn.Data) do
				if string.find(string.lower(v.label), Client.Skin.Model.AddOn.FilterStr) then
					v.filtered = true
					Client.Skin.Model.AddOn.FilterCount = Client.Skin.Model.AddOn.FilterCount + 1
				else
					v.filtered = false
				end
			end
		end, Client.Menu.Ped.AddOn)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-clear"), nil, {IsDisabled = Client.IsPedSpawning or Client.Skin.Camera.Handle ~= nil}, function(onSelected)
			if onSelected then
				local ped = PlayerPedId()
				ClearPedBloodDamage(ped)
				ClearPedWetness(ped)
				SetEntityVisible(ped, true)
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-ped-visible"), nil, Client.Ped.Status.Visible, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				SetEntityVisible(PlayerPedId(), IsChecked)
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-ped-fast-swim"), nil, Client.Ped.Config.FastSwim, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Ped.Config.FastSwim = IsChecked
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-ped-fast-run"), nil, Client.Ped.Config.FastRun, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				if not Client.Ped.Config.BeastMode then
					Client.Ped.Config.FastRun = IsChecked
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-ped-super-jump"), nil, Client.Ped.Config.SuperJump, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				if not Client.Ped.Config.BeastMode then
					Client.Ped.Config.SuperJump = IsChecked
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-ped-beast-mode"), nil, Client.Ped.Config.BeastMode, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Ped.Config.FastRun = IsChecked
				Client.Ped.Config.SuperJump = IsChecked
				Client.Ped.Config.BeastMode = IsChecked
				Client.Ped.Status.WasDoingBeastJump = false
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Ped.Skin.Main:IsVisible(function(Items)
		Client.IsSkinMenuVisible = true
		Items:AddList(Client.Function.Translate.Get("skin-slots") .. " (" .. Client.Skin.Saved.Index .. "/" .. #Client.Skin.Slots .. ")", Client.Skin.Slots, Client.Skin.Saved.Index, nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onListChange or onSelected then
				Client.Skin.Saved.Index = Index
				Client.Function.Skin.Set(Client.Skin.Saved.Data[Client.Skin.Saved.Index], true)
				TriggerServerEvent("server:core:saveSkin", Client.Skin.Saved.Index, nil, nil)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("skin-save"), nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Skin.Saved.Data[Client.Skin.Saved.Index] = Client.Function.Skin.GetCurrent()
				TriggerServerEvent("server:core:saveSkin", Client.Skin.Saved.Index, Client.Skin.Saved.Data[Client.Skin.Saved.Index], nil)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("skin-import"), nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = json.encode(Client.Function.Skin.GetCurrent())
				})
				Client.NUI.Callback = "skin import"
			end
		end)

		Items:AddList(Client.Function.Translate.Get("skin-sex") .. " (" .. (Client.Skin.Menu["sex"].Index + 1) .. "/" .. #Client.Skin.Menu["sex"].List .. ")", Client.Skin.Menu["sex"].List, Client.Skin.Menu["sex"].Index + 1, nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onListChange then
				Client.Skin.Menu["sex"].Index = Index - 1
				Client.Function.Skin.Set({["sex"] = Client.Skin.Menu["sex"].Index}, true)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-face"), nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
		end, Client.Menu.Ped.Skin.Face)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-component"), nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
		end, Client.Menu.Ped.Skin.Component)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-prop"), nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
		end, Client.Menu.Ped.Skin.Prop)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-overlay"), nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
		end, Client.Menu.Ped.Skin.Overlay)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-tattoo"), nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning, RightLabel = "→→→"}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
		end, Client.Menu.Ped.Skin.Tattoo.Main)
	end, function(Panels)
	end)

	Client.Menu.Ped.Skin.Face:IsVisible(function(Items)
		Client.IsSkinMenuVisible = true
		Items:AddList(Client.Function.Translate.Get("skin-face") .. " (" .. (Client.Skin.Menu["face"].Index + 1) .. "/" .. #Client.Skin.Menu["face"].List .. ")", Client.Skin.Menu["face"].List, Client.Skin.Menu["face"].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 0.6
			Client.Skin.Camera.CamOffset = 0.65
			if onListChange then
				local ped = PlayerPedId()
				Client.Skin.Menu["face"].Index = Index - 1
				Client.Function.Skin.SetHeadBlend(ped, Client.Skin.Menu["face"].Index, Client.Skin.Menu["face2"].Index, (Client.Skin.Menu["faceMix"].Index) / 10.0, Client.Skin.Menu["skin"].Index, Client.Skin.Menu["skin2"].Index, (Client.Skin.Menu["skinMix"].Index) / 10.0)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("skin-face2") .. " (" .. (Client.Skin.Menu["face2"].Index + 1) .. "/" .. #Client.Skin.Menu["face2"].List .. ")", Client.Skin.Menu["face2"].List, Client.Skin.Menu["face2"].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 0.6
			Client.Skin.Camera.CamOffset = 0.65
			if onListChange then
				local ped = PlayerPedId()
				Client.Skin.Menu["face2"].Index = Index - 1
				Client.Function.Skin.SetHeadBlend(ped, Client.Skin.Menu["face"].Index, Client.Skin.Menu["face2"].Index, (Client.Skin.Menu["faceMix"].Index) / 10.0, Client.Skin.Menu["skin"].Index, Client.Skin.Menu["skin2"].Index, (Client.Skin.Menu["skinMix"].Index) / 10.0)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("skin-faceMix"), Client.Skin.Menu["faceMix"].List, Client.Skin.Menu["faceMix"].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 0.6
			Client.Skin.Camera.CamOffset = 0.65
			if onListChange then
				local ped = PlayerPedId()
				Client.Skin.Menu["faceMix"].Index = Index - 1
				Client.Function.Skin.SetHeadBlend(ped, Client.Skin.Menu["face"].Index, Client.Skin.Menu["face2"].Index, (Client.Skin.Menu["faceMix"].Index) / 10.0, Client.Skin.Menu["skin"].Index, Client.Skin.Menu["skin2"].Index, (Client.Skin.Menu["skinMix"].Index) / 10.0)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("skin-skin") .. " (" .. (Client.Skin.Menu["skin"].Index + 1) .. "/" .. #Client.Skin.Menu["skin"].List .. ")", Client.Skin.Menu["skin"].List, Client.Skin.Menu["skin"].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 0.6
			Client.Skin.Camera.CamOffset = 0.65
			if onListChange then
				local ped = PlayerPedId()
				Client.Skin.Menu["skin"].Index = Index - 1
				Client.Function.Skin.SetHeadBlend(ped, Client.Skin.Menu["face"].Index, Client.Skin.Menu["face2"].Index, (Client.Skin.Menu["faceMix"].Index) / 10.0, Client.Skin.Menu["skin"].Index, Client.Skin.Menu["skin2"].Index, (Client.Skin.Menu["skinMix"].Index) / 10.0)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("skin-skin2") .. " (" .. (Client.Skin.Menu["skin2"].Index + 1) .. "/" .. #Client.Skin.Menu["skin2"].List .. ")", Client.Skin.Menu["skin2"].List, Client.Skin.Menu["skin2"].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 0.6
			Client.Skin.Camera.CamOffset = 0.65
			if onListChange then
				local ped = PlayerPedId()
				Client.Skin.Menu["skin2"].Index = Index - 1
				Client.Function.Skin.SetHeadBlend(ped, Client.Skin.Menu["face"].Index, Client.Skin.Menu["face2"].Index, (Client.Skin.Menu["faceMix"].Index) / 10.0, Client.Skin.Menu["skin"].Index, Client.Skin.Menu["skin2"].Index, (Client.Skin.Menu["skinMix"].Index) / 10.0)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("skin-skinMix"), Client.Skin.Menu["skinMix"].List, Client.Skin.Menu["skinMix"].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			Client.Skin.Camera.ZoomOffset = 0.6
			Client.Skin.Camera.CamOffset = 0.65
			if onListChange then
				local ped = PlayerPedId()
				Client.Skin.Menu["skinMix"].Index = Index - 1
				Client.Function.Skin.SetHeadBlend(ped, Client.Skin.Menu["face"].Index, Client.Skin.Menu["face2"].Index, (Client.Skin.Menu["faceMix"].Index) / 10.0, Client.Skin.Menu["skin"].Index, Client.Skin.Menu["skin2"].Index, (Client.Skin.Menu["skinMix"].Index) / 10.0)
			end
		end)

		for i = 0, 19 do
			Items:AddList(Client.Function.Translate.Get("skin-faceFeature_" .. i), Client.Skin.Menu["faceFeature_" .. i].List, Client.Skin.Menu["faceFeature_" .. i].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
				Client.Skin.Camera.ZoomOffset = 0.6
				Client.Skin.Camera.CamOffset = 0.65
				if onListChange then
					local ped = PlayerPedId()
					Client.Skin.Menu["faceFeature_" .. i].Index = Index - 1
					Client.Function.Skin.SetFaceFeature(ped, i, (Client.Skin.Menu["faceFeature_" .. i].Index - (i >= 18 and 0 or 10)) / 10.0)
				end
			end)
		end

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-random"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomFace(true), true)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-reset"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomFace(false), true)
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Ped.Skin.Component:IsVisible(function(Items)
		Client.IsSkinMenuVisible = true
		for i = 1, #Client.Skin.Components do
			local component = Client.Skin.Components[i]
			if component.Id then
				Items:AddList(Client.Function.Translate.Get("skin-" .. component.Item1) .. " (" .. (Client.Skin.Menu[component.Item1].Index + 1) .. "/" .. #Client.Skin.Menu[component.Item1].List .. ")", Client.Skin.Menu[component.Item1].List, Client.Skin.Menu[component.Item1].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
					Client.Skin.Camera.ZoomOffset = component.ZoomOffset
					Client.Skin.Camera.CamOffset = component.CamOffset
					if onListChange then
						local ped = PlayerPedId()
						Client.Skin.Menu[component.Item1].Index = Index - 1
						Client.Skin.Menu[component.Item2].Index = 0
						Client.Function.Skin.SetComponent(ped, component.Id, Client.Skin.Menu[component.Item1].Index, Client.Skin.Menu[component.Item2].Index, 2)
						Client.Skin.Menu[component.Item2] = {List = {}, Index = 0}
						for j = 0, GetNumberOfPedTextureVariations(ped, component.Id, Client.Skin.Menu[component.Item1].Index) - 1 do
							Client.Skin.Menu[component.Item2].List[#Client.Skin.Menu[component.Item2].List + 1] = j + 1
						end
						local value = GetPedTextureVariation(ped, component.Id)
						Client.Skin.Menu[component.Item2].Index = value and value >= 0 and value < #Client.Skin.Menu[component.Item2].List and value or 0
					end
				end)

				Items:AddList(Client.Function.Translate.Get("skin-" .. component.Item2) .. " (" .. (Client.Skin.Menu[component.Item2].Index + 1) .. "/" .. #Client.Skin.Menu[component.Item2].List .. ")", Client.Skin.Menu[component.Item2].List, Client.Skin.Menu[component.Item2].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
					Client.Skin.Camera.ZoomOffset = component.ZoomOffset
					Client.Skin.Camera.CamOffset = component.CamOffset
					if onListChange then
						local ped = PlayerPedId()
						Client.Skin.Menu[component.Item2].Index = Index - 1
						Client.Function.Skin.SetComponent(ped, component.Id, Client.Skin.Menu[component.Item1].Index, Client.Skin.Menu[component.Item2].Index, 2)
					end
				end)
			else
				Items:AddList(Client.Function.Translate.Get("skin-" .. component.Item1) .. " (" .. (Client.Skin.Menu[component.Item1].Index + 1) .. "/" .. #Client.Skin.Menu[component.Item1].List .. ")", Client.Skin.Menu[component.Item1].List, Client.Skin.Menu[component.Item1].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
					Client.Skin.Camera.ZoomOffset = component.ZoomOffset
					Client.Skin.Camera.CamOffset = component.CamOffset
					if onListChange then
						local ped = PlayerPedId()
						Client.Skin.Menu[component.Item1].Index = Index - 1
						Client.Function.Skin.SetHairColor(ped, Client.Skin.Menu[component.Item1].Index, Client.Skin.Menu[component.Item2].Index)
					end
				end)

				Items:AddList(Client.Function.Translate.Get("skin-" .. component.Item2) .. " (" .. (Client.Skin.Menu[component.Item2].Index + 1) .. "/" .. #Client.Skin.Menu[component.Item2].List .. ")", Client.Skin.Menu[component.Item2].List, Client.Skin.Menu[component.Item2].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
					Client.Skin.Camera.ZoomOffset = component.ZoomOffset
					Client.Skin.Camera.CamOffset = component.CamOffset
					if onListChange then
						local ped = PlayerPedId()
						Client.Skin.Menu[component.Item2].Index = Index - 1
						Client.Function.Skin.SetHairColor(ped, Client.Skin.Menu[component.Item1].Index, Client.Skin.Menu[component.Item2].Index)
					end
				end)
			end
		end

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-random"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomComponent(true), true)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-reset"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomComponent(false), true)
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Ped.Skin.Prop:IsVisible(function(Items)
		Client.IsSkinMenuVisible = true
		for i = 1, #Client.Skin.Props do
			local prop = Client.Skin.Props[i]
			Items:AddList(Client.Function.Translate.Get("skin-" .. prop.Item1) .. " (" .. (Client.Skin.Menu[prop.Item1].Index + 2) .. "/" .. #Client.Skin.Menu[prop.Item1].List .. ")", Client.Skin.Menu[prop.Item1].List, Client.Skin.Menu[prop.Item1].Index + 2, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
				Client.Skin.Camera.ZoomOffset = prop.ZoomOffset
				Client.Skin.Camera.CamOffset = prop.CamOffset
				if onListChange then
					local ped = PlayerPedId()
					Client.Skin.Menu[prop.Item1].Index = Index - 2
					Client.Skin.Menu[prop.Item2].Index = 0
					Client.Function.Skin.SetProp(ped, prop.Id, Client.Skin.Menu[prop.Item1].Index, Client.Skin.Menu[prop.Item2].Index)
					Client.Skin.Menu[prop.Item2] = {List = {}, Index = 0}
					for j = 0, GetNumberOfPedPropTextureVariations(ped, prop.Id, Client.Skin.Menu[prop.Item1].Index) - 1 do
						Client.Skin.Menu[prop.Item2].List[#Client.Skin.Menu[prop.Item2].List + 1] = j + 1
					end
					local value = GetPedPropTextureIndex(ped, prop.Id)
					Client.Skin.Menu[prop.Item2].Index = value and value >= 0 and value < #Client.Skin.Menu[prop.Item2].List and value or 0
				end
			end)

			Items:AddList(Client.Function.Translate.Get("skin-" .. prop.Item2) .. " (" .. (#Client.Skin.Menu[prop.Item2].List == 0 and 0 or (Client.Skin.Menu[prop.Item2].Index + 1)) .. "/" .. #Client.Skin.Menu[prop.Item2].List .. ")", #Client.Skin.Menu[prop.Item2].List == 0 and {0} or Client.Skin.Menu[prop.Item2].List, Client.Skin.Menu[prop.Item2].Index + 1, nil, {IsDisabled = #Client.Skin.Menu[prop.Item2].List == 0}, function(Index, onSelected, onListChange)
				Client.Skin.Camera.ZoomOffset = prop.ZoomOffset
				Client.Skin.Camera.CamOffset = prop.CamOffset
				if onListChange then
					local ped = PlayerPedId()
					Client.Skin.Menu[prop.Item2].Index = Index - 1
					Client.Function.Skin.SetProp(ped, prop.Id, Client.Skin.Menu[prop.Item1].Index, Client.Skin.Menu[prop.Item2].Index)
				end
			end)
		end

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-random"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomProp(true), true)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-reset"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomProp(false), true)
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Ped.Skin.Overlay:IsVisible(function(Items)
		Client.IsSkinMenuVisible = true
		for i = 1, #Client.Skin.Overlays do
			local overlay = Client.Skin.Overlays[i]
			if overlay.Id then
				Items:AddList(Client.Function.Translate.Get("skin-" .. overlay.Item1) .. " (" .. (Client.Skin.Menu[overlay.Item1].Index + 1) .. "/" .. #Client.Skin.Menu[overlay.Item1].List .. ")", Client.Skin.Menu[overlay.Item1].List, Client.Skin.Menu[overlay.Item1].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
					Client.Skin.Camera.ZoomOffset = overlay.ZoomOffset
					Client.Skin.Camera.CamOffset = overlay.CamOffset
					if onListChange then
						local ped = PlayerPedId()
						Client.Skin.Menu[overlay.Item1].Index = Index - 1
						Client.Function.Skin.SetHeadOverlay(ped, overlay.Id, Client.Skin.Menu[overlay.Item1].Index, Client.Skin.Menu[overlay.Item2].Index / 10.0)
					end
				end)

				Items:AddList(Client.Function.Translate.Get("skin-" .. overlay.Item2), Client.Skin.Menu[overlay.Item2].List, Client.Skin.Menu[overlay.Item2].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
					Client.Skin.Camera.ZoomOffset = overlay.ZoomOffset
					Client.Skin.Camera.CamOffset = overlay.CamOffset
					if onListChange then
						local ped = PlayerPedId()
						Client.Skin.Menu[overlay.Item2].Index = Index - 1
						Client.Function.Skin.SetHeadOverlay(ped, overlay.Id, Client.Skin.Menu[overlay.Item1].Index, Client.Skin.Menu[overlay.Item2].Index / 10.0)
					end
				end)

				if overlay.Color1 then
					Items:AddList(Client.Function.Translate.Get("skin-" .. overlay.Color1) .. " (" .. (Client.Skin.Menu[overlay.Color1].Index + 1) .. "/" .. #Client.Skin.Menu[overlay.Color1].List .. ")", Client.Skin.Menu[overlay.Color1].List, Client.Skin.Menu[overlay.Color1].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
						Client.Skin.Camera.ZoomOffset = overlay.ZoomOffset
						Client.Skin.Camera.CamOffset = overlay.CamOffset
						if onListChange then
							local ped = PlayerPedId()
							Client.Skin.Menu[overlay.Color1].Index = Index - 1
							Client.Function.Skin.SetHeadOverlayColor(ped, overlay.Id, 1, Client.Skin.Menu[overlay.Color1].Index, overlay.Color2 and Client.Skin.Menu[overlay.Color2].Index or 0)
						end
					end)
				end

				if overlay.Color2 then
					Items:AddList(Client.Function.Translate.Get("skin-" .. overlay.Color2) .. " (" .. (Client.Skin.Menu[overlay.Color2].Index + 1) .. "/" .. #Client.Skin.Menu[overlay.Color2].List .. ")", Client.Skin.Menu[overlay.Color2].List, Client.Skin.Menu[overlay.Color2].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
						Client.Skin.Camera.ZoomOffset = overlay.ZoomOffset
						Client.Skin.Camera.CamOffset = overlay.CamOffset
						if onListChange then
							local ped = PlayerPedId()
							Client.Skin.Menu[overlay.Color2].Index = Index - 1
							Client.Function.Skin.SetHeadOverlayColor(ped, overlay.Id, 1, Client.Skin.Menu[overlay.Color1].Index, Client.Skin.Menu[overlay.Color2].Index)
						end
					end)
				end
			else
				Items:AddList(Client.Function.Translate.Get("skin-" .. overlay.Item1) .. " (" .. (Client.Skin.Menu[overlay.Item1].Index + 1) .. "/" .. #Client.Skin.Menu[overlay.Item1].List .. ")", Client.Skin.Menu[overlay.Item1].List, Client.Skin.Menu[overlay.Item1].Index + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
					Client.Skin.Camera.ZoomOffset = overlay.ZoomOffset
					Client.Skin.Camera.CamOffset = overlay.CamOffset
					if onListChange then
						local ped = PlayerPedId()
						Client.Skin.Menu[overlay.Item1].Index = Index - 1
						Client.Function.Skin.SetEyeColor(ped, Client.Skin.Menu[overlay.Item1].Index)
					end
				end)
			end
		end

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-random"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomOverlay(true), true)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-reset"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Skin.GetRandomOverlay(false), true)
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Ped.Skin.Tattoo.Main:IsVisible(function(Items)
		Client.IsSkinMenuVisible = true
		for i = 1, #Client.Skin.Tattoo.Zones do
			local zoneName = Client.Skin.Tattoo.Zones[i]
			Items:AddButton(Client.Function.Translate.Get("skin-tattoo-" .. zoneName:gsub("^ZONE_", ""):lower():gsub("_", "-")), nil, {IsDisabled = false, RightLabel = "→→→"}, function(onSelected)
				if i == 1 then
					Client.Skin.Camera.ZoomOffset = 0.85
					Client.Skin.Camera.CamOffset = 0.15
				elseif i == 2 then
					Client.Skin.Camera.ZoomOffset = 0.4
					Client.Skin.Camera.CamOffset = 0.65
				elseif i == 3 then
					Client.Skin.Camera.ZoomOffset = 0.85
					Client.Skin.Camera.CamOffset = 0.15
				elseif i == 4 then
					Client.Skin.Camera.ZoomOffset = 0.85
					Client.Skin.Camera.CamOffset = 0.15
				elseif i == 5 then
					Client.Skin.Camera.ZoomOffset = 1.0
					Client.Skin.Camera.CamOffset = -0.5
				elseif i == 6 then
					Client.Skin.Camera.ZoomOffset = 1.0
					Client.Skin.Camera.CamOffset = -0.5
				end
			end, Client.Menu.Ped.Skin.Tattoo.Zones[zoneName])
		end

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-random"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Tattoo.GetRandomData(true), true)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-ped-skin-reset"), nil, {IsDisabled = Client.IsPedSpawning}, function(onSelected)
			Client.Skin.Camera.ZoomOffset = 2.5
			Client.Skin.Camera.CamOffset = 0.0
			if onSelected then
				Client.Function.Skin.Set(Client.Function.Tattoo.GetRandomData(false), true)
			end
		end)
	end, function(Panels)
	end)

	for _, zoneName in pairs(Client.Skin.Tattoo.Zones) do
		Client.Menu.Ped.Skin.Tattoo.Zones[zoneName]:IsVisible(function(Items)
			Client.IsSkinMenuVisible = true
			local zoneData = (Client.Skin.Menu["sex"].Index == 0 and Client.Skin.Tattoo.ZoneData.Male[zoneName]) or (Client.Skin.Menu["sex"].Index == 1 and Client.Skin.Tattoo.ZoneData.Female[zoneName])
			if zoneData then
				for i = 1, #zoneData do
					local tattooData = zoneData[i]
					local tattooLabel = tattooData.Label
					local tattooCollection = tattooData.Collection
					local tattooOverlay = tattooData.Overlay
					local currentData = Client.Skin.Tattoo.Current[tattooOverlay]
					local tattooCount = currentData and currentData.Count or 0
					Items:AddList(tattooLabel, {(tattooCount * 10) .. "%"}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
						if onListChange == "left" then
							Client.Function.Tattoo.Change({Collection = tattooCollection, Overlay = tattooOverlay, Count = tattooCount - 1})
						elseif onListChange == "right" then
							Client.Function.Tattoo.Change({Collection = tattooCollection, Overlay = tattooOverlay, Count = tattooCount + 1})
						end
					end)
				end
			end
		end, function(Panels)
		end)
	end

	Client.Menu.Ped.Animal:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-ped-model-filter") .. " (" .. Client.Skin.Model.Animal.FilterCount .. "/" .. #Client.Skin.Model.Animal.Data .. ")", nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Client.Skin.Model.Animal.FilterStr
				})
				Client.NUI.Callback = "ped model filter"
			end
		end)

		for k, v in pairs(Client.Skin.Model.Animal.Data) do
			if v.filtered then
				Items:AddButton(v.label, nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning or not IsModelValid(v.model) or not IsModelAPed(v.model)}, function(onSelected)
					if onSelected then
						Client.IsPedSpawning = true
						CreateThread(function()
							Client.Function.Vehicle.DeleteCurrent()
							RequestModel(v.model)
							while not HasModelLoaded(v.model) do Wait(0) end
							SetPlayerModel(PlayerId(), v.model)
							SetPedRandomComponentVariation(PlayerPedId())
							SetEntityVisible(PlayerPedId(), true)
							SetModelAsNoLongerNeeded(v.model)
							TriggerServerEvent("server:core:saveSkin", nil, nil, v.model)
							if Client.Permission.Weapon and Client.Preference.WeaponLoaded then
								Client.Function.Weapon.RemoveAll(PlayerPedId())
								Client.Function.Weapon.LoadSaved(PlayerPedId())
							end
							Client.IsPedSpawning = false
						end)
					end
				end)
			end
		end
	end, function(Panels)
	end)

	Client.Menu.Ped.AddOn:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-ped-model-filter") .. " (" .. Client.Skin.Model.AddOn.FilterCount .. "/" .. #Client.Skin.Model.AddOn.Data .. ")", nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Client.Skin.Model.AddOn.FilterStr
				})
				Client.NUI.Callback = "ped model filter"
			end
		end)

		for k, v in pairs(Client.Skin.Model.AddOn.Data) do
			if v.filtered then
				Items:AddButton(v.label, nil, {IsDisabled = IsNuiFocused() or Client.IsPedSpawning or not IsModelValid(v.model) or not IsModelAPed(v.model)}, function(onSelected)
					if onSelected then
						Client.IsPedSpawning = true
						CreateThread(function()
							Client.Function.Vehicle.DeleteCurrent()
							RequestModel(v.model)
							while not HasModelLoaded(v.model) do Wait(0) end
							SetPlayerModel(PlayerId(), v.model)
							SetPedRandomComponentVariation(PlayerPedId())
							SetEntityVisible(PlayerPedId(), true)
							SetModelAsNoLongerNeeded(v.model)
							TriggerServerEvent("server:core:saveSkin", nil, nil, v.model)
							if Client.Permission.Weapon and Client.Preference.WeaponLoaded then
								Client.Function.Weapon.RemoveAll(PlayerPedId())
								Client.Function.Weapon.LoadSaved(PlayerPedId())
							end
							Client.IsPedSpawning = false
						end)
					end
				end)
			end
		end
	end, function(Panels)
	end)

	Client.Menu.Weapon.Main:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-weapon-category"), nil, {IsDisabled = not Client.Permission.Weapon, RightLabel = "→→→"}, function(onSelected)
			if onSelected then
				Client.Function.Vehicle.DeleteCurrent()
				ClearPedTasksImmediately(PlayerPedId())
				SetEntityVisible(PlayerPedId(), true)
				Client.Function.Weapon.Editing()
			end
		end, Client.Menu.Weapon.Category)

		Items:AddButton(Client.Function.Translate.Get("menu-add-ammo"), nil, {IsDisabled = not Client.Permission.Weapon or not Client.Function.Weapon.CanAddAmmo(PlayerPedId())}, function(onSelected)
			if onSelected then
				Client.Function.Weapon.AddAmmoForAll(PlayerPedId())
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-load-saved-weapon"), nil, {IsDisabled = not Client.Permission.Weapon or not Client.Function.Weapon.CanLoadSaved()}, function(onSelected)
			if onSelected then
				Client.Preference.WeaponLoaded = true
				Client.Function.Weapon.RemoveAll(PlayerPedId())
				Client.Function.Weapon.LoadSaved(PlayerPedId())
				TriggerServerEvent("server:core:preferences", {WeaponLoaded = Client.Preference.WeaponLoaded})
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-remove-all-weapons"), nil, {IsDisabled = not Client.Permission.Weapon}, function(onSelected)
			if onSelected then
				Client.Preference.WeaponLoaded = false
				Client.Function.Weapon.RemoveAll(PlayerPedId())
				TriggerServerEvent("server:core:preferences", {WeaponLoaded = Client.Preference.WeaponLoaded})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-infinite-ammo"), nil, Client.Preference.InfiniteAmmo, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.InfiniteAmmo = IsChecked
				TriggerServerEvent("server:core:preferences", {InfiniteAmmo = Client.Preference.InfiniteAmmo})
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Weapon.Category:IsVisible(function(Items)
		Client.IsWeaponMenuVisible = true
		for i = 1, #Client.Weapon.Categories do
			local categoryData = Client.Weapon.Categories[i]
			local categoryName = categoryData.Name
			local categoryLabel = categoryData.Label
			Items:AddButton(categoryLabel, nil, {IsDisabled = false, RightLabel = "→→→"}, function(onSelected)

			end, Client.Menu.Weapon.Categories[categoryName])
		end
	end, function(Panels)
	end)

	for _, categoryData in pairs(Client.Weapon.Categories) do
		local categoryName = categoryData.Name
		local weaponList = categoryData.List
		Client.Menu.Weapon.Categories[categoryName]:IsVisible(function(Items)
			Client.IsWeaponMenuVisible = true
			for i = 1, #weaponList do
				local weaponData = weaponList[i]
				local weaponName = weaponData.Name
				local weaponLabel = weaponData.Label
				Items:AddButton(weaponLabel, nil, {IsDisabled = false, RightLabel = "→→→"}, function(onSelected)
					Client.Weapon.CurrentEditing.Name = weaponName
					Client.Weapon.CurrentEditing.Hash = GetHashKey(weaponName)
				end, Client.Menu.Weapon.All[weaponName])
			end
		end, function(Panels)
		end)
	end

	for weaponName, weaponData in pairs(Client.Weapon.All) do
		Client.Menu.Weapon.All[weaponName]:IsVisible(function(Items)
			Client.IsWeaponMenuVisible = true
			local ped = PlayerPedId()
			local weaponHash = GetHashKey(weaponName)

			if Client.Weapon.EditingEnable then
				Items:CheckBox(Client.Function.Translate.Get("weapon-enable"), nil, Client.Weapon.Saved[weaponName] and Client.Weapon.Saved[weaponName].Enable and true or false, {Style = 1}, function(onSelected, IsChecked)
					if onSelected then
						Client.Weapon.Saved[weaponName] = Client.Weapon.Saved[weaponName] or {}
						Client.Weapon.Saved[weaponName].Enable = IsChecked and true or false
						Client.Weapon.Changed[weaponName] = 1
					end
				end)

				if weaponData.Tints then
					local tintIndex = GetPedWeaponTintIndex(ped, weaponHash)
					Items:AddList(string.format(Client.Function.Translate.Get("weapon-tint"), tintIndex + 1, #weaponData.Tints), weaponData.Tints, tintIndex + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
						if onListChange then
							SetPedWeaponTintIndex(ped, weaponHash, weaponData.Tints[Index].Value)
							Client.Weapon.Changed[weaponName] = 1
						end
					end)
				end

				if weaponData.Liveries then
					local liveryIndex = 1
					for i = 2, #weaponData.Liveries do
						if HasPedGotWeaponComponent(ped, weaponHash, GetHashKey(weaponData.Liveries[i].Camo)) then
							liveryIndex = i
							break
						end
					end
					local colorIndex = math.max(liveryIndex > 1 and GetPedWeaponLiveryColor(ped, weaponHash, GetHashKey(weaponData.Liveries[liveryIndex].Camo)) or -1, 0)
					Items:AddList(string.format(Client.Function.Translate.Get("weapon-livery-camo"), liveryIndex, #weaponData.Liveries), weaponData.Liveries, liveryIndex, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
						if onListChange then
							if Index > 1 then
								local liveryHash = GetHashKey(weaponData.Liveries[Index].Camo)
								if not HasPedGotWeaponComponent(ped, weaponHash, liveryHash) then
									GiveWeaponComponentToPed(ped, weaponHash, liveryHash)
									SetPedWeaponLiveryColor(ped, weaponHash, liveryHash, colorIndex)
								end
							else
								for i = 2, #weaponData.Liveries do
									local liveryHash = GetHashKey(weaponData.Liveries[i].Camo)
									if HasPedGotWeaponComponent(ped, weaponHash, liveryHash) then
										RemoveWeaponComponentFromPed(ped, weaponHash, liveryHash)
									end
								end
							end
							Client.Weapon.Changed[weaponName] = 1
						end
					end)
					Items:AddList(string.format(Client.Function.Translate.Get("weapon-livery-color"), colorIndex + 1, #weaponData.Colors), weaponData.Colors, colorIndex + 1, nil, {IsDisabled = liveryIndex == 1}, function(Index, onSelected, onListChange)
						if onListChange then
							local liveryHash = GetHashKey(weaponData.Liveries[liveryIndex].Camo)
							local liveryColor = Index - 1
							SetPedWeaponLiveryColor(ped, weaponHash, liveryHash, liveryColor)
							Client.Weapon.Changed[weaponName] = 1
						end
					end)
				end

				if weaponData.Liveries2 then
					local liveryIndex2 = 1
					for i = 2, #weaponData.Liveries2 do
						if HasPedGotWeaponComponent(ped, weaponHash, GetHashKey(weaponData.Liveries2[i].Camo)) then
							liveryIndex2 = i
							break
						end
					end
					local colorIndex2 = math.max(liveryIndex2 > 1 and GetPedWeaponLiveryColor(ped, weaponHash, GetHashKey(weaponData.Liveries2[liveryIndex2].Camo)) or -1, 0)
					Items:AddList(string.format(Client.Function.Translate.Get("weapon-livery-camo-2"), liveryIndex2, #weaponData.Liveries2), weaponData.Liveries2, liveryIndex2, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
						if onListChange then
							if Index > 1 then
								local liveryHash2 = GetHashKey(weaponData.Liveries2[Index].Camo)
								if not HasPedGotWeaponComponent(ped, weaponHash, liveryHash2) then
									GiveWeaponComponentToPed(ped, weaponHash, liveryHash2)
									SetPedWeaponLiveryColor(ped, weaponHash, liveryHash2, colorIndex2)
								end
							else
								for i = 2, #weaponData.Liveries2 do
									local liveryHash2 = GetHashKey(weaponData.Liveries2[i].Camo)
									if HasPedGotWeaponComponent(ped, weaponHash, liveryHash2) then
										RemoveWeaponComponentFromPed(ped, weaponHash, liveryHash2)
									end
								end
							end
							Client.Weapon.Changed[weaponName] = 1
						end
					end)
					Items:AddList(string.format(Client.Function.Translate.Get("weapon-livery-color-2"), colorIndex2 + 1, #weaponData.Colors), weaponData.Colors, colorIndex2 + 1, nil, {IsDisabled = liveryIndex2 == 1}, function(Index, onSelected, onListChange)
						if onListChange then
							local liveryHash2 = GetHashKey(weaponData.Liveries2[liveryIndex2].Camo)
							local liveryColor2 = Index - 1
							SetPedWeaponLiveryColor(ped, weaponHash, liveryHash2, liveryColor2)
							Client.Weapon.Changed[weaponName] = 1
						end
					end)
				end

				if weaponData.Components then
					for i = 1, #weaponData.Components do
						local component = weaponData.Components[i]
						local componentHash = GetHashKey(component.Name)
						local componentLabel = component.Label
						Items:CheckBox(componentLabel, nil, HasPedGotWeaponComponent(ped, weaponHash, componentHash), {Style = 1}, function(onSelected, IsChecked)
							if onSelected then
								if IsChecked then
									GiveWeaponComponentToPed(ped, weaponHash, componentHash)
								else
									RemoveWeaponComponentFromPed(ped, weaponHash, componentHash)
								end
								Client.Weapon.Changed[weaponName] = 1
							end
						end)
					end
				end
			end
		end, function(Panels)
		end)
	end

	Client.Menu.World.Main:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-world-weather"), nil, {IsDisabled = false, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.World.Weather)

		Items:AddButton(Client.Function.Translate.Get("menu-world-time"), nil, {IsDisabled = false, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.World.Time)

		Items:AddButton(Client.Function.Translate.Get("menu-world-teleport"), nil, {IsDisabled = false, RightLabel = "→→→"}, function(onSelected)

		end, Client.Menu.World.Teleport)
	end, function(Panels)
	end)

	Client.Menu.World.Weather:IsVisible(function(Items)
		for i = 1, #Client.Weather.Types do
			local weatherType = Client.Weather.Types[i]
			Items:AddButton(Client.Function.Translate.Get(weatherType), nil, {IsDisabled = false}, function(onSelected)
				if onSelected then
					Client.Function.Environment.SetWeather(weatherType)
				end
			end)
		end
	end, function(Panels)
	end)

	Client.Menu.World.Time:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Hours"), Client.Time.Hours, Client.Time.CurrentHour + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Function.Environment.SetTime(Index - 1, Client.Time.CurrentMinute, Client.Time.CurrentSecond)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Minutes"), Client.Time.Minutes, Client.Time.CurrentMinute + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Function.Environment.SetTime(Client.Time.CurrentHour, Index - 1, Client.Time.CurrentSecond)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Seconds"), Client.Time.Seconds, Client.Time.CurrentSecond + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Function.Environment.SetTime(Client.Time.CurrentHour, Client.Time.CurrentMinute, Index - 1)
			end
		end)

		if not Client.IsInRace then
			Items:CheckBox(Client.Function.Translate.Get("lock-time"), nil, Client.Time.Lock, {Style = 1}, function(onSelected, IsChecked)
				if onSelected then
					Client.Time.Lock = IsChecked
				end
			end)
		end
	end, function(Panels)
	end)

	Client.Menu.World.Teleport:IsVisible(function(Items)
		if not Client.IsInRace then
			Items:AddButton(Client.Function.Translate.Get("menu-tp-to-waypoint"), nil, {IsDisabled = Client.IsTeleportingInProgress}, function(onSelected)
				if onSelected then
					if IsWaypointActive() then
						local coords = GetBlipInfoIdCoord(GetFirstBlipInfoId(GetWaypointBlipEnumId()))
						Client.IsTeleportingInProgress = true
						CreateThread(function()
							local ped = PlayerPedId()
							local vehicle = GetVehiclePedIsIn(ped, false)
							local x, y, groundZ, Z_START = coords["x"], coords["y"], 850.0, 950.0
							local found = false
							FreezeEntityPosition(vehicle > 0 and vehicle or ped, true)
							for i = Z_START, 0, -25.0 do
								local z = i
								if (i % 2) ~= 0 then
									z = Z_START - i
								end
								NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
								local curTime = GetGameTimer()
								while IsNetworkLoadingScene() do
									if GetGameTimer() - curTime > 1000 then
										break
									end
									Wait(0)
								end
								NewLoadSceneStop()
								SetPedCoordsKeepVehicle(ped, x, y, z)
								while not HasCollisionLoadedAroundEntity(ped) do
									RequestCollisionAtCoord(x, y, z)
									if GetGameTimer() - curTime > 1000 then
										break
									end
									Wait(0)
								end
								found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
								if found then
									Wait(0)
									SetPedCoordsKeepVehicle(ped, x, y, groundZ)
									break
								end
								Wait(0)
							end
							FreezeEntityPosition(vehicle > 0 and vehicle or ped, false)
							SetPedCoordsKeepVehicle(ped, x, y, groundZ)
							SetGameplayCamRelativeHeading(0)
							Client.Function.Message.Display(Client.Function.Translate.Get("teleport-success"))
							Client.IsTeleportingInProgress = false
						end)
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("no-waypoint"))
					end
				end
			end)

			Items:AddButton(Client.Function.Translate.Get("menu-stunt-location-record"), nil, {IsDisabled = Client.IsTeleportingInProgress}, function(onSelected)
				if onSelected then
					Client.Function.Stunt.SaveTeleportCoords(true)
				end
			end)

			Items:AddButton(Client.Function.Translate.Get("menu-stunt-quick-teleport"), nil, {IsDisabled = Client.IsTeleportingInProgress}, function(onSelected)
				if onSelected then
					Client.Function.Stunt.TeleportToCoords(true)
				end
			end)

			Items:CheckBox(Client.Function.Translate.Get("menu-stunt-advanced-teleport"), nil, Client.Preference.AdvancedTeleport, {Style = 1}, function(onSelected, IsChecked)
				if onSelected and not Client.IsTeleportingInProgress then
					Client.Preference.AdvancedTeleport = IsChecked
					Client.Stunt.TeleportData.X = nil
					Client.Stunt.TeleportData.Y = nil
					Client.Stunt.TeleportData.Z = nil
					Client.Stunt.TeleportData.Heading = nil
					Client.Stunt.TeleportData.Speed = 0.0
					Client.Stunt.TeleportData.Rotation = vector3(0.0, 0.0, 0.0)
					Client.Stunt.TeleportData.Velocity = vector3(0.0, 0.0, 0.0)
					Client.Stunt.TeleportData.CamHeading = 0.0
					Client.Stunt.TeleportData.HasAdvancedData = false
					TriggerServerEvent("server:core:preferences", {AdvancedTeleport = Client.Preference.AdvancedTeleport})
				end
			end)

			Items:AddSeparator(Client.Function.Translate.Get("menu-tp-keybind-tip"), true)
		else
			Items:AddButton(Client.Function.Translate.Get("menu-tpn"), nil, {IsDisabled = not Client.Permission.TeleportInRace}, function(onSelected)
				if onSelected then
					Race.Function.Teleport.GoToNextCheckpoint()
				end
			end)

			Items:AddButton(Client.Function.Translate.Get("menu-tpp"), nil, {IsDisabled = not Client.Permission.TeleportInRace}, function(onSelected)
				if onSelected then
					Race.Function.Teleport.GoToPreviousCheckpoint()
				end
			end)
		end
	end, function(Panels)
	end)

	Client.Menu.Record:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-recording"), nil, {IsDisabled = false}, function(onSelected)
			if onSelected then
				CreateThread(function()
					Client.Function.Recording.Toggle()
				end)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-action-replay"), nil, {IsDisabled = false}, function(onSelected)
			if onSelected then
				CreateThread(function()
					Client.Function.Recording.ActionReplay()
				end)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-cancel-recording"), nil, {IsDisabled = false}, function(onSelected)
			if onSelected then
				CreateThread(function()
					Client.Function.Recording.Cancel()
				end)
			end
		end)
	end, function(Panels)
	end)

	Client.Menu.Misc:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("menu-refresh-permission"), nil, {IsDisabled = false}, function(onSelected)
			if onSelected then
				CreateThread(function()
					TriggerServerCallback("server:core:getMyData", function(serverId, permission, myData)
						local grantedCount = 0
						local permissionCount = 0
						for key, value in pairs(permission) do
							grantedCount = grantedCount + (value and 1 or 0)
							permissionCount = permissionCount + 1
						end
						Client.Permission = permission
						Client.Hud.Data.Logo = myData.Logo
						if grantedCount == permissionCount then
							Client.Function.Message.Display(Client.Function.Translate.Get("permission-on"))
						elseif grantedCount >= 1 then
							Client.Function.Message.Display(Client.Function.Translate.Get("permission-refresh"))
						else
							Client.Function.Message.Display(Client.Function.Translate.Get("permission-off"))
						end
					end, true)
				end)
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("menu-fix-lod"), nil, {IsDisabled = Client.IsTeleportingInProgress}, function(onSelected)
			if onSelected then
				Client.IsTeleportingInProgress = true
				CreateThread(function()
					local ped_1 = PlayerPedId()
					local vehicle_1 = GetVehiclePedIsIn(ped_1, false)
					local pos = GetEntityCoords(vehicle_1 > 0 and vehicle_1 or ped_1)
					SetEntityCoordsNoOffset(vehicle_1 > 0 and vehicle_1 or ped_1, pos.x + 5000.0, pos.y + 5000.0, pos.z)
					SetGameplayCamRelativeHeading(0)
					Wait(1000)
					local ped_2 = PlayerPedId()
					local vehicle_2 = GetVehiclePedIsIn(ped_2, false)
					SetEntityCoordsNoOffset(vehicle_2 > 0 and vehicle_2 or ped_2, pos.x, pos.y, pos.z)
					SetGameplayCamRelativeHeading(0)
					Client.IsTeleportingInProgress = false
				end)
			end
		end)

		if not Client.IsInRace then
			Items:AddButton(Client.Function.Translate.Get("menu-reset-area"), nil, {IsDisabled = false}, function(onSelected)
				if onSelected then
					local pos = GetEntityCoords(PlayerPedId())
					ClearAreaLeaveVehicleHealth(pos.x, pos.y, pos.z, 100000000000000000000000.0, false, false, false, false, false)
				end
			end)

			Items:CheckBox(Client.Function.Translate.Get("menu-traffic"), nil, Client.Preference.Traffic, {Style = 1}, function(onSelected, IsChecked)
				if onSelected then
					Client.Function.Environment.SetTraffic(not Client.Preference.Traffic)
				end
			end)

			Items:CheckBox(Client.Function.Translate.Get("menu-ambient-sound"), nil, Client.Preference.EnableAmbientSound, {Style = 1}, function(onSelected, IsChecked)
				if onSelected then
					Client.Preference.EnableAmbientSound = IsChecked
					if Client.Preference.EnableAmbientSound then
						StopAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
						Client.Function.Message.Display(Client.Function.Translate.Get("ambient-sound-on"))
					else
						StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
						Client.Function.Message.Display(Client.Function.Translate.Get("ambient-sound-off"))
					end
					TriggerServerEvent("server:core:preferences", {EnableAmbientSound = Client.Preference.EnableAmbientSound})
				end
			end)
		end

		if Client.IsInRace then
			Items:CheckBox(Client.Function.Translate.Get("menu-simulate-alt-f4"), nil, Client.Preference.SimulateAltF4, {Style = 1}, function(onSelected, IsChecked)
				if onSelected then
					Client.Preference.SimulateAltF4 = IsChecked
					TriggerServerEvent("server:core:preferences", {SimulateAltF4 = Client.Preference.SimulateAltF4})
				end
			end)
		end

		Items:CheckBox(Client.Function.Translate.Get("menu-disable-moto-melee"), nil, Client.Preference.DisableMotoMelee, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.DisableMotoMelee = IsChecked
				TriggerServerEvent("server:core:preferences", {DisableMotoMelee = Client.Preference.DisableMotoMelee})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-fix-bmx-float"), nil, Client.Preference.FixBmxFloat, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.FixBmxFloat = IsChecked
				TriggerServerEvent("server:core:preferences", {FixBmxFloat = Client.Preference.FixBmxFloat})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-online-map"), Client.Function.Translate.Get("menu-online-map-desc"), Client.Preference.EnableOnlineMap, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.EnableOnlineMap = IsChecked
				TriggerServerEvent("server:core:preferences", {EnableOnlineMap = Client.Preference.EnableOnlineMap})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("menu-vanilla-minimap"), nil, Client.Preference.EnableVanillaMinimap, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.EnableVanillaMinimap = IsChecked
				TriggerServerEvent("server:core:preferences", {EnableVanillaMinimap = Client.Preference.EnableVanillaMinimap})
			end
		end)

		if Client.IsInRace then
			Items:CheckBox(Client.Function.Translate.Get("menu-ped-visible"), nil, Client.Ped.Status.Visible, {Style = 1}, function(onSelected, IsChecked)
				if onSelected then
					SetEntityVisible(PlayerPedId(), IsChecked)
				end
			end)
		end

		Items:CheckBox(Client.Function.Translate.Get("convar-original-bmx-jump"), Client.Function.Translate.Get("convar-original-bmx-jump-desc"), GetConvar("game_originalBikeJump", "false") == "true", {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				if Client.Permission.SetConvar then
					TriggerServerEvent("server:core:setConvar", "game_originalBikeJump", IsChecked and "true" or "false")
				else
					Client.Function.Message.Display(Client.Function.Translate.Get("permission-off"))
				end
			end
		end)
	end, function(Panels)
	end)
end