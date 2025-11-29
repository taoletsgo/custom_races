RaceServer = {}
RaceServer.Rooms = {}
RaceServer.RoomId = 1000
RaceServer.PlayerInRoom = {}
RaceServer.SpawnedVehicles = {}
RaceServer.CooldownLicenses = {}
RaceServer.Data = {}
RaceServer.Data.Front = {}
RaceServer.Data.SearchStatus = {}
RaceServer.Data.SearchCaches = {}
RaceServer.Data.IsUpdatingData = true
RaceServer.Data.LastUpdateTime = 0

function CheckUserRole(discordId, callback)
	local url = string.format("%s/guilds/%s/members/%s", Config.Whitelist.Discord.api_url, Config.Whitelist.Discord.guild_id, discordId)
	PerformHttpRequest(url, function(statusCode, response, headers)
		if statusCode == 200 then
			local data = json.decode(response)
			if data and data.roles then
				for _, role_user in pairs(data.roles) do
					for _, role_permission in pairs(Config.Whitelist.Discord.role_ids) do
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
		["Authorization"] = "Bot " .. Config.Whitelist.Discord.bot_token,
		["Content-Type"] = "application/json"
	})
end

function RoundedValue(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

CreateServerCallback("custom_races:server:getPlayerList", function(player, callback)
	local playerId = player.src
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	if currentRoom and currentRoom.status == "waiting" then
		local allPlayers = {}
		local inRoomPlayers = {}
		local availablePlayers = {}
		for k, v in pairs(GetPlayers()) do
			if tonumber(v) ~= playerId then
				table.insert(allPlayers, tonumber(v))
			end
		end
		for k, v in pairs(currentRoom.players) do
			inRoomPlayers[v.src] = true
		end
		for k, v in pairs(allPlayers) do
			if not inRoomPlayers[v] and not currentRoom.invitations[v] then
				availablePlayers[#availablePlayers + 1] = {id = v, name = GetPlayerName(v) or "unknown"}
			end
		end
		callback(availablePlayers)
	else
		callback({})
	end
end)

CreateServerCallback("custom_races:server:getRoomList", function(player, callback)
	local roomList = {}
	for k, v in pairs(RaceServer.Rooms) do
		if v.roomData.accessible == "public" and (v.status == "waiting" or v.status == "loading" or v.status == "racing") then
			table.insert(roomList, {
				roomid = v.roomId,
				name = v.roomData.name,
				vehicle = v.roomData.vehicle,
				creator = v.ownerName,
				players = #v.players .. "/" .. v.roomData.maxplayers
			})
		end
	end
	callback(roomList)
end)

CreateServerCallback("custom_races:server:permission", function(player, callback, clientOutdated)
	local playerId = player.src
	local playerName = player.name
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local identifier_discord = GetPlayerIdentifierByType(playerId, "discord")
	local identifier = nil
	local discordId = nil
	local permission = false
	local isChecking = false
	if identifier_license then
		identifier = identifier_license:gsub("license:", "")
		for _, license in pairs(Config.Whitelist.License) do
			if (identifier_license == license) or (identifier == license) then
				permission = true
				break
			end
		end
		if not permission then
			local result = MySQL.query.await("SELECT `group` FROM custom_race_users WHERE license = ?", {identifier})
			if result and result[1] then
				for _, group in pairs(Config.Whitelist.Group) do
					if result[1].group == group then
						permission = true
						break
					end
				end
			end
		end
		if not permission and Config.Whitelist.Discord.enable and identifier_discord then
			discordId = identifier_discord:gsub("discord:", "")
			isChecking = true
			CheckUserRole(discordId, function(bool)
				permission = bool
				isChecking = false
			end)
		end
		while isChecking or RaceServer.Data.IsUpdatingData do Citizen.Wait(0) end
		if permission then
			callback(true, clientOutdated and RaceServer.Data.Front or nil, nil)
		else
			local cooldownTime = RaceServer.CooldownLicenses[identifier]
			if not cooldownTime then
				RaceServer.CooldownLicenses[identifier] = GetGameTimer()
				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 10)
					RaceServer.CooldownLicenses[identifier] = nil
				end)
				callback(true, clientOutdated and RaceServer.Data.Front or nil, nil)
			else
				callback(false, nil, math.floor((1000 * 60 * 10 - (GetGameTimer() - cooldownTime)) / 1000))
			end
		end
	else
		callback(false, nil, 99999)
	end
end)

