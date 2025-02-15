AddEventHandler('custom_races:loadrace', function()
	isInRace = true
end)

AddEventHandler('custom_races:unloadrace', function()
	isInRace = false
end)

RegisterNetEvent("custom_creator:info", function(str, attempt)
	if str == "ugc-wait" then
		DisplayCustomMsgs(string.format(GetTranslate("ugc-wait"), attempt))
	end
end)

RegisterNUICallback('urlValid', function(data, cb)
	global_var.thumbnailValid = true
end)

RegisterNUICallback('urlError', function(data, cb)
	global_var.thumbnailValid = false
	DisplayCustomMsgs(GetTranslate("thumbnail-error"))
end)

RegisterNUICallback('previewUrlValid', function(data, cb)
	global_var.showPreviewThumbnail = true
end)

RegisterNUICallback('custom_creator:submit', function(data, cb)
	if nuiCallBack == "" then
		return
	else
		SetNuiFocus(false, false)
	end
	if nuiCallBack == "race title" then
		local title = data.text:gsub("[\\/:\"*?<>|]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		if strinCount(title) > 20 then
			DisplayCustomMsgs(GetTranslate("title-limit"))
		elseif strinCount(title) > 0 then
			if title == "unknown" then
				DisplayCustomMsgs(GetTranslate("title-exist"))
			else
				global_var.lock = true
				TriggerServerCallback('custom_creator:server:check_title', function(bool)
					if bool then
						currentRace.title = title
					else
						DisplayCustomMsgs(GetTranslate("title-exist"))
					end
					global_var.lock = false
				end, title)
			end
		else
			DisplayCustomMsgs(GetTranslate("title-error"))
		end
	elseif nuiCallBack == "import ugc" then
		local url = data.text
		if string.find(url, "https://prod.cloud.rockstargames.com/ugc/gta5mission/") and string.find(url, "jpg") then
			global_var.lock = true
			global_var.querying = true
			TriggerServerCallback('custom_creator:server:get_ugc', function(data)
				if data then
					convertJsonData(data)
					global_var.previewThumbnail = ""
					global_var.showPreviewThumbnail = false
					global_var.thumbnailValid = false
					SendNUIMessage({
						action = 'thumbnail_off'
					})
					SendNUIMessage({
						action = 'thumbnail_url',
						thumbnail_url = currentRace.thumbnail
					})
					DisplayCustomMsgs(GetTranslate("load-success"))
				else
					DisplayCustomMsgs(GetTranslate("ugc-not-exist"))
				end
				while global_var.lock_2 do Citizen.Wait(0) end
				global_var.lock = false
				global_var.querying = false
			end, url)
		else
			DisplayCustomMsgs(GetTranslate("url-error"))
		end
	elseif nuiCallBack == "race thumbnail" then
		if #data.text > 0 then
			currentRace.thumbnail = data.text
			SendNUIMessage({
				action = 'thumbnail_url',
				thumbnail_url = currentRace.thumbnail
			})
			global_var.thumbnailValid = false
		else
			DisplayCustomMsgs(GetTranslate("url-error"))
		end
	elseif nuiCallBack == "test vehicle" then
		local text = data.text
		local hash = tonumber(text) or GetHashKey(text)
		if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
			currentRace.test_vehicle = tonumber(text) or text
		else
			DisplayCustomMsgs(string.format(GetTranslate("vehicle-hash-null"), text))
		end
	elseif nuiCallBack == "prop hash" then
		lastValidText = data.text
		local hash = tonumber(lastValidText) or GetHashKey(lastValidText)
		if IsModelInCdimage(hash) and IsModelValid(hash) then
			lastValidHash = hash
			global_var.propZposLock = nil
			global_var.propColor = nil
		else
			lastValidHash = nil
			DisplayCustomMsgs(string.format(GetTranslate("object-hash-null"), data.text))
		end
	elseif nuiCallBack == "checkpoint transform vehicles" then
		local str = string.gsub(data.text, "%s+", "")
		local result = {}
		for value in string.gmatch(str, "([^,]+)") do
			if tonumber(value) == 0 then
				table.insert(result, tonumber(value))
			else
				local hash = tonumber(value) or GetHashKey(value)
				if hash and ((IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash)) or (tonumber(value) and (hash == -422877666) or (hash == -731262150))) then
					table.insert(result, tonumber(value) or value)
				end
			end
		end
		local previewHash = currentCheckpoint.is_transform and currentRace.transformVehicles[currentCheckpoint.transform_index + 1] or false
		local vehicles = {}
		local vehicles_2 = {}
		if #currentRace.checkpoints > 0 then
			for i = 1, #currentRace.checkpoints do
				vehicles[i] = currentRace.checkpoints[i].is_transform and currentRace.transformVehicles[currentRace.checkpoints[i].transform_index + 1] or false
			end
			if currentRace.checkpoints_2[i] then
				vehicles_2[i] = currentRace.checkpoints_2[i].is_transform and currentRace.transformVehicles[currentRace.checkpoints_2[i].transform_index + 1] or false
			end
		end
		if #result == 0 then
			currentRace.transformVehicles = {0, -422877666, -731262150, "bmx", "xa21"}
			DisplayCustomMsgs(GetTranslate("reset-transformVehicles"))
		else
			currentRace.transformVehicles = result
		end
		if not isCheckpointPickedUp and currentCheckpoint.is_transform then
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
		if #currentRace.checkpoints > 0 then
			for i = 1, #currentRace.checkpoints do
				if currentRace.checkpoints[i].is_transform then
					local found = false
					for k, v in pairs(currentRace.transformVehicles) do
						if v == vehicles[i] then
							currentRace.checkpoints[i].transform_index = k - 1
							found = true
							break
						end
					end
					if not found then
						currentRace.checkpoints[i].transform_index = 0
					end
				end
				if currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].is_transform then
					local found = false
					for k, v in pairs(currentRace.transformVehicles) do
						if v == vehicles_2[i] then
							currentRace.checkpoints_2[i].transform_index = k - 1
							found = true
							break
						end
					end
					if not found then
						currentRace.checkpoints_2[i].transform_index = 0
					end
				end
			end
		end
		if isCheckpointPickedUp and currentCheckpoint.is_transform then
			currentCheckpoint = global_var.isPrimaryCheckpointItems and tableDeepCopy(currentRace.checkpoints[checkpointIndex]) or tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
		end
	else
		local value = tonumber(data.text)
		if value then
			if nuiCallBack == "startingGrid heading" then
				currentstartingGridVehicle.heading = RoundedValue(value + 0.0, 3)
				if (currentstartingGridVehicle.heading > 9999.0) or (currentstartingGridVehicle.heading < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentstartingGridVehicle.heading = 0.0
				end
				SetEntityRotation(currentstartingGridVehicle.handle, 0.0, 0.0, currentstartingGridVehicle.heading, 2, 0)
				if isStartingGridVehiclePickedUp and currentRace.startingGrid[startingGridVehicleIndex] then
					currentRace.startingGrid[startingGridVehicleIndex] = tableDeepCopy(currentstartingGridVehicle)
					globalRot.z = RoundedValue(currentstartingGridVehicle.heading, 3)
				end
			elseif nuiCallBack == "place checkpoint" then
				local index = math.floor(value)
				local success = false
				if (index >= 1) then
					if global_var.isPrimaryCheckpointItems then
						if index < #currentRace.checkpoints then
							currentCheckpoint.index = index
							table.insert(currentRace.checkpoints, index, currentCheckpoint)
							for k, v in pairs(currentRace.checkpoints) do
								v.index = k
							end
							local copy_checkpoints_2 = {}
							for k, v in pairs(currentRace.checkpoints_2) do
								if index > k then
									v.index = k
									copy_checkpoints_2[k] = v
								elseif index < k then
									v.index = k + 1
									copy_checkpoints_2[k + 1] = v
								end
							end
							currentRace.checkpoints_2 = tableDeepCopy(copy_checkpoints_2)
							success = true
						elseif index >= #currentRace.checkpoints then
							table.insert(currentRace.checkpoints, currentCheckpoint)
							success = true
						end
					else
						if not currentCheckpoint.is_planeRot then
							if currentRace.checkpoints[index] and not currentRace.checkpoints_2[index] then
								currentCheckpoint.index = index
								currentRace.checkpoints_2[index] = tableDeepCopy(currentCheckpoint)
								success = true
							elseif currentRace.checkpoints[index] and currentRace.checkpoints_2[index] then
								DisplayCustomMsgs(string.format(GetTranslate("checkpoints_2-exist"), index))
							elseif not currentRace.checkpoints[index] then
								DisplayCustomMsgs(GetTranslate("checkpoints_2-failed"))
							end
						else
							DisplayCustomMsgs(GetTranslate("checkpoints_2-planeRot-failed"))
						end
					end
					if success then
						checkpointIndex = currentCheckpoint.index
						checkpointPreview = nil
						globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
						currentCheckpoint = {
							index = nil,
							x = nil,
							y = nil,
							z = nil,
							heading = nil,
							d = nil,
							is_round = nil,
							is_air = nil,
							is_fake = nil,
							is_random = nil,
							randomClass = nil,
							is_transform = nil,
							transform_index = nil,
							is_planeRot = nil,
							plane_rot = nil,
							is_warp = nil
						}
						for k, v in pairs(blips.checkpoints) do
							RemoveBlip(v)
						end
						for k, v in pairs(blips.checkpoints_2) do
							RemoveBlip(v)
						end
						blips.checkpoints = {}
						blips.checkpoints_2 = {}
						for k, v in pairs(currentRace.checkpoints) do
							blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
						end
						for k, v in pairs(currentRace.checkpoints_2) do
							blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
						end
					end
				end
			elseif nuiCallBack == "checkpoint x" then
				currentCheckpoint.x = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints_2[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					end
				end
			elseif nuiCallBack == "checkpoint y" then
				currentCheckpoint.y = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints_2[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					end
				end
			elseif nuiCallBack == "checkpoint z" then
				currentCheckpoint.z = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
						SetBlipCoords(blips.checkpoints_2[currentCheckpoint.index], currentCheckpoint.x, currentCheckpoint.y, currentCheckpoint.z)
					end
				end
			elseif nuiCallBack == "checkpoint heading" then
				currentCheckpoint.heading = RoundedValue(value + 0.0, 3)
				if (currentCheckpoint.heading > 9999.0) or (currentCheckpoint.heading < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.heading = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
				end
			elseif nuiCallBack == "prop x" then
				currentObject.x = RoundedValue(value + 0.0, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			elseif nuiCallBack == "prop y" then
				currentObject.y = RoundedValue(value + 0.0, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			elseif nuiCallBack == "prop z" then
				local newZ = RoundedValue(value + 0.0, 3)
				if (newZ > -198.99) and (newZ <= 2698.99) then
					currentObject.z = newZ
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					if isPropPickedUp and currentRace.objects[objectIndex] then
						currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
						global_var.propZposLock = currentObject.z
					end
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			elseif nuiCallBack == "prop rotX" then
				currentObject.rotX = RoundedValue(value + 0.0, 3)
				if (currentObject.rotX > 9999.0) or (currentObject.rotX < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotX = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.x = RoundedValue(currentObject.rotX, 3)
				end
			elseif nuiCallBack == "prop rotY" then
				currentObject.rotY = RoundedValue(value + 0.0, 3)
				if (currentObject.rotY > 9999.0) or (currentObject.rotY < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotY = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.y = RoundedValue(currentObject.rotY, 3)
				end
			elseif nuiCallBack == "prop rotZ" then
				currentObject.rotZ = RoundedValue(value + 0.0, 3)
				if (currentObject.rotZ > 9999.0) or (currentObject.rotZ < -9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentObject.rotZ = 0.0
				end
				SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
					globalRot.z = RoundedValue(currentObject.rotZ, 3)
				end
			elseif nuiCallBack == "template x" then
				templatePreview[1].x = RoundedValue(value + 0.0, 3)
				SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
			elseif nuiCallBack == "template y" then
				templatePreview[1].y = RoundedValue(value + 0.0, 3)
				SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
			elseif nuiCallBack == "template z" then
				local newZ = RoundedValue(value + 0.0, 3)
				if (newZ > -198.99) and (newZ <= 2698.99) then
					templatePreview[1].z = newZ
					SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			elseif nuiCallBack == "template rotX" then
				local newRot = RoundedValue(value + 0.0, 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotX = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "template rotY" then
				local newRot = RoundedValue(value + 0.0, 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotY = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "template rotZ" then
				local newRot = RoundedValue(value + 0.0, 3)
				if (newRot <= 9999.0) and (newRot >= -9999.0) then
					templatePreview[1].rotZ = newRot
					SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			else
				DisplayCustomMsgs(GetTranslate("error-input"))
			end
		else
			local inputData = data.text:gsub("%s+", "")
			local x, y, z, rotX, rotY, rotZ = inputData:match("x=([+-]?%d+%.?%d*),y=([+-]?%d+%.?%d*),z=([+-]?%d+%.?%d*),rotX=([+-]?%d+%.?%d*),rotY=([+-]?%d+%.?%d*),rotZ=([+-]?%d+%.?%d*)")
			if tonumber(x) and tonumber(y) and tonumber(z) and tonumber(rotX) and tonumber(rotY) and tonumber(rotZ) then
				if nuiCallBack == "prop override" then
					local newZ = RoundedValue(tonumber(z) + 0.0, 3)
					if (newZ > -198.99) and (newZ <= 2698.99) then
						currentObject.x = RoundedValue(tonumber(x) + 0.0, 3)
						currentObject.y = RoundedValue(tonumber(y) + 0.0, 3)
						currentObject.z = RoundedValue(tonumber(z) + 0.0, 3)
						currentObject.rotX = RoundedValue(tonumber(rotX) + 0.0, 3)
						currentObject.rotY = RoundedValue(tonumber(rotY) + 0.0, 3)
						currentObject.rotZ = RoundedValue(tonumber(rotZ) + 0.0, 3)
						if (currentObject.rotX > 9999.0) or (currentObject.rotX < -9999.0) then
							DisplayCustomMsgs(GetTranslate("rot-limit"))
							currentObject.rotX = 0.0
						end
						if (currentObject.rotY > 9999.0) or (currentObject.rotY < -9999.0) then
							DisplayCustomMsgs(GetTranslate("rot-limit"))
							currentObject.rotY = 0.0
						end
						if (currentObject.rotZ > 9999.0) or (currentObject.rotZ < -9999.0) then
							DisplayCustomMsgs(GetTranslate("rot-limit"))
							currentObject.rotZ = 0.0
						end
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
						SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
						if isPropPickedUp and currentRace.objects[objectIndex] then
							currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
							global_var.propZposLock = currentObject.z
							globalRot.x = RoundedValue(currentObject.rotX, 3)
							globalRot.y = RoundedValue(currentObject.rotY, 3)
							globalRot.z = RoundedValue(currentObject.rotZ, 3)
						end
					else
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
				elseif nuiCallBack == "template override" then
					local overflow_z = false
					local newZ = RoundedValue(tonumber(z) + 0.0, 3)
					if (newZ <= -198.99) or (newZ > 2698.99) then
						overflow_z = true
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
					local overflow_rot = false
					local newRot_x = RoundedValue(tonumber(rotX) + 0.0, 3)
					local newRot_y = RoundedValue(tonumber(rotY) + 0.0, 3)
					local newRot_z = RoundedValue(tonumber(rotZ) + 0.0, 3)
					if ((newRot_x > 9999.0) or (newRot_x < -9999.0)) or ((newRot_y > 9999.0) or (newRot_y < -9999.0)) or ((newRot_z > 9999.0) or (newRot_z < -9999.0)) then
						overflow_rot = true
						DisplayCustomMsgs(GetTranslate("rot-limit"))
					end
					if not overflow_z and not overflow_rot then
						templatePreview[1].x = RoundedValue(tonumber(x) + 0.0, 3)
						templatePreview[1].y = RoundedValue(tonumber(y) + 0.0, 3)
						templatePreview[1].z = newZ
						SetEntityCoordsNoOffset(templatePreview[1].handle, templatePreview[1].x, templatePreview[1].y, templatePreview[1].z)
						templatePreview[1].rotX = newRot_x
						templatePreview[1].rotY = newRot_y
						templatePreview[1].rotZ = newRot_z
						SetEntityRotation(templatePreview[1].handle, templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ, 2, 0)
					end
				end
			else
				DisplayCustomMsgs(GetTranslate("error-input"))
			end
		end
	end
	while global_var.lock do Citizen.Wait(0) end
	nuiCallBack = ""
end)