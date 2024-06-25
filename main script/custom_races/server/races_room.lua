RaceRoom = {}
Races = setmetatable({}, { __index = RaceRoom })

NewRace = function(roomId, data, name)
	local currentRace = {
		source = roomId,
		data = data,
		drivers = {},
		checkpointPositions = {},
		racePositions = {},
		actualTrack = {
			lastexplode = "no-explosions" ~= data.explosions and tonumber(GetTimeFromStringExplode(data.explosions)) or 0,
			mode = data.modo
		},
		totalRaceTime = 0,
		totalRaceTimeStart = 0,
		playersFinished = 0,
		gridPositions = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		finalPositions = {},
		status = "initializing",
		nameRace = name,
		players = {{
			nick = GetPlayerName(roomId),
			src = roomId,
			ownerRace = true,
			vehicle = false
		}},
		playervehicles = {},
		invitations = {},
		NfStarted = false
	}
	IdsRacesAll[tostring(roomId)] = tostring(roomId)
	Races[roomId] = currentRace
	return setmetatable(currentRace, getmetatable(Races))
end

GetTimeFromStringExplode = function(data)
	return data:match("explosions%-(%d+)")
end

RaceRoom.invitePlayer = function(currentRace, playerId, roomId, inviteId)
	currentRace.invitations[tostring(playerId)] = { nick = GetPlayerName(playerId), src = playerId }
	RaceRoom.sendInvitation(playerId, roomId, inviteId, currentRace.nameRace)

	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
	end
end

RaceRoom.sendInvitation = function(playerId, roomId, inviteId, nameRace)
	TriggerClientEvent("custom_races:client:sendInvitation", playerId, roomId, GetPlayerName(inviteId), nameRace)
end

RaceRoom.removeInvitation = function(currentRace, playerId)
	currentRace.invitations[tostring(playerId)] = nil
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
	end
	TriggerClientEvent("custom_races:client:removeinvitation", playerId, currentRace.source)
end

RaceRoom.acceptInvitation = function(currentRace, playerId)
	table.insert(currentRace.players, {nick = GetPlayerName(playerId), src = playerId, ownerRace = false, vehicle = false})
	currentRace.invitations[tostring(playerId)] = nil
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			IdsRacesAll[tostring(playerId)] = tostring(currentRace.source)
			TriggerClientEvent("custom_races:client:joinRace", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.nameRace, currentRace.data)
		else
			TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
		end
	end
end

RaceRoom.denyInvitation = function(currentRace, playerId)
	currentRace.invitations[tostring(playerId)] = nil
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
	end
end

RaceRoom.getSrcPlayersList = function(currentRace)
	local srcPlayersList = {}
	for k, v in pairs(currentRace.players) do
		table.insert(srcPlayersList, v.src)
	end
	return srcPlayersList
end

RaceRoom.startRace = function(currentRace, veh)
	LoadNewRace(currentRace.data.raceid, currentRace.data.racelaps, {}, veh, currentRace.data.weather, currentRace.data.hour, currentRace.source)
end

RaceRoom.LoadNewRace = function(currentRace, raceId, laps, weapons, vehicle, weather, time, roomId)
	currentRace.currentWeapons = weapons
	currentRace.actualWeatherAndHour = { weather = weather, hour = tonumber(time), minute = 0, second = 0 }
	math.randomseed(os.time())
	currentRace.status = "loading_race"
	currentRace.totalRaceTime = 0
	currentRace.playersStats = {}
	currentRace.drivers = {}
	currentRace.checkpointPositions = {}
	currentRace.finalPositions = {}
	currentRace.positions = {}
	currentRace.gridPositions = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	currentRace.racePositions = {}
	currentRace.playersFinished = 0
	playersLoaded = {}

	Citizen.CreateThread(function()
		local raceid = raceId
		local route_file = GetRouteFileByRaceID(raceid)
		if route_file then
			local trackUGC = json.decode(LoadResourceFile(GetCurrentResourceName(), route_file))
			currentRace.currentTrackUGC = trackUGC
			ConvertFromUGCtoERS(tonumber(laps), roomId)
			SendTrackToClient(roomId)
			Citizen.Wait(2000)
			startSession(roomId)
		else
			print("ERROR: No route_file found for raceid: " .. raceid)
		end
	end)
