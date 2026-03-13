MainMenu = RageUI.CreateMenu(GetTranslate("MainMenu-Title"), GetTranslate("MainMenu-Subtitle"), true)

RaceDetailSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("RaceDetailSubMenu-Subtitle"), false)
RaceDetailSubMenu_Class = RageUI.CreateSubMenu(RaceDetailSubMenu, "", GetTranslate("RaceDetailSubMenu_Class-Subtitle"), false)
RaceDetailSubMenu_Class_Vehicles = {}
for classid = 0, 27 do
	RaceDetailSubMenu_Class_Vehicles[classid] = RageUI.CreateSubMenu(RaceDetailSubMenu_Class, "", GetTranslate("RaceDetailSubMenu_Class-" .. classid), false)
end

PlacementSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("PlacementSubMenu-Subtitle"), false)
PlacementSubMenu_StartingGrid = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_StartingGrid-Subtitle"), false)
PlacementSubMenu_Checkpoints = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Checkpoints-Subtitle"), false)
PlacementSubMenu_Checkpoints_ExtraRandomSetting = RageUI.CreateSubMenu(PlacementSubMenu_Checkpoints, "", GetTranslate("PlacementSubMenu_Checkpoints_ExtraRandomSetting-Subtitle"), false)
PlacementSubMenu_Props = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Props-Subtitle"), false)
PlacementSubMenu_Templates = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Templates-Subtitle"), false)
-- PlacementSubMenu_Pickup = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Pickup-Subtitle"), false)
PlacementSubMenu_MoveAll = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_MoveAll-Subtitle"), false)
PlacementSubMenu_FixtureRemover = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_FixtureRemover-Subtitle"), false)
PlacementSubMenu_Firework = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Firework-Subtitle"), false)

MultiplayerSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("MultiplayerSubMenu-Subtitle"), false)
MultiplayerSubMenu_Invite = RageUI.CreateSubMenu(MultiplayerSubMenu, "", GetTranslate("MultiplayerSubMenu_Invite-Subtitle"), false)

WeatherSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("WeatherSubMenu-Subtitle"), false)
TimeSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("TimeSubMenu-Subtitle"), false)
MiscSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("MiscSubMenu-Subtitle"), false)

