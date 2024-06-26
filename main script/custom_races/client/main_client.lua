IdRace = nil

Config.Framework = "esx"
if "esx" == Config.Framework then
	ESX = exports.es_extended.getSharedObject()
end

StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
StatSetInt(`MP0_STEALTH_ABILITY`, 100, true)
StatSetInt(`MP0_FLYING_ABILITY`, 100, true)
StatSetInt(`MP0_WHEELIE_ABILITY`, 100, true)
StatSetInt(`MP0_LUNG_CAPACITY`, 100, true)
StatSetInt(`MP0_STRENGTH`, 100, true)
StatSetInt(`MP0_STAMINA`, 100, true)

JoinRacePoint = vector3(1036.58, 2215.49, 24.32) -- Record the last location
JoinRaceHeading = 0 -- Record the last heading
local r = 255
local g = 255
local b = 255
local lastVehicle = nil
local canOpenMenu = true
local playerscoords = {}
local weatherAndHour = {}
local lastPlayerPosToRemoveObj = {}
track = {}
local laps = 0
local weapons = {}
local car = {}
local carTransformed = ""
local transformIsParachute = false
local canFoot = true
local hasResetKnockLevel = false
local serverStatus = ""
local enablePickUps = false
local pickUpsRace = {}
local hasFirstSpawn = false
local canJoinRaces = false
local isInASession = false
local status = "loading" -- loading / freemode / waiting / nf / starting / racing / leaving
local canSpectate = false
local isSpecting = false
local playersToSpectate = {}
local spectingPlayerIndex = 0
local totalCheckPointsTouched = 0
local actualCheckPoint = 0
local nextCheckpoint = 0
local lastCheckpointPair = 0 -- 0 = primary / 1 = secondary
local finishLine = false
local actualLap = 0
local startLapTime = 0
local actualLapTime = 0
local lastLapTime = 0
local totalTimeStart = 0
local totalTime = 0
local nextBlip = nil
local actualBlip = nil
local nextBlip_pair = nil
local actualBlip_pair = nil
local actualPosition = 0
local gridPosition = 0
local isActuallyRestartingPosition = false
local isRestartingPosition = false
local hasRestartedPosition = false
local restartingPositionTimer = 0
local restartingPositionTimerStart = 0
local sessionPB = 9999999
local deltaTempCheckpoints = {}
local isPlayerSpawning = false
local cam = nil
local isOverClouds = false
local fakepos = false
local drivers = {}
local racePositions = {}
local gamertags = {}
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

RegisterNetEvent("custom_races:LoadDone")
RegisterNetEvent("custom_races:startSession")
RegisterNetEvent("custom_races:forceJoin")
RegisterNetEvent("custom_races:hereIsTheSessionData")
RegisterNetEvent("custom_races:hereIsTheDriversAndPositions")
RegisterNetEvent("custom_races:hereIsTheServerStatus")
RegisterNetEvent("custom_races:startCountdown")
RegisterNetEvent("custom_races:showFinalResult")
RegisterNetEvent("custom_races:giveMeYourCar")

function CreateBlip(x, y, z, id, isSecundary)
	local blip = AddBlipForCoord(x, y, z)
	local scale = 0.9
	local alpha = 255

	if isSecundary then
		scale = 0.65
		alpha = 130
	end

	SetBlipSprite(blip, id)
	SetBlipColour(blip, 5)
	SetBlipDisplay(blip, 6)
	SetBlipScale(blip, 0.9)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Checkpoint")
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, scale)
	SetBlipAlpha(blip, alpha)

	return blip
end

function CreateMarker(marerkType, x, y, z, rx, ry, rz, w, l, h, r, g, b, a)
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
		false,
		2,
		nil,
		nil,
		false
	)
end

function Warp(pair)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local nextCheckpoint = track.checkpoints[actualCheckPoint+1]
	local oldSpeedForward = GetEntitySpeedVector(vehicle, true).y

	if not pair then
		SetEntityCoords(vehicle, nextCheckpoint.x, nextCheckpoint.y, nextCheckpoint.z)
		SetEntityHeading(vehicle, nextCheckpoint.heading)
	else
		SetEntityCoords(vehicle, nextCheckpoint.pair_x, nextCheckpoint.pair_y, nextCheckpoint.pair_z)
		SetEntityHeading(vehicle, nextCheckpoint.pair_heading)
	end
	SetVehicleForwardSpeed(vehicle, oldSpeedForward)
end

function Slow()
	PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", 0)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local speed = GetEntitySpeed(vehicle)
	SetVehicleForwardSpeed(vehicle, speed*10/100)
end

function SetCar(_car, positionX, positionY, positionZ, heading, engine)
	local carHash = carTransformed ~= "" and carTransformed or (type(_car) == "number" and _car or _car.model)

	if transformIsParachute then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
		GiveWeaponToPed(GetPlayerPed(-1), "GADGET_PARACHUTE", 1, false, false)
		SetEntityCoords(PlayerPedId(), positionX, positionY, positionZ, heading)
		return
	end

	RequestModel(carHash)

	while not HasModelLoaded(carHash) do
		Wait(500)
	end

	local playerPed = PlayerPedId()
	local x, y, z, newHeading = positionX, positionY, positionZ + 10, heading
	local spawnedVehicle = CreateVehicle(carHash, x, y, z, newHeading, true, false) -- Spawn vehicle at the top of the checkpoint

	-- Spawn vehicle at the top of the checkpoint
	SetEntityCoordsNoOffset(spawnedVehicle, x, y, z)
	SetEntityHeading(spawnedVehicle, newHeading)
	SetEntityCollision(spawnedVehicle, false, false) -- Vehicle collision OFF
	SetVehicleDoorsLocked(spawnedVehicle, 0)
	SetVehicleFuelLevel(spawnedVehicle, 100.0)
	SetVehRadioStation(spawnedVehicle, 'OFF')
	SetModelAsNoLongerNeeded(carHash)

	if type(_car) == "number" then
		car = ESX.Game.GetVehicleProperties(spawnedVehicle)
	else
		ESX.Game.SetVehicleProperties(spawnedVehicle, _car)
		vehicle = _car
		car = _car
	end
	SetVehicleExtraColours(spawnedVehicle, 0, 0) -- Set the vehicle's extra color, 0 is black
	SetVehicleCustomPrimaryColour(spawnedVehicle, r, g, b) -- Set the RGB color of the vehicle, the default is white

	if track.mode == "no_collision" then
		SetLocalPlayerAsGhost(true)
		-- Wait for 1 frame
		Citizen.Wait(0) -- Do not delete it, otherwise there will be a 1 frame collision in non-collision mode
	end

	-- Delete vehicle after spawn vehicle
	if DoesEntityExist(lastVehicle) then
		local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
		TriggerServerEvent("custom_races:deleteVehicle", vehId)
	end
	if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
	end
	if GetVehiclePedIsIn(PlayerPedId(), true) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), true))
	end

	-- send ped into spawnedVehicle
	SetPedIntoVehicle(playerPed, spawnedVehicle, -1)
	if track.mode ~= "gta" then
		SetVehicleDoorsLocked(spawnedVehicle, 4)
	end

	-- Teleport the vehicle back to the checkpoint location
	SetEntityCoords(spawnedVehicle, positionX, positionY, positionZ)
	SetEntityHeading(spawnedVehicle, heading)
	SetEntityCollision(spawnedVehicle, true, true) -- Vehicle collision ON

	SetVehicleEngineOn(spawnedVehicle, engine, true, false)

	-- Helicopter blade speed
	if IsThisModelAPlane(carHash) or IsThisModelAHeli(carHash) then
		ControlLandingGear(spawnedVehicle, 3)
		SetHeliBladesSpeed(spawnedVehicle, 1.0)
		SetHeliBladesFullSpeed(spawnedVehicle)
	end

	if carHash == GetHashKey("avenger") or carHash == GetHashKey("hydra") then
		SetVehicleFlightNozzlePositionImmediate(spawnedVehicle, 0.0)
	end

	if GetVehicleClassFromName(carHash) == 16 then
		SetVehicleForwardSpeed(spawnedVehicle, 30.0)
		Citizen.Wait(100)
		ControlLandingGear(spawnedVehicle, 1)
	end

	SetGameplayCamRelativeHeading(0)

	local vehNetId = NetworkGetNetworkIdFromEntity(spawnedVehicle)
	TriggerServerEvent('custom_races:spawnvehicle', vehNetId)
	lastVehicle = spawnedVehicle
end

