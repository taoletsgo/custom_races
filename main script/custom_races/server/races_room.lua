RaceRoom = {}
Races = setmetatable({}, { __index = RaceRoom })

RaceRoom.StartRaceRoom = function(currentRace, raceid)
	currentRace.status = "loading"
	currentRace.drivers = {}
	currentRace.positions = {} -- gridPosition
	currentRace.finishedCount = 0
	Citizen.CreateThread(function()
		local trackUGC = nil
		if raceid then
			local route_file, category= GetRouteFileByRaceID(raceid)
			if route_file and category then
				if string.find(route_file, "local_files") then
					trackUGC = json.decode(LoadResourceFile(GetCurrentResourceName(), route_file))
				else
					trackUGC = json.decode(LoadResourceFile("custom_creator", route_file))
				end
				if category ~= "Custom" and trackUGC then
					trackUGC.mission.gen.ownerid = category
				end
			end
		else
			trackUGC = races_data_web_caches[currentRace.ownerId]
			races_data_web_caches[currentRace.ownerId] = nil
		end
		if trackUGC then
			currentRace.currentTrackUGC = trackUGC
			currentRace.ConvertFromUGC(currentRace)
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:countDown", v.src)
				currentRace.InitDriverInfos(currentRace, v.src, v.nick)
				TriggerClientEvent("custom_races:client:startRaceRoom", v.src, k, currentRace.playerVehicles[v.src] or currentRace.actualTrack.predefinedVehicle)
			end
			currentRace.status = "racing"
		else
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:exitRoom", v.src, "file-not-exist")
				IdsRacesAll[tostring(v.src)] = nil
			end
			currentRace.isFinished = true
			races_data_web_caches[currentRace.ownerId] = nil
			Races[currentRace.source] = nil
		end
	end)
	Citizen.CreateThread(function()
		while currentRace and not currentRace.isFinished do
			local drivers = {}
			for k, v in pairs(currentRace.drivers) do
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
					not v.hasFinished and GetEntityCoords(GetPlayerPed(tostring(v.playerId))) or v.currentCoords,
					v.finishCoords,
					v.dnf
				}
			end
			local timeServerSide = GetGameTimer()
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:syncDrivers", v.src, drivers, timeServerSide)
			end
			Citizen.Wait(500)
		end
	end)
end

