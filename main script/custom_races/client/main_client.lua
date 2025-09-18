StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
StatSetInt(`MP0_STEALTH_ABILITY`, 100, true)
StatSetInt(`MP0_FLYING_ABILITY`, 100, true)
StatSetInt(`MP0_WHEELIE_ABILITY`, 100, true)
StatSetInt(`MP0_LUNG_CAPACITY`, 100, true)
StatSetInt(`MP0_STRENGTH`, 100, true)
StatSetInt(`MP0_STAMINA`, 100, true)

inRoom = false
inVehicleUI = false
status = "freemode"
joinRacePoint = nil
joinRaceHeading = nil
joinRaceVehicle = 0
timeServerSide = {
	["syncDrivers"] = nil,
	["syncPlayers"] = nil,
}
dataOutdated = false
enableXboxController = false
local roomServerId = nil
local cooldownTime = nil
local isCreatorEnable = false
local needRefreshTag = false
local lastVehicle = nil
local disableTraffic = false
local togglePositionUI = false
local totalPlayersInRace = 0
local currentUiPage = 1
local laps = 0
local weatherAndTime = {}
local isLoadingObjects = false
local loadedObjects = {}
local arenaProp = {}
local fireworkObjects = {}
local track = {}
local roomData = {}
local raceVehicle = {}
local hasCheated = false
local transformedModel = ""
local transformIsParachute = false
local transformIsBeast = false
local canFoot = true
local lastspectatePlayerId = nil
local pedToSpectate = nil
local spectatingPlayerIndex = 0
local totalCheckpointsTouched = 0
local actualCheckpoint = 0
local actualCheckpoint_draw = nil
local actualCheckpoint_pair_draw = nil
local actualCheckpoint_spectate_draw = nil
local actualCheckpoint_spectate_pair_draw = nil
local nextCheckpoint = 0
local lastCheckpointPair = 0 -- 0 = primary / 1 = secondary
local finishLine = false
local actualLap = 0
local startLapTime = 0
local actualLapTime = 0
local totalTimeStart = 0
local totalRaceTime = 0
local nextBlip = nil
local actualBlip = nil
local nextBlip_pair = nil
local actualBlip_pair = nil
local nextBlip_spectate = nil
local actualBlip_spectate = nil
local nextBlip_spectate_pair = nil
local actualBlip_spectate_pair = nil
local gridPositionIndex = 1
local totalDriversNubmer = nil
local hasShowRespawnUI = false
local isRespawning = false
local hasRespawned = false
local respawnTime = 0
local respawnTimeStart = 0
local isRespawningInProgress = false
local isTransformingInProgress = false
local isTeleportingInProgress = false
local cam = nil
local isOverClouds = false
local drivers = {}
local hudData = {}
local syncData = {
	fps = 999,
	actualLap = 1,
	actualCheckpoint = 1,
	vehicle = "",
	lastlap = 0,
	bestlap = 0,
	totalRaceTime = 0,
	totalCheckpointsTouched = 0,
	lastCheckpointPair = 0
}

local vehicle_weapons = {
	2971687502,
	1945616459,
	3450622333,
	3530961278,
	1259576109,
	4026335563,
	1566990507,
	1186503822,
	2669318622,
	3473446624,
	4171469727,
	1741783703,
	2211086889
}

