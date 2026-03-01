RegisterNetEvent("custom_creator:server:saveData", function(data)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local currentCreator = CreatorServer.Creators[playerId]
	if identifier_license and playerName and currentCreator and data and type(data) == "table" then
		local preferencesKeys = {"DisableNpcChecked", "ObjectLowerAlphaChecked"}
		for key, _ in pairs(CreatorServer.DefaultPreferences) do
			if data[key] ~= nil then
				currentCreator.preferences[key] = data[key] and 1 or 0
			end
		end
		if data.template ~= nil then
			if type(data.template) == "table" then
				if currentCreator.templates < 30 then
					table.insert(currentCreator.templates, data.template)
				end
			elseif type(data.template) == "number" then
				if currentCreator.templates[data.template] then
					table.remove(currentCreator.templates, data.template)
				end
			end
		end
		local race_creator = {
			preferences = currentCreator.preferences or {},
			templates = currentCreator.templates or {}
		}
		local identifier = identifier_license:gsub("license:", "")
		local results = MySQL.query.await("SELECT race_creator FROM custom_race_users WHERE license = ?", {identifier})
		if results and results[1] then
			MySQL.update("UPDATE custom_race_users SET name = ?, race_creator = ? WHERE license = ?", {playerName, json.encode(race_creator), identifier})
		else
			MySQL.insert("INSERT INTO custom_race_users (license, name, race_creator) VALUES (?, ?, ?)", {identifier, playerName, json.encode(race_creator)})
		end
	end
end)

RegisterNetEvent("custom_creator:server:cancel", function()
	local playerId = tonumber(source)
	CreatorServer.SearchStatus[playerId] = nil
end)

RegisterNetEvent("custom_creator:server:spawnVehicle", function(netId)
	local playerId = tonumber(source)
	CreatorServer.SpawnedVehicles[playerId] = netId
end)

RegisterNetEvent("custom_creator:server:deleteVehicle", function(netId)
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	Citizen.CreateThread(function()
		-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
		-- Sometimes it happens lol, with a probability of 0.000000000001%
		-- If the vehicle exists, delete it
		if DoesEntityExist(vehicle) then
			DeleteEntity(vehicle)
		end
	end)
end)

AddEventHandler("playerJoining", function()
	local playerId = tonumber(source)
	CreatorServer.OnlinePlayers[playerId] = GetPlayerName(playerId)
end)

AddEventHandler("playerDropped", function()
	local playerId = tonumber(source)
	local netId = CreatorServer.SpawnedVehicles[playerId]
	CreatorServer.Creators[playerId] = nil
	CreatorServer.SearchStatus[playerId] = nil
	CreatorServer.OnlinePlayers[playerId] = nil
	CreatorServer.SpawnedVehicles[playerId] = nil
	for _, currentSession in pairs(CreatorServer.Sessions) do
		local found = false
		local playerName = nil
		for k, v in pairs(currentSession.creators) do
			if v.playerId == playerId then
				found = true
				playerName = v.playerName
				table.remove(currentSession.creators, k)
				break
			end
		end
		if found then
			if #currentSession.creators == 0 then
				CreatorServer.Sessions[currentSession.sessionId] = nil
			else
				for k, v in pairs(currentSession.creators) do
					TriggerClientEvent("custom_creator:client:playerLeaveSession", v.playerId, playerName, playerId)
				end
			end
		end
	end
	if netId then
		Citizen.CreateThread(function()
			-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
			-- Sometimes it happens lol, with a probability of 0.000000000001%
			-- If the vehicle exists, delete it
			local attempt = 0
			while DoesEntityExist(NetworkGetEntityFromNetworkId(netId)) and (attempt < 10) do
				attempt = attempt + 1
				DeleteEntity(NetworkGetEntityFromNetworkId(netId))
				Citizen.Wait(200)
			end
		end)
	end
end)

