RaceRoom = {}
Races = setmetatable({}, { __index = RaceRoom })

RaceRoom.StartRaceRoom = function(currentRace, raceid)
	currentRace.status = "loading"
	Citizen.CreateThread(function()
		local UGC = nil
		if raceid then
			local route_file, category= GetRouteFileByRaceID(raceid)
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
			UGC = races_data_web_caches[currentRace.ownerId]
			races_data_web_caches[currentRace.ownerId] = nil
		end
		local success, exist = currentRace.ConvertFromUGC(currentRace, UGC)
		if success then
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:countDown", v.src)
				currentRace.InitDriverInfos(currentRace, v.src, v.nick)
				TriggerClientEvent("custom_races:client:startRaceRoom", v.src, k, currentRace.playerVehicles[v.src] or currentRace.actualTrack.predefinedVehicle)
			end
			currentRace.status = "racing"
			Citizen.CreateThread(function()
				while currentRace and (currentRace.status == "racing" or currentRace.status == "dnf") do
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
					Citizen.Wait(500)
				end
			end)
		else
			currentRace.status = "invalid"
			for k, v in pairs(currentRace.players) do
				IdsRacesAll[v.src] = nil
				TriggerClientEvent("custom_races:client:exitRoom", v.src, exist and "file-not-valid" or "file-not-exist")
			end
			races_data_web_caches[currentRace.ownerId] = nil
			Races[currentRace.source] = nil
		end
	end)
end

