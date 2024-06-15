IdsRacesAll = {}
playerSpawnedVehicles = {}

Config.Framework = "esx"
if "esx" == Config.Framework then
	ESX = exports.es_extended.getSharedObject()
end

RegisterServerEvent("custom_races:LoadMe")
RegisterServerEvent("custom_races:hereIsMyCar")
RegisterServerEvent("custom_races:checkPointTouched")
RegisterServerEvent("custom_races:checkPointTouchedRemove")
RegisterServerEvent("custom_races:playerFinish")
RegisterServerEvent("custom_races:checkLapTime")
RegisterServerEvent("custom_races:updateDriverInfo")
RegisterServerEvent("custom_races:updateDriverLapTimeServer")
RegisterServerEvent("custom_races:updateDriverStartRaceTimeServer")
RegisterServerEvent("custom_races:updateMySpectateStatus")
RegisterServerEvent("custom_races:spawnvehicle")

LoadNewRace = function(raceId, laps, weapons, vehicle, weather, time, roomId)
	Races[roomId].LoadNewRace(Races[roomId], raceId, laps, weapons, vehicle, weather, time, roomId)
end

ConvertFromUGCtoERS = function(lapCount, roomId)
	Races[roomId].ConvertFromUGCtoERS(Races[roomId], lapCount)
end

SendTrackToClient = function(roomId)
	Races[roomId].SendTrackToClient(Races[roomId], roomId)
end

StartPlayerSession = function(playerId, roomId)
	Races[roomId].StartPlayerSession(Races[roomId], playerId, roomId)
end

startSession = function(roomId)
	local srcPlayersList = Races[roomId].getSrcPlayersList(Races[roomId])
	for k, v in pairs(srcPlayersList) do
		TriggerClientEvent("custom_races:raceHasStarted", v)
		StartPlayerSession(v, roomId)
	end
	Citizen.Wait(3000)
	startCountdown(srcPlayersList, roomId)
end

startCountdown = function(playersList, roomId)
	local status = "start"
	for k, v in pairs(playersList) do
		TriggerClientEvent("custom_races:hereIsTheServerStatus", v, status)
	end

	local list = {}
	for k, v in pairs(playersList) do
		list[k] = v
	end

	for gridPosition = 1, #list do
		local randomIndex = math.random(1, #list)
		local playerId = list[randomIndex]
		table.remove(list, randomIndex)
		local car = Races[roomId].playervehicles[playerId] or Races[roomId].actualTrack.predefveh
		TriggerClientEvent("custom_races:forceJoin", playerId, gridPosition, car)
	end

	Citizen.CreateThread(function()
		Citizen.Wait(5000)
		for k, v in pairs(playersList) do
			TriggerClientEvent("custom_races:startCountdown", v)
		end
		Citizen.Wait(3000)
		for k, v in pairs(playersList) do
			TriggerClientEvent("custom_races:hereIsTheServerStatus", v, status)
		end
		
		local currentRace = Races[roomId]
		currentRace.setTotalRaceTimeStart(currentRace, GetGameTimer())
	end)
end

UpdateRaceTable = function(playerId, finalPosition, roomId)
	Races[roomId].UpdateRaceTable(Races[roomId], playerId, finalPosition)
end

ClearPlayerCheckpoints = function(playerId, roomId)
	Races[roomId].ClearPlayerCheckpoints(Races[roomId], playerId)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Races) do
			Races[k].updateTotalRaceTime(Races[k], GetGameTimer())
		end
	end
end)

AddEventHandler('custom_races:spawnvehicle', function(vehNetId)
	local playerId = source
	playerSpawnedVehicles[playerId] = vehNetId
end)

AddEventHandler("playerDropped", function()
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace then
		currentRace.playerDropped(currentRace, playerId)
	end
	local vehNetId = playerSpawnedVehicles[playerId]
	if vehNetId then
		local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
		if DoesEntityExist(vehicle) then
			DeleteEntity(vehicle)
		end
		playerSpawnedVehicles[playerId] = nil
	end
end)

