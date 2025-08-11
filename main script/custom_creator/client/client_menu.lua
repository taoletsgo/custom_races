MainMenu = RageUI.CreateMenu(GetTranslate("MainMenu-Title"), GetTranslate("MainMenu-Subtitle"), true)

RaceDetailSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("RaceDetailSubMenu-Subtitle"), false)

PlacementSubMenu = RageUI.CreateSubMenu(MainMenu, "", GetTranslate("PlacementSubMenu-Subtitle"), false)
PlacementSubMenu_StartingGrid = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_StartingGrid-Subtitle"), false)
PlacementSubMenu_Checkpoints = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Checkpoints-Subtitle"), false)
PlacementSubMenu_Props = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Props-Subtitle"), false)
PlacementSubMenu_Templates = RageUI.CreateSubMenu(PlacementSubMenu, "", GetTranslate("PlacementSubMenu_Templates-Subtitle"), false)
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
						action = 'open',
						value = currentRace.title
					})
					nuiCallBack = "race title"
				end
				if global_var.previewThumbnail ~= "" then
					global_var.previewThumbnail = ""
					SendNUIMessage({
						action = 'thumbnail_preview_off'
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
			end)

			if global_var.querying then
				Items:AddButton(GetTranslate("MainMenu-Button-Cancel"), nil, { IsDisabled = false }, function(onSelected)
					if (onSelected) then
						TriggerServerEvent('custom_creator:server:cancel')
					end
				end)
			end

			Items:AddButton(GetTranslate("MainMenu-Button-Multiplayer"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = ">>>" }, function(onSelected)

			end, MultiplayerSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Weather"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = ">>>" }, function(onSelected)

			end, WeatherSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Time"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = ">>>" }, function(onSelected)

			end, TimeSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Misc"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = ">>>" }, function(onSelected)

			end, MiscSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Exit"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if (onSelected) then
					RageUI.QuitIndex = nil
					TriggerEvent('custom_creator:unload')
					DisableControlAction(0, 140, true)
					Citizen.CreateThread(function()
						local delay = GetGameTimer()
						while (GetGameTimer() - delay) <= 1000 do
							DisableControlAction(0, 140, true)
							DisableControlAction(0, 244, true)
							Citizen.Wait(0)
						end
					end)
					Citizen.CreateThread(function()
						SetRadarBigmapEnabled(false, false)
						Citizen.Wait(0)
						SetRadarZoom(0)
					end)
					RemoveBlip(global_var.creatorBlipHandle)
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
						blimp_text = "",
						startingGrid = {},
						checkpoints = {},
						checkpoints_2 = {},
						transformVehicles = {0, -422877666, -731262150, "bmx", "xa21"},
						objects = {},
						fixtures = {},
						firework = {
							name = "scr_indep_firework_trailburst",
							r = 255,
							g = 255,
							b = 255
						}
					}
					startingGridVehicleIndex = 0
					checkpointIndex = 0
					objectIndex = 0
					fixtureIndex = 0
					particleIndex = 1
					globalRot = {
						x = 0.0,
						y = 0.0,
						z = 0.0
					}
					global_var = {
						timeChecked = false,
						IsBigmapActive = false,
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
						testBlipHandle_2 = nil,
						creatorBlipHandle = nil,
						respawnData = {},
						autoRespawn = true,
						isRespawning = false,
						isTransforming = false,
						enableBeastMode = false,
						DisableNpcChecked = false,
						showAllModelCheckedMsg = false
					}
					blimp = {
						scaleform = nil,
						rendertarget = nil
					}
					ReleaseNamedRendertarget("blimp_text")
					Citizen.CreateThread(function()
						RageUI.CloseAll(true)
						Citizen.Wait(0)
						local ped = PlayerPedId()
						if joinCreatorVehicle ~= 0 then
							if DoesEntityExist(joinCreatorVehicle) then
								SetEntityCoords(joinCreatorVehicle, joinCreatorPoint)
								SetEntityHeading(joinCreatorVehicle, joinCreatorHeading)
								SetEntityVisible(joinCreatorVehicle, true)
								SetEntityCollision(joinCreatorVehicle, true, true)
								SetPedIntoVehicle(ped, joinCreatorVehicle, -1)
							else
								SetEntityCoords(ped, joinCreatorPoint)
								SetEntityHeading(ped, joinCreatorHeading)
							end
						else
							SetEntityCoordsNoOffset(ped, joinCreatorPoint)
							SetEntityHeading(ped, joinCreatorHeading)
						end
						SetEntityVisible(ped, true)
						SetEntityCollision(ped, true, true)
						SetEntityCompletelyDisableCollision(ped, true, true)
						FreezeEntityPosition(ped, false)
						if DoesEntityExist(joinCreatorVehicle) then
							FreezeEntityPosition(joinCreatorVehicle, false)
							ActivatePhysics(joinCreatorVehicle)
						end
						SetBlipAlpha(GetMainPlayerBlipId(), 255)
						SetLocalPlayerAsGhost(false)
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						SetGameplayCamRelativeHeading(0)
						camera = nil
						cameraPosition = nil
						cameraRotation = nil
						joinCreatorPoint = nil
						joinCreatorHeading = nil
						joinCreatorVehicle = 0
					end)
				end
			end)

			Items:AddSeparator(GetTranslate("MainMenu-Separator-Load"))

			Items:AddButton(GetTranslate("MainMenu-Button-Filter"), nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock }, function(onSelected)
				if (onSelected) then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = 'open',
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
						action = 'thumbnail_preview_off'
					})
				end
			end)

			for i = 1, #races_data.category[races_data.index].data do
				Items:AddButton(races_data.category[races_data.index].data[i].name, nil, { IsDisabled = global_var.IsNuiFocused or global_var.lock, RightLabel = races_data.category[races_data.index].data[i].published and "√" or "x" }, function(onSelected)
					if global_var.previewThumbnail ~= races_data.category[races_data.index].data[i].img and not global_var.lock then
						global_var.previewThumbnail = races_data.category[races_data.index].data[i].img
						SendNUIMessage({
							action = 'thumbnail_preview',
							preview_url = global_var.previewThumbnail
						})
					end
					if (onSelected) then
						global_var.lock = true
						RageUI.QuitIndex = RageUI.CurrentMenu.Index
						Citizen.CreateThread(function()
							TriggerServerCallback('custom_creator:server:get_json', function(data, data_2, inSessionPlayers)
								if data and not data_2 then
									convertJsonData(data)
									global_var.thumbnailValid = false
									global_var.previewThumbnail = ""
									SendNUIMessage({
										action = 'thumbnail_preview_off'
									})
									SendNUIMessage({
										action = 'thumbnail_url',
										thumbnail_url = currentRace.thumbnail
									})
									DisplayCustomMsgs(GetTranslate("load-success"))
									if not inSession and currentRace.raceid then
										inSession = true
										lockSession = true
										multiplayer.inSessionPlayers = {}
										table.insert(multiplayer.inSessionPlayers, { playerId = myServerId, playerName = GetPlayerName(PlayerId()) })
										TriggerServerCallback('custom_creator:server:sessionData', function()
											lockSession = false
										end, currentRace.raceid, currentRace)
									end
								elseif data and data_2 then
									loadSessionData(data, data_2)
									global_var.thumbnailValid = false
									global_var.previewThumbnail = ""
									SendNUIMessage({
										action = 'thumbnail_preview_off'
									})
									SendNUIMessage({
										action = 'thumbnail_url',
										thumbnail_url = currentRace.thumbnail
									})
									DisplayCustomMsgs(GetTranslate("join-session-success"))
									TriggerServerEvent('custom_creator:server:loadDone', currentRace.raceid)
									multiplayer.inSessionPlayers = inSessionPlayers
									inSession = true
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
			Items:AddButton(GetTranslate("MainMenu-Button-RaceDetail"), nil, { IsDisabled = global_var.lock or lockSession, RightLabel = ">>>" }, function(onSelected)

			end, RaceDetailSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Placement"), nil, { IsDisabled = global_var.lock or lockSession, RightLabel = ">>>" }, function(onSelected)

			end, PlacementSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Multiplayer"), nil, { IsDisabled = global_var.lock or lockSession, RightLabel = ">>>" }, function(onSelected)

			end, MultiplayerSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Weather"), nil, { IsDisabled = global_var.lock or lockSession, RightLabel = ">>>" }, function(onSelected)

			end, WeatherSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Time"), nil, { IsDisabled = global_var.lock or lockSession, RightLabel = ">>>" }, function(onSelected)

			end, TimeSubMenu)

			if currentRace.published then
				Items:AddButton(GetTranslate("MainMenu-Button-Update"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
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

				Items:AddButton(GetTranslate("MainMenu-Button-CancelPublish"), GetTranslate("MainMenu-Button-CancelPublish-Desc"), { IsDisabled = global_var.lock or lockSession }, function(onSelected)
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
				Items:AddButton(GetTranslate("MainMenu-Button-Save"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
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
								if not inSession and currentRace.raceid then
									inSession = true
									multiplayer.inSessionPlayers = {}
									table.insert(multiplayer.inSessionPlayers, { playerId = myServerId, playerName = GetPlayerName(PlayerId()) })
									TriggerServerEvent('custom_creator:server:createSession', currentRace.raceid, currentRace)
								end
								global_var.lock = false
							end, convertRaceToUGC(currentRace), "save")
						end)
					end
				end)

				Items:AddButton(GetTranslate("MainMenu-Button-Publish"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
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
								if not inSession and currentRace.raceid then
									inSession = true
									multiplayer.inSessionPlayers = {}
									table.insert(multiplayer.inSessionPlayers, { playerId = myServerId, playerName = GetPlayerName(PlayerId()) })
									TriggerServerEvent('custom_creator:server:createSession', currentRace.raceid, currentRace)
								end
								global_var.lock = false
							end, convertRaceToUGC(currentRace), "publish")
						end)
					end
				end)
			end

			Items:AddButton(GetTranslate("MainMenu-Button-Export"), (not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown")) and GetTranslate("MainMenu-Button-Save-Desc") or nil, { IsDisabled = global_var.lock or not global_var.thumbnailValid or (#currentRace.startingGrid == 0) or (#currentRace.checkpoints < 10) or (#currentRace.objects == 0) or (currentRace.title == "unknown") or lockSession }, function(onSelected)
				if (onSelected) then
					global_var.lock = true
					Citizen.CreateThread(function()
						TriggerServerCallback('custom_creator:server:export_file', function(str)
							if str == "success" then
								DisplayCustomMsgs(GetTranslate("export-success"))
							elseif str == "failed" then
								DisplayCustomMsgs(GetTranslate("export-failed"))
							elseif str == "denied" then
								DisplayCustomMsgs(GetTranslate("no-permission"))
							elseif str == "no discord" then
								DisplayCustomMsgs(GetTranslate("no-discord"))
							end
							global_var.lock = false
						end, convertRaceToUGC(currentRace))
					end)
				end
			end)

			Items:AddButton(GetTranslate("MainMenu-Button-Misc"), nil, { IsDisabled = global_var.lock or lockSession, RightLabel = ">>>" }, function(onSelected)

			end, MiscSubMenu)

			Items:AddButton(GetTranslate("MainMenu-Button-Exit"), nil, { IsDisabled = global_var.lock or lockSession }, function(onSelected)
				if (onSelected) then
					if inSession then
						inSession = false
						modificationCount = {
							title = 0,
							thumbnail = 0,
							test_vehicle = 0,
							blimp_text = 0,
							transformVehicles = 0,
							startingGrid = 0,
							checkpoints = 0,
							fixtures = 0,
							firework = 0
						}
						for i = 1, #multiplayer.inSessionPlayers do
							if multiplayer.inSessionPlayers[i].blip and DoesBlipExist(multiplayer.inSessionPlayers[i].blip) then
								RemoveBlip(multiplayer.inSessionPlayers[i].blip)
							end
						end
						multiplayer.inSessionPlayers = {}
						TriggerServerEvent('custom_creator:server:leaveSession', currentRace.raceid)
					end
					TriggerEvent('custom_creator:unload')
					DisableControlAction(0, 140, true)
					Citizen.CreateThread(function()
						local delay = GetGameTimer()
						while (GetGameTimer() - delay) <= 1000 do
							DisableControlAction(0, 140, true)
							DisableControlAction(0, 244, true)
							Citizen.Wait(0)
						end
					end)
					Citizen.CreateThread(function()
						SetRadarBigmapEnabled(false, false)
						Citizen.Wait(0)
						SetRadarZoom(0)
					end)
					RemoveBlip(global_var.creatorBlipHandle)
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
						blimp_text = "",
						startingGrid = {},
						checkpoints = {},
						checkpoints_2 = {},
						transformVehicles = {0, -422877666, -731262150, "bmx", "xa21"},
						objects = {},
						fixtures = {},
						firework = {
							name = "scr_indep_firework_trailburst",
							r = 255,
							g = 255,
							b = 255
						}
					}
					startingGridVehicleIndex = 0
					checkpointIndex = 0
					objectIndex = 0
					fixtureIndex = 0
					particleIndex = 1
					globalRot = {
						x = 0.0,
						y = 0.0,
						z = 0.0
					}
					global_var = {
						timeChecked = false,
						IsBigmapActive = false,
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
						testBlipHandle_2 = nil,
						creatorBlipHandle = nil,
						respawnData = {},
						autoRespawn = true,
						isRespawning = false,
						isTransforming = false,
						enableBeastMode = false,
						DisableNpcChecked = false,
						showAllModelCheckedMsg = false
					}
					blimp = {
						scaleform = nil,
						rendertarget = nil
					}
					ReleaseNamedRendertarget("blimp_text")
					Citizen.CreateThread(function()
						RageUI.CloseAll(true)
						Citizen.Wait(0)
						local ped = PlayerPedId()
						if joinCreatorVehicle ~= 0 then
							if DoesEntityExist(joinCreatorVehicle) then
								SetEntityCoords(joinCreatorVehicle, joinCreatorPoint)
								SetEntityHeading(joinCreatorVehicle, joinCreatorHeading)
								SetEntityVisible(joinCreatorVehicle, true)
								SetEntityCollision(joinCreatorVehicle, true, true)
								SetPedIntoVehicle(ped, joinCreatorVehicle, -1)
							else
								SetEntityCoords(ped, joinCreatorPoint)
								SetEntityHeading(ped, joinCreatorHeading)
							end
						else
							SetEntityCoordsNoOffset(ped, joinCreatorPoint)
							SetEntityHeading(ped, joinCreatorHeading)
						end
						SetEntityVisible(ped, true)
						SetEntityCollision(ped, true, true)
						SetEntityCompletelyDisableCollision(ped, true, true)
						FreezeEntityPosition(ped, false)
						if DoesEntityExist(joinCreatorVehicle) then
							FreezeEntityPosition(joinCreatorVehicle, false)
							ActivatePhysics(joinCreatorVehicle)
						end
						SetBlipAlpha(GetMainPlayerBlipId(), 255)
						SetLocalPlayerAsGhost(false)
						RenderScriptCams(false, false, 0, true, false)
						DestroyCam(camera, false)
						SetGameplayCamRelativeHeading(0)
						camera = nil
						cameraPosition = nil
						cameraRotation = nil
						joinCreatorPoint = nil
						joinCreatorHeading = nil
						joinCreatorVehicle = 0
					end)
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
					action = 'open',
					value = currentRace.title
				})
				nuiCallBack = "race title"
			end
		end)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-Thumbnail"), not global_var.thumbnailValid and GetTranslate("RaceDetailSubMenu-Button-Thumbnail-Desc"), { IsDisabled = global_var.IsNuiFocused or lockSession, Color = not global_var.thumbnailValid and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
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

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-TestVeh"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = currentRace.test_vehicle
				})
				nuiCallBack = "test vehicle"
			end
		end)

		Items:AddButton(GetTranslate("RaceDetailSubMenu-Button-Blimp"), nil, { IsDisabled = global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = currentRace.blimp_text
				})
				nuiCallBack = "blimp text"
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu-Button-StartingGrid"), (#currentRace.startingGrid == 0) and GetTranslate("PlacementSubMenu-Button-StartingGrid-Desc"), { IsDisabled = false, RightLabel = ">>>", Color = (#currentRace.startingGrid == 0) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_StartingGrid)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Checkpoints"), (#currentRace.checkpoints < 10) and GetTranslate("PlacementSubMenu-Button-Checkpoints-Desc"), { IsDisabled = false, RightLabel = ">>>", Color = (#currentRace.checkpoints < 10) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_Checkpoints)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Props"), (#currentRace.objects == 0) and GetTranslate("PlacementSubMenu-Button-Props-Desc"), { IsDisabled = false, RightLabel = ">>>", Color = (#currentRace.objects == 0) and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)

		end, PlacementSubMenu_Props)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Templates"), nil, { IsDisabled = false, RightLabel = ">>>" }, function(onSelected)

		end, PlacementSubMenu_Templates)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-MoveAll"), nil, { IsDisabled = false, RightLabel = ">>>" }, function(onSelected)

		end, PlacementSubMenu_MoveAll)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-FixtureRemover"), nil, { IsDisabled = false, RightLabel = ">>>" }, function(onSelected)

		end, PlacementSubMenu_FixtureRemover)

		Items:AddButton(GetTranslate("PlacementSubMenu-Button-Firework"), nil, { IsDisabled = false, RightLabel = ">>>" }, function(onSelected)

		end, PlacementSubMenu_Firework)
	end, function(Panels)
	end)

	PlacementSubMenu_StartingGrid:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu_StartingGrid-Button-Place"), (#currentRace.startingGrid >= Config.StartingGridLimit) and GetTranslate("PlacementSubMenu_StartingGrid-Button-startingGridLimit-Desc") or nil, { IsDisabled = isStartingGridVehiclePickedUp or global_var.IsNuiFocused or (not startingGridVehicleSelect and not startingGridVehiclePreview) or (#currentRace.startingGrid >= Config.StartingGridLimit) or lockSession }, function(onSelected)
			if (onSelected) then
				if not isStartingGridVehiclePickedUp and startingGridVehiclePreview then
					ResetEntityAlpha(startingGridVehiclePreview)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutlineShader(1)
					SetEntityDrawOutline(startingGridVehiclePreview, true)
					table.insert(currentRace.startingGrid, currentstartingGridVehicle)
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, insertIndex = #currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
					startingGridVehicleIndex = #currentRace.startingGrid
					startingGridVehiclePreview = nil
					globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
					currentstartingGridVehicle = {
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-Heading"), { (not startingGridVehicleSelect and not startingGridVehiclePreview) and "" or currentstartingGridVehicle.heading }, 1, nil, { IsDisabled = (not startingGridVehicleSelect and not startingGridVehiclePreview) or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
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
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
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

		Items:AddButton(GetTranslate("PlacementSubMenu_StartingGrid-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isStartingGridVehiclePickedUp) or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				startingGridVehicleSelect = nil
				isStartingGridVehiclePickedUp = false
				DeleteVehicle(currentstartingGridVehicle.handle)
				local deleteIndex = 0
				for k, v in pairs(currentRace.startingGrid) do
					if currentstartingGridVehicle.handle == v.handle then
						deleteIndex = k
						table.remove(currentRace.startingGrid, k)
						break
					end
				end
				if startingGridVehicleIndex > #currentRace.startingGrid then
					startingGridVehicleIndex = #currentRace.startingGrid
				end
				if inSession then
					modificationCount.startingGrid = modificationCount.startingGrid + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, deleteIndex = deleteIndex, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_StartingGrid-List-CycleItems"), { startingGridVehicleIndex .. " / " .. #currentRace.startingGrid }, 1, nil, { IsDisabled = #currentRace.startingGrid == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
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
				startingGridVehicleIndex = startingGridVehicleIndex - 1
				if startingGridVehicleIndex < 1 then
					startingGridVehicleIndex = #currentRace.startingGrid
				end
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
				startingGridVehicleSelect = currentstartingGridVehicle.handle
				SetEntityDrawOutline(currentstartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensions(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentstartingGridVehicle.x + (20.0 - min.z) * math.sin(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.y - (20.0 - min.z) * math.cos(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentstartingGridVehicle.heading}
			elseif (onListChange) == "right" then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
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
				startingGridVehicleIndex = startingGridVehicleIndex + 1
				if startingGridVehicleIndex > #currentRace.startingGrid then
					startingGridVehicleIndex = 1
				end
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
				startingGridVehicleSelect = currentstartingGridVehicle.handle
				SetEntityDrawOutline(currentstartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensions(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentstartingGridVehicle.x + (20.0 - min.z) * math.sin(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.y - (20.0 - min.z) * math.cos(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentstartingGridVehicle.heading}
			end
			if (onSelected) and currentRace.startingGrid[startingGridVehicleIndex] then
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
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
				global_var.isSelectingStartingGridVehicle = true
				isStartingGridVehiclePickedUp = true
				currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
				startingGridVehicleSelect = currentstartingGridVehicle.handle
				SetEntityDrawOutline(currentstartingGridVehicle.handle, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
				local min, max = GetModelDimensions(GetEntityModel(startingGridVehicleSelect))
				cameraPosition = vector3(currentstartingGridVehicle.x + (20.0 - min.z) * math.sin(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.y - (20.0 - min.z) * math.cos(math.rad(currentstartingGridVehicle.heading)), currentstartingGridVehicle.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentstartingGridVehicle.heading}
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Checkpoints:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Test"), nil, { IsDisabled = global_var.IsNuiFocused or not isCheckpointPickedUp or (isCheckpointPickedUp and (not global_var.isPrimaryCheckpointItems and not currentRace.checkpoints_2[checkpointIndex])) or lockSession }, function(onSelected)
			if (onSelected) then
				global_var.enableTest = true
				global_var.isRespawning = true
				global_var.tipsRendered = false
				Citizen.CreateThread(function()
					SetRadarBigmapEnabled(false, false)
					Citizen.Wait(0)
					SetRadarZoom(1000)
				end)
				SetBlipAlpha(GetMainPlayerBlipId(), 255)
				RemoveBlip(global_var.creatorBlipHandle)
				global_var.creatorBlipHandle = nil
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
				firework = {}
				arenaProp = {}
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
						if arenaObjects[currentRace.objects[i].hash] then
							arenaProp[#arenaProp + 1] = currentRace.objects[i]
						end
					end
					if currentRace.objects[i].hash == GetHashKey("ind_prop_firework_01") or currentRace.objects[i].hash == GetHashKey("ind_prop_firework_02") or currentRace.objects[i].hash == GetHashKey("ind_prop_firework_03") or currentRace.objects[i].hash == GetHashKey("ind_prop_firework_04") then
						firework[#firework + 1] = currentRace.objects[i]
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
					SetEntityCompletelyDisableCollision(ped, true, true)
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
					updateBlips("test")
					global_var.tipsRendered = true
				end)
				global_var.respawnData = {
					checkpointIndex = checkpointIndex,
					checkpointIndex_draw = checkpointIndex + 1
				}
				local checkpoint = {}
				if global_var.isPrimaryCheckpointItems then
					checkpoint = currentRace.checkpoints[global_var.respawnData.checkpointIndex] and tableDeepCopy(currentRace.checkpoints[global_var.respawnData.checkpointIndex]) or {}
				else
					checkpoint = currentRace.checkpoints_2[global_var.respawnData.checkpointIndex] and tableDeepCopy(currentRace.checkpoints_2[global_var.respawnData.checkpointIndex]) or {}
				end
				global_var.respawnData.x = checkpoint.x or 0.0
				global_var.respawnData.y = checkpoint.y or 0.0
				global_var.respawnData.z = checkpoint.z or 0.0
				global_var.respawnData.heading = checkpoint.heading or 0.0
				global_var.respawnData.model = checkpoint.is_transform and currentRace.transformVehicles[checkpoint.transform_index + 1]
				TestCurrentCheckpoint(global_var.respawnData)
			end
		end)

		Items:AddList("", { global_var.isPrimaryCheckpointItems and GetTranslate("PlacementSubMenu_Checkpoints-List-Primary") or GetTranslate("PlacementSubMenu_Checkpoints-List-Secondary") }, 1, nil, { IsDisabled = global_var.IsNuiFocused or isCheckpointPickedUp or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				global_var.isPrimaryCheckpointItems = not global_var.isPrimaryCheckpointItems
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Place"), nil, { IsDisabled = global_var.IsNuiFocused or isCheckpointPickedUp or not checkpointPreview or lockSession }, function(onSelected)
			if (onSelected) and not global_var.IsNuiFocused then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = tostring(global_var.isPrimaryCheckpointItems and (#currentRace.checkpoints + 1) or checkpointIndex)
				})
				nuiCallBack = "place checkpoint"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Alignment"), { isCheckpointPositionRelativeEnable and GetTranslate("PlacementSubMenu_Checkpoints-List-Alignment-Relative") or GetTranslate("PlacementSubMenu_Checkpoints-List-Alignment-World") }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				isCheckpointPositionRelativeEnable = not isCheckpointPositionRelativeEnable
			end
		end)

		Items:AddList("X:", { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.x }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.x then
				if not isCheckpointPositionRelativeEnable then
					currentCheckpoint.x = RoundedValue(currentCheckpoint.x - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, -speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0, 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
			elseif (onListChange) == "right" and currentCheckpoint.x then
				if not isCheckpointPositionRelativeEnable then
					currentCheckpoint.x = RoundedValue(currentCheckpoint.x + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0, 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
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
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					updateBlips("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList("Y:", { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.y }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentCheckpoint.y then
				if not isCheckpointPositionRelativeEnable then
					currentCheckpoint.y = RoundedValue(currentCheckpoint.y - speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, 0.0, -speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
			elseif (onListChange) == "right" and currentCheckpoint.y then
				if not isCheckpointPositionRelativeEnable then
					currentCheckpoint.y = RoundedValue(currentCheckpoint.y + speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z, currentCheckpoint.heading, 0.0, speed.checkpoint_offset.value[speed.checkpoint_offset.index][2], 0.0)
					currentCheckpoint.x = RoundedValue(coords.x, 3)
					currentCheckpoint.y = RoundedValue(coords.y, 3)
					currentCheckpoint.z = RoundedValue(coords.z, 3)
				end
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
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					updateBlips("checkpoint")
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
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					updateBlips("checkpoint")
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
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

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Diameter"), { (not isCheckpointPickedUp and not checkpointPreview) and "" or currentCheckpoint.d }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp and not checkpointPreview) or lockSession }, function(Index, onSelected, onListChange)
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Round"), nil, currentCheckpoint.is_round, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
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
						if inSession then
							modificationCount.checkpoints = modificationCount.checkpoints + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
						end
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Air"), nil, currentCheckpoint.is_air, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
				currentCheckpoint.is_air = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Fake"), nil, currentCheckpoint.is_fake, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
				currentCheckpoint.is_fake = IsChecked
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Random"), nil, currentCheckpoint.is_random, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
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
					updateBlips("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Random"), { (currentCheckpoint.randomClass == 0 and GetTranslate("RandomClass-0")) or (currentCheckpoint.randomClass == 1 and GetTranslate("RandomClass-1")) or (currentCheckpoint.randomClass == 2 and GetTranslate("RandomClass-2")) or (currentCheckpoint.randomClass == 3 and GetTranslate("RandomClass-3")) or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_random) or lockSession }, function(Index, onSelected, onListChange)
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Transform"), nil, currentCheckpoint.is_transform, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
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
					updateBlips("checkpoint")
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
				vehName = GetLabelText(GetDisplayNameFromVehicleModel(currentRace.transformVehicles[currentCheckpoint.transform_index + 1]))
			end
		elseif #currentRace.transformVehicles == 0 then
			vehName = "No Valid Vehicles"
		end
		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-Transform"), { vehName }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_transform) or (#currentRace.transformVehicles == 0) or lockSession }, function(Index, onSelected, onListChange)
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Transform"), nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_transform) or lockSession }, function(onSelected)
			if (onSelected) then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = currentRace.transformVehicles
				})
				nuiCallBack = "checkpoint transform vehicles"
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-PlaneRot"), nil, currentCheckpoint.is_planeRot, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
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
					updateBlips("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-PlaneRot"), { (currentCheckpoint.plane_rot == 0 and GetTranslate("PlaneRot-0")) or (currentCheckpoint.plane_rot == 1 and GetTranslate("PlaneRot-1")) or (currentCheckpoint.plane_rot == 2 and GetTranslate("PlaneRot-2")) or (currentCheckpoint.plane_rot == 3 and GetTranslate("PlaneRot-3")) or "" }, 1, nil, { IsDisabled = global_var.IsNuiFocused or (not currentCheckpoint.is_planeRot) or lockSession }, function(Index, onSelected, onListChange)
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(GetTranslate("PlacementSubMenu_Checkpoints-CheckBox-Warp"), nil, currentCheckpoint.is_warp, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) and not global_var.IsNuiFocused and not lockSession then
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
					updateBlips("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Checkpoints-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isCheckpointPickedUp) or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				isCheckpointPickedUp = false
				local deleteIndex = checkpointIndex
				if global_var.isPrimaryCheckpointItems then
					if currentRace.checkpoints[checkpointIndex] then
						table.remove(currentRace.checkpoints, checkpointIndex)
					end
					local copy_checkpoints_2 = {}
					for k, v in pairs(currentRace.checkpoints_2) do
						if checkpointIndex > k then
							copy_checkpoints_2[k] = v
						elseif checkpointIndex < k then
							copy_checkpoints_2[k - 1] = v
						end
					end
					currentRace.checkpoints_2 = tableDeepCopy(copy_checkpoints_2)
					if checkpointIndex > #currentRace.checkpoints then
						checkpointIndex = #currentRace.checkpoints
					end
				else
					currentRace.checkpoints_2[checkpointIndex] = nil
				end
				updateBlips("checkpoint")
				if inSession then
					modificationCount.checkpoints = modificationCount.checkpoints + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, deleteIndex = deleteIndex, isPrimaryCheckpoint = global_var.isPrimaryCheckpointItems, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Checkpoints-List-CycleItems"), { checkpointIndex .. " / " .. #currentRace.checkpoints }, 1, nil, { IsDisabled = (global_var.isPrimaryCheckpointItems and (#currentRace.checkpoints == 0)) or (not global_var.isPrimaryCheckpointItems and (tableCount(currentRace.checkpoints_2) == 0)) or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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
				globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
				local d = currentCheckpoint.d
				local is_round = currentCheckpoint.is_round
				local is_air = currentCheckpoint.is_air
				local is_fake = currentCheckpoint.is_fake
				local is_random = currentCheckpoint.is_random
				local is_transform = currentCheckpoint.is_transform
				local is_planeRot = currentCheckpoint.is_planeRot
				local is_warp = currentCheckpoint.is_warp
				local diameter = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
				cameraPosition = vector3(currentCheckpoint.x + (20.0 + diameter) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20.0 + diameter) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20.0 + diameter))
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
				globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
				local d = currentCheckpoint.d
				local is_round = currentCheckpoint.is_round
				local is_air = currentCheckpoint.is_air
				local is_fake = currentCheckpoint.is_fake
				local is_random = currentCheckpoint.is_random
				local is_transform = currentCheckpoint.is_transform
				local is_planeRot = currentCheckpoint.is_planeRot
				local is_warp = currentCheckpoint.is_warp
				local diameter = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
				cameraPosition = vector3(currentCheckpoint.x + (20.0 + diameter) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20.0 + diameter) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20.0 + diameter))
				cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
			end
			if (onSelected) then
				if ((global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex]) or (not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex])) then
					isCheckpointPickedUp = true
					checkpointPreview = nil
					currentCheckpoint = global_var.isPrimaryCheckpointItems and tableDeepCopy(currentRace.checkpoints[checkpointIndex]) or tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
					local d = currentCheckpoint.d
					local is_round = currentCheckpoint.is_round
					local is_air = currentCheckpoint.is_air
					local is_fake = currentCheckpoint.is_fake
					local is_random = currentCheckpoint.is_random
					local is_transform = currentCheckpoint.is_transform
					local is_planeRot = currentCheckpoint.is_planeRot
					local is_warp = currentCheckpoint.is_warp
					local diameter = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
					cameraPosition = vector3(currentCheckpoint.x + (20.0 + diameter) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20.0 + diameter) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20.0 + diameter))
					cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
				elseif not global_var.isPrimaryCheckpointItems and not currentRace.checkpoints_2[checkpointIndex] then
					DisplayCustomMsgs(string.format(GetTranslate("checkpoints_2-null"), checkpointIndex))
				end
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Props:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-EnterModelHash"), GetTranslate("PlacementSubMenu_Props-Button-EnterModelHash-Desc"), { IsDisabled = isPropPickedUp or global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				DeleteObject(objectPreview)
				objectPreview = nil
				childPropBoneCount = nil
				childPropBoneIndex = nil
				currentObject = {
					uniqueId = nil,
					modificationCount = 0,
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

		Items:AddList(string.format(GetTranslate("PlacementSubMenu_Props-List-Category"), categoryIndex, #category), { category[categoryIndex].class }, 1, nil, { IsDisabled = isPropPickedUp or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				categoryIndex = categoryIndex - 1
				if categoryIndex < 1 then
					categoryIndex = #category
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				childPropBoneCount = nil
				childPropBoneIndex = nil
				lastValidHash = nil
				currentObject = {
					uniqueId = nil,
					modificationCount = 0,
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
				global_var.propColor = nil
			elseif (onListChange) == "right" then
				categoryIndex = categoryIndex + 1
				if categoryIndex > #category then
					categoryIndex = 1
				end
				DeleteObject(objectPreview)
				objectPreview = nil
				childPropBoneCount = nil
				childPropBoneIndex = nil
				lastValidHash = nil
				currentObject = {
					uniqueId = nil,
					modificationCount = 0,
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
				global_var.propColor = nil
			end
		end)

		Items:AddList(string.format(GetTranslate("PlacementSubMenu_Props-List-Model"), category[categoryIndex].index, #category[categoryIndex].model), category[categoryIndex].model, category[categoryIndex].index, nil, { IsDisabled = isPropPickedUp or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				category[categoryIndex].index = Index
			end
			if (onSelected) or (onListChange) then
				DeleteObject(objectPreview)
				objectPreview = nil
				childPropBoneCount = nil
				childPropBoneIndex = nil
				lastValidHash = nil
				currentObject = {
					uniqueId = nil,
					modificationCount = 0,
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
				global_var.propColor = nil
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Place"), (#currentRace.objects >= Config.ObjectLimit) and GetTranslate("PlacementSubMenu_Props-Button-objectLimit-Desc") or nil, { IsDisabled = isPropPickedUp or (not isPropPickedUp and not objectPreview) or global_var.IsNuiFocused or (#currentRace.objects >= Config.ObjectLimit) or lockSession }, function(onSelected)
			if (onSelected) then
				if currentObject.visible then
					ResetEntityAlpha(objectPreview)
				end
				if currentObject.collision then
					SetEntityCollision(objectPreview, true, true)
				else
					SetEntityCollision(objectPreview, false, false)
				end
				table.insert(currentRace.objects, currentObject)
				updateBlips("object")
				if inSession then
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-place")
				end
				objectIndex = #currentRace.objects
				objectPreview = nil
				childPropBoneCount = nil
				childPropBoneIndex = nil
				globalRot = {
					x = RoundedValue(currentObject.rotX, 3),
					y = RoundedValue(currentObject.rotY, 3),
					z = RoundedValue(currentObject.rotZ, 3)
				}
				global_var.propColor = currentObject.color
				currentObject = {
					uniqueId = nil,
					modificationCount = 0,
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

		Items:CheckBox(GetTranslate("PlacementSubMenu_Props-CheckBox-Stack"), GetTranslate("PlacementSubMenu_Props-CheckBox-Stack-Desc"), isPropStackEnable, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) then
				isPropStackEnable = IsChecked
			end
		end)

		local stackOptionsAvailable = (isPropStackEnable and stackObject.handle and objectPreview and currentObject.handle and childPropBoneCount and childPropBoneIndex) and true or false
		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-BoneIndexParent"), { stackOptionsAvailable and stackObject.boneIndex or "" }, 1, not stackObject.handle and GetTranslate("PlacementSubMenu_Props-List-BoneIndexParent-Desc") or nil, { IsDisabled = not stackOptionsAvailable or not objectPreview or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				objectPreview_coords_change = true
				stackObject.boneIndex = stackObject.boneIndex - 1
				if stackObject.boneIndex < 0 then
					stackObject.boneIndex = stackObject.boneCount - 1
				end
				local rotation_parent = GetEntityRotation(stackObject.handle, 2)
				SetEntityRotation(currentObject.handle, 0.0, 0.0, 0.0, 2, 0)
				SetEntityRotation(stackObject.handle, 0.0, 0.0, 0.0, 2, 0)
				AttachEntityBoneToEntityBone(objectPreview, stackObject.handle, childPropBoneIndex, stackObject.boneIndex, true, false)
				SetEntityRotation(stackObject.handle, rotation_parent, 2, 0)
				DetachEntity(objectPreview, false, currentObject.collision)
				local coords = GetEntityCoords(objectPreview)
				local rotation = GetEntityRotation(objectPreview, 2)
				currentObject.x = RoundedValue(coords.x, 3)
				currentObject.y = RoundedValue(coords.y, 3)
				currentObject.z = RoundedValue(coords.z, 3)
				currentObject.rotX = RoundedValue(rotation.x, 3)
				currentObject.rotY = RoundedValue(rotation.y, 3)
				currentObject.rotZ = RoundedValue(rotation.z, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				SetEntityCollision(currentObject.handle, false, false)
			elseif (onListChange) == "right" then
				objectPreview_coords_change = true
				stackObject.boneIndex = stackObject.boneIndex + 1
				if stackObject.boneIndex > stackObject.boneCount - 1 then
					stackObject.boneIndex = 0
				end
				local rotation_parent = GetEntityRotation(stackObject.handle, 2)
				SetEntityRotation(currentObject.handle, 0.0, 0.0, 0.0, 2, 0)
				SetEntityRotation(stackObject.handle, 0.0, 0.0, 0.0, 2, 0)
				AttachEntityBoneToEntityBone(objectPreview, stackObject.handle, childPropBoneIndex, stackObject.boneIndex, true, false)
				SetEntityRotation(stackObject.handle, rotation_parent, 2, 0)
				DetachEntity(objectPreview, false, currentObject.collision)
				local coords = GetEntityCoords(objectPreview)
				local rotation = GetEntityRotation(objectPreview, 2)
				currentObject.x = RoundedValue(coords.x, 3)
				currentObject.y = RoundedValue(coords.y, 3)
				currentObject.z = RoundedValue(coords.z, 3)
				currentObject.rotX = RoundedValue(rotation.x, 3)
				currentObject.rotY = RoundedValue(rotation.y, 3)
				currentObject.rotZ = RoundedValue(rotation.z, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				SetEntityCollision(currentObject.handle, false, false)
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-BoneIndexChild"), { stackOptionsAvailable and childPropBoneIndex or "" }, 1, not (childPropBoneCount and childPropBoneIndex) and GetTranslate("PlacementSubMenu_Props-List-BoneIndexChild-Desc") or nil, { IsDisabled = not stackOptionsAvailable or (stackObject.boneIndex == -1) or not objectPreview or global_var.IsNuiFocused }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				objectPreview_coords_change = true
				childPropBoneIndex = childPropBoneIndex - 1
				if childPropBoneIndex < 0 then
					childPropBoneIndex = childPropBoneCount - 1
				end
				local rotation_parent = GetEntityRotation(stackObject.handle, 2)
				SetEntityRotation(currentObject.handle, 0.0, 0.0, 0.0, 2, 0)
				SetEntityRotation(stackObject.handle, 0.0, 0.0, 0.0, 2, 0)
				AttachEntityBoneToEntityBone(objectPreview, stackObject.handle, childPropBoneIndex, stackObject.boneIndex, true, false)
				SetEntityRotation(stackObject.handle, rotation_parent, 2, 0)
				DetachEntity(objectPreview, false, currentObject.collision)
				local coords = GetEntityCoords(objectPreview)
				local rotation = GetEntityRotation(objectPreview, 2)
				currentObject.x = RoundedValue(coords.x, 3)
				currentObject.y = RoundedValue(coords.y, 3)
				currentObject.z = RoundedValue(coords.z, 3)
				currentObject.rotX = RoundedValue(rotation.x, 3)
				currentObject.rotY = RoundedValue(rotation.y, 3)
				currentObject.rotZ = RoundedValue(rotation.z, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				SetEntityCollision(currentObject.handle, false, false)
			elseif (onListChange) == "right" then
				objectPreview_coords_change = true
				childPropBoneIndex = childPropBoneIndex + 1
				if childPropBoneIndex > childPropBoneCount - 1 then
					childPropBoneIndex = 0
				end
				local rotation_parent = GetEntityRotation(stackObject.handle, 2)
				SetEntityRotation(currentObject.handle, 0.0, 0.0, 0.0, 2, 0)
				SetEntityRotation(stackObject.handle, 0.0, 0.0, 0.0, 2, 0)
				AttachEntityBoneToEntityBone(objectPreview, stackObject.handle, childPropBoneIndex, stackObject.boneIndex, true, false)
				SetEntityRotation(stackObject.handle, rotation_parent, 2, 0)
				DetachEntity(objectPreview, false, currentObject.collision)
				local coords = GetEntityCoords(objectPreview)
				local rotation = GetEntityRotation(objectPreview, 2)
				currentObject.x = RoundedValue(coords.x, 3)
				currentObject.y = RoundedValue(coords.y, 3)
				currentObject.z = RoundedValue(coords.z, 3)
				currentObject.rotX = RoundedValue(rotation.x, 3)
				currentObject.rotY = RoundedValue(rotation.y, 3)
				currentObject.rotZ = RoundedValue(rotation.z, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				SetEntityCollision(currentObject.handle, false, false)
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-Alignment"), { isPropPositionRelativeEnable and GetTranslate("PlacementSubMenu_Props-List-Alignment-Relative") or GetTranslate("PlacementSubMenu_Props-List-Alignment-World") }, 1, nil, { IsDisabled = not currentObject.x or not currentObject.y or not currentObject.z or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) then
				isPropPositionRelativeEnable = not isPropPositionRelativeEnable
			end
		end)

		Items:AddList("X:", { currentObject.x or "" }, 1, nil, { IsDisabled = not currentObject.x or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				if not isPropPositionRelativeEnable then
					currentObject.x = RoundedValue(currentObject.x - speed.prop_offset.value[speed.prop_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				else
					local coords = GetOffsetFromEntityInWorldCoords(currentObject.handle, -speed.prop_offset.value[speed.prop_offset.index][2], 0.0, 0.0)
					if (RoundedValue(coords.z, 3) > -198.99) and (RoundedValue(coords.z, 3) <= 2698.99) then
						currentObject.x = RoundedValue(coords.x, 3)
						currentObject.y = RoundedValue(coords.y, 3)
						currentObject.z = RoundedValue(coords.z, 3)
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				end
			elseif (onListChange) == "right" then
				if not isPropPositionRelativeEnable then
					currentObject.x = RoundedValue(currentObject.x + speed.prop_offset.value[speed.prop_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				else
					local coords = GetOffsetFromEntityInWorldCoords(currentObject.handle, speed.prop_offset.value[speed.prop_offset.index][2], 0.0, 0.0)
					if (RoundedValue(coords.z, 3) > -198.99) and (RoundedValue(coords.z, 3) <= 2698.99) then
						currentObject.x = RoundedValue(coords.x, 3)
						currentObject.y = RoundedValue(coords.y, 3)
						currentObject.z = RoundedValue(coords.z, 3)
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				end
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
				if objectPreview then
					if currentObject.collision then
						SetEntityCollision(objectPreview, true, true)
					else
						SetEntityCollision(objectPreview, false, false)
					end
				end
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:AddList("Y:", { currentObject.y or "" }, 1, nil, { IsDisabled = not currentObject.y or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.y then
				if not isPropPositionRelativeEnable then
					currentObject.y = RoundedValue(currentObject.y - speed.prop_offset.value[speed.prop_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				else
					local coords = GetOffsetFromEntityInWorldCoords(currentObject.handle, 0.0, -speed.prop_offset.value[speed.prop_offset.index][2], 0.0)
					if (RoundedValue(coords.z, 3) > -198.99) and (RoundedValue(coords.z, 3) <= 2698.99) then
						currentObject.x = RoundedValue(coords.x, 3)
						currentObject.y = RoundedValue(coords.y, 3)
						currentObject.z = RoundedValue(coords.z, 3)
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				end
			elseif (onListChange) == "right" and currentObject.y then
				if not isPropPositionRelativeEnable then
					currentObject.y = RoundedValue(currentObject.y + speed.prop_offset.value[speed.prop_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				else
					local coords = GetOffsetFromEntityInWorldCoords(currentObject.handle, 0.0, speed.prop_offset.value[speed.prop_offset.index][2], 0.0)
					if (RoundedValue(coords.z, 3) > -198.99) and (RoundedValue(coords.z, 3) <= 2698.99) then
						currentObject.x = RoundedValue(coords.x, 3)
						currentObject.y = RoundedValue(coords.y, 3)
						currentObject.z = RoundedValue(coords.z, 3)
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				end
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
				if objectPreview then
					if currentObject.collision then
						SetEntityCollision(objectPreview, true, true)
					else
						SetEntityCollision(objectPreview, false, false)
					end
				end
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:AddList("Z:", { currentObject.z or "" }, 1, nil, { IsDisabled = not currentObject.z or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.z then
				if not isPropPositionRelativeEnable then
					local newZ = RoundedValue(currentObject.z - speed.prop_offset.value[speed.prop_offset.index][2], 3)
					if (newZ > -198.99) and (newZ <= 2698.99) then
						currentObject.z = newZ
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				else
					local coords = GetOffsetFromEntityInWorldCoords(currentObject.handle, 0.0, 0.0, -speed.prop_offset.value[speed.prop_offset.index][2])
					if (RoundedValue(coords.z, 3) > -198.99) and (RoundedValue(coords.z, 3) <= 2698.99) then
						currentObject.x = RoundedValue(coords.x, 3)
						currentObject.y = RoundedValue(coords.y, 3)
						currentObject.z = RoundedValue(coords.z, 3)
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				end
			elseif (onListChange) == "right" and currentObject.z then
				if not isPropPositionRelativeEnable then
					local newZ = RoundedValue(currentObject.z + speed.prop_offset.value[speed.prop_offset.index][2], 3)
					if (newZ > -198.99) and (newZ <= 2698.99) then
						currentObject.z = newZ
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				else
					local coords = GetOffsetFromEntityInWorldCoords(currentObject.handle, 0.0, 0.0, speed.prop_offset.value[speed.prop_offset.index][2])
					if (RoundedValue(coords.z, 3) > -198.99) and (RoundedValue(coords.z, 3) <= 2698.99) then
						currentObject.x = RoundedValue(coords.x, 3)
						currentObject.y = RoundedValue(coords.y, 3)
						currentObject.z = RoundedValue(coords.z, 3)
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
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
				global_var.propZposLock = currentObject.z
				if objectPreview then
					if currentObject.collision then
						SetEntityCollision(objectPreview, true, true)
					else
						SetEntityCollision(objectPreview, false, false)
					end
				end
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:AddList("Rot X:", { currentObject.rotX or "" }, 1, nil, { IsDisabled = not currentObject.rotX or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.rotX then
				currentObject.rotX = RoundedValue(currentObject.rotX - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotX > 9999.0) or (currentObject.rotX < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotX = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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

		Items:AddList("Rot Y:", { currentObject.rotY or "" }, 1, nil, { IsDisabled = not currentObject.rotY or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.rotY then
				currentObject.rotY = RoundedValue(currentObject.rotY - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotY > 9999.0) or (currentObject.rotY < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotY = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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

		Items:AddList("Rot Z:", { currentObject.rotZ or "" }, 1, nil, { IsDisabled = not currentObject.rotZ or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.rotZ then
				currentObject.rotZ = RoundedValue(currentObject.rotZ - speed.prop_offset.value[speed.prop_offset.index][2], 3)
				if (currentObject.rotZ > 9999.0) or (currentObject.rotZ < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotZ = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Override"), nil, { IsDisabled = global_var.IsNuiFocused or (not isPropPickedUp and not objectPreview) or lockSession }, function(onSelected)
			if (onSelected) then
				objectPreview_coords_change = true
				if objectPreview then
					if currentObject.collision then
						SetEntityCollision(objectPreview, true, true)
					else
						SetEntityCollision(objectPreview, false, false)
					end
				end
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'open',
					value = "x = " .. (currentObject.x) .. ", y = " .. (currentObject.y) .. ", z = " .. (currentObject.z) .. ", rotX = " .. (currentObject.rotX) .. ", rotY = " .. (currentObject.rotY) .. ", rotZ = " .. (currentObject.rotZ)
				})
				nuiCallBack = "prop override"
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-Color"), { currentObject.color or "" }, 1, nil, { IsDisabled = not currentObject.color or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" and currentObject.color then
				currentObject.color = currentObject.color - 1
				if currentObject.color < 0 then
					currentObject.color = 15
				end
				SetObjectTextureVariant(currentObject.handle, currentObject.color)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
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
					if isPropPickedUp and currentRace.objects[objectIndex] then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
						currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
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
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
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
				end
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Props-Button-Delete"), nil, { IsDisabled = global_var.IsNuiFocused or (not isPropPickedUp) or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
			if (onSelected) then
				if inSession then
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-delete")
				end
				objectSelect = nil
				isPropPickedUp = false
				if stackObject.handle then
					SetEntityDrawOutline(stackObject.handle, false)
					stackObject = {
						handle = nil,
						boneCount = nil,
						boneIndex = nil
					}
				end
				DeleteObject(currentObject.handle)
				for k, v in pairs(currentRace.objects) do
					if currentObject.handle == v.handle then
						table.remove(currentRace.objects, k)
						break
					end
				end
				if objectIndex > #currentRace.objects then
					objectIndex = #currentRace.objects
				end
				currentObject = {
					uniqueId = nil,
					modificationCount = 0,
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
				updateBlips("object")
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_Props-List-CycleItems"), { objectIndex .. " / " .. #currentRace.objects }, 1, nil, { IsDisabled = #currentRace.objects == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				objectIndex = objectIndex - 1
				if objectIndex < 1 then
					objectIndex = #currentRace.objects
				end
				isPropPickedUp = true
				if stackObject.handle then
					SetEntityDrawOutline(stackObject.handle, false)
					stackObject = {
						handle = nil,
						boneCount = nil,
						boneIndex = nil
					}
				end
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
				childPropBoneCount = nil
				childPropBoneIndex = nil
				if objectSelect then
					SetEntityDrawOutline(objectSelect, false)
				end
				SetEntityDrawOutlineColor(255, 255, 255, 125)
				SetEntityDrawOutlineShader(1)
				SetEntityDrawOutline(currentObject.handle, true)
				objectSelect = currentObject.handle
				local min, max = GetModelDimensions(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20.0 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20.0 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			elseif (onListChange) == "right" then
				objectIndex = objectIndex + 1
				if objectIndex > #currentRace.objects then
					objectIndex = 1
				end
				isPropPickedUp = true
				if stackObject.handle then
					SetEntityDrawOutline(stackObject.handle, false)
					stackObject = {
						handle = nil,
						boneCount = nil,
						boneIndex = nil
					}
				end
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
				childPropBoneCount = nil
				childPropBoneIndex = nil
				if objectSelect then
					SetEntityDrawOutline(objectSelect, false)
				end
				SetEntityDrawOutlineColor(255, 255, 255, 125)
				SetEntityDrawOutlineShader(1)
				SetEntityDrawOutline(currentObject.handle, true)
				objectSelect = currentObject.handle
				local min, max = GetModelDimensions(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20.0 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20.0 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			end
			if (onSelected) and currentRace.objects[objectIndex] then
				isPropPickedUp = true
				if stackObject.handle then
					SetEntityDrawOutline(stackObject.handle, false)
					stackObject = {
						handle = nil,
						boneCount = nil,
						boneIndex = nil
					}
				end
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
				childPropBoneCount = nil
				childPropBoneIndex = nil
				if objectSelect then
					SetEntityDrawOutline(objectSelect, false)
				end
				SetEntityDrawOutlineColor(255, 255, 255, 125)
				SetEntityDrawOutlineShader(1)
				SetEntityDrawOutline(currentObject.handle, true)
				objectSelect = currentObject.handle
				local min, max = GetModelDimensions(currentObject.hash)
				cameraPosition = vector3(currentObject.x + (20.0 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20.0 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20.0 - min.z))
				cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
			end
		end)
	end, function(Panels)
	end)

	PlacementSubMenu_Templates:IsVisible(function(Items)
		Items:AddList(GetTranslate("PlacementSubMenu_Templates-List-Templates"), { templateIndex .. " / " .. #template }, 1, nil, { IsDisabled = (#template == 0) or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate"), (#template >= Config.TemplateLimit) and GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate-Desc1") or GetTranslate("PlacementSubMenu_Templates-Button-SaveTemplate-Desc2"), { IsDisabled = (#currentTemplate.props <= 1) or global_var.IsNuiFocused or (#template >= Config.TemplateLimit) or lockSession }, function(onSelected)
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

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-PlaceTemplate"), nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(onSelected)
			if (onSelected) then
				if not isTemplatePropPickedUp then
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
					end
					updateBlips("object")
					if inSession then
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, templatePreview, "template-place")
					end
					objectIndex = #currentRace.objects
					templatePreview = {}
				end
			end
		end)

		Items:AddList("X:", {templatePreview[1] and templatePreview[1].x or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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

		Items:AddList("Y:", {templatePreview[1] and templatePreview[1].y or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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

		Items:AddList("Z:", {templatePreview[1] and templatePreview[1].z or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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

		Items:AddList("Rot X:", {templatePreview[1] and templatePreview[1].rotX or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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

		Items:AddList("Rot Y:", {templatePreview[1] and templatePreview[1].rotY or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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

		Items:AddList("Rot Z:", {templatePreview[1] and templatePreview[1].rotZ or ""}, 1, nil, { IsDisabled = #templatePreview == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
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
					action = 'open',
					value = "x = " .. (templatePreview[1] and templatePreview[1].x) .. ", y = " .. (templatePreview[1] and templatePreview[1].y) .. ", z = " .. (templatePreview[1] and templatePreview[1].z) .. ", rotX = " .. (templatePreview[1] and templatePreview[1].rotX) .. ", rotY = " .. (templatePreview[1] and templatePreview[1].rotY) .. ", rotZ = " .. (templatePreview[1] and templatePreview[1].rotZ)
				})
				nuiCallBack = "template override"
			end
		end)

		Items:AddButton(GetTranslate("PlacementSubMenu_Templates-Button-Delete"), nil, { IsDisabled = (#templatePreview == 0) or (#template == 0) or global_var.IsNuiFocused or lockSession, Color = { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} }, Emoji = "⚠️" }, function(onSelected)
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

	PlacementSubMenu_MoveAll:IsVisible(function(Items)
		Items:AddList("X:", { "" }, 1, nil, { IsDisabled = lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				for i = 1, #currentRace.startingGrid do
					currentRace.startingGrid[i].x = RoundedValue(currentRace.startingGrid[i].x - speed.move_offset.value[speed.move_offset.index][2], 3)
				end
				for i = 1, #currentRace.checkpoints do
					currentRace.checkpoints[i].x = RoundedValue(currentRace.checkpoints[i].x - speed.move_offset.value[speed.move_offset.index][2], 3)
					if currentRace.checkpoints_2[i] then
						currentRace.checkpoints_2[i].x = RoundedValue(currentRace.checkpoints_2[i].x - speed.move_offset.value[speed.move_offset.index][2], 3)
					end
				end
				updateBlips("checkpoint")
				for i = 1, #currentRace.objects do
					currentRace.objects[i].x = RoundedValue(currentRace.objects[i].x - speed.move_offset.value[speed.move_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentRace.objects[i].handle, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z)
				end
				if inSession then
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { offset_x = -speed.move_offset.value[speed.move_offset.index][2], offset_y = 0, offset_z = 0 }, "move-all")
				end
			elseif (onListChange) == "right" then
				for i = 1, #currentRace.startingGrid do
					currentRace.startingGrid[i].x = RoundedValue(currentRace.startingGrid[i].x + speed.move_offset.value[speed.move_offset.index][2], 3)
				end
				for i = 1, #currentRace.checkpoints do
					currentRace.checkpoints[i].x = RoundedValue(currentRace.checkpoints[i].x + speed.move_offset.value[speed.move_offset.index][2], 3)
					if currentRace.checkpoints_2[i] then
						currentRace.checkpoints_2[i].x = RoundedValue(currentRace.checkpoints_2[i].x + speed.move_offset.value[speed.move_offset.index][2], 3)
					end
				end
				updateBlips("checkpoint")
				for i = 1, #currentRace.objects do
					currentRace.objects[i].x = RoundedValue(currentRace.objects[i].x + speed.move_offset.value[speed.move_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentRace.objects[i].handle, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z)
				end
				if inSession then
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { offset_x = speed.move_offset.value[speed.move_offset.index][2], offset_y = 0, offset_z = 0 }, "move-all")
				end
			end
		end)

		Items:AddList("Y:", { "" }, 1, nil, { IsDisabled = lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				for i = 1, #currentRace.startingGrid do
					currentRace.startingGrid[i].y = RoundedValue(currentRace.startingGrid[i].y - speed.move_offset.value[speed.move_offset.index][2], 3)
				end
				for i = 1, #currentRace.checkpoints do
					currentRace.checkpoints[i].y = RoundedValue(currentRace.checkpoints[i].y - speed.move_offset.value[speed.move_offset.index][2], 3)
					if currentRace.checkpoints_2[i] then
						currentRace.checkpoints_2[i].y = RoundedValue(currentRace.checkpoints_2[i].y - speed.move_offset.value[speed.move_offset.index][2], 3)
					end
				end
				updateBlips("checkpoint")
				for i = 1, #currentRace.objects do
					currentRace.objects[i].y = RoundedValue(currentRace.objects[i].y - speed.move_offset.value[speed.move_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentRace.objects[i].handle, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z)
				end
				if inSession then
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { offset_x = 0, offset_y = -speed.move_offset.value[speed.move_offset.index][2], offset_z = 0 }, "move-all")
				end
			elseif (onListChange) == "right" then
				for i = 1, #currentRace.startingGrid do
					currentRace.startingGrid[i].y = RoundedValue(currentRace.startingGrid[i].y + speed.move_offset.value[speed.move_offset.index][2], 3)
				end
				for i = 1, #currentRace.checkpoints do
					currentRace.checkpoints[i].y = RoundedValue(currentRace.checkpoints[i].y + speed.move_offset.value[speed.move_offset.index][2], 3)
					if currentRace.checkpoints_2[i] then
						currentRace.checkpoints_2[i].y = RoundedValue(currentRace.checkpoints_2[i].y + speed.move_offset.value[speed.move_offset.index][2], 3)
					end
				end
				updateBlips("checkpoint")
				for i = 1, #currentRace.objects do
					currentRace.objects[i].y = RoundedValue(currentRace.objects[i].y + speed.move_offset.value[speed.move_offset.index][2], 3)
					SetEntityCoordsNoOffset(currentRace.objects[i].handle, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z)
				end
				if inSession then
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { offset_x = 0, offset_y = speed.move_offset.value[speed.move_offset.index][2], offset_z = 0 }, "move-all")
				end
			end
		end)

		Items:AddList("Z:", { "" }, 1, nil, { IsDisabled = lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				local overflow_z = false
				for i = 1, #currentRace.startingGrid do
					local newZ_startingGrid = RoundedValue(currentRace.startingGrid[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
					if (newZ_startingGrid <= -198.99) or (newZ_startingGrid > 2698.99) then
						overflow_z = true
					end
				end
				for i = 1, #currentRace.checkpoints do
					local newZ_checkpoint = RoundedValue(currentRace.checkpoints[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
					if (newZ_checkpoint <= -198.99) or (newZ_checkpoint > 2698.99) then
						overflow_z = true
					end
					if currentRace.checkpoints_2[i] then
						local newZ_checkpoint_2 = RoundedValue(currentRace.checkpoints_2[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
						if (newZ_checkpoint_2 <= -198.99) or (newZ_checkpoint_2 > 2698.99) then
							overflow_z = true
						end
					end
				end
				for i = 1, #currentRace.objects do
					local newZ_object = RoundedValue(currentRace.objects[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
					if (newZ_object <= -198.99) or (newZ_object > 2698.99) then
						overflow_z = true
					end
				end
				if not overflow_z then
					for i = 1, #currentRace.startingGrid do
						currentRace.startingGrid[i].z = RoundedValue(currentRace.startingGrid[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
					end
					for i = 1, #currentRace.checkpoints do
						currentRace.checkpoints[i].z = RoundedValue(currentRace.checkpoints[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
						if currentRace.checkpoints_2[i] then
							currentRace.checkpoints_2[i].z = RoundedValue(currentRace.checkpoints_2[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
						end
					end
					updateBlips("checkpoint")
					for i = 1, #currentRace.objects do
						currentRace.objects[i].z = RoundedValue(currentRace.objects[i].z - speed.move_offset.value[speed.move_offset.index][2], 3)
						SetEntityCoordsNoOffset(currentRace.objects[i].handle, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z)
					end
					if inSession then
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { offset_x = 0, offset_y = 0, offset_z = -speed.move_offset.value[speed.move_offset.index][2] }, "move-all")
					end
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			elseif (onListChange) == "right" then
				local overflow_z = false
				for i = 1, #currentRace.startingGrid do
					local newZ_startingGrid = RoundedValue(currentRace.startingGrid[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
					if (newZ_startingGrid <= -198.99) or (newZ_startingGrid > 2698.99) then
						overflow_z = true
					end
				end
				for i = 1, #currentRace.checkpoints do
					local newZ_checkpoint = RoundedValue(currentRace.checkpoints[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
					if (newZ_checkpoint <= -198.99) or (newZ_checkpoint > 2698.99) then
						overflow_z = true
					end
					if currentRace.checkpoints_2[i] then
						local newZ_checkpoint_2 = RoundedValue(currentRace.checkpoints_2[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
						if (newZ_checkpoint_2 <= -198.99) or (newZ_checkpoint_2 > 2698.99) then
							overflow_z = true
						end
					end
				end
				for i = 1, #currentRace.objects do
					local newZ_object = RoundedValue(currentRace.objects[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
					if (newZ_object <= -198.99) or (newZ_object > 2698.99) then
						overflow_z = true
					end
				end
				if not overflow_z then
					for i = 1, #currentRace.startingGrid do
						currentRace.startingGrid[i].z = RoundedValue(currentRace.startingGrid[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
					end
					for i = 1, #currentRace.checkpoints do
						currentRace.checkpoints[i].z = RoundedValue(currentRace.checkpoints[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
						if currentRace.checkpoints_2[i] then
							currentRace.checkpoints_2[i].z = RoundedValue(currentRace.checkpoints_2[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
						end
					end
					updateBlips("checkpoint")
					for i = 1, #currentRace.objects do
						currentRace.objects[i].z = RoundedValue(currentRace.objects[i].z + speed.move_offset.value[speed.move_offset.index][2], 3)
						SetEntityCoordsNoOffset(currentRace.objects[i].handle, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z)
					end
					if inSession then
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { offset_x = 0, offset_y = 0, offset_z = speed.move_offset.value[speed.move_offset.index][2] }, "move-all")
					end
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			end
		end)

		Items:AddList(GetTranslate("PlacementSubMenu_MoveAll-List-ChangeSpeed"), { speed.move_offset.value[speed.move_offset.index][1] }, 1, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				speed.move_offset.index = speed.move_offset.index - 1
				if speed.move_offset.index < 1 then
					speed.move_offset.index = #speed.move_offset.value
				end
			elseif (onListChange) == "right" then
				speed.move_offset.index = speed.move_offset.index + 1
				if speed.move_offset.index > #speed.move_offset.value then
					speed.move_offset.index = 1
				end
			end
		end)
	end, function(Panels)
	end)

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
	PlacementSubMenu_FixtureRemover:IsVisible(function(Items)
		Items:AddButton(GetTranslate("PlacementSubMenu_FixtureRemover-Button-Select"), nil, { IsDisabled = global_var.IsNuiFocused or not currentFixture.handle or not selectFixtureAvailable or lockSession }, function(onSelected)
			if (onSelected) then
				table.insert(currentRace.fixtures, currentFixture)
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

		Items:AddList(GetTranslate("PlacementSubMenu_FixtureRemover-List-CycleItems"), { fixtureIndex .. " / " .. #currentRace.fixtures }, 1, nil, { IsDisabled = #currentRace.fixtures == 0 or global_var.IsNuiFocused or lockSession }, function(Index, onSelected, onListChange)
			if (onListChange) == "left" then
				fixtureIndex = fixtureIndex - 1
				if fixtureIndex < 1 then
					fixtureIndex = #currentRace.fixtures
				end
				currentFixture = tableDeepCopy(currentRace.fixtures[fixtureIndex])
				local min, max = GetModelDimensions(currentFixture.hash)
				cameraPosition = vector3(currentFixture.x, currentFixture.y, currentFixture.z + (10.0 + max.z - min.z))
				cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
			elseif (onListChange) == "right" then
				fixtureIndex = fixtureIndex + 1
				if fixtureIndex > #currentRace.fixtures then
					fixtureIndex = 1
				end
				currentFixture = tableDeepCopy(currentRace.fixtures[fixtureIndex])
				local min, max = GetModelDimensions(currentFixture.hash)
				cameraPosition = vector3(currentFixture.x, currentFixture.y, currentFixture.z + (10.0 + max.z - min.z))
				cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
			end
			if (onSelected) and currentRace.fixtures[fixtureIndex] then
				currentFixture = tableDeepCopy(currentRace.fixtures[fixtureIndex])
				local min, max = GetModelDimensions(currentFixture.hash)
				cameraPosition = vector3(currentFixture.x, currentFixture.y, currentFixture.z + (10.0 + max.z - min.z))
				cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
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
								TriggerServerCallback('custom_creator:server:joinPlayerSession', function(data, data_2, inSessionPlayers)
									if data and data_2 then
										loadSessionData(data, data_2)
										global_var.thumbnailValid = false
										SendNUIMessage({
											action = 'thumbnail_url',
											thumbnail_url = currentRace.thumbnail
										})
										RageUI.GoBack()
										DisplayCustomMsgs(GetTranslate("join-session-success"))
										TriggerServerEvent('custom_creator:server:loadDone', currentRace.raceid)
										multiplayer.inSessionPlayers = inSessionPlayers
										inSession = true
									else
										DisplayCustomMsgs(GetTranslate("join-session-failed"))
									end
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
			Items:AddButton(GetTranslate("MultiplayerSubMenu-Button-Invite"), not inSession and GetTranslate("MultiplayerSubMenu-Button-Invite-Desc"), { IsDisabled = not inSession, RightLabel = ">>>", Color = not inSession and { BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255} } }, function(onSelected)
				if (onSelected) then
					global_var.lock = true
					Citizen.CreateThread(function()
						TriggerServerCallback('custom_creator:server:getPlayerList', function(players)
							multiplayer.availablePlayers = players
							global_var.lock = false
						end, currentRace.raceid)
					end)
				end
			end, MultiplayerSubMenu_Invite)

			for i = 1, #multiplayer.inSessionPlayers do
				Items:AddButton(multiplayer.inSessionPlayers[i].playerName or multiplayer.inSessionPlayers[i].playerId, nil, { IsDisabled = false }, function(onSelected)
					if (onSelected) then
						local ped = PlayerPedId()
						local myLocalId = PlayerId()
						local id = GetPlayerFromServerId(multiplayer.inSessionPlayers[i].playerId)
						local creator = (id ~= -1) and (id ~= myLocalId) and GetPlayerPed(id)
						if (id ~= -1) and (id ~= myLocalId) and creator and (ped ~= creator) then
							local creator_coords = GetEntityCoords(creator)
							cameraPosition = vector3(creator_coords.x + 0.0, creator_coords.y + 0.0, creator_coords.z + 20.0)
							cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
						end
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
						TriggerServerEvent('custom_creator:server:invitePlayer', v.playerId, currentRace.title, currentRace.raceid)
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

		Items:CheckBox(GetTranslate("MiscSubMenu-CheckBox-DisableNpc"), nil, global_var.DisableNpcChecked, { Style = 1 }, function(onSelected, IsChecked)
			if (onSelected) then
				global_var.DisableNpcChecked = IsChecked
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
						SetRadarZoom(0)
					end
				end)
			end
		end)
	end, function(Panels)
	end)
end