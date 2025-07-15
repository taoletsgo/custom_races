IdsRacesAll = {} -- Table to store all room IDs associated with players
playerSpawnedVehicles = {} -- Table to store vehicles spawned by players
roomServerId = 1000 -- Initial server room ID, starting from 1000

CreateRaceRoom = function(roomId, data, ownerId)
	local currentRace = {
		source = roomId,
		data = data,
		actualTrack = {
			mode = data.mode
		},
		finishedCount = 0,
		status = "waiting",
		name = data.name,
		creator = GetPlayerName(ownerId),
		ownerId = ownerId,
		inJoinProgress = {},
		players = {{
			nick = GetPlayerName(ownerId),
			src = ownerId,
			ownerRace = true,
			vehicle = false
		}},
		drivers = {},
		invitations = {},
		playerVehicles = {},
		DNFstarted = false,
		isFinished = false
	}
	IdsRacesAll[tostring(ownerId)] = tostring(roomId)
	Races[roomId] = currentRace
	return setmetatable(currentRace, getmetatable(Races))
end

GetRouteFileByRaceID = function(raceid)
	if raceid then
		local result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = ?", {raceid})
		if result and #result > 0 then
			return result[1].route_file, result[1].category
		end
	end
	return nil, nil
end

GetPlayerList = function(playerId, currentRace)
	local onlinePlayers = {}
	local activePlayers = {}
	local availablePlayers = {}
	for k, v in pairs(GetPlayers()) do
		if tonumber(v) ~= playerId then
			table.insert(onlinePlayers, tonumber(v))
		end
	end
	for k, v in pairs(currentRace.players) do
		activePlayers[v.src] = true
	end
	-- Iterate through the player list and filter out active and invited players
	for _, player in pairs(onlinePlayers) do
		if player ~= playerId and not activePlayers[player] and not currentRace.invitations[tostring(player)] then
			local playerData = {}
			playerData.id = player
			playerData.name = GetPlayerName(player)
			availablePlayers[#availablePlayers + 1] = playerData
		end
	end
	return availablePlayers
end

CheckUserRole = function(discordId, callback)
	local url = string.format("%s/guilds/%s/members/%s", Config.Discord.api_url, Config.Discord.guild_id, discordId)
	PerformHttpRequest(url, function(statusCode, response, headers)
		if statusCode == 200 then
			local data = json.decode(response)
			if data and data.roles then
				for _, role_user in pairs(data.roles) do
					for _, role_permission in pairs(Config.Discord.role_ids) do
						if role_user == role_permission then
							callback(true)
							return
						end
					end
				end
			end
			callback(false)
		else
			callback(false)
		end
	end, "GET", "", {
		["Authorization"] = "Bot " .. Config.Discord.bot_token,
		["Content-Type"] = "application/json"
	})
end

CreateServerCallback("custom_races:server:getPlayerList", function(player, callback)
	local playerId = player.src
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace then
		local playerList = GetPlayerList(playerId, currentRace)
		callback(playerList)
	else
		callback({})
	end
end)

CreateServerCallback("custom_races:server:getRoomList", function(player, callback)
	local roomList = {}
	for k, v in pairs(Races) do
		if v.data.accessible == "public" and not v.isFinished and not v.DNFstarted then
			table.insert(roomList, {
				name = v.name,
				creator = v.creator,
				players = #v.players .. "/" .. v.data.maxplayers,
				roomid = v.source,
				vehicle = v.data.vehicle
			})
		end
	end
	callback(roomList)
end)

CreateServerCallback('custom_races:server:permission', function(player, callback, clientOutdated)
	local playerId = player.src
	local playerName = player.name
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	local identifier_discord = GetPlayerIdentifierByType(playerId, 'discord')
	local identifier = nil
	local discordId = nil
	local permission = false
	local isChecking = false
	if identifier_license then
		identifier = identifier_license:gsub('license:', '')
		for _, license in pairs(Config.Discord.whitelist_license) do
			if (identifier_license == license) or (identifier == license) then
				permission = true
				break
			end
		end
		if not permission then
			local result = MySQL.query.await("SELECT `group` FROM custom_race_users WHERE license = ?", {identifier})
			if result and result[1] then
				for _, group in pairs(Config.Discord.whitelist_group) do
					if result[1].group == group then
						permission = true
						break
					end
				end
			end
		end
		if not permission and Config.Discord.enable and identifier_discord then
			discordId = identifier_discord:gsub('discord:', '')
			isChecking = true
			CheckUserRole(discordId, function(bool)
				permission = bool
				isChecking = false
			end)
		end
		while isChecking do Citizen.Wait(0) end
		if permission then
			while isUpdatingData do Citizen.Wait(0) end
			callback(true, clientOutdated and races_data_front or nil)
		else
			while isUpdatingData do Citizen.Wait(0) end
			callback(false, clientOutdated and races_data_front or nil)
		end
	else
		while isUpdatingData do Citizen.Wait(0) end
		callback(false, clientOutdated and races_data_front or nil)
		print(playerName .. "does not have a valid license")
	end
end)

RegisterNetEvent("custom_races:server:createRace", function(data)
	roomServerId = roomServerId + 1
	local roomId = roomServerId
	local ownerId = tonumber(source)
	Races[roomId] = nil
	Races[roomId] = CreateRaceRoom(roomId, data, ownerId)
end)

RegisterNetEvent("custom_races:server:invitePlayer", function(playerId)
	local playerId = tonumber(playerId)
	local inviteId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(inviteId)])]
	if currentRace then
		currentRace.InvitePlayer(currentRace, playerId, currentRace.source, inviteId)
	end