AddEventHandler("custom_races:checkPointTouched", function(actualCheckPoint, totalCheckPointsTouched, roomId)
	Races[roomId].checkPointTouched(Races[roomId], actualCheckPoint, totalCheckPointsTouched, source)
end)

AddEventHandler("custom_races:checkPointTouchedRemove", function(actualCheckPoint, totalCheckPointsTouched, roomId)
	Races[roomId].checkPointTouchedRemove(Races[roomId], actualCheckPoint, totalCheckPointsTouched, source)
end)

AddEventHandler("custom_races:playerFinish", function(playerId)
	local playerId = playerId or source
	Races[tonumber(IdsRacesAll[tostring(playerId)])].playerFinish(Races[tonumber(IdsRacesAll[tostring(playerId)])], playerId)
end)

RaceIsFinished = function(roomId)
	Races[roomId].RaceIsFinished(Races[roomId])
end

StartNFCountdown = function(roomId)
	Races[roomId].StartNFCountdown(Races[roomId])
end

AddEventHandler("custom_races:checkLapTime", function(actualLapTime)
	Races[tonumber(IdsRacesAll[tostring(source)])].checkLapTime(Races[tonumber(IdsRacesAll[tostring(source)])], source, actualLapTime)
end)

AddEventHandler("custom_races:updateDriverInfo", function(actualCheckPoint, actualLap, startLapTime, lastLapTime)
	Races[tonumber(IdsRacesAll[tostring(source)])].updateDriverInfo(Races[tonumber(IdsRacesAll[tostring(source)])], source, actualCheckPoint, actualLap, startLapTime, lastLapTime)
end)

AddEventHandler("custom_races:updateDriverLapTimeServer", function()
	Races[tonumber(IdsRacesAll[tostring(source)])].updateDriverLapTimeServer(Races[tonumber(IdsRacesAll[tostring(source)])], source)
end)

AddEventHandler("custom_races:updateDriverStartRaceTimeServer", function()
	Races[tonumber(IdsRacesAll[tostring(source)])].updateDriverStartRaceTimeServer(Races[tonumber(IdsRacesAll[tostring(source)])], source)
end)

AddEventHandler("custom_races:updateMySpectateStatus", function(bool)
	Races[tonumber(IdsRacesAll[tostring(source)])].updateMySpectateStatus(Races[tonumber(IdsRacesAll[tostring(source)])], source, bool)
end)

AddEventHandler("custom_races:LoadMe", function()
	LoadPlayer(source)
end)

LoadPlayer = function(playerId)
	Citizen.CreateThread(function()
		Citizen.Wait(250)
		TriggerClientEvent("custom_races:LoadDone", playerId)
	end)
end

AddEventHandler("custom_races:hereIsMyCar", function(veh)
	Races[tonumber(IdsRacesAll[tostring(source)])].hereIsMyCar(Races[tonumber(IdsRacesAll[tostring(source)])], veh, source)
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	for k, v in ipairs(GetPlayers()) do
		LoadPlayer(v)
	end
end)

RegisterNetEvent("custom_races:server:createRace", function(data)
	CreateRaceFunction(source, data, data.name)
end)

CreateRaceFunction = function(roomId, data, name)
	Races[roomId] = nil
	Races[roomId] = NewRace(roomId, data, name)
end

RegisterNetEvent("custom_races:server:invitePlayer", function(inviteData)
	local roomId = tonumber(IdsRacesAll[tostring(source)])
	local inviteId = source
	Races[roomId].invitePlayer(Races[roomId], inviteData.idPlayer, roomId, inviteId)
end)

RegisterNetEvent("custom_races:server:acceptInvitation", function(roomId)
	if not Races[roomId] then
		TriggerClientEvent("custom_races:hostLeaveRoom", source)
		return
	end
	if #Races[roomId].players < Races[roomId].data.maxplayers then
		Races[roomId].acceptInvitation(Races[roomId], source)
	else
		TriggerClientEvent("custom_races:client:maxplayersinvitation", source, roomId)
	end
end)