function SetCarTransformed(transformIndex)
	local carHash = track.transformVehicles[transformIndex+1]

	local oldVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local oldVehicleVelocity = oldVehicle ~= nil and GetEntityVelocity(oldVehicle) or GetEntityVelocity(PlayerPedId()) -- Old vehicle speed

	if carHash == 0 then -- If the value is 0, it means that the vehicle to be transformed is the vehicle driven by the player at the start of the game
		carHash = car.model
		carTransformed = ""
	elseif carHash == -422877666 then -- parachute
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
		GiveWeaponToPed(GetPlayerPed(-1), "GADGET_PARACHUTE", 1, false, false)
		transformIsParachute = true
		return
	end

	carTransformed = carHash
	transformIsParachute = false
	RequestModel(carHash)

	while not HasModelLoaded(carHash) do
		Wait(0)
	end

	DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))

	local playerPed = PlayerPedId()
	local pos = GetEntityCoords(playerPed)
	local spawnedVehicle = CreateVehicle(carHash, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)

	SetVehicleFuelLevel(spawnedVehicle, 100.0)
	SetVehicleDoorsLocked(spawnedVehicle, 0)
	SetPedIntoVehicle(playerPed, spawnedVehicle, -1)
	SetEntityHeading(spawnedVehicle, track.checkpoints[actualCheckPoint].heading)
	SetModelAsNoLongerNeeded(carHash)

	SetVehRadioStation(spawnedVehicle, 'OFF')
	SetEntityHeading(spawnedVehicle, GetEntityHeading(spawnedVehicle))
	SetVehicleEngineOn(spawnedVehicle, true, true, false)
	ESX.Game.SetVehicleProperties(spawnedVehicle, car)
	SetVehicleExtraColours(spawnedVehicle, 0, 0)
	SetVehicleCustomPrimaryColour(spawnedVehicle, r, g, b)

	SetHeliBladesFullSpeed(spawnedVehicle)

	if IsThisModelAPlane(carHash) or IsThisModelAHeli(carHash) then
		ControlLandingGear(spawnedVehicle, 3)
		SetHeliBladesSpeed(spawnedVehicle, 1.0)
		SetHeliBladesFullSpeed(spawnedVehicle)
	end

	if carHash == GetHashKey("avenger") or carHash == GetHashKey("hydra") then
		SetVehicleFlightNozzlePositionImmediate(spawnedVehicle, 0.0)
	end

	if GetVehicleClassFromName(carHash) == 16 then
		SetVehicleForwardSpeed(spawnedVehicle, 30.0)
		Citizen.Wait(100)
		ControlLandingGear(spawnedVehicle, 1)
	end

	if track.mode ~= "gta" then
		SetVehicleDoorsLocked(spawnedVehicle, 4)
	end
	lastVehicle = spawnedVehicle

	Citizen.Wait(1)
	SetEntityVelocity(spawnedVehicle, oldVehicleVelocity) -- Inherit the speed of the old vehicle
end

function SetWeatherAndHour()
	SetWeatherTypeOverTime(weatherAndHour.weather, 15.0)
	ClearOverrideWeather()
	ClearWeatherTypePersist()
	SetWeatherTypePersist(weatherAndHour.weather)
	SetWeatherTypeNow(weatherAndHour.weather)
	SetWeatherTypeNowPersist(weatherAndHour.weather)
	if weatherAndHour.weather == 'XMAS' then
		SetForceVehicleTrails(true)
		SetForcePedFootstepsTracks(true)
	else
		SetForceVehicleTrails(false)
		SetForcePedFootstepsTracks(false)
	end
	if weatherAndHour.weather == 'RAIN' then
		SetRainLevel(0.3)
	elseif weatherAndHour.weather == 'THUNDER' then
		SetRainLevel(0.5)
	else
		SetRainLevel(0.0)
	end

	NetworkOverrideClockTime(weatherAndHour.hour, weatherAndHour.minute, weatherAndHour.second)
end

function EnableSpecMode()
	isSpecting = true
	SetEntityVisible(PlayerPedId(), false)
	FreezeEntityPosition(PlayerPedId(), true)
	NetworkSetInSpectatorMode(true, PlayerPedId())
	TriggerServerEvent("custom_races:updateMySpectateStatus", true)
end

function DisableSpecMode()
	SetEntityVisible(PlayerPedId(), true)
	FreezeEntityPosition(PlayerPedId(), false)
	isSpecting = false
	TriggerServerEvent("custom_races:updateMySpectateStatus", false)
	NetworkSetInSpectatorMode(false)
end

function DrawCheckpointMarker(finishLine, pair)
	local x = nil
	local y = nil
	local z = nil
	local esi = 0.0
	local ese = 0.0
	local updateZ = 0.0

	if pair and track.checkpoints[actualCheckPoint].pair_x ~= 0.0 and track.checkpoints[actualCheckPoint].pair_x ~= nil and track.checkpoints[actualCheckPoint].pair_y ~= 0.0 and track.checkpoints[actualCheckPoint].pair_y ~= nil and track.checkpoints[actualCheckPoint].pair_z ~= 0.0 and track.checkpoints[actualCheckPoint].pair_z ~= nil then
		x = track.checkpoints[actualCheckPoint].pair_x
		y = track.checkpoints[actualCheckPoint].pair_y
		z = track.checkpoints[actualCheckPoint].pair_z
		heading = track.checkpoints[actualCheckPoint].pair_heading
		isRound = track.checkpoints[actualCheckPoint].pair_isRound
		isLarge = track.checkpoints[actualCheckPoint].pair_isLarge
		transform = track.checkpoints[actualCheckPoint].pair_transform
		warp = track.checkpoints[actualCheckPoint].pair_warp
		planerot = track.checkpoints[actualCheckPoint].pair_planerot
		d = track.checkpoints[actualCheckPoint].pair_d
	else
		x = track.checkpoints[actualCheckPoint].x
		y = track.checkpoints[actualCheckPoint].y
		z = track.checkpoints[actualCheckPoint].z
		heading = track.checkpoints[actualCheckPoint].heading
		isRound = track.checkpoints[actualCheckPoint].isRound
		isLarge = track.checkpoints[actualCheckPoint].isLarge
		transform = track.checkpoints[actualCheckPoint].transform
		warp = track.checkpoints[actualCheckPoint].warp
		planerot = track.checkpoints[actualCheckPoint].planerot
		d = track.checkpoints[actualCheckPoint].d
	end

	if isLarge then
		esi = d/3
		ese = d
		updateZ = 0.0
	else
		updateZ = 8.8
	end

	if finishLine then
		CreateMarker(4, x, y, z + 2, 0.0, 0.0, heading, 6.0, 6.0, 6.0, 62, 182, 245, 125)
		CreateMarker(1, x, y, z, 0.0, 0.0, 0.0, 11.0, 11.0, 6.0, 255, 255, 100, 10)
	else
		if transform ~= -1 then
			local vehicleHash = track.transformVehicles[transform+1]
			local vehicleClass = GetVehicleClassFromName(vehicleHash)
			local marker = 32

			-- https://docs.fivem.net/docs/game-references/markers/
			if vehicleHash == -422877666 then
				marker = 40
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

			CreateMarker(marker, x, y, z + updateZ, 0.0, 0.0, heading, 12.0 + esi, 12.0 + esi, 12.0 + esi, 140, 140, 255, 150)
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, 20.0 + ese, 20.0 + ese, 20.0 + ese, 255, 80, 80, 150)
		elseif planerot then
			local r, g, b = 0, 140, 180
			local rot = GetEntityRotation(GetVehiclePedIsIn(PlayerPedId(), false))

			if planerot == "up" then
				if rot.x > 45 or rot.x < -45 or rot.y > 45 or rot.y < -45 then
					r, g, b = 255, 80, 80
				end
				CreateMarker(7, x, y, z + updateZ, 0.0, 0.0, 180 + heading, 12.0 + esi, 12.0 + esi, 12.0 + esi, r, g, b, 150)
			elseif planerot == "left" then
				if rot.y > -40 then
					r, g, b = 255, 80, 80
				end
				CreateMarker(7, x, y, z + updateZ, heading, -90.0, 180.0, 12.0 + esi, 12.0 + esi, 12.0 + esi, r, g, b, 150)
			elseif planerot == "right" then
				if rot.y < 40 then
					r, g, b = 255, 80, 80
				end
				CreateMarker(7, x, y, z + updateZ, heading - 180, 270.0, 0.0, 12.0 + esi, 12.0 + esi, 12.0 + esi, r, g, b, 150)
			elseif planerot == "down" then
				if (rot.x < 135 and rot.x > -135) or rot.y > 45 or rot.y < -45 then
					r, g, b = 255, 80, 80
				end
				CreateMarker(7, x, y, z + updateZ, 180.0, 0.0, -heading, 12.0 + esi, 12.0 + esi, 12.0 + esi, r, g, b, 150)
			end
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, 20.0 + ese, 20.0 + ese, 20.0 + ese, 255, 255, 100, 150)
		elseif warp then
			CreateMarker(42, x, y, z + updateZ, 0.0, 0.0, heading, 12.0 + esi, 12.0 + esi, 12.0 + esi, 0, 140, 180, 150)
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, 20.0 + ese, 20.0 + ese, 20.0 + ese, 255, 255, 100, 150)
		elseif isRound then
			CreateMarker(21, x, y, z + updateZ, 270.0 + heading, 270.0, 0.0, 6.0 + esi, 6.0 + esi, 6.0 + esi, 0, 140, 180, 150)
			CreateMarker(6, x, y, z + updateZ, heading, 270.0, 0.0, 20.0 + ese, 20.0 + ese, 20.0 + ese, 255, 255, 100, 150)
		else
			CreateMarker(22, x, y, z + 2, 270.0 + heading, 270.0, 0.0, 6.0, 6.0, 6.0, 62, 182, 245, 125)
			CreateMarker(1, x, y, z, 0.0, 0.0, 0.0, 11.0, 11.0, 6.0, 255, 255, 100, 10)
		end
	end