end)

RegisterNetEvent("custom_races:server:cancelInvitation", function(playerId)
	local playerId = tonumber(playerId)
	local ownerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(ownerId)])]
	if currentRace then
		currentRace.RemoveInvitation(currentRace, playerId)
	end
end)

RegisterNetEvent("custom_races:server:acceptInvitation", function(roomId)
	if not Races[tonumber(roomId)] or Races[tonumber(roomId)].DNFstarted or Races[tonumber(roomId)].isFinished then
		TriggerClientEvent("custom_races:client:roomNull", source)
		return
	end
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local currentRace = Races[tonumber(roomId)]
	currentRace.inJoinProgress[playerId] = true
	while currentRace.status == "loading" do
		Citizen.Wait(0)
	end
	if #currentRace.players < currentRace.data.maxplayers then
		if currentRace.status == "waiting" then
			currentRace.AcceptInvitation(currentRace, playerId, playerName, true)
		elseif currentRace.status == "racing" then
			currentRace.JoinRaceMidway(currentRace, playerId, playerName, true)
		end
	else
		TriggerClientEvent("custom_races:client:maxplayers", playerId)
	end
	currentRace.inJoinProgress[playerId] = nil
end)

RegisterNetEvent("custom_races:server:denyInvitation", function(roomId)
	local currentRace = Races[tonumber(roomId)]
	if currentRace then
		currentRace.DenyInvitation(currentRace, source)
	end
end)

RegisterNetEvent("custom_races:server:kickPlayer", function(playerId)
	local playerId = tonumber(playerId)
	local ownerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(ownerId)])]
	if currentRace then
		for k, v in pairs(currentRace.players) do
			if v.src == playerId then
				IdsRacesAll[tostring(v.src)] = nil
				TriggerClientEvent("custom_races:client:exitRoom", v.src, "kick")
				table.remove(currentRace.players, k)
				break
			end
		end
		local timeServerSide = GetGameTimer()
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
		end
	end
end)

RegisterNetEvent("custom_races:server:leaveRoom", function()
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace then
		local canKickAll = false
		for k, v in pairs(currentRace.players) do
			if v.src == playerId and v.ownerRace then
				canKickAll = true
				break
			end
		end
		if canKickAll then
			-- If the player is the owner, kick all players from the room
			for k, v in pairs(currentRace.players) do
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "leave")
				else
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "")
				end
				IdsRacesAll[tostring(v.src)] = nil
			end
			Races[currentRace.source] = nil
		else
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(v.src)] = nil
					table.remove(currentRace.players, k)
					break
				end
			end
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:joinPublicRoom", function(roomId)
	if not Races[tonumber(roomId)] or Races[tonumber(roomId)].DNFstarted or Races[tonumber(roomId)].isFinished then
		TriggerClientEvent("custom_races:client:roomNull", source)
		return
	end
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local currentRace = Races[tonumber(roomId)]
	currentRace.inJoinProgress[playerId] = true
	while currentRace.status == "loading" do
		Citizen.Wait(0)
	end
	if #currentRace.players < currentRace.data.maxplayers then
		if currentRace.status == "waiting" then
			currentRace.AcceptInvitation(currentRace, playerId, playerName, false)
		elseif currentRace.status == "racing" then
			currentRace.JoinRaceMidway(currentRace, playerId, playerName, false)
		end
	else
		TriggerClientEvent("custom_races:client:maxplayers", playerId)
	end
	currentRace.inJoinProgress[playerId] = nil
end)