RaceRoom.ConvertFromUGC = function(currentRace)
	currentRace.actualTrack.trackName = currentRace.currentTrackUGC.mission.gen.nm
	currentRace.actualTrack.creatorName = currentRace.currentTrackUGC.mission.gen.ownerid
	currentRace.actualTrack.blimpText = currentRace.currentTrackUGC.mission.gen.blmpmsg
	currentRace.actualTrack.firework = {
		name = currentRace.currentTrackUGC.firework and currentRace.currentTrackUGC.firework.name or "scr_indep_firework_trailburst",
		r = currentRace.currentTrackUGC.firework and currentRace.currentTrackUGC.firework.r or 255,
		g = currentRace.currentTrackUGC.firework and currentRace.currentTrackUGC.firework.g or 255,
		b = currentRace.currentTrackUGC.firework and currentRace.currentTrackUGC.firework.b or 255
	}
	-- Check if a predefined vehicle is not set for the track / the vehicle mode is "default"
	if not currentRace.actualTrack.predefinedVehicle then
		currentRace.actualTrack.predefinedVehicle = tonumber(Config.PredefinedVehicle) or GetHashKey(Config.PredefinedVehicle or "bmx")
	end
	currentRace.actualTrack.checkpoints = {}
	-- cpbs1
	local isRound = 1
	local pair_isRound = 2
	local isLarge = 9
	local pair_isLarge = 13
	local isTemporal = 10
	local pair_isTemporal = 11
	local warp = 27
	local pair_warp = 28
	-- cpbs2
	--[[
	local isUnderWater = 5
	local pair_isUnderWater = 6
	local isWanted = 22
	local pair_isWanted = 23
	local isWantedMax = 26
	local pair_isWantedMax = 27
	]]
	for i = 1, currentRace.currentTrackUGC.mission.race.chp, 1 do
		currentRace.actualTrack.checkpoints[i] = {}
		currentRace.actualTrack.checkpoints[i].x = currentRace.currentTrackUGC.mission.race.chl[i].x + 0.0
		currentRace.actualTrack.checkpoints[i].y = currentRace.currentTrackUGC.mission.race.chl[i].y + 0.0
		currentRace.actualTrack.checkpoints[i].z = currentRace.currentTrackUGC.mission.race.chl[i].z + 0.0
		currentRace.actualTrack.checkpoints[i].heading = currentRace.currentTrackUGC.mission.race.chh[i] + 0.0
		currentRace.actualTrack.checkpoints[i].d = currentRace.currentTrackUGC.mission.race.chs and currentRace.currentTrackUGC.mission.race.chs[i] >= 0.5 and 10 * currentRace.currentTrackUGC.mission.race.chs[i] or 5.0
		if currentRace.currentTrackUGC.mission.race.sndchk then
			currentRace.actualTrack.checkpoints[i].pair_x = currentRace.currentTrackUGC.mission.race.sndchk[i].x + 0.0
			currentRace.actualTrack.checkpoints[i].pair_y = currentRace.currentTrackUGC.mission.race.sndchk[i].y + 0.0
			currentRace.actualTrack.checkpoints[i].pair_z = currentRace.currentTrackUGC.mission.race.sndchk[i].z + 0.0
			currentRace.actualTrack.checkpoints[i].pair_heading = currentRace.currentTrackUGC.mission.race.sndrsp[i] + 0.0
			currentRace.actualTrack.checkpoints[i].pair_d = currentRace.currentTrackUGC.mission.race.chs2 and (currentRace.currentTrackUGC.mission.race.chs2[i] >= 0.5 and 10 * currentRace.currentTrackUGC.mission.race.chs2[i] or 5.0) or currentRace.actualTrack.checkpoints[i].d
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
			currentRace.actualTrack.checkpoints[i].pair_d = 0.0
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
		end
		currentRace.actualTrack.checkpoints[i].planerot = nil
		currentRace.actualTrack.checkpoints[i].pair_planerot = nil
		if currentRace.currentTrackUGC.mission.race.cppsst and currentRace.currentTrackUGC.mission.race.cppsst[i] then
			local cppsst = currentRace.currentTrackUGC.mission.race.cppsst[i]
			if isBitSet(cppsst, 0) then
				currentRace.actualTrack.checkpoints[i].planerot = "up"
			elseif isBitSet(cppsst, 1) then
				currentRace.actualTrack.checkpoints[i].planerot = "right"
			elseif isBitSet(cppsst, 2) then
				currentRace.actualTrack.checkpoints[i].planerot = "down"
			elseif isBitSet(cppsst, 3) then
				currentRace.actualTrack.checkpoints[i].planerot = "left"
			end
		end
		-- Other settings of checkpoints
		--[[if currentRace.currentTrackUGC.mission.race.cpbs2 and currentRace.currentTrackUGC.mission.race.cpbs2[i] then
			-- todo list / client side + server side
			local cpbs2 = currentRace.currentTrackUGC.mission.race.cpbs2[i]
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
		currentRace.actualTrack.checkpoints[i].random = currentRace.currentTrackUGC.mission.race.cptrtt and currentRace.currentTrackUGC.mission.race.cptrtt[i] or -1
		currentRace.actualTrack.checkpoints[i].pair_random = currentRace.currentTrackUGC.mission.race.cptrtts and currentRace.currentTrackUGC.mission.race.cptrtts[i] or -1
		if currentRace.actualTrack.checkpoints[i].isLarge then
			currentRace.actualTrack.checkpoints[i].d = currentRace.actualTrack.checkpoints[i].d * 4.5
		elseif currentRace.actualTrack.checkpoints[i].isRound or currentRace.actualTrack.checkpoints[i].warp or currentRace.actualTrack.checkpoints[i].planerot or (currentRace.actualTrack.checkpoints[i].transform ~= -1) then
			currentRace.actualTrack.checkpoints[i].d = currentRace.actualTrack.checkpoints[i].d * 2.25
		end
		if currentRace.actualTrack.checkpoints[i].pair_isLarge then
			currentRace.actualTrack.checkpoints[i].pair_d = currentRace.actualTrack.checkpoints[i].pair_d * 4.5
		elseif currentRace.actualTrack.checkpoints[i].pair_isRound or currentRace.actualTrack.checkpoints[i].pair_warp or (currentRace.actualTrack.checkpoints[i].pair_transform ~= -1) then
			currentRace.actualTrack.checkpoints[i].pair_d = currentRace.actualTrack.checkpoints[i].pair_d * 2.25
		end
	end
	-- Set the track grid positions
	currentRace.actualTrack.positions = {}
	local maxPlayers = Config.MaxPlayers
	local totalPositions = #currentRace.currentTrackUGC.mission.veh.loc
	for i = 1, maxPlayers do
		local index = i
		if index > totalPositions then
			index = math.random(totalPositions) -- If the actual number of players is less than the maximum number of players, the default is set to random loc
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
	currentRace.actualTrack.cp1_unknown_unknowns = currentRace.currentTrackUGC.mission.race.cptrtt and true or false
	currentRace.actualTrack.cp2_unknown_unknowns = currentRace.currentTrackUGC.mission.race.cptrtts and true or false
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
	-- Populate the props (props) for the track from the UGC data
	currentRace.actualTrack.props = {}
	if currentRace.currentTrackUGC.mission.prop and currentRace.currentTrackUGC.mission.prop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, currentRace.currentTrackUGC.mission.prop.no do
			table.insert(currentRace.actualTrack.props, {
				hash = currentRace.currentTrackUGC.mission.prop.model[i],
				x = currentRace.currentTrackUGC.mission.prop.loc[i].x + 0.0,
				y = currentRace.currentTrackUGC.mission.prop.loc[i].y + 0.0,
				z = currentRace.currentTrackUGC.mission.prop.loc[i].z + 0.0,
				rot = {x = currentRace.currentTrackUGC.mission.prop.vRot[i].x + 0.0, y = currentRace.currentTrackUGC.mission.prop.vRot[i].y + 0.0, z = currentRace.currentTrackUGC.mission.prop.vRot[i].z + 0.0},
				prpclr = currentRace.currentTrackUGC.mission.prop.prpclr and currentRace.currentTrackUGC.mission.prop.prpclr[i] or nil,
				dist = currentRace.currentTrackUGC.mission.prop.pLODDist and currentRace.currentTrackUGC.mission.prop.pLODDist[i] or nil,
				collision = not currentRace.currentTrackUGC.mission.prop.collision or (currentRace.currentTrackUGC.mission.prop.collision and (currentRace.currentTrackUGC.mission.prop.collision[i] == 1))
			})
		end
	end
	-- Populate the dynamic props (dprops) for the track from the UGC data
	currentRace.actualTrack.dprops = {}
	if currentRace.currentTrackUGC.mission.dprop and currentRace.currentTrackUGC.mission.dprop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, currentRace.currentTrackUGC.mission.dprop.no do
			table.insert(currentRace.actualTrack.dprops, {
				hash = currentRace.currentTrackUGC.mission.dprop.model[i],
				x = currentRace.currentTrackUGC.mission.dprop.loc[i].x + 0.0,
				y = currentRace.currentTrackUGC.mission.dprop.loc[i].y + 0.0,
				z = currentRace.currentTrackUGC.mission.dprop.loc[i].z + 0.0,
				rot = {x = currentRace.currentTrackUGC.mission.dprop.vRot[i].x + 0.0, y = currentRace.currentTrackUGC.mission.dprop.vRot[i].y + 0.0, z = currentRace.currentTrackUGC.mission.dprop.vRot[i].z + 0.0},
				prpdclr = currentRace.currentTrackUGC.mission.dprop.prpdclr and currentRace.currentTrackUGC.mission.dprop.prpdclr[i] or nil,
				collision = not currentRace.currentTrackUGC.mission.dprop.collision or (currentRace.currentTrackUGC.mission.dprop.collision and (currentRace.currentTrackUGC.mission.dprop.collision[i] == 1))
			})
		end
	end
	-- Populate the props (dhprops) to remove for the track from the UGC data
	currentRace.actualTrack.dhprop = {}
	if currentRace.currentTrackUGC.mission.dhprop and currentRace.currentTrackUGC.mission.dhprop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, currentRace.currentTrackUGC.mission.dhprop.no do
			table.insert(currentRace.actualTrack.dhprop, {
				hash = currentRace.currentTrackUGC.mission.dhprop.mn[i]
			})
		end
	end
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:loadTrack", v.src, currentRace.data, currentRace.actualTrack, currentRace.source)
	end
end

RaceRoom.InvitePlayer = function(currentRace, playerId, roomId, inviteId)
	local hasJoin = false
	-- Check if the player is already in the race
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end
	-- If the player is not in the race and still online, send an invitation
	if not hasJoin and GetPlayerName(playerId) then
		currentRace.invitations[tostring(playerId)] = { nick = GetPlayerName(playerId), src = playerId }
		local timeServerSide = GetGameTimer()
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
		end
		TriggerClientEvent("custom_races:client:receiveInvitation", playerId, roomId, GetPlayerName(inviteId), currentRace.name)
	end
end

RaceRoom.RemoveInvitation = function(currentRace, playerId)
	currentRace.invitations[tostring(playerId)] = nil
	local timeServerSide = GetGameTimer()
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
	end
	TriggerClientEvent("custom_races:client:removeinvitation", playerId, currentRace.source)
end

RaceRoom.AcceptInvitation = function(currentRace, playerId, playerName, fromInvite)
	currentRace.invitations[tostring(playerId)] = nil
	table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[1] and currentRace.players[1].vehicle or false})
	local timeServerSide = GetGameTimer()
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
			TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.name, currentRace.data, true)
		else
			TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
		end
	end