RegisterNetEvent("custom_races:server:createRace", function(data)
	local ownerId = tonumber(source)
	local ownerName = GetPlayerName(ownerId)
	if RaceServer.Rooms[RaceServer.PlayerInRoom[ownerId]] or not ownerName then
		return
	end
	RaceServer.RoomId = RaceServer.RoomId + 1
	local roomId = RaceServer.RoomId
	RaceServer.PlayerInRoom[ownerId] = roomId
	RaceServer.Rooms[roomId] = Room.CreateRaceRoom(roomId, data, ownerId, ownerName)
	Citizen.CreateThread(function()
		local lastSyncTime = GetGameTimer()
		while true do
			local currentRoom = RaceServer.Rooms[roomId]
			if currentRoom then
				if currentRoom.status == "waiting" then
					local timeServerSide = GetGameTimer()
					if currentRoom.syncNextFrame or (timeServerSide - lastSyncTime > 5000) then
						currentRoom.syncNextFrame = false
						lastSyncTime = timeServerSide
						for k, v in pairs(currentRoom.players) do
							TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRoom.players, currentRoom.invitations, currentRoom.roomData.maxplayers, currentRoom.roomData.vehicle, timeServerSide)
						end
					end
					if currentRoom.isAnyPlayerJoining then
						local lock = false
						for _, _ in pairs(currentRoom.inJoinProgress) do
							lock = true
							break
						end
						if not lock then
							currentRoom.isAnyPlayerJoining = false
							currentRoom.syncNextFrame = true
						end
					end
				elseif currentRoom.status == "loading" then
					local allLoaded = true
					for k, v in pairs(currentRoom.players) do
						if not v.raceLoaded then
							allLoaded = false
							break
						end
					end
					if allLoaded or (currentRoom.startTime and (GetGameTimer() - currentRoom.startTime >= 30000)) then
						for k, v in pairs(currentRoom.players) do
							TriggerClientEvent("custom_races:client:startRace", v.src)
						end
						currentRoom.status = "racing"
					end
				elseif currentRoom.status == "racing" or currentRoom.status == "dnf" then
					local timeServerSide = GetGameTimer()
					local drivers = {}
					for k, v in pairs(currentRoom.drivers) do
						if not v.hasFinished then
							local pos = GetEntityCoords(GetPlayerPed(tostring(v.playerId)))
							local x = RoundedValue(pos.x, 3)
							local y = RoundedValue(pos.y, 3)
							local z = RoundedValue(pos.z, 3)
							v.currentCoords = vector3(x, y, z)
						end
						v.ping = GetPlayerPing(v.playerId)
						drivers[v.playerId] = {
							v.playerId,
							v.playerName,
							v.ping,
							v.fps,
							v.actualLap,
							v.actualCheckpoint,
							v.vehicle,
							v.lastlap,
							v.bestlap,
							v.totalRaceTime,
							v.totalCheckpointsTouched,
							v.lastCheckpointPair,
							v.hasFinished,
							v.currentCoords,
							v.finishCoords,
							v.dnf
						}
					end
					for k, v in pairs(currentRoom.players) do
						TriggerClientEvent("custom_races:client:syncDrivers", v.src, drivers, timeServerSide)
					end
					if currentRoom.isAnyPlayerJoining then
						local lock = false
						for _, _ in pairs(currentRoom.inJoinProgress) do
							lock = true
							break
						end
						if not lock then
							currentRoom.isAnyPlayerJoining = false
						end
					end
				elseif currentRoom.status == "ending" or currentRoom.status == "invalid" then
					RaceServer.Rooms[roomId] = nil
					break
				end
			else
				break
			end
			Citizen.Wait(currentRoom and currentRoom.status == "loading" and 100 or 500)
		end
	end)
end)

RegisterNetEvent("custom_races:server:invitePlayer", function(playerId)
	local playerId = tonumber(playerId)
	local inviteId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[inviteId]]
	if currentRoom and currentRoom.status == "waiting" then
		Room.InvitePlayer(currentRoom, playerId, currentRoom.roomId, inviteId)
	end
end)

RegisterNetEvent("custom_races:server:cancelInvitation", function(playerId)
	local playerId = tonumber(playerId)
	local ownerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[ownerId]]
	if currentRoom and currentRoom.status == "waiting" and playerId ~= currentRoom.ownerId and ownerId == currentRoom.ownerId then
		Room.RemoveInvitation(currentRoom, playerId)
	end
end)

RegisterNetEvent("custom_races:server:acceptInvitation", function(roomId)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local currentRoom = RaceServer.Rooms[tonumber(roomId)]
	if currentRoom then
		currentRoom.isAnyPlayerJoining = true
		if currentRoom.inJoinProgress[playerId] then return end
		currentRoom.inJoinProgress[playerId] = true
		if currentRoom.status == "waiting" then
			if #currentRoom.players < currentRoom.roomData.maxplayers then
				Room.AcceptInvitation(currentRoom, playerId, playerName, true)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		elseif currentRoom.status == "loading" then
			Room.InvitePlayer(currentRoom, playerId, currentRoom.roomId, nil)
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "race-loading")
		elseif currentRoom.status == "racing" then
			if #currentRoom.players < currentRoom.roomData.maxplayers then
				Room.JoinRaceMidway(currentRoom, playerId, playerName, true)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		else
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
		end
		currentRoom.inJoinProgress[playerId] = nil
	else
		TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
	end
