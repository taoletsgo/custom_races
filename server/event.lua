RegisterNetEvent("server:core:init", function()
	local playerId = tonumber(source)
	TriggerLatentClientEvent("client:core:init", playerId, 65536)
end)

RegisterNetEvent("server:core:loaded", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.loaded = true
	end
end)

RegisterNetEvent("server:core:setFlag", function(clientLanguage)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local flags = {"US", "FR", "DE", "IT", "ES", "BR", "PL", "RU", "KR", "TW", "JP", "MX", "CN"}
		local flagsAll = {"AC", "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ-BO", "BQ-SA", "BQ-SE", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES-CT", "ES", "ET", "EU", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB-ENG", "GB-NIR", "GB-SCT", "GB-WLS", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", "IC", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TA", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "XA", "XC", "XK", "XO", "YE", "YT", "ZA", "ZM", "ZW"}
		if currentPlayer.ip then
			PerformHttpRequest("http://ip-api.com/json/" .. currentPlayer.ip, function(statusCode, response, headers)
				local flag = nil
				if statusCode == 200 then
					local data = json.decode(response)
					if data and data.countryCode then
						for i = 1, #flagsAll do
							if flagsAll[i] == data.countryCode then
								flag = data.countryCode
								break
							end
						end
					end
				end
				currentPlayer.flag = flag or flags[clientLanguage + 1] or "US"
			end, "GET", "", {["Content-Type"] = "application/json"})
		else
			currentPlayer.flag = flags[clientLanguage + 1] or "US"
		end
	end
end)

RegisterNetEvent("server:core:inRace", function(bool)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.inRace = bool
	end
end)

RegisterNetEvent("server:core:inCreator", function(bool)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.inCreator = bool
	end
end)

RegisterNetEvent("server:core:inTestMode", function(bool)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.inTestMode = bool
	end
end)

RegisterNetEvent("server:core:inSpectator", function(bool)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.inSpectator = bool
	end
end)