end

RaceRoom.DenyInvitation = function(currentRace, playerId)
	currentRace.invitations[tostring(playerId)] = nil
	local timeServerSide = GetGameTimer()
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
	end
end

RaceRoom.InitDriverInfos = function(currentRace, playerId, playerName)
	local playerId = tonumber(playerId)
	currentRace.drivers[playerId] = {
		playerId = playerId,
		timeClientSide = 0,
		playerName = playerName,
		fps = 999,
		actualLap = 1,
		actualCheckpoint = 1,
		vehicle = "",
		lastlap = 0,
		bestlap = 0,
		totalRaceTime = 0,
		totalCheckpointsTouched = 0,
		lastCheckpointPair = 0,
		hasCheated = false,
		hasFinished = false,
		currentCoords = GetEntityCoords(GetPlayerPed(tostring(playerId))),
		finishCoords = nil,
		dnf = false,
		spectateId = nil -- todo
	}
end

RaceRoom.JoinRaceMidway = function(currentRace, playerId, playerName, fromInvite)
	currentRace.invitations[tostring(playerId)] = nil
	table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[1] and currentRace.players[1].vehicle or false})
	currentRace.InitDriverInfos(currentRace, playerId, playerName)
	local timeServerSide = GetGameTimer()
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
			TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.name, currentRace.data, false)
		else
			TriggerClientEvent("custom_races:client:playerJoinRace", v.src, playerName)
			TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
		end
	end
	TriggerClientEvent("custom_races:client:loadTrack", playerId, currentRace.data, currentRace.actualTrack, currentRace.source)
	TriggerClientEvent("custom_races:client:startRaceRoom", playerId, 1, currentRace.actualTrack.predefinedVehicle)
