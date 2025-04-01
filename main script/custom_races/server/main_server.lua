if "esx" == Config.Framework then
	if GetResourceState("es_extended") == "started" then
		ESX = exports["es_extended"]:getSharedObject()
	else
		Citizen.CreateThread(function()
			print('^1=============================================^0')
			print('^1es_extended does not exist or is not started.^0')
			print('^1=============================================^0')
		end)
	end
elseif "qb" == Config.Framework then
	if GetResourceState("qb-core") == "started" then
		QBCore = exports["qb-core"]:GetCoreObject()
	else
		Citizen.CreateThread(function()
			print('^1=========================================^0')
			print('^1qb-core does not exist or is not started.^0')
			print('^1=========================================^0')
		end)
	end
elseif "standalone" == Config.Framework then
	Citizen.CreateThread(function()
		print('^5['.. GetResourceMetadata(GetCurrentResourceName(), 'version', 0) ..'] ^2' .. GetCurrentResourceName() .. ' is in standalone mode, currently cannot load personal vehicles for players. ^3But you can modify the code yourself according to your garage script.^0')
	end)
else
	Citizen.CreateThread(function()
		print('^1================================================================================================^0')
		print([[^1Config.Framework ~= "esx" / "qb" / "standalone", please make sure you enter the correct string.^0]])
		print('^1================================================================================================^0')
	end)
end

IdsRacesAll = {} -- Table to store all room IDs associated with players
playerSpawnedVehicles = {} -- Table to store vehicles spawned by players
roomServerId = 1000 -- Initial server room ID, starting from 1000

--- Function to create a new race and store it in the Races table
--- @param roomId number The ID of the race room
--- @param data table The data related to the race
--- @param name string The name of the race
--- @param ownerId number The ID of the player who owns the race
CreateRaceFunction = function(roomId, data, name, ownerId)
	-- Remove any existing race with the same roomId
	Races[roomId] = nil

	-- Create and store a new race
	Races[roomId] = NewRace(roomId, data, name, ownerId)
end

--- Function to create a new race room and initializes its properties
--- @param roomId number The ID of the race room
--- @param data table The data configuration for the race
--- @param name string The name of the race
--- @param ownerId number The ID of the player who owns the race
--- @return table The newly created race object
NewRace = function(roomId, data, name, ownerId)
	local currentRace = {
		source = roomId,
		data = data,
		actualTrack = {
			mode = data.mode
		},
		finishedCount = 0,
		status = "waiting",
		nameRace = name,
		creator = GetPlayerName(ownerId),
		players = {{
			nick = GetPlayerName(ownerId),
			src = ownerId,
			ownerRace = true,
			vehicle = false
		}},
		drivers = {},
		invitations = {},
		playervehicles = {},
		playerstatus = {
			[ownerId] = "inroom"
		},
		NfStarted = false,
		isFinished = false
	}
	IdsRacesAll[tostring(ownerId)] = tostring(roomId)
	Races[roomId] = currentRace
	return setmetatable(currentRace, getmetatable(Races))
end

-- Function to get the actual path of route_file
--- @param raceid number The ID of the race in sql
--- @return string|nil The data of the route file and category if found, or nil if not found
GetRouteFileByRaceID = function(raceid)
	if raceid then
		local result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = raceid})
		if result and #result > 0 then
			return result[1].route_file, result[1].category
		end
	end
	return nil, nil
end

--- Function to start the race session
--- @param roomId number The ID of the race room
startSession = function(roomId)
	local players = {}
	local currentRace = Races[tonumber(roomId)]

	-- Collect IDs of all players in the race
	for k, v in pairs(currentRace.players) do
		table.insert(players, v.src)

		-- Trigger the client event to count down and initiate player sessions
		TriggerClientEvent("custom_races:countDown", v.src)
		currentRace.StartPlayerSession(currentRace, v.src, v.nick)
	end

	currentRace.status = "loading_done"

	-- Wait for 5 seconds before starting the race
	Citizen.Wait(5000)
	startCurrentRace(currentRace, players)
end

