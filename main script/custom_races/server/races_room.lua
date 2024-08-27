RaceRoom = {}
Races = setmetatable({}, { __index = RaceRoom })

--- Function to start loading the race
--- @param currentRace table The current race object
--- @param raceId number The ID of the race
--- @param laps number The number of laps for the race
--- @param weather string The weather condition for the race
--- @param time string The start time for the race in hours
--- @param roomId number The ID of the race room
RaceRoom.LoadNewRace = function(currentRace, raceId, laps, weather, time, roomId)
	currentRace.status = "loading"
	currentRace.actualWeatherAndHour = { weather = weather, hour = tonumber(time), minute = 0, second = 0 }
	currentRace.drivers = {}
	currentRace.positions = {} -- gridPosition
	currentRace.finishedCount = 0

	-- Load the race track and send it to client
	Citizen.CreateThread(function()
		local raceid = raceId
		local route_file, category= GetRouteFileByRaceID(raceid)
		if route_file and category then
			-- Load the track data from the json file
			local trackUGC = json.decode(LoadResourceFile(GetCurrentResourceName(), route_file))
			currentRace.currentTrackUGC = trackUGC
			currentRace.currentTrackUGC.mission.gen.ownerid = category

			ConvertFromUGC(tonumber(laps), roomId)
			SendTrackToClient(roomId)

			-- Start the race session for players
			startSession(roomId)
			currentRace.status = "racing"
		else
			print("ERROR: No route_file found for raceid: " .. raceid)
		end
	end)
end

