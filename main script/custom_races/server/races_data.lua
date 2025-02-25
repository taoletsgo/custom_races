races_data = {}
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
		UpdateAllRace()
		isUpdatingData = false
	end
end)

--- Function to update all race data from the database
UpdateAllRace = function()
	races_data_front = {}
	local time = os.time()
	local count = 0 -- When the number of maps > 3000, there will be some performance issues when loading for the first time with my cpu, so optimize it
	for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
		if not races_data_front[v.category] then
			races_data_front[v.category] = {}
		end
		if v.published ~= "x" then
			count = count + 1
			table.insert(races_data_front[v.category], {
				name = v.route_file:match("([^/]+)%.json$"),
				img = v.route_image,
				raceid = tostring(v.raceid),
				maxplayers = Config.MaxPlayers,
				besttimes = json.decode(v.besttimes),
				date = v.updated_time or (os.date("%Y/%m/%d %H:%M:%S", tonumber(time) - tonumber(v.raceid)))
			})
		end
		if count > 500 then
			count = 0
			Citizen.Wait(0)
		end
	end
	-- Sort races made or updated by custom_creator
	count = 0
	for k, v in pairs(races_data_front) do
		if #races_data_front[k] >= 2 then
			count = count + 1
			table.sort(races_data_front[k], function(a, b)
				return convertToTimestamp(a.date) > convertToTimestamp(b.date)
			end)
		end
		if count > 10 then
			count = 0
			Citizen.Wait(0)
		end
	end
	if not races_data_front["Custom"] then
		races_data_front["Custom"] = {}
	end
end

--- Function to convert str to timestamp
--- @param formattedTime string
--- @return number
convertToTimestamp = function (formattedTime)
	local pattern = "(%d+)%/(%d+)%/(%d+) (%d+):(%d+):(%d+)"
	local year, month, day, hour, min, sec = formattedTime:match(pattern)
	return os.time{year = year, month = month, day = day, hour = hour, min = min, sec = sec}
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
	while isUpdatingData do
		Citizen.Wait(0)
	end
	callback(races_data_front)
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

AddEventHandler('custom_races:server:UpdateAllRace', function()
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
				UpdateAllRace()
				isUpdatingData = false
			end
		end
	end
end)