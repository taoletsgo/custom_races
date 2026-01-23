StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
StatSetInt(`MP0_STEALTH_ABILITY`, 100, true)
StatSetInt(`MP0_FLYING_ABILITY`, 100, true)
StatSetInt(`MP0_WHEELIE_ABILITY`, 100, true)
StatSetInt(`MP0_LUNG_CAPACITY`, 100, true)
StatSetInt(`MP0_STRENGTH`, 100, true)
StatSetInt(`MP0_STAMINA`, 100, true)

inRoom = false
inVehicleUI = false
isPedVisible = false
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
local isCreatorEnable = false
local needRefreshTag = false
local togglePositionUI = false
local currentUiPage = 1
local arenaProps = {}
local explodeProps = {}
local fireworkProps = {}
local raceVehicle = {}
local hasCheated = false
local transformIsParachute = false
local transformIsBeast = false
local isSyncLocked = false
local totalCheckpointsTouched = 0
local actualCheckpoint = 0
local lastCheckpointPair = 0 -- 0 = primary / 1 = secondary
local actualLap = 0
local startLapTime = 0
local actualLapTime = 0
local totalTimeStart = 0
local totalRaceTime = 0
local hasShowRespawnUI = false
local isRespawning = false
local hasRespawned = false
local respawnTime = 0
local respawnTimeStart = 0
local isRespawningInProgress = false
local isTransformingInProgress = false
local isTeleportingInProgress = false
local finishCamera = nil
local isOverClouds = false
local spectateData = {
	isFadeOut = false,
	fadeOutTime = nil,
	playerId = nil,
	ped = nil,
	index = 0,
	players = {}
}
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
local currentRace = {
	roomId = nil,
	owner_name = "",
	title = "",
	blimp_text = "",
	laps = 1,
	weather = "",
	time = {},
	traffic = true,
	mode = "",
	roomData = nil,
	playerCount = 1,
	drivers = {},
	lastVehicle = nil,
	default_vehicle = nil,
	use_room_vehicle = false,
	random_vehicles = {},
	gridPositionIndex = 1,
	startingGrid = {
		[1] = {
			x = 0.0,
			y = 0.0,
			z = 0.0,
			heading = 0.0
		}
	},
	checkpoints = {},
	checkpoints_2 = {},
	transformVehicles = {},
	objects = {},
	fixtures = {},
	firework = {
		name = "scr_indep_firework_trailburst",
		r = 255,
		g = 255,
		b = 255
	}
}

function JoinRace()
	status = "ready"
	totalCheckpointsTouched = 0
	actualCheckpoint = 1
	lastCheckpointPair = 0
	actualLap = 1
	isRespawningInProgress = true
	RespawnVehicle(currentRace.startingGrid[currentRace.gridPositionIndex].x, currentRace.startingGrid[currentRace.gridPositionIndex].y, currentRace.startingGrid[currentRace.gridPositionIndex].z, currentRace.startingGrid[currentRace.gridPositionIndex].heading, false, nil)
	isRespawningInProgress = false
	isPedVisible = IsEntityVisible(PlayerPedId())
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)
	CreateBlipForRace(actualCheckpoint, actualLap)
	CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
	CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
	ClearAreaLeaveVehicleHealth(currentRace.startingGrid[currentRace.gridPositionIndex].x, currentRace.startingGrid[currentRace.gridPositionIndex].y, currentRace.startingGrid[currentRace.gridPositionIndex].z, 100000000000000000000000.0, false, false, false, false, false)
	RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_01", false, -1)
	RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_02", false, -1)
end