local speedUpObjects = {
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

local slowDownObjects = {
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

local arenaObjects = {
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

function JoinRace()
	status = "ready"
	totalCheckpointsTouched = 0
	actualCheckpoint = 1
	nextCheckpoint = 2
	lastCheckpointPair = 0
	finishLine = false
	actualLap = 1
	isRespawningInProgress = true
	RespawnVehicle(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, track.gridPositions[gridPositionIndex].heading, false)
	isRespawningInProgress = false
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)
	actualBlip = CreateBlipForRace(actualCheckpoint, 1, false, false)
	if track.checkpoints[actualCheckpoint].hasPair then
		actualBlip_pair = CreateBlipForRace(actualCheckpoint, 1, false, true)
	end
	nextBlip = CreateBlipForRace(nextCheckpoint, 1, true, false)
	if track.checkpoints[nextCheckpoint].hasPair then
		nextBlip_pair = CreateBlipForRace(nextCheckpoint, 1, true, true)
	end
	allVehModels = GetAllVehicleModels()
	ClearAreaLeaveVehicleHealth(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, 100000000000000000000000.0, false, false, false, false, false)
end

function StartRace()
	status = "racing"
	if track.mode == "gta" then
		GiveWeapons()
	end
	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "nui_msg:showRaceHud",
			showCurrentLap = laps > 1
		})
		totalTimeStart = GetGameTimer()
		startLapTime = totalTimeStart
		while status == "racing" do
			actualLapTime = GetGameTimer() - startLapTime
			totalRaceTime = GetGameTimer() - totalTimeStart
			-- Hide street and vehicle information in the lower right corner
			-- https://docs.fivem.net/natives/?_0x6806C51AD12B83B8
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			if not IsNuiFocused() and not IsPauseMenuActive() and not IsControlPressed(0, 244) --[[M menu]] then
				if IsControlJustReleased(0, 48) --[[Z]] then
					if togglePositionUI and ((currentUiPage * 20) < totalPlayersInRace) then
						currentUiPage = currentUiPage + 1
					else
						togglePositionUI = not togglePositionUI
						currentUiPage = 1
					end
				end
			else
				togglePositionUI = false
			end
			if IsDisabledControlJustPressed(0, 200) --[[Esc]] then
				ExecuteCommand("quit_race")
			end
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			-- Adjust the knock level for bmx and motorcycle
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
				local model = GetEntityModel(vehicle)
				local class = GetVehicleClassFromName(model)
				if class == 8 or class == 13 then
					-- Allow flipping the bird while on a bike to taunt
					if track.mode ~= "gta" then
						EnableControlAction(0, 68, true)
					end
				else
					if track.mode ~= "gta" then
						DisableControlAction(0, 68, true)
					end
					if not IsThisModelAPlane(model) and not IsThisModelAHeli(model) and not (model == GetHashKey("submersible")) and not (model == GetHashKey("submersible2")) and not (model == GetHashKey("avisa")) then
						UseVehicleCamStuntSettingsThisUpdate()
					end
				end
			else
				if track.mode == "no_collision" and DoesEntityExist(lastVehicle) then
					SetEntityCollision(lastVehicle, false, false)
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
			if track.mode ~= "gta" then
				canFoot = false
				SetEntityInvincible(ped, true)
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
				SetPlayerCanDoDriveBy(PlayerId(), true)
				DisableControlAction(0, 75, true) -- F
				if vehicle ~= 0 and DoesVehicleHaveWeapons(vehicle) == 1 then
					for i = 1, #vehicle_weapons do
						DisableVehicleWeapon(true, vehicle_weapons[i], vehicle, ped)
					end
				end
				DisableControlAction(0, 69, true)
				DisableControlAction(0, 70, true)
				DisableControlAction(0, 92, true)
				DisableControlAction(0, 114, true)
				DisableControlAction(0, 121, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 257, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 264, true)
				DisableControlAction(0, 331, true)
			else
				canFoot = true
				SetEntityInvincible(ped, false)
				SetPlayerCanDoDriveBy(PlayerId(), true)
				EnableControlAction(0, 75, true) -- F
			end
			if IsControlPressed(0, 75) or IsDisabledControlPressed(0, 75) then
				if hasRespawned and not isRespawningInProgress and not transformIsParachute and not transformIsBeast and not IsPedInAnyVehicle(ped) and not canFoot then
					ResetAndHideRespawnUI()
				end
				-- Press F to respawn
				StartRespawn()
			elseif not transformIsParachute and not transformIsBeast and not IsPedInAnyVehicle(ped) and not canFoot then
				if hasRespawned and not isRespawningInProgress then
					ResetAndHideRespawnUI()
				end
				-- Automatically respawn after falling off a vehicle
				StartRespawn()
			else
				ResetAndHideRespawnUI()
			end
			local checkPointTouched = false
			local playerCoords = GetEntityCoords(ped)
			local checkpointCoords = vector3(track.checkpoints[actualCheckpoint].x, track.checkpoints[actualCheckpoint].y, track.checkpoints[actualCheckpoint].z)
			local checkpointCoords_pair = vector3(track.checkpoints[actualCheckpoint].pair_x, track.checkpoints[actualCheckpoint].pair_y, track.checkpoints[actualCheckpoint].pair_z)
			local checkpointRadius = track.checkpoints[actualCheckpoint].d / 2
			local checkpointRadius_pair = track.checkpoints[actualCheckpoint].pair_d / 2
			local _checkpointCoords = checkpointCoords
			local _checkpointCoords_pair = checkpointCoords_pair
			-- The actual rendered primary checkpoint coords
			if finishLine then
				if track.checkpoints[actualCheckpoint].isRound then
					if not track.checkpoints[actualCheckpoint].isLarge then
						_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
					end
				else
					_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
				end
			else
				if track.checkpoints[actualCheckpoint].isRound or track.checkpoints[actualCheckpoint].warp or track.checkpoints[actualCheckpoint].planerot or track.checkpoints[actualCheckpoint].transform ~= -1 then
					if not track.checkpoints[actualCheckpoint].isLarge then
						_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
					end
				else
					_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
				end
			end
			-- The actual rendered secondary checkpoint coords
			if track.checkpoints[actualCheckpoint].hasPair then
				if finishLine then
					if track.checkpoints[actualCheckpoint].pair_isRound then
						if not track.checkpoints[actualCheckpoint].pair_isLarge then
							_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
						end
					else
						_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
					end
				else
					if track.checkpoints[actualCheckpoint].pair_isRound or track.checkpoints[actualCheckpoint].pair_warp or track.checkpoints[actualCheckpoint].pair_planerot or track.checkpoints[actualCheckpoint].pair_transform ~= -1 then
						if not track.checkpoints[actualCheckpoint].pair_isLarge then
							_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
						end
					else
						_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
					end
				end
			end
			-- When ped (not vehicle) touch the checkpoint
			if ((#(playerCoords - checkpointCoords) <= (checkpointRadius * 2.0)) or (#(playerCoords - _checkpointCoords) <= (checkpointRadius * 1.5))) and not isRespawningInProgress and not isTransformingInProgress and not isTeleportingInProgress then
				checkPointTouched = true
				lastCheckpointPair = 0
				syncData.lastCheckpointPair = lastCheckpointPair
				if track.checkpoints[actualCheckpoint].transform ~= -1 and not finishLine then
					local r, g, b = nil, nil, nil
					if vehicle ~= 0 then
						r, g, b = GetVehicleColor(vehicle)
					end
					TriggerServerEvent("custom_races:server:syncParticleFx", r, g, b)
					PlayTransformEffectAndSound(nil, r, g, b)
					TransformVehicle(track.checkpoints[actualCheckpoint].transform, actualCheckpoint)
				elseif track.checkpoints[actualCheckpoint].warp and not finishLine then
					local r, g, b = nil, nil, nil
					if vehicle ~= 0 then
						r, g, b = GetVehicleColor(vehicle)
					end
					TriggerServerEvent("custom_races:server:syncParticleFx", r, g, b)
					PlayTransformEffectAndSound(nil, r, g, b)
					WarpVehicle(false, actualCheckpoint)
				elseif track.checkpoints[actualCheckpoint].planerot and not finishLine then
					if vehicle ~= 0 then
						local planerot = track.checkpoints[actualCheckpoint].planerot
						local rot = GetEntityRotation(vehicle)
						if planerot == "up" then
							if rot.x > 45 or rot.x < -45 or rot.y > 45 or rot.y < -45 then
								SlowVehicle(vehicle)
							end
						elseif planerot == "left" then
							if rot.y > -40 then
								SlowVehicle(vehicle)
							end
						elseif planerot == "right" then
							if rot.y < 40 then
								SlowVehicle(vehicle)
							end
						elseif planerot == "down" then
							if (rot.x < 135 and rot.x > -135) or rot.y > 45 or rot.y < -45 then
								SlowVehicle(vehicle)
							end
						end
					end
				end
			elseif track.checkpoints[actualCheckpoint].hasPair and ((#(playerCoords - checkpointCoords_pair) <= (checkpointRadius_pair * 2.0)) or (#(playerCoords - _checkpointCoords_pair) <= (checkpointRadius_pair * 1.5))) and not isRespawningInProgress and not isTransformingInProgress and not isTeleportingInProgress then
				checkPointTouched = true
				lastCheckpointPair = 1
				syncData.lastCheckpointPair = lastCheckpointPair
				if track.checkpoints[actualCheckpoint].pair_transform ~= -1 and not finishLine then
					local r, g, b = nil, nil, nil
					if vehicle ~= 0 then
						r, g, b = GetVehicleColor(vehicle)
					end
					TriggerServerEvent("custom_races:server:syncParticleFx", r, g, b)
					PlayTransformEffectAndSound(nil, r, g, b)
					TransformVehicle(track.checkpoints[actualCheckpoint].pair_transform, actualCheckpoint)
				elseif track.checkpoints[actualCheckpoint].pair_warp and not finishLine then
					local r, g, b = nil, nil, nil
					if vehicle ~= 0 then
						r, g, b = GetVehicleColor(vehicle)
					end
					TriggerServerEvent("custom_races:server:syncParticleFx", r, g, b)
					PlayTransformEffectAndSound(nil, r, g, b)
					WarpVehicle(true, actualCheckpoint)
				end
			end
			if checkPointTouched then
				totalCheckpointsTouched = totalCheckpointsTouched + 1
				syncData.totalCheckpointsTouched = totalCheckpointsTouched
				DeleteCheckpoint(actualCheckpoint_draw)
				DeleteCheckpoint(actualCheckpoint_pair_draw)
				actualCheckpoint_draw = nil
				actualCheckpoint_pair_draw = nil
				RemoveBlip(actualBlip)
				RemoveBlip(nextBlip)
				RemoveBlip(actualBlip_pair)
				RemoveBlip(nextBlip_pair)
				if actualCheckpoint == #track.checkpoints then
					PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
					syncData.lastlap = actualLapTime
					if (syncData.bestlap == 0) or (syncData.bestlap > actualLapTime) then
						syncData.bestlap = actualLapTime
					end
					syncData.totalRaceTime = totalRaceTime
					if actualLap < laps then
						actualCheckpoint = 1
						nextCheckpoint = 2
						actualLap = actualLap + 1
						startLapTime = GetGameTimer()
						syncData.actualCheckpoint = actualCheckpoint
						syncData.actualLap = actualLap
						hudData.timeLap = nil
						actualLapTime = 0
					else
						FinishRace("yeah")
						break
					end
				else
					PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
					actualCheckpoint = actualCheckpoint + 1
					nextCheckpoint = nextCheckpoint + 1
					syncData.actualCheckpoint = actualCheckpoint
				end
				-- Create a blip for the actual checkpoint
				if actualCheckpoint == #track.checkpoints then
					if actualLap < laps then
						actualBlip = CreateBlipForRace(actualCheckpoint, 58, false, false, true)
						if track.checkpoints[actualCheckpoint].hasPair then
							actualBlip_pair = CreateBlipForRace(actualCheckpoint, 58, false, true, true)
						end
					else
						actualBlip = CreateBlipForRace(actualCheckpoint, 38, false, false, true)
						if track.checkpoints[actualCheckpoint].hasPair then
							actualBlip_pair = CreateBlipForRace(actualCheckpoint, 38, false, true, true)
						end
						finishLine = true
					end
				else
					actualBlip = CreateBlipForRace(actualCheckpoint, 1, false, false)
					if track.checkpoints[actualCheckpoint].hasPair then
						actualBlip_pair = CreateBlipForRace(actualCheckpoint, 1, false, true)
					end
				end
				-- Create a blip for the next checkpoint
				if nextCheckpoint > #track.checkpoints then
					if actualLap < laps then
						nextBlip = CreateBlipForRace(1, 1, true, false)
						if track.checkpoints[1].hasPair then
							nextBlip_pair = CreateBlipForRace(1, 1, true, true)
						end
					else
						RemoveBlip(nextBlip)
						RemoveBlip(nextBlip_pair)
					end
				elseif nextCheckpoint == #track.checkpoints then
					if actualLap < laps then
						nextBlip = CreateBlipForRace(nextCheckpoint, 58, true, false, true)
						if track.checkpoints[nextCheckpoint].hasPair then
							nextBlip_pair = CreateBlipForRace(nextCheckpoint, 58, true, true, true)
						end
					else
						nextBlip = CreateBlipForRace(nextCheckpoint, 38, true, false, true)
						if track.checkpoints[nextCheckpoint].hasPair then
							nextBlip_pair = CreateBlipForRace(nextCheckpoint, 38, true, true, true)
						end
					end
				else
					nextBlip = CreateBlipForRace(nextCheckpoint, 1, true, false)
					if track.checkpoints[nextCheckpoint].hasPair then
						nextBlip_pair = CreateBlipForRace(nextCheckpoint, 1, true, true)
					end
				end
			end
			-- Draw the HUD
			DrawBottomHUD()
			-- Draw the primary checkpoint
			DrawCheckpointForRace(finishLine, actualCheckpoint, false)
			-- Draw the secondary checkpoint
			DrawCheckpointForRace(finishLine, actualCheckpoint, true)
			Citizen.Wait(0)
		end
		DeleteCheckpoint(actualCheckpoint_draw)
		DeleteCheckpoint(actualCheckpoint_pair_draw)
		actualCheckpoint_draw = nil
		actualCheckpoint_pair_draw = nil
		RemoveBlip(actualBlip)
		RemoveBlip(nextBlip)
		RemoveBlip(actualBlip_pair)
		RemoveBlip(nextBlip_pair)
	end)
	Citizen.CreateThread(function()
		local isPositionUIVisible = false
		local playerTopPosition = nil
		local MsgItem = nil
		local firstLoad = true
		local startTime = GetGameTimer()
		while status == "racing" do
			Citizen.Wait(500)
			local _drivers = drivers
			local driversInfo = UpdateDriversInfo(_drivers)
			totalPlayersInRace = Count(_drivers)
			if togglePositionUI then
				local frontpos = {}
				local _labels = {
					label_name = GetTranslate("racing-ui-label_name"),
					label_fps = "FPS",
					label_distance = GetTranslate("racing-ui-label_distance"),
					label_lap = laps > 1 and GetTranslate("racing-ui-label_lap"),
					label_checkpoint = GetTranslate("racing-ui-label_checkpoint"),
					label_vehicle = GetTranslate("racing-ui-label_vehicle"),
					label_lastlap = laps > 1 and GetTranslate("racing-ui-label_lastlap"),
					label_bestlap = laps > 1 and GetTranslate("racing-ui-label_bestlap"),
					label_totaltime = GetTranslate("racing-ui-label_totaltime")
				}
				for k, v in pairs(_drivers) do
					local _position = GetPlayerPosition(driversInfo, v.playerId)
					local _name = v.playerName
					local _fps = v.fps
					local _distance = nil
					local _lap = v.actualLap
					local _checkpoint = v.actualCheckpoint
					local _vehicle = (v.vehicle == "parachute" and GetTranslate("transform-parachute")) or (v.vehicle == "beast" and GetTranslate("transform-beast")) or (GetLabelText(v.vehicle) ~= "NULL" and GetLabelText(v.vehicle):gsub("µ", " ")) or GetTranslate("unknown-vehicle")
					local _lastlap = v.lastlap ~= 0 and GetTimeAsString(v.lastlap) or "-"
					local _bestlap = v.bestlap ~= 0 and GetTimeAsString(v.bestlap) or "-"
					local _totaltime = v.hasFinished and GetTimeAsString(v.totalRaceTime) or "-"
					if v.dnf then
						table.insert(frontpos, {
							position = _position,
							name = _name,
							fps = "DNF",
							distance = "DNF",
							lap = "DNF",
							checkpoint = "DNF",
							vehicle = "DNF",
							lastlap = "DNF",
							bestlap = "DNF",
							totaltime = "DNF"
						})
					elseif v.hasFinished and not v.dnf then
						table.insert(frontpos, {
							position = _position,
							name = _name,
							fps = "-",
							distance = "-",
							lap = "-",
							checkpoint = "-",
							vehicle = _vehicle,
							lastlap = _lastlap,
							bestlap = _bestlap,
							totaltime = _totaltime
						})
					else
						_distance = RoundedValue(#(v.currentCoords - vector3(v.lastCheckpointPair == 1 and track.checkpoints[v.actualCheckpoint].hasPair and track.checkpoints[v.actualCheckpoint].pair_x or track.checkpoints[v.actualCheckpoint].x, v.lastCheckpointPair == 1 and track.checkpoints[v.actualCheckpoint].hasPair and track.checkpoints[v.actualCheckpoint].pair_y or track.checkpoints[v.actualCheckpoint].y, v.lastCheckpointPair == 1 and track.checkpoints[v.actualCheckpoint].hasPair and track.checkpoints[v.actualCheckpoint].pair_z or track.checkpoints[v.actualCheckpoint].z)), 1) .. "m"
						table.insert(frontpos, {
							position = _position,
							name = _name,
							fps = _fps,
							distance = _distance,
							lap = _lap,
							checkpoint = _checkpoint,
							vehicle = _vehicle,
							lastlap = _lastlap,
							bestlap = _bestlap,
							totaltime = _totaltime
						})
					end
				end
				table.sort(frontpos, function(a, b)
					return a.position < b.position
				end)
				if (currentUiPage > 1) and (((currentUiPage - 1) * 20 + 1) > totalPlayersInRace) then
					currentUiPage = currentUiPage - 1
				end
				local startIdx = (currentUiPage - 1) * 20 + 1
				local endIdx = math.min(startIdx + 20 - 1, totalPlayersInRace)
				local frontpos_show = {}
				for i = startIdx, endIdx do
					table.insert(frontpos_show, frontpos[i])
				end
				SendNUIMessage({
					frontpos = frontpos_show,
					visible = not isPositionUIVisible,
					labels = _labels
				})
				isPositionUIVisible = true
			else
				if isPositionUIVisible then
					SendNUIMessage({
						action = "nui_msg:hidePositionUI"
					})
					isPositionUIVisible = false
				end
			end
			if firstLoad then
				playerTopPosition = driversInfo[1].playerId
				firstLoad = false
			end
			if (GetGameTimer() - startTime) >= 5000 then
				if totalPlayersInRace > 1 and (playerTopPosition ~= driversInfo[1].playerId) and not driversInfo[1].hasFinished then
					playerTopPosition = driversInfo[1].playerId
					local message = string.format(GetTranslate("racing-info-1st"), driversInfo[1].playerName)
					MsgItem = DisplayCustomMsgs(message, true, MsgItem)
				end
			end
		end
		if isPositionUIVisible then
			SendNUIMessage({
				action = "nui_msg:hidePositionUI"
			})
			isPositionUIVisible = false
		end
	end)
end

function UpdateDriversInfo(driversToSort)
	local sortedDrivers = {}
	for _, driver in pairs(driversToSort) do
		local index = driver.actualCheckpoint
		local cpTouchPair = driver.lastCheckpointPair == 1 and track.checkpoints[index].hasPair
		local playerCoords = driver.finishCoords or driver.currentCoords
		local cpCoords = cpTouchPair and vector3(track.checkpoints[index].pair_x, track.checkpoints[index].pair_y, track.checkpoints[index].pair_z) or vector3(track.checkpoints[index].x, track.checkpoints[index].y, track.checkpoints[index].z)
		driver.dist = #(playerCoords - cpCoords)
		table.insert(sortedDrivers, driver)
	end
	table.sort(sortedDrivers, function(a, b)
		if not a.dnf and not b.dnf then
			if not a.hasFinished and not b.hasFinished then
				if a.totalCheckpointsTouched == b.totalCheckpointsTouched then
					return a.dist < b.dist
				else
					return a.totalCheckpointsTouched > b.totalCheckpointsTouched
				end
			end
			if a.hasFinished and b.hasFinished then
				return a.totalRaceTime < b.totalRaceTime
			end
			if a.hasFinished ~= b.hasFinished then
				return a.hasFinished
			end
		end
		if a.dnf and b.dnf then
			if a.totalCheckpointsTouched == b.totalCheckpointsTouched then
				return a.dist < b.dist
			else
				return a.totalCheckpointsTouched > b.totalCheckpointsTouched
			end
		end
		if a.dnf ~= b.dnf then
			return not a.dnf
		end
	end)
	return sortedDrivers
end

function GetPlayerPosition(_driversInfo, playerId)
	for position, driver in ipairs(_driversInfo) do
		if driver.playerId == tonumber(playerId) then
			return position
		end
	end
	return #track.gridPositions + 1
end

function DrawBottomHUD()
	-- Current lap number
	if not hudData.actualLap or hudData.actualLap ~= actualLap then
		SendNUIMessage({
			laps = actualLap .. "/" .. laps
		})
		hudData.actualLap = actualLap
	end
	-- Current ranking
	local _drivers = drivers
	local driversInfo = UpdateDriversInfo(_drivers)
	local position = GetPlayerPosition(driversInfo, GetPlayerServerId(PlayerId()))
	if not hudData.position or hudData.position ~= position or totalDriversNubmer ~= Count(_drivers) then
		SendNUIMessage({
			position = position .. '</span><span style="font-size: 4vh;margin-left: 9px;">/ ' .. Count(_drivers)
		})
		hudData.position = position
		totalDriversNubmer = Count(_drivers)
	end
	-- Current checkpoint
	if not hudData.checkpoints or hudData.checkpoints ~= actualCheckpoint then
		SendNUIMessage({
			checkpoints = actualCheckpoint .. "/" .. #track.checkpoints
		})
		hudData.checkpoints = actualCheckpoint
	end
	-- Current lap time
	if (not hudData.timeLap or actualLapTime - hudData.timeLap >= 1000) and laps > 1 then
		local minutes = math.floor(actualLapTime / 60000)
		local seconds = math.floor(actualLapTime / 1000 - minutes * 60)
		if minutes <= 9 then minutes = "0" .. minutes end
		if seconds <= 9 then seconds = "0" .. seconds end
		SendNUIMessage({
			timeLap = minutes .. ":" .. seconds
		})
		hudData.timeLap = actualLapTime
	end
	-- Current total time
	if not hudData.timeTotal or totalRaceTime - hudData.timeTotal >= 1000 then
		local minutes = math.floor(totalRaceTime / 60000)
		local seconds = math.floor(totalRaceTime / 1000 - minutes * 60)
		if minutes <= 9 then minutes = "0" .. minutes end
		if seconds <= 9 then seconds = "0" .. seconds end
		SendNUIMessage({
			timeTotal = minutes .. ":" .. seconds
		})
		hudData.timeTotal = totalRaceTime
	end
end

function CreateMarkerWithParam(marerkType, x, y, z, rx, ry, rz, w, l, h, r, g, b, a, faceCamera)
	-- https://docs.fivem.net/natives/?_0x28477EC23D892089
	DrawMarker(
		marerkType,
		x,
		y,
		z,
		0.0,
		0.0,
		0.0,
		rx,
		ry,
		rz,
		w,
		l,
		h,
		r,
		g,
		b,
		a,
		false,
		faceCamera or false,
		2,
		nil,
		nil,
		false
	)
end

function DrawCheckpointForRace(isFinishLine, index, pair)
	if pair and not track.checkpoints[index].hasPair then return end
	local x = nil
	local y = nil
	local z = nil
	local heading = nil
	local isRound = nil
	local isLarge = nil
	local transform = nil
	local warp = nil
	local planerot = nil
	local diameter = nil
	local updateZ = 0.0
	--local shiftX = 0.0
	--local shiftY = 0.0
	--local shiftZ = 0.0
	--local rotFix = 0.0
	if pair then
		x = track.checkpoints[index].pair_x
		y = track.checkpoints[index].pair_y
		z = track.checkpoints[index].pair_z
		heading = track.checkpoints[index].pair_heading
		isRound = track.checkpoints[index].pair_isRound
		isLarge = track.checkpoints[index].pair_isLarge
		transform = track.checkpoints[index].pair_transform
		warp = track.checkpoints[index].pair_warp
		planerot = track.checkpoints[index].pair_planerot
		diameter = track.checkpoints[index].pair_d
		--shiftX = track.checkpoints[index].pair_shiftX
		--shiftY = track.checkpoints[index].pair_shiftY
		--shiftZ = track.checkpoints[index].pair_shiftZ
		--rotFix = track.checkpoints[index].pair_rotFix
		if transform == -1 and not warp and not planerot and not isFinishLine then
			local markers = {17, 18, 19}
			local checkpoint_type = isRound and 17 or markers[math.random(#markers)]
			local checkpoint_z = isRound and (isLarge and 0.0 or diameter/2) or diameter/2
			if status == "racing" and actualCheckpoint_pair_draw == nil then
				actualCheckpoint_pair_draw = CreateCheckpoint(
					checkpoint_type,
					x,
					y,
					z + checkpoint_z,
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_x or track.checkpoints[index + 1].x)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_x or track.checkpoints[1].x),
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_y or track.checkpoints[index + 1].y)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_y or track.checkpoints[1].y),
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_z or track.checkpoints[index + 1].z)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_z or track.checkpoints[1].z),
					diameter/2, 62, 182, 245, 125, 0
				)
			elseif status == "spectating" and actualCheckpoint_spectate_pair_draw == nil then
				actualCheckpoint_spectate_pair_draw = CreateCheckpoint(
					checkpoint_type,
					x,
					y,
					z + checkpoint_z,
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_x or track.checkpoints[index + 1].x)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_x or track.checkpoints[1].x),
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_y or track.checkpoints[index + 1].y)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_y or track.checkpoints[1].y),
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_z or track.checkpoints[index + 1].z)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_z or track.checkpoints[1].z),
					diameter/2, 62, 182, 245, 125, 0
				)
			end
		end
	else
		x = track.checkpoints[index].x
		y = track.checkpoints[index].y
		z = track.checkpoints[index].z
		heading = track.checkpoints[index].heading
		isRound = track.checkpoints[index].isRound
		isLarge = track.checkpoints[index].isLarge
		transform = track.checkpoints[index].transform
		warp = track.checkpoints[index].warp
		planerot = track.checkpoints[index].planerot
		diameter = track.checkpoints[index].d
		--shiftX = track.checkpoints[index].shiftX
		--shiftY = track.checkpoints[index].shiftY
		--shiftZ = track.checkpoints[index].shiftZ
		--rotFix = track.checkpoints[index].rotFix
		if transform == -1 and not warp and not planerot and not isFinishLine then
			local markers = {17, 18, 19}
			local checkpoint_type = isRound and 17 or markers[math.random(#markers)]
			local checkpoint_z = isRound and (isLarge and 0.0 or diameter/2) or diameter/2
			if status == "racing" and actualCheckpoint_draw == nil then
				actualCheckpoint_draw = CreateCheckpoint(
					checkpoint_type,
					x,
					y,
					z + checkpoint_z,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].x or track.checkpoints[1].x,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].y or track.checkpoints[1].y,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].z or track.checkpoints[1].z,
					diameter/2, 62, 182, 245, 125, 0
				)
			elseif status == "spectating" and actualCheckpoint_spectate_draw == nil then
				actualCheckpoint_spectate_draw = CreateCheckpoint(
					checkpoint_type,
					x,
					y,
					z + checkpoint_z,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].x or track.checkpoints[1].x,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].y or track.checkpoints[1].y,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].z or track.checkpoints[1].z,
					diameter/2, 62, 182, 245, 125, 0
				)
			end
		end
	end
	if isLarge then
		updateZ = 0.0
	else
		updateZ = diameter/2
	end
	if isFinishLine then
		if isRound then
			CreateMarkerWithParam(5, x, y, z + updateZ, 0.0, 0.0, 0.0, diameter, diameter, diameter, 62, 182, 245, 125, true)
			CreateMarkerWithParam(6, x, y, z + updateZ, 0.0, 0.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125, true)
		else
			CreateMarkerWithParam(4, x, y, z + diameter/2, 0.0, 0.0, 0.0, diameter/2, diameter/2, diameter/2, 62, 182, 245, 125, true)
			CreateMarkerWithParam(1, x, y, z, 0.0, 0.0, 0.0, diameter, diameter, diameter/2, 254, 235, 169, 30, true)
		end
	else
		if transform ~= -1 then
			local vehicleHash = nil
			local vehicleClass = nil
			local marker = 32
			if transform ~= -2 then
				vehicleHash = track.transformVehicles[transform + 1]
				vehicleClass = GetVehicleClassFromName(vehicleHash)
			end
			-- https://docs.fivem.net/docs/game-references/markers/
			if vehicleHash == -422877666 then
				marker = 40
			elseif vehicleHash == -731262150 then
				marker = 31
			elseif vehicleClass == 0
			or vehicleClass == 1
			or vehicleClass == 2
			or vehicleClass == 3
			or vehicleClass == 4
			or vehicleClass == 5
			or vehicleClass == 6
			or vehicleClass == 7
			or vehicleClass == 9
			or vehicleClass == 10
			or vehicleClass == 11
			or vehicleClass == 12
			or vehicleClass == 17
			or vehicleClass == 18
			or vehicleClass == 22
			then
				marker = 36
			elseif vehicleClass == 8 then
				marker = 37
			elseif vehicleClass == 13 then
				marker = 38
			elseif vehicleClass == 14 then
				marker = 35
			elseif vehicleClass == 15 then
				marker = 34
			elseif vehicleClass == 16 then
				marker = 33
			elseif vehicleClass == 20 then
				marker = 39
			elseif vehicleClass == 19 then
				if vehicleHash == GetHashKey("thruster") then
					marker = 41
				else
					marker = 36
				end
			elseif vehicleClass == 21 then
			end
			CreateMarkerWithParam(marker, x, y, z + updateZ, 0.0, 0.0, heading, diameter/2, diameter/2, diameter/2, 62, 182, 245, 125)
			CreateMarkerWithParam(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 255, 50, 50, 125)
		elseif planerot then
			local r, g, b = 62, 182, 245
			local ped = PlayerPedId()
			local rot = GetEntityRotation(GetVehiclePedIsIn(ped, false))
			if planerot == "up" then
				if rot.x > 45 or rot.x < -45 or rot.y > 45 or rot.y < -45 then
					r, g, b = 255, 50, 50
				end
				CreateMarkerWithParam(7, x, y, z + updateZ, 0.0, 0.0, 180 + heading, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			elseif planerot == "left" then
				if rot.y > -40 then
					r, g, b = 255, 50, 50
				end
				CreateMarkerWithParam(7, x, y, z + updateZ, heading, -90.0, 180.0, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			elseif planerot == "right" then
				if rot.y < 40 then
					r, g, b = 255, 50, 50
				end
				CreateMarkerWithParam(7, x, y, z + updateZ, heading - 180, 270.0, 0.0, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			elseif planerot == "down" then
				if (rot.x < 135 and rot.x > -135) or rot.y > 45 or rot.y < -45 then
					r, g, b = 255, 50, 50
				end
				CreateMarkerWithParam(7, x, y, z + updateZ, 180.0, 0.0, -heading, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			end
			CreateMarkerWithParam(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125)
		elseif warp then
			CreateMarkerWithParam(42, x, y, z + updateZ, 0.0, 0.0, heading, diameter/2, diameter/2, diameter/2, 62, 182, 245, 125)
			CreateMarkerWithParam(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125)
		elseif isRound then
			CreateMarkerWithParam(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125)
		else
			CreateMarkerWithParam(1, x, y, z, 0.0, 0.0, 0.0, diameter, diameter, diameter/2, 254, 235, 169, 30)
		end
	end
end

function CreateBlipForRace(index, id, isNext, isPair, isLapEnd)
	local blip = nil
	local scale = 0.9
	local alpha = 255
	local blipId = id
	local color = id == 38 and 0 or 5
	if isNext then
		scale = 0.65
		alpha = 130
	end
	if isPair and not isLapEnd and track.checkpoints[index].pair_transform ~= -1 then
		blipId = 570
		color = 1
	elseif not isPair and not isLapEnd and track.checkpoints[index].transform ~= -1 then
		blipId = 570
		color = 1
	end
	if isPair then
		blip = AddBlipForCoord(track.checkpoints[index].pair_x, track.checkpoints[index].pair_y, track.checkpoints[index].pair_z)
	else
		blip = AddBlipForCoord(track.checkpoints[index].x, track.checkpoints[index].y, track.checkpoints[index].z)
	end
	SetBlipSprite(blip, blipId)
	SetBlipColour(blip, color)
	SetBlipDisplay(blip, 6)
	BeginTextCommandSetBlipName("STRING")
	if isLapEnd then
		AddTextComponentString(GetTranslate("racing-blip-finishline"))
	else
		AddTextComponentString(GetTranslate("racing-blip-checkpoint"))
	end
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, scale)
	SetBlipAlpha(blip, alpha)
	return blip
end

function StartRespawn()
	if status == "racing" then
		if hasRespawned then
			return
		end
		if not isRespawning then
			respawnTimeStart = GetGameTimer()
			isRespawning = true
		end
		if respawnTime >= Config.RespawnHoldTime then
			hasRespawned = true
			ReadyRespawn()
		else
			respawnTime = GetGameTimer() - respawnTimeStart
		end
		if respawnTime >= 100 and not hasShowRespawnUI then
			hasShowRespawnUI = true
			SendNUIMessage({
				action = "nui_msg:showRespawnUI"
			})
		end
	else
		ResetAndHideRespawnUI()
	end
end

function ResetAndHideRespawnUI()
	hasRespawned = false
	isRespawning = false
	respawnTime = 0
	if hasShowRespawnUI then
		hasShowRespawnUI = false
		SendNUIMessage({
			action = "nui_msg:hideRespawnUI"
		})
	end
end

function ReadyRespawn()
	if isTransformingInProgress or isTeleportingInProgress then return end
	if not isRespawningInProgress then
		isRespawningInProgress = true
		Citizen.CreateThread(function()
			local ped = PlayerPedId()
			RemoveAllPedWeapons(ped, false)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
			if track.checkpoints then
				if track.checkpoints[actualCheckpoint - 1] == nil then
					if totalCheckpointsTouched ~= 0 then
						local index = #track.checkpoints
						local x, y, z, heading = 0.0, 0.0, 0.0, 0.0
						if lastCheckpointPair == 1 and track.checkpoints[index].hasPair then
							x = track.checkpoints[index].pair_x
							y = track.checkpoints[index].pair_y
							z = track.checkpoints[index].pair_z
							heading = track.checkpoints[index].pair_heading
						else
							x = track.checkpoints[index].x
							y = track.checkpoints[index].y
							z = track.checkpoints[index].z
							heading = track.checkpoints[index].heading
						end
						if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(x, y, z, heading, true, false) end
						RespawnVehicle(x, y, z, heading, true)
					else
						if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
							NetworkResurrectLocalPlayer(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, track.gridPositions[gridPositionIndex].heading, true, false)
						end
						RespawnVehicle(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, track.gridPositions[gridPositionIndex].heading, true)
					end
				else
					local index, reset = GetNonFakeCheckpoint(actualCheckpoint)
					if reset then
						finishLine = false
						DeleteCheckpoint(actualCheckpoint_draw)
						DeleteCheckpoint(actualCheckpoint_pair_draw)
						actualCheckpoint_draw = nil
						actualCheckpoint_pair_draw = nil
						RemoveBlip(actualBlip)
						RemoveBlip(nextBlip)
						RemoveBlip(actualBlip_pair)
						RemoveBlip(nextBlip_pair)
						actualBlip = CreateBlipForRace(actualCheckpoint, 1, false, false)
						if track.checkpoints[actualCheckpoint].hasPair then
							actualBlip_pair = CreateBlipForRace(actualCheckpoint, 1, false, true)
						end
						if nextCheckpoint == #track.checkpoints then
							if actualLap < laps then
								nextBlip = CreateBlipForRace(nextCheckpoint, 58, true, false, true)
								if track.checkpoints[nextCheckpoint].hasPair then
									nextBlip_pair = CreateBlipForRace(nextCheckpoint, 58, true, true, true)
								end
							else
								nextBlip = CreateBlipForRace(nextCheckpoint, 38, true, false, true)
								if track.checkpoints[nextCheckpoint].hasPair then
									nextBlip_pair = CreateBlipForRace(nextCheckpoint, 38, true, true, true)
								end
							end
						else
							nextBlip = CreateBlipForRace(nextCheckpoint, 1, true, false)
							if track.checkpoints[nextCheckpoint].hasPair then
								nextBlip_pair = CreateBlipForRace(nextCheckpoint, 1, true, true)
							end
						end
						local vehicleModel = (transformIsParachute and -422877666) or (transformIsBeast and -731262150) or (transformedModel ~= "" and transformedModel) or 0
						if lastCheckpointPair == 1 and track.checkpoints[index].hasPair then
							for i = index, 1, -1 do
								if track.checkpoints[i].hasPair and (track.checkpoints[i].pair_transform ~= -1) and (track.checkpoints[i].pair_transform ~= -2) then
									vehicleModel = track.transformVehicles[track.checkpoints[i].pair_transform + 1]
									break
								elseif track.checkpoints[i].hasPair and (track.checkpoints[i].pair_transform == -2) then
									vehicleModel = GetRandomVehicleModel(i)
									break
								end
							end
						else
							for i = index, 1, -1 do
								if (track.checkpoints[i].transform ~= -1) and (track.checkpoints[i].transform ~= -2) then
									vehicleModel = track.transformVehicles[track.checkpoints[i].transform + 1]
									break
								elseif (track.checkpoints[i].transform == -2) then
									vehicleModel = GetRandomVehicleModel(i)
									break
								end
							end
						end
						if vehicleModel == -422877666 then
							syncData.vehicle = "parachute"
							transformedModel = ""
							transformIsParachute = true
							transformIsBeast = false
							SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
						elseif vehicleModel == -731262150 then
							syncData.vehicle = "beast"
							transformedModel = ""
							transformIsParachute = false
							if not transformIsBeast then
								transformIsBeast = true
								Citizen.CreateThread(function()
									local wasJumping = false
									local wasOnFoot = false
									local canPlayLandSound = false
									-- Init sounds
									-- RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_01", false, -1)
									-- RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_02", false, -1)
									-- RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_03", false, -1)
									-- RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_01", false, -1)
									RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_02", false, -1)
									while transformIsBeast do
										SetSuperJumpThisFrame(PlayerId())
										SetBeastModeActive(PlayerId())
										local pedInBeastMode = PlayerPedId()
										local isJumping = IsPedDoingBeastJump(pedInBeastMode)
										local isOnFoot = not IsPedFalling(pedInBeastMode)
										if isJumping and not wasJumping then
											canPlayLandSound = true
											PlaySoundFromEntity(-1, "Beast_Jump", pedInBeastMode, "DLC_AR_Beast_Soundset", true, 60)
										end
										if isOnFoot and not wasOnFoot and canPlayLandSound then
											canPlayLandSound = false
											PlaySoundFromEntity(-1, "Beast_Jump_Land", pedInBeastMode, "DLC_AR_Beast_Soundset", true, 60)
										end
										wasJumping = isJumping
										wasOnFoot = isOnFoot
										Citizen.Wait(0)
									end
								end)
							end
							SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
						else
							if vehicleModel == 0 then
								vehicleModel = raceVehicle.model
								transformedModel = ""
							else
								if not IsModelInCdimage(vehicleModel) or not IsModelValid(vehicleModel) then
									if vehicleModel then
										print("vehicle model (" .. vehicleModel .. ") does not exist in current gta version! We have spawned a default vehicle for you")
									else
										print("Unknown error! We have spawned a default vehicle for you")
									end
									vehicleModel = Config.ReplaceInvalidVehicle
								end
								transformedModel = vehicleModel
							end
							transformIsParachute = false
							transformIsBeast = false
							SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
							syncData.vehicle = GetDisplayNameFromVehicleModel(vehicleModel) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(vehicleModel) or "Unknown"
						end
						syncData.totalCheckpointsTouched = totalCheckpointsTouched
						syncData.actualCheckpoint = actualCheckpoint
					end
					local x, y, z, heading = 0.0, 0.0, 0.0, 0.0
					if lastCheckpointPair == 1 and track.checkpoints[index].hasPair then
						x = track.checkpoints[index].pair_x
						y = track.checkpoints[index].pair_y
						z = track.checkpoints[index].pair_z
						heading = track.checkpoints[index].pair_heading
					else
						x = track.checkpoints[index].x
						y = track.checkpoints[index].y
						z = track.checkpoints[index].z
						heading = track.checkpoints[index].heading
					end
					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(x, y, z, heading, true, false) end
					RespawnVehicle(x, y, z, heading, true)
				end
			end
			if track.mode == "gta" then
				GiveWeapons()
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
			end
			isRespawningInProgress = false
		end)
	end
end

function GetNonFakeCheckpoint(cpIndex)
	local reset = false
	for i = cpIndex - 1, 1, -1 do
		if lastCheckpointPair == 1 and track.checkpoints[i].hasPair then
			if not track.checkpoints[i].pair_isTemporal and track.checkpoints[i].pair_planerot == nil then
				return i, reset
			else
				totalCheckpointsTouched = totalCheckpointsTouched - 1
				actualCheckpoint = actualCheckpoint - 1
				nextCheckpoint = nextCheckpoint - 1
				reset = true
			end
		else
			if not track.checkpoints[i].isTemporal and track.checkpoints[i].planerot == nil then
				return i, reset
			else
				totalCheckpointsTouched = totalCheckpointsTouched - 1
				actualCheckpoint = actualCheckpoint - 1
				nextCheckpoint = nextCheckpoint - 1
				reset = true
			end
		end
	end
	return 1, reset
end

function TeleportToPreviousCheckpoint()
	if actualCheckpoint - 2 <= 0 then return false end
	finishLine = false
	totalCheckpointsTouched = totalCheckpointsTouched - 1
	actualCheckpoint = actualCheckpoint - 1
	nextCheckpoint = nextCheckpoint - 1
	syncData.totalCheckpointsTouched = totalCheckpointsTouched
	syncData.actualCheckpoint = actualCheckpoint
	local ped = PlayerPedId()
	if lastCheckpointPair == 1 and track.checkpoints[actualCheckpoint - 1].hasPair then
		if IsPedInAnyVehicle(ped) then
			SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint - 1].pair_x, track.checkpoints[actualCheckpoint - 1].pair_y, track.checkpoints[actualCheckpoint - 1].pair_z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint - 1].pair_heading)
		else
			SetEntityCoords(ped, track.checkpoints[actualCheckpoint - 1].pair_x, track.checkpoints[actualCheckpoint - 1].pair_y, track.checkpoints[actualCheckpoint - 1].pair_z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(ped, track.checkpoints[actualCheckpoint - 1].pair_heading)
		end
	else
		if IsPedInAnyVehicle(ped) then
			SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint - 1].x, track.checkpoints[actualCheckpoint - 1].y, track.checkpoints[actualCheckpoint - 1].z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint - 1].heading)
		else
			SetEntityCoords(ped, track.checkpoints[actualCheckpoint - 1].x, track.checkpoints[actualCheckpoint - 1].y, track.checkpoints[actualCheckpoint - 1].z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(ped, track.checkpoints[actualCheckpoint - 1].heading)
		end
	end
	PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
	DeleteCheckpoint(actualCheckpoint_draw)
	DeleteCheckpoint(actualCheckpoint_pair_draw)
	actualCheckpoint_draw = nil
	actualCheckpoint_pair_draw = nil
	RemoveBlip(actualBlip)
	RemoveBlip(nextBlip)
	RemoveBlip(actualBlip_pair)
	RemoveBlip(nextBlip_pair)
	actualBlip = CreateBlipForRace(actualCheckpoint, 1, false, false)
	if track.checkpoints[actualCheckpoint].hasPair then
		actualBlip_pair = CreateBlipForRace(actualCheckpoint, 1, false, true)
	end
	if nextCheckpoint == #track.checkpoints then
		if actualLap < laps then
			nextBlip = CreateBlipForRace(nextCheckpoint, 58, true, false, true)
			if track.checkpoints[nextCheckpoint].hasPair then
				nextBlip_pair = CreateBlipForRace(nextCheckpoint, 58, true, true, true)
			end
		else
			nextBlip = CreateBlipForRace(nextCheckpoint, 38, true, false, true)
			if track.checkpoints[nextCheckpoint].hasPair then
				nextBlip_pair = CreateBlipForRace(nextCheckpoint, 38, true, true, true)
			end
		end
	else
		nextBlip = CreateBlipForRace(nextCheckpoint, 1, true, false)
		if track.checkpoints[nextCheckpoint].hasPair then
			nextBlip_pair = CreateBlipForRace(nextCheckpoint, 1, true, true)
		end
	end
	return true
end

function RespawnVehicle(positionX, positionY, positionZ, heading, engine)
	local ped = PlayerPedId()
	SetEntityVisible(ped, true)
	if transformIsParachute then
		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			DeleteEntity(lastVehicle)
			TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
		end
		ClearPedBloodDamage(ped)
		ClearPedWetness(ped)
		GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
		SetEntityCoords(ped, positionX, positionY, positionZ)
		SetEntityHeading(ped, heading)
		SetGameplayCamRelativeHeading(0)
		return
	end
	if transformIsBeast then
		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			DeleteEntity(lastVehicle)
			TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
		end
		ClearPedBloodDamage(ped)
		ClearPedWetness(ped)
		SetEntityCoords(ped, positionX, positionY, positionZ)
		SetEntityHeading(ped, heading)
		SetGameplayCamRelativeHeading(0)
		return
	end
	local vehicleModel = transformedModel ~= "" and transformedModel or (type(raceVehicle) == "number" and raceVehicle or (type(raceVehicle) == "table" and raceVehicle.model))
	local isHashValid = true
	if not IsModelInCdimage(vehicleModel) or not IsModelValid(vehicleModel) then
		if vehicleModel then
			print("vehicle model (" .. vehicleModel .. ") does not exist in current gta version! We have spawned a default vehicle for you")
		else
			print("Unknown error! We have spawned a default vehicle for you")
		end
		isHashValid = false
		vehicleModel = Config.ReplaceInvalidVehicle
		syncData.vehicle = GetDisplayNameFromVehicleModel(vehicleModel) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(vehicleModel) or "Unknown"
	end
	RequestModel(vehicleModel)
	while not HasModelLoaded(vehicleModel) do
		Citizen.Wait(0)
	end
	-- Spawn vehicle at the top of the player, fix OneSync culling
	local pos = GetEntityCoords(ped)
	local spawnedVehicle = CreateVehicle(vehicleModel, pos.x, pos.y, pos.z + 50.0, heading, true, false)
	FreezeEntityPosition(spawnedVehicle, true)
	SetEntityCollision(spawnedVehicle, false, false)
	SetVehRadioStation(spawnedVehicle, 'OFF')
	SetVehicleDoorsLocked(spawnedVehicle, 0)
	SetModelAsNoLongerNeeded(vehicleModel)
	if type(raceVehicle) == "number" or not isHashValid then
		SetVehicleColourCombination(spawnedVehicle, 0)
		raceVehicle = GetVehicleProperties(spawnedVehicle)
	else
		SetVehicleProperties(spawnedVehicle, raceVehicle)
	end
	if track.mode ~= "no_collision" then
		SetLocalPlayerAsGhost(true)
	end
	Citizen.Wait(0) -- Do not delete! Vehicle still has collisions before this. BUG?
	if DoesEntityExist(lastVehicle) then
		local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
		DeleteEntity(lastVehicle)
		TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
	end
	ClearPedBloodDamage(ped)
	ClearPedWetness(ped)
	-- Teleport the vehicle back to the checkpoint location
	SetEntityCoords(spawnedVehicle, positionX, positionY, positionZ)
	SetEntityHeading(spawnedVehicle, heading)
	SetPedIntoVehicle(ped, spawnedVehicle, -1)
	if track.mode ~= "gta" then
		SetVehicleDoorsLocked(spawnedVehicle, 4)
	end
	SetEntityCollision(spawnedVehicle, true, true)
	SetVehicleFuelLevel(spawnedVehicle, 100.0)
	SetVehicleDirtLevel(spawnedVehicle, 0.0)
	SetVehicleEngineOn(spawnedVehicle, engine, true, false)
	SetGameplayCamRelativeHeading(0)
	Citizen.Wait(0)
	if engine then
		FreezeEntityPosition(spawnedVehicle, false)
		ActivatePhysics(spawnedVehicle)
	end
	if IsThisModelAPlane(vehicleModel) or IsThisModelAHeli(vehicleModel) then
		ControlLandingGear(spawnedVehicle, 3)
		SetHeliBladesSpeed(spawnedVehicle, 1.0)
		SetHeliBladesFullSpeed(spawnedVehicle)
		SetVehicleForwardSpeed(spawnedVehicle, 30.0)
	end
	if vehicleModel == GetHashKey("avenger") or vehicleModel == GetHashKey("hydra") then
		SetVehicleFlightNozzlePositionImmediate(spawnedVehicle, 0.0)
	end
	local vehNetId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
	TriggerServerEvent('custom_races:server:spawnVehicle', vehNetId)
	lastVehicle = spawnedVehicle
	if track.mode ~= "no_collision" then
		Citizen.CreateThread(function()
			Citizen.Wait(500)
			local myServerId = GetPlayerServerId(PlayerId())
			while not isRespawningInProgress and ((status == "ready") or (status == "racing")) do
				local _drivers = drivers
				local myCoords = GetEntityCoords(PlayerPedId())
				local isPedNearMe = false
				for _, driver in pairs(_drivers) do
					if myServerId ~= driver.playerId and (#(myCoords - driver.currentCoords) <= 10.0) then
						isPedNearMe = true
						break
					end
				end
				if not isPedNearMe or (Count(_drivers) == 1) then
					break
				end
				Citizen.Wait(0)
			end
			if not isRespawningInProgress then
				SetLocalPlayerAsGhost(false)
			end
		end)
	end
end

function TransformVehicle(transformIndex, index)
	isTransformingInProgress = true
	Citizen.CreateThread(function()
		local vehicleModel = 0
		if transformIndex == -2 then
			vehicleModel = GetRandomVehicleModel(index)
		else
			vehicleModel = track.transformVehicles[transformIndex + 1]
		end
		local ped = PlayerPedId()
		local copySpeed = false
		local oldVehicle = GetVehiclePedIsIn(ped, false)
		local oldVehicleSpeed = oldVehicle ~= 0 and GetEntitySpeed(oldVehicle) or GetEntitySpeed(ped)
		local oldVehicleRotation = oldVehicle ~= 0 and GetEntityRotation(oldVehicle, 2) or GetEntityRotation(ped, 2)
		local oldVelocity = oldVehicle ~= 0 and GetEntityVelocity(oldVehicle) or GetEntityVelocity(ped)
		if transformIsParachute or transformIsBeast then
			copySpeed = true
		end
		if vehicleModel == -422877666 then
			-- Parachute
			if DoesEntityExist(lastVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
				DeleteEntity(lastVehicle)
				TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
			end
			syncData.vehicle = "parachute"
			GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
			SetEntityVelocity(ped, oldVelocity.x, oldVelocity.y, oldVelocity.z)
			transformedModel = ""
			transformIsParachute = true
			transformIsBeast = false
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			isTransformingInProgress = false
			return
		elseif vehicleModel == -731262150 then
			-- Beast mode
			if DoesEntityExist(lastVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
				DeleteEntity(lastVehicle)
				TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
			end
			syncData.vehicle = "beast"
			SetEntityVelocity(ped, oldVelocity.x, oldVelocity.y, oldVelocity.z)
			transformedModel = ""
			transformIsParachute = false
			if not transformIsBeast then
				transformIsBeast = true
				Citizen.CreateThread(function()
					local wasJumping = false
					local wasOnFoot = false
					local canPlayLandSound = false
					-- Init sounds
					-- RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_01", false, -1)
					-- RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_02", false, -1)
					-- RequestScriptAudioBank("DLC_STUNT/STUNT_RACE_03", false, -1)
					-- RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_01", false, -1)
					RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_02", false, -1)
					while transformIsBeast do
						SetSuperJumpThisFrame(PlayerId())
						SetBeastModeActive(PlayerId())
						local pedInBeastMode = PlayerPedId()
						local isJumping = IsPedDoingBeastJump(pedInBeastMode)
						local isOnFoot = not IsPedFalling(pedInBeastMode)
						if isJumping and not wasJumping then
							canPlayLandSound = true
							PlaySoundFromEntity(-1, "Beast_Jump", pedInBeastMode, "DLC_AR_Beast_Soundset", true, 60)
						end
						if isOnFoot and not wasOnFoot and canPlayLandSound then
							canPlayLandSound = false
							PlaySoundFromEntity(-1, "Beast_Jump_Land", pedInBeastMode, "DLC_AR_Beast_Soundset", true, 60)
						end
						wasJumping = isJumping
						wasOnFoot = isOnFoot
						Citizen.Wait(0)
					end
				end)
			end
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
			isTransformingInProgress = false
			return
		end
		if vehicleModel == 0 then
			-- Transform vehicle to the start vehicle
			vehicleModel = raceVehicle.model
			transformedModel = ""
		else
			if not IsModelInCdimage(vehicleModel) or not IsModelValid(vehicleModel) then
				if vehicleModel then
					print("vehicle model (" .. vehicleModel .. ") does not exist in current gta version! We have spawned a default vehicle for you")
				else
					print("Unknown error! We have spawned a default vehicle for you")
				end
				vehicleModel = Config.ReplaceInvalidVehicle
			end
			transformedModel = vehicleModel
		end
		transformIsParachute = false
		transformIsBeast = false
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		RequestModel(vehicleModel)
		while not HasModelLoaded(vehicleModel) do
			Citizen.Wait(0)
		end
		local pos = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local spawnedVehicle = CreateVehicle(vehicleModel, pos.x, pos.y, pos.z + 50.0, heading, true, false)
		SetModelAsNoLongerNeeded(vehicleModel)
		if not AreAnyVehicleSeatsFree(spawnedVehicle) then
			if DoesEntityExist(spawnedVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
				TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
				DeleteEntity(spawnedVehicle)
			end
			return TransformVehicle(transformIndex, index)
		end
		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			DeleteEntity(lastVehicle)
			TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
		end
		SetVehRadioStation(spawnedVehicle, 'OFF')
		SetVehicleDoorsLocked(spawnedVehicle, 0)
		SetVehicleColourCombination(spawnedVehicle, 0)
		SetVehicleProperties(spawnedVehicle, raceVehicle)
		SetPedIntoVehicle(ped, spawnedVehicle, -1)
		if track.mode ~= "gta" then
			SetVehicleDoorsLocked(spawnedVehicle, 4)
		end
		SetEntityCoords(spawnedVehicle, pos.x, pos.y, pos.z)
		SetEntityHeading(spawnedVehicle, heading)
		SetVehicleFuelLevel(spawnedVehicle, 100.0)
		SetVehicleDirtLevel(spawnedVehicle, 0.0)
		SetVehicleEngineOn(spawnedVehicle, true, true, false)
		if IsThisModelAPlane(vehicleModel) or IsThisModelAHeli(vehicleModel) then
			ControlLandingGear(spawnedVehicle, 3)
			SetHeliBladesSpeed(spawnedVehicle, 1.0)
			SetHeliBladesFullSpeed(spawnedVehicle)
			copySpeed = true
		end
		if vehicleModel == GetHashKey("avenger") or vehicleModel == GetHashKey("hydra") then
			SetVehicleFlightNozzlePositionImmediate(spawnedVehicle, 0.0)
		end
		SetVehicleForwardSpeed(spawnedVehicle, 0.0)
		SetEntityVelocity(spawnedVehicle, oldVelocity.x, oldVelocity.y, oldVelocity.z)
		SetEntityRotation(spawnedVehicle, oldVehicleRotation, 2)
		if copySpeed then
			SetVehicleForwardSpeed(spawnedVehicle, oldVehicleSpeed ~= 0.0 and oldVehicleSpeed or 30.0)
		end
		syncData.vehicle = GetDisplayNameFromVehicleModel(vehicleModel) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(vehicleModel) or "Unknown"
		local vehNetId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
		TriggerServerEvent('custom_races:server:spawnVehicle', vehNetId)
		lastVehicle = spawnedVehicle
		if lastCheckpointPair == 1 and track.checkpoints[index].hasPair and track.checkpoints[index].pair_warp then
			WarpVehicle(true, index)
		elseif lastCheckpointPair == 0 and track.checkpoints[index].warp then
			WarpVehicle(false, index)
		end
		isTransformingInProgress = false
	end)
end

function GetRandomVehicleModel(index)
	local vehicleModel = 0
	local isUnknownUnknowns = (lastCheckpointPair == 0 and track.cp1_unknown_unknowns) or (lastCheckpointPair == 1 and track.cp2_unknown_unknowns)
	if isUnknownUnknowns then
		-- Random race type: Unknown Unknowns (mission.race.cptrtt ~= nil)
		local vehicleList = {}
		local allVehClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22}
		for k, v in pairs(allVehClass) do
			vehicleList[v] = {}
		end
		for k, v in pairs(allVehModels) do
			local hash = GetHashKey(v)
			local modelClass = GetVehicleClassFromName(hash)
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			if not Config.BlacklistedVehs[hash] and label ~= "NULL" and vehicleList[modelClass] then
				table.insert(vehicleList[modelClass], hash)
			end
		end
		local isRandomClassValid = false
		local availableClass = {}
		local randomClass = lastCheckpointPair == 0 and track.checkpoints[index].random or track.checkpoints[index].pair_random
		if randomClass == 0 then -- land
			isRandomClassValid = true
			availableClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 17, 18, 19, 20, 22}
		elseif randomClass == 1 then -- plane
			isRandomClassValid = true
			availableClass = {15, 16}
		elseif randomClass == 2 then -- boat
			isRandomClassValid = true
			availableClass = {14}
		elseif randomClass == 3 then -- plane + land
			isRandomClassValid = true
			availableClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 22}
		else
			-- ====================================================================================================
			-- Need more test, but I don't think Rockstar's random race style is betther than FiveM servers
			-- ====================================================================================================
			isRandomClassValid = false
		end
		local blacklistSet = {}
		for _, class in ipairs(track.blacklistClass) do
			blacklistSet[class] = true
		end
		local filteredAvailableClass = {}
		for _, class in ipairs(availableClass) do
			if not blacklistSet[class] then
				table.insert(filteredAvailableClass, class)
			end
		end
		availableClass = #filteredAvailableClass > 0 and filteredAvailableClass or availableClass
		local availableVehModels = {}
		if isRandomClassValid then
			for i = 1, #availableClass do
				for j = 1, #vehicleList[availableClass[i]] do
					table.insert(availableVehModels, vehicleList[availableClass[i]][j])
				end
			end
			if #availableVehModels == 0 then
				isRandomClassValid = false
			end
		end
		local attempt = 0
		while attempt < 10 do
			attempt = attempt + 1
			if isRandomClassValid then
				local randomIndex = math.random(#availableVehModels)
				local randomHash = availableVehModels[randomIndex]
				if transformedModel ~= randomHash and GetVehicleModelNumberOfSeats(randomHash) >= 1 then
					vehicleModel = randomHash
					break
				end
			else
				local randomIndex = math.random(#allVehModels)
				local randomHash = GetHashKey(allVehModels[randomIndex])
				local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))
				if not Config.BlacklistedVehs[randomHash] and label ~= "NULL" and IsThisModelACar(randomHash) then
					if transformedModel ~= randomHash and GetVehicleModelNumberOfSeats(randomHash) >= 1 then
						vehicleModel = randomHash
						break
					end
				end
			end
			Citizen.Wait(0)
		end
	else
		local isKnownUnknowns = false
		for k, v in pairs(track.transformVehicles) do
			if v ~= 0 then
				isKnownUnknowns = true
				break
			end
		end
		-- Random race type: Unknown Unknowns (mission.race.cptrtt == nil)
		if not isKnownUnknowns then
			local attempt = 0
			while attempt < 10 do
				attempt = attempt + 1
				local randomIndex = math.random(#allVehModels)
				local randomHash = GetHashKey(allVehModels[randomIndex])
				local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))
				if not Config.BlacklistedVehs[randomHash] and label ~= "NULL" and IsThisModelACar(randomHash) then
					if transformedModel ~= randomHash and GetVehicleModelNumberOfSeats(randomHash) >= 1 then
						vehicleModel = randomHash
						break
					end
				end
				Citizen.Wait(0)
			end
		else
			-- Random race type: Known Unknowns
			local availableModels = {}
			local count = 0
			local seen = {}
			for k, v in pairs(track.transformVehicles) do
				if v ~= 0 and not seen[v] then
					count = count + 1
					availableModels[count] = {}
					table.insert(availableModels[count], v)
					seen[v] = true
				end
			end
			local attempt = 0
			while attempt < 10 do
				attempt = attempt + 1
				if count == 0 then
					break
				elseif count == 1 then
					vehicleModel = availableModels[count][1]
					break
				else
					local randomIndex = math.random(count)
					if transformedModel ~= availableModels[randomIndex][1] then
						vehicleModel = availableModels[randomIndex][1]
						break
					end
				end
				Citizen.Wait(0)
			end
		end
	end
	return vehicleModel
end

function PlayTransformEffectAndSound(playerPed, r, g, b)
	Citizen.CreateThread(function()
		local ped = playerPed or PlayerPedId()
		local particleDictionary = "scr_as_trans"
		local particleName = "scr_as_trans_smoke"
		local scale = 2.0
		RequestNamedPtfxAsset(particleDictionary)
		while not HasNamedPtfxAssetLoaded(particleDictionary) do
			Citizen.Wait(0)
		end
		UseParticleFxAssetNextCall(particleDictionary)
		PlaySoundFromEntity(-1, "Transform_JN_VFX", ped, "DLC_IE_JN_Player_Sounds", false, 0)
		local effect = StartParticleFxLoopedOnEntity(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
		if tonumber(r) and tonumber(g) and tonumber(b) then
			SetParticleFxLoopedColour(effect, (tonumber(r) / 255) + 0.0, (tonumber(g) / 255) + 0.0, (tonumber(b) / 255) + 0.0, true)
		end
		Citizen.Wait(500)
		StopParticleFxLooped(effect, true)
	end)
end

function WarpVehicle(pair, index)
	local ped = PlayerPedId()
	local entity = GetVehiclePedIsIn(ped, false) ~= 0 and GetVehiclePedIsIn(ped, false) or ped
	local checkpoint = track.checkpoints[index + 1] or track.checkpoints[1]
	local entitySpeed = GetEntitySpeed(entity)
	local entityRotation = GetEntityRotation(entity, 2)
	if checkpoint.hasPair and pair then
		SetEntityCoords(entity, checkpoint.pair_x, checkpoint.pair_y, checkpoint.pair_z)
		SetEntityRotation(entity, entityRotation, 2)
		SetEntityHeading(entity, checkpoint.pair_heading)
	else
		SetEntityCoords(entity, checkpoint.x, checkpoint.y, checkpoint.z)
		SetEntityRotation(entity, entityRotation, 2)
		SetEntityHeading(entity, checkpoint.heading)
	end
	SetVehicleForwardSpeed(entity, entitySpeed)
	SetGameplayCamRelativeHeading(0)
end

function SlowVehicle(veh)
	local speed = math.min(GetEntitySpeed(veh), GetVehicleEstimatedMaxSpeed(veh))
	SetVehicleForwardSpeed(veh, speed / 3.0)
	PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 0)
end

function DisplayCustomMsgs(msg, instantDelete, oldMsgItem)
	local newMsgItem = nil
	if instantDelete and oldMsgItem then
		ThefeedRemoveItem(oldMsgItem)
	end
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	newMsgItem = EndTextCommandThefeedPostTicker(false, false)
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		ThefeedRemoveItem(newMsgItem)
	end)
	if instantDelete then
		return newMsgItem
	end
