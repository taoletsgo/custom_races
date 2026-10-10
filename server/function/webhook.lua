function Server.Function.Webhook.Notification(payload, playerName)
	if Config.Discord.Webhook.Notification.Url == "" then return end
	PerformHttpRequest(Config.Discord.Webhook.Notification.Url, function(statusCode, response, headers)
		if statusCode ~= 204 then
			print("^3Failed to send discord message for player: ^1" .. playerName .. "^3, status code: ^1" .. statusCode .. "^0")
		end
	end, "POST", json.encode(payload), {["Content-Type"] = "application/json"})
end

function Server.Function.Webhook.ExportFile(data, discordId, cb)
	local boundary = "----WebKitFormBoundary" .. os.time()
	local headers = {
		["Content-Type"] = "multipart/form-data; boundary=" .. boundary
	}
	local body = "--" .. boundary .. "\r\n" .. "Content-Disposition: form-data; name=\"payload_json\"\r\n\r\n" .. json.encode({content = ((discordId and ("<@" .. discordId .. "> ") or "") .. data.mission.gen.nm)}) .. "\r\n" .. "--" .. boundary .. "\r\n" .. "Content-Disposition: form-data; name=\"file\"; filename=\"" .. data.mission.gen.nm .. ".json\"\r\n" .. "Content-Type: application/json\r\n\r\n" .. json.encode(data) .. "\r\n" .. "--" .. boundary .. "--\r\n"
	PerformHttpRequest(Config.Discord.Webhook.ExportTrack.Url, function(statusCode, response, headers)
		cb(statusCode)
	end, "POST", body, headers)
end