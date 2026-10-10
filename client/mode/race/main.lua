function Race.Function.Join()
	Race.Status = "ready"
	Race.GlobalVar.TotalCheckpointsTouched = 0
	Race.GlobalVar.ActualCheckpoint = 1
	Race.GlobalVar.LastCheckpointPair = 0
	Race.GlobalVar.ActualLap = 1
	Race.Cache.IsRespawningInProgress = true
	Race.Function.RespawnVehicle(Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].x, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].y, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].z, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].heading, false, nil)
	Race.Cache.IsRespawningInProgress = false
	Client.Function.Weapon.RemoveAll(PlayerPedId())
	Race.Function.CreateCheckpointBlip(Race.GlobalVar.ActualCheckpoint, Race.GlobalVar.ActualLap)
	Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, false, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
	Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, true, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
	ClearAreaLeaveVehicleHealth(Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].x, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].y, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].z, 100000000000000000000000.0, false, false, false, false, false)
	if Race.Track.Current.RoomData.raceId and not Race.Track.Played[Race.Track.Current.RoomData.raceId] then
		Race.Track.Played[Race.Track.Current.RoomData.raceId] = true
		local found = false
		for k, v in pairs(Race.Track.Data) do
			for i = 1, #v do
				if v[i].raceId == Race.Track.Current.RoomData.raceId then
					v[i].played = true
					found = true
					break
				end
			end
			if found then break end
		end
		TriggerServerEvent("server:race:saveData", {played = true, raceId = Race.Track.Current.RoomData.raceId})
	end
end

