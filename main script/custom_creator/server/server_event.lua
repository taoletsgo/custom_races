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
		[1] = {
			class = "published-races",
			data = {}
		},
		[2] = {
			class = "saved-races",
			data = {}
		}
	}
	local template = {}
	local isAdmin = false
	local result_admin = {}
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		local query = MySQL.query.await("SELECT `group`, race_creator FROM custom_race_users WHERE license = ?", {identifier})
		if query and query[1] then
			isAdmin = query[1].group == "admin"
			template = json.decode(query[1].race_creator) or {}
		end
		local count = 0
		for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list")) do
			if identifier == v.license then
				local data = {
					name = v.route_file:match("([^/]+)%.json$"),
					img = v.route_image,
					raceid = v.raceid
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
					raceid = v.raceid
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
	callback(result, template)
end)

CreateServerCallback('custom_creator:server:get_json', function(source, callback, id)
	local playerId = tonumber(source)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	local identifier = nil
	local isAdmin = false
	if identifier_license then
		identifier = identifier_license:gsub('license:', '')
		local result = MySQL.query.await("SELECT `group` FROM custom_race_users WHERE license = ?", {identifier})
		if result and result[1] then
			isAdmin = result[1].group == "admin"
		end
	end
	local path, raceid, published, category, thumbnail = nil, id, nil, nil, nil
	local query = MySQL.query.await("SELECT route_file, route_image, category, published, license FROM custom_race_list WHERE raceid = ?", {raceid})
	if query and query[1] then
		if (identifier == query[1].license) or isAdmin then
			path = query[1].route_file
			thumbnail = query[1].route_image
			category = query[1].category
			published = query[1].published ~= "x"
		end
	end
	if path then
		local data = json.decode(LoadResourceFile(string.find(string.lower(path), "custom_files") and GetCurrentResourceName() or "custom_races", path))
		if data then
			data.raceid = raceid
			data.published = published
			data.thumbnail = thumbnail
			if category ~= "Custom" then
				data.mission.gen.ownerid = category
			end
			data.mission.gen.nm = path:match("([^/]+)%.json$")
			callback(data)
		else
			callback(false)
		end
	else
		callback(false)
	end
end)