end

function ButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

function Button(ControlButton)
	N_0xe83a3e3557a56640(ControlButton)
end

function SetupScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()
	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(1)
	Button(GetControlInstructionalButton(2, 173, true))
	Button(GetControlInstructionalButton(2, 172, true))
	ButtonMessage(GetTranslate("racing-spectator-select"))
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
	PushScaleformMovieFunctionParameterInt(0)
	Button(GetControlInstructionalButton(2, 202, true))
	ButtonMessage(GetTranslate("racing-spectator-quit"))
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()
	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

function ResetClient()
	local ped = PlayerPedId()
	hasCheated = false
	togglePositionUI = false
	totalPlayersInRace = 0
	currentUiPage = 1
	transformIsParachute = false
	transformIsBeast = false
	isRespawningInProgress = false
	isTransformingInProgress = false
	isTeleportingInProgress = false
	totalDriversNubmer = nil
	transformedModel = ""
	lastVehicle = nil
	loadedObjects = {}
	arenaProp = {}
	fireworkObjects = {}
	drivers = {}
	hudData = {}
	syncData = {
		fps = 999,
		actualLap = 1,
		actualCheckpoint = 1,
		vehicle = "",
		lastlap = 0,
		bestlap = 0,
		totalRaceTime = 0,
		totalCheckpointsTouched = 0,
		lastCheckpointPair = 0
	}
	RemoveBlip(actualBlip)
	RemoveBlip(nextBlip)
	RemoveBlip(actualBlip_pair)
	RemoveBlip(nextBlip_pair)
	ResetAndHideRespawnUI()
	FreezeEntityPosition(ped, true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	SetPedConfigFlag(ped, 151, true)
	SetPedCanBeKnockedOffVehicle(ped, 0)
	SetEntityInvincible(ped, false)
	SetPedArmour(ped, 100)
	SetEntityHealth(ped, 200)
	SetBlipAlpha(GetMainPlayerBlipId(), 255)
	SetEntityVisible(ped, true)
	ClearPedBloodDamage(ped)
	ClearPedWetness(ped)
	SetLocalPlayerAsGhost(false)
	ClearAreaLeaveVehicleHealth(joinRacePoint.x + 0.0, joinRacePoint.y + 0.0, joinRacePoint.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
end

function EnableSpecMode()
	if status == "racing" then
		FinishRace("spectator")
	end
end

function FinishRace(raceStatus)
	status = "waiting"
	SendNUIMessage({
		action = "nui_msg:hideRaceHud"
	})
	local ped = PlayerPedId()
	local finishCoords = GetEntityCoords(ped)
	local _drivers = drivers
	if GetDriversNotFinishAndNotDNF(_drivers) >= 2 and raceStatus == "yeah" then
		CreateFinishCamera()
	end
	TriggerServerEvent("custom_races:server:playerFinish", {
		syncData.fps,
		syncData.actualLap,
		syncData.actualCheckpoint,
		syncData.vehicle,
		syncData.lastlap,
		syncData.bestlap,
		syncData.totalRaceTime,
		syncData.totalCheckpointsTouched,
		syncData.lastCheckpointPair
	}, GetGameTimer() + 3000, hasCheated, finishCoords, raceStatus)
	Citizen.Wait(1000)
	AnimpostfxStop("MP_Celeb_Win")
	SetEntityVisible(ped, false)
	FreezeEntityPosition(ped, true)
	if DoesEntityExist(lastVehicle) then
		local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
		DeleteEntity(lastVehicle)
		TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
	end
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
	SetBlipAlpha(GetMainPlayerBlipId(), 0)
end

function LeaveRace()
	if status == "racing" or status == "spectating" then
		status = "leaving"
		SendNUIMessage({
			action = "nui_msg:hideRaceHud"
		})
		local ped = PlayerPedId()
		RemoveFinishCamera()
		RemoveLoadedObjects()
		SwitchOutPlayer(ped, 0, 1)
		TriggerServerEvent('custom_races:server:leaveRace')
		Citizen.Wait(1000)
		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			DeleteEntity(lastVehicle)
			TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
		end
		RemoveAllPedWeapons(ped, false)
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		Citizen.Wait(4000)
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
		SwitchInPlayer(ped)
		status = "freemode"
		ResetClient()
		TriggerServerCallback('custom_races:server:getRoomList', function(result)
			SendNUIMessage({
				action = "nui_msg:updateRoomList",
				result = result
			})
		end)
		while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
		if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
			local pos = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)
			NetworkResurrectLocalPlayer(pos[1], pos[2], pos[3], heading, true, false)
		end
		FreezeEntityPosition(ped, false)
		if DoesEntityExist(joinRaceVehicle) then
			FreezeEntityPosition(joinRaceVehicle, false)
			ActivatePhysics(joinRaceVehicle)
		end
		joinRacePoint = nil
		joinRaceHeading = nil
		joinRaceVehicle = 0
		TriggerEvent('custom_races:unloadrace')
		TriggerServerEvent("custom_core:server:inRace", false)
	end
end

function EndRace()
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		RemoveFinishCamera()
		SwitchOutPlayer(ped, 0, 1)
		Citizen.Wait(2500)
		RemoveLoadedObjects()
		isOverClouds = true
		local waitTime = 1000 + 2000 * (math.floor((Count(drivers) - 1) / 10) + 1)
		ShowScoreboard()
		Citizen.Wait(waitTime)
		isOverClouds = false
		Citizen.Wait(1000)
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
		SwitchInPlayer(ped)
		status = "freemode"
		ResetClient()
		TriggerServerCallback('custom_races:server:getRoomList', function(result)
			SendNUIMessage({
				action = "nui_msg:updateRoomList",
				result = result
			})
		end)
		while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
		if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
			local pos = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)
			NetworkResurrectLocalPlayer(pos[1], pos[2], pos[3], heading, true, false)
		end
		FreezeEntityPosition(ped, false)
		if DoesEntityExist(joinRaceVehicle) then
			FreezeEntityPosition(joinRaceVehicle, false)
			ActivatePhysics(joinRaceVehicle)
		end
		joinRacePoint = nil
		joinRaceHeading = nil
		joinRaceVehicle = 0
		TriggerEvent('custom_races:unloadrace')
		TriggerServerEvent("custom_core:server:inRace", false)
	end)
