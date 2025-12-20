function FindValidJson(json_url, url, attempt, retry, playerId, cb)
	PerformHttpRequest(json_url, function(statusCode, response, headers)
		if statusCode == 200 then
			print("^7A valid json link was found ^2" .. json_url .. "^7")
			CreatorServer.SearchStatus[playerId] = ""
			local data = json.decode(response) or {}
			data.raceid = nil
			data.published = false
			data.thumbnail = url
			if data.mission and data.mission.race then
				data.mission.race.cptrst = nil
				data.mission.race.cptrsts = nil
			end
			cb(data, true, attempt + 1)
		else
			if statusCode == 404 then
				cb(nil, false, attempt + 1)
			else
				if retry < 3 then
					FindValidJson(json_url, url, attempt + 1, retry + 1, playerId, cb)
				else
					cb(nil, false, attempt + 1)
				end
			end
		end
	end, "GET", "", {["Content-Type"] = "application/json"})
end

function CheckUserRole(discordId, callback)
	local url = string.format("%s/guilds/%s/members/%s", Config.Whitelist.Discord.api_url, Config.Whitelist.Discord.guild_id, discordId)
	PerformHttpRequest(url, function(statusCode, response, headers)
		if statusCode == 200 then
			local data = json.decode(response)
			if data and data.roles then
				for _, role_user in pairs(data.roles) do
					for _, role_permission in pairs(Config.Whitelist.Discord.role_ids) do
						if role_user == role_permission then
							callback(true)
							return
						end
					end
				end
			end
			callback(false)
		else
			callback(false)
		end
	end, "GET", "", {
		["Authorization"] = "Bot " .. Config.Whitelist.Discord.bot_token,
		["Content-Type"] = "application/json"
	})
end

function ExportFileToWebhook(data, discordId, cb)
	local boundary = "----WebKitFormBoundary" .. os.time()
	local headers = {
		["Content-Type"] = "multipart/form-data; boundary=" .. boundary
	}
	local body = "--" .. boundary .. "\r\n" .. "Content-Disposition: form-data; name=\"payload_json\"\r\n\r\n" .. json.encode({content = ((discordId and ("<@" .. discordId .. "> ") or "") .. data.mission.gen.nm)}) .. "\r\n" .. "--" .. boundary .. "\r\n" .. "Content-Disposition: form-data; name=\"file\"; filename=\"" .. data.mission.gen.nm .. ".json\"\r\n" .. "Content-Type: application/json\r\n\r\n" .. json.encode(data) .. "\r\n" .. "--" .. boundary .. "--\r\n"
	PerformHttpRequest(Config.Webhook, function(statusCode)
		cb(statusCode)
	end, "POST", body, headers)
end

function RoundedValue(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end