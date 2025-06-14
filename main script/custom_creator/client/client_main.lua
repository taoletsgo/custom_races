races_data = {
	index = 1,
	filter = "",
	category = {
		[1] = {
			class = "published-races",
			data = {}
		},
		[2] = {
			class = "saved-races",
			data = {}
		}
	}
}

currentRace = {
	-- Info
	raceid = nil,
	owner_name = "",
	published = false,

	-- Race details
	title = "",
	thumbnail = "",
	test_vehicle = "",
	blimp_text = "",

	-- Grid positions
	startingGrid = {},

	-- Checkpoints info
	checkpoints = {}, -- Primary
	checkpoints_2 = {}, -- Secondary

	-- Transform hashes or names, 0 = default vehicle
	transformVehicles = {0, -422877666, -731262150, "bmx", "xa21"},

	-- Static props and Dynamic props
	objects = {},

	-- Fixture remover
	fixtures = {},

	-- Firework particle
	firework = {
		name = "scr_indep_firework_trailburst",
		r = 255,
		g = 255,
		b = 255
	}
}

speed = {
	cam_pos = {
		index = 1,
		value = {
			{"1x", 0.5},
			{"2x", 1.0},
			{"5x", 2.5},
			{"10x", 5.0},
			{"20x", 10.0}
		}
	},
	cam_rot = {
		index = 1,
		value = {
			{"1x", 1.0},
			{"2x", 2.0},
			{"5x", 5.0}
		}
	},
	grid_offset = {
		index = 3,
		value = {
			{"0.001x", 0.001},
			{"0.01x", 0.01},
			{"0.1x", 0.1},
			{"1x", 1.0},
			{"10x", 10.0},
		}
	},
	checkpoint_offset = {
		index = 3,
		value = {
			{"0.001x", 0.001},
			{"0.01x", 0.01},
			{"0.1x", 0.1},
			{"1x", 1.0},
			{"10x", 10.0},
			{"100x", 100.0}
		}
	},
	prop_offset = {
		index = 3,
		value = {
			{"0.001x", 0.001},
			{"0.01x", 0.01},
			{"0.1x", 0.1},
			{"1x", 1.0},
			{"10x", 10.0},
			{"100x", 100.0}
		}
	},
	template_offset = {
		index = 3,
		value = {
			{"0.001x", 0.001},
			{"0.01x", 0.01},
			{"0.1x", 0.1},
			{"1x", 1.0},
			{"10x", 10.0},
			{"100x", 100.0}
		}
	},
	move_offset = {
		index = 5,
		value = {
			{"0.001x", 0.001},
			{"0.01x", 0.01},
			{"0.1x", 0.1},
			{"1x", 1.0},
			{"10x", 10.0},
			{"100x", 100.0}
		}
	}
}

isStartingGridMenuVisible = false
isStartingGridVehiclePickedUp = false
startingGridVehicleIndex = 0
startingGridVehicleSelect = nil
startingGridVehiclePreview = nil
currentstartingGridVehicle = {
	index = nil,
	handle = nil,
	x = nil,
	y = nil,
	z = nil,
	heading = nil
}

checkpointDrawNumber = 0
checkpointTextDrawNumber = 0
isCheckpointMenuVisible = false
isCheckpointPickedUp = false
checkpointIndex = 0
checkpointPreview = nil
checkpointPreview_coords_change = false
currentCheckpoint = {
	index = nil,
	x = nil,
	y = nil,
	z = nil,
	heading = nil,
	d = nil,
	is_round = nil,
	is_air = nil,
	is_fake = nil,
	is_random = nil,
	randomClass = nil,
	is_transform = nil,
	transform_index = nil,
	is_planeRot = nil,
	plane_rot = nil,
	is_warp = nil
}

lastValidHash = nil
lastValidText = ""
isPropMenuVisible = false
isPropPickedUp = false
objectIndex = 0
objectSelect = nil
objectPreview = nil
objectPreview_coords_change = false
isPropPositionRelativeEnable = false
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

isPropStackEnable = false
childPropBoneCount = nil
childPropBoneIndex = nil
stackObject = {
	handle = nil,
	boneCount = nil,
	boneIndex = nil
}

isTemplateMenuVisible = false
isTemplatePropPickedUp = false
templatePreview_coords_change = false
templatePreview = {}
currentTemplate = {
	index = nil,
	props = {}
}

isFixtureRemoverMenuVisible = false
fixtureIndex = 0
currentFixture = {
	hash = nil,
	handle = nil,
	x = nil,
	y = nil,
	z = nil
}

isFireworkMenuVisible = false
fireworkPreview = false
firework = {}
arenaProp = {}
particleIndex = 1
particles = {"scr_indep_firework_trailburst", "scr_indep_firework_starburst", "scr_indep_firework_shotburst", "scr_indep_firework_fountain"}

isInRace = false
nuiCallBack = ""
camera = nil
cameraPosition = nil
cameraRotation = nil
cameraFramerateMoveFix = 1.0
loopGetCameraFramerate = false
joinCreatorPoint = nil
joinCreatorHeading = nil
joinCreatorVehicle = 0
buttonToDraw = 0

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
	currentLanguage = 0,
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
	creatorBlipHandle = nil,
	autoRespawn = true,
	isRespawning = false,
	enableBeastMode = false,
	DisableNpcChecked = false,
	showAllModelCheckedMsg = false
}

blips = {
	checkpoints = {},
	checkpoints_2 = {},
	objects = {}
}

blimp = {
	scaleform = nil,
	rendertarget = nil
}

weatherTypes = {
	[1] = 'CLEAR',
	[2] = 'EXTRASUNNY',
	[3] = 'CLOUDS',
	[4] = 'OVERCAST',
	[5] = 'RAIN',
	[6] = 'CLEARING',
	[7] = 'THUNDER',
	[8] = 'SMOG',
	[9] = 'FOGGY',
	[10] = 'XMAS',
	[11] = 'SNOW',
	[12] = 'SNOWLIGHT',
	[13] = 'BLIZZARD',
	[14] = 'HALLOWEEN',
	[15] = 'NEUTRAL'
}

hourIndex = 1
hours = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}
minuteIndex = 1
minutes = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59}
secondIndex = 1
seconds = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59}
creatorVehicle = {}

