MainMenu = RageUI.CreateMenu(GetTranslate("MainMenu-Title"), GetTranslate("MainMenu-Subtitle"), true)

RaceDetailSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("RaceDetailSubMenu-Subtitle"), false)

PlacementSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("PlacementSubMenu-Subtitle"), false)
PlacementSubMenu_StartingGrid = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_StartingGrid-Subtitle"), false)
PlacementSubMenu_Checkpoints = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Checkpoints-Subtitle"), false)
PlacementSubMenu_Props = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Props-Subtitle"), false)
PlacementSubMenu_Templates = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Templates-Subtitle"), false)

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
						action = 'open',
						value = currentRace.title
					})
					nuiCallBack = "race title"
				end
				if global_var.showPreviewThumbnail then
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
			end)

			Items:AddButton(GetTranslate("MainMenu-Button-Import"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = 'open',
						value = GetTranslate("paste-url")
					})
					nuiCallBack = "import ugc"
				end
				if global_var.showPreviewThumbnail then
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
			end)

			if global_var.querying then
				Items:AddButton(GetTranslate("MainMenu-Button-Cancel"), nil, { IsDisabled = false }, function(onSelected)
					if (onSelected) then
						TriggerServerEvent('custom_creator:server:cancel')
					end
				end)
			end

			Items:AddButton(GetTranslate("MainMenu-Button-Weather"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if global_var.showPreviewThumbnail then
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
			end, WeatherSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Time"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if global_var.showPreviewThumbnail then
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
			end, TimeSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Misc"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if global_var.showPreviewThumbnail then
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
			end, MiscSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Exit"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if global_var.showPreviewThumbnail then
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
				if (onSelected) then
					TriggerEvent('custom_creator:unload')
					SetRadarBigmapEnabled(false, false)
					for k, v in pairs(blips.checkpoints) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.checkpoints_2) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.objects) do
						RemoveBlip(v)
					end
					blips.checkpoints = {}
					blips.checkpoints_2 = {}
					blips.objects = {}
					for i = 1, #currentRace.objects do
						DeleteObject(currentRace.objects[i].handle)
					end
					currentRace = {
						raceid = nil,
						owner_name = "",
						published = false,
						title = "",
						thumbnail = "",
						test_vehicle = "",
						startingGrid = {},
						checkpoints = {},
						checkpoints_2 = {},
						transformVehicles = {0, -422877666, -731262150, "bmx", "xa21"},
						objects = {},
						dhprop = {}
					}
					startingGridVehicleIndex = 0
					checkpointIndex = 0
					objectIndex = 0
					globalRot = {
						x = 0.0,
						y = 0.0,
						z = 0.0
					}
					global_var = {
						timeChecked = false,
						RadarBigmapChecked = false,
						enableCreator = false,
						TempClosed = false,
						lock = false,
						lock_2 = false,
						querying = false,
						IsNuiFocused = false,
						IsPauseMenuActive = false,
						IsPlayerSwitchInProgress = false,
						IsUsingKeyboard = true,
						currentLanguage = GetCurrentLanguage(),
						previewThumbnail = "",
						showPreviewThumbnail = false,
						showThumbnail = false,
						thumbnailValid = false,
						queryingThumbnail = false,
						isSelectingStartingGridVehicle = false,
						isPrimaryCheckpointItems = true,
						propColor = nil,
						propZposLock = nil,
						tipsRendered = false,
						enableTest = false,
						testVehicleHandle = nil,
						testBlipHandle = nil,
						autoRespawn = true,
						isRespawning = false,
						enableBeastMode = false,
					}
					Citizen.CreateThread(function()
						RageUI.CloseAll()
						Citizen.Wait(0)
						local ped = PlayerPedId()
						SetEntityCoords(ped, JoinRacePoint)
						SetEntityHeading(ped, JoinRaceHeading)
						FreezeEntityPosition(ped, false)
						SetEntityVisible(ped, true)
						SetEntityCollision(ped, true, true)
						SetLocalPlayerAsGhost(false)
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						SetGameplayCamRelativeHeading(0)
						camera = nil
						cameraPosition = nil
						cameraRotation = nil
						JoinRacePoint = nil
						JoinRaceHeading = nil
					end)
				end
			end)

			Items:AddSeparator(GetTranslate("MainMenu-Separator-Load"))

			local category_list = {}
			for i = 1, #races_data.category do
				category_list[i] = (i == 1 and GetTranslate("published-races")) or (i == 2 and GetTranslate("saved-races")) or races_data.category[i].class
			end
			Items:AddList("", category_list, races_data.index, nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(Index, onSelected, onListChange)
				if (onListChange) then
					races_data.index = Index
				end
				if global_var.showPreviewThumbnail then
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
			end)

			for i = 1, #races_data.category[races_data.index].data do
				Items:AddButton(races_data.category[races_data.index].data[i].name, nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
					if global_var.previewThumbnail ~= races_data.category[races_data.index].data[i].img and not global_var.lock then
						global_var.previewThumbnail = races_data.category[races_data.index].data[i].img
						SendNUIMessage({
							action = 'thumbnail_preview',
							preview_url = global_var.previewThumbnail
						})
					end
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback('custom_creator:server:get_json', function(data)
								if data then
									convertJsonData(data)
									global_var.thumbnailValid = false
									global_var.previewThumbnail = ""
									global_var.showPreviewThumbnail = false
									SendNUIMessage({
										action = 'thumbnail_off'
									})
									SendNUIMessage({
										action = 'thumbnail_url',
										thumbnail_url = currentRace.thumbnail
									})
									DisplayCustomMsgs(GetTranslate("load-success"))
								else
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
			Items:AddButton(GetTranslate("MainMenu-Button-RaceDetail"), nil, { IsDisabled = global_var.lock }, function(onSelected)

			end, RaceDetailSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Placement"), nil, { IsDisabled = global_var.lock }, function(onSelected)

			end, PlacementSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Weather"), nil, { IsDisabled = global_var.lock }, function(onSelected)

			end, WeatherSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Time"), nil, { IsDisabled = global_var.lock }, function(onSelected)

			end, TimeSubMenu)

			if currentRace.published then
				Items:AddButton(GetTranslate("MainMenu-Button-Update"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						TriggerServerCallback('custom_creator:server:save_file', function(str, raceid, owner_name)
							if str == "success" then
								DisplayCustomMsgs(GetTranslate("update-success"))
								currentRace.raceid = raceid
								currentRace.published = true
								currentRace.owner_name = owner_name
							elseif str == "wrong-artifact" then
								DisplayCustomMsgs(GetTranslate("wrong-artifact"))
							elseif str == "denied" then
								DisplayCustomMsgs(GetTranslate("no-permission"))
							elseif str == "no discord" then
								DisplayCustomMsgs(GetTranslate("no-discord"))
							end
							global_var.lock = false
						end, convertRaceToUGC(currentRace), "update")
					end
				end)

				Items:AddButton(GetTranslate("MainMenu-Button-CancelPublish"), GetTranslate("MainMenu-Button-CancelPublish-Desc"), { IsDisabled = global_var.lock }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						TriggerServerCallback('custom_creator:server:cancel_publish', function(bool)
							if bool then
								currentRace.published = false
							end
							global_var.lock = false
						end, currentRace.raceid)
					end
				end)
			else
				Items:AddButton(GetTranslate("MainMenu-Button-Save"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback('custom_creator:server:save_file', function(str, raceid, owner_name)
								if str == "success" then
									DisplayCustomMsgs(GetTranslate("save-success"))
									currentRace.raceid = raceid
									currentRace.published = false
									currentRace.owner_name = owner_name
								elseif str == "wrong-artifact" then
									DisplayCustomMsgs(GetTranslate("wrong-artifact"))
								elseif str == "denied" then
									DisplayCustomMsgs(GetTranslate("no-permission"))
								elseif str == "no discord" then
									DisplayCustomMsgs(GetTranslate("no-discord"))
								end
								global_var.lock = false
							end, convertRaceToUGC(currentRace), "save")
						end)
					end
				end)

				Items:AddButton(GetTranslate("MainMenu-Button-Publish"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") }, function(onSelected)
					if (onSelected) then
						global_var.lock = true
						Citizen.CreateThread(function()
							TriggerServerCallback('custom_creator:server:save_file', function(str, raceid, owner_name)
								if str == "success" then
									DisplayCustomMsgs(GetTranslate("publish-success"))
									currentRace.raceid = raceid
									currentRace.published = true
									currentRace.owner_name = owner_name
								elseif str == "wrong-artifact" then
									DisplayCustomMsgs(GetTranslate("wrong-artifact"))
								elseif str == "denied" then
									DisplayCustomMsgs(GetTranslate("no-permission"))
								elseif str == "no discord" then
									DisplayCustomMsgs(GetTranslate("no-discord"))
								end
								global_var.lock = false
							end, convertRaceToUGC(currentRace), "publish")
						end)
					end
				end)
			end

			Items:AddButton(GetTranslate("MainMenu-Button-Exit"), nil, { IsDisabled = global_var.lock }, function(onSelected)
				if (onSelected) then
					TriggerEvent('custom_creator:unload')
					SetRadarBigmapEnabled(false, false)
					for k, v in pairs(blips.checkpoints) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.checkpoints_2) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.objects) do
						RemoveBlip(v)
					end
					blips.checkpoints = {}
					blips.checkpoints_2 = {}
					blips.objects = {}
					for i = 1, #currentRace.objects do
						DeleteObject(currentRace.objects[i].handle)
					end
					currentRace = {
						raceid = nil,
						owner_name = "",
						published = false,
						title = "",
						thumbnail = "",
						test_vehicle = "",
						startingGrid = {},
						checkpoints = {},
						checkpoints_2 = {},
						transformVehicles = {0, -422877666, -731262150, "bmx", "xa21"},
						objects = {},
						dhprop = {}
					}
					startingGridVehicleIndex = 0
					checkpointIndex = 0
					objectIndex = 0
					globalRot = {
						x = 0.0,
						y = 0.0,
						z = 0.0
					}
					global_var = {
						timeChecked = false,
						RadarBigmapChecked = false,
						enableCreator = false,
						TempClosed = false,
						lock = false,
						lock_2 = false,
						querying = false,
						IsNuiFocused = false,
						IsPauseMenuActive = false,
						IsPlayerSwitchInProgress = false,
						IsUsingKeyboard = true,
						currentLanguage = GetCurrentLanguage(),
						previewThumbnail = "",
						showPreviewThumbnail = false,
						showThumbnail = false,
						thumbnailValid = false,
						queryingThumbnail = false,
						isSelectingStartingGridVehicle = false,
						isPrimaryCheckpointItems = true,
						propColor = nil,
						propZposLock = nil,
						tipsRendered = false,
						enableTest = false,
						testVehicleHandle = nil,
						testBlipHandle = nil,
						autoRespawn = true,
						isRespawning = false,
						enableBeastMode = false,
					}
					Citizen.CreateThread(function()
						RageUI.CloseAll()
						Citizen.Wait(0)
						local ped = PlayerPedId()
						SetEntityCoords(ped, JoinRacePoint)
						SetEntityHeading(ped, JoinRaceHeading)
						FreezeEntityPosition(ped, false)
						SetEntityVisible(ped, true)
						SetEntityCollision(ped, true, true)
						SetLocalPlayerAsGhost(false)
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						SetGameplayCamRelativeHeading(0)
						camera = nil
						cameraPosition = nil
						cameraRotation = nil
						JoinRacePoint = nil
						JoinRaceHeading = nil
					end)
				end
			end)

			Items:AddButton(GetTranslate("MainMenu-Button-Misc"), nil, { IsDisabled = global_var.lock }, function(onSelected)

			end, MiscSubMenu)
		end
	end, function(Panels)
	end)

	RaceDetailSubMenu:IsVisible(function(Items)
		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-Title"), (currentRace.title == "unknown") and GetTranslate("RaceDetailSubMenu-Button-Title-Desc"), { IsDisabled = global_var.IsNuiFocused, Color = (currentRace.title == "unknown") and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = currentRace.title
				})
				nuiCallBack = "race title"
			end
		end)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-Thumbnail"), not global_var.thumbnailValid and GetTranslate("RaceDetailSubMenu-Button-Thumbnail-Desc"), { IsDisabled = global_var.IsNuiFocused, Color = not global_var.thumbnailValid and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
			if (onSelected) then
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = 'open',
						value = currentRace.thumbnail
					})
					nuiCallBack = "race thumbnail"
				end
			end
		end)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-TestVeh"), nil, { IsDisabled = global_var.IsNuiFocused }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = currentRace.test_vehicle
				})
				nuiCallBack = "test vehicle"
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu-Button-StartingGrid"), (#currentRace.startingGrid == 0) and GetTranslate("PlacementSubMenu-Button-StartingGrid-Desc"), { IsDisabled = false, Color = (#currentRace.startingGrid == 0) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_StartingGrid)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Checkpoints"), (#currentRace.checkpoints < 10) and GetTranslate("PlacementSubMenu-Button-Checkpoints-Desc"), { IsDisabled = false, Color = (#currentRace.checkpoints < 10) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_Checkpoints)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Props"), (#currentRace.objects == 0) and GetTranslate("PlacementSubMenu-Button-Props-Desc"), { IsDisabled = false, Color = (#currentRace.objects == 0) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_Props)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Templates"), nil, { IsDisabled = false }, function(onSelected)

		end, PlacementSubMenu_Templates)
	end, function(Panels)
	end)

	PlacementSubMenu_StartingGrid:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu_StartingGrid-Button-Place"), (#currentRace.startingGrid >= Config.startingGridLimit) and GetTranslate("PlacementSubMenu_StartingGrid-Button-startingGridLimit-Desc") or nil, { IsDisabled = isStartingGridVehiclePickedUp or global_var.IsNuiFocused or (not startingGridVehicleSelect and not startingGridVehiclePreview) or (#currentRace.startingGrid >= Config.startingGridLimit) }, function(onSelected)
			if (onSelected) then
				if not isStartingGridVehiclePickedUp and startingGridVehiclePreview then
					ResetEntityAlpha(startingGridVehiclePreview)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutline(startingGridVehiclePreview, true)
					table.insert(currentRace.startingGrid, currentstartingGridVehicle)
					startingGridVehicleIndex = currentstartingGridVehicle.index
					startingGridVehiclePreview = nil
					globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
					currentstartingGridVehicle = {
						index = nil,
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-Heading"), { currentstartingGridVehicle.heading or "" }, 1, nil, { IsDisabled = (not startingGridVehicleSelect and not startingGridVehiclePreview) or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentstartingGridVehicle.heading = RoundedValue(currentstartingGridVehicle.heading - speed.grid_offset.value[speed.grid_offset.index][2], 3)
				if (currentstartingGridVehicle.heading > 9999.0) or (currentstartingGridVehicle.heading < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentstartingGridVehicle.heading = 0.0
				end
				SetEntityRotation(currentstartingGridVehicle.handle, 0.0, 0.0, currentstartingGridVehicle.heading, 2, 0)
				if isStartingGridVehiclePickedUp and currentRace.startingGrid[startingGridVehicleIndex] then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
					globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
				end
			elseif (onListChange) == "right" then
				currentstartingGridVehicle.heading = RoundedValue(currentstartingGridVehicle.heading + speed.grid_offset.value[speed.grid_offset.index][2], 3)
				if (currentstartingGridVehicle.heading > 9999.0) or (currentstartingGridVehicle.heading < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentstartingGridVehicle.heading = 0.0
				end
				SetEntityRotation(currentstartingGridVehicle.handle, 0.0, 0.0, currentstartingGridVehicle.heading, 2, 0)
				if isStartingGridVehiclePickedUp and currentRace.startingGrid[startingGridVehicleIndex] then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
					globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentstartingGridVehicle.heading)
				})
				nuiCallBack = "startingGrid heading"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-ChangeSpeed"), { speed.grid_offset.value[speed.grid_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				speed.grid_offset.index = speed.grid_offset.index - 1
				if speed.grid_offset.index < 1 then
					speed.grid_offset.index = #speed.grid_offset.value
				end
			elseif (onListChange) == "right" then
				speed.grid_offset.index = speed.grid_offset.index + 1
				if speed.grid_offset.index > #speed.grid_offset.value then
					speed.grid_offset.index = 1
				end
			end
		end)

		Items:AddSeparator("x = " .. (currentstartingGridVehicle.x or 0.0) .. ", y = " .. (currentstartingGridVehicle.y or 0.0) .. ", z = " .. (currentstartingGridVehicle.z or 0.0))

		Items:AddButton(GetTranslate("PlacementSubMenu_StartingGrid-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isStartingGridVehiclePickedUp), Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				startingGridVehicleSelect = nil
				isStartingGridVehiclePickedUp = false
				DeleteVehicle(currentstartingGridVehicle.handle)
				for k, v in pairs(currentRace.startingGrid) do
					if currentstartingGridVehicle.handle == v.handle then
						table.remove(currentRace.startingGrid, k)
						break
					end
				end
				for k, v in pairs(currentRace.startingGrid) do
					v.index = k
				end
				if startingGridVehicleIndex > #currentRace.startingGrid then
					startingGridVehicleIndex = #currentRace.startingGrid
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-CycleItems"), { startingGridVehicleIndex .. " / " .. #currentRace.startingGrid }, 1, nil, { IsDisabled = #currentRace.startingGrid == 0 or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
					ResetEntityAlpha(startingGridVehicleSelect)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutline(startingGridVehicleSelect, true)
				end
				if startingGridVehiclePreview then
					DeleteVehicle(startingGridVehiclePreview)
					startingGridVehiclePreview = nil
				end
				startingGridVehicleIndex = startingGridVehicleIndex - 1
				if startingGridVehicleIndex < 1 then
					startingGridVehicleIndex = #currentRace.startingGrid
				end
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				startingGridVehicleSelect = currentstartingGridVehicle.handle
				SetEntityDrawOutline(currentstartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensions(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentstartingGridVehicle.x + (20 - min.z) * math.sin(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.y - (20 - min.z) * math.cos(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.z + (20 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentstartingGridVehicle.heading}
			elseif (onListChange) == "right" then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
					ResetEntityAlpha(startingGridVehicleSelect)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutline(startingGridVehicleSelect, true)
				end
				if startingGridVehiclePreview then
					DeleteVehicle(startingGridVehiclePreview)
					startingGridVehiclePreview = nil
				end
				startingGridVehicleIndex = startingGridVehicleIndex + 1
				if startingGridVehicleIndex > #currentRace.startingGrid then
					startingGridVehicleIndex = 1
				end
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				startingGridVehicleSelect = currentstartingGridVehicle.handle
				SetEntityDrawOutline(currentstartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensions(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentstartingGridVehicle.x + (20 - min.z) * math.sin(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.y - (20 - min.z) * math.cos(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.z + (20 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentstartingGridVehicle.heading}
			end
			if (onSelected) then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
					ResetEntityAlpha(startingGridVehicleSelect)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutline(startingGridVehicleSelect, true)
				end
				if startingGridVehiclePreview then
					DeleteVehicle(startingGridVehiclePreview)
					startingGridVehiclePreview = nil
				end
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				startingGridVehicleSelect = currentstartingGridVehicle.handle
				SetEntityDrawOutline(currentstartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensions(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentstartingGridVehicle.x + (20 - min.z) * math.sin(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.y - (20 - min.z) * math.cos(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.z + (20 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentstartingGridVehicle.heading}
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Checkpoints:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Test"), nil, { IsDisabled = global_var.IsNuiFocused or not isCheckpointPickedUp or (isCheckpointPickedUp and (not global_var.isPrimaryCheckpointItems and not currentRace.checkpoints_2[checkpointIndex])) }, function(onSelected)
			if (onSelected) then
				global_var.enableTest = true
				global_var.isRespawning = true
				global_var.tipsRendered = false
				global_var.RadarBigmapChecked = false
				SetRadarBigmapEnabled(global_var.RadarBigmapChecked, false)
				for k, v in pairs(blips.checkpoints) do
					RemoveBlip(v)
				end
				for k, v in pairs(blips.checkpoints_2) do
					RemoveBlip(v)
				end
				for k, v in pairs(blips.objects) do
					RemoveBlip(v)
				end
				blips.checkpoints = {}
				blips.checkpoints_2 = {}
				blips.objects = {}
				for i = 1, #currentRace.objects do
					DeleteObject(currentRace.objects[i].handle)
					currentRace.objects[i].handle = createProp(currentRace.objects[i].hash, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z, currentRace.objects[i].rotX, currentRace.objects[i].rotY, currentRace.objects[i].rotZ, currentRace.objects[i].color)
				end
				for i = 1, #currentRace.objects do
					ResetEntityAlpha(currentRace.objects[i].handle)
					if not currentRace.objects[i].visible then
						SetEntityVisible(currentRace.objects[i].handle, false)
					end
					if not currentRace.objects[i].collision then
						SetEntityCollision(currentRace.objects[i].handle, false, false)
					end
					if currentRace.objects[i].dynamic then
						FreezeEntityPosition(currentRace.objects[i].handle, false)
					end
				end
				Citizen.CreateThread(function()
					RageUI.CloseAll()
					Citizen.Wait(0)
					while global_var.autoRespawn and (not global_var.testVehicleHandle) do Citizen.Wait(0) end
					local ped = PlayerPedId()
					FreezeEntityPosition(ped, false)
					SetEntityVisible(ped, true)
					SetEntityCollision(ped, true, true)
					RenderScriptCams(false, false, 0, true, false)
					DestroyCam(camera, false)
					camera = nil
					Citizen.Wait(500)
					DisplayCustomMsgs(string.format(GetTranslate("respawn-tip"), global_var.IsUsingKeyboard and "F" or "Y"))
					Citizen.Wait(100)
					BeginTextCommandDisplayHelp("THREESTRINGS")
					AddTextComponentSubstringPlayerName(GetTranslate("quit-test"))
					AddTextComponentSubstringPlayerName("")
					AddTextComponentSubstringPlayerName("")
					EndTextCommandDisplayHelp(0, true, true, -1)
					global_var.tipsRendered = true
				end)
				TestCurrentCheckpoint(global_var.isPrimaryCheckpointItems, checkpointIndex)
			end
		end)

		Items:AddList("", { global_var.isPrimaryCheckpointItems and GetTranslate("PlacementSubMenu_Checkpoints-List-Primary") or GetTranslate("PlacementSubMenu_Checkpoints-List-Secondary") }, 1, nil, { IsDisabled = global_var.IsNuiFocused or isCheckpointPickedUp or (not isCheckpointPickedUp and not checkpointPreview) }, function(Index, onSelected, onListChange)
			if (onListChange) then
				global_var.isPrimaryCheckpointItems = not global_var.isPrimaryCheckpointItems
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Place"), nil, { IsDisabled = global_var.IsNuiFocused or isCheckpointPickedUp or not checkpointPreview }, function(onSelected)
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(global_var.isPrimaryCheckpointItems and (#currentRace.checkpoints + 1) or checkpointIndex)
				})
				nuiCallBack = "place checkpoint"
			end
		end)

		Items:AddList("X:", { currentCheckpoint.x or "" }, 1, nil, { IsDisabled = not currentCheckpoint.x or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.x then
				currentCheckpoint.x = RoundedValue(currentCheckpoint.x - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			elseif (onListChange) == "right" and currentCheckpoint.x then
				currentCheckpoint.x = RoundedValue(currentCheckpoint.x + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentCheckpoint.x)
				})
				nuiCallBack = "checkpoint x"
			end
			if (onListChange) or (onSelected) then
				checkpointPreview_coords_change = true

				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints_2[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					end
				end
			end
		end)

		Items:AddList("Y:", { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.y }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.y then
				currentCheckpoint.y = RoundedValue(currentCheckpoint.y - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			elseif (onListChange) == "right" and currentCheckpoint.y then
				currentCheckpoint.y = RoundedValue(currentCheckpoint.y + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentCheckpoint.y)
				})
				nuiCallBack = "checkpoint y"
			end
			if (onListChange) or (onSelected) then
				checkpointPreview_coords_change = true

				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints_2[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					end
				end
			end
		end)

		Items:AddList("Z:", { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.z }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.z then
				currentCheckpoint.z = RoundedValue(currentCheckpoint.z - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			elseif (onListChange) == "right" and currentCheckpoint.z then
				currentCheckpoint.z = RoundedValue(currentCheckpoint.z + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentCheckpoint.z)
				})
				nuiCallBack = "checkpoint z"
			end
			if (onListChange) or (onSelected) then
				checkpointPreview_coords_change = true

				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints_2[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Heading"), { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.heading }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.heading then
				currentCheckpoint.heading = RoundedValue(currentCheckpoint.heading - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				if (currentCheckpoint.heading > 9999.0) or (currentCheckpoint.heading < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.heading = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
				end
			elseif (onListChange) == "right" and currentCheckpoint.heading then
				currentCheckpoint.heading = RoundedValue(currentCheckpoint.heading + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				if (currentCheckpoint.heading > 9999.0) or (currentCheckpoint.heading < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.heading = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentCheckpoint.heading)
				})
				nuiCallBack = "checkpoint heading"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-ChangeSpeed"), { speed.checkpoint_offset.value[speed.checkpoint_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				speed.checkpoint_offset.index = speed.checkpoint_offset.index - 1
				if speed.checkpoint_offset.index < 1 then
					speed.checkpoint_offset.index = #speed.checkpoint_offset.value
				end
			elseif (onListChange) == "right" then
				speed.checkpoint_offset.index = speed.checkpoint_offset.index + 1
				if speed.checkpoint_offset.index > #speed.checkpoint_offset.value then
					speed.checkpoint_offset.index = 1
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Diameter"), { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.d }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.d then
				currentCheckpoint.d = RoundedValue(currentCheckpoint.d - 0.25, 3)
				if currentCheckpoint.d < 0.5 then
					currentCheckpoint.d = 5.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
				end
			elseif (onListChange) == "right" and currentCheckpoint.d then
				currentCheckpoint.d = RoundedValue(currentCheckpoint.d + 0.25, 3)
				if currentCheckpoint.d > 5.0 then
					currentCheckpoint.d = 0.5
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Round"), nil, currentCheckpoint.is_round, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused then
				if currentCheckpoint.is_random or currentCheckpoint.is_transform or currentCheckpoint.is_planeRot or currentCheckpoint.is_warp then
					DisplayCustomMsgs(GetTranslate("checkpoints-round-lock"))
				else
					currentCheckpoint.is_round = IsChecked
					if isCheckpointPickedUp then
						if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
							currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
							currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						end
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Air"), nil, currentCheckpoint.is_air, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused then
				currentCheckpoint.is_air = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Fake"), nil, currentCheckpoint.is_fake, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused then
				currentCheckpoint.is_fake = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Random"), nil, currentCheckpoint.is_random, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused then
				currentCheckpoint.is_random = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
					currentCheckpoint.randomClass = 0
					currentCheckpoint.is_transform = nil
					currentCheckpoint.transform_index = nil
					currentCheckpoint.is_planeRot = nil
					currentCheckpoint.plane_rot = nil
					currentCheckpoint.is_warp = nil
				else
					currentCheckpoint.randomClass = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					for k, v in pairs(blips.checkpoints) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.checkpoints_2) do
						RemoveBlip(v)
					end
					blips.checkpoints = {}
					blips.checkpoints_2 = {}
					for k, v in pairs(currentRace.checkpoints) do
						blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
					for k, v in pairs(currentRace.checkpoints_2) do
						blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Random"), { (currentCheckpoint.randomClass == 0 and GetTranslate("RandomClass-0")) or (currentCheckpoint.randomClass == 1 and GetTranslate("RandomClass-1")) or (currentCheckpoint.randomClass == 2 and GetTranslate("RandomClass-2")) or (currentCheckpoint.randomClass == 3 and GetTranslate("RandomClass-3")) or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_random) }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentCheckpoint.randomClass = currentCheckpoint.randomClass - 1
			elseif (onListChange) == "right" then
				currentCheckpoint.randomClass = currentCheckpoint.randomClass + 1
			end
			if (onListChange)then
				if currentCheckpoint.randomClass < 0 then
					currentCheckpoint.randomClass = 3
				elseif currentCheckpoint.randomClass > 3 then
					currentCheckpoint.randomClass = 0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Transform"), nil, currentCheckpoint.is_transform, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused then
				currentCheckpoint.is_transform = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
					currentCheckpoint.transform_index = 0
					currentCheckpoint.is_random = nil
					currentCheckpoint.randomClass = nil
					currentCheckpoint.is_planeRot = nil
					currentCheckpoint.plane_rot = nil
					currentCheckpoint.is_warp = nil
				else
					currentCheckpoint.transform_index = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					for k, v in pairs(blips.checkpoints) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.checkpoints_2) do
						RemoveBlip(v)
					end
					blips.checkpoints = {}
					blips.checkpoints_2 = {}
					for k, v in pairs(currentRace.checkpoints) do
						blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
					for k, v in pairs(currentRace.checkpoints_2) do
						blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
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
				vehName = GetLabelText(GetDisplayNameFromVehicleModel(currentRace.transformVehicles[currentCheckpoint.transform_index + 1]))
			end
		elseif #currentRace.transformVehicles == 0 then
			vehName = "No Valid Vehicles"
		end
		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Transform"), { vehName }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_transform) or (#currentRace.transformVehicles == 0) }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentCheckpoint.transform_index = currentCheckpoint.transform_index - 1
			elseif (onListChange) == "right" then
				currentCheckpoint.transform_index = currentCheckpoint.transform_index + 1
			end
			if (onListChange)then
				if currentCheckpoint.transform_index < 0 then
					currentCheckpoint.transform_index = #currentRace.transformVehicles - 1
				elseif currentCheckpoint.transform_index > (#currentRace.transformVehicles - 1) then
					currentCheckpoint.transform_index = 0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Transform"), nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_transform) }, function(onSelected)
			if (onSelected) then
				if (onSelected) and not global_var.IsNuiFocused then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = 'open',
						value = currentRace.transformVehicles
					})
					nuiCallBack = "checkpoint transform vehicles"
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-PlaneRot"), nil, currentCheckpoint.is_planeRot, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused then
				currentCheckpoint.is_planeRot = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
					currentCheckpoint.plane_rot = 0
					currentCheckpoint.is_random = nil
					currentCheckpoint.randomClass = nil
					currentCheckpoint.is_transform = nil
					currentCheckpoint.transform_index = nil
					currentCheckpoint.is_warp = nil
				else
					currentCheckpoint.plane_rot = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					for k, v in pairs(blips.checkpoints) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.checkpoints_2) do
						RemoveBlip(v)
					end
					blips.checkpoints = {}
					blips.checkpoints_2 = {}
					for k, v in pairs(currentRace.checkpoints) do
						blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
					for k, v in pairs(currentRace.checkpoints_2) do
						blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-PlaneRot"), { (currentCheckpoint.plane_rot == 0 and GetTranslate("PlaneRot-0")) or (currentCheckpoint.plane_rot == 1 and GetTranslate("PlaneRot-1")) or (currentCheckpoint.plane_rot == 2 and GetTranslate("PlaneRot-2")) or (currentCheckpoint.plane_rot == 3 and GetTranslate("PlaneRot-3")) or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_planeRot) }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentCheckpoint.plane_rot = currentCheckpoint.plane_rot - 1
			elseif (onListChange) == "right" then
				currentCheckpoint.plane_rot = currentCheckpoint.plane_rot + 1
			end
			if (onListChange)then
				if currentCheckpoint.plane_rot < 0 then
					currentCheckpoint.plane_rot = 3
				elseif currentCheckpoint.plane_rot > 3 then
					currentCheckpoint.plane_rot = 0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Warp"), nil, currentCheckpoint.is_warp, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused then
				currentCheckpoint.is_warp = IsChecked
				if IsChecked then
					currentCheckpoint.is_round = true
					currentCheckpoint.is_random = nil
					currentCheckpoint.randomClass = nil
					currentCheckpoint.is_transform = nil
					currentCheckpoint.transform_index = nil
					currentCheckpoint.is_planeRot = nil
					currentCheckpoint.plane_rot = nil
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					for k, v in pairs(blips.checkpoints) do
						RemoveBlip(v)
					end
					for k, v in pairs(blips.checkpoints_2) do
						RemoveBlip(v)
					end
					blips.checkpoints = {}
					blips.checkpoints_2 = {}
					for k, v in pairs(currentRace.checkpoints) do
						blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
					for k, v in pairs(currentRace.checkpoints_2) do
						blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp), Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				local index = currentCheckpoint.index
				isCheckpointPickedUp = false
				if global_var.isPrimaryCheckpointItems then
					for k, v in pairs(currentRace.checkpoints) do
						if index == v.index then
							table.remove(currentRace.checkpoints, k)
							break
						end
					end
					for k, v in pairs(currentRace.checkpoints) do
						v.index = k
					end
					local copy_checkpoints_2 = {}
					for k, v in pairs(currentRace.checkpoints_2) do
						if index > k then
							v.index = k
							copy_checkpoints_2[k] = v
						elseif index < k then
							v.index = k - 1
							copy_checkpoints_2[k - 1] = v
						end
					end
					currentRace.checkpoints_2 = tableDeepCopy(copy_checkpoints_2)
					if checkpointIndex > #currentRace.checkpoints then
						checkpointIndex = #currentRace.checkpoints
					end
				else
					currentRace.checkpoints_2[index] = nil
				end
				for k, v in pairs(blips.checkpoints) do
					RemoveBlip(v)
				end
				for k, v in pairs(blips.checkpoints_2) do
					RemoveBlip(v)
				end
				blips.checkpoints = {}
				blips.checkpoints_2 = {}
				for k, v in pairs(currentRace.checkpoints) do
					blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
				end
				for k, v in pairs(currentRace.checkpoints_2) do
					blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-CycleItems"), { checkpointIndex .. " / " .. #currentRace.checkpoints }, 1, nil, { IsDisabled = (global_var.isPrimaryCheckpointItems and (#currentRace.checkpoints == 0)) or (not global_var.isPrimaryCheckpointItems and (tableCount(currentRace.checkpoints_2) == 0)) or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				if global_var.isPrimaryCheckpointItems then
					checkpointIndex = checkpointIndex - 1
					if checkpointIndex < 1 then
						checkpointIndex = #currentRace.checkpoints
					end
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
				currentCheckpoint = global_var.isPrimaryCheckpointItems and tableDeepCopy(currentRace.checkpoints[checkpointIndex]) or tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				local d = currentCheckpoint.d
				local is_round = currentCheckpoint.is_round
				local is_air = currentCheckpoint.is_air
				local is_fake = currentCheckpoint.is_fake
				local is_random = currentCheckpoint.is_random
				local is_transform = currentCheckpoint.is_transform
				local is_planeRot = currentCheckpoint.is_planeRot
				local is_warp = currentCheckpoint.is_warp
				local diameter = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
				cameraPosition = vector3(currentCheckpoint.x + (20 + diameter) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20 + diameter) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20 + diameter))
				cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
			elseif (onListChange) == "right" then
				if global_var.isPrimaryCheckpointItems then
					checkpointIndex = checkpointIndex + 1
					found = true
					if checkpointIndex > #currentRace.checkpoints then
						checkpointIndex = 1
					end
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
				currentCheckpoint = global_var.isPrimaryCheckpointItems and tableDeepCopy(currentRace.checkpoints[checkpointIndex]) or tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				local d = currentCheckpoint.d
				local is_round = currentCheckpoint.is_round
				local is_air = currentCheckpoint.is_air
				local is_fake = currentCheckpoint.is_fake
				local is_random = currentCheckpoint.is_random
				local is_transform = currentCheckpoint.is_transform
				local is_planeRot = currentCheckpoint.is_planeRot
				local is_warp = currentCheckpoint.is_warp
				local diameter = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
				cameraPosition = vector3(currentCheckpoint.x + (20 + diameter) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20 + diameter) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20 + diameter))
				cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
			end
			if (onSelected) then
				if (global_var.isPrimaryCheckpointItems or (not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex])) then
					isCheckpointPickedUp = true
					checkpointPreview = nil
					currentCheckpoint = global_var.isPrimaryCheckpointItems and tableDeepCopy(currentRace.checkpoints[checkpointIndex]) or tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
					local d = currentCheckpoint.d
					local is_round = currentCheckpoint.is_round
					local is_air = currentCheckpoint.is_air
					local is_fake = currentCheckpoint.is_fake
					local is_random = currentCheckpoint.is_random
					local is_transform = currentCheckpoint.is_transform
					local is_planeRot = currentCheckpoint.is_planeRot
					local is_warp = currentCheckpoint.is_warp
					local diameter = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
					cameraPosition = vector3(currentCheckpoint.x + (20 + diameter) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20 + diameter) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20 + diameter))
					cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
				elseif not global_var.isPrimaryCheckpointItems and not currentRace.checkpoints_2[checkpointIndex] then
					DisplayCustomMsgs(string.format(GetTranslate("checkpoints_2-null"), checkpointIndex))
				end
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Props:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-EnterModelHash"), nil, { IsDisabled = isPropPickedUp or global_var.IsNuiFocused }, function(onSelected)
			if (onSelected) then
				DeleteObject(objectPreview)
				objectPreview = nil
				currentObject = {
					index = nil,
					hash = nil,
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					rotX = nil,
					rotY = nil,
					rotZ = nil,
					color = nil,
					visible = nil,
					collision = nil,
					dynamic = nil
				}
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = lastValidText or ""
				})
				nuiCallBack = "prop hash"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-Category"), { category[categoryIndex].class }, 1, nil, { IsDisabled = isPropPickedUp or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				categoryIndex = categoryIndex - 1
				if categoryIndex < 1 then
					categoryIndex = #category
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				lastValidHash = nil
				currentObject = {
					index = nil,
					hash = nil,
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					rotX = nil,
					rotY = nil,
					rotZ = nil,
					color = nil,
					visible = nil,
					collision = nil,
					dynamic = nil
				}
				global_var.propZposLock = nil
				global_var.propColor = nil
			elseif (onListChange) == "right" then
				categoryIndex = categoryIndex + 1
				if categoryIndex > #category then
					categoryIndex = 1
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				lastValidHash = nil
				currentObject = {
					index = nil,
					hash = nil,
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					rotX = nil,
					rotY = nil,
					rotZ = nil,
					color = nil,
					visible = nil,
					collision = nil,
					dynamic = nil
				}
				global_var.propZposLock = nil
				global_var.propColor = nil
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-Model"), category[categoryIndex].model, category[categoryIndex].index, nil, { IsDisabled = isPropPickedUp or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) then
				category[categoryIndex].index = Index
			end
			if (onSelected) or (onListChange) then
				DeleteObject(objectPreview)
				objectPreview = nil
				lastValidHash = nil
				currentObject = {
					index = nil,
					hash = nil,
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					rotX = nil,
					rotY = nil,
					rotZ = nil,
					color = nil,
					visible = nil,
					collision = nil,
					dynamic = nil
				}
				global_var.propZposLock = nil
				global_var.propColor = nil
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Place"), (#currentRace.objects >= Config.objectLimit) and GetTranslate("PlacementSubMenu_Props-Button-objectLimit-Desc") or nil, { IsDisabled = isPropPickedUp or (not isPropPickedUp and not objectPreview) or global_var.IsNuiFocused or (#currentRace.objects >= Config.objectLimit) }, function(onSelected)
			if (onSelected) then
				if currentObject.visible then
					ResetEntityAlpha(objectPreview)
				end
				table.insert(currentRace.objects, currentObject)
				blips.objects[currentObject.index] = createBlip(currentObject.x, currentObject.y, currentObject.z, 0.60, 271, 50, currentObject.handle)
				objectIndex = currentObject.index
				objectPreview = nil
				globalRot = {
					x = RoundedValue(currentObject.rotX, 3),
					y = RoundedValue(currentObject.rotY, 3),
					z = RoundedValue(currentObject.rotZ, 3)
				}
				global_var.propColor = currentObject.color
				currentObject = {
					index = nil,
					hash = nil,
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					rotX = nil,
					rotY = nil,
					rotZ = nil,
					color = nil,
					visible = nil,
					collision = nil,
					dynamic = nil
				}
			end
		end)

		Items:AddList("X:", { currentObject.x or "" }, 1, nil, { IsDisabled = not currentObject.x or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				currentObject.x = RoundedValue(currentObject.x - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
			elseif (onListChange) == "right" then
				currentObject.x = RoundedValue(currentObject.x + speed.prop_offset.value[speed.prop_offset.index][2], 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentObject.x)
				})
				nuiCallBack = "prop x"
			end
			if (onListChange) or (onSelected) then
				objectPreview_coords_change = true

				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:AddList("Y:", { currentObject.y or "" }, 1, nil, { IsDisabled = not currentObject.y or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.y then
				currentObject.y = RoundedValue(currentObject.y - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
			elseif (onListChange) == "right" and currentObject.y then
				currentObject.y = RoundedValue(currentObject.y + speed.prop_offset.value[speed.prop_offset.index][2], 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentObject.y)
				})
				nuiCallBack = "prop y"
			end
			if (onListChange) or (onSelected) then
				objectPreview_coords_change = true

				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:AddList("Z:", { currentObject.z or "" }, 1, nil, { IsDisabled = not currentObject.z or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.z then
				local newZ = RoundedValue(currentObject.z - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (newZ > -198.99) and (newZ <= 2698.99) then
					currentObject.z = newZ
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			elseif (onListChange) == "right" and currentObject.z then
				local newZ = RoundedValue(currentObject.z + speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (newZ > -198.99) and (newZ <= 2698.99) then
					currentObject.z = newZ
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentObject.z)
				})
				nuiCallBack = "prop z"
			end
			if (onListChange) or (onSelected) then
				objectPreview_coords_change = true

				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					global_var.propZposLock = currentObject.z
				end
			end
		end)

		Items:AddList("Rot X:", { currentObject.rotX or "" }, 1, nil, { IsDisabled = not currentObject.rotX or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.rotX then
				currentObject.rotX = RoundedValue(currentObject.rotX - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotX > 9999.0) or (currentObject.rotX < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotX = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.x = RoundedValue(currentObject.rotX, 3)
				end
			elseif (onListChange) == "right" and currentObject.rotX then
				currentObject.rotX = RoundedValue(currentObject.rotX + speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotX > 9999.0) or (currentObject.rotX < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotX = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.x = RoundedValue(currentObject.rotX, 3)
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentObject.rotX)
				})
				nuiCallBack = "prop rotX"
			end
		end)

		Items:AddList("Rot Y:", { currentObject.rotY or "" }, 1, nil, { IsDisabled = not currentObject.rotY or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.rotY then
				currentObject.rotY = RoundedValue(currentObject.rotY - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotY > 9999.0) or (currentObject.rotY < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotY = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.y = RoundedValue(currentObject.rotY, 3)
				end
			elseif (onListChange) == "right" and currentObject.rotY then
				currentObject.rotY = RoundedValue(currentObject.rotY + speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotY > 9999.0) or (currentObject.rotY < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotY = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.y = RoundedValue(currentObject.rotY, 3)
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentObject.rotY)
				})
				nuiCallBack = "prop rotY"
			end
		end)

		Items:AddList("Rot Z:", { currentObject.rotZ or "" }, 1, nil, { IsDisabled = not currentObject.rotZ or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.rotZ then
				currentObject.rotZ = RoundedValue(currentObject.rotZ - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotZ > 9999.0) or (currentObject.rotZ < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotZ = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.z = RoundedValue(currentObject.rotZ, 3)
				end
			elseif (onListChange) == "right" and currentObject.rotZ then
				currentObject.rotZ = RoundedValue(currentObject.rotZ + speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotZ > 9999.0) or (currentObject.rotZ < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotZ = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.z = RoundedValue(currentObject.rotZ, 3)
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(currentObject.rotZ)
				})
				nuiCallBack = "prop rotZ"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-ChangeSpeed"), { speed.prop_offset.value[speed.prop_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				speed.prop_offset.index = speed.prop_offset.index - 1
				if speed.prop_offset.index < 1 then
					speed.prop_offset.index = #speed.prop_offset.value
				end
			elseif (onListChange) == "right" then
				speed.prop_offset.index = speed.prop_offset.index + 1
				if speed.prop_offset.index > #speed.prop_offset.value then
					speed.prop_offset.index = 1
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Override"), nil, { IsDisabled = global_var.IsNuiFocused or (not isPropPickedUp and not objectPreview) }, function(onSelected)
			if (onSelected) then
				objectPreview_coords_change = true
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = "x = " .. (currentObject.x) .. ", y = " .. (currentObject.y) .. ", z = " .. (currentObject.z) .. ", rotX = " .. (currentObject.rotX) .. ", rotY = " .. (currentObject.rotY) .. ", rotZ = " .. (currentObject.rotZ)
				})
				nuiCallBack = "prop override"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-Color"), { currentObject.color or "" }, 1, nil, { IsDisabled = not currentObject.color or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.color then
				currentObject.color = currentObject.color - 1
				if currentObject.color < 0 then
					currentObject.color = 15
				end
				SetObjectTextureVariant(currentObject.handle, currentObject.color)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					global_var.propColor = currentObject.color
				end
			elseif (onListChange) == "right" and currentObject.color then
				currentObject.color = currentObject.color + 1
				if currentObject.color > 15 then
					currentObject.color = 0
				end
				SetObjectTextureVariant(currentObject.handle, currentObject.color)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					global_var.propColor = currentObject.color
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Visible"), nil, currentObject.visible, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and currentObject.handle then
				if currentObject.dynamic then
					DisplayCustomMsgs(GetTranslate("visible-dynamic"))
				else
					currentObject.visible = IsChecked
					if IsChecked then
						ResetEntityAlpha(currentObject.handle)
					else
						SetEntityAlpha(currentObject.handle, 150)
					end
					if isPropPickedUp and currentRace.objects[objectIndex] then
						currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Collision"), nil, currentObject.collision, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and currentObject.handle then
				currentObject.collision = IsChecked
				if IsChecked then
					SetEntityCollision(currentObject.handle, true, true)
				else
					SetEntityCollision(currentObject.handle, false, false)
				end
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Dynamic"), nil, currentObject.dynamic, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and currentObject.handle then
				currentObject.dynamic = IsChecked
				if IsChecked then
					if not currentObject.visible then
						ResetEntityAlpha(currentObject.handle)
						currentObject.visible = true
						DisplayCustomMsgs(GetTranslate("visible-dynamic"))
					end
				end
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isPropPickedUp), Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				objectSelect = nil
				isPropPickedUp = false
				DeleteObject(currentObject.handle)
				for k, v in pairs(currentRace.objects) do
					if currentObject.handle == v.handle then
						table.remove(currentRace.objects, k)
						table.remove(blips.objects, k)
						break
					end
				end
				for k, v in pairs(currentRace.objects) do
					v.index = k
				end
				if objectIndex > #currentRace.objects then
					objectIndex = #currentRace.objects
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-CycleItems"), { objectIndex .. " / " .. #currentRace.objects }, 1, nil, { IsDisabled = #currentRace.objects == 0 or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				objectIndex = objectIndex - 1
				if objectIndex < 1 then
					objectIndex = #currentRace.objects
				end
				isPropPickedUp = true
				currentObject = tableDeepCopy(currentRace.objects[objectIndex])
				global_var.propZposLock = currentObject.z
				globalRot.x = RoundedValue(currentObject.rotX, 3)
				globalRot.y = RoundedValue(currentObject.rotY, 3)
				globalRot.z = RoundedValue(currentObject.rotZ, 3)
				global_var.propColor = currentObject.color
				lastValidHash = GetEntityModel(currentObject.handle)
				local found = false
				for k, v in pairs(category) do
					if not found then
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
					end
				end
				if not found then
					local hash_2 = tonumber(lastValidText) or GetHashKey(lastValidText)
					if lastValidHash ~= hash_2 then
						lastValidText = tostring(lastValidHash) or ""
					end
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				if objectSelect then
					SetEntityDrawOutline(objectSelect, false)
				end
				SetEntityDrawOutlineColor(255, 255, 255, 125)
				SetEntityDrawOutline(currentObject.handle, true)
				objectSelect = currentObject.handle
				local min, max = GetModelDimensions(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			elseif (onListChange) == "right" then
				objectIndex = objectIndex + 1
				if objectIndex > #currentRace.objects then
					objectIndex = 1
				end
				isPropPickedUp = true
				currentObject = tableDeepCopy(currentRace.objects[objectIndex])
				global_var.propZposLock = currentObject.z
				globalRot.x = RoundedValue(currentObject.rotX, 3)
				globalRot.y = RoundedValue(currentObject.rotY, 3)
				globalRot.z = RoundedValue(currentObject.rotZ, 3)
				global_var.propColor = currentObject.color
				lastValidHash = GetEntityModel(currentObject.handle)
				local found = false
				for k, v in pairs(category) do
					if not found then
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
					end
				end
				if not found then
					local hash_2 = tonumber(lastValidText) or GetHashKey(lastValidText)
					if lastValidHash ~= hash_2 then
						lastValidText = tostring(lastValidHash) or ""
					end
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				if objectSelect then
					SetEntityDrawOutline(objectSelect, false)
				end
				SetEntityDrawOutlineColor(255, 255, 255, 125)
				SetEntityDrawOutline(currentObject.handle, true)
				objectSelect = currentObject.handle
				local min, max = GetModelDimensions(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			end
			if (onSelected) then
				isPropPickedUp = true
				currentObject = tableDeepCopy(currentRace.objects[objectIndex])
				global_var.propZposLock = currentObject.z
				globalRot.x = RoundedValue(currentObject.rotX, 3)
				globalRot.y = RoundedValue(currentObject.rotY, 3)
				globalRot.z = RoundedValue(currentObject.rotZ, 3)
				global_var.propColor = currentObject.color
				lastValidHash = GetEntityModel(currentObject.handle)
				local found = false
				for k, v in pairs(category) do
					if not found then
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
					end
				end
				if not found then
					local hash_2 = tonumber(lastValidText) or GetHashKey(lastValidText)
					if lastValidHash ~= hash_2 then
						lastValidText = tostring(lastValidHash) or ""
					end
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				if objectSelect then
					SetEntityDrawOutline(objectSelect, false)
				end
				SetEntityDrawOutlineColor(255, 255, 255, 125)
				SetEntityDrawOutline(currentObject.handle, true)
				objectSelect = currentObject.handle
				local min, max = GetModelDimensions(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Templates:IsVisible(function(Items)
		Items:AddList(GetTranslate("PlacementSubMenu_Templates-List-Templates"), { templateIndex .. " / " .. #template }, 1, nil, { IsDisabled = (#template == 0) or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				templateIndex = templateIndex - 1
				if templateIndex < 1 then
					templateIndex = #template
				end
				for i = 1, #templatePreview do
					DeleteObject(templatePreview[i].handle)
				end
				templatePreview = {}
			elseif (onListChange) == "right" then
				templateIndex = templateIndex + 1
				if templateIndex > #template then
					templateIndex = 1
				end
				for i = 1, #templatePreview do
					DeleteObject(templatePreview[i].handle)
				end
				templatePreview = {}
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate"), (#template >= Config.templateLimit) and GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate-Desc1") or GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate-Desc2"), { IsDisabled = (#currentTemplate.props <= 1) or global_var.IsNuiFocused or (#template >= Config.templateLimit) }, function(onSelected)
			if (onSelected) then
				for i = 1, #currentTemplate.props do
					SetEntityDrawOutline(currentTemplate.props[i].handle, false)
				end
				currentTemplate.index = #template + 1
				table.insert(template, currentTemplate)
				templateIndex = #template
				currentTemplate = {
					index = nil,
					props = {}
				}
				isTemplatePropPickedUp = false
				TriggerServerEvent('custom_creator:server:save_template', template)
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-PlaceTemplate"), nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused }, function(onSelected)
			if (onSelected) then
				if not isTemplatePropPickedUp then
					objectIndex = #currentRace.objects + (#templatePreview)
					SetEntityDrawOutline(templatePreview[1].handle, false)
					for i = 1, #templatePreview do
						if i > 1 then
							DetachEntity(templatePreview[i].handle, false, true)
						end
						if templatePreview[i].visible then
							ResetEntityAlpha(templatePreview[i].handle)
						end
						if templatePreview[i].collision then
							SetEntityCollision(templatePreview[i].handle, true, true)
						end
						local coords = GetEntityCoords(templatePreview[i].handle)
						local rotation = GetEntityRotation(templatePreview[i].handle, 2)
						templatePreview[i].x = RoundedValue(coords.x, 3)
						templatePreview[i].y = RoundedValue(coords.y, 3)
						templatePreview[i].z = RoundedValue(coords.z, 3)
						templatePreview[i].rotX = RoundedValue(rotation.x, 3)
						templatePreview[i].rotY = RoundedValue(rotation.y, 3)
						templatePreview[i].rotZ = RoundedValue(rotation.z, 3)
						table.insert(currentRace.objects, templatePreview[i])
						blips.objects[templatePreview[i].index] = createBlip(templatePreview[i].x, templatePreview[i].y, templatePreview[i].z, 0.60, 271, 50, templatePreview[i].handle)
					end
					templatePreview = {}
				end
			end
		end)

		Items:AddList("X:", {templatePreview[1] and templatePreview[1].x or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused}, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				templatePreview[1].x = RoundedValue(templatePreview[1].x - speed.template_offset.value[speed.template_offset.index][2], 3)
				SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
			elseif (onListChange) == "right" then
				templatePreview[1].x = RoundedValue(templatePreview[1].x + speed.template_offset.value[speed.template_offset.index][2], 3)
				SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(templatePreview[1] and templatePreview[1].x)
				})
				nuiCallBack = "template x"
			end
			if (onListChange) or (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
			end
		end)

		Items:AddList("Y:", {templatePreview[1] and templatePreview[1].y or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				templatePreview[1].y = RoundedValue(templatePreview[1].y - speed.template_offset.value[speed.template_offset.index][2], 3)
				SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
			elseif (onListChange) == "right" then
				templatePreview[1].y = RoundedValue(templatePreview[1].y + speed.template_offset.value[speed.template_offset.index][2], 3)
				SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(templatePreview[1] and templatePreview[1].y)
				})
				nuiCallBack = "template y"
			end

			if (onListChange) or (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
			end
		end)

		Items:AddList("Z:", {templatePreview[1] and templatePreview[1].z or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local newZ = RoundedValue(templatePreview[1].z - speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newZ > -198.99) and (newZ <= 2698.99) then
					templatePreview[1].z = newZ
					SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			elseif (onListChange) == "right" then
				local newZ = RoundedValue(templatePreview[1].z + speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newZ > -198.99) and (newZ <= 2698.99) then
					templatePreview[1].z = newZ
					SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(templatePreview[1] and templatePreview[1].z)
				})
				nuiCallBack = "template z"
			end
			if (onListChange) or (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
			end
		end)

		Items:AddList("Rot X:", {templatePreview[1] and templatePreview[1].rotX or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local newRot = RoundedValue(templatePreview[1].rotX - speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotX = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif (onListChange) == "right" then
				local newRot = RoundedValue(templatePreview[1].rotX + speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotX = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(templatePreview[1] and templatePreview[1].rotX)
				})
				nuiCallBack = "template rotX"
			end
			if (onListChange) or (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
			end
		end)

		Items:AddList("Rot Y:", {templatePreview[1] and templatePreview[1].rotY or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local newRot = RoundedValue(templatePreview[1].rotY - speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotY = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif (onListChange) == "right" then
				local newRot = RoundedValue(templatePreview[1].rotY + speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotY = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(templatePreview[1] and templatePreview[1].rotY)
				})
				nuiCallBack = "template rotY"
			end
			if (onListChange) or (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
			end
		end)

		Items:AddList("Rot Z:", {templatePreview[1] and templatePreview[1].rotZ or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local newRot = RoundedValue(templatePreview[1].rotZ - speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotZ = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif (onListChange) == "right" then
				local newRot = RoundedValue(templatePreview[1].rotZ + speed.template_offset.value[speed.template_offset.index][2], 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotZ = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			end
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(templatePreview[1] and templatePreview[1].rotZ)
				})
				nuiCallBack = "template rotZ"
			end
			if (onListChange) or (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Templates-List-ChangeSpeed"), { speed.template_offset.value[speed.template_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				speed.template_offset.index = speed.template_offset.index - 1
				if speed.template_offset.index < 1 then
					speed.template_offset.index = #speed.template_offset.value
				end
			elseif (onListChange) == "right" then
				speed.template_offset.index = speed.template_offset.index + 1
				if speed.template_offset.index > #speed.template_offset.value then
					speed.template_offset.index = 1
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-Override"), nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused }, function(onSelected)
			if (onSelected) then
				templatePreview_coords_change = true
				for i = 1, #templatePreview do
					if templatePreview[i].collision then
						SetEntityCollision(templatePreview[i].handle, true, true)
					end
				end
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = "x = " .. (templatePreview[1] and templatePreview[1].x) .. ", y = " .. (templatePreview[1] and templatePreview[1].y) .. ", z = " .. (templatePreview[1] and templatePreview[1].z) .. ", rotX = " .. (templatePreview[1] and templatePreview[1].rotX) .. ", rotY = " .. (templatePreview[1] and templatePreview[1].rotY) .. ", rotZ = " .. (templatePreview[1] and templatePreview[1].rotZ)
				})
				nuiCallBack = "template override"
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-Delete"), nil, { IsDisabled = (#templatePreview == 0) or (#template == 0) or global_var.IsNuiFocused, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				for i = 1, #templatePreview do
					DeleteObject(templatePreview[i].handle)
				end
				templatePreview = {}
				for k, v in pairs(template) do
					if v.index == templateIndex then
						table.remove(template, k)
						break
					end
				end
				for k, v in pairs(template) do
					v.index = k
				end
				if templateIndex > #template then
					templateIndex = #template
				end
				TriggerServerEvent('custom_creator:server:save_template', template)
			end
		end)
	end, function(Panels)
	end)

	WeatherSubMenu:IsVisible(function(Items)
		for _, weatherName in pairs(weatherTypes) do
			Items:AddButton(GetTranslate(weatherName), nil, { IsDisabled = false }, function(onSelected)
				if (onSelected) then
					SetWeatherTypeNowPersist(weatherName)
					if weatherName == 'XMAS' then
						SetForceVehicleTrails(true)
						SetForcePedFootstepsTracks(true)
					else
						SetForceVehicleTrails(false)
						SetForcePedFootstepsTracks(false)
					end
					if weatherName == 'RAIN' then
						SetRainLevel(0.3)
					elseif weatherName == 'THUNDER' then
						SetRainLevel(0.5)
					else
						SetRainLevel(0.0)
					end
				end
			end)
		end
	end, function(Panels)
	end)

	TimeSubMenu:IsVisible(function(Items)
		Items:AddList(GetTranslate("Hours"), hours, hourIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				hour = Index - 1
				NetworkOverrideClockTime(hour, GetClockMinutes(), GetClockSeconds())
			end
		end)

		Items:AddList(GetTranslate("Minutes"), minutes, minuteIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				minute = Index - 1
				NetworkOverrideClockTime(GetClockHours(), minute, GetClockSeconds())
			end
		end)

		Items:AddList(GetTranslate("Seconds"), seconds, secondIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) then
				second = Index - 1
				NetworkOverrideClockTime(GetClockHours(), GetClockMinutes(), second)
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
				speed.cam_pos.index = speed.cam_pos.index - 1
				if speed.cam_pos.index < 1 then
					speed.cam_pos.index = #speed.cam_pos.value
				end
			elseif (onListChange) == "right" then
				speed.cam_pos.index = speed.cam_pos.index + 1
				if speed.cam_pos.index > #speed.cam_pos.value then
					speed.cam_pos.index = 1
				end
			end
		end)

		Items:AddList(GetTranslate("MiscSubMenu-List-CamRotateSpeed"), { speed.cam_rot.value[speed.cam_rot.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				speed.cam_rot.index = speed.cam_rot.index - 1
				if speed.cam_rot.index < 1 then
					speed.cam_rot.index = #speed.cam_rot.value
				end
			elseif (onListChange) == "right" then
				speed.cam_rot.index = speed.cam_rot.index + 1
				if speed.cam_rot.index > #speed.cam_rot.value then
					speed.cam_rot.index = 1
				end
			end
		end)

		Items:CheckBox(GetTranslate("MiscSubMenu-CheckBox-RadarBigmap"), nil, global_var.RadarBigmapChecked, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) then
				global_var.RadarBigmapChecked = IsChecked
				SetRadarBigmapEnabled(global_var.RadarBigmapChecked, false)
			end
		end)
	end, function(Panels)
	end)
end