end

-- Function to get the actual path of route_file
GetRouteFileByRaceID = function(raceid)
	local result = MySQL.query.await("SELECT route_file FROM custom_race_list WHERE raceid = @raceid", {['@raceid'] = raceid})
	if result and #result > 0 then
		return result[1].route_file
	else
		return nil
	end
end

local randomVeh = {
	"t20",
	"xa21",
	"bmx"
}

RaceRoom.ConvertFromUGCtoERS = function(currentRace, lapCount)
	currentRace.actualTrack.trackName = currentRace.currentTrackUGC.mission.gen.nm
	currentRace.actualTrack.laps = lapCount
	currentRace.actualTrack.removeprops = currentRace.currentTrackUGC.mission.dhprop

	if not currentRace.actualTrack.removeprops then
		currentRace.actualTrack.removeprops = {mn = {}, pos = {}}
	end

	if not currentRace.actualTrack.predefveh then
		currentRace.actualTrack.predefveh = GetHashKey("bmx") -- If no vehicle is selected, lock the vehicle to bmx
		--[[currentRace.actualTrack.predefveh = currentRace.currentTrackUGC.mission.gen.ivm
		if type(currentRace.actualTrack.predefveh) == "number" and (currentRace.actualTrack.predefveh >= 99999 or currentRace.actualTrack.predefveh <= -99999) then
			goto lbl_66
		end
		currentRace.actualTrack.predefveh = GetHashKey(randomVeh[math.random(1, #randomVeh)]) -- random vehicle]]
	end
	::lbl_66::
	currentRace.actualTrack.checkpoints = {}
	for i = 1, currentRace.currentTrackUGC.mission.race.chp, 1 do
		currentRace.actualTrack.checkpoints[i] = {}
		currentRace.actualTrack.checkpoints[i].x = currentRace.currentTrackUGC.mission.race.chl[i].x
		currentRace.actualTrack.checkpoints[i].y = currentRace.currentTrackUGC.mission.race.chl[i].y
		currentRace.actualTrack.checkpoints[i].z = currentRace.currentTrackUGC.mission.race.chl[i].z
		currentRace.actualTrack.checkpoints[i].heading = currentRace.currentTrackUGC.mission.race.chh[i]
		currentRace.actualTrack.checkpoints[i].d = currentRace.currentTrackUGC.mission.race.chs and 10 * currentRace.currentTrackUGC.mission.race.chs[i] or 10
		currentRace.actualTrack.checkpoints[i].pair_d = currentRace.currentTrackUGC.mission.race.chs2 and 10 * currentRace.currentTrackUGC.mission.race.chs2[i] or 10

		if currentRace.currentTrackUGC.mission.race.cpbs1 then
			currentRace.actualTrack.checkpoints[i].id = currentRace.currentTrackUGC.mission.race.cpbs1[i]
			if Config.PointsType.Primary.Round_Large[currentRace.currentTrackUGC.mission.race.cpbs1[i]] then
				currentRace.actualTrack.checkpoints[i].isRound = true
				currentRace.actualTrack.checkpoints[i].isLarge = true
			end
			if Config.PointsType.Primary.Temporal[currentRace.currentTrackUGC.mission.race.cpbs1[i]] then
				currentRace.actualTrack.checkpoints[i].isTemporal = true
			end
			if Config.PointsType.Primary.Round[currentRace.currentTrackUGC.mission.race.cpbs1[i]] then
				currentRace.actualTrack.checkpoints[i].isRound = true
			end
			currentRace.actualTrack.checkpoints[i].warp = Config.PointsType.Primary.Warp[currentRace.currentTrackUGC.mission.race.cpbs1[i]] or false
			if currentRace.currentTrackUGC.mission.race.cppsst then
				if currentRace.currentTrackUGC.mission.race.cppsst[i] == 1 then
					currentRace.actualTrack.checkpoints[i].planerot = "up"
				elseif currentRace.currentTrackUGC.mission.race.cppsst[i] == 2 then
					currentRace.actualTrack.checkpoints[i].planerot = "left"
				elseif currentRace.currentTrackUGC.mission.race.cppsst[i] == 4 then
					currentRace.actualTrack.checkpoints[i].planerot = "right"
				elseif currentRace.currentTrackUGC.mission.race.cppsst[i] == 8 then
					currentRace.actualTrack.checkpoints[i].planerot = "down"
				end
			end
		else
			currentRace.actualTrack.checkpoints[i].warp = false
		end
		currentRace.actualTrack.checkpoints[i].transform = currentRace.currentTrackUGC.mission.race.cptfrm and currentRace.currentTrackUGC.mission.race.cptfrm[i] or -1
		currentRace.actualTrack.checkpoints[i].pair_transform = currentRace.currentTrackUGC.mission.race.cptfrms and currentRace.currentTrackUGC.mission.race.cptfrms[i] or -1

		if currentRace.currentTrackUGC.mission.race.sndchk then
			currentRace.actualTrack.checkpoints[i].pair_x = currentRace.currentTrackUGC.mission.race.sndchk[i].x
			currentRace.actualTrack.checkpoints[i].pair_y = currentRace.currentTrackUGC.mission.race.sndchk[i].y
			currentRace.actualTrack.checkpoints[i].pair_z = currentRace.currentTrackUGC.mission.race.sndchk[i].z
			currentRace.actualTrack.checkpoints[i].pair_heading = currentRace.currentTrackUGC.mission.race.sndrsp[i]
			if currentRace.currentTrackUGC.mission.race.cpbs1 then
				currentRace.actualTrack.checkpoints[i].pair_isRound = Config.PointsType.Pair.Round_Large[currentRace.currentTrackUGC.mission.race.cpbs1[i]] or false
				currentRace.actualTrack.checkpoints[i].pair_isLarge = Config.PointsType.Pair.Round_Large[currentRace.currentTrackUGC.mission.race.cpbs1[i]] or false
				currentRace.actualTrack.checkpoints[i].isTemporal = Config.PointsType.Pair.Temporal[currentRace.currentTrackUGC.mission.race.cpbs1[i]] or false
				currentRace.actualTrack.checkpoints[i].pair_isRound = Config.PointsType.Pair.Round[currentRace.currentTrackUGC.mission.race.cpbs1[i]] or false
				currentRace.actualTrack.checkpoints[i].pair_warp = Config.PointsType.Pair.Warp[currentRace.currentTrackUGC.mission.race.cpbs1[i]] or false
			end
		else
			currentRace.actualTrack.checkpoints[i].pair_warp = false
			currentRace.actualTrack.checkpoints[i].pair_x = 0.0
			currentRace.actualTrack.checkpoints[i].pair_y = 0.0
			currentRace.actualTrack.checkpoints[i].pair_z = 0.0
			currentRace.actualTrack.checkpoints[i].pair_heading = 0.0
		end
		if currentRace.currentTrackUGC.mission.race.rndchk and currentRace.currentTrackUGC.mission.race.rndchk[i] then
			currentRace.actualTrack.checkpoints[i].isRound = true
		end
		if currentRace.currentTrackUGC.mission.race.rndchks and currentRace.currentTrackUGC.mission.race.rndchks[i] then
			currentRace.actualTrack.checkpoints[i].pair_isRound = true
		end
		if currentRace.actualTrack.checkpoints[i].pair_x ~= 0.0 and currentRace.actualTrack.checkpoints[i].pair_x ~= nil then
			goto lbl_571
		end
		if currentRace.actualTrack.checkpoints[i].pair_y ~= 0.0 and currentRace.actualTrack.checkpoints[i].pair_y ~= nil then
			goto lbl_571
		end
		if currentRace.actualTrack.checkpoints[i].pair_z ~= 0.0 and currentRace.actualTrack.checkpoints[i].pair_z ~= nil then
			goto lbl_571
		end
		currentRace.actualTrack.checkpoints[i].hasPair = false
		goto lbl_575
		::lbl_571::
		currentRace.actualTrack.checkpoints[i].hasPair = true
		::lbl_575::
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
			currentRace.actualTrack.checkpoints[i].pair_d = 30 * currentRace.currentTrackUGC.mission.race.chs2[i]
		else
			if not currentRace.actualTrack.checkpoints[i].pair_isRound and not currentRace.actualTrack.checkpoints[i].pair_warp then
				goto lbl_663
			end
			currentRace.actualTrack.checkpoints[i].pair_d = 15 * currentRace.currentTrackUGC.mission.race.chs2[i]
		end 
		::lbl_663::
	end

	currentRace.actualTrack.positions = {}
	local maxPlayers = 30 -- Defined maximum number of players
	local totalPositions = #currentRace.currentTrackUGC.mission.veh.loc -- Actual maximum number of players

	for i = 1, maxPlayers do
		local index = i

		if index > totalPositions then
			index = 1 -- If the actual number of players is less than the maximum number of players, the default is set to loc 1
		end

		table.insert(currentRace.actualTrack.positions, {
			x = currentRace.currentTrackUGC.mission.veh.loc[index].x,
			y = currentRace.currentTrackUGC.mission.veh.loc[index].y,
			z = currentRace.currentTrackUGC.mission.veh.loc[index].z,
			heading = currentRace.currentTrackUGC.mission.veh.head[index]
		})
	end

	currentRace.actualTrack.transformVehicles = currentRace.currentTrackUGC.mission.race.trfmvm or {}
	for i = 1, #currentRace.actualTrack.transformVehicles do
		if currentRace.actualTrack.transformVehicles[i] == 0 and currentRace.actualTrack.checkpoints[i] and currentRace.actualTrack.checkpoints[i].transform ~= -1 then
			table.remove(currentRace.actualTrack.checkpoints, i)
		end
	end

	currentRace.actualTrack.propsToRemove = {}
	if currentRace.currentTrackUGC.mission.dhprop then
		for k, v in ipairs(currentRace.currentTrackUGC.mission.dhprop.mn) do
			currentRace.actualTrack.propsToRemove[v] = true
		end
	end

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
RaceRoom.SendTrackToClient = function(currentRace, roomId)
	PlayerRoutingBucket = PlayerRoutingBucket + 1
	currentRace.actualTrack.routingbucket = PlayerRoutingBucket
	local props = {}
	local dprops = {}
	for i = 1, currentRace.currentTrackUGC.mission.prop.no do
		table.insert(props, {
			hash = currentRace.currentTrackUGC.mission.prop.model[i],
			x = currentRace.currentTrackUGC.mission.prop.loc[i].x,
			y = currentRace.currentTrackUGC.mission.prop.loc[i].y,
			z = currentRace.currentTrackUGC.mission.prop.loc[i].z,
			rot = {x = currentRace.currentTrackUGC.mission.prop.vRot[i].x + 0.0, y = currentRace.currentTrackUGC.mission.prop.vRot[i].y + 0.0, z = currentRace.currentTrackUGC.mission.prop.vRot[i].z + 0.0},
			prpclr = currentRace.currentTrackUGC.mission.prop.prpclr and currentRace.currentTrackUGC.mission.prop.prpclr[i] or nil,
		})
	end
	for i = 1, currentRace.currentTrackUGC.mission.dprop.no do
		table.insert(dprops, {
			hash = currentRace.currentTrackUGC.mission.dprop.model[i],
			x = currentRace.currentTrackUGC.mission.dprop.loc[i].x,
			y = currentRace.currentTrackUGC.mission.dprop.loc[i].y,
			z = currentRace.currentTrackUGC.mission.dprop.loc[i].z,
			rot = {x = currentRace.currentTrackUGC.mission.dprop.vRot[i].x + 0.0, y = currentRace.currentTrackUGC.mission.dprop.vRot[i].y + 0.0, z = currentRace.currentTrackUGC.mission.dprop.vRot[i].z + 0.0},
			prpdclr = currentRace.currentTrackUGC.mission.dprop.prpdclr and currentRace.currentTrackUGC.mission.dprop.prpdclr[i] or nil,
		})
	end
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:loadTrack", v.src, currentRace.actualTrack, props, dprops, tonumber(k))
	end
end

RaceRoom.checkPointTouched = function(currentRace, actualCheckPoint, totalCheckPointsTouched, playerId)
	currentRace.drivers[playerId].actualCheckPoint = actualCheckPoint
	currentRace.drivers[playerId].totalCheckpointsTouched = totalCheckPointsTouched

	if nil == currentRace.checkpointPositions[totalCheckPointsTouched] then
		currentRace.checkpointPositions[totalCheckPointsTouched] = {{playerID = playerId, totalTime = currentRace.totalRaceTime}}
	else
		table.insert(currentRace.checkpointPositions[totalCheckPointsTouched], {playerID = playerId, totalTime = currentRace.totalRaceTime})
	end

	UpdateRaceTable(playerId, #currentRace.checkpointPositions[totalCheckPointsTouched], currentRace.source)

	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.setTotalRaceTimeStart = function(currentRace, totalRaceTimeStart)
	currentRace.totalRaceTimeStart = totalRaceTimeStart
end

RaceRoom.updateTotalRaceTime = function(currentRace, totalRaceTime)
	currentRace.totalRaceTime = totalRaceTime - currentRace.totalRaceTimeStart + 3000
end

RaceRoom.StartPlayerSession = function(currentRace, playerId, roomId)
	local playerId = tonumber(playerId)

	currentRace.drivers[playerId] = {
		playerID = playerId,
		playerName = GetPlayerName(playerId),
		points = 0,
		bestLap = 9999999,
		bestLapFormatted = "",
		gridPosition = 0,
		totalCheckpointsTouched = 0,
		actualCheckPoint = 1,
		actualLap = 0,
		startLapTime = 0,
		startLapTimeServer = 0,
		startRaceTimeServer = 0,
		lastLapTime = 0,
		totalRaceTime = 0,
		totalRaceTimeFormatted = 0,
		isSpecting = true,
		worthy = false,
		hasFinished = false,
		startPosition = 0,
		finalPosition = 0,
		hasnf = false,
		hascheated = false
	}

	currentRace.racePositions[#currentRace.racePositions + 1] = {playerID = tonumber(playerId), bestLap = 9999999}

	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end

	TriggerClientEvent("custom_races:hereIsTheServerStatus", playerId, "race")
	TriggerClientEvent("custom_races:startSession", playerId)
	TriggerClientEvent("custom_races:hereIsTheSessionData", playerId, currentRace.actualWeatherAndHour, currentRace.actualTrack, currentRace.actualTrack.laps, currentRace.currentWeapons)
end

RaceRoom.UpdateRaceTable = function(currentRace, playerId, finalPosition)
	local racePositions = {}
	local position = 1
	for k, v in pairs(currentRace.racePositions) do
		if v.playerID == playerId then
			racePositions = currentRace.racePositions[k]
			table.remove(currentRace.racePositions, position)
			break
		end
		position = position + 1
	end
	if finalPosition ~= -1 then
		table.insert(currentRace.racePositions, finalPosition, {playerID = racePositions.playerID, bestLap = racePositions.bestLap})
	end
end

RaceRoom.checkPointTouchedRemove = function(currentRace, actualCheckPoint, totalCheckPointsTouched, playerId)
	currentRace.drivers[playerId].actualCheckPoint = actualCheckPoint
	currentRace.drivers[playerId].totalCheckpointsTouched = totalCheckPointsTouched

	for k, v in ipairs(currentRace.checkpointPositions[totalCheckPointsTouched + 1]) do
		if tonumber(playerId) == tonumber(v.playerID) then
			table.remove(currentRace.checkpointPositions[totalCheckPointsTouched + 1], k)
		end
	end

	UpdateRaceTable(playerId, #currentRace.checkpointPositions[totalCheckPointsTouched], currentRace.source)

	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.hereIsMyCar = function(currentRace, veh, playerId)
	currentRace.drivers[playerId].vehicle = veh
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.playerFinish = function(currentRace, playerId)
	currentRace.playersFinished = currentRace.playersFinished + 1
	currentRace.drivers[playerId].totalRaceTime = currentRace.totalRaceTime
	currentRace.drivers[playerId].totalRaceTimeFormatted = FormatTimeFromMilliseconds(currentRace.totalRaceTime)
	table.insert(currentRace.finalPositions, playerId)
	local finalPosition = #currentRace.finalPositions
	if currentRace.actualTrack.lastexplode > 0 then
		finalPosition = Count(currentRace.drivers) - finalPosition + 1
	end
	if 9999999 == currentRace.drivers[playerId].bestLap then
		currentRace.drivers[playerId].bestLap = 0
	end
	currentRace.drivers[playerId].finalPosition = finalPosition
	currentRace.drivers[playerId].worthy = true
	currentRace.drivers[playerId].hasFinished = true
	UpdateRaceTable(playerId, finalPosition, currentRace.source)
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
	if currentRace.playersFinished >= #currentRace.racePositions then
		RaceIsFinished(currentRace.source)
	elseif currentRace.playersFinished * 2 >= #currentRace.racePositions and not currentRace.NfStarted then
		StartNFCountdown(currentRace.source)
		currentRace.NfStarted = true
	end
end

RaceRoom.RaceIsFinished = function(currentRace)
	currentRace.status = "waiting"
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheServerStatus", v.src, currentRace.status)
		TriggerClientEvent("custom_races:raceHasEnded", v.src)
	end
	for k, v in ipairs(currentRace.finalPositions) do
		TriggerClientEvent("custom_races:giveMeYourCar", v)
	end
	Citizen.Wait(1000)

	if currentRace.actualTrack.lastexplode > 0 then
		local finishedPlayers = {}
		local notFinishedPlayers = {}
		for k, v in pairs(currentRace.finalPositions) do
			if currentRace.drivers[v].hasnf then
				table.insert(notFinishedPlayers, v)
			else
				table.insert(finishedPlayers, v)
			end
		end
		for k, v in pairs(ReverseTable(notFinishedPlayers)) do
			table.insert(finishedPlayers, v)
		end
		for k, v in pairs(finishedPlayers) do
			currentRace.drivers[v].finalPosition = k
			currentRace.racePositions[k] = {
				playerID = tonumber(v),
				bestLap = currentRace.drivers[v].bestLap
			}
		end
		currentRace.finalPositions = finishedPlayers
	end

	if currentRace.actualTrack.lastexplode == 0 then
		local category, raceid = GetRaceFrontFromRaceid(currentRace.data.raceid)
		if races_data_front[category] and races_data_front[category][raceid] and races_data_front[category][raceid].besttimes then
			for k, v in pairs(currentRace.drivers) do
				if not currentRace.drivers[k].hasnf and not currentRace.drivers[k].hascheated then
					if GetPlayerName(k) then
						table.insert(races_data_front[category][raceid].besttimes, {
							name = GetPlayerName(k),
							time = v.totalRaceTime,
							vehicle = v.vehicle and v.vehicle.name or "-",
							date = os.date("%x")
						})
					end
				end
			end
			table.sort(races_data_front[category][raceid].besttimes, function(timeA, timeB) return timeA.time < timeB.time end)
			local names = {}
			local besttimes = {}
			for i = 1, #races_data_front[category][raceid].besttimes do
				if #besttimes < 10 and not names[races_data_front[category][raceid].besttimes[i].name] then
					names[races_data_front[category][raceid].besttimes[i].name] = true
					table.insert(besttimes, races_data_front[category][raceid].besttimes[i])
				end
			end
			races_data_front[category][raceid].besttimes = besttimes
			TriggerClientEvent("custom_races:client:UpdateRacesData_Front_S", -1, category, raceid, races_data_front[category][raceid])
			MySQL.update("UPDATE custom_race_list SET besttimes = ? WHERE raceid = ?", {json.encode(races_data_front[category][raceid].besttimes), currentRace.data.raceid})
		end
	end

	if #currentRace.finalPositions >= 8 then
		for i = 1, #currentRace.finalPositions do
			local player = ESX.GetPlayerFromId(currentRace.finalPositions[i])
			if player then
				if i <= 3 then
					local podiumPosition = (1 == i and "frst") or (2 == i and "scnd") or "thrd"
					UpdateTop(player.getIdentifier(), podiumPosition, currentRace.finalPositions[i], #currentRace.finalPositions + 1 - i)
				else
					AddPlayerExperience(player.getIdentifier(), currentRace.finalPositions[i], #currentRace.finalPositions + 1 - i)
				end
			end
		end
	end

	for k, v in ipairs(currentRace.finalPositions) do
		if currentRace.drivers[v] then
			TriggerClientEvent("custom_races:showFinalResult", v, not currentRace.drivers[v].hasnf and currentRace.drivers[v].hasnf)
		end
	end
end

RaceRoom.StartNFCountdown = function(currentRace)
	if 0 == currentRace.actualTrack.lastexplode then
		for k, v in pairs(currentRace.drivers) do
			TriggerClientEvent("custom_races:client:StartNFCountdown", v.playerID)
		end
	end
end

RaceRoom.checkLapTime = function(currentRace, playerId, actualLapTime)
	if 1 == tonumber(currentRace.data.racelaps) then
		actualLapTime = currentRace.totalRaceTime
	end
	if currentRace.drivers[playerId].bestLap > actualLapTime then
		currentRace.drivers[playerId].bestLap = actualLapTime
		currentRace.drivers[playerId].bestLapFormatted = FormatTimeFromMilliseconds(actualLapTime)
		for k, v in ipairs(currentRace.racePositions) do
			if v.playerID == playerId then
				currentRace.racePositions[k].bestLap = actualLapTime
			end
		end
	end
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.updateDriverInfo = function(currentRace, playerId, actualCheckPoint, actualLap, startLapTime, lastLapTime)
	currentRace.drivers[playerId].actualCheckPoint = actualCheckPoint
	currentRace.drivers[playerId].actualLap = actualLap
	currentRace.drivers[playerId].startLapTime = startLapTime
	currentRace.drivers[playerId].lastLapTime = lastLapTime
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.updateDriverLapTimeServer = function(currentRace, playerId)
	currentRace.drivers[playerId].startLapTimeServer = GetGameTimer()
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.updateDriverStartRaceTimeServer = function(currentRace, playerId)
	currentRace.drivers[playerId].startRaceTimeServer = GetGameTimer()
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.updateMySpectateStatus = function(currentRace, playerId, bool)
	if nil == currentRace.drivers[playerId] then
		return
	end
	currentRace.drivers[playerId].isSpecting = bool
	for k, v in pairs(currentRace.players) do
		TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
	end
end

RaceRoom.playerDropped = function(currentRace, playerId)
	if "initializing" ~= currentRace.status and currentRace.source then
		if currentRace.drivers[playerId] and currentRace.drivers[playerId].hasFinished then
			currentRace.playersFinished = currentRace.playersFinished - 1
		end
		if nil ~= currentRace.drivers[playerId] then
			ClearPlayerCheckpoints(playerId, currentRace.source)
			for k, v in ipairs(currentRace.racePositions) do
				if v.playerID == playerId then
					table.remove(currentRace.racePositions, k)
					break
				end
			end
			for k, v in ipairs(currentRace.finalPositions) do
				if v == playerId then
					table.remove(currentRace.finalPositions, k)
					break
				end
			end
			currentRace.gridPositions[currentRace.drivers[playerId].gridPosition] = 0
			currentRace.drivers[playerId] = nil
		end
		UpdateRaceTable(playerId, -1, currentRace.source)
		if currentRace.source == playerId and not currentRace.NfStarted then
			StartNFCountdown(currentRace.source)
			currentRace.NfStarted = true
			for k, v in pairs(currentRace.players) do
				if currentRace.players[k] and v.src ~= playerId then
					TriggerClientEvent("custom_races:hostdropped", v.src)
				end
			end
		end
		for k, v in pairs(currentRace.players) do
			if v.src ~= playerId then
				TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
			else
				currentRace.players[k] = nil
			end
		end
	else
		if currentRace.source and currentRace.source == playerId then
			for k, v in pairs(currentRace.players) do
				if not v.ownerRace then
					TriggerClientEvent("custom_races:client:exitRoom", v.src)
				end
				IdsRacesAll[tostring(v.src)] = nil
			end
			Races[currentRace.source] = nil
		else
			if currentRace.source then
				local canSyncToClient = false
				for k, v in pairs(currentRace.players) do
					if v.src == playerId then
						currentRace.players[k] = nil
						canSyncToClient = true
					end
				end
				if currentRace.invitations[tostring(playerId)] ~= nil then
					currentRace.invitations[tostring(playerId)] = nil
					canSyncToClient = true
				end
				if canSyncToClient then
					for i = 1, #currentRace.players do
						TriggerClientEvent("custom_races:client:SyncPlayerList", currentRace.players[i].src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
					end
				end
			end
		end
	end
end

RaceRoom.leaveRace = function(currentRace, playerId)
	if "initializing" ~= currentRace.status and currentRace.source then
		if currentRace.drivers[playerId].hasFinished then
			currentRace.playersFinished = currentRace.playersFinished - 1
		end
		if currentRace.drivers[playerId] then
			ClearPlayerCheckpoints(playerId, currentRace.source)
			local isPlayerFound = false
			for k, v in ipairs(currentRace.racePositions) do
				if v.playerID == playerId then
					table.remove(currentRace.racePositions, k)
					break
				end
			end
			currentRace.gridPositions[currentRace.drivers[playerId].gridPosition] = 0
			currentRace.drivers[playerId] = nil
		end
		UpdateRaceTable(playerId, -1, currentRace.source)
		if currentRace.source == playerId and not currentRace.NfStarted then
			StartNFCountdown(currentRace.source)
			currentRace.NfStarted = true
			for k, v in pairs(currentRace.players) do
				if currentRace.players[k] and v.src ~= playerId then
					TriggerClientEvent("custom_races:hostleaverace", v.src)
				end
			end
		end
		for k, v in pairs(currentRace.players) do
			if v.src ~= playerId then
				TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
			else
				currentRace.players[k] = nil
			end
		end
	--[[else
		if currentRace.source then
			for k, v in pairs(currentRace.players) do
				if v.src == playerId then
					currentRace.players[k] = nil
				end
			end
			if #currentRace.players > 0 then
				for i = 1, #currentRace.players do
					TriggerClientEvent("custom_races:client:SyncPlayerList", currentRace.players[i].src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
				end
			else
				Races[currentRace.source] = nil
			end
			IdsRacesAll[tostring(playerId)] = nil
		end]]
	end
	TriggerClientEvent("custom_races:raceHasEnded", playerId)
end

RaceRoom.ClearPlayerCheckpoints = function(currentRace, playerId)
	for k, v in pairs(currentRace.checkpointPositions) do
		for a, b in pairs(v) do
			if b.playerID == playerId then
				table.remove(currentRace.checkpointPositions[k], a)
				break
			end
		end
	end
end

RaceRoom.setPlayerCar = function(currentRace, playerId, data)
	for k, v in pairs(currentRace.players) do
		if v.src == playerId then
			currentRace.players[k].vehicle = data.label
			local model_number = tonumber(data.model)
			if model_number then
				currentRace.playervehicles[playerId] = model_number
			else
				local query_result = MySQL.query.await("SELECT mods FROM player_vehicles WHERE plate = ?", {data.model})
				if query_result[1] then
					currentRace.playervehicles[playerId] = json.decode(query_result[1].mods)
				else
					currentRace.players[k].vehicle = false
				end
			end
			for i = 1, #currentRace.players do
				if currentRace.players[i] then
					TriggerClientEvent("custom_races:client:SyncPlayerList", currentRace.players[i].src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
				end
			end
			break
		end
	end
end

function FormatTimeFromMilliseconds(milliseconds) -- 61345 = 01:01.345
	local time_minutes = math.floor(milliseconds / 1000 / 60)
	local time_seconds = math.floor(math.fmod(milliseconds / 1000, 60))
	local time_milliseconds = math.fmod(milliseconds, 1000)

	if time_minutes < 10 then
		time_minutes = "0" .. time_minutes
	end
	if time_seconds < 10 then
		time_seconds = "0" .. time_seconds
	end
	if time_milliseconds < 10 then
		time_milliseconds = "00" .. time_milliseconds
	elseif time_milliseconds < 100 then
		time_milliseconds = "0" .. time_milliseconds
	end

	return time_minutes .. ":" .. time_seconds .. "." .. time_milliseconds
end