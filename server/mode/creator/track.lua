CreateServerCallback("server:creator:getTrack", function(currentPlayer, callback, raceId)
	if not raceId then return end
	local permission = false
	local isAdmin = currentPlayer.group == "admin"
	local trackName = nil
	local filePath = nil
	local thumbnail = nil
	local published = false
	local category = "Custom"
	local result = MySQL.query.await("SELECT * FROM tracks WHERE id = ?", {raceId})
	if result and result[1] then
		if type(result[1].name) == "string" then
			trackName = result[1].name
		end
		local responseData = json.decode(result[1].data) or {}
		if type(responseData.contributors) == "table" then
			for i = 1, #responseData.contributors do
				if currentPlayer.license == responseData.contributors[i] then
					permission = true
					break
				end
			end
		end
		if permission or isAdmin then
			local currentSession = Server.Creator.Sessions[raceId]
			if currentSession then
				table.insert(currentSession.creators, {playerId = currentPlayer.id, license = currentPlayer.license, playerName = currentPlayer.name})
				for k, v in pairs(currentSession.creators) do
					if v.playerId ~= currentPlayer.id then
						TriggerClientEvent("client:creator:playerJoinSession", v.playerId, currentPlayer.name, currentPlayer.id)
					end
				end
				TriggerClientEvent("client:creator:info", currentPlayer.id, "join-session-trying")
				while not currentSession.data do
					if not Server.Creator.Sessions[raceId] then
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
					return
				end
			end
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
			if type(responseData.filePath) == "string" then
				filePath = responseData.filePath
			end
			if type(responseData.thumbnail) == "string" then
				thumbnail = responseData.thumbnail
			end
			if type(responseData.published) == "boolean" then
				published = responseData.published
			end
			if type(responseData.category) == "string" then
				category = responseData.category
			end
			if filePath then
				local fileData = Server.Function.Track.LoadFile(filePath)
				if fileData then
					fileData.raceId = raceId
					fileData.thumbnail = thumbnail
					fileData.published = published
					fileData.category = category
					if fileData.mission and fileData.mission.gen then
						fileData.mission.gen.nm = trackName
					end
					fileData.contributors = nil
					if Server.Players[currentPlayer.id] then
						TriggerClientEvent("client:creator:info", currentPlayer.id, "track-download", #json.encode(fileData) * 1.02)
						callback(fileData)
						return
					end
				end
			end
		end
	end
	Server.Creator.Sessions[raceId] = nil
	callback(false)
end)

CreateServerCallback("server:creator:saveTrack", function(currentPlayer, callback, fileData, action)
	if not fileData or not action then return end
	local found = false
	local raceId = fileData.raceId
	local currentSession = Server.Creator.Sessions[raceId]
	local trackName = fileData.mission.gen.nm:gsub("%%s", "")
	local desc = fileData.mission.gen.dec
	local filePath = "tracks/%s - " .. trackName .. ".json"
	local thumbnail = fileData.thumbnail
	local published = action == "publish" or action == "update"
	local likeCount = 0
	local playedCount = 0
	local createdDate = nil
	local updatedDate = os.date("%Y/%m/%d %H:%M:%S", os.time())
	local category = fileData.category
	local tags = {}
	local bestTimes = {}
	local contributors = {}
	if raceId then
		local result = MySQL.query.await("SELECT * FROM tracks WHERE id = ?", {raceId})
		if result and result[1] then
			local responseData = json.decode(result[1].data) or {}
			if type(responseData.likeCount) == "number" then
				likeCount = responseData.likeCount
			end
			if type(responseData.playedCount) == "number" then
				playedCount = responseData.playedCount
			end
			if type(responseData.createdDate) == "string" then
				createdDate = responseData.createdDate
			end
			if type(responseData.tags) == "table" then
				tags = responseData.tags
			end
			if type(responseData.bestTimes) == "table" then
				bestTimes = responseData.bestTimes
			end
			if type(responseData.contributors) == "table" then
				contributors = responseData.contributors
			end
			if category == "Custom" then
				if currentSession then
					local seen = {}
					for i = 1, #contributors do
						seen[contributors[i]] = true
					end
					for k, v in pairs(currentSession.creators) do
						if v.license and not seen[v.license] then
							seen[v.license] = true
							table.insert(contributors, v.license)
						end
					end
				end
				if currentPlayer.license == contributors[1] then
					fileData.mission.gen.ownerid = currentPlayer.name
				end
			end
			found = true
		end
	else
		if action == "publish" or action == "save" then
			raceId = MySQL.insert.await("INSERT INTO tracks (name, data) VALUES (?, ?)", {"", "[]"})
			fileData.raceId = raceId
			fileData.mission.gen.ownerid = currentPlayer.name
			createdDate = updatedDate
			table.insert(contributors, currentPlayer.license)
			found = raceId and true or false
		end
	end
	if not found then
		callback(nil, nil, nil)
		return
	end
	local trackData = {
		desc = desc,
		filePath = string.format(filePath, raceId),
		thumbnail = thumbnail,
		published = published,
		likeCount = likeCount,
		playedCount = playedCount,
		createdDate = createdDate,
		updatedDate = updatedDate,
		category = category,
		tags = tags,
		bestTimes = bestTimes,
		contributors = contributors
	}
	MySQL.update("UPDATE tracks SET name = ?, data = ? WHERE id = ?",
	{
		trackName,
		json.encode(trackData),
		raceId
	}, function(affectedRows)
		if affectedRows then
			fileData.published = published
			fileData.contributors = contributors
			if currentSession then
				for k, v in pairs(currentSession.creators) do
					if v.playerId ~= currentPlayer.id then
						TriggerClientEvent("client:creator:syncSession", v.playerId, {published = published and "√" or "x", action = action}, "published-status", currentPlayer.name)
					end
				end
				currentSession.data.Published = published
			end
			Server.Function.Track.SaveFile(trackData.filePath, fileData)
			Server.Function.Track.Update(raceId, trackName, trackData)
			callback("success", raceId, fileData.mission.gen.ownerid)
		else
			callback(nil, nil, nil)
		end
	end)
end)