RegisterServerEvent("custom_races:server:denyInvitation", function(roomId)
	local currentRace = Races[tonumber(roomId)]
	if currentRace then
		currentRace.denyInvitation(currentRace, source)
	end
end)

RegisterNetEvent("custom_races:server:startRace", function(veh)
	Races[source].startRace(Races[source], veh)
end)

RegisterNetEvent("custom_races:server:sendVehicle", function(veh)
	for k, v in pairs(Races[source].getSrcPlayersList(Races[source])) do
		TriggerClientEvent("custom_races:hereIsTheVehicle", v, veh, GetPlayerName(source), source)
	end
end)

RegisterNetEvent("custom_races:server:LoadEveryIndividualVehicles", function()
	for k, v in pairs(Races[source].getSrcPlayersList(Races[source])) do
		TriggerClientEvent("custom_races:LoadIndividualVehicle", v)
	end
end)

GetPlayerList = function(playerId)
	local activeList = {}
	for k, v in pairs(GetPlayers()) do
		if v ~= playerId then
			table.insert(activeList, v)
		end
	end
	return activeList
end

FetchPlayerList = function(playerId, raceData)
	local playerList = GetPlayerList(playerId)
	local activePlayers = {}
	local availablePlayers = {}

	for index, player in pairs(raceData.players) do
		activePlayers[player.src] = true
	end

	for index, player in pairs(playerList) do
		local player = tonumber(player)

		if player ~= playerId and not activePlayers[player] and not raceData.invitations[tostring(player)] then
			local playerData = {}
			playerData.id = player
			playerData.name = GetPlayerName(player)
			availablePlayers[#availablePlayers + 1] = playerData
		end
	end

	return availablePlayers
end

ESX.RegisterServerCallback("custom_races:callback:getPlayerList", function(source, callback)
	local playerList = FetchPlayerList(source, Races[tonumber(IdsRacesAll[tostring(source)])])
	callback(playerList)
end)

RegisterServerEvent("custom_races:kickPlayer", function(playerId)
	local playerId = tonumber(playerId)
	local currentRace = Races[source]

	for i = 1, #currentRace.players do
		if currentRace.players[i].src == playerId then
			IdsRacesAll[tostring(currentRace.players[i].src)] = nil
			TriggerClientEvent("custom_races:client:exitRoom", currentRace.players[i].src, true)
			table.remove(currentRace.players, i)
			break
		end
	end

	for i = 1, #currentRace.players do
		TriggerClientEvent("custom_races:client:SyncPlayerList", currentRace.players[i].src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
	end
end)

RegisterServerEvent("custom_races:cancelInvi", function(data)
	local currentRace = Races[tonumber(data.sala)]
	if currentRace then
		currentRace.removeInvitation(currentRace, tonumber(data.player))
	end
end)

RegisterServerEvent("custom_races:leaveRoom", function(roomId)
	local roomId = tonumber(roomId)
	local currentRace = Races[roomId]
	if currentRace then
		if roomId == source then
			for k, v in pairs(currentRace.players) do
				TriggerClientEvent("custom_races:client:exitRoom", v.src, false)
				IdsRacesAll[tostring(v.src)] = nil
			end
			Races[roomId] = nil
		else
			for i = 1, #currentRace.players do
				if currentRace.players[i].src == source then
					IdsRacesAll[tostring(currentRace.players[i].src)] = nil
					table.remove(currentRace.players, i)
					break
				end
			end
			for i = 1, #currentRace.players do
				TriggerClientEvent("custom_races:client:SyncPlayerList", currentRace.players[i].src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
			end
		end
	end
end)

ESX.RegisterServerCallback("custom_races:raceList", function(source, callback)
	local raceList = {}
	for k, v in pairs(Races) do
		if v.data.accesible == "publica" and v.status == "initializing" then
			table.insert(raceList, {
				name = v.nameRace,
				creator = GetPlayerName(v.source),
				players = #v.players .. "/" .. v.data.maxplayers,
				roomid = v.source,
				vehicle = v.data.vehiculo
			})
		end
	end
	callback(raceList)
end)

RegisterServerEvent("custom_races:nfplayer", function()
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] then
		currentRace.drivers[playerId].hasnf = true
		for k, v in pairs(currentRace.players) do
			TriggerClientEvent("custom_races:hereIsTheDriversAndPositions", v.src, currentRace.drivers, currentRace.racePositions)
		end
	end
end)

RegisterServerEvent("custom_races:TpToNextCheckpoint", function()
	local playerId = tonumber(source)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(playerId)])]
	if currentRace and currentRace.drivers[playerId] then
		currentRace.drivers[playerId].hascheated = true
	end