function Race.Function.Start()
	SendNUIMessage({
		action = "show race info",
		raceName = Race.Track.Current.Title .. " (" .. Race.Track.Current.OwnerName .. ")"
	})
	Wait(4000)
	Race.Status = "racing"
	CreateThread(function()
		SendNUIMessage({
			action = "show race hud",
			showCurrentLap = Race.Track.Current.Laps > 1
		})
		if DoesEntityExist(Race.Track.Current.LastVehicle) then
			FreezeEntityPosition(Race.Track.Current.LastVehicle, false)
			SetVehicleEngineOn(Race.Track.Current.LastVehicle, true, true, true)
		end
		Client.Function.Weapon.ReloadForRaceAndCreator(PlayerPedId(), false, false, Race.Track.Current.Mode == "gta")
		TriggerServerEvent("server:race:raceStarted")
		local wasJumping = false
		local wasFalling = false
		local wasControlPressed = false
		Race.GlobalVar.TotalTimeStart = GetGameTimer()
		Race.GlobalVar.StartLapTime = Race.GlobalVar.TotalTimeStart
		while Race.Status == "racing" do
			Race.GlobalVar.ActualLapTime = GetGameTimer() - Race.GlobalVar.StartLapTime
			Race.GlobalVar.TotalRaceTime = GetGameTimer() - Race.GlobalVar.TotalTimeStart
			if not IsNuiFocused() and not IsPauseMenuActive() and not Client.IsAnyClientMenuVisible then
				if IsControlJustReleased(0, 48) --[[Z]] then
					if Race.HUD.Position.Showed and ((Race.HUD.Position.Page * 20) < Race.Track.Current.PlayerCount) then
						Race.HUD.Position.Page = Race.HUD.Position.Page + 1
					else
						if Race.Track.Current.PlayerCount > 0 then
							if Race.HUD.Position.Showed then
								SendNUIMessage({
									action = "hide position ui"
								})
							end
							Race.HUD.Position.Showed = not Race.HUD.Position.Showed
							Race.HUD.Position.Page = 1
						end
					end
				end
			else
				if Race.HUD.Position.Showed then
					SendNUIMessage({
						action = "hide position ui"
					})
					Race.HUD.Position.Showed = false
				end
			end
			if not Client.Hud.DisableInfoUINextFrame and IsDisabledControlJustPressed(0, 200) --[[Esc]] then
				ExecuteCommand("leave")
			end
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local vehicle = GetVehiclePedIsIn(ped, false)
			local vehicleR, vehicleG, vehicleB = nil, nil, nil
			if vehicle > 0 then
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
				if class ~= 8 and class ~= 13 and not IsThisModelAPlane(model) and not IsThisModelAHeli(model) and not (model == GetHashKey("submersible")) and not (model == GetHashKey("submersible2")) and not (model == GetHashKey("avisa")) then
					UseVehicleCamStuntSettingsThisUpdate()
				end
				vehicleR, vehicleG, vehicleB = GetVehicleColor(vehicle)
			else
				if Race.Track.Current.Mode == "no_collision" and DoesEntityExist(Race.Track.Current.LastVehicle) then
					SetEntityCollision(Race.Track.Current.LastVehicle, false, false)
				end
			end
			for k, v in pairs(Race.ArenaProps) do
				if not v.touching and DoesEntityExist(v.handle) and IsEntityTouchingEntity(vehicle > 0 and vehicle or ped, v.handle) then
					v.touching = true
					CreateThread(function()
						if DoesEntityExist(v.handle) then
							SetEnableArenaPropPhysics(v.handle, true)
						end
						Wait(5000)
						if DoesEntityExist(v.handle) then
							SetEnableArenaPropPhysics(v.handle, false)
						end
						v.touching = nil
					end)
				end
			end
			for k, v in pairs(Race.ExplodeProps) do
				if not v.exploded and DoesEntityExist(v.handle) and IsEntityTouchingEntity(vehicle > 0 and vehicle or ped, v.handle) then
					v.exploded = true
					local coords = GetEntityCoords(v.handle)
					FreezeEntityPosition(v.handle, true)
					SetEntityVisible(v.handle, false)
					SetEntityCollision(v.handle, false, false)
					SetEntityCompletelyDisableCollision(v.handle, false, false)
					AddExplosion(coords.x, coords.y, coords.z, 58, 1.0, true, false, 1.0, false)
					TriggerServerEvent("server:race:syncExplosion", k, v.hash)
				end
			end
			if Race.GlobalVar.TransformIsBeast then
				SetSuperJumpThisFrame(PlayerId())
				SetBeastModeActive(PlayerId())
				local isJumping = IsPedDoingBeastJump(ped)
				local isFalling = IsPedFalling(ped)
				if isJumping and not wasJumping then
					Race.GlobalVar.WasDoingBeastJump = true
					PlaySoundFromEntity(-1, "Beast_Jump", ped, "DLC_AR_Beast_Soundset", true, 60)
				end
				if not isFalling and wasFalling and Race.GlobalVar.WasDoingBeastJump then
					Race.GlobalVar.WasDoingBeastJump = false
					PlaySoundFromEntity(-1, "Beast_Jump_Land", ped, "DLC_AR_Beast_Soundset", true, 60)
				end
				wasJumping = isJumping
				wasFalling = isFalling
			end
			if Race.Track.Current.Mode ~= "gta" then
				SetEntityInvincible(ped, true)
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
				SetPlayerCanDoDriveBy(PlayerId(), true)
				if vehicle > 0 and DoesVehicleHaveWeapons(vehicle) == 1 then
					local weapons = {2971687502, 1945616459, 3450622333, 3530961278, 1259576109, 4026335563, 1566990507, 1186503822, 2669318622, 3473446624, 4171469727, 1741783703, 2211086889}
					for i = 1, #weapons do
						DisableVehicleWeapon(true, weapons[i], vehicle, ped)
					end
				end
			else
				SetEntityInvincible(ped, false)
				SetPlayerCanDoDriveBy(PlayerId(), true)
			end
			if IsControlPressed(0, 75) or IsDisabledControlPressed(0, 75) then
				wasControlPressed = true
				if Race.HUD.Respawn.HasRespawned and not Race.Cache.IsRespawningInProgress and ((not Race.GlobalVar.TransformIsParachute and not Race.GlobalVar.TransformIsBeast and vehicle == 0 and Race.Track.Current.Mode ~= "gta") or (IsEntityDead(ped) or IsPlayerDead(PlayerId()))) then
					Race.Function.ResetAndHideRespawnUI()
				end
				Race.Function.StartRespawn()
			elseif (not Race.GlobalVar.TransformIsParachute and not Race.GlobalVar.TransformIsBeast and vehicle == 0 and Race.Track.Current.Mode ~= "gta") or (IsEntityDead(ped) or IsPlayerDead(PlayerId())) then
				wasControlPressed = false
				if Race.HUD.Respawn.HasRespawned and not Race.Cache.IsRespawningInProgress then
					Race.Function.ResetAndHideRespawnUI()
				end
				Race.Function.StartRespawn()
			else
				if Race.Track.Current.Mode == "gta" and wasControlPressed and vehicle > 0 and Race.HUD.Respawn.Time > 0 and Race.HUD.Respawn.Time < 100 then
					TaskLeaveVehicle(ped, vehicle, GetEntitySpeed(vehicle) <= 1.0 and 0 or 4160)
				end
				wasControlPressed = false
				Race.Function.ResetAndHideRespawnUI()
			end

			local checkPointTouched = false
			local finishLine = Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps
			local checkpoint = Race.Track.Current.Checkpoints[Race.GlobalVar.ActualCheckpoint]
			local checkpoint_2 = Race.Track.Current.Checkpoints_2[Race.GlobalVar.ActualCheckpoint]
			local nextCheckpoint = not finishLine and Race.Track.Current.Checkpoints[Race.GlobalVar.ActualCheckpoint + 1] or Race.Track.Current.Checkpoints[1]
			local nextCheckpoint_2 = not finishLine and Race.Track.Current.Checkpoints_2[Race.GlobalVar.ActualCheckpoint + 1] or Race.Track.Current.Checkpoints_2[1]

			local checkpointCoords = nil
			local collectSize = nil
			local checkpointRadius = nil
			local _checkpointCoords = nil
			local checkpointSlow = false
			if checkpoint then
				checkpointCoords = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
				collectSize = ((checkpoint.isAir and (4.5 * checkpoint.diameterCollect)) or ((checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) and (2.25 * checkpoint.diameterCollect)) or checkpoint.diameterCollect) * 10
				checkpointRadius = collectSize / 2
				_checkpointCoords = checkpointCoords
				if finishLine then
					if checkpoint.isRound then
						if not checkpoint.isAir then
							_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
						end
					else
						_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
					end
				else
					if checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp then
						if not checkpoint.isAir then
							_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
						end
					else
						_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
					end
					if checkpoint.isPlaneRot and checkpoint.drawId then
						if vehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(checkpoint, vehicle) then
							local r, g, b = GetHudColour(6)
							SetCheckpointRgba2(checkpoint.drawId, r, g, b, 150)
							checkpointSlow = true
						else
							local r, g, b = GetHudColour(134)
							SetCheckpointRgba2(checkpoint.drawId, r, g, b, 150)
							checkpointSlow = false
						end
					end
				end
			end

			local checkpointCoords_2 = nil
			local collectSize_2 = nil
			local checkpointRadius_2 = nil
			local _checkpointCoords_2 = nil
			local checkpointSlow_2 = false
			if checkpoint_2 then
				checkpointCoords_2 = vector3(checkpoint_2.x, checkpoint_2.y, checkpoint_2.z)
				collectSize_2 = ((checkpoint_2.isAir and (4.5 * checkpoint_2.diameterCollect)) or ((checkpoint_2.isRound or checkpoint_2.isRandom or checkpoint_2.isTransform or checkpoint_2.isPlaneRot or checkpoint_2.isWarp) and (2.25 * checkpoint_2.diameterCollect)) or checkpoint_2.diameterCollect) * 10
				checkpointRadius_2 = collectSize_2 / 2
				_checkpointCoords_2 = checkpointCoords_2
				if finishLine then
					if checkpoint_2.isRound then
						if not checkpoint_2.isAir then
							_checkpointCoords_2 = checkpointCoords_2 + vector3(0, 0, checkpointRadius_2)
						end
					else
						_checkpointCoords_2 = checkpointCoords_2 + vector3(0, 0, checkpointRadius_2)
					end
				else
					if checkpoint_2.isRound or checkpoint_2.isRandom or checkpoint_2.isTransform or checkpoint_2.isPlaneRot or checkpoint_2.isWarp then
						if not checkpoint_2.isAir then
							_checkpointCoords_2 = checkpointCoords_2 + vector3(0, 0, checkpointRadius_2)
						end
					else
						_checkpointCoords_2 = checkpointCoords_2 + vector3(0, 0, checkpointRadius_2)
					end
					if checkpoint_2.isPlaneRot and checkpoint_2.drawId then
						if vehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(checkpoint_2, vehicle) then
							local r, g, b = GetHudColour(6)
							SetCheckpointRgba2(checkpoint_2.drawId, r, g, b, 150)
							checkpointSlow_2 = true
						else
							local r, g, b = GetHudColour(134)
							SetCheckpointRgba2(checkpoint_2.drawId, r, g, b, 150)
							checkpointSlow_2 = false
						end
					end
				end
			end

			if checkpointCoords and collectSize and checkpointRadius and _checkpointCoords and ((#(pos - checkpointCoords) <= (checkpointRadius * 2.0)) or (#(pos - _checkpointCoords) <= (checkpointRadius * 1.5))) and not Race.Cache.IsRespawningInProgress and not Race.Cache.IsTransformingInProgress and not Race.Cache.IsTeleportingInProgress then
				checkPointTouched = true
				Race.GlobalVar.LastCheckpointPair = 0
				local effect_1 = 0
				local effect_2 = 0
				if checkpoint.isPlaneRot and vehicle > 0 and not finishLine then
					if checkpointSlow then
						effect_1 = 2
						Client.Function.Shared.SlowVehicle(vehicle)
					else
						effect_1 = 1
					end
				end
				if checkpoint.isWarp and nextCheckpoint and not finishLine then
					effect_2 = 1
					Client.Function.Shared.WarpVehicle(nextCheckpoint, vehicle > 0 and vehicle or ped)
				end
				if (checkpoint.isTransform or checkpoint.isRandom) and not finishLine then
					effect_2 = effect_2 == 0 and 2 or effect_2
					local speed = vehicle > 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
					local rotation = vehicle > 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
					local velocity = vehicle > 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
					Race.Function.TransformVehicle(checkpoint, speed, rotation, velocity, function(props)
						checkpoint.respawnData = props
						if checkpoint_2 then
							checkpoint_2.respawnData = props
						end
					end)
				else
					local props = Race.GlobalVar.TotalCheckpointsTouched == 0 and Race.Cache.VehicleProps or (Race.GlobalVar.ActualCheckpoint == 1 and Race.Track.Current.Checkpoints[#Race.Track.Current.Checkpoints].respawnData) or (Race.Track.Current.Checkpoints[Race.GlobalVar.ActualCheckpoint - 1].respawnData)
					checkpoint.respawnData = props
					if checkpoint_2 then
						checkpoint_2.respawnData = props
					end
					if checkpoint.isPit and vehicle > 0 and not finishLine then
						Client.Function.Vehicle.Fix(vehicle)
					end
				end
				Client.Function.Shared.PlayEffectAndSound(ped, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
				if not Race.Cache.IsSyncLocked then
					TriggerServerEvent("server:race:syncParticleFx", effect_1, effect_2, vehicleR, vehicleG, vehicleB)
					Race.Cache.IsSyncLocked = true
					CreateThread(function()
						Wait(1000)
						Race.Cache.IsSyncLocked = false
					end)
				end
			elseif checkpointCoords_2 and collectSize_2 and checkpointRadius_2 and _checkpointCoords_2 and ((#(pos - checkpointCoords_2) <= (checkpointRadius_2 * 2.0)) or (#(pos - _checkpointCoords_2) <= (checkpointRadius_2 * 1.5))) and not Race.Cache.IsRespawningInProgress and not Race.Cache.IsTransformingInProgress and not Race.Cache.IsTeleportingInProgress then
				checkPointTouched = true
				Race.GlobalVar.LastCheckpointPair = 1
				local effect_1 = 0
				local effect_2 = 0
				if checkpoint_2.isPlaneRot and vehicle > 0 and not finishLine then
					if checkpointSlow_2 then
						effect_1 = 2
						Client.Function.Shared.SlowVehicle(vehicle)
					else
						effect_1 = 1
					end
				end
				if checkpoint_2.isWarp and (nextCheckpoint_2 or nextCheckpoint) and not finishLine then
					effect_2 = 1
					Client.Function.Shared.WarpVehicle(nextCheckpoint_2 or nextCheckpoint, vehicle > 0 and vehicle or ped)
				end
				if (checkpoint_2.isTransform or checkpoint_2.isRandom) and not finishLine then
					effect_2 = effect_2 == 0 and 2 or effect_2
					local speed = vehicle > 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
					local rotation = vehicle > 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
					local velocity = vehicle > 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
					Race.Function.TransformVehicle(checkpoint_2, speed, rotation, velocity, function(props)
						checkpoint.respawnData = props
						checkpoint_2.respawnData = props
					end)
				else
					local props = Race.GlobalVar.TotalCheckpointsTouched == 0 and Race.Cache.VehicleProps or (Race.GlobalVar.ActualCheckpoint == 1 and Race.Track.Current.Checkpoints[#Race.Track.Current.Checkpoints].respawnData) or (Race.Track.Current.Checkpoints[Race.GlobalVar.ActualCheckpoint - 1].respawnData)
					checkpoint.respawnData = props
					checkpoint_2.respawnData = props
					if checkpoint_2.isPit and vehicle > 0 and not finishLine then
						Client.Function.Vehicle.Fix(vehicle)
					end
				end
				Client.Function.Shared.PlayEffectAndSound(ped, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
				if not Race.Cache.IsSyncLocked then
					TriggerServerEvent("server:race:syncParticleFx", effect_1, effect_2, vehicleR, vehicleG, vehicleB)
					Race.Cache.IsSyncLocked = true
					CreateThread(function()
						Wait(1000)
						Race.Cache.IsSyncLocked = false
					end)
				end
			end

			if checkPointTouched then
				Race.GlobalVar.TotalCheckpointsTouched = Race.GlobalVar.TotalCheckpointsTouched + 1
				Race.SyncData.LastCheckpointPair = Race.GlobalVar.LastCheckpointPair
				Race.SyncData.TotalCheckpointsTouched = Race.GlobalVar.TotalCheckpointsTouched
				if Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints then
					Race.SyncData.LastLap = Race.GlobalVar.ActualLapTime
					if (Race.SyncData.BestLap == 0) or (Race.SyncData.BestLap > Race.GlobalVar.ActualLapTime) then
						Race.SyncData.BestLap = Race.GlobalVar.ActualLapTime
					end
					Race.SyncData.TotalRaceTime = Race.GlobalVar.TotalRaceTime
					if Race.GlobalVar.ActualLap < Race.Track.Current.Laps then
						Race.GlobalVar.ActualCheckpoint = 1
						Race.GlobalVar.ActualLap = Race.GlobalVar.ActualLap + 1
						Race.GlobalVar.StartLapTime = GetGameTimer()
						Race.SyncData.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint
						Race.SyncData.ActualLap = Race.GlobalVar.ActualLap
						Race.HUD.Bottom.TimeLap = nil
						Race.GlobalVar.ActualLapTime = 0
					else
						if Race.Track.Current.RoomData.raceId and not Race.Track.Finished[Race.Track.Current.RoomData.raceId] and not Race.Cache.HasCheated then
							Race.Track.Finished[Race.Track.Current.RoomData.raceId] = true
							local found = false
							for k, v in pairs(Race.Track.Data) do
								for i = 1, #v do
									if v[i].raceId == Race.Track.Current.RoomData.raceId then
										v[i].finished = true
										found = true
										break
									end
								end
								if found then break end
							end
							TriggerServerEvent("server:race:saveData", {finished = true, raceId = Race.Track.Current.RoomData.raceId})
						end
						Race.Function.Finish("yeah")
						break
					end
				else
					Race.GlobalVar.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint + 1
					Race.SyncData.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint
				end
				Race.Function.ResetCheckpointAndBlip()
				Race.Function.CreateCheckpointBlip(Race.GlobalVar.ActualCheckpoint, Race.GlobalVar.ActualLap)
				Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, false, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
				Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, true, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
			end
			Race.Function.DrawBottomHUD()
			Wait(0)
		end
	end)
	CreateThread(function()
		local topId = nil
		local MsgItem = nil
		local firstLoad = true
		local startTime = GetGameTimer()
		while Race.Status == "racing" do
			Wait(500)
			local driversInfo = Race.Function.Player.GetDriversInfo(Race.Track.Current.Drivers)
			if Race.HUD.Position.Showed and #driversInfo > 0 then
				local frontPosAll = {}
				local labels = {
					label_name = Client.Function.Translate.Get("racing-ui-label_name"),
					label_ping = "Ping",
					label_fps = "FPS",
					label_distance = Client.Function.Translate.Get("racing-ui-label_distance"),
					label_lap = Race.Track.Current.Laps > 1 and Client.Function.Translate.Get("racing-ui-label_lap"),
					label_checkpoint = Client.Function.Translate.Get("racing-ui-label_checkpoint"),
					label_vehicle = Client.Function.Translate.Get("racing-ui-label_vehicle"),
					label_last_lap = Race.Track.Current.Laps > 1 and Client.Function.Translate.Get("racing-ui-label_last_lap"),
					label_best_lap = Race.Track.Current.Laps > 1 and Client.Function.Translate.Get("racing-ui-label_best_lap"),
					label_total_time = Client.Function.Translate.Get("racing-ui-label_total_time")
				}
				for k, v in pairs(Race.Track.Current.Drivers) do
					local position = Race.Function.Player.GetPosition(driversInfo, v.playerId)
					local name = v.playerName
					local flag = v.flag or "US"
					local keyboard = v.keyboard and "💻" or "🎮"
					local ping = v.ping
					local fps = v.fps
					local distance = nil
					local lap = v.actualLap
					local checkpoint = v.actualCheckpoint
					local vehicle = (v.vehicle == "parachute" and Client.Function.Translate.Get("Transform-Parachute")) or (v.vehicle == "beast" and Client.Function.Translate.Get("Transform-Beast")) or (GetLabelText(v.vehicle) ~= "NULL" and GetLabelText(v.vehicle):gsub("µ", " ")) or Client.Function.Translate.Get("unknown-vehicle")
					local lastLap = v.lastLap ~= 0 and GetTimeAsString(v.lastLap) or "-"
					local bestLap = v.bestLap ~= 0 and GetTimeAsString(v.bestLap) or "-"
					local totalTime = v.hasFinished and GetTimeAsString(v.totalRaceTime) or "-"
					if v.dnf then
						table.insert(frontPosAll, {
							position = position,
							name = name,
							flag = flag,
							keyboard = keyboard,
							ping = "DNF",
							fps = "DNF",
							distance = "DNF",
							lap = "DNF",
							checkpoint = "DNF",
							vehicle = "DNF",
							lastLap = "DNF",
							bestLap = "DNF",
							totalTime = "DNF"
						})
					elseif v.hasFinished and not v.dnf then
						table.insert(frontPosAll, {
							position = position,
							name = name,
							flag = flag,
							keyboard = keyboard,
							ping = "-",
							fps = "-",
							distance = "-",
							lap = "-",
							checkpoint = "-",
							vehicle = vehicle,
							lastLap = lastLap,
							bestLap = bestLap,
							totalTime = totalTime
						})
					else
						local checkpointCoords = v.lastCheckpointPair == 1 and Race.Track.Current.Checkpoints_2[v.actualCheckpoint] or Race.Track.Current.Checkpoints[v.actualCheckpoint] or vector3(0.0, 0.0, 0.0)
						distance = Client.Function.Math.RoundedValue(#(v.currentCoords - vector3(checkpointCoords.x, checkpointCoords.y, checkpointCoords.z)), 1) .. "m"
						table.insert(frontPosAll, {
							position = position,
							name = name,
							flag = flag,
							keyboard = keyboard,
							ping = ping,
							fps = fps,
							distance = distance,
							lap = lap,
							checkpoint = checkpoint,
							vehicle = vehicle,
							lastLap = lastLap,
							bestLap = bestLap,
							totalTime = totalTime
						})
					end
				end
				table.sort(frontPosAll, function(a, b)
					return a.position < b.position
				end)
				if (Race.HUD.Position.Page > 1) and (((Race.HUD.Position.Page - 1) * 20 + 1) > Race.Track.Current.PlayerCount) then
					Race.HUD.Position.Page = Race.HUD.Position.Page - 1
				end
				local startIdx = (Race.HUD.Position.Page - 1) * 20 + 1
				local endIdx = math.min(startIdx + 20 - 1, Race.Track.Current.PlayerCount)
				local frontPos = {}
				for i = startIdx, endIdx do
					local player = frontPosAll[i]
					if player then
						table.insert(frontPos, player)
					end
				end
				SendNUIMessage({
					frontPos = frontPos,
					labels = labels
				})
			end
			if firstLoad and #driversInfo > 0 then
				topId = driversInfo[1].playerId
				firstLoad = false
			end
			if #driversInfo >= 2 and not driversInfo[1].hasFinished and (GetGameTimer() - startTime) >= 5000 and topId ~= driversInfo[1].playerId then
				topId = driversInfo[1].playerId
				MsgItem = Client.Function.Message.Display_2(string.format(Client.Function.Translate.Get("racing-info-1st"), driversInfo[1].playerName), true, MsgItem)
			end
		end
		if Race.HUD.Position.Showed then
			SendNUIMessage({
				action = "hide position ui"
			})
			Race.HUD.Position.Showed = false
		end
	end)
end

function Race.Function.DrawBottomHUD()
	if not Race.HUD.Bottom.ActualLap or Race.HUD.Bottom.ActualLap ~= Race.GlobalVar.ActualLap then
		SendNUIMessage({
			laps = Race.GlobalVar.ActualLap .. "/" .. Race.Track.Current.Laps
		})
		Race.HUD.Bottom.ActualLap = Race.GlobalVar.ActualLap
	end
	local driversInfo = Race.Function.Player.GetDriversInfo(Race.Track.Current.Drivers)
	local position = Race.Function.Player.GetPosition(driversInfo, Client.ServerId)
	if not Race.HUD.Bottom.Position or Race.HUD.Bottom.Position ~= position or Race.HUD.Bottom.PlayerCount ~= Race.Track.Current.PlayerCount then
		SendNUIMessage({
			position = position .. "</span><span style='font-size: 4vh;margin-left: 9px;'>/ " .. Race.Track.Current.PlayerCount
		})
		Race.HUD.Bottom.Position = position
		Race.HUD.Bottom.PlayerCount = Race.Track.Current.PlayerCount
	end
	if not Race.HUD.Bottom.Checkpoints or Race.HUD.Bottom.Checkpoints ~= Race.GlobalVar.ActualCheckpoint then
		SendNUIMessage({
			checkpoints = Race.GlobalVar.ActualCheckpoint .. "/" .. #Race.Track.Current.Checkpoints
		})
		Race.HUD.Bottom.Checkpoints = Race.GlobalVar.ActualCheckpoint
	end
	if (not Race.HUD.Bottom.TimeLap or Race.GlobalVar.ActualLapTime - Race.HUD.Bottom.TimeLap >= 125) and Race.Track.Current.Laps > 1 then
		SendNUIMessage({
			timeLap = GetTimeAsString(Race.GlobalVar.ActualLapTime)
		})
		Race.HUD.Bottom.TimeLap = Race.GlobalVar.ActualLapTime
	end
	if not Race.HUD.Bottom.TimeTotal or Race.GlobalVar.TotalRaceTime - Race.HUD.Bottom.TimeTotal >= 125 then
		SendNUIMessage({
			timeTotal = GetTimeAsString(Race.GlobalVar.TotalRaceTime)
		})
		Race.HUD.Bottom.TimeTotal = Race.GlobalVar.TotalRaceTime
	end
end

function Race.Function.ResetCheckpointAndBlip()
	for i, checkpoint in ipairs(Race.Track.Current.Checkpoints) do
		if checkpoint.drawId then
			DeleteCheckpoint(checkpoint.drawId)
			checkpoint.drawId = nil
		end
		if checkpoint.blipId then
			RemoveBlip(checkpoint.blipId)
			checkpoint.blipId = nil
		end
		local checkpoint_2 = Race.Track.Current.Checkpoints_2[i]
		if checkpoint_2 then
			if checkpoint_2.drawId then
				DeleteCheckpoint(checkpoint_2.drawId)
				checkpoint_2.drawId = nil
			end
			if checkpoint_2.blipId then
				RemoveBlip(checkpoint_2.blipId)
				checkpoint_2.blipId = nil
			end
		end
	end
end

function Race.Function.CreateCheckpoint(index, pair, isFinishLine)
	local checkpoint = pair and Race.Track.Current.Checkpoints_2[index] or Race.Track.Current.Checkpoints[index]
	if not checkpoint then return end
	local checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(13)
	local checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
	local checkpointA_1, checkpointA_2 = 150, 150
	if not checkpoint.drawId then
		local drawSize = ((checkpoint.isAir and (4.5 * checkpoint.diameterDraw)) or ((checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) and (2.25 * checkpoint.diameterDraw)) or checkpoint.diameterDraw) * 10
		local checkpointNearHeight = 9.5
		local checkpointFarHeight = 9.5
		local checkpointRangeHeight = checkpoint.isTall and checkpoint.tallRadius or 100.0
		local drawHigher = false
		local updateZ = checkpoint.isRound and (checkpoint.isAir and 0.0 or (drawSize / 2)) or (drawSize / 2)
		local nextCheckpoint = pair and (Race.Track.Current.Checkpoints_2[index + 1] or Race.Track.Current.Checkpoints[index + 1] or Race.Track.Current.Checkpoints_2[1] or Race.Track.Current.Checkpoints[1]) or (Race.Track.Current.Checkpoints[index + 1] or Race.Track.Current.Checkpoints[1])
		local prevCheckpoint = pair and (Race.Track.Current.Checkpoints_2[index - 1] or Race.Track.Current.Checkpoints[index - 1] or Race.Track.Current.Checkpoints_2[#Race.Track.Current.Checkpoints] or Race.Track.Current.Checkpoints[#Race.Track.Current.Checkpoints]) or (Race.Track.Current.Checkpoints[index - 1] or Race.Track.Current.Checkpoints[#Race.Track.Current.Checkpoints])
		local checkpointIcon = 6
		if checkpoint.isRandom and not isFinishLine then
			checkpointIcon = 56
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.isTransform and not isFinishLine then
			local transformVehicle = Race.Track.Current.TransformVehicles[checkpoint.transformIndex + 1]
			local model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
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
		elseif checkpoint.isPlaneRot and not isFinishLine then
			if checkpoint.planeRot == 0 then
				checkpointIcon = 37
			elseif checkpoint.planeRot == 1 then
				checkpointIcon = 39
			elseif checkpoint.planeRot == 2 then
				checkpointIcon = 40
			elseif checkpoint.planeRot == 3 then
				checkpointIcon = 38
			end
			if checkpoint.isPlaneRot then
				local ped = Race.Status == "spectating" and DoesEntityExist(Race.SpectateData.Ped) and Race.SpectateData.Ped or PlayerPedId()
				local vehicle = GetVehiclePedIsIn(ped, false)
				if vehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(checkpoint, vehicle) then
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(6)
				else
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
				end
			end
		elseif checkpoint.isWarp and not isFinishLine then
			checkpointIcon = 66
		elseif checkpoint.isRound then
			if isFinishLine then
				checkpointIcon = 16
			else
				checkpointIcon = 12
			end
		else
			local diffPrev = vector3(prevCheckpoint.x, prevCheckpoint.y, prevCheckpoint.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
			local diffNext = vector3(nextCheckpoint.x, nextCheckpoint.y, nextCheckpoint.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
			local checkpointAngle = GetAngleBetween_2dVectors(diffPrev.x, diffPrev.y, diffNext.x, diffNext.y)
			checkpointAngle = checkpointAngle > 180.0 and (360.0 - checkpointAngle) or checkpointAngle
			local found, groundZ = GetGroundZExcludingObjectsFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false)
			if found and math.abs(groundZ - checkpoint.z) > (drawSize * 0.3125) then
				drawHigher = true
				checkpointNearHeight = drawSize * 0.375
				checkpointFarHeight = checkpoint.isTall and (drawSize * 0.375 * 50.0) or (drawSize * 0.375)
				updateZ = 0.0
			else
				checkpointNearHeight = drawSize * 0.75
				checkpointFarHeight = checkpoint.isTall and (drawSize * 0.75 * 50.0) or (drawSize * 0.75)
			end
			if checkpointAngle < 80.0 then
				checkpointIcon = drawHigher == true and ((isFinishLine and 4) or (checkpoint.isPit and 5) or 2) or ((isFinishLine and 10) or (checkpoint.isPit and 11) or 8)
			elseif checkpointAngle < 140.0 then
				checkpointIcon = drawHigher == true and ((isFinishLine and 4) or (checkpoint.isPit and 5) or 1) or ((isFinishLine and 10) or (checkpoint.isPit and 11) or 7)
			elseif checkpointAngle <= 180.0 then
				checkpointIcon = drawHigher == true and ((isFinishLine and 4) or (checkpoint.isPit and 5) or 0) or ((isFinishLine and 10) or (checkpoint.isPit and 11) or 6)
			end
		end
		if not (checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) then
			local hour = GetClockHours()
			if hour > 6 and hour < 20 then
				checkpointA_1 = 210
				checkpointA_2 = 180
			end
		end
		local pos_1 = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
		local pos_2 = vector3(nextCheckpoint.x, nextCheckpoint.y, nextCheckpoint.z)
		if not (checkpoint.offset.x == 0.0 and checkpoint.offset.y == 0.0 and checkpoint.offset.z == 0.0) then
			pos_2 = pos_1 + vector3(0.0, 0.0, updateZ) + vector3(checkpoint.offset.x, checkpoint.offset.y, checkpoint.offset.z)
		end
		checkpoint.drawId = CreateCheckpoint(
			checkpointIcon,
			pos_1.x, pos_1.y, pos_1.z + updateZ,
			pos_2.x, pos_2.y, pos_2.z,
			drawSize, checkpointR_2, checkpointG_2, checkpointB_2, checkpointA_2, 0
		)
		if not isFinishLine and (checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) then
			if checkpoint.lockDirection then
				local dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
				local pos_3 = pos_1 + vector3(0.0, 0.0, updateZ) - dirVec
				-- Rockstar does it this way, but there seems to be a display error for inside icons, WTF?
				-- local pos_3 = checkpoint.isPlaneRot and (pos_1 + vector3(0.0, 0.0, updateZ) - dirVec) or (pos_1 + vector3(0.0, 0.0, updateZ) + dirVec)
				N_0xdb1ea9411c8911ec(checkpoint.drawId) -- SET_CHECKPOINT_FORCE_DIRECTION
				N_0x3c788e7f6438754d(checkpoint.drawId, pos_3.x, pos_3.y, pos_3.z) -- SET_CHECKPOINT_DIRECTION
			end
		else
			if drawHigher then
				SetCheckpointIconHeight(checkpoint.drawId, (isFinishLine and 0.75) or (checkpoint.isPit and 0.75) or 0.5) -- SET_CHECKPOINT_INSIDE_CYLINDER_HEIGHT_SCALE
				-- SetCheckpointIconScale(checkpoint.drawId, 0.85) -- SET_CHECKPOINT_INSIDE_CYLINDER_SCALE
			end
			SetCheckpointCylinderHeight(checkpoint.drawId, checkpointNearHeight, checkpointFarHeight, checkpointRangeHeight)
		end
		SetCheckpointRgba(checkpoint.drawId, checkpointR_1, checkpointG_1, checkpointB_1, checkpointA_1)
	end
end

function Race.Function.CreateCheckpointBlip(cpIndex, lapIndex)
	local function createData(checkpoint, isNext, isLapEnd, isFinishLine)
		local x, y, z = checkpoint.x, checkpoint.y, checkpoint.z
		local sprite = (isFinishLine and 38) or (isLapEnd and 58) or (checkpoint.isRandom and 66) or (checkpoint.isTransform and 570) or 1
		local scale = isNext and 0.65 or 0.9
		local alpha = (isNext or (not isFinishLine and checkpoint.lowerAlpha)) and 125 or 255
		local colour = (sprite == 38 and 0) or (not isLapEnd and (checkpoint.isRandom or checkpoint.isTransform) and 1) or 5
		local display = 6
		local name = (isLapEnd or isFinishLine) and Client.Function.Translate.Get("racing-blip-finishline") or Client.Function.Translate.Get("racing-blip-checkpoint")
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
	local checkpoint = Race.Track.Current.Checkpoints[cpIndex]
	if checkpoint then
		checkpoint.blipId = createBlip(createData(checkpoint, false, cpIndex == #Race.Track.Current.Checkpoints, cpIndex == #Race.Track.Current.Checkpoints and lapIndex == Race.Track.Current.Laps))
	end
	local checkpoint_2 = Race.Track.Current.Checkpoints_2[cpIndex]
	if checkpoint_2 then
		checkpoint_2.blipId = createBlip(createData(checkpoint_2, false, cpIndex == #Race.Track.Current.Checkpoints, cpIndex == #Race.Track.Current.Checkpoints and lapIndex == Race.Track.Current.Laps))
	end
	local nextCheckpoint = Race.Track.Current.Checkpoints[cpIndex + 1] or ((cpIndex == #Race.Track.Current.Checkpoints and lapIndex ~= Race.Track.Current.Laps) and Race.Track.Current.Checkpoints[1])
	if nextCheckpoint then
		nextCheckpoint.blipId = createBlip(createData(nextCheckpoint, true, (cpIndex + 1) == #Race.Track.Current.Checkpoints, (cpIndex + 1) == #Race.Track.Current.Checkpoints and lapIndex == Race.Track.Current.Laps))
	end
	local nextCheckpoint_2 = Race.Track.Current.Checkpoints_2[cpIndex + 1] or ((cpIndex == #Race.Track.Current.Checkpoints and lapIndex ~= Race.Track.Current.Laps) and Race.Track.Current.Checkpoints_2[1])
	if nextCheckpoint_2 then
		nextCheckpoint_2.blipId = createBlip(createData(nextCheckpoint_2, true, (cpIndex + 1) == #Race.Track.Current.Checkpoints, (cpIndex + 1) == #Race.Track.Current.Checkpoints and lapIndex == Race.Track.Current.Laps))
	end
end

function Race.Function.StartRespawn()
	if Race.Status == "racing" then
		if Race.HUD.Respawn.HasRespawned then
			return
		end
		if not Race.HUD.Respawn.Holding then
			Race.HUD.Respawn.TimeStart = GetGameTimer()
			Race.HUD.Respawn.Holding = true
		end
		if Race.HUD.Respawn.Time >= 500 then
			Race.HUD.Respawn.HasRespawned = true
			Race.Function.ReadyRespawn()
			TriggerServerEvent("server:race:respawning")
		else
			Race.HUD.Respawn.Time = GetGameTimer() - Race.HUD.Respawn.TimeStart
		end
		if Race.HUD.Respawn.Time >= 100 and not Race.HUD.Respawn.Showed then
			Race.HUD.Respawn.Showed = true
			SendNUIMessage({
				action = "show respawn ui"
			})
		end
	else
		Race.Function.ResetAndHideRespawnUI()
	end
end

function Race.Function.ResetAndHideRespawnUI()
	Race.HUD.Respawn.HasRespawned = false
	Race.HUD.Respawn.Holding = false
	Race.HUD.Respawn.Time = 0
	if Race.HUD.Respawn.Showed then
		Race.HUD.Respawn.Showed = false
		SendNUIMessage({
			action = "hide respawn ui"
		})
	end
end

function Race.Function.ReadyRespawn()
	if not Race.Cache.IsRespawningInProgress and not Race.Cache.IsTransformingInProgress and not Race.Cache.IsTeleportingInProgress then
		Race.Cache.IsRespawningInProgress = true
		CreateThread(function()
			local ped = PlayerPedId()
			if Race.Track.Current.Checkpoints[Race.GlobalVar.ActualCheckpoint - 1] == nil then
				if Race.GlobalVar.TotalCheckpointsTouched ~= 0 then
					local index = #Race.Track.Current.Checkpoints
					local respawnCheckpoint = Race.GlobalVar.LastCheckpointPair == 1 and Race.Track.Current.Checkpoints_2[index] or Race.Track.Current.Checkpoints[index]
					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(respawnCheckpoint.x, respawnCheckpoint.y, respawnCheckpoint.z, respawnCheckpoint.heading, true, false) end
					Race.Function.RespawnVehicle(respawnCheckpoint.x, respawnCheckpoint.y, respawnCheckpoint.z, respawnCheckpoint.heading, true, respawnCheckpoint)
				else
					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
						NetworkResurrectLocalPlayer(Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].x, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].y, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].z, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].heading, true, false)
					end
					Race.Function.RespawnVehicle(Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].x, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].y, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].z, Race.Track.Current.StartingGrid[Race.Track.Current.GridPositionIndex].heading, true, nil)
				end
			else
				local currentModel = (DoesEntityExist(Race.Track.Current.LastVehicle) and GetEntityModel(Race.Track.Current.LastVehicle)) or (Race.GlobalVar.TransformIsParachute and -422877666) or (Race.GlobalVar.TransformIsBeast and -731262150)
				local index, reset = Race.Function.GetNonFakeCheckpoint(Race.GlobalVar.ActualCheckpoint)
				if reset then
					Race.SyncData.TotalCheckpointsTouched = Race.GlobalVar.TotalCheckpointsTouched
					Race.SyncData.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint
					local model = nil
					local checkpoint = Race.Track.Current.Checkpoints[index]
					local checkpoint_2 = Race.Track.Current.Checkpoints_2[index]
					if Race.GlobalVar.LastCheckpointPair == 1 and checkpoint_2 then
						for i = index, 1, -1 do
							local tempCheckpoint_2 = Race.Track.Current.Checkpoints_2[i]
							if tempCheckpoint_2 and tempCheckpoint_2.isTransform then
								local transformVehicle = Race.Track.Current.TransformVehicles[tempCheckpoint_2.transformIndex + 1]
								model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
								break
							elseif tempCheckpoint_2 and tempCheckpoint_2.isRandom then
								local transformVehicle = Client.Function.Shared.GetRandomVehicleModel(Race.Track.Current.TransformVehicles, Race.Track.Current.RandomVehicles, tempCheckpoint_2.randomClass, tempCheckpoint_2.randomCustom, tempCheckpoint_2.randomSetting)
								model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
								break
							end
						end
					else
						for i = index, 1, -1 do
							local tempCheckpoint = Race.Track.Current.Checkpoints[i]
							if tempCheckpoint and tempCheckpoint.isTransform then
								local transformVehicle = Race.Track.Current.TransformVehicles[tempCheckpoint.transformIndex + 1]
								model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
								break
							elseif tempCheckpoint and tempCheckpoint.isRandom then
								local transformVehicle = Client.Function.Shared.GetRandomVehicleModel(Race.Track.Current.TransformVehicles, Race.Track.Current.RandomVehicles, tempCheckpoint.randomClass, tempCheckpoint.randomCustom, tempCheckpoint.randomSetting)
								model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
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
							checkpoint.respawnData = Race.Cache.VehicleProps
							if checkpoint_2 then
								checkpoint_2.respawnData = Race.Cache.VehicleProps
							end
						else
							if not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model) then
								model = GetHashKey("bmx")
							end
							local found = false
							for k, v in pairs(Client.Vehicle.SavedVehicles) do
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
								while not HasModelLoaded(model) do Wait(0) end
								local pos = GetEntityCoords(ped)
								local heading = GetEntityHeading(ped)
								local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(pos.x, pos.y, pos.z, true, false)
								local tempVehicle = CreateVehicle(model, x, y, z, heading, false, false)
								SetVehicleColourCombination(tempVehicle, 0)
								local props = Client.Function.Tuning.GetProperties(tempVehicle, true)
								checkpoint.respawnData = props
								if checkpoint_2 then
									checkpoint_2.respawnData = props
								end
								SetModelAsNoLongerNeeded(model)
								DeleteEntity(tempVehicle)
							end
						end
					end
				end
				local respawnCheckpoint = Race.GlobalVar.LastCheckpointPair == 1 and Race.Track.Current.Checkpoints_2[index] or Race.Track.Current.Checkpoints[index]
				if respawnCheckpoint.respawnData.model == -422877666 then
					Race.SyncData.Vehicle = "parachute"
					if respawnCheckpoint.respawnData.model ~= currentModel then
						Client.Function.Message.Display_2(Client.Function.Translate.Get("Transform-Parachute"), false, nil)
					end
					Race.GlobalVar.TransformIsParachute = true
					Race.GlobalVar.TransformIsBeast = false
					Race.GlobalVar.WasDoingBeastJump = false
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				elseif respawnCheckpoint.respawnData.model == -731262150 then
					Race.SyncData.Vehicle = "beast"
					if respawnCheckpoint.respawnData.model ~= currentModel then
						Client.Function.Message.Display_2(Client.Function.Translate.Get("Transform-Beast"), false, nil)
					end
					Race.GlobalVar.TransformIsParachute = false
					Race.GlobalVar.TransformIsBeast = true
					Race.GlobalVar.WasDoingBeastJump = false
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
				else
					Race.SyncData.Vehicle = GetDisplayNameFromVehicleModel(respawnCheckpoint.respawnData.model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(respawnCheckpoint.respawnData.model) or "Unknown"
					if respawnCheckpoint.respawnData.model ~= currentModel then
						Client.Function.Message.Display_2(GetLabelText(Race.SyncData.Vehicle), false, nil)
					end
					Race.GlobalVar.TransformIsParachute = false
					Race.GlobalVar.TransformIsBeast = false
					Race.GlobalVar.WasDoingBeastJump = false
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
				end
				if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(respawnCheckpoint.x, respawnCheckpoint.y, respawnCheckpoint.z, respawnCheckpoint.heading, true, false) end
				if reset then
					Race.Function.RespawnVehicle(respawnCheckpoint.x, respawnCheckpoint.y, respawnCheckpoint.z, respawnCheckpoint.heading, true, respawnCheckpoint, function(success)
						if success then
							Race.Function.ResetCheckpointAndBlip()
							Race.Function.CreateCheckpointBlip(Race.GlobalVar.ActualCheckpoint, Race.GlobalVar.ActualLap)
							Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, false, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
							Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, true, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
						end
					end)
				else
					Race.Function.RespawnVehicle(respawnCheckpoint.x, respawnCheckpoint.y, respawnCheckpoint.z, respawnCheckpoint.heading, true, respawnCheckpoint)
				end
			end
			if Race.Track.Current.Mode == "gta" then
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
			end
			Client.Function.Weapon.ReloadForRaceAndCreator(ped, Race.GlobalVar.TransformIsParachute, Race.GlobalVar.TransformIsBeast, Race.Track.Current.Mode == "gta")
			Race.Cache.IsRespawningInProgress = false
		end)
	end
end

function Race.Function.GetNonFakeCheckpoint(cpIndex)
	local reset = false
	for i = cpIndex - 1, 1, -1 do
		local checkpoint = Race.Track.Current.Checkpoints[i]
		local checkpoint_2 = Race.Track.Current.Checkpoints_2[i]
		if Race.GlobalVar.LastCheckpointPair == 1 and checkpoint_2 then
			if not checkpoint_2.isFake and not checkpoint_2.isPlaneRot then
				return i, reset
			else
				Race.GlobalVar.TotalCheckpointsTouched = Race.GlobalVar.TotalCheckpointsTouched - 1
				Race.GlobalVar.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint - 1
				reset = true
			end
		else
			if not checkpoint.isFake and not checkpoint.isPlaneRot then
				return i, reset
			else
				Race.GlobalVar.TotalCheckpointsTouched = Race.GlobalVar.TotalCheckpointsTouched - 1
				Race.GlobalVar.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint - 1
				reset = true
			end
		end
	end
	return 1, reset
end

function Race.Function.RespawnVehicle(posX, posY, posZ, heading, engine, checkpoint, cb)
	local ped = PlayerPedId()
	local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(posX, posY, posZ, false, true)
	local model = nil
	if not Race.Function.Pool.IsNearbyObjectsSpawned(x, y) then
		if engine then
			DoScreenFadeOut(0)
			SendNUIMessage({
				action = "fade out",
				time = 0
			})
		end
		Race.ObjectPool.ForceLoad.x = x
		Race.ObjectPool.ForceLoad.y = y
		Race.ObjectPool.ForceLoad.z = z
		local time = GetGameTimer()
		while not Race.Function.Pool.IsNearbyObjectsSpawned(x, y) and (GetGameTimer() - time < 500) do Wait(0) end
	end
	if checkpoint then
		if Race.GlobalVar.TransformIsParachute or Race.GlobalVar.TransformIsBeast then
			if cb ~= nil then cb(true) end
			Race.Function.DeleteVehicle()
			ClearPedBloodDamage(ped)
			ClearPedWetness(ped)
			SetEntityCoords(ped, x, y, z)
			SetEntityHeading(ped, heading)
			SetGameplayCamRelativeHeading(0)
			DoScreenFadeIn(500)
			SendNUIMessage({
				action = "fade in",
				time = 500
			})
			Race.ObjectPool.ForceLoad.x = nil
			Race.ObjectPool.ForceLoad.y = nil
			Race.ObjectPool.ForceLoad.z = nil
			return
		end
		model = checkpoint.respawnData.model
	else
		if type(Race.Cache.VehicleProps) == "table" then
			model = Race.Cache.VehicleProps.model
		elseif type(Race.Cache.VehicleProps) == "number" then
			model = Race.Cache.VehicleProps
		elseif type(Race.Cache.VehicleProps) == "string" then
			model = GetHashKey(Race.Cache.VehicleProps)
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
		Race.SyncData.Vehicle = GetDisplayNameFromVehicleModel(model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(model) or "Unknown"
		Client.Function.Message.Display_2(GetLabelText(Race.SyncData.Vehicle), false, nil)
	end
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end
	-- Spawn vehicle at the top of the player, fix OneSync culling
	local pos = GetEntityCoords(ped)
	local _x, _y, _z = Client.Function.Shared.GetValidXYZFor_3dCoord(pos.x, pos.y, pos.z, true, false)
	local newVehicle = CreateVehicle(model, _x, _y, _z, heading, true, false)
	local netId = NetworkGetNetworkIdFromEntity(newVehicle)
	TriggerServerEvent("server:core:spawnEntity", netId)
	SetModelAsNoLongerNeeded(model)
	FreezeEntityPosition(newVehicle, true)
	SetEntityCollision(newVehicle, false, false)
	SetVehRadioStation(newVehicle, "OFF")
	SetVehicleDoorsLocked(newVehicle, Race.Track.Current.Mode == "gta" and 0 or 10)
	SetVehicleColourCombination(newVehicle, 0)
	if checkpoint then
		Client.Function.Tuning.SetProperties(newVehicle, checkpoint.respawnData)
	else
		if type(Race.Cache.VehicleProps) == "number" or type(Race.Cache.VehicleProps) == "string" or not isHashValid then
			local found = false
			for k, v in pairs(Client.Vehicle.SavedVehicles) do
				if v.model == model then
					Race.Cache.VehicleProps = v
					Client.Function.Tuning.SetProperties(newVehicle, v)
					found = true
					break
				end
			end
			if not found then
				Race.Cache.VehicleProps = Client.Function.Tuning.GetProperties(newVehicle, true)
			end
		else
			Client.Function.Tuning.SetProperties(newVehicle, Race.Cache.VehicleProps)
		end
	end
	if Race.Track.Current.Mode ~= "no_collision" then
		SetLocalPlayerAsGhost(true)
	end
	Wait(0) -- Do not delete! Vehicle still has collisions before this. BUG?
	if cb ~= nil then cb(true) end
	Race.Function.DeleteVehicle()
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
	DoScreenFadeIn(500)
	SendNUIMessage({
		action = "fade in",
		time = 500
	})
	Wait(0)
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
	Race.ObjectPool.ForceLoad.x = nil
	Race.ObjectPool.ForceLoad.y = nil
	Race.ObjectPool.ForceLoad.z = nil
	Race.Track.Current.LastVehicle = newVehicle
	if Race.Track.Current.Mode ~= "no_collision" then
		CreateThread(function()
			Wait(500)
			while not Race.Cache.IsRespawningInProgress and (Race.Status == "ready" or Race.Status == "racing") do
				local myCoords = GetEntityCoords(PlayerPedId())
				local isPedNearMe = false
				for _, driver in pairs(Race.Track.Current.Drivers) do
					if Client.ServerId ~= driver.playerId and (#(myCoords - driver.currentCoords) <= 10.0) then
						isPedNearMe = true
						break
					end
				end
				if not isPedNearMe or (Race.Track.Current.PlayerCount == 1) then
					break
				end
				Wait(0)
			end
			if not Race.Cache.IsRespawningInProgress then
				SetLocalPlayerAsGhost(false)
			end
		end)
	end
end

function Race.Function.TransformVehicle(checkpoint, speed, rotation, velocity, cb)
	Race.Cache.IsTransformingInProgress = true
	CreateThread(function()
		local transformVehicle = 0
		if checkpoint.isRandom then
			transformVehicle = Client.Function.Shared.GetRandomVehicleModel(Race.Track.Current.TransformVehicles, Race.Track.Current.RandomVehicles, checkpoint.randomClass, checkpoint.randomCustom, checkpoint.randomSetting)
		else
			transformVehicle = Race.Track.Current.TransformVehicles[checkpoint.transformIndex + 1]
		end
		local model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
		local ped = PlayerPedId()
		local copyVelocity = true
		if Race.GlobalVar.TransformIsParachute or Race.GlobalVar.TransformIsBeast then
			copyVelocity = ((math.abs(velocity.x) > 0.0) or (math.abs(velocity.y) > 0.0) or (math.abs(velocity.z) > 0.0)) and true or false
			speed = speed > 0.03 and speed or 30.0
		end
		Race.GlobalVar.TransformIsParachute = (model == -422877666) and true or false
		Race.GlobalVar.TransformIsBeast = (model == -731262150) and true or false
		Race.GlobalVar.WasDoingBeastJump = false
		if Race.GlobalVar.TransformIsParachute or Race.GlobalVar.TransformIsBeast then
			Race.Function.DeleteVehicle()
			cb(Race.GlobalVar.TransformIsParachute and {model = -422877666} or {model = -731262150})
			Race.SyncData.Vehicle = Race.GlobalVar.TransformIsParachute and "parachute" or "beast"
			Client.Function.Message.Display_2(Race.GlobalVar.TransformIsParachute and Client.Function.Translate.Get("Transform-Parachute") or Client.Function.Translate.Get("Transform-Beast"), false, nil)
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			SetRunSprintMultiplierForPlayer(PlayerId(), Race.GlobalVar.TransformIsBeast and 1.49 or 1.0)
			Client.Function.Weapon.ReloadForRaceAndCreator(ped, Race.GlobalVar.TransformIsParachute, Race.GlobalVar.TransformIsBeast, Race.Track.Current.Mode == "gta")
			Race.Cache.IsTransformingInProgress = false
			return
		end
		local reset = false
		if model == 0 then
			reset = true
			model = Race.Cache.VehicleProps.model
		end
		if not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model) then
			if model then
				print("vehicle model (" .. model .. ") does not exist in current gta version! We have spawned a default vehicle for you")
			else
				print("Unknown error! We have spawned a default vehicle for you")
			end
			model = GetHashKey("bmx")
		end
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(0) end
		local pos = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local x1, y1, z1 = Client.Function.Shared.GetValidXYZFor_3dCoord(pos.x, pos.y, pos.z, true, false)
		local x2, y2, z2 = Client.Function.Shared.GetValidXYZFor_3dCoord(pos.x, pos.y, pos.z, false, true)
		local newVehicle = CreateVehicle(model, x1, y1, z1, heading, true, false)
		local netId = NetworkGetNetworkIdFromEntity(newVehicle)
		TriggerServerEvent("server:core:spawnEntity", netId)
		SetModelAsNoLongerNeeded(model)
		Race.Function.DeleteVehicle()
		SetVehRadioStation(newVehicle, "OFF")
		SetVehicleDoorsLocked(newVehicle, Race.Track.Current.Mode == "gta" and 0 or 10)
		SetVehicleColourCombination(newVehicle, 0)
		local props = reset and Race.Cache.VehicleProps or nil
		if not props then
			for k, v in pairs(Client.Vehicle.SavedVehicles) do
				if v.model == model then
					props = v
					break
				end
			end
		end
		props = props or Client.Function.Tuning.GetProperties(newVehicle, true)
		cb(props)
		Client.Function.Tuning.SetProperties(newVehicle, props)
		SetPedIntoVehicle(ped, newVehicle, -1)
		SetEntityCoords(newVehicle, x2, y2, z2)
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
		Race.SyncData.Vehicle = GetDisplayNameFromVehicleModel(model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(model) or "Unknown"
		Client.Function.Message.Display_2(GetLabelText(Race.SyncData.Vehicle), false, nil)
		Client.Function.Weapon.ReloadForRaceAndCreator(ped, false, false, Race.Track.Current.Mode == "gta")
		Race.Track.Current.LastVehicle = newVehicle
		Race.Cache.IsTransformingInProgress = false
	end)
end

function Race.Function.DeleteVehicle()
	if DoesEntityExist(Race.Track.Current.LastVehicle) then
		local netId = NetworkGetNetworkIdFromEntity(Race.Track.Current.LastVehicle)
		DeleteEntity(Race.Track.Current.LastVehicle)
		TriggerServerEvent("server:core:deleteEntity", netId)
	end
end

function Race.Function.Reset(showResult)
	CreateThread(function()
		local ped = PlayerPedId()
		Race.Function.Camera.Remove()
		SwitchOutPlayer(ped, 0, 1)
		Race.Function.ResetCheckpointAndBlip()
		Race.Function.ResetAndHideRespawnUI()
		Wait(3000)
		if showResult then
			Race.Cache.IsOverClouds = true
			Race.Function.ShowScoreboard()
			Wait(1000 + 2000 * (math.floor((Race.Track.Current.PlayerCount - 1) / 10) + 1))
			Race.Cache.IsOverClouds = false
		end
		Race.Function.DeleteVehicle()
		Client.Function.Weapon.RemoveAll(ped)
		FreezeEntityPosition(ped, true)
		if Race.Cache.JoinVehicleNetId then
			SetEntityCoords(ped, Race.Cache.JoinPoint)
			SetEntityHeading(ped, Race.Cache.JoinHeading)
		else
			SetEntityCoordsNoOffset(ped, Race.Cache.JoinPoint)
			SetEntityHeading(ped, Race.Cache.JoinHeading)
		end
		ClearPedBloodDamage(ped)
		ClearPedWetness(ped)
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		SetPedConfigFlag(ped, 151, true)
		SetPedCanBeKnockedOffVehicle(ped, 0)
		SetEntityInvincible(ped, false)
		SetPedArmour(ped, 100)
		SetEntityHealth(ped, 200)
		SetEntityVisible(ped, true)
		SetBlipAlpha(GetMainPlayerBlipId(), 255)
		SetLocalPlayerAsGhost(false)
		ClearAreaLeaveVehicleHealth(Race.Cache.JoinPoint.x + 0.0, Race.Cache.JoinPoint.y + 0.0, Race.Cache.JoinPoint.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
		Wait(500)
		local veh = Race.Cache.JoinVehicleNetId and NetworkDoesNetworkIdExist(Race.Cache.JoinVehicleNetId) and NetworkDoesEntityExistWithNetworkId(Race.Cache.JoinVehicleNetId) and NetworkGetEntityFromNetworkId(Race.Cache.JoinVehicleNetId)
		if DoesEntityExist(veh) then
			SetPedIntoVehicle(ped, veh, -1)
		end
		SetGameplayCamRelativeHeading(0)
		SwitchInPlayer(ped)
		while IsPlayerSwitchInProgress() do Wait(0) end
		if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
			local pos = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)
			NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, heading, true, false)
		end
		FreezeEntityPosition(ped, false)
		Race.Cache.JoinPoint = nil
		Race.Cache.JoinHeading = nil
		Race.Cache.JoinVehicleNetId = nil
		Race.Cache.IsRespawningInProgress = false
		Race.Cache.IsTransformingInProgress = false
		Race.Cache.IsTeleportingInProgress = false
		Race.Cache.HasCheated = false
		Race.Cache.VehicleProps = {}
		Race.ArenaProps = {}
		Race.ExplodeProps = {}
		Race.FireworkProps = {}
		Race.HUD.Bottom = {}
		Race.HUD.Position.Showed = false
		Race.HUD.Position.Page = 1
		Race.GlobalVar.TransformIsParachute = false
		Race.GlobalVar.TransformIsBeast = false
		Race.GlobalVar.WasDoingBeastJump = false
		Race.SyncData.ActualLap = 1
		Race.SyncData.ActualCheckpoint = 1
		Race.SyncData.Vehicle = ""
		Race.SyncData.LastLap = 0
		Race.SyncData.BestLap = 0
		Race.SyncData.TotalRaceTime = 0
		Race.SyncData.TotalCheckpointsTouched = 0
		Race.SyncData.LastCheckpointPair = 0
		Race.Track.Current.RoomId = nil
		Race.Track.Current.OwnerName = ""
		Race.Track.Current.Title = ""
		Race.Track.Current.BlimpText = ""
		Race.Track.Current.Laps = 1
		Race.Track.Current.Mode = ""
		Race.Track.Current.RoomData = nil
		Race.Track.Current.PlayerCount = 1
		Race.Track.Current.Drivers = {}
		Race.Track.Current.LastVehicle = nil
		Race.Track.Current.DefaultVehicle = nil
		Race.Track.Current.RandomVehicles = {}
		Race.Track.Current.GridPositionIndex = 1
		Race.Track.Current.StartingGrid = {}
		Race.Track.Current.StartingGrid[1] = {}
		Race.Track.Current.StartingGrid[1].x = 0.0
		Race.Track.Current.StartingGrid[1].y = 0.0
		Race.Track.Current.StartingGrid[1].z = 0.0
		Race.Track.Current.StartingGrid[1].heading = 0.0
		Race.Track.Current.Checkpoints = {}
		Race.Track.Current.Checkpoints_2 = {}
		Race.Track.Current.TransformVehicles = {}
		Race.Track.Current.Fixtures = {}
		Race.Track.Current.Firework = {}
		Race.Track.Current.Firework.Name = "scr_indep_firework_trailburst"
		Race.Track.Current.Firework.R = 255
		Race.Track.Current.Firework.G = 255
		Race.Track.Current.Firework.B = 255
		Race.Status = "freemode"
		Client.IsInRace = false
		Client.IsInSpectator = false
		Client.Hud.ResetNextFrame = true
		if Client.Permission.Weapon and Client.Preference.WeaponLoaded then
			Client.Function.Weapon.RemoveAll(PlayerPedId())
			Client.Function.Weapon.LoadSaved(PlayerPedId())
		end
		Client.Menu.Main.Index = 1
		TriggerServerEvent("server:core:inRace", false)
		TriggerServerCallback("server:race:getRoomList", function(result)
			SendNUIMessage({
				action = "update room list",
				result = result
			})
		end)
	end)
end

function Race.Function.Finish(raceStatus)
	Race.Status = "waiting"
	SendNUIMessage({
		action = "hide race hud",
		timeLap = Race.Track.Current.Laps > 1 and GetTimeAsString(Race.GlobalVar.ActualLapTime),
		timeTotal = GetTimeAsString(Race.GlobalVar.TotalRaceTime)
	})
	local ped = PlayerPedId()
	local finishCoords = GetEntityCoords(ped)
	if Race.Track.Current.PlayerCount - Race.Function.Player.GetFinishedCount() >= 2 and raceStatus == "yeah" then
		Race.Function.Camera.Create()
	end
	TriggerServerEvent("server:race:playerFinish", {
		Client.Function.Math.RoundedValue(1.0 / GetFrameTime()),
		Race.SyncData.ActualLap,
		Race.SyncData.ActualCheckpoint,
		Race.SyncData.Vehicle,
		Race.SyncData.LastLap,
		Race.SyncData.BestLap,
		Race.SyncData.TotalRaceTime,
		Race.SyncData.TotalCheckpointsTouched,
		Race.SyncData.LastCheckpointPair,
		IsUsingKeyboard()
	}, GetGameTimer() + 3000, Race.Cache.HasCheated, vector3(Client.Function.Math.RoundedValue(finishCoords.x, 3), Client.Function.Math.RoundedValue(finishCoords.y, 3), Client.Function.Math.RoundedValue(finishCoords.z, 3)), raceStatus)
	Race.Function.ResetCheckpointAndBlip()
	Wait(1000)
	SetEntityVisible(ped, false)
	FreezeEntityPosition(ped, true)
	Race.Function.DeleteVehicle()
	Client.Function.Weapon.RemoveAll(ped)
	SetBlipAlpha(GetMainPlayerBlipId(), 0)
end

function Race.Function.ShowScoreboard()
	CreateThread(function()
		local frontPosResultAll = {}
		local bestLapTable = {}
		local driversInfo = Race.Function.Player.GetDriversInfo(Race.Track.Current.Drivers)
		local currentUiPageResult = 1
		local firstLoad = true
		for k, v in pairs(Race.Track.Current.Drivers) do
			if not v.dnf and v.hasFinished then
				table.insert(bestLapTable, {
					playerId = v.playerId,
					bestLap = v.bestLap
				})
			end
			table.insert(frontPosResultAll, {
				playerId = v.playerId,
				position = Race.Function.Player.GetPosition(driversInfo, v.playerId),
				name = v.playerName,
				flag = v.flag or "US",
				keyboard = v.keyboard and "💻" or "🎮",
				vehicle = (v.vehicle == "parachute" and Client.Function.Translate.Get("Transform-Parachute")) or (v.vehicle == "beast" and Client.Function.Translate.Get("Transform-Beast")) or (GetLabelText(v.vehicle) ~= "NULL" and GetLabelText(v.vehicle):gsub("µ", " ")) or Client.Function.Translate.Get("unknown-vehicle"),
				totalTime = v.dnf and "DNF" or (v.hasFinished and GetTimeAsString(v.totalRaceTime)) or "network error", -- Maybe someone's network latency is too high?
				bestLap = v.dnf and "DNF" or (v.hasFinished and GetTimeAsString(v.bestLap)) or "network error" -- Maybe someone's network latency is too high?
			})
		end
		table.sort(bestLapTable, function(a, b)
			return a.bestLap < b.bestLap
		end)
		table.sort(frontPosResultAll, function(a, b)
			return a.position < b.position
		end)
		if #bestLapTable > 0 then
			for i = 1, #frontPosResultAll do
				if frontPosResultAll[i].playerId == bestLapTable[1].playerId then
					frontPosResultAll[i].bestLap = frontPosResultAll[i].bestLap .. "★"
					break
				end
			end
		end
		while Race.Cache.IsOverClouds do
			local startIdx = (currentUiPageResult - 1) * 10 + 1
			local endIdx = math.min(startIdx + 10 - 1, Race.Track.Current.PlayerCount)
			local frontPosResult = {}
			for i = startIdx, endIdx do
				local player = frontPosResultAll[i]
				if player then
					table.insert(frontPosResult, player)
				end
			end
			SendNUIMessage({
				action = "show scoreboard",
				frontPosResult = frontPosResult,
				title = firstLoad and (Race.Track.Current.Title .. " (" .. Race.Track.Current.OwnerName .. ")") or false
			})
			firstLoad = false
			if (currentUiPageResult * 10) < Race.Track.Current.PlayerCount then
				currentUiPageResult = currentUiPageResult + 1
			else
				currentUiPageResult = 1
			end
			Wait(2000)
		end
		SendNUIMessage({
			action = "hide scoreboard"
		})
	end)
end

function Race.Function.UpdatePauseMenuInfo()
	SendNUIMessage({
		action = "update pause menu",
		img = Race.Track.Current.RoomData.img,
		title = Race.Track.Current.Title .. " (" .. Race.Track.Current.OwnerName .. ")",
		dnf = Race.Track.Current.RoomData.dnf,
		traffic = Race.Track.Current.RoomData.traffic,
		weather = Race.Track.Current.RoomData.weather,
		time = Race.Track.Current.RoomData.time .. ":00",
		accessible = Race.Track.Current.RoomData.accessible,
		mode = Race.Track.Current.RoomData.mode
	})
end

function Race.Function.SetFireworks()
	if #Race.FireworkProps > 0 then
		CreateThread(function()
			while Client.IsInRace do
				local ped = Race.Status == "spectating" and DoesEntityExist(Race.SpectateData.Ped) and Race.SpectateData.Ped or PlayerPedId()
				local pos = GetEntityCoords(ped)
				for k, v in pairs(Race.FireworkProps) do
					if not v.playing and DoesEntityExist(v.handle) and (#(pos - GetEntityCoords(v.handle)) <= 50.0) then
						v.playing = true
						CreateThread(function()
							RequestNamedPtfxAsset("scr_indep_fireworks")
							while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do Wait(0) end
							UseParticleFxAssetNextCall("scr_indep_fireworks")
							local effect = StartParticleFxLoopedOnEntity(Race.Track.Current.Firework.Name, v.handle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)
							local r, g, b = tonumber(Race.Track.Current.Firework.R), tonumber(Race.Track.Current.Firework.G), tonumber(Race.Track.Current.Firework.B)
							if r and g and b then
								SetParticleFxLoopedColour(effect, (r / 255) + 0.0, (g / 255) + 0.0, (b / 255) + 0.0, true)
							end
							Wait(2000)
							StopParticleFxLooped(effect, true)
							v.playing = nil
						end)
					end
				end
				Wait(0)
			end
		end)
	end
end

function Race.Function.RemoveFixtures()
	if #Race.Track.Current.Fixtures > 0 then
		CreateThread(function()
			local hide = {}
			for k, v in pairs(Race.Track.Current.Fixtures) do
				hide[v.hash] = true
			end
			while Client.IsInRace do
				if Race.Status == "ready" or Race.Status == "racing" or Race.Status == "spectating" then
					local spawn = {}
					for uniqueId, object in pairs(Race.ObjectPool.ActiveObjects) do
						if object.handle then
							spawn[object.handle] = true
						end
					end
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
					for k, v in pairs(Race.Track.Current.Fixtures) do
						local fixture = GetClosestObjectOfType(pos.x, pos.y, pos.z, 300.0, v.hash, false)
						if fixture and not spawn[fixture] and DoesEntityExist(fixture) then
							SetEntityAsMissionEntity(fixture, true, true)
							DeleteEntity(fixture)
						end
					end
				elseif Race.Status == "leaving" or Race.Status == "ending" then
					break
				end
				Wait(0)
			end
		end)
	end
end

function Race.Function.SyncData()
	CreateThread(function()
		local firstSync = true
		local a, b, c, d, e, f, g, h, i, j = nil, nil, nil, nil, nil, nil, nil, nil, nil
		while Race.Status == "ready" or Race.Status == "racing" do
			local fps = Client.Function.Math.RoundedValue(1.0 / GetFrameTime())
			local keyboard = IsUsingKeyboard()
			if firstSync or (a ~= fps) or (b ~= Race.SyncData.ActualLap) or (c ~= Race.SyncData.ActualCheckpoint) or (d ~= Race.SyncData.Vehicle) or (e ~= Race.SyncData.LastLap) or (f ~= Race.SyncData.BestLap) or (g ~= Race.SyncData.TotalRaceTime) or (h ~= Race.SyncData.TotalCheckpointsTouched) or (i ~= Race.SyncData.LastCheckpointPair) or (j ~= keyboard) then
				firstSync = false
				a, b, c, d, e, f, g, h, i, j = fps, Race.SyncData.ActualLap, Race.SyncData.ActualCheckpoint, Race.SyncData.Vehicle, Race.SyncData.LastLap, Race.SyncData.BestLap, Race.SyncData.TotalRaceTime, Race.SyncData.TotalCheckpointsTouched, Race.SyncData.LastCheckpointPair, keyboard
				TriggerServerEvent("server:race:clientSync", {
					fps,
					Race.SyncData.ActualLap,
					Race.SyncData.ActualCheckpoint,
					Race.SyncData.Vehicle,
					Race.SyncData.LastLap,
					Race.SyncData.BestLap,
					Race.SyncData.TotalRaceTime,
					Race.SyncData.TotalCheckpointsTouched,
					Race.SyncData.LastCheckpointPair,
					keyboard
				}, GetGameTimer())
			end
			Wait(500)
		end
	end)
end