end

local cacheddata = {} -- UI
local racePositionsNubmer = nil
function DrawBottomHUD()
	-- Current lap number
	if not cacheddata.actualLap or cacheddata.actualLap ~= actualLap then
		SendNUIMessage({
			laps = actualLap .. "/" .. laps
		})
		cacheddata.actualLap = actualLap
	end

	-- Current Ranking
	local position = fakepos or GetPlayerPositionFromRacePositions(GetPlayerServerId(PlayerId()))
	if not cacheddata.position or cacheddata.position ~= position or racePositionsNubmer ~= #racePositions then
		SendNUIMessage({
			position = position .. '</span><span style="font-size: 4vh;margin-left: 9px;">/ ' .. #racePositions
		})
		cacheddata.position = position
		racePositionsNubmer = #racePositions
	end

	-- Current Checkpoint
	local checkpoints = actualCheckPoint-1 >= 0 and actualCheckPoint-1 or 0
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

-- set gridPosition
function JoinRace()
	DisplayRadar(true)

	carTransformed = ""
	SetCar(car, track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z, track.positions[gridPosition].heading, false)

	ActivarFuegoAmigo()

	local playerCar = GetVehiclePedIsIn(PlayerPedId(), false)

	totalCheckPointsTouched = 0
	actualCheckPoint = 1
	nextCheckpoint = 2
	actualLap = 1
	actualLapTime = 0
	lastLapTime = 0
	totalTimeStart = 0
	totalTime = 0

	DisableSpecMode()

	TriggerServerEvent("custom_races:updateDriverLapTimeServer")
	TriggerServerEvent("custom_races:updateDriverStartRaceTimeServer")

	while not IsEntityPositionFrozen(GetVehiclePedIsIn(PlayerPedId(), false)) and totalTimeStart == 0 do
		FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)
		Citizen.Wait(100)
	end
	SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), vector3(track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z))

	nextBlip = CreateBlip(track.checkpoints[nextCheckpoint].x, track.checkpoints[nextCheckpoint].y, track.checkpoints[nextCheckpoint].z, 1, true)
	actualBlip = CreateBlip(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 1, false)

	if track.checkpoints[nextCheckpoint].hasPair then
		nextBlip_pair = CreateBlip(track.checkpoints[nextCheckpoint].pair_x, track.checkpoints[nextCheckpoint].pair_y, track.checkpoints[nextCheckpoint].pair_z, 1, true)
	end
	if track.checkpoints[actualCheckPoint].hasPair then
		actualBlip_pair = CreateBlip(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 1, false)
	end
end