RegisterNetEvent("custom_races:server:setPlayerVehicle", function(vehicle)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and vehicle then
		if currentRace.data.vehicle == "specific" then
			for k, v in pairs(currentRace.players) do
				currentRace.players[k].vehicle = vehicle.label
			end
			currentRace.actualTrack.predefinedVehicle = vehicle.mods
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
			end
		elseif currentRace.data.vehicle == "personal" then
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					currentRace.players[k].vehicle = vehicle.label
					currentRace.playerVehicles[playerId] = vehicle.mods
					currentRace.actualTrack.predefinedVehicle = vehicle.mods
					break
				end
			end
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:startRace", function()
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and (currentRace.ownerId == playerId) then
		currentRace.StartRaceRoom(currentRace, currentRace.data.raceid)
	elseif currentRace and (currentRace.ownerId ~= playerId) then
		-- print("ERROR: " .. (GetPlayerName(playerId) or playerId) .. " is cheating to start this race room")
	else
		print("ERROR: Owner can't start race")
	end
end)

RegisterNetEvent("custom_races:server:clientSync", function(data, timeClientSide)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] and (currentRace.drivers[playerId].timeClientSide < timeClientSide) then
		currentRace.ClientSync(currentRace, playerId, data, timeClientSide)
	end
end)

RegisterNetEvent("custom_races:server:playerFinish", function(data, timeClientSide, hasCheated, finishCoords, raceStatus)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] then
		currentRace.ClientSync(currentRace, playerId, data, timeClientSide)
		currentRace.PlayerFinish(currentRace, playerId, hasCheated, finishCoords, raceStatus)
	end
end)

RegisterNetEvent("custom_races:server:spectatePlayer", function(id, actionFromUser)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] then
		local spectateId = tonumber(id)
		currentRace.drivers[playerId].spectateId = spectateId
		if not actionFromUser then return end
		local name_A = GetPlayerName(playerId)
		local name_B = GetPlayerName(spectateId)
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:whoSpectateWho", v.src, name_A, name_B)
		end
	end
end)

RegisterNetEvent("custom_races:server:syncParticleFx", function(r, g, b)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] then
		for k, v in pairs(currentRace.players) do
			if v.src ~= playerId then
				TriggerClientEvent("custom_races:client:syncParticleFx", v.src, playerId, r, g, b)
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:leaveRace", function()
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace then
		currentRace.LeaveRace(currentRace, playerId)
	end
end)

RegisterNetEvent("custom_races:server:re-sync", function(event)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace then
		if event == "syncDrivers" then
			--TriggerClientEvent("custom_races:client:syncDrivers", playerId, currentRace.drivers, GetGameTimer())
		elseif event == "syncPlayers" then
			TriggerClientEvent("custom_races:client:syncPlayers", playerId, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, GetGameTimer())
		end
	end
end)

RegisterNetEvent('custom_races:server:spawnVehicle', function(vehNetId)
	local playerId = tonumber(source)
	playerSpawnedVehicles[playerId] = vehNetId
end)

RegisterNetEvent('custom_races:server:deleteVehicle', function(vehId)
	local playerId = tonumber(source)
	local vehicle = NetworkGetEntityFromNetworkId(vehId)
	Citizen.CreateThread(function()
		-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
		-- Sometimes it happens lol, with a probability of 0.000000000001%
		-- If the vehicle exists, delete it
		if DoesEntityExist(vehicle) then
			DeleteEntity(vehicle)
		end
	end)
end)

AddEventHandler("playerDropped", function()
	local playerId = tonumber(source)
	local vehNetId = playerSpawnedVehicles[playerId]
	if vehNetId then
		Citizen.CreateThread(function()
			-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
			-- Sometimes it happens lol, with a probability of 0.000000000001%
			-- If the vehicle exists, delete it
			local attempt = 0
			while DoesEntityExist(NetworkGetEntityFromNetworkId(vehNetId)) and (attempt < 3) do
				attempt = attempt + 1
				DeleteEntity(NetworkGetEntityFromNetworkId(vehNetId))
				Citizen.Wait(0)
			end
		end)
		playerSpawnedVehicles[playerId] = nil
	end
	for k, v in pairs(Races) do
		if not Races[k].isFinished then
			Races[k].PlayerDropped(Races[k], playerId)
		end
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			local version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
			if not string.find(version, "dev") then
				PerformHttpRequest('https://raw.githubusercontent.com/taoletsgo/custom_races/refs/heads/main/main%20script/version_check.json', function (err, updatedata, headers)
					if updatedata ~= nil then
						local data = json.decode(updatedata)
						if data.custom_races ~= version then
							print('^1=======================================================================================^0')
							print('^1('..GetCurrentResourceName()..') is outdated!^0')
							print('Latest version: (^2'..data.custom_races..'^0) https://github.com/taoletsgo/custom_races/releases/')
							print('^1=======================================================================================^0')
						end
					end
				end, 'GET', '')
			end
		end)
	end
end)