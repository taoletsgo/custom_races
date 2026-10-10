CreateThread(function()
	MySQL.Async.execute([[
		CREATE TABLE IF NOT EXISTS `tracks` (
			`id` int(11) NOT NULL AUTO_INCREMENT,
			`name` varchar(200) DEFAULT NULL,
			`data` longtext DEFAULT "[]",
			PRIMARY KEY (`id`) USING BTREE
		)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]], {}, function()
			Server.Function.Track.GetAll()
		end)
	MySQL.Async.execute([[
		CREATE TABLE IF NOT EXISTS `users` (
			`license` varchar(100) DEFAULT NULL,
			`name` varchar(100) DEFAULT NULL,
			`group` varchar(50) DEFAULT NULL,
			`race` longtext DEFAULT NULL,
			`creator` longtext DEFAULT NULL,
			`position` longtext DEFAULT NULL,
			`skin` longtext DEFAULT NULL,
			`weapons` longtext DEFAULT NULL,
			`vehicles` longtext DEFAULT NULL,
			`preferences` longtext DEFAULT NULL,
			PRIMARY KEY (`license`) USING BTREE
		)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])
end)

local function MigrationDataFromV3()
	CreateThread(function()
		Wait(3000)
		print("Migration started")
		local finishedPlayers = {}
		for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_list") or {}) do
			local id = v.raceid
			local name = v.route_file:match("([^/]+)%.json$")
			local oldFilePath = "tracks/" .. name .. ".json"
			local newFilePath = "tracks/" .. id .. " - " .. name .. ".json"
			local bestTimes = json.decode(v.besttimes) or {}
			for _, time in pairs(bestTimes) do
				finishedPlayers[time.name] = finishedPlayers[time.name] or {}
				finishedPlayers[time.name][tostring(id)] = true
			end
			local license = json.decode(v.license)
			local contributors = type(license) == "table" and license or (v.license and {v.license}) or {}
			local data = {
				desc = "",
				filePath = newFilePath,
				thumbnail = v.route_image or "",
				published = v.published ~= "x",
				likeCount = 0,
				playedCount = 0,
				createdDate = nil,
				updatedDate = v.updated_time or nil,
				category = v.category or "Custom",
				tags = {},
				bestTimes = bestTimes,
				contributors = contributors
			}
			local result = MySQL.query.await("SELECT * FROM tracks WHERE id = ?", {id})
			if result and result[1] then
				MySQL.update.await("UPDATE tracks SET name = ?, data = ? WHERE id = ?", {name, json.encode(data), id})
			else
				MySQL.insert.await("INSERT INTO tracks (id, name, data) VALUES (?, ?, ?)", {id, name, json.encode(data)})
			end
			local fileData = Server.Function.Track.LoadFile(oldFilePath)
			if fileData then
				Server.Function.Track.SaveFile(newFilePath, fileData)
			else
				print("Track: [" .. name .. "] does not exist, id: " .. id)
			end
		end
		for k, v in pairs(MySQL.query.await("SELECT * FROM custom_race_users") or {}) do
			local license = v.license or "dev"
			local name = v.name or "unknown"
			local group = v.group or ""
			local race_creator = json.decode(v.race_creator) or {}
			local race = {}
			local creator = {}
			race.bookmarked = {}
			race.played = finishedPlayers[name] or {}
			race.finished = finishedPlayers[name] or {}
			creator.favorite = {}
			creator.templates = race_creator.templates or {}
			local position = json.decode(v.position) or {}
			local skin = json.decode(v.skin) or {}
			local weapons = json.decode(v.weapon) or {}
			local vehicles = {}
			vehicles.favorite = json.decode(v.fav_vehs) or {}
			vehicles.saved = json.decode(v.vehicle_mods) or {}
			local preferences = json.decode(v.preferences) or {}
			for key, value in pairs(race_creator.preferences or {}) do
				if Config.Default.Preferences[key] ~= nil then
					preferences[key] = value
				end
			end
			local result = MySQL.query.await("SELECT * FROM users WHERE license = ?", {license})
			if result and result[1] then
				MySQL.update.await("UPDATE users SET name = ?, `group` = ?, race = ?, creator = ?, position = ?, skin = ?, weapons = ?, vehicles = ?, preferences = ? WHERE license = ?", {name, group, json.encode(race), json.encode(creator), json.encode(position), json.encode(skin), json.encode(weapons), json.encode(vehicles), json.encode(preferences), license})
			else
				MySQL.insert.await("INSERT INTO users (license, name, `group`, race, creator, position, skin, weapons, vehicles, preferences) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", {license, name, group, json.encode(race), json.encode(creator), json.encode(position), json.encode(skin), json.encode(weapons), json.encode(vehicles), json.encode(preferences)})
			end
		end
		print("Migration finished")
	end)
end

--MigrationDataFromV3()