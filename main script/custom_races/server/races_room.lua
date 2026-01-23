Room = {}

function Room.CreateRaceRoom(roomId, data, ownerId, ownerName)
	local currentRoom = {
		roomId = roomId,
		roomData = data,
		ugcData = nil,
		status = "waiting",
		startTime = nil,
		ownerId = ownerId,
		ownerName = ownerName,
		syncNextFrame = true,
		predefinedVehicle = nil,
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
		local data = nil
		if raceid then
			local route_file, category = nil, nil
			local result = MySQL.query.await("SELECT * FROM custom_race_list WHERE raceid = ?", {raceid})
			if result and #result > 0 then
				route_file = result[1].route_file
				category = result[1].category
			end
			if route_file and category then
				if string.find(route_file, "local_files") then
					data = json.decode(LoadResourceFile(GetCurrentResourceName(), route_file))
				else
					data = json.decode(LoadResourceFile("custom_creator", route_file))
				end
				if category ~= "Custom" and data and data.mission and data.mission.gen then
					data.mission.gen.ownerid = category
				end
			end
		else
			data = RaceServer.Data.SearchCaches[currentRoom.ownerId]
		end
		local success, exist = Room.GetUgcFromData(currentRoom, data)
		if success then
			for k, v in pairs(currentRoom.players) do
				TriggerClientEvent("custom_races:client:countDown", v.src)
				Room.InitDriverInfos(currentRoom, v.src, v.nick)
				local identifier_license = GetPlayerIdentifierByType(v.src, "license")
				local personalVehicles = nil
				if identifier_license then
					local identifier = identifier_license:gsub("license:", "")
					local results = MySQL.query.await("SELECT vehicle_mods FROM custom_race_users WHERE license = ?", {identifier})
					if results and results[1] then
						personalVehicles = json.decode(results[1].vehicle_mods)
					end
				end
				TriggerClientEvent("custom_races:client:startRaceRoom", v.src, currentRoom.playerVehicles[v.src] or currentRoom.predefinedVehicle, personalVehicles or {}, false)
			end
			currentRoom.startTime = GetGameTimer()
		else
			currentRoom.status = "invalid"
			for k, v in pairs(currentRoom.players) do
				RaceServer.PlayerInRoom[v.src] = nil
				TriggerClientEvent("custom_races:client:exitRoom", v.src, exist and "file-not-valid" or "file-not-exist")
			end
		end
		RaceServer.Data.SearchCaches[currentRoom.ownerId] = nil
	end)
end