end)

RegisterNetEvent("custom_races:server:denyInvitation", function(roomId)
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[tonumber(roomId)]
	if currentRoom and currentRoom.status == "waiting" then
		Room.DenyInvitation(currentRoom, playerId)
	end
end)

RegisterNetEvent("custom_races:server:kickPlayer", function(playerId)
	local playerId = tonumber(playerId)
	local ownerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[ownerId]]
	if currentRoom and currentRoom.status == "waiting" and playerId ~= currentRoom.ownerId and ownerId == currentRoom.ownerId then
		for k, v in pairs(currentRoom.players) do
			if v.src == playerId and v.roomLoaded then
				RaceServer.PlayerInRoom[v.src] = nil
				TriggerClientEvent("custom_races:client:exitRoom", v.src, "kick")
				table.remove(currentRoom.players, k)
				currentRoom.syncNextFrame = true
				break
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:roomLoaded", function()
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	if currentRoom and currentRoom.status == "waiting" then
		for k, v in pairs(currentRoom.players) do
			if v.src == playerId then
				v.roomLoaded = true
				currentRoom.syncNextFrame = true
				break
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:leaveRoom", function()
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	if currentRoom and currentRoom.status == "waiting" then
		if playerId == currentRoom.ownerId then
			currentRoom.status = "invalid"
			for k, v in pairs(currentRoom.players) do
				RaceServer.PlayerInRoom[v.src] = nil
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "leave")
				else
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "")
				end
			end
			RaceServer.Data.SearchCaches[currentRoom.ownerId] = nil
		else
			for k, v in pairs(currentRoom.players) do
				if v.src == playerId then
					RaceServer.PlayerInRoom[v.src] = nil
					TriggerClientEvent("custom_races:client:exitRoom", playerId, "")
					table.remove(currentRoom.players, k)
					currentRoom.syncNextFrame = true
					break
				end
			end
		end
	elseif not currentRoom then
		RaceServer.PlayerInRoom[playerId] = nil
		TriggerClientEvent("custom_races:client:exitRoom", playerId, "")
	end
end)

RegisterNetEvent("custom_races:server:joinPublicRoom", function(roomId)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local currentRoom = RaceServer.Rooms[tonumber(roomId)]
	if currentRoom then
		currentRoom.isAnyPlayerJoining = true
		if currentRoom.inJoinProgress[playerId] then return end
		currentRoom.inJoinProgress[playerId] = true
		if currentRoom.status == "waiting" then
			if #currentRoom.players < currentRoom.roomData.maxplayers then
				Room.AcceptInvitation(currentRoom, playerId, playerName, false)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		elseif currentRoom.status == "loading" then
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "race-loading")
		elseif currentRoom.status == "racing" then
			if #currentRoom.players < currentRoom.roomData.maxplayers then
				Room.JoinRaceMidway(currentRoom, playerId, playerName, false)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		else
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
		end
		currentRoom.inJoinProgress[playerId] = nil
	else
		TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
	end
end)

RegisterNetEvent("custom_races:server:setPlayerVehicle", function(vehicle)
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	if currentRoom and currentRoom.status == "waiting" and vehicle then
		if currentRoom.roomData.vehicle == "specific" then
			if playerId == currentRoom.ownerId then
				for k, v in pairs(currentRoom.players) do
					v.vehicle = vehicle.label
				end
				currentRoom.predefinedVehicle = vehicle.mods
				currentRoom.syncNextFrame = true
			end
		elseif currentRoom.roomData.vehicle == "personal" then
			for k, v in pairs(currentRoom.players) do
				if v.src == playerId then
					v.vehicle = vehicle.label
					currentRoom.playerVehicles[playerId] = vehicle.mods
					currentRoom.predefinedVehicle = vehicle.mods
					currentRoom.syncNextFrame = true
					break
				end
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:startRace", function()
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	if currentRoom and currentRoom.status == "waiting" and playerId == currentRoom.ownerId and not currentRoom.isAnyPlayerJoining then
		Room.StartRaceRoom(currentRoom, currentRoom.roomData.raceid)
	end
end)