-- Countdown ends and join the race
function StartRace()
	cacheddata = {}
	racePositionsNubmer = nil

	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "showRaceHud"
		})

		if track.lastexplode > 0 then
			SendNUIMessage({
				action = "startLastExplode",
				value = track.lastexplode * 1000
			})
		end

		if track.mode == "gta" then
			GiveWeapons()
		end

		status = "racing"

		Citizen.Wait(500)

		totalTimeStart = GetGameTimer()
		startLapTime = totalTimeStart
		local explodetime = totalTimeStart
		lastPlayerPosToRemoveObj = GetEntityCoords(GetPlayerPed(-1))
		RemoveObjects()

		while status == "racing" do
			if track.lastexplode > 0 then
				local secondstoexplode = (GetGameTimer() - explodetime)/1000
				if secondstoexplode >= track.lastexplode then
					explodetime = GetGameTimer()

					if Count(drivers) > 1 then
						local alivedrivers = GetDriversNoNFAndNotFinished(drivers)
						local nonfplayers = GetDriversNoNF(drivers)

						if GetPlayerPositionFromRacePositions(GetPlayerServerId(PlayerId())) == nonfplayers then
							local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
							status = "nf"
							TriggerServerEvent("custom_races:nfplayer")
							AddVehiclePhoneExplosiveDevice(vehicle)
							DetonateVehiclePhoneExplosiveDevice(vehicle)
							finishRace()
							break
						elseif alivedrivers == 2 then
							Citizen.Wait(5000)
							finishRace()
							break
						end
					end
				end
			end

			if track.mode ~= "gta" then
				canFoot = false
				DisableControlAction(0, 75, true) -- F
				local veh = GetVehiclePedIsIn(PlayerPedId(), false)
				if DoesVehicleHaveWeapons(veh) == 1 then
					for i = 1, #vehicle_weapons do
						DisableVehicleWeapon(true, vehicle_weapons[i], veh, PlayerPedId())
					end
				end
				if GetEntityModel(veh) == GetHashKey("bmx") then
					EnableControlAction(0, 68, true) -- Allow flipping the bird while on a bike to taunt.
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
				EnableControlAction(0, 75, true) -- F
			end

			-- The code is moved to the "setcar function" to solve the 1 frame collision
			--[[
			if track.mode == "no_collision" then
				SetLocalPlayerAsGhost(true)
			end
			]]

			actualLapTime = GetGameTimer() - startLapTime

			DrawBottomHUD()
			DrawCheckpointMarker(finishLine, false) -- Draw the first checkpoint.
			DrawCheckpointMarker(finishLine, true) -- Draw the second checkpoint if they are a couple.

			local playerCoords = GetEntityCoords(GetPlayerPed(-1))
			if #(playerCoords - lastPlayerPosToRemoveObj) >= 200 then
				RemoveObjects()
				lastPlayerPosToRemoveObj = playerCoords
			end

			if IsControlPressed(0, 75) or IsDisabledControlPressed(0, 75) then -- Press F to respawn
				StartRestartPosition()
			elseif not transformIsParachute and not IsPedInAnyVehicle(GetPlayerPed(-1)) and not canFoot then-- Automatically respawn after falling off a car
				StartRestartPosition()
			else
				isRestartingPosition = false
				restartingPositionTimer = 0
				hasRestartedPosition = false
				SendNUIMessage({
					action = "hideRestartPosition"
				})
			end

			local checkPointTouched = false

			local _playerCoords = vector3(playerCoords.x, playerCoords.y, playerCoords.z)
			local _checkpointCoords = vector3(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z)
			local _checkpointCoords_pair = vector3(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z)

			if track.checkpoints[actualCheckPoint].isRound or track.checkpoints[actualCheckPoint].warp or track.checkpoints[actualCheckPoint].planerot or track.checkpoints[actualCheckPoint].transform ~= -1 then
				_checkpointCoords = _checkpointCoords + vector3(0, 0, 8.5)
			end

			if track.checkpoints[actualCheckPoint].pair_isRound or track.checkpoints[actualCheckPoint].pair_warp or track.checkpoints[actualCheckPoint].pair_transform ~= -1 then
				_checkpointCoords_pair = _checkpointCoords_pair + vector3(0, 0, 8.5)
			end

			if #(_playerCoords - _checkpointCoords) <= track.checkpoints[actualCheckPoint].d then
				if track.checkpoints[actualCheckPoint].transform ~= -1 then
					PlayVehicleTransformEffectsAndSound()
					SetCarTransformed(track.checkpoints[actualCheckPoint].transform)
				elseif track.checkpoints[actualCheckPoint].warp then
					PlayVehicleTransformEffectsAndSound()
					Warp()
				elseif track.checkpoints[actualCheckPoint].planerot then
					planerot = track.checkpoints[actualCheckPoint].planerot
					local rot = GetEntityRotation(GetVehiclePedIsIn(PlayerPedId(), false))

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

				checkPointTouched = true
				lastCheckpointPair = 0
			elseif track.checkpoints[actualCheckPoint].pair_x ~= 0.0 and track.checkpoints[actualCheckPoint].pair_y ~= 0.0 and track.checkpoints[actualCheckPoint].pair_z ~= 0.0 and #(_playerCoords - _checkpointCoords_pair) <= track.checkpoints[actualCheckPoint].pair_d then
				if track.checkpoints[actualCheckPoint].pair_transform ~= -1 then
					PlayVehicleTransformEffectsAndSound()
					SetCarTransformed(track.checkpoints[actualCheckPoint].pair_transform)
				elseif track.checkpoints[actualCheckPoint].pair_warp then
					PlayVehicleTransformEffectsAndSound()
					Warp(true)
				end

				checkPointTouched = true
				lastCheckpointPair = 1
			end

			if checkPointTouched then
				totalCheckPointsTouched = totalCheckPointsTouched + 1
				TriggerServerEvent("custom_races:checkPointTouched", actualCheckPoint, totalCheckPointsTouched, IdRace)
				if actualCheckPoint == #track.checkpoints then -- Finish a lap
					PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
					TriggerServerEvent("custom_races:checkLapTime", actualLapTime)
					TriggerServerEvent("custom_races:updateDriverLapTimeServer")
					if actualLap < laps then -- If more laps are left after completing a lap
						actualCheckPoint = 1
						nextCheckpoint = 2
						actualLap = actualLap + 1
						lastLapTime = actualLapTime
						startLapTime = GetGameTimer()
						if actualLapTime > 0 then deltaTempCheckpoints[actualCheckPoint] = actualLapTime end
						if actualLapTime < sessionPB then
							sessionPB = actualLapTime
						end
					else -- Finish the race
						finishRace()
						break
					end
				else
					PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0) -- Sound of reaching a checkpoint
					actualCheckPoint = actualCheckPoint + 1
					nextCheckpoint = nextCheckpoint + 1
				end
				RemoveBlip(actualBlip)
				RemoveBlip(nextBlip)
				RemoveBlip(actualBlip_pair)
				RemoveBlip(nextBlip_pair)

				-- Create a blip for the next checkpoint
				if nextCheckpoint > #track.checkpoints then
					if actualLap < laps then
						nextBlip = CreateBlip(track.checkpoints[2].x, track.checkpoints[2].y, track.checkpoints[2].z, 1, 0.6)
						if track.checkpoints[2].hasPair then
							nextBlip_pair = CreateBlip(track.checkpoints[2].pair_x, track.checkpoints[2].pair_y, track.checkpoints[2].pair_z, 1, 0.6)
						end
					else
						RemoveBlip(nextBlip)
						RemoveBlip(nextBlip_pair)
					end
				elseif nextCheckpoint == #track.checkpoints then
					if actualLap < laps then
						nextBlip = CreateBlip(track.checkpoints[nextCheckpoint].x, track.checkpoints[nextCheckpoint].y, track.checkpoints[nextCheckpoint].z, 58, true)
						if track.checkpoints[nextCheckpoint].hasPair then
							nextBlip_pair = CreateBlip(track.checkpoints[nextCheckpoint].pair_x, track.checkpoints[nextCheckpoint].pair_y, track.checkpoints[nextCheckpoint].pair_z, 58, true)
						end
					else
						nextBlip = CreateBlip(track.checkpoints[nextCheckpoint].x, track.checkpoints[nextCheckpoint].y, track.checkpoints[nextCheckpoint].z, 38, true)
						if track.checkpoints[nextCheckpoint].hasPair then
							nextBlip_pair = CreateBlip(track.checkpoints[nextCheckpoint].pair_x, track.checkpoints[nextCheckpoint].pair_y, track.checkpoints[nextCheckpoint].pair_z, 38, true)
						end
					end
				else
					nextBlip = CreateBlip(track.checkpoints[nextCheckpoint].x, track.checkpoints[nextCheckpoint].y, track.checkpoints[nextCheckpoint].z, 1, true)
					if track.checkpoints[nextCheckpoint].hasPair then
						nextBlip_pair = CreateBlip(track.checkpoints[nextCheckpoint].pair_x, track.checkpoints[nextCheckpoint].pair_y, track.checkpoints[nextCheckpoint].pair_z, 1, true)
					end
				end

				-- Create a blip for the actual checkpoint
				if actualCheckPoint == #track.checkpoints then
					if actualLap < laps then
						actualBlip = CreateBlip(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 58, false)
						if track.checkpoints[actualCheckPoint].hasPair then
							actualBlip_pair = CreateBlip(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 58, false)
						end
					else
						actualBlip = CreateBlip(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 38, false)
						if track.checkpoints[actualCheckPoint].hasPair then
							actualBlip_pair = CreateBlip(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 38, false)
						end
						finishLine = true
					end
				else
					actualBlip = CreateBlip(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 1, false)
					if track.checkpoints[actualCheckPoint].hasPair then
						actualBlip_pair = CreateBlip(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 1, false)
					end
				end
				TriggerServerEvent("custom_races:updateDriverInfo", actualCheckPoint, actualLap, startLapTime, lastLapTime)
				checkPointTouched = false
			end
			Citizen.Wait(0)
		end
		RemoveBlip(actualBlip)
		RemoveBlip(nextBlip)
		RemoveBlip(actualBlip_pair)
		RemoveBlip(nextBlip_pair)
	end)

	-- Player rankings
	Citizen.CreateThread(function()
		while status == "racing" and not isSpecting do
			Citizen.Wait(500)
			local pcoords = GetEntityCoords(PlayerPedId())
			local frontpos = {}
			local pointpos = {
				{ i = true, name = GetPlayerName(PlayerId()), dist = #(GetEntityCoords(PlayerPedId()) - vector3(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z)), pos = GetPlayerPositionFromRacePositions(GetPlayerServerId(PlayerId())), completed = actualCheckPoint }
			}

			for k, v in pairs(playerscoords) do
				if drivers[k] then
					table.insert(pointpos, { dist = #(v - vector3(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z)), pos = GetPlayerPositionFromRacePositions(k), id = GetPlayerFromServerId(k), name = drivers[k].playerName, completed = drivers[k].actualCheckPoint })
				end
			end

			local fewpos, mypos = false, 1

			table.sort(pointpos, function(a, b)
				return a.completed > b.completed or (a.completed == b.completed and a.dist < b.dist)
			end)

			for i = 1, #pointpos do
				if not fewpos or pointpos[i].pos < fewpos then
					fewpos = pointpos[i].pos
				end
				if pointpos[i].i then
					mypos = i
				end
			end

			fakepos = fewpos + mypos - 1

			for i = 1, 3 do
				if racePositions[i] and drivers[racePositions[i].playerID] then
					local player = pointpos[i]
					if player then
						frontpos[i] = { name = player.name, position = i, meters = player.id == -1 and "+420m" or ESX.Math.Round(#(GetEntityCoords(GetPlayerPed(player.id)) - pcoords), 2) .. "m" }
						if player.id == PlayerId() then
							frontpos[i].meters = nil
						end
					end
				end
			end

			if pointpos[mypos-1] then
				if frontpos[mypos-1] then
					frontpos[mypos-1] = { name = GetPlayerName(pointpos[mypos-1].id), position = fakepos - 1, meters = ESX.Math.Round(#(GetEntityCoords(GetPlayerPed(pointpos[mypos-1].id)) - pcoords), 2) .. "m" }
				else
					table.insert(frontpos, { name = GetPlayerName(pointpos[mypos-1].id), position = fakepos - 1, meters = ESX.Math.Round(#(GetEntityCoords(GetPlayerPed(pointpos[mypos-1].id)) - pcoords), 2) .. "m" })
				end
			end

			if not frontpos[fakepos] then
				table.insert(frontpos, { name = GetPlayerName(PlayerId()), position = fakepos, i = true })
			else
				frontpos[fakepos] = { name = GetPlayerName(PlayerId()), position = fakepos, i = true }
			end

			if pointpos[mypos+1] then
				if frontpos[mypos+1] then
					frontpos[mypos+1] = { name = GetPlayerName(pointpos[mypos+1].id), position = fakepos + 1, meters = ESX.Math.Round(#(GetEntityCoords(GetPlayerPed(pointpos[mypos+1].id)) - pcoords), 2) .. "m" }
				else
					table.insert(frontpos, { name = GetPlayerName(pointpos[mypos+1].id), position = fakepos + 1, meters = ESX.Math.Round(#(GetEntityCoords(GetPlayerPed(pointpos[mypos+1].id)) - pcoords), 2) .. "m" })
				end
			end

			SendNUIMessage({
				frontpos = frontpos
			})
		end
	end)
end

AddEventHandler("custom_races:startCountdown", function()
	if not canJoinRaces or not isInASession then return end

	Citizen.CreateThread(function()
		status = "starting"

		while IsEntityPositionFrozen(GetVehiclePedIsIn(PlayerPedId(), false)) do
			FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
			Citizen.Wait(10)
		end

		if totalTimeStart == 0 then totalTimeStart = GetGameTimer() end

		if car and GetVehicleClassFromName(car.model) == 16 then
			ControlLandingGear(GetVehiclePedIsIn(PlayerPedId(), false), 1)
		end

		SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)), true, true, true)
		StartRace()
	end)
end)

-- Hold down the F key or fall off the car for 500ms to trigger respawn
function StartRestartPosition()
	local waitTime = 500 -- You can change it however you want
	if status == "racing" then
		if hasRestartedPosition then
			return
		end

		if not isRestartingPosition then
			restartingPositionTimerStart = GetGameTimer()
		end

		if restartingPositionTimer >= waitTime then
			restartingPositionTimer = waitTime
			RestartPosition(0)
			hasRestartedPosition = true
		else
			restartingPositionTimer = GetGameTimer() - restartingPositionTimerStart
		end

		if not isRestartingPosition then
			isRestartingPosition = true
			SendNUIMessage({
				action = "showRestartPosition"
			})
		end
	else
		isRestartingPosition = false
		SendNUIMessage({
			action = "hideRestartPosition"
		})
		restartingPositionTimer = 0
	end
end

function RestartPosition(delay)
	if not isActuallyRestartingPosition then
		isActuallyRestartingPosition = true
		Citizen.CreateThread(function()
			Citizen.Wait(delay)
			--DoScreenFadeOut(500) -- I don't like black screen
			--Citizen.Wait(500)
			if track.checkpoints then
				if track.checkpoints[actualCheckPoint-1] == nil then
					if IsEntityDead(PlayerPedId()) then
						NetworkResurrectLocalPlayer(track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z, track.positions[gridPosition].heading, true, false)
					end
					SetCar(car, track.positions[gridPosition].x, track.positions[gridPosition].y, track.positions[gridPosition].z, track.positions[gridPosition].heading, true)
				else
					local nonTemporalCheckpoint = GetNonTemporalCheckpointToSpawn()

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

					if IsEntityDead(PlayerPedId()) then NetworkResurrectLocalPlayer(x, y, z, heading, true, false) end
					SetCar(car, x, y, z, heading, true)
				end
			else
				if IsEntityDead(PlayerPedId()) then NetworkResurrectLocalPlayer(100.0, 150.0, 100.0, 100.0, true, false) end
			end
			--DoScreenFadeIn(500) -- I don't like black screen
			--Citizen.Wait(500)
			isActuallyRestartingPosition = false
			isPlayerSpawning = false
			if track.mode == "gta" then
				GiveWeapons()
			end
		end)
	end
end

function GetNonTemporalCheckpointToSpawn()
	for i = actualCheckPoint - 1, 1, -1 do
		if not track.checkpoints[i].isTemporal and track.checkpoints[i].planerot == nil then
			return i
		else
			if actualCheckPoint-2 <= 0 and not canSpectate then
				return 1
			end
			totalCheckPointsTouched = totalCheckPointsTouched - 1
			nextCheckpoint = nextCheckpoint - 1
			actualCheckPoint = actualCheckPoint - 1

			RemoveBlip(actualBlip)
			RemoveBlip(nextBlip)
			RemoveBlip(actualBlip_pair)
			RemoveBlip(nextBlip_pair)

			nextBlip = CreateBlip(track.checkpoints[nextCheckpoint].x, track.checkpoints[nextCheckpoint].y, track.checkpoints[nextCheckpoint].z, 1, true)
			actualBlip = CreateBlip(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 1, false)

			if track.checkpoints[nextCheckpoint].hasPair then
				nextBlip_pair = CreateBlip(track.checkpoints[nextCheckpoint].pair_x, track.checkpoints[nextCheckpoint].pair_y, track.checkpoints[nextCheckpoint].pair_z, 1, true)
			end
			if track.checkpoints[actualCheckPoint].hasPair then
				actualBlip_pair = CreateBlip(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 1, false)
			end
			TriggerServerEvent("custom_races:checkPointTouchedRemove", actualCheckPoint, totalCheckPointsTouched, IdRace)
		end
	end
	return 1
end

function GiveWeapons()
	for k, v in pairs(Config.Weapons) do
		GiveWeaponToPed(GetPlayerPed(-1), k, v, true, false)
	end
end

function GetPlayerPositionFromRacePositions(playerID)
	for position, player in ipairs(racePositions) do
		if playerID == player.playerID then
			return position
		end
	end
end

-- Main Thread
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if status ~= "freemode" and status ~= "loading" then
			SetWeatherAndHour()
			-- Remove Traffic and NPCs
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetGarbageTrucks(0)
			SetRandomBoats(0)
			SetPedDensityMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
			local playerCoords = GetEntityCoords(PlayerPedId())
			RemoveVehiclesFromGeneratorsInArea(playerCoords.x - 500.0, playerCoords.y - 500.0, playerCoords.z - 500.0, playerCoords.x + 500.0, playerCoords.y + 500.0, playerCoords.z + 500.0)

			if IsEntityDead(PlayerPedId()) then
				if not isPlayerSpawning then
					isPlayerSpawning = true
					if status == "racing" then
						RestartPosition(0)
					elseif status == "nf" then
						local firstTrackCheckpointCoords = track.checkpoints[1]
						NetworkResurrectLocalPlayer(firstTrackCheckpointCoords.x, firstTrackCheckpointCoords.y, firstTrackCheckpointCoords.z, 0.0, true, false)
						isPlayerSpawning = false
					else
						isPlayerSpawning = false
					end
				end
			end

			DisableControlAction(2, 27, true)

			if status == "waiting" or status == "loading_track" then
				DisableControlAction(2, 24, true)
				DisableControlAction(0, 75, true) -- F
			end

			if isSpecting and canSpectate then
				HideHudComponentThisFrame(2)
				HideHudComponentThisFrame(14)
				HideHudComponentThisFrame(19)
				DisableControlAction(2, 24, true)
				DisableControlAction(2, 26, true)
				DisableControlAction(2, 32, true)
				DisableControlAction(2, 33, true) -- S
				DisableControlAction(2, 34, true) -- A
				DisableControlAction(2, 35, true) -- D
				DisableControlAction(2, 37, true) -- TAB

				playersToSpectate = {}
				playerServerID = GetPlayerServerId(PlayerId())
				for i, driver in pairs(drivers) do
					if not driver.isSpecting and driver.playerID ~= playerServerID then
						driver.position = GetPlayerPositionFromRacePositions(driver.playerID)
						table.insert(playersToSpectate, driver)
					end
				end
				table.sort(playersToSpectate, function(a, b)
					return a.position < b.position
				end)

				-- Spectator Control Buttons
				if IsControlJustReleased(0, 172) and not IsScreenFadedOut() then -- Up Arrow
					spectingPlayerIndex = spectingPlayerIndex -1

					if spectingPlayerIndex < 1 then
						spectingPlayerIndex = #playersToSpectate
					end
				end

				if IsControlJustReleased(0, 173) and not IsScreenFadedOut() then -- Down Arrow
					spectingPlayerIndex = spectingPlayerIndex + 1

					if spectingPlayerIndex > #playersToSpectate then
						spectingPlayerIndex = 1
					end
				end

				if IsControlJustReleased(0, 18) and not IsScreenFadedOut() then -- Enter
					lastspectateindex = 0
				end

				if #playersToSpectate > 0 then
					if not lastcoords then
						lastcoords = GetEntityCoords(PlayerPedId())
					end
					if playersToSpectate[spectingPlayerIndex] == nil then
						spectingPlayerIndex = 1
					end
					if not lastspectateindex or lastspectateindex ~= spectingPlayerIndex then
						DoScreenFadeOut(500)
						Citizen.Wait(500)
						TriggerServerEvent('custom_races:server:SpectatePlayer', playersToSpectate[spectingPlayerIndex].playerID)
						lastspectateindex = spectingPlayerIndex
						if lastspectateplayers then
							SendNUIMessage({
								action = "slectedSpectate",
								playerid = playersToSpectate[spectingPlayerIndex].playerID
							})
						end
					end

					if not lastspectateplayers or #playersToSpectate ~= lastspectateplayers then
						lastspectateplayers = #playersToSpectate
						SendNUIMessage({
							action = "showSpectate",
							players = playersToSpectate
						})
						SendNUIMessage({
							action = "slectedSpectate",
							playerid = playersToSpectate[spectingPlayerIndex].playerID
						})
					end
				else
					NetworkSetInSpectatorMode(false)
					if lastcoords then
						SetEntityCoords(PlayerPedId(), lastcoords)
						lastcoords = nil
						lastspectateindex = nil
						lastspectateplayers = nil
					end
				end
			end

			if status == "racing" or status == "starting" then
				if actualCheckPoint == 0 then
					actualCheckPoint = 1
				end

				-- Set ped to be invincible when mode ~= "gta"
				if track.mode ~= "gta" then
					SetEntityInvincible(PlayerPedId(), true)
					SetPedArmour(PlayerPedId(), 100)
					SetEntityHealth(PlayerPedId(), 200)
					SetPlayerCanDoDriveBy(PlayerId(), true)
				else
					SetEntityInvincible(PlayerPedId(), false)
					SetPlayerCanDoDriveBy(PlayerId(), true)
				end
			else
				SetEntityInvincible(PlayerPedId(), true)
			end

			local players = GetActivePlayers()
			playerscoords = {} -- Record other players and locations

			if status == "racing" or status == "starting" then
				for index, id in pairs(players) do
					if id ~= PlayerId() then
						if not isSpecting then
							playerscoords[GetPlayerServerId(id)] = GetEntityCoords(GetPlayerPed(id))
						end
						-- Create player tag and blip
						--[[if IsEntityVisible(GetPlayerPed(id)) and NetworkIsPlayerActive(id) and not gamertags[id] then
							CreateGamerTagInfo(id, GetPlayerServerId(id), GetPlayerName(id))
						elseif (not IsEntityVisible(GetPlayerPed(id)) or not NetworkIsPlayerActive(id)) and gamertags[id] then
							RemoveGamerTagInfo(GetPlayerServerId(id))
							gamertags[id] = false
						end

						local pedVeh = GetVehiclePedIsIn(GetPlayerPed(id), false)
						local blip = GetBlipFromEntity(pedVeh)

						if not DoesBlipExist(blip) then
							blip = AddBlipForEntity(pedVeh)
							SetBlipSprite(blip, 1)
							ShowHeadingIndicatorOnBlip(blip, true)
						else
							SetBlipRotation(blip, math.ceil(GetEntityHeading(pedVeh))) del blip.
							SetBlipNameToPlayerName(blip, id)
							SetBlipScale(blip, 0.70)
						end
					end
				end
			else
				for k, v in pairs(gamertags) do
					RemoveMpGamerTag(gamertags[k])
					gamertags[k] = nil]]
					end
				end
			end
		end
	end
end)

RegisterNetEvent('custom_races:client:SpectatePlayer', function(serverid, coords)
	coords = coords - vector3(0, 0, 100)
	SetEntityCoords(PlayerPedId(), coords)
	Citizen.Wait(100)
	local ped = GetPlayerPed(GetPlayerFromServerId(serverid))
	RequestCollisionAtCoord(coords)
	while not HasCollisionLoadedAroundEntity(ped) do
		if ped == 0 or ped == GetPlayerPed(-1) then
			ped = GetPlayerPed(GetPlayerFromServerId(serverid))
		elseif #(GetEntityCoords(PlayerPedId()) - coords > 30) then
			coords = GetEntityCoords(ped) - vector3(0, 0, 100)
			SetEntityCoords(PlayerPedId(), coords)
			RequestCollisionAtCoord(coords)
		end
		Wait(100)
	end
	NetworkSetInSpectatorMode(true, ped)
	while not NetworkIsInSpectatorMode() do
		coords = GetEntityCoords(ped) - vector3(0, 0, 100)
		SetEntityCoords(PlayerPedId(), coords)
		NetworkSetInSpectatorMode(true, ped)
		Citizen.Wait(100)
	end
	CameraFinish_Remove()
	DoScreenFadeIn(500)
end)

function DoRaceOverMessage() -- Display Results Screen
	Citizen.CreateThread(function()
		canSpectate = false
		RemoveRaceLoadedProps()
		SwitchOutPlayer(PlayerPedId(), 0, 1)
		enablePickUps = false
		Citizen.Wait(2500)
		isOverClouds = true
		ShowScoreboard()
		Citizen.Wait(5000)
		isOverClouds = false
		CameraFinish_Remove()
		SetLocalPlayerAsGhost(false)
		SetEntityCoords(PlayerPedId(), JoinRacePoint.x, JoinRacePoint.y, JoinRacePoint.z)
		SetEntityHeading(PlayerPedId(), JoinRaceHeading)
		SetGameplayCamRelativeHeading(0)
		status = "freemode"
		TriggerEvent('custom_races:unloadrace')
		SwitchInPlayer(PlayerPedId())
		DisableSpecMode()
		SetEntityVisible(PlayerPedId(), true, true)
		DisplayRadar(true)
		isInASession = false
		Citizen.Wait(2500)
		FreezeEntityPosition(PlayerPedId(), false)
	end)
end

function CameraFinish_Create()
	ClearFocus()

	local playerPed = PlayerPedId()
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
		rZ = rZ - -180
	end

	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pX, pY, pZ, rX, rY, rZ, fov)

	SetCamActive(cam, true)
	RenderScriptCams(true, false, 0, true, false)

	SetCamAffectsAiming(cam, false)
end

function CameraFinish_Remove()
	ClearFocus()
	RenderScriptCams(false, false, 0, true, false)
	DestroyCam(cam, false)
	cam = nil
end

Citizen.CreateThread(function()
	while not ESX.GetPlayerData() or not ESX.GetPlayerData().job do
		Citizen.Wait(1000)
	end

	if not hasFirstSpawn then
		hasFirstSpawn = true
		Citizen.Wait(1000)
		TriggerServerEvent("custom_races:LoadMe")
	end
end)

AddEventHandler('custom_races:LoadDone', function()
	SetLocalPlayerAsGhost(false)
	canJoinRaces = true
	hasFirstSpawn = true
	FreezeEntityPosition(PlayerPedId(), false)
	RemoveLoadingPrompt()
	Citizen.Wait(20)
	status = "freemode"
end)

AddEventHandler("custom_races:startSession", function()
	if not canJoinRaces then return end
	status = "waiting"
	StopScreenEffect("MenuMGIn")
	Citizen.Wait(1500)
	SwitchInPlayer(PlayerPedId())
	Citizen.Wait(2000)
end)

AddEventHandler("custom_races:forceJoin", function(_gridPosition, _car)
	if not canJoinRaces or not isInASession then return end
	exports.spawnmanager:setAutoSpawn(false)
	gridPosition = _gridPosition
	actualPosition = _gridPosition
	car = _car
	isOver = false
	RemoveLoadingPrompt()
	Citizen.CreateThread(function()
		SendNUIMessage({
			action = "hideLoad"
		})
		SetNuiFocus(false)
		TriggerEvent('custom_races:loadrace')
		hasResetKnockLevel = false
		canOpenMenu = false
		JoinRace()
		finishLine = false
		Citizen.Wait(1000)
		SendNUIMessage({
			action = "showRaceInfo",
			racename = track.trackName
		})
	end)
end)

AddEventHandler("custom_races:hereIsTheSessionData", function(_weatherAndHour, _track, _laps, _weapons)
	if not canJoinRaces then return end
	isInASession = true
	weatherAndHour = _weatherAndHour
	track = _track
	laps = _laps
	weapons = _weapons
	SetWeatherAndHour()
	RemoveAllPedWeapons(GetPlayerPed(-1), false)
	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"))
end)

AddEventHandler("custom_races:hereIsTheDriversAndPositions", function(_drivers, _racePositions)
	if not canJoinRaces or not isInASession then return end
	drivers = _drivers
	racePositions = _racePositions
end)

AddEventHandler("custom_races:hereIsTheServerStatus", function (_serverStatus)
	if not canJoinRaces or not isInASession then return end
	serverStatus = _serverStatus
end)

AddEventHandler("custom_races:showFinalResult", function()
	if not canJoinRaces or not isInASession then return end
	DoScreenFadeIn(500)
	DoRaceOverMessage()
end)

AddEventHandler("custom_races:giveMeYourCar", function()
	if not canJoinRaces or not isInASession then return end
	car.name = GetLabelText(GetDisplayNameFromVehicleModel(car.model))
	TriggerServerEvent("custom_races:hereIsMyCar", car)
end)

RegisterNetEvent("custom_races:loadTrack")
AddEventHandler("custom_races:loadTrack", function(_track, objects, dobjects, _gridPosition)
	TriggerServerEvent('custom_races:server:SetPlayerRoutingBucket', _track.routingbucket)
	if not canJoinRaces then return end
	local totalObjects = #objects + #dobjects
	track = _track
	status = "loading_track"
	Citizen.Wait(500)
	BeginTextCommandBusyString("STRING")
	AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "]")
	EndTextCommandBusyString(2)
	RemoveRaceLoadedProps()
	Citizen.Wait(1000)
	LoadedMap = {mapName=track.trackName, loadedObjects={}}
	local iTotal = 0
	for i=1,#objects do
		iTotal = iTotal + 1
		RemoveLoadingPrompt()
		BeginTextCommandBusyString("STRING")
		AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "] ("..math.floor(iTotal*100/totalObjects).."%)")
		EndTextCommandBusyString(2)

		RequestModel(objects[i]["hash"])
		local time = 0
		while not HasModelLoaded(objects[i]["hash"]) do
			Citizen.Wait(0)
		end

		local obj = CreateObjectNoOffset(objects[i]["hash"], objects[i]["x"], objects[i]["y"], objects[i]["z"], false, true, false)
		if objects[i]["hash"] == 73742208 or objects[i]["hash"] == -977919647 or objects[i]["hash"] == -1081534242 or objects[i]["hash"] == 1243328051 then
			FreezeEntityPosition(obj, false)
		else
			FreezeEntityPosition(obj, true)
		end
		SetEntityRotation(obj, objects[i]["rot"]["x"], objects[i]["rot"]["y"], objects[i]["rot"]["z"], 2, 0)

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

		LoadedMap.loadedObjects[iTotal] = obj
		::continue::
	end

	for i=1,#dobjects do
		iTotal = iTotal + 1
		RemoveLoadingPrompt()
		BeginTextCommandBusyString("STRING")
		AddTextComponentSubstringPlayerName("Loading [" .. track.trackName .. "] ("..math.floor(iTotal*100/totalObjects).."%)")
		EndTextCommandBusyString(2)

		RequestModel(dobjects[i]["hash"])
		local time = 0
		while not HasModelLoaded(dobjects[i]["hash"]) do
			Citizen.Wait(0)
		end

		local dobj = CreateObjectNoOffset(dobjects[i]["hash"], dobjects[i]["x"], dobjects[i]["y"], dobjects[i]["z"], false, true, false)
		-- ObjToNet(dobj)
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

		LoadedMap.loadedObjects[iTotal] = dobj
		::continue::
	end

	Citizen.Wait(2000)
	for i,pickUp in ipairs(track.pickUps) do
		enablePickUps = true
		if pickUp.type == 160266735 then
			CreatePickUp_Wrench(pickUp)
		end
	end
	RemoveLoadingPrompt()
end)

function ShowScoreboard()
	Citizen.CreateThread(function()
		local racefrontpos = {}

		for k, v in pairs(racePositions) do
			if drivers[v.playerID] then
				local driver = drivers[v.playerID]

				table.insert(racefrontpos, {
					position = driver.finalPosition,
					name = driver.playerName,
					vehicle = driver.vehicle and driver.vehicle.name or "-",
					totaltime = driver.hasnf and "NF" or GetTimeAsString(driver.totalRaceTime),
					bestLap = driver.hasnf and "NF" or GetTimeAsString(driver.bestLap)
				})
			end
		end

		table.sort(racefrontpos, function(a, b)
			return a.position < b.position
		end)

		SendNUIMessage({
			action = "showScoreboard",
			racefrontpos = racefrontpos
		})
		while isOverClouds do
			Citizen.Wait(0)
		end
		SendNUIMessage({
			action = "hideScoreboard"
		})
		TriggerServerEvent('custom_races:server:SetPlayerRoutingBucket')
	end)
end

function PlayVehicleTransformEffectsAndSound()
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		local particleDictionary = "scr_as_trans"
		local particleName = "scr_as_trans_smoke"
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local scale = 2.0

		RequestNamedPtfxAsset(particleDictionary)
		while not HasNamedPtfxAssetLoaded(particleDictionary) do
			Citizen.Wait(0)
		end

		UseParticleFxAssetNextCall(particleDictionary)

		PlaySoundFrontend(-1, "Transform_JN_VFX", "DLC_IE_JN_Player_Sounds", 0)

		local effect = StartParticleFxLoopedOnEntity(particleName, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
		Citizen.Wait(1500)
		StopParticleFxLooped(effect, true)
	end)
end

function RemoveObjects()
	Citizen.CreateThread(function()
		for i = 1, #track.removeprops.mn, 1 do
			local object = GetClosestObjectOfType(track.removeprops.pos[i].x, track.removeprops.pos[i].y, track.removeprops.pos[i].z, 1.0, track.removeprops.mn[i])
			SetEntityAsMissionEntity(object, true, true)
			DeleteEntity(object)
		end
	end)
end

function ActivarFuegoAmigo()
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(GetPlayerPed(-1), true, true)
end

function CreatePickUp_Wrench(pickUp)
	Citizen.CreateThread(function()
		local tmp_pickUp = CreatePickup(pickUp.type, pickUp.x, pickUp.y, pickUp.z, 0, 0, false, pickUp.type)
		table.insert(pickUpsRace, tmp_pickUp)

		while enablePickUps do
			Citizen.Wait(0)
			if HasPickupBeenCollected(tmp_pickUp) and enablePickUps then
				Citizen.Wait(15000)
				CreatePickUp_Wrench(pickUp)
				break
			end
			if not DoesPickupExist(tmp_pickUp) and enablePickUps then
				CreatePickUp_Wrench(pickUp)
				break
			end
		end
	end)
end

RegisterNetEvent("custom_races:client:StartNFCountdown")
AddEventHandler("custom_races:client:StartNFCountdown", function()
	SendNUIMessage({
		action = "startNFCountdown"
	})
	Citizen.Wait(10000)
	if status == "racing" then
		status = "nf"
		TriggerServerEvent("custom_races:nfplayer")
		finishRace()
	end
end)

function RemoveRaceLoadedProps()
	if LoadedMap and LoadedMap.loadedObjects then
		for i,object in ipairs(LoadedMap.loadedObjects) do
			DeleteObject(object)
		end

		enablePickUps = false
		for i, pickUp in ipairs(pickUpsRace) do
			RemovePickup(pickUp)
		end
		pickUpsRace = {}
	end
end

-- Teleport to the previous checkpoint
function TeleportToPreviousCheckpoint()
	if actualCheckPoint-2 <= 0 and not canSpectate then return end

	totalCheckPointsTouched = totalCheckPointsTouched - 1
	nextCheckpoint = nextCheckpoint - 1
	actualCheckPoint = actualCheckPoint - 1

	if lastCheckpointPair == 1 and track.checkpoints[actualCheckPoint-1].hasPair then
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint-1].pair_x, track.checkpoints[actualCheckPoint-1].pair_y, track.checkpoints[actualCheckPoint-1].pair_z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint-1].pair_heading)
		else
			SetEntityCoords(PlayerPedId(), track.checkpoints[actualCheckPoint-1].pair_x, track.checkpoints[actualCheckPoint-1].pair_y, track.checkpoints[actualCheckPoint-1].pair_z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(PlayerPedId(), track.checkpoints[actualCheckPoint-1].pair_heading)
		end
	else
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint-1].x, track.checkpoints[actualCheckPoint-1].y, track.checkpoints[actualCheckPoint-1].z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint-1].heading)
		else
			SetEntityCoords(PlayerPedId(), track.checkpoints[actualCheckPoint-1].x, track.checkpoints[actualCheckPoint-1].y, track.checkpoints[actualCheckPoint-1].z, 0.0, 0.0, 0.0, false)
			SetEntityHeading(PlayerPedId(), track.checkpoints[actualCheckPoint-1].heading)
		end
	end
	PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
	RemoveBlip(actualBlip)
	RemoveBlip(nextBlip)
	RemoveBlip(actualBlip_pair)
	RemoveBlip(nextBlip_pair)

	nextBlip = CreateBlip(track.checkpoints[nextCheckpoint].x, track.checkpoints[nextCheckpoint].y, track.checkpoints[nextCheckpoint].z, 1, true)
	actualBlip = CreateBlip(track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 1, false)

	if track.checkpoints[nextCheckpoint].hasPair then
		nextBlip_pair = CreateBlip(track.checkpoints[nextCheckpoint].pair_x, track.checkpoints[nextCheckpoint].pair_y, track.checkpoints[nextCheckpoint].pair_z, 1, true)
	end
	if track.checkpoints[actualCheckPoint].hasPair then
		actualBlip_pair = CreateBlip(track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 1, false)
	end

	TriggerServerEvent("custom_races:checkPointTouchedRemove", actualCheckPoint, totalCheckPointsTouched, IdRace)
end

function GetDriversNoNF(____drivers)
	local count = 0
	for k, v in pairs(____drivers) do
		if not v.hasnf then
			count = count + 1
		end
	end
	return count
end

function GetDriversNoNFAndNotFinished(____drivers)
	local count = 0
	for k, v in pairs(____drivers) do
		if not v.hasnf and not v.hasFinished then
			count = count + 1
		end
	end
	return count
end

function finishRace()
	status = "leaving"
	SendNUIMessage({
		action = "hideRaceHud"
	})
	TriggerEvent('custom_races:canleavingrace')
	RemoveAllPedWeapons(GetPlayerPed(-1), false)
	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"))
	canSpectate = true
	totalTime = GetGameTimer() - totalTimeStart
	TriggerServerEvent('custom_races:playerFinish')
	CameraFinish_Create()
	Citizen.Wait(1000)
	AnimpostfxStop("MP_Celeb_Win")
	EnableSpecMode()
	if DoesEntityExist(lastVehicle) then
		local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
		TriggerServerEvent("custom_races:deleteVehicle", vehId)
	end
	if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
	end
	if GetVehiclePedIsIn(PlayerPedId(), true) ~= 0 then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), true))
	end
