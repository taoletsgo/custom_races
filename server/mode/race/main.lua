CreateServerCallback("server:race:getPlayerList", function(currentPlayer, callback)
	local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
	if currentRoom and currentRoom.status == "waiting" then
		local inRoomPlayers = {}
		local availablePlayers = {}
		for k, v in pairs(currentRoom.players) do
			inRoomPlayers[v.src] = true
		end
		for k, v in pairs(Server.Players) do
			if not inRoomPlayers[v.id] and not currentRoom.invitations[v.id] then
				availablePlayers[#availablePlayers + 1] = {id = v.id, name = v.name}
			end
		end
		callback(availablePlayers)
	else
		callback({})
	end
end)

CreateServerCallback("server:race:getRoomList", function(currentPlayer, callback)
	local roomList = {}
	for k, v in pairs(Server.Race.Rooms) do
		if v.roomData.accessible == "public" and (v.status == "waiting" or v.status == "loading" or v.status == "racing") then
			table.insert(roomList, {
				roomId = v.roomId,
				name = v.roomData.name,
				vehicle = v.roomData.vehicle,
				creator = v.ownerName,
				players = #v.players .. "/" .. v.roomData.maxPlayers
			})
		end
	end
	callback(roomList)
end)

RegisterNetEvent("server:race:createRace", function(data)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if not currentPlayer or Server.Race.Rooms[currentPlayer.roomId] then return end
	Server.Race.RoomId = Server.Race.RoomId + 1
	local roomId = Server.Race.RoomId
	currentPlayer.roomId = roomId
	Server.Race.Rooms[roomId] = Server.Function.Room.Create(roomId, data, currentPlayer.id, currentPlayer.name)
	CreateThread(function()
		local lastSyncTime = GetGameTimer()
		while true do
			local currentRoom = Server.Race.Rooms[roomId]
			if currentRoom then
				if currentRoom.status == "waiting" then
					local inRoomPlayers = {}
					for k, v in pairs(currentRoom.players) do
						if Server.Players[v.src] then
							inRoomPlayers[#inRoomPlayers + 1] = v
						else
							currentRoom.syncNextFrame = true
							if v.src == currentRoom.ownerId then
								currentRoom.status = "invalid"
								break
							end
						end
					end
					currentRoom.players = inRoomPlayers
					local inRoomInvitations = {}
					for k, v in pairs(currentRoom.invitations) do
						if Server.Players[v.src] then
							inRoomInvitations[v.src] = v
						else
							currentRoom.syncNextFrame = true
						end
					end
					currentRoom.invitations = inRoomInvitations
					if currentRoom.status == "invalid" then
						for k, v in pairs(currentRoom.players) do
							local player = Server.Players[v.src]
							if player then
								player.roomId = nil
							end
							TriggerClientEvent("client:race:exitRoom", v.src, "leave")
						end
					else
						local timeServerSide = GetGameTimer()
						if currentRoom.syncNextFrame or (timeServerSide - lastSyncTime > 5000) then
							currentRoom.syncNextFrame = false
							lastSyncTime = timeServerSide
							for k, v in pairs(currentRoom.players) do
								TriggerClientEvent("client:race:syncPlayers", v.src, currentRoom.players, currentRoom.invitations, currentRoom.roomData.maxPlayers, currentRoom.roomData.vehicle, timeServerSide)
							end
						end
					end
				elseif currentRoom.status == "loading" and currentRoom.startTime then
					local offlinePlayers = {}
					local inRoomPlayers = {}
					for k, v in pairs(currentRoom.players) do
						if Server.Players[v.src] then
							inRoomPlayers[#inRoomPlayers + 1] = v
						end
					end
					currentRoom.players = inRoomPlayers
					local inRoomDrivers = {}
					for k, v in pairs(currentRoom.drivers) do
						if Server.Players[v.playerId] then
							inRoomDrivers[v.playerId] = v
						else
							offlinePlayers[v.playerId] = v.playerName
						end
					end
					currentRoom.drivers = inRoomDrivers
					for _, playerName in pairs(offlinePlayers) do
						for k, v in pairs(currentRoom.players) do
							TriggerClientEvent("client:race:info", v.src, "msg-drop-server", {name = playerName})
						end
					end
					local allRaceLoaded = true
					for k, v in pairs(currentRoom.players) do
						if not v.raceLoaded then
							allRaceLoaded = false
							break
						end
					end
					if allRaceLoaded or (GetGameTimer() - currentRoom.startTime >= currentRoom.timeOut) then
						if #currentRoom.players > 0 then
							for k, v in pairs(currentRoom.players) do
								TriggerClientEvent("client:race:startRace", v.src)
							end
							currentRoom.status = "racing"
						else
							currentRoom.status = "invalid"
						end
					end
				elseif currentRoom.status == "racing" or currentRoom.status == "dnf" then
					local offlinePlayers = {}
					local inRoomPlayers = {}
					for k, v in pairs(currentRoom.players) do
						if Server.Players[v.src] then
							inRoomPlayers[#inRoomPlayers + 1] = v
						end
					end
					currentRoom.players = inRoomPlayers
					local inRoomDrivers = {}
					for k, v in pairs(currentRoom.drivers) do
						if Server.Players[v.playerId] then
							inRoomDrivers[v.playerId] = v
						else
							offlinePlayers[v.playerId] = v.playerName
						end
					end
					currentRoom.drivers = inRoomDrivers
					for _, playerName in pairs(offlinePlayers) do
						for k, v in pairs(currentRoom.players) do
							TriggerClientEvent("client:race:info", v.src, "msg-drop-server", {name = playerName})
						end
					end
					local allRaceStarted = true
					for k, v in pairs(currentRoom.players) do
						if not v.raceStarted then
							allRaceStarted = false
							break
						end
					end
					local finishedCount, validPlayerCount = Server.Function.Room.GetFinishedAndValidCount(currentRoom)
					if finishedCount >= validPlayerCount and allRaceStarted then
						currentRoom.status = "ending"
						for k, v in pairs(currentRoom.players) do
							local player = Server.Players[v.src]
							if player then
								player.roomId = nil
							end
							TriggerClientEvent("client:race:showFinalResult", v.src)
						end
					elseif currentRoom.status == "racing" and tonumber(currentRoom.roomData.dnf) and (finishedCount / tonumber(currentRoom.roomData.dnf)) >= validPlayerCount and allRaceStarted then
						currentRoom.status = "dnf"
						for k, v in pairs(currentRoom.players) do
							TriggerClientEvent("client:race:startDNFCountdown", v.src, currentRoom.roomId)
						end
					end
					local timeServerSide = GetGameTimer() + (currentRoom.status == "ending" and 3000 or 0)
					local drivers = {}
					for k, v in pairs(currentRoom.drivers) do
						local player = Server.Players[v.playerId]
						if player then
							if not v.hasFinished then
								local pos = GetEntityCoords(GetPlayerPed(tostring(v.playerId)))
								local x = Server.Function.Math.RoundedValue(pos.x, 3)
								local y = Server.Function.Math.RoundedValue(pos.y, 3)
								local z = Server.Function.Math.RoundedValue(pos.z, 3)
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
								v.lastLap,
								v.bestLap,
								v.totalRaceTime,
								v.totalCheckpointsTouched,
								v.lastCheckpointPair,
								v.hasFinished,
								v.currentCoords,
								v.finishCoords,
								v.dnf,
								v.keyboard,
								player.flag
							}
						end
					end
					for k, v in pairs(currentRoom.players) do
						TriggerClientEvent("client:race:syncDrivers", v.src, drivers, timeServerSide)
					end
				elseif currentRoom.status == "ending" or currentRoom.status == "invalid" then
					Server.Race.Rooms[roomId] = nil
					break
				end
			else
				break
			end
			Wait(currentRoom and currentRoom.status == "loading" and 100 or 500)
		end
	end)
end)

RegisterNetEvent("server:race:invitePlayer", function(inviteId)
	local playerId = tonumber(source)
	local inviteId = tonumber(inviteId)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "waiting" then
			Server.Function.Room.InvitePlayer(currentRoom, inviteId, currentRoom.roomId, currentPlayer.name)
		end
	end
end)

RegisterNetEvent("server:race:cancelInvitation", function(inviteId)
	local playerId = tonumber(source)
	local inviteId = tonumber(inviteId)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "waiting" and inviteId ~= currentRoom.ownerId and currentPlayer.id == currentRoom.ownerId then
			Server.Function.Room.RemoveInvitation(currentRoom, inviteId)
		end
	end
end)

RegisterNetEvent("server:race:acceptInvitation", function(roomId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[tonumber(roomId)]
		if currentRoom then
			if currentRoom.status == "waiting" then
				if #currentRoom.players < currentRoom.roomData.maxPlayers then
					Server.Function.Room.AcceptInvitation(currentRoom, currentPlayer, true)
				else
					TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-full")
				end
			elseif currentRoom.status == "loading" then
				Server.Function.Room.InvitePlayer(currentRoom, currentPlayer.id, currentRoom.roomId, "System")
				TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "race-loading")
			elseif currentRoom.status == "racing" then
				if #currentRoom.players < currentRoom.roomData.maxPlayers then
					Server.Function.Room.JoinRaceMidway(currentRoom, currentPlayer, true)
				else
					TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-full")
				end
			else
				TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-null")
			end
		else
			TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-null")
		end
	end
end)

RegisterNetEvent("server:race:denyInvitation", function(roomId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[tonumber(roomId)]
		if currentRoom and currentRoom.status == "waiting" then
			Server.Function.Room.DenyInvitation(currentRoom, currentPlayer)
		end
	end
end)

RegisterNetEvent("server:race:kickPlayer", function(kickId)
	local playerId = tonumber(source)
	local kickId = tonumber(kickId)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "waiting" and kickId ~= currentRoom.ownerId and currentPlayer.id == currentRoom.ownerId then
			for k, v in pairs(currentRoom.players) do
				if v.src == kickId and v.roomLoaded then
					local player = Server.Players[v.src]
					if player then
						player.roomId = nil
					end
					TriggerClientEvent("client:race:exitRoom", v.src, "kick")
					table.remove(currentRoom.players, k)
					currentRoom.syncNextFrame = true
					break
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:roomLoaded", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "waiting" then
			for k, v in pairs(currentRoom.players) do
				if v.src == currentPlayer.id then
					v.roomLoaded = true
					currentRoom.syncNextFrame = true
					break
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:leaveRoom", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "waiting" then
			if currentPlayer.id == currentRoom.ownerId then
				currentRoom.status = "invalid"
				for k, v in pairs(currentRoom.players) do
					local player = Server.Players[v.src]
					if player then
						player.roomId = nil
					end
					if v.src ~= currentPlayer.id then
						TriggerClientEvent("client:race:exitRoom", v.src, "leave")
					else
						TriggerClientEvent("client:race:exitRoom", v.src, "")
					end
				end
				currentPlayer.searchCache = nil
			else
				for k, v in pairs(currentRoom.players) do
					if v.src == currentPlayer.id then
						currentPlayer.roomId = nil
						TriggerClientEvent("client:race:exitRoom", currentPlayer.id, "")
						table.remove(currentRoom.players, k)
						currentRoom.syncNextFrame = true
						break
					end
				end
			end
		elseif not currentRoom then
			currentPlayer.roomId = nil
			TriggerClientEvent("client:race:exitRoom", currentPlayer.id, "")
		end
	end
end)

RegisterNetEvent("server:race:joinPublicRoom", function(roomId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[tonumber(roomId)]
		if currentRoom then
			if currentRoom.status == "waiting" then
				if #currentRoom.players < currentRoom.roomData.maxPlayers then
					Server.Function.Room.AcceptInvitation(currentRoom, currentPlayer, false)
				else
					TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-full")
				end
			elseif currentRoom.status == "loading" then
				TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "race-loading")
			elseif currentRoom.status == "racing" then
				if #currentRoom.players < currentRoom.roomData.maxPlayers then
					Server.Function.Room.JoinRaceMidway(currentRoom, currentPlayer, false)
				else
					TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-full")
				end
			else
				TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-null")
			end
		else
			TriggerClientEvent("client:race:joinRoomFailed", currentPlayer.id, "room-null")
		end
	end
end)

RegisterNetEvent("server:race:setPlayerVehicle", function(vehicle)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "waiting" and vehicle then
			if currentRoom.roomData.vehicle == "specific" then
				if currentPlayer.id == currentRoom.ownerId then
					for k, v in pairs(currentRoom.players) do
						v.vehicle = vehicle.label
					end
					currentRoom.predefinedVehicle = vehicle.mods
					currentRoom.syncNextFrame = true
				end
			elseif currentRoom.roomData.vehicle == "personal" then
				for k, v in pairs(currentRoom.players) do
					if v.src == currentPlayer.id then
						v.vehicle = vehicle.label
						currentRoom.playerVehicles[currentPlayer.id] = vehicle.mods
						currentRoom.predefinedVehicle = vehicle.mods
						currentRoom.syncNextFrame = true
						break
					end
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:startRace", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "waiting" and currentPlayer.id == currentRoom.ownerId then
			local allRoomLoaded = true
			for k, v in pairs(currentRoom.players) do
				if not v.roomLoaded then
					allRoomLoaded = false
					break
				end
			end
			if allRoomLoaded then
				Server.Function.Room.StartRace(currentRoom, currentPlayer, currentRoom.roomData.raceId)
			else
				TriggerClientEvent("client:race:info", currentPlayer.id, "msg-join-room")
			end
		end
	end
end)

RegisterNetEvent("server:race:raceLoaded", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "loading" then
			for k, v in pairs(currentRoom.players) do
				if v.src == currentPlayer.id then
					v.raceLoaded = true
					break
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:raceStarted", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and currentRoom.status == "racing" then
			for k, v in pairs(currentRoom.players) do
				if v.src == currentPlayer.id then
					v.raceStarted = true
					break
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:clientSync", function(data, timeClientSide)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		local currentDriver = currentRoom and currentRoom.drivers[currentPlayer.id]
		if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver and (currentDriver.timeClientSide < timeClientSide) then
			Server.Function.Room.ClientSync(currentRoom, currentDriver, data, timeClientSide)
		end
	end
end)

RegisterNetEvent("server:race:playerFinish", function(data, timeClientSide, hasCheated, finishCoords, raceStatus)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		local currentDriver = currentRoom and currentRoom.drivers[currentPlayer.id]
		if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
			Server.Function.Room.ClientSync(currentRoom, currentDriver, data, timeClientSide)
			Server.Function.Room.PlayerFinish(currentRoom, currentDriver, hasCheated, finishCoords, raceStatus)
		end
	end
end)

RegisterNetEvent("server:race:spectatePlayer", function(spectateId, actionFromUser)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		local currentDriver = currentRoom and currentRoom.drivers[currentPlayer.id]
		if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
			local spectateId = tonumber(spectateId)
			currentDriver.spectateId = spectateId
			if not actionFromUser then return end
			for k, v in pairs(currentRoom.players) do
				TriggerClientEvent("client:race:info", v.src, "a-spectate-b", {nameA = currentPlayer.name, nameB = GetPlayerName(spectateId)})
			end
		end
	end
end)

RegisterNetEvent("server:race:respawning", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		local currentDriver = currentRoom and currentRoom.drivers[currentPlayer.id]
		if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") and currentDriver then
			for k, v in pairs(currentRoom.drivers) do
				if Server.Players[v.playerId] then
					if v.spectateId == currentPlayer.id then
						TriggerClientEvent("client:race:respawning", v.playerId, currentPlayer.id, currentDriver.ping, v.ping)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:syncExplosion", function(index, hash)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") then
			for k, v in pairs(currentRoom.players) do
				if v.src ~= currentPlayer.id then
					TriggerClientEvent("client:race:syncExplosion", v.src, index, hash)
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:syncParticleFx", function(effect_1, effect_2, vehicleR, vehicleG, vehicleB)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") then
			for k, v in pairs(currentRoom.players) do
				if v.src ~= currentPlayer.id then
					TriggerClientEvent("client:race:syncParticleFx", v.src, currentPlayer.id, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
				end
			end
		end
	end
end)

RegisterNetEvent("server:race:leaveRace", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		local currentRoom = Server.Race.Rooms[currentPlayer.roomId]
		if currentRoom and (currentRoom.status == "racing" or currentRoom.status == "dnf") then
			Server.Function.Room.Leave(currentRoom, currentPlayer)
		end
	end
end)