--- Function to start the race
--- @param currentRace table The current race object
--- @param players table List of players in the race
startCurrentRace = function(currentRace, players)
	local list = {}

	-- Create a copy of the players list
	for k, v in pairs(players) do
		list[k] = v
	end

	-- Randomize the grid positions for the players
	for gridPosition = 1, #list do
		local randomIndex = math.random(1, #list)
		local playerId = list[randomIndex]
		table.remove(list, randomIndex)
		local car = currentRace.playervehicles[playerId] or currentRace.actualTrack.predefveh
		-- Trigger the client event to synchronize the player's grid position and vehicle
		TriggerClientEvent("custom_races:showRaceInfo", playerId, gridPosition, car)
	end

	-- Sync the driver information to all players in the race
	local timeServerSide = GetGameTimer()
	for k, v in pairs(players) do
		TriggerClientEvent("custom_races:hereIsTheDriversInfo", v, currentRace.drivers, timeServerSide)
	end

	-- Create a thread to trigger a client event for all players to start race after 5 seconds
	Citizen.CreateThread(function()
		Citizen.Wait(5000)
		for k, v in pairs(players) do
			TriggerClientEvent("custom_races:startRace", v)
			currentRace.playerstatus[tonumber(v)] = "racing"
		end
	end)
end

--- Function to get a list of all players except the specified player
--- @param playerId number The ID of the player to exclude from the list
--- @return table A list of player IDs excluding the specified player
GetPlayerList = function(playerId)
	local activeList = {}

	-- Iterate through all players
	for k, v in pairs(GetPlayers()) do
		-- Add players to the list, excluding the specified player
		if v ~= playerId then
			table.insert(activeList, v)
		end
	end

	return activeList
end

--- Function to fetch a list of available players
--- @param playerId number The ID of the player requesting the list
--- @param currentRace table The current race object containing active players and invitations
--- @return table A list of player data objects for players who are not already in the race or invited
FetchPlayerList = function(playerId, currentRace)

	-- Get a list of all players excluding the specified player
	local playerList = GetPlayerList(playerId)

	local activePlayers = {}
	local availablePlayers = {}

	-- Mark players currently in the race as active
	for k, v in pairs(currentRace.players) do
		activePlayers[v.src] = true
	end

	-- Iterate through the player list and filter out active and invited players
	for index, player in pairs(playerList) do
		local player = tonumber(player)
		if player ~= playerId and not activePlayers[player] and not currentRace.invitations[tostring(player)] then
			local playerData = {}
			playerData.id = player
			playerData.name = GetPlayerName(player)

			-- Add player data to the available players list
			availablePlayers[#availablePlayers + 1] = playerData
		end
	end

	return availablePlayers
end

--- Function to check discord roles
--- @param discordId str
--- @param callback function
CheckUserRole = function(discordId, callback)
	local url = string.format("%s/guilds/%s/members/%s", Config.Discord.api_url, Config.Discord.guild_id, discordId)
	PerformHttpRequest(url, function(statusCode, response, headers)
		if statusCode == 200 then
			local data = json.decode(response)
			if data and data.roles then
				for _, role_user in pairs(data.roles) do
					for _, role_permission in pairs(Config.Discord.role_ids) do
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
		["Authorization"] = "Bot " .. Config.Discord.bot_token,
		["Content-Type"] = "application/json"
	})
end

--- Server callback to retrieve a list of available players for a specific race
--- @param source number The ID of the requesting player
--- @param callback function The callback function to return the player list
CreateServerCallback("custom_races:callback:getPlayerList", function(source, callback)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	-- Fetch the list of available players if the race exists
	if currentRace then
		local playerList = FetchPlayerList(playerId, currentRace)
		callback(playerList)
	else
		callback({})
	end
end)

--- Server callback to retrieve a list of accessible races
--- @param source number The ID of the player requesting the race list
--- @param callback function The callback function to return the race list
CreateServerCallback("custom_races:raceList", function(source, callback)
	local raceList = {}

	-- Iterate through all races
	for k, v in pairs(Races) do
		-- Check if the race is public and not finished and not dnf
		if v.data.accessible == "public" and not v.isFinished and not v.NfStarted then
			-- Find the owner/creator of the race
			for a, b in pairs(v.players) do
				if b.ownerRace then
					-- Add race details to the list
					table.insert(raceList, {
						name = v.nameRace,
						creator = v.creator,
						players = #v.players .. "/" .. v.data.maxplayers,
						roomid = v.source,
						vehicle = v.data.vehicle
					})
				end
			end
		end
	end

	-- Return the list of races to the client
	callback(raceList)
end)

--- Server callback to check permission
--- @param source number The ID of the player
--- @param callback function The callback function to return the permission
--- @param clientOutdated boolean Determine whether a pull update is needed
CreateServerCallback('custom_races:server:permission', function(source, callback, clientOutdated)
	local playerId = tonumber(source)
	local identifier_license = GetPlayerIdentifierByType(playerId, 'license')
	if identifier_license then
		local identifier = identifier_license:gsub('license:', '')
		if Config.Discord.enable then
			local identifier_discord = GetPlayerIdentifierByType(playerId, 'discord')
			if identifier_discord then
				local discordId = identifier_discord:gsub('discord:', '')
				CheckUserRole(discordId, function(bool)
					if bool then
						while isUpdatingData do Citizen.Wait(0) end
						callback(true, clientOutdated and races_data_front or nil)
					else
						while isUpdatingData do Citizen.Wait(0) end
						callback(false, clientOutdated and races_data_front or nil)
					end
				end)
			else
				while isUpdatingData do Citizen.Wait(0) end
				callback(false, clientOutdated and races_data_front or nil)
			end
		else
			local hasPermission = false
			for _, role_permission in pairs(Config.Discord.whitelist_license) do
				if identifier_license == role_permission then
					hasPermission = true
					break
				end
			end
			if hasPermission then
				while isUpdatingData do Citizen.Wait(0) end
				callback(true, clientOutdated and races_data_front or nil)
			else
				while isUpdatingData do Citizen.Wait(0) end
				callback(false, clientOutdated and races_data_front or nil)
			end
		end
	else
		while isUpdatingData do Citizen.Wait(0) end
		callback(false, clientOutdated and races_data_front or nil)
		print(GetPlayerName(playerId) .. "does not have a valid license")
	end
end)

--- Event handler for creating a custom race
--- @param data table
RegisterNetEvent("custom_races:server:createRace", function(data)
	-- Get the owner's ID (player ID of the source)
	local ownerId = tonumber(source)

	-- Increment the server room ID
	roomServerId = roomServerId + 1

	-- Store the current room ID
	local roomId = roomServerId

	-- Create the race with the provided data, name, and owner ID
	CreateRaceFunction(roomId, data, data.name, ownerId)

	-- Trigger a client event to send the room ID back to the owner
	TriggerClientEvent("custom_races:hereIsRoomId", ownerId, roomId)
end)

--- Event handler for inviting a player to a race
--- @param inviteData table The data for the invitation, including player ID
--- @field idPlayer number The ID of the player being invited
RegisterNetEvent("custom_races:server:invitePlayer", function(inviteData)
	-- Get the ID of the player being invited
	local playerId = tonumber(inviteData.idPlayer)

	-- Get the ID of the player sending the invite (source)
	local inviteId = tonumber(source)

	-- Retrieve the current race based on the invite sender's ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(inviteId)])]

	-- Invite the player to the race
	if currentRace then
		currentRace.invitePlayer(currentRace, playerId, currentRace.source, inviteId)
	end
end)

--- Event handler for canceling an invitation
--- @param data table The data containing the player ID of the invitation to be canceled
--- @field player number The ID of the player whose invitation is to be canceled
RegisterNetEvent("custom_races:cancelInvi", function(data)
	-- Get the ID of the player issuing the invitation cancel request (source)
	local ownerId = tonumber(source)

	-- Retrieve the current race based on the owner ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(ownerId)])]

	-- Remove the specified player's invitation if the race exists
	if currentRace then
		currentRace.removeInvitation(currentRace, tonumber(data.player))
	end
