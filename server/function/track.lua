function Server.Function.Track.SaveFile(filePath, fileData)
	if filePath and fileData then
		SaveResourceFile(Server.ResourceName, filePath, json.encode(fileData), -1)
	end
end

function Server.Function.Track.LoadFile(filePath)
	return json.decode(LoadResourceFile(Server.ResourceName, type(filePath) == "string" and filePath:gsub("^/+", "") or ""))
end

function Server.Function.Track.GetAll()
	if not Server.Track.IsUpdating then
		Server.Track.IsUpdating = true
		CreateThread(function()
			local data = {}
			local maxPlayers = GetConvarInt("sv_maxclients", 48)
			local count = 0
			for k, v in pairs(MySQL.query.await("SELECT * FROM tracks")) do
				local raceId = type(v.id) == "number" and v.id or 0
				local trackName = type(v.name) == "string" and v.name or "unknown"
				local responseData = json.decode(v.data) or {}
				local thumbnail = type(responseData.thumbnail) == "string" and responseData.thumbnail or ""
				local published = type(responseData.published) == "boolean" and responseData.published or false
				local order = type(responseData.updatedDate) == "string" and Server.Function.Shared.ConvertToTimestamp(responseData.updatedDate) or (1 - raceId)
				local category = type(responseData.category) == "string" and responseData.category or "Custom"
				if published then
					data[category] = data[category] or {}
					table.insert(data[category], {
						raceId = tostring(raceId),
						name = trackName,
						img = thumbnail,
						maxPlayers = maxPlayers,
						order = order
					})
				end
				count = count + 1
				if count >= 500 then
					count = 0
					Wait(0)
				end
			end
			count = 0
			for k, v in pairs(data) do
				if #v >= 2 then
					table.sort(v, function(a, b)
						return a.order > b.order
					end)
				end
				for _, track in pairs(v) do
					track.order = nil
				end
				count = count + 1
				if count >= 10 then
					count = 0
					Wait(0)
				end
			end
			data["Custom"] = data["Custom"] or {}
			Server.Track.Data = data
			Server.Track.IsUpdating = false
		end)
	end
end

function Server.Function.Track.Update(raceId, trackName, trackData)
	local sync = true
	local tracks = Server.Track.Data[trackData.category]
	if tracks then
		local found = false
		local newList = {}
		if trackData.published then
			table.insert(newList, {
				raceId = tostring(raceId),
				name = trackName,
				img = trackData.thumbnail,
				maxPlayers = GetConvarInt("sv_maxclients", 48)
			})
		end
		for i = 1, #tracks do
			local track = tracks[i]
			if track.raceId == tostring(raceId) then
				found = true
			else
				table.insert(newList, track)
			end
		end
		if not found and not trackData.published then
			sync = false
		end
		Server.Track.Data[trackData.category] = newList
	else
		Server.Function.Track.GetAll()
	end
	if sync then
		TriggerClientEvent("client:race:info", -1, "data-outdated", {})
	end
end

function Server.Function.Track.SearchForRace(urlJson, retry, cb)
	PerformHttpRequest(urlJson, function(statusCode, response, headers)
		if statusCode == 200 then
			local data = json.decode(response) or {}
			cb(data, true)
		else
			if statusCode == 404 then
				cb(nil, false)
			else
				if retry < 3 then
					Server.Function.Track.SearchForRace(urlJson, retry + 1, cb)
				else
					cb(nil, false)
				end
			end
		end
	end, "GET", "", {["Content-Type"] = "application/json"})
end

function Server.Function.Track.SearchForCreator(urlJson, url, attempt, retry, playerName, cb)
	PerformHttpRequest(urlJson, function(statusCode, response, headers)
		if statusCode == 200 then
			local data = json.decode(response) or {}
			data.raceId = nil
			data.thumbnail = url
			data.published = false
			data.category = "Custom"
			if data.mission then
				if data.mission.gen then
					data.mission.gen.ownerid = playerName
				end
				if data.mission.race then
					data.mission.race.cptrst = nil
					data.mission.race.cptrsts = nil
				end
			end
			cb(data, true, attempt + 1)
		else
			if statusCode == 404 then
				cb(nil, false, attempt + 1)
			else
				if retry < 3 then
					Server.Function.Track.SearchForCreator(urlJson, url, attempt + 1, retry + 1, playerName, cb)
				else
					cb(nil, false, attempt + 1)
				end
			end
		end
	end, "GET", "", {["Content-Type"] = "application/json"})
end