function StartRace()
	status = "starting"
	SendNUIMessage({
		action = "nui_msg:showRaceInfo",
		racename = currentRace.title
	})
	Citizen.Wait(4000)
	if status ~= "starting" then return end
	status = "racing"
	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "nui_msg:showRaceHud",
			showCurrentLap = currentRace.laps > 1
		})
		if DoesEntityExist(currentRace.lastVehicle) then
			FreezeEntityPosition(currentRace.lastVehicle, false)
			SetVehicleEngineOn(currentRace.lastVehicle, true, true, true)
		end
		if currentRace.mode == "gta" then
			GiveWeapons(PlayerPedId())
		end
		local wasJumping = false
		local wasOnFoot = false
		local wasJumped = false
		local wasControlPressed = false
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
					if togglePositionUI and ((currentUiPage * 20) < currentRace.playerCount) then
						currentUiPage = currentUiPage + 1
					else
						if currentRace.playerCount > 0 then
							togglePositionUI = not togglePositionUI
							currentUiPage = 1
						end
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
					if currentRace.mode ~= "gta" then
						EnableControlAction(0, 68, true)
					end
				else
					if currentRace.mode ~= "gta" then
						DisableControlAction(0, 68, true)
					end
					if not IsThisModelAPlane(model) and not IsThisModelAHeli(model) and not (model == GetHashKey("submersible")) and not (model == GetHashKey("submersible2")) and not (model == GetHashKey("avisa")) then
						UseVehicleCamStuntSettingsThisUpdate()
					end
				end
				vehicle_r, vehicle_g, vehicle_b = GetVehicleColor(vehicle)
			else
				if currentRace.mode == "no_collision" and DoesEntityExist(currentRace.lastVehicle) then
					SetEntityCollision(currentRace.lastVehicle, false, false)
				end
			end
			for k, v in pairs(arenaProps) do
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
			for k, v in pairs(explodeProps) do
				if not v.touching and DoesEntityExist(v.handle) and IsEntityTouchingEntity(vehicle ~= 0 and vehicle or ped, v.handle) then
					v.touching = true
					local coords = GetEntityCoords(v.handle)
					FreezeEntityPosition(v.handle, true)
					SetEntityVisible(v.handle, false)
					SetEntityCollision(v.handle, false, false)
					SetEntityCompletelyDisableCollision(v.handle, false, false)
					AddExplosion(coords.x, coords.y, coords.z, 58, 1.0, true, false, 1.0, false)
					TriggerServerEvent("custom_races:server:syncExplosion", k, v.hash)
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
			if currentRace.mode ~= "gta" then
				SetEntityInvincible(ped, true)
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
				SetPlayerCanDoDriveBy(PlayerId(), true)
				if vehicle ~= 0 and DoesVehicleHaveWeapons(vehicle) == 1 then
					local weapons = {2971687502, 1945616459, 3450622333, 3530961278, 1259576109, 4026335563, 1566990507, 1186503822, 2669318622, 3473446624, 4171469727, 1741783703, 2211086889}
					for i = 1, #weapons do
						DisableVehicleWeapon(true, weapons[i], vehicle, ped)
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
				SetEntityInvincible(ped, false)
				SetPlayerCanDoDriveBy(PlayerId(), true)
			end
			if IsControlPressed(0, 75) or IsDisabledControlPressed(0, 75) then
				wasControlPressed = true
				if hasRespawned and not isRespawningInProgress and ((not transformIsParachute and not transformIsBeast and vehicle == 0 and currentRace.mode ~= "gta") or (IsEntityDead(ped) or IsPlayerDead(PlayerId()))) then
					ResetAndHideRespawnUI()
				end
				-- Press F to respawn
				StartRespawn()
			elseif (not transformIsParachute and not transformIsBeast and vehicle == 0 and currentRace.mode ~= "gta") or (IsEntityDead(ped) or IsPlayerDead(PlayerId())) then
				wasControlPressed = false
				if hasRespawned and not isRespawningInProgress then
					ResetAndHideRespawnUI()
				end
				-- Automatically respawn after falling off a vehicle or dead
				StartRespawn()
			else
				if currentRace.mode == "gta" and wasControlPressed and vehicle ~= 0 and respawnTime > 0 and respawnTime < 100 then
					TaskLeaveVehicle(ped, vehicle, GetEntitySpeed(vehicle) <= 1.0 and 0 or 4160)
				end
				wasControlPressed = false
				ResetAndHideRespawnUI()
			end

			local checkPointTouched = false
			local finishLine = actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps
			local checkpoint = currentRace.checkpoints[actualCheckpoint]
			local checkpoint_2 = currentRace.checkpoints_2[actualCheckpoint]
			local checkpoint_next = not finishLine and currentRace.checkpoints[actualCheckpoint + 1] or currentRace.checkpoints[1]
			local checkpoint_2_next = not finishLine and currentRace.checkpoints_2[actualCheckpoint + 1] or currentRace.checkpoints_2[1]

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
				if finishLine then
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
					if checkpoint.is_planeRot and checkpoint.draw_id then
						if vehicle ~= 0 and GetVehicleShouldSlowDown(checkpoint, vehicle) then
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
				if finishLine then
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
					if checkpoint_2.is_planeRot and checkpoint_2.draw_id then
						if vehicle ~= 0 and GetVehicleShouldSlowDown(checkpoint_2, vehicle) then
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
			end

			if checkpoint_coords and collect_size and checkpoint_radius and _checkpoint_coords and ((#(pos - checkpoint_coords) <= (checkpoint_radius * 2.0)) or (#(pos - _checkpoint_coords) <= (checkpoint_radius * 1.5))) and not isRespawningInProgress and not isTransformingInProgress and not isTeleportingInProgress then
				checkPointTouched = true
				lastCheckpointPair = 0
				local effect_1 = 0
				local effect_2 = 0
				if checkpoint.is_planeRot and vehicle ~= 0 and not finishLine then
					if checkpoint_slow then
						effect_1 = 2
						SlowVehicle(vehicle)
					else
						effect_1 = 1
					end
				end
				if checkpoint.is_warp and checkpoint_next and not finishLine then
					effect_2 = 1
					WarpVehicle(checkpoint_next, vehicle ~= 0 and vehicle or ped)
				end
				if (checkpoint.is_transform or checkpoint.is_random) and not finishLine then
					effect_2 = effect_2 == 0 and 2 or effect_2
					local speed = vehicle ~= 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
					local rotation = vehicle ~= 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
					local velocity = vehicle ~= 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
					TransformVehicle(checkpoint, speed, rotation, velocity, function(props)
						checkpoint.respawnData = props
						if checkpoint_2 then
							checkpoint_2.respawnData = props
						end
					end)
				else
					local props = totalCheckpointsTouched == 0 and raceVehicle or (actualCheckpoint == 1 and currentRace.checkpoints[#currentRace.checkpoints].respawnData) or (currentRace.checkpoints[actualCheckpoint - 1].respawnData)
					checkpoint.respawnData = props
					if checkpoint_2 then
						checkpoint_2.respawnData = props
					end
					if checkpoint.is_pit and vehicle ~= 0 and not finishLine then
						SetVehicleUndriveable(vehicle, false)
						SetVehicleEngineCanDegrade(vehicle, false)
						SetVehicleEngineHealth(vehicle, 1000.0)
						SetVehiclePetrolTankHealth(vehicle, 1000.0)
						SetVehicleEngineOn(vehicle, true, true)
						SetVehicleFixed(vehicle)
						StopEntityFire(vehicle)
						SetVehicleFuelLevel(vehicle, 100.0)
						SetVehicleOilLevel(vehicle, 1.0)
						SetVehicleDirtLevel(vehicle, 0)
						SetVehicleDeformationFixed(vehicle)
					end
				end
				PlayEffectAndSound(ped, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
				if not isSyncLocked then
					TriggerServerEvent("custom_races:server:syncParticleFx", effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
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
				if checkpoint_2.is_planeRot and vehicle ~= 0 and not finishLine then
					if checkpoint_2_slow then
						effect_1 = 2
						SlowVehicle(vehicle)
					else
						effect_1 = 1
					end
				end
				if checkpoint_2.is_warp and (checkpoint_2_next or checkpoint_next) and not finishLine then
					effect_2 = 1
					WarpVehicle(checkpoint_2_next or checkpoint_next, vehicle ~= 0 and vehicle or ped)
				end
				if (checkpoint_2.is_transform or checkpoint_2.is_random) and not finishLine then
					effect_2 = effect_2 == 0 and 2 or effect_2
					local speed = vehicle ~= 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
					local rotation = vehicle ~= 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
					local velocity = vehicle ~= 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
					TransformVehicle(checkpoint_2, speed, rotation, velocity, function(props)
						checkpoint.respawnData = props
						checkpoint_2.respawnData = props
					end)
				else
					local props = totalCheckpointsTouched == 0 and raceVehicle or (actualCheckpoint == 1 and currentRace.checkpoints[#currentRace.checkpoints].respawnData) or (currentRace.checkpoints[actualCheckpoint - 1].respawnData)
					checkpoint.respawnData = props
					checkpoint_2.respawnData = props
					if checkpoint_2.is_pit and vehicle ~= 0 and not finishLine then
						SetVehicleUndriveable(vehicle, false)
						SetVehicleEngineCanDegrade(vehicle, false)
						SetVehicleEngineHealth(vehicle, 1000.0)
						SetVehiclePetrolTankHealth(vehicle, 1000.0)
						SetVehicleEngineOn(vehicle, true, true)
						SetVehicleFixed(vehicle)
						StopEntityFire(vehicle)
						SetVehicleFuelLevel(vehicle, 100.0)
						SetVehicleOilLevel(vehicle, 1.0)
						SetVehicleDirtLevel(vehicle, 0)
						SetVehicleDeformationFixed(vehicle)
					end
				end
				PlayEffectAndSound(ped, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
				if not isSyncLocked then
					TriggerServerEvent("custom_races:server:syncParticleFx", effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
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
				if actualCheckpoint == #currentRace.checkpoints then
					syncData.lastlap = actualLapTime
					if (syncData.bestlap == 0) or (syncData.bestlap > actualLapTime) then
						syncData.bestlap = actualLapTime
					end
					syncData.totalRaceTime = totalRaceTime
					if actualLap < currentRace.laps then
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
				CreateBlipForRace(actualCheckpoint, actualLap)
				CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
				CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
			end
			DrawBottomHUD()
			Citizen.Wait(0)
		end
	end)
	Citizen.CreateThread(function()
		local visible = false
		local topId = nil
		local MsgItem = nil
		local firstLoad = true
		local startTime = GetGameTimer()
		while status == "racing" do
			Citizen.Wait(500)
			local driversInfo = UpdateDriversInfo(currentRace.drivers)
			if togglePositionUI and #driversInfo > 0 then
				local frontpos = {}
				local _labels = {
					label_name = GetTranslate("racing-ui-label_name"),
					label_ping = "Ping",
					label_fps = "FPS",
					label_distance = GetTranslate("racing-ui-label_distance"),
					label_lap = currentRace.laps > 1 and GetTranslate("racing-ui-label_lap"),
					label_checkpoint = GetTranslate("racing-ui-label_checkpoint"),
					label_vehicle = GetTranslate("racing-ui-label_vehicle"),
					label_lastlap = currentRace.laps > 1 and GetTranslate("racing-ui-label_lastlap"),
					label_bestlap = currentRace.laps > 1 and GetTranslate("racing-ui-label_bestlap"),
					label_totaltime = GetTranslate("racing-ui-label_totaltime")
				}
				for k, v in pairs(currentRace.drivers) do
					local _position = GetPlayerPosition(driversInfo, v.playerId)
					local _name = v.playerName
					local _flag = v.flag or "US"
					local _keyboard = v.keyboard and "💻" or "🎮"
					local _ping = v.ping
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
							flag = _flag,
							keyboard = "DNF",
							ping = "DNF",
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
							flag = _flag,
							keyboard = "-",
							ping = "-",
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
						local checkpoint = v.lastCheckpointPair == 1 and currentRace.checkpoints_2[v.actualCheckpoint] or currentRace.checkpoints[v.actualCheckpoint] or vector3(0.0, 0.0, 0.0)
						_distance = RoundedValue(#(v.currentCoords - vector3(checkpoint.x, checkpoint.y, checkpoint.z)), 1) .. "m"
						table.insert(frontpos, {
							position = _position,
							name = _name,
							flag = _flag,
							keyboard = _keyboard,
							ping = _ping,
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
				if (currentUiPage > 1) and (((currentUiPage - 1) * 20 + 1) > currentRace.playerCount) then
					currentUiPage = currentUiPage - 1
				end
				local startIdx = (currentUiPage - 1) * 20 + 1
				local endIdx = math.min(startIdx + 20 - 1, currentRace.playerCount)
				local frontpos_show = {}
				for i = startIdx, endIdx do
					local player = frontpos[i]
					if player then
						table.insert(frontpos_show, player)
					end
				end
				SendNUIMessage({
					frontpos = frontpos_show,
					visible = not visible,
					labels = _labels
				})
				visible = true
			else
				if visible then
					SendNUIMessage({
						action = "nui_msg:hidePositionUI"
					})
					visible = false
				end
			end
			if firstLoad then
				topId = driversInfo[1].playerId
				firstLoad = false
			end
			if (GetGameTimer() - startTime) >= 5000 then
				if currentRace.playerCount > 1 and (topId ~= driversInfo[1].playerId) and not driversInfo[1].hasFinished then
					topId = driversInfo[1].playerId
					local message = string.format(GetTranslate("racing-info-1st"), driversInfo[1].playerName)
					MsgItem = DisplayCustomMsgs(message, true, MsgItem)
				end
			end
		end
		if visible then
			SendNUIMessage({
				action = "nui_msg:hidePositionUI"
			})
			visible = false
		end
	end)
end

function UpdateDriversInfo(driversToSort)
	local sortedDrivers = {}
	for _, driver in pairs(driversToSort) do
		local checkpoint = driver.lastCheckpointPair == 1 and currentRace.checkpoints_2[driver.actualCheckpoint] or currentRace.checkpoints[driver.actualCheckpoint] or vector3(0.0, 0.0, 0.0)
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
	return currentRace.playerCount
end

function DrawBottomHUD()
	-- Current lap number
	if not hudData.actualLap or hudData.actualLap ~= actualLap then
		SendNUIMessage({
			laps = actualLap .. "/" .. currentRace.laps
		})
		hudData.actualLap = actualLap
	end
	-- Current ranking
	local driversInfo = UpdateDriversInfo(currentRace.drivers)
	local position = GetPlayerPosition(driversInfo, GetPlayerServerId(PlayerId()))
	if not hudData.position or hudData.position ~= position or hudData.playerCount ~= currentRace.playerCount then
		SendNUIMessage({
			position = position .. "</span><span style='font-size: 4vh;margin-left: 9px;'>/ " .. currentRace.playerCount
		})
		hudData.position = position
		hudData.playerCount = currentRace.playerCount
	end
	-- Current checkpoint
	if not hudData.checkpoints or hudData.checkpoints ~= actualCheckpoint then
		SendNUIMessage({
			checkpoints = actualCheckpoint .. "/" .. #currentRace.checkpoints
		})
		hudData.checkpoints = actualCheckpoint
	end
	-- Current lap time
	if (not hudData.timeLap or actualLapTime - hudData.timeLap >= 1000) and currentRace.laps > 1 then
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
	for i, checkpoint in ipairs(currentRace.checkpoints) do
		if checkpoint.draw_id then
			DeleteCheckpoint(checkpoint.draw_id)
			checkpoint.draw_id = nil
		end
		if checkpoint.blip_id then
			RemoveBlip(checkpoint.blip_id)
			checkpoint.blip_id = nil
		end
		local checkpoint_2 = currentRace.checkpoints_2[i]
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
	local checkpoint = pair and currentRace.checkpoints_2[index] or currentRace.checkpoints[index]
	if not checkpoint then return end
	local checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(13)
	local checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
	local checkpointA_1, checkpointA_2 = 150, 150
	if not checkpoint.draw_id then
		local draw_size = ((checkpoint.is_air and (4.5 * checkpoint.d_draw)) or ((checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) and (2.25 * checkpoint.d_draw)) or checkpoint.d_draw) * 10
		local checkpointNearHeight = 9.5
		local checkpointFarHeight = 9.5
		local checkpointRangeHeight = checkpoint.is_tall and checkpoint.tall_radius or 100.0
		local drawHigher = false
		local updateZ = checkpoint.is_round and (checkpoint.is_air and 0.0 or (draw_size / 2)) or (draw_size / 2)
		local checkpoint_next = pair and (currentRace.checkpoints_2[index + 1] or currentRace.checkpoints[index + 1] or currentRace.checkpoints_2[1] or currentRace.checkpoints[1]) or (currentRace.checkpoints[index + 1] or currentRace.checkpoints[1])
		local checkpoint_prev = pair and (currentRace.checkpoints_2[index - 1] or currentRace.checkpoints[index - 1] or currentRace.checkpoints_2[#currentRace.checkpoints] or currentRace.checkpoints[#currentRace.checkpoints]) or (currentRace.checkpoints[index - 1] or currentRace.checkpoints[#currentRace.checkpoints])
		local checkpointIcon = 6
		if checkpoint.is_random and not isFinishLine then
			checkpointIcon = 56
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.is_transform and not isFinishLine then
			local transform_vehicle = currentRace.transformVehicles[checkpoint.transform_index + 1]
			local model = transform_vehicle and (tonumber(transform_vehicle) or GetHashKey(transform_vehicle)) or 0
			local class = GetVehicleClassFromName(model)
			if model == -422877666 then
				checkpointIcon = 64
			elseif model == -731262150 then
				checkpointIcon = 55
			elseif class >= 0 and class <= 7 or class >= 9 and class <= 12 or class == 17 or class == 18 or class == 22 then
				checkpointIcon = 60
			elseif class == 8 then
				checkpointIcon = 61
			elseif class == 13 then
				checkpointIcon = 62
			elseif class == 14 then
				checkpointIcon = 59
			elseif class == 15 then
				checkpointIcon = 58
			elseif class == 16 then
				checkpointIcon = 57
			elseif class == 20 then
				checkpointIcon = 63
			elseif class == 19 then
				if model == GetHashKey("thruster") then
					checkpointIcon = 65
				else
					checkpointIcon = 60
				end
			elseif class == 21 then
				checkpointIcon = 60
			end
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.is_planeRot and not isFinishLine then
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
				local ped = status == "spectating" and DoesEntityExist(spectateData.ped) and spectateData.ped or PlayerPedId()
				local vehicle = GetVehiclePedIsIn(ped, false)
				if vehicle ~= 0 and GetVehicleShouldSlowDown(checkpoint, vehicle) then
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(6)
				else
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
				end
			end
		elseif checkpoint.is_warp and not isFinishLine then
			checkpointIcon = 66
		elseif checkpoint.is_round then
			if isFinishLine then
				checkpointIcon = 16
			else
				checkpointIcon = 12
			end
		else
			local diffPrev = vector3(checkpoint_prev.x, checkpoint_prev.y, checkpoint_prev.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
			local diffNext = vector3(checkpoint_next.x, checkpoint_next.y, checkpoint_next.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
			local checkpointAngle = GetAngleBetween_2dVectors(diffPrev.x, diffPrev.y, diffNext.x, diffNext.y)
			checkpointAngle = checkpointAngle > 180.0 and (360.0 - checkpointAngle) or checkpointAngle
			local found, groundZ = GetGroundZExcludingObjectsFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false)
			if found and math.abs(groundZ - checkpoint.z) > (draw_size * 0.3125) then
				drawHigher = true
				checkpointNearHeight = draw_size * 0.375
				checkpointFarHeight = checkpoint.is_tall and (draw_size * 0.375 * 50.0) or (draw_size * 0.375)
				updateZ = 0.0
			else
				checkpointNearHeight = draw_size * 0.75
				checkpointFarHeight = checkpoint.is_tall and (draw_size * 0.75 * 50.0) or (draw_size * 0.75)
			end
			if checkpointAngle < 80.0 then
				checkpointIcon = drawHigher == true and ((isFinishLine and 4) or (checkpoint.is_pit and 5) or 2) or ((isFinishLine and 10) or (checkpoint.is_pit and 11) or 8)
			elseif checkpointAngle < 140.0 then
				checkpointIcon = drawHigher == true and ((isFinishLine and 4) or (checkpoint.is_pit and 5) or 1) or ((isFinishLine and 10) or (checkpoint.is_pit and 11) or 7)
			elseif checkpointAngle <= 180.0 then
				checkpointIcon = drawHigher == true and ((isFinishLine and 4) or (checkpoint.is_pit and 5) or 0) or ((isFinishLine and 10) or (checkpoint.is_pit and 11) or 6)
			end
		end
		if not (checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) then
			local hour = GetClockHours()
			if hour > 6 and hour < 20 then
				checkpointA_1 = 210
				checkpointA_2 = 180
			end
		end
		local pos_1 = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
		local pos_2 = vector3(checkpoint_next.x, checkpoint_next.y, checkpoint_next.z)
		if not (checkpoint.offset.x == 0.0 and checkpoint.offset.y == 0.0 and checkpoint.offset.z == 0.0) then
			pos_2 = pos_1 + vector3(0.0, 0.0, updateZ) + vector3(checkpoint.offset.x, checkpoint.offset.y, checkpoint.offset.z)
		end
		checkpoint.draw_id = CreateCheckpoint(
			checkpointIcon,
			pos_1.x, pos_1.y, pos_1.z + updateZ,
			pos_2.x, pos_2.y, pos_2.z,
			draw_size, checkpointR_2, checkpointG_2, checkpointB_2, checkpointA_2, 0
		)
		if not isFinishLine and (checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) then
			if checkpoint.lock_dir then
				local dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
				local pos_3 = pos_1 + vector3(0.0, 0.0, updateZ) - dirVec
				-- Rockstar does it this way, but there seems to be a display error for inside icons, WTF?
				-- local pos_3 = checkpoint.is_planeRot and (pos_1 + vector3(0.0, 0.0, updateZ) - dirVec) or (pos_1 + vector3(0.0, 0.0, updateZ) + dirVec)
				N_0xdb1ea9411c8911ec(checkpoint.draw_id) -- SET_CHECKPOINT_FORCE_DIRECTION
				N_0x3c788e7f6438754d(checkpoint.draw_id, pos_3.x, pos_3.y, pos_3.z) -- SET_CHECKPOINT_DIRECTION
			end
		else
			if drawHigher then
				SetCheckpointIconHeight(checkpoint.draw_id, (isFinishLine and 0.75) or (checkpoint.is_pit and 0.75) or 0.5) -- SET_CHECKPOINT_INSIDE_CYLINDER_HEIGHT_SCALE
				-- SetCheckpointIconScale(checkpoint.draw_id, 0.85) -- SET_CHECKPOINT_INSIDE_CYLINDER_SCALE
			end
			SetCheckpointCylinderHeight(checkpoint.draw_id, checkpointNearHeight, checkpointFarHeight, checkpointRangeHeight)
		end
		SetCheckpointRgba(checkpoint.draw_id, checkpointR_1, checkpointG_1, checkpointB_1, checkpointA_1)
	end
end

function CreateBlipForRace(cpIndex, lapIndex)
	local function createData(checkpoint, isNext, isLapEnd, isFinishLine)
		local x, y, z = checkpoint.x, checkpoint.y, checkpoint.z
		local sprite = (isFinishLine and 38) or (isLapEnd and 58) or (checkpoint.is_random and 66) or (checkpoint.is_transform and 570) or 1
		local scale = isNext and 0.65 or 0.9
		local alpha = (isNext or (not isFinishLine and checkpoint.lower_alpha)) and 125 or 255
		local colour = (sprite == 38 and 0) or (not isLapEnd and (checkpoint.is_random or checkpoint.is_transform) and 1) or 5
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
	local checkpoint = currentRace.checkpoints[cpIndex]
	if checkpoint then
		checkpoint.blip_id = createBlip(createData(checkpoint, false, cpIndex == #currentRace.checkpoints, cpIndex == #currentRace.checkpoints and lapIndex == currentRace.laps))
	end
	local checkpoint_2 = currentRace.checkpoints_2[cpIndex]
	if checkpoint_2 then
		checkpoint_2.blip_id = createBlip(createData(checkpoint_2, false, cpIndex == #currentRace.checkpoints, cpIndex == #currentRace.checkpoints and lapIndex == currentRace.laps))
	end
	local checkpoint_next = not (cpIndex == #currentRace.checkpoints and lapIndex == currentRace.laps) and (currentRace.checkpoints[cpIndex + 1] or currentRace.checkpoints[1])
	if checkpoint_next then
		checkpoint_next.blip_id = createBlip(createData(checkpoint_next, true, (cpIndex + 1) == #currentRace.checkpoints, (cpIndex + 1) == #currentRace.checkpoints and lapIndex == currentRace.laps))
	end
	local checkpoint_2_next = not (cpIndex == #currentRace.checkpoints and lapIndex == currentRace.laps) and (currentRace.checkpoints_2[cpIndex + 1] or currentRace.checkpoints_2[1])
	if checkpoint_2_next then
		checkpoint_2_next.blip_id = createBlip(createData(checkpoint_2_next, true, (cpIndex + 1) == #currentRace.checkpoints, (cpIndex + 1) == #currentRace.checkpoints and lapIndex == currentRace.laps))
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
			TriggerServerEvent("custom_races:server:respawning")
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
	if not isRespawningInProgress and not isTransformingInProgress and not isTeleportingInProgress then
		isRespawningInProgress = true
		Citizen.CreateThread(function()
			local ped = PlayerPedId()
			RemoveAllPedWeapons(ped, false)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
			if currentRace.checkpoints[actualCheckpoint - 1] == nil then
				if totalCheckpointsTouched ~= 0 then
					local index = #currentRace.checkpoints
					local checkpoint_respawn = lastCheckpointPair == 1 and currentRace.checkpoints_2[index] or currentRace.checkpoints[index]
					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(checkpoint_respawn.x, checkpoint_respawn.y, checkpoint_respawn.z, checkpoint_respawn.heading, true, false) end
					RespawnVehicle(checkpoint_respawn.x, checkpoint_respawn.y, checkpoint_respawn.z, checkpoint_respawn.heading, true, checkpoint_respawn)
				else
					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
						NetworkResurrectLocalPlayer(currentRace.startingGrid[currentRace.gridPositionIndex].x, currentRace.startingGrid[currentRace.gridPositionIndex].y, currentRace.startingGrid[currentRace.gridPositionIndex].z, currentRace.startingGrid[currentRace.gridPositionIndex].heading, true, false)
					end
					RespawnVehicle(currentRace.startingGrid[currentRace.gridPositionIndex].x, currentRace.startingGrid[currentRace.gridPositionIndex].y, currentRace.startingGrid[currentRace.gridPositionIndex].z, currentRace.startingGrid[currentRace.gridPositionIndex].heading, true, nil)
				end
			else
				local currentModel = (DoesEntityExist(currentRace.lastVehicle) and GetEntityModel(currentRace.lastVehicle)) or (transformIsParachute and -422877666) or (transformIsBeast and -731262150)
				local index, reset = GetNonFakeCheckpoint(actualCheckpoint)
				if reset then
					syncData.totalCheckpointsTouched = totalCheckpointsTouched
					syncData.actualCheckpoint = actualCheckpoint
					local model = nil
					local checkpoint = currentRace.checkpoints[index]
					local checkpoint_2 = currentRace.checkpoints_2[index]
					if lastCheckpointPair == 1 and checkpoint_2 then
						for i = index, 1, -1 do
							local checkpoint_2_temp = currentRace.checkpoints_2[i]
							if checkpoint_2_temp and checkpoint_2_temp.is_transform then
								local transform_vehicle = currentRace.transformVehicles[checkpoint_2_temp.transform_index + 1]
								model = transform_vehicle and (tonumber(transform_vehicle) or GetHashKey(transform_vehicle)) or 0
								break
							elseif checkpoint_2_temp and checkpoint_2_temp.is_random then
								local transform_vehicle = GetRandomVehicleModel(checkpoint_2_temp.random_class, checkpoint_2_temp.random_custom, checkpoint_2_temp.random_setting)
								model = transform_vehicle and (tonumber(transform_vehicle) or GetHashKey(transform_vehicle)) or 0
								break
							end
						end
					else
						for i = index, 1, -1 do
							local checkpoint_temp = currentRace.checkpoints[i]
							if checkpoint_temp and checkpoint_temp.is_transform then
								local transform_vehicle = currentRace.transformVehicles[checkpoint_temp.transform_index + 1]
								model = transform_vehicle and (tonumber(transform_vehicle) or GetHashKey(transform_vehicle)) or 0
								break
							elseif checkpoint_temp and checkpoint_temp.is_random then
								local transform_vehicle = GetRandomVehicleModel(checkpoint_temp.random_class, checkpoint_temp.random_custom, checkpoint_temp.random_setting)
								model = transform_vehicle and (tonumber(transform_vehicle) or GetHashKey(transform_vehicle)) or 0
								break
							end
						end
					end
					if model then
						if model == -422877666 then
							checkpoint.respawnData = {model = -422877666}
							if checkpoint_2 then
								checkpoint_2.respawnData = {model = -422877666}
							end
						elseif model == -731262150 then
							checkpoint.respawnData = {model = -731262150}
							if checkpoint_2 then
								checkpoint_2.respawnData = {model = -731262150}
							end
						elseif model == 0 then
							checkpoint.respawnData = raceVehicle
							if checkpoint_2 then
								checkpoint_2.respawnData = raceVehicle
							end
						else
							if not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model) then
								model = GetHashKey("bmx")
							end
							local found = false
							for k, v in pairs(personalVehicles) do
								if v.model == model then
									checkpoint.respawnData = v
									if checkpoint_2 then
										checkpoint_2.respawnData = v
									end
									found = true
									break
								end
							end
							if not found then
								RequestModel(model)
								while not HasModelLoaded(model) do Citizen.Wait(0) end
								local pos = GetEntityCoords(ped)
								local heading = GetEntityHeading(ped)
								local vehicle_temp = CreateVehicle(model, pos.x, pos.y, GetValidZFor_3dCoord(pos.x, pos.y, pos.z, true, false), heading, false, false)
								SetVehicleColourCombination(vehicle_temp, 0)
								local props = GetVehicleProperties(vehicle_temp) or {}
								checkpoint.respawnData = props
								if checkpoint_2 then
									checkpoint_2.respawnData = props
								end
								SetModelAsNoLongerNeeded(model)
								DeleteEntity(vehicle_temp)
							end
						end
					end
				end
				local checkpoint_respawn = lastCheckpointPair == 1 and currentRace.checkpoints_2[index] or currentRace.checkpoints[index]
				if checkpoint_respawn.respawnData.model == -422877666 then
					syncData.vehicle = "parachute"
					if checkpoint_respawn.respawnData.model ~= currentModel then
						DisplayCustomMsgs(GetTranslate("transform-parachute"), false, nil)
					end
					transformIsParachute = true
					transformIsBeast = false
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				elseif checkpoint_respawn.respawnData.model == -731262150 then
					syncData.vehicle = "beast"
					if checkpoint_respawn.respawnData.model ~= currentModel then
						DisplayCustomMsgs(GetTranslate("transform-beast"), false, nil)
					end
					transformIsParachute = false
					transformIsBeast = true
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
				else
					syncData.vehicle = GetDisplayNameFromVehicleModel(checkpoint_respawn.respawnData.model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(checkpoint_respawn.respawnData.model) or "Unknown"
					if checkpoint_respawn.respawnData.model ~= currentModel then
						DisplayCustomMsgs(GetLabelText(syncData.vehicle), false, nil)
					end
					transformIsParachute = false
					transformIsBeast = false
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				end
				if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(checkpoint_respawn.x, checkpoint_respawn.y, checkpoint_respawn.z, checkpoint_respawn.heading, true, false) end
				if reset then
					RespawnVehicle(checkpoint_respawn.x, checkpoint_respawn.y, checkpoint_respawn.z, checkpoint_respawn.heading, true, checkpoint_respawn, function(success)
						if success then
							ResetCheckpointAndBlipForRace()
							CreateBlipForRace(actualCheckpoint, actualLap)
							CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
							CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
						end
					end)
				else
					RespawnVehicle(checkpoint_respawn.x, checkpoint_respawn.y, checkpoint_respawn.z, checkpoint_respawn.heading, true, checkpoint_respawn)
				end
			end
			if currentRace.mode == "gta" then
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
		local checkpoint = currentRace.checkpoints[i]
		local checkpoint_2 = currentRace.checkpoints_2[i]
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
	local vehicle = GetVehiclePedIsIn(ped, false)
	local checkpoint_prev = lastCheckpointPair == 1 and currentRace.checkpoints_2[actualCheckpoint - 1] or currentRace.checkpoints[actualCheckpoint - 1]
	SetEntityCoords(vehicle > 0 and vehicle or ped, checkpoint_prev.x, checkpoint_prev.y, GetValidZFor_3dCoord(checkpoint_prev.x, checkpoint_prev.y, checkpoint_prev.z, false, true))
	SetEntityHeading(vehicle > 0 and vehicle or ped, checkpoint_prev.heading)
	PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
	ResetCheckpointAndBlipForRace()
	CreateBlipForRace(actualCheckpoint, actualLap)
	CreateCheckpointForRace(actualCheckpoint, false, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
	CreateCheckpointForRace(actualCheckpoint, true, actualCheckpoint == #currentRace.checkpoints and actualLap == currentRace.laps)
	return true
end

function RespawnVehicle(x, y, z, heading, engine, checkpoint, cb)
	local ped = PlayerPedId()
	local model = nil
	if checkpoint then
		if checkpoint.respawnData.model == -422877666 then
			DeleteCurrentVehicle()
			ClearPedBloodDamage(ped)
			ClearPedWetness(ped)
			GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
			SetEntityCoords(ped, x, y, GetValidZFor_3dCoord(x, y, z, false, true))
			SetEntityHeading(ped, heading)
			SetGameplayCamRelativeHeading(0)
			if cb ~= nil then
				cb(true)
			end
			return
		end
		if checkpoint.respawnData.model == -731262150 then
			DeleteCurrentVehicle()
			ClearPedBloodDamage(ped)
			ClearPedWetness(ped)
			SetEntityCoords(ped, x, y, GetValidZFor_3dCoord(x, y, z, false, true))
			SetEntityHeading(ped, heading)
			SetGameplayCamRelativeHeading(0)
			if cb ~= nil then
				cb(true)
			end
			return
		end
		model = checkpoint.respawnData.model
	else
		if type(raceVehicle) == "table" then
			model = raceVehicle.model
		elseif type(raceVehicle) == "number" then
			model = raceVehicle
		elseif type(raceVehicle) == "string" then
			model = GetHashKey(raceVehicle)
		end
	end
	local isHashValid = true
	if not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model) then
		if model then
			print("vehicle model (" .. model .. ") does not exist in current gta version! We have spawned a default vehicle for you")
		else
			print("Unknown error! We have spawned a default vehicle for you")
		end
		isHashValid = false
		model = GetHashKey("bmx")
		syncData.vehicle = GetDisplayNameFromVehicleModel(model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(model) or "Unknown"
		DisplayCustomMsgs(GetLabelText(syncData.vehicle), false, nil)
	end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(0)
	end
	-- Spawn vehicle at the top of the player, fix OneSync culling
	local pos = GetEntityCoords(ped)
	local newVehicle = CreateVehicle(model, pos.x, pos.y, GetValidZFor_3dCoord(pos.x, pos.y, pos.z, true, false), heading, true, false)
	local vehNetId = NetworkGetNetworkIdFromEntity(newVehicle)
	TriggerServerEvent("custom_races:server:spawnVehicle", vehNetId)
	SetModelAsNoLongerNeeded(model)
	FreezeEntityPosition(newVehicle, true)
	SetEntityCollision(newVehicle, false, false)
	SetVehRadioStation(newVehicle, "OFF")
	SetVehicleDoorsLocked(newVehicle, 10)
	SetVehicleColourCombination(newVehicle, 0)
	if checkpoint then
		SetVehicleProperties(newVehicle, checkpoint.respawnData)
	else
		if type(raceVehicle) == "number" or type(raceVehicle) == "string" or not isHashValid then
			local found = false
			for k, v in pairs(personalVehicles) do
				if v.model == model then
					raceVehicle = v
					SetVehicleProperties(newVehicle, v)
					found = true
					break
				end
			end
			if not found then
				raceVehicle = GetVehicleProperties(newVehicle) or {}
			end
		else
			SetVehicleProperties(newVehicle, raceVehicle)
		end
	end
	if currentRace.mode ~= "no_collision" then
		SetLocalPlayerAsGhost(true)
	end
	Citizen.Wait(0) -- Do not delete! Vehicle still has collisions before this. BUG?
	if cb ~= nil then
		cb(true)
	end
	DeleteCurrentVehicle()
	ClearPedBloodDamage(ped)
	ClearPedWetness(ped)
	-- Teleport the vehicle back to the checkpoint location
	SetEntityCoords(newVehicle, x, y, GetValidZFor_3dCoord(x, y, z, false, true))
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
	currentRace.lastVehicle = newVehicle
	if currentRace.mode ~= "no_collision" then
		if currentRace.mode == "gta" then
			SetVehicleDoorsLocked(newVehicle, 0)
		end
		Citizen.CreateThread(function()
			Citizen.Wait(500)
			local myServerId = GetPlayerServerId(PlayerId())
			while not isRespawningInProgress and (status == "ready" or status == "starting" or status == "racing") do
				local myCoords = GetEntityCoords(PlayerPedId())
				local isPedNearMe = false
				for _, driver in pairs(currentRace.drivers) do
					if myServerId ~= driver.playerId and (#(myCoords - driver.currentCoords) <= 10.0) then
						isPedNearMe = true
						break
					end
				end
				if not isPedNearMe or (currentRace.playerCount == 1) then
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

function TransformVehicle(checkpoint, speed, rotation, velocity, cb)
	isTransformingInProgress = true
	Citizen.CreateThread(function()
		local transform_vehicle = 0
		if checkpoint.is_random then
			transform_vehicle = GetRandomVehicleModel(checkpoint.random_class, checkpoint.random_custom, checkpoint.random_setting)
		else
			transform_vehicle = currentRace.transformVehicles[checkpoint.transform_index + 1]
		end
		local model = transform_vehicle and (tonumber(transform_vehicle) or GetHashKey(transform_vehicle)) or 0
		local ped = PlayerPedId()
		local copyVelocity = true
		if transformIsParachute or transformIsBeast then
			copyVelocity = ((math.abs(velocity.x) > 0.0) or (math.abs(velocity.y) > 0.0) or (math.abs(velocity.z) > 0.0)) and true or false
			speed = speed > 0.03 and speed or 30.0
		end
		if model == -422877666 then
			-- Parachute
			DeleteCurrentVehicle()
			cb({model = -422877666})
			syncData.vehicle = "parachute"
			DisplayCustomMsgs(GetTranslate("transform-parachute"), false, nil)
			GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			transformIsParachute = true
			transformIsBeast = false
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			isTransformingInProgress = false
			return
		elseif model == -731262150 then
			-- Beast mode
			DeleteCurrentVehicle()
			cb({model = -731262150})
			syncData.vehicle = "beast"
			DisplayCustomMsgs(GetTranslate("transform-beast"), false, nil)
			RemoveAllPedWeapons(ped, false)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			transformIsParachute = false
			transformIsBeast = true
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
			if currentRace.mode == "gta" then
				GiveWeapons(ped)
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
			end
			isTransformingInProgress = false
			return
		end
		local reset = false
		if model == 0 then
			-- Transform vehicle to the start vehicle
			reset = true
			model = raceVehicle.model
		end
		if not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model) then
			if model then
				print("vehicle model (" .. model .. ") does not exist in current gta version! We have spawned a default vehicle for you")
			else
				print("Unknown error! We have spawned a default vehicle for you")
			end
			model = GetHashKey("bmx")
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
		local newVehicle = CreateVehicle(model, pos.x, pos.y, GetValidZFor_3dCoord(pos.x, pos.y, pos.z, true, false), heading, true, false)
		local vehNetId = NetworkGetNetworkIdFromEntity(newVehicle)
		TriggerServerEvent("custom_races:server:spawnVehicle", vehNetId)
		SetModelAsNoLongerNeeded(model)
		DeleteCurrentVehicle()
		SetVehRadioStation(newVehicle, "OFF")
		SetVehicleDoorsLocked(newVehicle, 10)
		SetVehicleColourCombination(newVehicle, 0)
		local props = reset and raceVehicle or nil
		if not props then
			for k, v in pairs(personalVehicles) do
				if v.model == model then
					props = v
					break
				end
			end
		end
		props = props or GetVehicleProperties(newVehicle) or {}
		cb(props)
		SetVehicleProperties(newVehicle, props)
		SetPedIntoVehicle(ped, newVehicle, -1)
		SetEntityCoords(newVehicle, pos.x, pos.y, GetValidZFor_3dCoord(pos.x, pos.y, pos.z, false, true))
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
		if currentRace.mode == "gta" then
			GiveWeapons(ped)
			SetPedArmour(ped, 100)
			SetEntityHealth(ped, 200)
			SetVehicleDoorsLocked(newVehicle, 0)
		end
		currentRace.lastVehicle = newVehicle
		isTransformingInProgress = false
	end)
end

function GetRandomVehicleModel(random_class, random_custom, random_setting)
	local model = 0
	local random_vehicles = currentRace.random_vehicles
	local availableVehModels = {}
	local allVehModels = GetAllVehicleModels()
	if random_class >= 0 then
		if random_class == 0 then -- land
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if random_vehicles[hash] and (class <= 13 or class >= 17) and (class ~= 21) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif random_class == 1 then -- plane
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if class == 15 or class == 16 then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif random_class == 2 then -- boat
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if class == 14 then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif random_class == 3 then -- plane + land
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if (class == 15 or class == 16) or (random_vehicles[hash] and (class <= 13 or class >= 17) and (class ~= 21)) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		end
	elseif random_class == -1 then
		if random_custom == 1 then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if random_setting == vehicleClasses[class] then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif random_custom == 2 then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if IsBitSetValue(random_setting, class) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif random_custom == 3 then
			for _, model in pairs(random_setting) do
				local hash = tonumber(model) or GetHashKey(model)
				if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif random_custom == 4 then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				if IsThisModelACar(hash) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		end
	elseif random_class == -2 then
		local isKnownUnknowns = false
		for k, v in pairs(currentRace.transformVehicles) do
			local hash = tonumber(v) or GetHashKey(v)
			if hash ~= 0 then
				isKnownUnknowns = true
				break
			end
		end
		if not isKnownUnknowns then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				if random_vehicles[hash] then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		else
			local seen = {}
			for k, v in pairs(currentRace.transformVehicles) do
				local hash = tonumber(v) or GetHashKey(v)
				if not seen[hash] then
					seen[hash] = true
					table.insert(availableVehModels, hash)
				end
			end
		end
	end
	if #availableVehModels >= 2 then
		for i = 1, 10 do
			local randomIndex = math.random(#availableVehModels)
			local randomHash = availableVehModels[randomIndex]
			if GetVehicleModelNumberOfSeats(randomHash) >= 1 then
				model = randomHash
				break
			end
		end
	else
		for i = 1, 10 do
			local randomIndex = math.random(#allVehModels)
			local randomHash = GetHashKey(allVehModels[randomIndex])
			local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))
			if label ~= "NULL" and IsThisModelACar(randomHash) then
				if GetVehicleModelNumberOfSeats(randomHash) >= 1 then
					model = randomHash
					break
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
				RequestNamedPtfxAsset("scr_as_trans")
				while not HasNamedPtfxAssetLoaded("scr_as_trans") do
					Citizen.Wait(0)
				end
				UseParticleFxAssetNextCall("scr_as_trans")
				local effect = StartParticleFxLoopedOnEntity("scr_as_trans_smoke", playerPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)
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
	SetEntityCoords(entity, checkpoint.x, checkpoint.y, GetValidZFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false, true))
	SetEntityRotation(entity, entityRotation, 2)
	SetEntityHeading(entity, checkpoint.heading)
	SetVehicleForwardSpeed(entity, entitySpeed)
	SetGameplayCamRelativeHeading(0)
end

function SlowVehicle(entity)
	local speed = math.min(GetEntitySpeed(entity), GetVehicleEstimatedMaxSpeed(entity))
	SetVehicleForwardSpeed(entity, speed / 3.0)
end

function GetVehicleShouldSlowDown(checkpoint, entity)
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

function DeleteCurrentVehicle()
	if DoesEntityExist(currentRace.lastVehicle) then
		local vehId = NetworkGetNetworkIdFromEntity(currentRace.lastVehicle)
		DeleteEntity(currentRace.lastVehicle)
		TriggerServerEvent("custom_races:server:deleteVehicle", vehId)
	end
end

function ResetClient()
	ResetCheckpointAndBlipForRace()
	local ped = PlayerPedId()
	hasCheated = false
	togglePositionUI = false
	currentUiPage = 1
	transformIsParachute = false
	transformIsBeast = false
	isRespawningInProgress = false
	isTransformingInProgress = false
	isTeleportingInProgress = false
	arenaProps = {}
	explodeProps = {}
	fireworkProps = {}
	raceVehicle = {}
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
	currentRace = {
		roomId = nil,
		owner_name = "",
		title = "",
		blimp_text = "",
		laps = 1,
		weather = "",
		time = {},
		traffic = true,
		mode = "",
		roomData = nil,
		playerCount = 1,
		drivers = {},
		lastVehicle = nil,
		default_vehicle = nil,
		use_room_vehicle = false,
		random_vehicles = {},
		gridPositionIndex = 1,
		startingGrid = {
			[1] = {
				x = 0.0,
				y = 0.0,
				z = 0.0,
				heading = 0.0
			}
		},
		checkpoints = {},
		checkpoints_2 = {},
		transformVehicles = {},
		objects = {},
		fixtures = {},
		firework = {
			name = "scr_indep_firework_trailburst",
			r = 255,
			g = 255,
			b = 255
		}
	}
	ResetAndHideRespawnUI()
	FreezeEntityPosition(ped, true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	SetPedConfigFlag(ped, 151, true)
	SetPedCanBeKnockedOffVehicle(ped, 0)
	SetEntityInvincible(ped, false)
	SetPedArmour(ped, 100)
	SetEntityHealth(ped, 200)
	SetBlipAlpha(GetMainPlayerBlipId(), 255)
	SetEntityVisible(ped, isPedVisible)
	ClearPedBloodDamage(ped)
	ClearPedWetness(ped)
	SetLocalPlayerAsGhost(false)
	ClearAreaLeaveVehicleHealth(joinRacePoint.x + 0.0, joinRacePoint.y + 0.0, joinRacePoint.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
	ReleaseScriptAudioBank()
end

function FinishRace(raceStatus)
	status = "waiting"
	SendNUIMessage({
		action = "nui_msg:hideRaceHud"
	})
	local ped = PlayerPedId()
	local finishCoords = GetEntityCoords(ped)
	if GetDriversNotFinishAndNotDNF() >= 2 and raceStatus == "yeah" then
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
		syncData.lastCheckpointPair,
		IsUsingKeyboard()
	}, GetGameTimer() + 3000, hasCheated, vector3(RoundedValue(finishCoords.x, 3), RoundedValue(finishCoords.y, 3), RoundedValue(finishCoords.z, 3)), raceStatus)
	ResetCheckpointAndBlipForRace()
	Citizen.Wait(1000)
	SetEntityVisible(ped, false)
	FreezeEntityPosition(ped, true)
	DeleteCurrentVehicle()
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
	SetBlipAlpha(GetMainPlayerBlipId(), 0)
end

function LeaveRace()
	status = "leaving"
	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "nui_msg:hideRaceHud"
		})
		TriggerServerEvent("custom_races:server:leaveRace")
		local ped = PlayerPedId()
		RemoveFinishCamera()
		SwitchOutPlayer(ped, 0, 1)
		ResetCheckpointAndBlipForRace()
		Citizen.Wait(1000)
		DeleteCurrentVehicle()
		RemoveAllPedWeapons(ped, false)
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		Citizen.Wait(1500)
		RemoveLoadedObjects()
		Citizen.Wait(2500)
		if joinRaceVehicle ~= 0 then
			if DoesEntityExist(joinRaceVehicle) then
				NetworkRequestControlOfEntity(joinRaceVehicle)
				local timeOutCount = 0
				while timeOutCount < 20 and not NetworkHasControlOfEntity(joinRaceVehicle) do
					timeOutCount = timeOutCount + 1
					Citizen.Wait(100)
				end
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

function EndRace()
	status = "ending"
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		RemoveFinishCamera()
		SwitchOutPlayer(ped, 0, 1)
		ResetCheckpointAndBlipForRace()
		Citizen.Wait(1000)
		DeleteCurrentVehicle()
		RemoveAllPedWeapons(ped, false)
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		Citizen.Wait(1500)
		RemoveLoadedObjects()
		isOverClouds = true
		ShowScoreboard()
		Citizen.Wait(1000 + 2000 * (math.floor((currentRace.playerCount - 1) / 10) + 1))
		isOverClouds = false
		Citizen.Wait(1000)
		if joinRaceVehicle ~= 0 then
			if DoesEntityExist(joinRaceVehicle) then
				NetworkRequestControlOfEntity(joinRaceVehicle)
				local timeOutCount = 0
				while timeOutCount < 20 and not NetworkHasControlOfEntity(joinRaceVehicle) do
					timeOutCount = timeOutCount + 1
					Citizen.Wait(100)
				end
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
		local driversInfo = UpdateDriversInfo(currentRace.drivers)
		local currentUiPage_result = 1
		local firstLoad = true
		for k, v in pairs(currentRace.drivers) do
			if not v.dnf and v.hasFinished then
				table.insert(bestlapTable, {
					playerId = v.playerId,
					bestlap = v.bestlap
				})
			end
			table.insert(racefrontpos, {
				playerId = v.playerId,
				position = GetPlayerPosition(driversInfo, v.playerId),
				name = v.playerName,
				flag = v.flag or "US",
				keyboard = v.keyboard and "💻" or "🎮",
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
			local endIdx = math.min(startIdx + 10 - 1, currentRace.playerCount)
			local racefrontpos_show = {}
			for i = startIdx, endIdx do
				local player = racefrontpos[i]
				if player then
					table.insert(racefrontpos_show, player)
				end
			end
			SendNUIMessage({
				action = "nui_msg:showScoreboard",
				racefrontpos = racefrontpos_show,
				animation = firstLoad
			})
			firstLoad = false
			if (currentUiPage_result * 10) < currentRace.playerCount then
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
	for k, v in pairs(currentRace.objects) do
		DeleteObject(v.handle)
	end
end

function CreateFinishCamera()
	ClearFocus()
	local rotZ = currentRace.checkpoints[#currentRace.checkpoints].heading
	if rotZ < 0 then
		rotZ = rotZ - 180.0
	elseif rotZ > 0 then
		rotZ = rotZ + 180.0
	end
	finishCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", currentRace.checkpoints[#currentRace.checkpoints].x, currentRace.checkpoints[#currentRace.checkpoints].y, currentRace.checkpoints[#currentRace.checkpoints].z + 5.0, 0.0, 0.0, rotZ, 90.0)
	SetCamActive(finishCamera, true)
	RenderScriptCams(true, false, 0, true, false)
	SetCamAffectsAiming(finishCamera, false)
end

function RemoveFinishCamera()
	if not finishCamera then return end
	ClearFocus()
	RenderScriptCams(false, false, 0, true, false)
	DestroyCam(finishCamera, false)
	finishCamera = nil
end

function GiveWeapons(ped)
	for k, v in pairs(availableWeapons) do
		GiveWeaponToPed(ped, k, v, true, false)
	end
end

function GetDriversNotFinishAndNotDNF()
	local count = 0
	for k, v in pairs(currentRace.drivers) do
		if not v.hasFinished and not v.dnf then
			count = count + 1
		end
	end
	return count
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

function UpdatePauseMenuInfo()
	SendNUIMessage({
		action = "nui_msg:updatePauseMenu",
		img = currentRace.roomData.img,
		title = currentRace.title .. " - made by [" .. currentRace.owner_name .. "]",
		dnf = currentRace.roomData.dnf,
		traffic = currentRace.roomData.traffic,
		weather = currentRace.roomData.weather,
		time = currentRace.roomData.time .. ":00",
		accessible = currentRace.roomData.accessible,
		mode = currentRace.roomData.mode
	})
end

function SetCurrentRace()
	-- Set weather and time, remove npc and traffic
	Citizen.CreateThread(function()
		ClearOverrideWeather()
		ClearWeatherTypePersist()
		SetWeatherTypePersist(currentRace.weather)
		SetWeatherTypeNow(currentRace.weather)
		SetWeatherTypeNowPersist(currentRace.weather)
		SetRainLevel(-1.0)
		if currentRace.weather == "XMAS" then
			SetForceVehicleTrails(true)
			SetForcePedFootstepsTracks(true)
		else
			SetForceVehicleTrails(false)
			SetForcePedFootstepsTracks(false)
		end
		while status ~= "freemode" do
			NetworkOverrideClockTime(currentRace.time.hour, currentRace.time.minute, currentRace.time.second)
			if not currentRace.traffic then
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				RemoveVehiclesFromGeneratorsInArea(pos[1] - 200.0, pos[2] - 200.0, pos[3] - 200.0, pos[1] + 200.0, pos[2] + 200.0, pos[3] + 200.0)
				SetVehicleDensityMultiplierThisFrame(0.0)
				SetRandomVehicleDensityMultiplierThisFrame(0.0)
				SetParkedVehicleDensityMultiplierThisFrame(0.0)
				SetGarbageTrucks(0)
				SetRandomBoats(0)
				SetPedDensityMultiplierThisFrame(0.0)
				SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
			end
			DisableControlAction(0, 75, true) -- F
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
				local driversInfo = UpdateDriversInfo(currentRace.drivers)
				if firstLoad then
					for k, v in pairs(currentRace.drivers) do
						if v.hasFinished then
							-- When joining a race midway, other players have already finished
							finishedPlayer[v.playerId] = true
						end
					end
					firstLoad = false
				end
				for k, v in pairs(currentRace.drivers) do
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
		ScaleformMovieMethodAddParamLiteralString(currentRace.blimp_text or "")
		EndScaleformMovieMethod()
		BeginScaleformMovieMethod(scaleform, "SET_COLOUR")
		ScaleformMovieMethodAddParamInt(1)
		EndScaleformMovieMethod()
		BeginScaleformMovieMethod(scaleform, "SET_SCROLL_SPEED")
		ScaleformMovieMethodAddParamFloat(100.0)
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
	-- Loop get fps and sync to other players
	Citizen.CreateThread(function()
		Citizen.Wait(3000)
		while status == "loading_track" or status == "ready" or status == "starting" or status == "racing" do
			local startCount = GetFrameCount()
			Citizen.Wait(1000)
			local endCount = GetFrameCount()
			local fps = endCount - startCount - 1
			if fps <= 0 then fps = 1 end
			syncData.fps = fps
		end
	end)
end

function SetFireworks()
	if #fireworkProps > 0 then
		Citizen.CreateThread(function()
			while status ~= "freemode" do
				local ped = status == "spectating" and DoesEntityExist(spectateData.ped) and spectateData.ped or PlayerPedId()
				local pos = GetEntityCoords(ped)
				for k, v in pairs(fireworkProps) do
					if not v.playing and DoesEntityExist(v.handle) and (#(pos - GetEntityCoords(v.handle)) <= 50.0) then
						v.playing = true
						Citizen.CreateThread(function()
							RequestNamedPtfxAsset("scr_indep_fireworks")
							while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
								Citizen.Wait(0)
							end
							UseParticleFxAssetNextCall("scr_indep_fireworks")
							local effect = StartParticleFxLoopedOnEntity(currentRace.firework.name, v.handle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)
							local r, g, b = tonumber(currentRace.firework.r), tonumber(currentRace.firework.g), tonumber(currentRace.firework.b)
							if r and g and b then
								SetParticleFxLoopedColour(effect, (r / 255) + 0.0, (g / 255) + 0.0, (b / 255) + 0.0, true)
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
	end
end

function RemoveFixtures()
	if #currentRace.fixtures > 0 then
		Citizen.CreateThread(function()
			local hide = {}
			for k, v in pairs(currentRace.fixtures) do
				hide[v.hash] = true
			end
			local spawn = {}
			for k, v in pairs(currentRace.objects) do
				spawn[v.handle] = true
			end
			while status ~= "freemode" do
				if status == "starting" or status == "racing" or status == "spectating" then
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
					for k, v in pairs(currentRace.fixtures) do
						local fixture = GetClosestObjectOfType(pos.x, pos.y, pos.z, 300.0, v.hash, false)
						if fixture and not spawn[fixture] and DoesEntityExist(fixture) then
							SetEntityAsMissionEntity(fixture, true, true)
							DeleteEntity(fixture)
						end
					end
				elseif status == "leaving" or status == "ending" then
					break
				end
				Citizen.Wait(0)
			end
		end)
	end
end

function StartSyncDataToServer()
	Citizen.CreateThread(function()
		while status == "ready" or status == "starting" or status == "racing" do
			TriggerServerEvent("custom_races:server:clientSync", {
				syncData.fps,
				syncData.actualLap,
				syncData.actualCheckpoint,
				syncData.vehicle,
				syncData.lastlap,
				syncData.bestlap,
				syncData.totalRaceTime,
				syncData.totalCheckpointsTouched,
				syncData.lastCheckpointPair,
				IsUsingKeyboard()
			}, GetGameTimer())
			Citizen.Wait(500)
		end
	end)
end

RegisterNetEvent("custom_races:client:loadTrack", function(roomData, data, roomId, gridPositionIndex)
	status = "loading_track"
	TriggerEvent("custom_races:loadrace")
	TriggerServerEvent("custom_core:server:inRace", true)
	SetLocalPlayerAsGhost(true)
	currentRace.roomId = roomId
	currentRace.owner_name = data.mission.gen.ownerid
	currentRace.title = data.mission.gen.nm
	currentRace.blimp_text = data.mission.gen.blmpmsg
	currentRace.laps = tonumber(roomData.laps)
	currentRace.weather = roomData.weather
	currentRace.time = {hour = tonumber(roomData.time), minute = 0, second = 0}
	currentRace.traffic = roomData.traffic ~= "off" and true or false
	currentRace.mode = roomData.mode
	currentRace.roomData = roomData
	currentRace.playerCount = 1
	currentRace.drivers = {}
	currentRace.lastVehicle = nil
	currentRace.default_vehicle = nil
	currentRace.use_room_vehicle = roomData.vehicle ~= "default" and true or false
	currentRace.random_vehicles = {}
	UpdatePauseMenuInfo()
	if joinRaceVehicle ~= 0 and not currentRace.use_room_vehicle then
		raceVehicle = GetVehicleProperties(joinRaceVehicle) or {}
	end
	local adlcs = {data.mission.race.adlc, data.mission.race.adlc2, data.mission.race.adlc3}
	local aveh = data.mission.race.aveh
	local clbs = data.mission.race.clbs
	local icv = data.mission.race.icv
	local ivm = data.mission.gen.ivm
	for classid = 0, 27 do
		if IsBitSetValue(clbs, classid) then
			if vanilla[classid].aveh then
				if aveh[classid + 1] then
					for i = 0, #vanilla[classid].aveh - 1 do
						if not IsBitSetValue(aveh[classid + 1], i) then
							local model = vanilla[classid].aveh[i + 1]
							local hash = GetHashKey(model)
							if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
								currentRace.random_vehicles[hash] = true
							end
						end
					end
				end
			end
			if vanilla[classid].adlc then
				for offset, adlc in ipairs(adlcs) do
					if adlc[classid + 1] then
						for i = 0, 30 do
							if IsBitSetValue(adlc[classid + 1], i) then
								local model = vanilla[classid].adlc[(offset - 1) * 31 + i + 1]
								local hash = model and GetHashKey(model)
								if hash and IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
									currentRace.random_vehicles[hash] = true
								end
							end
						end
					end
				end
			end
		end
	end
	if IsModelInCdimage(ivm) and IsModelValid(ivm) and IsModelAVehicle(ivm) then
		currentRace.default_vehicle = ivm
	else
		local default_vehicle = vanilla[icv] and vanilla[icv].aveh and vanilla[icv].aveh[ivm + 1]
		if default_vehicle then
			currentRace.default_vehicle = default_vehicle
		else
			if data.test_vehicle then
				currentRace.default_vehicle = data.test_vehicle
			else
				local random_vehicles = {}
				for k, v in pairs(currentRace.random_vehicles) do
					table.insert(random_vehicles, k)
				end
				if #random_vehicles > 0 then
					currentRace.default_vehicle = random_vehicles[math.random(#random_vehicles)]
				end
			end
		end
	end
	currentRace.transformVehicles = data.mission.race.trfmvm
	currentRace.firework = data.firework
	currentRace.gridPositionIndex = gridPositionIndex <= data.mission.veh.no and gridPositionIndex or 1
	currentRace.startingGrid = {}
	for i = 1, data.mission.veh.no do
		local loc = data.mission.veh.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local head = data.mission.veh.head[i] or 0.0
		local x = RoundedValue(loc.x, 3)
		local y = RoundedValue(loc.y, 3)
		local z = RoundedValue(loc.z, 3)
		currentRace.startingGrid[i] = {
			x = x,
			y = y,
			z = GetValidZFor_3dCoord(x, y, z, false, false),
			heading = RoundedValue(head, 3)
		}
	end
	currentRace.checkpoints = {}
	currentRace.checkpoints_2 = {}
	for i = 1, data.mission.race.chp, 1 do
		local chl = data.mission.race.chl[i] or {}
		chl.x = chl.x or 0.0
		chl.y = chl.y or 0.0
		chl.z = chl.z or 0.0
		local chh = data.mission.race.chh[i] or 0.0
		local chs = data.mission.race.chs[i] or 1.0
		local chvs = data.mission.race.chvs[i] or chs
		local chpp = data.mission.race.chpp[i] or 0.0
		local cpado = data.mission.race.cpado[i] or {}
		cpado.x = cpado.x or 0.0
		cpado.y = cpado.y or 0.0
		cpado.z = cpado.z or 0.0
		local chstR = data.mission.race.chstR[i] or 500.0
		local cptfrm = data.mission.race.cptfrm[i] or -1
		local cptrtt = data.mission.race.cptrtt[i] or -2
		local cptrst = data.mission.race.cptrst[i] or 0
		local cpbs1 = data.mission.race.cpbs1[i] or nil
		local cpbs2 = data.mission.race.cpbs2[i] or nil
		local cpbs3 = data.mission.race.cpbs3[i] or nil
		local cppsst = data.mission.race.cppsst[i] or nil
		currentRace.checkpoints[i] = {
			x = RoundedValue(chl.x, 3),
			y = RoundedValue(chl.y, 3),
			z = RoundedValue(chl.z, 3),
			heading = RoundedValue(chh, 3),
			d_collect = RoundedValue(chs >= 0.5 and chs or 1.0, 3),
			d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
			pitch = chpp,
			offset = cpado,
			lock_dir = cpbs1 and ((IsBitSetValue(cpbs1, 16) and not (cpado.x == 0.0 and cpado.y == 0.0 and cpado.z == 0.0)) or IsBitSetValue(cpbs1, 18)),
			is_pit = cpbs2 and IsBitSetValue(cpbs2, 16),
			is_tall = cpbs2 and IsBitSetValue(cpbs2, 20),
			tall_radius = chstR,
			lower_alpha = cpbs2 and IsBitSetValue(cpbs2, 24),
			is_round = cpbs1 and IsBitSetValue(cpbs1, 1),
			is_air = cpbs1 and IsBitSetValue(cpbs1, 9),
			is_fake = cpbs1 and IsBitSetValue(cpbs1, 10),
			is_random = cptfrm == -2,
			random_class = cptfrm == -2 and cptrtt,
			random_custom = cptfrm == -2 and cptrtt == -1 and ((type(cptrst) == "string" and 1) or (type(cptrst) == "number" and 2) or (type(cptrst) == "table" and 3) or (type(cptrst) == "boolean" and 4)),
			random_setting = cptfrm == -2 and cptrtt == -1 and cptrst,
			is_transform = cptfrm >= 0,
			transform_index = cptfrm >= 0 and cptfrm,
			is_planeRot = cppsst and ((IsBitSetValue(cppsst, 0)) or (IsBitSetValue(cppsst, 1)) or (IsBitSetValue(cppsst, 2)) or (IsBitSetValue(cppsst, 3))),
			plane_rot = cppsst and ((IsBitSetValue(cppsst, 0) and 0) or (IsBitSetValue(cppsst, 1) and 1) or (IsBitSetValue(cppsst, 2) and 2) or (IsBitSetValue(cppsst, 3) and 3)),
			is_warp = cpbs1 and IsBitSetValue(cpbs1, 27)
		}
		if currentRace.checkpoints[i].is_random or currentRace.checkpoints[i].is_transform or currentRace.checkpoints[i].is_planeRot or currentRace.checkpoints[i].is_warp then
			currentRace.checkpoints[i].is_round = true
		end
		if currentRace.checkpoints[i].lock_dir then
			currentRace.checkpoints[i].is_round = true
		end
		local sndchk = data.mission.race.sndchk[i] or {}
		sndchk.x = sndchk.x or 0.0
		sndchk.y = sndchk.y or 0.0
		sndchk.z = sndchk.z or 0.0
		if not (sndchk.x == 0.0 and sndchk.y == 0.0 and sndchk.z == 0.0) then
			local sndrsp = data.mission.race.sndrsp[i] or 0.0
			local chs2 = data.mission.race.chs2[i] or chs
			local chpps = data.mission.race.chpps[i] or 0.0
			local cpados = data.mission.race.cpados[i] or {}
			cpados.x = cpados.x or 0.0
			cpados.y = cpados.y or 0.0
			cpados.z = cpados.z or 0.0
			local chstRs = data.mission.race.chstRs[i] or 500.0
			local cptfrms = data.mission.race.cptfrms[i] or -1
			local cptrtts = data.mission.race.cptrtts[i] or -2
			local cptrsts = data.mission.race.cptrsts[i] or 0
			currentRace.checkpoints_2[i] = {
				x = RoundedValue(sndchk.x, 3),
				y = RoundedValue(sndchk.y, 3),
				z = RoundedValue(sndchk.z, 3),
				heading = RoundedValue(sndrsp, 3),
				d_collect = RoundedValue(chs2 >= 0.5 and chs2 or 1.0, 3),
				d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
				pitch = chpps,
				offset = cpados,
				lock_dir = cpbs1 and ((IsBitSetValue(cpbs1, 17) and not (cpados.x == 0.0 and cpados.y == 0.0 and cpados.z == 0.0)) or IsBitSetValue(cpbs1, 19)),
				is_pit = cpbs2 and IsBitSetValue(cpbs2, 17),
				is_tall = cpbs2 and IsBitSetValue(cpbs2, 21),
				tall_radius = chstRs,
				lower_alpha = cpbs2 and IsBitSetValue(cpbs2, 25),
				is_round = cpbs1 and IsBitSetValue(cpbs1, 2),
				is_air = cpbs1 and IsBitSetValue(cpbs1, 13),
				is_fake = cpbs1 and IsBitSetValue(cpbs1, 11),
				is_random = cptfrms == -2,
				random_class = cptfrms == -2 and cptrtts,
				random_custom = cptfrms == -2 and cptrtts == -1 and ((type(cptrsts) == "string" and 1) or (type(cptrsts) == "number" and 2) or (type(cptrsts) == "table" and 3) or (type(cptrsts) == "boolean" and 4)),
				random_setting = cptfrms == -2 and cptrtts == -1 and cptrsts,
				is_transform = cptfrms >= 0,
				transform_index = cptfrms >= 0 and cptfrms,
				is_planeRot = cppsst and ((IsBitSetValue(cppsst, 4)) or (IsBitSetValue(cppsst, 5)) or (IsBitSetValue(cppsst, 6)) or (IsBitSetValue(cppsst, 7))),
				plane_rot = cppsst and ((IsBitSetValue(cppsst, 4) and 0) or (IsBitSetValue(cppsst, 5) and 1) or (IsBitSetValue(cppsst, 6) and 2) or (IsBitSetValue(cppsst, 7) and 3)),
				is_warp = cpbs1 and IsBitSetValue(cpbs1, 28)
			}
			if currentRace.checkpoints_2[i].is_random or currentRace.checkpoints_2[i].is_transform or currentRace.checkpoints_2[i].is_planeRot or currentRace.checkpoints_2[i].is_warp then
				currentRace.checkpoints_2[i].is_round = true
			end
			if currentRace.checkpoints_2[i].lock_dir then
				currentRace.checkpoints_2[i].is_round = true
			end
		end
	end
	currentRace.fixtures = {}
	local seen = {}
	for i = 1, data.mission.dhprop.no do
		local mn = data.mission.dhprop.mn[i]
		if mn and not seen[mn] and IsModelInCdimage(mn) and IsModelValid(mn) then
			seen[mn] = true
			currentRace.fixtures[#currentRace.fixtures + 1] = {
				hash = mn
			}
		end
	end
	SetCurrentRace()
	Citizen.Wait(500)
	BeginTextCommandBusyString("STRING")
	AddTextComponentSubstringPlayerName("Loading [" .. currentRace.title .. "]")
	EndTextCommandBusyString(2)
	Citizen.Wait(1000)
	local invalidObjects = {}
	currentRace.objects = {}
	for i = 1, data.mission.prop.no do
		RemoveLoadingPrompt()
		if status == "leaving" or status == "ending" or status == "freemode" then return end
		BeginTextCommandBusyString("STRING")
		AddTextComponentSubstringPlayerName("Loading [" .. currentRace.title .. "] (" .. math.floor(i * 100 / (data.mission.prop.no + data.mission.dprop.no)) .. "%)")
		EndTextCommandBusyString(2)
		local model = data.mission.prop.model[i] or 779917859
		local loc = data.mission.prop.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local vRot = data.mission.prop.vRot[i] or {}
		vRot.x = vRot.x or 0.0
		vRot.y = vRot.y or 0.0
		vRot.z = vRot.z or 0.0
		local prpclr = data.mission.prop.prpclr[i] or 0
		local pLODDist = data.mission.prop.pLODDist[i] or 16960
		local collision = data.mission.prop.collision[i] or (not noCollisionObjects[model] and 1 or 0)
		local prpbs = data.mission.prop.prpbs[i] or 0
		local prpsba = data.mission.prop.prpsba[i] or 2
		local object = {
			hash = model,
			handle = nil,
			x = RoundedValue(loc.x, 3),
			y = RoundedValue(loc.y, 3),
			z = RoundedValue(loc.z, 3),
			rotX = RoundedValue(vRot.x, 3),
			rotY = RoundedValue(vRot.y, 3),
			rotZ = RoundedValue(vRot.z, 3),
			color = prpclr,
			prpsba = prpsba,
			visible = not IsBitSetValue(prpbs, 9) and (pLODDist ~= 1),
			collision = collision == 1,
			dynamic = false
		}
		object.handle = CreatePropForRace(object.hash, object.x, object.y, object.z, object.rotX, object.rotY, object.rotZ, object.color, object.prpsba)
		if object.handle then
			if object.hash == 73742208 or object.hash == -977919647 or object.hash == -1081534242 or object.hash == 1243328051 then
				FreezeEntityPosition(object.handle, false)
			else
				FreezeEntityPosition(object.handle, true)
			end
			if not object.visible then
				SetEntityVisible(object.handle, false)
			else
				SetEntityLodDist(object.handle, pLODDist > 1 and pLODDist or 16960)
			end
			if not object.collision then
				SetEntityCollision(object.handle, false, false)
			end
			currentRace.objects[#currentRace.objects + 1] = object
			if fireworkObjects[object.hash] then
				fireworkProps[#fireworkProps + 1] = object
			end
		else
			invalidObjects[object.hash] = true
		end
	end
	for i = 1, data.mission.dprop.no do
		RemoveLoadingPrompt()
		if status == "leaving" or status == "ending" or status == "freemode" then return end
		BeginTextCommandBusyString("STRING")
		AddTextComponentSubstringPlayerName("Loading [" .. currentRace.title .. "] (" .. math.floor((i + data.mission.prop.no) * 100 / (data.mission.prop.no + data.mission.dprop.no)) .. "%)")
		EndTextCommandBusyString(2)
		local model = data.mission.dprop.model[i] or 779917859
		local loc = data.mission.dprop.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local vRot = data.mission.dprop.vRot[i] or {}
		vRot.x = vRot.x or 0.0
		vRot.y = vRot.y or 0.0
		vRot.z = vRot.z or 0.0
		local prpdclr = data.mission.dprop.prpdclr[i] or 0
		local collision = data.mission.dprop.collision[i] or (not noCollisionObjects[model] and 1 or 0)
		local object = {
			hash = model,
			handle = nil,
			x = RoundedValue(loc.x, 3),
			y = RoundedValue(loc.y, 3),
			z = RoundedValue(loc.z, 3),
			rotX = RoundedValue(vRot.x, 3),
			rotY = RoundedValue(vRot.y, 3),
			rotZ = RoundedValue(vRot.z, 3),
			color = prpdclr,
			prpsba = 2,
			visible = true,
			collision = collision == 1,
			dynamic = true
		}
		object.handle = CreatePropForRace(object.hash, object.x, object.y, object.z, object.rotX, object.rotY, object.rotZ, object.color, object.prpsba)
		if object.handle then
			SetEntityLodDist(object.handle, 16960)
			if not object.collision then
				SetEntityCollision(object.handle, false, false)
			end
			currentRace.objects[#currentRace.objects + 1] = object
			if arenaObjects[object.hash] then
				arenaProps[#arenaProps + 1] = object
			end
			if explodeObjects[object.hash] then
				explodeProps[#explodeProps + 1] = object
			end
			if fireworkObjects[object.hash] then
				fireworkProps[#fireworkProps + 1] = object
			end
		else
			invalidObjects[object.hash] = true
		end
	end
	RemoveLoadingPrompt()
	if status == "leaving" or status == "ending" or status == "freemode" then return end
	for k, v in pairs(invalidObjects) do
		print("model (" .. k .. ") does not exist or is invalid!")
		DisplayCustomMsgs(string.format(GetTranslate("object-hash-null"), k))
	end
	if TableCount(invalidObjects) > 0 then
		print("Ask the server owner to stream invalid models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end
	SetFireworks()
	RemoveFixtures()
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	for k, v in pairs(invalidObjects) do
		DisplayCustomMsgs(string.format(GetTranslate("object-hash-null"), k), false, nil)
	end
end)

RegisterNetEvent("custom_races:client:startRaceRoom", function(vehicle, personals, joinMidway)
	if GetResourceState("spawnmanager") == "started" and exports.spawnmanager and exports.spawnmanager.setAutoSpawn then
		exports.spawnmanager:setAutoSpawn(false)
	end
	local ped = PlayerPedId()
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
	Citizen.Wait(3000)
	SetEntityCoords(ped, currentRace.startingGrid[1].x, currentRace.startingGrid[1].y, currentRace.startingGrid[1].z)
	SetEntityHeading(ped, currentRace.startingGrid[1].heading)
	SwitchInPlayer(ped)
	Citizen.Wait(1000)
	if DoesEntityExist(joinRaceVehicle) then
		SetEntityVisible(joinRaceVehicle, false)
		SetEntityCollision(joinRaceVehicle, false, false)
		FreezeEntityPosition(joinRaceVehicle, true)
	end
	Citizen.Wait(1000)
	StopScreenEffect("MenuMGIn")
	if currentRace.use_room_vehicle then
		raceVehicle = vehicle or "bmx"
	else
		if type(raceVehicle) == "table" and not raceVehicle.model then
			raceVehicle = currentRace.default_vehicle or "bmx"
		end
	end
	if type(raceVehicle) == "table" then
		syncData.vehicle = raceVehicle.model and GetDisplayNameFromVehicleModel(raceVehicle.model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(raceVehicle.model) or "Unknown"
	elseif type(raceVehicle) == "number" then
		syncData.vehicle = GetDisplayNameFromVehicleModel(raceVehicle) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(raceVehicle) or "Unknown"
	elseif type(raceVehicle) == "string" then
		syncData.vehicle = GetDisplayNameFromVehicleModel(GetHashKey(raceVehicle)) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(GetHashKey(raceVehicle)) or "Unknown"
	end
	personalVehicles = {}
	for k, v in pairs(personals) do
		if v.plate then
			personalVehicles[v.plate] = v
		end
	end
	Citizen.CreateThread(function()
		JoinRace()
		StartSyncDataToServer()
		SendNUIMessage({
			action = "nui_msg:hideLoad"
		})
		Citizen.Wait(1000)
		while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
		enableXboxController = false
		if joinMidway then
			if status == "ready" then
				StartRace()
			end
		else
			TriggerServerEvent("custom_races:server:raceLoaded")
			Citizen.Wait(5000)
			while status == "ready" do
				DisplayCustomMsgs(GetTranslate("wait-players"), false, nil)
				Citizen.Wait(10000)
			end
		end
	end)
end)

RegisterNetEvent("custom_races:client:startRace", function()
	if status == "ready" then
		StartRace()
	end
end)

RegisterNetEvent("custom_races:client:syncDrivers", function(drivers, gameTimer)
	if not timeServerSide["syncDrivers"] or timeServerSide["syncDrivers"] < gameTimer then
		timeServerSide["syncDrivers"] = gameTimer
		local copy_drivers = {}
		local count = 0
		for k, v in pairs(drivers) do
			count = count + 1
			copy_drivers[v[1]] = {
				playerId = v[1],
				playerName = v[2],
				ping = v[3],
				fps = v[4],
				actualLap = v[5],
				actualCheckpoint = v[6],
				vehicle = v[7],
				lastlap = v[8],
				bestlap = v[9],
				totalRaceTime = v[10],
				totalCheckpointsTouched = v[11],
				lastCheckpointPair = v[12],
				hasFinished = v[13],
				currentCoords = v[14],
				finishCoords = v[15],
				dnf = v[16],
				keyboard = v[17],
				flag = v[18]
			}
		end
		currentRace.playerCount = count
		currentRace.drivers = copy_drivers
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
	if status == "racing" and roomId == currentRace.roomId then
		FinishRace("dnf")
	end
end)

RegisterNetEvent("custom_races:client:enableSpectatorMode", function(raceStatus)
	Citizen.Wait(1000)
	if status ~= "waiting" then return end
	status = "spectating"
	TriggerEvent("custom_races:startSpectating")
	TriggerServerEvent("custom_core:server:inSpectator", true)
	local myServerId = GetPlayerServerId(PlayerId())
	local actionFromUser = (raceStatus == "spectator") and true or false
	local timeOutCount = 0
	Citizen.CreateThread(function()
		while status == "spectating" do
			spectateData.players = {}
			local driversInfo = UpdateDriversInfo(currentRace.drivers)
			for _, driver in pairs(currentRace.drivers) do
				if not driver.hasFinished and driver.playerId ~= myServerId then
					driver.position = GetPlayerPosition(driversInfo, driver.playerId)
					driver.flag = driver.flag or "US"
					driver.keyboard = driver.keyboard and "💻" or "🎮"
					table.insert(spectateData.players, driver)
				end
			end
			table.sort(spectateData.players, function(a, b)
				return a.position < b.position
			end)
			if #spectateData.players > 0 then
				local canPlaySound = false
				if spectateData.playerId then
					for k, v in pairs(spectateData.players) do
						if spectateData.playerId == v.playerId then
							spectateData.index = k
							break
						end
					end
					if spectateData.ped and not DoesEntityExist(spectateData.ped) then
						spectateData.playerId = nil
					end
				end
				if spectateData.players[spectateData.index] == nil then
					spectateData.index = 1
				end
				if spectateData.playerId ~= spectateData.players[spectateData.index].playerId then
					DoScreenFadeOut(500)
					spectateData.isFadeOut = true
					spectateData.fadeOutTime = GetGameTimer()
					Citizen.Wait(500)
					canPlaySound = true
					spectateData.playerId = spectateData.players[spectateData.index].playerId
					spectateData.ped = nil
					TriggerServerEvent("custom_races:server:spectatePlayer", spectateData.playerId, actionFromUser)
					actionFromUser = false
				end
				local ped = PlayerPedId()
				SetEntityCoordsNoOffset(ped, spectateData.players[spectateData.index].currentCoords + vector3(0.0, 0.0, 50.0))
				if not spectateData.ped or not NetworkIsInSpectatorMode() then
					spectateData.ped = spectateData.playerId and GetPlayerPed(GetPlayerFromServerId(spectateData.playerId))
					if spectateData.ped and DoesEntityExist(spectateData.ped) and (spectateData.ped ~= ped) then
						RemoveFinishCamera()
						NetworkSetInSpectatorMode(true, spectateData.ped)
						SetMinimapInSpectatorMode(true, spectateData.ped)
						DoScreenFadeIn(500)
						spectateData.isFadeOut = false
						spectateData.fadeOutTime = nil
					else
						spectateData.ped = nil
					end
				end
				local isFadeOut = spectateData.isFadeOut
				local fadeOutTime = spectateData.fadeOutTime
				if isFadeOut and fadeOutTime and (GetGameTimer() - fadeOutTime > 3000) then
					DoScreenFadeIn(500)
					spectateData.isFadeOut = false
					spectateData.fadeOutTime = nil
				end
				local playersPerPage = 10
				local currentPage = math.floor((spectateData.index - 1) / playersPerPage) + 1
				local startIdx = (currentPage - 1) * playersPerPage + 1
				local endIdx = math.min(startIdx + playersPerPage - 1, #spectateData.players)
				local players = {}
				for i = startIdx, endIdx do
					table.insert(players, spectateData.players[i])
				end
				SendNUIMessage({
					action = "nui_msg:showSpectate",
					players = players,
					playerid = spectateData.playerId,
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
		SendNUIMessage({
			action = "nui_msg:hideSpectate"
		})
		if spectateData.isFadeOut then
			DoScreenFadeIn(500)
		end
		spectateData = {
			isFadeOut = false,
			fadeOutTime = nil,
			playerId = nil,
			ped = nil,
			index = 0,
			players = {}
		}
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
			if #spectateData.players >= 2 then
				if IsControlJustPressed(0, 172) --[[Up Arrow]] then
					spectateData.index = spectateData.index -1
					if spectateData.index < 1 or spectateData.index > #spectateData.players then
						spectateData.index = #spectateData.players
					end
					spectateData.playerId = nil
					actionFromUser = true
				end
				if IsControlJustPressed(0, 173) --[[Down Arrow]] then
					spectateData.index = spectateData.index + 1
					if spectateData.index > #spectateData.players then
						spectateData.index = 1
					end
					spectateData.playerId = nil
					actionFromUser= true
				end
			end
			if #spectateData.players > 0 then
				local driverInfo_spectate = spectateData.playerId and currentRace.drivers[spectateData.playerId]
				if driverInfo_spectate then
					local totalCheckpointsTouched_spectate = driverInfo_spectate.totalCheckpointsTouched
					local actualCheckpoint_spectate = driverInfo_spectate.actualCheckpoint
					local actualLap_spectate = driverInfo_spectate.actualLap
					local vehicle_spectate = GetVehiclePedIsIn(DoesEntityExist(spectateData.ped) and spectateData.ped or PlayerPedId(), false)
					local checkpoint_spectate = currentRace.checkpoints[actualCheckpoint_spectate]
					local checkpoint_2_spectate = currentRace.checkpoints_2[actualCheckpoint_spectate]
					if checkpoint_spectate and not (actualCheckpoint_spectate == #currentRace.checkpoints and actualLap_spectate == currentRace.laps) then
						if checkpoint_spectate.is_planeRot and checkpoint_spectate.draw_id then
							if vehicle_spectate ~= 0 and GetVehicleShouldSlowDown(checkpoint_spectate, vehicle_spectate) then
								local r, g, b = GetHudColour(6)
								SetCheckpointRgba2(checkpoint_spectate.draw_id, r, g, b, 150)
							else
								local r, g, b = GetHudColour(134)
								SetCheckpointRgba2(checkpoint_spectate.draw_id, r, g, b, 150)
							end
						end
					end
					if checkpoint_2_spectate and not (actualCheckpoint_spectate == #currentRace.checkpoints and actualLap_spectate == currentRace.laps) then
						if checkpoint_2_spectate.is_planeRot and checkpoint_2_spectate.draw_id then
							if vehicle_spectate ~= 0 and GetVehicleShouldSlowDown(checkpoint_2_spectate, vehicle_spectate) then
								local r, g, b = GetHudColour(6)
								SetCheckpointRgba2(checkpoint_2_spectate.draw_id, r, g, b, 150)
							else
								local r, g, b = GetHudColour(134)
								SetCheckpointRgba2(checkpoint_2_spectate.draw_id, r, g, b, 150)
							end
						end
					end
					if last_totalCheckpointsTouched_spectate ~= totalCheckpointsTouched_spectate then
						ResetCheckpointAndBlipForRace()
						CreateBlipForRace(actualCheckpoint_spectate, actualLap_spectate)
						CreateCheckpointForRace(actualCheckpoint_spectate, false, actualCheckpoint_spectate == #currentRace.checkpoints and actualLap_spectate == currentRace.laps)
						CreateCheckpointForRace(actualCheckpoint_spectate, true, actualCheckpoint_spectate == #currentRace.checkpoints and actualLap_spectate == currentRace.laps)
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

RegisterNetEvent("custom_races:client:respawning", function(playerId, playerPing, myPing)
	local time = GetGameTimer()
	if status == "spectating" and spectateData.playerId == playerId then
		DoScreenFadeOut(0)
		spectateData.isFadeOut = true
		spectateData.fadeOutTime = time
	end
	local offset = 0
	local ping = playerPing + myPing
	-- Fixed black screen duration under high latency
	if ping > 250 then
		offset = offset + ping * 2
	end
	Citizen.Wait(500 + offset)
	if status == "spectating" and spectateData.playerId == playerId then
		if time == spectateData.fadeOutTime then
			DoScreenFadeIn(500)
			spectateData.isFadeOut = false
			spectateData.fadeOutTime = nil
			SetGameplayCamRelativeHeading(0)
		end
	end
end)

RegisterNetEvent("custom_races:client:syncExplosion", function(index, hash)
	if status == "starting" or status == "racing" or status == "spectating" then
		for k, v in pairs(explodeProps) do
			if k == index and v.hash == hash and not v.touching and DoesEntityExist(v.handle) then
				v.touching = true
				FreezeEntityPosition(v.handle, true)
				SetEntityVisible(v.handle, false)
				SetEntityCollision(v.handle, false, false)
				SetEntityCompletelyDisableCollision(v.handle, false, false)
				break
			end
		end
	end
end)

RegisterNetEvent("custom_races:client:syncParticleFx", function(playerId, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
	Citizen.Wait(100)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
	if playerPed and playerPed ~= 0 and playerPed ~= PlayerPedId() then
		if status == "spectating" and spectateData.playerId == playerId then
			PlayEffectAndSound(playerPed, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
		else
			PlayEffectAndSound(playerPed, -1, effect_2 ~= 0 and effect_2 or -1, vehicle_r, vehicle_g, vehicle_b)
		end
	end
end)

RegisterNetEvent("custom_races:client:showFinalResult", function()
	if status == "leaving" or status == "ending" then return end
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
	currentRace.weather = weather
	ClearOverrideWeather()
	ClearWeatherTypePersist()
	SetWeatherTypePersist(currentRace.weather)
	SetWeatherTypeNow(currentRace.weather)
	SetWeatherTypeNowPersist(currentRace.weather)
	SetRainLevel(-1.0)
	if currentRace.weather == "XMAS" then
		SetForceVehicleTrails(true)
		SetForcePedFootstepsTracks(true)
	else
		SetForceVehicleTrails(false)
		SetForcePedFootstepsTracks(false)
	end
end)

exports("setTime", function(hour, minute, second)
	currentRace.time.hour = hour or 12
	currentRace.time.minute = minute or 0
	currentRace.time.second = second or 0
end)

-- Teleport to the previous checkpoint
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

-- Teleport to the next checkpoint
function tpn()
	if status == "racing" and not isRespawningInProgress and not isTransformingInProgress then
		isTeleportingInProgress = true
		hasCheated = true
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		local checkpoint = lastCheckpointPair == 1 and currentRace.checkpoints_2[actualCheckpoint] or currentRace.checkpoints[actualCheckpoint]
		SetEntityCoords(vehicle > 0 and vehicle or ped, checkpoint.x, checkpoint.y, GetValidZFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false, true))
		SetEntityHeading(vehicle > 0 and vehicle or ped, checkpoint.heading)
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