RegisterNetEvent("custom_races:server:raceLoaded", function()
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	if currentRoom and currentRoom.status == "loading" then
		for k, v in pairs(currentRoom.players) do
			if v.src == playerId then
				v.raceLoaded = true
				break
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:clientSync", function(data, timeClientSide)
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	local currentDriver = currentRoom and currentRoom.drivers[playerId]
	if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver and (currentDriver.timeClientSide < timeClientSide) then
		Room.ClientSync(currentRoom, currentDriver, data, timeClientSide)
	end
end)

RegisterNetEvent("custom_races:server:playerFinish", function(data, timeClientSide, hasCheated, finishCoords, raceStatus)
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	local currentDriver = currentRoom and currentRoom.drivers[playerId]
	if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
		Room.ClientSync(currentRoom, currentDriver, data, timeClientSide)
		Room.PlayerFinish(currentRoom, currentDriver, hasCheated, finishCoords, raceStatus)
	end
end)

RegisterNetEvent("custom_races:server:spectatePlayer", function(spectateId, actionFromUser)
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	local currentDriver = currentRoom and currentRoom.drivers[playerId]
	if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
		local spectateId = tonumber(spectateId)
		currentDriver.spectateId = spectateId
		if not actionFromUser then return end
		local name_A = GetPlayerName(playerId)
		local name_B = GetPlayerName(spectateId)
		for k, v in pairs(currentRoom.players) do
			TriggerClientEvent("custom_races:client:whoSpectateWho", v.src, name_A, name_B)
		end
	end
end)

RegisterNetEvent("custom_races:server:respawning", function()
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	local currentDriver = currentRoom and currentRoom.drivers[playerId]
	if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
		for k, v in pairs(currentRoom.drivers) do
			if v.spectateId == playerId then
				TriggerClientEvent("custom_races:client:respawning", v.playerId, playerId, currentDriver.ping)
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:syncExplosion", function(index, hash)
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	local currentDriver = currentRoom and currentRoom.drivers[playerId]
	if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
		for k, v in pairs(currentRoom.players) do
			if v.src ~= playerId then
				TriggerClientEvent("custom_races:client:syncExplosion", v.src, index, hash)
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:syncParticleFx", function(effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	local currentDriver = currentRoom and currentRoom.drivers[playerId]
	if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
		for k, v in pairs(currentRoom.players) do
			if v.src ~= playerId then
				TriggerClientEvent("custom_races:client:syncParticleFx", v.src, playerId, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:leaveRace", function()
	local playerId = tonumber(source)
	local currentRoom = RaceServer.Rooms[RaceServer.PlayerInRoom[playerId]]
	local currentDriver = currentRoom and currentRoom.drivers[playerId]
	if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
		Room.LeaveRace(currentRoom, playerId, currentDriver.playerName)
	end
end)

RegisterNetEvent("custom_races:server:spawnVehicle", function(vehNetId)
	local playerId = tonumber(source)
	RaceServer.SpawnedVehicles[playerId] = vehNetId
end)

RegisterNetEvent("custom_races:server:deleteVehicle", function(vehId)
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
	local vehNetId = RaceServer.SpawnedVehicles[playerId]
	if vehNetId then
		Citizen.CreateThread(function()
			-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
			-- Sometimes it happens lol, with a probability of 0.000000000001%
			-- If the vehicle exists, delete it
			local attempt = 0
			while DoesEntityExist(NetworkGetEntityFromNetworkId(vehNetId)) and (attempt < 10) do
				attempt = attempt + 1
				DeleteEntity(NetworkGetEntityFromNetworkId(vehNetId))
				Citizen.Wait(200)
			end
		end)
		RaceServer.SpawnedVehicles[playerId] = nil
	end
	Citizen.Wait(1000)
	RaceServer.Data.SearchCaches[playerId] = nil
	RaceServer.Data.SearchStatus[playerId] = nil
	RaceServer.PlayerInRoom[playerId] = nil
	for k, v in pairs(RaceServer.Rooms) do
		if not (v.status == "ending") then
			Room.PlayerDropped(v, playerId)
		end
	end
end)

AddEventHandler("onResourceStart", function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			local version = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
			if not string.find(version, "dev") then
				PerformHttpRequest("https://raw.githubusercontent.com/taoletsgo/custom_races/refs/heads/main/main%20script/version_check.json", function (err, updatedata, headers)
					if updatedata ~= nil then
						local data = json.decode(updatedata)
						if data.custom_races ~= version then
							print("^1=======================================================================================^0")
							print("^1("..GetCurrentResourceName()..") is outdated!^0")
							print("Latest version: (^2"..data.custom_races.."^0) https://github.com/taoletsgo/custom_races/releases/")
							print("^1=======================================================================================^0")
						end
					end
				end, "GET", "")
			end
		end)
	end
end)