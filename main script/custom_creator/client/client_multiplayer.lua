inSession = false
myServerId = 0
globalUniqueId = 0
lockSession = false
hasStartSyncPreview = false

modificationCount = {
	title = 0,
	thumbnail = 0,
	test_vehicle = 0,
	available_vehicles = 0,
	blimp_text = 0,
	transformVehicles = 0,
	startingGrid = 0,
	checkpoints = 0,
	fixtures = 0,
	firework = 0
}

multiplayer = {
	loadingPlayers = {},
	availablePlayers = {},
	invitationList = {},
	inSessionPlayers = {}
}

function LoadSessionData(data, data_2)
	objectPool.isRefreshing = true
	DisplayBusyspinner("parse", 10000, #data.objects + 10000)
	for classid = 0, 27 do
		for i = 1, #data.available_vehicles[classid].vehicles do
			data.available_vehicles[classid].vehicles[i].name = GetLabelText(GetDisplayNameFromVehicleModel(data.available_vehicles[classid].vehicles[i].hash))
		end
	end
	currentRace = data
	modificationCount = data_2
	SetScrollTextOnBlimp(currentRace.blimp_text)
	particleIndex = 1
	for i = 1, #particles do
		if particles[i] == currentRace.firework.name then
			particleIndex = i
			break
		end
	end
	startingGridVehicleIndex = #currentRace.startingGrid
	for k, v in pairs(currentRace.startingGrid) do
		v.handle = nil
	end
	checkpointIndex = #currentRace.checkpoints
	blips.checkpoints = {}
	blips.checkpoints_2 = {}
	for k, v in pairs(currentRace.checkpoints) do
		blips.checkpoints[k] = CreateBlipForCreator(v.x, v.y, v.z, 0.9, (v.is_random and 66) or (v.is_transform and 570) or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	for k, v in pairs(currentRace.checkpoints_2) do
		blips.checkpoints_2[k] = CreateBlipForCreator(v.x, v.y, v.z, 0.9, (v.is_random and 66) or (v.is_transform and 570) or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	fixtureIndex = #currentRace.fixtures
	Citizen.Wait(1000)
	local count = 0
	for k, v in pairs(currentRace.objects) do
		v.handle = nil
		local gx = math.floor(v.x / 100.0)
		local gy = math.floor(v.y / 100.0)
		objectPool.grids[gx] = objectPool.grids[gx] or {}
		objectPool.grids[gx][gy] = objectPool.grids[gx][gy] or {}
		objectPool.grids[gx][gy][v.uniqueId] = v
		objectPool.all[v.uniqueId] = gx .. "-" .. gy
		if effectObjects[v.hash] then
			objectPool.effects[v.uniqueId] = {ptfxHandle = nil, object = v, style = effectObjects[v.hash]}
		end
		count = count + 1
		if count >= 10000 then
			count = 0
			Citizen.Wait(1000)
		end
	end
	objectIndex = #currentRace.objects
	objectPool.isRefreshing = false
	if currentRace.startingGrid[1] then
		local default_vehicle = currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] and currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index] and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].model or currentRace.test_vehicle
		local model = tonumber(default_vehicle) or GetHashKey(default_vehicle)
		local min, max = GetModelDimensionsInCaches(model)
		cameraPosition = vector3(currentRace.startingGrid[1].x + (20.0 - min.z) * math.sin(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].y - (20.0 - min.z) * math.cos(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].z + (20.0 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.startingGrid[1].heading}
	elseif currentRace.objects[1] then
		local model = tonumber(currentRace.objects[1].hash) or GetHashKey(currentRace.objects[1].hash)
		local min, max = GetModelDimensionsInCaches(model)
		cameraPosition = vector3(currentRace.objects[1].x + (20.0 - min.z) * math.sin(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].y - (20.0 - min.z) * math.cos(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].z + (20.0 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.objects[1].rotZ}
	end
end

function UpdateStartingGrid(data)
	if isStartingGridMenuVisible then
		for k, v in pairs(currentRace.startingGrid) do
			if v.handle then
				DeleteVehicle(v.handle)
			end
		end
	end
	currentRace.startingGrid = data.startingGrid
	if isStartingGridMenuVisible then
		for k, v in pairs(currentRace.startingGrid) do
			local default_vehicle = currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] and currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index] and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].model or currentRace.test_vehicle
			local model = tonumber(default_vehicle) or GetHashKey(default_vehicle)
			v.handle = CreateGridVehicleForCreator(model, v.x, v.y, v.z, v.heading)
			ResetEntityAlpha(v.handle)
			SetEntityDrawOutlineColor(255, 255, 255, 125)
			SetEntityDrawOutlineShader(1)
			SetEntityDrawOutline(v.handle, true)
		end
	end
	if isStartingGridVehiclePickedUp then
		if not data.deleteIndex then
			if currentRace.startingGrid[startingGridVehicleIndex] then
				currentStartingGridVehicle = TableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				startingGridVehicleSelect = currentStartingGridVehicle.handle
				SetEntityDrawOutline(startingGridVehicleSelect, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
			else
				isStartingGridVehiclePickedUp = false
				startingGridVehicleSelect = nil
				ResetGlobalVariable("currentStartingGridVehicle")
			end
		else
			if data.deleteIndex == startingGridVehicleIndex then
				isStartingGridVehiclePickedUp = false
				startingGridVehicleSelect = nil
				ResetGlobalVariable("currentStartingGridVehicle")
			elseif data.deleteIndex > startingGridVehicleIndex then
				if currentRace.startingGrid[startingGridVehicleIndex] then
					currentStartingGridVehicle = TableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
					startingGridVehicleSelect = currentStartingGridVehicle.handle
					SetEntityDrawOutline(startingGridVehicleSelect, false)
					SetEntityAlpha(startingGridVehicleSelect, 150)
				else
					isStartingGridVehiclePickedUp = false
					startingGridVehicleSelect = nil
					ResetGlobalVariable("currentStartingGridVehicle")
				end
			elseif data.deleteIndex < startingGridVehicleIndex then
				if currentRace.startingGrid[startingGridVehicleIndex - 1] then
					currentStartingGridVehicle = TableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex - 1])
					startingGridVehicleSelect = currentStartingGridVehicle.handle
					SetEntityDrawOutline(startingGridVehicleSelect, false)
					SetEntityAlpha(startingGridVehicleSelect, 150)
					startingGridVehicleIndex = startingGridVehicleIndex - 1
				else
					isStartingGridVehiclePickedUp = false
					startingGridVehicleSelect = nil
					ResetGlobalVariable("currentStartingGridVehicle")
				end
			end
		end
	end
	if (startingGridVehicleIndex > #currentRace.startingGrid) or (startingGridVehicleIndex == 0 and #currentRace.startingGrid > 0) then
		startingGridVehicleIndex = #currentRace.startingGrid
	end
end

function UpdateCheckpoints(data)
	currentRace.checkpoints = data.checkpoints
	currentRace.checkpoints_2 = data.checkpoints_2
	if isCheckpointPickedUp then
		if not data.insertIndex and not data.deleteIndex then
			if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
				currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex])
			elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
				currentCheckpoint = TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
			else
				isCheckpointPickedUp = false
				ResetGlobalVariable("currentCheckpoint")
			end
		elseif data.insertIndex then
			if data.insertIndex <= checkpointIndex then
				if global_var.isPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex + 1] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex + 1])
						checkpointIndex = checkpointIndex + 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex])
					else
						isCheckpointPickedUp = false
						ResetGlobalVariable("currentCheckpoint")
					end
				else
					if data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex + 1] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints_2[checkpointIndex + 1])
						checkpointIndex = checkpointIndex + 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
					else
						isCheckpointPickedUp = false
						ResetGlobalVariable("currentCheckpoint")
					end
				end
			elseif data.insertIndex > checkpointIndex then
				if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
					currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex])
				elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
					currentCheckpoint = TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				else
					isCheckpointPickedUp = false
					ResetGlobalVariable("currentCheckpoint")
				end
			end
		elseif data.deleteIndex then
			if data.deleteIndex == checkpointIndex then
				if global_var.isPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint then
						isCheckpointPickedUp = false
						ResetGlobalVariable("currentCheckpoint")
					else
						if currentRace.checkpoints[checkpointIndex] then
							currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex])
						else
							isCheckpointPickedUp = false
							ResetGlobalVariable("currentCheckpoint")
						end
					end
				else
					isCheckpointPickedUp = false
					ResetGlobalVariable("currentCheckpoint")
				end
			elseif data.deleteIndex < checkpointIndex then
				if global_var.isPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex - 1] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex - 1])
						checkpointIndex = checkpointIndex - 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex])
					else
						isCheckpointPickedUp = false
						ResetGlobalVariable("currentCheckpoint")
					end
				else
					if data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex - 1] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints_2[checkpointIndex - 1])
						checkpointIndex = checkpointIndex - 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex] then
						currentCheckpoint = TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
					else
						isCheckpointPickedUp = false
						ResetGlobalVariable("currentCheckpoint")
					end
				end
			elseif data.deleteIndex > checkpointIndex then
				if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
					currentCheckpoint = TableDeepCopy(currentRace.checkpoints[checkpointIndex])
				elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
					currentCheckpoint = TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				else
					isCheckpointPickedUp = false
					ResetGlobalVariable("currentCheckpoint")
				end
			end
		end
	end
	if (checkpointIndex > #currentRace.checkpoints) or (checkpointIndex == 0 and #currentRace.checkpoints > 0) then
		checkpointIndex = #currentRace.checkpoints
	end
	if not global_var.enableTest then
		UpdateBlipForCreator("checkpoint")
	else
		if global_var.respawnData then
			if data.insertIndex then
				if data.insertIndex <= global_var.respawnData.checkpointIndex then
					global_var.respawnData.checkpointIndex = ((global_var.respawnData.checkpointIndex + 1) <= #currentRace.checkpoints) and (global_var.respawnData.checkpointIndex + 1) or #currentRace.checkpoints
				end
				if data.insertIndex < global_var.respawnData.checkpointIndex_draw then
					global_var.respawnData.checkpointIndex_draw = ((global_var.respawnData.checkpointIndex_draw + 1) <= #currentRace.checkpoints) and (global_var.respawnData.checkpointIndex_draw + 1) or #currentRace.checkpoints
				end
			elseif data.deleteIndex then
				if data.deleteIndex <= global_var.respawnData.checkpointIndex then
					global_var.respawnData.checkpointIndex = ((global_var.respawnData.checkpointIndex - 1) >= 0) and (global_var.respawnData.checkpointIndex - 1) or 0
				end
				if data.deleteIndex < global_var.respawnData.checkpointIndex_draw then
					global_var.respawnData.checkpointIndex_draw = ((global_var.respawnData.checkpointIndex_draw - 1) >= 1) and (global_var.respawnData.checkpointIndex_draw - 1) or 1
				end
			end
		end
		if global_var.tipsRendered then
			ResetCheckpointAndBlipForTest()
			global_var.testData.checkpoints = TableDeepCopy(currentRace.checkpoints) or {}
			global_var.testData.checkpoints_2 = TableDeepCopy(currentRace.checkpoints_2) or {}
			CreateBlipForTest(global_var.respawnData.checkpointIndex_draw)
			CreateCheckpointForTest(global_var.respawnData.checkpointIndex_draw, false)
			CreateCheckpointForTest(global_var.respawnData.checkpointIndex_draw, true)
		end
	end
end

function UpdateFixtures(data)
	currentRace.fixtures = data.fixtures
	if (fixtureIndex > #currentRace.fixtures) or (fixtureIndex == 0 and #currentRace.fixtures > 0) then
		fixtureIndex = #currentRace.fixtures
	end
end

function UpdateFirework(data)
	currentRace.firework.name = data.firework.name or "scr_indep_firework_trailburst"
	currentRace.firework.r = data.firework.r or 255
	currentRace.firework.g = data.firework.g or 255
	currentRace.firework.b = data.firework.b or 255
	for i = 1, #particles do
		if particles[i] == currentRace.firework.name then
			particleIndex = i
			break
		end
	end
end

function SendCreatorPreview()
	if not hasStartSyncPreview then
		hasStartSyncPreview = true
		Citizen.CreateThread(function()
			while global_var.enableCreator do
				local time = 1000
				if inSession and currentRace.raceid and #multiplayer.inSessionPlayers > 1 then
					if startingGridVehiclePreview and currentStartingGridVehicle.x then
						time = 50
						local data = TableDeepCopy(currentStartingGridVehicle)
						data.playerId = myServerId
						data.preview = "startingGrid"
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, data, "creator-preview")
					elseif checkpointPreview and currentCheckpoint.x then
						time = 50
						local data = TableDeepCopy(currentCheckpoint)
						data.playerId = myServerId
						data.preview = "checkpoint"
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, data, "creator-preview")
					elseif objectPreview and currentObject.x then
						time = 50
						local data = TableDeepCopy(currentObject)
						data.playerId = myServerId
						data.preview = "object"
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, data, "creator-preview")
					else
						time = 200
					end
				end
				Citizen.Wait(time)
			end
			hasStartSyncPreview = false
		end)
	end
end

function ReceiveCreatorPreview(data)
	if not data.x then return end
	if data.preview == "startingGrid" then
		for k, v in pairs(multiplayer.inSessionPlayers) do
			if v.playerId == data.playerId then
				local old_veh = v.startingGridVehiclePreview
				if old_veh and DoesEntityExist(old_veh) then
					DeleteVehicle(old_veh)
				end
				local default_vehicle = currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] and currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index] and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].model or currentRace.test_vehicle
				local model = tonumber(default_vehicle) or GetHashKey(default_vehicle)
				local new_veh = CreateGridVehicleForCreator(model, data.x, data.y, data.z, data.heading, 0)
				SetEntityCollision(new_veh, false, false)
				v.startingGridVehiclePreview = new_veh
				Citizen.CreateThread(function()
					Citizen.Wait(300)
					if new_veh and DoesEntityExist(new_veh) then
						DeleteVehicle(new_veh)
					end
				end)
				break
			end
		end
	elseif data.preview == "checkpoint" then
		for k, v in pairs(multiplayer.inSessionPlayers) do
			if v.playerId == data.playerId then
				v.checkpointPreview = data
				v.receiveTime = GetGameTimer()
				break
			end
		end
	elseif data.preview == "object" then
		for k, v in pairs(multiplayer.inSessionPlayers) do
			if v.playerId == data.playerId then
				local old_obj = v.objectPreview
				if old_obj and DoesEntityExist(old_obj) then
					DeleteObject(old_obj)
				end
				local new_obj = CreatePropForCreator(data.hash, data.x, data.y, data.z, data.rotX, data.rotY, data.rotZ, data.color)
				SetEntityAlpha(new_obj, 150)
				SetEntityLodDist(new_obj, 16960)
				SetEntityCollision(new_obj, false, false)
				FreezeEntityPosition(new_obj, true)
				v.objectPreview = new_obj
				Citizen.CreateThread(function()
					Citizen.Wait(300)
					if new_obj and DoesEntityExist(new_obj) then
						DeleteObject(new_obj)
					end
				end)
				break
			end
		end
	end