end)

RegisterServerEvent("custom_races:server:joinPublicLobby", function(roomId)
	local currentRace = Races[tonumber(roomId)]
	if #currentRace.players < currentRace.data.maxplayers then
		currentRace.invitations[tostring(source)] = nil
		table.insert(currentRace.players, {nick = GetPlayerName(source), src = source, ownerRace = false, vehicle = false})
		for k, v in pairs(currentRace.players) do
			if v.src == source then
				IdsRacesAll[tostring(source)] = tostring(currentRace.source)
				TriggerClientEvent("custom_races:client:joinPlayerLobby", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers, currentRace.nameRace, currentRace.data)
			else
				TriggerClientEvent("custom_races:client:SyncPlayerList", v.src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
			end
		end
	else
		TriggerClientEvent("custom_races:client:maxplayerspubliclobby", source, roomId)
	end
end)

Bucket = {} -- If you want different races to be in different routing buckets, you can uncomment
RegisterServerEvent("custom_races:server:SetPlayerRoutingBucket", function(routingbucket)
	--[[if not routingbucket then
		SetPlayerRoutingBucket(source, Bucket[source])
	else
		Bucket[source] = GetPlayerRoutingBucket(source)
		SetPlayerRoutingBucket(source, routingbucket)
	end]]
end)

RegisterServerEvent("custom_races:server:SpectatePlayer", function(playerId)
	TriggerClientEvent("custom_races:client:SpectatePlayer", source, playerId, GetEntityCoords(GetPlayerPed(playerId)))
end)

RegisterServerEvent("custom_races:server:leave_race", function()
	local currentRace = Races[tonumber(IdsRacesAll[tostring(source)])]
	if currentRace then
		currentRace.leaveRace(currentRace, source)
	end
end)

RegisterServerEvent("custom_races:server:setplayercar", function(data)
	local currentRace = Races[tonumber(IdsRacesAll[tostring(source)])]
	if currentRace then
		if currentRace.data.vehiculo == "specific" then
			for k, v in pairs(currentRace.players) do
				currentRace.players[k].vehicle = data.label
			end
			if tonumber(data.model) then
				currentRace.actualTrack.predefveh = tonumber(data.model)
			else
				local vehicleMods = MySQL.query.await("SELECT mods FROM player_vehicles WHERE plate = ?", {data.model})[1]
				if vehicleMods then
					currentRace.actualTrack.predefveh = json.decode(vehicleMods.mods)
				end
			end
			for i = 1, #currentRace.players do
				TriggerClientEvent("custom_races:client:SyncPlayerList", currentRace.players[i].src, currentRace.players, currentRace.invitations, currentRace.data.maxplayers)
			end
		else
			currentRace.setPlayerCar(currentRace, source, data)
		end
	end
end)

ReverseTable = function(t)
	local reversedTable = {}
	local itemCount = #t
	for k, v in ipairs(t) do
		reversedTable[itemCount + 1 - k] = v
	end
	return reversedTable
end

Count = function(t)
	local c = 0
	for _, _ in pairs(t) do
		c = c + 1
	end
	return c
end