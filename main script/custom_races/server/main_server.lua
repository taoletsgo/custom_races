IdsRacesAll = {} -- Table to store all room IDs associated with players
playerSpawnedVehicles = {} -- Table to store vehicles spawned by players
roomServerId = 1000 -- Initial server room ID, starting from 1000

CreateRaceRoom = function(roomId, data, name, ownerId)
	Races[roomId] = nil
	Races[roomId] = NewRace(roomId, data, name, ownerId)
end

NewRace = function(roomId, data, name, ownerId)
	local currentRace = {
		source = roomId,
		data = data,
		actualTrack = {
			mode = data.mode
		},
		finishedCount = 0,
		status = "waiting",
		nameRace = name,
		creator = GetPlayerName(ownerId),
		ownerId = ownerId,
		players = {{
			nick = GetPlayerName(ownerId),
			src = ownerId,
			ownerRace = true,
			vehicle = false
		}},
		drivers = {},
		invitations = {},
		playerVehicles = {},
		playerstatus = {
			[ownerId] = "inroom"
		},
		DNFstarted = false,
		isFinished = false
	}
	IdsRacesAll[tostring(ownerId)] = tostring(roomId)
	Races[roomId] = currentRace
	return setmetatable(currentRace, getmetatable(Races))
end

GetRouteFileByRaceID = function(raceid)
	if raceid then
		local result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = raceid})
		if result and #result > 0 then
			return result[1].route_file, result[1].category
		end
	end
	return nil, nil
end

StartSession = function(currentRace)
	local players = {}
	for k, v in pairs(currentRace.players) do
		table.insert(players, v.src)
		TriggerClientEvent("custom_races:client:countDown", v.src)
		currentRace.StartPlayerSession(currentRace, v.src, v.nick)
	end
	currentRace.status = "loading_done"
	Citizen.Wait(5000)
	StartCurrentRace(currentRace, players)
end

StartCurrentRace = function(currentRace, players)
	local list = {}
	for k, v in pairs(players) do
		list[k] = v
	end
	for gridPosition = 1, #list do
		local randomIndex = math.random(1, #list)
		local playerId = list[randomIndex]
		table.remove(list, randomIndex)
		local vehicle = currentRace.playerVehicles[playerId] or currentRace.actualTrack.predefinedVehicle
		TriggerClientEvent("custom_races:client:showRaceInfo", playerId, gridPosition, vehicle)
	end
	local timeServerSide = GetGameTimer()
	for k, v in pairs(players) do
		TriggerClientEvent("custom_races:client:syncDrivers", v, currentRace.drivers, timeServerSide)
	end
	Citizen.CreateThread(function()
		Citizen.Wait(5000)
		for k, v in pairs(players) do
			TriggerClientEvent("custom_races:client:startRace", v)
			currentRace.playerstatus[tonumber(v)] = "racing"
		end
	end)
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

CreateServerCallback("custom_races:server:getPlayerList", function(source, callback)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace then
		local playerList = GetPlayerList(playerId, currentRace)
		callback(playerList)
	else
		callback({})
	end
end)

CreateServerCallback("custom_races:server:getRaceList", function(source, callback)
	local raceList = {}
	for k, v in pairs(Races) do
		if v.data.accessible == "public" and not v.isFinished and not v.DNFstarted then
			for a, b in pairs(v.players) do
				if b.ownerRace then
					table.insert(raceList, {
						name = v.nameRace,
						creator = v.creator,
						players = #v.players .. "/" .. v.data.maxplayers,
						roomid = v.source,
						vehicle = v.data.vehicle
					})
				end
			end
		end
	end
	callback(raceList)
end)

CreateServerCallback('custom_races:server:permission', function(source, callback, clientOutdated)
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
						while isUpdatingData do Citizen.Wait(0) end
						callback(true, clientOutdated and races_data_front or nil)
					else
						while isUpdatingData do Citizen.Wait(0) end
						callback(false, clientOutdated and races_data_front or nil)
					end
				end)
			else
				while isUpdatingData do Citizen.Wait(0) end
				callback(false, clientOutdated and races_data_front or nil)
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
				while isUpdatingData do Citizen.Wait(0) end
				callback(true, clientOutdated and races_data_front or nil)
			else
				while isUpdatingData do Citizen.Wait(0) end
				callback(false, clientOutdated and races_data_front or nil)
			end
		end
	else
		while isUpdatingData do Citizen.Wait(0) end
		callback(false, clientOutdated and races_data_front or nil)
		print(GetPlayerName(playerId) .. "does not have a valid license")
	end
end)

