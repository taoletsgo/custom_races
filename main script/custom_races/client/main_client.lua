StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
StatSetInt(`MP0_STEALTH_ABILITY`, 100, true)
StatSetInt(`MP0_FLYING_ABILITY`, 100, true)
StatSetInt(`MP0_WHEELIE_ABILITY`, 100, true)
StatSetInt(`MP0_LUNG_CAPACITY`, 100, true)
StatSetInt(`MP0_STRENGTH`, 100, true)
StatSetInt(`MP0_STAMINA`, 100, true)

roomServerId = nil
inMenu = false
inRoom = false
isCreatorEnable = false
inVehicleUI = false
status = ""
JoinRacePoint = nil -- Record the last location
JoinRaceHeading = 0 -- Record the last heading
timeServerSide = {
	["syncDrivers"] = nil,
	["syncPlayers"] = nil,
}
dataOutdated = false
local cooldownTime = nil
local isLocked = false
local lastVehicle = nil
local disableTraffic = false
local togglePositionUI = false
local totalPlayersInRace = 0
local currentUiPage = 1
local weatherAndTime = {}
local track = {}
local laps = 0
local car = {}
local raceData = {}
local carTransformed = ""
local transformIsParachute = false
local transformIsSuperJump = false
local canFoot = true
local lastspectatePlayerId = nil
local pedToSpectate = nil
local spectatingPlayerIndex = 0
local totalCheckPointsTouched = 0
local actualCheckPoint = 0
local actualCheckPoint_draw = nil
local actualCheckPoint_pair_draw = nil
local actualCheckPoint_spectate_draw = nil
local actualCheckPoint_spectate_pair_draw = nil
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
local gridPosition = 0
local totalDriversNubmer = nil
local hasShowRespawnUI = false
local isActuallyRestartingPosition = false
local isRestartingPosition = false
local hasRestartedPosition = false
local restartingPositionTimer = 0
local restartingPositionTimerStart = 0
local isPlayerSpawning = false
local isActuallyTransforming = false
local cam = nil
local isOverClouds = false
local drivers = {}
local cacheddata = {} -- UI

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
	2211086889,
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

--- Function to set grid position and reset info
function JoinRace()
	local ped = PlayerPedId()
	carTransformed = ""
	isActuallyTransforming = false
	lastVehicle = nil
	SetCar(car, track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z, track.positions[gridPosition].heading, false)

	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(ped, true, true)
	totalCheckPointsTouched = 0
	actualCheckPoint = 1
	nextCheckpoint = 2
	actualLap = 1
	actualLapTime = 0

	while not IsEntityPositionFrozen(GetVehiclePedIsIn(ped, false)) do
		FreezeEntityPosition(GetVehiclePedIsIn(ped, false), true)
		Citizen.Wait(100)
	end
	SetEntityCoords(GetVehiclePedIsIn(ped, false), vector3(track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z))

	actualBlip = CreateBlip(actualCheckPoint, 1, false, false)
	if track.checkpoints[actualCheckPoint].hasPair then
		actualBlip_pair = CreateBlip(actualCheckPoint, 1, false, true)
	end

	nextBlip = CreateBlip(nextCheckpoint, 1, true, false)
	if track.checkpoints[nextCheckpoint].hasPair then
		nextBlip_pair = CreateBlip(nextCheckpoint, 1, true, true)
	end
end

