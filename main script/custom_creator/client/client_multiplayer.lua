inSession = false
myServerId = 0
uniqueId = 0
lockSession = false
hasStartSyncPreview = false

modificationCount = {
	title = 0,
	thumbnail = 0,
	test_vehicle = 0,
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

function loadSessionData(data, data_2)
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
	for i = 1, #currentRace.startingGrid do
		currentRace.startingGrid[i].handle = nil
	end
	checkpointIndex = #currentRace.checkpoints
	blips.checkpoints = {}
	blips.checkpoints_2 = {}
	for k, v in pairs(currentRace.checkpoints) do
		blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	for k, v in pairs(currentRace.checkpoints_2) do
		blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	fixtureIndex = #currentRace.fixtures
	for i = 1, #currentRace.objects do
		local newObject = createProp(currentRace.objects[i].hash, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z, currentRace.objects[i].rotX, currentRace.objects[i].rotY, currentRace.objects[i].rotZ, currentRace.objects[i].color)
		if currentRace.objects[i].visible then
			ResetEntityAlpha(newObject)
		end
		if not currentRace.objects[i].collision then
			SetEntityCollision(newObject, false, false)
		end
		currentRace.objects[i].handle = newObject
	end
	objectIndex = #currentRace.objects
	blips.objects = {}
	for k, v in pairs(currentRace.objects) do
		blips.objects[k] = createBlip(v.x, v.y, v.z, 0.60, 271, 50, v.handle)
	end
	if currentRace.startingGrid[1] then
		local min, max = GetModelDimensions(tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle))
		cameraPosition = vector3(currentRace.startingGrid[1].x + (20 - min.z) * math.sin(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].y - (20 - min.z) * math.cos(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].z + (20 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.startingGrid[1].heading}
	elseif currentRace.objects[1] then
		local min, max = GetModelDimensions(tonumber(currentRace.objects[1].hash) or GetHashKey(currentRace.objects[1].hash))
		cameraPosition = vector3(currentRace.objects[1].x + (20 - min.z) * math.sin(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].y - (20 - min.z) * math.cos(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].z + (20 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.objects[1].rotZ}
	end
end

function updateStartingGrid(data)
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
			v.handle = createVeh((currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle)) or GetHashKey("bmx"), v.x, v.y, v.z, v.heading)
			ResetEntityAlpha(v.handle)
			SetEntityDrawOutlineColor(255, 255, 255, 125)
			SetEntityDrawOutlineShader(1)
			SetEntityDrawOutline(v.handle, true)
		end
	end
	if isStartingGridVehiclePickedUp then
		if not data.deleteIndex then
			if currentRace.startingGrid[startingGridVehicleIndex] then
				currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
				startingGridVehicleSelect = currentstartingGridVehicle.handle
				SetEntityDrawOutline(startingGridVehicleSelect, false)
				SetEntityAlpha(startingGridVehicleSelect, 150)
			else
				isStartingGridVehiclePickedUp = false
				startingGridVehicleSelect = nil
				currentstartingGridVehicle = {
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					heading = nil
				}
			end
		else
			if data.deleteIndex == startingGridVehicleIndex then
				isStartingGridVehiclePickedUp = false
				startingGridVehicleSelect = nil
				currentstartingGridVehicle = {
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					heading = nil
				}
			elseif data.deleteIndex > startingGridVehicleIndex then
				if currentRace.startingGrid[startingGridVehicleIndex] then
					currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex])
					startingGridVehicleSelect = currentstartingGridVehicle.handle
					SetEntityDrawOutline(startingGridVehicleSelect, false)
					SetEntityAlpha(startingGridVehicleSelect, 150)
				else
					isStartingGridVehiclePickedUp = false
					startingGridVehicleSelect = nil
					currentstartingGridVehicle = {
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
				end
			elseif data.deleteIndex < startingGridVehicleIndex then
				if currentRace.startingGrid[startingGridVehicleIndex - 1] then
					currentstartingGridVehicle = tableDeepCopy(currentRace.startingGrid[startingGridVehicleIndex - 1])
					startingGridVehicleSelect = currentstartingGridVehicle.handle
					SetEntityDrawOutline(startingGridVehicleSelect, false)
					SetEntityAlpha(startingGridVehicleSelect, 150)
					startingGridVehicleIndex = startingGridVehicleIndex - 1
				else
					isStartingGridVehiclePickedUp = false
					startingGridVehicleSelect = nil
					currentstartingGridVehicle = {
						handle = nil,
						x = nil,
						y = nil,
						z = nil,
						heading = nil
					}
				end
			end
		end
	end
	if (startingGridVehicleIndex > #currentRace.startingGrid) or (startingGridVehicleIndex == 0 and #currentRace.startingGrid > 0) then
		startingGridVehicleIndex = #currentRace.startingGrid
	end
end

function updateCheckpoints(data)
	currentRace.checkpoints = data.checkpoints
	currentRace.checkpoints_2 = data.checkpoints_2
	if isCheckpointPickedUp then
		if not data.insertIndex and not data.deleteIndex then
			if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
				currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex])
			elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
				currentCheckpoint = tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
			else
				isCheckpointPickedUp = false
			end
		elseif data.insertIndex then
			if data.insertIndex <= checkpointIndex then
				if global_var.isPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex + 1] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex + 1])
						checkpointIndex = checkpointIndex + 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex])
					else
						isCheckpointPickedUp = false
					end
				else
					if data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex + 1] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints_2[checkpointIndex + 1])
						checkpointIndex = checkpointIndex + 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
					else
						isCheckpointPickedUp = false
					end
				end
			elseif data.insertIndex > checkpointIndex then
				if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
					currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex])
				elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
					currentCheckpoint = tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				else
					isCheckpointPickedUp = false
				end
			end
		elseif data.deleteIndex then
			if data.deleteIndex == checkpointIndex then
				if global_var.isPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint then
						isCheckpointPickedUp = false
					else
						if currentRace.checkpoints[checkpointIndex] then
							currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex])
						else
							isCheckpointPickedUp = false
						end
					end
				else
					isCheckpointPickedUp = false
				end
			elseif data.deleteIndex < checkpointIndex then
				if global_var.isPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex - 1] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex - 1])
						checkpointIndex = checkpointIndex - 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints[checkpointIndex] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex])
					else
						isCheckpointPickedUp = false
					end
				else
					if data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex - 1] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints_2[checkpointIndex - 1])
						checkpointIndex = checkpointIndex - 1
					elseif not data.isPrimaryCheckpoint and currentRace.checkpoints_2[checkpointIndex] then
						currentCheckpoint = tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
					else
						isCheckpointPickedUp = false
					end
				end
			elseif data.deleteIndex > checkpointIndex then
				if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
					currentCheckpoint = tableDeepCopy(currentRace.checkpoints[checkpointIndex])
				elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
					currentCheckpoint = tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
				else
					isCheckpointPickedUp = false
				end
			end
		end
	end
	if (checkpointIndex > #currentRace.checkpoints) or (checkpointIndex == 0 and #currentRace.checkpoints > 0) then
		checkpointIndex = #currentRace.checkpoints
	end
	if not global_var.enableTest then
		updateBlips("checkpoint")
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
			updateBlips("test")
		end
	end
end

function updateFixtures(data)
	currentRace.fixtures = data.fixtures
	if (fixtureIndex > #currentRace.fixtures) or (fixtureIndex == 0 and #currentRace.fixtures > 0) then
		fixtureIndex = #currentRace.fixtures
	end
end

function updateFirework(data)
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

function sendCreatorPreview()
	if not hasStartSyncPreview then
		hasStartSyncPreview = true
		Citizen.CreateThread(function()
			while global_var.enableCreator do
				local time = 1000
				if inSession and currentRace.raceid and #multiplayer.inSessionPlayers > 1 then
					if startingGridVehiclePreview and currentstartingGridVehicle.x then
						time = 50
						local data = tableDeepCopy(currentstartingGridVehicle)
						data.playerId = myServerId
						data.preview = "startingGrid"
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, data, "creator-preview")
					elseif checkpointPreview and currentCheckpoint.x then
						time = 50
						local data = tableDeepCopy(currentCheckpoint)
						data.playerId = myServerId
						data.preview = "checkpoint"
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, data, "creator-preview")
					elseif objectPreview and currentObject.x then
						time = 50
						local data = tableDeepCopy(currentObject)
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

function receiveCreatorPreview(data)
	if not data.x then return end
	if data.preview == "startingGrid" then
		for i = 1, #multiplayer.inSessionPlayers do
			if multiplayer.inSessionPlayers[i].playerId == data.playerId then
				local old_veh = multiplayer.inSessionPlayers[i].startingGridVehiclePreview
				if old_veh and DoesEntityExist(old_veh) then
					DeleteVehicle(old_veh)
				end
				local new_veh = createVeh((currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle)) or GetHashKey("bmx"), data.x, data.y, data.z, data.heading, 0)
				SetEntityCollision(new_veh, false, false)
				multiplayer.inSessionPlayers[i].startingGridVehiclePreview = new_veh
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
		for i = 1, #multiplayer.inSessionPlayers do
			if multiplayer.inSessionPlayers[i].playerId == data.playerId then
				multiplayer.inSessionPlayers[i].checkpointPreview = data
				multiplayer.inSessionPlayers[i].receiveTime = GetGameTimer()
				break
			end
		end
	elseif data.preview == "object" then
		for i = 1, #multiplayer.inSessionPlayers do
			if multiplayer.inSessionPlayers[i].playerId == data.playerId then
				local old_obj = multiplayer.inSessionPlayers[i].objectPreview
				if old_obj and DoesEntityExist(old_obj) then
					DeleteObject(old_obj)
				end
				local new_obj = createProp(data.hash, data.x, data.y, data.z, data.rotX, data.rotY, data.rotZ, data.color)
				SetEntityCollision(new_obj, false, false)
				multiplayer.inSessionPlayers[i].objectPreview = new_obj
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
		for i = 1, #multiplayer.invitationList do
			if multiplayer.invitationList[i].sessionId == sessionId then
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
	lockSession = true
	table.insert(multiplayer.loadingPlayers, id)
	table.insert(multiplayer.inSessionPlayers, { playerId = id, playerName = playerName })
	DisplayCustomMsgs(string.format(GetTranslate("join-session"), playerName or id))
	Citizen.CreateThread(function()
		Citizen.Wait(10000)
		while lockSession do
			DisplayCustomMsgs(string.format(GetTranslate("join-session-wait"), playerName or id))
			Citizen.Wait(10000)
		end
	end)