end)

--- Event handler for accepting a race invitation
--- @param roomId number The ID of the race room to join
RegisterNetEvent("custom_races:server:acceptInvitation", function(roomId)
	-- Check if the race room exists
	if not Races[tonumber(roomId)] or Races[tonumber(roomId)].NfStarted then
		TriggerClientEvent("custom_races:RoomNull", source)
		return
	end

	-- Get the player ID from the source
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)

	-- Retrieve the current race based on the room ID
	local currentRace = Races[tonumber(roomId)]
	currentRace.playerstatus[playerId] = "joining"

	while currentRace.status == "loading" do
		Citizen.Wait(0)
	end

	-- Check if the number of players is below the maximum allowed
	if #currentRace.players < currentRace.data.maxplayers then
		-- Handle invitation based on the race status
		if currentRace.status == "waiting" then
			-- Accept the invitation
			currentRace.acceptInvitation(currentRace, playerId, playerName, true)

			-- Update room id to client
			TriggerClientEvent("custom_races:hereIsRoomId", playerId, currentRace.source)
			currentRace.playerstatus[playerId] = "inroom"
		elseif currentRace.status == "racing" or currentRace.status == "loading_done" then
			-- Accept the invitation for an ongoing race
			currentRace.acceptInvitation(currentRace, playerId, playerName, false)

			-- Update room id to client
			TriggerClientEvent("custom_races:hereIsRoomId", playerId, currentRace.source)

			-- Send track to client
			TriggerClientEvent("custom_races:loadTrack", playerId, currentRace.data, currentRace.actualTrack, currentRace.actualTrack.props, currentRace.actualTrack.dprops, currentRace.actualweatherAndTime, currentRace.actualTrack.laps)

			-- Start the player's session in the race after 2 seconds
			Citizen.Wait(2000)
			currentRace.StartPlayerSession(currentRace, playerId, playerName)

			-- Trigger the client event to synchronize the player's grid position and vehicle after 3 seconds
			Citizen.Wait(3000)
			TriggerClientEvent("custom_races:showRaceInfo", playerId, 1, currentRace.actualTrack.predefveh)

			-- Sync the driver information to all players in the race
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers, timeServerSide)
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:playerJoinRace", v.src, playerName)
				end
			end

			-- Trigger the client event for the player to start race after 5 seconds
			Citizen.Wait(5000)
			TriggerClientEvent("custom_races:startRace", playerId)
			currentRace.playerstatus[playerId] = "racing"
		end
	else
		-- Notify the player that the maximum number of players has been reached
		TriggerClientEvent("custom_races:client:maxplayers", playerId)
		currentRace.playerstatus[playerId] = nil
	end
