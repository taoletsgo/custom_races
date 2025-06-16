races_data_front = {}
isUpdatingData = true
lastUpdateTime = 0

Citizen.CreateThread(function()
	local attempt = 0
	while GetResourceState("oxmysql") ~= "started" and attempt < 3 do
		attempt = attempt + 1
		Citizen.Wait(1000)
	end
	Citizen.Wait(1000)
	if GetResourceState("oxmysql") == "started" then
		races_data_front = UpdateAllRace()
		isUpdatingData = false
	end
end)

UpdateAllRace = function()
	local races_data_front_temp = {}
	local count = 0 -- When the number of maps > 3000, there will be some performance issues when loading for the first time with my cpu, so optimize it
	for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
		if not races_data_front_temp[v.category] then
			races_data_front_temp[v.category] = {}
		end
		if v.published ~= "x" then
			count = count + 1
			table.insert(races_data_front_temp[v.category], {
				name = v.route_file:match("([^/]+)%.json$"),
				img = v.route_image,
				raceid = tostring(v.raceid),
				maxplayers = Config.MaxPlayers,
				date = v.updated_time or tonumber(v.raceid)
			})
		end
		if count > 500 then
			count = 0
			Citizen.Wait(0)
		end
	end
	-- Sort races made or updated by custom_creator
	count = 0
	for k, v in pairs(races_data_front_temp) do
		if #races_data_front_temp[k] >= 2 then
			count = count + 1
			table.sort(races_data_front_temp[k], function(a, b)
				return ConvertToTimestamp(a.date) > ConvertToTimestamp(b.date)
			end)
		end
		if count > 10 then
			count = 0
			Citizen.Wait(0)
		end
	end
	if not races_data_front_temp["Custom"] then
		races_data_front_temp["Custom"] = {}
	end
	return races_data_front_temp
end

ConvertToTimestamp = function(date)
	if type(date) == "number" then
		return 1 - date
	else
		local pattern = "(%d+)%/(%d+)%/(%d+) (%d+):(%d+):(%d+)"
		local year, month, day, hour, min, sec = date:match(pattern)
		return os.time{year = year, month = month, day = day, hour = hour, min = min, sec = sec}
	end
end

GetRaceFrontFromRaceid = function(raceId)
	for k, v in pairs(races_data_front) do
		for i = 1, #v do
			if v[i].raceid == raceId then
				return k, i
			end
		end
	end
end

CreateServerCallback("custom_races:server:getVehicles", function(source, callback)
	local playerId = tonumber(source)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	local favoriteVehicles = nil
	local personalVehicles = nil
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		local favoriteVehicles_results = MySQL.query.await("SELECT fav_vehs FROM custom_race_users WHERE license = ?", {identifier})
		if favoriteVehicles_results and favoriteVehicles_results[1] then
			favoriteVehicles = json.decode(favoriteVehicles_results[1].fav_vehs)
		end
		local personalVehicles_results = MySQL.query.await("SELECT vehicle_mods FROM custom_race_users WHERE license = ?", {identifier})
		if personalVehicles_results and personalVehicles_results[1] then
			personalVehicles = json.decode(personalVehicles_results[1].vehicle_mods)
		end
	end
	callback(favoriteVehicles or {}, personalVehicles or {})
end)

CreateServerCallback("custom_races:server:getBestTimes", function(source, callback, raceid)
	local results = MySQL.query.await("SELECT besttimes FROM custom_race_list WHERE raceid = ?", {raceid})
	local besttimes = results and results[1] and json.decode(results[1].besttimes) or {}
	callback(besttimes)
end)

CreateServerCallback("custom_races:server:getRacesData", function(source, callback)
	while isUpdatingData do
		Citizen.Wait(0)
	end
	callback(races_data_front)
end)

RegisterNetEvent("custom_races:server:setFavorite", function(fav_vehs)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		local favoriteVehicles_results = MySQL.query.await("SELECT fav_vehs FROM custom_race_users WHERE license = ?", {identifier})
		if favoriteVehicles_results and favoriteVehicles_results[1] then
			MySQL.update("UPDATE custom_race_users SET name = ?, fav_vehs = ? WHERE license = ?", {playerName, json.encode(fav_vehs), identifier})
		else
			MySQL.insert('INSERT INTO custom_race_users (license, name, fav_vehs) VALUES (?, ?, ?)', {identifier, playerName, json.encode(fav_vehs)})
		end
	end
end)

AddEventHandler('custom_races:server:updateAllRace', function()
	TriggerClientEvent("custom_races:client:dataOutdated", -1)
	if GetResourceState("oxmysql") == "started" then
		local time = GetGameTimer()
		if time > lastUpdateTime then
			lastUpdateTime = time
			while isUpdatingData do
				Citizen.Wait(0)
			end
			if time == lastUpdateTime then
				isUpdatingData = true
				races_data_front = UpdateAllRace()
				isUpdatingData = false
			end
		end
	end
end)