end

RegisterNetEvent("custom_creator:client:receiveInvitation", function(title, sessionId, playerName)
	if title and sessionId and playerName then
		local found = false
		for k, v in pairs(multiplayer.invitationList) do
			if v.sessionId == sessionId then
				found = true
				break
			end
		end
		if not found then
			table.insert(multiplayer.invitationList, {title = title, sessionId = sessionId})
		end
		DisplayCustomMsgs(string.format(GetTranslate("receive-invitation", GetCurrentLanguage()), playerName, title))
	end
end)

RegisterNetEvent("custom_creator:client:playerJoinSession", function(playerName, id)
	if not global_var.enableCreator then return end
	lockSession = true
	table.insert(multiplayer.loadingPlayers, id)
	table.insert(multiplayer.inSessionPlayers, { playerId = id, playerName = playerName })
	DisplayCustomMsgs(string.format(GetTranslate("join-session"), playerName or id))
	Citizen.CreateThread(function()
		Citizen.Wait(10000)
		while lockSession do
			if not busyspinner.status then
				DisplayCustomMsgs(string.format(GetTranslate("join-session-wait"), playerName or id))
			end
			Citizen.Wait(10000)
		end
	end)
end)

RegisterNetEvent("custom_creator:client:loadDone", function(id)
	if not global_var.enableCreator then return end
	for k, v in pairs(multiplayer.loadingPlayers) do
		if v == id then
			table.remove(multiplayer.loadingPlayers, k)
			break
		end
	end
	if #multiplayer.loadingPlayers == 0 then
		lockSession = false
	end
end)