RegisterNetEvent("custom_races:server:createRace", function(data)
	local ownerId = tonumber(source)
	roomServerId = roomServerId + 1
	local roomId = roomServerId
	CreateRaceRoom(roomId, data, data.name, ownerId)
	TriggerClientEvent("custom_races:client:roomId", ownerId, roomId)
end)

RegisterNetEvent("custom_races:server:invitePlayer", function(data)
	local playerId = tonumber(data.id)
	local inviteId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(inviteId)])]
	if currentRace then
		currentRace.InvitePlayer(currentRace, playerId, currentRace.source, inviteId)
	end
end)

RegisterNetEvent("custom_races:server:cancelInvitation", function(data)
	local ownerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(ownerId)])]
	if currentRace then
		currentRace.RemoveInvitation(currentRace, tonumber(data.player))
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
	currentRace.playerstatus[playerId] = "joining"
	while currentRace.status == "loading" do
		Citizen.Wait(0)
	end
	if #currentRace.players < currentRace.data.maxplayers then
		if currentRace.status == "waiting" then
			currentRace.AcceptInvitation(currentRace, playerId, playerName, true)
			TriggerClientEvent("custom_races:client:roomId", playerId, currentRace.source)
			currentRace.playerstatus[playerId] = "inroom"
		elseif currentRace.status == "racing" or currentRace.status == "loading_done" then
			currentRace.AcceptInvitation(currentRace, playerId, playerName, false)
			TriggerClientEvent("custom_races:client:roomId", playerId, currentRace.source)
			TriggerClientEvent("custom_races:client:loadTrack", playerId, currentRace.data, currentRace.actualTrack, currentRace.actualTrack.props, currentRace.actualTrack.dprops, currentRace.actualweatherAndTime, currentRace.actualTrack.laps)
			Citizen.Wait(2000)
			currentRace.StartPlayerSession(currentRace, playerId, playerName)
			Citizen.Wait(3000)
			TriggerClientEvent("custom_races:client:showRaceInfo", playerId, 1, currentRace.actualTrack.predefinedVehicle)
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:syncDrivers", v.src, currentRace.drivers, timeServerSide)
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:client:playerJoinRace", v.src, playerName)
				end
			end
			Citizen.Wait(5000)
			TriggerClientEvent("custom_races:client:startRace", playerId)
			currentRace.playerstatus[playerId] = "racing"
		end
	else
		TriggerClientEvent("custom_races:client:maxplayers", playerId)
		currentRace.playerstatus[playerId] = nil
	end
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

