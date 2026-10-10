RegisterNetEvent("server:creator:cancelSearch", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.searchStatus = nil
	end
end)

CreateServerCallback("server:creator:searchUGC", function(currentPlayer, callback, url, ugcImg, ugcJson)
	if not string.find(url, "^https://prod%.cloud%.rockstargames%.com/ugc/gta5mission/") then
		callback(false)
		return
	end
	if ugcJson then
		Server.Function.Track.SearchForCreator(url, "", 0, 99, currentPlayer.name, function(fileData)
			if fileData then
				TriggerClientEvent("client:creator:info", currentPlayer.id, "track-download", #json.encode(fileData) * 1.02)
				callback(fileData)
			else
				callback(false)
			end
		end)
	elseif ugcImg then
		currentPlayer.searchStatus = "querying"
		local lang = {"en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"}
		local path = url:match("(.-)/[^/]+$")
		local found = false
		local attempt = 0
		local startTime = GetGameTimer()
		for i = 0, 2 do
			for j = 0, 500 do
				for k = 1, 13 do
					if GetGameTimer() - startTime > 10000 then
						startTime = GetGameTimer()
						if currentPlayer.searchStatus then
							TriggerClientEvent("client:creator:info", currentPlayer.id, "ugc-wait", attempt)
						end
					end
					local urlJson = path .. "/" .. i .. "_" .. j .. "_" .. lang[k] .. ".json"
					local lock = true
					local retry = 0
					Server.Function.Track.SearchForCreator(urlJson, url, attempt, retry, currentPlayer.name, function(fileData, bool, _attempt)
						found = bool
						attempt = _attempt
						lock = false
						if fileData then
							TriggerClientEvent("client:creator:info", currentPlayer.id, "track-download", #json.encode(fileData) * 1.02)
							callback(fileData)
						end
					end)
					while lock do Wait(0) end
					if found or not currentPlayer.searchStatus then break end
				end
				if found or not currentPlayer.searchStatus then break end
			end
			if found or not currentPlayer.searchStatus then break end
		end
		if not found then
			callback(false)
		end
	else
		callback(false)
	end
end)