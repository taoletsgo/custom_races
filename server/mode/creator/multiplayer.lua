RegisterNetEvent("server:creator:createSession", function(raceId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	local currentSession = Server.Creator.Sessions[raceId]
	if currentPlayer and not currentSession then
		Server.Creator.Sessions[raceId] = {
			sessionId = raceId,
			creators = {{playerId = currentPlayer.id, license = currentPlayer.license, playerName = currentPlayer.name}},
			data = nil,
			modificationCount = {
				title = 0,
				thumbnail = 0,
				testVehicle = 0,
				availableVehicles = 0,
				blimpText = 0,
				transformVehicles = 0,
				startingGrid = 0,
				checkpoints = 0,
				fixtures = 0,
				firework = 0
			}
		}
	end
end)

RegisterNetEvent("server:creator:invitePlayer", function(inviteId, title, sessionId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		TriggerClientEvent("client:creator:receiveInvitation", inviteId, title, sessionId, currentPlayer.name)
	end
end)

RegisterNetEvent("server:creator:syncSession", function(raceId, data, str)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	local currentSession = Server.Creator.Sessions[raceId]
	if currentPlayer and currentSession and currentSession.data then
		local canSync = false
		if str == "title-sync" then
			if currentSession.modificationCount.title < data.modificationCount then
				currentSession.modificationCount.title = data.modificationCount
				currentSession.data.Title = data.title
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {title = currentSession.data.Title, modificationCount = currentSession.modificationCount.title}, str, nil, true)
			end
		elseif str == "thumbnail-sync" then
			if currentSession.modificationCount.thumbnail < data.modificationCount then
				currentSession.modificationCount.thumbnail = data.modificationCount
				currentSession.data.Thumbnail = data.thumbnail
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {thumbnail = currentSession.data.Thumbnail, modificationCount = currentSession.modificationCount.thumbnail}, str, nil, true)
			end
		elseif str == "test-vehicle-sync" then
			if currentSession.modificationCount.testVehicle < data.modificationCount then
				currentSession.modificationCount.testVehicle = data.modificationCount
				currentSession.data.TestVehicle = data.testVehicle
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {testVehicle = currentSession.data.TestVehicle, modificationCount = currentSession.modificationCount.testVehicle}, str, nil, true)
			end
		elseif str == "available-vehicles-sync" then
			if currentSession.modificationCount.availableVehicles < data.modificationCount then
				currentSession.modificationCount.availableVehicles = data.modificationCount
				currentSession.data.DefaultClass = data.defaultClass
				currentSession.data.AvailableVehicles = data.availableVehicles
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {defaultClass = currentSession.data.DefaultClass, availableVehicles = currentSession.data.AvailableVehicles, modificationCount = currentSession.modificationCount.availableVehicles}, str, nil, true)
			end
		elseif str == "blimp-text-sync" then
			if currentSession.modificationCount.blimpText < data.modificationCount then
				currentSession.modificationCount.blimpText = data.modificationCount
				currentSession.data.BlimpText = data.blimpText
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {blimpText = currentSession.data.BlimpText, modificationCount = currentSession.modificationCount.blimpText}, str, nil, true)
			end
		elseif str == "transformVehicles-sync" then
			if currentSession.modificationCount.transformVehicles < data.modificationCount then
				currentSession.modificationCount.transformVehicles = data.modificationCount
				currentSession.data.TransformVehicles = data.transformVehicles
				currentSession.data.Checkpoints = data.checkpoints
				currentSession.data.Checkpoints_2 = data.checkpoints_2
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {transformVehicles = currentSession.data.TransformVehicles, checkpoints = currentSession.data.Checkpoints, checkpoints_2 = currentSession.data.Checkpoints_2, modificationCount = currentSession.modificationCount.transformVehicles}, str, nil, true)
			end
		elseif str == "startingGrid-sync" then
			if currentSession.modificationCount.startingGrid < data.modificationCount then
				currentSession.modificationCount.startingGrid = data.modificationCount
				currentSession.data.StartingGrid = data.startingGrid
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {startingGrid = currentSession.data.StartingGrid, modificationCount = currentSession.modificationCount.startingGrid}, str, nil, true)
			end
		elseif str == "checkpoints-sync" then
			if currentSession.modificationCount.checkpoints < data.modificationCount then
				currentSession.modificationCount.checkpoints = data.modificationCount
				currentSession.data.Checkpoints = data.checkpoints
				currentSession.data.Checkpoints_2 = data.checkpoints_2
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {checkpoints = currentSession.data.Checkpoints, checkpoints_2 = currentSession.data.Checkpoints_2, modificationCount = currentSession.modificationCount.checkpoints}, str, nil, true)
			end
		elseif str == "fixtures-sync" then
			if currentSession.modificationCount.fixtures < data.modificationCount then
				currentSession.modificationCount.fixtures = data.modificationCount
				currentSession.data.Fixtures = data.fixtures
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {fixtures = currentSession.data.Fixtures, modificationCount = currentSession.modificationCount.fixtures}, str, nil, true)
			end
		elseif str == "firework-sync" then
			if currentSession.modificationCount.firework < data.modificationCount then
				currentSession.modificationCount.firework = data.modificationCount
				currentSession.data.Firework = data.firework
				canSync = true
			else
				TriggerClientEvent("client:creator:syncSession", currentPlayer.id, {firework = currentSession.data.Firework, modificationCount = currentSession.modificationCount.firework}, str, nil, true)
			end
		elseif str == "creator-preview" then
			canSync = true
		elseif str == "objects-place" then
			table.insert(currentSession.data.Objects, data)
			canSync = true
		elseif str == "objects-change" then
			for k, v in pairs(currentSession.data.Objects) do
				if v.uniqueId == data.uniqueId then
					if v.modificationCount < data.modificationCount then
						currentSession.data.Objects[k] = data
						canSync = true
					else
						TriggerClientEvent("client:creator:syncSession", currentPlayer.id, v, str, nil, true)
					end
					break
				end
			end
		elseif str == "objects-delete" then
			for k, v in pairs(currentSession.data.Objects) do
				if v.uniqueId == data.uniqueId then
					table.remove(currentSession.data.Objects, k)
					break
				end
			end
			canSync = true
		elseif str == "template-place" then
			for i = 1, #data do
				table.insert(currentSession.data.Objects, data[i])
			end
			canSync = true
		elseif str == "move-all" then
			for k, v in pairs(currentSession.data.StartingGrid) do
				v.x = Server.Function.Math.RoundedValue(v.x + data.offsetX, 3)
				v.y = Server.Function.Math.RoundedValue(v.y + data.offsetY, 3)
				v.z = Server.Function.Math.RoundedValue(v.z + data.offsetZ, 3)
			end
			for k, v in pairs(currentSession.data.Checkpoints) do
				v.x = Server.Function.Math.RoundedValue(v.x + data.offsetX, 3)
				v.y = Server.Function.Math.RoundedValue(v.y + data.offsetY, 3)
				v.z = Server.Function.Math.RoundedValue(v.z + data.offsetZ, 3)
				local v_2 = currentSession.data.Checkpoints_2[k]
				if v_2 then
					v_2.x = Server.Function.Math.RoundedValue(v_2.x + data.offsetX, 3)
					v_2.y = Server.Function.Math.RoundedValue(v_2.y + data.offsetY, 3)
					v_2.z = Server.Function.Math.RoundedValue(v_2.z + data.offsetZ, 3)
				end
			end
			for k, v in pairs(currentSession.data.Objects) do
				v.x = Server.Function.Math.RoundedValue(v.x + data.offsetX, 3)
				v.y = Server.Function.Math.RoundedValue(v.y + data.offsetY, 3)
				v.z = Server.Function.Math.RoundedValue(v.z + data.offsetZ, 3)
			end
			canSync = true
		end
		if canSync then
			for k, v in pairs(currentSession.creators) do
				if v.playerId ~= currentPlayer.id then
					TriggerClientEvent("client:creator:syncSession", v.playerId, data, str, currentPlayer.name)
				end
			end
		end
	end