--- Function to start race
function StartRace()
	status = "racing"
	cacheddata = {}
	totalDriversNubmer = nil

	if track.mode == "gta" then
		GiveWeapons()
	end

	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "showRaceHud"
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
			end

			if track.mode ~= "gta" then
				canFoot = false
				SetEntityInvincible(ped, true)
				SetPedArmour(ped, 100)
				SetEntityHealth(ped, 200)
				SetPlayerCanDoDriveBy(PlayerId(), true)
				DisableControlAction(0, 75, true) -- F
				if DoesVehicleHaveWeapons(vehicle) == 1 then
					for i = 1, #vehicle_weapons do
						DisableVehicleWeapon(true, vehicle_weapons[i], vehicle, ped)
					end
				end
				if GetEntityModel(vehicle) == GetHashKey("bmx") then
					-- Allow flipping the bird while on a bike to taunt
					EnableControlAction(0, 68, true)
				else
					DisableControlAction(0, 68, true)
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
				if hasRestartedPosition and not isActuallyRestartingPosition and not transformIsParachute and not transformIsSuperJump and not IsPedInAnyVehicle(ped) and not canFoot then
					ResetAndHideRespawnUI()
				end

				-- Press F to respawn
				StartRestartPosition()
			elseif not transformIsParachute and not transformIsSuperJump and not IsPedInAnyVehicle(ped) and not canFoot then
				if hasRestartedPosition and not isActuallyRestartingPosition then
					ResetAndHideRespawnUI()
				end

				-- Automatically respawn after falling off a car
				StartRestartPosition()
			else
				ResetAndHideRespawnUI()
			end

			local checkPointTouched = false
			local playerCoords = GetEntityCoords(ped)
			local checkpointCoords = vector3(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z)
			local checkpointCoords_pair = vector3(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z)
			local checkpointRadius = track.checkpoints[actualCheckPoint].d / 2
			local checkpointRadius_pair = track.checkpoints[actualCheckPoint].pair_d / 2
			local _checkpointCoords = checkpointCoords
			local _checkpointCoords_pair = checkpointCoords_pair

			-- The actual rendered primary checkpoint coords
			if finishLine then
				if track.checkpoints[actualCheckPoint].isRound then
					if not track.checkpoints[actualCheckPoint].isLarge then
						_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
					end
				else
					_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
				end
			else
				if track.checkpoints[actualCheckPoint].isRound or track.checkpoints[actualCheckPoint].warp or track.checkpoints[actualCheckPoint].planerot or track.checkpoints[actualCheckPoint].transform ~= -1 then
					if not track.checkpoints[actualCheckPoint].isLarge then
						_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
					end
				else
					_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
				end
			end

			-- The actual rendered secondary checkpoint coords
			if track.checkpoints[actualCheckPoint].hasPair then
				if finishLine then
					if track.checkpoints[actualCheckPoint].pair_isRound then
						if not track.checkpoints[actualCheckPoint].pair_isLarge then
							_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
						end
					else
						_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
					end
				else
					if track.checkpoints[actualCheckPoint].pair_isRound or track.checkpoints[actualCheckPoint].pair_warp or track.checkpoints[actualCheckPoint].pair_planerot or track.checkpoints[actualCheckPoint].pair_transform ~= -1 then
						if not track.checkpoints[actualCheckPoint].pair_isLarge then
							_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
						end
					else
						_checkpointCoords_pair = checkpointCoords_pair + vector3(0, 0, checkpointRadius_pair)
					end
				end
			end

			-- When ped (not vehicle) touch the checkpoint
			if ((#(playerCoords - checkpointCoords) <= checkpointRadius) or (#(playerCoords - _checkpointCoords) <= (checkpointRadius * 1.5))) and not isActuallyRestartingPosition and not isActuallyTransforming then
				checkPointTouched = true
				lastCheckpointPair = 0

				if track.checkpoints[actualCheckPoint].transform ~= -1 and not finishLine then
					PlayVehicleTransformEffectsAndSound()
					SetCarTransformed(track.checkpoints[actualCheckPoint].transform, actualCheckPoint)
				elseif track.checkpoints[actualCheckPoint].warp and not finishLine then
					PlayVehicleTransformEffectsAndSound()
					Warp(false)
				elseif track.checkpoints[actualCheckPoint].planerot and not finishLine then
					if vehicle ~= 0 then
						local planerot = track.checkpoints[actualCheckPoint].planerot
						local rot = GetEntityRotation(vehicle)

						if planerot == "up" then
							if rot.x > 45 or rot.x < -45 or rot.y > 45 or rot.y < -45 then
								Slow()
							end
						elseif planerot == "left" then
							if rot.y > -40 then
								Slow()
							end
						elseif planerot == "right" then
							if rot.y < 40 then
								Slow()
							end
						elseif planerot == "down" then
							if (rot.x < 135 and rot.x > -135) or rot.y > 45 or rot.y < -45 then
								Slow()
							end
						end
					end
				end
			elseif track.checkpoints[actualCheckPoint].hasPair and ((#(playerCoords - checkpointCoords_pair) <= checkpointRadius_pair) or (#(playerCoords - _checkpointCoords_pair) <= (checkpointRadius_pair * 1.5))) and not isActuallyRestartingPosition and not isActuallyTransforming then
				checkPointTouched = true
				lastCheckpointPair = 1

				if track.checkpoints[actualCheckPoint].pair_transform ~= -1 and not finishLine then
					PlayVehicleTransformEffectsAndSound()
					SetCarTransformed(track.checkpoints[actualCheckPoint].pair_transform, actualCheckPoint)
				elseif track.checkpoints[actualCheckPoint].pair_warp and not finishLine then
					PlayVehicleTransformEffectsAndSound()
					Warp(true)
				end
			end

			if checkPointTouched then
				totalCheckPointsTouched = totalCheckPointsTouched + 1
				DeleteCheckpoint(actualCheckPoint_draw)
				DeleteCheckpoint(actualCheckPoint_pair_draw)
				actualCheckPoint_draw = nil
				actualCheckPoint_pair_draw = nil
				RemoveBlip(actualBlip)
				RemoveBlip(nextBlip)
				RemoveBlip(actualBlip_pair)
				RemoveBlip(nextBlip_pair)
				if actualCheckPoint == #track.checkpoints then
					-- Finish a lap
					PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
					if actualLap < laps then
						-- If more laps are left after completing a lap
						actualCheckPoint = 1
						nextCheckpoint = 2
						actualLap = actualLap + 1
						startLapTime = GetGameTimer()
						TriggerServerEvent("custom_races:updateTime", actualLapTime, totalRaceTime, actualLap)
					else
						-- Finish the race
						finishRace("yeah")
						break
					end
				else
					PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
					actualCheckPoint = actualCheckPoint + 1
					nextCheckpoint = nextCheckpoint + 1
				end
				TriggerServerEvent("custom_races:updateCheckPoint", actualCheckPoint, totalCheckPointsTouched, lastCheckpointPair, roomServerId)

				-- Create a blip for the actual checkpoint
				if actualCheckPoint == #track.checkpoints then
					if actualLap < laps then
						actualBlip = CreateBlip(actualCheckPoint, 58, false, false, true)
						if track.checkpoints[actualCheckPoint].hasPair then
							actualBlip_pair = CreateBlip(actualCheckPoint, 58, false, true, true)
						end
					else
						actualBlip = CreateBlip(actualCheckPoint, 38, false, false, true)
						if track.checkpoints[actualCheckPoint].hasPair then
							actualBlip_pair = CreateBlip(actualCheckPoint, 38, false, true, true)
						end
						finishLine = true
					end
				else
					actualBlip = CreateBlip(actualCheckPoint, 1, false, false)
					if track.checkpoints[actualCheckPoint].hasPair then
						actualBlip_pair = CreateBlip(actualCheckPoint, 1, false, true)
					end
				end

				-- Create a blip for the next checkpoint
				if nextCheckpoint > #track.checkpoints then
					if actualLap < laps then
						nextBlip = CreateBlip(1, 1, true, false)
						if track.checkpoints[1].hasPair then
							nextBlip_pair = CreateBlip(1, 1, true, true)
						end
					else
						RemoveBlip(nextBlip)
						RemoveBlip(nextBlip_pair)
					end
				elseif nextCheckpoint == #track.checkpoints then
					if actualLap < laps then
						nextBlip = CreateBlip(nextCheckpoint, 58, true, false, true)
						if track.checkpoints[nextCheckpoint].hasPair then
							nextBlip_pair = CreateBlip(nextCheckpoint, 58, true, true, true)
						end
					else
						nextBlip = CreateBlip(nextCheckpoint, 38, true, false, true)
						if track.checkpoints[nextCheckpoint].hasPair then
							nextBlip_pair = CreateBlip(nextCheckpoint, 38, true, true, true)
						end
					end
				else
					nextBlip = CreateBlip(nextCheckpoint, 1, true, false)
					if track.checkpoints[nextCheckpoint].hasPair then
						nextBlip_pair = CreateBlip(nextCheckpoint, 1, true, true)
					end
				end
			end

			-- Draw the HUD
			DrawBottomHUD()

			-- Draw the primary checkpoint
			DrawCheckpointMarker(finishLine, actualCheckPoint, false)

			-- Draw the secondary checkpoint
			DrawCheckpointMarker(finishLine, actualCheckPoint, true)

			Citizen.Wait(0)
		end
		DeleteCheckpoint(actualCheckPoint_draw)
		DeleteCheckpoint(actualCheckPoint_pair_draw)
		actualCheckPoint_draw = nil
		actualCheckPoint_pair_draw = nil
		RemoveBlip(actualBlip)
		RemoveBlip(nextBlip)
		RemoveBlip(actualBlip_pair)
		RemoveBlip(nextBlip_pair)
	end)

	-- Player rankings
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
					label_distance = GetTranslate("racing-ui-label_distance"),
					label_lap = GetTranslate("racing-ui-label_lap"),
					label_checkpoint = GetTranslate("racing-ui-label_checkpoint"),
					label_vehicle = GetTranslate("racing-ui-label_vehicle"),
					label_bestlap = GetTranslate("racing-ui-label_bestlap"),
					label_totaltime = GetTranslate("racing-ui-label_totaltime")
				}

				for k, v in pairs(_drivers) do
					local _position = GetPlayerPosition(driversInfo, v.playerID)
					local _name = v.playerName
					local _distance = nil
					local _lap = v.actualLap
					local _checkpoint = v.actualCheckPoint - 1
					local _vehicle = (GetLabelText(v.vehNameCurrent) ~= "NULL" and GetLabelText(v.vehNameCurrent)) or (v.vehNameCurrent ~= "" and v.vehNameCurrent) or "On Foot"
					local _bestlap = GetTimeAsString(v.bestLap)
					local _totaltime = v.hasFinished and GetTimeAsString(v.totalRaceTime) or "-"
					if v.hasnf then
						table.insert(frontpos, {
							position = _position,
							name = _name,
							distance = "DNF",
							lap = "DNF",
							checkpoint = "DNF",
							vehicle = "DNF",
							bestlap = "DNF",
							totaltime = "DNF"
						})
					elseif v.hasFinished and not v.hasnf then
						table.insert(frontpos, {
							position = _position,
							name = _name,
							distance = "-",
							lap = "-",
							checkpoint = "-",
							vehicle = _vehicle,
							bestlap = _bestlap,
							totaltime = _totaltime
						})
					else
						_distance = RoundedValue(#(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(v.playerID))) - vector3(v.lastCheckpointPair == 1 and track.checkpoints[v.actualCheckPoint].hasPair and track.checkpoints[v.actualCheckPoint].pair_x or track.checkpoints[v.actualCheckPoint].x, v.lastCheckpointPair == 1 and track.checkpoints[v.actualCheckPoint].hasPair and track.checkpoints[v.actualCheckPoint].pair_y or track.checkpoints[v.actualCheckPoint].y, v.lastCheckpointPair == 1 and track.checkpoints[v.actualCheckPoint].hasPair and track.checkpoints[v.actualCheckPoint].pair_z or track.checkpoints[v.actualCheckPoint].z)), 1) .. "m"
						table.insert(frontpos, {
							position = _position,
							name = _name,
							distance = _distance,
							lap = _lap,
							checkpoint = _checkpoint,
							vehicle = _vehicle,
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

				local frontpos_show ={}

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
				isPositionUIVisible = false
				SendNUIMessage({
					action = "hidePositionUI"
				})
			end

			if firstLoad then
				playerTopPosition = driversInfo[1].playerID
				firstLoad = false
			end

			if (GetGameTimer() - startTime) >= 5000 then
				if totalPlayersInRace > 1 and (playerTopPosition ~= driversInfo[1].playerID) and not driversInfo[1].hasFinished then
					playerTopPosition = driversInfo[1].playerID
					local message = string.format(GetTranslate("racing-info-1st"), driversInfo[1].playerName)
					MsgItem = DisplayNotification(message, true, MsgItem)
				end
			end
		end
		SendNUIMessage({
			action = "hidePositionUI"
		})
	end)
end

--- Function to sort drivers
--- @param driversToSort table The current drivers to be sort
--- @return table The sorted list of current drivers
function UpdateDriversInfo(driversToSort)
	local sortedDrivers = {}

	for _, driver in pairs(driversToSort) do
		local cpIndex = driver.actualCheckPoint
		local cpTouchPair = driver.lastCheckpointPair == 1 and track.checkpoints[cpIndex].hasPair
		local playerCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(driver.playerID)))
		local cpCoords = cpTouchPair and vector3(track.checkpoints[cpIndex].pair_x, track.checkpoints[cpIndex].pair_y, track.checkpoints[cpIndex].pair_z) or vector3(track.checkpoints[cpIndex].x, track.checkpoints[cpIndex].y, track.checkpoints[cpIndex].z)
		driver.dist = #(playerCoords - cpCoords)
		table.insert(sortedDrivers, driver)
	end

	table.sort(sortedDrivers, function(a, b)
		if not a.hasnf and not b.hasnf then
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

		if a.hasnf and b.hasnf then
			if a.totalCheckpointsTouched == b.totalCheckpointsTouched then
				return a.dist < b.dist
			else
				return a.totalCheckpointsTouched > b.totalCheckpointsTouched
			end
		end

		if a.hasnf ~= b.hasnf then
			return not a.hasnf
		end
	end)

	return sortedDrivers
end

--- Function to get the position of a player
--- @param _driversInfo table The sorted list of current drivers
--- @param playerID number The ID of the player whose position is to be determined
--- @return number The position of the player in the sorted list
function GetPlayerPosition(_driversInfo, playerID)
	for position, driver in ipairs(_driversInfo) do
		if driver.playerID == tonumber(playerID) then
			return position
		end
	end
	return Config.MaxPlayers + 1
end

--- Function to draw hud
function DrawBottomHUD()
	-- Current lap number
	if not cacheddata.actualLap or cacheddata.actualLap ~= actualLap then
		SendNUIMessage({
			laps = actualLap .. "/" .. laps
		})
		cacheddata.actualLap = actualLap
	end

	-- Current Ranking
	local _drivers = drivers
	local driversInfo = UpdateDriversInfo(_drivers)
	local position = GetPlayerPosition(driversInfo, GetPlayerServerId(PlayerId()))
	if not cacheddata.position or cacheddata.position ~= position or totalDriversNubmer ~= Count(_drivers) then
		SendNUIMessage({
			position = position .. '</span><span style="font-size: 4vh;margin-left: 9px;">/ ' .. Count(_drivers)
		})
		cacheddata.position = position
		totalDriversNubmer = Count(_drivers)
	end

	-- Current Checkpoint
	local checkpoints = actualCheckPoint - 1 >= 0 and actualCheckPoint - 1 or 0
	if not cacheddata.checkpoints or cacheddata.checkpoints ~= checkpoints then
		SendNUIMessage({
			checkpoints = checkpoints .. "/" .. (#track.checkpoints-1 >= 0 and #track.checkpoints-1 or 0)
		})
		cacheddata.checkpoints = checkpoints
	end

	-- Current time
	local time = GetGameTimer() - totalTimeStart
	if not cacheddata.time or time - cacheddata.time >= 1000 then
		local minutes = math.floor(time / 60000)
		local seconds = math.floor(time / 1000 - minutes * 60)
		if minutes <= 9 then minutes = "0"..minutes end
		if seconds <= 9 then seconds = "0"..seconds end
		SendNUIMessage({
			time = minutes .. ":" .. seconds
		})
		cacheddata.time = time
	end
end

--- Function to create a marker
--- @param markerType number The type of marker to create
--- @param x number The x-coordinate of the marker
--- @param y number The y-coordinate of the marker
--- @param z number The z-coordinate of the marker
--- @param rx number The x-axis rotation of the marker
--- @param ry number The y-axis rotation of the marker
--- @param rz number The z-axis rotation of the marker
--- @param w number The scale for the marker on the X axis
--- @param l number The scale for the marker on the Y axis
--- @param h number The scale for the marker on the Z axis
--- @param r number The red component of the marker's color (0-255)
--- @param g number The green component of the marker's color (0-255)
--- @param b number The blue component of the marker's color (0-255)
--- @param a number The alpha (transparency) of the marker (0-255)
--- @param faceCamera boolean Whether to rotate with the camera (only for end checkpoint / finish line)
function CreateMarker(marerkType, x, y, z, rx, ry, rz, w, l, h, r, g, b, a, faceCamera)
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

--- Function to get a checkpoint marker info
--- @param isFinishLine boolean Whether the checkpoint is a finish line
--- @param index number The number of actual checkpoint
--- @param pair boolean Whether to use the secondary checkpoint coordinates for drawing
function DrawCheckpointMarker(isFinishLine, index, pair)
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
			local checkpoint_z = isRound and (isLarge and 0.0 or diameter/2) or diameter/2

			if status == "racing" and actualCheckPoint_pair_draw == nil then
				actualCheckPoint_pair_draw = CreateCheckpoint(
					17,
					x,
					y,
					z + checkpoint_z,
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_x or track.checkpoints[index + 1].x)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_x or track.checkpoints[1].x),
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_y or track.checkpoints[index + 1].y)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_y or track.checkpoints[1].y),
					(track.checkpoints[index + 1] and (track.checkpoints[index + 1].hasPair and track.checkpoints[index + 1].pair_z or track.checkpoints[index + 1].z)) or (track.checkpoints[1].hasPair and track.checkpoints[1].pair_z or track.checkpoints[1].z),
					diameter/2, 62, 182, 245, 125, 0
				)
			elseif status == "spectating" and actualCheckPoint_spectate_pair_draw == nil then
				actualCheckPoint_spectate_pair_draw = CreateCheckpoint(
					17,
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
			local checkpoint_z = isRound and (isLarge and 0.0 or diameter/2) or diameter/2

			if status == "racing" and actualCheckPoint_draw == nil then
				actualCheckPoint_draw = CreateCheckpoint(
					17,
					x,
					y,
					z + checkpoint_z,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].x or track.checkpoints[1].x,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].y or track.checkpoints[1].y,
					track.checkpoints[index + 1] and track.checkpoints[index + 1].z or track.checkpoints[1].z,
					diameter/2, 62, 182, 245, 125, 0
				)
			elseif status == "spectating" and actualCheckPoint_spectate_draw == nil then
				actualCheckPoint_spectate_draw = CreateCheckpoint(
					17,
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
			CreateMarker(5, x, y, z + updateZ, 0.0, 0.0, 0.0, diameter, diameter, diameter, 62, 182, 245, 125, true)
			CreateMarker(6, x, y, z + updateZ, 0.0, 0.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125, true)
		else
			CreateMarker(4, x, y, z + diameter/2, 0.0, 0.0, 0.0, diameter/2, diameter/2, diameter/2, 62, 182, 245, 125, true)
			CreateMarker(1, x, y, z, 0.0, 0.0, 0.0, diameter, diameter, diameter/2, 254, 235, 169, 30, true)
		end
	else
		if transform ~= -1 then
			local vehicleHash = nil
			local vehicleClass = nil
			local marker = 32

			if transform ~= -2 and transform ~= -3 then
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

			CreateMarker(marker, x, y, z + updateZ, 0.0, 0.0, heading, diameter/2, diameter/2, diameter/2, 62, 182, 245, 125)
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 255, 50, 50, 125)
		elseif planerot then
			local r, g, b = 62, 182, 245
			local ped = PlayerPedId()
			local rot = GetEntityRotation(GetVehiclePedIsIn(ped, false))

			if planerot == "up" then
				if rot.x > 45 or rot.x < -45 or rot.y > 45 or rot.y < -45 then
					r, g, b = 255, 50, 50
				end
				CreateMarker(7, x, y, z + updateZ, 0.0, 0.0, 180 + heading, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			elseif planerot == "left" then
				if rot.y > -40 then
					r, g, b = 255, 50, 50
				end
				CreateMarker(7, x, y, z + updateZ, heading, -90.0, 180.0, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			elseif planerot == "right" then
				if rot.y < 40 then
					r, g, b = 255, 50, 50
				end
				CreateMarker(7, x, y, z + updateZ, heading - 180, 270.0, 0.0, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			elseif planerot == "down" then
				if (rot.x < 135 and rot.x > -135) or rot.y > 45 or rot.y < -45 then
					r, g, b = 255, 50, 50
				end
				CreateMarker(7, x, y, z + updateZ, 180.0, 0.0, -heading, diameter/2, diameter/2, diameter/2, r, g, b, 125)
			end
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125)
		elseif warp then
			CreateMarker(42, x, y, z + updateZ, 0.0, 0.0, heading, diameter/2, diameter/2, diameter/2, 62, 182, 245, 125)
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125)
		elseif isRound then
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, diameter, diameter, diameter, 254, 235, 169, 125)
		else
			CreateMarker(1, x, y, z, 0.0, 0.0, 0.0, diameter, diameter, diameter/2, 254, 235, 169, 30)
		end
	end
