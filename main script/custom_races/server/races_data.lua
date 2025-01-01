races_data = {}
races_data_front = {}
local isUpdatingData = false

Citizen.CreateThread(function()
	local attempt = 0
	while GetResourceState("oxmysql") ~= "started" and attempt < 3 do
		attempt = attempt + 1
		Citizen.Wait(1000)
	end
	Citizen.Wait(1000)
	if GetResourceState("oxmysql") == "started" then
		UpdateAllRace()
	end
end)

--- Function to update all race data from the database
UpdateAllRace = function()
	isUpdatingData = true
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
	isUpdatingData = false
end

--- Function to get data from a race URL
--- @param file string The URL or path of the JSON file
--- @return table The race data decoded from the JSON file
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
		-- The default value is the json file name and the maxplayers. Parsing a large number of json files is not friendly to low-end CPUs
		return { mission = { gen = { nm = filename }, veh = { no = Config.MaxPlayers } } }
	end
end

--- Function to get data from an image URL
--- @param file string The URL or path of the image file
--- @return string The image URL or local path
GetDataFromImageUrl = function(file)
	if string.find(file, "https") then
		return file -- Return URL directly
	else
		return "/" .. GetCurrentResourceName() .. "/" .. file -- Returns the local path (not supported yet, to do list)
	end
end

--- Function to get the category and index of a race from its ID
--- @param raceId string The ID of the race to search for
--- @return string|nil The category of the race or nil if not found
--- @return number|nil The index of the race within the category or nil if not found
GetRaceFrontFromRaceid = function(raceId)
	for k, v in pairs(races_data_front) do
		for i = 1, #v do
			if v[i].raceid == raceId then
				return k, i
			end
		end
	end
end

--- Function to fetch favorite and personal vehicles for a player
--- @param playerId number The ID of the player whose vehicles are to be fetched
--- @param callback function The callback function to execute with the fetched data
FetchVehicles = function(playerId, callback)
	local identifier = nil
	local usersTable = nil
	local userIdentifierColumn = nil
	local vehicleTable = nil
	local vehicleOwnerColumn = nil
	local favoriteVehicles = nil
	local personalVehicles = nil

	if "esx" == Config.Framework then
		identifier = ESX and ESX.GetPlayerFromId(playerId).identifier
		usersTable = "users"
		userIdentifierColumn = "identifier"
		vehicleTable = "owned_vehicles"
		vehicleOwnerColumn = "owner"
	elseif "qb" == Config.Framework then
		identifier = QBCore and QBCore.Functions.GetPlayer(playerId).PlayerData.citizenid
		usersTable = "players"
		userIdentifierColumn = "citizenid"
		vehicleTable = "player_vehicles"
		vehicleOwnerColumn = "citizenid"
	elseif "standalone" == Config.Framework then
		local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
		if identifier_license then
			identifier = identifier_license:gsub('license:', '')
			usersTable = "custom_race_users"
			userIdentifierColumn = "license"
			vehicleTable = nil
			vehicleOwnerColumn = nil
		end
	end

	if identifier and usersTable and userIdentifierColumn then
		local favoriteVehicles_results = MySQL.query.await("SELECT fav_vehs FROM " .. usersTable .. " WHERE " .. userIdentifierColumn .. " = ?", {identifier})
		if favoriteVehicles_results and favoriteVehicles_results[1] then
			favoriteVehicles = json.decode(favoriteVehicles_results[1].fav_vehs)
		end
	end

	if identifier and vehicleTable and vehicleOwnerColumn then
		local personalVehicles_results = MySQL.query.await("SELECT * FROM " .. vehicleTable .. " WHERE " .. vehicleOwnerColumn .. " = ?", {identifier})
		if personalVehicles_results then
			personalVehicles = personalVehicles_results
		end
	end

	callback(favoriteVehicles or {}, personalVehicles or {})
end

--- Server callback for fetching favorite and personal vehicles of a player
--- @param playerId number The ID of the player whose vehicles are to be fetched
--- @param callback function The callback function to execute with the fetched data
CreateServerCallback("custom_races:callback:favoritesvehs_personalvehs", function(playerId, callback)
	FetchVehicles(tonumber(playerId), callback)
end)

--- Function to handle a server callback for getting race data
--- @param source number The ID of the requesting player
--- @param callback function The callback function to send data to client when joining
CreateServerCallback("custom_races:GetRacesData_Front", function(source, callback)
	if isUpdatingData then
		callback({})
	else
		callback(races_data_front)
	end
end)

--- Function to set favorite vehicles for a player
--- @param fake_fav table The list of favorite vehicles to be set for the player
RegisterNetEvent("custom_races:SetFavorite", function(fake_fav)
	local playerId = tonumber(source)
	local identifier = nil
	local playerName = GetPlayerName(playerId)
	if "esx" == Config.Framework then
		identifier = ESX and ESX.GetPlayerFromId(playerId).identifier
		if identifier then
			MySQL.update("UPDATE " .. "users" .. " SET fav_vehs = ? WHERE " .. "identifier" .. " = ?", {json.encode(fake_fav), identifier})
		end
	elseif "qb" == Config.Framework then
		identifier = QBCore and QBCore.Functions.GetPlayer(playerId).PlayerData.citizenid
		if identifier then
			MySQL.update("UPDATE " .. "players" .. " SET fav_vehs = ? WHERE " .. "citizenid" .. " = ?", {json.encode(fake_fav), identifier})
		end
	elseif "standalone" == Config.Framework then
		local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
		if identifier_license then
			identifier = identifier_license:gsub('license:', '')
			local favoriteVehicles_results = MySQL.query.await("SELECT fav_vehs FROM custom_race_users WHERE license = ?", {identifier})
			if favoriteVehicles_results and favoriteVehicles_results[1] then
				MySQL.update("UPDATE custom_race_users SET name = ?, fav_vehs = ? WHERE license = ?", {playerName, json.encode(fake_fav), identifier})
			else
				MySQL.insert('INSERT INTO custom_race_users (license, name, fav_vehs) VALUES (?, ?, ?)', {identifier, playerName, json.encode(fake_fav)})
			end
		end
	end
end)