CreateServerCallback("custom_creator:server:checkTitle", function(player, callback, title)
	local found = false
	for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
		if v.route_file:match("([^/]+)%.json$") == title then
			found = true
			break
		end
	end
	callback(not found)
end)

CreateServerCallback("custom_creator:server:getData", function(player, callback)
	local playerId = player.src
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local result = {
		[1] = {
			class = "published-races",
			data = {}
		},
		[2] = {
			class = "saved-races",
			data = {}
		}
	}
	local isAdmin = false
	local result_admin = {}
	CreatorServer.Creators[playerId] = {
		playerId = playerId,
		preferences = {},
		templates = {},
		vehicles = {}
	}
	local currentCreator = CreatorServer.Creators[playerId]
	if identifier_license then
		local identifier = identifier_license:gsub("license:", "")
		local query = MySQL.query.await("SELECT `group`, race_creator, vehicle_mods FROM custom_race_users WHERE license = ?", {identifier})
		if query and query[1] then
			isAdmin = query[1].group == "admin"
			local race_creator = json.decode(query[1].race_creator) or {}
			if race_creator.preferences then
				currentCreator.preferences = race_creator.preferences
			end
			if race_creator.templates then
				currentCreator.templates = race_creator.templates
			else
				for i = 1, #race_creator do
					if race_creator[i] and race_creator[i].props then
						currentCreator.templates[#currentCreator.templates + 1] = race_creator[i].props
					end
				end
			end
			currentCreator.vehicles = json.decode(query[1].vehicle_mods) or {}
		end
		local count = 0
		for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
			local permission = false
			local identifiers = json.decode(v.license)
			if type(identifiers) == "table" then
				for i = 1, #identifiers do
					if identifier == identifiers[i] then
						permission = true
						break
					end
				end
			else
				if identifier == v.license then
					permission = true
				end
			end
			if permission then
				local data = {
					name = v.route_file:match("([^/]+)%.json$"),
					img = v.route_image,
					raceid = v.raceid,
					published = v.published ~= "x"
				}
				if v.published ~= "x" then
					table.insert(result[1].data, data)
				else
					table.insert(result[2].data, data)
				end
			end
			if isAdmin then
				if count > 500 then
					count = 0
					Citizen.Wait(0)
				end
				if not result_admin[v.category] then
					result_admin[v.category] = {}
				end
				count = count + 1
				table.insert(result_admin[v.category], {
					name = v.route_file:match("([^/]+)%.json$"),
					img = v.route_image,
					raceid = v.raceid,
					published = v.published ~= "x"
				})
			end
		end
		local sorted_categories = {}
		for category in pairs(result_admin) do
			table.insert(sorted_categories, category)
		end
		if #sorted_categories >= 2 then
			table.sort(sorted_categories, function(a, b)
				return string.lower(a) < string.lower(b)
			end)
		end
		for i = 1, #sorted_categories do
			result[2 + i] = {
				class = sorted_categories[i],
				data = result_admin[sorted_categories[i]]
			}
		end
		for i = 1, #result do
			if #result[i].data >= 2 then
				table.sort(result[i].data, function(a, b)
					return string.lower(a.name) < string.lower(b.name)
				end)
			end
		end
	end
	result[#result + 1] = {
		class = "filter-races",
		data = {}
	}
	for key, bool in pairs(CreatorServer.DefaultPreferences) do
		if currentCreator.preferences[key] == nil then
			currentCreator.preferences[key] = bool and 1 or 0
		end
	end
	TriggerClientEvent("custom_creator:client:info", playerId, "track-list", #json.encode(result) * 1.02)
	callback(result, currentCreator)
end)

CreateServerCallback("custom_creator:server:getJson", function(player, callback, raceid)
	if not raceid then return end
	local playerId = player.src
	local playerName = player.name
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local identifier = nil
	local isAdmin = false
	if identifier_license then
		identifier = identifier_license:gsub("license:", "")
		local result = MySQL.query.await("SELECT `group` FROM custom_race_users WHERE license = ?", {identifier})
		if result and result[1] then
			isAdmin = result[1].group == "admin"
		end
	end
	local path, published, category, thumbnail = nil, nil, nil, nil
	local query = MySQL.query.await("SELECT route_file, route_image, category, published, license FROM custom_race_list WHERE raceid = ?", {raceid})
	if query and query[1] then
		local permission = false
		local identifiers = json.decode(query[1].license)
		if type(identifiers) == "table" then
			for i = 1, #identifiers do
				if identifier == identifiers[i] then
					permission = true
					break
				end
			end
		else
			if identifier == query[1].license then
				permission = true
			end
		end
		if permission or isAdmin then
			local currentSession = CreatorServer.Sessions[raceid]
			if currentSession then
				table.insert(currentSession.creators, { playerId = playerId, identifier = identifier, playerName = playerName })
				for k, v in pairs(currentSession.creators) do
					if v.playerId ~= playerId then
						TriggerClientEvent("custom_creator:client:playerJoinSession", v.playerId, playerName, playerId)
					end
				end
				TriggerClientEvent("custom_creator:client:info", playerId, "join-session-trying")
				while not currentSession.data do
					if not CreatorServer.Sessions[raceid] then
						break
					end
					Citizen.Wait(1000)
				end
				Citizen.Wait(3000)
				if currentSession.data and currentSession.modificationCount and currentSession.creators then
					local inSessionPlayers = {}
					for k, v in pairs(currentSession.creators) do
						inSessionPlayers[#inSessionPlayers + 1] = { playerId = v.playerId, playerName = v.playerName }
					end
					if #inSessionPlayers >= 2 then
						table.sort(inSessionPlayers, function(a, b)
							return string.lower(a.playerName) < string.lower(b.playerName)
						end)
					end
					TriggerClientEvent("custom_creator:client:info", playerId, "track-download", #json.encode(currentSession.data) * 1.02)
					callback(currentSession.data, currentSession.modificationCount, inSessionPlayers)
					return
				end
			end
			CreatorServer.Sessions[raceid] = {
				sessionId = raceid,
				creators = { { playerId = playerId, identifier = identifier, playerName = playerName } },
				data = nil,
				modificationCount = {
					title = 0,
					thumbnail = 0,
					test_vehicle = 0,
					available_vehicles = 0,
					blimp_text = 0,
					transformVehicles = 0,
					startingGrid = 0,
					checkpoints = 0,
					fixtures = 0,
					firework = 0
				}
			}
			path = query[1].route_file
			thumbnail = query[1].route_image
			category = query[1].category
			published = query[1].published ~= "x"
			if path then
				local data = json.decode(LoadResourceFile(string.find(path, "custom_files") and GetCurrentResourceName() or "custom_races", path))
				if data then
					data.raceid = raceid
					data.published = published
					data.thumbnail = thumbnail
					if category ~= "Custom" then
						data.mission.gen.ownerid = category
					end
					data.mission.gen.nm = path:match("([^/]+)%.json$")
					data.contributors = nil
					if CreatorServer.Creators[playerId] then
						TriggerClientEvent("custom_creator:client:info", playerId, "track-download", #json.encode(data) * 1.02)
						callback(data)
						return
					end
				end
			end
		end
	end
	CreatorServer.Sessions[raceid] = nil
	callback(false)
end)

CreateServerCallback("custom_creator:server:getUGC", function(player, callback, url, ugc_img, ugc_json)
	if not string.find(url, "^https://prod%.cloud%.rockstargames%.com/ugc/gta5mission/") then
		callback(false)
		return
	end
	local playerId = player.src
	local playerName = player.name
	CreatorServer.SearchStatus[playerId] = "querying"
	if ugc_json then
		FindValidJson(url, "", 0, 99, playerId, function(data)
			if data then
				if data.mission and data.mission.gen then
					data.mission.gen.ownerid = playerName
				end
				TriggerClientEvent("custom_creator:client:info", playerId, "track-download", #json.encode(data) * 1.02)
				callback(data)
			else
				CreatorServer.SearchStatus[playerId] = nil
				callback(false)
			end
		end)
	elseif ugc_img then
		local lang = {"en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"}
		local path = url:match("(.-)/[^/]+$")
		local found = false
		local attempt = 0
		local startTime = GetGameTimer()
		for i = 0, 2 do
			for j = 0, 500 do
				for k = 1, 13 do
					if GetGameTimer() - startTime > 10000 then
						startTime = GetGameTimer()
						if CreatorServer.SearchStatus[playerId] then
							TriggerClientEvent("custom_creator:client:info", playerId, "ugc-wait", attempt)
						end
					end
					local json_url = path .. "/" .. i .. "_" .. j .. "_" .. lang[k] .. ".json"
					local lock = true
					local retry = 0
					FindValidJson(json_url, url, attempt, retry, playerId, function(data, bool, _attempt)
						found = bool
						attempt = _attempt
						lock = false
						if data then
							if data.mission and data.mission.gen then
								data.mission.gen.ownerid = playerName
							end
							TriggerClientEvent("custom_creator:client:info", playerId, "track-download", #json.encode(data) * 1.02)
							callback(data)
						end
					end)
					while lock do Citizen.Wait(0) end
					if found or not CreatorServer.SearchStatus[playerId] then break end
				end
				if found or not CreatorServer.SearchStatus[playerId] then break end
			end
			if found or not CreatorServer.SearchStatus[playerId] then break end
		end
		if not found then
			CreatorServer.SearchStatus[playerId] = nil
			callback(false)
		end
	else
		callback(false)
	end
end)

CreateServerCallback("custom_creator:server:saveFile", function(player, callback, data, action)
	if not data or not action then return end
	local resourceName = GetCurrentResourceName()
	local currentSession = CreatorServer.Sessions[data.raceid]
	local playerId = player.src
	local playerName = player.name
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local identifier = identifier_license and identifier_license:gsub("license:", "")
	if identifier then
		local found = false
		local path = nil
		local og_license = nil
		local og_category = nil
		if data.raceid then
			local sql_result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = ?", {data.raceid})
			if sql_result and #sql_result > 0 then
				found = true
				path = sql_result[1].route_file
				local identifiers = json.decode(sql_result[1].license)
				if type(identifiers) == "table" then
					og_license = identifiers[1]
				else
					og_license = sql_result[1].license
				end
				og_category = sql_result[1].category
				local contributors = type(identifiers) == "table" and identifiers or (sql_result[1].license and {sql_result[1].license}) or {}
				if og_category == "Custom" and currentSession then
					local seen = {}
					for i = 1, #contributors do
						seen[contributors[i]] = true
					end
					for k, v in pairs(currentSession.creators) do
						if v.identifier and not seen[v.identifier] then
							seen[v.identifier] = true
							table.insert(contributors, v.identifier)
						end
					end
				end
				data.contributors = contributors
			end
		else
			data.contributors = {identifier}
		end
		local r_path = "/custom_files/" .. (og_license or identifier)
		local a_path = GetResourcePath(resourceName) .. r_path
		local continue = os and os.createdir and true or false
		if continue then
			local success, _error = os.createdir(a_path)
			if not success and not string.find(string.lower(tostring(_error) or ""), "exist") and string.find(string.lower(tostring(_error) or ""), "failed") then
				continue = false
			end
		end
		if not continue then
			print("Failed to save ^1" .. data.mission.gen.nm .. "^0. Please update the ^2server artifact^0")
			print("More info: https://docs.fivem.net/docs/developers/sandbox/")
			print("If you are on Linux, please contact cfx for support")
			callback("wrong-artifact", nil, nil)
			return
		end
		if path and string.find(path, "custom_files") and (path:match("([^/]+)%.json$") ~= data.mission.gen.nm) then
			os.remove(GetResourcePath(resourceName) .. path)
		end
		if not found then
			if action == "publish" or action == "save" then
				local published = action == "publish"
				MySQL.insert("INSERT INTO custom_race_list (route_file, route_image, category, besttimes, published, updated_time, license) VALUES (?, ?, ?, ?, ?, ?, ?)",
				{
					r_path .. "/" .. data.mission.gen.nm .. ".json",
					data.thumbnail,
					"Custom",
					"[]",
					published and "√" or "x",
					os.date("%Y/%m/%d %H:%M:%S", os.time()),
					json.encode(data.contributors)
				}, function(result)
					if result then
						data.raceid = result
						data.published = published
						data.mission.gen.ownerid = playerName
						SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
						if published and GetResourceState("custom_races") == "started" then
							TriggerEvent("custom_races:server:updateAllRace")
						end
						callback("success", result, data.mission.gen.ownerid)
					else
						callback(nil, nil, nil)
					end
				end)
			else
				print("Failed to query the database when updating the map")
				callback(nil, nil, nil)
			end
		else
			local published = action == "publish" or action == "update"
			MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ?, license = ? WHERE raceid = ?",
			{
				r_path .. "/" .. data.mission.gen.nm .. ".json",
				data.thumbnail,
				published and "√" or "x",
				os.date("%Y/%m/%d %H:%M:%S", os.time()),
				json.encode(data.contributors),
				data.raceid
			}, function(result)
				if result then
					data.published = published
					if og_category == "Custom" and (identifier == og_license) then
						data.mission.gen.ownerid = playerName
					end
					SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
					if (published or action == "cancel") and GetResourceState("custom_races") == "started" then
						TriggerEvent("custom_races:server:updateAllRace")
					end
					if currentSession then
						for k, v in pairs(currentSession.creators) do
							if v.playerId ~= playerId then
								TriggerClientEvent("custom_creator:client:syncData", v.playerId, { published = published and "√" or "x", action = action }, "published-status", playerName)
							end
						end
						currentSession.data.published = published
					end
					callback("success", data.raceid, data.mission.gen.ownerid)
				else
					callback(nil, nil, nil)
				end
			end)
		end
	else
		print(playerName .. " does not have a valid license")
		callback(nil, nil, nil)
	end
end)

CreateServerCallback("custom_creator:server:exportFile", function(player, callback, data)
	if not data or (CreatorServer.Webhook == "") then callback("failed") return end
	local playerId = player.src
	local playerName = player.name
	local identifier_discord = GetPlayerIdentifierByType(playerId, "discord")
	local discordId = identifier_discord and identifier_discord:gsub("discord:", "")
	local currentSession = CreatorServer.Sessions[data.raceid]
	if currentSession then
		for k, v in pairs(currentSession.creators) do
			if v.playerId ~= playerId then
				TriggerClientEvent("custom_creator:client:syncData", v.playerId, { published = currentSession.data.published and "√" or "x", action = "export" }, "published-status", playerName)
			end
		end
	end
	data.raceid = nil
	data.published = nil
	data.thumbnail = nil
	data.test_vehicle = nil
	data.firework = nil
	data.mission.gen.ownerid = playerName
	data.mission.dprop.collision = nil
	data.mission.prop.collision = nil
	for i = 1, #data.mission.race.cptrtt do
		data.mission.race.cptrtt[i] = data.mission.race.cptrtt[i] >= 0 and data.mission.race.cptrtt[i] or 0
	end
	data.mission.race.cptrst = nil
	for i = 1, #data.mission.race.cptrtts do
		data.mission.race.cptrtts[i] = data.mission.race.cptrtts[i] >= 0 and data.mission.race.cptrtts[i] or 0
	end
	data.mission.race.cptrsts = nil
	ExportFileToWebhook(data, discordId, function(statusCode)
		if statusCode == 200 then
			callback("success")
		else
			callback("failed")
		end
	end)
end)