end

--- Function to create a blip
--- @param cpIndex number The number of the checkponint
--- @param id number The sprite ID for the blip
--- @param isNext boolean Whether this blip is for the next checkpoint (affects scale and alpha)
--- @param isPair boolean Whether this blip is for the primary or secondary checkpoint
--- @param isFinishLine boolean Whether this blip is for the lap-end or finish line
--- @return number The handle of the created blip
function CreateBlip(cpIndex, id, isNext, isPair, isFinishLine)
	local blip = nil
	local scale = 0.9
	local alpha = 255
	local blipId = id
	local color = 5

	if isNext then
		scale = 0.65
		alpha = 130
	end

	if isPair and not isFinishLine and track.checkpoints[cpIndex].pair_transform ~= -1 then
		blipId = 570
		color = 1
	elseif not isPair and not isFinishLine and track.checkpoints[cpIndex].transform ~= -1 then
		blipId = 570
		color = 1
	end

	if isPair then
		blip = AddBlipForCoord(track.checkpoints[cpIndex].pair_x, track.checkpoints[cpIndex].pair_y, track.checkpoints[cpIndex].pair_z)
	else
		blip = AddBlipForCoord(track.checkpoints[cpIndex].x, track.checkpoints[cpIndex].y, track.checkpoints[cpIndex].z)
	end

	SetBlipSprite(blip, blipId)
	SetBlipColour(blip, color)
	SetBlipDisplay(blip, 6)
	BeginTextCommandSetBlipName("STRING")
	if isFinishLine then
		AddTextComponentString(GetTranslate("racing-blip-finishline"))
	else
		AddTextComponentString(GetTranslate("racing-blip-checkpoint"))
	end
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, scale)
	SetBlipAlpha(blip, alpha)

	return blip
end

--- Function to hold down the F key or fall off the car for 500ms to trigger respawn
function StartRestartPosition()
	local waitTime = Config.RespawnHoldTime
	local waitUiTime = 100

	if status == "racing" then
		if hasRestartedPosition then
			return
		end

		if not isRestartingPosition then
			restartingPositionTimerStart = GetGameTimer()
			isRestartingPosition = true
		end

		if restartingPositionTimer >= waitTime then
			restartingPositionTimer = waitTime
			RestartPosition()
			hasRestartedPosition = true
		else
			restartingPositionTimer = GetGameTimer() - restartingPositionTimerStart
		end

		if restartingPositionTimer >= waitUiTime and not hasShowRespawnUI then
			SendNUIMessage({
				action = "showRestartPosition"
			})
			hasShowRespawnUI = true
		end
	else
		ResetAndHideRespawnUI()
	end
end

--- Function to reset respawn settings and hide respawn UI
function ResetAndHideRespawnUI()
	hasRestartedPosition = false
	isRestartingPosition = false
	restartingPositionTimer = 0
	if hasShowRespawnUI then
		SendNUIMessage({
			action = "hideRestartPosition"
		})
		hasShowRespawnUI = false
	end
end

--- Function to restart position
function RestartPosition()
	if not isActuallyRestartingPosition then
		isActuallyRestartingPosition = true
		Citizen.CreateThread(function()
			if Config.EnableRespawnBlackScreen then
				DoScreenFadeOut(500)
				Citizen.Wait(500)
			end
			local ped = PlayerPedId()
			if track.checkpoints then
				if track.checkpoints[actualCheckPoint - 1] == nil then
					if totalCheckPointsTouched ~= 0 then
						local lapEndCheckpoint = #track.checkpoints

						local x_lap = track.checkpoints[lapEndCheckpoint].x
						local y_lap = track.checkpoints[lapEndCheckpoint].y
						local z_lap = track.checkpoints[lapEndCheckpoint].z
						local heading_lap = track.checkpoints[lapEndCheckpoint].heading

						if lastCheckpointPair == 1 and track.checkpoints[lapEndCheckpoint].hasPair then
							x_lap = track.checkpoints[lapEndCheckpoint].pair_x
							y_lap = track.checkpoints[lapEndCheckpoint].pair_y
							z_lap = track.checkpoints[lapEndCheckpoint].pair_z
							heading_lap = track.checkpoints[lapEndCheckpoint].pair_heading
						end
						if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
							NetworkResurrectLocalPlayer(x_lap, y_lap, z_lap, heading_lap, true, false)
						end
						SetCar(car, x_lap, y_lap, z_lap, heading_lap, true)
					else
						if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
							NetworkResurrectLocalPlayer(track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z, track.positions[gridPosition].heading, true, false)
						end
						SetCar(car, track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z, track.positions[gridPosition].heading, true)
					end
				else
					local nonTemporalCheckpoint, reset = GetNonTemporalCheckpointToSpawn()

					if reset then
						finishLine = false
						DeleteCheckpoint(actualCheckPoint_draw)
						DeleteCheckpoint(actualCheckPoint_pair_draw)
						actualCheckPoint_draw = nil
						actualCheckPoint_pair_draw = nil
						RemoveBlip(actualBlip)
						RemoveBlip(nextBlip)
						RemoveBlip(actualBlip_pair)
						RemoveBlip(nextBlip_pair)

						actualBlip = CreateBlip(actualCheckPoint, 1, false, false)
						if track.checkpoints[actualCheckPoint].hasPair then
							actualBlip_pair = CreateBlip(actualCheckPoint, 1, false, true)
						end

						if nextCheckpoint == #track.checkpoints then
							if actualLap < laps then
								nextBlip = CreateBlip(nextCheckpoint, 58, true, false, true)
								if track.checkpoints[nextCheckpoint].hasPair then
									nextBlip_pair = CreateBlip(nextCheckpoint, 58, true, true, true)
								end
							else
								nextBlip = CreateBlip(nextCheckpoint, 38, true, false, true)
								if track.checkpoints[nextCheckpoint].hasPair then
									nextBlip_pair = CreateBlip(nextCheckpoint, 38, true, true, true)
								end
							end
						else
							nextBlip = CreateBlip(nextCheckpoint, 1, true, false)
							if track.checkpoints[nextCheckpoint].hasPair then
								nextBlip_pair = CreateBlip(nextCheckpoint, 1, true, true)
							end
						end

						TriggerServerEvent("custom_races:updateCheckPoint", actualCheckPoint, totalCheckPointsTouched, lastCheckpointPair, roomServerId)
					end

					local x = track.checkpoints[nonTemporalCheckpoint].x
					local y = track.checkpoints[nonTemporalCheckpoint].y
					local z = track.checkpoints[nonTemporalCheckpoint].z
					local heading = track.checkpoints[nonTemporalCheckpoint].heading

					if lastCheckpointPair == 1 and track.checkpoints[nonTemporalCheckpoint].hasPair then
						x = track.checkpoints[nonTemporalCheckpoint].pair_x
						y = track.checkpoints[nonTemporalCheckpoint].pair_y
						z = track.checkpoints[nonTemporalCheckpoint].pair_z
						heading = track.checkpoints[nonTemporalCheckpoint].pair_heading
					end

					if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(x, y, z, heading, true, false) end
					SetCar(car, x, y, z, heading, true)
				end
			else
				if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then NetworkResurrectLocalPlayer(100.0, 150.0, 100.0, 100.0, true, false) end
			end
			if Config.EnableRespawnBlackScreen then
				DoScreenFadeIn(500)
				Citizen.Wait(500)
			end
			isActuallyRestartingPosition = false
			isPlayerSpawning = false
			if track.mode == "gta" then
				GiveWeapons()
			end
		end)
	end
end

--- Function to get checkpoint that is not a fake
--- @return number The number of valid checkpoint
--- @return boolean Whether to reset CheckpointsAndBlips
function GetNonTemporalCheckpointToSpawn()
	local cpIndex = actualCheckPoint
	local resetCheckpointsAndBlips = false
	for i = cpIndex - 1, 1, -1 do
		if lastCheckpointPair ~= 1 and not track.checkpoints[i].isTemporal and track.checkpoints[i].planerot == nil then
			return i, resetCheckpointsAndBlips
		elseif lastCheckpointPair == 1 and not track.checkpoints[i].pair_isTemporal and track.checkpoints[i].pair_planerot == nil then
			return i, resetCheckpointsAndBlips
		else
			totalCheckPointsTouched = totalCheckPointsTouched - 1
			nextCheckpoint = nextCheckpoint - 1
			actualCheckPoint = actualCheckPoint - 1
			resetCheckpointsAndBlips = true
		end
	end
	return 1, resetCheckpointsAndBlips
end