end)

--- Event handler for denying a race invitation
--- @param roomId number The ID of the race room to which the invitation was sent
RegisterNetEvent("custom_races:server:denyInvitation", function(roomId)
	-- Retrieve the current race based on the room ID
	local currentRace = Races[tonumber(roomId)]

	-- Deny the invitation if the race exists
	if currentRace then
		currentRace.denyInvitation(currentRace, source)
	end
end)

--- Event handler for kicking a player from a race room
--- @param playerId number The ID of the player to be kicked
RegisterNetEvent("custom_races:kickPlayer", function(playerId)
	-- Convert playerId to a number
	local playerId = tonumber(playerId)

	-- Get the ID of the player issuing the kick command (source)
	local ownerId = tonumber(source)

	-- Retrieve the current race based on the owner ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(ownerId)])]

	if currentRace then
		-- Iterate through the list of players in the current race
		for k, v in pairs(currentRace.players) do
			if v.src == playerId then
				-- Remove the kicked player from the IdsRacesAll table
				IdsRacesAll[tostring(v.src)] = nil

				-- Notify the player to exit the race room
				TriggerClientEvent("custom_races:client:exitRoom", v.src, "kick")

				-- Remove the player from the race's player list
				table.remove(currentRace.players, k)
				break
			end
		end

		-- Sync the updated player list with the remaining players
		local timeServerSide = GetGameTimer()
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
		end
	end
end)

--- Event handler for a player leaving a race room
--- @param roomId number The ID of the race room the player is leaving
RegisterNetEvent("custom_races:leaveRoom", function(roomId)
	-- Get the ID of the player requesting to leave (source)
	local playerId = tonumber(source)

	-- Retrieve the current race based on the room ID
	local currentRace = Races[tonumber(roomId)]

	if currentRace then
		local canKickAll = false

		-- Check if the player is an owner of the race
		for k, v in pairs(currentRace.players) do
			if v.src == playerId and v.ownerRace then
				canKickAll = true
				break
			end
		end

		if canKickAll then
			-- If the player is the owner, kick all players from the race
			for k, v in pairs(currentRace.players) do
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "leave")
				else
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "")
				end
				IdsRacesAll[tostring(v.src)] = nil
			end

			-- Remove the race from the Races table
			Races[currentRace.source] = nil
		else
			-- If the player is not the owner, remove only this player from the race
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(v.src)] = nil
					table.remove(currentRace.players, k)
					break
				end
			end

			-- Sync the updated player list with the remaining players
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
			end
		end
	end