--- Function to convert UGC track data for the current race
--- @param currentRace table The current race object
--- @param lapCount number The number of laps for the race
RaceRoom.ConvertFromUGC = function(currentRace, lapCount)
	-- Set the track name, creator name and lap count for the current race
	currentRace.actualTrack.trackName = currentRace.currentTrackUGC.mission.gen.nm
	currentRace.actualTrack.creatorName = currentRace.currentTrackUGC.mission.gen.ownerid
	currentRace.actualTrack.laps = lapCount

	-- Check if a predefined vehicle is not set for the track / the vehicle mode is "default"
	if not currentRace.actualTrack.predefveh then
		if Config.EnableDefaultRandomVehicle then
			math.randomseed(os.time())
			-- Select a random vehicle from the configuration list
			currentRace.actualTrack.predefveh = GetHashKey(Config.RandomVehicle[math.random(#Config.RandomVehicle)])
		else
			currentRace.actualTrack.predefveh = GetHashKey("bmx")
		end
	end

	-- Set the track checkpoints
	currentRace.actualTrack.checkpoints = {}
	local isRound = 1
	local pair_isRound = 2
	local isLarge = 9
	local pair_isLarge = 13
	local isTemporal = 10
	local pair_isTemporal = 11
	local warp = 27
	local pair_warp = 28
	for i = 1, currentRace.currentTrackUGC.mission.race.chp, 1 do
		currentRace.actualTrack.checkpoints[i] = {}
		currentRace.actualTrack.checkpoints[i].x = currentRace.currentTrackUGC.mission.race.chl[i].x + 0.0
		currentRace.actualTrack.checkpoints[i].y = currentRace.currentTrackUGC.mission.race.chl[i].y + 0.0
		currentRace.actualTrack.checkpoints[i].z = currentRace.currentTrackUGC.mission.race.chl[i].z + 0.0
		currentRace.actualTrack.checkpoints[i].heading = currentRace.currentTrackUGC.mission.race.chh[i] + 0.0
		currentRace.actualTrack.checkpoints[i].d = currentRace.currentTrackUGC.mission.race.chs and 10 * currentRace.currentTrackUGC.mission.race.chs[i] or 10

		if currentRace.currentTrackUGC.mission.race.sndchk then
			currentRace.actualTrack.checkpoints[i].pair_x = currentRace.currentTrackUGC.mission.race.sndchk[i].x + 0.0
			currentRace.actualTrack.checkpoints[i].pair_y = currentRace.currentTrackUGC.mission.race.sndchk[i].y + 0.0
			currentRace.actualTrack.checkpoints[i].pair_z = currentRace.currentTrackUGC.mission.race.sndchk[i].z + 0.0
			currentRace.actualTrack.checkpoints[i].pair_heading = currentRace.currentTrackUGC.mission.race.sndrsp[i] + 0.0
			currentRace.actualTrack.checkpoints[i].pair_d = currentRace.currentTrackUGC.mission.race.chs2 and 10 * currentRace.currentTrackUGC.mission.race.chs2[i] or 10
			if currentRace.actualTrack.checkpoints[i].pair_x == 0.0 and currentRace.actualTrack.checkpoints[i].pair_y == 0.0 and currentRace.actualTrack.checkpoints[i].pair_z == 0.0 then
				currentRace.actualTrack.checkpoints[i].hasPair = false
			else
				currentRace.actualTrack.checkpoints[i].hasPair = true
			end
		else
			currentRace.actualTrack.checkpoints[i].pair_x = 0.0
			currentRace.actualTrack.checkpoints[i].pair_y = 0.0
			currentRace.actualTrack.checkpoints[i].pair_z = 0.0
			currentRace.actualTrack.checkpoints[i].pair_heading = 0.0
			currentRace.actualTrack.checkpoints[i].pair_d = nil
			currentRace.actualTrack.checkpoints[i].hasPair = false
		end

		if currentRace.currentTrackUGC.mission.race.cpbs1 and currentRace.currentTrackUGC.mission.race.cpbs1[i] then
			local cpbs1 = currentRace.currentTrackUGC.mission.race.cpbs1[i]
			currentRace.actualTrack.checkpoints[i].isRound = isBitSet(cpbs1, isRound)
			currentRace.actualTrack.checkpoints[i].isLarge = isBitSet(cpbs1, isLarge)
			currentRace.actualTrack.checkpoints[i].isTemporal = isBitSet(cpbs1, isTemporal)
			currentRace.actualTrack.checkpoints[i].warp = isBitSet(cpbs1, warp)
			currentRace.actualTrack.checkpoints[i].pair_isRound = isBitSet(cpbs1, pair_isRound)
			currentRace.actualTrack.checkpoints[i].pair_isLarge = isBitSet(cpbs1, pair_isLarge)
			currentRace.actualTrack.checkpoints[i].pair_isTemporal = isBitSet(cpbs1, pair_isTemporal)
			currentRace.actualTrack.checkpoints[i].pair_warp = isBitSet(cpbs1, pair_warp)
			if currentRace.currentTrackUGC.mission.race.cppsst then
				if currentRace.currentTrackUGC.mission.race.cppsst[i] == 1 then
					currentRace.actualTrack.checkpoints[i].planerot = "up"
				elseif currentRace.currentTrackUGC.mission.race.cppsst[i] == 2 then
					currentRace.actualTrack.checkpoints[i].planerot = "right"
				elseif currentRace.currentTrackUGC.mission.race.cppsst[i] == 4 then
					currentRace.actualTrack.checkpoints[i].planerot = "down"
				elseif currentRace.currentTrackUGC.mission.race.cppsst[i] == 8 then
					currentRace.actualTrack.checkpoints[i].planerot = "left"
				end
			end
		end

		-- Other settings of checkpoints
		--[[if currentRace.currentTrackUGC.mission.race.cpbs2 and currentRace.currentTrackUGC.mission.race.cpbs2[i] then
			-- todo list / client side + server side
			local isUnderWater = 5
			local pair_isUnderWater = 6
			local isWanted = 22
			local pair_isWanted = 23
			local isWantedMax = 26
			local pair_isWantedMax = 27
			currentRace.actualTrack.checkpoints[i].isUnderWater = isBitSet(cpbs2, isUnderWater)
			currentRace.actualTrack.checkpoints[i].isWanted = isBitSet(cpbs2, isWanted)
			currentRace.actualTrack.checkpoints[i].isWantedMax = isBitSet(cpbs2, isWantedMax)
			currentRace.actualTrack.checkpoints[i].pair_isUnderWater = isBitSet(cpbs2, pair_isUnderWater)
			currentRace.actualTrack.checkpoints[i].pair_isWanted = isBitSet(cpbs2, pair_isWanted)
			currentRace.actualTrack.checkpoints[i].pair_isWantedMax = isBitSet(cpbs2, pair_isWantedMax)
		end]]

		-- Shift from primary checkpoints location?
		--[[if currentRace.currentTrackUGC.mission.race.cpado then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].shiftX = currentRace.currentTrackUGC.mission.race.cpado[i].x + 0.0
			currentRace.actualTrack.checkpoints[i].shiftY = currentRace.currentTrackUGC.mission.race.cpado[i].y + 0.0
			currentRace.actualTrack.checkpoints[i].shiftZ = currentRace.currentTrackUGC.mission.race.cpado[i].z + 0.0
		end]]

		-- Shift from secondary checkpoints location?
		--[[if currentRace.currentTrackUGC.mission.race.cpados then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].pair_shiftX = currentRace.currentTrackUGC.mission.race.cpados[i].x + 0.0
			currentRace.actualTrack.checkpoints[i].pair_shiftY = currentRace.currentTrackUGC.mission.race.cpados[i].y + 0.0
			currentRace.actualTrack.checkpoints[i].pair_shiftZ = currentRace.currentTrackUGC.mission.race.cpados[i].z + 0.0
		end]]

		-- Rot of primary checkpoints? Pitch?
		--[[if currentRace.currentTrackUGC.mission.race.chpp then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].rotFix = currentRace.currentTrackUGC.mission.race.chpp[i] + 0.0
		end]]

		-- Rot of secondary checkpoints? Pitch?
		--[[if currentRace.currentTrackUGC.mission.race.chpps then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].pair_rotFix = currentRace.currentTrackUGC.mission.race.chpps[i] + 0.0
		end]]

		currentRace.actualTrack.checkpoints[i].transform = currentRace.currentTrackUGC.mission.race.cptfrm and currentRace.currentTrackUGC.mission.race.cptfrm[i] or -1
		currentRace.actualTrack.checkpoints[i].pair_transform = currentRace.currentTrackUGC.mission.race.cptfrms and currentRace.currentTrackUGC.mission.race.cptfrms[i] or -1

		if currentRace.actualTrack.checkpoints[i].isLarge then
			currentRace.actualTrack.checkpoints[i].d = 30 * currentRace.currentTrackUGC.mission.race.chs[i]
		else
			if not currentRace.actualTrack.checkpoints[i].isRound and not currentRace.actualTrack.checkpoints[i].warp and not currentRace.actualTrack.checkpoints[i].planerot then
				goto lbl_622
			end
			currentRace.actualTrack.checkpoints[i].d = 15 * currentRace.currentTrackUGC.mission.race.chs[i]
		end
		::lbl_622::
		if currentRace.actualTrack.checkpoints[i].pair_isLarge then
			currentRace.actualTrack.checkpoints[i].pair_d = currentRace.currentTrackUGC.mission.race.chs2 and 30 * currentRace.currentTrackUGC.mission.race.chs2[i] or 30
		else
			if not currentRace.actualTrack.checkpoints[i].pair_isRound and not currentRace.actualTrack.checkpoints[i].pair_warp then
				goto lbl_663
			end
			currentRace.actualTrack.checkpoints[i].pair_d = currentRace.currentTrackUGC.mission.race.chs2 and 15 * currentRace.currentTrackUGC.mission.race.chs2[i] or 15
		end 
		::lbl_663::
	end

	-- Set the track grid positions
	currentRace.actualTrack.positions = {}
	local maxPlayers = Config.MaxPlayers
	local totalPositions = #currentRace.currentTrackUGC.mission.veh.loc
	for i = 1, maxPlayers do
		local index = i

		if index > totalPositions then
			index = 1 -- If the actual number of players is less than the maximum number of players, the default is set to loc 1
		end

		table.insert(currentRace.actualTrack.positions, {
			x = currentRace.currentTrackUGC.mission.veh.loc[index].x + 0.0,
			y = currentRace.currentTrackUGC.mission.veh.loc[index].y + 0.0,
			z = currentRace.currentTrackUGC.mission.veh.loc[index].z + 0.0,
			heading = currentRace.currentTrackUGC.mission.veh.head[index] + 0.0
		})
	end

	-- Set the track transform vehicles if it exists
	currentRace.actualTrack.transformVehicles = currentRace.currentTrackUGC.mission.race.trfmvm or {}

	-- Set the track random transform class if it exists
	currentRace.actualTrack.randomClass = currentRace.currentTrackUGC.mission.race.cptrtt or {}

	-- Set the track veh class blacklist
	currentRace.actualTrack.blacklistClass = {}
	for k, v in pairs(currentRace.currentTrackUGC.meta.vehcl) do
		if v == "Compacts" then
			table.insert(currentRace.actualTrack.blacklistClass, 0)
		elseif v == "Sedans" then
			table.insert(currentRace.actualTrack.blacklistClass, 1)
		elseif v == "SUV" then
			table.insert(currentRace.actualTrack.blacklistClass, 2)
		elseif v == "Coupes" then
			table.insert(currentRace.actualTrack.blacklistClass, 3)
		elseif v == "Mucle" then
			table.insert(currentRace.actualTrack.blacklistClass, 4)
		elseif v == "Classics" then
			table.insert(currentRace.actualTrack.blacklistClass, 5)
		elseif v == "Sports" then
			table.insert(currentRace.actualTrack.blacklistClass, 6)
		elseif v == "Super" then
			table.insert(currentRace.actualTrack.blacklistClass, 7)
		elseif v == "Bikes" then
			table.insert(currentRace.actualTrack.blacklistClass, 8)
		elseif v == "OffRoad" then
			table.insert(currentRace.actualTrack.blacklistClass, 9)
		elseif v == "Industrial" then
			table.insert(currentRace.actualTrack.blacklistClass, 10)
		elseif v == "Utility" then
			table.insert(currentRace.actualTrack.blacklistClass, 11)
		elseif v == "Vans" then
			table.insert(currentRace.actualTrack.blacklistClass, 12)
		elseif v == "Cycles" then
			table.insert(currentRace.actualTrack.blacklistClass, 13)
		elseif v == "Special" then
			-- table.insert(currentRace.actualTrack.blacklistClass, 17)
			table.insert(currentRace.actualTrack.blacklistClass, 18)
			-- table.insert(currentRace.actualTrack.blacklistClass, 20)
		elseif v == "Weaponised" then
			table.insert(currentRace.actualTrack.blacklistClass, 19)
		elseif v == "Contender" then
			-- table.insert(currentRace.actualTrack.blacklistClass, 0)
		elseif v == "Open Wheel" then
			table.insert(currentRace.actualTrack.blacklistClass, 22)
		elseif v == "Go-Kart" then
			-- table.insert(currentRace.actualTrack.blacklistClass, 0)
		elseif v == "Car Club" then
			-- table.insert(currentRace.actualTrack.blacklistClass, 0)
		end
	end

	-- Set the track pick-ups/weapons if it exists 
	currentRace.actualTrack.pickUps = {}
	if currentRace.currentTrackUGC.mission.weap then
		for i = 1, currentRace.currentTrackUGC.mission.weap.no do
			table.insert(currentRace.actualTrack.pickUps, {
				x = currentRace.currentTrackUGC.mission.weap.loc[i].x,
				y = currentRace.currentTrackUGC.mission.weap.loc[i].y,
				z = currentRace.currentTrackUGC.mission.weap.loc[i].z,
				type = currentRace.currentTrackUGC.mission.weap.type[i]
			})
		end
	end