--- Function to teleport to the previous checkpoint
--- @return boolean Whether teleported or not
function TeleportToPreviousCheckpoint()
	if actualCheckPoint - 2 <= 0 then return false end

	finishLine = false
	totalCheckPointsTouched = totalCheckPointsTouched - 1
	nextCheckpoint = nextCheckpoint - 1
	actualCheckPoint = actualCheckPoint - 1

	local ped = PlayerPedId()
	if lastCheckpointPair == 1 and track.checkpoints[actualCheckPoint - 1].hasPair then
		if IsPedInAnyVehicle(ped) then
			SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint - 1].pair_x, track.checkpoints[actualCheckPoint - 1].pair_y, track.checkpoints[actualCheckPoint - 1].pair_z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint - 1].pair_heading)
		else
			SetEntityCoords(ped, track.checkpoints[actualCheckPoint - 1].pair_x, track.checkpoints[actualCheckPoint - 1].pair_y, track.checkpoints[actualCheckPoint - 1].pair_z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(ped, track.checkpoints[actualCheckPoint - 1].pair_heading)
		end
	else
		if IsPedInAnyVehicle(ped) then
			SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint - 1].x, track.checkpoints[actualCheckPoint - 1].y, track.checkpoints[actualCheckPoint - 1].z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint - 1].heading)
		else
			SetEntityCoords(ped, track.checkpoints[actualCheckPoint - 1].x, track.checkpoints[actualCheckPoint - 1].y, track.checkpoints[actualCheckPoint - 1].z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(ped, track.checkpoints[actualCheckPoint - 1].heading)
		end
	end
	PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)

	DeleteCheckpoint(actualCheckPoint_draw)
	DeleteCheckpoint(actualCheckPoint_pair_draw)
	actualCheckPoint_draw = nil
	actualCheckPoint_pair_draw = nil
	RemoveBlip(actualBlip)
	RemoveBlip(nextBlip)
	RemoveBlip(actualBlip_pair)
	RemoveBlip(nextBlip_pair)

	actualBlip = CreateBlip(actualCheckPoint, 1, false, false)
	if track.checkpoints[actualCheckPoint].hasPair then
		actualBlip_pair = CreateBlip(actualCheckPoint, 1, false, true)
	end

	if nextCheckpoint == #track.checkpoints then
		if actualLap < laps then
			nextBlip = CreateBlip(nextCheckpoint, 58, true, false, true)
			if track.checkpoints[nextCheckpoint].hasPair then
				nextBlip_pair = CreateBlip(nextCheckpoint, 58, true, true, true)
			end
		else
			nextBlip = CreateBlip(nextCheckpoint, 38, true, false, true)
			if track.checkpoints[nextCheckpoint].hasPair then
				nextBlip_pair = CreateBlip(nextCheckpoint, 38, true, true, true)
			end
		end
	else
		nextBlip = CreateBlip(nextCheckpoint, 1, true, false)
		if track.checkpoints[nextCheckpoint].hasPair then
			nextBlip_pair = CreateBlip(nextCheckpoint, 1, true, true)
		end
	end

	TriggerServerEvent("custom_races:updateCheckPoint", actualCheckPoint, totalCheckPointsTouched, lastCheckpointPair, roomServerId)

	return true
end

--- Function to respawn the vehicle
--- @param _car number|table The model hash or table of the vehicle to be set
--- @param positionX number The X coordinate of the checkpoint's position
--- @param positionY number The Y coordinate of the checkpoint's position
--- @param positionZ number The Z coordinate of the checkpoint's position
--- @param heading number The heading direction of the checkpoint
--- @param engine boolean Whether to start the vehicle's engine (true) or not (false)
function SetCar(_car, positionX, positionY, positionZ, heading, engine)
	local carHash = carTransformed ~= "" and carTransformed or (type(_car) == "number" and _car or _car.model)
	local isHashValid = true
	local ped = PlayerPedId()

	if transformIsParachute then
		DeleteEntity(GetVehiclePedIsIn(ped, false))
		GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
		SetEntityCoords(ped, positionX, positionY, positionZ)
		SetEntityHeading(ped, heading)
		SetGameplayCamRelativeHeading(0)
		return
	end

	if transformIsSuperJump then
		DeleteEntity(GetVehiclePedIsIn(ped, false))
		SetEntityCoords(ped, positionX, positionY, positionZ)
		SetEntityHeading(ped, heading)
		SetGameplayCamRelativeHeading(0)
		return
	end

	if not IsModelInCdimage(carHash) or not IsModelValid(carHash) then
		if carHash then
			print("vehicle model ("..carHash..") does not exist in current gta version! We have spawned a default vehicle for you")
		else
			print("Unknown error! We have spawned a default vehicle for you")
		end
		isHashValid = false
		carHash = Config.ReplaceInvalidVehicle
		local vehNameCurrent = GetDisplayNameFromVehicleModel(carHash) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(carHash) or "Unknown"
		TriggerServerEvent("custom_races:updateVehName", vehNameCurrent)
	end

	RequestModel(carHash)

	while not HasModelLoaded(carHash) do
		Citizen.Wait(0)
	end

	-- Spawn vehicle at the top of the checkpoint
	local x, y, z, newHeading = positionX, positionY, positionZ + 50, heading
	local spawnedVehicle = CreateVehicle(carHash, x, y, z, newHeading, true, false)

	FreezeEntityPosition(spawnedVehicle, true)
	SetEntityCoordsNoOffset(spawnedVehicle, x, y, z)
	SetEntityHeading(spawnedVehicle, newHeading)
	SetEntityCollision(spawnedVehicle, false, false)
	SetVehicleDoorsLocked(spawnedVehicle, 0)
	SetVehicleFuelLevel(spawnedVehicle, 100.0)
	SetVehRadioStation(spawnedVehicle, 'OFF')
	SetModelAsNoLongerNeeded(carHash)

	if type(_car) == "number" or not isHashValid then
		car = GetVehicleProperties(spawnedVehicle)
	else
		SetVehicleProperties(spawnedVehicle, _car)
	end

	if Config.EnableRespawnBlackScreen then
		ClearPedTasksImmediately(ped)
		Citizen.Wait(0)
	end

	if track.mode == "no_collision" and not Config.EnableRespawnBlackScreen then
		-- Wait for 1 frame
		Citizen.Wait(0) -- Do not delete it, otherwise there will be a 1 frame collision in non-collision mode
	end

	-- Delete last vehicle after spawn new vehicle
	if DoesEntityExist(lastVehicle) then
		local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
		TriggerServerEvent("custom_races:deleteVehicle", vehId)
	end
	if GetVehiclePedIsIn(ped, false) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(ped, false))
	end
	if GetVehiclePedIsIn(ped, true) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(ped, true))
	end

	-- send ped into spawnedVehicle
	SetPedIntoVehicle(ped, spawnedVehicle, -1)
	if track.mode ~= "gta" then
		SetVehicleDoorsLocked(spawnedVehicle, 4)
	end

	-- Teleport the vehicle back to the checkpoint location
	SetEntityCoords(spawnedVehicle, positionX, positionY, positionZ)
	SetEntityHeading(spawnedVehicle, heading)
	SetEntityCollision(spawnedVehicle, true, true)

	SetVehicleEngineOn(spawnedVehicle, engine, true, false)
	SetGameplayCamRelativeHeading(0)

	Citizen.Wait(0)
	FreezeEntityPosition(spawnedVehicle, false)
	ActivatePhysics(spawnedVehicle)

	-- Helicopter and plane speed
	if IsThisModelAPlane(carHash) or IsThisModelAHeli(carHash) then
		ControlLandingGear(spawnedVehicle, 3)
		SetHeliBladesSpeed(spawnedVehicle, 1.0)
		SetHeliBladesFullSpeed(spawnedVehicle)
		SetVehicleForwardSpeed(spawnedVehicle, 30.0)
	end

	if carHash == GetHashKey("avenger") or carHash == GetHashKey("hydra") then
		SetVehicleFlightNozzlePositionImmediate(spawnedVehicle, 0.0)
	end

	local vehNetId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
	TriggerServerEvent('custom_races:spawnvehicle', vehNetId)
	lastVehicle = spawnedVehicle
end

