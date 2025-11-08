IdsRacesAll = {}
playerSpawnedVehicles = {}
playerCooldownLicenses = {}
roomServerId = 1000

CreateRaceRoom = function(roomId, data, ownerId, ownerName)
	local currentRace = {
		source = roomId,
		data = data,
		actualTrack = {mode = data.mode},
		status = "waiting",
		ownerId = ownerId,
		ownerName = ownerName,
		syncNextFrame = true,
		isAnyPlayerJoining = false,
		players = {{nick = ownerName, src = ownerId, ownerRace = true, vehicle = false}},
		drivers = {},
		invitations = {},
		playerVehicles = {},
		inJoinProgress = {}
	}
	return setmetatable(currentRace, getmetatable(Races))
end

GetRouteFileByRaceID = function(raceid)
	if raceid then
		local result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = ?", {raceid})
		if result and #result > 0 then
			return result[1].route_file, result[1].category
		end
	end
	return nil, nil
end

function RoundedValue(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

CheckUserRole = function(discordId, callback)
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

CreateServerCallback("custom_races:server:getPlayerList", function(player, callback)
	local playerId = player.src
	local currentRace = Races[IdsRacesAll[playerId]]
	if currentRace and currentRace.status == "waiting" then
		local allPlayers = {}
		local inRoomPlayers = {}
		local availablePlayers = {}
		for k, v in pairs(GetPlayers()) do
			if tonumber(v) ~= playerId then
				table.insert(allPlayers, tonumber(v))
			end
		end
		for k, v in pairs(currentRace.players) do
			inRoomPlayers[v.src] = true
		end
		for k, v in pairs(allPlayers) do
			if not inRoomPlayers[v] and not currentRace.invitations[v] then
				availablePlayers[#availablePlayers + 1] = {id = v, name = GetPlayerName(v) or "unknown"}
			end
		end
		callback(availablePlayers)
	else
		callback({})
	end
end)

CreateServerCallback("custom_races:server:getRoomList", function(player, callback)
	local roomList = {}
	for k, v in pairs(Races) do
		if v.data.accessible == "public" and (v.status == "waiting" or v.status == "loading" or v.status == "racing") then
			table.insert(roomList, {
				roomid = v.source,
				name = v.data.name,
				vehicle = v.data.vehicle,
				creator = v.ownerName,
				players = #v.players .. "/" .. v.data.maxplayers
			})
		end
	end
	callback(roomList)
end)

CreateServerCallback("custom_races:server:permission", function(player, callback, clientOutdated)
	local playerId = player.src
	local playerName = player.name
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local identifier_discord = GetPlayerIdentifierByType(playerId, "discord")
	local identifier = nil
	local discordId = nil
	local permission = false
	local isChecking = false
	if identifier_license then
		identifier = identifier_license:gsub("license:", "")
		for _, license in pairs(Config.Whitelist.License) do
			if (identifier_license == license) or (identifier == license) then
				permission = true
				break
			end
		end
		if not permission then
			local result = MySQL.query.await("SELECT `group` FROM custom_race_users WHERE license = ?", {identifier})
			if result and result[1] then
				for _, group in pairs(Config.Whitelist.Group) do
					if result[1].group == group then
						permission = true
						break
					end
				end
			end
		end
		if not permission and Config.Whitelist.Discord.enable and identifier_discord then
			discordId = identifier_discord:gsub("discord:", "")
			isChecking = true
			CheckUserRole(discordId, function(bool)
				permission = bool
				isChecking = false
			end)
		end
		while isChecking or isUpdatingData do Citizen.Wait(0) end
		if permission then
			callback(true, clientOutdated and races_data_front or nil, nil)
		else
			local cooldownTime = playerCooldownLicenses[identifier]
			if not cooldownTime then
				playerCooldownLicenses[identifier] = GetGameTimer()
				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 10)
					playerCooldownLicenses[identifier] = nil
				end)
				callback(true, clientOutdated and races_data_front or nil, nil)
			else
				callback(false, nil, math.floor((1000 * 60 * 10 - (GetGameTimer() - cooldownTime)) / 1000))
			end
		end
	else
		callback(false, nil, 99999)
	end
end)