function RageUI.PoolMenus:Creator()
	MainMenu:IsVisible(function(Items)
		if currentRace.title == "" then
			Items:AddButton(GetTranslate("MainMenu-Button-Create"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "open",
						value = currentRace.title
					})
					nuiCallBack = "race title"
				end
				if global_var.previewThumbnail ~= "" then
					global_var.previewThumbnail = ""
					SendNUIMessage({
						action = "thumbnail_preview_off"
					})
				end
			end)

			Items:AddButton(GetTranslate("MainMenu-Button-Import"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "open",
						value = GetTranslate("paste-url")
					})
					nuiCallBack = "import ugc"
				end
			end)

			if global_var.querying then
				Items:AddButton(GetTranslate("MainMenu-Button-Cancel"), nil, { IsDisabled = false }, function(onSelected)
					if (onSelected) then
						global_var.querying = false
						TriggerServerEvent("custom_creator:server:cancel")
					end
				end)
			end

			Items:AddButton(GetTranslate("MainMenu-Button-Multiplayer"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = "→→→" }, function(onSelected)

			end, MultiplayerSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Weather"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = "→→→" }, function(onSelected)

			end, WeatherSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Time"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = "→→→" }, function(onSelected)

			end, TimeSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Misc"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = "→→→" }, function(onSelected)

			end, MiscSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Exit"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if (onSelected) then
					RageUI.QuitIndex = nil
					ExitCreator()
				end
			end)

			Items:AddSeparator(GetTranslate("MainMenu-Separator-Load"))

			Items:AddButton(GetTranslate("MainMenu-Button-Filter"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "open",
						value = races_data.filter
					})
					nuiCallBack = "filter races"
				end
			end)

			local category_list = {}
			for i = 1, #races_data.category do
				category_list[i] = (i == #races_data.category and GetTranslate("filter-races")) or (i == 1 and GetTranslate("published-races")) or (i == 2 and GetTranslate("saved-races")) or races_data.category[i].class
			end
			Items:AddList("", category_list, races_data.index, nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(Index, onSelected, onListChange)
				if (onListChange) then
					races_data.index = Index
				end
				if global_var.previewThumbnail ~= "" then
					global_var.previewThumbnail = ""
					SendNUIMessage({
						action = "thumbnail_preview_off"
					})
				end
			end)

			for i = 1, #races_data.category[races_data.index].data do
				Items:CheckBox(races_data.category[races_data.index].data[i].name, nil, true, { IsDisabled = global_var.IsNuiFocused or global_var.lock, Style = races_data.category[races_data.index].data[i].published and 1 or 2 }, function(onSelected)
					if global_var.previewThumbnail ~= races_data.category[races_data.index].data[i].img and not global_var.IsNuiFocused and not global_var.lock then
						global_var.previewThumbnail = races_data.category[races_data.index].data[i].img
						SendNUIMessage({
							action = "thumbnail_preview",
							preview_url = global_var.previewThumbnail
						})
					end
					if (onSelected) then
						global_var.lock = true
						RageUI.QuitIndex = RageUI.CurrentMenu.Index
						Citizen.CreateThread(function()
							busyspinner.status = "download"
							RemoveLoadingPrompt()
							BeginTextCommandBusyString("STRING")
							AddTextComponentSubstringPlayerName(string.format(GetTranslate("download-progress"), 0))
							EndTextCommandBusyString(4)
							TriggerServerCallback("custom_creator:server:getJson", function(data, data_2, inSessionPlayers)
								if data and not data_2 then
									ConvertDataFromUGC(data)
									global_var.thumbnailValid = false
									global_var.previewThumbnail = ""
									SendNUIMessage({
										action = "thumbnail_preview_off"
									})
									SendNUIMessage({
										action = "thumbnail_url",
										thumbnail_url = currentRace.thumbnail
									})
									DisplayCustomMsgs(GetTranslate("load-success"))
									if not inSession and currentRace.raceid then
										inSession = true
										lockSession = true
										multiplayer.inSessionPlayers = {}
										table.insert(multiplayer.inSessionPlayers, { playerId = myServerId, playerName = GetPlayerName(PlayerId()) })
										TriggerServerCallback("custom_creator:server:sessionData", function()
											if #multiplayer.loadingPlayers == 0 then
												lockSession = false
											end
											RemoveLoadingPrompt()
											busyspinner.status = nil
										end, currentRace.raceid, currentRace)
										DisplayBusyspinner("sync", 65536, #json.encode(currentRace) * 1.02)
									end
								elseif data and data_2 then
									inSession = true
									lockSession = true
									LoadSessionData(data, data_2)
									global_var.thumbnailValid = false
									global_var.previewThumbnail = ""
									SendNUIMessage({
										action = "thumbnail_preview_off"
									})
									SendNUIMessage({
										action = "thumbnail_url",
										thumbnail_url = currentRace.thumbnail
									})
									DisplayCustomMsgs(GetTranslate("join-session-success"))
									TriggerServerEvent("custom_creator:server:loadDone", currentRace.raceid)
									for i = 1, #inSessionPlayers do
										table.insert(multiplayer.inSessionPlayers, inSessionPlayers[i])
									end
									if #multiplayer.loadingPlayers == 0 then
										lockSession = false
									end
									RemoveLoadingPrompt()
									busyspinner.status = nil
								else
									RemoveLoadingPrompt()
									busyspinner.status = nil
									DisplayCustomMsgs(GetTranslate("json-not-exist"))
								end
								while global_var.lock_2 do Citizen.Wait(0) end
								global_var.lock = false
							end, races_data.category[races_data.index].data[i].raceid)
						end)
					end
				end)
			end
		else
			Items:AddButton(GetTranslate("MainMenu-Button-RaceDetail"), nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

			end, RaceDetailSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Placement"), nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

			end, PlacementSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Multiplayer"), nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

			end, MultiplayerSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Weather"), nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

			end, WeatherSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Time"), nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

			end, TimeSubMenu)

			if currentRace.published then
				Items:AddButton(GetTranslate("MainMenu-Button-Update"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback("custom_creator:server:saveFile", function(str, raceid, owner_name)
								if str == "success" then
									DisplayCustomMsgs(GetTranslate("update-success"))
									currentRace.raceid = raceid
									currentRace.published = true
									currentRace.owner_name = owner_name
								elseif str == "wrong-artifact" then
									DisplayCustomMsgs(GetTranslate("wrong-artifact"))
								end
								RemoveLoadingPrompt()
								busyspinner.status = nil
								global_var.lock = false
							end, ConvertDataToUGC(), "update")
						end)
					end
				end)

				Items:AddButton(GetTranslate("MainMenu-Button-CancelPublish"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or GetTranslate("MainMenu-Button-CancelPublish-Desc"), { IsDisabled = objectPool.isRefreshing or global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback("custom_creator:server:saveFile", function(str, raceid, owner_name)
								if str == "success" then
									DisplayCustomMsgs(GetTranslate("cancel-success"))
									currentRace.raceid = raceid
									currentRace.published = false
									currentRace.owner_name = owner_name
								elseif str == "wrong-artifact" then
									DisplayCustomMsgs(GetTranslate("wrong-artifact"))
								end
								RemoveLoadingPrompt()
								busyspinner.status = nil
								global_var.lock = false
							end, ConvertDataToUGC(), "cancel")
						end)
					end
				end)
			else
				Items:AddButton(GetTranslate("MainMenu-Button-Save"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback("custom_creator:server:saveFile", function(str, raceid, owner_name)
								if str == "success" then
									DisplayCustomMsgs(GetTranslate("save-success"))
									currentRace.raceid = raceid
									currentRace.published = false
									currentRace.owner_name = owner_name
								elseif str == "wrong-artifact" then
									DisplayCustomMsgs(GetTranslate("wrong-artifact"))
								end
								if not inSession and currentRace.raceid then
									inSession = true
									lockSession = true
									multiplayer.inSessionPlayers = {}
									table.insert(multiplayer.inSessionPlayers, { playerId = myServerId, playerName = GetPlayerName(PlayerId()) })
									TriggerServerEvent("custom_creator:server:createSession", currentRace.raceid)
									Citizen.Wait(3000)
									TriggerServerCallback("custom_creator:server:sessionData", function()
										if #multiplayer.loadingPlayers == 0 then
											lockSession = false
										end
										RemoveLoadingPrompt()
										busyspinner.status = nil
										global_var.lock = false
									end, currentRace.raceid, currentRace)
									DisplayBusyspinner("sync", 65536, #json.encode(currentRace) * 1.02)
								else
									RemoveLoadingPrompt()
									busyspinner.status = nil
									global_var.lock = false
								end
							end, ConvertDataToUGC(), "save")
						end)
					end
				end)

				Items:AddButton(GetTranslate("MainMenu-Button-Publish"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback("custom_creator:server:saveFile", function(str, raceid, owner_name)
								if str == "success" then
									DisplayCustomMsgs(GetTranslate("publish-success"))
									currentRace.raceid = raceid
									currentRace.published = true
									currentRace.owner_name = owner_name
								elseif str == "wrong-artifact" then
									DisplayCustomMsgs(GetTranslate("wrong-artifact"))
								end
								if not inSession and currentRace.raceid then
									inSession = true
									lockSession = true
									multiplayer.inSessionPlayers = {}
									table.insert(multiplayer.inSessionPlayers, { playerId = myServerId, playerName = GetPlayerName(PlayerId()) })
									TriggerServerEvent("custom_creator:server:createSession", currentRace.raceid)
									Citizen.Wait(3000)
									TriggerServerCallback("custom_creator:server:sessionData", function()
										if #multiplayer.loadingPlayers == 0 then
											lockSession = false
										end
										RemoveLoadingPrompt()
										busyspinner.status = nil
										global_var.lock = false
									end, currentRace.raceid, currentRace)
									DisplayBusyspinner("sync", 65536, #json.encode(currentRace) * 1.02)
								else
									RemoveLoadingPrompt()
									busyspinner.status = nil
									global_var.lock = false
								end
							end, ConvertDataToUGC(), "publish")
						end)
					end
				end)
			end

			Items:AddButton(GetTranslate("MainMenu-Button-Export"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
				if (onSelected) then
					global_var.lock = true
					Citizen.CreateThread(function()
						TriggerServerCallback("custom_creator:server:exportFile", function(str)
							if str == "success" then
								DisplayCustomMsgs(GetTranslate("export-success"))
							elseif str == "failed" then
								DisplayCustomMsgs(GetTranslate("export-failed"))
							end
							RemoveLoadingPrompt()
							busyspinner.status = nil
							global_var.lock = false
						end, ConvertDataToUGC())
					end)
				end
			end)

			Items:AddButton(GetTranslate("MainMenu-Button-Misc"), nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

			end, MiscSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Exit"), nil, { IsDisabled = objectPool.isRefreshing or global_var.lock or lockSession }, function(onSelected)
				if (onSelected) then
					ExitCreator()
				end
			end)
		end
	end, function(Panels)
	end)

	RaceDetailSubMenu:IsVisible(function(Items)
		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-Title"), (currentRace.title == "unknown") and GetTranslate("RaceDetailSubMenu-Button-Title-Desc"), { IsDisabled = global_var.IsNuiFocused or lockSession, Color = (currentRace.title == "unknown") and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = currentRace.title
				})
				nuiCallBack = "race title"
			end
		end)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-Thumbnail"), not global_var.thumbnailValid and GetTranslate("RaceDetailSubMenu-Button-Thumbnail-Desc"), { IsDisabled = global_var.IsNuiFocused or lockSession, Color = not global_var.thumbnailValid and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = currentRace.thumbnail
				})
				nuiCallBack = "race thumbnail"
			end
		end)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-InputVehicle"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] and currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index] and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].model or currentRace.test_vehicle
				})
				nuiCallBack = "input vehicle"
			end
		end)

		Items:AddList(GetTranslate("RaceDetailSubMenu-List-DefaultClass"), { currentRace.default_class and GetTranslate("RaceDetailSubMenu_Class-" .. currentRace.default_class) or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = currentRace.default_class or 0
				local validClasses = {}
				for classid = 0, 27 do
					for i = 1, #currentRace.available_vehicles[classid].vehicles do
						if currentRace.available_vehicles[classid].vehicles[i].enabled then
							validClasses[classid] = true
							break
						end
					end
				end
				local found = false
				local found_2 = false
				for i = index - 1, 0, -1 do
					if validClasses[i] then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = 27, 0, -1 do
						if validClasses[i] then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					currentRace.default_class = index
					if currentRace.available_vehicles[index].index then
						currentRace.test_vehicle = currentRace.available_vehicles[index].vehicles[currentRace.available_vehicles[index].index].model
						if inSession then
							modificationCount.test_vehicle = modificationCount.test_vehicle + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { test_vehicle = currentRace.test_vehicle, modificationCount = modificationCount.test_vehicle }, "test-vehicle-sync")
						end
					end
				else
					currentRace.default_class = nil
				end
			elseif (onListChange) == "right" then
				local index = currentRace.default_class or 0
				local validClasses = {}
				for classid = 0, 27 do
					for i = 1, #currentRace.available_vehicles[classid].vehicles do
						if currentRace.available_vehicles[classid].vehicles[i].enabled then
							validClasses[classid] = true
							break
						end
					end
				end
				local found = false
				local found_2 = false
				for i = index + 1, 27, 1 do
					if validClasses[i] then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = 0, 27, 1 do
						if validClasses[i] then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					currentRace.default_class = index
					if currentRace.available_vehicles[index].index then
						currentRace.test_vehicle = currentRace.available_vehicles[index].vehicles[currentRace.available_vehicles[index].index].model
						if inSession then
							modificationCount.test_vehicle = modificationCount.test_vehicle + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { test_vehicle = currentRace.test_vehicle, modificationCount = modificationCount.test_vehicle }, "test-vehicle-sync")
						end
					end
				else
					currentRace.default_class = nil
				end
			end
		end)

		Items:AddList(GetTranslate("RaceDetailSubMenu-List-DefaultVehicle"), { currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] and currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index] and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].name or "" }, 1, nil, { IsDisabled = not currentRace.default_class or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = currentRace.available_vehicles[currentRace.default_class].index or 0
				local found = false
				local found_2 = false
				for i = index - 1, 1, -1 do
					if currentRace.available_vehicles[currentRace.default_class].vehicles[i].enabled then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = #currentRace.available_vehicles[currentRace.default_class].vehicles, 1, -1 do
						if currentRace.available_vehicles[currentRace.default_class].vehicles[i].enabled then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					currentRace.available_vehicles[currentRace.default_class].index = index
					currentRace.test_vehicle = currentRace.available_vehicles[currentRace.default_class].vehicles[index].model
					if inSession then
						modificationCount.test_vehicle = modificationCount.test_vehicle + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { test_vehicle = currentRace.test_vehicle, modificationCount = modificationCount.test_vehicle }, "test-vehicle-sync")
					end
				else
					currentRace.available_vehicles[currentRace.default_class].index = nil
				end
			elseif (onListChange) == "right" then
				local index = currentRace.available_vehicles[currentRace.default_class].index or 0
				local found = false
				local found_2 = false
				for i = index + 1, #currentRace.available_vehicles[currentRace.default_class].vehicles, 1 do
					if currentRace.available_vehicles[currentRace.default_class].vehicles[i].enabled then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = 1, #currentRace.available_vehicles[currentRace.default_class].vehicles do
						if currentRace.available_vehicles[currentRace.default_class].vehicles[i].enabled then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					currentRace.available_vehicles[currentRace.default_class].index = index
					currentRace.test_vehicle = currentRace.available_vehicles[currentRace.default_class].vehicles[index].model
					if inSession then
						modificationCount.test_vehicle = modificationCount.test_vehicle + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { test_vehicle = currentRace.test_vehicle, modificationCount = modificationCount.test_vehicle }, "test-vehicle-sync")
					end
				else
					currentRace.available_vehicles[currentRace.default_class].index = nil
				end
			end
		end)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-AvailableClass"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession, RightLabel = "→→→" }, function(onSelected)

		end, RaceDetailSubMenu_Class)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-Blimp"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = currentRace.blimp_text
				})
				nuiCallBack = "blimp text"
			end
		end)
	end, function(Panels)
	end)

	RaceDetailSubMenu_Class:IsVisible(function(Items)
		for classid = 0, 27 do
			Items:AddButton(GetTranslate("RaceDetailSubMenu_Class-" .. classid), nil, { IsDisabled = #currentRace.available_vehicles[classid].vehicles == 0 or global_var.IsNuiFocused or lockSession, RightLabel = "→→→" }, function(onSelected)

			end, RaceDetailSubMenu_Class_Vehicles[classid])
		end
	end, function(Panels)
	end)

	for classid = 0, 27 do
		RaceDetailSubMenu_Class_Vehicles[classid]:IsVisible(function(Items)
			Items:AddButton(GetTranslate("RaceDetailSubMenu_Class_Vehicles-Button-Select"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.fixEventSizeOverflow or lockSession }, function(onSelected)
				if (onSelected) then
					local default_class = nil
					local found = false
					for i = 1, #currentRace.available_vehicles[classid].vehicles do
						if currentRace.available_vehicles[classid].vehicles[i].enabled then
							found = true
							break
						end
					end
					if found then
						for i = 1, #currentRace.available_vehicles[classid].vehicles do
							currentRace.available_vehicles[classid].vehicles[i].enabled = false
						end
						currentRace.available_vehicles[classid].index = nil
						local validClasses = {}
						for _classid = 0, 27 do
							for i = 1, #currentRace.available_vehicles[_classid].vehicles do
								if currentRace.available_vehicles[_classid].vehicles[i].enabled then
									validClasses[_classid] = true
									break
								end
							end
						end
						local found_2 = false
						for i = 0, 27, 1 do
							if validClasses[i] then
								default_class = i
								found_2 = true
								break
							end
						end
						if not found_2 then
							default_class = nil
						end
					else
						local valid = false
						for i = 1, #currentRace.available_vehicles[classid].vehicles do
							local hash = currentRace.available_vehicles[classid].vehicles[i].hash
							if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
								currentRace.available_vehicles[classid].vehicles[i].enabled = true
								valid = true
							end
						end
						if valid then
							currentRace.available_vehicles[classid].index = 1
							default_class = classid
						else
							currentRace.available_vehicles[classid].index = nil
							local validClasses = {}
							for _classid = 0, 27 do
								for i = 1, #currentRace.available_vehicles[_classid].vehicles do
									if currentRace.available_vehicles[_classid].vehicles[i].enabled then
										validClasses[_classid] = true
										break
									end
								end
							end
							local found_2 = false
							for i = 0, 27, 1 do
								if validClasses[i] then
									default_class = i
									found_2 = true
									break
								end
							end
							if not found_2 then
								default_class = nil
							end
						end
					end
					currentRace.default_class = default_class
					if inSession then
						global_var.fixEventSizeOverflow = true
						global_var.fixEventSizeOverflowTimer = GetGameTimer()
						modificationCount.available_vehicles = modificationCount.available_vehicles + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { default_class = currentRace.default_class, available_vehicles = currentRace.available_vehicles, modificationCount = modificationCount.available_vehicles }, "available-vehicles-sync")
					end
				end
			end)

			for i = 1, #currentRace.available_vehicles[classid].vehicles do
				Items:CheckBox(currentRace.available_vehicles[classid].vehicles[i].name, nil, currentRace.available_vehicles[classid].vehicles[i].enabled, { Style = 1 }, function(onSelected, IsChecked)
					if (onSelected) and not global_var.fixEventSizeOverflow then
						local hash = currentRace.available_vehicles[classid].vehicles[i].hash
						if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
							currentRace.available_vehicles[classid].vehicles[i].enabled = IsChecked
							local default_class = nil
							if IsChecked then
								currentRace.available_vehicles[classid].index = i
								default_class = classid
							else
								local found = false
								for j = 1, #currentRace.available_vehicles[classid].vehicles, 1 do
									if currentRace.available_vehicles[classid].vehicles[j].enabled then
										currentRace.available_vehicles[classid].index = j
										found = true
										break
									end
								end
								if not found then
									currentRace.available_vehicles[classid].index = nil
								end
								local validClasses = {}
								for _classid = 0, 27 do
									for j = 1, #currentRace.available_vehicles[_classid].vehicles do
										if currentRace.available_vehicles[_classid].vehicles[j].enabled then
											validClasses[_classid] = true
											break
										end
									end
								end
								local found_2 = false
								if validClasses[classid] then
									default_class = classid
									found_2 = true
								else
									for j = 0, 27, 1 do
										if validClasses[j] then
											default_class = j
											found_2 = true
											break
										end
									end
								end
								if not found_2 then
									default_class = nil
								end
							end
							currentRace.default_class = default_class
						else
							DisplayCustomMsgs(string.format(GetTranslate("vehicle-hash-null"), currentRace.available_vehicles[classid].vehicles[i].model))
						end
						if inSession then
							global_var.fixEventSizeOverflow = true
							global_var.fixEventSizeOverflowTimer = GetGameTimer()
							modificationCount.available_vehicles = modificationCount.available_vehicles + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { default_class = currentRace.default_class, available_vehicles = currentRace.available_vehicles, modificationCount = modificationCount.available_vehicles }, "available-vehicles-sync")
						end
					end
				end)
			end
		end, function(Panels)
		end)
	end

	PlacementSubMenu:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu-Button-StartingGrid"), (#currentRace.startingGrid == 0) and GetTranslate("PlacementSubMenu-Button-StartingGrid-Desc"), { IsDisabled = global_var.IsNuiFocused or global_var.lock or lockSession, RightLabel = "→→→", Color = (#currentRace.startingGrid == 0) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_StartingGrid)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Checkpoints"), (#currentRace.checkpoints < 10) and GetTranslate("PlacementSubMenu-Button-Checkpoints-Desc"), { IsDisabled = global_var.IsNuiFocused or global_var.lock or lockSession, RightLabel = "→→→", Color = (#currentRace.checkpoints < 10) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_Checkpoints)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Props"), (#currentRace.objects == 0) and GetTranslate("PlacementSubMenu-Button-Props-Desc"), { IsDisabled = global_var.IsNuiFocused or global_var.lock or lockSession, RightLabel = "→→→", Color = (#currentRace.objects == 0) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_Props)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Templates"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

		end, PlacementSubMenu_Templates)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-MoveAll"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

		end, PlacementSubMenu_MoveAll)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-FixtureRemover"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

		end, PlacementSubMenu_FixtureRemover)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Firework"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock or lockSession, RightLabel = "→→→" }, function(onSelected)

		end, PlacementSubMenu_Firework)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Import"), not inSession and GetTranslate("PlacementSubMenu-Button-Desc"), { IsDisabled = not inSession or global_var.IsNuiFocused or global_var.lock or lockSession, Color = not inSession and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = GetTranslate("paste-url")
				})
				nuiCallBack = "import ugc"
			end
		end)

		if global_var.querying then
			Items:AddButton(GetTranslate("PlacementSubMenu-Button-Cancel"), nil, { IsDisabled = false }, function(onSelected)
				if (onSelected) then
					global_var.querying = false
					TriggerServerEvent("custom_creator:server:cancel")
				end
			end)
		end
	end, function(Panels)
	end)

	PlacementSubMenu_StartingGrid:IsVisible(function(Items)
		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-CycleItems"), { startingGridVehicleIndex .. " / " .. #currentRace.startingGrid }, 1, nil, { IsDisabled = #currentRace.startingGrid == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = TableDeepCopy(currentStartingGridVehicle)
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
					ResetEntityAlpha(startingGridVehicleSelect)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutlineShader(1)
					SetEntityDrawOutline(startingGridVehicleSelect, true)
				end
				if startingGridVehiclePreview then
					DeleteVehicle(startingGridVehiclePreview)
					startingGridVehiclePreview = nil
				end
				local index = startingGridVehicleIndex - 1
				if index < 1 then
					index = #currentRace.startingGrid
				elseif index > #currentRace.startingGrid then
					index = 1
				end
				startingGridVehicleIndex = index
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentStartingGridVehicle = TableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				globalRot.z = RoundedValue(currentStartingGridVehicle.heading, 3)
				startingGridVehicleSelect = currentStartingGridVehicle.handle
				SetEntityDrawOutline(currentStartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensionsInCaches(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentStartingGridVehicle.x + (20.0 - min.z) * math.sin(math.rad(currentStartingGridVehicle.heading)), currentStartingGridVehicle.y - (20.0 - min.z) * math.cos(math.rad(currentStartingGridVehicle.heading)), currentStartingGridVehicle.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentStartingGridVehicle.heading}
			elseif (onListChange) == "right" then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = TableDeepCopy(currentStartingGridVehicle)
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
					ResetEntityAlpha(startingGridVehicleSelect)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutlineShader(1)
					SetEntityDrawOutline(startingGridVehicleSelect, true)
				end
				if startingGridVehiclePreview then
					DeleteVehicle(startingGridVehiclePreview)
					startingGridVehiclePreview = nil
				end
				local index = startingGridVehicleIndex + 1
				if index < 1 then
					index = #currentRace.startingGrid
				elseif index > #currentRace.startingGrid then
					index = 1
				end
				startingGridVehicleIndex = index
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentStartingGridVehicle = TableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				globalRot.z = RoundedValue(currentStartingGridVehicle.heading, 3)
				startingGridVehicleSelect = currentStartingGridVehicle.handle
				SetEntityDrawOutline(currentStartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensionsInCaches(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentStartingGridVehicle.x + (20.0 - min.z) * math.sin(math.rad(currentStartingGridVehicle.heading)), currentStartingGridVehicle.y - (20.0 - min.z) * math.cos(math.rad(currentStartingGridVehicle.heading)), currentStartingGridVehicle.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentStartingGridVehicle.heading}
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(startingGridVehicleIndex)
				})
				nuiCallBack = "goto startingGrid"
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_StartingGrid-Button-Place"), (#currentRace.startingGrid >= 48) and GetTranslate("PlacementSubMenu_StartingGrid-Button-startingGridLimit-Desc") or nil, { IsDisabled = isStartingGridVehiclePickedUp or global_var.IsNuiFocused or (not startingGridVehicleSelect and not startingGridVehiclePreview) or (#currentRace.startingGrid >= 48) or lockSession }, function(onSelected)
			if (onSelected) then
				if not isStartingGridVehiclePickedUp and startingGridVehiclePreview then
					ResetEntityAlpha(startingGridVehiclePreview)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutlineShader(1)
					SetEntityDrawOutline(startingGridVehiclePreview, true)
					table.insert(currentRace.startingGrid, TableDeepCopy(currentStartingGridVehicle))
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, insertIndex = #currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
					startingGridVehicleIndex = #currentRace.startingGrid
					startingGridVehiclePreview = nil
					globalRot.z = RoundedValue(currentStartingGridVehicle.heading, 3)
					ResetGlobalVariable("currentStartingGridVehicle")
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-Heading"), { (not startingGridVehicleSelect and not startingGridVehiclePreview) and "" or currentStartingGridVehicle.heading }, 1, nil, { IsDisabled = (not startingGridVehicleSelect and not startingGridVehiclePreview) or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentStartingGridVehicle.heading = RoundedValue(currentStartingGridVehicle.heading - speed.grid_offset.value[speed.grid_offset.index][2], 3)
				if (currentStartingGridVehicle.heading <= -9999.0) or (currentStartingGridVehicle.heading >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentStartingGridVehicle.heading = 0.0
				end
				SetEntityRotation(currentStartingGridVehicle.handle, 0.0, 0.0, currentStartingGridVehicle.heading, 2, 0)
				if isStartingGridVehiclePickedUp and currentRace.startingGrid[startingGridVehicleIndex] then
					currentRace.startingGrid[startingGridVehicleIndex] = TableDeepCopy(currentStartingGridVehicle)
					globalRot.z = RoundedValue(currentStartingGridVehicle.heading, 3)
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
				end
			elseif (onListChange) == "right" then
				currentStartingGridVehicle.heading = RoundedValue(currentStartingGridVehicle.heading + speed.grid_offset.value[speed.grid_offset.index][2], 3)
				if (currentStartingGridVehicle.heading <= -9999.0) or (currentStartingGridVehicle.heading >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentStartingGridVehicle.heading = 0.0
				end
				SetEntityRotation(currentStartingGridVehicle.handle, 0.0, 0.0, currentStartingGridVehicle.heading, 2, 0)
				if isStartingGridVehiclePickedUp and currentRace.startingGrid[startingGridVehicleIndex] then
					currentRace.startingGrid[startingGridVehicleIndex] = TableDeepCopy(currentStartingGridVehicle)
					globalRot.z = RoundedValue(currentStartingGridVehicle.heading, 3)
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
				end
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(currentStartingGridVehicle.heading)
				})
				nuiCallBack = "startingGrid heading"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-ChangeSpeed"), { speed.grid_offset.value[speed.grid_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = speed.grid_offset.index - 1
				if index < 1 then
					index = #speed.grid_offset.value
				end
				speed.grid_offset.index = index
			elseif (onListChange) == "right" then
				local index = speed.grid_offset.index + 1
				if index > #speed.grid_offset.value then
					index = 1
				end
				speed.grid_offset.index = index
			end
		end)

		Items:AddSeparator("x = " .. (currentStartingGridVehicle.x or 0.0) .. ", y = " .. (currentStartingGridVehicle.y or 0.0) .. ", z = " .. (currentStartingGridVehicle.z or 0.0))

		Items:AddButton(GetTranslate("PlacementSubMenu_StartingGrid-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isStartingGridVehiclePickedUp) or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				startingGridVehicleSelect = nil
				isStartingGridVehiclePickedUp = false
				DeleteVehicle(currentStartingGridVehicle.handle)
				local deleteIndex = 0
				for k, v in pairs(currentRace.startingGrid) do
					if currentStartingGridVehicle.handle == v.handle then
						deleteIndex = k
						table.remove(currentRace.startingGrid, k)
						break
					end
				end
				if startingGridVehicleIndex > #currentRace.startingGrid then
					startingGridVehicleIndex = #currentRace.startingGrid
				end
				ResetGlobalVariable("currentStartingGridVehicle")
				if inSession then
					modificationCount.startingGrid = modificationCount.startingGrid + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, deleteIndex = deleteIndex, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
				end
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Checkpoints:IsVisible(function(Items)
		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-CycleItems"), { checkpointIndex .. " / " .. #currentRace.checkpoints }, 1, nil, { IsDisabled = (global_var.isPrimaryCheckpointItems and (#currentRace.checkpoints == 0)) or (not global_var.isPrimaryCheckpointItems and (TableCount(currentRace.checkpoints_2) == 0)) or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				if global_var.isPrimaryCheckpointItems then
					local index = checkpointIndex - 1
					if index < 1 then
						index = #currentRace.checkpoints
					elseif index > #currentRace.checkpoints then
						index = 1
					end
					checkpointIndex = index
				else
					local found = false
					for i = checkpointIndex - 1, 1, -1 do
						if currentRace.checkpoints_2[i] then
							checkpointIndex = i
							found = true
							break
						end
					end
					if not found then
						for i = #currentRace.checkpoints, 1, -1 do
							if currentRace.checkpoints_2[i] then
								checkpointIndex = i
								break
							end
						end
					end
				end
				isCheckpointPickedUp = true
				checkpointPreview = nil
				currentCheckpoint = global_var.isPrimaryCheckpointItems and TableDeepCopy(currentRace.checkpoints[checkpointIndex]) or TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
				local d = currentCheckpoint.d_draw
				local is_round = currentCheckpoint.is_round
				local is_air = currentCheckpoint.is_air
				local is_fake = currentCheckpoint.is_fake
				local is_random = currentCheckpoint.is_random
				local is_transform = currentCheckpoint.is_transform
				local is_planeRot = currentCheckpoint.is_planeRot
				local is_warp = currentCheckpoint.is_warp
				local draw_size = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
				cameraPosition = vector3(currentCheckpoint.x + (20.0 + draw_size) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20.0 + draw_size) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20.0 + draw_size))
				cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
			elseif (onListChange) == "right" then
				if global_var.isPrimaryCheckpointItems then
					local index = checkpointIndex + 1
					if index < 1 then
						index = #currentRace.checkpoints
					elseif index > #currentRace.checkpoints then
						index = 1
					end
					checkpointIndex = index
				else
					local found = false
					for i = checkpointIndex + 1, #currentRace.checkpoints, 1 do
						if currentRace.checkpoints_2[i] then
							checkpointIndex = i
							found = true
							break
						end
					end
					if not found then
						for i = 1, #currentRace.checkpoints, 1 do
							if currentRace.checkpoints_2[i] then
								checkpointIndex = i
								break
							end
						end
					end
				end
				isCheckpointPickedUp = true
				checkpointPreview = nil
				currentCheckpoint = global_var.isPrimaryCheckpointItems and TableDeepCopy(currentRace.checkpoints[checkpointIndex]) or TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
				local d = currentCheckpoint.d_draw
				local is_round = currentCheckpoint.is_round
				local is_air = currentCheckpoint.is_air
				local is_fake = currentCheckpoint.is_fake
				local is_random = currentCheckpoint.is_random
				local is_transform = currentCheckpoint.is_transform
				local is_planeRot = currentCheckpoint.is_planeRot
				local is_warp = currentCheckpoint.is_warp
				local draw_size = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
				cameraPosition = vector3(currentCheckpoint.x + (20.0 + draw_size) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20.0 + draw_size) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20.0 + draw_size))
				cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(checkpointIndex)
				})
				nuiCallBack = "goto checkpoint"
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Test"), nil, { IsDisabled = global_var.IsNuiFocused or not isCheckpointPickedUp or (isCheckpointPickedUp and (global_var.isPrimaryCheckpointItems and not currentRace.checkpoints[checkpointIndex]) or (not global_var.isPrimaryCheckpointItems and not currentRace.checkpoints_2[checkpointIndex])) or lockSession }, function(onSelected)
			if (onSelected) then
				TriggerServerEvent("custom_core:server:inTestMode", true)
				global_var.joiningTest = true
				global_var.enableTest = true
				global_var.isRespawning = true
				global_var.tipsRendered = false
				Citizen.CreateThread(function()
					SetRadarBigmapEnabled(false, false)
					Citizen.Wait(0)
					SetRadarZoom(1200)
				end)
				DoScreenFadeOut(0)
				UnlockMinimapAngle()
				UnlockMinimapPosition()
				SetBlipAlpha(GetMainPlayerBlipId(), 255)
				RemoveBlip(global_var.creatorBlipHandle)
				global_var.creatorBlipHandle = nil
				for k, v in pairs(blips.checkpoints) do
					RemoveBlip(v)
				end
				for k, v in pairs(blips.checkpoints_2) do
					RemoveBlip(v)
				end
				blips.checkpoints = {}
				blips.checkpoints_2 = {}
				arenaProps = {}
				explodeProps = {}
				fireworkProps = {}
				for k, v in pairs(currentRace.objects) do
					if v.dynamic then
						if arenaObjects[v.hash] then
							arenaProps[#arenaProps + 1] = v
						end
						if explodeObjects[v.hash] then
							explodeProps[#explodeProps + 1] = v
						end
					end
					if fireworkObjects[v.hash] then
						fireworkProps[#fireworkProps + 1] = v
					end
				end
				for uniqueId, effectData in pairs(objectPool.activeEffects) do
					if effectData.ptfxHandle then
						StopParticleFxLooped(effectData.ptfxHandle, true)
						effectData.ptfxHandle = nil
					end
					objectPool.activeEffects[uniqueId] = nil
				end
				for uniqueId, object in pairs(objectPool.activeObjects) do
					if object.handle then
						DeleteObject(object.handle)
						object.handle = nil
					end
					objectPool.activeObjects[uniqueId] = nil
				end
				objectPool.activeGrids = {}
				UpdateBlipForCreator("object", nil)
				Citizen.CreateThread(function()
					RageUI.CloseAll()
					Citizen.Wait(500)
					DisplayCustomMsgs(string.format(GetTranslate("respawn-tip"), global_var.IsUsingKeyboard and "F" or "Y"))
					Citizen.Wait(100)
					BeginTextCommandDisplayHelp("THREESTRINGS")
					AddTextComponentSubstringPlayerName(GetTranslate("quit-test"))
					AddTextComponentSubstringPlayerName("")
					AddTextComponentSubstringPlayerName("")
					EndTextCommandDisplayHelp(0, true, true, -1)
					global_var.testData.checkpoints = TableDeepCopy(currentRace.checkpoints) or {}
					global_var.testData.checkpoints_2 = TableDeepCopy(currentRace.checkpoints_2) or {}
					CreateBlipForTest(global_var.respawnData.checkpointIndex_draw)
					CreateCheckpointForTest(global_var.respawnData.checkpointIndex_draw, false)
					CreateCheckpointForTest(global_var.respawnData.checkpointIndex_draw, true)
					global_var.tipsRendered = true
				end)
				global_var.respawnData = {
					checkpointIndex = checkpointIndex,
					checkpointIndex_draw = checkpointIndex + 1
				}
				local checkpoint = {}
				if global_var.isPrimaryCheckpointItems then
					checkpoint = currentRace.checkpoints[global_var.respawnData.checkpointIndex] and TableDeepCopy(currentRace.checkpoints[global_var.respawnData.checkpointIndex]) or {}
				else
					checkpoint = currentRace.checkpoints_2[global_var.respawnData.checkpointIndex] and TableDeepCopy(currentRace.checkpoints_2[global_var.respawnData.checkpointIndex]) or {}
				end
				global_var.respawnData.x = checkpoint.x or 0.0
				global_var.respawnData.y = checkpoint.y or 0.0
				global_var.respawnData.z = checkpoint.z or 0.0
				global_var.respawnData.heading = checkpoint.heading or 0.0
				global_var.respawnData.model = checkpoint.is_transform and currentRace.transformVehicles[checkpoint.transform_index + 1]
				global_var.joiningTest = false
				TestCurrentCheckpoint(global_var.respawnData, function(ped)
					FreezeEntityPosition(ped, false)
					SetEntityVisible(ped, true)
					SetEntityCollision(ped, true, true)
					SetEntityCompletelyDisableCollision(ped, true, true)
					RenderScriptCams(false, false, 0, true, false)
					DestroyCam(camera, false)
					camera = nil
				end)
			end
		end)

		Items:AddList("", { global_var.isPrimaryCheckpointItems and GetTranslate("PlacementSubMenu_Checkpoints-List-Primary") or GetTranslate("PlacementSubMenu_Checkpoints-List-Secondary") }, 1, nil, { IsDisabled = global_var.IsNuiFocused or isCheckpointPickedUp or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				global_var.isPrimaryCheckpointItems = not global_var.isPrimaryCheckpointItems
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Place"), nil, { IsDisabled = global_var.IsNuiFocused or isCheckpointPickedUp or not checkpointPreview or lockSession }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(global_var.isPrimaryCheckpointItems and (#currentRace.checkpoints + 1) or checkpointIndex)
				})
				nuiCallBack = "place checkpoint"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Alignment"), { isCheckpointOverrideRelativeEnable and GetTranslate("PlacementSubMenu_Checkpoints-List-Alignment-Relative") or GetTranslate("PlacementSubMenu_Checkpoints-List-Alignment-World") }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				isCheckpointOverrideRelativeEnable = not isCheckpointOverrideRelativeEnable
			end
		end)

		Items:AddList("X:", { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.x }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.x then
				if not isCheckpointOverrideRelativeEnable then
					currentCheckpoint.x = RoundedValue(currentCheckpoint.x - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, -speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0, 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
			elseif (onListChange) == "right" and currentCheckpoint.x then
				if not isCheckpointOverrideRelativeEnable then
					currentCheckpoint.x = RoundedValue(currentCheckpoint.x + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0, 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(currentCheckpoint.x)
				})
				nuiCallBack = "checkpoint x"
			end
			if (onListChange) or (onSelected) then
				checkpointPreview_coords_change = true
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList("Y:", { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.y }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.y then
				if not isCheckpointOverrideRelativeEnable then
					currentCheckpoint.y = RoundedValue(currentCheckpoint.y - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, 0.0, -speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
			elseif (onListChange) == "right" and currentCheckpoint.y then
				if not isCheckpointOverrideRelativeEnable then
					currentCheckpoint.y = RoundedValue(currentCheckpoint.y + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, 0.0, speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(currentCheckpoint.y)
				})
				nuiCallBack = "checkpoint y"
			end
			if (onListChange) or (onSelected) then
				checkpointPreview_coords_change = true
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList("Z:", { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.z }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.z then
				currentCheckpoint.z = RoundedValue(currentCheckpoint.z - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			elseif (onListChange) == "right" and currentCheckpoint.z then
				currentCheckpoint.z = RoundedValue(currentCheckpoint.z + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(currentCheckpoint.z)
				})
				nuiCallBack = "checkpoint z"
			end
			if (onListChange) or (onSelected) then
				checkpointPreview_coords_change = true
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-LockDirection"), nil, currentCheckpoint.lock_dir, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.lock_dir = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Heading"), { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.heading }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.heading then
				currentCheckpoint.heading = RoundedValue(currentCheckpoint.heading - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				if (currentCheckpoint.heading <= -9999.0) or (currentCheckpoint.heading >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.heading = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif (onListChange) == "right" and currentCheckpoint.heading then
				currentCheckpoint.heading = RoundedValue(currentCheckpoint.heading + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				if (currentCheckpoint.heading <= -9999.0) or (currentCheckpoint.heading >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.heading = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(currentCheckpoint.heading)
				})
				nuiCallBack = "checkpoint heading"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Pitch"), { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.pitch }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or not currentCheckpoint.lock_dir or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.pitch then
				currentCheckpoint.pitch = RoundedValue(currentCheckpoint.pitch - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				if (currentCheckpoint.pitch <= -9999.0) or (currentCheckpoint.pitch >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.pitch = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif (onListChange) == "right" and currentCheckpoint.pitch then
				currentCheckpoint.pitch = RoundedValue(currentCheckpoint.pitch + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				if (currentCheckpoint.pitch <= -9999.0) or (currentCheckpoint.pitch >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.pitch = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(currentCheckpoint.pitch)
				})
				nuiCallBack = "checkpoint pitch"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-ChangeSpeed"), { speed.checkpoint_offset.value[speed.checkpoint_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = speed.checkpoint_offset.index - 1
				if index < 1 then
					index = #speed.checkpoint_offset.value
				end
				speed.checkpoint_offset.index = index
			elseif (onListChange) == "right" then
				local index = speed.checkpoint_offset.index + 1
				if index > #speed.checkpoint_offset.value then
					index = 1
				end
				speed.checkpoint_offset.index = index
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-DiameterDraw"), { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.d_draw }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.d_draw then
				currentCheckpoint.d_draw = RoundedValue(currentCheckpoint.d_draw - 0.25, 3)
				if currentCheckpoint.d_draw < 0.5 then
					currentCheckpoint.d_draw = 5.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
						local checkpoint_2 = currentRace.checkpoints_2[checkpointIndex]
						if checkpoint_2 then
							checkpoint_2.d_draw = currentCheckpoint.d_draw
						end
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
						local checkpoint = currentRace.checkpoints[checkpointIndex]
						if checkpoint then
							checkpoint.d_draw = currentCheckpoint.d_draw
						end
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif (onListChange) == "right" and currentCheckpoint.d_draw then
				currentCheckpoint.d_draw = RoundedValue(currentCheckpoint.d_draw + 0.25, 3)
				if currentCheckpoint.d_draw > 5.0 then
					currentCheckpoint.d_draw = 0.5
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
						local checkpoint_2 = currentRace.checkpoints_2[checkpointIndex]
						if checkpoint_2 then
							checkpoint_2.d_draw = currentCheckpoint.d_draw
						end
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
						local checkpoint = currentRace.checkpoints[checkpointIndex]
						if checkpoint then
							checkpoint.d_draw = currentCheckpoint.d_draw
						end
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-DiameterCollect"), { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.d_collect }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.d_collect then
				currentCheckpoint.d_collect = RoundedValue(currentCheckpoint.d_collect - 0.25, 3)
				if currentCheckpoint.d_collect < 0.5 then
					currentCheckpoint.d_collect = 5.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif (onListChange) == "right" and currentCheckpoint.d_collect then
				currentCheckpoint.d_collect = RoundedValue(currentCheckpoint.d_collect + 0.25, 3)
				if currentCheckpoint.d_collect > 5.0 then
					currentCheckpoint.d_collect = 0.5
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-LowerAlpha"), nil, currentCheckpoint.lower_alpha, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.lower_alpha = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Air"), nil, currentCheckpoint.is_air, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_air = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Fake"), nil, currentCheckpoint.is_fake, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_fake = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Tall"), nil, currentCheckpoint.is_tall, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_tall = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-TallRadius"), { not currentCheckpoint.is_tall and "" or currentCheckpoint.tall_radius }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or not currentCheckpoint.is_tall or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.tall_radius then
				currentCheckpoint.tall_radius = RoundedValue(currentCheckpoint.tall_radius - 100.0, 3)
				if currentCheckpoint.tall_radius < 100.0 then
					currentCheckpoint.tall_radius = 1000.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif (onListChange) == "right" and currentCheckpoint.tall_radius then
				currentCheckpoint.tall_radius = RoundedValue(currentCheckpoint.tall_radius + 100.0, 3)
				if currentCheckpoint.tall_radius > 1000.0 then
					currentCheckpoint.tall_radius = 100.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Pit"), nil, currentCheckpoint.is_pit, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_pit = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Round"), nil, currentCheckpoint.is_round, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				if currentCheckpoint.is_random or currentCheckpoint.is_transform or currentCheckpoint.is_planeRot or currentCheckpoint.is_warp then
					DisplayCustomMsgs(GetTranslate("checkpoints-round-lock"))
				else
					currentCheckpoint.is_round = IsChecked
					if not IsChecked then
						currentCheckpoint.lock_dir = false
					end
					if isCheckpointPickedUp then
						if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
							currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
						elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
							currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
						end
						UpdateBlipForCreator("checkpoint")
						if inSession then
							modificationCount.checkpoints = modificationCount.checkpoints + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
						end
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Random"), nil, currentCheckpoint.is_random, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_random = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
					currentCheckpoint.random_class = 0
					currentCheckpoint.random_custom = nil
					currentCheckpoint.random_setting = nil
					currentCheckpoint.is_transform = nil
					currentCheckpoint.transform_index = nil
				else
					currentCheckpoint.random_class = nil
					currentCheckpoint.random_custom = nil
					currentCheckpoint.random_setting = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Random"), { (currentCheckpoint.random_class == 0 and GetTranslate("RandomClass-0")) or (currentCheckpoint.random_class == 1 and GetTranslate("RandomClass-1")) or (currentCheckpoint.random_class == 2 and GetTranslate("RandomClass-2")) or (currentCheckpoint.random_class == 3 and GetTranslate("RandomClass-3")) or (currentCheckpoint.random_class == -1 and GetTranslate("RandomClass-Custom")) or (currentCheckpoint.random_class == -2 and GetTranslate("RandomClass-Transform")) or (currentCheckpoint.random_class and "NULL") or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or not currentCheckpoint.is_random or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentCheckpoint.random_class = currentCheckpoint.random_class - 1
			elseif (onListChange) == "right" then
				currentCheckpoint.random_class = currentCheckpoint.random_class + 1
			end
			if (onListChange) then
				if currentCheckpoint.random_class < -2 then
					currentCheckpoint.random_class = 3
				elseif currentCheckpoint.random_class > 3 then
					currentCheckpoint.random_class = -2
				end
				if currentCheckpoint.random_class == -1 then
					currentCheckpoint.random_custom = 1
					currentCheckpoint.random_setting = "Compact"
				else
					currentCheckpoint.random_custom = nil
					currentCheckpoint.random_setting = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		if currentCheckpoint.is_random and not currentCheckpoint.is_transform then
			if currentCheckpoint.random_class == -1 and currentCheckpoint.random_custom then
				Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-ExtraRandomSetting"), { (currentCheckpoint.random_custom == 1 and GetTranslate("ExtraRandomSetting-1")) or (currentCheckpoint.random_custom == 2 and GetTranslate("ExtraRandomSetting-2")) or (currentCheckpoint.random_custom == 3 and GetTranslate("ExtraRandomSetting-3")) or (currentCheckpoint.random_custom == 4 and GetTranslate("ExtraRandomSetting-4")) or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
					if (onListChange) == "left" then
						currentCheckpoint.random_custom = currentCheckpoint.random_custom - 1
					elseif (onListChange) == "right" then
						currentCheckpoint.random_custom = currentCheckpoint.random_custom + 1
					end
					if (onListChange) then
						if currentCheckpoint.random_custom < 1 then
							currentCheckpoint.random_custom = 4
						elseif currentCheckpoint.random_custom > 4 then
							currentCheckpoint.random_custom = 1
						end
						if currentCheckpoint.random_custom == 1 then
							currentCheckpoint.random_setting = "Compact"
						elseif currentCheckpoint.random_custom == 2 then
							currentCheckpoint.random_setting = 1
						elseif currentCheckpoint.random_custom == 3 then
							currentCheckpoint.random_setting = {"bmx", "t20", "xa21"}
						elseif currentCheckpoint.random_custom == 4 then
							currentCheckpoint.random_setting = true
						end
						if isCheckpointPickedUp then
							if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
								currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
							elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
								currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
							end
							UpdateBlipForCreator("checkpoint")
							if inSession then
								modificationCount.checkpoints = modificationCount.checkpoints + 1
								TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
							end
						end
					end
				end)

				if currentCheckpoint.random_custom == 1 then
					Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-ExtraRandomSetting-1"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession, RightLabel = "→→→" }, function(onSelected)

					end, PlacementSubMenu_Checkpoints_ExtraRandomSetting)
				elseif currentCheckpoint.random_custom == 2 then
					Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-ExtraRandomSetting-2"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession, RightLabel = "→→→" }, function(onSelected)

					end, PlacementSubMenu_Checkpoints_ExtraRandomSetting)
				elseif currentCheckpoint.random_custom == 3 then
					Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-ExtraRandomSetting-3"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(onSelected)
						if (onSelected) then
							SetNuiFocus(true, true)
							SendNUIMessage({
								action = "open",
								value = currentCheckpoint.random_setting
							})
							nuiCallBack = "checkpoint random custom"
						end
					end)
				end
			end
		end

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Transform"), nil, currentCheckpoint.is_transform, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_transform = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
					currentCheckpoint.transform_index = 0
					currentCheckpoint.is_random = nil
					currentCheckpoint.random_class = nil
					currentCheckpoint.random_custom = nil
					currentCheckpoint.random_setting = nil
				else
					currentCheckpoint.transform_index = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		local vehName = ""
		if currentCheckpoint.is_transform and (#currentRace.transformVehicles > 0) then
			if currentRace.transformVehicles[currentCheckpoint.transform_index + 1] == -422877666 then
				vehName = GetTranslate("Transform-Parachute")
			elseif currentRace.transformVehicles[currentCheckpoint.transform_index + 1] == -731262150 then
				vehName = GetTranslate("Transform-Beast")
			elseif currentRace.transformVehicles[currentCheckpoint.transform_index + 1] == 0 then
				vehName = GetTranslate("Transform-Default")
			else
				local transform_vehicle = currentRace.transformVehicles[currentCheckpoint.transform_index + 1]
				local model = transform_vehicle and (tonumber(transform_vehicle) or GetHashKey(transform_vehicle)) or 0
				vehName = GetLabelText(GetDisplayNameFromVehicleModel(model))
			end
		elseif #currentRace.transformVehicles == 0 then
			vehName = "No Valid Vehicles"
		end
		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Transform"), { vehName }, 1, nil, { IsDisabled = global_var.IsNuiFocused or not currentCheckpoint.is_transform or (#currentRace.transformVehicles == 0) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentCheckpoint.transform_index = currentCheckpoint.transform_index - 1
			elseif (onListChange) == "right" then
				currentCheckpoint.transform_index = currentCheckpoint.transform_index + 1
			end
			if (onListChange) then
				if currentCheckpoint.transform_index < 0 then
					currentCheckpoint.transform_index = #currentRace.transformVehicles - 1
				elseif currentCheckpoint.transform_index > (#currentRace.transformVehicles - 1) then
					currentCheckpoint.transform_index = 0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		if not currentCheckpoint.is_random and currentCheckpoint.is_transform then
			Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Transform"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(onSelected)
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "open",
						value = currentRace.transformVehicles
					})
					nuiCallBack = "checkpoint transform vehicles"
				end
			end)
		end

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-PlaneRot"), nil, currentCheckpoint.is_planeRot, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_planeRot = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
					currentCheckpoint.plane_rot = 0
				else
					currentCheckpoint.plane_rot = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-PlaneRot"), { (currentCheckpoint.plane_rot == 0 and GetTranslate("PlaneRot-0")) or (currentCheckpoint.plane_rot == 1 and GetTranslate("PlaneRot-1")) or (currentCheckpoint.plane_rot == 2 and GetTranslate("PlaneRot-2")) or (currentCheckpoint.plane_rot == 3 and GetTranslate("PlaneRot-3")) or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or not currentCheckpoint.is_planeRot or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentCheckpoint.plane_rot = currentCheckpoint.plane_rot - 1
			elseif (onListChange) == "right" then
				currentCheckpoint.plane_rot = currentCheckpoint.plane_rot + 1
			end
			if (onListChange) then
				if currentCheckpoint.plane_rot < 0 then
					currentCheckpoint.plane_rot = 3
				elseif currentCheckpoint.plane_rot > 3 then
					currentCheckpoint.plane_rot = 0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Warp"), nil, currentCheckpoint.is_warp, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and (isCheckpointPickedUp or checkpointPreview) and not lockSession then
				currentCheckpoint.is_warp = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp) or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				local deleteIndex = checkpointIndex
				local success = false
				if global_var.isPrimaryCheckpointItems then
					if currentRace.checkpoints[deleteIndex] then
						success = true
						table.remove(currentRace.checkpoints, deleteIndex)
						local copy_checkpoints_2 = {}
						for k, v in pairs(currentRace.checkpoints_2) do
							if deleteIndex > k then
								copy_checkpoints_2[k] = v
							elseif deleteIndex < k then
								copy_checkpoints_2[k - 1] = v
							end
						end
						currentRace.checkpoints_2 = TableDeepCopy(copy_checkpoints_2)
						if checkpointIndex > #currentRace.checkpoints then
							checkpointIndex = #currentRace.checkpoints
						end
					end
				else
					success = true
					currentRace.checkpoints_2[deleteIndex] = nil
				end
				if success then
					isCheckpointPickedUp = false
					ResetGlobalVariable("currentCheckpoint")
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, deleteIndex = deleteIndex, isPrimaryCheckpoint = global_var.isPrimaryCheckpointItems, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Checkpoints_ExtraRandomSetting:IsVisible(function(Items)
		if currentCheckpoint.is_random and currentCheckpoint.random_class == -1 and currentCheckpoint.random_custom == 1 and type(currentCheckpoint.random_setting) == "string" then
			for i = 0, 22 do
				if vehicleClasses[i] then
					Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints_ExtraRandomSetting-CheckBox-" .. vehicleClasses[i]), nil, currentCheckpoint.random_setting == vehicleClasses[i], { Style = 1 }, function(onSelected, IsChecked)
						if (onSelected) and currentCheckpoint.random_setting ~= vehicleClasses[i] and IsChecked then
							currentCheckpoint.random_setting = vehicleClasses[i]
							if isCheckpointPickedUp then
								if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
									currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
								elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
									currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
								end
								UpdateBlipForCreator("checkpoint")
								if inSession then
									modificationCount.checkpoints = modificationCount.checkpoints + 1
									TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
								end
							end
						end
					end)
				end
			end
		elseif currentCheckpoint.is_random and currentCheckpoint.random_class == -1 and currentCheckpoint.random_custom == 2 and type(currentCheckpoint.random_setting) == "number" then
			for i = 0, 22 do
				if vehicleClasses[i] then
					Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints_ExtraRandomSetting-CheckBox-" .. vehicleClasses[i]), nil, IsBitSetValue(currentCheckpoint.random_setting, i), { Style = 1 }, function(onSelected, IsChecked)
						if (onSelected) then
							local random_setting = currentCheckpoint.random_setting
							if IsChecked then
								random_setting = SetBitValue(random_setting, i)
							else
								random_setting = ClearBitValue(random_setting, i)
							end
							if random_setting > 0 then
								currentCheckpoint.random_setting = random_setting
								if isCheckpointPickedUp then
									if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
										currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
									elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
										currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
									end
									UpdateBlipForCreator("checkpoint")
									if inSession then
										modificationCount.checkpoints = modificationCount.checkpoints + 1
										TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
									end
								end
							end
						end
					end)
				end
			end
		else
			RageUI.GoBack()
		end
	end, function(Panels)
	end)

	PlacementSubMenu_Props:IsVisible(function(Items)
		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-CycleItems"), { objectIndex .. " / " .. #currentRace.objects }, 1, nil, { IsDisabled = isPropSnappingEnable or #currentRace.objects == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = objectIndex - 1
				if index < 1 then
					index = #currentRace.objects
				elseif index > #currentRace.objects then
					index = 1
				end
				objectIndex = index
				isPropPickedUp = true
				if objectPreview then
					if objectPreview_effect then
						StopParticleFxLooped(objectPreview_effect, true)
						objectPreview_effect = nil
					end
					DeleteObject(objectPreview)
					objectPreview = nil
				end
				currentObject = currentRace.objects[objectIndex]
				global_var.propZposLock = currentObject.z
				globalRot.x = RoundedValue(currentObject.rotX, 3)
				globalRot.y = RoundedValue(currentObject.rotY, 3)
				globalRot.z = RoundedValue(currentObject.rotZ, 3)
				global_var.propColor = currentObject.color
				lastValidHash = currentObject.hash
				local found = false
				for k, v in pairs(category) do
					for i = 1, #v.model do
						local hash = tonumber(v.model[i]) or GetHashKey(v.model[i])
						if lastValidHash == hash then
							found = true
							lastValidText = v.model[i]
							v.index = i
							categoryIndex = k
							break
						end
					end
					if found then break end
				end
				if not found then
					local hash_2 = tonumber(lastValidText) or GetHashKey(lastValidText)
					if lastValidHash ~= hash_2 then
						lastValidText = tostring(lastValidHash) or ""
					end
				end
				local min, max = GetModelDimensionsInCaches(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20.0 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20.0 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			elseif (onListChange) == "right" then
				local index = objectIndex + 1
				if index < 1 then
					index = #currentRace.objects
				elseif index > #currentRace.objects then
					index = 1
				end
				objectIndex = index
				isPropPickedUp = true
				if objectPreview then
					if objectPreview_effect then
						StopParticleFxLooped(objectPreview_effect, true)
						objectPreview_effect = nil
					end
					DeleteObject(objectPreview)
					objectPreview = nil
				end
				currentObject = currentRace.objects[objectIndex]
				global_var.propZposLock = currentObject.z
				globalRot.x = RoundedValue(currentObject.rotX, 3)
				globalRot.y = RoundedValue(currentObject.rotY, 3)
				globalRot.z = RoundedValue(currentObject.rotZ, 3)
				global_var.propColor = currentObject.color
				lastValidHash = currentObject.hash
				local found = false
				for k, v in pairs(category) do
					for i = 1, #v.model do
						local hash = tonumber(v.model[i]) or GetHashKey(v.model[i])
						if lastValidHash == hash then
							found = true
							lastValidText = v.model[i]
							v.index = i
							categoryIndex = k
							break
						end
					end
					if found then break end
				end
				if not found then
					local hash_2 = tonumber(lastValidText) or GetHashKey(lastValidText)
					if lastValidHash ~= hash_2 then
						lastValidText = tostring(lastValidHash) or ""
					end
				end
				local min, max = GetModelDimensionsInCaches(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20.0 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20.0 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(objectIndex)
				})
				nuiCallBack = "goto prop"
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-EnterModelHash"), GetTranslate("PlacementSubMenu_Props-Button-EnterModelHash-Desc"), { IsDisabled = isPropPickedUp or global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				if objectPreview then
					if objectPreview_effect then
						StopParticleFxLooped(objectPreview_effect, true)
						objectPreview_effect = nil
					end
					DeleteObject(objectPreview)
					objectPreview = nil
					ResetGlobalVariable("currentObject")
				end
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = lastValidText or ""
				})
				nuiCallBack = "prop hash"
			end
		end)

		Items:AddList(string.format(GetTranslate("PlacementSubMenu_Props-List-Category"), categoryIndex, #category), { category[categoryIndex].class }, 1, nil, { IsDisabled = isPropPickedUp or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				categoryIndex = categoryIndex - 1
				if categoryIndex < 1 then
					categoryIndex = #category
				end
				if objectPreview then
					if objectPreview_effect then
						StopParticleFxLooped(objectPreview_effect, true)
						objectPreview_effect = nil
					end
					DeleteObject(objectPreview)
					objectPreview = nil
					ResetGlobalVariable("currentObject")
				end
				lastValidHash = nil
				global_var.propColor = nil
			elseif (onListChange) == "right" then
				categoryIndex = categoryIndex + 1
				if categoryIndex > #category then
					categoryIndex = 1
				end
				if objectPreview then
					if objectPreview_effect then
						StopParticleFxLooped(objectPreview_effect, true)
						objectPreview_effect = nil
					end
					DeleteObject(objectPreview)
					objectPreview = nil
					ResetGlobalVariable("currentObject")
				end
				lastValidHash = nil
				global_var.propColor = nil
			end
		end)

		Items:AddList(string.format(GetTranslate("PlacementSubMenu_Props-List-Model"), category[categoryIndex].index, #category[categoryIndex].model), category[categoryIndex].model, category[categoryIndex].index, nil, { IsDisabled = isPropPickedUp or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				category[categoryIndex].index = Index
			end
			if (onSelected) or (onListChange) then
				if objectPreview then
					if objectPreview_effect then
						StopParticleFxLooped(objectPreview_effect, true)
						objectPreview_effect = nil
					end
					DeleteObject(objectPreview)
					objectPreview = nil
					ResetGlobalVariable("currentObject")
				end
				lastValidHash = nil
				global_var.propColor = nil
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Place"), nil, { IsDisabled = (isPropSnappingEnable and not snappingObject.handle) or not currentObject.handle or isPropPickedUp or (not isPropPickedUp and not objectPreview) or global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				if objectPreview_effect then
					StopParticleFxLooped(objectPreview_effect, true)
					objectPreview_effect = nil
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				local object = currentObject
				object.handle = nil
				local gx = math.floor(object.x / 100.0)
				local gy = math.floor(object.y / 100.0)
				objectPool.grids[gx] = objectPool.grids[gx] or {}
				objectPool.grids[gx][gy] = objectPool.grids[gx][gy] or {}
				if TableCount(objectPool.grids[gx][gy]) < 300 then
					objectPool.grids[gx][gy][object.uniqueId] = object
					objectPool.all[object.uniqueId] = gx .. "-" .. gy
					if effectObjects[object.hash] then
						objectPool.effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = effectObjects[object.hash]}
					end
					currentRace.objects[#currentRace.objects + 1] = object
					if isPropSnappingEnable and not isPropSnappingWithSphericalMode then
						snappingObject.handle = nil
						snappingObject.object = nil
						snappingObject.nextObject = object.uniqueId
					end
					if inSession then
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-place")
					end
					objectIndex = #currentRace.objects
				else
					DisplayCustomMsgs(GetTranslate("300-limit"))
				end
				globalRot.x = RoundedValue(currentObject.rotX, 3)
				globalRot.y = RoundedValue(currentObject.rotY, 3)
				globalRot.z = RoundedValue(currentObject.rotZ, 3)
				global_var.propColor = currentObject.color
				ResetGlobalVariable("currentObject")
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Snapping"), nil, isPropSnappingEnable, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
				isPropSnappingEnable = IsChecked
				if isPropSnappingEnable then
					if isPropPickedUp then
						isPropPickedUp = false
						ResetGlobalVariable("currentObject")
					end
				else
					if snappingObject.handle then
						snappingObject.handle = nil
						snappingObject.object = nil
					end
				end
				snappingObject.nextObject = nil
			end
		end)

		if isPropSnappingEnable then
			if snappingObject.handle then
				if snappingObject.boneIndexParent > GetEntityBoneCount(snappingObject.handle) - 1 then
					snappingObject.boneIndexParent = -1
				end
			end
			if currentObject.handle then
				if snappingObject.boneIndexChild > GetEntityBoneCount(currentObject.handle) - 1 then
					snappingObject.boneIndexChild = -1
				end
			end
			Items:AddList(GetTranslate("PlacementSubMenu_Props-List-BoneIndexParent"), { snappingObject.handle and GetBoneNameFromIndex(snappingObject.handle, snappingObject.boneIndexParent) or "" }, 1, nil, { IsDisabled = not snappingObject.handle or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
				if (onListChange) == "left" then
					local index = snappingObject.boneIndexParent
					index = index - 1
					if index < -27 then
						index = GetEntityBoneCount(snappingObject.handle) - 1
					end
					snappingObject.boneIndexParent = index
					SetObjectNewPositionAndRotationEnhanced()
				elseif (onListChange) == "right" then
					local index = snappingObject.boneIndexParent
					index = index + 1
					if index > GetEntityBoneCount(snappingObject.handle) - 1 then
						index = -27
					end
					snappingObject.boneIndexParent = index
					SetObjectNewPositionAndRotationEnhanced()
				end
			end)

			Items:AddList(GetTranslate("PlacementSubMenu_Props-List-BoneIndexChild"), { currentObject.handle and GetBoneNameFromIndex(currentObject.handle, snappingObject.boneIndexChild) or "" }, 1, nil, { IsDisabled = not currentObject.handle or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
				if (onListChange) == "left" then
					local index = snappingObject.boneIndexChild
					index = index - 1
					if index < -27 then
						index = GetEntityBoneCount(currentObject.handle) - 1
					end
					snappingObject.boneIndexChild = index
					SetObjectNewPositionAndRotationEnhanced()
				elseif (onListChange) == "right" then
					local index = snappingObject.boneIndexChild
					index = index + 1
					if index > GetEntityBoneCount(currentObject.handle) - 1 then
						index = -27
					end
					snappingObject.boneIndexChild = index
					SetObjectNewPositionAndRotationEnhanced()
				end
			end)

			Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Spherical"), nil, isPropSnappingWithSphericalMode, { Style = 1 }, function(onSelected, IsChecked)
				if (onSelected) and not global_var.IsNuiFocused and not lockSession then
					isPropSnappingWithSphericalMode = IsChecked
					snappingObject.nextObject = nil
				end
			end)

			Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Reset"), nil, { IsDisabled = false }, function(onSelected)
				if (onSelected) then
					snappingObject.offset.steps = {}
					snappingObject.offset.x = 0.0
					snappingObject.offset.y = 0.0
					snappingObject.offset.z = 0.0
					snappingObject.offset.rotX = 0.0
					snappingObject.offset.rotY = 0.0
					snappingObject.offset.rotZ = 0.0
					SetObjectNewPositionAndRotationEnhanced()
				end
			end)
		else
			Items:AddList(GetTranslate("PlacementSubMenu_Props-List-Alignment"), { isPropOverrideRelativeEnable and GetTranslate("PlacementSubMenu_Props-List-Alignment-Relative") or GetTranslate("PlacementSubMenu_Props-List-Alignment-World") }, 1, nil, { IsDisabled = not currentObject.handle or not currentObject.x or not currentObject.y or not currentObject.z or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
				if (onListChange) then
					isPropOverrideRelativeEnable = not isPropOverrideRelativeEnable
				end
			end)

			if isPropOverrideRelativeEnable then
				if currentObject.handle then
					if propOverrideRotIndex > GetEntityBoneCount(currentObject.handle) - 1 then
						propOverrideRotIndex = -1
					end
				end
				Items:AddList(GetTranslate("PlacementSubMenu_Props-List-AlignmentEnhanced"), { currentObject.handle and GetBoneNameFromIndex(currentObject.handle, propOverrideRotIndex) or "" }, 1, nil, { IsDisabled = not currentObject.handle or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
					if (onListChange) == "left" then
						local index = propOverrideRotIndex
						index = index - 1
						if index < -27 then
							index = GetEntityBoneCount(currentObject.handle) - 1
						end
						propOverrideRotIndex = index
					elseif (onListChange) == "right" then
						local index = propOverrideRotIndex
						index = index + 1
						if index > GetEntityBoneCount(currentObject.handle) - 1 then
							index = -27
						end
						propOverrideRotIndex = index
					end
				end)
			end
		end

		isPropSnappingCanInsertData = false

		local lists = {
			{label = "X", key = "x"},
			{label = "Y", key = "y"},
			{label = "Z", key = "z"},
			{label = "Rot X", key = "rotX"},
			{label = "Rot Y", key = "rotY"},
			{label = "Rot Z", key = "rotZ"}
		}
		for i = 1, #lists do
			Items:AddList(isPropSnappingEnable and (GetTranslate("PlacementSubMenu_Props-List-Offset") .. " " .. lists[i].label .. ":") or (lists[i].label .. ":"), { (isPropSnappingEnable and snappingObject.handle and currentObject.handle and snappingObject.offset[lists[i].key]) or (not isPropSnappingEnable and currentObject.handle and currentObject[lists[i].key]) or "" }, 1, nil, { IsDisabled = (isPropSnappingEnable and (not snappingObject.handle or not currentObject.handle)) or (not isPropSnappingEnable and (not currentObject.handle or not currentObject[lists[i].key])) or global_var.IsNuiFocused or lockSession}, function(Index, onSelected, onListChange)
				if isPropSnappingEnable then
					if (onListChange) then
						local stepIndex = #snappingObject.offset.steps
						if stepIndex > 0 and snappingObject.offset.steps[stepIndex].axis == lists[i].key and snappingObject.offset.steps[stepIndex].sphericalMode == isPropSnappingWithSphericalMode then
							local value = snappingObject.offset.steps[stepIndex].value + ((onListChange) == "left" and -speed.prop_offset.value[speed.prop_offset.index][2] or speed.prop_offset.value[speed.prop_offset.index][2])
							if value ~= 0.0 then
								snappingObject.offset.steps[stepIndex].value = value
							else
								snappingObject.offset.steps[stepIndex] = nil
							end
						else
							snappingObject.offset.steps[stepIndex + 1] = {axis = lists[i].key, value = (onListChange) == "left" and -speed.prop_offset.value[speed.prop_offset.index][2] or speed.prop_offset.value[speed.prop_offset.index][2], sphericalMode = isPropSnappingWithSphericalMode}
						end
						GetObjectOffsetPositionAndRotation()
						SetObjectNewPositionAndRotationEnhanced()
					end
					if not isPropPickedUp and objectPreview then
						isPropSnappingCanInsertData = true
						if (onSelected) then
							if objectPreview_effect then
								StopParticleFxLooped(objectPreview_effect, true)
								objectPreview_effect = nil
							end
							DeleteObject(objectPreview)
							objectPreview = nil
							local object = currentObject
							object.handle = nil
							local gx = math.floor(object.x / 100.0)
							local gy = math.floor(object.y / 100.0)
							objectPool.grids[gx] = objectPool.grids[gx] or {}
							objectPool.grids[gx][gy] = objectPool.grids[gx][gy] or {}
							if TableCount(objectPool.grids[gx][gy]) < 300 then
								objectPool.grids[gx][gy][object.uniqueId] = object
								objectPool.all[object.uniqueId] = gx .. "-" .. gy
								if effectObjects[object.hash] then
									objectPool.effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = effectObjects[object.hash]}
								end
								currentRace.objects[#currentRace.objects + 1] = object
								if not isPropSnappingWithSphericalMode then
									snappingObject.handle = nil
									snappingObject.object = nil
									snappingObject.nextObject = object.uniqueId
								end
								if inSession then
									TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-place")
								end
								objectIndex = #currentRace.objects
							else
								DisplayCustomMsgs(GetTranslate("300-limit"))
							end
							globalRot.x = RoundedValue(currentObject.rotX, 3)
							globalRot.y = RoundedValue(currentObject.rotY, 3)
							globalRot.z = RoundedValue(currentObject.rotZ, 3)
							global_var.propColor = currentObject.color
							ResetGlobalVariable("currentObject")
						end
					end
				else
					if (onListChange) then
						local old_x = currentObject.x
						local old_y = currentObject.y
						local old_z = currentObject.z
						if not isPropOverrideRelativeEnable then
							local newValue = RoundedValue(currentObject[lists[i].key] + ((onListChange) == "left" and -speed.prop_offset.value[speed.prop_offset.index][2] or speed.prop_offset.value[speed.prop_offset.index][2]), 3)
							if i == 1 or i == 2 then
								if (newValue > -16000.0) and (newValue < 16000.0) then
									currentObject[lists[i].key] = newValue
									SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
								else
									DisplayCustomMsgs(GetTranslate("xy-limit"))
								end
							elseif i == 3 then
								if (newValue > -200.0) and (newValue < 2700.0) then
									currentObject[lists[i].key] = newValue
									SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
								else
									DisplayCustomMsgs(GetTranslate("z-limit"))
								end
							else
								if (newValue > -9999.0) and (newValue < 9999.0) then
									currentObject[lists[i].key] = newValue
									SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
								else
									DisplayCustomMsgs(GetTranslate("rot-limit"))
								end
							end
						else
							SetObjectNewPositionAndRotation(lists[i].key, (onListChange) == "left" and -speed.prop_offset.value[speed.prop_offset.index][2] or speed.prop_offset.value[speed.prop_offset.index][2])
						end
						if old_z ~= currentObject.z then
							objectPreview_coords_change = true
							global_var.propZposLock = currentObject.z
						elseif old_x ~= currentObject.x or old_y ~= currentObject.y then
							objectPreview_coords_change = true
						end
						if isPropPickedUp then
							if inSession then
								currentObject.modificationCount = currentObject.modificationCount + 1
								TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
							end
							globalRot.x = RoundedValue(currentObject.rotX, 3)
							globalRot.y = RoundedValue(currentObject.rotY, 3)
							globalRot.z = RoundedValue(currentObject.rotZ, 3)
							RefreshGirdForObject(old_x, old_y, currentObject)
						end
					end
					if (onSelected) then
						objectPreview_coords_change = true
						SetNuiFocus(true, true)
						SendNUIMessage({
							action = "open",
							value = tostring(currentObject[lists[i].key])
						})
						nuiCallBack = "prop " .. lists[i].key
					end
				end
			end)
		end

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-ChangeSpeed"), { speed.prop_offset.value[speed.prop_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = speed.prop_offset.index - 1
				if index < 1 then
					index = #speed.prop_offset.value
				end
				speed.prop_offset.index = index
			elseif (onListChange) == "right" then
				local index = speed.prop_offset.index + 1
				if index > #speed.prop_offset.value then
					index = 1
				end
				speed.prop_offset.index = index
			end
		end)

		if not isPropSnappingEnable then
			Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Override"), nil, { IsDisabled = not currentObject.handle or global_var.IsNuiFocused or (not isPropPickedUp and not objectPreview) or lockSession }, function(onSelected)
				if (onSelected) then
					objectPreview_coords_change = true
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "open",
						value = "x = " .. (currentObject.x) .. ", y = " .. (currentObject.y) .. ", z = " .. (currentObject.z) .. ", rotX = " .. (currentObject.rotX) .. ", rotY = " .. (currentObject.rotY) .. ", rotZ = " .. (currentObject.rotZ)
					})
					nuiCallBack = "prop override"
				end
			end)
		end

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-Color"), { currentObject.handle and currentObject.color or "" }, 1, nil, { IsDisabled = not currentObject.handle or not currentObject.color or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentObject.color = currentObject.color - 1
				if currentObject.color < 0 then
					currentObject.color = 15
				end
				SetObjectTextureVariation(currentObject.handle, currentObject.color)
				if isPropPickedUp then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					global_var.propColor = currentObject.color
				end
			elseif (onListChange) == "right" then
				currentObject.color = currentObject.color + 1
				if currentObject.color > 15 then
					currentObject.color = 0
				end
				SetObjectTextureVariation(currentObject.handle, currentObject.color)
				if isPropPickedUp then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					global_var.propColor = currentObject.color
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Visible"), nil, currentObject.visible, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and currentObject.handle and not lockSession then
				if currentObject.dynamic then
					DisplayCustomMsgs(GetTranslate("visible-dynamic"))
				else
					currentObject.visible = IsChecked
					if IsChecked then
						ResetEntityAlpha(currentObject.handle)
					else
						SetEntityAlpha(currentObject.handle, 150)
					end
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Collision"), nil, currentObject.collision, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and currentObject.handle and not lockSession then
				currentObject.collision = IsChecked
				if IsChecked then
					SetEntityCollision(currentObject.handle, true, true)
				else
					SetEntityCollision(currentObject.handle, false, false)
				end
				if isPropPickedUp then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Dynamic"), nil, currentObject.dynamic, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and currentObject.handle and not lockSession then
				currentObject.dynamic = IsChecked
				if IsChecked then
					if not currentObject.visible then
						ResetEntityAlpha(currentObject.handle)
						currentObject.visible = true
						DisplayCustomMsgs(GetTranslate("visible-dynamic"))
					end
					currentObject.prpsba = 2
				end
				if isPropPickedUp then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
				end
			end
		end)

		if currentObject.hash and speedUpObjects[currentObject.hash] and not currentObject.dynamic then
			Items:AddList(GetTranslate("PlacementSubMenu_Props-List-SpeedPad"), { currentObject.handle and ((currentObject.prpsba == 1 and GetTranslate("SpeedUp-1")) or (currentObject.prpsba == 2 and GetTranslate("SpeedUp-2")) or (currentObject.prpsba == 3 and GetTranslate("SpeedUp-3")) or (currentObject.prpsba == 4 and GetTranslate("SpeedUp-4")) or (currentObject.prpsba == 5 and GetTranslate("SpeedUp-5"))) or "" }, 1, nil, { IsDisabled = not currentObject.handle or not currentObject.prpsba or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
				if (onListChange) == "left" then
					currentObject.prpsba = currentObject.prpsba - 1
					if currentObject.prpsba < 1 then
						currentObject.prpsba = 5
					end
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
					end
				elseif (onListChange) == "right" then
					currentObject.prpsba = currentObject.prpsba + 1
					if currentObject.prpsba > 5 then
						currentObject.prpsba = 1
					end
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
					end
				end
			end)
		end

		if currentObject.hash and slowDownObjects[currentObject.hash] and not currentObject.dynamic then
			Items:AddList(GetTranslate("PlacementSubMenu_Props-List-DragPad"), { currentObject.handle and ((currentObject.prpsba == 1 and GetTranslate("SpeedUp-1")) or (currentObject.prpsba == 2 and GetTranslate("SpeedUp-2")) or (currentObject.prpsba == 3 and GetTranslate("SpeedUp-3"))) or "" }, 1, nil, { IsDisabled = not currentObject.handle or not currentObject.prpsba or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
				if (onListChange) == "left" then
					currentObject.prpsba = currentObject.prpsba - 1
					if currentObject.prpsba < 1 then
						currentObject.prpsba = 3
					end
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
					end
				elseif (onListChange) == "right" then
					currentObject.prpsba = currentObject.prpsba + 1
					if currentObject.prpsba > 3 then
						currentObject.prpsba = 1
					end
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
					end
				end
			end)
		end

		isPropDeleteItemActive = false
		if not isPropSnappingEnable then
			Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isPropPickedUp) or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
				isPropDeleteItemActive = true
				if (onSelected) and currentObject.uniqueId then
					if inSession then
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-delete")
					end
					isPropPickedUp = false
					for k, v in pairs(currentRace.objects) do
						if v.uniqueId == currentObject.uniqueId then
							table.remove(currentRace.objects, k)
							break
						end
					end
					objectPool.all[currentObject.uniqueId] = nil
					objectPool.effects[currentObject.uniqueId] = nil
					for uniqueId, effectData in pairs(objectPool.activeEffects) do
						if uniqueId == currentObject.uniqueId then
							if effectData.ptfxHandle then
								StopParticleFxLooped(effectData.ptfxHandle, true)
								effectData.ptfxHandle = nil
							end
							objectPool.activeEffects[uniqueId] = nil
							break
						end
					end
					for uniqueId, object in pairs(objectPool.activeObjects) do
						if uniqueId == currentObject.uniqueId then
							if object.handle then
								DeleteObject(object.handle)
								object.handle = nil
							end
							objectPool.activeObjects[uniqueId] = nil
							break
						end
					end
					local gx = math.floor(currentObject.x / 100.0)
					local gy = math.floor(currentObject.y / 100.0)
					if objectPool.grids[gx] and objectPool.grids[gx][gy] then
						objectPool.grids[gx][gy][currentObject.uniqueId] = nil
					end
					if objectIndex > #currentRace.objects then
						objectIndex = #currentRace.objects
					end
					ResetGlobalVariable("currentObject")
				end
			end)
		end
	end, function(Panels)
	end)

	PlacementSubMenu_Templates:IsVisible(function(Items)
		Items:AddList(GetTranslate("PlacementSubMenu_Templates-List-Templates"), { templateIndex .. " / " .. #templates }, 1, nil, { IsDisabled = (#currentTemplate > 0) or (#templates == 0) or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				templateIndex = templateIndex - 1
				if templateIndex < 1 then
					templateIndex = #templates
				end
				if #templatePreview > 0 then
					for i = 1, #templatePreview do
						DeleteObject(templatePreview[i].handle)
					end
					templatePreview = {}
				end
			elseif (onListChange) == "right" then
				templateIndex = templateIndex + 1
				if templateIndex > #templates then
					templateIndex = 1
				end
				if #templatePreview > 0 then
					for i = 1, #templatePreview do
						DeleteObject(templatePreview[i].handle)
					end
					templatePreview = {}
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate"), (#templates >= 30) and GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate-Desc") or nil, { IsDisabled = (#currentTemplate <= 1) or global_var.IsNuiFocused or (#templates >= 30) or lockSession }, function(onSelected)
			if (onSelected) then
				for i = 1, #currentTemplate do
					if DoesEntityExist(currentTemplate[i].handle) then
						SetEntityDrawOutline(currentTemplate[i].handle, false)
					end
				end
				TriggerServerEvent("custom_creator:server:saveData", {template = TableDeepCopy(currentTemplate)})
				table.insert(templates, TableDeepCopy(currentTemplate))
				templateIndex = #templates
				isTemplatePropPickedUp = false
				ResetGlobalVariable("currentTemplate")
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-PlaceTemplate"), nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				if not isTemplatePropPickedUp then
					local invalidX = false
					local invalidY = false
					local invalidZ = false
					local invalidRot = false
					local maxLimit = false
					local validObjects = {}
					for i = 1, #templatePreview do
						DeleteObject(templatePreview[i].handle)
						templatePreview[i].handle = nil
						local gx = math.floor(templatePreview[i].x / 100.0)
						local gy = math.floor(templatePreview[i].y / 100.0)
						objectPool.grids[gx] = objectPool.grids[gx] or {}
						objectPool.grids[gx][gy] = objectPool.grids[gx][gy] or {}
						if TableCount(objectPool.grids[gx][gy]) < 300 then
							local overflow = false
							if (templatePreview[i].x <= -16000.0) or (templatePreview[i].x >= 16000.0) then
								overflow = true
								invalidX = true
							end
							if (templatePreview[i].y <= -16000.0) or (templatePreview[i].y >= 16000.0) then
								overflow = true
								invalidY = true
							end
							if (templatePreview[i].z <= -200.0) or (templatePreview[i].z >= 2700.0) then
								overflow = true
								invalidZ = true
							end
							if (templatePreview[i].rotX <= -9999.0) or (templatePreview[i].rotX >= 9999.0) or (templatePreview[i].rotY <= -9999.0) or (templatePreview[i].rotY >= 9999.0) or (templatePreview[i].rotZ <= -9999.0) or (templatePreview[i].rotZ >= 9999.0) then
								overflow = true
								invalidRot = true
							end
							if not overflow then
								objectPool.grids[gx][gy][templatePreview[i].uniqueId] = templatePreview[i]
								objectPool.all[templatePreview[i].uniqueId] = gx .. "-" .. gy
								if effectObjects[templatePreview[i].hash] then
									objectPool.effects[templatePreview[i].uniqueId] = {ptfxHandle = nil, object = templatePreview[i], style = effectObjects[templatePreview[i].hash]}
								end
								currentRace.objects[#currentRace.objects + 1] = templatePreview[i]
								table.insert(validObjects, templatePreview[i])
							end
						else
							maxLimit = true
						end
					end
					if #validObjects >= 1 then
						if inSession then
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, validObjects, "template-place")
						end
						objectIndex = #currentRace.objects
					end
					if invalidX or invalidY then
						DisplayCustomMsgs(GetTranslate("xy-limit"))
					end
					if invalidZ then
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
					if invalidRot then
						DisplayCustomMsgs(GetTranslate("rot-limit"))
					end
					if maxLimit then
						DisplayCustomMsgs(GetTranslate("300-limit"))
					end
					templatePreview = {}
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Templates-List-Alignment"), { isTemplateOverrideRelativeEnable and GetTranslate("PlacementSubMenu_Templates-List-Alignment-Relative") or GetTranslate("PlacementSubMenu_Templates-List-Alignment-World") }, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				isTemplateOverrideRelativeEnable = not isTemplateOverrideRelativeEnable
			end
		end)

		local lists = {
			{label = "X", key = "x"},
			{label = "Y", key = "y"},
			{label = "Z", key = "z"},
			{label = "Rot X", key = "rotX"},
			{label = "Rot Y", key = "rotY"},
			{label = "Rot Z", key = "rotZ"}
		}
		for i = 1, #lists do
			Items:AddList(lists[i].label .. ":", { templatePreview[1] and templatePreview[1][lists[i].key] or "" }, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
				if (onListChange) then
					if not isTemplateOverrideRelativeEnable then
						local newValue = RoundedValue(templatePreview[1][lists[i].key] + ((onListChange) == "left" and -speed.template_offset.value[speed.template_offset.index][2] or speed.template_offset.value[speed.template_offset.index][2]), 3)
						if i == 1 then
							if (newValue > -16000.0) and (newValue < 16000.0) then
								local aPos_new, aRot_new = vector3(newValue, templatePreview[1].y, templatePreview[1].z), vector3(templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ)
								local aQuat_new = RotationToQuaternion(aRot_new)
								SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
							else
								DisplayCustomMsgs(GetTranslate("xy-limit"))
							end
						elseif i == 2 then
							if (newValue > -16000.0) and (newValue < 16000.0) then
								local aPos_new, aRot_new = vector3(templatePreview[1].x, newValue, templatePreview[1].z), vector3(templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ)
								local aQuat_new = RotationToQuaternion(aRot_new)
								SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
							else
								DisplayCustomMsgs(GetTranslate("xy-limit"))
							end
						elseif i == 3 then
							if (newValue > -200.0) and (newValue < 2700.0) then
								local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, newValue), vector3(templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ)
								local aQuat_new = RotationToQuaternion(aRot_new)
								SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
							else
								DisplayCustomMsgs(GetTranslate("z-limit"))
							end
						else
							if (newValue > -9999.0) and (newValue < 9999.0) then
								if i == 4 then
									local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, templatePreview[1].z), vector3(newValue, templatePreview[1].rotY, templatePreview[1].rotZ)
									local aQuat_new = RotationToQuaternion(aRot_new)
									SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
								elseif i == 5 then
									local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, templatePreview[1].z), vector3(templatePreview[1].rotX, newValue, templatePreview[1].rotZ)
									local aQuat_new = RotationToQuaternion(aRot_new)
									SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
								elseif i == 6 then
									local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, templatePreview[1].z), vector3(templatePreview[1].rotX, templatePreview[1].rotY, newValue)
									local aQuat_new = RotationToQuaternion(aRot_new)
									SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
								end
							else
								DisplayCustomMsgs(GetTranslate("rot-limit"))
							end
						end
					else
						local aPos_new, aQuat_new = UpdatePositionAndQuaternionForSingleAxis(vector3(templatePreview[1].x, templatePreview[1].y, templatePreview[1].z), RotationToQuaternion(vector3(templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ)), lists[i].key, (onListChange) == "left" and -speed.template_offset.value[speed.template_offset.index][2] or speed.template_offset.value[speed.template_offset.index][2])
						SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
					end
					global_var.templateZposLock = templatePreview[1].z
				end
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "open",
						value = tostring(templatePreview[1] and templatePreview[1][lists[i].key])
					})
					nuiCallBack = "template " .. lists[i].key
				end
				if (onListChange) or (onSelected) then
					templatePreview_coords_change = true
					for j = 1, #templatePreview do
						if templatePreview[j].collision then
							SetEntityCollision(templatePreview[j].handle, true, true)
						end
					end
				end
			end)
		end

		Items:AddList(GetTranslate("PlacementSubMenu_Templates-List-ChangeSpeed"), { speed.template_offset.value[speed.template_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = speed.template_offset.index - 1
				if index < 1 then
					index = #speed.template_offset.value
				end
				speed.template_offset.index = index
			elseif (onListChange) == "right" then
				local index = speed.template_offset.index + 1
				if index > #speed.template_offset.value then
					index = 1
				end
				speed.template_offset.index = index
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-Override"), nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = "x = " .. (templatePreview[1] and templatePreview[1].x) .. ", y = " .. (templatePreview[1] and templatePreview[1].y) .. ", z = " .. (templatePreview[1] and templatePreview[1].z) .. ", rotX = " .. (templatePreview[1] and templatePreview[1].rotX) .. ", rotY = " .. (templatePreview[1] and templatePreview[1].rotY) .. ", rotZ = " .. (templatePreview[1] and templatePreview[1].rotZ)
				})
				nuiCallBack = "template override"
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-Delete"), nil, { IsDisabled = (#currentTemplate > 0) or (#templates == 0) or global_var.IsNuiFocused or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				if #templatePreview > 0 then
					for i = 1, #templatePreview do
						DeleteObject(templatePreview[i].handle)
					end
					templatePreview = {}
				end
				if templates[templateIndex] then
					TriggerServerEvent("custom_creator:server:saveData", {template = templateIndex})
					table.remove(templates, templateIndex)
				end
				if templateIndex > #templates then
					templateIndex = #templates
				end
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_MoveAll:IsVisible(function(Items)
		local lists = {
			{label = "X", key = "x"},
			{label = "Y", key = "y"},
			{label = "Z", key = "z"}
		}
		for i = 1, #lists do
			Items:AddList(lists[i].label .. ":", { "" }, 1, nil, { IsDisabled = lockSession }, function(Index, onSelected, onListChange)
				if (onListChange) then
					local overflow = false
					local value = (onListChange) == "left" and -speed.move_offset.value[speed.move_offset.index][2] or speed.move_offset.value[speed.move_offset.index][2]
					for k, v in pairs(currentRace.startingGrid) do
						if not IsValueValid(i, RoundedValue(v[lists[i].key] + value, 3)) then
							overflow = true
							break
						end
					end
					if not overflow then
						for k, v in pairs(currentRace.checkpoints) do
							if not IsValueValid(i, RoundedValue(v[lists[i].key] + value, 3)) then
								overflow = true
								break
							end
							local v_2 = currentRace.checkpoints_2[k]
							if v_2 then
								if not IsValueValid(i, RoundedValue(v_2[lists[i].key] + value, 3)) then
									overflow = true
									break
								end
							end
						end
					end
					if not overflow then
						for k, v in pairs(currentRace.objects) do
							if not IsValueValid(i, RoundedValue(v[lists[i].key] + value, 3)) then
								overflow = true
								break
							end
						end
					end
					if not overflow then
						for k, v in pairs(currentRace.startingGrid) do
							v[lists[i].key] = RoundedValue(v[lists[i].key] + value, 3)
						end
						for k, v in pairs(currentRace.checkpoints) do
							v[lists[i].key] = RoundedValue(v[lists[i].key] + value, 3)
							local v_2 = currentRace.checkpoints_2[k]
							if v_2 then
								v_2[lists[i].key] = RoundedValue(v_2[lists[i].key] + value, 3)
							end
						end
						UpdateBlipForCreator("checkpoint")
						for k, v in pairs(currentRace.objects) do
							v[lists[i].key] = RoundedValue(v[lists[i].key] + value, 3)
							if v.handle then
								SetEntityCoordsNoOffset(v.handle, v.x, v.y, v.z)
							end
						end
						if inSession then
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { offset_x = i == 1 and value or 0.0, offset_y = i == 2 and value or 0.0, offset_z = i == 3 and value or 0.0 }, "move-all")
						end
					else
						if i == 1 or i == 2 then
							DisplayCustomMsgs(GetTranslate("xy-limit"))
						elseif i == 3 then
							DisplayCustomMsgs(GetTranslate("z-limit"))
						end
					end
				end
			end)
		end

		Items:AddList(GetTranslate("PlacementSubMenu_MoveAll-List-ChangeSpeed"), { speed.move_offset.value[speed.move_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = speed.move_offset.index - 1
				if index < 1 then
					index = #speed.move_offset.value
				end
				speed.move_offset.index = index
			elseif (onListChange) == "right" then
				local index = speed.move_offset.index + 1
				if index > #speed.move_offset.value then
					index = 1
				end
				speed.move_offset.index = index
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_FixtureRemover:IsVisible(function(Items)
		local selectFixtureAvailable = false
		local deselectFixtureAvailable = false
		local foundFixture = false
		if currentFixture.handle then
			for k, v in pairs(currentRace.fixtures) do
				if v.hash == currentFixture.hash then
					foundFixture = true
					break
				end
			end
		end
		if not foundFixture then
			selectFixtureAvailable = true
		else
			deselectFixtureAvailable = true
		end
		Items:AddList(GetTranslate("PlacementSubMenu_FixtureRemover-List-CycleItems"), { fixtureIndex .. " / " .. #currentRace.fixtures }, 1, nil, { IsDisabled = #currentRace.fixtures == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = fixtureIndex - 1
				if index < 1 then
					index = #currentRace.fixtures
				elseif index > #currentRace.fixtures then
					index = 1
				end
				fixtureIndex = index
				currentFixture = TableDeepCopy(currentRace.fixtures[fixtureIndex])
				local min, max = GetModelDimensionsInCaches(currentFixture.hash)
				cameraPosition = vector3(currentFixture.x, currentFixture.y, currentFixture.z + (10.0 + max.z - min.z))
				cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
			elseif (onListChange) == "right" then
				local index = fixtureIndex + 1
				if index < 1 then
					index = #currentRace.fixtures
				elseif index > #currentRace.fixtures then
					index = 1
				end
				fixtureIndex = index
				currentFixture = TableDeepCopy(currentRace.fixtures[fixtureIndex])
				local min, max = GetModelDimensionsInCaches(currentFixture.hash)
				cameraPosition = vector3(currentFixture.x, currentFixture.y, currentFixture.z + (10.0 + max.z - min.z))
				cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
			end
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "open",
					value = tostring(fixtureIndex)
				})
				nuiCallBack = "goto fixture"
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_FixtureRemover-Button-Select"), nil, { IsDisabled = global_var.IsNuiFocused or not currentFixture.handle or not selectFixtureAvailable or lockSession }, function(onSelected)
			if (onSelected) then
				table.insert(currentRace.fixtures, TableDeepCopy(currentFixture))
				fixtureIndex = #currentRace.fixtures
				if inSession then
					modificationCount.fixtures = modificationCount.fixtures + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { fixtures = currentRace.fixtures, modificationCount = modificationCount.fixtures }, "fixtures-sync")
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_FixtureRemover-Button-Deselect"), nil, { IsDisabled = global_var.IsNuiFocused or not currentFixture.handle or not deselectFixtureAvailable or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				for k, v in pairs(currentRace.fixtures) do
					if v.hash == currentFixture.hash then
						table.remove(currentRace.fixtures, k)
						break
					end
				end
				if fixtureIndex > #currentRace.fixtures then
					fixtureIndex = #currentRace.fixtures
				end
				if inSession then
					modificationCount.fixtures = modificationCount.fixtures + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { fixtures = currentRace.fixtures, modificationCount = modificationCount.fixtures }, "fixtures-sync")
				end
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Firework:IsVisible(function(Items)
		Items:AddList(GetTranslate("PlacementSubMenu_Firework-List-ParticleName"), particles, particleIndex, nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				particleIndex = Index
				currentRace.firework.name = particles[particleIndex]
				if inSession then
					modificationCount.firework = modificationCount.firework + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { firework = currentRace.firework, modificationCount = modificationCount.firework }, "firework-sync")
				end
			end
		end)

		Items:AddList("R", { currentRace.firework.r }, 1, nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentRace.firework.r = currentRace.firework.r - 1
				if currentRace.firework.r < 0 then
					currentRace.firework.r = 255
				end
				if inSession then
					modificationCount.firework = modificationCount.firework + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { firework = currentRace.firework, modificationCount = modificationCount.firework }, "firework-sync")
				end
			elseif (onListChange) == "right" then
				currentRace.firework.r = currentRace.firework.r + 1
				if currentRace.firework.r > 255 then
					currentRace.firework.r = 0
				end
				if inSession then
					modificationCount.firework = modificationCount.firework + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { firework = currentRace.firework, modificationCount = modificationCount.firework }, "firework-sync")
				end
			end
		end)

		Items:AddList("G", { currentRace.firework.g }, 1, nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentRace.firework.g = currentRace.firework.g - 1
				if currentRace.firework.g < 0 then
					currentRace.firework.g = 255
				end
				if inSession then
					modificationCount.firework = modificationCount.firework + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { firework = currentRace.firework, modificationCount = modificationCount.firework }, "firework-sync")
				end
			elseif (onListChange) == "right" then
				currentRace.firework.g = currentRace.firework.g + 1
				if currentRace.firework.g > 255 then
					currentRace.firework.g = 0
				end
				if inSession then
					modificationCount.firework = modificationCount.firework + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { firework = currentRace.firework, modificationCount = modificationCount.firework }, "firework-sync")
				end
			end
		end)

		Items:AddList("B", { currentRace.firework.b }, 1, nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentRace.firework.b = currentRace.firework.b - 1
				if currentRace.firework.b < 0 then
					currentRace.firework.b = 255
				end
				if inSession then
					modificationCount.firework = modificationCount.firework + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { firework = currentRace.firework, modificationCount = modificationCount.firework }, "firework-sync")
				end
			elseif (onListChange) == "right" then
				currentRace.firework.b = currentRace.firework.b + 1
				if currentRace.firework.b > 255 then
					currentRace.firework.b = 0
				end
				if inSession then
					modificationCount.firework = modificationCount.firework + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { firework = currentRace.firework, modificationCount = modificationCount.firework }, "firework-sync")
				end
			end
		end)
	end, function(Panels)
	end)

	MultiplayerSubMenu:IsVisible(function(Items)
		if currentRace.title == "" then
			if #multiplayer.invitationList > 0 then
				for k, v in pairs(multiplayer.invitationList) do
					Items:AddButton(v.title, nil, { IsDisabled = global_var.lock or inSession }, function(onSelected)
						if (onSelected) then
							global_var.lock = true
							Citizen.CreateThread(function()
								busyspinner.status = "download"
								RemoveLoadingPrompt()
								BeginTextCommandBusyString("STRING")
								AddTextComponentSubstringPlayerName(string.format(GetTranslate("download-progress"), 0))
								EndTextCommandBusyString(4)
								TriggerServerCallback("custom_creator:server:joinPlayerSession", function(data, data_2, inSessionPlayers)
									if data and data_2 then
										inSession = true
										lockSession = true
										LoadSessionData(data, data_2)
										global_var.thumbnailValid = false
										SendNUIMessage({
											action = "thumbnail_url",
											thumbnail_url = currentRace.thumbnail
										})
										RageUI.QuitIndex = nil
										RageUI.GoBack()
										DisplayCustomMsgs(GetTranslate("join-session-success"))
										TriggerServerEvent("custom_creator:server:loadDone", currentRace.raceid)
										for i = 1, #inSessionPlayers do
											table.insert(multiplayer.inSessionPlayers, inSessionPlayers[i])
										end
										if #multiplayer.loadingPlayers == 0 then
											lockSession = false
										end
									else
										DisplayCustomMsgs(GetTranslate("join-session-failed"))
									end
									RemoveLoadingPrompt()
									busyspinner.status = nil
									global_var.lock = false
									table.remove(multiplayer.invitationList, k)
								end, v.sessionId)
							end)
						end
					end)
				end
			else
				Items:AddButton(GetTranslate("MultiplayerSubMenu-Button-No-Invitation"), nil, { IsDisabled = true }, function(onSelected)

				end)
			end
		else
			Items:AddButton(GetTranslate("MultiplayerSubMenu-Button-Invite"), not inSession and GetTranslate("MultiplayerSubMenu-Button-Invite-Desc"), { IsDisabled = not inSession, RightLabel = "→→→", Color = not inSession and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
				if (onSelected) then
					global_var.lock = true
					Citizen.CreateThread(function()
						TriggerServerCallback("custom_creator:server:getPlayerList", function(players)
							multiplayer.availablePlayers = players
							global_var.lock = false
						end, currentRace.raceid)
					end)
				end
			end, MultiplayerSubMenu_Invite)

			for k, v in pairs(multiplayer.inSessionPlayers) do
				Items:AddButton(v.playerName or v.playerId, nil, { IsDisabled = myServerId == v.playerId or global_var.lock }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback("custom_creator:server:getPlayerCoords", function(coords)
								if coords then
									cameraPosition = vector3(coords.x + 0.0, coords.y + 0.0, coords.z + 20.0)
									cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
								end
								global_var.lock = false
							end, v.playerId)
						end)
					end
				end)
			end
		end
	end, function(Panels)
	end)

	MultiplayerSubMenu_Invite:IsVisible(function(Items)
		if #multiplayer.availablePlayers > 0 then
			for k, v in pairs(multiplayer.availablePlayers) do
				Items:AddButton(v.playerName, nil, { IsDisabled = global_var.lock }, function(onSelected)
					if (onSelected) then
						TriggerServerEvent("custom_creator:server:invitePlayer", v.playerId, currentRace.title, currentRace.raceid)
						table.remove(multiplayer.availablePlayers, k)
					end
				end)
			end
		else
			Items:AddButton(GetTranslate("MultiplayerSubMenu_Invite-Button-No-Result"), nil, { IsDisabled = true }, function(onSelected)

			end)
		end
	end, function(Panels)
	end)

	WeatherSubMenu:IsVisible(function(Items)
		for i = 1, #weatherTypes do
			Items:AddButton(GetTranslate(weatherTypes[i]), nil, { IsDisabled = false }, function(onSelected)
				if (onSelected) then
					ClearOverrideWeather()
					ClearWeatherTypePersist()
					SetWeatherTypePersist(weatherTypes[i])
					SetWeatherTypeNow(weatherTypes[i])
					SetWeatherTypeNowPersist(weatherTypes[i])
					SetRainLevel(-1.0)
					if weatherTypes[i] == "XMAS" then
						SetForceVehicleTrails(true)
						SetForcePedFootstepsTracks(true)
					else
						SetForceVehicleTrails(false)
						SetForcePedFootstepsTracks(false)
					end
				end
			end)
		end
	end, function(Panels)
	end)

	TimeSubMenu:IsVisible(function(Items)
		Items:AddList(GetTranslate("Hours"), hours, hourIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				hourIndex = Index
				NetworkOverrideClockTime(hours[hourIndex], minutes[minuteIndex], seconds[secondIndex])
			end
		end)

		Items:AddList(GetTranslate("Minutes"), minutes, minuteIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				minuteIndex = Index
				NetworkOverrideClockTime(hours[hourIndex], minutes[minuteIndex], seconds[secondIndex])
			end
		end)

		Items:AddList(GetTranslate("Seconds"), seconds, secondIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				secondIndex = Index
				NetworkOverrideClockTime(hours[hourIndex], minutes[minuteIndex], seconds[secondIndex])
			end
		end)

		Items:CheckBox(GetTranslate("Lock"), nil, global_var.timeChecked, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) then
				global_var.timeChecked = IsChecked
			end
		end)
	end, function(Panels)
	end)

	MiscSubMenu:IsVisible(function(Items)
		Items:AddList(GetTranslate("MiscSubMenu-List-CamMoveSpeed"), { speed.cam_pos.value[speed.cam_pos.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = speed.cam_pos.index - 1
				if index < 1 then
					index = #speed.cam_pos.value
				end
				speed.cam_pos.index = index
			elseif (onListChange) == "right" then
				local index = speed.cam_pos.index + 1
				if index > #speed.cam_pos.value then
					index = 1
				end
				speed.cam_pos.index = index
			end
		end)

		Items:AddList(GetTranslate("MiscSubMenu-List-CamRotateSpeed"), { speed.cam_rot.value[speed.cam_rot.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local index = speed.cam_rot.index - 1
				if index < 1 then
					index = #speed.cam_rot.value
				end
				speed.cam_rot.index = index
			elseif (onListChange) == "right" then
				local index = speed.cam_rot.index + 1
				if index > #speed.cam_rot.value then
					index = 1
				end
				speed.cam_rot.index = index
			end
		end)

		Items:CheckBox(GetTranslate("MiscSubMenu-CheckBox-DisableNpc"), nil, global_var.DisableNpcChecked, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) then
				global_var.DisableNpcChecked = IsChecked
				TriggerServerEvent("custom_creator:server:saveData", {DisableNpcChecked = IsChecked})
			end
		end)

		Items:CheckBox(GetTranslate("MiscSubMenu-CheckBox-RadarBigmap"), nil, global_var.RadarBigmapChecked, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) then
				global_var.RadarBigmapChecked = IsChecked
				Citizen.CreateThread(function()
					SetRadarBigmapEnabled(global_var.RadarBigmapChecked, false)
					Citizen.Wait(0)
					if global_var.RadarBigmapChecked then
						SetRadarZoom(500)
					else
						SetRadarZoom(1200)
					end
				end)
			end
		end)

		Items:CheckBox(GetTranslate("MiscSubMenu-CheckBox-ObjectLowerAlpha"), nil, global_var.ObjectLowerAlphaChecked, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) then
				global_var.ObjectLowerAlphaChecked = IsChecked
				TriggerServerEvent("custom_creator:server:saveData", {ObjectLowerAlphaChecked = IsChecked})
			end
		end)

		if currentRace.title ~= "" then
			Items:AddButton(GetTranslate("MiscSubMenu-Button-RefreshGrids"), GetTranslate("MiscSubMenu-Button-RefreshGrids-Desc"), { IsDisabled = objectPool.isRefreshing }, function(onSelected)
				if (onSelected) then
					objectPool.isRefreshing = true
					RefreshAllGirds()
				end
			end)
		end
	end, function(Panels)
	end)
end