--- Function to transform vehicle
--- @param transformIndex number The index of the vehicle transformation in the track's transformation list
--- @param index number The number of the actual checkpoint
function SetCarTransformed(transformIndex, index)
	Citizen.CreateThread(function()
		isActuallyTransforming = true

		local carHash = 0

		if transformIndex == -2 then
			carHash = GetRandomVehModel(index)
		elseif transformIndex == -3 then -- Random add-on, NOT UGC RACEs from social club
			carHash = GetRandomAddOnVehModel()
		else
			carHash = track.transformVehicles[transformIndex + 1]
		end

		local ped = PlayerPedId()
		local copySpeed = false
		local oldVehicle = GetVehiclePedIsIn(ped, false)
		local oldVehicleSpeed = oldVehicle ~= 0 and GetEntitySpeed(oldVehicle) or GetEntitySpeed(ped) -- Old vehicle speed
		local oldVehicleRotation = oldVehicle ~= 0 and GetEntityRotation(oldVehicle, 2) or GetEntityRotation(ped, 2) -- Old vehicle rotation
		local oldVelocity = oldVehicle ~= 0 and GetEntityVelocity(oldVehicle) or GetEntityVelocity(ped) -- Old vehicle velocity

		if transformIsParachute or transformIsSuperJump then
			copySpeed = true
		end

		if carHash == 0 then
			-- Transform vehicle to the start vehicle
			carHash = car.model
			carTransformed = ""
		elseif carHash == -422877666 then
			-- parachute
			if DoesEntityExist(lastVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
				TriggerServerEvent("custom_races:deleteVehicle", vehId)
			end
			if GetVehiclePedIsIn(ped, false) ~= 0 then
				DeleteEntity(GetVehiclePedIsIn(ped, false))
			end
			if GetVehiclePedIsIn(ped, true) ~= 0 then
				DeleteEntity(GetVehiclePedIsIn(ped, true))
			end
			local vehNameCurrent = ""
			TriggerServerEvent("custom_races:updateVehName", vehNameCurrent)
			GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
			SetEntityVelocity(ped, oldVelocity.x, oldVelocity.y, oldVelocity.z)
			transformIsParachute = true
			transformIsSuperJump = false
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			isActuallyTransforming = false
			return
		elseif carHash == -731262150 then
			-- beast mode
			if DoesEntityExist(lastVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
				TriggerServerEvent("custom_races:deleteVehicle", vehId)
			end
			if GetVehiclePedIsIn(ped, false) ~= 0 then
				DeleteEntity(GetVehiclePedIsIn(ped, false))
			end
			if GetVehiclePedIsIn(ped, true) ~= 0 then
				DeleteEntity(GetVehiclePedIsIn(ped, true))
			end
			local vehNameCurrent = ""
			TriggerServerEvent("custom_races:updateVehName", vehNameCurrent)
			SetEntityVelocity(ped, oldVelocity.x, oldVelocity.y, oldVelocity.z)
			transformIsParachute = false
			transformIsSuperJump = true
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
			isActuallyTransforming = false

			Citizen.CreateThread(function()
				local wasJumping = false
				local wasOnFoot = false
				local canPlayLandSound = false
				while transformIsSuperJump do
					SetSuperJumpThisFrame(PlayerId())
					SetBeastModeActive(PlayerId())
					local pedInBeastMode = PlayerPedId()
					local isJumping = IsPedDoingBeastJump(pedInBeastMode)
					local isOnFoot = not IsPedFalling(pedInBeastMode)
					if isJumping and not wasJumping then
						canPlayLandSound = true
						-- PlaySound(-1, "Beast_Jump", "DLC_AR_Beast_Soundset", true) -- I don't like beast sound
					end
					if isOnFoot and not wasOnFoot and canPlayLandSound then
						canPlayLandSound = false
						-- PlaySound(-1, "Beast_Jump_Land", "DLC_AR_Beast_Soundset", true) -- I don't like beast sound
					end
					wasJumping = isJumping
					wasOnFoot = isOnFoot
					Citizen.Wait(0)
				end
			end)

			return
		end

		if not IsModelInCdimage(carHash) or not IsModelValid(carHash) then
			if carHash then
				print("vehicle model ("..carHash..") does not exist in current gta version! We have spawned a default vehicle for you")
			else
				print("Unknown error! We have spawned a default vehicle for you")
			end
			carHash = Config.ReplaceInvalidVehicle
		end

		carTransformed = carHash
		transformIsParachute = false
		transformIsSuperJump = false
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)

		RequestModel(carHash)

		while not HasModelLoaded(carHash) do
			Citizen.Wait(0)
		end

		local pos = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local spawnedVehicle = CreateVehicle(carHash, pos.x, pos.y, pos.z + 50, heading, true, false)

		if not AreAnyVehicleSeatsFree(spawnedVehicle) then
			if DoesEntityExist(spawnedVehicle) then
				local vehId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
				TriggerServerEvent("custom_races:deleteVehicle", vehId)
				DeleteEntity(spawnedVehicle)
			end
			isActuallyTransforming = false
			return SetCarTransformed(transformIndex, index)
		end

		SetVehicleDoorsLocked(spawnedVehicle, 0)
		SetVehicleFuelLevel(spawnedVehicle, 100.0)
		SetVehRadioStation(spawnedVehicle, 'OFF')
		SetVehicleProperties(spawnedVehicle, car)
		SetModelAsNoLongerNeeded(carHash)

		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			TriggerServerEvent("custom_races:deleteVehicle", vehId)
		end
		if GetVehiclePedIsIn(ped, false) ~= 0 then
			DeleteEntity(GetVehiclePedIsIn(ped, false))
		end
		if GetVehiclePedIsIn(ped, true) ~= 0 then
			DeleteEntity(GetVehiclePedIsIn(ped, true))
		end

		SetPedIntoVehicle(ped, spawnedVehicle, -1)
		if track.mode ~= "gta" then
			SetVehicleDoorsLocked(spawnedVehicle, 4)
		end

		SetEntityCoords(spawnedVehicle, pos.x, pos.y, pos.z)
		SetEntityHeading(spawnedVehicle, heading)
		SetVehicleEngineOn(spawnedVehicle, true, true, false)

		if IsThisModelAPlane(carHash) or IsThisModelAHeli(carHash) then
			ControlLandingGear(spawnedVehicle, 3)
			SetHeliBladesSpeed(spawnedVehicle, 1.0)
			SetHeliBladesFullSpeed(spawnedVehicle)
			copySpeed = true
		end

		if carHash == GetHashKey("avenger") or carHash == GetHashKey("hydra") then
			SetVehicleFlightNozzlePositionImmediate(spawnedVehicle, 0.0)
		end

		-- Reset speed
		SetVehicleForwardSpeed(spawnedVehicle, 0.0)

		-- Inherit the velocity of the old vehicle
		SetEntityVelocity(spawnedVehicle, oldVelocity.x, oldVelocity.y, oldVelocity.z)

		-- Inherit the rotation of the old vehicle
		SetEntityRotation(spawnedVehicle, oldVehicleRotation, 2)

		if copySpeed then
			-- Inherit the speed of the old vehicle
			SetVehicleForwardSpeed(spawnedVehicle, oldVehicleSpeed ~= 0.0 and oldVehicleSpeed or 30.0)
		end

		local vehNameCurrent = GetDisplayNameFromVehicleModel(carHash) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(carHash) or "Unknown"
		TriggerServerEvent("custom_races:updateVehName", vehNameCurrent)

		local vehNetId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
		TriggerServerEvent('custom_races:spawnvehicle', vehNetId)
		lastVehicle = spawnedVehicle

		if lastCheckpointPair == 1 and track.checkpoints[index].hasPair and track.checkpoints[index].pair_warp then
			Warp(true)
		elseif lastCheckpointPair == 0 and track.checkpoints[index].warp then
			Warp(false)
		end

		isActuallyTransforming = false
	end)
end

--- Function to get veh hash for random races
--- @param index number The number of the actual checkpoint
function GetRandomVehModel(index)
	local carHash = 0
	local isUnknownUnknowns = (lastCheckpointPair == 0 and track.cp1_unknown_unknowns) or (lastCheckpointPair == 1 and track.cp2_unknown_unknowns)

	if isUnknownUnknowns then
		-- Random race type: Unknown Unknowns (mission.race.cptrtt ~= nil)
		local vehicleList = {}
		local allVehClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22}
		for k, v in pairs(allVehClass) do
			vehicleList[v] = {}
		end

		local allVehModels = GetAllVehicleModels()
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

		availableClass = filteredAvailableClass

		while true do
			if isRandomClassValid then
				local modelClassIndex = math.random(#availableClass)
				local randomIndex = math.random(#vehicleList[availableClass[modelClassIndex]])
				local randomHash = vehicleList[availableClass[modelClassIndex]][randomIndex]

				if carTransformed ~= randomHash then
					carHash = randomHash
					break
				end
			else
				local randomIndex = math.random(#allVehModels)
				local randomHash = GetHashKey(allVehModels[randomIndex])
				local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))

				if not Config.BlacklistedVehs[randomHash] and label ~= "NULL" and IsThisModelACar(randomHash) then
					if carTransformed ~= randomHash then
						carHash = randomHash
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
		local allVehModels = GetAllVehicleModels()
		while not isKnownUnknowns do
			local randomIndex = math.random(#allVehModels)
			local randomHash = GetHashKey(allVehModels[randomIndex])
			local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))

			if not Config.BlacklistedVehs[randomHash] and label ~= "NULL" and IsThisModelACar(randomHash) then
				if carTransformed ~= randomHash then
					carHash = randomHash
					break
				end
			end

			Citizen.Wait(0)
		end

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

		while isKnownUnknowns do
			if count == 0 then
				break
			elseif count == 1 then
				carHash = availableModels[count][1]
				break
			else
				local randomIndex = math.random(count)

				if carTransformed ~= availableModels[randomIndex][1] then
					carHash = availableModels[randomIndex][1]
					break
				end
			end
			Citizen.Wait(0)
		end
	end
	return carHash
end

--- Function to get add-on veh hash for random races (beta version 2024/09/23)
function GetRandomAddOnVehModel()
	local carHash = 0
	local addOnVehList = Config.addOnVehList
	while true do
		if #addOnVehList == 0 then
			break
		elseif #addOnVehList == 1 then
			carHash = addOnVehList[1]
			break
		else
			local randomHash = addOnVehList[math.random(#addOnVehList)]

			if carTransformed ~= randomHash then
				carHash = randomHash
				break
			end
		end
		Citizen.Wait(0)
	end
	return carHash
end

--- Function to play transform sound and effect
function PlayVehicleTransformEffectsAndSound(playerPed)
	Citizen.CreateThread(function()
		local ped = playerPed or PlayerPedId()
		local particleDictionary = "scr_as_trans"
		local particleName = "scr_as_trans_smoke"
		local coords = GetEntityCoords(ped)
		local scale = 2.0

		RequestNamedPtfxAsset(particleDictionary)
		while not HasNamedPtfxAssetLoaded(particleDictionary) do
			Citizen.Wait(0)
		end

		UseParticleFxAssetNextCall(particleDictionary)

		PlaySoundFrontend(-1, "Transform_JN_VFX", "DLC_IE_JN_Player_Sounds", 0)

		local effect = StartParticleFxLoopedOnEntity(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
		Citizen.Wait(750)
		StopParticleFxLooped(effect, true)
	end)
end

--- Function to warp the player to the next checkpoint
--- @param pair boolean Whether to warp to a secondary checkpoint or the primary checkpoint
function Warp(pair)
	local ped = PlayerPedId()
	local entity = GetVehiclePedIsIn(ped, false) ~= 0 and GetVehiclePedIsIn(ped, false) or ped
	local coords = actualCheckPoint < #track.checkpoints and track.checkpoints[actualCheckPoint + 1] or track.checkpoints[1]
	local entitySpeed = GetEntitySpeed(entity)
	local entityRotation = GetEntityRotation(entity, 2)

	if coords.hasPair and pair then
		SetEntityCoords(entity, coords.pair_x, coords.pair_y, coords.pair_z)
		SetEntityRotation(entity, entityRotation, 2)
		SetEntityHeading(entity, coords.pair_heading)
	else
		SetEntityCoords(entity, coords.x, coords.y, coords.z)
		SetEntityRotation(entity, entityRotation, 2)
		SetEntityHeading(entity, coords.heading)
	end

	SetVehicleForwardSpeed(entity, entitySpeed)
	SetGameplayCamRelativeHeading(0)
end

--- Function to slow down the player's vehicle
function Slow()
	PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 0)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local speed = GetEntitySpeed(vehicle)
	SetVehicleForwardSpeed(vehicle, speed*10/100)
end

--- Function to display notification in gta style
--- @param msg string The message text to be displayed
--- @param instantDelete boolean Whether to delete the notification immediately instead of waiting for it to disappear
--- @param oldMsgItem number The index of old message item
--- @return number The index of new message item
function DisplayNotification(msg, instantDelete, oldMsgItem)
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

--- Function to reset ped and transform settings
function ResetClient()
	local ped = PlayerPedId()
	togglePositionUI = false
	totalPlayersInRace = 0
	currentUiPage = 1
	transformIsParachute = false
	transformIsSuperJump = false
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	car = {}
	SetPedConfigFlag(ped, 151, true)
	SetPedCanBeKnockedOffVehicle(ped, 0)
	SetEntityInvincible(ped, false)
	SetPedArmour(ped, 100)
	SetEntityHealth(ped, 200)
	SetBlipAlpha(GetMainPlayerBlipId(), 255)
	SetEntityVisible(ped, true)
	FreezeEntityPosition(ped, false)
end

--- Function to enable spectator mode
function EnableSpecMode()
	if status == "racing" then
		finishRace("spectator")
	end
end

--- Function to finish race and set status to "waiting"
--- @param raceStatus string The status of the race
function finishRace(raceStatus)
	status = "waiting"
	SendNUIMessage({
		action = "hideRaceHud"
	})
	local ped = PlayerPedId()
	local _drivers = drivers
	if GetDriversNoNFAndNotFinished(_drivers) >= 2 and raceStatus == "yeah" then
		CameraFinish_Create()
	end
	SetLocalPlayerAsGhost(false)
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
	TriggerServerEvent('custom_races:playerFinish', totalCheckPointsTouched, lastCheckpointPair, actualLapTime, totalRaceTime, raceStatus)
	Citizen.Wait(1000)
	AnimpostfxStop("MP_Celeb_Win")
	SetEntityVisible(ped, false)
	FreezeEntityPosition(ped, true)
	if DoesEntityExist(lastVehicle) then
		local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
		TriggerServerEvent("custom_races:deleteVehicle", vehId)
	end
	if GetVehiclePedIsIn(ped, false) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(ped, false))
	end
	if GetVehiclePedIsIn(ped, true) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(ped, true))
	end
	SetBlipAlpha(GetMainPlayerBlipId(), 0)
end

--- Function to leave race when racing or spectating
function LeaveRace()
	if status == "racing" or status == "spectating" then
		status = "leaving"
		SendNUIMessage({
			action = "hideRaceHud"
		})
		local ped = PlayerPedId()
		CameraFinish_Remove()
		SetLocalPlayerAsGhost(false)
		RemoveRaceLoadedProps()
		SwitchOutPlayer(ped, 0, 1)
		RemoveAllPedWeapons(ped, false)
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		TriggerServerEvent('custom_races:server:leave_race')
		Citizen.Wait(1000)
		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			TriggerServerEvent("custom_races:deleteVehicle", vehId)
		end
		if GetVehiclePedIsIn(ped, false) ~= 0 then
			DeleteEntity(GetVehiclePedIsIn(ped, false))
		end
		if GetVehiclePedIsIn(ped, true) ~= 0 then
			DeleteEntity(GetVehiclePedIsIn(ped, true))
		end
		Citizen.Wait(4000)
		SetEntityCoords(ped, JoinRacePoint.x, JoinRacePoint.y, JoinRacePoint.z + 2)
		SetEntityHeading(ped, JoinRaceHeading)
		SetGameplayCamRelativeHeading(0)
		SwitchInPlayer(ped)
		status = "freemode"
		ResetClient()
		TriggerServerEvent('custom_races:server:SetPlayerRoutingBucket')
		TriggerServerCallback('custom_races:raceList', function(result)
			SendNUIMessage({
				action = "updateRaceList",
				result = result
			})
		end)
		while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
		TriggerEvent('custom_races:unloadrace')
	end