function Room.GetUgcFromData(currentRoom, data)
	if not data then
		return false, nil
	end
	-- Info
	data.meta = data.meta or {}
	data.meta.vehcl = data.meta.vehcl or {}
	data.mission = data.mission or {}
	data.mission.gen = data.mission.gen or {}
	data.mission.gen.ownerid = data.mission.gen.ownerid or ""
	data.mission.gen.nm = data.mission.gen.nm or ""
	data.mission.gen.dec = data.mission.gen.dec or {""}
	data.mission.gen.type = data.mission.gen.type or 2
	data.mission.gen.subtype = data.mission.gen.type or 6
	data.mission.gen.start = data.mission.gen.start or {}
	data.mission.gen.start.x = data.mission.gen.start.x or 0.0
	data.mission.gen.start.y = data.mission.gen.start.y or 0.0
	data.mission.gen.start.z = data.mission.gen.start.z or 0.0
	data.mission.gen.blmpmsg = data.mission.gen.blmpmsg or ""
	data.mission.gen.ivm = data.mission.gen.ivm or -1
	-- Fixtures
	data.mission.dhprop = data.mission.dhprop or {}
	data.mission.dhprop.mn = data.mission.dhprop.mn or {}
	data.mission.dhprop.pos = data.mission.dhprop.pos or {}
	data.mission.dhprop.no = data.mission.dhprop.no or 0
	-- Dynamic props
	data.mission.dprop = data.mission.dprop or {}
	data.mission.dprop.model = data.mission.dprop.model or {}
	data.mission.dprop.loc = data.mission.dprop.loc or {}
	data.mission.dprop.vRot = data.mission.dprop.vRot or {}
	data.mission.dprop.prpdclr = data.mission.dprop.prpdclr or {}
	data.mission.dprop.collision = data.mission.dprop.collision or {}
	data.mission.dprop.no = data.mission.dprop.no or 0
	-- Static props
	data.mission.prop = data.mission.prop or {}
	data.mission.prop.model = data.mission.prop.model or {}
	data.mission.prop.loc = data.mission.prop.loc or {}
	data.mission.prop.vRot = data.mission.prop.vRot or {}
	data.mission.prop.prpclr = data.mission.prop.prpclr or {}
	data.mission.prop.pLODDist = data.mission.prop.pLODDist or {}
	data.mission.prop.collision = data.mission.prop.collision or {}
	data.mission.prop.prpbs = data.mission.prop.prpbs or {}
	data.mission.prop.prpsba = data.mission.prop.prpsba or {}
	data.mission.prop.no = data.mission.prop.no or 0
	-- Checkpoints
	data.mission.race = data.mission.race or {}
	data.mission.race.adlc = data.mission.race.adlc or {}
	data.mission.race.adlc2 = data.mission.race.adlc2 or {}
	data.mission.race.adlc3 = data.mission.race.adlc3 or {}
	data.mission.race.aveh = data.mission.race.aveh or {}
	data.mission.race.clbs = data.mission.race.clbs or 0
	data.mission.race.icv = data.mission.race.icv or -1
	data.mission.race.chl = data.mission.race.chl or {}
	data.mission.race.chh = data.mission.race.chh or {}
	data.mission.race.chs = data.mission.race.chs or {}
	data.mission.race.chpp = data.mission.race.chpp or {}
	data.mission.race.cpado = data.mission.race.cpado or {}
	data.mission.race.chstR = data.mission.race.chstR or {}
	data.mission.race.cptfrm = data.mission.race.cptfrm or {}
	data.mission.race.cptrtt = data.mission.race.cptrtt or {}
	data.mission.race.cptrst = data.mission.race.cptrst or {}
	data.mission.race.sndchk = data.mission.race.sndchk or {}
	data.mission.race.sndrsp = data.mission.race.sndrsp or {}
	data.mission.race.chs2 = data.mission.race.chs2 or {}
	data.mission.race.chpps = data.mission.race.chpps or {}
	data.mission.race.cpados = data.mission.race.cpados or {}
	data.mission.race.chstRs = data.mission.race.chstRs or {}
	data.mission.race.cptfrms = data.mission.race.cptfrms or {}
	data.mission.race.cptrtts = data.mission.race.cptrtts or {}
	data.mission.race.cptrsts = data.mission.race.cptrsts or {}
	data.mission.race.chvs = data.mission.race.chvs or {}
	data.mission.race.cpbs1 = data.mission.race.cpbs1 or {}
	data.mission.race.cpbs2 = data.mission.race.cpbs2 or {}
	data.mission.race.cpbs3 = data.mission.race.cpbs3 or {}
	data.mission.race.trfmvm = data.mission.race.trfmvm or {}
	data.mission.race.cppsst = data.mission.race.cppsst or {}
	data.mission.race.chp = data.mission.race.chp or 0
	-- Vehicle grids
	data.mission.veh.loc = data.mission.veh.loc or {}
	data.mission.veh.head = data.mission.veh.head or {}
	data.mission.veh.no = data.mission.veh.no or #data.mission.veh.loc
	if not (data.mission.race.chp >= 3 and data.mission.veh.no >= 1) then
		return false, 1
	end
	currentRoom.ugcData = {
		test_vehicle = data.test_vehicle or nil,
		firework = {
			name = data.firework and data.firework.name or "scr_indep_firework_trailburst",
			r = data.firework and data.firework.r or 255,
			g = data.firework and data.firework.g or 255,
			b = data.firework and data.firework.b or 255
		},
		meta = {
			vehcl = data.meta.vehcl
		},
		mission = {
			gen = {
				ownerid = data.mission.gen.ownerid,
				nm = data.mission.gen.nm,
				blmpmsg = data.mission.gen.blmpmsg,
				ivm = data.mission.gen.ivm
			},
			dhprop = {
				mn = data.mission.dhprop.mn,
				pos = data.mission.dhprop.pos,
				no = data.mission.dhprop.no
			},
			dprop = {
				model = data.mission.dprop.model,
				loc = data.mission.dprop.loc,
				vRot = data.mission.dprop.vRot,
				prpdclr = data.mission.dprop.prpdclr,
				collision = data.mission.dprop.collision,
				no = data.mission.dprop.no
			},
			prop = {
				model = data.mission.prop.model,
				loc = data.mission.prop.loc,
				vRot = data.mission.prop.vRot,
				prpclr = data.mission.prop.prpclr,
				pLODDist = data.mission.prop.pLODDist,
				collision = data.mission.prop.collision,
				prpbs = data.mission.prop.prpbs,
				prpsba = data.mission.prop.prpsba,
				no = data.mission.prop.no
			},
			race = {
				-- Vehicle bitset
				adlc = data.mission.race.adlc,
				adlc2 = data.mission.race.adlc2,
				adlc3 = data.mission.race.adlc3,
				aveh = data.mission.race.aveh,
				clbs = data.mission.race.clbs,
				icv = data.mission.race.icv,
				-- Primary
				chl = data.mission.race.chl,
				chh = data.mission.race.chh,
				chs = data.mission.race.chs,
				chpp = data.mission.race.chpp,
				cpado = data.mission.race.cpado,
				chstR = data.mission.race.chstR,
				cptfrm = data.mission.race.cptfrm,
				cptrtt = data.mission.race.cptrtt,
				cptrst = data.mission.race.cptrst,
				-- Secondary
				sndchk = data.mission.race.sndchk,
				sndrsp = data.mission.race.sndrsp,
				chs2 = data.mission.race.chs2,
				chpps = data.mission.race.chpps,
				cpados = data.mission.race.cpados,
				chstRs = data.mission.race.chstRs,
				cptfrms = data.mission.race.cptfrms,
				cptrtts = data.mission.race.cptrtts,
				cptrsts = data.mission.race.cptrsts,
				-- Other Settings
				chvs = data.mission.race.chvs,
				cpbs1 = data.mission.race.cpbs1,
				cpbs2 = data.mission.race.cpbs2,
				cpbs3 = data.mission.race.cpbs3,
				trfmvm = data.mission.race.trfmvm,
				cppsst = data.mission.race.cppsst,
				chp = data.mission.race.chp
			},
			veh = {
				loc = data.mission.veh.loc,
				head = data.mission.veh.head,
				no = data.mission.veh.no
			}
		}
	}
	for k, v in pairs(currentRoom.players) do
		TriggerClientEvent("custom_races:client:loadTrack", v.src, currentRoom.roomData, currentRoom.ugcData, currentRoom.roomId, k)
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
	local playerName = GetPlayerName(playerId)
	if not hasJoin and playerName then
		currentRoom.invitations[playerId] = { nick = playerName, src = playerId }
		currentRoom.syncNextFrame = true
		TriggerClientEvent("custom_races:client:receiveInvitation", playerId, roomId, inviteId and GetPlayerName(inviteId) or "System", currentRoom.roomData.name)
	end