CreateServerCallback('custom_creator:server:get_ugc', function(source, callback, url, ugc_img, ugc_json)
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
						if ugc_json then
							findValidJson(url, "", 0, 99, playerId, function(data)
								if data then
									callback(data, true)
								else
									creator_status[playerId] = nil
									print("^7Failed to find a valid UGC ^3" .. url .. "^7")
									callback(false, true)
								end
							end)
						elseif ugc_img then
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
									creator_status[playerId] = nil
									print("^7Failed to find a valid UGC ^3" .. url .. "^7")
									callback(false, true)
								end
							end
						else
							callback(false, true)
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
				if ugc_json then
					findValidJson(url, "", 0, 99, playerId, function(data)
						if data then
							callback(data, true)
						else
							creator_status[playerId] = nil
							print("^7Failed to find a valid UGC ^3" .. url .. "^7")
							callback(false, true)
						end
					end)
				elseif ugc_img then
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
							creator_status[playerId] = nil
							print("^7Failed to find a valid UGC ^3" .. url .. "^7")
							callback(false, true)
						end
					end
				else
					callback(false, true)
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
							local path = nil
							local og_license = nil
							local og_category = nil
							if data.raceid then
								local sql_result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = data.raceid})
								if sql_result and #sql_result > 0 then
									found = true
									path = sql_result[1].route_file
									og_license = sql_result[1].license
									og_category = sql_result[1].category
								end
							end
							local r_path = "/custom_files/" .. (og_license or identifier)
							local a_path = GetResourcePath(resourceName) .. r_path
							if not os.rename(a_path, a_path) then
								if os and os.createdir then
									os.createdir(a_path)
								else
									local success, _error = os.execute("mkdir \"" .. a_path .. "\"")
									if not success or (_error == "Permission denied") then
										action = "wrong-artifact"
										print("Failed to save ^1" .. data.mission.gen.nm .. "^0. Please check if the ^2server artifact >= 13026 or <= 11895^0")
										print("More info: https://docs.fivem.net/docs/developers/sandbox/")
									end
								end
							end
							if path and string.find(string.lower(path), "custom_files") and (path:match("([^/]+)%.json$") ~= data.mission.gen.nm) and (action ~= "wrong-artifact") then
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
											data.mission.gen.ownerid = GetPlayerName(playerId)
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											if GetResourceState("custom_races") == "started" then
												TriggerEvent('custom_races:server:UpdateAllRace')
											end
											callback("success", result, data.mission.gen.ownerid)
										else
											callback(nil, nil, nil)
										end
									end)
								else
									MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ? WHERE raceid = ?",
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"√",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										data.raceid
									}, function(result)
										if result then
											data.published = true
											if og_category == "Custom" and (identifier == og_license) then
												data.mission.gen.ownerid = GetPlayerName(playerId)
											end
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											if GetResourceState("custom_races") == "started" then
												TriggerEvent('custom_races:server:UpdateAllRace')
											end
											callback("success", data.raceid, data.mission.gen.ownerid)
										else
											callback(nil, nil, nil)
										end
									end)
								end
							elseif action == "update" then
								if found then
									MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ? WHERE raceid = ?",
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"√",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										data.raceid
									}, function(result)
										if result then
											data.published = true
											if og_category == "Custom" and (identifier == og_license) then
												data.mission.gen.ownerid = GetPlayerName(playerId)
											end
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											if GetResourceState("custom_races") == "started" then
												TriggerEvent('custom_races:server:UpdateAllRace')
											end
											callback("success", data.raceid, data.mission.gen.ownerid)
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
											data.mission.gen.ownerid = GetPlayerName(playerId)
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											callback("success", result, data.mission.gen.ownerid)
										else
											callback(nil, nil, nil)
										end
									end)
								else
									MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ? WHERE raceid = ?",
									{
										r_path .. "/" .. data.mission.gen.nm .. ".json",
										data.thumbnail,
										"x",
										os.date("%Y/%m/%d %H:%M:%S", os.time()),
										data.raceid
									}, function(result)
										if result then
											data.published = false
											if og_category == "Custom" and (identifier == og_license) then
												data.mission.gen.ownerid = GetPlayerName(playerId)
											end
											SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
											callback("success", data.raceid, data.mission.gen.ownerid)
										else
											callback(nil, nil, nil)
										end
									end)
								end
							elseif action == "wrong-artifact" then
								callback("wrong-artifact", nil, nil)
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
					local path = nil
					local og_license = nil
					local og_category = nil
					if data.raceid then
						local sql_result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = data.raceid})
						if sql_result and #sql_result > 0 then
							found = true
							path = sql_result[1].route_file
							og_license = sql_result[1].license
							og_category = sql_result[1].category
						end
					end
					local r_path = "/custom_files/" .. (og_license or identifier)
					local a_path = GetResourcePath(resourceName) .. r_path
					if not os.rename(a_path, a_path) then
						if os and os.createdir then
							os.createdir(a_path)
						else
							local success, _error = os.execute("mkdir \"" .. a_path .. "\"")
							if not success or (_error == "Permission denied") then
								action = "wrong-artifact"
								print("Failed to save ^1" .. data.mission.gen.nm .. "^0. Please check if the ^2server artifact >= 13026 or <= 11895^0")
								print("More info: https://docs.fivem.net/docs/developers/sandbox/")
							end
						end
					end
					if path and string.find(string.lower(path), "custom_files") and (path:match("([^/]+)%.json$") ~= data.mission.gen.nm) and (action ~= "wrong-artifact") then
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
									data.mission.gen.ownerid = GetPlayerName(playerId)
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									if GetResourceState("custom_races") == "started" then
										TriggerEvent('custom_races:server:UpdateAllRace')
									end
									callback("success", result, data.mission.gen.ownerid)
								else
									callback(nil, nil, nil)
								end
							end)
						else
							MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ? WHERE raceid = ?",
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"√",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								data.raceid
							}, function(result)
								if result then
									data.published = true
									if og_category == "Custom" and (identifier == og_license) then
										data.mission.gen.ownerid = GetPlayerName(playerId)
									end
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									if GetResourceState("custom_races") == "started" then
										TriggerEvent('custom_races:server:UpdateAllRace')
									end
									callback("success", data.raceid, data.mission.gen.ownerid)
								else
									callback(nil, nil, nil)
								end
							end)
						end
					elseif action == "update" then
						if found then
							MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ? WHERE raceid = ?",
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"√",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								data.raceid
							}, function(result)
								if result then
									data.published = true
									if og_category == "Custom" and (identifier == og_license) then
										data.mission.gen.ownerid = GetPlayerName(playerId)
									end
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									if GetResourceState("custom_races") == "started" then
										TriggerEvent('custom_races:server:UpdateAllRace')
									end
									callback("success", data.raceid, data.mission.gen.ownerid)
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
									data.mission.gen.ownerid = GetPlayerName(playerId)
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									callback("success", result, data.mission.gen.ownerid)
								else
									callback(nil, nil, nil)
								end
							end)
						else
							MySQL.update("UPDATE custom_race_list SET route_file = ?, route_image = ?, published = ?, updated_time = ? WHERE raceid = ?",
							{
								r_path .. "/" .. data.mission.gen.nm .. ".json",
								data.thumbnail,
								"x",
								os.date("%Y/%m/%d %H:%M:%S", os.time()),
								data.raceid
							}, function(result)
								if result then
									data.published = false
									if og_category == "Custom" and (identifier == og_license) then
										data.mission.gen.ownerid = GetPlayerName(playerId)
									end
									SaveResourceFile(resourceName, r_path .. "/" .. data.mission.gen.nm .. ".json", json.encode(data), -1)
									callback("success", data.raceid, data.mission.gen.ownerid)
								else
									callback(nil, nil, nil)
								end
							end)
						end
					elseif action == "wrong-artifact" then
						callback("wrong-artifact", nil, nil)
					end
				else
					callback("denied", nil, nil)
				end
			end
		else
			print(GetPlayerName(playerId) .. "does not have a valid license")
			callback(nil, nil, nil)
		end
	else
		print(GetPlayerName(playerId) .. " is cheating")
		callback(nil, nil, nil)
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
				if data then
					data.published = false
					SaveResourceFile(GetCurrentResourceName(), path, json.encode(data), -1)
				end
				callback(true)
			else
				callback(false)
			end
		end)
	end
end)