end)

RegisterNetEvent("custom_creator:client:loadDone", function(id)
	for i = 1, #multiplayer.loadingPlayers do
		if multiplayer.loadingPlayers[i] == id then
			table.remove(multiplayer.loadingPlayers, i)
			break
		end
	end
	if #multiplayer.loadingPlayers == 0 then
		lockSession = false
	end
end)

RegisterNetEvent("custom_creator:client:playerLeaveSession", function(playerName, id)
	for i = 1, #multiplayer.loadingPlayers do
		if multiplayer.loadingPlayers[i] == id then
			table.remove(multiplayer.loadingPlayers, i)
			break
		end
	end
	if #multiplayer.loadingPlayers == 0 then
		lockSession = false
	end
	for i = 1, #multiplayer.inSessionPlayers do
		if multiplayer.inSessionPlayers[i].playerId == id then
			if multiplayer.inSessionPlayers[i].blip and DoesBlipExist(multiplayer.inSessionPlayers[i].blip) then
				RemoveBlip(multiplayer.inSessionPlayers[i].blip)
			end
			table.remove(multiplayer.inSessionPlayers, i)
			break
		end
	end
	DisplayCustomMsgs(string.format(GetTranslate("left-session"), playerName or id))
end)

RegisterNetEvent("custom_creator:client:syncData", function(data, str, playerName, rollback)
	if not global_var.enableCreator or not inSession then return end
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
			action = 'thumbnail_url',
			thumbnail_url = currentRace.thumbnail
		})
		global_var.queryingThumbnail = true
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("thumbnail-sync"), playerName))
		end
	elseif str == "test-vehicle-sync" then
		if not data.test_vehicle then return end
		modificationCount.test_vehicle = data.modificationCount
		currentRace.test_vehicle = data.test_vehicle
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("test-vehicle-sync"), playerName, data.test_vehicle))
		end
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
		currentRace.transformVehicles = data.transformVehicles
		if not isCheckpointPickedUp and currentCheckpoint.is_transform then
			local previewHash = currentRace.transformVehicles[currentCheckpoint.transform_index + 1]
			local found = false
			for k, v in pairs(currentRace.transformVehicles) do
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
		updateCheckpoints(data)
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("transformVehicles-sync"), playerName))
		end
	elseif str == "startingGrid-sync" then
		if not data.startingGrid then return end
		modificationCount.startingGrid = data.modificationCount
		updateStartingGrid(data)
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
		updateCheckpoints(data)
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
		updateFixtures(data)
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("fixtures-sync"), playerName))
		end
	elseif str == "firework-sync" then
		if not data.firework then return end
		modificationCount.firework = data.modificationCount
		updateFirework(data)
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("firework-sync"), playerName))
		end
	elseif str == "creator-preview" then
		if (type(data) ~= "table") then return end
		receiveCreatorPreview(data)
	elseif str == "objects-place" then
		if (type(data) ~= "table") then return end
		data.handle = createProp(data.hash, data.x, data.y, data.z, data.rotX, data.rotY, data.rotZ, data.color)
		if global_var.enableTest then
			if data.dynamic then
				FreezeEntityPosition(data.handle, false)
			else
				FreezeEntityPosition(data.handle, true)
			end
			if not data.visible then
				SetEntityVisible(data.handle, false)
			end
		else
			FreezeEntityPosition(data.handle, true)
			if not data.visible then
				SetEntityAlpha(data.handle, 150)
			end
		end
		if data.visible then
			ResetEntityAlpha(data.handle)
			SetEntityVisible(data.handle, true)
		end
		if data.collision then
			SetEntityCollision(data.handle, true, true)
		else
			SetEntityCollision(data.handle, false, false)
		end
		table.insert(currentRace.objects, data)
		if objectIndex == 0 and #currentRace.objects > 0 then
			objectIndex = #currentRace.objects
		end
		if not global_var.enableTest then
			updateBlips("object")
		end
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("objects-place"), playerName, data.hash, data.x, data.y, data.z))
		end
	elseif str == "objects-change" then
		if (type(data) ~= "table") then return end
		for i = 1, #currentRace.objects do
			if currentRace.objects[i].uniqueId == data.uniqueId then
				data.handle = currentRace.objects[i].handle
				currentRace.objects[i] = tableDeepCopy(data)
				if isPropPickedUp and currentObject.uniqueId == data.uniqueId then
					currentObject = tableDeepCopy(data)
				end
				SetEntityCoordsNoOffset(data.handle, data.x, data.y, data.z)
				SetEntityRotation(data.handle, data.rotX, data.rotY, data.rotZ, 2, 0)
				SetObjectTextureVariant(data.handle, data.color)
				if global_var.enableTest then
					if data.dynamic then
						FreezeEntityPosition(data.handle, false)
					else
						FreezeEntityPosition(data.handle, true)
					end
					if not data.visible then
						SetEntityVisible(data.handle, false)
					end
				else
					FreezeEntityPosition(data.handle, true)
					if not data.visible then
						SetEntityAlpha(data.handle, 150)
					end
				end
				if data.visible then
					ResetEntityAlpha(data.handle)
					SetEntityVisible(data.handle, true)
				end
				if data.collision then
					SetEntityCollision(data.handle, true, true)
				else
					SetEntityCollision(data.handle, false, false)
				end
				break
			end
		end
	elseif str == "objects-delete" then
		if (type(data) ~= "table") then return end
		for k, v in pairs(currentRace.objects) do
			if v.uniqueId == data.uniqueId then
				if playerName then
					DisplayCustomMsgs(string.format(GetTranslate("objects-delete"), playerName, k, v.hash, v.x, v.y, v.z))
				end
				DeleteObject(v.handle)
				table.remove(currentRace.objects, k)
				break
			end
		end
		if isPropPickedUp then
			if currentObject.uniqueId == data.uniqueId then
				objectSelect = nil
				isPropPickedUp = false
				currentObject = {
					uniqueId = nil,
					modificationCount = 0,
					hash = nil,
					handle = nil,
					x = nil,
					y = nil,
					z = nil,
					rotX = nil,
					rotY = nil,
					rotZ = nil,
					color = nil,
					visible = nil,
					collision = nil,
					dynamic = nil
				}
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
		if not global_var.enableTest then
			updateBlips("object")
		end
	elseif str == "template-place" then
		if (type(data) ~= "table") then return end
		for i = 1, #data do
			data[i].handle = createProp(data[i].hash, data[i].x, data[i].y, data[i].z, data[i].rotX, data[i].rotY, data[i].rotZ, data[i].color)
			if global_var.enableTest then
				if data[i].dynamic then
					FreezeEntityPosition(data[i].handle, false)
				else
					FreezeEntityPosition(data[i].handle, true)
				end
				if not data[i].visible then
					SetEntityVisible(data[i].handle, false)
				end
			else
				FreezeEntityPosition(data[i].handle, true)
				if not data[i].visible then
					SetEntityAlpha(data[i].handle, 150)
				end
			end
			if data[i].visible then
				ResetEntityAlpha(data[i].handle)
				SetEntityVisible(data[i].handle, true)
			end
			if data[i].collision then
				SetEntityCollision(data[i].handle, true, true)
			else
				SetEntityCollision(data[i].handle, false, false)
			end
			table.insert(currentRace.objects, data[i])
		end
		if not global_var.enableTest then
			updateBlips("object")
		end
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("template-place"), playerName, #data))
		end
	elseif str == "move-all" then
		if (type(data) ~= "table") then return end
		for i = 1, #currentRace.startingGrid do
			currentRace.startingGrid[i].x = RoundedValue(currentRace.startingGrid[i].x + data.offset_x, 3)
			currentRace.startingGrid[i].y = RoundedValue(currentRace.startingGrid[i].y + data.offset_y, 3)
			currentRace.startingGrid[i].z = RoundedValue(currentRace.startingGrid[i].z + data.offset_z, 3)
		end
		for i = 1, #currentRace.checkpoints do
			currentRace.checkpoints[i].x = RoundedValue(currentRace.checkpoints[i].x + data.offset_x, 3)
			currentRace.checkpoints[i].y = RoundedValue(currentRace.checkpoints[i].y + data.offset_y, 3)
			currentRace.checkpoints[i].z = RoundedValue(currentRace.checkpoints[i].z + data.offset_z, 3)
			if currentRace.checkpoints_2[i] then
				currentRace.checkpoints_2[i].x = RoundedValue(currentRace.checkpoints_2[i].x + data.offset_x, 3)
				currentRace.checkpoints_2[i].y = RoundedValue(currentRace.checkpoints_2[i].y + data.offset_y, 3)
				currentRace.checkpoints_2[i].z = RoundedValue(currentRace.checkpoints_2[i].z + data.offset_z, 3)
			end
		end
		for i = 1, #currentRace.objects do
			currentRace.objects[i].x = RoundedValue(currentRace.objects[i].x + data.offset_x, 3)
			currentRace.objects[i].y = RoundedValue(currentRace.objects[i].y + data.offset_y, 3)
			currentRace.objects[i].z = RoundedValue(currentRace.objects[i].z + data.offset_z, 3)
			if currentRace.objects[i].uniqueId == currentObject.uniqueId then
				currentObject = tableDeepCopy(currentRace.objects[i])
			end
			SetEntityCoordsNoOffset(currentRace.objects[i].handle, currentRace.objects[i].x, currentRace.objects[i].y, currentRace.objects[i].z)
		end
		if not global_var.enableTest then
			updateBlips("checkpoint")
			updateBlips("object")
		else
			if global_var.tipsRendered then
				updateBlips("test")
			end
		end
		if playerName then
			DisplayCustomMsgs(string.format(GetTranslate("move-all"), playerName, data.offset_x, data.offset_y, data.offset_z))
		end
	end
end)