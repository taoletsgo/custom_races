RegisterNetEvent("server:race:cancelSearch", function()
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer then
		currentPlayer.searchStatus = nil
	end
end)

CreateServerCallback("server:race:searchUGC", function(currentPlayer, callback, url, ugcImg, ugcJson)
	if not string.find(url, "^https://prod%.cloud%.rockstargames%.com/ugc/gta5mission/") then
		callback(nil, nil, nil)
		return
	end
	if ugcJson then
		Server.Function.Track.SearchForRace(url, 99, function(data)
			if data then
				if data.mission and data.mission.gen and data.mission.race and data.mission.race.chp and data.mission.race.chp >= 3 and data.mission.veh and data.mission.veh.loc and #data.mission.veh.loc >= 1 then
					data.mission.race.cptrst = nil
					data.mission.race.cptrsts = nil
					currentPlayer.searchCache = data
					callback((data.mission.gen.nm or "unknown track") .. " (" .. (data.mission.gen.ownerid or "unknown creator") .. ")", GetConvarInt("sv_maxclients", 48), nil)
				else
					callback(nil, nil, "failed")
				end
			else
				callback(nil, nil, "failed")
			end
		end)
	elseif ugcImg then
		currentPlayer.searchStatus = "querying"
		local lang = {"en", "ja", "zh", "zh-cn", "fr", "de", "it", "ru", "pt", "pl", "ko", "es", "es-mx"}
		local path = url:match("(.-)/[^/]+$")
		local found = false
		for i = 0, 2 do
			for j = 0, 500 do
				for k = 1, 13 do
					local urlJson = path .. "/" .. i .. "_" .. j .. "_" .. lang[k] .. ".json"
					local lock = true
					local retry = 0
					Server.Function.Track.SearchForRace(urlJson, retry, function(data, bool)
						found = bool
						lock = false
						if data then
							if data.mission and data.mission.gen and data.mission.race and data.mission.race.chp and data.mission.race.chp >= 3 and data.mission.veh and data.mission.veh.loc and #data.mission.veh.loc >= 1 then
								data.mission.race.cptrst = nil
								data.mission.race.cptrsts = nil
								currentPlayer.searchCache = data
								callback((data.mission.gen.nm or "unknown track") .. " (" .. (data.mission.gen.ownerid or "unknown creator") .. ")", GetConvarInt("sv_maxclients", 48), nil)
							else
								callback(nil, nil, "failed")
							end
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
			callback(nil, nil, currentPlayer.searchStatus and "timed-out" or "cancel")
		end
	else
		callback(nil, nil, "failed")
	end
end)