end

RaceRoom.ClientSync = function(currentRace, playerId, data, timeClientSide)
	currentRace.drivers[playerId].timeClientSide = timeClientSide
	currentRace.drivers[playerId].fps = data[1]
	currentRace.drivers[playerId].actualLap = data[2]
	currentRace.drivers[playerId].actualCheckpoint = data[3]
	currentRace.drivers[playerId].vehicle = data[4]
	currentRace.drivers[playerId].lastlap = data[5]
	currentRace.drivers[playerId].bestlap = data[6]
	currentRace.drivers[playerId].totalRaceTime = data[7]
	currentRace.drivers[playerId].totalCheckpointsTouched = data[8]
	currentRace.drivers[playerId].lastCheckpointPair = data[9]
end

RaceRoom.PlayerFinish = function(currentRace, playerId, hasCheated, finishCoords, raceStatus)
	currentRace.finishedCount = currentRace.finishedCount + 1
	currentRace.drivers[playerId].hasCheated = hasCheated
	currentRace.drivers[playerId].hasFinished = true
	currentRace.drivers[playerId].finishCoords = finishCoords
	if raceStatus == "dnf" or raceStatus == "spectator" then
		currentRace.drivers[playerId].dnf = true
	elseif raceStatus == "yeah" then
		currentRace.drivers[playerId].dnf = false
		currentRace.UpdateRanking(currentRace, playerId)
	end
	if currentRace.finishedCount >= #currentRace.players and not currentRace.isFinished then
		currentRace.FinishRace(currentRace)
	elseif tonumber(currentRace.data.dnf) and ((currentRace.finishedCount / (tonumber(currentRace.data.dnf))) >= #currentRace.players) and not currentRace.DNFstarted then
		currentRace.DNFstarted = true
		TriggerClientEvent("custom_races:client:enableSpecMode", playerId, raceStatus)
		currentRace.startDNFCountdown(currentRace)
	else
		TriggerClientEvent("custom_races:client:enableSpecMode", playerId, raceStatus)
	end
end

RaceRoom.UpdateRanking = function(currentRace, playerId)
	if not currentRace.drivers[playerId].hasCheated and currentRace.data.raceid then
		local results = MySQL.query.await("SELECT besttimes FROM custom_race_list WHERE raceid = ?", {currentRace.data.raceid})
		local og_besttimes = results and results[1] and json.decode(results[1].besttimes) or {}
		local names = {}
		local besttimes = {}
		table.insert(og_besttimes, {
			name = currentRace.drivers[playerId].playerName,
			time = currentRace.drivers[playerId].bestlap,
			vehicle = currentRace.drivers[playerId].vehicle,
			date = os.date("%x")
		})
		table.sort(og_besttimes, function(a, b) return a.time < b.time end)
		for i = 1, #og_besttimes do
			if #besttimes < 10 and not names[og_besttimes[i].name] then
				names[og_besttimes[i].name] = true
				table.insert(besttimes, og_besttimes[i])
			end
		end
		MySQL.update("UPDATE custom_race_list SET besttimes = ? WHERE raceid = ?", {json.encode(besttimes), currentRace.data.raceid})
	end
end

RaceRoom.startDNFCountdown = function(currentRace)
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:startDNFCountdown", v.src, currentRace.source)
	end
end

RaceRoom.FinishRace = function(currentRace)
	currentRace.isFinished = true
	local drivers = {}
	for k, v in pairs(currentRace.drivers) do
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
	local timeServerSide = GetGameTimer() + 3000
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:syncDrivers", v.src, drivers, timeServerSide)
		TriggerClientEvent("custom_races:client:showFinalResult", v.src)
	end
	Citizen.Wait(3000) -- This may solve some sync issues under very poor network conditions or caused by frequent data updates!
	Races[currentRace.source] = nil
end

RaceRoom.LeaveRace = function(currentRace, playerId)
	if currentRace.status == "racing" then
		if currentRace.drivers[playerId].hasFinished then
			currentRace.finishedCount = currentRace.finishedCount - 1
		end
		local playerName = currentRace.drivers[playerId].playerName
		currentRace.drivers[playerId] = nil
		for k, v in pairs(currentRace.players) do
			if v.src == playerId then
				table.remove(currentRace.players, k)
				IdsRacesAll[tostring(v.src)] = nil
				break
			end
		end
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:client:playerLeaveRace", v.src, playerName, true)
		end
		if currentRace.finishedCount >= #currentRace.players and not currentRace.isFinished then
			currentRace.FinishRace(currentRace)
		end
	end
end

RaceRoom.PlayerDropped = function(currentRace, playerId)
	while currentRace.status == "loading" or currentRace.inJoinProgress[playerId] do
		Citizen.Wait(0)
	end
	if currentRace.status == "racing" then
		if currentRace.drivers[playerId] then
			if currentRace.drivers[playerId].hasFinished then
				currentRace.finishedCount = currentRace.finishedCount - 1
			end
			local playerName = currentRace.drivers[playerId].playerName
			currentRace.drivers[playerId] = nil
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					table.remove(currentRace.players, k)
					IdsRacesAll[tostring(v.src)] = nil
					break
				end
			end
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:playerLeaveRace", v.src, playerName, false)
			end
			if currentRace.finishedCount >= #currentRace.players and not currentRace.isFinished then
				currentRace.FinishRace(currentRace)
			end
		end
	elseif currentRace.status == "waiting" then
		if playerId == currentRace.ownerId then
			-- Kick all players from the room
			for k, v in pairs(currentRace.players) do
				if v.src ~= playerId then
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "leave")
				else
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "")
				end
				IdsRacesAll[tostring(v.src)] = nil
			end
			Races[currentRace.source] = nil
		else
			local canSyncToClient = false
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					IdsRacesAll[tostring(v.src)] = nil
					table.remove(currentRace.players, k) -- remove player name from room (In room)
					canSyncToClient = true
					break
				end
			end
			if currentRace.invitations[tostring(playerId)] ~= nil then
				currentRace.invitations[tostring(playerId)] = nil -- remove player name from room (Guest)
				canSyncToClient = true
			end
			if canSyncToClient then
				local timeServerSide = GetGameTimer()
				for k, v in pairs(currentRace.players) do
					TriggerClientEvent("custom_races:client:syncPlayers", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, timeServerSide)
				end
			end
		end
	end
end

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