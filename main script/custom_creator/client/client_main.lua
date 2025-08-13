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
	handle = nil,
	x = nil,
	y = nil,
	z = nil,
	heading = nil
}

markerDrawCount = 0
textDrawCount = 0
isCheckpointMenuVisible = false
isCheckpointPickedUp = false
checkpointIndex = 0
checkpointPreview = nil
checkpointPreview_coords_change = false
isCheckpointPositionRelativeEnable = false
currentCheckpoint = {
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
isTemplatePositionRelativeEnable = false
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
hud_colors = {{255, 255, 255}, {240, 240, 240}, {155, 155, 155}, {205, 205, 205}, {224, 50, 50}, {240, 153, 153}, {93, 182, 229}, {174, 219, 242}, {240, 200, 80}, {254, 235, 169}, {255, 133, 85}, {255, 194, 170}, {114, 204, 114}, {185, 230, 185}, {132, 102, 226}, {192, 179, 239}, {203, 54, 148}, {235, 36, 39}, {194, 80, 80}, {156, 110, 175}, {255, 123, 196}, {247, 159, 123}, {178, 144, 132}, {141, 206, 167}, {113, 169, 175}, {211, 209, 231}, {144, 127, 153}, {106, 196, 191}, {214, 196, 153}, {234, 142, 80}, {152, 203, 234}, {178, 98, 135}, {144, 142, 122}, {166, 117, 94}, {175, 168, 168}, {232, 142, 155}, {187, 214, 91}, {123, 196, 255}, {171, 60, 230}, {206, 169, 13}, {71, 99, 173}, {42, 166, 185}, {186, 157, 125}, {201, 225, 255}, {240, 240, 150}, {237, 140, 161}, {249, 138, 138}, {252, 239, 166}, {240, 240, 240}, {159, 201, 166}, {140, 140, 140}, {240, 160, 0}, {140, 140, 140}, {140, 140, 140}, {100, 112, 127}, {120, 120, 75}, {152, 76, 93}, {124, 69, 69}, {180, 130, 97}, {150, 153, 161}, {214, 181, 99}, {166, 221, 190}, {29, 100, 153}, {214, 116, 15}, {135, 125, 142}, {229, 119, 185}, {252, 239, 166}, {45, 110, 185}, {93, 182, 229}, {194, 80, 80}, {154, 154, 154}, {194, 80, 80}, {252, 115, 201}, {252, 177, 49}, {109, 247, 204}, {241, 101, 34}, {214, 189, 97}, {234, 153, 28}, {146, 200, 62}, {234, 153, 28}, {66, 89, 148}, {164, 76, 242}, {101, 180, 212}, {171, 237, 171}, {255, 163, 87}, {235, 239, 30}, {255, 149, 14}, {246, 60, 161}, {210, 166, 249}, {82, 38, 121}, {127, 81, 43}, {240, 240, 240}, {234, 153, 28}, {225, 140, 8}, {48, 255, 255}, {48, 255, 0}, {176, 80, 0}, {53, 166, 224}, {162, 79, 157}, {104, 192, 141}, {29, 100, 153}, {234, 153, 28}, {240, 160, 1}, {247, 159, 123}, {226, 134, 187}, {239, 238, 151}, {113, 169, 175}, {160, 140, 193}, {141, 206, 167}, {181, 214, 234}, {178, 144, 132}, {0, 132, 114}, {216, 85, 117}, {30, 100, 152}, {43, 181, 117}, {233, 141, 79}, {137, 210, 215}, {134, 125, 141}, {109, 34, 33}, {255, 0, 0}, {255, 255, 0}, {0, 255, 0}, {0, 255, 255}, {0, 0, 255}, {255, 0, 255}, {38, 136, 234}, {154, 178, 54}, {93, 107, 45}, {206, 169, 13}, {0, 151, 151}}
creatorVehicle = {}

Citizen.CreateThread(function()
	while true do
		ExtendWorldBoundaryForPlayer(-100000000000000000000000.0, -100000000000000000000000.0, 100000000000000000000000.0)
		ExtendWorldBoundaryForPlayer(100000000000000000000000.0, 100000000000000000000000.0, 100000000000000000000000.0)
		Citizen.Wait(0)
	end
end)

function OpenCreator()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	sendCreatorPreview()
	SetWeatherTypeNowPersist("CLEAR")
	hourIndex = 13
	minuteIndex = 1
	secondIndex = 1
	NetworkOverrideClockTime(hours[hourIndex], minutes[minuteIndex], seconds[secondIndex])
	global_var.timeChecked = true
	joinCreatorPoint = pos
	joinCreatorHeading = GetEntityHeading(ped)
	joinCreatorVehicle = GetVehiclePedIsIn(ped, false)
	if joinCreatorVehicle ~= 0 then
		creatorVehicle = GetVehicleProperties(joinCreatorVehicle) or creatorVehicle or {}
		currentRace.test_vehicle = creatorVehicle.model ~= 0 and creatorVehicle.model or ""
		SetEntityCoordsNoOffset(ped, joinCreatorPoint)
		SetEntityVisible(joinCreatorVehicle, false)
		SetEntityCollision(joinCreatorVehicle, false, false)
		FreezeEntityPosition(joinCreatorVehicle, true)
	end
	global_var.lock = true
	TriggerServerCallback("custom_creator:server:get_list", function(result, _template, _myServerId)
		myServerId = _myServerId
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
		if RageUI.QuitIndex then
			if #races_data.category[races_data.index].data >= 1 then
				if RageUI.QuitIndex < (10 + #races_data.category[races_data.index].data) then
					RageUI.CurrentMenu.Index = RageUI.QuitIndex
				else
					RageUI.CurrentMenu.Index = 10 + #races_data.category[races_data.index].data
				end
			else
				RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index
			end
		end
		global_var.lock = false
	end)
	SetBlipAlpha(GetMainPlayerBlipId(), 0)
	global_var.creatorBlipHandle = AddBlipForCoord(joinCreatorPoint.x, joinCreatorPoint.y, joinCreatorPoint.z)
	SetBlipSprite(global_var.creatorBlipHandle, 398)
	SetBlipPriority(global_var.creatorBlipHandle, 11)
	SetLocalPlayerAsGhost(true)
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
	DeleteWaypoint()
	OpenCreatorMenu()
	CreateCreatorFreeCam(ped)
	LoopGetCameraFramerateMoveFix()
	InitScrollTextOnBlimp()
	ClearAreaLeaveVehicleHealth(joinCreatorPoint.x + 0.0, joinCreatorPoint.y + 0.0, joinCreatorPoint.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
	Citizen.CreateThread(function()
		while global_var.enableCreator do
			ped = PlayerPedId()
			pos = GetEntityCoords(ped)
			global_var.IsNuiFocused = IsNuiFocused()
			global_var.IsPauseMenuActive = IsPauseMenuActive()
			global_var.IsPlayerSwitchInProgress = IsPlayerSwitchInProgress()

			if (global_var.IsPauseMenuActive or global_var.IsPlayerSwitchInProgress or (IsWarningMessageActive() and tonumber(GetWarningMessageTitleHash()) == 1246147334)) and not global_var.TempClosed and not global_var.enableTest then
				global_var.TempClosed = true
				RageUI.CloseAll()
			elseif not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress and not (IsWarningMessageActive() and tonumber(GetWarningMessageTitleHash()) == 1246147334) and global_var.TempClosed and not global_var.enableTest then
				global_var.TempClosed = false
				OpenCreatorMenu()
			end

			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 26, true)
			DisableControlAction(0, 36, true)
			DisableControlAction(0, 37, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
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
				MainMenu.Title, MainMenu.Subtitle = GetTranslate("MainMenu-Title"), string.upper(GetTranslate("MainMenu-Subtitle"))
				RaceDetailSubMenu.Subtitle = string.upper(GetTranslate("RaceDetailSubMenu-Subtitle"))
				PlacementSubMenu.Subtitle = string.upper(GetTranslate("PlacementSubMenu-Subtitle"))
				PlacementSubMenu_StartingGrid.Subtitle = string.upper(GetTranslate("PlacementSubMenu_StartingGrid-Subtitle"))
				PlacementSubMenu_Checkpoints.Subtitle = string.upper(GetTranslate("PlacementSubMenu_Checkpoints-Subtitle"))
				PlacementSubMenu_Props.Subtitle = string.upper(GetTranslate("PlacementSubMenu_Props-Subtitle"))
				PlacementSubMenu_Templates.Subtitle = string.upper(GetTranslate("PlacementSubMenu_Templates-Subtitle"))
				PlacementSubMenu_MoveAll.Subtitle = string.upper(GetTranslate("PlacementSubMenu_MoveAll-Subtitle"))
				PlacementSubMenu_FixtureRemover.Subtitle = string.upper(GetTranslate("PlacementSubMenu_FixtureRemover-Subtitle"))
				PlacementSubMenu_Firework.Subtitle = string.upper(GetTranslate("PlacementSubMenu_Firework-Subtitle"))
				MultiplayerSubMenu.Subtitle = string.upper(GetTranslate("MultiplayerSubMenu-Subtitle"))
				MultiplayerSubMenu_Invite.Subtitle = string.upper(GetTranslate("MultiplayerSubMenu_Invite-Subtitle"))
				WeatherSubMenu.Subtitle = string.upper(GetTranslate("WeatherSubMenu-Subtitle"))
				TimeSubMenu.Subtitle = string.upper(GetTranslate("TimeSubMenu-Subtitle"))
				MiscSubMenu.Subtitle = string.upper(GetTranslate("MiscSubMenu-Subtitle"))
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
				end

				for k, v in pairs(arenaProp) do
					if not v.touching and DoesEntityExist(v.handle) and IsEntityTouchingEntity(vehicle ~= 0 and vehicle or ped, v.handle) then
						v.touching = true
						Citizen.CreateThread(function()
							if DoesEntityExist(v.handle) then
								SetEnableArenaPropPhysics(v.handle, true)
							end
							Citizen.Wait(5000)
							if DoesEntityExist(v.handle) then
								SetEnableArenaPropPhysics(v.handle, false)
							end
							v.touching = false
						end)
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
					if not v.playing and DoesEntityExist(v.handle) and (#(pos - GetEntityCoords(v.handle)) <= 50.0) then
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

				local checkPointTouched = false
				local checkpoint = global_var.respawnData and global_var.respawnData.checkpointIndex_draw and currentRace.checkpoints[global_var.respawnData.checkpointIndex_draw] and tableDeepCopy(currentRace.checkpoints[global_var.respawnData.checkpointIndex_draw])
				local checkpoint_2 = global_var.respawnData and global_var.respawnData.checkpointIndex_draw and currentRace.checkpoints_2[global_var.respawnData.checkpointIndex_draw] and tableDeepCopy(currentRace.checkpoints_2[global_var.respawnData.checkpointIndex_draw])
				local checkpoint_next = global_var.respawnData and global_var.respawnData.checkpointIndex_draw and currentRace.checkpoints[global_var.respawnData.checkpointIndex_draw + 1] and tableDeepCopy(currentRace.checkpoints[global_var.respawnData.checkpointIndex_draw + 1])
				local checkpoint_2_next = global_var.respawnData and global_var.respawnData.checkpointIndex_draw and currentRace.checkpoints_2[global_var.respawnData.checkpointIndex_draw + 1] and tableDeepCopy(currentRace.checkpoints_2[global_var.respawnData.checkpointIndex_draw + 1])

				local checkpoint_coords = nil
				local diameter = nil
				local checkpoint_radius = nil
				local _checkpoint_coords = nil
				if checkpoint and global_var.tipsRendered then
					checkpoint_coords = checkpoint and vector3(checkpoint.x, checkpoint.y, checkpoint.z)
					diameter = ((checkpoint.is_air and (4.5 * checkpoint.d)) or ((checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) and (2.25 * checkpoint.d)) or checkpoint.d) * 10
					checkpoint_radius = diameter / 2
					_checkpoint_coords = checkpoint_coords
					if checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp then
						if not checkpoint.is_air then
							_checkpoint_coords = checkpoint_coords + vector3(0, 0, checkpoint_radius)
						end
					else
						_checkpoint_coords = checkpoint_coords + vector3(0, 0, checkpoint_radius)
					end
				end

				local checkpoint_2_coords = nil
				local diameter_2 = nil
				local checkpoint_2_radius = nil
				local _checkpoint_2_coords = nil
				if checkpoint_2 and global_var.tipsRendered then
					checkpoint_2_coords = vector3(checkpoint_2.x, checkpoint_2.y, checkpoint_2.z)
					diameter_2 = ((checkpoint_2.is_air and (4.5 * checkpoint_2.d)) or ((checkpoint_2.is_round or checkpoint_2.is_random or checkpoint_2.is_transform or checkpoint_2.is_planeRot or checkpoint_2.is_warp) and (2.25 * checkpoint_2.d)) or checkpoint_2.d) * 10
					checkpoint_2_radius = diameter_2 / 2
					_checkpoint_2_coords = checkpoint_2_coords
					if checkpoint_2.is_round or checkpoint_2.is_random or checkpoint_2.is_transform or checkpoint_2.is_planeRot or checkpoint_2.is_warp then
						if not checkpoint_2.is_air then
							_checkpoint_2_coords = checkpoint_2_coords + vector3(0, 0, checkpoint_2_radius)
						end
					else
						_checkpoint_2_coords = checkpoint_2_coords + vector3(0, 0, checkpoint_2_radius)
					end
				end

				if checkpoint_coords and diameter and checkpoint_radius and _checkpoint_coords and ((#(pos - checkpoint_coords) <= checkpoint_radius) or (#(pos - _checkpoint_coords) <= (checkpoint_radius * 1.5))) and not global_var.isRespawning and not global_var.isTransforming then
					checkPointTouched = true
					if checkpoint.is_transform or checkpoint.is_random then
						local r, g, b = nil, nil, nil
						if vehicle ~= 0 then
							r, g, b = GetVehicleColor(vehicle)
						end
						PlayTransformEffectAndSound(ped, r, g, b)
						TransformVehicle(checkpoint.is_random and -2 or checkpoint.transform_index, checkpoint, checkpoint_next)
					elseif checkpoint.is_warp and checkpoint_next then
						local r, g, b = nil, nil, nil
						if vehicle ~= 0 then
							r, g, b = GetVehicleColor(vehicle)
						end
						PlayTransformEffectAndSound(ped, r, g, b)
						WarpVehicle(checkpoint_next)
					elseif checkpoint.is_planeRot then
						if vehicle ~= 0 then
							local rot = GetEntityRotation(vehicle)
							if checkpoint.plane_rot == 0 then
								if rot.x > 45 or rot.x < -45 or rot.y > 45 or rot.y < -45 then
									SlowVehicle(vehicle)
								end
							elseif checkpoint.plane_rot == 1 then
								if rot.y < 40 then
									SlowVehicle(vehicle)
								end
							elseif checkpoint.plane_rot == 2 then
								if (rot.x < 135 and rot.x > -135) or rot.y > 45 or rot.y < -45 then
									SlowVehicle(vehicle)
								end
							elseif checkpoint.plane_rot == 3 then
								if rot.y > -40 then
									SlowVehicle(vehicle)
								end
							end
						end
					end
				elseif checkpoint_2_coords and diameter_2 and checkpoint_2_radius and _checkpoint_2_coords and ((#(pos - checkpoint_2_coords) <= checkpoint_2_radius) or (#(pos - _checkpoint_2_coords) <= (checkpoint_2_radius * 1.5))) and not global_var.isRespawning and not global_var.isTransforming then
					checkPointTouched = true
					if checkpoint_2.is_transform or checkpoint_2.is_random then
						local r, g, b = nil, nil, nil
						if vehicle ~= 0 then
							r, g, b = GetVehicleColor(vehicle)
						end
						PlayTransformEffectAndSound(ped, r, g, b)
						TransformVehicle(checkpoint_2.is_random and -2 or checkpoint_2.transform_index, checkpoint_2, checkpoint_2_next)
					elseif checkpoint_2.is_warp and (checkpoint_2_next or checkpoint_next) then
						local r, g, b = nil, nil, nil
						if vehicle ~= 0 then
							r, g, b = GetVehicleColor(vehicle)
						end
						PlayTransformEffectAndSound(ped, r, g, b)
						WarpVehicle(checkpoint_2_next or checkpoint_next)
					end
				end

				if checkPointTouched then
					global_var.respawnData.checkpointIndex_draw = global_var.respawnData.checkpointIndex_draw + 1
					PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
					updateBlips("test")
				end

				local checkpoint_draw = global_var.respawnData and global_var.respawnData.checkpointIndex_draw and currentRace.checkpoints[global_var.respawnData.checkpointIndex_draw] and tableDeepCopy(currentRace.checkpoints[global_var.respawnData.checkpointIndex_draw])
				if checkpoint_draw and global_var.tipsRendered then
					DrawCheckpointForCreator(checkpoint_draw.x, checkpoint_draw.y, checkpoint_draw.z, checkpoint_draw.heading, checkpoint_draw.d, checkpoint_draw.is_round, checkpoint_draw.is_air, checkpoint_draw.is_fake, checkpoint_draw.is_random, checkpoint_draw.randomClass, checkpoint_draw.is_transform, checkpoint_draw.transform_index, checkpoint_draw.is_planeRot, checkpoint_draw.plane_rot, checkpoint_draw.is_warp, true, false, nil, false)
				end

				local checkpoint_2_draw = global_var.respawnData and global_var.respawnData.checkpointIndex_draw and currentRace.checkpoints_2[global_var.respawnData.checkpointIndex_draw] and tableDeepCopy(currentRace.checkpoints_2[global_var.respawnData.checkpointIndex_draw])
				if checkpoint_2_draw and global_var.tipsRendered then
					DrawCheckpointForCreator(checkpoint_2_draw.x, checkpoint_2_draw.y, checkpoint_2_draw.z, checkpoint_2_draw.heading, checkpoint_2_draw.d, checkpoint_2_draw.is_round, checkpoint_2_draw.is_air, checkpoint_2_draw.is_fake, checkpoint_2_draw.is_random, checkpoint_2_draw.randomClass, checkpoint_2_draw.is_transform, checkpoint_2_draw.transform_index, checkpoint_2_draw.is_planeRot, checkpoint_2_draw.plane_rot, checkpoint_2_draw.is_warp, true, false, nil, true)
				end

				if (IsControlJustReleased(0, 75) or IsDisabledControlJustReleased(0, 75)) and not global_var.isRespawning and not global_var.isTransforming and not checkPointTouched then
					global_var.isRespawning = true
					TestCurrentCheckpoint(global_var.respawnData)
				elseif global_var.autoRespawn and not global_var.isRespawning and not global_var.isTransforming and not IsPedInAnyVehicle(ped) and not checkPointTouched then
					global_var.isRespawning = true
					TestCurrentCheckpoint(global_var.respawnData)
				end

				if IsControlJustReleased(0, 48) and not global_var.isRespawning and not global_var.isTransforming and global_var.tipsRendered and not checkPointTouched then
					global_var.enableTest = false
					if global_var.testVehicleHandle then
						DeleteEntity(global_var.testVehicleHandle)
						global_var.testVehicleHandle = nil
					end
					if global_var.testBlipHandle then
						RemoveBlip(global_var.testBlipHandle)
						global_var.testBlipHandle = nil
					end
					if global_var.testBlipHandle_2 then
						RemoveBlip(global_var.testBlipHandle_2)
						global_var.testBlipHandle_2 = nil
					end
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
					SetBlipPriority(global_var.creatorBlipHandle, 11)
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
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
					startingGridVehicleSelect = nil
					currentstartingGridVehicle = {
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
				if isCheckpointPickedUp then
					isCheckpointPickedUp = false
					currentCheckpoint = {
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
				if checkpointPreview then
					checkpointPreview = nil
					currentCheckpoint = {
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
				if objectPreview then
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
					SetEntityCoordsNoOffset(ped, 0.0, 60.0, 1050.0)
					SetEntityHeading(ped, -180.0)
					NetworkOverrideClockTime(0, 0, 0)
					if global_var.creatorBlipHandle and DoesBlipExist(global_var.creatorBlipHandle) then
						SetBlipCoords(global_var.creatorBlipHandle, 0.0, 60.0, 1050.0)
					end
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

			if RageUI.Visible(RaceDetailSubMenu) or RageUI.Visible(PlacementSubMenu) or RageUI.Visible(MultiplayerSubMenu) or RageUI.Visible(MultiplayerSubMenu_Invite) or RageUI.Visible(WeatherSubMenu) or RageUI.Visible(TimeSubMenu) or RageUI.Visible(MiscSubMenu) then
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
				local fix_pos = IsControlPressed(0, 352) and 5.0 or 1.0 -- LEFT SHIFT or Xbox Controller L3
				if global_var.IsPauseMenuActive and IsWaypointActive() then
					local waypoint = GetBlipInfoIdCoord(GetFirstBlipInfoId(GetWaypointBlipEnumId()))
					cameraPosition = vector3(waypoint.x + 0.0, waypoint.y + 0.0, cameraPosition.z + 0.0)
					DeleteWaypoint()
				end
				if IsControlPressed(0, 32) then -- W or Xbox Controller
					cameraPosition = cameraPosition + GetCameraForwardVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if IsControlPressed(0, 33) then -- S or Xbox Controller
					cameraPosition = cameraPosition - GetCameraForwardVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if IsControlPressed(0, 34) then -- A or Xbox Controller
					cameraPosition = cameraPosition - GetCameraRightVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if IsControlPressed(0, 35) then -- D or Xbox Controller
					cameraPosition = cameraPosition + GetCameraRightVector(camera) * speed.cam_pos.value[speed.cam_pos.index][2] * fix_pos * cameraFramerateMoveFix
				end
				if cameraPosition.z + 0.0 > 3000 then
					cameraPosition = vector3(cameraPosition.x + 0.0, cameraPosition.y + 0.0, 3000.0)
				elseif cameraPosition.z + 0.0 < -200 then
					cameraPosition = vector3(cameraPosition.x + 0.0, cameraPosition.y + 0.0, -200.0)
				end
				local mouseX = GetControlNormal(0, 1) -- Mouse or Xbox Controller
				local mouseY = GetControlNormal(0, 2) -- Mouse or Xbox Controller
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
				if isPropMenuVisible and not isPropPickedUp then
					if IsControlPressed(0, 252) then -- X or LT
						if not objectPreview then
							global_var.propZposLock = RoundedValue(cameraPosition.z + (((cameraRotation.x < 0) and -25.0) or ((cameraRotation.x >= 0) and 25.0)), 3)
							if (global_var.propZposLock <= -198.99) or (global_var.propZposLock > 2698.99) then
								global_var.propZposLock = nil
							end
						elseif objectPreview and not objectPreview_coords_change and currentObject.z then
							local newZposLock = RoundedValue((global_var.propZposLock or currentObject.z) - speed.prop_offset.value[speed.prop_offset.index][2], 3)
							if newZposLock > -198.99 then
								global_var.propZposLock = newZposLock
								cameraPosition = vector3(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0 - speed.prop_offset.value[speed.prop_offset.index][2])
							end
						end
					end
					if IsControlPressed(0, 253) then -- C or RT
						if not objectPreview then
							global_var.propZposLock = RoundedValue(cameraPosition.z + (((cameraRotation.x < 0) and -25.0) or ((cameraRotation.x >= 0) and 25.0)), 3)
							if (global_var.propZposLock <= -198.99) or (global_var.propZposLock > 2698.99) then
								global_var.propZposLock = nil
							end
						elseif objectPreview and not objectPreview_coords_change and currentObject.z then
							local newZposLock = RoundedValue((global_var.propZposLock or currentObject.z) + speed.prop_offset.value[speed.prop_offset.index][2], 3)
							if newZposLock <= 2698.99 then
								global_var.propZposLock = newZposLock
								cameraPosition = vector3(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0 + speed.prop_offset.value[speed.prop_offset.index][2])
							end
						end
					end
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
					SetEntityCompletelyDisableCollision(ped, false, false)
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

			if IsControlJustReleased(0, 203) and not global_var.IsNuiFocused and not lockSession then
				if isStartingGridMenuVisible then
					local found = false
					for k, v in pairs(currentRace.startingGrid) do
						if entity == v.handle then
							DeleteVehicle(startingGridVehiclePreview)
							startingGridVehiclePreview = nil
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
							if inSession then
								modificationCount.startingGrid = modificationCount.startingGrid + 1
								TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
							end
							ResetEntityAlpha(startingGridVehicleSelect)
							SetEntityDrawOutlineColor(255, 255, 255, 125)
							SetEntityDrawOutlineShader(1)
							SetEntityDrawOutline(startingGridVehicleSelect, true)
							isStartingGridVehiclePickedUp = false
							startingGridVehicleSelect = nil
							currentstartingGridVehicle = {
								handle = nil,
								x = nil,
								y = nil,
								z = nil,
								heading = nil
							}
						end
					end
				elseif isCheckpointMenuVisible then
					if not checkpointPreview and isCheckpointPickedUp then
						isCheckpointPickedUp = false
						currentCheckpoint = {
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
						elseif entity and (entity ~= objectPreview) and (IsEntityAnObject(entity) or IsEntityAVehicle(entity)) then
							local rotation = GetEntityRotation(entity, 2)
							globalRot.x = RoundedValue(rotation.x, 3)
							globalRot.y = RoundedValue(rotation.y, 3)
							globalRot.z = RoundedValue(rotation.z, 3)
							global_var.propColor = GetObjectTextureVariation(entity)
							if objectPreview then
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
							end
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

			local propZposLock = global_var.propZposLock
			if endCoords or (propZposLock and isPropMenuVisible) then
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
							local deleteIndex = 0
							for k, v in pairs(currentRace.startingGrid) do
								if startingGridVehicleSelect == v.handle then
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
							DeleteVehicle(startingGridVehicleSelect)
							isStartingGridVehiclePickedUp = false
							startingGridVehicleSelect = nil
							currentstartingGridVehicle = {
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
						local coord_x = not propZposLock and RoundedValue(endCoords.x, 3) or nil
						local coord_y = not propZposLock and RoundedValue(endCoords.y, 3) or nil
						local coord_z = propZposLock or RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xy_Valid = true
						if propZposLock then
							coord_x, coord_y = calculateXYAtHeight(cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0, cameraRotation.x + 0.0, cameraRotation.y + 0.0, cameraRotation.z + 0.0, coord_z)
						end
						if not coord_x or not coord_y then
							xy_Valid = false
						end
						if (coord_z > -198.99) and (coord_z <= 2698.99) and xy_Valid and not global_var.IsNuiFocused then
							objectPreview = createProp(hash, coord_x, coord_y, coord_z, globalRot.x, globalRot.y, globalRot.z, global_var.propColor)
							if objectPreview then
								objectPreview_coords_change = false
								uniqueId = uniqueId + 1
								currentObject = {
									uniqueId = myServerId .. "-" .. uniqueId,
									modificationCount = 0,
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
						end
					elseif objectPreview and not isPropPickedUp and not objectPreview_coords_change then
						local min, max = GetModelDimensions(GetEntityModel(objectPreview))
						local coord_x = not propZposLock and RoundedValue(endCoords.x, 3) or nil
						local coord_y = not propZposLock and RoundedValue(endCoords.y, 3) or nil
						local coord_z = propZposLock or RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xy_Valid = true
						if propZposLock then
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
							local firstObjectValid = false
							for i = 1, #template[templateIndex].props do
								local obj = createProp(template[templateIndex].props[i].hash, template[templateIndex].props[i].x, template[templateIndex].props[i].y, template[templateIndex].props[i].z, firstObjectValid and template[templateIndex].props[i].rotX or 0.0, firstObjectValid and template[templateIndex].props[i].rotY or 0.0, firstObjectValid and template[templateIndex].props[i].rotZ or 0.0, template[templateIndex].props[i].color)
								if obj then
									uniqueId = uniqueId + 1
									templatePreview[#templatePreview + 1] = {
										uniqueId = myServerId .. "-" .. uniqueId,
										modificationCount = 0,
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
									if not firstObjectValid then
										firstObjectValid = true
									end
								end
							end
							if #templatePreview >= 2 then
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
							else
								for i = 1, #templatePreview do
									DeleteObject(templatePreview[i].handle)
								end
								templatePreview = {}
							end
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
				if (not objectPreview_coords_change and not isPropPickedUp) and propZposLock then
					marker_z = propZposLock
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
					local deleteIndex = 0
					for k, v in pairs(currentRace.startingGrid) do
						if startingGridVehicleSelect == v.handle then
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
					DeleteVehicle(startingGridVehicleSelect)
					isStartingGridVehiclePickedUp = false
					startingGridVehicleSelect = nil
					currentstartingGridVehicle = {
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
						if v.handle ~= startingGridVehicleSelect and DoesEntityExist(v.handle) then
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
				DrawCheckpointForCreator(x, y, z, heading, d, is_round, is_air, is_fake, is_random, randomClass, is_transform, transform_index, is_planeRot, plane_rot, is_warp, true, true, nil)
			end

			markerDrawCount = 0
			textDrawCount = 0
			if inSession then
				local time = GetGameTimer()
				local myLocalId = PlayerId()
				for i = 1, #multiplayer.inSessionPlayers do
					local id = GetPlayerFromServerId(multiplayer.inSessionPlayers[i].playerId)
					local creator = (id ~= -1) and (id ~= myLocalId) and GetPlayerPed(id)
					if (id ~= -1) and (id ~= myLocalId) and creator and (ped ~= creator) then
						if not multiplayer.inSessionPlayers[i].color then
							multiplayer.inSessionPlayers[i].color = hud_colors[math.random(#hud_colors)]
						end
						local color = multiplayer.inSessionPlayers[i].color
						local creator_coords = GetEntityCoords(creator)
						local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(creator_coords.x, creator_coords.y, creator_coords.z)
						if onScreen and IsEntityPositionFrozen(creator) and not IsEntityVisible(creator) then
							markerDrawCount = markerDrawCount + 1
							DrawMarker(
								28,
								creator_coords.x,
								creator_coords.y,
								creator_coords.z,
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								0.5,
								0.5,
								0.5,
								color[1],
								color[2],
								color[3],
								125,
								false,
								false,
								2,
								nil,
								nil,
								false
							)
							if (#(creator_coords - pos) > 3.6) and (#(creator_coords - pos) < 36.0) then
								textDrawCount = textDrawCount + 1
								DrawFloatingTextForCreator(creator_coords.x, creator_coords.y, creator_coords.z, 2.0, GetPlayerName(id), false, color)
							end
						end
						if not multiplayer.inSessionPlayers[i].blip and IsEntityPositionFrozen(creator) and not IsEntityVisible(creator) then
							multiplayer.inSessionPlayers[i].blip = AddBlipForCoord(creator_coords.x, creator_coords.y, creator_coords.z)
							SetBlipSprite(multiplayer.inSessionPlayers[i].blip, 398)
							SetBlipPriority(multiplayer.inSessionPlayers[i].blip, 10)
						else
							if multiplayer.inSessionPlayers[i].blip and DoesBlipExist(multiplayer.inSessionPlayers[i].blip) then
								if IsEntityPositionFrozen(creator) and not IsEntityVisible(creator) then
									SetBlipCoords(multiplayer.inSessionPlayers[i].blip, creator_coords.x, creator_coords.y, creator_coords.z)
								else
									RemoveBlip(multiplayer.inSessionPlayers[i].blip)
									multiplayer.inSessionPlayers[i].blip = nil
								end
							end
						end
						local vehicle_preview = multiplayer.inSessionPlayers[i].startingGridVehiclePreview
						if vehicle_preview and DoesEntityExist(vehicle_preview) then
							local vehicle_preview_coords = GetEntityCoords(vehicle_preview)
							DrawLine(creator_coords.x, creator_coords.y, creator_coords.z, vehicle_preview_coords.x, vehicle_preview_coords.y, vehicle_preview_coords.z, color[1], color[2], color[3], 255)
						end
						if multiplayer.inSessionPlayers[i].receiveTime and ((time - multiplayer.inSessionPlayers[i].receiveTime) > 300) then
							multiplayer.inSessionPlayers[i].checkpointPreview = nil
						end
						local checkpoint_preview = multiplayer.inSessionPlayers[i].checkpointPreview
						if checkpoint_preview then
							DrawCheckpointForCreator(checkpoint_preview.x, checkpoint_preview.y, checkpoint_preview.z, checkpoint_preview.heading, checkpoint_preview.d, checkpoint_preview.is_round, checkpoint_preview.is_air, checkpoint_preview.is_fake, checkpoint_preview.is_random, checkpoint_preview.randomClass, checkpoint_preview.is_transform, checkpoint_preview.transform_index, checkpoint_preview.is_planeRot, checkpoint_preview.plane_rot, checkpoint_preview.is_warp, false, false, nil)
							DrawLine(creator_coords.x, creator_coords.y, creator_coords.z, checkpoint_preview.x, checkpoint_preview.y, checkpoint_preview.z, color[1], color[2], color[3], 255)
						end
						local object_preview = multiplayer.inSessionPlayers[i].objectPreview
						if object_preview and DoesEntityExist(object_preview) then
							local object_preview_coords = GetEntityCoords(object_preview)
							DrawLine(creator_coords.x, creator_coords.y, creator_coords.z, object_preview_coords.x, object_preview_coords.y, object_preview_coords.z, color[1], color[2], color[3], 255)
						end
					else
						if multiplayer.inSessionPlayers[i].blip and DoesBlipExist(multiplayer.inSessionPlayers[i].blip) then
							RemoveBlip(multiplayer.inSessionPlayers[i].blip)
							multiplayer.inSessionPlayers[i].blip = nil
						end
					end
				end
			end

			if #currentRace.checkpoints > 0 and isCheckpointMenuVisible and not global_var.enableTest then
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
					DrawCheckpointForCreator(x, y, z, heading, d, is_round, is_air, is_fake, is_random, randomClass, is_transform, transform_index, is_planeRot, plane_rot, is_warp, false, global_var.isPrimaryCheckpointItems and highlight, i, false)

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
						DrawCheckpointForCreator(x_2, y_2, z_2, heading_2, d_2, is_round_2, is_air_2, is_fake_2, is_random_2, randomClass_2, is_transform_2, transform_index_2, is_planeRot_2, plane_rot_2, is_warp_2, false, not global_var.isPrimaryCheckpointItems and highlight_2, i, true)
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
			Citizen.Wait(0)
		end
	end)
end

local isCreatorLocked = false
RegisterCommand('open_creator', function()
	if isCreatorLocked then return end
	global_var.IsNuiFocused = IsNuiFocused()
	global_var.IsPauseMenuActive = IsPauseMenuActive()
	global_var.IsPlayerSwitchInProgress = IsPlayerSwitchInProgress()
	if not global_var.enableCreator and not global_var.IsNuiFocused and not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress and not isInRace and not isAllModelChecked then
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
	elseif not global_var.enableCreator and not global_var.IsNuiFocused and not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress and not isInRace and isAllModelChecked then
		TriggerEvent('custom_creator:load')
		global_var.enableCreator = true
		OpenCreator()
	end
end)

exports('lockCreator', function()
	isCreatorLocked = true
end)

exports('unlockCreator', function()
	isCreatorLocked = false
end)