end

RegisterCommand("leaverace", function()
	if status == "racing" then
		SendNUIMessage({
			action = "hideRaceHud"
		})
		SendNUIMessage({
			action = "hideSpectate"
		})
		status = "leaving"
		TriggerEvent('custom_races:canleavingrace')
		RemoveAllPedWeapons(GetPlayerPed(-1), false)
		SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"))
		DisableSpecMode()
		TriggerServerEvent('custom_races:server:leave_race')
		SwitchOutPlayer(PlayerPedId(), 0, 1)
		Citizen.Wait(2000)
		enablePickUps = false
		if DoesEntityExist(lastVehicle) then
			local vehId = NetworkGetNetworkIdFromEntity(lastVehicle)
			TriggerServerEvent("custom_races:deleteVehicle", vehId)
		end
		if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
			DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
		end
		if GetVehiclePedIsIn(PlayerPedId(), true) ~= 0 then
			DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), true))
		end
		FreezeEntityPosition(PlayerPedId(), false)
		RemoveRaceLoadedProps()
		isOverClouds = false
		Citizen.Wait(1000)
		SetEntityCoords(PlayerPedId(), JoinRacePoint.x, JoinRacePoint.y, JoinRacePoint.z)
		SetEntityHeading(PlayerPedId(), JoinRaceHeading)
		SetGameplayCamRelativeHeading(0)
		status = "freemode"
		TriggerEvent('custom_races:unloadrace')
		SwitchInPlayer(PlayerPedId())
		DisplayRadar(true)
		isInASession = false
		SetLocalPlayerAsGhost(false)
		TriggerServerEvent('custom_races:server:SetPlayerRoutingBucket')
	end
