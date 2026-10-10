RegisterNetEvent("server:creator:saveData", function(data)
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if currentPlayer and data and type(data) == "table" then
		if data.favorite then
			if data.model and type(data.model) == "string" then
				currentPlayer.creator.favorite[data.model] = data.favorite == 1 and true or nil
			end
		elseif data.template then
			if type(data.template) == "table" then
				if #currentPlayer.creator.templates < 30 then
					table.insert(currentPlayer.creator.templates, data.template)
				end
			elseif type(data.template) == "number" then
				if currentPlayer.creator.templates[data.template] then
					table.remove(currentPlayer.creator.templates, data.template)
				end
			end
		end
		local result = MySQL.query.await("SELECT creator FROM users WHERE license = ?", {currentPlayer.license})
		if result and result[1] then
			MySQL.update("UPDATE users SET name = ?, creator = ? WHERE license = ?", {currentPlayer.name, json.encode(currentPlayer.creator), currentPlayer.license})
		else
			MySQL.insert("INSERT INTO users (license, name, creator) VALUES (?, ?, ?)", {currentPlayer.license, currentPlayer.name, json.encode(currentPlayer.creator)})
		end
	end
end)

CreateServerCallback("server:creator:getData", function(currentPlayer, callback)
	local result = {
		[1] = {
			class = "published-races",
			data = {}
		},
		[2] = {
			class = "saved-races",
			data = {}
		}
	}
	local isAdmin = currentPlayer.group == "admin"
	local resultAdmin = {}
	local count = 0
	for k, v in pairs(MySQL.query.await("SELECT * FROM tracks")) do
		local raceId = type(v.id) == "number" and v.id or 0
		local trackName = type(v.name) == "string" and v.name or "unknown"
		local responseData = json.decode(v.data) or {}
		local thumbnail = type(responseData.thumbnail) == "string" and responseData.thumbnail or ""
		local published = type(responseData.published) == "boolean" and responseData.published or false
		if type(responseData.contributors) == "table" then
			for i = 1, #responseData.contributors do
				if currentPlayer.license == responseData.contributors[i] then
					table.insert(result[published and 1 or 2].data, {
						raceId = raceId,
						name = trackName,
						img = thumbnail,
						published = published
					})
					break
				end
			end
		end
		if isAdmin then
			local category = type(responseData.category) == "string" and responseData.category or "Custom"
			resultAdmin[category] = resultAdmin[category] or {}
			table.insert(resultAdmin[category], {
				raceId = raceId,
				name = trackName,
				img = thumbnail,
				published = published
			})
		end
		count = count + 1
		if count >= 500 then
			count = 0
			Wait(0)
		end
	end
	local sortedCategories = {}
	for category in pairs(resultAdmin) do
		table.insert(sortedCategories, category)
	end
	if #sortedCategories >= 2 then
		table.sort(sortedCategories, function(a, b)
			return string.lower(a) < string.lower(b)
		end)
	end
	for i = 1, #sortedCategories do
		result[2 + i] = {
			class = sortedCategories[i],
			data = resultAdmin[sortedCategories[i]]
		}
	end
	for i = 1, #result do
		if #result[i].data >= 2 then
			table.sort(result[i].data, function(a, b)
				return string.lower(a.name) < string.lower(b.name)
			end)
		end
	end
	result[#result + 1] = {
		class = "filter-races",
		data = {}
	}
	TriggerClientEvent("client:creator:info", currentPlayer.id, "track-list", #json.encode(result) * 1.02)
	callback(result)
end)