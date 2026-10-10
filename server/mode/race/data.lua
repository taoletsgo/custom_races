RegisterNetEvent("server:race:saveData", function(data)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and data and type(data) == "table" then
		if data.bookmarked then
			if data.raceId and type(data.raceId) == "string" then
				currentPlayer.race.bookmarked[data.raceId] = data.bookmarked == 1 and true or nil
			end
		elseif data.played then
			if data.raceId and type(data.raceId) == "string" then
				currentPlayer.race.played[data.raceId] = true
			end
		elseif data.finished then
			if data.raceId and type(data.raceId) == "string" then
				currentPlayer.race.finished[data.raceId] = true
			end
		end
		local result = MySQL.query.await("SELECT race FROM users WHERE license = ?", {currentPlayer.license})
		if result and result[1] then
			MySQL.update("UPDATE users SET name = ?, race = ? WHERE license = ?", {currentPlayer.name, json.encode(currentPlayer.race), currentPlayer.license})
		else
			MySQL.insert("INSERT INTO users (license, name, race) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(currentPlayer.race)})
		end
	end
end)

RegisterNetEvent("server:race:saveFavorite", function(data, flag)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and data and flag and type(data) == "table" then
		if flag == 2 then
			currentPlayer.vehicles.favorite = data
		elseif flag == 1 then
			if data.favorite then
				currentPlayer.vehicles.favorite[data.favorite] = true
			end
		elseif flag == 0 then
			if data.favorite then
				currentPlayer.vehicles.favorite[data.favorite] = nil
			end
		end
		local result = MySQL.query.await("SELECT vehicles FROM users WHERE license = ?", {currentPlayer.license})
		if result and result[1] then
			MySQL.update("UPDATE users SET name = ?, vehicles = ? WHERE license = ?", {currentPlayer.name, json.encode(currentPlayer.vehicles), currentPlayer.license})
		else
			MySQL.insert("INSERT INTO users (license, name, vehicles) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(currentPlayer.vehicles)})
		end
	end
end)