end

local PlayerRoutingBucket = 10000

--- Function to send the track data to clients for the current race
--- @param currentRace table The current race object
--- @param roomId number The ID of the race room
RaceRoom.SendTrackToClient = function(currentRace, roomId)
	PlayerRoutingBucket = PlayerRoutingBucket + 1
	currentRace.actualTrack.routingbucket = PlayerRoutingBucket

	-- Populate the props (props) for the track from the UGC data
	currentRace.actualTrack.props = {}
	for i = 1, currentRace.currentTrackUGC.mission.prop.no do
		table.insert(currentRace.actualTrack.props, {
			hash = currentRace.currentTrackUGC.mission.prop.model[i],
			x = currentRace.currentTrackUGC.mission.prop.loc[i].x,
			y = currentRace.currentTrackUGC.mission.prop.loc[i].y,
			z = currentRace.currentTrackUGC.mission.prop.loc[i].z,
			rot = {x = currentRace.currentTrackUGC.mission.prop.vRot[i].x + 0.0, y = currentRace.currentTrackUGC.mission.prop.vRot[i].y + 0.0, z = currentRace.currentTrackUGC.mission.prop.vRot[i].z + 0.0},
			prpclr = currentRace.currentTrackUGC.mission.prop.prpclr and currentRace.currentTrackUGC.mission.prop.prpclr[i] or nil,
		})
	end

	-- Populate the dynamic props (dprops) for the track from the UGC data
	currentRace.actualTrack.dprops = {}
	for i = 1, currentRace.currentTrackUGC.mission.dprop.no do
		table.insert(currentRace.actualTrack.dprops, {
			hash = currentRace.currentTrackUGC.mission.dprop.model[i],
			x = currentRace.currentTrackUGC.mission.dprop.loc[i].x,
			y = currentRace.currentTrackUGC.mission.dprop.loc[i].y,
			z = currentRace.currentTrackUGC.mission.dprop.loc[i].z,
			rot = {x = currentRace.currentTrackUGC.mission.dprop.vRot[i].x + 0.0, y = currentRace.currentTrackUGC.mission.dprop.vRot[i].y + 0.0, z = currentRace.currentTrackUGC.mission.dprop.vRot[i].z + 0.0},
			prpdclr = currentRace.currentTrackUGC.mission.dprop.prpdclr and currentRace.currentTrackUGC.mission.dprop.prpdclr[i] or nil,
		})
	end

	-- Send track to client
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:loadTrack", v.src, currentRace.data, currentRace.actualTrack, currentRace.actualTrack.props, currentRace.actualTrack.dprops, currentRace.actualWeatherAndHour, currentRace.actualTrack.laps)
	end

	currentRace.status = "loading_done"