RegisterNetEvent("custom_races:server:leaveRoom", function(roomId)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(roomId)]
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
	currentRace.playerstatus[playerId] = "joining"
	while currentRace.status == "loading" do
		Citizen.Wait(0)
	end
	if #currentRace.players < currentRace.data.maxplayers then
		if currentRace.status == "waiting" then
			currentRace.invitations[tostring(playerId)] = nil
			table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[1].vehicle or false})
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
					TriggerClientEvent("custom_races:client:joinPublicRoom", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.nameRace, currentRace.data, true)
				else
					TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
				end
			end
			TriggerClientEvent("custom_races:client:roomId", playerId, currentRace.source)
			currentRace.playerstatus[playerId] = "inroom"
		elseif currentRace.status == "racing" or currentRace.status == "loading_done" then
			currentRace.invitations[tostring(playerId)] = nil
			table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[1].vehicle or false})
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
					TriggerClientEvent("custom_races:client:joinPublicRoom", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.nameRace, currentRace.data, false)
				else
					TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
				end
			end
			TriggerClientEvent("custom_races:client:roomId", playerId, currentRace.source)
			TriggerClientEvent("custom_races:client:loadTrack", playerId, currentRace.data, currentRace.actualTrack, currentRace.actualTrack.props, currentRace.actualTrack.dprops, currentRace.actualweatherAndTime, currentRace.actualTrack.laps)
			Citizen.Wait(2000)
			currentRace.StartPlayerSession(currentRace, playerId, playerName)
			Citizen.Wait(3000)
			TriggerClientEvent("custom_races:client:showRaceInfo", playerId, 1, currentRace.actualTrack.predefinedVehicle)
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:syncDrivers", v.src, currentRace.drivers, timeServerSide)
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:client:playerJoinRace", v.src, playerName)
				end
			end
			Citizen.Wait(5000)
			TriggerClientEvent("custom_races:client:startRace", playerId)
			currentRace.playerstatus[playerId] = "racing"
		end
	else
		TriggerClientEvent("custom_races:client:maxplayers", playerId)
		currentRace.playerstatus[playerId] = nil
	end
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
		currentRace.StartRaceRoom(currentRace, currentRace.data.raceid, currentRace.data.laps, currentRace.data.weather, currentRace.data.time)
	elseif currentRace and (currentRace.ownerId ~= playerId) then
		-- print("ERROR: " .. (GetPlayerName(playerId) or playerId) .. " is cheating to start this race room")
	else
		print("ERROR: Owner can't start race")
	end
end)

RegisterNetEvent("custom_races:server:updateVehName", function(vehNameCurrent)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] then
		currentRace.drivers[playerId].vehNameCurrent = vehNameCurrent
		local timeServerSide = GetGameTimer()
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:syncDrivers", v.src, currentRace.drivers, timeServerSide)
		end
	end
end)

RegisterNetEvent("custom_races:server:updateCheckPoint", function(actualCheckPoint, totalCheckPointsTouched, lastCheckpointPair, roomId)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(roomId)]
	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
		currentRace.UpdateCheckPoint(currentRace, actualCheckPoint, totalCheckPointsTouched, lastCheckpointPair, playerId)
	end
end)

RegisterNetEvent("custom_races:server:updateTime", function(actualLapTime, totalRaceTime, actualLap)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
		currentRace.UpdateTime(currentRace, playerId, actualLapTime, totalRaceTime, actualLap)
	end
end)

RegisterNetEvent("custom_races:server:updateFPS", function(fps)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] then
		currentRace.UpdateFPS(currentRace, playerId, fps)
	end
end)

RegisterNetEvent("custom_races:server:playerFinish", function(totalCheckPointsTouched, lastCheckpointPair, actualLapTime, totalRaceTime, raceStatus, hasCheated, finishCoords)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
		currentRace.UpdateTime(currentRace, playerId, actualLapTime, totalRaceTime)
		currentRace.PlayerFinish(currentRace, playerId, totalCheckPointsTouched, lastCheckpointPair, raceStatus, hasCheated, finishCoords)
	end
end)

RegisterNetEvent("custom_races:server:spectatePlayer", function(id, actionFromUser)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
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
			TriggerClientEvent("custom_races:client:syncDrivers", playerId, currentRace.drivers, GetGameTimer())
		elseif event == "syncPlayers" then
			TriggerClientEvent("custom_races:client:syncPlayers", playerId, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, GetGameTimer())
		end
	end
end)

RegisterNetEvent('custom_races:server:spawnvehicle', function(vehNetId)
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