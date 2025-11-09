StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
StatSetInt(`MP0_STEALTH_ABILITY`, 100, true)
StatSetInt(`MP0_FLYING_ABILITY`, 100, true)
StatSetInt(`MP0_WHEELIE_ABILITY`, 100, true)
StatSetInt(`MP0_LUNG_CAPACITY`, 100, true)
StatSetInt(`MP0_STRENGTH`, 100, true)
StatSetInt(`MP0_STAMINA`, 100, true)

inRoom = false
inVehicleUI = false
status = ""
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
local isSyncLocked = false
local lastspectatePlayerId = nil
local pedToSpectate = nil
local spectatingPlayerIndex = 0
local totalCheckpointsTouched = 0
local actualCheckpoint = 0
local lastCheckpointPair = 0 -- 0 = primary / 1 = secondary
local actualLap = 0
local startLapTime = 0
local actualLapTime = 0
local totalTimeStart = 0
local totalRaceTime = 0
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
	lastCheckpointPair = 0
	actualLap = 1
	isRespawningInProgress = true
	RespawnVehicle(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, track.gridPositions[gridPositionIndex].heading, false)
	isRespawningInProgress = false
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)
	CreateBlipForRace(actualCheckpoint, actualCheckpoint == #track.checkpoints, actualCheckpoint == #track.checkpoints and actualLap == laps)
	CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #track.checkpoints and actualLap == laps)
	CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #track.checkpoints and actualLap == laps)
	allVehModels = GetAllVehicleModels()
	ClearAreaLeaveVehicleHealth(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, 100000000000000000000000.0, false, false, false, false, false)
	RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_01", false, -1)
	RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_02", false, -1)
end

function StartRace()
	status = "racing"
	if track.mode == "gta" then
		GiveWeapons(PlayerPedId())
	end
	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "nui_msg:showRaceHud",
			showCurrentLap = laps > 1
		})
		local wasJumping = false
		local wasOnFoot = false
		local wasJumped = false
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
			local pos = GetEntityCoords(ped)
			local vehicle = GetVehiclePedIsIn(ped, false)
			local vehicle_r, vehicle_g, vehicle_b = nil, nil, nil
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
				vehicle_r, vehicle_g, vehicle_b = GetVehicleColor(vehicle)
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
			if transformIsBeast then
				SetSuperJumpThisFrame(PlayerId())
				SetBeastModeActive(PlayerId())
				local isJumping = IsPedDoingBeastJump(ped)
				local isOnFoot = not IsPedFalling(ped)
				if isJumping and not wasJumping then
					wasJumped = true
					PlaySoundFromEntity(-1, "Beast_Jump", ped, "DLC_AR_Beast_Soundset", true, 60)
				end
				if isOnFoot and not wasOnFoot and wasJumped then
					wasJumped = false
					PlaySoundFromEntity(-1, "Beast_Jump_Land", ped, "DLC_AR_Beast_Soundset", true, 60)
				end
				wasJumping = isJumping
				wasOnFoot = isOnFoot
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
				DisableControlAction(0, 24, true)
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
			local checkpoint = track.checkpoints[actualCheckpoint]
			local checkpoint_2 = track.checkpoints_2[actualCheckpoint]
			local checkpoint_next = not (actualCheckpoint == #track.checkpoints and actualLap == laps) and (track.checkpoints[actualCheckpoint + 1] or track.checkpoints[1])
			local checkpoint_2_next = not (actualCheckpoint == #track.checkpoints and actualLap == laps) and (track.checkpoints_2[actualCheckpoint + 1] or track.checkpoints_2[1])

			local checkpoint_coords = nil
			local collect_size = nil
			local checkpoint_radius = nil
			local _checkpoint_coords = nil
			local checkpoint_slow = false
			if checkpoint then
				checkpoint_coords = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
				collect_size = ((checkpoint.is_air and (4.5 * checkpoint.d_collect)) or ((checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) and (2.25 * checkpoint.d_collect)) or checkpoint.d_collect) * 10
				checkpoint_radius = collect_size / 2
				_checkpoint_coords = checkpoint_coords
				if actualCheckpoint == #track.checkpoints and actualLap == laps then
					if checkpoint.is_round then
						if not checkpoint.is_air then
							_checkpoint_coords = checkpoint_coords + vector3(0, 0, checkpoint_radius)
						end
					else
						_checkpoint_coords = checkpoint_coords + vector3(0, 0, checkpoint_radius)
					end
				else
					if checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp then
						if not checkpoint.is_air then
							_checkpoint_coords = checkpoint_coords + vector3(0, 0, checkpoint_radius)
						end
					else
						_checkpoint_coords = checkpoint_coords + vector3(0, 0, checkpoint_radius)
					end
				end
				if checkpoint.is_planeRot and checkpoint.draw_id then
					if vehicle ~= 0 and GetVehicleCanSlowDown(checkpoint, vehicle) then
						local r, g, b = GetHudColour(6)
						SetCheckpointRgba2(checkpoint.draw_id, r, g, b, 150)
						checkpoint_slow = true
					else
						local r, g, b = GetHudColour(134)
						SetCheckpointRgba2(checkpoint.draw_id, r, g, b, 150)
						checkpoint_slow = false
					end
				end
			end

			local checkpoint_2_coords = nil
			local collect_size_2 = nil
			local checkpoint_2_radius = nil
			local _checkpoint_2_coords = nil
			local checkpoint_2_slow = false
			if checkpoint_2 then
				checkpoint_2_coords = vector3(checkpoint_2.x, checkpoint_2.y, checkpoint_2.z)
				collect_size_2 = ((checkpoint_2.is_air and (4.5 * checkpoint_2.d_collect)) or ((checkpoint_2.is_round or checkpoint_2.is_random or checkpoint_2.is_transform or checkpoint_2.is_planeRot or checkpoint_2.is_warp) and (2.25 * checkpoint_2.d_collect)) or checkpoint_2.d_collect) * 10
				checkpoint_2_radius = collect_size_2 / 2
				_checkpoint_2_coords = checkpoint_2_coords
				if actualCheckpoint == #track.checkpoints and actualLap == laps then
					if checkpoint_2.is_round then
						if not checkpoint_2.is_air then
							_checkpoint_2_coords = checkpoint_2_coords + vector3(0, 0, checkpoint_2_radius)
						end
					else
						_checkpoint_2_coords = checkpoint_2_coords + vector3(0, 0, checkpoint_2_radius)
					end
				else
					if checkpoint_2.is_round or checkpoint_2.is_random or checkpoint_2.is_transform or checkpoint_2.is_planeRot or checkpoint_2.is_warp then
						if not checkpoint_2.is_air then
							_checkpoint_2_coords = checkpoint_2_coords + vector3(0, 0, checkpoint_2_radius)
						end
					else
						_checkpoint_2_coords = checkpoint_2_coords + vector3(0, 0, checkpoint_2_radius)
					end
				end
				if checkpoint_2.is_planeRot and checkpoint_2.draw_id then
					if vehicle ~= 0 and GetVehicleCanSlowDown(checkpoint_2, vehicle) then
						local r, g, b = GetHudColour(6)
						SetCheckpointRgba2(checkpoint_2.draw_id, r, g, b, 150)
						checkpoint_2_slow = true
					else
						local r, g, b = GetHudColour(134)
						SetCheckpointRgba2(checkpoint_2.draw_id, r, g, b, 150)
						checkpoint_2_slow = false
					end
				end
			end

			if checkpoint_coords and collect_size and checkpoint_radius and _checkpoint_coords and ((#(pos - checkpoint_coords) <= (checkpoint_radius * 2.0)) or (#(pos - _checkpoint_coords) <= (checkpoint_radius * 1.5))) and not isRespawningInProgress and not isTransformingInProgress and not isTeleportingInProgress then
				checkPointTouched = true
				lastCheckpointPair = 0
				local effect_1 = 0
				local effect_2 = 0
				if checkpoint.is_planeRot and vehicle ~= 0 then
					if checkpoint_slow then
						effect_1 = 2
						SlowVehicle(vehicle)
					else
						effect_1 = 1
					end
				end
				if checkpoint.is_warp and checkpoint_next then
					effect_2 = 1
					WarpVehicle(checkpoint_next, vehicle ~= 0 and vehicle or ped)
				end
				if (checkpoint.is_transform or checkpoint.is_random) then
					effect_2 = effect_2 == 0 and 2 or effect_2
					local speed = vehicle ~= 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
					local rotation = vehicle ~= 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
					local velocity = vehicle ~= 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
					TransformVehicle(checkpoint, speed, rotation, velocity)
				end
				PlayEffectAndSound(ped, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
				if not isSyncLocked then
					TriggerServerEvent("custom_races:server:syncParticleFx", effect_1, effect_2, r, g, b)
					isSyncLocked = true
					Citizen.CreateThread(function()
						Citizen.Wait(1000)
						isSyncLocked = false
					end)
				end
			elseif checkpoint_2_coords and collect_size_2 and checkpoint_2_radius and _checkpoint_2_coords and ((#(pos - checkpoint_2_coords) <= (checkpoint_2_radius * 2.0)) or (#(pos - _checkpoint_2_coords) <= (checkpoint_2_radius * 1.5))) and not isRespawningInProgress and not isTransformingInProgress and not isTeleportingInProgress then
				checkPointTouched = true
				lastCheckpointPair = 1
				local effect_1 = 0
				local effect_2 = 0
				if checkpoint_2.is_planeRot and vehicle ~= 0 then
					if checkpoint_2_slow then
						effect_1 = 2
						SlowVehicle(vehicle)
					else
						effect_1 = 1
					end
				end
				if checkpoint_2.is_warp and (checkpoint_2_next or checkpoint_next) then
					effect_2 = 1
					WarpVehicle(checkpoint_2_next or checkpoint_next, vehicle ~= 0 and vehicle or ped)
				end
				if (checkpoint_2.is_transform or checkpoint_2.is_random) then
					effect_2 = effect_2 == 0 and 2 or effect_2
					local speed = vehicle ~= 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
					local rotation = vehicle ~= 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
					local velocity = vehicle ~= 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
					TransformVehicle(checkpoint_2, speed, rotation, velocity)
				end
				PlayEffectAndSound(ped, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
				if not isSyncLocked then
					TriggerServerEvent("custom_races:server:syncParticleFx", effect_1, effect_2, r, g, b)
					isSyncLocked = true
					Citizen.CreateThread(function()
						Citizen.Wait(1000)
						isSyncLocked = false
					end)
				end
			end

			if checkPointTouched then
				totalCheckpointsTouched = totalCheckpointsTouched + 1
				syncData.lastCheckpointPair = lastCheckpointPair
				syncData.totalCheckpointsTouched = totalCheckpointsTouched
				if actualCheckpoint == #track.checkpoints then
					syncData.lastlap = actualLapTime
					if (syncData.bestlap == 0) or (syncData.bestlap > actualLapTime) then
						syncData.bestlap = actualLapTime
					end
					syncData.totalRaceTime = totalRaceTime
					if actualLap < laps then
						actualCheckpoint = 1
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
					actualCheckpoint = actualCheckpoint + 1
					syncData.actualCheckpoint = actualCheckpoint
				end
				ResetCheckpointAndBlipForRace()
				CreateBlipForRace(actualCheckpoint, actualCheckpoint == #track.checkpoints, actualCheckpoint == #track.checkpoints and actualLap == laps)
				CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #track.checkpoints and actualLap == laps)
				CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #track.checkpoints and actualLap == laps)
			end
			DrawBottomHUD()
			Citizen.Wait(0)
		end
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
						local checkpoint = v.lastCheckpointPair == 1 and track.checkpoints_2[v.actualCheckpoint] or track.checkpoints[v.actualCheckpoint] or vector3(0.0, 0.0, 0.0)
						_distance = RoundedValue(#(v.currentCoords - vector3(checkpoint.x, checkpoint.y, checkpoint.z)), 1) .. "m"
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
		local checkpoint = driver.lastCheckpointPair == 1 and track.checkpoints_2[driver.actualCheckpoint] or track.checkpoints[driver.actualCheckpoint] or vector3(0.0, 0.0, 0.0)
		driver.dist = #((driver.finishCoords or driver.currentCoords) - vector3(checkpoint.x, checkpoint.y, checkpoint.z))
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
			position = position .. "</span><span style='font-size: 4vh;margin-left: 9px;'>/ " .. Count(_drivers)
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

function ResetCheckpointAndBlipForRace()
	for i, checkpoint in ipairs(track.checkpoints) do
		if checkpoint.draw_id then
			DeleteCheckpoint(checkpoint.draw_id)
			checkpoint.draw_id = nil
		end
		if checkpoint.blip_id then
			RemoveBlip(checkpoint.blip_id)
			checkpoint.blip_id = nil
		end
		local checkpoint_2 = track.checkpoints_2[i]
		if checkpoint_2 then
			if checkpoint_2.draw_id then
				DeleteCheckpoint(checkpoint_2.draw_id)
				checkpoint_2.draw_id = nil
			end
			if checkpoint_2.blip_id then
				RemoveBlip(checkpoint_2.blip_id)
				checkpoint_2.blip_id = nil
			end
		end
	end
end

function CreateCheckpointForRace(index, pair, isFinishLine)
	local checkpoint = pair and track.checkpoints_2[index] or track.checkpoints[index]
	if not checkpoint then return end
	local checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(13)
	local checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
	local checkpointA_1, checkpointA_2 = 150, 150
	if not checkpoint.draw_id then
		local draw_size = checkpoint.is_restricted and (7.5 * 0.66) or (((checkpoint.is_air and (4.5 * checkpoint.d_draw)) or ((checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) and (2.25 * checkpoint.d_draw)) or checkpoint.d_draw) * 10)
		local checkpointNearHeight = checkpoint.is_lower and 6.0 or 9.5
		local checkpointFarHeight = checkpoint.is_tall and 250.0 or (checkpoint.is_lower and 6.0) or 9.5
		local checkpointRangeHeight = checkpoint.is_tall and checkpoint.tall_range or 100.0
		local drawHigher = false
		local updateZ = (checkpoint.is_round and (checkpoint.is_air and 0.0 or draw_size/2) or draw_size/2)
		local checkpoint_next = pair and (track.checkpoints_2[index + 1] or track.checkpoints[index + 1] or track.checkpoints_2[1] or track.checkpoints[1]) or (track.checkpoints[index + 1] or track.checkpoints[1])
		local checkpoint_prev = pair and (track.checkpoints_2[index - 1] or track.checkpoints[index - 1] or track.checkpoints_2[#track.checkpoints] or track.checkpoints[#track.checkpoints]) or (track.checkpoints[index - 1] or track.checkpoints[#track.checkpoints])
		local checkpointIcon = 6
		if isFinishLine then
			if checkpoint.is_round then
				checkpointIcon = 16
			else
				checkpointIcon = 10
			end
		elseif checkpoint.is_pit then
			checkpointIcon = 11
		elseif checkpoint.is_random then
			checkpointIcon = 56
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.is_transform then
			local vehicleHash = track.transformVehicles[checkpoint.transform_index + 1]
			local vehicleClass = GetVehicleClassFromName(vehicleHash)
			if vehicleHash == -422877666 then
				checkpointIcon = 64
			elseif vehicleHash == -731262150 then
				checkpointIcon = 55
			elseif vehicleClass >= 0 and vehicleClass <= 7 or vehicleClass >= 9 and vehicleClass <= 12 or vehicleClass == 17 or vehicleClass == 18 or vehicleClass == 22 then
				checkpointIcon = 60
			elseif vehicleClass == 8 then
				checkpointIcon = 61
			elseif vehicleClass == 13 then
				checkpointIcon = 62
			elseif vehicleClass == 14 then
				checkpointIcon = 59
			elseif vehicleClass == 15 then
				checkpointIcon = 58
			elseif vehicleClass == 16 then
				checkpointIcon = 57
			elseif vehicleClass == 20 then
				checkpointIcon = 63
			elseif vehicleClass == 19 then
				if vehicleHash == GetHashKey("thruster") then
					checkpointIcon = 65
				else
					checkpointIcon = 60
				end
			elseif vehicleClass == 21 then
				checkpointIcon = 60
			end
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.is_warp then
			checkpointIcon = 66
		elseif checkpoint.is_planeRot then
			if checkpoint.plane_rot == 0 then
				checkpointIcon = 37
			elseif checkpoint.plane_rot == 1 then
				checkpointIcon = 39
			elseif checkpoint.plane_rot == 2 then
				checkpointIcon = 40
			elseif checkpoint.plane_rot == 3 then
				checkpointIcon = 38
			end
			if checkpoint.is_planeRot then
				local ped = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(ped, false)
				if vehicle ~= 0 and GetVehicleCanSlowDown(checkpoint, vehicle) then
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(6)
				else
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
				end
			end
		else
			if checkpoint.is_round then
				checkpointIcon = 12
			else
				local diffPrev = vector3(checkpoint_prev.x, checkpoint_prev.y, checkpoint_prev.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
				local diffNext = vector3(checkpoint_next.x, checkpoint_next.y, checkpoint_next.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
				local checkpointAngle = GetAngleBetween_2dVectors(diffPrev.x, diffPrev.y, diffNext.x, diffNext.y)
				checkpointAngle = checkpointAngle > 180.0 and (360.0 - checkpointAngle) or checkpointAngle
				local foundGround, groundZ = GetGroundZExcludingObjectsFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false)
				if foundGround then
					if math.abs(groundZ - checkpoint.z) > 15.0 then
						drawHigher = true
						checkpointNearHeight = checkpointNearHeight - 4.5
						checkpointFarHeight = checkpointFarHeight - 4.5
						updateZ = 0.0
					end
				end
				if checkpointAngle < 80.0 then
					checkpointIcon = drawHigher == true and 2 or 8
				elseif checkpointAngle < 140.0 then
					checkpointIcon = drawHigher == true and 1 or 7
				elseif checkpointAngle <= 180.0 then
					checkpointIcon = drawHigher == true and 0 or 6
				end
			end
		end
		local hour = GetClockHours()
		if hour > 6 and hour < 20 and not (checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) then
			checkpointA_1 = 210
			checkpointA_2 = 180
		end
		local pos_1 = vector3(checkpoint.x, checkpoint.y, checkpoint.z + updateZ)
		local pos_2 = vector3(checkpoint_next.x, checkpoint_next.y, checkpoint_next.z)
		if not (checkpoint.offset.x == 0.0 and checkpoint.offset.y == 0.0 and checkpoint.offset.z == 0.0) then
			pos_2 = pos_1 + vector3(checkpoint.offset.x, checkpoint.offset.y, checkpoint.offset.z)
		end
		checkpoint.draw_id = CreateCheckpoint(
			checkpointIcon,
			pos_1.x, pos_1.y, pos_1.z,
			pos_2.x, pos_2.y, pos_2.z,
			draw_size, checkpointR_2, checkpointG_2, checkpointB_2, checkpointA_2, 0
		)
		if not isFinishLine and (checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) then
			if checkpoint.lock_dir then
				local dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
				local pos_3 = checkpoint.is_planeRot and (pos_1 - dirVec) or (pos_1 + dirVec)
				N_0xdb1ea9411c8911ec(checkpoint.draw_id) -- SET_CHECKPOINT_FORCE_DIRECTION
				N_0x3c788e7f6438754d(checkpoint.draw_id, pos_3.x, pos_3.y, pos_3.z) -- SET_CHECKPOINT_DIRECTION
			end
		else
			if drawHigher then
				SetCheckpointIconHeight(checkpoint.draw_id, 0.5) -- SET_CHECKPOINT_INSIDE_CYLINDER_HEIGHT_SCALE
			end
			if checkpoint.is_lower then
				SetCheckpointIconScale(checkpoint.draw_id, 0.85) -- SET_CHECKPOINT_INSIDE_CYLINDER_SCALE
			end
			SetCheckpointCylinderHeight(checkpoint.draw_id, checkpointNearHeight, checkpointFarHeight, checkpointRangeHeight)
		end
		SetCheckpointRgba(checkpoint.draw_id, checkpointR_1, checkpointG_1, checkpointB_1, checkpointA_1)
	end
end

function CreateBlipForRace(index, isLapEnd, isFinishLine)
	local function createData(checkpoint, isNext)
		local x, y, z = checkpoint.x, checkpoint.y, checkpoint.z
		local sprite = isFinishLine and 38 or (isLapEnd and 58) or (checkpoint.is_random and 66) or (checkpoint.is_transform and 570) or 1
		local scale = isNext and 0.65 or 0.9
		local alpha = (isNext or (not isFinishLine and checkpoint.low_alpha)) and 125 or 255
		local colour = sprite == 38 and 0 or (not isLapEnd and (checkpoint.is_random or checkpoint.is_transform) and 1) or 5
		local display = 6
		local name = (isLapEnd or isFinishLine) and GetTranslate("racing-blip-finishline") or GetTranslate("racing-blip-checkpoint")
		return {
			x = x,
			y = y,
			z = z,
			sprite = sprite,
			scale = scale,
			alpha = alpha,
			colour = colour,
			display = display,
			name = name
		}
	end
	local function createBlip(data)
		local blip = 0
		if data.x ~= nil and data.y ~= nil and data.z ~= nil then
			blip = AddBlipForCoord(data.x, data.y, data.z)
		end
		if data.sprite ~= nil then
			SetBlipSprite(blip, data.sprite)
		end
		if data.scale ~= nil then
			SetBlipScale(blip, data.scale)
		end
		if data.alpha ~= nil then
			SetBlipAlpha(blip, data.alpha)
		end
		if data.colour ~= nil then
			SetBlipColour(blip, data.colour)
		end
		if data.display ~= nil then
			SetBlipDisplay(blip, data.display)
		end
		if data.name ~= nil then
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(data.name)
			EndTextCommandSetBlipName(blip)
		end
		return blip
	end
	local checkpoint = track.checkpoints[index]
	if checkpoint then
		checkpoint.blip_id = createBlip(createData(checkpoint, false))
	end
	local checkpoint_2 = track.checkpoints_2[index]
	if checkpoint_2 then
		checkpoint_2.blip_id = createBlip(createData(checkpoint_2, false))
	end
	local checkpoint_next = not isFinishLine and (track.checkpoints[index + 1] or track.checkpoints[1])
	if checkpoint_next then
		checkpoint_next.blip_id = createBlip(createData(checkpoint_next, true))
	end
	local checkpoint_2_next = not isFinishLine and (track.checkpoints_2[index + 1] or track.checkpoints_2[1])
	if checkpoint_2_next then
		checkpoint_2_next.blip_id = createBlip(createData(checkpoint_2_next, true))
	end
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
			if track.checkpoints[actualCheckpoint - 1] == nil then
				if totalCheckpointsTouched ~= 0 then
					local index = #track.checkpoints
					local checkpoint = lastCheckpointPair == 1 and track.checkpoints_2[index] or track.checkpoints[index]
					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(checkpoint.x, checkpoint.y, checkpoint.z, checkpoint.heading, true, false) end
					RespawnVehicle(checkpoint.x, checkpoint.y, checkpoint.z, checkpoint.heading, true)
				else
					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
						NetworkResurrectLocalPlayer(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, track.gridPositions[gridPositionIndex].heading, true, false)
					end
					RespawnVehicle(track.gridPositions[gridPositionIndex].x, track.gridPositions[gridPositionIndex].y, track.gridPositions[gridPositionIndex].z, track.gridPositions[gridPositionIndex].heading, true)
				end
			else
				local index, reset = GetNonFakeCheckpoint(actualCheckpoint)
				if reset then
					ResetCheckpointAndBlipForRace()
					CreateBlipForRace(actualCheckpoint, actualCheckpoint == #track.checkpoints, actualCheckpoint == #track.checkpoints and actualLap == laps)
					CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #track.checkpoints and actualLap == laps)
					CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #track.checkpoints and actualLap == laps)
					-- Recording vehicles in checkpoints and checkpoints_2 seems like a good idea, todo
					local model = (transformIsParachute and -422877666) or (transformIsBeast and -731262150) or (transformedModel ~= "" and transformedModel) or 0
					if lastCheckpointPair == 1 and track.checkpoints_2[index] then
						for i = index, 1, -1 do
							local checkpoint_2 = track.checkpoints_2[i]
							if checkpoint_2 and checkpoint_2.is_transform then
								model = track.transformVehicles[checkpoint_2.transform_index + 1]
								break
							elseif checkpoint_2 and checkpoint_2.is_random then
								model = GetRandomVehicleModel(checkpoint_2.randomClass)
								break
							end
							model = 0
						end
					else
						for i = index, 1, -1 do
							local checkpoint = track.checkpoints[i]
							if checkpoint and checkpoint.is_transform then
								model = track.transformVehicles[checkpoint.transform_index + 1]
								break
							elseif checkpoint and checkpoint.is_random then
								model = GetRandomVehicleModel(checkpoint.randomClass)
								break
							end
							model = 0
						end
					end
					if model == -422877666 then
						syncData.vehicle = "parachute"
						DisplayCustomMsgs(GetTranslate("transform-parachute"), false, nil)
						transformedModel = ""
						transformIsParachute = true
						transformIsBeast = false
						SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
					elseif model == -731262150 then
						syncData.vehicle = "beast"
						DisplayCustomMsgs(GetTranslate("transform-beast"), false, nil)
						transformedModel = ""
						transformIsParachute = false
						transformIsBeast = true
						SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
					else
						if model == 0 then
							model = raceVehicle.model
							transformedModel = ""
						else
							if not IsModelInCdimage(model) or not IsModelValid(model) then
								if model then
									print("vehicle model (" .. model .. ") does not exist in current gta version! We have spawned a default vehicle for you")
								else
									print("Unknown error! We have spawned a default vehicle for you")
								end
								model = Config.ReplaceInvalidVehicle
							end
							transformedModel = model
						end
						transformIsParachute = false
						transformIsBeast = false
						SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
						syncData.vehicle = GetDisplayNameFromVehicleModel(model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(model) or "Unknown"
						DisplayCustomMsgs(GetLabelText(syncData.vehicle), false, nil)
					end
					syncData.totalCheckpointsTouched = totalCheckpointsTouched
					syncData.actualCheckpoint = actualCheckpoint
				end
				local checkpoint = lastCheckpointPair == 1 and track.checkpoints_2[index] or track.checkpoints[index]
				if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(checkpoint.x, checkpoint.y, checkpoint.z, checkpoint.heading, true, false) end
				RespawnVehicle(checkpoint.x, checkpoint.y, checkpoint.z, checkpoint.heading, true)
			end
			if track.mode == "gta" then
				GiveWeapons(ped)
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
		local checkpoint = track.checkpoints[i]
		local checkpoint_2 = track.checkpoints_2[i]
		if lastCheckpointPair == 1 and checkpoint_2 then
			if not checkpoint_2.is_fake and not checkpoint_2.is_planeRot then
				return i, reset
			else
				totalCheckpointsTouched = totalCheckpointsTouched - 1
				actualCheckpoint = actualCheckpoint - 1
				reset = true
			end
		else
			if not checkpoint.is_fake and not checkpoint.is_planeRot then
				return i, reset
			else
				totalCheckpointsTouched = totalCheckpointsTouched - 1
				actualCheckpoint = actualCheckpoint - 1
				reset = true
			end
		end
	end
	return 1, reset
end

function TeleportToPreviousCheckpoint()
	if actualCheckpoint - 2 <= 0 then return false end
	totalCheckpointsTouched = totalCheckpointsTouched - 1
	actualCheckpoint = actualCheckpoint - 1
	syncData.totalCheckpointsTouched = totalCheckpointsTouched
	syncData.actualCheckpoint = actualCheckpoint
	local ped = PlayerPedId()
	local checkpoint_prev = lastCheckpointPair == 1 and track.checkpoints_2[actualCheckpoint - 1] or track.checkpoints[actualCheckpoint - 1]
	if IsPedInAnyVehicle(ped) then
		SetEntityCoords(GetVehiclePedIsIn(ped, false), checkpoint_prev.x, checkpoint_prev.y, checkpoint_prev.z, 0.0, 0.0, 0.0, false)
		SetEntityHeading(GetVehiclePedIsIn(ped, false), checkpoint_prev.heading)
	else
		SetEntityCoords(ped, checkpoint_prev.x, checkpoint_prev.y, checkpoint_prev.z, 0.0, 0.0, 0.0, false)
		SetEntityHeading(ped, checkpoint_prev.heading)
	end
	PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
	ResetCheckpointAndBlipForRace()
	CreateBlipForRace(actualCheckpoint, actualCheckpoint == #track.checkpoints, actualCheckpoint == #track.checkpoints and actualLap == laps)
	CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #track.checkpoints and actualLap == laps)
	CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #track.checkpoints and actualLap == laps)
	return true
end

function RespawnVehicle(x, y, z, heading, engine)
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
		SetEntityCoords(ped, x, y, z)
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
		SetEntityCoords(ped, x, y, z)
		SetEntityHeading(ped, heading)
		SetGameplayCamRelativeHeading(0)
		return
	end
	local model = transformedModel ~= "" and transformedModel or (type(raceVehicle) == "number" and raceVehicle or (type(raceVehicle) == "table" and raceVehicle.model))
	local isHashValid = true
	if not IsModelInCdimage(model) or not IsModelValid(model) then
		if model then
			print("vehicle model (" .. model .. ") does not exist in current gta version! We have spawned a default vehicle for you")
		else
			print("Unknown error! We have spawned a default vehicle for you")
		end
		isHashValid = false
		model = Config.ReplaceInvalidVehicle
		syncData.vehicle = GetDisplayNameFromVehicleModel(model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(model) or "Unknown"
		DisplayCustomMsgs(GetLabelText(syncData.vehicle), false, nil)
	end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
	-- Spawn vehicle at the top of the player, fix OneSync culling
	local pos = GetEntityCoords(ped)
	local newVehicle = CreateVehicle(model, pos.x, pos.y, pos.z + 50.0, heading, true, false)
	local vehNetId = NetworkGetNetworkIdFromEntity(newVehicle)
	TriggerServerEvent("custom_races:server:spawnVehicle", vehNetId)
	SetModelAsNoLongerNeeded(model)
	FreezeEntityPosition(newVehicle, true)
	SetEntityCollision(newVehicle, false, false)
	SetVehRadioStation(newVehicle, "OFF")
	SetVehicleDoorsLocked(newVehicle, 10)
	SetVehicleColourCombination(newVehicle, 0)
	if type(raceVehicle) == "number" or not isHashValid then
		raceVehicle = GetVehicleProperties(newVehicle)
	else
		SetVehicleProperties(newVehicle, raceVehicle)
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
	SetEntityCoords(newVehicle, x, y, z)
	SetEntityHeading(newVehicle, heading)
	SetPedIntoVehicle(ped, newVehicle, -1)
	SetEntityCollision(newVehicle, true, true)
	SetVehicleFuelLevel(newVehicle, 100.0)
	SetVehicleDirtLevel(newVehicle, 0.0)
	SetVehicleEngineOn(newVehicle, engine, true, false)
	SetGameplayCamRelativeHeading(0)
	Citizen.Wait(0)
	if engine then
		FreezeEntityPosition(newVehicle, false)
		ActivatePhysics(newVehicle)
	end
	if IsThisModelAPlane(model) or IsThisModelAHeli(model) then
		ControlLandingGear(newVehicle, 3)
		SetHeliBladesSpeed(newVehicle, 1.0)
		SetHeliBladesFullSpeed(newVehicle)
		SetVehicleForwardSpeed(newVehicle, 30.0)
	end
	if model == GetHashKey("avenger") or model == GetHashKey("hydra") then
		SetVehicleFlightNozzlePositionImmediate(newVehicle, 0.0)
	end
	lastVehicle = newVehicle
	if track.mode ~= "no_collision" then
		if track.mode == "gta" then
			SetVehicleDoorsLocked(newVehicle, 0)
		end
		Citizen.CreateThread(function()
			Citizen.Wait(500)
			local myServerId = GetPlayerServerId(PlayerId())
			while not isRespawningInProgress and (status == "ready" or status == "racing") do
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

function TransformVehicle(checkpoint, speed, rotation, velocity)
	isTransformingInProgress = true
	Citizen.CreateThread(function()
		local model = 0
		if checkpoint.is_random then
			model = GetRandomVehicleModel(checkpoint.randomClass)
		else
			model = track.transformVehicles[checkpoint.transform_index + 1]
		end
		local ped = PlayerPedId()
		local copyVelocity = true
		if transformIsParachute or transformIsBeast then
			copyVelocity = ((math.abs(velocity.x) > 0.0) or (math.abs(velocity.y) > 0.0) or (math.abs(velocity.z) > 0.0)) and true or false
			speed = speed > 0.03 and speed or 30.0
		end
		if model == -422877666 then
			-- Parachute
			if DoesEntityExist(lastVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
				DeleteEntity(lastVehicle)
				TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
			end
			syncData.vehicle = "parachute"
			DisplayCustomMsgs(GetTranslate("transform-parachute"), false, nil)
			GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			transformedModel = ""
			transformIsParachute = true
			transformIsBeast = false
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			isTransformingInProgress = false
			return
		elseif model == -731262150 then
			-- Beast mode
			if DoesEntityExist(lastVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
				DeleteEntity(lastVehicle)
				TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
			end
			syncData.vehicle = "beast"
			DisplayCustomMsgs(GetTranslate("transform-beast"), false, nil)
			RemoveAllPedWeapons(ped, false)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			transformedModel = ""
			transformIsParachute = false
			transformIsBeast = true
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
			if track.mode == "gta" then
				GiveWeapons(ped)
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
			end
			isTransformingInProgress = false
			return
		end
		if model == 0 then
			-- Transform vehicle to the start vehicle
			model = raceVehicle.model
			transformedModel = ""
		else
			if not IsModelInCdimage(model) or not IsModelValid(model) then
				if model then
					print("vehicle model (" .. model .. ") does not exist in current gta version! We have spawned a default vehicle for you")
				else
					print("Unknown error! We have spawned a default vehicle for you")
				end
				model = Config.ReplaceInvalidVehicle
			end
			transformedModel = model
		end
		transformIsParachute = false
		transformIsBeast = false
		RemoveAllPedWeapons(ped, false)
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		local pos = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local newVehicle = CreateVehicle(model, pos.x, pos.y, pos.z + 50.0, heading, true, false)
		local vehNetId = NetworkGetNetworkIdFromEntity(newVehicle)
		TriggerServerEvent("custom_races:server:spawnVehicle", vehNetId)
		SetModelAsNoLongerNeeded(model)
		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			DeleteEntity(lastVehicle)
			TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
		end
		SetVehRadioStation(newVehicle, "OFF")
		SetVehicleDoorsLocked(newVehicle, 10)
		SetVehicleColourCombination(newVehicle, 0)
		SetVehicleProperties(newVehicle, raceVehicle)
		SetPedIntoVehicle(ped, newVehicle, -1)
		SetEntityCoords(newVehicle, pos.x, pos.y, pos.z)
		SetEntityHeading(newVehicle, heading)
		SetVehicleFuelLevel(newVehicle, 100.0)
		SetVehicleDirtLevel(newVehicle, 0.0)
		SetVehicleEngineOn(newVehicle, true, true, false)
		if IsThisModelAPlane(model) or IsThisModelAHeli(model) then
			ControlLandingGear(newVehicle, 3)
			SetHeliBladesSpeed(newVehicle, 1.0)
			SetHeliBladesFullSpeed(newVehicle)
			speed = speed > 0.03 and speed or 30.0
		end
		if model == GetHashKey("avenger") or model == GetHashKey("hydra") then
			SetVehicleFlightNozzlePositionImmediate(newVehicle, 0.0)
		end
		SetVehicleForwardSpeed(newVehicle, speed)
		if copyVelocity then
			SetEntityVelocity(newVehicle, velocity.x, velocity.y, velocity.z)
		end
		SetEntityRotation(newVehicle, rotation, 2)
		syncData.vehicle = GetDisplayNameFromVehicleModel(model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(model) or "Unknown"
		DisplayCustomMsgs(GetLabelText(syncData.vehicle), false, nil)
		if track.mode == "gta" then
			GiveWeapons(ped)
			SetPedArmour(ped, 100)
			SetEntityHealth(ped, 200)
			SetVehicleDoorsLocked(newVehicle, 0)
		end
		lastVehicle = newVehicle
		isTransformingInProgress = false
	end)
end

function GetRandomVehicleModel(randomClass)
	local model = 0
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
		for i = 1, 10 do
			if isRandomClassValid then
				local randomIndex = math.random(#availableVehModels)
				local randomHash = availableVehModels[randomIndex]
				if transformedModel ~= randomHash and GetVehicleModelNumberOfSeats(randomHash) >= 1 then
					model = randomHash
					break
				end
			else
				local randomIndex = math.random(#allVehModels)
				local randomHash = GetHashKey(allVehModels[randomIndex])
				local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))
				if not Config.BlacklistedVehs[randomHash] and label ~= "NULL" and IsThisModelACar(randomHash) then
					if transformedModel ~= randomHash and GetVehicleModelNumberOfSeats(randomHash) >= 1 then
						model = randomHash
						break
					end
				end
			end
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
			for i = 1, 10 do
				local randomIndex = math.random(#allVehModels)
				local randomHash = GetHashKey(allVehModels[randomIndex])
				local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))
				if not Config.BlacklistedVehs[randomHash] and label ~= "NULL" and IsThisModelACar(randomHash) then
					if transformedModel ~= randomHash and GetVehicleModelNumberOfSeats(randomHash) >= 1 then
						model = randomHash
						break
					end
				end
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
			for i = 1, 10 do
				if count == 0 then
					break
				elseif count == 1 then
					model = availableModels[count][1]
					break
				else
					local randomIndex = math.random(count)
					if transformedModel ~= availableModels[randomIndex][1] then
						model = availableModels[randomIndex][1]
						break
					end
				end
			end
		end
	end
	return model
end

function PlayEffectAndSound(playerPed, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
	if effect_1 == 0 and effect_2 == 0 then
		PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
	else
		if effect_1 == 1 then
			PlaySoundFrontend(-1, "Orientation_Success", "DLC_Air_Race_Sounds_Player", false)
		elseif effect_1 == 2 then
			PlaySoundFrontend(-1, "Orientation_Fail", "DLC_Air_Race_Sounds_Player", false)
		elseif effect_2 == 1 then
			PlaySoundFromEntity(-1, "Vehicle_Warp", playerPed, "DLC_Air_Race_Sounds_Player", false, 0)
		elseif effect_2 == 2 then
			PlaySoundFromEntity(-1, "Vehicle_Transform", playerPed, "DLC_Air_Race_Sounds_Player", false, 0)
		end
		if effect_1 == 1 then
			if AnimpostfxIsRunning("CrossLine") then
				AnimpostfxStop("CrossLine")
				AnimpostfxPlay("CrossLineOut", 0, false)
			end
			AnimpostfxPlay("MP_SmugglerCheckpoint", 1000, false)
		elseif effect_1 == 2 then
			Citizen.CreateThread(function()
				if not AnimpostfxIsRunning("CrossLine") then
					AnimpostfxPlay("CrossLine", 0, true)
				end
				Citizen.Wait(1000)
				if AnimpostfxIsRunning("CrossLine") then
					AnimpostfxStop("CrossLine")
					AnimpostfxPlay("CrossLineOut", 0, false)
				end
			end)
		end
		if effect_2 == 1 or effect_2 == 2 then
			Citizen.CreateThread(function()
				local particleDictionary = "scr_as_trans"
				local particleName = "scr_as_trans_smoke"
				local scale = 2.0
				RequestNamedPtfxAsset(particleDictionary)
				while not HasNamedPtfxAssetLoaded(particleDictionary) do
					Citizen.Wait(0)
				end
				UseParticleFxAssetNextCall(particleDictionary)
				local effect = StartParticleFxLoopedOnEntity(particleName, playerPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
				local r, g, b = tonumber(vehicle_r), tonumber(vehicle_g), tonumber(vehicle_b)
				if r and g and b then
					SetParticleFxLoopedColour(effect, (r / 255) + 0.0, (g / 255) + 0.0, (b / 255) + 0.0, true)
				end
				Citizen.Wait(500)
				StopParticleFxLooped(effect, true)
			end)
		end
	end
end

function WarpVehicle(checkpoint, entity)
	local entitySpeed = GetEntitySpeed(entity)
	local entityRotation = GetEntityRotation(entity, 2)
	SetEntityCoords(entity, checkpoint.x, checkpoint.y, checkpoint.z)
	SetEntityRotation(entity, entityRotation, 2)
	SetEntityHeading(entity, checkpoint.heading)
	SetVehicleForwardSpeed(entity, entitySpeed)
	SetGameplayCamRelativeHeading(0)
end

function SlowVehicle(entity)
	local speed = math.min(GetEntitySpeed(entity), GetVehicleEstimatedMaxSpeed(entity))
	SetVehicleForwardSpeed(entity, speed / 3.0)
end

function GetVehicleCanSlowDown(checkpoint, entity)
	local forward, right, up, vehPos = GetEntityMatrix(entity)
	local cpPos = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
	local dirVec
	if checkpoint.lock_dir then
		dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
	elseif Vdist2(vehPos.x, vehPos.y, vehPos.z, cpPos.x, cpPos.y, cpPos.z) > 20.0 then
		dirVec = cpPos - vehPos
	else
		dirVec = forward
	end
	dirVec = NormVec(dirVec)
	local rightVec = NormVec(CrossVec(dirVec, vector3(0.0, 0.0, 1.0)))
	local upVec = NormVec(-CrossVec(dirVec, rightVec))
	if checkpoint.plane_rot == 2 then
		upVec = -upVec
		rightVec = -rightVec
	elseif checkpoint.plane_rot == 3 then
		local tempUp = upVec
		local tempRight = rightVec
		upVec = -tempRight
		rightVec = tempUp
	elseif checkpoint.plane_rot == 1 then
		local tempUp = upVec
		local tempRight = rightVec
		upVec = tempRight
		rightVec = -tempUp
	end
	if ((DotVec(upVec, up) > (1.0 - 0.3) and DotVec(rightVec, right) > (1.0 - (0.3 * 1.5))) or
		(math.abs(dirVec.z) > 0.95 and DotVec(dirVec, forward) > (1.0 - 0.3))) then
		return false
	else
		return true
	end
end

function CrossVec(vecA, vecB)
	return vector3(
		(vecA.y * vecB.z) - (vecA.z * vecB.y),
		(vecA.z * vecB.x) - (vecA.x * vecB.z),
		(vecA.x * vecB.y) - (vecA.y * vecB.x)
	)
end

function NormVec(vec)
	local mag = #(vec)
	if mag ~= 0.0 then
		return vec / mag
	else
		return vector3(0.0, 0.0, 0.0)
	end
end

function DotVec(vecA, vecB)
	return (vecA.x * vecB.x) + (vecA.y * vecB.y) + (vecA.z * vecB.z)
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
	AddTextComponentSubstringKeyboardDisplay(text)
	EndTextCommandScaleformString()
end

function SetupScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
	EndScaleformMovieMethod()
	BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
	ScaleformMovieMethodAddParamInt(200)
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(1)
	ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(2, 173, true))
	ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(2, 172, true))
	ButtonMessage(GetTranslate("racing-spectator-select"))
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(2, 202, true))
	ButtonMessage(GetTranslate("racing-spectator-quit"))
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	EndScaleformMovieMethod()
	BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(80)
	EndScaleformMovieMethod()
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
	ResetCheckpointAndBlipForRace()
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
	ReleaseScriptAudioBank()
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
	ResetCheckpointAndBlipForRace()
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
		--SwitchOutPlayer(ped, 0, 1)
		TriggerServerEvent("custom_races:server:leaveRace")
		ResetCheckpointAndBlipForRace()
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
		TriggerServerCallback("custom_races:server:getRoomList", function(result)
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
		TriggerEvent("custom_races:unloadrace")
		TriggerServerEvent("custom_core:server:inRace", false)
	end
end

function EndRace()
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		RemoveFinishCamera()
		--SwitchOutPlayer(ped, 0, 1)
		ResetCheckpointAndBlipForRace()
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
		TriggerServerCallback("custom_races:server:getRoomList", function(result)
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
		TriggerEvent("custom_races:unloadrace")
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

function GiveWeapons(ped)
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
	if weatherAndTime.weather == "XMAS" then
		SetForceVehicleTrails(true)
		SetForcePedFootstepsTracks(true)
	else
		SetForceVehicleTrails(false)
		SetForcePedFootstepsTracks(false)
	end
	if weatherAndTime.weather == "RAIN" then
		SetRainLevel(0.3)
	elseif weatherAndTime.weather == "THUNDER" then
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
				RemoveVehiclesFromGeneratorsInArea(pos["x"] - 500.0, pos["y"] - 500.0, pos["z"] - 500.0, pos["x"] + 500.0, pos["y"] + 500.0, pos["z"] + 500.0)
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
		BeginScaleformMovieMethod(scaleform, "SET_MESSAGE")
		ScaleformMovieMethodAddParamLiteralString(track.blimpText or "")
		EndScaleformMovieMethod()
		BeginScaleformMovieMethod(scaleform, "SET_COLOUR")
		ScaleformMovieMethodAddParamInt(track.blimpColor or 1)
		EndScaleformMovieMethod()
		BeginScaleformMovieMethod(scaleform, "SET_SCROLL_SPEED")
		ScaleformMovieMethodAddParamFloat(track.blimpSpeed or 100.0)
		EndScaleformMovieMethod()
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
		while isLoadingObjects do Citizen.Wait(0) end
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
		local hide = {}
		for k, v in pairs(track.dhprop) do
			hide[v.hash] = true
		end
		local spawn = {}
		for i = 1, #loadedObjects do
			spawn[loadedObjects[i]] = true
		end
		while status ~= "freemode" do
			if #track.dhprop > 0 and (status == "racing" or status == "spectating") then
				local pool = GetGamePool("CObject")
				for i = 1, #pool do
					local fixture = pool[i]
					if fixture and not spawn[fixture] and DoesEntityExist(fixture) then
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
					if fixture and not spawn[fixture] and DoesEntityExist(fixture) then
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
				local speed = 25
				if objects[i].prpsba == 1 then
					speed = 15
				elseif objects[i].prpsba == 2 then
					speed = 25
				elseif objects[i].prpsba == 3 then
					speed = 35
				elseif objects[i].prpsba == 4 then
					speed = 45
				elseif objects[i].prpsba == 5 then
					speed = 100
				end
				local duration = 0.4
				if objects[i].prpsba == 1 then
					duration = 0.3
				elseif objects[i].prpsba == 2 then
					duration = 0.4
				elseif objects[i].prpsba == 3 then
					duration = 0.5
				elseif objects[i].prpsba == 4 then
					duration = 0.5
				elseif objects[i].prpsba == 5 then
					duration = 0.5
				end
				SetObjectStuntPropSpeedup(obj, speed)
				SetObjectStuntPropDuration(obj, duration)
			end
			if slowDownObjects[objects[i].hash] then
				local speed = 30
				if objects[i].prpsba == 1 then
					speed = 44
				elseif objects[i].prpsba == 2 then
					speed = 30
				elseif objects[i].prpsba == 3 then
					speed = 16
				end
				SetObjectStuntPropSpeedup(obj, speed)
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
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	for k, v in pairs(invalidObjects) do
		DisplayCustomMsgs(string.format(GetTranslate("object-hash-null"), k), false, nil)
	end
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
	TriggerEvent("custom_races:startSpectating")
	TriggerServerEvent("custom_core:server:inSpectator", true)
	local playersToSpectate = {}
	local myServerId = GetPlayerServerId(PlayerId())
	local actionFromUser = (raceStatus == "spectator") and true or false
	local isScreenFadeOut = false
	local fadeOutTime = nil
	local timeOutCount = 0
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
					fadeOutTime = GetGameTimer()
					Citizen.Wait(500)
					canPlaySound = true
					lastspectatePlayerId = playersToSpectate[spectatingPlayerIndex].playerId
					pedToSpectate = nil
					TriggerServerEvent("custom_races:server:spectatePlayer", lastspectatePlayerId, actionFromUser)
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
						fadeOutTime = nil
					else
						pedToSpectate = nil
					end
				end
				if isScreenFadeOut and fadeOutTime and (GetGameTimer() - fadeOutTime > 3000) then
					DoScreenFadeIn(500)
					isScreenFadeOut = false
					fadeOutTime = nil
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
				timeOutCount = 0
			else
				timeOutCount = timeOutCount + 1
				if timeOutCount >= 5 then
					break
				end
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
		TriggerEvent("custom_races:stopSpectating")
		TriggerServerEvent("custom_core:server:inSpectator", false)
	end)
	Citizen.CreateThread(function()
		local last_totalCheckpointsTouched_spectate = nil
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
				local driverInfo_spectate = lastspectatePlayerId and drivers[lastspectatePlayerId]
				if driverInfo_spectate then
					local totalCheckpointsTouched_spectate = driverInfo_spectate.totalCheckpointsTouched
					local actualCheckpoint_spectate = driverInfo_spectate.actualCheckpoint
					local actualLap_spectate = driverInfo_spectate.actualLap
					if last_totalCheckpointsTouched_spectate ~= totalCheckpointsTouched_spectate then
						ResetCheckpointAndBlipForRace()
						CreateBlipForRace(actualCheckpoint_spectate, actualCheckpoint_spectate == #track.checkpoints, actualCheckpoint_spectate == #track.checkpoints and actualLap_spectate == laps)
						CreateCheckpointForRace(actualCheckpoint_spectate, false, actualCheckpoint_spectate == #track.checkpoints and actualLap_spectate == laps)
						CreateCheckpointForRace(actualCheckpoint_spectate, true, actualCheckpoint_spectate == #track.checkpoints and actualLap_spectate == laps)
					end
					last_totalCheckpointsTouched_spectate = totalCheckpointsTouched_spectate
				end
			else
				if timeOutCount >= 5 then
					break
				end
			end
			Citizen.Wait(0)
		end
	end)
end)

RegisterNetEvent("custom_races:client:whoSpectateWho", function(playerName_A, playerName_B)
	if playerName_A and playerName_B then
		DisplayCustomMsgs("~HUD_COLOUR_GREEN~" .. playerName_A .. "~s~" .. GetTranslate("msg-spectate") .. "~HUD_COLOUR_YELLOW~" .. playerName_B .. "~s~", false, nil)
	end
end)

RegisterNetEvent("custom_races:client:syncParticleFx", function(playerId, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
	Citizen.Wait(100)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
	if playerPed and playerPed ~= 0 and playerPed ~= PlayerPedId() then
		if status == "spectating" and lastspectatePlayerId == playerId then
			PlayEffectAndSound(playerPed, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
		else
			PlayEffectAndSound(playerPed, -1, effect_2 ~= 0 and effect_2 or -1, vehicle_r, vehicle_g, vehicle_b)
		end
	end
end)

RegisterNetEvent("custom_races:client:showFinalResult", function()
	if status == "leaving" or status == "ending" then return end
	status = "ending"
	EndRace()
end)

local isRaceLocked = false
RegisterCommand("open_race", function()
	if isRaceLocked then return end
	if status == "freemode" and not isCreatorEnable and not enableXboxController and not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
		enableXboxController = true
		XboxControlSimulation()
		LoopGetNUIFramerateMoveFix()
		TriggerServerCallback("custom_races:server:permission", function(bool, newData, time)
			if newData then
				races_data_front = newData
				dataOutdated = false
				needRefreshTag = true
			end
			if bool then
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
					message = string.format(GetTranslate("msg-open-menu"), time)
				})
				enableXboxController = false
			end
		end, dataOutdated)
	end
end)

RegisterCommand("check_invitation", function()
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

RegisterCommand("quit_race", function()
	if isRaceLocked then return end
	if (status == "racing" or status == "spectating") and not isCreatorEnable and not enableXboxController and not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
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

exports("lockRace", function()
	isRaceLocked = true
end)

exports("unlockRace", function()
	isRaceLocked = false
end)

exports("setWeather", function(weather)
	weatherAndTime.weather = weather
end)

exports("setTime", function(hour, minute, second)
	weatherAndTime.hour = hour
	weatherAndTime.minute = minute
	weatherAndTime.second = second
end)

--- Teleport to the previous checkpoint
function tpp()
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
function tpn()
	if status == "racing" and not isRespawningInProgress and not isTransformingInProgress then
		isTeleportingInProgress = true
		hasCheated = true
		local ped = PlayerPedId()
		local checkpoint = lastCheckpointPair == 1 and track.checkpoints_2[actualCheckpoint] or track.checkpoints[actualCheckpoint]
		if IsPedInAnyVehicle(ped) then
			SetEntityCoords(GetVehiclePedIsIn(ped, false),checkpoint.x, checkpoint.y, checkpoint.z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(GetVehiclePedIsIn(ped, false), checkpoint.heading)
		else
			SetEntityCoords(ped, checkpoint.x, checkpoint.y, checkpoint.z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(ped, checkpoint.heading)
		end
		SendNUIMessage({
			action = "nui_msg:showNotification",
			message = GetTranslate("msg-tpn")
		})
		SetGameplayCamRelativeHeading(0)
		isTeleportingInProgress = false
	end
end

AddEventHandler("custom_races:tpp", function()
	tpp()
end)

AddEventHandler("custom_races:tpn", function()
	tpn()
end)

AddEventHandler("custom_creator:load", function()
	isCreatorEnable = true
end)

AddEventHandler("custom_creator:unload", function()
	isCreatorEnable = false
end)