RaceRoom.ConvertFromUGC = function(currentRace, UGC)
	if not (UGC and UGC.mission and UGC.mission.gen and UGC.mission.gen.nm and UGC.mission.gen.ownerid and UGC.mission.race and UGC.mission.race.chp and UGC.mission.race.chp >= 3 and UGC.mission.veh and UGC.mission.veh.loc and #UGC.mission.veh.loc >= 1) then
		return false, UGC and 1 or nil
	end
	currentRace.actualTrack.trackName = UGC.mission.gen.nm
	currentRace.actualTrack.creatorName = UGC.mission.gen.ownerid
	currentRace.actualTrack.blimpText = UGC.mission.gen.blmpmsg
	currentRace.actualTrack.firework = {
		name = UGC.firework and UGC.firework.name or "scr_indep_firework_trailburst",
		r = UGC.firework and UGC.firework.r or 255,
		g = UGC.firework and UGC.firework.g or 255,
		b = UGC.firework and UGC.firework.b or 255
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
	for i = 1, UGC.mission.race.chp, 1 do
		currentRace.actualTrack.checkpoints[i] = {}
		currentRace.actualTrack.checkpoints[i].x = UGC.mission.race.chl[i].x + 0.0
		currentRace.actualTrack.checkpoints[i].y = UGC.mission.race.chl[i].y + 0.0
		currentRace.actualTrack.checkpoints[i].z = UGC.mission.race.chl[i].z + 0.0
		currentRace.actualTrack.checkpoints[i].heading = UGC.mission.race.chh[i] + 0.0
		currentRace.actualTrack.checkpoints[i].d = UGC.mission.race.chs and UGC.mission.race.chs[i] >= 0.5 and 10 * UGC.mission.race.chs[i] or 5.0
		if UGC.mission.race.sndchk then
			currentRace.actualTrack.checkpoints[i].pair_x = UGC.mission.race.sndchk[i].x + 0.0
			currentRace.actualTrack.checkpoints[i].pair_y = UGC.mission.race.sndchk[i].y + 0.0
			currentRace.actualTrack.checkpoints[i].pair_z = UGC.mission.race.sndchk[i].z + 0.0
			currentRace.actualTrack.checkpoints[i].pair_heading = UGC.mission.race.sndrsp[i] + 0.0
			currentRace.actualTrack.checkpoints[i].pair_d = UGC.mission.race.chs2 and (UGC.mission.race.chs2[i] >= 0.5 and 10 * UGC.mission.race.chs2[i] or 5.0) or currentRace.actualTrack.checkpoints[i].d
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
		if UGC.mission.race.cpbs1 and UGC.mission.race.cpbs1[i] then
			local cpbs1 = UGC.mission.race.cpbs1[i]
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
		if UGC.mission.race.cppsst and UGC.mission.race.cppsst[i] then
			local cppsst = UGC.mission.race.cppsst[i]
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
		--[[if UGC.mission.race.cpbs2 and UGC.mission.race.cpbs2[i] then
			-- todo list / client side + server side
			local cpbs2 = UGC.mission.race.cpbs2[i]
			currentRace.actualTrack.checkpoints[i].isUnderWater = isBitSet(cpbs2, isUnderWater)
			currentRace.actualTrack.checkpoints[i].isWanted = isBitSet(cpbs2, isWanted)
			currentRace.actualTrack.checkpoints[i].isWantedMax = isBitSet(cpbs2, isWantedMax)
			currentRace.actualTrack.checkpoints[i].pair_isUnderWater = isBitSet(cpbs2, pair_isUnderWater)
			currentRace.actualTrack.checkpoints[i].pair_isWanted = isBitSet(cpbs2, pair_isWanted)
			currentRace.actualTrack.checkpoints[i].pair_isWantedMax = isBitSet(cpbs2, pair_isWantedMax)
		end]]
		-- Shift from primary checkpoints location?
		--[[if UGC.mission.race.cpado then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].shiftX = UGC.mission.race.cpado[i].x + 0.0
			currentRace.actualTrack.checkpoints[i].shiftY = UGC.mission.race.cpado[i].y + 0.0
			currentRace.actualTrack.checkpoints[i].shiftZ = UGC.mission.race.cpado[i].z + 0.0
		end]]
		-- Shift from secondary checkpoints location?
		--[[if UGC.mission.race.cpados then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].pair_shiftX = UGC.mission.race.cpados[i].x + 0.0
			currentRace.actualTrack.checkpoints[i].pair_shiftY = UGC.mission.race.cpados[i].y + 0.0
			currentRace.actualTrack.checkpoints[i].pair_shiftZ = UGC.mission.race.cpados[i].z + 0.0
		end]]
		-- Rot of primary checkpoints? Pitch?
		--[[if UGC.mission.race.chpp then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].rotFix = UGC.mission.race.chpp[i] + 0.0
		end]]
		-- Rot of secondary checkpoints? Pitch?
		--[[if UGC.mission.race.chpps then
			-- todo list / client side + server side
			currentRace.actualTrack.checkpoints[i].pair_rotFix = UGC.mission.race.chpps[i] + 0.0
		end]]
		currentRace.actualTrack.checkpoints[i].transform = UGC.mission.race.cptfrm and UGC.mission.race.cptfrm[i] or -1
		currentRace.actualTrack.checkpoints[i].pair_transform = UGC.mission.race.cptfrms and UGC.mission.race.cptfrms[i] or -1
		currentRace.actualTrack.checkpoints[i].random = UGC.mission.race.cptrtt and UGC.mission.race.cptrtt[i] or -1
		currentRace.actualTrack.checkpoints[i].pair_random = UGC.mission.race.cptrtts and UGC.mission.race.cptrtts[i] or -1
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
	currentRace.actualTrack.gridPositions = {}
	local maxPlayers = Config.MaxPlayers
	local totalPositions = #UGC.mission.veh.loc
	for i = 1, maxPlayers do
		local index = i
		if index > totalPositions then
			index = math.random(totalPositions) -- If the actual number of players is less than the maximum number of players, the default is set to random loc
		end
		table.insert(currentRace.actualTrack.gridPositions, {
			x = UGC.mission.veh.loc[index].x + 0.0,
			y = UGC.mission.veh.loc[index].y + 0.0,
			z = UGC.mission.veh.loc[index].z + 0.0,
			heading = UGC.mission.veh.head[index] + 0.0
		})
	end
	-- Set the track transform vehicles if it exists
	currentRace.actualTrack.transformVehicles = UGC.mission.race.trfmvm or {}
	currentRace.actualTrack.cp1_unknown_unknowns = UGC.mission.race.cptrtt and true or false
	currentRace.actualTrack.cp2_unknown_unknowns = UGC.mission.race.cptrtts and true or false
	-- Set the track veh class blacklist
	currentRace.actualTrack.blacklistClass = {}
	for k, v in pairs(UGC.meta.vehcl) do
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
	if UGC.mission.prop and UGC.mission.prop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, UGC.mission.prop.no do
			table.insert(currentRace.actualTrack.props, {
				hash = UGC.mission.prop.model[i],
				x = UGC.mission.prop.loc[i].x + 0.0,
				y = UGC.mission.prop.loc[i].y + 0.0,
				z = UGC.mission.prop.loc[i].z + 0.0,
				rot = {x = UGC.mission.prop.vRot[i].x + 0.0, y = UGC.mission.prop.vRot[i].y + 0.0, z = UGC.mission.prop.vRot[i].z + 0.0},
				prpclr = UGC.mission.prop.prpclr and UGC.mission.prop.prpclr[i] or nil,
				dist = UGC.mission.prop.pLODDist and UGC.mission.prop.pLODDist[i] or nil,
				invisible = UGC.mission.prop.prpbs and isBitSet(UGC.mission.prop.prpbs[i], 9),
				collision = not UGC.mission.prop.collision or (UGC.mission.prop.collision and (UGC.mission.prop.collision[i] == 1))
			})
		end
	end
	-- Populate the dynamic props (dprops) for the track from the UGC data
	currentRace.actualTrack.dprops = {}
	if UGC.mission.dprop and UGC.mission.dprop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, UGC.mission.dprop.no do
			table.insert(currentRace.actualTrack.dprops, {
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
	currentRace.actualTrack.dhprop = {}
	if UGC.mission.dhprop and UGC.mission.dhprop.no --[[the value may be nil in 2024+ newer json]] then
		for i = 1, UGC.mission.dhprop.no do
			table.insert(currentRace.actualTrack.dhprop, {
				hash = UGC.mission.dhprop.mn[i]
			})
		end
	end
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:loadTrack", v.src, currentRace.data, currentRace.actualTrack, currentRace.source)
	end
	return true, 1
end

RaceRoom.InvitePlayer = function(currentRace, playerId, roomId, inviteId)
	local hasJoin = false
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end
	if not hasJoin and GetPlayerName(playerId) then
		currentRace.invitations[playerId] = { nick = GetPlayerName(playerId), src = playerId }
		currentRace.syncNextFrame = true
		TriggerClientEvent("custom_races:client:receiveInvitation", playerId, roomId, GetPlayerName(inviteId), currentRace.data.name)
	end
end

RaceRoom.RemoveInvitation = function(currentRace, playerId)
	if currentRace.invitations[playerId] then
		currentRace.invitations[playerId] = nil
		currentRace.syncNextFrame = true
		TriggerClientEvent("custom_races:client:removeinvitation", playerId, currentRace.source)
	end
end

RaceRoom.AcceptInvitation = function(currentRace, playerId, playerName, fromInvite)
	local hasJoin = false
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end
	if hasJoin then return end
	IdsRacesAll[playerId] = currentRace.source
	table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[currentRace.ownerId] and currentRace.players[currentRace.ownerId].vehicle or false})
	currentRace.invitations[playerId] = nil
	currentRace.syncNextFrame = true
	TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", playerId, currentRace.data, true)
