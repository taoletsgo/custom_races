function FindValidJson(json_url, url, attempt, retry, playerId, cb)
	PerformHttpRequest(json_url, function(statusCode, response, headers)
		if statusCode == 200 then
			print("^7A valid json link was found ^2" .. json_url .. "^7")
			creator_status[playerId] = ""
			local data = json.decode(response)
			data.raceid = nil
			data.published = false
			data.thumbnail = url
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

function SaveUGCFile(resourceName, path, data)
	local keyOrderMap = {}
	keyOrderMap[data] = {"raceid", "published", "contributors", "thumbnail", "test_vehicle", "firework", "meta", "mission"}
	keyOrderMap[data.firework] = {"name", "r", "g", "b"}
	keyOrderMap[data.mission] = {"gen", "dhprop", "dprop", "prop", "race", "veh"}
	keyOrderMap[data.mission.gen] = {"ownerid", "nm", "dec", "type", "subtype", "start", "blmpmsg", "ivm"}
	keyOrderMap[data.mission.dhprop] = {"mn", "pos", "no"}
	keyOrderMap[data.mission.dprop] = {"model", "loc", "vRot", "prpdclr", "collision", "no"}
	keyOrderMap[data.mission.prop] = {"model", "loc", "vRot", "prpclr", "pLODDist", "collision", "prpbs", "prpsba", "no"}
	keyOrderMap[data.mission.race] = {"adlc", "adlc2", "adlc3", "aveh", "clbs", "icv", "chl", "chh", "chs", "chpp", "cpado", "chstR", "cptfrm", "cptrtt", "sndchk", "sndrsp", "chs2", "chpps", "cpados", "chstRs", "cptfrms", "cptrtts", "chvs", "cpbs1", "cpbs2", "cpbs3", "trfmvm", "cppsst", "chp"}
	keyOrderMap[data.mission.veh] = {"loc", "head", "no"}
	local function detectXYZ(tbl)
		if type(tbl) == "table" then
			if tbl.x ~= nil and tbl.y ~= nil and tbl.z ~= nil then
				keyOrderMap[tbl] = {"x", "y", "z"}
			end
			for k, v in pairs(tbl) do
				if type(v) == "table" then
					if #v > 0 then
						for _, item in ipairs(v) do
							detectXYZ(item)
						end
					else
						detectXYZ(v)
					end
				end
			end
		end
	end
	detectXYZ(data)
	local function encodeOrderedJSON(tbl, orderMap)
		local function encodeValue(val)
			local t = type(val)
			if t == "table" then
				if orderMap[val] then
					return encodeOrderedJSON(val, orderMap)
				else
					return json.encode(val)
				end
			elseif t == "string" then
				return string.format('"%s"', val)
			elseif t == "boolean" or t == "number" then
				return tostring(val)
			else
				return "null"
			end
		end
		local order = orderMap[tbl] or {}
		local parts = {"{"}
		for i, key in ipairs(order) do
			local val = tbl[key]
			if val ~= nil then
				table.insert(parts, string.format('"%s":%s', key, encodeValue(val)))
				if i < #order then
					table.insert(parts, ",")
				end
			end
		end
		table.insert(parts, "}")
		return table.concat(parts)
	end
	local ugc = encodeOrderedJSON(data, keyOrderMap)
	SaveResourceFile(resourceName, path, ugc, -1)
end

function ExportFileToWebhook(data, discordId, cb)
	local boundary = "----WebKitFormBoundary" .. os.time()
	local headers = {
		["Content-Type"] = "multipart/form-data; boundary=" .. boundary
	}
	local body = "--" .. boundary .. "\r\n" .. "Content-Disposition: form-data; name=\"payload_json\"\r\n\r\n" .. json.encode({content = ((discordId and ("<@" .. discordId .. "> ") or "") .. data.mission.gen.nm)}) .. "\r\n" .. "--" .. boundary .. "\r\n" .. "Content-Disposition: form-data; name='file'; filename='" .. data.mission.gen.nm .. ".json'\r\n" .. "Content-Type: application/json\r\n\r\n" .. json.encode(data) .. "\r\n" .. "--" .. boundary .. "--\r\n"
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