RegisterNetEvent("custom_creator:client:playerLeaveSession", function(playerName, id)
	if not global_var.enableCreator then return end
	for k, v in pairs(multiplayer.loadingPlayers) do
		if v == id then
			table.remove(multiplayer.loadingPlayers, k)
			break
		end
	end
	if #multiplayer.loadingPlayers == 0 then
		lockSession = false
	end
	for k, v in pairs(multiplayer.inSessionPlayers) do
		if v.playerId == id then
			table.remove(multiplayer.inSessionPlayers, k)
			break
		end
	end
	DisplayCustomMsgs(string.format(GetTranslate("left-session"), playerName or id))
end)

RegisterNetEvent("custom_creator:client:syncData", function(data, str, playerName, rollback)
	if not global_var.enableCreator or not inSession then return end
	while global_var.quitingTest or global_var.joiningTest or objectPool.isRefreshing do Citizen.Wait(0) end
	if rollback then
		DisplayCustomMsgs(GetTranslate("session-data-rollback"))
	end
	if str == "published-status" then
		if not data.published then return end
		currentRace.published = data.published == "√"
		if playerName and data.action then
			if data.action == "publish" then
				DisplayCustomMsgs(string.format(GetTranslate("published-status-publish"), playerName))
			elseif data.action == "update" then
				DisplayCustomMsgs(string.format(GetTranslate("published-status-update"), playerName))
			elseif data.action == "save" then
				DisplayCustomMsgs(string.format(GetTranslate("published-status-save"), playerName))
			elseif data.action == "cancel" then
				DisplayCustomMsgs(string.format(GetTranslate("published-status-cancel"), playerName))
			elseif data.action == "export" then
				DisplayCustomMsgs(string.format(GetTranslate("published-status-export"), playerName))
			end
			if not (currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] and currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index]) then
				local hash = tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle)
				if not IsModelInCdimage(hash) or not IsModelValid(hash) or not IsModelAVehicle(hash) then
					currentRace.available_vehicles[13].vehicles[1].enabled = true
					currentRace.available_vehicles[13].index = 1
					currentRace.default_class = 13
				else
					local found = false
					for classid = 0, 27 do
						for i = 1, #currentRace.available_vehicles[classid].vehicles do
							if currentRace.available_vehicles[classid].vehicles[i].hash == hash then
								currentRace.available_vehicles[classid].vehicles[i].enabled = true
								currentRace.available_vehicles[classid].index = i
								currentRace.default_class = classid
								found = true
								break
							end
						end
						if found then break end
					end
					if not found then
						currentRace.default_class = nil
					end
				end
			end
		end
	elseif str == "title-sync" then
		if not data.title then return end
		modificationCount.title = data.modificationCount
		currentRace.title = data.title
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("title-sync"), playerName, data.title))
		end
	elseif str == "thumbnail-sync" then
		if not data.thumbnail then return end
		modificationCount.thumbnail = data.modificationCount
		currentRace.thumbnail = data.thumbnail
		SendNUIMessage({
			action = "thumbnail_url",
			thumbnail_url = currentRace.thumbnail
		})
		global_var.queryingThumbnail = true
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("thumbnail-sync"), playerName))
		end
	elseif str == "test-vehicle-sync" then
		if not data.test_vehicle then return end
		modificationCount.test_vehicle = data.modificationCount
		local hash = tonumber(data.test_vehicle) or GetHashKey(data.test_vehicle)
		local found = false
		for classid = 0, 27 do
			for i = 1, #currentRace.available_vehicles[classid].vehicles do
				if currentRace.available_vehicles[classid].vehicles[i].hash == hash then
					currentRace.available_vehicles[classid].vehicles[i].enabled = true
					currentRace.available_vehicles[classid].index = i
					currentRace.default_class = classid
					found = true
					break
				end
			end
			if found then break end
		end
		if not found then
			currentRace.default_class = nil
		end
		currentRace.test_vehicle = data.test_vehicle
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("test-vehicle-sync"), playerName, GetLabelText(GetDisplayNameFromVehicleModel(hash))))
		end
	elseif str == "available-vehicles-sync" then
		if not data.available_vehicles then return end
		modificationCount.available_vehicles = data.modificationCount
		currentRace.default_class = data.default_class
		for classid = 0, 27 do
			for i = 1, #data.available_vehicles[classid].vehicles do
				data.available_vehicles[classid].vehicles[i].name = GetLabelText(GetDisplayNameFromVehicleModel(data.available_vehicles[classid].vehicles[i].hash))
			end
		end
		currentRace.available_vehicles = data.available_vehicles
	elseif str == "blimp-text-sync" then
		if not data.blimp_text then return end
		modificationCount.blimp_text = data.modificationCount
		currentRace.blimp_text = data.blimp_text
		SetScrollTextOnBlimp(currentRace.blimp_text)
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("blimp-text-sync"), playerName, data.blimp_text))
		end
	elseif str == "transformVehicles-sync" then
		if not data.transformVehicles then return end
		modificationCount.transformVehicles = data.modificationCount
		if not isCheckpointPickedUp and currentCheckpoint.is_transform then
			local previewHash = currentRace.transformVehicles[currentCheckpoint.transform_index + 1]
			local found = false
			for k, v in pairs(data.transformVehicles) do
				if v == previewHash then
					currentCheckpoint.transform_index = k - 1
					found = true
					break
				end
			end
			if not found then
				currentCheckpoint.transform_index = 0
			end
		end
		currentRace.transformVehicles = data.transformVehicles
		UpdateCheckpoints(data)
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("transformVehicles-sync"), playerName))
		end
	elseif str == "startingGrid-sync" then
		if not data.startingGrid then return end
		modificationCount.startingGrid = data.modificationCount
		UpdateStartingGrid(data)
		if playerName then
			if data.insertIndex then
				DisplayCustomMsgs(string.format(GetTranslate("startingGrid-insert"), playerName, data.insertIndex))
			elseif data.deleteIndex then
				DisplayCustomMsgs(string.format(GetTranslate("startingGrid-delete"), playerName, data.deleteIndex))
			end
		end
	elseif str == "checkpoints-sync" then
		if not data.checkpoints then return end
		modificationCount.checkpoints = data.modificationCount
		UpdateCheckpoints(data)
		if playerName then
			if data.insertIndex then
				if data.isPrimaryCheckpoint then
					DisplayCustomMsgs(string.format(GetTranslate("checkpoints-insert-primary"), playerName, data.insertIndex))
				else
					DisplayCustomMsgs(string.format(GetTranslate("checkpoints-insert-secondary"), playerName, data.insertIndex))
				end
			elseif data.deleteIndex then
				if data.isPrimaryCheckpoint then
					DisplayCustomMsgs(string.format(GetTranslate("checkpoints-delete-primary"), playerName, data.deleteIndex))
				else
					DisplayCustomMsgs(string.format(GetTranslate("checkpoints-delete-secondary"), playerName, data.deleteIndex))
				end
			end
		end
	elseif str == "fixtures-sync" then
		if not data.fixtures then return end
		modificationCount.fixtures = data.modificationCount
		UpdateFixtures(data)
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("fixtures-sync"), playerName))
		end
	elseif str == "firework-sync" then
		if not data.firework then return end
		modificationCount.firework = data.modificationCount
		UpdateFirework(data)
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("firework-sync"), playerName))
		end
	elseif str == "creator-preview" then
		if (type(data) ~= "table") then return end
		ReceiveCreatorPreview(data)
	elseif str == "objects-place" then
		if (type(data) ~= "table") then return end
		local object = data
		object.handle = nil
		local gx = math.floor(object.x / 100.0)
		local gy = math.floor(object.y / 100.0)
		objectPool.grids[gx] = objectPool.grids[gx] or {}
		objectPool.grids[gx][gy] = objectPool.grids[gx][gy] or {}
		objectPool.grids[gx][gy][object.uniqueId] = object
		objectPool.all[object.uniqueId] = gx .. "-" .. gy
		if effectObjects[object.hash] then
			objectPool.effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = effectObjects[object.hash]}
		end
		currentRace.objects[#currentRace.objects + 1] = object
		if objectIndex == 0 and #currentRace.objects > 0 then
			objectIndex = #currentRace.objects
		end
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("objects-place"), playerName, data.hash, data.x, data.y, data.z))
		end
	elseif str == "objects-change" then
		if (type(data) ~= "table") then return end
		for k, v in pairs(currentRace.objects) do
			if v.uniqueId == data.uniqueId then
				local x = v.x
				local y = v.y
				v.modificationCount = data.modificationCount
				v.hash = data.hash
				v.x = data.x
				v.y = data.y
				v.z = data.z
				v.rotX = data.rotX
				v.rotY = data.rotY
				v.rotZ = data.rotZ
				v.color = data.color
				v.prpsba = data.prpsba
				v.visible = data.visible
				v.collision = data.collision
				v.dynamic = data.dynamic
				objectPool.changedObjects[v.uniqueId] = true
				RefreshGirdForObject(x, y, v)
				break
			end
		end
	elseif str == "objects-delete" then
		if (type(data) ~= "table") or not data.uniqueId then return end
		for k, v in pairs(currentRace.objects) do
			if v.uniqueId == data.uniqueId then
				if playerName then
					DisplayCustomMsgs(string.format(GetTranslate("objects-delete"), playerName, k, v.hash, v.x, v.y, v.z))
				end
				table.remove(currentRace.objects, k)
				break
			end
		end
		objectPool.all[data.uniqueId] = nil
		objectPool.effects[data.uniqueId] = nil
		for uniqueId, effectData in pairs(objectPool.activeEffects) do
			if uniqueId == data.uniqueId then
				if effectData.ptfxHandle then
					StopParticleFxLooped(effectData.ptfxHandle, true)
					effectData.ptfxHandle = nil
				end
				objectPool.activeEffects[uniqueId] = nil
				break
			end
		end
		for uniqueId, object in pairs(objectPool.activeObjects) do
			if uniqueId == data.uniqueId then
				if object.handle then
					DeleteObject(object.handle)
					object.handle = nil
				end
				objectPool.activeObjects[uniqueId] = nil
				break
			end
		end
		local gx = math.floor(data.x / 100.0)
		local gy = math.floor(data.y / 100.0)
		if objectPool.grids[gx] and objectPool.grids[gx][gy] then
			objectPool.grids[gx][gy][data.uniqueId] = nil
		end
		if isPropPickedUp then
			if currentObject.uniqueId == data.uniqueId then
				isPropPickedUp = false
				ResetGlobalVariable("currentObject")
			else
				for k, v in pairs(currentRace.objects) do
					if v.uniqueId == currentObject.uniqueId then
						objectIndex = k
						break
					end
				end
			end
		end
		if objectIndex > #currentRace.objects then
			objectIndex = #currentRace.objects
		end
	elseif str == "template-place" then
		if (type(data) ~= "table") then return end
		for i = 1, #data do
			local object = data[i]
			object.handle = nil
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			objectPool.grids[gx] = objectPool.grids[gx] or {}
			objectPool.grids[gx][gy] = objectPool.grids[gx][gy] or {}
			objectPool.grids[gx][gy][object.uniqueId] = object
			objectPool.all[object.uniqueId] = gx .. "-" .. gy
			if effectObjects[object.hash] then
				objectPool.effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = effectObjects[object.hash]}
			end
			currentRace.objects[#currentRace.objects + 1] = object
		end
		if objectIndex == 0 and #currentRace.objects > 0 then
			objectIndex = #currentRace.objects
		end
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("template-place"), playerName, #data))
		end
	elseif str == "move-all" then
		if (type(data) ~= "table") then return end
		for k, v in pairs(currentRace.startingGrid) do
			v.x = RoundedValue(v.x + data.offset_x, 3)
			v.y = RoundedValue(v.y + data.offset_y, 3)
			v.z = RoundedValue(v.z + data.offset_z, 3)
		end
		currentStartingGridVehicle = isStartingGridVehiclePickedUp and TableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex]) or currentStartingGridVehicle
		for k, v in pairs(currentRace.checkpoints) do
			v.x = RoundedValue(v.x + data.offset_x, 3)
			v.y = RoundedValue(v.y + data.offset_y, 3)
			v.z = RoundedValue(v.z + data.offset_z, 3)
			local v_2 = currentRace.checkpoints_2[k]
			if v_2 then
				v_2.x = RoundedValue(v_2.x + data.offset_x, 3)
				v_2.y = RoundedValue(v_2.y + data.offset_y, 3)
				v_2.z = RoundedValue(v_2.z + data.offset_z, 3)
			end
		end
		currentCheckpoint = isCheckpointPickedUp and (global_var.isPrimaryCheckpointItems and TableDeepCopy(currentRace.checkpoints[checkpointIndex]) or TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])) or currentCheckpoint
		for k, v in pairs(currentRace.objects) do
			v.x = RoundedValue(v.x + data.offset_x, 3)
			v.y = RoundedValue(v.y + data.offset_y, 3)
			v.z = RoundedValue(v.z + data.offset_z, 3)
			objectPool.changedObjects[v.uniqueId] = true
		end
		if not global_var.enableTest then
			UpdateBlipForCreator("checkpoint")
		else
			if global_var.tipsRendered then
				ResetCheckpointAndBlipForTest()
				global_var.testData.checkpoints = TableDeepCopy(currentRace.checkpoints) or {}
				global_var.testData.checkpoints_2 = TableDeepCopy(currentRace.checkpoints_2) or {}
				CreateBlipForTest(global_var.respawnData.checkpointIndex_draw)
				CreateCheckpointForTest(global_var.respawnData.checkpointIndex_draw, false)
				CreateCheckpointForTest(global_var.respawnData.checkpointIndex_draw, true)
			end
		end
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("move-all"), playerName, data.offset_x, data.offset_y, data.offset_z))
		end
	end
end)