end

RaceRoom.DenyInvitation = function(currentRace, playerId)
	if currentRace.invitations[playerId] then
		currentRace.invitations[playerId] = nil
		currentRace.syncNextFrame = true
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
	local hasJoin = false
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			hasJoin = true
			break
		end
	end
	if hasJoin then return end
	IdsRacesAll[playerId] = currentRace.source
	table.insert(currentRace.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRace.data.vehicle == "specific" and currentRace.players[currentRace.ownerId] and currentRace.players[currentRace.ownerId].vehicle or false})
	currentRace.invitations[playerId] = nil
	currentRace.syncNextFrame = true
	TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", playerId, currentRace.data, false)
	TriggerClientEvent("custom_races:client:loadTrack", playerId, currentRace.data, currentRace.actualTrack, currentRace.source)
	currentRace.InitDriverInfos(currentRace, playerId, playerName)
	TriggerClientEvent("custom_races:client:startRaceRoom", playerId, 1, currentRace.actualTrack.predefinedVehicle)
	for k, v in pairs(currentRace.players) do
		if v.src ~= playerId then
			TriggerClientEvent("custom_races:client:playerJoinRace", v.src, playerName)
		end
	end
end

RaceRoom.ClientSync = function(currentRace, currentDriver, data, timeClientSide)
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

RaceRoom.GetFinishedAndValidCount = function(currentRace)
	local lock = false
	for _, _ in pairs(currentRace.inJoinProgress) do
		lock = true
		break
	end
	if lock then return 0, 1 end
	local finishedCount = 0
	local validPlayerCount = 0
	local onlinePlayers = {}
	for k, v in pairs(GetPlayers()) do
		onlinePlayers[tonumber(v)] = true
	end
	for k, v in pairs(currentRace.drivers) do
		if v.hasFinished then
			finishedCount = finishedCount + 1
		end
	end
	for k, v in pairs(currentRace.players) do
		if onlinePlayers[v.src] and IdsRacesAll[v.src] == currentRace.source then
			validPlayerCount = validPlayerCount + 1
		end
	end
	return finishedCount, validPlayerCount