end)

RegisterNetEvent("server:creator:loadDone", function(raceId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	local currentSession = Server.Creator.Sessions[raceId]
	if currentPlayer and currentSession then
		for k, v in pairs(currentSession.creators) do
			if v.playerId ~= currentPlayer.id then
				TriggerClientEvent("client:creator:loadDone", v.playerId, currentPlayer.id)
			end
		end
	end
end)

RegisterNetEvent("server:creator:leaveSession", function(raceId)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	local currentSession = Server.Creator.Sessions[raceId]
	if currentPlayer and currentSession then
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
end)

CreateServerCallback("server:creator:sessionData", function(currentPlayer, callback, raceId, data)
	local currentSession = Server.Creator.Sessions[raceId]
	if currentSession then
		currentSession.data = data
	else
		print("Error: The session no longer exists when receiving session data? Report it on GitHub to help me fix it!")
	end
	callback({})
end)

CreateServerCallback("server:creator:joinPlayerSession", function(currentPlayer, callback, sessionId)
	local currentSession = Server.Creator.Sessions[sessionId]
	if currentSession then
		table.insert(currentSession.creators, {playerId = currentPlayer.id, license = currentPlayer.license, playerName = currentPlayer.name})
		for k, v in pairs(currentSession.creators) do
			if v.playerId ~= currentPlayer.id then
				TriggerClientEvent("client:creator:playerJoinSession", v.playerId, currentPlayer.name, currentPlayer.id)
			end
		end
		while not currentSession.data do
			if not Server.Creator.Sessions[sessionId] then
				break
			end
			Wait(1000)
		end
		Wait(3000)
		if currentSession.data and currentSession.modificationCount and currentSession.creators then
			local inSessionPlayers = {}
			for k, v in pairs(currentSession.creators) do
				inSessionPlayers[#inSessionPlayers + 1] = {playerId = v.playerId, playerName = v.playerName}
			end
			if #inSessionPlayers >= 2 then
				table.sort(inSessionPlayers, function(a, b)
					return string.lower(a.playerName) < string.lower(b.playerName)
				end)
			end
			TriggerClientEvent("client:creator:info", currentPlayer.id, "track-download", #json.encode(currentSession.data) * 1.02)
			callback(currentSession.data, currentSession.modificationCount, inSessionPlayers)
		else
			Server.Creator.Sessions[sessionId] = nil
			callback(false)
		end
	else
		callback(false)
	end
end)

CreateServerCallback("server:creator:getPlayerList", function(currentPlayer, callback, raceId)
	local currentSession = Server.Creator.Sessions[raceId]
	if currentSession then
		local inSessionPlayers = {}
		local availablePlayers = {}
		for k, v in pairs(currentSession.creators) do
			inSessionPlayers[v.playerId] = true
		end
		for k, v in pairs(Server.Players) do
			if not inSessionPlayers[v.id] then
				availablePlayers[#availablePlayers + 1] = {playerId = v.id, playerName = v.name}
			end
		end
		callback(availablePlayers)
	else
		callback({})
	end
end)

CreateServerCallback("server:creator:getPlayerCoords", function(currentPlayer, callback, playerId)
	local creator = GetPlayerPed(playerId)
	if creator ~= 0 then
		callback(GetEntityCoords(creator))
	else
		callback(nil)
	end
end)