end)

function Count(t)
	local c = 0
	for _, _ in pairs(t) do
		c = c + 1
	end
	return c
end

exports("hasStartRace", function()
	return status
end)

function CreateGamerTagInfo(playerclient, id, name)
	if gamertags[id] and IsMpGamerTagActive(gamertags[k]) then return end
	gamertags[id] = CreateFakeMpGamerTag(GetPlayerPed(playerclient), name, false, false, '', 0, 0, 0, 0)
end

function RemoveGamerTagInfo(id)
	RemoveMpGamerTag(gamertags[id])
	gamertags[id] = nil
end

AddEventHandler('custom_races:unloadrace', function()
	Citizen.Wait(5000)
	canOpenMenu = true
end)

AddEventHandler("DarkRP_Racing:Loadmap", function()
	canOpenMenu = false
end)

AddEventHandler("DarkRP_Racing:Unloadmap", function()
	canOpenMenu = true
end)

AddEventHandler('racemenu:opened', function()
	canOpenMenu = false
end)

AddEventHandler('racemenu:closed', function()
	canOpenMenu = true
end)

local inMenu = false
Citizen.CreateThread(function()
	local _w = 1000
	while true do
		if not inMenu then
			_w = 5
			if IsControlJustReleased(0, 167) and status == "freemode" and canOpenMenu then
				if not inMenu then
					openMenu()
					inMenu = true
				end
			end
			if IsControlJustReleased(0, 167) and not canOpenMenu and not IsNuiFocused() then
				if GetCurrentLanguage() == 12 then
					ESX.ShowNotification("你已经在比赛中了")
				else
					ESX.ShowNotification("You're already in race.")
				end
			end
		end
		Wait(_w)
	end
end)