end

--- Function to invite a player to a race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player being invited
--- @param roomId number The ID of the race room
--- @param inviteId number The ID of the player who sent the invitation
RaceRoom.invitePlayer = function(currentRace, playerId, roomId, inviteId)
	local hasJoin = false

	-- Check if the player is already in the race
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end

	-- If the player is not in the race, send an invitation
	if not hasJoin then
		-- Add the player to the invitations list
		currentRace.invitations[tostring(playerId)] = { nick = GetPlayerName(playerId), src = playerId }

		-- Send an invitation to the player
		RaceRoom.sendInvitation(playerId, roomId, inviteId, currentRace.nameRace)

		-- Sync the updated player list with the remaining players
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
		end
	end
end

--- Function to send an invitation to a player
--- @param playerId number The ID of the player receiving the invitation
--- @param roomId number The ID of the race room
--- @param inviteId number The ID of the player who sent the invitation
--- @param nameRace string The name of the race
RaceRoom.sendInvitation = function(playerId, roomId, inviteId, nameRace)
	TriggerClientEvent("custom_races:client:receiveInvitation", playerId, roomId, GetPlayerName(inviteId), nameRace)
end

--- Function to remove an invitation for a player
--- @param currentRace table The current race object
--- @param playerId number The ID of the player whose invitation is to be removed
RaceRoom.removeInvitation = function(currentRace, playerId)
	-- Remove the player from the invitations list
	currentRace.invitations[tostring(playerId)] = nil

	-- Sync the updated player list with the remaining players
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
	end

	-- Notify the player that invitation has been removed
	TriggerClientEvent("custom_races:client:removeinvitation", playerId, currentRace.source)
