AddEventHandler("custom_races:loadrace", function()
	isInRace = true
end)

AddEventHandler("custom_races:unloadrace", function()
	isInRace = false
end)

AddEventHandler("custom_chat:open", function()
	isChatInputActive = true
end)

AddEventHandler("custom_chat:close", function()
	isChatInputActive = false
end)

RegisterNetEvent("custom_creator:client:info", function(str, info)
	if str == "ugc-wait" then
		DisplayCustomMsgs(string.format(GetTranslate("ugc-wait"), info))
	elseif str == "join-session-trying" then
		DisplayCustomMsgs(GetTranslate("join-session-trying"))
	elseif str == "track-list" then
		if busyspinner.status == "load" then
			DisplayBusyspinner("load", 65536, info)
		end
	elseif str == "track-download" then
		if busyspinner.status == "download" then
			DisplayBusyspinner("download", 65536, info)
		end
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
		if StringCount(title) > 20 then
			DisplayCustomMsgs(GetTranslate("title-limit"))
		elseif StringCount(title) > 0 then
			if title == "unknown" then
				DisplayCustomMsgs(GetTranslate("title-exist"))
			else
				global_var.lock = true
				TriggerServerCallback("custom_creator:server:checkTitle", function(bool)
					if bool then
						if currentRace.title == "" then
							RageUI.QuitIndex = nil
						end
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
		if string.find(url, "^https://prod%.cloud%.rockstargames%.com/ugc/gta5mission/") and (string.find(url, "jpg$") or string.find(url, "json$")) then
			global_var.lock = true
			global_var.querying = true
			local ugc_img = string.find(url, "jpg$")
			local ugc_json = string.find(url, "json$")
			busyspinner.status = "download"
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName(string.format(GetTranslate("download-progress"), 0))
			EndTextCommandBusyString(4)
			TriggerServerCallback("custom_creator:server:getUGC", function(data)
				if data then
					if currentRace.title == "" then
						ConvertDataFromUGC(data)
						global_var.thumbnailValid = false
						SendNUIMessage({
							action = "thumbnail_url",
							thumbnail_url = currentRace.thumbnail
						})
						RageUI.QuitIndex = nil
					else
						AddDataFromUGC(data)
					end
					DisplayCustomMsgs(GetTranslate("load-success"))
				else
					DisplayCustomMsgs(GetTranslate("ugc-not-exist"))
				end
				while global_var.lock_2 do Citizen.Wait(0) end
				RemoveLoadingPrompt()
				busyspinner.status = nil
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
	elseif nuiCallBack == "input vehicle" then
		local text = data.text
		local hash = tonumber(text) or GetHashKey(text)
		if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
			currentRace.test_vehicle = tonumber(text) or text
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
			if inSession then
				modificationCount.test_vehicle = modificationCount.test_vehicle + 1
				TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { test_vehicle = currentRace.test_vehicle, modificationCount = modificationCount.test_vehicle }, "test-vehicle-sync")
			end
		else
			DisplayCustomMsgs(string.format(GetTranslate("vehicle-hash-null"), text))
		end
	elseif nuiCallBack == "blimp text" then
		local text = data.text:gsub("[\\/:\"*?<>|]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		if StringCount(text) > 100 then
			DisplayCustomMsgs(GetTranslate("blimp-text-limit"))
		elseif StringCount(text) > 0 then
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
	elseif nuiCallBack == "checkpoint random custom" then
		local str = string.gsub(data.text, "%s+", "")
		local result = {}
		for value in string.gmatch(str, "([^,]+)") do
			local hash = tonumber(value) or GetHashKey(value)
			if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
				table.insert(result, tonumber(value) or value)
			end
		end
		if currentCheckpoint.is_random and currentCheckpoint.random_class == -1 and currentCheckpoint.random_custom == 3 then
			if #result >= 2 then
				currentCheckpoint.random_setting = result
			else
				currentCheckpoint.random_setting = {"bmx", "t20", "xa21"}
			end
			if isCheckpointPickedUp then
				if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
					currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
				elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
					currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
				end
				UpdateBlipForCreator("checkpoint")
				if inSession then
					modificationCount.checkpoints = modificationCount.checkpoints + 1
					TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
				end
			end
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
			currentCheckpoint = global_var.isPrimaryCheckpointItems and TableDeepCopy(currentRace.checkpoints[checkpointIndex]) or TableDeepCopy(currentRace.checkpoints_2[checkpointIndex])
		end
		if inSession then
			modificationCount.transformVehicles = modificationCount.transformVehicles + 1
			TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { transformVehicles = currentRace.transformVehicles, checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.transformVehicles }, "transformVehicles-sync")
		end
	else
		local value = tonumber(data.text)
		if value then
			if nuiCallBack == "goto startingGrid" then
				local index = math.floor(value)
				if not isStartingGridVehiclePickedUp or (isStartingGridVehiclePickedUp and startingGridVehicleIndex ~= index) then
					local startingGrid = TableDeepCopy(currentRace.startingGrid[index])
					if startingGrid then
						if startingGridVehicleSelect then
							currentRace.startingGrid[startingGridVehicleIndex] = TableDeepCopy(currentStartingGridVehicle)
							if inSession then
								modificationCount.startingGrid = modificationCount.startingGrid + 1
								TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
							end
							ResetEntityAlpha(startingGridVehicleSelect)
							SetEntityDrawOutlineColor(255, 255, 255, 125)
							SetEntityDrawOutlineShader(1)
							SetEntityDrawOutline(startingGridVehicleSelect, true)
						end
						if startingGridVehiclePreview then
							DeleteVehicle(startingGridVehiclePreview)
							startingGridVehiclePreview = nil
						end
						startingGridVehicleIndex = index
						global_var.isSelectingStartingGridVehicle = true
						isStartingGridVehiclePickedUp = true
						currentStartingGridVehicle = startingGrid
						globalRot.z = RoundedValue(currentStartingGridVehicle.heading, 3)
						startingGridVehicleSelect = currentStartingGridVehicle.handle
						SetEntityDrawOutline(currentStartingGridVehicle.handle, false)
						SetEntityAlpha(startingGridVehicleSelect, 150)
					end
				end
				if startingGridVehicleSelect then
					local min, max = GetModelDimensionsInCaches(GetEntityModel(startingGridVehicleSelect))
					cameraPosition = vector3(currentStartingGridVehicle.x + (20.0 - min.z) * math.sin(math.rad(currentStartingGridVehicle.heading)), currentStartingGridVehicle.y - (20.0 - min.z) * math.cos(math.rad(currentStartingGridVehicle.heading)), currentStartingGridVehicle.z + (20.0 - min.z))
					cameraRotation = {x = -45.0, y = 0.0, z = currentStartingGridVehicle.heading}
				end
			elseif nuiCallBack == "startingGrid heading" then
				currentStartingGridVehicle.heading = RoundedValue(value + 0.0, 3)
				if (currentStartingGridVehicle.heading <= -9999.0) or (currentStartingGridVehicle.heading >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentStartingGridVehicle.heading = 0.0
				end
				SetEntityRotation(currentStartingGridVehicle.handle, 0.0, 0.0, currentStartingGridVehicle.heading, 2, 0)
				if isStartingGridVehiclePickedUp and currentRace.startingGrid[startingGridVehicleIndex] then
					currentRace.startingGrid[startingGridVehicleIndex] = TableDeepCopy(currentStartingGridVehicle)
					globalRot.z = RoundedValue(currentStartingGridVehicle.heading, 3)
					if inSession then
						modificationCount.startingGrid = modificationCount.startingGrid + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { startingGrid = currentRace.startingGrid, modificationCount = modificationCount.startingGrid }, "startingGrid-sync")
					end
				end
			elseif nuiCallBack == "goto checkpoint" then
				local index = math.floor(value)
				local checkpoint = (global_var.isPrimaryCheckpointItems and TableDeepCopy(currentRace.checkpoints[index])) or (not global_var.isPrimaryCheckpointItems and TableDeepCopy(currentRace.checkpoints_2[index]))
				if checkpoint then
					checkpointIndex = index
					isCheckpointPickedUp = true
					checkpointPreview = nil
					currentCheckpoint = checkpoint
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
					local d = currentCheckpoint.d_draw
					local is_round = currentCheckpoint.is_round
					local is_air = currentCheckpoint.is_air
					local is_fake = currentCheckpoint.is_fake
					local is_random = currentCheckpoint.is_random
					local is_transform = currentCheckpoint.is_transform
					local is_planeRot = currentCheckpoint.is_planeRot
					local is_warp = currentCheckpoint.is_warp
					local draw_size = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
					cameraPosition = vector3(currentCheckpoint.x + (20.0 + draw_size) * math.sin(math.rad(currentCheckpoint.heading)), currentCheckpoint.y - (20.0 + draw_size) * math.cos(math.rad(currentCheckpoint.heading)), currentCheckpoint.z + (20.0 + draw_size))
					cameraRotation = {x = -45.0, y = 0.0, z = currentCheckpoint.heading}
				else
					if not global_var.isPrimaryCheckpointItems then
						DisplayCustomMsgs(string.format(GetTranslate("checkpoints_2-null"), index))
					end
				end
			elseif nuiCallBack == "place checkpoint" then
				local index = math.floor(value)
				local success = false
				if (index >= 1) then
					if global_var.isPrimaryCheckpointItems then
						if index <= #currentRace.checkpoints then
							checkpointIndex = index
							table.insert(currentRace.checkpoints, index, TableDeepCopy(currentCheckpoint))
							local copy_checkpoints_2 = {}
							for k, v in pairs(currentRace.checkpoints_2) do
								if index > k then
									copy_checkpoints_2[k] = v
								elseif index <= k then
									copy_checkpoints_2[k + 1] = v
								end
							end
							currentRace.checkpoints_2 = TableDeepCopy(copy_checkpoints_2)
							success = true
						elseif index > #currentRace.checkpoints then
							table.insert(currentRace.checkpoints, TableDeepCopy(currentCheckpoint))
							checkpointIndex = #currentRace.checkpoints
							success = true
						end
					else
						local checkpoint = currentRace.checkpoints[index]
						local checkpoint_2 = currentRace.checkpoints_2[index]
						if checkpoint and not checkpoint_2 then
							checkpointIndex = index
							currentCheckpoint.d_draw = checkpoint.d_draw
							currentRace.checkpoints_2[index] = TableDeepCopy(currentCheckpoint)
							success = true
						elseif checkpoint and checkpoint_2 then
							DisplayCustomMsgs(string.format(GetTranslate("checkpoints_2-exist"), index))
						elseif not checkpoint then
							DisplayCustomMsgs(GetTranslate("checkpoints_2-failed"))
						end
					end
					if success then
						checkpointPreview = nil
						globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
						ResetGlobalVariable("currentCheckpoint")
						UpdateBlipForCreator("checkpoint")
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
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "checkpoint y" then
				currentCheckpoint.y = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "checkpoint z" then
				currentCheckpoint.z = RoundedValue(value + 0.0, 3)
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "checkpoint heading" then
				currentCheckpoint.heading = RoundedValue(value + 0.0, 3)
				if (currentCheckpoint.heading <= -9999.0) or (currentCheckpoint.heading >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.heading = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					globalRot.z = RoundedValue(currentCheckpoint.heading, 3)
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "checkpoint pitch" then
				currentCheckpoint.pitch = RoundedValue(value + 0.0, 3)
				if (currentCheckpoint.pitch <= -9999.0) or (currentCheckpoint.pitch >= 9999.0) then
					DisplayCustomMsgs(GetTranslate("rot-limit"))
					currentCheckpoint.pitch = 0.0
				end
				if isCheckpointPickedUp then
					if global_var.isPrimaryCheckpointItems and currentRace.checkpoints[checkpointIndex] then
						currentRace.checkpoints[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					elseif not global_var.isPrimaryCheckpointItems and currentRace.checkpoints_2[checkpointIndex] then
						currentRace.checkpoints_2[checkpointIndex] = TableDeepCopy(currentCheckpoint)
					end
					UpdateBlipForCreator("checkpoint")
					if inSession then
						modificationCount.checkpoints = modificationCount.checkpoints + 1
						TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, { checkpoints = currentRace.checkpoints, checkpoints_2 = currentRace.checkpoints_2, modificationCount = modificationCount.checkpoints }, "checkpoints-sync")
					end
				end
			elseif nuiCallBack == "goto prop" then
				local index = math.floor(value)
				local object = currentRace.objects[index]
				if object then
					objectIndex = index
					isPropPickedUp = true
					if objectPreview then
						if objectPreview_effect then
							StopParticleFxLooped(objectPreview_effect, true)
							objectPreview_effect = nil
						end
						DeleteObject(objectPreview)
						objectPreview = nil
					end
					currentObject = object
					global_var.propZposLock = currentObject.z
					globalRot.x = RoundedValue(currentObject.rotX, 3)
					globalRot.y = RoundedValue(currentObject.rotY, 3)
					globalRot.z = RoundedValue(currentObject.rotZ, 3)
					global_var.propColor = currentObject.color
					lastValidHash = currentObject.hash
					local found = false
					for k, v in pairs(category) do
						for i = 1, #v.model do
							local hash = tonumber(v.model[i]) or GetHashKey(v.model[i])
							if lastValidHash == hash then
								found = true
								lastValidText = v.model[i]
								v.index = i
								categoryIndex = k
								break
							end
						end
						if found then break end
					end
					if not found then
						local hash_2 = tonumber(lastValidText) or GetHashKey(lastValidText)
						if lastValidHash ~= hash_2 then
							lastValidText = tostring(lastValidHash) or ""
						end
					end
					local min, max = GetModelDimensionsInCaches(currentObject.hash)
					cameraPosition = vector3(currentObject.x + (20.0 - min.z) * math.sin(math.rad(currentObject.rotZ)), currentObject.y - (20.0 - min.z) * math.cos(math.rad(currentObject.rotZ)), currentObject.z + (20.0 - min.z))
					cameraRotation = {x = -45.0, y = 0.0, z = currentObject.rotZ}
				end
			elseif nuiCallBack == "prop x" and currentObject.handle then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -16000.0) and (newValue < 16000.0) then
					local old_x = currentObject.x
					local old_y = currentObject.y
					currentObject.x = newValue
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
						RefreshGirdForObject(old_x, old_y, currentObject)
					end
				else
					DisplayCustomMsgs(GetTranslate("xy-limit"))
				end
			elseif nuiCallBack == "prop y" and currentObject.handle then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -16000.0) and (newValue < 16000.0) then
					local old_x = currentObject.x
					local old_y = currentObject.y
					currentObject.y = newValue
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
						RefreshGirdForObject(old_x, old_y, currentObject)
					end
				else
					DisplayCustomMsgs(GetTranslate("xy-limit"))
				end
			elseif nuiCallBack == "prop z" and currentObject.handle then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -200.0) and (newValue < 2700.0) then
					currentObject.z = newValue
					SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
					global_var.propZposLock = currentObject.z
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
					end
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			elseif nuiCallBack == "prop rotX" and currentObject.handle then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -9999.0) and (newValue < 9999.0) then
					currentObject.rotX = newValue
					SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
						globalRot.x = RoundedValue(currentObject.rotX, 3)
					end
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "prop rotY" and currentObject.handle then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -9999.0) and (newValue < 9999.0) then
					currentObject.rotY = newValue
					SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
						globalRot.y = RoundedValue(currentObject.rotY, 3)
					end
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "prop rotZ" and currentObject.handle then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -9999.0) and (newValue < 9999.0) then
					currentObject.rotZ = newValue
					SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
					if isPropPickedUp then
						if inSession then
							currentObject.modificationCount = currentObject.modificationCount + 1
							TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
						end
						globalRot.z = RoundedValue(currentObject.rotZ, 3)
					end
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "template x" then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -16000.0) and (newValue < 16000.0) then
					local aPos_new, aRot_new = vector3(newValue, templatePreview[1].y, templatePreview[1].z), vector3(templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ)
					local aQuat_new = RotationToQuaternion(aRot_new)
					SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
				else
					DisplayCustomMsgs(GetTranslate("xy-limit"))
				end
			elseif nuiCallBack == "template y" then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -16000.0) and (newValue < 16000.0) then
					local aPos_new, aRot_new = vector3(templatePreview[1].x, newValue, templatePreview[1].z), vector3(templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ)
					local aQuat_new = RotationToQuaternion(aRot_new)
					SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
				else
					DisplayCustomMsgs(GetTranslate("xy-limit"))
				end
			elseif nuiCallBack == "template z" then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -200.0) and (newValue < 2700.0) then
					local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, newValue), vector3(templatePreview[1].rotX, templatePreview[1].rotY, templatePreview[1].rotZ)
					local aQuat_new = RotationToQuaternion(aRot_new)
					SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
					global_var.templateZposLock = templatePreview[1].z
				else
					DisplayCustomMsgs(GetTranslate("z-limit"))
				end
			elseif nuiCallBack == "template rotX" then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -9999.0) and (newValue < 9999.0) then
					local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, templatePreview[1].z), vector3(newValue, templatePreview[1].rotY, templatePreview[1].rotZ)
					local aQuat_new = RotationToQuaternion(aRot_new)
					SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "template rotY" then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -9999.0) and (newValue < 9999.0) then
					local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, templatePreview[1].z), vector3(templatePreview[1].rotX, newValue, templatePreview[1].rotZ)
					local aQuat_new = RotationToQuaternion(aRot_new)
					SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "template rotZ" then
				local newValue = RoundedValue(value + 0.0, 3)
				if (newValue > -9999.0) and (newValue < 9999.0) then
					local aPos_new, aRot_new = vector3(templatePreview[1].x, templatePreview[1].y, templatePreview[1].z), vector3(templatePreview[1].rotX, templatePreview[1].rotY, newValue)
					local aQuat_new = RotationToQuaternion(aRot_new)
					SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
				else
					DisplayCustomMsgs(GetTranslate("rot-limit"))
				end
			elseif nuiCallBack == "goto fixture" then
				local index = math.floor(value)
				local fixture = TableDeepCopy(currentRace.fixtures[index])
				if fixture then
					fixtureIndex = index
					currentFixture = fixture
					local min, max = GetModelDimensionsInCaches(currentFixture.hash)
					cameraPosition = vector3(currentFixture.x, currentFixture.y, currentFixture.z + (10.0 + max.z - min.z))
					cameraRotation = {x = -89.9, y = 0.0, z = cameraRotation.z}
				end
			else
				DisplayCustomMsgs(GetTranslate("error-input"))
			end
		else
			local inputData = data.text:gsub("%s+", "")
			local x, y, z, rotX, rotY, rotZ = inputData:match("x=([+-]?%d+%.?%d*),y=([+-]?%d+%.?%d*),z=([+-]?%d+%.?%d*),rotX=([+-]?%d+%.?%d*),rotY=([+-]?%d+%.?%d*),rotZ=([+-]?%d+%.?%d*)")
			if tonumber(x) and tonumber(y) and tonumber(z) and tonumber(rotX) and tonumber(rotY) and tonumber(rotZ) then
				if nuiCallBack == "prop override" and currentObject.handle then
					local overflow = false
					local newX = RoundedValue(tonumber(x) + 0.0, 3)
					local newY = RoundedValue(tonumber(y) + 0.0, 3)
					local newZ = RoundedValue(tonumber(z) + 0.0, 3)
					local newRot_x = RoundedValue(tonumber(rotX) + 0.0, 3)
					local newRot_y = RoundedValue(tonumber(rotY) + 0.0, 3)
					local newRot_z = RoundedValue(tonumber(rotZ) + 0.0, 3)
					if (newX <= -16000.0) or (newX >= 16000.0) or (newY <= -16000.0) or (newY >= 16000.0) then
						overflow = true
						DisplayCustomMsgs(GetTranslate("xy-limit"))
					end
					if (newZ <= -200.0) or (newZ >= 2700.0) then
						overflow = true
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
					if (newRot_x <= -9999.0) or (newRot_x >= 9999.0) or (newRot_y <= -9999.0) or (newRot_y >= 9999.0) or (newRot_z <= -9999.0) or (newRot_z >= 9999.0) then
						overflow = true
						DisplayCustomMsgs(GetTranslate("rot-limit"))
					end
					if not overflow then
						local old_x = currentObject.x
						local old_y = currentObject.y
						currentObject.x = newX
						currentObject.y = newY
						currentObject.z = newZ
						currentObject.rotX = newRot_x
						currentObject.rotY = newRot_y
						currentObject.rotZ = newRot_z
						SetEntityCoordsNoOffset(currentObject.handle, currentObject.x, currentObject.y, currentObject.z)
						SetEntityRotation(currentObject.handle, currentObject.rotX, currentObject.rotY, currentObject.rotZ, 2, 0)
						global_var.propZposLock = currentObject.z
						if isPropPickedUp then
							if inSession then
								currentObject.modificationCount = currentObject.modificationCount + 1
								TriggerServerEvent("custom_creator:server:syncData", currentRace.raceid, currentObject, "objects-change")
							end
							globalRot.x = RoundedValue(currentObject.rotX, 3)
							globalRot.y = RoundedValue(currentObject.rotY, 3)
							globalRot.z = RoundedValue(currentObject.rotZ, 3)
							RefreshGirdForObject(old_x, old_y, currentObject)
						end
					end
				elseif nuiCallBack == "template override" then
					local overflow = false
					local newX = RoundedValue(tonumber(x) + 0.0, 3)
					local newY = RoundedValue(tonumber(y) + 0.0, 3)
					local newZ = RoundedValue(tonumber(z) + 0.0, 3)
					local newRot_x = RoundedValue(tonumber(rotX) + 0.0, 3)
					local newRot_y = RoundedValue(tonumber(rotY) + 0.0, 3)
					local newRot_z = RoundedValue(tonumber(rotZ) + 0.0, 3)
					if (newX <= -16000.0) or (newX >= 16000.0) or (newY <= -16000.0) or (newY >= 16000.0) then
						overflow = true
						DisplayCustomMsgs(GetTranslate("xy-limit"))
					end
					if (newZ <= -200.0) or (newZ >= 2700.0) then
						overflow = true
						DisplayCustomMsgs(GetTranslate("z-limit"))
					end
					if (newRot_x <= -9999.0) or (newRot_x >= 9999.0) or (newRot_y <= -9999.0) or (newRot_y >= 9999.0) or (newRot_z <= -9999.0) or (newRot_z >= 9999.0) then
						overflow = true
						DisplayCustomMsgs(GetTranslate("rot-limit"))
					end
					if not overflow then
						local aPos_new, aRot_new = vector3(newX, newY, newZ), vector3(newRot_x, newRot_y, newRot_z)
						local aQuat_new = RotationToQuaternion(aRot_new)
						SetTemplateNewPositionAndRotation(aPos_new, aQuat_new)
						global_var.templateZposLock = templatePreview[1].z
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