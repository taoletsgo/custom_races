function Server.Function.Player.Init(playerId, playerName)
	local license = GetPlayerIdentifierByType(playerId, "license")
	local discord = GetPlayerIdentifierByType(playerId, "discord")
	local ip = GetPlayerIdentifierByType(playerId, "ip")
	Server.Players[playerId] = {
		id = playerId,
		name = playerName,
		loaded = false,
		license = license and license:gsub("license:", "") or "dev",
		discord = discord and discord:gsub("discord:", ""),
		ip = ip and ip:gsub("ip:", ""),
		group = nil,
		race = {
			bookmarked = {},
			played = {},
			finished = {}
		},
		creator = {
			favorite = {},
			templates = {}
		},
		position = Config.Default.SpawnPos,
		skin = {
			data = {},
			index = 1,
			hash = nil
		},
		weapons = {},
		vehicles = {
			favorite = {},
			saved = {}
		},
		preferences = {},
		role = {},
		color = {255, 255, 255},
		logo = "./img/server.png",
		flag = "US",
		roomId = nil,
		searchStatus = nil,
		searchCache = nil,
		inRace = false,
		inCreator = false,
		inTestMode = false,
		inSpectator = false,
		disableTraffic = true,
		entitys = {}
	}
	Server.PlayerCount = Server.PlayerCount + 1
	return Server.Players[playerId]
end

function Server.Function.Player.GetDiscordInfo(discordId, callback)
	local url = string.format("%s/guilds/%s/members/%s", Config.Discord.Api, Config.Discord.GuildId, discordId)
	PerformHttpRequest(url, function(statusCode, response, headers)
		local role = {}
		local color = {255, 255, 255}
		local logo = "./img/server.png"
		if statusCode == 200 then
			local data = json.decode(response)
			if data then
				if data.roles then
					for _, id in pairs(data.roles) do
						role[tostring(id)] = true
					end
					for i = 1, #Config.Chat do
						if role[tostring(Config.Chat[i].RoleId)] then
							color = Config.Chat[i].Color
							break
						end
					end
				end
				if data.user and data.user.id and data.user.avatar then
					logo = string.format("https://cdn.discordapp.com/avatars/%s/%s.png?size=128", data.user.id, data.user.avatar)
				end
			end
		end
		callback(role, color, logo)
	end, "GET", "", {
		["Authorization"] = "Bot " .. Config.Discord.Token,
		["Content-Type"] = "application/json"
	})
end

function Server.Function.Player.CheckPermission(group, role)
	local permission = {}
	for key, _ in pairs(Config.Permission) do
		permission[key] = Config.Permission[key].Default and true or false
		if group and type(Config.Permission[key].Group) == "table" then
			for i = 1, #Config.Permission[key].Group do
				if group == Config.Permission[key].Group[i] then
					permission[key] = true
					break
				end
			end
		end
		if not permission[key] and type(Config.Permission[key].Discord) == "table" then
			for j = 1, #Config.Permission[key].Discord do
				if role[tostring(Config.Permission[key].Discord[j])] then
					permission[key] = true
					break
				end
			end
		end
	end
	return permission
end

function Server.Function.Player.CheckName(str)
	local bannedWords = {"administrator", "admin", "username", "user", "name", "bmxer", "stunter", "creator", "player", "rockstar", "client", "server"}
	local lowerStr = string.lower(str)
	for k, v in pairs(bannedWords) do
		if string.find(lowerStr, v) then
			return true
		end
	end
	return false
end

function Server.Function.Player.HasJoined(license)
	for k, v in pairs(Server.Players) do
		if v.license == license then
			return true
		end
	end
	return false
end