function openMenu()
	SendNUIMessage({
		action = "openMenu",
		races_data_front = races_data_front,
		inrace = isRacing
	})
	SetNuiFocus(true, true)
end

_G.EndCam = function()
	ClearFocus()
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(cam, false)
	inMenu = false
	cam = nil
end

_G.EndCam2 = function()
	ClearFocus()
	RenderScriptCams(false, true, 0, true, false)
	DestroyCam(cam, false)
	inMenu = false
	cam = nil
end

-- Adjust the knock level and ped invincible
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if status == "racing" then
			-- Hide street and vehicle information in the lower right corner
			-- https://docs.fivem.net/natives/?_0x6806C51AD12B83B8
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9) 

			-- Adjust the knock level for bmx and motorcycle
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
			end
		end

		-- Reset the knock level and ped invincible
		if status == "freemode" and not hasResetKnockLevel then
			transformIsParachute = false -- If the previous race was exited with a parachute, reset the state
			SetPedConfigFlag(ped, 151, true)
			SetPedCanBeKnockedOffVehicle(ped, 0)

			SetEntityInvincible(ped, false)
			SetPedArmour(ped, 100)
			SetEntityHealth(ped, 200)

			hasResetKnockLevel = true
		end

		Citizen.Wait(0)
	end
end)