end

function ShowScoreboard()
	Citizen.CreateThread(function()
		local racefrontpos = {}
		local bestlapTable = {}
		local _drivers = drivers
		local driversInfo = UpdateDriversInfo(_drivers)
		local totalPlayersInRace_result = Count(_drivers)
		local currentUiPage_result = 1
		local firstLoad = true
		for k, v in pairs(_drivers) do
			if not v.dnf then
				table.insert(bestlapTable, {
					playerId = v.playerId,
					bestlap = v.bestlap
				})
			end
			table.insert(racefrontpos, {
				playerId = v.playerId,
				position = GetPlayerPosition(driversInfo, v.playerId),
				name = v.playerName,
				vehicle = (v.vehicle == "parachute" and GetTranslate("transform-parachute")) or (v.vehicle == "beast" and GetTranslate("transform-beast")) or (GetLabelText(v.vehicle) ~= "NULL" and GetLabelText(v.vehicle):gsub("µ", " ")) or GetTranslate("unknown-vehicle"),
				totaltime = v.dnf and "DNF" or (v.hasFinished and GetTimeAsString(v.totalRaceTime)) or "network error", -- Maybe someone's network latency is too high?
				bestlap = v.dnf and "DNF" or (v.hasFinished and GetTimeAsString(v.bestlap)) or "network error" -- Maybe someone's network latency is too high?
			})
		end
		table.sort(bestlapTable, function(a, b)
			return a.bestlap < b.bestlap
		end)
		table.sort(racefrontpos, function(a, b)
			return a.position < b.position
		end)
		if #bestlapTable > 0 then
			for i = 1, #racefrontpos do
				if racefrontpos[i].playerId == bestlapTable[1].playerId then
					racefrontpos[i].bestlap = racefrontpos[i].bestlap .. "★"
					break
				end
			end
		end
		while isOverClouds do
			local startIdx = (currentUiPage_result - 1) * 10 + 1
			local endIdx = math.min(startIdx + 10 - 1, totalPlayersInRace_result)
			local racefrontpos_show = {}
			for i = startIdx, endIdx do
				table.insert(racefrontpos_show, racefrontpos[i])
			end
			SendNUIMessage({
				action = "nui_msg:showScoreboard",
				racefrontpos = racefrontpos_show,
				animation = firstLoad
			})
			firstLoad = false
			if (currentUiPage_result * 10) < totalPlayersInRace_result then
				currentUiPage_result = currentUiPage_result + 1
			else
				currentUiPage_result = 1
			end
			Citizen.Wait(2000)
		end
		SendNUIMessage({
			action = "nui_msg:hideScoreboard"
		})
	end)