end

--- Function to reset game
function DoRaceOverMessage()
	Citizen.CreateThread(function()
		status = "ending"
		local ped = PlayerPedId()
		CameraFinish_Remove()
		SwitchOutPlayer(ped, 0, 1)
		Citizen.Wait(2500)
		RemoveRaceLoadedProps()
		isOverClouds = true
		local waitTime = 1000 + 2000 * (math.floor((Count(drivers) - 1) / 10) + 1)
		ShowScoreboard()
		Citizen.Wait(waitTime)
		isOverClouds = false
		Citizen.Wait(1000)
		SetEntityCoords(ped, JoinRacePoint.x, JoinRacePoint.y, JoinRacePoint.z + 2)
		SetEntityHeading(ped, JoinRaceHeading)
		SetGameplayCamRelativeHeading(0)
		SwitchInPlayer(ped)
		status = "freemode"
		ResetClient()
		TriggerServerEvent('custom_races:server:SetPlayerRoutingBucket')
		TriggerServerCallback('custom_races:raceList', function(result)
			SendNUIMessage({
				action = "updateRaceList",
				result = result
			})
		end)
		while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
		TriggerEvent('custom_races:unloadrace')
	end)
end

--- Function to display scoreboard
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
			if not v.hasnf then
				table.insert(bestlapTable, {
					playerId = v.playerID,
					bestLap = v.bestLap
				})
			end

			table.insert(racefrontpos, {
				playerId = v.playerID,
				position = GetPlayerPosition(driversInfo, v.playerID),
				name = v.playerName,
				vehicle = (GetLabelText(v.vehNameCurrent) ~= "NULL" and GetLabelText(v.vehNameCurrent)) or (v.vehNameCurrent ~= "" and v.vehNameCurrent) or "On Foot",
				totaltime = v.hasnf and "DNF" or (v.hasFinished and GetTimeAsString(v.totalRaceTime)) or "network error", -- Maybe someone's network latency is too high?
				bestLap = v.hasnf and "DNF" or (v.hasFinished and GetTimeAsString(v.bestLap)) or "network error" -- Maybe someone's network latency is too high?
			})
		end

		table.sort(bestlapTable, function(a, b)
			return a.bestLap < b.bestLap
		end)

		table.sort(racefrontpos, function(a, b)
			return a.position < b.position
		end)

		if #bestlapTable > 0 then
			for i = 1, #racefrontpos do
				if racefrontpos[i].playerId == bestlapTable[1].playerId then
					racefrontpos[i].bestLap = racefrontpos[i].bestLap .. "★"
					break
				end
			end
		end

		while isOverClouds do
			local startIdx = (currentUiPage_result - 1) * 10 + 1
			local endIdx = math.min(startIdx + 10 - 1, totalPlayersInRace_result)

			local racefrontpos_show ={}

			for i = startIdx, endIdx do
				table.insert(racefrontpos_show, racefrontpos[i])
			end

			SendNUIMessage({
				action = "showScoreboard",
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
			action = "hideScoreboard"
		})
	end)
end

--- Function to remove props/dprops when unloading race
function RemoveRaceLoadedProps()
	if LoadedMap and LoadedMap.loadedObjects then
		for i,object in ipairs(LoadedMap.loadedObjects) do
			DeleteObject(object)
		end
	end
end

--- Function to create finish camera
function CameraFinish_Create()
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

--- Function to remove finish camera
function CameraFinish_Remove()
	ClearFocus()
	RenderScriptCams(false, false, 0, true, false)
	DestroyCam(cam, false)
	cam = nil
end

--- Function to reset game
function EndCam()
	ClearFocus()
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(cam, false)
	inMenu = false
	cam = nil
end

--- Function to reset game
function EndCam2()
	ClearFocus()
	RenderScriptCams(false, true, 0, true, false)
	DestroyCam(cam, false)
	inMenu = false
	cam = nil
end

--- Function to give weapons when in gta mode
function GiveWeapons()
	local ped = PlayerPedId()
	for k, v in pairs(Config.Weapons) do
		GiveWeaponToPed(ped, k, v, true, false)
	end
end

--- Function to get players who are not in the "nf" status and are not finished
--- @param _drivers table The table whose elements are to be counted
--- @return number The number of alivedrivers
function GetDriversNoNFAndNotFinished(_drivers)
	local count = 0
	for k, v in pairs(_drivers) do
		if not v.hasnf and not v.hasFinished then
			count = count + 1
		end
	end
	return count
end

--- Function to count the number of elements in a table
--- @param t table The table whose elements are to be counted
--- @return number The number of elements in the table
function Count(t)
	local c = 0
	for _, _ in pairs(t) do
		c = c + 1
	end
	return c
end

--- Function to set the weather and time in the game
function SetweatherAndTime()
	SetWeatherTypeOverTime(weatherAndTime.weather, 15.0)
	ClearOverrideWeather()
	ClearWeatherTypePersist()
	SetWeatherTypePersist(weatherAndTime.weather)
	SetWeatherTypeNow(weatherAndTime.weather)
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

--- Function to set weather and time, remove npc and traffic, and more misc...
function SetCurrentRace()
	-- Set weather and time, remove npc and traffic
	Citizen.CreateThread(function()
		while status ~= "freemode" do
			local ped = PlayerPedId()

			-- Set weather and time after loading a track
			SetweatherAndTime()

			if disableTraffic then
				-- Remove Traffic and NPCs
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

			if IsEntityDead(ped) or IsPlayerDead(PlayerId()) then
				if not isPlayerSpawning then
					isPlayerSpawning = true
					if status == "racing" then
						RestartPosition()
					elseif status == "nf" then
						local firstTrackCheckpointCoords = track.checkpoints[1]
						NetworkResurrectLocalPlayer(firstTrackCheckpointCoords.x, firstTrackCheckpointCoords.y, firstTrackCheckpointCoords.z, 0.0, true, false)
						isPlayerSpawning = false
					else
						isPlayerSpawning = false
					end
				end
			end

			if status ~= "racing" then
				DisableControlAction(0, 75, true) -- F
			end

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
							finishedPlayer[v.playerID] = true
						end
					end
					firstLoad = false
				end

				for k, v in pairs(_drivers) do
					if v.hasFinished and not finishedPlayer[v.playerID] then
						finishedPlayer[v.playerID] = true

						if not v.hasnf then
							local name = v.playerName
							local position = GetPlayerPosition(driversInfo, v.playerID)
							local message = string.format(GetTranslate("racing-info-finished"), name, position)
							DisplayNotification(message, false, nil)
							Citizen.Wait(100)
						end

					elseif not v.hasFinished then
						finishedPlayer[v.playerID] = false
					end
				end
				Citizen.Wait(500)
			else
				Citizen.Wait(1000)
			end
		end
	end)

	-- Fixture remover
	Citizen.CreateThread(function()
		if #track.dhprop > 0 then
			local validHash = {}
			-- Some hash may not exist in downgrade version
			for i = 1, #track.dhprop do
				if IsModelInCdimage(track.dhprop[i]["hash"]) and IsModelValid(track.dhprop[i]["hash"]) then
					table.insert(validHash, track.dhprop[i])
				end
			end
			track.dhprop = validHash
		end

		while status ~= "freemode" do
			if #track.dhprop > 0 and (status == "racing" or status == "spectating") then
				local playerCoords = GetEntityCoords(PlayerPedId())
				for i = 1, #track.dhprop do
					local objectCoords = vector3(track.dhprop[i]["x"], track.dhprop[i]["y"], track.dhprop[i]["z"])
					if #(playerCoords - objectCoords) <= 300.0 then
						local object = GetClosestObjectOfType(track.dhprop[i]["x"], track.dhprop[i]["y"], track.dhprop[i]["z"], track.dhprop[i]["radius"], track.dhprop[i]["hash"], false)
						if object > 0 then
							SetEntityAsMissionEntity(object, true, true)
							DeleteEntity(object)
						end
					end
				end
			elseif #track.dhprop == 0 or status == "leaving" or status == "ending" then
				break
			end
			Citizen.Wait(500)
		end
	end)
end