end

RaceRoom.PlayerFinish = function(currentRace, currentDriver, hasCheated, finishCoords, raceStatus)
	currentDriver.hasCheated = hasCheated
	currentDriver.hasFinished = true
	currentDriver.finishCoords = finishCoords
	if raceStatus == "dnf" or raceStatus == "spectator" then
		currentDriver.dnf = true
	elseif raceStatus == "yeah" then
		currentDriver.dnf = false
		currentRace.UpdateRanking(currentRace, currentDriver)
	end
	local finishedCount, validPlayerCount = currentRace.GetFinishedAndValidCount(currentRace)
	if finishedCount >= validPlayerCount and (currentRace.status == "racing" or currentRace.status == "dnf") then
		currentRace.FinishRace(currentRace)
	elseif tonumber(currentRace.data.dnf) and (finishedCount / tonumber(currentRace.data.dnf)) >= validPlayerCount and currentRace.status == "racing" then
		currentRace.DNFCountdown(currentRace)
		TriggerClientEvent("custom_races:client:enableSpecMode", currentDriver.playerId, raceStatus)
	else
		TriggerClientEvent("custom_races:client:enableSpecMode", currentDriver.playerId, raceStatus)
	end
end

RaceRoom.UpdateRanking = function(currentRace, currentDriver)
	if not currentDriver.hasCheated and currentRace.data.raceid then
		local results = MySQL.query.await("SELECT besttimes FROM custom_race_list WHERE raceid = ?", {currentRace.data.raceid})
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
		MySQL.update("UPDATE custom_race_list SET besttimes = ? WHERE raceid = ?", {json.encode(besttimes), currentRace.data.raceid})
	end
end

RaceRoom.DNFCountdown = function(currentRace)
	if currentRace.status == "dnf" then return end
	currentRace.status = "dnf"
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:startDNFCountdown", v.src, currentRace.source)
	end
end

RaceRoom.FinishRace = function(currentRace)
	if currentRace.status == "ending" then return end
	currentRace.status = "ending"
	local timeServerSide = GetGameTimer() + 3000
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
	for k, v in pairs(currentRace.players) do
		IdsRacesAll[v.src] = nil
		TriggerClientEvent("custom_races:client:syncDrivers", v.src, drivers, timeServerSide)
		TriggerClientEvent("custom_races:client:showFinalResult", v.src)
	end
	Citizen.Wait(3000) -- This may solve some sync issues under very poor network conditions or caused by frequent data updates!
	Races[currentRace.source] = nil
end

RaceRoom.LeaveRace = function(currentRace, playerId, playerName)
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			IdsRacesAll[v.src] = nil
			table.remove(currentRace.players, k)
			break
		end
	end
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:playerLeaveRace", v.src, playerName, true)
	end
	currentRace.drivers[playerId] = nil
	local finishedCount, validPlayerCount = currentRace.GetFinishedAndValidCount(currentRace)
	if finishedCount >= validPlayerCount then
		currentRace.FinishRace(currentRace)
	end
end

RaceRoom.PlayerDropped = function(currentRace, playerId)
	while currentRace.status == "loading" or currentRace.inJoinProgress[playerId] do
		Citizen.Wait(0)
	end
	if currentRace.status == "racing" or currentRace.status == "dnf" then
		local currentDriver = currentRace.drivers[playerId]
		local playerName = currentDriver and currentDriver.playerName
		if currentDriver then
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					table.remove(currentRace.players, k)
					break
				end
			end
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:playerLeaveRace", v.src, playerName, false)
			end
			currentRace.drivers[playerId] = nil
		end
		local finishedCount, validPlayerCount = currentRace.GetFinishedAndValidCount(currentRace)
		if finishedCount >= validPlayerCount then
			currentRace.FinishRace(currentRace)
		end
	elseif currentRace.status == "waiting" then
		if playerId == currentRace.ownerId then
			currentRace.status = "invalid"
			for k, v in pairs(currentRace.players) do
				if v.src ~= playerId then
					IdsRacesAll[v.src] = nil
					TriggerClientEvent("custom_races:client:exitRoom", v.src, "leave")
				end
			end
			Races[currentRace.source] = nil
		else
			local found = false
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					table.remove(currentRace.players, k)
					found = true
					break
				end
			end
			if currentRace.invitations[playerId] then
				currentRace.invitations[playerId] = nil
				found = true
			end
			if found then
				currentRace.syncNextFrame = true
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