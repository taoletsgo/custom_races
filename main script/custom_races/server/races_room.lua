Room = {}

function Room.CreateRaceRoom(roomId, data, ownerId, ownerName)
	local currentRoom = {
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
	return currentRoom
end

function Room.StartRaceRoom(currentRoom, raceid)
	currentRoom.status = "loading"
	Citizen.CreateThread(function()
		local UGC = nil
		if raceid then
			local route_file, category = nil, nil
			local result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = ?", {raceid})
			if result and #result > 0 then
				route_file = result[1].route_file
				category = result[1].category
			end
			if route_file and category then
				if string.find(route_file, "local_files") then
					UGC = json.decode(LoadResourceFile(GetCurrentResourceName(), route_file))
				else
					UGC = json.decode(LoadResourceFile("custom_creator", route_file))
				end
				if category ~= "Custom" and UGC and UGC.mission and UGC.mission.gen then
					UGC.mission.gen.ownerid = category
				end
			end
		else
			UGC = races_data_web_caches[currentRoom.ownerId]
			races_data_web_caches[currentRoom.ownerId] = nil
		end
		local success, exist = Room.ConvertFromUGC(currentRoom, UGC)
		if success then
			for k, v in pairs(currentRoom.players) do
				TriggerClientEvent("custom_races:client:countDown", v.src)
				Room.InitDriverInfos(currentRoom, v.src, v.nick)
				TriggerClientEvent("custom_races:client:startRaceRoom", v.src, k, currentRoom.playerVehicles[v.src] or currentRoom.actualTrack.predefinedVehicle)
			end
			currentRoom.status = "racing"
		else
			currentRoom.status = "invalid"
			for k, v in pairs(currentRoom.players) do
				IdsRacesAll[v.src] = nil
				TriggerClientEvent("custom_races:client:exitRoom", v.src, exist and "file-not-valid" or "file-not-exist")
			end
			races_data_web_caches[currentRoom.ownerId] = nil
		end
	end)
end

function Room.ConvertFromUGC(currentRoom, UGC)
	if not (UGC and UGC.mission and UGC.mission.gen and UGC.mission.gen.nm and UGC.mission.gen.ownerid and UGC.mission.race and UGC.mission.race.chp and UGC.mission.race.chp >= 3 and UGC.mission.veh and UGC.mission.veh.loc and #UGC.mission.veh.loc >= 1) then
		return false, UGC and 1 or nil
	end
	-- Send to client for parsing, todo
	-- need to fix draw size and other things after updating creator script
	-- and zone、weap、prop、unit、cp in progress
	currentRoom.actualTrack.trackName = UGC.mission.gen.nm
	currentRoom.actualTrack.creatorName = UGC.mission.gen.ownerid
	currentRoom.actualTrack.blimpText = UGC.mission.gen.blmpmsg
	currentRoom.actualTrack.firework = {
		name = UGC.firework and UGC.firework.name or "scr_indep_firework_trailburst",
		r = UGC.firework and UGC.firework.r or 255,
		g = UGC.firework and UGC.firework.g or 255,
		b = UGC.firework and UGC.firework.b or 255
	}
	-- Check if a predefined vehicle is not set for the track / the vehicle mode is "default"
	if not currentRoom.actualTrack.predefinedVehicle then
		currentRoom.actualTrack.predefinedVehicle = tonumber(Config.PredefinedVehicle) or GetHashKey(Config.PredefinedVehicle or "bmx")
	end
	currentRoom.actualTrack.checkpoints = {}
	currentRoom.actualTrack.checkpoints_2 = {}
	for i = 1, UGC.mission.race.chp, 1 do
		local chl = UGC.mission.race.chl and UGC.mission.race.chl[i] or {}
		chl.x = chl.x or 0.0
		chl.y = chl.y or 0.0
		chl.z = chl.z or 0.0
		local chh = UGC.mission.race.chh and UGC.mission.race.chh[i] or 0.0
		local chs = UGC.mission.race.chs and UGC.mission.race.chs[i] or 1.0
		local chvs = UGC.mission.race.chvs and UGC.mission.race.chvs[i] or chs
		local chstR = UGC.mission.race.chstR and UGC.mission.race.chstR[i] or 500.0
		local cpado = UGC.mission.race.cpado and UGC.mission.race.cpado[i] or {}
		cpado.x = cpado.x or 0.0
		cpado.y = cpado.y or 0.0
		cpado.z = cpado.z or 0.0
		local chpp = UGC.mission.race.chpp and UGC.mission.race.chpp[i] or 0.0
		local cpbs1 = UGC.mission.race.cpbs1 and UGC.mission.race.cpbs1[i] or nil
		local cpbs2 = UGC.mission.race.cpbs2 and UGC.mission.race.cpbs2[i] or nil
		local cpbs3 = UGC.mission.race.cpbs3 and UGC.mission.race.cpbs3[i] or nil
		local cppsst = UGC.mission.race.cppsst and UGC.mission.race.cppsst[i] or nil
		local is_random_temp = UGC.mission.race.cptfrm and UGC.mission.race.cptfrm[i] == -2 and true
		local is_transform_temp = not is_random_temp and (UGC.mission.race.cptfrm and UGC.mission.race.cptfrm[i] >= 0 and true)
		currentRoom.actualTrack.checkpoints[i] = {
			x = RoundedValue(chl.x, 3),
			y = RoundedValue(chl.y, 3),
			z = RoundedValue(chl.z, 3),
			heading = RoundedValue(chh, 3),
			d_collect = RoundedValue(chs >= 0.5 and chs or 1.0, 3),
			d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
			offset = cpado,
			pitch = chpp,
			lock_dir = cpbs1 and (isBitSet(cpbs1, 16) and not (cpado.x == 0.0 and cpado.y == 0.0 and cpado.z == 0.0)) or isBitSet(cpbs1, 18),
			is_restricted = cpbs1 and isBitSet(cpbs1, 5),
			is_pit = cpbs2 and isBitSet(cpbs2, 16),
			is_lower = cpbs2 and isBitSet(cpbs2, 18),
			is_tall = cpbs2 and isBitSet(cpbs2, 20),
			tall_range = chstR,
			low_alpha = cpbs2 and isBitSet(cpbs2, 24),
			is_round = cpbs1 and isBitSet(cpbs1, 1),
			is_air = cpbs1 and isBitSet(cpbs1, 9),
			is_fake = cpbs1 and isBitSet(cpbs1, 10),
			is_random = is_random_temp,
			randomClass = is_random_temp and UGC.mission.race.cptrtt and UGC.mission.race.cptrtt[i] or 0,
			is_transform = is_transform_temp,
			transform_index = is_transform_temp and UGC.mission.race.cptfrm and UGC.mission.race.cptfrm[i] or 0,
			is_planeRot = cppsst and ((isBitSet(cppsst, 0)) or (isBitSet(cppsst, 1)) or (isBitSet(cppsst, 2)) or (isBitSet(cppsst, 3))),
			plane_rot = cppsst and ((isBitSet(cppsst, 0) and 0) or (isBitSet(cppsst, 1) and 1) or (isBitSet(cppsst, 2) and 2) or (isBitSet(cppsst, 3) and 3)),
			is_warp = cpbs1 and isBitSet(cpbs1, 27)
		}
		if currentRoom.actualTrack.checkpoints[i].is_random or currentRoom.actualTrack.checkpoints[i].is_transform or currentRoom.actualTrack.checkpoints[i].is_planeRot or currentRoom.actualTrack.checkpoints[i].is_warp then
			currentRoom.actualTrack.checkpoints[i].is_round = true
		end
		local sndchk = UGC.mission.race.sndchk and UGC.mission.race.sndchk[i] or {}
		sndchk.x = sndchk.x or 0.0
		sndchk.y = sndchk.y or 0.0
		sndchk.z = sndchk.z or 0.0
		if not (sndchk.x == 0.0 and sndchk.y == 0.0 and sndchk.z == 0.0) then
			local sndrsp = UGC.mission.race.sndrsp and UGC.mission.race.sndrsp[i] or 0.0
			local chs2 = UGC.mission.race.chs2 and UGC.mission.race.chs2[i] or chs
			local chstRs = UGC.mission.race.chstRs and UGC.mission.race.chstRs[i] or 500.0
			local cpados = UGC.mission.race.cpados and UGC.mission.race.cpados[i] or {}
			cpados.x = cpados.x or 0.0
			cpados.y = cpados.y or 0.0
			cpados.z = cpados.z or 0.0
			local chpps = UGC.mission.race.chpps and UGC.mission.race.chpps[i] or 0.0
			local is_random_temp_2 = UGC.mission.race.cptfrms and UGC.mission.race.cptfrms[i] == -2 and true
			local is_transform_temp_2 = not is_random_temp_2 and (UGC.mission.race.cptfrms and UGC.mission.race.cptfrms[i] >= 0 and true)
			currentRoom.actualTrack.checkpoints_2[i] = {
				x = RoundedValue(sndchk.x, 3),
				y = RoundedValue(sndchk.y, 3),
				z = RoundedValue(sndchk.z, 3),
				heading = RoundedValue(sndrsp, 3),
				d_collect = RoundedValue(chs2 >= 0.5 and chs2 or 1.0, 3),
				d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
				offset = cpados,
				pitch = chpps,
				lock_dir = cpbs1 and (isBitSet(cpbs1, 17) and not (cpados.x == 0.0 and cpados.y == 0.0 and cpados.z == 0.0)) or isBitSet(cpbs1, 19),
				is_restricted = cpbs2 and isBitSet(cpbs2, 15),
				is_pit = cpbs2 and isBitSet(cpbs2, 17),
				is_lower = cpbs2 and isBitSet(cpbs2, 19),
				is_tall = cpbs2 and isBitSet(cpbs2, 21),
				tall_range = chstRs,
				low_alpha = cpbs2 and isBitSet(cpbs2, 25),
				is_round = cpbs1 and isBitSet(cpbs1, 2),
				is_air = cpbs1 and isBitSet(cpbs1, 13),
				is_fake = cpbs1 and isBitSet(cpbs1, 11),
				is_random = is_random_temp_2,
				randomClass = is_random_temp_2 and UGC.mission.race.cptrtts and UGC.mission.race.cptrtts[i] or 0,
				is_transform = is_transform_temp_2,
				transform_index = is_transform_temp_2 and UGC.mission.race.cptfrms and UGC.mission.race.cptfrms[i] or 0,
				is_planeRot = cppsst and ((isBitSet(cppsst, 4)) or (isBitSet(cppsst, 5)) or (isBitSet(cppsst, 6)) or (isBitSet(cppsst, 7))),
				plane_rot = cppsst and ((isBitSet(cppsst, 4) and 0) or (isBitSet(cppsst, 5) and 1) or (isBitSet(cppsst, 6) and 2) or (isBitSet(cppsst, 7) and 3)),
				is_warp = cpbs1 and isBitSet(cpbs1, 28)
			}
			if currentRoom.actualTrack.checkpoints_2[i].is_random or currentRoom.actualTrack.checkpoints_2[i].is_transform or currentRoom.actualTrack.checkpoints_2[i].is_planeRot or currentRoom.actualTrack.checkpoints_2[i].is_warp then
				currentRoom.actualTrack.checkpoints_2[i].is_round = true
			end
		end
	end
	-- Set the track grid positions
	currentRoom.actualTrack.gridPositions = {}
	local maxPlayers = Config.MaxPlayers
	local totalPositions = #UGC.mission.veh.loc
	for i = 1, maxPlayers do
		local index = i
		if index > totalPositions then
			index = math.random(totalPositions) -- If the actual number of players is less than the maximum number of players, the default is set to random loc
		end
		table.insert(currentRoom.actualTrack.gridPositions, {
			x = UGC.mission.veh.loc[index].x + 0.0,
			y = UGC.mission.veh.loc[index].y + 0.0,
			z = UGC.mission.veh.loc[index].z + 0.0,
			heading = UGC.mission.veh.head[index] + 0.0
		})
	end
	-- Set the track transform vehicles if it exists
	currentRoom.actualTrack.transformVehicles = UGC.mission.race.trfmvm or {}
	currentRoom.actualTrack.cp1_unknown_unknowns = UGC.mission.race.cptrtt and true or false
	currentRoom.actualTrack.cp2_unknown_unknowns = UGC.mission.race.cptrtts and true or false
	-- Set the track veh class blacklist
	UGC.meta = UGC.meta or {}
	UGC.meta.vehcl = UGC.meta.vehcl or {}
	currentRoom.actualTrack.blacklistClass = {}
	for k, v in pairs(UGC.meta.vehcl) do
		if v == "Compacts" then
			table.insert(currentRoom.actualTrack.blacklistClass, 0)
		elseif v == "Sedans" then
			table.insert(currentRoom.actualTrack.blacklistClass, 1)
		elseif v == "SUV" then
			table.insert(currentRoom.actualTrack.blacklistClass, 2)
		elseif v == "Coupes" then
			table.insert(currentRoom.actualTrack.blacklistClass, 3)
		elseif v == "Mucle" then
			table.insert(currentRoom.actualTrack.blacklistClass, 4)
		elseif v == "Classics" then
			table.insert(currentRoom.actualTrack.blacklistClass, 5)
		elseif v == "Sports" then
			table.insert(currentRoom.actualTrack.blacklistClass, 6)
		elseif v == "Super" then
			table.insert(currentRoom.actualTrack.blacklistClass, 7)
		elseif v == "Bikes" then
			table.insert(currentRoom.actualTrack.blacklistClass, 8)
		elseif v == "OffRoad" then
			table.insert(currentRoom.actualTrack.blacklistClass, 9)
		elseif v == "Industrial" then
			table.insert(currentRoom.actualTrack.blacklistClass, 10)
		elseif v == "Utility" then
			table.insert(currentRoom.actualTrack.blacklistClass, 11)
		elseif v == "Vans" then
			table.insert(currentRoom.actualTrack.blacklistClass, 12)
		elseif v == "Cycles" then
			table.insert(currentRoom.actualTrack.blacklistClass, 13)
		elseif v == "Special" then
			-- table.insert(currentRoom.actualTrack.blacklistClass, 17)
			table.insert(currentRoom.actualTrack.blacklistClass, 18)
			-- table.insert(currentRoom.actualTrack.blacklistClass, 20)
		elseif v == "Weaponised" then
			table.insert(currentRoom.actualTrack.blacklistClass, 19)
		elseif v == "Contender" then
			-- table.insert(currentRoom.actualTrack.blacklistClass, 0)
		elseif v == "Open Wheel" then
			table.insert(currentRoom.actualTrack.blacklistClass, 22)
		elseif v == "Go-Kart" then
			-- table.insert(currentRoom.actualTrack.blacklistClass, 0)
		elseif v == "Car Club" then
			-- table.insert(currentRoom.actualTrack.blacklistClass, 0)
		end
	end
	-- Populate the props (props) for the track from the UGC data
	currentRoom.actualTrack.props = {}
	if UGC.mission.prop and UGC.mission.prop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, UGC.mission.prop.no do
			table.insert(currentRoom.actualTrack.props, {
				hash = UGC.mission.prop.model[i],
				x = UGC.mission.prop.loc[i].x + 0.0,
				y = UGC.mission.prop.loc[i].y + 0.0,
				z = UGC.mission.prop.loc[i].z + 0.0,
				rot = {x = UGC.mission.prop.vRot[i].x + 0.0, y = UGC.mission.prop.vRot[i].y + 0.0, z = UGC.mission.prop.vRot[i].z + 0.0},
				prpclr = UGC.mission.prop.prpclr and UGC.mission.prop.prpclr[i] or nil,
				prpsba = UGC.mission.prop.prpsba and UGC.mission.prop.prpsba[i] or nil,
				dist = UGC.mission.prop.pLODDist and UGC.mission.prop.pLODDist[i] or nil,
				invisible = UGC.mission.prop.prpbs and isBitSet(UGC.mission.prop.prpbs[i], 9),
				collision = not UGC.mission.prop.collision or (UGC.mission.prop.collision and (UGC.mission.prop.collision[i] == 1))
			})
		end
	end
	-- Populate the dynamic props (dprops) for the track from the UGC data
	currentRoom.actualTrack.dprops = {}
	if UGC.mission.dprop and UGC.mission.dprop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, UGC.mission.dprop.no do
			table.insert(currentRoom.actualTrack.dprops, {
				hash = UGC.mission.dprop.model[i],
				x = UGC.mission.dprop.loc[i].x + 0.0,
				y = UGC.mission.dprop.loc[i].y + 0.0,
				z = UGC.mission.dprop.loc[i].z + 0.0,
				rot = {x = UGC.mission.dprop.vRot[i].x + 0.0, y = UGC.mission.dprop.vRot[i].y + 0.0, z = UGC.mission.dprop.vRot[i].z + 0.0},
				prpdclr = UGC.mission.dprop.prpdclr and UGC.mission.dprop.prpdclr[i] or nil,
				collision = not UGC.mission.dprop.collision or (UGC.mission.dprop.collision and (UGC.mission.dprop.collision[i] == 1))
			})
		end
	end
	-- Populate the props (dhprops) to remove for the track from the UGC data
	currentRoom.actualTrack.dhprop = {}
	if UGC.mission.dhprop and UGC.mission.dhprop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, UGC.mission.dhprop.no do
			table.insert(currentRoom.actualTrack.dhprop, {
				hash = UGC.mission.dhprop.mn[i]
			})
		end
	end
	for k, v in pairs(currentRoom.players) do
		TriggerClientEvent("custom_races:client:loadTrack", v.src, currentRoom.data, currentRoom.actualTrack, currentRoom.source)
	end
	return true, 1
end

function Room.InvitePlayer(currentRoom, playerId, roomId, inviteId)
	local hasJoin = false
	for k, v in pairs(currentRoom.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end
	if not hasJoin and GetPlayerName(playerId) then
		currentRoom.invitations[playerId] = { nick = GetPlayerName(playerId), src = playerId }
		currentRoom.syncNextFrame = true
		TriggerClientEvent("custom_races:client:receiveInvitation", playerId, roomId, inviteId and GetPlayerName(inviteId) or "System", currentRoom.data.name)
	end
end

function Room.RemoveInvitation(currentRoom, playerId)
	if currentRoom.invitations[playerId] then
		currentRoom.invitations[playerId] = nil
		currentRoom.syncNextFrame = true
		TriggerClientEvent("custom_races:client:removeinvitation", playerId, currentRoom.source)
	end
end

function Room.AcceptInvitation(currentRoom, playerId, playerName, fromInvite)
	local hasJoin = false
	for k, v in pairs(currentRoom.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end
	if hasJoin then return end
	IdsRacesAll[playerId] = currentRoom.source
	table.insert(currentRoom.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRoom.data.vehicle == "specific" and currentRoom.players[currentRoom.ownerId] and currentRoom.players[currentRoom.ownerId].vehicle or false})
	currentRoom.invitations[playerId] = nil
	currentRoom.syncNextFrame = true
	TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", playerId, currentRoom.data, true)
end

function Room.DenyInvitation(currentRoom, playerId)
	if currentRoom.invitations[playerId] then
		currentRoom.invitations[playerId] = nil
		currentRoom.syncNextFrame = true
	end
end

function Room.InitDriverInfos(currentRoom, playerId, playerName)
	local playerId = tonumber(playerId)
	currentRoom.drivers[playerId] = {
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

function Room.JoinRaceMidway(currentRoom, playerId, playerName, fromInvite)
	local hasJoin = false
	for k, v in pairs(currentRoom.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end
	if hasJoin then return end
	IdsRacesAll[playerId] = currentRoom.source
	table.insert(currentRoom.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRoom.data.vehicle == "specific" and currentRoom.players[currentRoom.ownerId] and currentRoom.players[currentRoom.ownerId].vehicle or false})
	currentRoom.invitations[playerId] = nil
	currentRoom.syncNextFrame = true
	TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", playerId, currentRoom.data, false)
	TriggerClientEvent("custom_races:client:loadTrack", playerId, currentRoom.data, currentRoom.actualTrack, currentRoom.source)
	Room.InitDriverInfos(currentRoom, playerId, playerName)
	TriggerClientEvent("custom_races:client:startRaceRoom", playerId, 1, currentRoom.actualTrack.predefinedVehicle)
	for k, v in pairs(currentRoom.players) do
		if v.src ~= playerId then
			TriggerClientEvent("custom_races:client:playerJoinRace", v.src, playerName)
		end
	end
end

function Room.ClientSync(currentRoom, currentDriver, data, timeClientSide)
	currentDriver.timeClientSide = timeClientSide
	currentDriver.fps = data[1]
	currentDriver.actualLap = data[2]
	currentDriver.actualCheckpoint = data[3]
	currentDriver.vehicle = data[4]
	currentDriver.lastlap = data[5]
	currentDriver.bestlap = data[6]
	currentDriver.totalRaceTime = data[7]
	currentDriver.totalCheckpointsTouched = data[8]
	currentDriver.lastCheckpointPair = data[9]
end

function Room.GetFinishedAndValidCount(currentRoom)
	local finishedCount = 0
	local validPlayerCount = 0
	local onlinePlayers = {}
	for k, v in pairs(GetPlayers()) do
		onlinePlayers[tonumber(v)] = true
	end
	for k, v in pairs(currentRoom.drivers) do
		if v.hasFinished then
			finishedCount = finishedCount + 1
		end
	end
	for k, v in pairs(currentRoom.players) do
		if onlinePlayers[v.src] and IdsRacesAll[v.src] == currentRoom.source then
			validPlayerCount = validPlayerCount + 1
		end
	end
	return finishedCount, validPlayerCount
end

function Room.PlayerFinish(currentRoom, currentDriver, hasCheated, finishCoords, raceStatus)
	currentDriver.hasCheated = hasCheated
	currentDriver.hasFinished = true
	currentDriver.finishCoords = finishCoords
	if raceStatus == "dnf" or raceStatus == "spectator" then
		currentDriver.dnf = true
	elseif raceStatus == "yeah" then
		currentDriver.dnf = false
		Room.UpdateRanking(currentRoom, currentDriver)
	end
	local finishedCount, validPlayerCount = Room.GetFinishedAndValidCount(currentRoom)
	if finishedCount >= validPlayerCount and not currentRoom.isAnyPlayerJoining and (currentRoom.status == "racing" or currentRoom.status == "dnf") then
		Room.FinishRace(currentRoom)
	elseif tonumber(currentRoom.data.dnf) and (finishedCount / tonumber(currentRoom.data.dnf)) >= validPlayerCount and not currentRoom.isAnyPlayerJoining and currentRoom.status == "racing" then
		Room.DNFCountdown(currentRoom)
		TriggerClientEvent("custom_races:client:enableSpecMode", currentDriver.playerId, raceStatus)
	else
		TriggerClientEvent("custom_races:client:enableSpecMode", currentDriver.playerId, raceStatus)
	end
end

function Room.UpdateRanking(currentRoom, currentDriver)
	if not currentDriver.hasCheated and currentRoom.data.raceid then
		local results = MySQL.query.await("SELECT besttimes FROM custom_race_list WHERE raceid = ?", {currentRoom.data.raceid})
		local og_besttimes = results and results[1] and json.decode(results[1].besttimes) or {}
		local names = {}
		local besttimes = {}
		table.insert(og_besttimes, {
			name = currentDriver.playerName,
			time = currentDriver.bestlap,
			vehicle = currentDriver.vehicle,
			date = os.date("%x")
		})
		table.sort(og_besttimes, function(a, b) return a.time < b.time end)
		for i = 1, #og_besttimes do
			if #besttimes < 10 and not names[og_besttimes[i].name] then
				names[og_besttimes[i].name] = true
				table.insert(besttimes, og_besttimes[i])
			end
		end
		MySQL.update("UPDATE custom_race_list SET besttimes = ? WHERE raceid = ?", {json.encode(besttimes), currentRoom.data.raceid})
	end
end

function Room.DNFCountdown(currentRoom)
	if currentRoom.status == "dnf" then return end
	currentRoom.status = "dnf"
	for k, v in pairs(currentRoom.players) do
		TriggerClientEvent("custom_races:client:startDNFCountdown", v.src, currentRoom.source)
	end
end

function Room.FinishRace(currentRoom)
	if currentRoom.status == "ending" then return end
	currentRoom.status = "ending"
	local timeServerSide = GetGameTimer() + 3000
	local drivers = {}
	for k, v in pairs(currentRoom.drivers) do
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
	for k, v in pairs(currentRoom.players) do
		IdsRacesAll[v.src] = nil
		TriggerClientEvent("custom_races:client:syncDrivers", v.src, drivers, timeServerSide)
		TriggerClientEvent("custom_races:client:showFinalResult", v.src)
	end
end

function Room.LeaveRace(currentRoom, playerId, playerName)
	for k, v in pairs(currentRoom.players) do
		if v.src == playerId then
			IdsRacesAll[v.src] = nil
			table.remove(currentRoom.players, k)
			break
		end
	end
	for k, v in pairs(currentRoom.players) do
		TriggerClientEvent("custom_races:client:playerLeaveRace", v.src, playerName, true)
	end
	currentRoom.drivers[playerId] = nil
	local finishedCount, validPlayerCount = Room.GetFinishedAndValidCount(currentRoom)
	if finishedCount >= validPlayerCount and not currentRoom.isAnyPlayerJoining then
		Room.FinishRace(currentRoom)
	end
end

function Room.PlayerDropped(currentRoom, playerId)
	while currentRoom.status == "loading" or currentRoom.inJoinProgress[playerId] do
		Citizen.Wait(0)
	end
	if currentRoom.status == "racing" or currentRoom.status == "dnf" then
		local currentDriver = currentRoom.drivers[playerId]
		local playerName = currentDriver and currentDriver.playerName
		if currentDriver then
			for k, v in pairs(currentRoom.players) do
				if v.src == playerId then
					table.remove(currentRoom.players, k)
					break
				end
			end
			for k, v in pairs(currentRoom.players) do
				TriggerClientEvent("custom_races:client:playerLeaveRace", v.src, playerName, false)
			end
			currentRoom.drivers[playerId] = nil
		end
		local finishedCount, validPlayerCount = Room.GetFinishedAndValidCount(currentRoom)
		if finishedCount >= validPlayerCount and not currentRoom.isAnyPlayerJoining then
			Room.FinishRace(currentRoom)
		end
	elseif currentRoom.status == "waiting" then
		if playerId == currentRoom.ownerId then
			currentRoom.status = "invalid"
			for k, v in pairs(currentRoom.players) do
				if v.src ~= playerId then
					IdsRacesAll[v.src] = nil
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "leave")
				end
			end
		else
			local found = false
			for k, v in pairs(currentRoom.players) do
				if v.src == playerId then
					table.remove(currentRoom.players, k)
					found = true
					break
				end
			end
			if currentRoom.invitations[playerId] then
				currentRoom.invitations[playerId] = nil
				found = true
			end
			if found then
				currentRoom.syncNextFrame = true
			end
		end
	end
end

function isBitSet(x, n)
	return (x & (1 << n)) ~= 0
end

function RoundedValue(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

--[[prpbs-Static Prop
0 PROP_IgnoreVisCheck
1 PROP_IgnoreVisCheckCleanup
2 PROP_CleanupAtMidpoint
3 PROP_Position_Override
4 PROP_Rotation_Override
5 PROP_NGSpawnOnly
6 PROP_LGSpawnOnly
7 PROP_CleanupAtMissionEnd
8 PROP_FreeRotated
9 PROP_SetInvisible
10 PROP_EmitRadio
11 PROP_EmitCrashSound
12 PROP_AssociatedSpawn
13 PROP_SuddenDeathTarget
14 PROP_EnableTrackify
15 PROP_TriggerForAllRacers
16 PROP_TriggerOnEachLap
17 PROP_KeepInPlace
18 PROP_Cleanup_Flash
19 PROP_Cleanup_Fade
20 PROP_Cleanup_Detonate
21 PROP_Sound_Trigger_Play_Toggle
22 PROP_Sound_Trigger_Played_This_Lap
23 PROP_Sound_Trigger_Play_Once_Per_Lap
24 PROP_Sound_Trigger_Is_Invisible
25 PROP_PTFX_Played
26 PROP_Lock_Delete
27 PROP_Local_Align
28 PROP_Cleanup_Triggered
29 PROP_Is_Claimable
30 PROP_Requires_Alpha_Flash
31 PROP_Marked_for_correction]]

--[[prpbs2-Static Prop
0 PROP2_SLOW_DOWN_ENABLE
1 PROP2_SLOW_DOWN_ENABLE_EFFECT
2 PROP2_CAN_BE_TAGGED
3 PROP2_CylindricalSoundTrigger
4 PROP2_TriggerAlarmViaCCTV
5 PROP2_InvertUpdateRotation
6 PROP2_CleanUpVFX
7 PROP2_BlipAsSafeProp
8 PROP2_NoCollision
9 PROP2_UsePlacedFireworkZone
10 PROP2_Clamp_X_Override_Value
11 PROP2_Clamp_Y_Override_Value
12 PROP2_Clamp_Z_Override_Value
13 PROP2_UseAsTurret
14 PROP2_UFO_Spin
15 PROP2_UFO_Light
16 PROP2_HidePropInCutscene
17 PROP2_Reposition_Based_On_Painting_Index
18 PROP2_HavePropMatchLobbyHostVehicle
19 PROP2_PlacedInAnInterior]]

--[[prpbs-Dynamic Prop
0 DYNOPROP_IgnoreVisCheck
1 DYNOPROP_IgnoreVisCheckCleanup
2 DYNOPROP_CleanupAtMidpoint
3 DYNOPROP_CleanupAtMissionEnd
4 DYNOPROP_ExplodeOnTouch
5 DYNOPROP_KamakaziInvincibility
6 DYNOPROP_DestroyInOneHit
7 DYNOPROP_Position_Override
8 DYNOPROP_Rotation_Override
9 DYNOPROP_AffectedByScopingOut
10 DYNOPROP_ShowBlip
11 DYNOPROP_UsingNewBlipSpriteData
12 DYNOPROP_DroppedByEvent
13 DYNOPROP_InAnInterior]]

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