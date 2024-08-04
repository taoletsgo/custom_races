races_data = {}
races_data_front = {}

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	UpdateAllRace()
end)

--- Function to update all race data from the database
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
--- @param identifierKey string The key to use for identifying the player in the database
--- @param tableName string The name of the table containing personal vehicles
--- @param usersTable string The name of the table containing user data
FetchVehicles = function(playerId, callback, identifierKey, tableName, usersTable)
	local playerIdentifier = ESX.GetPlayerFromId(playerId).identifier

	local favoriteVehicles = MySQL.query.await("SELECT fav_vehs FROM " .. usersTable .. " WHERE " .. identifierKey .. " = ?", {playerIdentifier})
	if favoriteVehicles[1] then
		favoriteVehicles[1] = json.decode(favoriteVehicles[1].fav_vehs)
	end

	local personalVehicles = MySQL.query.await("SELECT * FROM " .. tableName .. " WHERE " .. "owner" .. " = ?", {playerIdentifier})

	callback(favoriteVehicles[1] or {}, personalVehicles)
end

--- Server callback for fetching favorite and personal vehicles of a player
--- @param playerId number The ID of the player whose vehicles are to be fetched
--- @param callback function The callback function to execute with the fetched data
ESX.RegisterServerCallback("custom_races:callback:favoritesvehs_personalvehs", function(playerId, callback)
	FetchVehicles(playerId, callback, "identifier", "owned_vehicles", "users")
end)

--- Function to handle a server callback for getting race data
--- @param result any The result to pass to the callback function
--- @param callback function The callback function to send data to client when joining
ESX.RegisterServerCallback("custom_races:GetRacesData_Front", function(result, callback)
	callback(races_data_front)
end)

--- Function to set favorite vehicles for a player
--- @param fake_fav table The list of favorite vehicles to be set for the player
RegisterServerEvent("custom_races:SetFavorite", function(fake_fav)
	local playerId = source
	local identifier = ESX.GetPlayerFromId(playerId).identifier
	MySQL.update("UPDATE " .. "users" .. " SET fav_vehs = ? WHERE " .. "identifier" .. " = ?", {json.encode(fake_fav), identifier})
end)