end

function Room.RemoveInvitation(currentRoom, playerId)
	if currentRoom.invitations[playerId] then
		currentRoom.invitations[playerId] = nil
		currentRoom.syncNextFrame = true
		TriggerClientEvent("custom_races:client:removeinvitation", playerId, currentRoom.roomId)
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
	RaceServer.PlayerInRoom[playerId] = currentRoom.roomId
	table.insert(currentRoom.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRoom.roomData.vehicle == "specific" and currentRoom.players[1] and currentRoom.players[1].vehicle or false})
	currentRoom.invitations[playerId] = nil
	currentRoom.syncNextFrame = true
	TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", playerId, currentRoom.roomData, true)
end

function Room.DenyInvitation(currentRoom, playerId)
	if currentRoom.invitations[playerId] then
		currentRoom.invitations[playerId] = nil
		currentRoom.syncNextFrame = true
	end
end

function Room.InitDriverInfos(currentRoom, playerId, playerName)
	local pos = GetEntityCoords(GetPlayerPed(tostring(playerId)))
	local x = RoundedValue(pos.x, 3)
	local y = RoundedValue(pos.y, 3)
	local z = RoundedValue(pos.z, 3)
	currentRoom.drivers[playerId] = {
		playerId = playerId,
		timeClientSide = 0,
		playerName = playerName,
		ping = 0,
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
		currentCoords = vector3(x, y, z),
		finishCoords = nil,
		dnf = false,
		spectateId = nil,
		keyboard = false
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
	RaceServer.PlayerInRoom[playerId] = currentRoom.roomId
	table.insert(currentRoom.players, {nick = playerName, src = playerId, ownerRace = false, vehicle = currentRoom.roomData.vehicle == "specific" and currentRoom.players[1] and currentRoom.players[1].vehicle or false})
	currentRoom.invitations[playerId] = nil
	currentRoom.syncNextFrame = true
	TriggerClientEvent(fromInvite and "custom_races:client:joinPlayerRoom" or "custom_races:client:joinPublicRoom", playerId, currentRoom.roomData, false)
	TriggerClientEvent("custom_races:client:loadTrack", playerId, currentRoom.roomData, currentRoom.ugcData, currentRoom.roomId, 1)
	Room.InitDriverInfos(currentRoom, playerId, playerName)
	local identifier_license = GetPlayerIdentifierByType(playerId, "license")
	local personalVehicles = nil
	if identifier_license then
		local identifier = identifier_license:gsub("license:", "")
		local results = MySQL.query.await("SELECT vehicle_mods FROM custom_race_users WHERE license = ?", {identifier})
		if results and results[1] then
			personalVehicles = json.decode(results[1].vehicle_mods)
		end
	end
	TriggerClientEvent("custom_races:client:startRaceRoom", playerId, currentRoom.predefinedVehicle, personalVehicles or {}, true)
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
	currentDriver.keyboard = data[10]
end

function Room.GetFinishedAndValidCount(currentRoom)
	local finishedCount = 0
	local validPlayerCount = 0
	local onlinePlayers = {}
	for k, v in pairs(GetPlayers()) do
		onlinePlayers[tonumber(v)] = true
	end
	for k, v in pairs(currentRoom.drivers) do
		if v.hasFinished and onlinePlayers[v.playerId] and RaceServer.PlayerInRoom[v.playerId] == currentRoom.roomId then
			finishedCount = finishedCount + 1
		end
	end
	for k, v in pairs(currentRoom.players) do
		if onlinePlayers[v.src] and RaceServer.PlayerInRoom[v.src] == currentRoom.roomId then
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
	TriggerClientEvent("custom_races:client:enableSpectatorMode", currentDriver.playerId, raceStatus)
end

function Room.UpdateRanking(currentRoom, currentDriver)
	if not currentDriver.hasCheated and currentRoom.roomData.raceid then
		local results = MySQL.query.await("SELECT besttimes FROM custom_race_list WHERE raceid = ?", {currentRoom.roomData.raceid})
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
		MySQL.update("UPDATE custom_race_list SET besttimes = ? WHERE raceid = ?", {json.encode(besttimes), currentRoom.roomData.raceid})
	end
end

function Room.LeaveRace(currentRoom, playerId, playerName)
	for k, v in pairs(currentRoom.players) do
		if v.src == playerId then
			RaceServer.PlayerInRoom[v.src] = nil
			table.remove(currentRoom.players, k)
			break
		end
	end
	for k, v in pairs(currentRoom.players) do
		TriggerClientEvent("custom_races:client:playerLeaveRace", v.src, playerName, true)
	end
	currentRoom.drivers[playerId] = nil
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
	elseif currentRoom.status == "waiting" then
		if playerId == currentRoom.ownerId then
			currentRoom.status = "invalid"
			for k, v in pairs(currentRoom.players) do
				if v.src ~= playerId then
					RaceServer.PlayerInRoom[v.src] = nil
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