end

--- Function to accept an invitation to a race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player accepting the invitation
--- @param bool boolean Indicates whether the race has started or is waiting
RaceRoom.acceptInvitation = function(currentRace, playerId, bool)
	-- Add the player to the race's players list
	table.insert(currentRace.players, {nick = GetPlayerName(playerId), src = playerId, ownerRace = false, vehicle = false})

	-- Remove the player from the invitations list
	currentRace.invitations[tostring(playerId)] = nil

	-- Sync the updated player list with the remaining players
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
			TriggerClientEvent("custom_races:client:joinRace", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.nameRace, currentRace.data, bool)
		else
			TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
		end
	end
end

--- Function to deny an invitation to a race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player whose invitation is being denied
RaceRoom.denyInvitation = function(currentRace, playerId)
	-- Remove the player from the invitations list
	currentRace.invitations[tostring(playerId)] = nil

	-- Sync the updated player list with the remaining players
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
	end
end

--- Function to set the vehicle for a player in the race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player whose vehicle is being set
--- @param data table A table containing vehicle data
--- @field data.label string The name of the vehicle
--- @field data.model number | string The model / plate of the vehicle
RaceRoom.setPlayerCar = function(currentRace, playerId, data)
	-- Iterate through players in the race to find the matching player
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			-- Update the vehicle text for the player in the race waiting lobby
			currentRace.players[k].vehicle = data.label

			if tonumber(data.model) then
				-- If there is a hash number in data, store it
				currentRace.playervehicles[playerId] = tonumber(data.model)

				-- If someone joins the race midway, the vehicle of the last player who set up the vehicle will be sync to him
				currentRace.actualTrack.predefveh = currentRace.playervehicles[playerId]
			else
				-- If there is a plate string in data, retrieve mods from database
				local vehicleMods = nil

				if "esx" == Config.Framework then
					vehicleMods = MySQL.query.await("SELECT vehicle FROM owned_vehicles WHERE plate = ?", {data.model})[1]
					if vehicleMods then
						currentRace.playervehicles[playerId] = json.decode(vehicleMods.vehicle)

						-- If someone joins the race midway, the vehicle of the last player who set up the vehicle will be sync to him
						currentRace.actualTrack.predefveh = currentRace.playervehicles[playerId]
					else
						currentRace.players[k].vehicle = false
					end
				elseif "qb" == Config.Framework then
					vehicleMods = MySQL.query.await("SELECT mods FROM player_vehicles WHERE plate = ?", {data.model})[1]
					if vehicleMods then
						currentRace.playervehicles[playerId] = json.decode(vehicleMods.mods)

						-- If someone joins the race midway, the vehicle of the last player who set up the vehicle will be sync to him
						currentRace.actualTrack.predefveh = currentRace.playervehicles[playerId]
					else
						currentRace.players[k].vehicle = false
					end
				end
			end

			break
		end
	end

	-- Sync the updated player list with the remaining players
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
	end
end

--- Function to initialize a player's session in the current race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player starting the session
RaceRoom.StartPlayerSession = function(currentRace, playerId)
	local playerId = tonumber(playerId)

	-- Initialize player data
	currentRace.drivers[playerId] = {
		playerID = playerId,
		playerName = GetPlayerName(playerId),
		vehicle = currentRace.playervehicles[playerId] or currentRace.actualTrack.predefveh,
		vehNameStart = "",
		bestLap = 9999999,
		totalRaceTime = 0,
		totalCheckpointsTouched = 0,
		isSpectating = false,
		hasFinished = false,
		hasnf = false,
		hascheated = false
	}

	-- start a race session for the player
	TriggerClientEvent("custom_races:startSession", playerId)
