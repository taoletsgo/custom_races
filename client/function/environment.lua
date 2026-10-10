function Client.Function.Environment.SetWeather(weatherType)
	ClearOverrideWeather()
	ClearWeatherTypePersist()
	SetWeatherTypePersist(weatherType)
	SetWeatherTypeNow(weatherType)
	SetWeatherTypeNowPersist(weatherType)
	SetRainLevel(-1.0)
	if weatherType == "XMAS" then
		SetForceVehicleTrails(true)
		SetForcePedFootstepsTracks(true)
	else
		SetForceVehicleTrails(false)
		SetForcePedFootstepsTracks(false)
	end
	Client.Weather.Current = weatherType
end

function Client.Function.Environment.SetTime(hour, minute, second)
	NetworkOverrideClockTime(hour, minute, second)
	Client.Time.CurrentHour = hour
	Client.Time.CurrentMinute = minute
	Client.Time.CurrentSecond = second
end

function Client.Function.Environment.SetTraffic(bool)
	if Client.Preference.Traffic ~= bool then
		Client.Function.Message.Display(Client.Function.Translate.Get(bool and "traffic-on" or "traffic-off"))
		Client.Preference.Traffic = bool
		TriggerServerEvent("server:core:preferences", {Traffic = Client.Preference.Traffic})
	end
end

function Client.Function.Environment.DisableTraffic()
	local pos = GetEntityCoords(PlayerPedId())
	ClearAreaLeaveVehicleHealth(pos.x, pos.y, pos.z, 100000000000000000000000.0, false, false, false, false, false)
	CreateThread(function()
		while true do
			local off = false
			local myPed = PlayerPedId()
			local myCoords = GetEntityCoords(myPed)
			for _, player in pairs(Client.Player.List) do
				local id = player[1]
				if id ~= Client.ServerId then
					local disableTraffic = player[8]
					if disableTraffic and (#(myCoords - vector3(player[2][1], player[2][2], player[2][3])) < 200.0) then
						off = true
						break
					end
				end
			end
			if Client.FirstLoad or not Client.Preference.Traffic or off then
				RemoveVehiclesFromGeneratorsInArea(myCoords.x - 200.0, myCoords.y - 200.0, myCoords.z - 200.0, myCoords.x + 200.0, myCoords.y + 200.0, myCoords.z + 200.0)
				SetVehicleDensityMultiplierThisFrame(0.0)
				SetRandomVehicleDensityMultiplierThisFrame(0.0)
				SetParkedVehicleDensityMultiplierThisFrame(0.0)
				SetGarbageTrucks(0)
				SetRandomBoats(0)
				SetPedDensityMultiplierThisFrame(0.0)
				SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
			end
			Wait(0)
		end
	end)
end

function Client.Function.Environment.DisableScenarios()
	local scenarios = {
		"WORLD_VEHICLE_ATTRACTOR",
		"WORLD_VEHICLE_AMBULANCE",
		"WORLD_VEHICLE_BICYCLE_BMX",
		"WORLD_VEHICLE_BICYCLE_BMX_BALLAS",
		"WORLD_VEHICLE_BICYCLE_BMX_FAMILY",
		"WORLD_VEHICLE_BICYCLE_BMX_HARMONY",
		"WORLD_VEHICLE_BICYCLE_BMX_VAGOS",
		"WORLD_VEHICLE_BICYCLE_MOUNTAIN",
		"WORLD_VEHICLE_BICYCLE_ROAD",
		"WORLD_VEHICLE_BIKE_OFF_ROAD_RACE",
		"WORLD_VEHICLE_BIKER",
		"WORLD_VEHICLE_BOAT_IDLE",
		"WORLD_VEHICLE_BOAT_IDLE_ALAMO",
		"WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
		"WORLD_VEHICLE_BOAT_IDLE_MARQUIS",
		"WORLD_VEHICLE_BROKEN_DOWN",
		"WORLD_VEHICLE_BUSINESSMEN",
		"WORLD_VEHICLE_HELI_LIFEGUARD",
		"WORLD_VEHICLE_CLUCKIN_BELL_TRAILER",
		"WORLD_VEHICLE_CONSTRUCTION_SOLO",
		"WORLD_VEHICLE_CONSTRUCTION_PASSENGERS",
		"WORLD_VEHICLE_DRIVE_PASSENGERS",
		"WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED",
		"WORLD_VEHICLE_DRIVE_SOLO",
		"WORLD_VEHICLE_FIRE_TRUCK",
		"WORLD_VEHICLE_EMPTY",
		"WORLD_VEHICLE_MARIACHI",
		"WORLD_VEHICLE_MECHANIC",
		"WORLD_VEHICLE_MILITARY_PLANES_BIG",
		"WORLD_VEHICLE_MILITARY_PLANES_SMALL",
		"WORLD_VEHICLE_PARK_PARALLEL",
		"WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN",
		"WORLD_VEHICLE_PASSENGER_EXIT",
		"WORLD_VEHICLE_POLICE_BIKE",
		"WORLD_VEHICLE_POLICE_CAR",
		"WORLD_VEHICLE_POLICE",
		"WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
		"WORLD_VEHICLE_QUARRY",
		"WORLD_VEHICLE_SALTON",
		"WORLD_VEHICLE_SALTON_DIRT_BIKE",
		"WORLD_VEHICLE_SECURITY_CAR",
		"WORLD_VEHICLE_STREETRACE",
		"WORLD_VEHICLE_TOURBUS",
		"WORLD_VEHICLE_TOURIST",
		"WORLD_VEHICLE_TANDL",
		"WORLD_VEHICLE_TRACTOR",
		"WORLD_VEHICLE_TRACTOR_BEACH",
		"WORLD_VEHICLE_TRUCK_LOGS",
		"WORLD_VEHICLE_TRUCKS_TRAILERS",
		"WORLD_VEHICLE_DISTANT_EMPTY_GROUND",
		"WORLD_HUMAN_PAPARAZZI"
	}
	for _, v in pairs(scenarios) do
		SetScenarioTypeEnabled(v, false)
	end
end

function Client.Function.Environment.DisableWantedLevel()
	CreateThread(function()
		while true do
			for i = 1, 15 do
				EnableDispatchService(i, false)
			end
			SetPlayerWantedLevel(PlayerId(), 0, false)
			SetPlayerWantedLevelNow(PlayerId(), false)
			SetPlayerWantedLevelNoDrop(PlayerId(), 0, false)
			Wait(0)
		end
	end)
end