end)

--- Event handler for joining a public race lobby
--- @param roomId number The ID of the race room to join
RegisterNetEvent("custom_races:server:joinPublicLobby", function(roomId)
	-- Check if the race room exists
	if not Races[tonumber(roomId)] or Races[tonumber(roomId)].NfStarted then
		TriggerClientEvent("custom_races:RoomNull", source)
		return
	end

	-- Get the player ID from the source
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)

	-- Retrieve the current race based on the room ID
	local currentRace = Races[tonumber(roomId)]
	currentRace.playerstatus[playerId] = "joining"

	while currentRace.status == "loading" do
		Citizen.Wait(0)
	end

	-- Check if the number of players is below the maximum allowed
	if #currentRace.players < currentRace.data.maxplayers then
		-- Handle invitation based on the race status
		if currentRace.status == "waiting" then
			-- Remove any existing invitation for the player
			currentRace.invitations[tostring(playerId)] = nil

			-- Add the player to the race's player list
			table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[1].vehicle or false})

			-- Sync the player list and send the room id to the joining player
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
					TriggerClientEvent("custom_races:client:joinPlayerLobby", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.nameRace, currentRace.data, true)
				else
					TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
				end
			end
			TriggerClientEvent("custom_races:hereIsRoomId", playerId, currentRace.source)
			currentRace.playerstatus[playerId] = "inroom"
		elseif currentRace.status == "racing" or currentRace.status == "loading_done" then
			-- Handle joining process for ongoing races
			currentRace.invitations[tostring(playerId)] = nil
			table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[1].vehicle or false})

			-- Sync the player list
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
					TriggerClientEvent("custom_races:client:joinPlayerLobby", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.nameRace, currentRace.data, false)
				else
					TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
				end
			end

			-- Update room id to client
			TriggerClientEvent("custom_races:hereIsRoomId", playerId, currentRace.source)

			-- Send track to client
			TriggerClientEvent("custom_races:loadTrack", playerId, currentRace.data, currentRace.actualTrack, currentRace.actualTrack.props, currentRace.actualTrack.dprops, currentRace.actualweatherAndTime, currentRace.actualTrack.laps)

			-- Start the player's session in the race after 2 seconds
			Citizen.Wait(2000)
			currentRace.StartPlayerSession(currentRace, playerId, playerName)

			-- Trigger the client event to synchronize the player's grid position and vehicle after 3 seconds
			Citizen.Wait(3000)
			TriggerClientEvent("custom_races:showRaceInfo", playerId, 1, currentRace.actualTrack.predefveh)

			-- Sync the driver information to all players in the race
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers, timeServerSide)
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:playerJoinRace", v.src, playerName)
				end
			end

			-- Trigger the client event for the player to start race after 5 seconds
			Citizen.Wait(5000)
			TriggerClientEvent("custom_races:startRace", playerId)
			currentRace.playerstatus[playerId] = "racing"
		end
	else
		-- Notify the player that the maximum number of players has been reached
		TriggerClientEvent("custom_races:client:maxplayers", playerId)
		currentRace.playerstatus[playerId] = nil
	end
end)