-- You can customize the triggering of this event, or delete the related code
AddEventHandler('sendRGB', function(newr, newg, newb)
	r = newr
	g = newg
	b = newb
end)

-- Teleport to the previous checkpoint
tpp = function()
	if status == "racing" then
		TeleportToPreviousCheckpoint()
		finishLine = false
		TriggerServerEvent('custom_races:TpToPreviousCheckpoint', track.trackName, totalCheckPointsTouched)
		if GetCurrentLanguage() == 12 then
			ESX.ShowNotification("牛逼")
		else
			ESX.ShowNotification("You are the god.")
		end
	end
end

RegisterCommand("tpp", function()
	tpp()
end)

-- Teleport to the next checkpoint
tpn = function()
	if status == "racing" then
		if lastCheckpointPair == 1 and track.checkpoints[actualCheckPoint].hasPair then
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint].pair_heading)
			else
				SetEntityCoords(PlayerPedId(), track.checkpoints[actualCheckPoint].pair_x, track.checkpoints[actualCheckPoint].pair_y, track.checkpoints[actualCheckPoint].pair_z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(PlayerPedId(), track.checkpoints[actualCheckPoint].pair_heading)
			end
		else
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
				SetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(GetVehiclePedIsIn(PlayerPedId(), false), track.checkpoints[actualCheckPoint].heading)
			else
				SetEntityCoords(PlayerPedId(), track.checkpoints[actualCheckPoint].x, track.checkpoints[actualCheckPoint].y, track.checkpoints[actualCheckPoint].z, 0.0, 0.0, 0.0, false)
				SetEntityHeading(PlayerPedId(), track.checkpoints[actualCheckPoint].heading)
			end
		end

		TriggerServerEvent('custom_races:TpToNextCheckpoint', track.trackName, totalCheckPointsTouched)

		if GetCurrentLanguage() == 12 then
			ESX.ShowNotification("传送成功，不会记录你的成绩")
		else
			ESX.ShowNotification("Teleported. And your time will not be recorded.")
		end
	end
end

RegisterCommand("tpn", function()
	tpn()
end)