RegisterNetEvent("custom_races:server:createRace", function(data)
	local ownerId = tonumber(source)
	local ownerName = GetPlayerName(ownerId)
	if Races[IdsRacesAll[ownerId]] or not ownerName then
		return
	end
	roomServerId = roomServerId + 1
	local roomId = roomServerId
	IdsRacesAll[ownerId] = roomId
	Races[roomId] = nil
	Races[roomId] = CreateRaceRoom(roomId, data, ownerId, ownerName)
	Citizen.CreateThread(function()
		local lastSyncTime = GetGameTimer()
		while true do
			local currentRace = Races[roomId]
			if currentRace then
				if currentRace.status == "waiting" then
					local timeServerSide = GetGameTimer()
					if currentRace.syncNextFrame or (timeServerSide - lastSyncTime > 5000) then
						currentRace.syncNextFrame = false
						lastSyncTime = timeServerSide
						for k, v in pairs(currentRace.players) do
							TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.data.vehicle, timeServerSide)
						end
					end
					if currentRace.isAnyPlayerJoining then
						local lock = false
						for _, _ in pairs(currentRace.inJoinProgress) do
							lock = true
							break
						end
						if not lock then
							currentRace.isAnyPlayerJoining = false
							currentRace.syncNextFrame = true
						end
					end
				elseif currentRace.status == "racing" or currentRace.status == "dnf" then
					local timeServerSide = GetGameTimer()
					local drivers = {}
					for k, v in pairs(currentRace.drivers) do
						v.currentCoords = not v.hasFinished and GetEntityCoords(GetPlayerPed(tostring(v.playerId))) or v.currentCoords
						drivers[v.playerId] = {
							v.playerId,
							v.playerName,
							v.fps,
							v.actualLap,
							v.actualCheckpoint,
							v.vehicle,
							v.lastlap,
							v.bestlap,
							v.totalRaceTime,
							v.totalCheckpointsTouched,
							v.lastCheckpointPair,
							v.hasFinished,
							v.currentCoords,
							v.finishCoords,
							v.dnf
						}
					end
					for k, v in pairs(currentRace.players) do
						TriggerClientEvent("custom_races:client:syncDrivers", v.src, drivers, timeServerSide)
					end
					if currentRace.isAnyPlayerJoining then
						local lock = false
						for _, _ in pairs(currentRace.inJoinProgress) do
							lock = true
							break
						end
						if not lock then
							currentRace.isAnyPlayerJoining = false
						end
					end
				elseif currentRace.status == "ending" or currentRace.status == "invalid" then
					Races[roomId] = nil
					break
				end
			else
				break
			end
			Citizen.Wait(500)
		end
	end)
end)

RegisterNetEvent("custom_races:server:invitePlayer", function(playerId)
	local playerId = tonumber(playerId)
	local inviteId = tonumber(source)
	local currentRace = Races[IdsRacesAll[inviteId]]
	if currentRace and currentRace.status == "waiting" then
		currentRace.InvitePlayer(currentRace, playerId, currentRace.source, inviteId)
	end
end)

RegisterNetEvent("custom_races:server:cancelInvitation", function(playerId)
	local playerId = tonumber(playerId)
	local ownerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[ownerId]]
	if currentRace and currentRace.status == "waiting" and playerId ~= currentRace.ownerId and ownerId == currentRace.ownerId then
		currentRace.RemoveInvitation(currentRace, playerId)
	end
end)

RegisterNetEvent("custom_races:server:acceptInvitation", function(roomId)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local currentRace = Races[tonumber(roomId)]
	if currentRace then
		currentRace.isAnyPlayerJoining = true
		if currentRace.inJoinProgress[playerId] then return end
		currentRace.inJoinProgress[playerId] = true
		if currentRace.status == "waiting" then
			if #currentRace.players < currentRace.data.maxplayers then
				currentRace.AcceptInvitation(currentRace, playerId, playerName, true)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		elseif currentRace.status == "loading" then
			currentRace.InvitePlayer(currentRace, playerId, currentRace.source, nil)
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "race-loading")
		elseif currentRace.status == "racing" then
			if #currentRace.players < currentRace.data.maxplayers then
				currentRace.JoinRaceMidway(currentRace, playerId, playerName, true)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		else
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
		end
		currentRace.inJoinProgress[playerId] = nil
	else
		TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
	end
