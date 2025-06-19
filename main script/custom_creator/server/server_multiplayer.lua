Sessions = {}

RegisterNetEvent("custom_creator:server:createSession", function(raceid, data)
	local playerId = tonumber(source)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	local identifier = nil
	if identifier_license then
		identifier = identifier_license:gsub('license:', '')
	end
	if Sessions[raceid] then return end
	Sessions[raceid] = {
		sessionId = raceid,
		creators = { { playerId = playerId, identifier = identifier } },
		data = data,
		modificationCount = {
			title = 0,
			thumbnail = 0,
			test_vehicle = 0,
			blimp_text = 0,
			transformVehicles = 0,
			startingGrid = 0,
			checkpoints = 0,
			fixtures = 0,
			firework = 0
		}
	}
end)

RegisterNetEvent("custom_creator:server:invitePlayer", function(inviteId, title, sessionId)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	if playerName then
		TriggerClientEvent("custom_creator:client:receiveInvitation", inviteId, title, sessionId, playerName)
	end
end)

RegisterNetEvent("custom_creator:server:syncData", function(raceid, data, str)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local currentSession = Sessions[raceid]
	if currentSession then
		local canSync = false
		if str == "title-sync" then
			if currentSession.modificationCount.title < data.modificationCount then
				currentSession.modificationCount.title = data.modificationCount
				currentSession.data.title = data.title
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { title = currentSession.data.title, modificationCount = currentSession.modificationCount.title }, str)
			end
		elseif str == "thumbnail-sync" then
			if currentSession.modificationCount.thumbnail < data.modificationCount then
				currentSession.modificationCount.thumbnail = data.modificationCount
				currentSession.data.thumbnail = data.thumbnail
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { thumbnail = currentSession.data.thumbnail, modificationCount = currentSession.modificationCount.thumbnail }, str)
			end
		elseif str == "test-vehicle-sync" then
			if currentSession.modificationCount.test_vehicle < data.modificationCount then
				currentSession.modificationCount.test_vehicle = data.modificationCount
				currentSession.data.test_vehicle = data.test_vehicle
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { test_vehicle = currentSession.data.test_vehicle, modificationCount = currentSession.modificationCount.test_vehicle }, str)
			end
		elseif str == "blimp-text-sync" then
			if currentSession.modificationCount.blimp_text < data.modificationCount then
				currentSession.modificationCount.blimp_text = data.modificationCount
				currentSession.data.blimp_text = data.blimp_text
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { blimp_text = currentSession.data.blimp_text, modificationCount = currentSession.modificationCount.blimp_text }, str)
			end
		elseif str == "transformVehicles-sync" then
			if currentSession.modificationCount.transformVehicles < data.modificationCount then
				currentSession.modificationCount.transformVehicles = data.modificationCount
				currentSession.data.transformVehicles = data.transformVehicles
				currentSession.data.checkpoints = data.checkpoints
				currentSession.data.checkpoints_2 = data.checkpoints_2
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { transformVehicles = currentSession.data.transformVehicles, checkpoints = currentSession.data.checkpoints, checkpoints_2 = currentSession.data.checkpoints_2, modificationCount = currentSession.modificationCount.transformVehicles }, str)
			end
		elseif str == "startingGrid-sync" then
			if currentSession.modificationCount.startingGrid < data.modificationCount then
				currentSession.modificationCount.startingGrid = data.modificationCount
				currentSession.data.startingGrid = data.startingGrid
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { startingGrid = currentSession.data.startingGrid, modificationCount = currentSession.modificationCount.startingGrid }, str)
			end
		elseif str == "checkpoints-sync" then
			if currentSession.modificationCount.checkpoints < data.modificationCount then
				currentSession.modificationCount.checkpoints = data.modificationCount
				currentSession.data.checkpoints = data.checkpoints
				currentSession.data.checkpoints_2 = data.checkpoints_2
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { checkpoints = currentSession.data.checkpoints, checkpoints_2 = currentSession.data.checkpoints_2, modificationCount = currentSession.modificationCount.checkpoints }, str)
			end
		elseif str == "fixtures-sync" then
			if currentSession.modificationCount.fixtures < data.modificationCount then
				currentSession.modificationCount.fixtures = data.modificationCount
				currentSession.data.fixtures = data.fixtures
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { fixtures = currentSession.data.fixtures, modificationCount = currentSession.modificationCount.fixtures }, str)
			end
		elseif str == "firework-sync" then
			if currentSession.modificationCount.firework < data.modificationCount then
				currentSession.modificationCount.firework = data.modificationCount
				currentSession.data.firework = data.firework
				canSync = true
			else
				TriggerClientEvent("custom_creator:client:syncData", playerId, { firework = currentSession.data.firework, modificationCount = currentSession.modificationCount.firework }, str)
			end
		elseif str == "objects-place" then
			table.insert(currentSession.data.objects, data)
			canSync = true
		elseif str == "objects-change" then
			for i = 1, #currentSession.data.objects do
				if currentSession.data.objects[i].uniqueId == data.uniqueId then
					if currentSession.data.objects[i].modificationCount < data.modificationCount then
						currentSession.data.objects[i] = data
						canSync = true
					else
						TriggerClientEvent("custom_creator:client:syncData", playerId, currentSession.data.objects[i], str)
					end
					break
				end
			end
		elseif str == "objects-delete" then
			for i = 1, #currentSession.data.objects do
				if currentSession.data.objects[i].uniqueId == data.uniqueId then
					table.remove(currentSession.data.objects, i)
					break
				end
			end
			canSync = true
		elseif str == "template-place" then
			for i = 1, #data do
				table.insert(currentSession.data.objects, data[i])
			end
			canSync = true
		elseif str == "move-all" then
			for i = 1, #currentSession.data.startingGrid do
				currentSession.data.startingGrid[i].x = RoundedValue(currentSession.data.startingGrid[i].x + data.offset_x, 3)
				currentSession.data.startingGrid[i].y = RoundedValue(currentSession.data.startingGrid[i].y + data.offset_y, 3)
				currentSession.data.startingGrid[i].z = RoundedValue(currentSession.data.startingGrid[i].z + data.offset_z, 3)
			end
			for i = 1, #currentSession.data.checkpoints do
				currentSession.data.checkpoints[i].x = RoundedValue(currentSession.data.checkpoints[i].x + data.offset_x, 3)
				currentSession.data.checkpoints[i].y = RoundedValue(currentSession.data.checkpoints[i].y + data.offset_y, 3)
				currentSession.data.checkpoints[i].z = RoundedValue(currentSession.data.checkpoints[i].z + data.offset_z, 3)
				if currentSession.data.checkpoints_2[i] then
					currentSession.data.checkpoints_2[i].x = RoundedValue(currentSession.data.checkpoints_2[i].x + data.offset_x, 3)
					currentSession.data.checkpoints_2[i].y = RoundedValue(currentSession.data.checkpoints_2[i].y + data.offset_y, 3)
					currentSession.data.checkpoints_2[i].z = RoundedValue(currentSession.data.checkpoints_2[i].z + data.offset_z, 3)
				end
			end
			for i = 1, #currentSession.data.objects do
				currentSession.data.objects[i].x = RoundedValue(currentSession.data.objects[i].x + data.offset_x, 3)
				currentSession.data.objects[i].y = RoundedValue(currentSession.data.objects[i].y + data.offset_y, 3)
				currentSession.data.objects[i].z = RoundedValue(currentSession.data.objects[i].z + data.offset_z, 3)
			end
			canSync = true
		end
		if canSync then
			for i = 1, #currentSession.creators do
				if currentSession.creators[i].playerId ~= playerId then
					TriggerClientEvent("custom_creator:client:syncData", currentSession.creators[i].playerId, data, str, playerName)
				end
			end
		end
	end