--- Event handler to load and set up a track
--- @param _data table The data to set ESC pause menu
--- @param _track table The track data
--- @param objects table List of objects to be loaded
--- @param dobjects table List of dynamic objects to be loaded
--- @param _weatherAndTime table The weather and time data
--- @param _laps number The number of laps for the race
RegisterNetEvent("custom_races:loadTrack", function(_data, _track, objects, dobjects, _weatherAndTime, _laps)
	TriggerServerEvent('custom_races:server:SetPlayerRoutingBucket', _track.routingbucket)
	SendNUIMessage({
		action = "updatePauseMenu",
		img = _data.img,
		title = _track.trackName.." - made by [".._track.creatorName.."]",
		dnf = _data.dnf,
		traffic = _data.traffic,
		weather = _data.weather,
		time = _data.time..":00",
		accessible = _data.accessible,
		mode = _data.mode
	})
	local totalObjects = #objects + #dobjects
	raceData = _data
	track = _track
	disableTraffic = (_data.traffic == "off") and true or false
	weatherAndTime = _weatherAndTime
	laps = _laps
	if raceData.vehicle == "default" then
		-- Get last vehicle properties, inspired by YouTube comments
		lastVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		car = lastVehicle ~= 0 and GetVehicleProperties(lastVehicle) or {}
	end
	if track.mode == "no_collision" then
		SetLocalPlayerAsGhost(true)
	end
	status = "loading_track"
	TriggerEvent('custom_races:loadrace')
	SetCurrentRace()
	Citizen.Wait(500)
	BeginTextCommandBusyString("STRING")
	AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "]")
	EndTextCommandBusyString(2)
	RemoveRaceLoadedProps()
	Citizen.Wait(1000)
	LoadedMap = {mapName=track.trackName, loadedObjects={}}
	local iTotal = 0
	local invaildTotal = 0
	for i = 1, #objects do
		if IsModelInCdimage(objects[i]["hash"]) and IsModelValid(objects[i]["hash"]) then
			iTotal = iTotal + 1
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "] ("..math.floor(iTotal*100/totalObjects).."%)")
			EndTextCommandBusyString(2)

			RequestModel(objects[i]["hash"])
			while not HasModelLoaded(objects[i]["hash"]) do
				Citizen.Wait(0)
			end

			local obj = CreateObjectNoOffset(objects[i]["hash"], objects[i]["x"], objects[i]["y"], objects[i]["z"], false, true, false)

			-- Create object of door type
			-- https://docs.fivem.net/natives/?_0x9A294B2138ABB884
			if obj == 0 then
				obj = CreateObjectNoOffset(objects[i]["hash"], objects[i]["x"], objects[i]["y"], objects[i]["z"], false, true, true)
			end

			SetEntityRotation(obj, objects[i]["rot"]["x"], objects[i]["rot"]["y"], objects[i]["rot"]["z"], 2, 0)

			if objects[i]["hash"] == 73742208 or objects[i]["hash"] == -977919647 or objects[i]["hash"] == -1081534242 or objects[i]["hash"] == 1243328051 then
				FreezeEntityPosition(obj, false)
			else
				FreezeEntityPosition(obj, true)
			end

			if speedUpObjects[objects[i]["hash"]] then
				SetObjectStuntPropSpeedup(obj, 100)
				SetObjectStuntPropDuration(obj, 0.5)
			end

			if slowDownObjects[objects[i]["hash"]] then
				SetObjectStuntPropSpeedup(obj, 16)
			end

			if objects[i]["prpclr"] ~= nil then
				SetObjectTextureVariant(obj, objects[i]["prpclr"])
			end

			if objects[i]["dist"] ~= nil then
				if objects[i]["dist"] == 1 then
					SetEntityVisible(obj, false)
					--SetEntityLodDist(obj, 1)
				else
					SetEntityLodDist(obj, objects[i]["dist"] == 0 and 16960 or objects[i]["dist"])
				end
			else
				SetEntityLodDist(obj, 16960)
			end

			SetEntityCollision(obj, objects[i]["collision"], objects[i]["collision"])

			LoadedMap.loadedObjects[iTotal] = obj
		else
			invaildTotal = invaildTotal + 1
			print("model ("..objects[i]["hash"]..") does not exist or is invaild!")
		end
	end

	for i = 1, #dobjects do
		if IsModelInCdimage(dobjects[i]["hash"]) and IsModelValid(dobjects[i]["hash"]) then
			iTotal = iTotal + 1
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "] ("..math.floor(iTotal*100/totalObjects).."%)")
			EndTextCommandBusyString(2)

			RequestModel(dobjects[i]["hash"])
			while not HasModelLoaded(dobjects[i]["hash"]) do
				Citizen.Wait(0)
			end

			local dobj = CreateObjectNoOffset(dobjects[i]["hash"], dobjects[i]["x"], dobjects[i]["y"], dobjects[i]["z"], false, true, false)

			-- Create object of door type
			-- https://docs.fivem.net/natives/?_0x9A294B2138ABB884
			if dobj == 0 then
				dobj = CreateObjectNoOffset(dobjects[i]["hash"], dobjects[i]["x"], dobjects[i]["y"], dobjects[i]["z"], false, true, true)
			end

			SetEntityRotation(dobj, dobjects[i]["rot"]["x"], dobjects[i]["rot"]["y"], dobjects[i]["rot"]["z"], 2, 0)

			if speedUpObjects[dobjects[i]["hash"]] then
				SetObjectStuntPropSpeedup(dobj, 100)
				SetObjectStuntPropDuration(dobj, 0.5)
			end

			if slowDownObjects[dobjects[i]["hash"]] then
				SetObjectStuntPropSpeedup(dobj, 16)
			end

			if dobjects[i]["prpdclr"] ~= nil then
				SetObjectTextureVariant(dobj, dobjects[i]["prpdclr"])
			end

			SetEntityLodDist(dobj, 16960)
			SetEntityCollision(dobj, dobjects[i]["collision"], dobjects[i]["collision"])

			LoadedMap.loadedObjects[iTotal] = dobj
		else
			invaildTotal = invaildTotal + 1
			print("model ("..dobjects[i]["hash"]..") does not exist or is invaild!")
		end
	end

	if invaildTotal > 0 then
		print("Ask the server owner to stream invaild models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end

	Citizen.Wait(2000)
	RemoveLoadingPrompt()
end)

--- Event handler to start a race session
RegisterNetEvent("custom_races:startSession", function()
	local ped = PlayerPedId()
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
	Citizen.Wait(3000)
	SetEntityCoords(ped, track.positions[1].x, track.positions[1].y, track.positions[1].z)
	SetEntityHeading(ped, track.positions[1].heading)
	SwitchInPlayer(ped)
	Citizen.Wait(2000)
	StopScreenEffect("MenuMGIn")
end)

--- Event handler to show race information and prepare the player
--- @param _gridPosition number The grid position of the player
--- @param _car number|table The car data
RegisterNetEvent("custom_races:showRaceInfo", function(_gridPosition, _car)
	local vehNameCurrent = ""
	exports.spawnmanager:setAutoSpawn(false)
	gridPosition = _gridPosition
	if raceData.vehicle ~= "default" or (raceData.vehicle == "default" and lastVehicle == 0) then
		car = _car
	end
	if tonumber(car) then
		vehNameCurrent = GetDisplayNameFromVehicleModel(car) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(car) or "Unknown"
	elseif car then
		vehNameCurrent = car.model and GetDisplayNameFromVehicleModel(car.model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(car.model) or "Unknown"
	end
	TriggerServerEvent("custom_races:updateVehName", vehNameCurrent)
	RemoveLoadingPrompt()
	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "hideLoad"
		})
		SetNuiFocus(false)
		inMenu = false
		lastCheckpointPair = 0
		finishLine = false
		JoinRace()
		Citizen.Wait(1000)
		SendNUIMessage({
			action = "showRaceInfo",
			racename = track.trackName
		})
	end)
end)

--- Event handler to update drivers' information
--- @param _drivers table List of drivers' data
--- @param _gameTimer number The game timer in server
RegisterNetEvent("custom_races:hereIsTheDriversInfo", function(_drivers, _gameTimer)
	if not timeServerSide["syncDrivers"] or timeServerSide["syncDrivers"] < _gameTimer then
		timeServerSide["syncDrivers"] = _gameTimer
		drivers = _drivers
	elseif timeServerSide["syncDrivers"] and timeServerSide["syncDrivers"] == _gameTimer then
		TriggerServerEvent("custom_races:re-sync", "syncDrivers")
	end
end)

--- Event handler for when a player is joining the race midway
--- @param playerName string The name of the player
RegisterNetEvent("custom_races:playerJoinRace", function(playerName)
	SendNUIMessage({
		action = "showNoty",
		message = playerName .. GetTranslate("msg-join-race")
	})
end)

--- Event handler for when a player leaves the race
--- @param playerName string The name of the player who left
--- @param bool boolean Indicates whether the player left the race (true) or the server (false)
RegisterNetEvent("custom_races:playerLeaveRace", function(playerName, bool)
	SendNUIMessage({
		action = "showNoty",
		message = playerName .. (bool and GetTranslate("msg-left-race") or GetTranslate("msg-drop-server"))
	})
end)

--- Event handler to start the race
RegisterNetEvent("custom_races:startRace", function()
	Citizen.CreateThread(function()
		status = "starting"
		local ped = PlayerPedId()

		while IsEntityPositionFrozen(GetVehiclePedIsIn(ped, false)) do
			FreezeEntityPosition(GetVehiclePedIsIn(ped, false), false)
			Citizen.Wait(0)
		end

		if car and GetVehicleClassFromName(car.model) == 16 then
			ControlLandingGear(GetVehiclePedIsIn(ped, false), 1)
		end

		SetVehicleEngineOn(GetVehiclePedIsIn(ped, false), true, true, true)
		StartRace()
	end)
end)

--- Event handler to start the not finish countdown
--- @param roomId number The room ID to be compared
RegisterNetEvent("custom_races:client:StartNFCountdown", function(roomId)
	SendNUIMessage({
		action = "startNFCountdown",
		endtime = Config.NFCountdownTime
	})
	Citizen.Wait(Config.NFCountdownTime)
	if status == "racing" and roomId == roomServerId then
		finishRace("dnf")
	end
end)

