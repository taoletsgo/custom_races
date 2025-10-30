AddEventHandler("custom_races:loadrace", function()
	isInRace = true
end)

AddEventHandler("custom_races:unloadrace", function()
	isInRace = false
end)

RegisterNetEvent("custom_creator:client:info", function(str, attempt)
	if str == "ugc-wait" then
		DisplayCustomMsgs(string.format(GetTranslate("ugc-wait"), attempt))
	elseif str == "join-session-trying" then
		DisplayCustomMsgs(GetTranslate("join-session-trying"))
	end
end)

RegisterNUICallback("urlValid", function(data, cb)
	global_var.thumbnailValid = true
	global_var.queryingThumbnail = false
end)

RegisterNUICallback("urlError", function(data, cb)
	global_var.thumbnailValid = false
	global_var.queryingThumbnail = false
	DisplayCustomMsgs(GetTranslate("thumbnail-error"))
end)

RegisterNUICallback("custom_creator:submit", function(data, cb)
	if nuiCallBack == "" or (lockSession and nuiCallBack ~= "") then
		if lockSession then
			SetNuiFocus(false, false)
			nuiCallBack = ""
		end
		return
	else
		SetNuiFocus(false, false)
	end
	if nuiCallBack == "race title" then
		local title = data.text:gsub("[\\/:\"*?<>|]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""):gsub("custom_files", ""):gsub("local_files", "")
		if strinCount(title) > 20 then
			DisplayCustomMsgs(GetTranslate("title-limit"))
		elseif strinCount(title) > 0 then
			if title == "unknown" then
				DisplayCustomMsgs(GetTranslate("title-exist"))
			else
				global_var.lock = true
				TriggerServerCallback("custom_creator:server:check_title", function(bool)
					if bool then
						currentRace.title = title
						if inSession then
							modificationCount.title = modificationCount.title + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { title = currentRace.title, modificationCount = modificationCount.title }, "title-sync")
						end
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
		if string.find(url, "^https://prod.cloud.rockstargames.com/ugc/gta5mission/") and (string.find(url, "jpg$") or string.find(url, "json$")) then
			global_var.lock = true
			global_var.querying = true
			local ugc_img = string.find(url, "jpg$")
			local ugc_json = string.find(url, "json$")
			TriggerServerCallback("custom_creator:server:get_ugc", function(data, permission)
				if data and permission then
					convertJsonData(data)
					global_var.thumbnailValid = false
					SendNUIMessage({
						action = "thumbnail_url",
						thumbnail_url = currentRace.thumbnail
					})
					DisplayCustomMsgs(GetTranslate("load-success"))
				elseif not permission then
					DisplayCustomMsgs(GetTranslate("no-permission"))
				elseif not data then
					DisplayCustomMsgs(GetTranslate("ugc-not-exist"))
				end
				while global_var.lock_2 do Citizen.Wait(0) end
				global_var.lock = false
				global_var.querying = false
			end, url, ugc_img, ugc_json)
		else
			DisplayCustomMsgs(GetTranslate("url-error"))
		end
	elseif nuiCallBack == "filter races" then
		global_var.lock = true
		races_data.filter = data.text
		local races = {}
		local seen = {}
		local str = string.lower(races_data.filter)
		if #str > 0 then
			for i = 1, #races_data.category - 1 do
				for j = 1, #races_data.category[i].data do
					if string.find(string.lower(races_data.category[i].data[j].name), str) and not seen[races_data.category[i].data[j].raceid] then
						table.insert(races, races_data.category[i].data[j])
						seen[races_data.category[i].data[j].raceid] = true
						if #races >= 50 then
							break
						end
					end
				end
				if #races >= 50 then
					break
				end
			end
		end
		if #races >= 50 then
			DisplayCustomMsgs(GetTranslate("result-limit"))
		end
		races_data.index = #races_data.category
		races_data.category[#races_data.category].data = races
		global_var.lock = false
	elseif nuiCallBack == "race thumbnail" then
		if (#data.text > 0) and (#data.text < 200) and string.find(data.text, "^https://") then
			currentRace.thumbnail = data.text
			SendNUIMessage({
				action = "thumbnail_url",
				thumbnail_url = currentRace.thumbnail
			})
			global_var.queryingThumbnail = true
			if inSession then
				modificationCount.thumbnail = modificationCount.thumbnail + 1
				TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { thumbnail = currentRace.thumbnail, modificationCount = modificationCount.thumbnail }, "thumbnail-sync")
			end
		else
			if string.find(data.text, "^http://") then
				DisplayCustomMsgs(GetTranslate("url-http-error"))
			else
				DisplayCustomMsgs(GetTranslate("url-error"))
			end
		end
	elseif nuiCallBack == "test vehicle" then
		local text = data.text
		local hash = tonumber(text) or GetHashKey(text)
		if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
			currentRace.test_vehicle = tonumber(text) or text
			if inSession then
				modificationCount.test_vehicle = modificationCount.test_vehicle + 1
				TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { test_vehicle = currentRace.test_vehicle, modificationCount = modificationCount.test_vehicle }, "test-vehicle-sync")
			end
		else
			DisplayCustomMsgs(string.format(GetTranslate("vehicle-hash-null"), text))
		end
	elseif nuiCallBack == "blimp text" then
		local text = data.text:gsub("[\\/:\"*?<>|]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		if strinCount(text) > 100 then
			DisplayCustomMsgs(GetTranslate("blimp-text-limit"))
		elseif strinCount(text) > 0 then
			currentRace.blimp_text = text
			SetScrollTextOnBlimp(currentRace.blimp_text)
			if inSession then
				modificationCount.blimp_text = modificationCount.blimp_text + 1
				TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { blimp_text = currentRace.blimp_text, modificationCount = modificationCount.blimp_text }, "blimp-text-sync")
			end
		end
	elseif nuiCallBack == "prop hash" then
		lastValidText = data.text
		local hash = tonumber(lastValidText) or GetHashKey(lastValidText)
		if IsModelInCdimage(hash) and IsModelValid(hash) then
			lastValidHash = hash
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
				if hash and ((IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash)) or (tonumber(value) and ((hash == -422877666) or (hash == -731262150)))) then
					table.insert(result, tonumber(value) or value)
				end
			end
		end
		local previewHash = currentCheckpoint.is_transform and currentRace.transformVehicles[currentCheckpoint.transform_index + 1] or false
		local vehicles = {}
		local vehicles_2 = {}
		if #currentRace.checkpoints > 0 then
			for i, checkpoint in ipairs(currentRace.checkpoints) do
				vehicles[i] = checkpoint.is_transform and currentRace.transformVehicles[checkpoint.transform_index + 1] or false
				local checkpoint_2 = currentRace.checkpoints_2[i]
				if checkpoint_2 then
					vehicles_2[i] = checkpoint_2.is_transform and currentRace.transformVehicles[checkpoint_2.transform_index + 1] or false
				end
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
			for i, checkpoint in ipairs(currentRace.checkpoints) do
				if checkpoint.is_transform then
					local found = false
					for j, hash in pairs(currentRace.transformVehicles) do
						if hash == vehicles[i] then
							checkpoint.transform_index = j - 1
							found = true
							break
						end
					end
					if not found then
						checkpoint.transform_index = 0
					end
				end
				local checkpoint_2 = currentRace.checkpoints_2[i]
				if checkpoint_2 and checkpoint_2.is_transform then
					local found = false
					for j, hash in pairs(currentRace.transformVehicles) do
						if hash == vehicles_2[i] then
							checkpoint_2.transform_index = j - 1
							found = true
							break
						end
					end
					if not found then
						checkpoint_2.transform_index = 0
					end
				end
			end
		end
		if isCheckpointPickedUp and currentCheckpoint.is_transform then
			currentCheckpoint = global_var.isPrimaryCheckpointItems and tableDeepCopy(currentRace.checkpoints[checkpointIndex]) or tableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
		end
		if inSession then
			modificationCount.transformVehicles = modificationCount.transformVehicles + 1
			TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { transformVehicles = currentRace.transformVehicles, checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.transformVehicles }, "transformVehicles-sync")
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
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
				end
			elseif nuiCallBack == "place checkpoint" then
				local index = math.floor(value)
				local success = false
				if (index >= 1) then
					if global_var.isPrimaryCheckpointItems then
						if index <= #currentRace.checkpoints then
							checkpointIndex = index
							table.insert(currentRace.checkpoints, index, tableDeepCopy(currentCheckpoint))
							local copy_checkpoints_2 = {}
							for k, v in pairs(currentRace.checkpoints_2) do
								if index > k then
									copy_checkpoints_2[k] = v
								elseif index <= k then
									copy_checkpoints_2[k + 1] = v
								end
							end
							currentRace.checkpoints_2 = tableDeepCopy(copy_checkpoints_2)
							success = true
						elseif index > #currentRace.checkpoints then
							table.insert(currentRace.checkpoints, tableDeepCopy(currentCheckpoint))
							checkpointIndex = #currentRace.checkpoints
							success = true
						end
					else
						if not currentCheckpoint.is_planeRot then
							if currentRace.checkpoints[index] and not currentRace.checkpoints_2[index] then
								checkpointIndex = index
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
						checkpointPreview = nil
						globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
						currentCheckpoint = {
							x = nil,
							y = nil,
							z = nil,
							heading = nil,
							d_collect = nil,
							d_draw = nil,
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
						updateBlips("checkpoint")
						if inSession then
							modificationCount.checkpoints = modificationCount.checkpoints + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, insertIndex = checkpointIndex, isPrimaryCheckpoint = global_var.isPrimaryCheckpointItems, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
						end
					end
				end
			elseif nuiCallBack == "checkpoint x" then
				currentCheckpoint.x = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					updateBlips("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "checkpoint y" then
				currentCheckpoint.y = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					updateBlips("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "checkpoint z" then
				currentCheckpoint.z = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = tableDeepCopy(currentCheckpoint)
					end
					updateBlips("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
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
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "prop x" then
				currentObject.x = RoundedValue(value + 0.0, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			elseif nuiCallBack == "prop y" then
				currentObject.y = RoundedValue(value + 0.0, 3)
				SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
				if isPropPickedUp and currentRace.objects[objectIndex] then
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
					currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
				end
			elseif nuiCallBack == "prop z" then
				local newZ = RoundedValue(value + 0.0, 3)
				if (newZ > -198.99) and (newZ <= 2698.99) then
					currentObject.z = newZ
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					global_var.propZposLock = currentObject.z
					if isPropPickedUp and currentRace.objects[objectIndex] then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
						currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
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
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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
					if inSession then
						currentObject.modificationCount = currentObject.modificationCount + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
					end
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
						global_var.propZposLock = currentObject.z
						if isPropPickedUp and currentRace.objects[objectIndex] then
							if inSession then
								currentObject.modificationCount = currentObject.modificationCount + 1
								TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
							end
							currentRace.objects[objectIndex] = tableDeepCopy(currentObject)
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