--- Event handler for setting a player's car in a race
--- @param data table The data containing the vehicle information
RegisterNetEvent("custom_races:server:setplayercar", function(data)
	-- Get the ID of the player who triggered the event
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	if currentRace then
		-- Check if the race has a specific vehicle mode
		if currentRace.data.vehicle == "specific" then
			-- Update the vehicle text for all players in the race waiting lobby
			for k, v in pairs(currentRace.players) do
				currentRace.players[k].vehicle = data.label
			end

			-- Set the predefined vehicle for the race
			if tonumber(data.model) then
				currentRace.actualTrack.predefveh = tonumber(data.model)
			else
				-- Retrieve vehicle modifications from sql
				local vehicleMods = nil

				if "esx" == Config.Framework then
					vehicleMods = MySQL.query.await("SELECT vehicle FROM owned_vehicles WHERE plate = ?", {data.model})[1]
					if vehicleMods then
						currentRace.actualTrack.predefveh = json.decode(vehicleMods.vehicle)
					end
				elseif "qb" == Config.Framework then
					vehicleMods = MySQL.query.await("SELECT mods FROM player_vehicles WHERE plate = ?", {data.model})[1]
					if vehicleMods then
						currentRace.actualTrack.predefveh = json.decode(vehicleMods.mods)
					end
				elseif "standalone" == Config.Framework then
					currentRace.actualTrack.predefveh = nil
				end
			end

			-- Sync the updated player list with the remaining players
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
			end
		elseif currentRace.data.vehicle == "personal" then
			-- Set the player's car if the vehicle mode is "personal"
			currentRace.setPlayerCar(currentRace, playerId, data)
		end
	end
end)

Bucket = {} -- If you want different races to be in different routing buckets, you can uncomment
RegisterNetEvent("custom_races:server:SetPlayerRoutingBucket", function(routingbucket)
	--[[if not routingbucket then
		SetPlayerRoutingBucket(source, Bucket[source])
	else
		Bucket[source] = GetPlayerRoutingBucket(source)
		SetPlayerRoutingBucket(source, routingbucket)
	end]]
end)

--- Event handler for the race owner to start the race
RegisterNetEvent("custom_races:ownerStartRace", function()
	-- Get the owner's ID (player ID of the source)
	local ownerId = tonumber(source)

	-- Retrieve the current race associated with the owner
	local currentRace = Races[tonumber(IdsRacesAll[tostring(ownerId)])]

	-- If the race exists, start loading the race
	if currentRace then
		currentRace.LoadNewRace(currentRace, currentRace.data.raceid, currentRace.data.laps, currentRace.data.weather, currentRace.data.time, currentRace.source)
	else
		print("ERROR: Owner can't start race") -- If no race is found, print an error message
	end
end)

--- Event handler to update vehicle name for a player
--- @param vehNameCurrent string The name of the vehicle
RegisterNetEvent("custom_races:updateVehName", function(vehNameCurrent)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	if currentRace and currentRace.drivers[playerId] then
		currentRace.drivers[playerId].vehNameCurrent = vehNameCurrent

		-- Sync the driver information to all players in the race
		local timeServerSide = GetGameTimer()
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers, timeServerSide)
		end
	end
end)

--- Event handler to update checkPoint for a player
--- @param actualCheckPoint number The number of actual checkpoint
--- @param totalCheckPointsTouched number The total number of checkpoints touched by the player
--- @param lastCheckpointPair number 0 = primary / 1 = secondary
--- @param roomId number The ID of the race room
RegisterNetEvent("custom_races:updateCheckPoint", function(actualCheckPoint, totalCheckPointsTouched, lastCheckpointPair, roomId)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	local currentRace = Races[tonumber(roomId)]

	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
		currentRace.updateCheckPoint(currentRace, actualCheckPoint, totalCheckPointsTouched, lastCheckpointPair, playerId)
	end
end)

--- Event handler for updating the race time
--- @param actualLapTime number The time of the current lap
--- @param totalRaceTime number The total time of the race
--- @param actualLap number The number of actual lap
RegisterNetEvent("custom_races:updateTime", function(actualLapTime, totalRaceTime, actualLap)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	-- Update the time for the player in the specified race room
	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
		currentRace.updateTime(currentRace, playerId, actualLapTime, totalRaceTime, actualLap)
	end
end)

--- Event handler for when a player finishes a race
--- @param totalCheckPointsTouched number The total number of checkpoints touched by the player
--- @param lastCheckpointPair number 0 = primary / 1 = secondary
--- @param actualLapTime number The time of the current lap
--- @param totalRaceTime number The total time of the race
--- @param raceStatus string The status of the race
--- @param hasCheated boolean Whether player tp?
RegisterNetEvent("custom_races:playerFinish", function(totalCheckPointsTouched, lastCheckpointPair, actualLapTime, totalRaceTime, raceStatus, hasCheated)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
		currentRace.updateTime(currentRace, playerId, actualLapTime, totalRaceTime)
		currentRace.playerFinish(currentRace, playerId, totalCheckPointsTouched, lastCheckpointPair, raceStatus, hasCheated)
	end
end)

