RegisterNetEvent('custom_creator:server:save_template', function(data)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		local results = MySQL.query.await("SELECT race_creator FROM custom_race_users WHERE license = ?", {identifier})
		if results and results[1] then
			MySQL.update("UPDATE custom_race_users SET name = ?, race_creator = ? WHERE license = ?", {playerName, json.encode(data), identifier})
		else
			MySQL.insert('INSERT INTO custom_race_users (license, name, race_creator) VALUES (?, ?, ?)', {identifier, playerName, json.encode(data)})
		end
	end
end)

RegisterNetEvent('custom_creator:server:cancel', function()
	local playerId = tonumber(source)
	creator_status[playerId] = nil
end)

AddEventHandler('playerDropped', function()
	local playerId = tonumber(source)
	creator_status[playerId] = nil
end)

CreateServerCallback('custom_creator:server:check_title', function(source, callback, title)
	local found = false
	for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
		if v.route_file:match("([^/]+)%.json$") == title then
			found = true
			break
		end
	end
	callback(not found)
end)

CreateServerCallback('custom_creator:server:get_list', function(source, callback)
	local playerId = tonumber(source)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	local result = {
		["published-races"] = {},
		["saved-races"] = {}
	}
	local template = {}
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
			if identifier == v.license then
				local data = {
					name = v.route_file:match("([^/]+)%.json$"),
					img = v.route_image
				}
				if v.published == "√" then
					table.insert(result["published-races"], data)
				else
					table.insert(result["saved-races"], data)
				end
			end
		end
		if #result["published-races"] >= 2 then
			table.sort(result["published-races"], function(a, b)
				return string.lower(a.name) < string.lower(b.name)
			end)
		end
		if #result["saved-races"] >= 2 then
			table.sort(result["saved-races"], function(a, b)
				return string.lower(a.name) < string.lower(b.name)
			end)
		end
		local query = MySQL.query.await("SELECT race_creator FROM custom_race_users WHERE license = ?", {identifier})
		if query and query[1] then
			template = json.decode(query[1].race_creator) or {}
		end
	end
	callback(result, template)
end)

CreateServerCallback('custom_creator:server:get_json', function(source, callback, title)
	local playerId = tonumber(source)
	local path, raceid, published, owner_name, thumbnail = nil, nil, nil, nil, nil

	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
			if v.route_file:match("([^/]+)%.json$") == title and identifier == v.license then
				path = v.route_file
				raceid = v.raceid
				published = v.published == "√"
				owner_name = GetPlayerName(playerId)
				thumbnail = v.route_image
				break
			end
		end
	end
	if path then
		local data = json.decode(LoadResourceFile(GetCurrentResourceName(), path))
		if data then
			data.raceid = raceid
			data.published = published
			data.thumbnail = thumbnail
			data.mission.gen.ownerid = owner_name
			data.mission.gen.nm = title
			callback(data)
		else
			callback(false)
		end
	else
		callback(false)
	end
end)

CreateServerCallback('custom_creator:server:get_ugc', function(source, callback, url)
	local playerId = tonumber(source)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		if Config.Discord.enable then
			local identifier_discord = GetPlayerIdentifierByType(playerId, 'discord')
			if identifier_discord then
				local discordId = identifier_discord:gsub('discord:', '')
				CheckUserRole(discordId, function(bool)
					if bool then
						creator_status[playerId] = "querying"
						print("^5" .. GetPlayerName(playerId) .. "^7 is querying UGC ^3" .. url .. "^7")
						local lang = {"en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"}
						local path = url:match("(.-)/[^/]+$")
						local found = false
						local attempt = 0
						local startTime = GetGameTimer()
						for i = 0, 2 do
							if found or not creator_status[playerId] then break end
							for j = 0, 500 do
								if found or not creator_status[playerId] then break end
								for k = 1, 13 do
									if found or not creator_status[playerId] then break end
									if GetGameTimer() - startTime > 10000 then
										startTime = GetGameTimer()
										if GetPlayerName(playerId) then
											TriggerClientEvent("custom_creator:info", playerId, "ugc-wait", attempt)
										end
									end
									local data = {}
									local json_url = path .. "/" .. i .. "_" .. j .. "_" .. lang[k] .. ".json"
									local lock = true
									local retry = 0
									findValidJson(json_url, url, attempt, retry, playerId, function(data, bool, _attempt)
										found = bool
										attempt = _attempt
										lock = false
										if data then
											callback(data, true)
										end
									end)
									while lock do Citizen.Wait(0) end
								end
							end
						end
						if GetPlayerName(playerId) and not found then
							if not creator_status[playerId] then
								callback(false, true)
							else
								print("^7Failed to find a valid UGC ^3" .. url .. "^7")
								callback(false, true)
							end
						end
					else
						callback(false, false)
					end
				end)
			else
				callback(false, false)
			end
		else
			local hasPermission = false
			for _, role_permission in pairs(Config.Discord.whitelist_license) do
				if identifier_license == role_permission then
					hasPermission = true
					break
				end
			end
			if hasPermission then
				creator_status[playerId] = "querying"
				print("^5" .. GetPlayerName(playerId) .. "^7 is querying UGC ^3" .. url .. "^7")
				local lang = {"en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"}
				local path = url:match("(.-)/[^/]+$")
				local found = false
				local attempt = 0
				local startTime = GetGameTimer()
				for i = 0, 2 do
					if found or not creator_status[playerId] then break end
					for j = 0, 500 do
						if found or not creator_status[playerId] then break end
						for k = 1, 13 do
							if found or not creator_status[playerId] then break end
							if GetGameTimer() - startTime > 10000 then
								startTime = GetGameTimer()
								if GetPlayerName(playerId) then
									TriggerClientEvent("custom_creator:info", playerId, "ugc-wait", attempt)
								end
							end
							local data = {}
							local json_url = path .. "/" .. i .. "_" .. j .. "_" .. lang[k] .. ".json"
							local lock = true
							local retry = 0
							findValidJson(json_url, url, attempt, retry, playerId, function(data, bool, _attempt)
								found = bool
								attempt = _attempt
								lock = false
								if data then
									callback(data, true)
								end
							end)
							while lock do Citizen.Wait(0) end
						end
					end
				end
				if GetPlayerName(playerId) and not found then
					if not creator_status[playerId] then
						callback(false, true)
					else
						print("^7Failed to find a valid UGC ^3" .. url .. "^7")
						callback(false, true)
					end
				end
			else
				callback(false, false)
			end
		end
	else
		callback(false, false)
	end
end)