end

--- Function to update veh name at grid position for a player
--- @param currentRace table The current race object
--- @param vehNameStart string The name of veh
--- @param playerId number The ID of the player whose veh name is being updated
RaceRoom.updateVehName = function(currentRace, vehNameStart, playerId)
	-- Update the veh information for the player
	currentRace.drivers[playerId].vehNameStart = vehNameStart

	-- Sync the driver information to all players in the race
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
	end
end

--- Function to update the checkpoint status for a player and notify all players
--- @param currentRace table The current race object
--- @param totalCheckPointsTouched number The total number of checkpoints touched by the player
--- @param playerId number The ID of the player who touched the checkpoint
RaceRoom.checkPointTouched = function(currentRace, totalCheckPointsTouched, playerId)
	-- Update the checkpoint information for the player
	currentRace.drivers[playerId].totalCheckpointsTouched = totalCheckPointsTouched

	-- Sync the driver information to all players in the race
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
	end
end

--- Function to update the checkpoint status when a checkpoint is removed and notify all players
--- @param currentRace table The current race object
--- @param totalCheckPointsTouched number The updated total number of checkpoints touched by the player
--- @param playerId number The ID of the player whose checkpoint status is being updated
RaceRoom.checkPointTouchedRemove = function(currentRace, totalCheckPointsTouched, playerId)
	-- Update the checkpoint information for the player
	currentRace.drivers[playerId].totalCheckpointsTouched = totalCheckPointsTouched

	-- Sync the driver information to all players in the race
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
	end
end

--- Function to update the lap time and total race time for a driver
--- @param currentRace table The current race object
--- @param playerId number The ID of the player whose times are being updated
--- @param actualLapTime number The time of the current lap
--- @param totalRaceTime number The total time taken for the race so far
RaceRoom.updateTime = function(currentRace, playerId, actualLapTime, totalRaceTime)
	-- Update the driver's total race time
	currentRace.drivers[playerId].totalRaceTime = totalRaceTime

	-- Update the driver's best lap time if the new lap time is better
	if currentRace.drivers[playerId].bestLap > actualLapTime then
		currentRace.drivers[playerId].bestLap = actualLapTime
	end

	-- Sync the driver information to all players in the race
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
	end
end

--- Function to handle a player's finish in the current race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player who finished the race
RaceRoom.playerFinish = function(currentRace, playerId)
	-- Increment the count of finished players
	currentRace.finishedCount = currentRace.finishedCount + 1

	-- Mark the player as finished
	currentRace.drivers[playerId].hasFinished = true

	-- Sync the driver information to all players in the race
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
	end

	-- Check if all drivers have finished
	if currentRace.finishedCount >= Count(currentRace.drivers) and not currentRace.isFinished then
		-- If all drivers have finished, call the function to end the race
		RaceIsFinished(currentRace.source)
	elseif currentRace.finishedCount * 2 >= Count(currentRace.drivers) and not currentRace.NfStarted and Config.EnableStartNFCountdown then
		-- If at least half of the drivers have finished and the countdown has not started yet, start the countdown
		StartNFCountdown(currentRace.source)
		currentRace.NfStarted = true
	end
end

--- Function to update a driver's spectating status
--- @param currentRace table The current race object
--- @param playerId number The ID of the player whose spectating status is being updated
RaceRoom.updateMySpectateStatus = function(currentRace, playerId)
	-- Mark the driver as spectating
	currentRace.drivers[playerId].isSpectating = true

	-- Sync the driver information to all players in the race
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
	end
end

--- Function to start the not finish countdown for all drivers
--- @param currentRace table The current race object
RaceRoom.StartNFCountdown = function(currentRace)
	-- Start the not finish countdown if the explode mode is disabled
	if 0 == currentRace.actualTrack.lastexplode then
		for k, v in pairs(currentRace.drivers) do
			TriggerClientEvent("custom_races:client:StartNFCountdown", v.playerID)
		end
	end
end