RegisterNetEvent("server:core:spawnEntity", function(netId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.entitys[#currentPlayer.entitys + 1 ] = netId
	end
end)

RegisterNetEvent("server:core:deleteEntity", function(netId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		for k, v in pairs(currentPlayer.entitys) do
			if netId == v then
				table.remove(currentPlayer.entitys, k)
				break
			end
		end
		local entity = NetworkGetEntityFromNetworkId(netId)
		if DoesEntityExist(entity) then
			DeleteEntity(entity)
		end
	end
end)

RegisterNetEvent("server:core:deleteAllEntitys", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		for k, v in pairs(currentPlayer.entitys) do
			local entity = NetworkGetEntityFromNetworkId(v)
			if DoesEntityExist(entity) then
				DeleteEntity(entity)
			end
		end
		currentPlayer.entitys = {}
	end
end)

RegisterNetEvent("server:core:saveVehicle", function(data, flag)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and data and flag then
		if flag == 3 and type(data) == "table" then
			local exist = false
			for k, v in pairs(currentPlayer.vehicles.saved) do
				if v.plate == data.newPlate then
					exist = true
					break
				end
			end
			if not exist then
				for k, v in pairs(currentPlayer.vehicles.saved) do
					if v.plate == data.oldPlate then
						v.plate = data.newPlate
						break
					end
				end
			end
		elseif flag == 2 and type(data) == "table" then
			for k, v in pairs(currentPlayer.vehicles.saved) do
				if v.plate == data.plate then
					currentPlayer.vehicles.saved[k] = data
					break
				end
			end
		elseif flag == 1 and type(data) == "table" then
			if #currentPlayer.vehicles.saved < Config.Default.MaxSlots.Vehicle then
				local exist = false
				for k, v in pairs(currentPlayer.vehicles.saved) do
					if v.plate == data.plate then
						exist = true
						break
					end
				end
				if not exist then
					table.insert(currentPlayer.vehicles.saved, data)
				end
			end
		elseif flag == 0 and (type(data) == "number" or type(data) == "string") then
			for k, v in pairs(currentPlayer.vehicles.saved) do
				if v.plate == data then
					table.remove(currentPlayer.vehicles.saved, k)
					break
				end
			end
		end
		local result = MySQL.query.await("SELECT vehicles FROM users WHERE license = ?", {currentPlayer.license})
		if result and result[1] then
			MySQL.update("UPDATE users SET name = ?, vehicles = ? WHERE license = ?", {currentPlayer.name, json.encode(currentPlayer.vehicles), currentPlayer.license})
		else
			MySQL.insert("INSERT INTO users (license, name, vehicles) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(currentPlayer.vehicles)})
		end
	end
end)

RegisterNetEvent("server:core:saveSkin", function(index, data, hash)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and (index or hash) then
		if hash then
			currentPlayer.skin.hash = hash ~= 0 and hash or nil
		elseif index and type(index) == "number" then
			if index >= 1 and index <= Config.Default.MaxSlots.Skin then
				currentPlayer.skin.data[index] = data or currentPlayer.skin.data[index] or {}
				currentPlayer.skin.index = index
				currentPlayer.skin.hash = nil
			end
		end
		local result = MySQL.query.await("SELECT skin FROM users WHERE license = ?", {currentPlayer.license})
		if result and result[1] then
			MySQL.update("UPDATE users SET name = ?, skin = ? WHERE license = ?", {currentPlayer.name, json.encode(currentPlayer.skin), currentPlayer.license})
		else
			MySQL.insert("INSERT INTO users (license, name, skin) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(currentPlayer.skin)})
		end
	end
end)

RegisterNetEvent("server:core:saveWeapon", function(data)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and data and type(data) == "table" then
		for i = 1, #data do
			local weaponName = data[i].weaponName
			local weaponData = data[i].weaponData
			if weaponName and weaponData then
				currentPlayer.weapons[weaponName] = weaponData
			end
		end
		local result = MySQL.query.await("SELECT weapons FROM users WHERE license = ?", {currentPlayer.license})
		if result and result[1] then
			MySQL.update("UPDATE users SET name = ?, weapons = ? WHERE license = ?", {currentPlayer.name, json.encode(currentPlayer.weapons), currentPlayer.license})
		else
			MySQL.insert("INSERT INTO users (license, name, weapons) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(currentPlayer.weapons)})
		end
	end
end)

RegisterNetEvent("server:core:preferences", function(data)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and data and type(data) == "table" then
		for key, value in pairs(data) do
			if Config.Default.Preferences[key] ~= nil then
				currentPlayer.preferences[key] = value and 1 or 0
			end
		end
		if currentPlayer.preferences.Traffic == 0 then
			currentPlayer.disableTraffic = true
		elseif currentPlayer.preferences.Traffic == 1 then
			currentPlayer.disableTraffic = false
		end
		local result = MySQL.query.await("SELECT preferences FROM users WHERE license = ?", {currentPlayer.license})
		if result and result[1] then
			MySQL.update("UPDATE users SET name = ?, preferences = ? WHERE license = ?", {currentPlayer.name, json.encode(currentPlayer.preferences), currentPlayer.license})
		else
			MySQL.insert("INSERT INTO users (license, name, preferences) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(currentPlayer.preferences)})
		end
	end
end)

RegisterNetEvent("server:core:setConvar", function(convarName, convarValue)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and Server.Function.Player.CheckPermission(currentPlayer.group, currentPlayer.role).SetConvar and type(convarName) == "string" and type(convarValue) == "string" then
		if Config.Default.Convar[convarName] then
			SetConvar(convarName, convarValue)
		elseif Config.Default.ConvarReplicated[convarName] then
			SetConvarReplicated(convarName, convarValue)
		end
	end
end)

CreateServerCallback("server:core:getMyData", function(currentPlayer, callback, refresh)
	local isChecking = false
	local result = MySQL.query.await("SELECT * FROM users WHERE license = ?", {currentPlayer.license})
	if result and result[1] then
		local group = result[1].group
		if type(group) == "string" then
			currentPlayer.group = group
		end
		local race = json.decode(result[1].race)
		if type(race) == "table" then
			if type(race.bookmarked) == "table" then
				currentPlayer.race.bookmarked = race.bookmarked
			end
			if type(race.played) == "table" then
				currentPlayer.race.played = race.played
			end
			if type(race.finished) == "table" then
				currentPlayer.race.finished = race.finished
			end
		end
		local creator = json.decode(result[1].creator)
		if type(creator) == "table" then
			if type(creator.favorite) == "table" then
				currentPlayer.creator.favorite = creator.favorite
			end
			if type(creator.templates) == "table" then
				currentPlayer.creator.templates = creator.templates
			end
		end
		local position = json.decode(result[1].position)
		if type(position) == "table" then
			if type(position.x) == "number" then
				currentPlayer.position.x = position.x
			end
			if type(position.y) == "number" then
				currentPlayer.position.y = position.y
			end
			if type(position.z) == "number" then
				currentPlayer.position.z = position.z
			end
			if type(position.heading) == "number" then
				currentPlayer.position.heading = position.heading
			end
		end
		local skin = json.decode(result[1].skin)
		if type(skin) == "table" then
			if type(skin.data) == "table" then
				currentPlayer.skin.data = skin.data
			end
			if type(skin.index) == "number" then
				currentPlayer.skin.index = skin.index
			end
			if type(skin.hash) == "number" then
				currentPlayer.skin.hash = skin.hash
			end
		end
		local weapons = json.decode(result[1].weapons)
		if type(weapons) == "table" then
			currentPlayer.weapons = weapons
		end
		local vehicles = json.decode(result[1].vehicles)
		if type(vehicles) == "table" then
			if type(vehicles.favorite) == "table" then
				currentPlayer.vehicles.favorite = vehicles.favorite
			end
			if type(vehicles.saved) == "table" then
				currentPlayer.vehicles.saved = vehicles.saved
			end
		end
		local preferences = json.decode(result[1].preferences)
		if type(preferences) == "table" then
			for key, _ in pairs(preferences) do
				if Config.Default.Preferences[key] == nil then
					preferences[key] = nil
				end
			end
			currentPlayer.preferences = preferences
		end
	end
	if Config.Discord.Enable and currentPlayer.discord then
		isChecking = true
		Server.Function.Player.GetDiscordInfo(currentPlayer.discord, function(role, color, logo)
			currentPlayer.role = role
			currentPlayer.color = color
			currentPlayer.logo = logo
			isChecking = false
		end)
	end
	while isChecking do Wait(0) end
	for key, bool in pairs(Config.Default.Preferences) do
		if currentPlayer.preferences[key] == nil then
			currentPlayer.preferences[key] = bool and 1 or 0
		end
	end
	if currentPlayer.preferences.Traffic == 0 then
		currentPlayer.disableTraffic = true
	elseif currentPlayer.preferences.Traffic == 1 then
		currentPlayer.disableTraffic = false
	end
	callback(currentPlayer.id, Server.Function.Player.CheckPermission(currentPlayer.group, currentPlayer.role), {
		Logo = currentPlayer.logo,
		Name = not refresh and currentPlayer.name,
		Info = not refresh and Config.ServerInfo,
		Count = not refresh and Server.PlayerCount,
		Ping = not refresh and GetPlayerPing(currentPlayer.id),
		Race = not refresh and currentPlayer.race,
		Creator = not refresh and currentPlayer.creator,
		Position = not refresh and currentPlayer.position,
		Skin = not refresh and currentPlayer.skin,
		Weapon = not refresh and currentPlayer.weapons,
		Vehicle = not refresh and currentPlayer.vehicles,
		Preference = not refresh and currentPlayer.preferences,
		AddOn = not refresh and Config.AddOnModels,
		Slots = not refresh and Config.Default.MaxSlots,
		ScriptStartTime = not refresh and Server.ScriptStartTime
	})
end)

AddEventHandler("chatMessage", function(source, name, message)
	CancelEvent()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and message and message:sub(1, 1) ~= "/" then
		TriggerClientEvent("chat:addMessage", -1, {
			color = currentPlayer.color or {255, 255, 255},
			multiline = true,
			args = {currentPlayer.name, "📬 " .. message}
		})
	end
end)

AddEventHandler("playerJoining", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Function.Player.Init(playerId, GetPlayerName(playerId) or "unknown")
	print("Connecting: ^5" .. currentPlayer.name .. " #" .. currentPlayer.id .. "^0")
	print(string.format(Config.Discord.Webhook.Notification.PlayerJoining.Description, Server.PlayerCount, GetConvarInt("sv_maxclients", 48)))
	local result = MySQL.query.await("SELECT name FROM users WHERE license = ?", {currentPlayer.license})
	if result and result[1] then
		MySQL.update("UPDATE users SET name = ? WHERE license = ?", {currentPlayer.name, currentPlayer.license})
	else
		MySQL.insert("INSERT INTO users (license, name) VALUES (?, ?)", {currentPlayer.license, currentPlayer.name})
	end
	local message = {{
		title = string.format(Config.Discord.Webhook.Notification.PlayerJoining.Title["join"], currentPlayer.name),
		description = string.format(Config.Discord.Webhook.Notification.PlayerJoining.Description, Server.PlayerCount, GetConvarInt("sv_maxclients", 48)),
		color = Config.Discord.Webhook.Notification.PlayerJoining.Color
	}}
	Server.Function.Webhook.Notification({embeds = message}, currentPlayer.name)
	TriggerClientEvent("client:core:joining", -1, currentPlayer.name)
end)

AddEventHandler("playerDropped", function(reason)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		Server.PlayerCount = Server.PlayerCount - 1
		print("Player ^1" .. currentPlayer.name .. " #" .. currentPlayer.id .. "^0 dropped (Reason: ^3" .. reason .. "^0)")
		print(string.format(Config.Discord.Webhook.Notification.PlayerDropped.Description, Server.PlayerCount, GetConvarInt("sv_maxclients", 48)))
		if currentPlayer.loaded then
			local ped = GetPlayerPed(currentPlayer.id)
			if currentPlayer.license and ped ~= 0 then
				local coords = GetEntityCoords(ped)
				local heading = GetEntityHeading(ped)
				local position = {x = Server.Function.Math.RoundedValue(coords.x, 3), y = Server.Function.Math.RoundedValue(coords.y, 3), z = Server.Function.Math.RoundedValue(coords.z, 3), heading = Server.Function.Math.RoundedValue(heading, 3)}
				local result = MySQL.query.await("SELECT position FROM users WHERE license = ?", {currentPlayer.license})
				if result and result[1] then
					MySQL.update("UPDATE users SET name = ?, position = ? WHERE license = ?", {currentPlayer.name, json.encode(position), currentPlayer.license})
				else
					MySQL.insert("INSERT INTO users (license, name, position) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(position)})
				end
			end
		end
		local message = {{
			title = nil,
			description = string.format(Config.Discord.Webhook.Notification.PlayerDropped.Description, Server.PlayerCount, GetConvarInt("sv_maxclients", 48)),
			color = Config.Discord.Webhook.Notification.PlayerDropped.Color
		}}
		local isTimedOut = false
		local isCrashed = false
		local isUnknowReason = false
		local lowerStr = string.lower(reason)
		if string.find(lowerStr, "exiting") or string.find(lowerStr, "disconnected") or string.find(lowerStr, "rockstar editor") then
			message[1].title = string.format(Config.Discord.Webhook.Notification.PlayerDropped.Title["left"], currentPlayer.name, reason)
		elseif string.find(lowerStr, "shutting down") then
			message[1].title = string.format(Config.Discord.Webhook.Notification.PlayerDropped.Title["left"], currentPlayer.name, "Server shutting down")
		elseif string.find(lowerStr, "timed out") or string.find(lowerStr, "expired") then
			isTimedOut = true
			message[1].title = string.format(Config.Discord.Webhook.Notification.PlayerDropped.Title["timed-out"], currentPlayer.name)
		elseif string.find(lowerStr, "crashed") then
			isCrashed = true
			message[1].title = string.format(Config.Discord.Webhook.Notification.PlayerDropped.Title["crashed"], currentPlayer.name)
		else
			isUnknowReason = true
			message[1].title = string.format(Config.Discord.Webhook.Notification.PlayerDropped.Title["unknown-reason"], currentPlayer.name)
		end
		Server.Function.Webhook.Notification({embeds = message}, currentPlayer.name)
		TriggerClientEvent("client:core:dropped", -1, currentPlayer.name, (isTimedOut and 1) or (isCrashed and 2) or (isUnknowReason and 3) or 0)
		for _, currentSession in pairs(Server.Creator.Sessions) do
			local found = false
			for k, v in pairs(currentSession.creators) do
				if v.playerId == currentPlayer.id then
					found = true
					table.remove(currentSession.creators, k)
					break
				end
			end
			if found then
				if #currentSession.creators == 0 then
					Server.Creator.Sessions[currentSession.sessionId] = nil
				else
					for k, v in pairs(currentSession.creators) do
						TriggerClientEvent("client:creator:playerLeaveSession", v.playerId, currentPlayer.name, currentPlayer.id)
					end
				end
			end
		end
		Server.Players[currentPlayer.id] = nil
		CreateThread(function()
			for k, v in pairs(currentPlayer.entitys) do
				local entity = NetworkGetEntityFromNetworkId(v)
				if DoesEntityExist(entity) then
					DeleteEntity(entity)
				end
			end
		end)
	end
end)

if not Config.Debug then
	AddEventHandler("playerConnecting", function(playerName, setKickReason, d)
		local playerId = tonumber(source)
		local license = GetPlayerIdentifierByType(playerId, "license")
		local trimmedName = playerName:gsub("%s+", "")
		d.defer()
		Wait(0)
		d.update("Checking ... ")
		CreateThread(function()
			if not license then
				d.done("\nUnable to obtain your license")
			elseif Server.PlayerCount >= GetConvarInt("sv_maxclients", 48) then
				d.done("\nThis server is full")
			elseif #trimmedName < 3 then
				d.done("\nUsername is too short")
			elseif #trimmedName > 20 then
				d.done("\nUsername is too long")
			elseif string.match(trimmedName, "(%d%d%d%d)$") then
				d.done("\nYou haven't set a username in the FiveM settings yet")
			elseif not string.match(trimmedName, "^[A-Za-z0-9]+$") then
				d.done("\nChange your username in FiveM settings (only English letters and numbers allowed)")
			elseif Server.Function.Player.CheckName(trimmedName) then
				d.done("\nThe username contains banned words")
			elseif Server.Function.Player.HasJoined(license:gsub("license:", "")) then
				d.done("\nYou have already joined")
			else
				d.done()
			end
		end)
	end)
end