end)

RegisterNetEvent("custom_creator:server:loadDone", function(raceid)
	local playerId = tonumber(source)
	local currentSession = Sessions[raceid]
	if currentSession then
		for i = 1, #currentSession.creators do
			if currentSession.creators[i].playerId ~= playerId then
				TriggerClientEvent("custom_creator:client:loadDone", currentSession.creators[i].playerId, playerId)
			end
		end
	end
end)

RegisterNetEvent("custom_creator:server:leaveSession", function(raceid)
	local playerId = tonumber(source)
	local currentSession = Sessions[raceid]
	if currentSession then
		local playerName = GetPlayerName(playerId)
		for k, v in pairs(currentSession.creators) do
			if v.playerId == playerId then
				table.remove(currentSession.creators, k)
				break
			end
		end
		if #currentSession.creators == 0 or not currentSession.data then
			Sessions[raceid] = nil
		else
			for i = 1, #currentSession.creators do
				TriggerClientEvent("custom_creator:client:playerLeaveSession", currentSession.creators[i].playerId, playerName, playerId)
			end
		end
	end
end)

CreateServerCallback("custom_creator:server:sessionData", function(source, callback, raceid, data)
	local playerId = tonumber(source)
	local currentSession = Sessions[raceid]
	if currentSession then
		currentSession.data = data
		callback({})
	end
end)

CreateServerCallback("custom_creator:server:joinPlayerSession", function(source, callback, sessionId)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	local identifier = nil
	if identifier_license then
		identifier = identifier_license:gsub('license:', '')
	end
	local currentSession = Sessions[sessionId]
	if currentSession then
		table.insert(currentSession.creators, { playerId = playerId, identifier = identifier })
		for i = 1, #currentSession.creators do
			if currentSession.creators[i].playerId ~= playerId then
				TriggerClientEvent("custom_creator:client:playerJoinSession", currentSession.creators[i].playerId, playerName, playerId)
			end
		end
		while not currentSession.data do
			if not Sessions[raceid] then
				break
			end
			Citizen.Wait(1000)
		end
		Citizen.Wait(3000)
		if currentSession.data and currentSession.modificationCount and currentSession.creators then
			callback(currentSession.data, currentSession.modificationCount, currentSession.creators)
		else
			Sessions[raceid] = nil
			callback(false)
		end
	else
		callback(false)
	end
end)

CreateServerCallback("custom_creator:server:getPlayerList", function(source, callback, raceid)
	local playerId = tonumber(source)
	local currentSession = Sessions[raceid]
	if currentSession then
		local allPlayers = {}
		local inSessionPlayers = {}
		local availablePlayers = {}
		for k, v in pairs(GetPlayers()) do
			if tonumber(v) ~= playerId then
				table.insert(allPlayers, tonumber(v))
			end
		end
		for k, v in pairs(currentSession.creators) do
			inSessionPlayers[v.playerId] = true
		end
		for k, v in pairs(allPlayers) do
			if not inSessionPlayers[v] then
				local playerName = GetPlayerName(v)
				if playerName then
					availablePlayers[#availablePlayers + 1] = {
						playerName = playerName,
						playerId = v
					}
				end
			end
		end
		callback(availablePlayers)
	else
		callback({})
	end
end)