--- Function to handle the end of a race and update race results
--- @param currentRace table The current race object
RaceRoom.RaceIsFinished = function(currentRace)
	-- Mark the race as finished
	currentRace.isFinished = true

	-- Update best times if the explode mode is disabled
	if currentRace.actualTrack.lastexplode == 0 then
		local category, index = GetRaceFrontFromRaceid(currentRace.data.raceid)

		if races_data_front[category] and races_data_front[category][index] and races_data_front[category][index].besttimes then
			for k, v in pairs(currentRace.drivers) do
				-- Insert driver's best lap time if the player status ~= "nf" / not cheated
				if not currentRace.drivers[k].hasnf and not currentRace.drivers[k].hascheated then
					if GetPlayerName(k) then
						table.insert(races_data_front[category][index].besttimes, {
							name = GetPlayerName(k),
							time = v.bestLap,
							vehicle = v.vehNameStart or "-",
							date = os.date("%x")
						})
					end
				end
			end

			-- Sort best times by lap time
			table.sort(races_data_front[category][index].besttimes, function(timeA, timeB) return timeA.time < timeB.time end)

			local names = {}
			local besttimes = {}

			-- Keep only the top 10 best times and avoid duplicate names
			for i = 1, #races_data_front[category][index].besttimes do
				if #besttimes < 10 and not names[races_data_front[category][index].besttimes[i].name] then
					names[races_data_front[category][index].besttimes[i].name] = true
					table.insert(besttimes, races_data_front[category][index].besttimes[i])
				end
			end
			races_data_front[category][index].besttimes = besttimes

			-- Update all clients with the latest race data
			TriggerClientEvent("custom_races:client:UpdateRacesData_Front_S", -1, category, index, races_data_front[category][index])

			-- Update the best times in the database
			MySQL.update("UPDATE custom_race_list SET besttimes = ? WHERE raceid = ?", {json.encode(races_data_front[category][index].besttimes), currentRace.data.raceid})
		end
	end

	-- Show final results to all drivers
	for k, v in pairs(currentRace.drivers) do
		TriggerClientEvent("custom_races:showFinalResult", v.playerID)
	end

	-- Remove the race room
	Races[currentRace.source] = nil
end

--- Function to handle a player leaving the race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player who is leaving the race
RaceRoom.leaveRace = function(currentRace, playerId)
	-- Check if the race is not in the "waiting" status
	if currentRace.status == "racing" then
		-- If the player has finished the race, decrease the finished count
		if currentRace.drivers[playerId].hasFinished then
			currentRace.finishedCount = currentRace.finishedCount - 1
		end

		local playerName = currentRace.drivers[playerId].playerName

		-- Remove the player from the drivers list
		currentRace.drivers[playerId] = nil

		-- Remove the player from the players list
		for k, v in pairs(currentRace.players) do
			if v.src == playerId then
				table.remove(currentRace.players, k)
				IdsRacesAll[tostring(v.src)] = nil
				break
			end
		end

		-- Sync the driver information to all players in the race
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
			TriggerClientEvent("custom_races:playerLeaveRace", v.src, playerName, true)
		end

		-- Check if the race should be finished
		if currentRace.finishedCount >= Count(currentRace.drivers) and not currentRace.isFinished then
			RaceIsFinished(currentRace.source)
		end
	end
end

--- Function to handle a player dropping out of the race
--- @param currentRace table The current race object
--- @param playerId number The ID of the player who dropped out
RaceRoom.playerDropped = function(currentRace, playerId)
	-- Check the race's status
	while currentRace.status == "loading" or currentRace.status == "loading_done" do
		Citizen.Wait(0)
	end
	if currentRace.status == "racing" then
		-- Execute the following code if the player is in current race
		if currentRace.drivers[playerId] then
			-- If the player has finished the race, decrease the finished count
			if currentRace.drivers[playerId].hasFinished then
				currentRace.finishedCount = currentRace.finishedCount - 1
			end

			local playerName = currentRace.drivers[playerId].playerName

			-- Remove the player from the drivers list
			currentRace.drivers[playerId] = nil

			-- Remove the player from the players list
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					table.remove(currentRace.players, k)
					IdsRacesAll[tostring(v.src)] = nil
					break
				end
			end

			-- Sync the driver information to all players in the race
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:hereIsTheDriversInfo", v.src, currentRace.drivers)
				TriggerClientEvent("custom_races:playerLeaveRace", v.src, playerName, false)
			end

			-- Check if the race should be finished
			if currentRace.finishedCount >= Count(currentRace.drivers) and not currentRace.isFinished then
				RaceIsFinished(currentRace.source)
			end
		end
	elseif currentRace.status == "waiting" then
		-- Determine if the player is an owner and can kick all players when race is in the "waiting" status
		local canKickAll = false
		for k, v in pairs(currentRace.players) do
			if v.src == playerId and v.ownerRace then
				canKickAll = true
				break
			end
		end

		if canKickAll then
			-- Kick all players from the race lobby
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:exitRoom", v.src)
				IdsRacesAll[tostring(v.src)] = nil
			end
			Races[currentRace.source] = nil
		else
			-- If the player is not an owner, update the player list and invitations
			local canSyncToClient = false
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(v.src)] = nil
					table.remove(currentRace.players, k) -- remove player name from lobby (In room)
					canSyncToClient = true
					break
				end
			end

			if currentRace.invitations[tostring(playerId)] ~= nil then
				currentRace.invitations[tostring(playerId)] = nil -- remove player name from lobby (Guest)
				canSyncToClient = true
			end

			if canSyncToClient then
				-- Sync the updated player list with the remaining players
				for k, v in pairs(currentRace.players) do
					TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
				end
			end
		end
	end