end)

RegisterNetEvent("custom_races:server:denyInvitation", function(roomId)
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(roomId)]
	if currentRace and currentRace.status == "waiting" then
		currentRace.DenyInvitation(currentRace, playerId)
	end
end)

RegisterNetEvent("custom_races:server:kickPlayer", function(playerId)
	local playerId = tonumber(playerId)
	local ownerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[ownerId]]
	if currentRace and currentRace.status == "waiting" and playerId ~= currentRace.ownerId and ownerId == currentRace.ownerId then
		for k, v in pairs(currentRace.players) do
			if v.src == playerId and v.loaded then
				IdsRacesAll[v.src] = nil
				TriggerClientEvent("custom_races:client:exitRoom", v.src, "kick")
				table.remove(currentRace.players, k)
				currentRace.syncNextFrame = true
				break
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:roomLoaded", function()
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	if currentRace and currentRace.status == "waiting" then
		for k, v in pairs(currentRace.players) do
			if v.src == playerId then
				v.loaded = true
				currentRace.syncNextFrame = true
				break
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:leaveRoom", function()
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	if currentRace and currentRace.status == "waiting" then
		if playerId == currentRace.ownerId then
			currentRace.status = "invalid"
			for k, v in pairs(currentRace.players) do
				IdsRacesAll[v.src] = nil
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "leave")
				else
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "")
				end
			end
			races_data_web_caches[currentRace.ownerId] = nil
		else
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[v.src] = nil
					TriggerClientEvent("custom_races:client:exitRoom", playerId, "")
					table.remove(currentRace.players, k)
					currentRace.syncNextFrame = true
					break
				end
			end
		end
	elseif not currentRace then
		IdsRacesAll[playerId] = nil
		TriggerClientEvent("custom_races:client:exitRoom", playerId, "")
	end
end)

RegisterNetEvent("custom_races:server:joinPublicRoom", function(roomId)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	local currentRace = Races[tonumber(roomId)]
	if currentRace then
		currentRace.isAnyPlayerJoining = true
		if currentRace.inJoinProgress[playerId] then return end
		currentRace.inJoinProgress[playerId] = true
		if currentRace.status == "waiting" then
			if #currentRace.players < currentRace.data.maxplayers then
				currentRace.AcceptInvitation(currentRace, playerId, playerName, false)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		elseif currentRace.status == "loading" then
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "race-loading")
		elseif currentRace.status == "racing" then
			if #currentRace.players < currentRace.data.maxplayers then
				currentRace.JoinRaceMidway(currentRace, playerId, playerName, false)
			else
				TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-full")
			end
		else
			TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
		end
		currentRace.inJoinProgress[playerId] = nil
	else
		TriggerClientEvent("custom_races:client:joinRoomFailed", playerId, "room-null")
	end
end)

RegisterNetEvent("custom_races:server:setPlayerVehicle", function(vehicle)
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	if currentRace and currentRace.status == "waiting" and vehicle then
		if currentRace.data.vehicle == "specific" then
			if playerId == currentRace.ownerId then
				for k, v in pairs(currentRace.players) do
					v.vehicle = vehicle.label
				end
				currentRace.actualTrack.predefinedVehicle = vehicle.mods
				currentRace.syncNextFrame = true
			end
		elseif currentRace.data.vehicle == "personal" then
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					v.vehicle = vehicle.label
					currentRace.playerVehicles[playerId] = vehicle.mods
					currentRace.actualTrack.predefinedVehicle = vehicle.mods
					currentRace.syncNextFrame = true
					break
				end
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:startRace", function()
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	if currentRace and currentRace.status == "waiting" and playerId == currentRace.ownerId and not currentRace.isAnyPlayerJoining then
		currentRace.StartRaceRoom(currentRace, currentRace.data.raceid)
	end
end)

RegisterNetEvent("custom_races:server:clientSync", function(data, timeClientSide)
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	local currentDriver = currentRace and currentRace.drivers[playerId]
	if currentRace and (currentRace.status == "racing" or currentRace.status == "dnf") and currentDriver and (currentDriver.timeClientSide < timeClientSide) then
		currentRace.ClientSync(currentRace, currentDriver, data, timeClientSide)
	end
end)

