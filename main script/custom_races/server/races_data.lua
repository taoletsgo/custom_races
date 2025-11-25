Citizen.CreateThread(function()
	local attempt = 0
	while GetResourceState("oxmysql") ~= "started" and attempt < 3 do
		attempt = attempt + 1
		Citizen.Wait(1000)
	end
	Citizen.Wait(1000)
	if GetResourceState("oxmysql") == "started" then
		RaceServer.Data.Front = UpdateAllRace()
		RaceServer.Data.IsUpdatingData = false
	end
end)

function UpdateAllRace()
	local data = {}
	local count = 0 -- When the number of maps > 3000, there will be some performance issues when loading for the first time with my cpu, so optimize it
	for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
		if not data[v.category] then
			data[v.category] = {}
		end
		if v.published ~= "x" then
			count = count + 1
			table.insert(data[v.category], {
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
	for k, v in pairs(data) do
		if #data[k] >= 2 then
			count = count + 1
			table.sort(data[k], function(a, b)
				return ConvertToTimestamp(a.date) > ConvertToTimestamp(b.date)
			end)
		end
		if count > 10 then
			count = 0
			Citizen.Wait(0)
		end
	end
	if not data["Custom"] then
		data["Custom"] = {}
	end
	return data
end

function ConvertToTimestamp(date)
	if type(date) == "number" then
		return 1 - date
	else
		local pattern = "(%d+)%/(%d+)%/(%d+) (%d+):(%d+):(%d+)"
		local year, month, day, hour, min, sec = date:match(pattern)
		return os.time{year = year, month = month, day = day, hour = hour, min = min, sec = sec}
	end
end

function SearchRockstarJob(json_url, retry, playerId, cb)
	PerformHttpRequest(json_url, function(statusCode, response, headers)
		if statusCode == 200 then
			RaceServer.Data.SearchStatus[playerId] = ""
			local data = json.decode(response)
			cb(data, true)
		else
			if statusCode == 404 then
				cb(nil, false)
			else
				if retry < 3 then
					SearchRockstarJob(json_url, retry + 1, playerId, cb)
				else
					cb(nil, false)
				end
			end
		end
	end, "GET", "", {["Content-Type"] = "application/json"})
end

CreateServerCallback("custom_races:server:getVehicles", function(player, callback)
	local playerId = player.src
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local favoriteVehicles = nil
	local personalVehicles = nil
	if identifier_license then
		local identifier = identifier_license:gsub("license:", "")
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

CreateServerCallback("custom_races:server:getBestTimes", function(player, callback, raceid)
	local results = MySQL.query.await("SELECT besttimes FROM custom_race_list WHERE raceid = ?", {raceid})
	local besttimes = results and results[1] and json.decode(results[1].besttimes) or {}
	callback(besttimes)
end)

CreateServerCallback("custom_races:server:getRacesData", function(player, callback)
	while RaceServer.Data.IsUpdatingData do
		Citizen.Wait(0)
	end
	callback(RaceServer.Data.Front)
end)

CreateServerCallback("custom_races:server:searchUGC", function(player, callback, url, ugc_img, ugc_json)
	if not string.find(url, "^https://prod%.cloud%.rockstargames%.com/ugc/gta5mission/") then
		callback(nil, nil, nil)
		return
	end
	local playerId = player.src
	if ugc_json then
		SearchRockstarJob(url, 99, playerId, function(data)
			if data then
				if data.mission and data.mission.race and data.mission.race.chp and data.mission.race.chp >= 3 and data.mission.veh and data.mission.veh.loc and #data.mission.veh.loc >= 1 then
					RaceServer.Data.SearchCaches[playerId] = data
					callback(data.mission.gen.nm, Config.MaxPlayers, nil)
				else
					callback(nil, nil, "failed")
				end
			else
				callback(nil, nil, "failed")
			end
		end)
	elseif ugc_img then
		RaceServer.Data.SearchStatus[playerId] = "querying"
		local lang = {"en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"}
		local path = url:match("(.-)/[^/]+$")
		local found = false
		for i = 0, 2 do
			for j = 0, 500 do
				for k = 1, 13 do
					local json_url = path .. "/" .. i .. "_" .. j .. "_" .. lang[k] .. ".json"
					local lock = true
					local retry = 0
					SearchRockstarJob(json_url, retry, playerId, function(data, bool)
						found = bool
						lock = false
						if data then
							if data.mission and data.mission.race and data.mission.race.chp and data.mission.race.chp >= 3 and data.mission.veh and data.mission.veh.loc and #data.mission.veh.loc >= 1 then
								RaceServer.Data.SearchCaches[playerId] = data
								callback(data.mission.gen.nm, Config.MaxPlayers, nil)
							else
								callback(nil, nil, "failed")
							end
						end
					end)
					while lock do Citizen.Wait(0) end
					if found or not RaceServer.Data.SearchStatus[playerId] then break end
				end
				if found or not RaceServer.Data.SearchStatus[playerId] then break end
			end
			if found or not RaceServer.Data.SearchStatus[playerId] then break end
		end
		if not found then
			callback(nil, nil, RaceServer.Data.SearchStatus[playerId] and "timed-out" or "cancel")
			RaceServer.Data.SearchStatus[playerId] = nil
		end
	else
		callback(nil, nil, "failed")
	end
end)

RegisterNetEvent("custom_races:server:cancelSearch", function()
	local playerId = tonumber(source)
	RaceServer.Data.SearchStatus[playerId] = nil
end)

RegisterNetEvent("custom_races:server:setFavorite", function(favoriteVehicles)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	if identifier_license then
		local identifier = identifier_license:gsub("license:", "")
		local favoriteVehicles_results = MySQL.query.await("SELECT fav_vehs FROM custom_race_users WHERE license = ?", {identifier})
		if favoriteVehicles_results and favoriteVehicles_results[1] then
			MySQL.update("UPDATE custom_race_users SET name = ?, fav_vehs = ? WHERE license = ?", {playerName, json.encode(favoriteVehicles), identifier})
		else
			MySQL.insert("INSERT INTO custom_race_users (license, name, fav_vehs) VALUES (?, ?, ?)", {identifier, playerName, json.encode(favoriteVehicles)})
		end
	end
end)

AddEventHandler("custom_races:server:updateAllRace", function()
	TriggerClientEvent("custom_races:client:dataOutdated", -1)
	if GetResourceState("oxmysql") == "started" then
		local time = GetGameTimer()
		if time > RaceServer.Data.LastUpdateTime then
			RaceServer.Data.LastUpdateTime = time
			while RaceServer.Data.IsUpdatingData do
				Citizen.Wait(0)
			end
			if time == RaceServer.Data.LastUpdateTime then
				RaceServer.Data.IsUpdatingData = true
				RaceServer.Data.Front = UpdateAllRace()
				RaceServer.Data.IsUpdatingData = false
			end
		end
	end
end)