CreateServerCallback('custom_creator:server:save_file', function(source, callback, data, action)
	local playerId = tonumber(source)
	if data and data.mission and data.mission.gen and action then
		local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
		local resourceName = GetCurrentResourceName()
		if identifier_license then
			local identifier = identifier_license:gsub('license:', '')
			if Config.Discord.enable then
				local identifier_discord = GetPlayerIdentifierByType(playerId, 'discord')
				if identifier_discord then
					local discordId = identifier_discord:gsub('discord:', '')
					CheckUserRole(discordId, function(bool)
						if bool then
							local found = false
							local r_path = "/custom_files/" .. identifier
							local a_path = GetResourcePath(resourceName) .. r_path
							local path = nil
							data.mission.gen.ownerid = GetPlayerName(playerId)
							if not os.rename(a_path, a_path) then
								-- Due to the sandboxing of lua, I am not sure whether os.rename and os.remove will be invalid in the future, so now I have rewritten it only for os.execute
								-- Test on artifact 12911
								-- More info: https://docs.fivem.net/docs/developers/sandbox/
								CreateUserPath("mkdir \"" .. a_path .. "\"")
							end
							if data.raceid then
								local sql_result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = data.raceid})
								if sql_result and #sql_result > 0 then
									path = sql_result[1].route_file
									found = true
								end
							end
							if path and (path:match("([^/]+)%.json$") ~= data.mission.gen.nm) then
								os.remove(GetResourcePath(resourceName) .. path)
							end
							if action == "publish" then
								if not found then
									MySQL.insert('INSERT INTO custom_race_list (route_file, route_image, category, besttimes, published, updated_time, license) VALUES (?, ?, ?, ?, ?, ?, ?)',
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"Custom",
										'[]',
										"√",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										identifier
									}, function(result)
										if result then
											data.raceid = result
											data.published = true
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											if GetResourceState("custom_races") == "started" then
												TriggerEvent('custom_races:server:UpdateAllRace')
											end
											callback("success", result, GetPlayerName(playerId))
										else
											callback(nil, nil, nil)
										end
									end)
								else
									MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ?, license = ? WHERE raceid = ?",
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"√",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										identifier,
										data.raceid
									}, function(result)
										if result then
											data.published = true
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											if GetResourceState("custom_races") == "started" then
												TriggerEvent('custom_races:server:UpdateAllRace')
											end
											callback("success", data.raceid, GetPlayerName(playerId))
										else
											callback(nil, nil, nil)
										end
									end)
								end
							elseif action == "update" then
								if found then
									MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ?, license = ? WHERE raceid = ?",
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"√",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										identifier,
										data.raceid
									}, function(result)
										if result then
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											if GetResourceState("custom_races") == "started" then
												TriggerEvent('custom_races:server:UpdateAllRace')
											end
											callback("success", data.raceid, GetPlayerName(playerId))
										else
											callback(nil, nil, nil)
										end
									end)
								else
									print("Failed to query the database when updating the map")
									callback(nil, nil, nil)
								end
							elseif action == "save" then
								if not found then
									MySQL.insert('INSERT INTO custom_race_list (route_file, route_image, category, besttimes, published, updated_time, license) VALUES (?, ?, ?, ?, ?, ?, ?)',
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"Custom",
										'[]',
										"x",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										identifier
									}, function(result)
										if result then
											data.raceid = result
											data.published = false
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											callback("success", result, GetPlayerName(playerId))
										else
											callback(nil, nil, nil)
										end
									end)
								else
									MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ?, license = ? WHERE raceid = ?",
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"x",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										identifier,
										data.raceid
									}, function(result)
										if result then
											data.published = false
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											callback("success", data.raceid, GetPlayerName(playerId))
										else
											callback(nil, nil, nil)
										end
									end)
								end
							end
						else
							callback("denied", nil, nil)
						end
					end)
				else
					callback("no discord", nil, nil)
				end
			else
				local hasPermission = false
				for _, role_permission in pairs(Config.Discord.whitelist_license) do
					if identifier_license == role_permission then
						hasPermission = true
						break
					end
				end
				if hasPermission then
					local found = false
					local r_path = "/custom_files/" .. identifier
					local a_path = GetResourcePath(resourceName) .. r_path
					local path = nil
					data.mission.gen.ownerid = GetPlayerName(playerId)
					if not os.rename(a_path, a_path) then
						-- Due to the sandboxing of lua, I am not sure whether os.rename and os.remove will be invalid in the future, so now I have rewritten it only for os.execute
						-- Test on artifact 12911
						-- More info: https://docs.fivem.net/docs/developers/sandbox/
						CreateUserPath("mkdir \"" .. a_path .. "\"")
					end
					if data.raceid then
						local sql_result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = data.raceid})
						if sql_result and #sql_result > 0 then
							path = sql_result[1].route_file
							found = true
						end
					end
					if path and (path:match("([^/]+)%.json$") ~= data.mission.gen.nm) then
						os.remove(GetResourcePath(resourceName) .. path)
					end
					if action == "publish" then
						if not found then
							MySQL.insert('INSERT INTO custom_race_list (route_file, route_image, category, besttimes, published, updated_time, license) VALUES (?, ?, ?, ?, ?, ?, ?)',
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"Custom",
								'[]',
								"√",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								identifier
							}, function(result)
								if result then
									data.raceid = result
									data.published = true
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									if GetResourceState("custom_races") == "started" then
										TriggerEvent('custom_races:server:UpdateAllRace')
									end
									callback("success", result, GetPlayerName(playerId))
								else
									callback(nil, nil, nil)
								end
							end)
						else
							MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ?, license = ? WHERE raceid = ?",
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"√",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								identifier,
								data.raceid
							}, function(result)
								if result then
									data.published = true
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									if GetResourceState("custom_races") == "started" then
										TriggerEvent('custom_races:server:UpdateAllRace')
									end
									callback("success", data.raceid, GetPlayerName(playerId))
								else
									callback(nil, nil, nil)
								end
							end)
						end
					elseif action == "update" then
						if found then
							MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ?, license = ? WHERE raceid = ?",
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"√",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								identifier,
								data.raceid
							}, function(result)
								if result then
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									if GetResourceState("custom_races") == "started" then
										TriggerEvent('custom_races:server:UpdateAllRace')
									end
									callback("success", data.raceid, GetPlayerName(playerId))
								else
									callback(nil, nil, nil)
								end
							end)
						else
							print("Failed to query the database when updating the map")
							callback(nil, nil, nil)
						end
					elseif action == "save" then
						if not found then
							MySQL.insert('INSERT INTO custom_race_list (route_file, route_image, category, besttimes, published, updated_time, license) VALUES (?, ?, ?, ?, ?, ?, ?)',
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"Custom",
								'[]',
								"x",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								identifier
							}, function(result)
								if result then
									data.raceid = result
									data.published = false
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									callback("success", result, GetPlayerName(playerId))
								else
									callback(nil, nil, nil)
								end
							end)
						else
							MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ?, license = ? WHERE raceid = ?",
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"x",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								identifier,
								data.raceid
							}, function(result)
								if result then
									data.published = false
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									callback("success", data.raceid, GetPlayerName(playerId))
								else
									callback(nil, nil, nil)
								end
							end)
						end
					end
				else
					callback("denied", nil, nil)
				end
			end
		else
			print(GetPlayerName(playerId) .. "does not have a valid license")
		end
	else
		print(GetPlayerName(playerId) .. " is cheating")
	end
end)

CreateServerCallback('custom_creator:server:cancel_publish', function(source, callback, raceid)
	local playerId = tonumber(source)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	if identifier_license and raceid then
		local identifier = identifier_license:gsub('license:', '')
		MySQL.update("UPDATE custom_race_list SET published = ?, updated_time = ? WHERE raceid = ?",
		{
			"x",
			os.date("%Y/%m/%d %H:%M:%S", os.time()),
			raceid
		}, function(result)
			if result then
				if GetResourceState("custom_races") == "started" then
					TriggerEvent('custom_races:server:UpdateAllRace')
				end
				local path = nil
				local result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = raceid})
				if result and #result > 0 then
					path = result[1].route_file
				end
				local data = json.decode(LoadResourceFile(GetCurrentResourceName(), path))
				data.published = false
				SaveResourceFile(GetCurrentResourceName(), path, json.encode(data), -1)
				callback(true)
			else
				callback(false)
			end
		end)
	end
end)