--- Event handler to enable spectator mode
--- @param raceStatus string The status of the race
RegisterNetEvent("custom_races:client:EnableSpecMode", function(raceStatus)
	Citizen.Wait(1000)

	if status ~= "waiting" then return end
	status = "spectating"

	local playersToSpectate = {}
	local playerServerID = GetPlayerServerId(PlayerId())
	local actionFromUser = (raceStatus == "spectator") and true or false

	Citizen.CreateThread(function()
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

			playersToSpectate = {}

			local _drivers = drivers
			local driversInfo = UpdateDriversInfo(_drivers)

			for i, driver in pairs(_drivers) do
				if not driver.isSpectating and driver.playerID ~= playerServerID then
					driver.position = GetPlayerPosition(driversInfo, driver.playerID)
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
						if lastspectatePlayerId == v.playerID then
							spectatingPlayerIndex = k
							break
						end
					end
					if not DoesEntityExist(pedToSpectate) then
						lastspectatePlayerId = nil
						pedToSpectate = nil
					end
				end

				if playersToSpectate[spectatingPlayerIndex] == nil then
					spectatingPlayerIndex = 1
				end

				if lastspectatePlayerId ~= playersToSpectate[spectatingPlayerIndex].playerID then
					DoScreenFadeOut(500)
					Citizen.Wait(500)
					CameraFinish_Remove()
					canPlaySound = true
					lastspectatePlayerId = playersToSpectate[spectatingPlayerIndex].playerID
					pedToSpectate = GetPlayerPed(GetPlayerFromServerId(lastspectatePlayerId))
					NetworkSetInSpectatorMode(true, pedToSpectate)
					SetMinimapInSpectatorMode(true, pedToSpectate)
					TriggerServerEvent('custom_races:server:SpectatePlayer', lastspectatePlayerId, actionFromUser)
					actionFromUser = false
					DoScreenFadeIn(500)
				end

				if pedToSpectate and DoesEntityExist(pedToSpectate) then
					local pedInSpectatorMode = PlayerPedId()
					SetEntityCoordsNoOffset(pedInSpectatorMode, GetEntityCoords(pedToSpectate) + vector3(0, 0, 50))
					if not NetworkIsInSpectatorMode() then NetworkSetInSpectatorMode(true, pedToSpectate) end
				end

				local playersPerPage = 10
				local currentPage = math.floor((spectatingPlayerIndex - 1) / playersPerPage) + 1
				local startIdx = (currentPage - 1) * playersPerPage + 1
				local endIdx = math.min(startIdx + playersPerPage - 1, #playersToSpectate)

				local playersToSpectate_show ={}

				for i = startIdx, endIdx do
					table.insert(playersToSpectate_show, playersToSpectate[i])
				end

				SendNUIMessage({
					action = "showSpectate",
					players = playersToSpectate_show,
					playerid = lastspectatePlayerId,
					sound = canPlaySound
				})
			else
				NetworkSetInSpectatorMode(false)
				SetMinimapInSpectatorMode(false)
				spectatingPlayerIndex = 0
				lastspectatePlayerId = nil
				pedToSpectate = nil
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
			action = "hideSpectate"
		})
	end)
	Citizen.CreateThread(function()
		local last_totalCheckpointsTouched_spectate = nil
		local last_actualCheckPoint_spectate = nil
		local copy_lastspectatePlayerId = nil
		while status == "spectating" do
			if #playersToSpectate >= 2 then
				-- Spectator Control Buttons
				if IsControlJustReleased(0, 172) then -- Up Arrow
					spectatingPlayerIndex = spectatingPlayerIndex -1

					if spectatingPlayerIndex < 1 or spectatingPlayerIndex > #playersToSpectate then
						spectatingPlayerIndex = #playersToSpectate
					end

					lastspectatePlayerId = nil
					pedToSpectate = nil
					actionFromUser = true
				end

				if IsControlJustReleased(0, 173) then -- Down Arrow
					spectatingPlayerIndex = spectatingPlayerIndex + 1

					if spectatingPlayerIndex > #playersToSpectate then
						spectatingPlayerIndex = 1
					end

					lastspectatePlayerId = nil
					pedToSpectate = nil
					actionFromUser= true
				end
			end

			if #playersToSpectate > 0 then
				local _drivers = drivers
				if lastspectatePlayerId and _drivers[lastspectatePlayerId] then
					local lastCheckpointPair_spectate = _drivers[lastspectatePlayerId].lastCheckpointPair
					local totalCheckpointsTouched_spectate = _drivers[lastspectatePlayerId].totalCheckpointsTouched
					local actualCheckPoint_spectate = _drivers[lastspectatePlayerId].actualCheckPoint
					local nextCheckpoint_spectate = _drivers[lastspectatePlayerId].actualCheckPoint + 1
					local actualLap_spectate = _drivers[lastspectatePlayerId].actualLap
					local finishLine_spectate = false

					if actualCheckPoint_spectate == #track.checkpoints and actualLap_spectate == track.laps then
						finishLine_spectate = true
					else
						finishLine_spectate = false
					end

					-- Draw the actualBlip_spectate / nextBlip_spectate and play sound in spectator mode
					if last_totalCheckpointsTouched_spectate ~= totalCheckpointsTouched_spectate then
						last_totalCheckpointsTouched_spectate = totalCheckpointsTouched_spectate

						if copy_lastspectatePlayerId == lastspectatePlayerId then
							PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
							if lastCheckpointPair_spectate == 0 and ((track.checkpoints[last_actualCheckPoint_spectate].transform ~= -1) or (track.checkpoints[last_actualCheckPoint_spectate].warp)) then
								PlayVehicleTransformEffectsAndSound(pedToSpectate)
							elseif lastCheckpointPair_spectate == 1 and track.checkpoints[last_actualCheckPoint_spectate].hasPair and ((track.checkpoints[last_actualCheckPoint_spectate].pair_transform ~= -1) or (track.checkpoints[last_actualCheckPoint_spectate].pair_warp)) then
								PlayVehicleTransformEffectsAndSound(pedToSpectate)
							end
						end

						DeleteCheckpoint(actualCheckPoint_spectate_draw)
						DeleteCheckpoint(actualCheckPoint_spectate_pair_draw)
						actualCheckPoint_spectate_draw = nil
						actualCheckPoint_spectate_pair_draw = nil
						RemoveBlip(actualBlip_spectate)
						RemoveBlip(nextBlip_spectate)
						RemoveBlip(actualBlip_spectate_pair)
						RemoveBlip(nextBlip_spectate_pair)

						if actualCheckPoint_spectate == #track.checkpoints then
							if actualLap_spectate < track.laps then
								actualBlip_spectate = CreateBlip(actualCheckPoint_spectate, 58, false, false, true)
								if track.checkpoints[actualCheckPoint_spectate].hasPair then
									actualBlip_spectate_pair = CreateBlip(actualCheckPoint_spectate, 58, false, true, true)
								end
							else
								actualBlip_spectate = CreateBlip(actualCheckPoint_spectate, 38, false, false, true)
								if track.checkpoints[actualCheckPoint_spectate].hasPair then
									actualBlip_spectate_pair = CreateBlip(actualCheckPoint_spectate, 38, false, true, true)
								end
							end
						else
							actualBlip_spectate = CreateBlip(actualCheckPoint_spectate, 1, false, false)
							if track.checkpoints[actualCheckPoint_spectate].hasPair then
								actualBlip_spectate_pair = CreateBlip(actualCheckPoint_spectate, 1, false, true)
							end
						end

						if nextCheckpoint_spectate > #track.checkpoints then
							if actualLap_spectate < track.laps then
								nextBlip_spectate = CreateBlip(1, 1, true, false)
								if track.checkpoints[1].hasPair then
									nextBlip_spectate_pair = CreateBlip(1, 1, true, true)
								end
							else
								RemoveBlip(nextBlip_spectate)
								RemoveBlip(nextBlip_spectate_pair)
							end
						elseif nextCheckpoint_spectate == #track.checkpoints then
							if actualLap_spectate < track.laps then
								nextBlip_spectate = CreateBlip(nextCheckpoint_spectate, 58, true, false, true)
								if track.checkpoints[nextCheckpoint_spectate].hasPair then
									nextBlip_spectate_pair = CreateBlip(nextCheckpoint_spectate, 58, true, true, true)
								end
							else
								nextBlip_spectate = CreateBlip(nextCheckpoint_spectate, 38, true, false, true)
								if track.checkpoints[nextCheckpoint_spectate].hasPair then
									nextBlip_spectate_pair = CreateBlip(nextCheckpoint_spectate, 38, true, true, true)
								end
							end
						else
							nextBlip_spectate = CreateBlip(nextCheckpoint_spectate, 1, true, false)
							if track.checkpoints[nextCheckpoint_spectate].hasPair then
								nextBlip_spectate_pair = CreateBlip(nextCheckpoint_spectate, 1, true, true)
							end
						end
					end
					last_actualCheckPoint_spectate = actualCheckPoint_spectate
					copy_lastspectatePlayerId = lastspectatePlayerId

					-- Draw the primary checkpoint_spectate and secondary checkpoint_spectate in spectator mode
					DrawCheckpointMarker(finishLine_spectate, actualCheckPoint_spectate, false)
					DrawCheckpointMarker(finishLine_spectate, actualCheckPoint_spectate, true)
				end
			else
				DeleteCheckpoint(actualCheckPoint_spectate_draw)
				DeleteCheckpoint(actualCheckPoint_spectate_pair_draw)
				actualCheckPoint_spectate_draw = nil
				actualCheckPoint_spectate_pair_draw = nil
				RemoveBlip(actualBlip_spectate)
				RemoveBlip(nextBlip_spectate)
				RemoveBlip(actualBlip_spectate_pair)
				RemoveBlip(nextBlip_spectate_pair)
				break
			end
			Citizen.Wait(0)
		end
		DeleteCheckpoint(actualCheckPoint_spectate_draw)
		DeleteCheckpoint(actualCheckPoint_spectate_pair_draw)
		actualCheckPoint_spectate_draw = nil
		actualCheckPoint_spectate_pair_draw = nil
		RemoveBlip(actualBlip_spectate)
		RemoveBlip(nextBlip_spectate)
		RemoveBlip(actualBlip_spectate_pair)
		RemoveBlip(nextBlip_spectate_pair)
	end)
end)

--- Event handler for when a player is spectating me
--- @param playerName string The username of the player who is spectating
RegisterNetEvent('custom_races:client:WhoSpectateMe', function(playerName)
	SendNUIMessage({
		action = "showNoty",
		message = playerName .. GetTranslate("msg-spectate")
	})
end)

--- Event handler to show the final results of the race
RegisterNetEvent("custom_races:showFinalResult", function()
	DoRaceOverMessage()
end)

--- Main thread
Citizen.CreateThread(function()
	while not PlayerPedId() or not DoesEntityExist(PlayerPedId()) do
		Citizen.Wait(1000)
	end

	SetLocalPlayerAsGhost(false)
	status = "freemode"

	-- Disable helmet
	local ped = PlayerPedId()
	SetPedConfigFlag(ped, 35, false)

	while true do
		local global_var = {
			IsNuiFocused = IsNuiFocused(),
			IsPauseMenuActive = IsPauseMenuActive(),
			IsPlayerSwitchInProgress = IsPlayerSwitchInProgress()
		}
		if IsControlJustReleased(0, Config.OpenMenuKey) and not global_var.IsNuiFocused and not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress then
			if status == "freemode" then
				if not inMenu and not isLocked then
					isLocked = true
					TriggerServerCallback("custom_races:server:permission", function(bool, newData)
						local _needRefresh = false
						if newData then
							races_data_front = newData
							dataOutdated = false
							_needRefresh = true
						end
						if bool then
							if not isCreatorEnable then
								SendNUIMessage({
									action = "openMenu",
									races_data_front = races_data_front,
									inrace = false,
									needRefresh = _needRefresh
								})
								SetNuiFocus(true, true)
								inMenu = true
							end
						else
							if not cooldownTime or (GetGameTimer() - cooldownTime > 1000 * 60 * 10) then
								cooldownTime = GetGameTimer()
								if not isCreatorEnable then
									SendNUIMessage({
										action = "openMenu",
										races_data_front = races_data_front,
										inrace = false,
										needRefresh = _needRefresh
									})
									SetNuiFocus(true, true)
									inMenu = true
								end
							else
								SendNUIMessage({
									action = "showNoty",
									message = string.format(GetTranslate("msg-open-menu"), (1000 * 60 * 10 - ((GetGameTimer() - cooldownTime))) / 1000)
								})
							end
						end
						isLocked = false
					end, dataOutdated)
				end
			else
				SendNUIMessage({
					action = "showNoty",
					message = GetTranslate("msg-in-racing")
				})
			end
		end

		if IsControlJustReleased(0, Config.CheckInvitationKey.key) and not global_var.IsNuiFocused and not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress and not isCreatorEnable and not isLocked then
			if status == "freemode" then
				SendNUIMessage({
					action = "openNotifications"
				})
				SetNuiFocus(true, true)
			else
				SendNUIMessage({
					action = "showNoty",
					message = GetTranslate("msg-disable-invite")
				})
			end
		end

		if IsControlJustReleased(0, Config.togglePositionUiKey) and not global_var.IsNuiFocused and not global_var.IsPauseMenuActive and not global_var.IsPlayerSwitchInProgress then
			if status == "racing" then
				if togglePositionUI and ((currentUiPage * 20) < totalPlayersInRace) then
					currentUiPage = currentUiPage + 1
				else
					togglePositionUI = not togglePositionUI
					currentUiPage = 1
				end
			end
		end

		if global_var.IsNuiFocused then
			togglePositionUI = false
			DisableControlAction(0, 199, true)
			DisableControlAction(0, 200, true)
		end

		if global_var.IsPauseMenuActive then
			togglePositionUI = false
		end

		Citizen.Wait(0)
	end
end)

--- Teleport to the previous checkpoint
tpp = function()
	if status == "racing" then
		local bool = TeleportToPreviousCheckpoint()
		if bool then
			SendNUIMessage({
				action = "showNoty",
				message = GetTranslate("msg-tpp")
			})
			SetGameplayCamRelativeHeading(0)

			Citizen.Wait(0)
			local tpIndex = status == "racing" and (actualCheckPoint - 1) or actualCheckPoint
			TriggerServerEvent('custom_races:TpToPreviousCheckpoint', track.trackName, tpIndex)
		end
	end
end

--- Teleport to the next checkpoint
tpn = function()
	if status == "racing" then
		local ped = PlayerPedId()
		if lastCheckpointPair == 1 and track.checkpoints[actualCheckPoint].hasPair then
			if IsPedInAnyVehicle(ped) then
				SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint].pair_heading)
			else
				SetEntityCoords(ped, track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(ped, track.checkpoints[actualCheckPoint].pair_heading)
			end
		else
			if IsPedInAnyVehicle(ped) then
				SetEntityCoords(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(GetVehiclePedIsIn(ped, false), track.checkpoints[actualCheckPoint].heading)
			else
				SetEntityCoords(ped, track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(ped, track.checkpoints[actualCheckPoint].heading)
			end
		end

		SendNUIMessage({
			action = "showNoty",
			message = GetTranslate("msg-tpn")
		})
		SetGameplayCamRelativeHeading(0)

		Citizen.Wait(0)
		local tpIndex = status == "racing" and (actualCheckPoint - 1) or actualCheckPoint
		TriggerServerEvent('custom_races:TpToNextCheckpoint', track.trackName, tpIndex)
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