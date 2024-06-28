races_data = {}
races_data_front = {}
races_data_stats = {}

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	UpdateAllRace()
end)

UpdateAllRace = function()
	for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
		v.raceid = tostring(v.raceid)
		races_data[v.raceid] = GetDataFromRaceUrl(v.route_file)
		local route_image_data = GetDataFromImageUrl(v.route_image)
		if races_data[v.raceid] and route_image_data then
			races_data_front[v.category] = races_data_front[v.category] or {}
			table.insert(races_data_front[v.category], {
				name = races_data[v.raceid].mission.gen.nm,
				img = route_image_data,
				raceid = v.raceid,
				maxplayers = races_data[v.raceid].mission.veh.no,
				besttimes = json.decode(v.besttimes)
			})
		end
	end
	races_data_stats = MySQL.query.await("SELECT * FROM custom_race_stats ORDER BY level DESC")
end

GetDataFromRaceUrl = function(file)
	local raceData = "NR"
	if string.find(file, "https") then -- It is not recommended to load from the network, as parsing JSON can easily block the thread
		PerformHttpRequest(file, function(errorCode, data, headers)
			raceData = data
		end, "GET", "", {["Content-Type"] = "application/json"})
		while "NR" == raceData do
			Citizen.Wait(0)
		end
		return json.decode(raceData)
	else
		local filename = file:match("([^/]+)%.json$")
		-- The default return value is the json file name and the maxplayers is 30. Parsing a large number of json files is not friendly to low-end CPUs.
		return { mission = { gen = { nm = filename }, veh = { no = 30 } } }
	end
end

GetDataFromImageUrl = function(file)
	if string.find(file, "https") then
		return file -- Return URL directly
	else
		return "/" .. GetCurrentResourceName() .. "/" .. file -- Returns the local path (not supported yet, to do list)
	end
end

UpdateTop = function(citizenid, podiumPosition, playerId, position)
	level, experience = AddPlayerExperience(citizenid, playerId, position, true)

	MySQL.insert(
		"INSERT INTO custom_race_stats (citizenid, level, experience, " .. podiumPosition .. ", name) VALUES (@citizenid, @level, @experience, 1, @name) ON DUPLICATE KEY UPDATE " .. podiumPosition .. " = " .. podiumPosition .. " + 1, level = @level, experience = @experience",
		{
			["@citizenid"] = citizenid,
			["@name"] = GetPlayerName(playerId),
			["@level"] = level,
			["@experience"] = experience
		}
	)

	local isPlayerFound = false
	for k, v in pairs(races_data_stats) do
		if v.citizenid == citizenid then
			v[podiumPosition] = v[podiumPosition] + 1
			v.level = level
			v.experience = experience
			isPlayerFound = true
			break
		end
	end

	if not isPlayerFound then
		table.insert(races_data_stats, {
			citizenid = citizenid,
			frst = 0,
			scnd = 0,
			thrd = 0,
			name = GetPlayerName(playerId),
			level = level,
			experience = experience,
			[podiumPosition] = 1
		})
	end

	table.sort(races_data_stats, function(levelA, levelB) return levelA.level > levelB.level end)

	local playerStats = {}
	for k, v in pairs(races_data_stats) do
		if v.citizenid == citizenid then
			playerStats = {
				frst = v.frst,
				scnd = v.scnd,
				thrd = v.thrd,
				level = v.level,
				experience = v.experience,
				posi = k
			}
			break
		end
	end

	TriggerClientEvent("custom_races:client:updatemytop", playerId, playerStats)
end

AddPlayerExperience = function(citizenid, playerId, experience, bool)
	local isPlayerFound, level, experience = false, 0, experience
	for k, v in pairs(races_data_stats) do
		if v.citizenid == citizenid then
			isPlayerFound = true
			v.experience = v.experience + experience
			level, experience = GetLevelFromExpAndLevel(v.level, v.experience)
			v.level = level
			v.experience = experience
			break
		end
	end
	if not bool then
		if not isPlayerFound then
			local playerStats = {
				citizenid = citizenid,
				frst = 0,
				scnd = 0,
				thrd = 0,
				name = GetPlayerName(playerId),
				level = 1,
				experience = experience
			}
			level, experience = GetLevelFromExpAndLevel(playerStats.level, playerStats.experience)
			playerStats.level = level
			playerStats.experience = experience
			table.insert(races_data_stats, playerStats)
		end
		MySQL.insert(
			"INSERT INTO custom_race_stats (citizenid, level, experience, name) VALUES (@citizenid, @level, @experience, @name) ON DUPLICATE KEY UPDATE level = @level, experience = @experience", 
			{
				["@citizenid"] = citizenid,
				["@name"] = GetPlayerName(playerId),
				["@level"] = level,
				["@experience"] = experience
			}
		)
	end
	return level, experience
end

GetLevelFromExpAndLevel = function(level, experience)
	local requiredExperience = math.floor(level * 3.14)
	while experience >= requiredExperience do
		Citizen.Wait(0)
		level = level + 1
		experience = requiredExperience - experience
		requiredExperience = math.floor(level * 3.14)
	end
	return level, experience
end

if Config.Framework == "esx" then
	ESX.RegisterServerCallback("custom_races:GetRacesData_Front", function(result, callback)
		callback(races_data_front)
	end)
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

FetchStats = function(playerId, callback, identifierKey, tableName, usersTable)
	local playerIdentifier = ESX.GetPlayerFromId(playerId).identifier

	local favoriteVehicles = MySQL.query.await("SELECT fav_vehs FROM " .. usersTable .. " WHERE " .. identifierKey .. " = ?", {playerIdentifier})
	if favoriteVehicles[1] then
		favoriteVehicles[1] = json.decode(favoriteVehicles[1].fav_vehs)
	end

	local personalVehicles = MySQL.query.await("SELECT * FROM " .. tableName .. " WHERE " .. "owner" .. " = ?", {playerIdentifier})

	local playerStats = {}
	for k, v in pairs(races_data_stats) do
		if v[identifierKey] == playerIdentifier then
			playerStats = {frst = v.frst, scnd = v.scnd, thrd = v.thrd, level = v.level, experience = v.experience, posi = k}
			break
		end
	end

	callback(favoriteVehicles[1] or {}, personalVehicles, playerStats)
end

ESX.RegisterServerCallback("custom_races:callback:favoritesvehs_personalvehs_mystats", function(playerId, callback)
	FetchStats(playerId, callback, "identifier", "owned_vehicles", "users")
end)

RegisterServerEvent("custom_races:SetFavorite", function(fake_fav)
	local playerId = source
	local identifier = ESX.GetPlayerFromId(playerId).identifier
	MySQL.update("UPDATE " .. "users" .. " SET fav_vehs = ? WHERE " .. "identifier" .. " = ?", {json.encode(fake_fav), identifier})
end)