end

--- Function to check if a specific bit is set in a number
--- @param x number The number to check
--- @param n number The bit position to check
--- @return boolean True if the bit is set, otherwise false
function isBitSet(x, n)
	return (x & (1 << n)) ~= 0
end

-- THANKS TO JoraEmin52!!!
--[[cpbs1
0 CHECKPOINT_LEGACY_CONVERSION
1 CHECKPOINT_ROUND
2 CHECKPOINT_ROUND_SECONDARY
3 CHECKPOINT_DISABLE_CATCHUP
4 UNUSED
5 CHECKPOINT_RESTRICTED_SPACE
6 CHECKPOINT_DISABLE_SLIPSTREAM
7 CHECKPOINT_WATER
8 CHECKPOINT_WATER_SECONDARY
9 CHECKPOINT_AIR
10 CHECKPOINT_IGNORE_RESPAWNS
11 CHECKPOINT_IGNORE_RESPAWNS_SECONDARY
12 CHECKPOINT_CENTRED_LOCATE
13 CHECKPOINT_AIR_SECONDARY
14 CHECKPOINT_OVERRIDDEN
15 CHECKPOINT_OVERRIDDEN_SECONDARY
16 CHECKPOINT_CUSTOM_RESPAWN_ROT
17 CHECKPOINT_CUSTOM_RESPAWN_ROT_SECONDARY
18 CHECKPOINT_NON_BILLBOARD
19 CHECKPOINT_NON_BILLBOARD_SECONDARY
20 CHECKPOINT_VEHICLE_SWAP_VEHOPTION_0
21 CHECKPOINT_VEHICLE_SWAP_VEHOPTION_1
22 CHECKPOINT_VEHICLE_SWAP_VEHOPTION_2
23 CHECKPOINT_VEHICLE_SWAP_VEHOPTION_SECONDARY_0
24 CHECKPOINT_VEHICLE_SWAP_VEHOPTION_SECONDARY_1
25 CHECKPOINT_VEHICLE_SWAP_VEHOPTION_SECONDARY_2
26 CHECKPOINT_RESPAWN_OFFSET
27 CHECKPOINT_WARP
28 CHECKPOINT_WARP_SECONDARY
29 CHECKPOINT_GIVE_HELP_TEXT_TO_SECONDARY_CHECKPOINT
30 CHECKPOINT_USE_VERTICAL_CAM
31 CHECKPOINT_USE_VERTICAL_CAM_SECONDARY]]

--[[cpbs2
0 CHECKPOINT_VALID_WARP_EXIT
1 CHECKPOINT_VALID_WARP_EXIT_SECONDARY
2 CHECKPOINT_DONT_USE_AIR_SCALE
3 CHECKPOINT_DONT_USE_AIR_SCALE_SECONDARY
4 CHECKPOINT_SWAP_DRIVER_AND_PASSENGER
5 CHECKPOINT_UNDERWATER
6 CHECKPOINT_UNDERWATER_SECONDARY
7 CHECKPOINT_VTOL_RESPAWN
8 CHECKPOINT_SWAP_DRIVER_AND_PASSENGER_SECONDARY
9 CHECKPOINT_IGNORE_Z_COORD_CHECK
10 CHECKPOINT_IGNORE_Z_COORD_CHECK_SECONDARY
11 CHECKPOINT_FORCE_CHECKPOINT_RED
12 CHECKPOINT_FORCE_CHECKPOINT_RED_SECONDARY
13 CHECKPOINT_RESTRICT_Z_CHECK
14 CHECKPOINT_RESTRICT_Z_CHECK_SECONDARY
15 CHECKPOINT_RESTRICTED_SPACE_SECONDARY
16 CHECKPOINT_USE_PIT_STOP_MARKER
17 CHECKPOINT_USE_PIT_STOP_MARKER_SECONDARY
18 CHECKPOINT_LOWER_ICON
19 CHECKPOINT_LOWER_ICON_SECONDARY
20 CHECKPOINT_SUPER_TALL
21 CHECKPOINT_SUPER_TALL_SECONDARY
22 CHECKPOINT_INCREMENT_WANTED
23 CHECKPOINT_INCREMENT_WANTED_SECONDARY
24 CHECKPOINT_LOW_ALPHA_CP_BLIP
25 CHECKPOINT_LOW_ALPHA_CP_BLIP_SECONDARY
26 CHECKPOINT_INCREMENT_WANTED_TO_MAX
27 CHECKPOINT_INCREMENT_WANTED_TO_MAX_SECONDARY]]