RegisterNetEvent("custom_races:server:playerFinish", function(data, timeClientSide, hasCheated, finishCoords, raceStatus)
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	local currentDriver = currentRace and currentRace.drivers[playerId]
	if currentRace and (currentRace.status == "racing" or currentRace.status == "dnf") and currentDriver then
		currentRace.ClientSync(currentRace, currentDriver, data, timeClientSide)
		currentRace.PlayerFinish(currentRace, currentDriver, hasCheated, finishCoords, raceStatus)
	end
end)

RegisterNetEvent("custom_races:server:spectatePlayer", function(spectateId, actionFromUser)
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	local currentDriver = currentRace and currentRace.drivers[playerId]
	if currentRace and (currentRace.status == "racing" or currentRace.status == "dnf") and currentDriver then
		local spectateId = tonumber(spectateId)
		currentDriver.spectateId = spectateId
		if not actionFromUser then return end
		local name_A = GetPlayerName(playerId)
		local name_B = GetPlayerName(spectateId)
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:whoSpectateWho", v.src, name_A, name_B)
		end
	end
end)

RegisterNetEvent("custom_races:server:syncParticleFx", function(effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	local currentDriver = currentRace and currentRace.drivers[playerId]
	if currentRace and (currentRace.status == "racing" or currentRace.status == "dnf") and currentDriver then
		for k, v in pairs(currentRace.players) do
			if v.src ~= playerId then
				TriggerClientEvent("custom_races:client:syncParticleFx", v.src, playerId, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
			end
		end
	end
end)

RegisterNetEvent("custom_races:server:leaveRace", function()
	local playerId = tonumber(source)
	local currentRace = Races[IdsRacesAll[playerId]]
	local currentDriver = currentRace and currentRace.drivers[playerId]
	if currentRace and (currentRace.status == "racing" or currentRace.status == "dnf") and currentDriver then
		currentRace.LeaveRace(currentRace, playerId, currentDriver.playerName)
	end
end)

RegisterNetEvent("custom_races:server:spawnVehicle", function(vehNetId)
	local playerId = tonumber(source)
	playerSpawnedVehicles[playerId] = vehNetId
end)

RegisterNetEvent("custom_races:server:deleteVehicle", function(vehId)
	local vehicle = NetworkGetEntityFromNetworkId(vehId)
	Citizen.CreateThread(function()
		-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
		-- Sometimes it happens lol, with a probability of 0.000000000001%
		-- If the vehicle exists, delete it
		if DoesEntityExist(vehicle) then
			DeleteEntity(vehicle)
		end
	end)
end)

AddEventHandler("playerDropped", function()
	local playerId = tonumber(source)
	local vehNetId = playerSpawnedVehicles[playerId]
	if vehNetId then
		Citizen.CreateThread(function()
			-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
			-- Sometimes it happens lol, with a probability of 0.000000000001%
			-- If the vehicle exists, delete it
			local attempt = 0
			while DoesEntityExist(NetworkGetEntityFromNetworkId(vehNetId)) and (attempt < 10) do
				attempt = attempt + 1
				DeleteEntity(NetworkGetEntityFromNetworkId(vehNetId))
				Citizen.Wait(200)
			end
		end)
		playerSpawnedVehicles[playerId] = nil
	end
	Citizen.Wait(1000)
	races_data_web_caches[playerId] = nil
	rockstar_search_status[playerId] = nil
	IdsRacesAll[playerId] = nil
	for k, v in pairs(Races) do
		if not (v.status == "ending") then
			v.PlayerDropped(v, playerId)
		end
	end
end)

AddEventHandler("onResourceStart", function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			local version = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
			if not string.find(version, "dev") then
				PerformHttpRequest("https://raw.githubusercontent.com/taoletsgo/custom_races/refs/heads/main/main%20script/version_check.json", function (err, updatedata, headers)
					if updatedata ~= nil then
						local data = json.decode(updatedata)
						if data.custom_races ~= version then
							print("^1=======================================================================================^0")
							print("^1("..GetCurrentResourceName()..") is outdated!^0")
							print("Latest version: (^2"..data.custom_races.."^0) https://github.com/taoletsgo/custom_races/releases/")
							print("^1=======================================================================================^0")
						end
					end
				end, "GET", "")
			end
		end)
	end
end)