end

function RemoveLoadedObjects()
	for i = 1, #loadedObjects do
		DeleteObject(loadedObjects[i])
	end
end

function CreateFinishCamera()
	ClearFocus()
	local rotation = vector3(track.checkpoints[#track.checkpoints].x, track.checkpoints[#track.checkpoints].y, track.checkpoints[#track.checkpoints].z)
	local pX = track.checkpoints[#track.checkpoints].x
	local pY = track.checkpoints[#track.checkpoints].y
	local pZ = track.checkpoints[#track.checkpoints].z + 5.0
	local rX = 0.0
	local rY = 0.0
	local rZ = track.checkpoints[#track.checkpoints].heading
	local fov = 90.0
	if rZ < 0 then
		rZ = rZ - 180
	elseif rZ > 0 then
		rZ = rZ + 180
	end
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pX, pY, pZ, rX, rY, rZ, fov)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 0, true, false)
	SetCamAffectsAiming(cam, false)
end

function RemoveFinishCamera()
	ClearFocus()
	RenderScriptCams(false, false, 0, true, false)
	DestroyCam(cam, false)
	cam = nil
end

function EndCam()
	ClearFocus()
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(cam, false)
	cam = nil
end

function EndCam2()
	ClearFocus()
	RenderScriptCams(false, true, 0, true, false)
	DestroyCam(cam, false)
	cam = nil
end

function GiveWeapons()
	local ped = PlayerPedId()
	for k, v in pairs(Config.Weapons) do
		GiveWeaponToPed(ped, k, v, true, false)
	end
end

function GetDriversNotFinishAndNotDNF(_drivers)
	local count = 0
	for k, v in pairs(_drivers) do
		if not v.hasFinished and not v.dnf then
			count = count + 1
		end
	end
	return count
end

function Count(t)
	local c = 0
	for _, _ in pairs(t) do
		c = c + 1
	end
	return c
end

function SetWeatherAndTime()
	SetWeatherTypeNowPersist(weatherAndTime.weather)
	if weatherAndTime.weather == 'XMAS' then
		SetForceVehicleTrails(true)
		SetForcePedFootstepsTracks(true)
	else
		SetForceVehicleTrails(false)
		SetForcePedFootstepsTracks(false)
	end
	if weatherAndTime.weather == 'RAIN' then
		SetRainLevel(0.3)
	elseif weatherAndTime.weather == 'THUNDER' then
		SetRainLevel(0.5)
	else
		SetRainLevel(0.0)
	end
	NetworkOverrideClockTime(weatherAndTime.hour, weatherAndTime.minute, weatherAndTime.second)
end

function SetCurrentRace()
	-- Set weather and time, remove npc and traffic
	Citizen.CreateThread(function()
		while status ~= "freemode" do
			local ped = PlayerPedId()
			SetWeatherAndTime()
			if disableTraffic then
				local pos = GetEntityCoords(ped)
				RemoveVehiclesFromGeneratorsInArea(pos['x'] - 500.0, pos['y'] - 500.0, pos['z'] - 500.0, pos['x'] + 500.0, pos['y'] + 500.0, pos['z'] + 500.0)
				SetVehicleDensityMultiplierThisFrame(0.0)
				SetRandomVehicleDensityMultiplierThisFrame(0.0)
				SetParkedVehicleDensityMultiplierThisFrame(0.0)
				SetGarbageTrucks(0)
				SetRandomBoats(0)
				SetPedDensityMultiplierThisFrame(0.0)
				SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
			end
			if (IsEntityDead(ped) or IsPlayerDead(PlayerId())) and status == "racing" then
				ReadyRespawn()
			end
			if status ~= "racing" then
				DisableControlAction(0, 75, true) -- F
			end
			DisableControlAction(0, 200, true) -- Esc
			Citizen.Wait(0)
		end
	end)
	-- Display the ranking of players who finished the race
	Citizen.CreateThread(function()
		local finishedPlayer = {}
		local firstLoad = true
		while status ~= "freemode" do
			if status == "racing" or status == "waiting" or status == "spectating" or status == "ending" then
				local _drivers = drivers
				local driversInfo = UpdateDriversInfo(_drivers)
				if firstLoad then
					for k, v in pairs(_drivers) do
						if v.hasFinished then
							-- When joining a race midway, other players have already finished
							finishedPlayer[v.playerId] = true
						end
					end
					firstLoad = false
				end
				for k, v in pairs(_drivers) do
					if v.hasFinished and not finishedPlayer[v.playerId] then
						finishedPlayer[v.playerId] = true
						if not v.dnf then
							local name = v.playerName
							local position = GetPlayerPosition(driversInfo, v.playerId)
							local message = string.format(GetTranslate("racing-info-finished"), name, position)
							DisplayCustomMsgs(message, false, nil)
							Citizen.Wait(100)
						end
					elseif not v.hasFinished then
						finishedPlayer[v.playerId] = false
					end
				end
				Citizen.Wait(500)
			else
				Citizen.Wait(1000)
			end
		end
	end)
	-- Blimp text
	Citizen.CreateThread(function()
		local scaleform = RequestScaleformMovie("blimp_text")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		local rendertarget = 0
		if not IsNamedRendertargetRegistered("blimp_text") then
			RegisterNamedRendertarget("blimp_text", false)
		end
		if not IsNamedRendertargetLinked(1575467428) then
			LinkNamedRendertarget(1575467428)
		end
		if IsNamedRendertargetRegistered("blimp_text") then
			rendertarget = GetNamedRendertargetRenderId("blimp_text")
		end
		PushScaleformMovieFunction(scaleform, "SET_MESSAGE")
		PushScaleformMovieFunctionParameterString(track.blimpText or "")
		PopScaleformMovieFunctionVoid()
		PushScaleformMovieFunction(scaleform, "SET_COLOUR")
		PushScaleformMovieFunctionParameterInt(track.blimpColor or 1)
		PopScaleformMovieFunctionVoid()
		PushScaleformMovieFunction(scaleform, "SET_SCROLL_SPEED")
		PushScaleformMovieFunctionParameterFloat(track.blimpSpeed or 100.0)
		PopScaleformMovieFunctionVoid()
		while status ~= "freemode" do
			SetTextRenderId(rendertarget)
			SetScriptGfxDrawOrder(4)
			SetScriptGfxDrawBehindPausemenu(true)
			SetScaleformMovieToUseSuperLargeRt(scaleform, true)
			DrawScaleformMovie(scaleform, 0.0, -0.08, 1.0, 1.7, 255, 255, 255, 255, 0)
			SetTextRenderId(GetDefaultScriptRendertargetRenderId())
			Citizen.Wait(0)
		end
		ReleaseNamedRendertarget("blimp_text")
	end)
	-- Firework
	Citizen.CreateThread(function()
		while isLoadingObjects do Citizen.Wait(0) end
		while status ~= "freemode" and #fireworkObjects > 0 do
			local pos = GetEntityCoords(PlayerPedId())
			for k, v in pairs(fireworkObjects) do
				if not v.playing and DoesEntityExist(v.handle) and (#(pos - GetEntityCoords(v.handle)) <= 50.0) then
					v.playing = true
					Citizen.CreateThread(function()
						local particleDictionary = "scr_indep_fireworks"
						local particleName = track.firework.name
						local scale = 2.0
						RequestNamedPtfxAsset(particleDictionary)
						while not HasNamedPtfxAssetLoaded(particleDictionary) do
							Citizen.Wait(0)
						end
						UseParticleFxAssetNextCall(particleDictionary)
						local effect = StartParticleFxLoopedOnEntity(particleName, v.handle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
						if tonumber(track.firework.r) and tonumber(track.firework.g) and tonumber(track.firework.b) then
							SetParticleFxLoopedColour(effect, (tonumber(track.firework.r) / 255) + 0.0, (tonumber(track.firework.g) / 255) + 0.0, (tonumber(track.firework.b) / 255) + 0.0, true)
						end
						Citizen.Wait(2000)
						StopParticleFxLooped(effect, true)
						v.playing = false
					end)
				end
			end
			Citizen.Wait(0)
		end
	end)
	-- Fixture remover
	Citizen.CreateThread(function()
		local hide = {}
		if #track.dhprop > 0 then
			local validHash = {}
			local seen = {}
			-- Some hash may not exist in downgrade version
			for i = 1, #track.dhprop do
				if not seen[track.dhprop[i].hash] and IsModelInCdimage(track.dhprop[i].hash) and IsModelValid(track.dhprop[i].hash) then
					seen[track.dhprop[i].hash] = true
					table.insert(validHash, track.dhprop[i])
				end
			end
			track.dhprop = validHash
		end
		for k, v in pairs(track.dhprop) do
			hide[v.hash] = true
		end
		while isLoadingObjects do Citizen.Wait(0) end
		while status ~= "freemode" do
			if #track.dhprop > 0 and (status == "racing" or status == "spectating") then
				local pool = GetGamePool('CObject')
				for i = 1, #pool do
					local fixture = pool[i]
					local found = false
					for i = 1, #loadedObjects do
						if fixture == loadedObjects[i] then
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
				local pos = GetEntityCoords(PlayerPedId())
				for k, v in pairs(track.dhprop) do
					local fixture = GetClosestObjectOfType(pos.x, pos.y, pos.z, 300.0, v.hash, false)
					local found = false
					for i = 1, #loadedObjects do
						if fixture == loadedObjects[i] then
							found = true
							break
						end
					end
					if not found and fixture and DoesEntityExist(fixture) then
						SetEntityAsMissionEntity(fixture, true, true)
						DeleteEntity(fixture)
					end
				end
			elseif #track.dhprop == 0 or status == "leaving" or status == "ending" then
				break
			end
			Citizen.Wait(0)
		end
	end)
	-- Loop get fps and sync to other players
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		while status == "loading_track" or status == "ready" or status == "racing" do
			local startCount = GetFrameCount()
			Citizen.Wait(1000)
			local endCount = GetFrameCount()
			local fps = endCount - startCount - 1
			if fps <= 0 then fps = 1 end
			syncData.fps = fps
		end
	end)
end

function StartSyncDataToServer()
	Citizen.CreateThread(function()
		while status == "ready" or status == "racing" do
			TriggerServerEvent("custom_races:server:clientSync", {
				syncData.fps,
				syncData.actualLap,
				syncData.actualCheckpoint,
				syncData.vehicle,
				syncData.lastlap,
				syncData.bestlap,
				syncData.totalRaceTime,
				syncData.totalCheckpointsTouched,
				syncData.lastCheckpointPair
			}, GetGameTimer())
			Citizen.Wait(500)
		end
	end)
end

RegisterNetEvent("custom_races:client:loadTrack", function(data, actualTrack, roomId)
	status = "loading_track"
	TriggerEvent("custom_races:loadrace")
	TriggerServerEvent("custom_core:server:inRace", true)
	roomData = data
	track = actualTrack
	roomServerId = roomId
	SendNUIMessage({
		action = "nui_msg:updatePauseMenu",
		img = roomData.img,
		title = track.trackName .. " - made by [" .. track.creatorName .. "]",
		dnf = roomData.dnf,
		traffic = roomData.traffic,
		weather = roomData.weather,
		time = roomData.time .. ":00",
		accessible = roomData.accessible,
		mode = roomData.mode
	})
	laps = tonumber(roomData.laps)
	disableTraffic = (roomData.traffic == "off") and true or false
	weatherAndTime = { weather = roomData.weather, hour = tonumber(roomData.time), minute = 0, second = 0 }
	if joinRaceVehicle ~= 0 and roomData.vehicle == "default" then
		raceVehicle = GetVehicleProperties(joinRaceVehicle) or raceVehicle or {}
	end
	SetLocalPlayerAsGhost(true)
	SetCurrentRace()
	Citizen.Wait(500)
	BeginTextCommandBusyString("STRING")
	AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "]")
	EndTextCommandBusyString(2)
	Citizen.Wait(1000)
	isLoadingObjects = true
	local objects = track.props
	local dobjects = track.dprops
	local totalObjects = #objects + #dobjects
	local iTotal = 0
	local invalidObjects = {}
	for i = 1, #objects do
		if IsModelInCdimage(objects[i].hash) and IsModelValid(objects[i].hash) then
			iTotal = iTotal + 1
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "] (" .. math.floor(iTotal * 100 / totalObjects) .. "%)")
			EndTextCommandBusyString(2)
			RequestModel(objects[i].hash)
			while not HasModelLoaded(objects[i].hash) do
				Citizen.Wait(0)
			end
			local obj = CreateObjectNoOffset(objects[i].hash, objects[i].x, objects[i].y, objects[i].z, false, true, false)
			-- Create object of door type
			-- https://docs.fivem.net/natives/?_0x9A294B2138ABB884
			if obj == 0 then
				obj = CreateObjectNoOffset(objects[i].hash, objects[i].x, objects[i].y, objects[i].z, false, true, true)
			end
			SetEntityRotation(obj, objects[i].rot.x, objects[i].rot.y, objects[i].rot.z, 2, 0)
			if objects[i].hash == 73742208 or objects[i].hash == -977919647 or objects[i].hash == -1081534242 or objects[i].hash == 1243328051 then
				FreezeEntityPosition(obj, false)
			else
				FreezeEntityPosition(obj, true)
			end
			if speedUpObjects[objects[i].hash] then
				SetObjectStuntPropSpeedup(obj, 100)
				SetObjectStuntPropDuration(obj, 0.5)
			end
			if slowDownObjects[objects[i].hash] then
				SetObjectStuntPropSpeedup(obj, 16)
			end
			if objects[i].prpclr ~= nil then
				SetObjectTextureVariant(obj, objects[i].prpclr)
			end
			if objects[i].invisible then
				SetEntityVisible(obj, false)
			else
				if objects[i].dist ~= nil then
					if objects[i].dist == 1 then
						SetEntityVisible(obj, false)
					else
						SetEntityLodDist(obj, objects[i].dist == 0 and 16960 or objects[i].dist)
					end
				else
					SetEntityLodDist(obj, 16960)
				end
			end
			SetEntityCollision(obj, objects[i].collision, objects[i].collision)
			if objects[i].hash == GetHashKey("ind_prop_firework_01") or objects[i].hash == GetHashKey("ind_prop_firework_02") or objects[i].hash == GetHashKey("ind_prop_firework_03") or objects[i].hash == GetHashKey("ind_prop_firework_04") then
				objects[i].handle = obj
				fireworkObjects[#fireworkObjects + 1] = objects[i]
			end
			loadedObjects[iTotal] = obj
		else
			invalidObjects[objects[i].hash] = true
		end
	end
	for i = 1, #dobjects do
		if IsModelInCdimage(dobjects[i].hash) and IsModelValid(dobjects[i].hash) then
			iTotal = iTotal + 1
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "] (" .. math.floor(iTotal * 100 / totalObjects) .. "%)")
			EndTextCommandBusyString(2)
			RequestModel(dobjects[i].hash)
			while not HasModelLoaded(dobjects[i].hash) do
				Citizen.Wait(0)
			end
			local dobj = CreateObjectNoOffset(dobjects[i].hash, dobjects[i].x, dobjects[i].y, dobjects[i].z, false, true, false)
			-- Create object of door type
			-- https://docs.fivem.net/natives/?_0x9A294B2138ABB884
			if dobj == 0 then
				dobj = CreateObjectNoOffset(dobjects[i].hash, dobjects[i].x, dobjects[i].y, dobjects[i].z, false, true, true)
			end
			SetEntityRotation(dobj, dobjects[i].rot.x, dobjects[i].rot.y, dobjects[i].rot.z, 2, 0)
			if speedUpObjects[dobjects[i].hash] then
				SetObjectStuntPropSpeedup(dobj, 100)
				SetObjectStuntPropDuration(dobj, 0.5)
			end
			if slowDownObjects[dobjects[i].hash] then
				SetObjectStuntPropSpeedup(dobj, 16)
			end
			if dobjects[i].prpdclr ~= nil then
				SetObjectTextureVariant(dobj, dobjects[i].prpdclr)
			end
			SetEntityLodDist(dobj, 16960)
			SetEntityCollision(dobj, dobjects[i].collision, dobjects[i].collision)
			if arenaObjects[dobjects[i].hash] then
				dobjects[i].handle = dobj
				arenaProp[#arenaProp + 1] = dobjects[i]
			end
			if dobjects[i].hash == GetHashKey("ind_prop_firework_01") or dobjects[i].hash == GetHashKey("ind_prop_firework_02") or dobjects[i].hash == GetHashKey("ind_prop_firework_03") or dobjects[i].hash == GetHashKey("ind_prop_firework_04") then
				dobjects[i].handle = dobj
				fireworkObjects[#fireworkObjects + 1] = dobjects[i]
			end
			loadedObjects[iTotal] = dobj
		else
			invalidObjects[dobjects[i].hash] = true
		end
	end
	for k, v in pairs(invalidObjects) do
		print("model (" .. k .. ") does not exist or is invalid!")
	end
	if Count(invalidObjects) > 0 then
		print("Ask the server owner to stream invalid models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end
	RemoveLoadingPrompt()
	isLoadingObjects = false
end)

RegisterNetEvent("custom_races:client:startRaceRoom", function(_gridPositionIndex, _vehicle)
	if GetResourceState("spawnmanager") == "started" and exports.spawnmanager and exports.spawnmanager.setAutoSpawn then
		exports.spawnmanager:setAutoSpawn(false)
	end
	gridPositionIndex = _gridPositionIndex
	local ped = PlayerPedId()
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
	Citizen.Wait(3000)
	SetEntityCoords(ped, track.gridPositions[1].x, track.gridPositions[1].y, track.gridPositions[1].z)
	SetEntityHeading(ped, track.gridPositions[1].heading)
	SwitchInPlayer(ped)
	Citizen.Wait(1000)
	if DoesEntityExist(joinRaceVehicle) then
		SetEntityVisible(joinRaceVehicle, false)
		SetEntityCollision(joinRaceVehicle, false, false)
		FreezeEntityPosition(joinRaceVehicle, true)
	end
	Citizen.Wait(1000)
	StopScreenEffect("MenuMGIn")
	if roomData.vehicle ~= "default" or (roomData.vehicle == "default" and (type(raceVehicle) == "table" and not raceVehicle.model)) then
		raceVehicle = _vehicle
	end
	if tonumber(raceVehicle) then
		syncData.vehicle = GetDisplayNameFromVehicleModel(raceVehicle) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(raceVehicle) or "Unknown"
	elseif raceVehicle then
		syncData.vehicle = raceVehicle.model and GetDisplayNameFromVehicleModel(raceVehicle.model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(raceVehicle.model) or "Unknown"
	end
	Citizen.CreateThread(function()
		JoinRace()
		StartSyncDataToServer()
		SendNUIMessage({
			action = "nui_msg:hideLoad"
		})
		Citizen.Wait(1000)
		SendNUIMessage({
			action = "nui_msg:showRaceInfo",
			racename = track.trackName
		})
		while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
		enableXboxController = false
	end)
	Citizen.Wait(5000)
	if DoesEntityExist(lastVehicle) then
		FreezeEntityPosition(lastVehicle, false)
		SetVehicleEngineOn(lastVehicle, true, true, true)
	end
	StartRace()
end)

RegisterNetEvent("custom_races:client:syncDrivers", function(_drivers, _gameTimer)
	if not timeServerSide["syncDrivers"] or timeServerSide["syncDrivers"] < _gameTimer then
		timeServerSide["syncDrivers"] = _gameTimer
		local copy_drivers = {}
		for k, v in pairs(_drivers) do
			copy_drivers[v[1]] = {
				playerId = v[1],
				playerName = v[2],
				fps = v[3],
				actualLap = v[4],
				actualCheckpoint = v[5],
				vehicle = v[6],
				lastlap = v[7],
				bestlap = v[8],
				totalRaceTime = v[9],
				totalCheckpointsTouched = v[10],
				lastCheckpointPair = v[11],
				hasFinished = v[12],
				currentCoords = v[13],
				finishCoords = v[14],
				dnf = v[15]
			}
		end
		drivers = copy_drivers
	end
end)

RegisterNetEvent("custom_races:client:playerJoinRace", function(playerName)
	SendNUIMessage({
		action = "nui_msg:showNotification",
		message = playerName .. GetTranslate("msg-join-race")
	})
end)

RegisterNetEvent("custom_races:client:playerLeaveRace", function(playerName, bool)
	SendNUIMessage({
		action = "nui_msg:showNotification",
		message = playerName .. (bool and GetTranslate("msg-left-race") or GetTranslate("msg-drop-server"))
	})
end)

RegisterNetEvent("custom_races:client:startDNFCountdown", function(roomId)
	SendNUIMessage({
		action = "nui_msg:startDNFCountdown",
		endtime = Config.DNFCountdownTime
	})
	Citizen.Wait(Config.DNFCountdownTime)
	if status == "racing" and roomId == roomServerId then
		FinishRace("dnf")
	end
end)

RegisterNetEvent("custom_races:client:enableSpecMode", function(raceStatus)
	Citizen.Wait(1000)
	if status ~= "waiting" then return end
	status = "spectating"
	TriggerEvent('custom_races:startSpectating')
	TriggerServerEvent("custom_core:server:inSpectator", true)
	local playersToSpectate = {}
	local myServerId = GetPlayerServerId(PlayerId())
	local actionFromUser = (raceStatus == "spectator") and true or false
	local isScreenFadeOut = false
	Citizen.CreateThread(function()
		while status == "spectating" do
			playersToSpectate = {}
			local _drivers = drivers
			local driversInfo = UpdateDriversInfo(_drivers)
			for _, driver in pairs(_drivers) do
				if not driver.hasFinished and driver.playerId ~= myServerId then
					driver.position = GetPlayerPosition(driversInfo, driver.playerId)
					table.insert(playersToSpectate, driver)
				end
			end
			table.sort(playersToSpectate, function(a, b)
				return a.position < b.position
			end)
			if #playersToSpectate > 0 then
				local canPlaySound = false
				if lastspectatePlayerId then
					for k, v in pairs(playersToSpectate) do
						if lastspectatePlayerId == v.playerId then
							spectatingPlayerIndex = k
							break
						end
					end
					if pedToSpectate and not DoesEntityExist(pedToSpectate) then
						lastspectatePlayerId = nil
					end
				end
				if playersToSpectate[spectatingPlayerIndex] == nil then
					spectatingPlayerIndex = 1
				end
				if lastspectatePlayerId ~= playersToSpectate[spectatingPlayerIndex].playerId then
					DoScreenFadeOut(500)
					isScreenFadeOut = true
					Citizen.Wait(500)
					canPlaySound = true
					lastspectatePlayerId = playersToSpectate[spectatingPlayerIndex].playerId
					pedToSpectate = nil
					TriggerServerEvent('custom_races:server:spectatePlayer', lastspectatePlayerId, actionFromUser)
					actionFromUser = false
				end
				local pedInSpectatorMode = PlayerPedId()
				SetEntityCoordsNoOffset(pedInSpectatorMode, playersToSpectate[spectatingPlayerIndex].currentCoords + vector3(0.0, 0.0, 50.0))
				if not pedToSpectate or not NetworkIsInSpectatorMode() then
					pedToSpectate = lastspectatePlayerId and GetPlayerPed(GetPlayerFromServerId(lastspectatePlayerId))
					if pedToSpectate and DoesEntityExist(pedToSpectate) and (pedToSpectate ~= pedInSpectatorMode) then
						RemoveFinishCamera()
						NetworkSetInSpectatorMode(true, pedToSpectate)
						SetMinimapInSpectatorMode(true, pedToSpectate)
						DoScreenFadeIn(500)
						isScreenFadeOut = false
					else
						pedToSpectate = nil
					end
				end
				local playersPerPage = 10
				local currentPage = math.floor((spectatingPlayerIndex - 1) / playersPerPage) + 1
				local startIdx = (currentPage - 1) * playersPerPage + 1
				local endIdx = math.min(startIdx + playersPerPage - 1, #playersToSpectate)
				local playersToSpectate_show = {}
				for i = startIdx, endIdx do
					table.insert(playersToSpectate_show, playersToSpectate[i])
				end
				SendNUIMessage({
					action = "nui_msg:showSpectate",
					players = playersToSpectate_show,
					playerid = lastspectatePlayerId,
					sound = canPlaySound
				})
			else
				break
			end
			Citizen.Wait(500)
		end
		NetworkSetInSpectatorMode(false)
		SetMinimapInSpectatorMode(false)
		spectatingPlayerIndex = 0
		lastspectatePlayerId = nil
		pedToSpectate = nil
		SendNUIMessage({
			action = "nui_msg:hideSpectate"
		})
		if isScreenFadeOut then
			DoScreenFadeIn(500)
		end
		TriggerEvent('custom_races:stopSpectating')
		TriggerServerEvent("custom_core:server:inSpectator", false)
	end)
	Citizen.CreateThread(function()
		local last_totalCheckpointsTouched_spectate = nil
		local last_actualCheckpoint_spectate = nil
		local copy_lastspectatePlayerId = nil
		while status == "spectating" do
			HideHudComponentThisFrame(2)
			HideHudComponentThisFrame(14)
			HideHudComponentThisFrame(19)
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 26, true)
			DisableControlAction(2, 32, true) -- W
			DisableControlAction(2, 33, true) -- S
			DisableControlAction(2, 34, true) -- A
			DisableControlAction(2, 35, true) -- D
			DisableControlAction(2, 37, true) -- TAB
			DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
			DisableControlAction(0, 80, true) -- VEH_CIN_CAM
			if not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
				DrawScaleformMovieFullscreen(SetupScaleform("instructional_buttons"))
			end
			if IsControlJustPressed(0, 202) --[[Esc/Backspace/B]] then
				ExecuteCommand("quit_race")
			end
			if #playersToSpectate >= 2 then
				if IsControlJustPressed(0, 172) --[[Up Arrow]] then
					spectatingPlayerIndex = spectatingPlayerIndex -1
					if spectatingPlayerIndex < 1 or spectatingPlayerIndex > #playersToSpectate then
						spectatingPlayerIndex = #playersToSpectate
					end
					lastspectatePlayerId = nil
					actionFromUser = true
				end
				if IsControlJustPressed(0, 173) --[[Down Arrow]] then
					spectatingPlayerIndex = spectatingPlayerIndex + 1
					if spectatingPlayerIndex > #playersToSpectate then
						spectatingPlayerIndex = 1
					end
					lastspectatePlayerId = nil
					actionFromUser= true
				end
			end
			if #playersToSpectate > 0 then
				local driverInfo_spectate = lastspectatePlayerId and drivers[lastspectatePlayerId] or nil
				if lastspectatePlayerId and driverInfo_spectate then
					local totalCheckpointsTouched_spectate = driverInfo_spectate.totalCheckpointsTouched
					local actualCheckpoint_spectate = driverInfo_spectate.actualCheckpoint
					local nextCheckpoint_spectate = driverInfo_spectate.actualCheckpoint + 1
					local actualLap_spectate = driverInfo_spectate.actualLap
					local finishLine_spectate = false
					if actualCheckpoint_spectate == #track.checkpoints and actualLap_spectate == laps then
						finishLine_spectate = true
					else
						finishLine_spectate = false
					end
					-- Draw the actualBlip_spectate / nextBlip_spectate and play sound in spectator mode
					if last_totalCheckpointsTouched_spectate ~= totalCheckpointsTouched_spectate then
						last_totalCheckpointsTouched_spectate = totalCheckpointsTouched_spectate
						if copy_lastspectatePlayerId == lastspectatePlayerId and (actualCheckpoint_spectate > last_actualCheckpoint_spectate) then
							PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
						end
						DeleteCheckpoint(actualCheckpoint_spectate_draw)
						DeleteCheckpoint(actualCheckpoint_spectate_pair_draw)
						actualCheckpoint_spectate_draw = nil
						actualCheckpoint_spectate_pair_draw = nil
						RemoveBlip(actualBlip_spectate)
						RemoveBlip(nextBlip_spectate)
						RemoveBlip(actualBlip_spectate_pair)
						RemoveBlip(nextBlip_spectate_pair)
						if actualCheckpoint_spectate == #track.checkpoints then
							if actualLap_spectate < laps then
								actualBlip_spectate = CreateBlipForRace(actualCheckpoint_spectate, 58, false, false, true)
								if track.checkpoints[actualCheckpoint_spectate].hasPair then
									actualBlip_spectate_pair = CreateBlipForRace(actualCheckpoint_spectate, 58, false, true, true)
								end
							else
								actualBlip_spectate = CreateBlipForRace(actualCheckpoint_spectate, 38, false, false, true)
								if track.checkpoints[actualCheckpoint_spectate].hasPair then
									actualBlip_spectate_pair = CreateBlipForRace(actualCheckpoint_spectate, 38, false, true, true)
								end
							end
						else
							actualBlip_spectate = CreateBlipForRace(actualCheckpoint_spectate, 1, false, false)
							if track.checkpoints[actualCheckpoint_spectate].hasPair then
								actualBlip_spectate_pair = CreateBlipForRace(actualCheckpoint_spectate, 1, false, true)
							end
						end
						if nextCheckpoint_spectate > #track.checkpoints then
							if actualLap_spectate < laps then
								nextBlip_spectate = CreateBlipForRace(1, 1, true, false)
								if track.checkpoints[1].hasPair then
									nextBlip_spectate_pair = CreateBlipForRace(1, 1, true, true)
								end
							else
								RemoveBlip(nextBlip_spectate)
								RemoveBlip(nextBlip_spectate_pair)
							end
						elseif nextCheckpoint_spectate == #track.checkpoints then
							if actualLap_spectate < laps then
								nextBlip_spectate = CreateBlipForRace(nextCheckpoint_spectate, 58, true, false, true)
								if track.checkpoints[nextCheckpoint_spectate].hasPair then
									nextBlip_spectate_pair = CreateBlipForRace(nextCheckpoint_spectate, 58, true, true, true)
								end
							else
								nextBlip_spectate = CreateBlipForRace(nextCheckpoint_spectate, 38, true, false, true)
								if track.checkpoints[nextCheckpoint_spectate].hasPair then
									nextBlip_spectate_pair = CreateBlipForRace(nextCheckpoint_spectate, 38, true, true, true)
								end
							end
						else
							nextBlip_spectate = CreateBlipForRace(nextCheckpoint_spectate, 1, true, false)
							if track.checkpoints[nextCheckpoint_spectate].hasPair then
								nextBlip_spectate_pair = CreateBlipForRace(nextCheckpoint_spectate, 1, true, true)
							end
						end
					end
					last_actualCheckpoint_spectate = actualCheckpoint_spectate
					copy_lastspectatePlayerId = lastspectatePlayerId
					-- Draw the primary checkpoint_spectate and secondary checkpoint_spectate in spectator mode
					DrawCheckpointForRace(finishLine_spectate, actualCheckpoint_spectate, false)
					DrawCheckpointForRace(finishLine_spectate, actualCheckpoint_spectate, true)
				end
			else
				break
			end
			Citizen.Wait(0)
		end
		DeleteCheckpoint(actualCheckpoint_spectate_draw)
		DeleteCheckpoint(actualCheckpoint_spectate_pair_draw)
		actualCheckpoint_spectate_draw = nil
		actualCheckpoint_spectate_pair_draw = nil
		RemoveBlip(actualBlip_spectate)
		RemoveBlip(nextBlip_spectate)
		RemoveBlip(actualBlip_spectate_pair)
		RemoveBlip(nextBlip_spectate_pair)
	end)
end)

RegisterNetEvent('custom_races:client:whoSpectateWho', function(playerName_A, playerName_B)
	if playerName_A and playerName_B then
		DisplayCustomMsgs("~HUD_COLOUR_GREEN~" .. playerName_A .. "~s~" .. GetTranslate("msg-spectate") .. "~HUD_COLOUR_YELLOW~" .. playerName_B .. "~s~", false, nil)
	end
end)

RegisterNetEvent('custom_races:client:syncParticleFx', function(playerId, r, g, b)
	Citizen.Wait(100)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
	if playerPed and playerPed ~= 0 and playerPed ~= PlayerPedId() then
		PlayTransformEffectAndSound(playerPed, r, g, b)
	end
end)

RegisterNetEvent("custom_races:client:showFinalResult", function()
	if status == "leaving" then return end
	status = "ending"
	EndRace()
end)

local isRaceLocked = false
RegisterCommand('open_race', function()
	if isRaceLocked then return end
	if status == "freemode" and not isCreatorEnable and not enableXboxController and not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
		enableXboxController = true
		XboxControlSimulation()
		LoopGetNUIFramerateMoveFix()
		TriggerServerCallback("custom_races:server:permission", function(bool, newData)
			if newData then
				races_data_front = newData
				dataOutdated = false
				needRefreshTag = true
			end
			if bool then
				cooldownTime = nil
				if not isCreatorEnable then
					SendNUIMessage({
						action = "nui_msg:openMenu",
						races_data_front = races_data_front,
						isInRace = false,
						needRefresh = needRefreshTag
					})
					needRefreshTag = false
				else
					enableXboxController = false
				end
			else
				if not cooldownTime or (GetGameTimer() - cooldownTime > 1000 * 60 * 10) then
					cooldownTime = GetGameTimer()
					if not isCreatorEnable then
						SendNUIMessage({
							action = "nui_msg:openMenu",
							races_data_front = races_data_front,
							isInRace = false,
							needRefresh = needRefreshTag
						})
						needRefreshTag = false
					else
						enableXboxController = false
					end
				else
					SendNUIMessage({
						action = "nui_msg:showNotification",
						message = string.format(GetTranslate("msg-open-menu"), (1000 * 60 * 10 - ((GetGameTimer() - cooldownTime))) / 1000)
					})
					enableXboxController = false
				end
			end
		end, dataOutdated)
	end
end)

RegisterCommand('check_invitation', function()
	if isRaceLocked then return end
	if status == "freemode" and not isCreatorEnable and not enableXboxController and not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
		enableXboxController = true
		XboxControlSimulation()
		LoopGetNUIFramerateMoveFix()
		Citizen.Wait(200)
		if not isCreatorEnable then
			SendNUIMessage({
				action = "nui_msg:openInvitations"
			})
		else
			enableXboxController = false
		end
	end
end)

RegisterCommand('quit_race', function()
	if isRaceLocked then return end
	if (status == "racing" or status == "spectating" ) and not isCreatorEnable and not enableXboxController and not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
		enableXboxController = true
		XboxControlSimulation()
		LoopGetNUIFramerateMoveFix()
		Citizen.Wait(200)
		if not isCreatorEnable then
			SendNUIMessage({
				action = "nui_msg:openMenu",
				races_data_front = races_data_front,
				isInRace = true,
				needRefresh = dataOutdated
			})
		else
			enableXboxController = false
		end
	end
end)

exports('lockRace', function()
	isRaceLocked = true
end)

exports('unlockRace', function()
	isRaceLocked = false
end)

exports('setWeather', function(weather)
	weatherAndTime.weather = weather
end)

exports('setTime', function(hour, minute, second)
	weatherAndTime.hour = hour
	weatherAndTime.minute = minute
	weatherAndTime.second = second
end)

--- Teleport to the previous checkpoint
tpp = function()
	if status == "racing" and not isRespawningInProgress and not isTransformingInProgress then
		isTeleportingInProgress = true
		local bool = TeleportToPreviousCheckpoint()
		if bool then
			SendNUIMessage({
				action = "nui_msg:showNotification",
				message = GetTranslate("msg-tpp")
			})
			SetGameplayCamRelativeHeading(0)
		end
		isTeleportingInProgress = false
	end
end

--- Teleport to the next checkpoint
tpn = function()
	if status == "racing" and not isRespawningInProgress and not isTransformingInProgress then
		isTeleportingInProgress = true
		hasCheated = true
		local ped = PlayerPedId()
		if lastCheckpointPair == 1 and track.checkpoints[actualCheckpoint].hasPair then
			if IsPedInAnyVehicle(ped) then
				SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint].pair_x, track.checkpoints[actualCheckpoint].pair_y, track.checkpoints[actualCheckpoint].pair_z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint].pair_heading)
			else
				SetEntityCoords(ped, track.checkpoints[actualCheckpoint].pair_x, track.checkpoints[actualCheckpoint].pair_y, track.checkpoints[actualCheckpoint].pair_z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(ped, track.checkpoints[actualCheckpoint].pair_heading)
			end
		else
			if IsPedInAnyVehicle(ped) then
				SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint].x, track.checkpoints[actualCheckpoint].y, track.checkpoints[actualCheckpoint].z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckpoint].heading)
			else
				SetEntityCoords(ped, track.checkpoints[actualCheckpoint].x, track.checkpoints[actualCheckpoint].y, track.checkpoints[actualCheckpoint].z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(ped, track.checkpoints[actualCheckpoint].heading)
			end
		end
		SendNUIMessage({
			action = "nui_msg:showNotification",
			message = GetTranslate("msg-tpn")
		})
		SetGameplayCamRelativeHeading(0)
		isTeleportingInProgress = false
	end
end

AddEventHandler('custom_races:tpp', function()
	tpp()
end)

AddEventHandler('custom_races:tpn', function()
	tpn()
end)

AddEventHandler('custom_creator:load', function()
	isCreatorEnable = true
end)

AddEventHandler('custom_creator:unload', function()
	isCreatorEnable = false
end)