--- Event handler for spectating a player in a race
--- @param id number The ID of the player to spectate
--- @param actionFromUser boolean Whether it is triggered by a real user
RegisterNetEvent("custom_races:server:SpectatePlayer", function(id, actionFromUser)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	if currentRace and currentRace.drivers[playerId] and currentRace.playerstatus[playerId] and currentRace.playerstatus[playerId] == "racing" then
		local spectateId = tonumber(id)

		currentRace.drivers[playerId].spectateId = spectateId

		if not actionFromUser then return end

		local name_A = GetPlayerName(playerId)
		local name_B = GetPlayerName(spectateId)

		-- Trigger all client event to tell who is spectating
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:WhoSpectateWho", v.src, name_A, name_B)
		end
	end
end)

--- Event handler for a player leaving a race
RegisterNetEvent("custom_races:server:leave_race", function()
	-- Get the ID of the player who triggered the event
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	-- If the race exists, call the leaveRace function for the player
	if currentRace then
		currentRace.leaveRace(currentRace, playerId)
	end
end)

--- Event handler for re-sync data to client
--- @param event string The name of the event that needs to be re-synchronized
RegisterNetEvent("custom_races:re-sync", function(event)
	-- Get the ID of the player who triggered the event
	local playerId = tonumber(source)

	-- Retrieve the current race based on the player ID
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]

	if currentRace then
		if event == "syncDrivers" then
			TriggerClientEvent("custom_races:hereIsTheDriversInfo", playerId, currentRace.drivers, GetGameTimer())
		elseif event == "syncPlayers" then
			TriggerClientEvent("custom_races:client:SyncPlayerList", playerId, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, GetGameTimer())
		end
	end
end)

--- Event handler for a spawned vehicle from client
--- @param vehNetId number The network ID of the vehicle
RegisterNetEvent('custom_races:spawnvehicle', function(vehNetId)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Store the spawned vehicle's network ID for the player
	playerSpawnedVehicles[playerId] = vehNetId
end)

--- Event handler for deleting a vehicle
--- @param vehId number The ID of the vehicle to delete
RegisterNetEvent('custom_races:deleteVehicle', function(vehId)
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Retrieve the vehicle entity using the network ID
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

--- Event handler for when a player drops from the server
AddEventHandler("playerDropped", function()
	-- Get the player ID from the source
	local playerId = tonumber(source)

	-- Retrieve the network ID of the vehicle spawned by the player
	local vehNetId = playerSpawnedVehicles[playerId]

	-- Check if the player had a spawned vehicle
	if vehNetId then
		Citizen.CreateThread(function()
			-- This will fix "Execution of native 00000000faa3d236 in script host failed" error
			-- Sometimes it happens lol, with a probability of 0.000000000001%
			-- If the vehicle exists, delete it
			local attempt = 0
			while DoesEntityExist(NetworkGetEntityFromNetworkId(vehNetId)) and (attempt < 3) do
				attempt = attempt + 1
				DeleteEntity(NetworkGetEntityFromNetworkId(vehNetId))
				Citizen.Wait(0)
			end
		end)

		-- Clear the stored vehicle ID for the player
		playerSpawnedVehicles[playerId] = nil
	end

	-- Iterate through all ongoing races
	for k, v in pairs(Races) do
		-- Check if the race is not finished
		if not Races[k].isFinished then
			Races[k].playerDropped(Races[k], playerId)
		end
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			local version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
			if not string.find(version, "dev") then
				PerformHttpRequest('https://raw.githubusercontent.com/taoletsgo/custom_races/refs/heads/main/main%20script/version_check.json', function (err, updatedata, headers)
					if updatedata ~= nil then
						local data = json.decode(updatedata)
						if data.custom_races ~= version then
							print('^1=======================================================================================^0')
							print('^1('..GetCurrentResourceName()..') is outdated!^0')
							print('Latest version: (^2'..data.custom_races..'^0) https://github.com/taoletsgo/custom_races/releases/')
							print('^1=======================================================================================^0')
						end
					end
				end, 'GET', '')
			end
		end)
	end
end)