Citizen.CreateThread(function()
	while true do
		ExtendWorldBoundaryForPlayer(-100000000000000000000000.0, -100000000000000000000000.0, 100000000000000000000000.0)
		ExtendWorldBoundaryForPlayer(100000000000000000000000.0, 100000000000000000000000.0, 100000000000000000000000.0)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		global_var.IsNuiFocused = IsNuiFocused()
		global_var.IsPauseMenuActive = IsPauseMenuActive()
		global_var.IsPlayerSwitchInProgress = IsPlayerSwitchInProgress()

		if IsControlJustReleased(0, Config.OpenCreatorKey) and not global_var.enableCreator and not global_var.IsNuiFocused and not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress and not isInRace and not isAllModelChecked then
			if (checkedModelsCount > 0) and (totalModelsCount > 0) then
				DisplayCustomMsgs(string.format(GetTranslate("wait-models", GetCurrentLanguage()), RoundedValue((checkedModelsCount / totalModelsCount) * 100, 2) .. "%"))
				if not global_var.showAllModelCheckedMsg then
					global_var.showAllModelCheckedMsg = true
					Citizen.CreateThread(function()
						while not isAllModelChecked do
							Citizen.Wait(0)
						end
						DisplayCustomMsgs(GetTranslate("wait-models-done", GetCurrentLanguage()))
						global_var.showAllModelCheckedMsg = false
					end)
				end
			end
		elseif IsControlJustReleased(0, Config.OpenCreatorKey) and not global_var.enableCreator and not global_var.IsNuiFocused and not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress and not isInRace and isAllModelChecked then
			TriggerEvent('custom_creator:load')
			global_var.enableCreator = true
			SetWeatherTypeNowPersist("CLEAR")
			hourIndex = 13
			minuteIndex = 1
			secondIndex = 1
			NetworkOverrideClockTime(hours[hourIndex], minutes[minuteIndex], seconds[secondIndex])
			global_var.timeChecked = true
			joinCreatorPoint = GetEntityCoords(ped)
			joinCreatorHeading = GetEntityHeading(ped)
			joinCreatorVehicle = GetVehiclePedIsIn(ped, false)
			if joinCreatorVehicle ~= 0 then
				creatorVehicle = GetVehicleProperties(joinCreatorVehicle) or creatorVehicle or {}
				currentRace.test_vehicle = creatorVehicle.model
				SetEntityCoordsNoOffset(ped, joinCreatorPoint)
				SetEntityVisible(joinCreatorVehicle, false)
				SetEntityCollision(joinCreatorVehicle, false, false)
				FreezeEntityPosition(joinCreatorVehicle, true)
			end
			global_var.lock = true
			TriggerServerCallback("custom_creator:server:get_list", function(result, _template)
				races_data.category = result
				if races_data.index > #result then
					races_data.index = 1
				end
				local races = {}
				local seen = {}
				local str = string.lower(races_data.filter)
				if #str > 0 then
					for i = 1, #races_data.category - 1 do
						for j = 1, #races_data.category[i].data do
							if string.find(string.lower(races_data.category[i].data[j].name), str) and not seen[races_data.category[i].data[j].raceid] then
								table.insert(races, races_data.category[i].data[j])
								seen[races_data.category[i].data[j].raceid] = true
								if #races >= 50 then
									break
								end
							end
						end
						if #races >= 50 then
							break
						end
					end
				end
				races_data.category[#races_data.category].data = races
				template = _template or {}
				templateIndex = (#template > 0) and 1 or 0
				global_var.lock = false
			end)
			SetBlipAlpha(GetMainPlayerBlipId(), 0)
			global_var.creatorBlipHandle = AddBlipForCoord(joinCreatorPoint.x, joinCreatorPoint.y, joinCreatorPoint.z)
			SetBlipSprite(global_var.creatorBlipHandle, 398)
			SetBlipPriority(global_var.creatorBlipHandle, 10)
			SetLocalPlayerAsGhost(true)
			RemoveAllPedWeapons(ped, false)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
			DeleteWaypoint()
			OpenCreatorMenu()
			CreateCreatorFreeCam(ped)
			LoopGetCameraFramerateMoveFix()
			InitScrollTextOnBlimp()
			ClearAreaLeaveVehicleHealth(joinCreatorPoint.x + 0.0, joinCreatorPoint.y + 0.0, joinCreatorPoint.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
		end

		if global_var.enableCreator then
			local pos = GetEntityCoords(ped)
			if (global_var.IsPauseMenuActive or global_var.IsPlayerSwitchInProgress or (IsWarningMessageActive() and tonumber(GetWarningMessageTitleHash()) == 1246147334)) and not global_var.TempClosed and not global_var.enableTest then
				global_var.TempClosed = true
				RageUI.CloseAll()
			elseif not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress and not (IsWarningMessageActive() and tonumber(GetWarningMessageTitleHash()) == 1246147334) and global_var.TempClosed and not global_var.enableTest then
				global_var.TempClosed = false
				OpenCreatorMenu()
			end

			DisableControlAction(0, 36, true)
			DisableControlAction(0, 37, true)
			SetEntityInvincible(ped, true)
			SetPedArmour(ped, 100)
			SetEntityHealth(ped, 200)

			if blimp.scaleform and blimp.rendertarget then
				SetTextRenderId(blimp.rendertarget)
				SetScriptGfxDrawOrder(4)
				SetScriptGfxDrawBehindPausemenu(true)
				SetScaleformMovieToUseSuperLargeRt(blimp.scaleform, true)
				DrawScaleformMovie(blimp.scaleform, 0.0, -0.08, 1.0, 1.7, 255, 255, 255, 255, 0)
				SetTextRenderId(GetDefaultScriptRendertargetRenderId())
			end

			if global_var.DisableNpcChecked then
				DisableTrafficAndNpc(pos)
			end

			if (global_var.currentLanguage ~= GetCurrentLanguage()) and not IsPauseMenuActive() then
				global_var.currentLanguage = GetCurrentLanguage()
				MainMenu.Title, MainMenu.Subtitle = GetTranslate("MainMenu-Title"), GetTranslate("MainMenu-Subtitle")
				RaceDetailSubMenu.Subtitle = GetTranslate("RaceDetailSubMenu-Subtitle")
				PlacementSubMenu.Subtitle = GetTranslate("PlacementSubMenu-Subtitle")
				PlacementSubMenu_StartingGrid.Subtitle = GetTranslate("PlacementSubMenu_StartingGrid-Subtitle")
				PlacementSubMenu_Checkpoints.Subtitle = GetTranslate("PlacementSubMenu_Checkpoints-Subtitle")
				PlacementSubMenu_Props.Subtitle = GetTranslate("PlacementSubMenu_Props-Subtitle")
				PlacementSubMenu_Templates.Subtitle = GetTranslate("PlacementSubMenu_Templates-Subtitle")
				PlacementSubMenu_MoveAll.Subtitle = GetTranslate("PlacementSubMenu_MoveAll-Subtitle")
				PlacementSubMenu_FixtureRemover.Subtitle = GetTranslate("PlacementSubMenu_FixtureRemover-Subtitle")
				PlacementSubMenu_Firework.Subtitle = GetTranslate("PlacementSubMenu_Firework-Subtitle")
				WeatherSubMenu.Subtitle = GetTranslate("WeatherSubMenu-Subtitle")
				TimeSubMenu.Subtitle = GetTranslate("TimeSubMenu-Subtitle")
				MiscSubMenu.Subtitle = GetTranslate("MiscSubMenu-Subtitle")
				if global_var.enableTest and global_var.tipsRendered then
					ClearAllHelpMessages()
					BeginTextCommandDisplayHelp("THREESTRINGS")
					AddTextComponentSubstringPlayerName(GetTranslate("quit-test"))
					AddTextComponentSubstringPlayerName("")
					AddTextComponentSubstringPlayerName("")
					EndTextCommandDisplayHelp(0, true, false, -1)
				end
			end

			if global_var.IsUsingKeyboard ~= IsUsingKeyboard() then
				global_var.IsUsingKeyboard = IsUsingKeyboard()
				if global_var.enableTest and global_var.tipsRendered then
					ClearAllHelpMessages()
					BeginTextCommandDisplayHelp("THREESTRINGS")
					AddTextComponentSubstringPlayerName(GetTranslate("quit-test"))
					AddTextComponentSubstringPlayerName("")
					AddTextComponentSubstringPlayerName("")
					EndTextCommandDisplayHelp(0, true, false, -1)
				end
			end

			if global_var.enableTest then
				SetPlayerCanDoDriveBy(PlayerId(), true)
				DisableControlAction(0, 75, true)
				local vehicle = GetVehiclePedIsIn(ped, false)
				if vehicle ~= 0 then
					local rot = GetEntityRotation(vehicle, 2)
					local pitch, roll, yaw = table.unpack(rot)
					if math.abs(pitch) < 90.0 and math.abs(roll) < 45.0 and not IsEntityInWater(ped) then
						SetPedConfigFlag(ped, 151, false)
						SetPedCanBeKnockedOffVehicle(ped, 1)
					else
						SetPedConfigFlag(ped, 151, true)
						SetPedCanBeKnockedOffVehicle(ped, 3)
					end
					if GetEntityModel(vehicle) == GetHashKey("bmx") then
						EnableControlAction(0, 68, true)
					else
						DisableControlAction(0, 68, true)
					end
					for k, v in pairs(arenaProp) do
						if IsEntityTouchingEntity(vehicle, v.handle) and not v.touching then
							v.touching = true
							Citizen.CreateThread(function()
								SetEnableArenaPropPhysics(v.handle, true)
								Citizen.Wait(5000)
								SetEnableArenaPropPhysics(v.handle, false)
								v.touching = false
							end)
						end
					end
				end

				if global_var.enableBeastMode then
					SetSuperJumpThisFrame(PlayerId())
					SetBeastModeActive(PlayerId())
				end

				if #currentRace.fixtures > 0 then
					local hide = {}
					for k, v in pairs(currentRace.fixtures) do
						hide[v.hash] = true
					end
					local pool = GetGamePool('CObject')
					for i = 1, #pool do
						local fixture = pool[i]
						local found = false
						for k, v in pairs(currentRace.objects) do
							if fixture == v.handle then
								found = true
								break
							end
						end
						if not found and fixture and DoesEntityExist(fixture) then
							local hash = GetEntityModel(fixture)
							if hide[hash] then
								SetEntityAsMissionEntity(fixture, true, true)
								DeleteEntity(fixture)
							end
						end
					end
					for k, v in pairs(currentRace.fixtures) do
						local fixture = GetClosestObjectOfType(pos.x, pos.y, pos.z, 300.0, v.hash, false)
						local found = false
						for k, v in pairs(currentRace.objects) do
							if fixture == v.handle then
								found = true
								break
							end
						end
						if not found and fixture and DoesEntityExist(fixture) then
							SetEntityAsMissionEntity(fixture, true, true)
							DeleteEntity(fixture)
						end
					end
				end

				for k, v in pairs(firework) do
					if not v.playing then
						if #(pos - vector3(v.x, v.y, v.z)) <= 50.0 then
							v.playing = true
							Citizen.CreateThread(function()
								local particleDictionary = "scr_indep_fireworks"
								local particleName = currentRace.firework.name
								local scale = 2.0
								RequestNamedPtfxAsset(particleDictionary)
								while not HasNamedPtfxAssetLoaded(particleDictionary) do
									Citizen.Wait(0)
								end
								UseParticleFxAssetNextCall(particleDictionary)
								local effect = StartParticleFxLoopedOnEntity(particleName, v.handle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
								if tonumber(currentRace.firework.r) and tonumber(currentRace.firework.g) and tonumber(currentRace.firework.b) then
									SetParticleFxLoopedColour(effect, (tonumber(currentRace.firework.r) / 255) + 0.0, (tonumber(currentRace.firework.g) / 255) + 0.0, (tonumber(currentRace.firework.b) / 255) + 0.0, true)
								end
								Citizen.Wait(2000)
								StopParticleFxLooped(effect, true)
								v.playing = false
							end)
						end
					end
				end

				if (IsControlJustReleased(0, 75) or IsDisabledControlJustReleased(0, 75)) and not global_var.isRespawning then
					global_var.isRespawning = true
					TestCurrentCheckpoint(global_var.isPrimaryCheckpointItems, checkpointIndex)
				elseif global_var.autoRespawn and not global_var.isRespawning and not IsPedInAnyVehicle(ped) then
					global_var.isRespawning = true
					TestCurrentCheckpoint(global_var.isPrimaryCheckpointItems, checkpointIndex)
				end

				if IsControlJustReleased(0, 48) and not global_var.isRespawning and global_var.tipsRendered then
					global_var.enableTest = false
					if global_var.testVehicleHandle then
						DeleteEntity(global_var.testVehicleHandle)
						global_var.testVehicleHandle = nil
					end
					RemoveBlip(global_var.testBlipHandle)
					global_var.testBlipHandle = nil
					if IsWaypointActive() then
						DeleteWaypoint()
					end
					Citizen.CreateThread(function()
						SetRadarBigmapEnabled(global_var.RadarBigmapChecked, false)
						Citizen.Wait(0)
						if global_var.RadarBigmapChecked then
							SetRadarZoom(500)
						else
							SetRadarZoom(0)
						end
					end)
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
					SetPedConfigFlag(ped, 151, true)
					SetPedCanBeKnockedOffVehicle(ped, 0)
					RemoveAllPedWeapons(ped, false)
					SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
					ClearAllHelpMessages()
					OpenCreatorMenu()
					CreateCreatorFreeCam(ped)
					SetEntityCoordsNoOffset(ped, pos.x + 1000.0, pos.y + 1000.0, pos.z)
					ClearAreaLeaveVehicleHealth(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
					for i = 1, #currentRace.objects do
						DeleteObject(currentRace.objects[i].handle)
						local newObject = createProp(currentRace.objects[i].hash, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z, currentRace.objects[i].rotX, currentRace.objects[i].rotY, currentRace.objects[i].rotZ, currentRace.objects[i].color)
						if currentRace.objects[i].visible then
							ResetEntityAlpha(newObject)
						end
						if not currentRace.objects[i].collision then
							SetEntityCollision(newObject, false, false)
						end
						currentRace.objects[i].handle = newObject
					end
					Citizen.Wait(0)
					for k, v in pairs(currentRace.checkpoints) do
						blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
					for k, v in pairs(currentRace.checkpoints_2) do
						blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
					end
					for k, v in pairs(currentRace.objects) do
						blips.objects[k] = createBlip(v.x, v.y, v.z, 0.60, 271, 50, v.handle)
					end
					firework = {}
					arenaProp = {}
					SetBlipAlpha(GetMainPlayerBlipId(), 0)
					global_var.creatorBlipHandle = AddBlipForCoord(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0)
					SetBlipSprite(global_var.creatorBlipHandle, 398)
					SetBlipPriority(global_var.creatorBlipHandle, 10)
				end
			end

			if global_var.IsNuiFocused and IsControlJustPressed(0, 255) and nuiCallBack ~= "" and not global_var.IsUsingKeyboard and not global_var.lock then
				SendNUIMessage({
					action = 'accept_controller'
				})
			end

			if RageUI.Visible(MainMenu) then
				buttonToDraw = -1
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			end

			if RageUI.Visible(RaceDetailSubMenu) then
				if not global_var.IsNuiFocused then
					if global_var.thumbnailValid then
						if not global_var.showThumbnail and not global_var.queryingThumbnail then
							global_var.showThumbnail = true
							SendNUIMessage({
								action = 'thumbnail_on'
							})
						end
					else
						if global_var.showThumbnail then
							global_var.showThumbnail = false
							SendNUIMessage({
								action = 'thumbnail_off'
							})
						end
					end
				else
					if global_var.showThumbnail then
						global_var.showThumbnail = false
						SendNUIMessage({
							action = 'thumbnail_off'
						})
					end
				end
			else
				if global_var.showThumbnail then
					global_var.showThumbnail = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
				end
				if (nuiCallBack == "race title" and currentRace.title ~= "") or nuiCallBack == "race thumbnail" or nuiCallBack == "test vehicle" or nuiCallBack == "blimp text" then
					SendNUIMessage({
						action = 'off'
					})
					SetNuiFocus(false, false)
					nuiCallBack = ""
				end
			end

			if RageUI.Visible(PlacementSubMenu_StartingGrid) then
				isStartingGridMenuVisible = true
				buttonToDraw = 1
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			else
				isStartingGridMenuVisible = false
				isStartingGridVehiclePickedUp = false
				if startingGridVehicleSelect then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
					startingGridVehicleSelect = nil
					currentstartingGridVehicle = {
						index = nil,
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
				end
				if startingGridVehiclePreview then
					DeleteVehicle(startingGridVehiclePreview)
					startingGridVehiclePreview = nil
					currentstartingGridVehicle = {
						index = nil,
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
				end
				if nuiCallBack == "startingGrid heading" then
					SendNUIMessage({
						action = 'off'
					})
					SetNuiFocus(false, false)
					nuiCallBack = ""
				end
			end

			if RageUI.Visible(PlacementSubMenu_Checkpoints) then
				isCheckpointMenuVisible = true
				buttonToDraw = 2
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			else
				isCheckpointMenuVisible = false
				isCheckpointPickedUp = false
				if checkpointPreview then
					checkpointPreview = nil
					currentCheckpoint = {
						index = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil,
						d = nil,
						is_round = nil,
						is_air = nil,
						is_fake = nil,
						is_random = nil,
						randomClass = nil,
						is_transform = nil,
						transform_index = nil,
						is_planeRot = nil,
						plane_rot = nil,
						is_warp = nil
					}
				end
				if nuiCallBack == "place checkpoint" or nuiCallBack == "checkpoint x" or nuiCallBack == "checkpoint y" or nuiCallBack == "checkpoint z" or nuiCallBack == "checkpoint heading" or nuiCallBack == "checkpoint transform vehicles" then
					SendNUIMessage({
						action = 'off'
					})
					SetNuiFocus(false, false)
					nuiCallBack = ""
				end
			end

			if RageUI.Visible(PlacementSubMenu_Props) then
				isPropMenuVisible = true
				buttonToDraw = 3
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			else
				isPropMenuVisible = false
				isPropPickedUp = false
				if stackObject.handle then
					SetEntityDrawOutline(stackObject.handle, false)
					stackObject = {
						handle = nil,
						boneCount = nil,
						boneIndex = nil
					}
				end
				if objectSelect then
					SetEntityDrawOutline(objectSelect, false)
					objectSelect = nil
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
				if objectPreview then
					DeleteObject(objectPreview)
					objectPreview = nil
					childPropBoneCount = nil
					childPropBoneIndex = nil
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
				global_var.propZposLock = nil
				globalRot.x = 0.0
				globalRot.y = 0.0
				global_var.propColor = nil
				if nuiCallBack == "prop hash" or nuiCallBack == "prop x" or nuiCallBack == "prop y" or nuiCallBack == "prop z" or nuiCallBack == "prop rotX" or nuiCallBack == "prop rotY" or nuiCallBack == "prop rotZ" or nuiCallBack == "prop override" then
					SendNUIMessage({
						action = 'off'
					})
					SetNuiFocus(false, false)
					nuiCallBack = ""
				end
			end

			if RageUI.Visible(PlacementSubMenu_Templates) then
				isTemplateMenuVisible = true
				buttonToDraw = 4
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			else
				isTemplateMenuVisible = false
				isTemplatePropPickedUp = false
				if #currentTemplate.props > 0 then
					for i = 1, #currentTemplate.props do
						SetEntityDrawOutline(currentTemplate.props[i].handle, false)
					end
					currentTemplate = {
						index = nil,
						props = {}
					}
				end
				if #templatePreview > 0 then
					for i = 1, #templatePreview do
						DeleteObject(templatePreview[i].handle)
					end
					templatePreview = {}
				end
				if nuiCallBack == "template x" or nuiCallBack == "template y" or nuiCallBack == "template z" or nuiCallBack == "template rotX" or nuiCallBack == "template rotY" or nuiCallBack == "template rotZ" or nuiCallBack == "template override" then
					SendNUIMessage({
						action = 'off'
					})
					SetNuiFocus(false, false)
					nuiCallBack = ""
				end
			end

			if RageUI.Visible(PlacementSubMenu_MoveAll) then
				buttonToDraw = 5
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
				if not global_var.IsBigmapActive then
					global_var.IsBigmapActive = true
					Citizen.CreateThread(function()
						SetRadarBigmapEnabled(true, false)
						Citizen.Wait(0)
						SetRadarZoom(500)
					end)
				end
			else
				if global_var.IsBigmapActive then
					global_var.IsBigmapActive = false
					if not global_var.RadarBigmapChecked then
						Citizen.CreateThread(function()
							SetRadarBigmapEnabled(false, false)
							Citizen.Wait(0)
							SetRadarZoom(0)
						end)
					end
				end
			end

			if RageUI.Visible(PlacementSubMenu_FixtureRemover) then
				isFixtureRemoverMenuVisible = true
				buttonToDraw = 0
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			else
				isFixtureRemoverMenuVisible = false
				if currentFixture.handle then
					SetEntityDrawOutline(currentFixture.handle, false)
					currentFixture = {
						hash = nil,
						handle = nil,
						x = nil,
						y = nil,
						z = nil
					}
				end
			end

			if RageUI.Visible(PlacementSubMenu_Firework) then
				isFireworkMenuVisible = true
				buttonToDraw = 5
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
				if camera ~= nil then
					SetCamCoord(camera, 0.0, 60.0, 1050.0)
					SetCamRot(camera, -15.0, 0.0, -180.0, 2)
					SetEntityCoordsNoOffset(ped, 0.0, 75.0, 1050.0)
					NetworkOverrideClockTime(0, 0, 0)
				end
				if not fireworkPreview then
					fireworkPreview = true
					Citizen.CreateThread(function()
						local particleDictionary = "scr_indep_fireworks"
						local particleName = currentRace.firework.name
						local scale = 2.0
						RequestNamedPtfxAsset(particleDictionary)
						while not HasNamedPtfxAssetLoaded(particleDictionary) do
							Citizen.Wait(0)
						end
						UseParticleFxAssetNextCall(particleDictionary)
						local effect = StartParticleFxLoopedAtCoord(particleName, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0, scale, false, false, false, false)
						if tonumber(currentRace.firework.r) and tonumber(currentRace.firework.g) and tonumber(currentRace.firework.b) then
							SetParticleFxLoopedColour(effect, (tonumber(currentRace.firework.r) / 255) + 0.0, (tonumber(currentRace.firework.g) / 255) + 0.0, (tonumber(currentRace.firework.b) / 255) + 0.0, true)
						end
						Citizen.Wait(2000)
						StopParticleFxLooped(effect, true)
						fireworkPreview = false
					end)
				end
			else
				isFireworkMenuVisible = false
			end

			if RageUI.Visible(RaceDetailSubMenu) or RageUI.Visible(PlacementSubMenu) or RageUI.Visible(WeatherSubMenu) or RageUI.Visible(TimeSubMenu) or RageUI.Visible(MiscSubMenu) then
				buttonToDraw = 0
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			end

			if not isFireworkMenuVisible then
				if global_var.timeChecked then
					NetworkOverrideClockTime(hours[hourIndex], minutes[minuteIndex], seconds[secondIndex])
				else
					hourIndex = GetClockHours() + 1
					minuteIndex = GetClockMinutes() + 1
					secondIndex = GetClockSeconds() + 1
				end
			end

			if camera ~= nil and not global_var.enableTest and not isFireworkMenuVisible then
				local fix_rot = global_var.IsUsingKeyboard and 2.0 or 1.0 -- Mouse DPI: 1600
				local fix_pos = IsControlPressed(1, 352) and 5.0 or 1.0 -- LEFT SHIFT or Xbox Controller L3
				if global_var.IsPauseMenuActive and IsWaypointActive() then
					local waypoint = GetBlipInfoIdCoord(GetFirstBlipInfoId(GetWaypointBlipEnumId()))
					cameraPosition = vector3(waypoint.x + 0.0, waypoint.y + 0.0, cameraPosition.z + 0.0)
					DeleteWaypoint()
				end
				if IsControlPressed(1, 32) then -- W or Xbox Controller
					cameraPosition = cameraPosition + GetCameraForwardVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if IsControlPressed(1, 33) then -- S or Xbox Controller
					cameraPosition = cameraPosition - GetCameraForwardVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if IsControlPressed(1, 34) then -- A or Xbox Controller
					cameraPosition = cameraPosition - GetCameraRightVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if IsControlPressed(1, 35) then -- D or Xbox Controller
					cameraPosition = cameraPosition + GetCameraRightVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if cameraPosition.z + 0.0 > 3000 then
					cameraPosition = vector3(cameraPosition.x + 0.0, cameraPosition.y + 0.0, 3000.0)
				elseif cameraPosition.z + 0.0 < -200 then
					cameraPosition = vector3(cameraPosition.x + 0.0, cameraPosition.y + 0.0, -200.0)
				end
				local mouseX = GetControlNormal(1, 1) -- Mouse or Xbox Controller
				local mouseY = GetControlNormal(1, 2) -- Mouse or Xbox Controller
				cameraRotation.x = cameraRotation.x - mouseY * speed.cam_rot.value[speed.cam_rot.index][2] * fix_rot * (fix_pos / 2) * cameraFramerateMoveFix
				cameraRotation.z = cameraRotation.z - mouseX * speed.cam_rot.value[speed.cam_rot.index][2] * fix_rot * (fix_pos / 2) * cameraFramerateMoveFix
				if cameraRotation.x > 89.9 then
					cameraRotation.x = 89.9
				elseif cameraRotation.x < -89.9 then
					cameraRotation.x = -89.9
				end
				if (cameraRotation.z > 9999.0) or (cameraRotation.z < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					cameraRotation.z = 0.0
				end
				SetCamCoord(camera, cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0)
				SetCamRot(camera, cameraRotation.x + 0.0, cameraRotation.y + 0.0, cameraRotation.z + 0.0, 2)
				SetEntityCoordsNoOffset(ped, cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0)
				SetEntityHeading(ped, cameraRotation.z + 0.0)
				if not IsEntityPositionFrozen(ped) then
					FreezeEntityPosition(ped, true)
				end
				if IsEntityVisible(ped) then
					SetEntityVisible(ped, false)
				end
				if not GetEntityCollisionDisabled(ped) then
					SetEntityCollision(ped, false, false)
				end
				if global_var.creatorBlipHandle and DoesBlipExist(global_var.creatorBlipHandle) then
					SetBlipCoords(global_var.creatorBlipHandle, cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0)
				end
			end

			local entity, endCoords, surfaceNormal = GetEntityInView(-1)
			if isPropMenuVisible then
				if not isPropPickedUp and isPropStackEnable and entity and endCoords then
					local found = false
					for k, v in pairs(currentRace.objects) do
						if (entity == v.handle) then
							if (stackObject.handle ~= v.handle) then
								local _boneCount = GetEntityBoneCount(v.handle)
								if _boneCount > 0 then
									if stackObject.handle then
										SetEntityDrawOutline(stackObject.handle, false)
									end
									SetEntityDrawOutlineColor(150, 255, 255, 125)
									SetEntityDrawOutlineShader(1)
									SetEntityDrawOutline(v.handle, true)
									stackObject = {
										handle = v.handle,
										boneCount = _boneCount,
										boneIndex = -1
									}
								else
									if stackObject.handle then
										SetEntityDrawOutline(stackObject.handle, false)
										stackObject = {
											handle = nil,
											boneCount = nil,
											boneIndex = nil
										}
									end
								end
							end
							found = true
							break
						end
					end
					if not found then
						if stackObject.handle then
							SetEntityDrawOutline(stackObject.handle, false)
							stackObject = {
								handle = nil,
								boneCount = nil,
								boneIndex = nil
							}
						end
					end
				elseif not isPropStackEnable or not entity or not endCoords then
					if stackObject.handle then
						SetEntityDrawOutline(stackObject.handle, false)
						stackObject = {
							handle = nil,
							boneCount = nil,
							boneIndex = nil
						}
					end
				end
			end

			if isFixtureRemoverMenuVisible then
				local found = false
				for k, v in pairs(currentRace.objects) do
					if entity == v.handle then
						found = true
						break
					end
				end
				if not found and entity and IsEntityAnObject(entity) then
					if not currentFixture.handle or (currentFixture.handle ~= entity) then
						if currentFixture.handle then
							SetEntityDrawOutline(currentFixture.handle, false)
						end
						SetEntityDrawOutlineColor(255, 255, 30, 125)
						SetEntityDrawOutlineShader(1)
						SetEntityDrawOutline(entity, true)
						currentFixture.hash = GetEntityModel(entity)
						currentFixture.handle = entity
						local coords = GetEntityCoords(entity)
						currentFixture.x = RoundedValue(coords.x, 3)
						currentFixture.y = RoundedValue(coords.y, 3)
						currentFixture.z = RoundedValue(coords.z, 3)
					end
				else
					if currentFixture.handle then
						SetEntityDrawOutline(currentFixture.handle, false)
						currentFixture = {
							hash = nil,
							handle = nil,
							x = nil,
							y = nil,
							z = nil
						}
					end
				end
			end

			if IsControlJustReleased(0, 203) and not global_var.IsNuiFocused then
				if isStartingGridMenuVisible then
					local found = false
					for k, v in pairs(currentRace.startingGrid) do
						if entity == v.handle then
							DeleteVehicle(startingGridVehiclePreview)
							startingGridVehiclePreview = nil
							if startingGridVehicleSelect then
								currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
								ResetEntityAlpha(startingGridVehicleSelect)
								SetEntityDrawOutlineColor(255, 255, 255, 125)
								SetEntityDrawOutlineShader(1)
								SetEntityDrawOutline(startingGridVehicleSelect, true)
							end
							SetEntityDrawOutline(entity, false)
							SetEntityAlpha(entity, 150)
							startingGridVehicleSelect = entity
							global_var.isSelectingStartingGridVehicle = true
							isStartingGridVehiclePickedUp = true
							startingGridVehicleIndex = k
							currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[k])
							globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
							found = true
							break
						end
					end
					if not found then
						if startingGridVehicleSelect then
							currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
							ResetEntityAlpha(startingGridVehicleSelect)
							SetEntityDrawOutlineColor(255, 255, 255, 125)
							SetEntityDrawOutlineShader(1)
							SetEntityDrawOutline(startingGridVehicleSelect, true)
							isStartingGridVehiclePickedUp = false
							startingGridVehicleSelect = nil
						end
					end
				elseif isCheckpointMenuVisible then
					if not checkpointPreview and isCheckpointPickedUp then
						isCheckpointPickedUp = false
					end
				elseif isPropMenuVisible then
					local found = false
					local found_2 = false
					for k, v in pairs(currentRace.objects) do
						if entity == v.handle then
							if stackObject.handle then
								SetEntityDrawOutline(stackObject.handle, false)
								stackObject = {
									handle = nil,
									boneCount = nil,
									boneIndex = nil
								}
							end
							SetEntityDrawOutlineColor(255, 255, 255, 125)
							SetEntityDrawOutlineShader(1)
							DeleteObject(objectPreview)
							objectPreview = nil
							childPropBoneCount = nil
							childPropBoneIndex = nil
							currentObject = tableDeepCopy(currentRace.objects[k])
							global_var.propZposLock = currentObject.z
							globalRot.x = RoundedValue(currentObject.rotX, 3)
							globalRot.y = RoundedValue(currentObject.rotY, 3)
							globalRot.z = RoundedValue(currentObject.rotZ, 3)
							global_var.propColor = currentObject.color
							lastValidHash = GetEntityModel(entity)
							for k, v in pairs(category) do
								if not found_2 then
									for i = 1, #v.model do
										local hash = tonumber(v.model[i]) or GetHashKey(v.model[i])
										if lastValidHash == hash then
											found_2 = true
											lastValidText = v.model[i]
											v.index = i
											categoryIndex = k
											break
										end
									end
								end
							end
							if not found_2 then
								local hash_2 = tonumber(lastValidText) or GetHashKey(lastValidText)
								if lastValidHash ~= hash_2 then
									lastValidText = tostring(lastValidHash) or ""
								end
							end
							objectIndex = k
							if objectSelect == entity then
								SetEntityDrawOutline(entity, false)
								isPropPickedUp = false
								objectSelect = nil
							else
								if objectSelect then
									SetEntityDrawOutline(objectSelect, false)
								end
								SetEntityDrawOutline(entity, true)
								objectSelect = entity
								isPropPickedUp = true
							end
							found = true
							break
						end
					end
					if not found then
						if objectSelect then
							SetEntityDrawOutline(objectSelect, false)
							isPropPickedUp = false
							objectSelect = nil
						elseif entity and (entity ~= objectPreview) and (IsEntityAnObject(entity) or IsEntityAVehicle(entity)) then
							local rotation = GetEntityRotation(entity, 2)
							globalRot.x = RoundedValue(rotation.x, 3)
							globalRot.y = RoundedValue(rotation.y, 3)
							globalRot.z = RoundedValue(rotation.z, 3)
							global_var.propZposLock = nil
							global_var.propColor = GetObjectTextureVariation(entity)
							DeleteObject(objectPreview)
							objectPreview = nil
							childPropBoneCount = nil
							childPropBoneIndex = nil
							lastValidHash = GetEntityModel(entity)
							lastValidText = tostring(lastValidHash) or ""
							DisplayCustomMsgs(string.format(GetTranslate("add-hash"), lastValidText))
						end
					end
				elseif isTemplateMenuVisible then
					for k, v in pairs(currentRace.objects) do
						if entity == v.handle and IsEntityPositionFrozen(entity) then
							local found = false
							for i = 1, #currentTemplate.props do
								if currentTemplate.props[i].handle == entity then
									found = true
									SetEntityDrawOutline(entity, false)
									table.remove(currentTemplate.props, i)
									break
								end
							end
							if not found then
								SetEntityDrawOutlineColor(255, 255, 255, 125)
								SetEntityDrawOutlineShader(1)
								SetEntityDrawOutline(entity, true)
								table.insert(currentTemplate.props, currentRace.objects[k])
							end
							if #currentTemplate.props > 0 then
								if #templatePreview > 0 then
									for i = 1, #templatePreview do
										DeleteObject(templatePreview[i].handle)
									end
									templatePreview = {}
								end
								isTemplatePropPickedUp = true
							else
								isTemplatePropPickedUp = false
							end
							break
						end
					end
				end
			end

			if endCoords or (global_var.propZposLock and isPropMenuVisible) then
				local _, groundZ = nil, -200.0
				if endCoords then
					_, groundZ = GetGroundZFor_3dCoord(endCoords.x, endCoords.y, endCoords.z, true)
				end
				if isStartingGridMenuVisible then
					if not startingGridVehiclePreview and not isStartingGridVehiclePickedUp then
						local hash = (currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle)) or GetHashKey("bmx")
						local min, max = GetModelDimensions(hash)
						local coord_z = RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (coord_z > -198.99) and (coord_z <= 2698.99) and ((#currentRace.startingGrid == 0) or (currentRace.startingGrid[1] and (#(vector3(RoundedValue(endCoords.x, 3), RoundedValue(endCoords.y, 3), coord_z) - vector3(currentRace.startingGrid[1].x, currentRace.startingGrid[1].y, currentRace.startingGrid[1].z)) < 200.0))) then
							startingGridVehiclePreview = createVeh(hash, RoundedValue(endCoords.x, 3), RoundedValue(endCoords.y, 3), coord_z, globalRot.z)
							if startingGridVehiclePreview then
								currentstartingGridVehicle = {
									index = #currentRace.startingGrid + 1,
									handle = startingGridVehiclePreview,
									x = RoundedValue(endCoords.x, 3),
									y = RoundedValue(endCoords.y, 3),
									z = coord_z,
									heading = globalRot.z
								}
								SetEntityCoordsNoOffset(startingGridVehiclePreview, currentstartingGridVehicle.x, currentstartingGridVehicle.y, currentstartingGridVehicle.z)
							end
						end
					elseif startingGridVehiclePreview and not isStartingGridVehiclePickedUp then
						local min, max = GetModelDimensions(GetEntityModel(startingGridVehiclePreview))
						local coord_z = RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (coord_z > -198.99) and (coord_z <= 2698.99) and ((#currentRace.startingGrid == 0) or (currentRace.startingGrid[1] and (#(vector3(RoundedValue(endCoords.x, 3), RoundedValue(endCoords.y, 3), coord_z) - vector3(currentRace.startingGrid[1].x, currentRace.startingGrid[1].y, currentRace.startingGrid[1].z)) < 200.0))) then
							currentstartingGridVehicle.x = RoundedValue(endCoords.x, 3)
							currentstartingGridVehicle.y = RoundedValue(endCoords.y, 3)
							currentstartingGridVehicle.z = coord_z
							SetEntityCoordsNoOffset(startingGridVehiclePreview, currentstartingGridVehicle.x, currentstartingGridVehicle.y, currentstartingGridVehicle.z)
						else
							if startingGridVehiclePreview then
								DeleteVehicle(startingGridVehiclePreview)
								startingGridVehiclePreview = nil
								currentstartingGridVehicle = {
									index = nil,
									handle = nil,
									x = nil,
									y = nil,
									z = nil,
									heading = nil
								}
								if nuiCallBack ~= "" then
									SendNUIMessage({
										action = 'off'
									})
									SetNuiFocus(false, false)
									nuiCallBack = ""
								end
							end
							if (coord_z <= -198.99) or (coord_z > 2698.99) then
								DisplayCustomMsgs(GetTranslate("z-limit"))
							else
								DisplayCustomMsgs(GetTranslate("startingGrid-error1"))
							end
						end
					elseif isStartingGridVehiclePickedUp and global_var.isSelectingStartingGridVehicle then
						global_var.isSelectingStartingGridVehicle = false
					elseif isStartingGridVehiclePickedUp and not global_var.isSelectingStartingGridVehicle then
						local min, max = GetModelDimensions(GetEntityModel(startingGridVehicleSelect))
						local coord_z = RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (coord_z > -198.99) and (coord_z <= 2698.99) and ((#currentRace.startingGrid == 0) or (currentRace.startingGrid[1] and (#(vector3(RoundedValue(endCoords.x, 3), RoundedValue(endCoords.y, 3), coord_z) - vector3(currentRace.startingGrid[1].x, currentRace.startingGrid[1].y, currentRace.startingGrid[1].z)) < 200.0))) then
							currentstartingGridVehicle.x = RoundedValue(endCoords.x, 3)
							currentstartingGridVehicle.y = RoundedValue(endCoords.y, 3)
							currentstartingGridVehicle.z = coord_z
							SetEntityCoordsNoOffset(startingGridVehicleSelect, currentstartingGridVehicle.x, currentstartingGridVehicle.y, currentstartingGridVehicle.z)
						else
							for k, v in pairs(currentRace.startingGrid) do
								if startingGridVehicleSelect == v.handle then
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
							DeleteVehicle(startingGridVehicleSelect)
							isStartingGridVehiclePickedUp = false
							startingGridVehicleSelect = nil
							currentstartingGridVehicle = {
								index = nil,
								handle = nil,
								x = nil,
								y = nil,
								z = nil,
								heading = nil
							}
							if nuiCallBack ~= "" then
								SendNUIMessage({
									action = 'off'
								})
								SetNuiFocus(false, false)
								nuiCallBack = ""
							end
							if (coord_z <= -198.99) or (coord_z > 2698.99) then
								DisplayCustomMsgs(GetTranslate("z-limit"))
							else
								DisplayCustomMsgs(GetTranslate("startingGrid-error1"))
							end
						end
					end
				elseif isCheckpointMenuVisible then
					if not checkpointPreview and not isCheckpointPickedUp then
						checkpointPreview_coords_change = false
						currentCheckpoint = {
							index = #currentRace.checkpoints + 1,
							x = RoundedValue(endCoords.x, 3),
							y = RoundedValue(endCoords.y, 3),
							z = RoundedValue(groundZ > endCoords.z and groundZ or endCoords.z, 3),
							heading = globalRot.z,
							d = 1.0,
							is_round = nil,
							is_air = nil,
							is_fake = nil,
							is_random = nil,
							randomClass = nil,
							is_transform = nil,
							transform_index = nil,
							is_planeRot = nil,
							plane_rot = nil,
							is_warp = nil
						}
						checkpointPreview = true
					elseif checkpointPreview and not isCheckpointPickedUp then
						if not checkpointPreview_coords_change then
							currentCheckpoint.x = RoundedValue(endCoords.x, 3)
							currentCheckpoint.y = RoundedValue(endCoords.y, 3)
							currentCheckpoint.z = RoundedValue(groundZ > endCoords.z and groundZ or endCoords.z, 3)
						end
					end
				elseif isPropMenuVisible then
					if not objectPreview and not isPropPickedUp then
						local model = category[categoryIndex].model[category[categoryIndex].index]
						local hash = lastValidHash or tonumber(model) or GetHashKey(model)
						local min, max = GetModelDimensions(hash)
						local coord_x = not global_var.propZposLock and RoundedValue(endCoords.x, 3) or nil
						local coord_y = not global_var.propZposLock and RoundedValue(endCoords.y, 3) or nil
						local coord_z = global_var.propZposLock or RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xy_Valid = true
						if global_var.propZposLock then
							coord_x, coord_y = calculateXYAtHeight(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0, cameraRotation.x + 0.0, cameraRotation.y + 0.0, cameraRotation.z + 0.0, coord_z)
						end
						if not coord_x or not coord_y then
							xy_Valid = false
						end
						if (coord_z > -198.99) and (coord_z <= 2698.99) and xy_Valid and not global_var.IsNuiFocused then
							-- Automatic snapping? Not in my plan
							--[[
							local rotX = math.deg(math.atan(surfaceNormal.z / math.sqrt(surfaceNormal.x^2 + surfaceNormal.y^2))) - 90.0
							local rotZ = -math.deg(math.atan2(surfaceNormal.x, surfaceNormal.y))
							globalRot.x, globalRot.y, globalRot.z = RoundedValue(rotX, 3), 0.0, RoundedValue(rotZ, 3) ~= -180.0 and RoundedValue(rotZ, 3) or 0.0
							]]
							objectPreview = createProp(hash, coord_x, coord_y, coord_z, globalRot.x, globalRot.y, globalRot.z, global_var.propColor)
							if objectPreview then
								objectPreview_coords_change = false
								currentObject = {
									index = #currentRace.objects + 1,
									hash = hash,
									handle = objectPreview,
									x = coord_x,
									y = coord_y,
									z = coord_z,
									rotX = globalRot.x,
									rotY = globalRot.y,
									rotZ = globalRot.z,
									color = GetObjectTextureVariation(objectPreview),
									visible = true,
									collision = true,
									dynamic = false
								}
								SetEntityCollision(objectPreview, false, false)
								local _boneCount = GetEntityBoneCount(objectPreview)
								if _boneCount > 0 then
									childPropBoneCount = _boneCount
									childPropBoneIndex = 0
								end
							end
						else
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
					elseif objectPreview and not isPropPickedUp and not objectPreview_coords_change then
						local min, max = GetModelDimensions(GetEntityModel(objectPreview))
						local coord_x = not global_var.propZposLock and RoundedValue(endCoords.x, 3) or nil
						local coord_y = not global_var.propZposLock and RoundedValue(endCoords.y, 3) or nil
						local coord_z = global_var.propZposLock or RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xy_Valid = true
						if global_var.propZposLock then
							coord_x, coord_y = calculateXYAtHeight(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0, cameraRotation.x + 0.0, cameraRotation.y + 0.0, cameraRotation.z + 0.0, coord_z)
						end
						if not coord_x or not coord_y then
							xy_Valid = false
						end
						if (coord_z > -198.99) and (coord_z <= 2698.99) and xy_Valid then
							currentObject.x = coord_x
							currentObject.y = coord_y
							currentObject.z = coord_z
							SetEntityCoordsNoOffset(objectPreview, currentObject.x, currentObject.y, currentObject.z)
						else
							if objectPreview then
								DeleteObject(objectPreview)
								objectPreview = nil
								childPropBoneCount = nil
								childPropBoneIndex = nil
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
								if nuiCallBack ~= "" then
									SendNUIMessage({
										action = 'off'
									})
									SetNuiFocus(false, false)
									nuiCallBack = ""
								end
								if not xy_Valid then
									DisplayCustomMsgs(GetTranslate("object-error"))
								else
									DisplayCustomMsgs(GetTranslate("z-limit"))
								end
							end
						end
					end
				elseif isTemplateMenuVisible then
					if #templatePreview == 0 and template[templateIndex] and not isTemplatePropPickedUp then
						local min, max = GetModelDimensions(template[templateIndex].props[1].hash)
						local coord_z = RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (coord_z > -198.99) and (coord_z <= 2698.99) then
							templatePreview_coords_change = false
							for i = 1, #template[templateIndex].props do
								templatePreview[i] = {}
								local obj = createProp(template[templateIndex].props[i].hash, template[templateIndex].props[i].x, template[templateIndex].props[i].y, template[templateIndex].props[i].z, i ~= 1 and template[templateIndex].props[i].rotX or 0.0, i ~= 1 and template[templateIndex].props[i].rotY or 0.0, i ~= 1 and template[templateIndex].props[i].rotZ or 0.0, template[templateIndex].props[i].color)
								templatePreview[i] = {
									index = #currentRace.objects + i,
									handle = obj,
									hash = template[templateIndex].props[i].hash,
									x = template[templateIndex].props[i].x,
									y = template[templateIndex].props[i].y,
									z = template[templateIndex].props[i].z,
									rotX = 0.0,
									rotY = 0.0,
									rotZ = 0.0,
									color = template[templateIndex].props[i].color,
									visible = template[templateIndex].props[i].visible,
									collision = template[templateIndex].props[i].collision,
									dynamic = template[templateIndex].props[i].dynamic
								}
							end
							for i = 1, #templatePreview do
								SetEntityCollision(templatePreview[i].handle, false, false)
								if i >= 2 then
									AttachEntityToEntity(templatePreview[i].handle, templatePreview[1].handle, 0, GetOffsetFromEntityGivenWorldCoords(templatePreview[1].handle, GetEntityCoords(templatePreview[i].handle)), GetEntityRotation(templatePreview[i].handle, 2), false, false, false, false, 2, true, 0)
								end
							end
							SetEntityCoordsNoOffset(templatePreview[1].handle, RoundedValue(endCoords.x, 3), RoundedValue(endCoords.y, 3), RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3))
							ResetEntityAlpha(templatePreview[1].handle)
							SetEntityDrawOutlineColor(255, 255, 30, 125)
							SetEntityDrawOutlineShader(1)
							SetEntityDrawOutline(templatePreview[1].handle, true)
						end
					elseif #templatePreview > 0 and not isTemplatePropPickedUp and not templatePreview_coords_change then
						local min, max = GetModelDimensions(GetEntityModel(templatePreview[1].handle))
						templatePreview[1].x = RoundedValue(endCoords.x, 3)
						templatePreview[1].y = RoundedValue(endCoords.y, 3)
						templatePreview[1].z = RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (templatePreview[1].z > -198.99) and (templatePreview[1].z <= 2698.99) then
							SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
						else
							if #templatePreview > 0 then
								for i = 1, #templatePreview do
									DeleteObject(templatePreview[i].handle)
								end
								templatePreview = {}
								if nuiCallBack ~= "" then
									SendNUIMessage({
										action = 'off'
									})
									SetNuiFocus(false, false)
									nuiCallBack = ""
								end
								DisplayCustomMsgs(GetTranslate("z-limit"))
							end
						end
					end
				end
				local marker_x = nil
				local marker_y = nil
				local marker_z = nil
				if (not objectPreview_coords_change and not isPropPickedUp) and global_var.propZposLock then
					marker_z = global_var.propZposLock
					marker_x, marker_y = calculateXYAtHeight(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0, cameraRotation.x + 0.0, cameraRotation.y + 0.0, cameraRotation.z + 0.0, marker_z)
				end
				if not marker_x or not marker_y or not marker_z then
					marker_x = endCoords and endCoords.x
					marker_y = endCoords and endCoords.y
					marker_z = endCoords and (groundZ > endCoords.z and groundZ or endCoords.z)
				end
				if marker_x and marker_y and marker_z and not global_var.enableTest then
					DrawMarker(
						25,
						marker_x,
						marker_y,
						marker_z,
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						2.0,
						2.0,
						2.0,
						255,
						255,
						255,
						255,
						false,
						false,
						2,
						nil,
						nil,
						false
					)
				end
			else
				if startingGridVehiclePreview then
					DeleteVehicle(startingGridVehiclePreview)
					startingGridVehiclePreview = nil
					currentstartingGridVehicle = {
						index = nil,
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
					if nuiCallBack ~= "" then
						SendNUIMessage({
							action = 'off'
						})
						SetNuiFocus(false, false)
						nuiCallBack = ""
					end
					DisplayCustomMsgs(GetTranslate("startingGrid-error2"))
				end
				if startingGridVehicleSelect then
					for k, v in pairs(currentRace.startingGrid) do
						if startingGridVehicleSelect == v.handle then
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
					DeleteVehicle(startingGridVehicleSelect)
					isStartingGridVehiclePickedUp = false
					startingGridVehicleSelect = nil
					currentstartingGridVehicle = {
						index = nil,
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
					if nuiCallBack ~= "" then
						SendNUIMessage({
							action = 'off'
						})
						SetNuiFocus(false, false)
						nuiCallBack = ""
					end
					DisplayCustomMsgs(GetTranslate("startingGrid-error2"))
				end
				if checkpointPreview and not checkpointPreview_coords_change then
					checkpointPreview = nil
					currentCheckpoint = {
						index = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil,
						d = nil,
						is_round = nil,
						is_air = nil,
						is_fake = nil,
						is_random = nil,
						randomClass = nil,
						is_transform = nil,
						transform_index = nil,
						is_planeRot = nil,
						plane_rot = nil,
						is_warp = nil
					}
					if nuiCallBack ~= "" then
						SendNUIMessage({
							action = 'off'
						})
						SetNuiFocus(false, false)
						nuiCallBack = ""
					end
					DisplayCustomMsgs(GetTranslate("checkpoint-error"))
				end
				if objectPreview and not objectPreview_coords_change then
					DeleteObject(objectPreview)
					objectPreview = nil
					childPropBoneCount = nil
					childPropBoneIndex = nil
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
					if nuiCallBack ~= "" then
						SendNUIMessage({
							action = 'off'
						})
						SetNuiFocus(false, false)
						nuiCallBack = ""
					end
					DisplayCustomMsgs(GetTranslate("object-error"))
				end
				if #templatePreview > 0 and not templatePreview_coords_change then
					for i = 1, #templatePreview do
						DeleteObject(templatePreview[i].handle)
					end
					templatePreview = {}
					if nuiCallBack ~= "" then
						SendNUIMessage({
							action = 'off'
						})
						SetNuiFocus(false, false)
						nuiCallBack = ""
					end
					DisplayCustomMsgs(GetTranslate("object-error"))
				end
			end

			if isStartingGridMenuVisible then
				for k, v in pairs(currentRace.startingGrid) do
					if v.handle then
						if v.handle ~= startingGridVehicleSelect then
							local min, max = GetModelDimensions(GetEntityModel(v.handle))
							local longestDiameter = math.sqrt((max.x - min.x)^2 + (max.y - min.y)^2 + (max.z - min.z)^2)
							DrawMarker(
								25,
								v.x,
								v.y,
								RoundedValue(GetEntityCoords(v.handle).z + min.z, 3),
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								longestDiameter,
								longestDiameter,
								longestDiameter,
								255,
								0,
								0,
								125,
								false,
								false,
								2,
								nil,
								nil,
								false
							)
						end
					else
						v.handle = createVeh((currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle)) or GetHashKey("bmx"), v.x, v.y, v.z, v.heading)
						ResetEntityAlpha(v.handle)
						SetEntityDrawOutlineColor(255, 255, 255, 125)
						SetEntityDrawOutlineShader(1)
						SetEntityDrawOutline(v.handle, true)
					end
				end
			else
				for k, v in pairs(currentRace.startingGrid) do
					if v.handle then
						DeleteVehicle(v.handle)
						v.handle = nil
					end
				end
			end

			if checkpointPreview and not isCheckpointPickedUp then
				local x = currentCheckpoint.x
				local y = currentCheckpoint.y
				local z = currentCheckpoint.z
				local heading = currentCheckpoint.heading
				local d = currentCheckpoint.d
				local is_round = currentCheckpoint.is_round
				local is_air = currentCheckpoint.is_air
				local is_fake = currentCheckpoint.is_fake
				local is_random = currentCheckpoint.is_random
				local randomClass = currentCheckpoint.randomClass
				local is_transform = currentCheckpoint.is_transform
				local transform_index = currentCheckpoint.transform_index
				local is_planeRot = currentCheckpoint.is_planeRot
				local plane_rot = currentCheckpoint.plane_rot
				local is_warp = currentCheckpoint.is_warp
				DarwRaceCheckpoint(x, y, z, heading, d, is_round, is_air, is_fake, is_random, randomClass, is_transform, transform_index, is_planeRot, plane_rot, is_warp, true, true, nil)
			end

			if global_var.enableTest then
				if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex + 1] then
					local x = currentRace.checkpoints[checkpointIndex + 1].x
					local y = currentRace.checkpoints[checkpointIndex + 1].y
					local z = currentRace.checkpoints[checkpointIndex + 1].z
					local heading = currentRace.checkpoints[checkpointIndex + 1].heading
					local d = currentRace.checkpoints[checkpointIndex + 1].d
					local is_round = currentRace.checkpoints[checkpointIndex + 1].is_round
					local is_air = currentRace.checkpoints[checkpointIndex + 1].is_air
					local is_fake = currentRace.checkpoints[checkpointIndex + 1].is_fake
					local is_random = currentRace.checkpoints[checkpointIndex + 1].is_random
					local randomClass = currentRace.checkpoints[checkpointIndex + 1].randomClass
					local is_transform = currentRace.checkpoints[checkpointIndex + 1].is_transform
					local transform_index = currentRace.checkpoints[checkpointIndex + 1].transform_index
					local is_planeRot = currentRace.checkpoints[checkpointIndex + 1].is_planeRot
					local plane_rot = currentRace.checkpoints[checkpointIndex + 1].plane_rot
					local is_warp = currentRace.checkpoints[checkpointIndex + 1].is_warp
					if not global_var.testBlipHandle then
						global_var.testBlipHandle = createBlip(currentRace.checkpoints[checkpointIndex + 1].x, currentRace.checkpoints[checkpointIndex + 1].y, currentRace.checkpoints[checkpointIndex + 1].z, 0.9, (currentRace.checkpoints[checkpointIndex + 1].is_random or currentRace.checkpoints[checkpointIndex + 1].is_transform) and 570 or 1, (currentRace.checkpoints[checkpointIndex + 1].is_random or currentRace.checkpoints[checkpointIndex + 1].is_transform) and 1 or 5)
					end
					DarwRaceCheckpoint(x, y, z, heading, d, is_round, is_air, is_fake, is_random, randomClass, is_transform, transform_index, is_planeRot, plane_rot, is_warp, true, false, nil, false)
				elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex + 1] then
					local x = currentRace.checkpoints_2[checkpointIndex + 1].x
					local y = currentRace.checkpoints_2[checkpointIndex + 1].y
					local z = currentRace.checkpoints_2[checkpointIndex + 1].z
					local heading = currentRace.checkpoints_2[checkpointIndex + 1].heading
					local d = currentRace.checkpoints_2[checkpointIndex + 1].d
					local is_round = currentRace.checkpoints_2[checkpointIndex + 1].is_round
					local is_air = currentRace.checkpoints_2[checkpointIndex + 1].is_air
					local is_fake = currentRace.checkpoints_2[checkpointIndex + 1].is_fake
					local is_random = currentRace.checkpoints_2[checkpointIndex + 1].is_random
					local randomClass = currentRace.checkpoints_2[checkpointIndex + 1].randomClass
					local is_transform = currentRace.checkpoints_2[checkpointIndex + 1].is_transform
					local transform_index = currentRace.checkpoints_2[checkpointIndex + 1].transform_index
					local is_planeRot = currentRace.checkpoints_2[checkpointIndex + 1].is_planeRot
					local plane_rot = currentRace.checkpoints_2[checkpointIndex + 1].plane_rot
					local is_warp = currentRace.checkpoints_2[checkpointIndex + 1].is_warp
					if not global_var.testBlipHandle then
						global_var.testBlipHandle = createBlip(currentRace.checkpoints_2[checkpointIndex + 1].x, currentRace.checkpoints_2[checkpointIndex + 1].y, currentRace.checkpoints_2[checkpointIndex + 1].z, 0.9, (currentRace.checkpoints_2[checkpointIndex + 1].is_random or currentRace.checkpoints_2[checkpointIndex + 1].is_transform) and 570 or 1, (currentRace.checkpoints_2[checkpointIndex + 1].is_random or currentRace.checkpoints_2[checkpointIndex + 1].is_transform) and 1 or 5)
					end
					DarwRaceCheckpoint(x, y, z, heading, d, is_round, is_air, is_fake, is_random, randomClass, is_transform, transform_index, is_planeRot, plane_rot, is_warp, true, false, nil, true)
				end
			end

			if #currentRace.checkpoints > 0 and isCheckpointMenuVisible then
				checkpointDrawNumber = 0
				checkpointTextDrawNumber = 0
				for i = 1, #currentRace.checkpoints do
					local highlight = isCheckpointPickedUp and checkpointIndex == i
					local x = currentRace.checkpoints[i].x
					local y = currentRace.checkpoints[i].y
					local z = currentRace.checkpoints[i].z
					local heading = currentRace.checkpoints[i].heading
					local d = currentRace.checkpoints[i].d
					local is_round = currentRace.checkpoints[i].is_round
					local is_air = currentRace.checkpoints[i].is_air
					local is_fake = currentRace.checkpoints[i].is_fake
					local is_random = currentRace.checkpoints[i].is_random
					local randomClass = currentRace.checkpoints[i].randomClass
					local is_transform = currentRace.checkpoints[i].is_transform
					local transform_index = currentRace.checkpoints[i].transform_index
					local is_planeRot = currentRace.checkpoints[i].is_planeRot
					local plane_rot = currentRace.checkpoints[i].plane_rot
					local is_warp = currentRace.checkpoints[i].is_warp
					DarwRaceCheckpoint(x, y, z, heading, d, is_round, is_air, is_fake, is_random, randomClass, is_transform, transform_index, is_planeRot, plane_rot, is_warp, false, global_var.isPrimaryCheckpointItems and highlight, currentRace.checkpoints[i].index, false)

					if currentRace.checkpoints_2[i] then
						local highlight_2 = isCheckpointPickedUp and checkpointIndex == i
						local x_2 = currentRace.checkpoints_2[i].x
						local y_2 = currentRace.checkpoints_2[i].y
						local z_2 = currentRace.checkpoints_2[i].z
						local heading_2 = currentRace.checkpoints_2[i].heading
						local d_2 = currentRace.checkpoints_2[i].d
						local is_round_2 = currentRace.checkpoints_2[i].is_round
						local is_air_2 = currentRace.checkpoints_2[i].is_air
						local is_fake_2 = currentRace.checkpoints_2[i].is_fake
						local is_random_2 = currentRace.checkpoints_2[i].is_random
						local randomClass_2 = currentRace.checkpoints_2[i].randomClass
						local is_transform_2 = currentRace.checkpoints_2[i].is_transform
						local transform_index_2 = currentRace.checkpoints_2[i].transform_index
						local is_planeRot_2 = currentRace.checkpoints_2[i].is_planeRot
						local plane_rot_2 = currentRace.checkpoints_2[i].plane_rot
						local is_warp_2 = currentRace.checkpoints_2[i].is_warp
						DarwRaceCheckpoint(x_2, y_2, z_2, heading_2, d_2, is_round_2, is_air_2, is_fake_2, is_random_2, randomClass_2, is_transform_2, transform_index_2, is_planeRot_2, plane_rot_2, is_warp_2, false, not global_var.isPrimaryCheckpointItems and highlight_2, currentRace.checkpoints_2[i].index, true)
					end
				end
			end

			if #currentRace.fixtures > 0 and isFixtureRemoverMenuVisible then
				local highlight = {}
				for k, v in pairs(currentRace.fixtures) do
					highlight[v.hash] = true
				end
				local pool = GetGamePool('CObject')
				for i = 1, #pool do
					local fixture = pool[i]
					local found = false
					for k, v in pairs(currentRace.objects) do
						if fixture == v.handle then
							found = true
							break
						end
					end
					if not found and fixture and DoesEntityExist(fixture) then
						local hash = GetEntityModel(fixture)
						if highlight[hash] then
							DrawFixtureLines(fixture, hash)
						end
					end
				end
			end
		end

		Citizen.Wait(0)
	end
end)