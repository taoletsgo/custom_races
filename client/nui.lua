RegisterNUICallback("colorSelected", function(data, cb)
	local r, g, b = data.color:match("rgb%((%d+),%s*(%d+),%s*(%d+)%)")
	if DoesEntityExist(Client.Vehicle.Tuning.Entity) and RageUI.Visible(Client.Menu.Vehicle.Custom.Respray) then
		local colorPrimary, colorSecondary = GetVehicleColours(Client.Vehicle.Tuning.Entity)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(Client.Vehicle.Tuning.Entity)
		if Client.NUI.Picker.Primary then
			Client.Vehicle.Menu["color1"].Index = 1
			Client.Vehicle.Menu["pearlescentColor"].Index = 1
			SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
			SetVehicleColours(Client.Vehicle.Tuning.Entity, 0, colorSecondary)
			SetVehicleExtraColours(Client.Vehicle.Tuning.Entity, 0, wheelColor)
			SetVehicleCustomPrimaryColour(Client.Vehicle.Tuning.Entity, tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255)
		elseif Client.NUI.Picker.Secondary then
			Client.Vehicle.Menu["color2"].Index = 1
			Client.Vehicle.Menu["pearlescentColor"].Index = 1
			SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
			SetVehicleColours(Client.Vehicle.Tuning.Entity, colorPrimary, 0)
			SetVehicleExtraColours(Client.Vehicle.Tuning.Entity, 0, wheelColor)
			SetVehicleCustomSecondaryColour(Client.Vehicle.Tuning.Entity, tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255)
		end
	end
end)

RegisterNUICallback("colorClosed", function(data, cb)
	if not Client.NUI.Picker.Enable then return end
	SetNuiFocus(false, false)
	Client.NUI.Picker.Enable = false
	Client.NUI.Picker.Primary = false
	Client.NUI.Picker.Secondary = false
end)

RegisterNUICallback("submitValue", function(data, cb)
	if Client.NUI.Callback == "" or Client.NUI.CallbackDisable then return end
	if Creator.Multiplayer.LockSession or type(data.value) ~= "string" then
		Client.NUI.CallbackDisable = true
		CreateThread(function()
			Wait(50)
			SetNuiFocus(false, false)
			Client.NUI.Callback = ""
			Client.NUI.CallbackDisable = false
		end)
		return
	end
	if Client.NUI.Callback == "spawn vehicle by model name" then
		if #data.value > 0 then
			Client.IsVehicleSpawning = true
			local model = tonumber(data.value) or GetHashKey(data.value)
			local name = GetDisplayNameFromVehicleModel(model)
			local label = GetLabelText(name)
			Client.Function.Vehicle.Spawn(model, nil, label ~= "NULL" and label or name)
		end
	elseif Client.NUI.Callback == "spawn vehicle by plate" then
		local plate = string.lower(data.value)
		local exist = false
		for key, savedVehicle in pairs(Client.Vehicle.SavedVehicles) do
			if string.lower(savedVehicle.plate) == plate then
				Client.IsVehicleSpawning = true
				exist = true
				local name = GetDisplayNameFromVehicleModel(savedVehicle.model)
				local label = GetLabelText(name)
				Client.Function.Vehicle.Spawn(savedVehicle.model, savedVehicle, label ~= "NULL" and label or name)
				break
			end
		end
		if not exist then
			Client.Function.Message.Display(Client.Function.Translate.Get("plate-text-not-found"))
		end
	elseif Client.NUI.Callback == "plate text" then
		if DoesEntityExist(Client.Vehicle.Tuning.Entity) and RageUI.Visible(Client.Menu.Vehicle.Custom.Main) then
			local oldPlate = Client.Function.Math.TrimedValue(GetVehicleNumberPlateText(Client.Vehicle.Tuning.Entity)) or ""
			SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
			SetVehicleNumberPlateText(Client.Vehicle.Tuning.Entity, data.value)
			local newPlate = Client.Function.Math.TrimedValue(GetVehicleNumberPlateText(Client.Vehicle.Tuning.Entity)) or ""
			if oldPlate ~= newPlate then
				local exist = false
				local props = nil
				for key, savedVehicle in pairs(Client.Vehicle.SavedVehicles) do
					if savedVehicle.plate == oldPlate then
						props = savedVehicle
						break
					end
				end
				for key, savedVehicle in pairs(Client.Vehicle.SavedVehicles) do
					if savedVehicle.plate == newPlate then
						exist = true
						break
					end
				end
				if exist then
					SetVehicleModKit(Client.Vehicle.Tuning.Entity, 0)
					SetVehicleNumberPlateText(Client.Vehicle.Tuning.Entity, oldPlate)
					Client.Function.Message.Display(Client.Function.Translate.Get("plate-text-exist"))
				else
					if props then
						props.plate = newPlate
						Client.Function.Vehicle.SetSavedForMenu()
						Client.Function.Message.Display(Client.Function.Translate.Get("plate-text-auto-saved"))
						TriggerServerEvent("server:core:saveVehicle", {oldPlate = oldPlate, newPlate = newPlate}, 3)
					end
				end
			end
		end
	elseif Client.NUI.Callback == "skin import" then
		if #data.value > 0 then
			local skinData = json.decode(data.value)
			if type(skinData) == "table" and not Client.IsPedSpawning then
				Client.Function.Skin.Set(skinData, true)
			end
		end
	elseif Client.NUI.Callback == "ped model filter" then
		if RageUI.Visible(Client.Menu.Ped.Animal) then
			Client.Skin.Model.Animal.FilterStr = string.lower(data.value)
			Client.Skin.Model.Animal.FilterCount = 0
			for k, v in pairs(Client.Skin.Model.Animal.Data) do
				if string.find(string.lower(v.label), Client.Skin.Model.Animal.FilterStr) then
					v.filtered = true
					Client.Skin.Model.Animal.FilterCount = Client.Skin.Model.Animal.FilterCount + 1
				else
					v.filtered = false
				end
			end
		elseif RageUI.Visible(Client.Menu.Ped.AddOn) then
			Client.Skin.Model.AddOn.FilterStr = string.lower(data.value)
			Client.Skin.Model.AddOn.FilterCount = 0
			for k, v in pairs(Client.Skin.Model.AddOn.Data) do
				if string.find(string.lower(v.label), Client.Skin.Model.AddOn.FilterStr) then
					v.filtered = true
					Client.Skin.Model.AddOn.FilterCount = Client.Skin.Model.AddOn.FilterCount + 1
				else
					v.filtered = false
				end
			end
		end
	elseif Client.NUI.Callback == "race title" then
		local title = data.value:gsub("[\\/:\"*?<>|]", ""):gsub("%%s", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		if Client.Function.Math.StringCount(title) > 20 then
			Client.Function.Message.Display(Client.Function.Translate.Get("title-limit"))
		elseif Client.Function.Math.StringCount(title) > 0 and title ~= "unknown" then
			if Creator.Track.Current.Title == "" then
				RageUI.QuitIndex = nil
			end
			Creator.Track.Current.Title = title
			if Creator.Multiplayer.InSession then
				Creator.Multiplayer.ModificationCount.title = Creator.Multiplayer.ModificationCount.title + 1
				TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {title = Creator.Track.Current.Title, modificationCount = Creator.Multiplayer.ModificationCount.title}, "title-sync")
			end
		else
			Client.Function.Message.Display(Client.Function.Translate.Get("title-error"))
		end
	elseif Client.NUI.Callback == "import ugc" then
		local url = data.value
		if string.find(url, "^https://prod%.cloud%.rockstargames%.com/ugc/gta5mission/") and (string.find(url, "jpg$") or string.find(url, "json$")) then
			Creator.GlobalVar.Lock = true
			Creator.GlobalVar.Querying = true
			local ugcImg = string.find(url, "jpg$")
			local ugcJson = string.find(url, "json$")
			Client.Busyspinner.Status = "download"
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName(string.format(Client.Function.Translate.Get("download-progress"), 0))
			EndTextCommandBusyString(4)
			TriggerServerCallback("server:creator:searchUGC", function(data)
				Creator.GlobalVar.Querying = false
				if data then
					if Creator.Track.Current.Title == "" then
						Creator.Function.Track.ConvertFromData(data)
						Creator.GlobalVar.ThumbnailValid = false
						SendNUIMessage({
							action = "thumbnail url",
							url = Creator.Track.Current.Thumbnail
						})
						RageUI.QuitIndex = nil
					else
						Creator.Function.Track.AddFromData(data)
					end
					Client.Function.Message.Display(Client.Function.Translate.Get("load-success"))
				else
					Client.Function.Message.Display(Client.Function.Translate.Get("ugc-not-exist"))
				end
				while Creator.GlobalVar.Lock_2 do Wait(0) end
				RemoveLoadingPrompt()
				Client.Busyspinner.Status = nil
				Creator.GlobalVar.Lock = false
			end, url, ugcImg, ugcJson)
		else
			Client.Function.Message.Display(Client.Function.Translate.Get("url-error"))
		end
	elseif Client.NUI.Callback == "filter races" then
		Creator.Track.FilterStr = data.value
		local races = {}
		local seen = {}
		local str = string.lower(Creator.Track.FilterStr)
		if #str > 0 then
			for i = 1, #Creator.Track.All - 1 do
				for j = 1, #Creator.Track.All[i].data do
					if string.find(string.lower(Creator.Track.All[i].data[j].name), str) and not seen[Creator.Track.All[i].data[j].raceId] then
						table.insert(races, Creator.Track.All[i].data[j])
						seen[Creator.Track.All[i].data[j].raceId] = true
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
			Client.Function.Message.Display(Client.Function.Translate.Get("result-limit"))
		end
		Creator.Track.Index = #Creator.Track.All
		Creator.Track.All[#Creator.Track.All].data = races
	elseif Client.NUI.Callback == "race thumbnail" then
		if (#data.value > 0) and (#data.value < 200) and string.find(data.value, "^https://") then
			Creator.Track.Current.Thumbnail = data.value
			SendNUIMessage({
				action = "thumbnail url",
				url = Creator.Track.Current.Thumbnail
			})
			Creator.GlobalVar.QueryingThumbnail = true
			if Creator.Multiplayer.InSession then
				Creator.Multiplayer.ModificationCount.thumbnail = Creator.Multiplayer.ModificationCount.thumbnail + 1
				TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {thumbnail = Creator.Track.Current.Thumbnail, modificationCount = Creator.Multiplayer.ModificationCount.thumbnail}, "thumbnail-sync")
			end
		else
			if string.find(data.value, "^http://") then
				Client.Function.Message.Display(Client.Function.Translate.Get("url-http-error"))
			else
				Client.Function.Message.Display(Client.Function.Translate.Get("url-error"))
			end
		end
	elseif Client.NUI.Callback == "input vehicle" then
		local text = data.value
		local hash = tonumber(text) or GetHashKey(text)
		if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
			Creator.Track.Current.TestVehicle = tonumber(text) or text
			local found = false
			for classid = 0, 27 do
				for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
					if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].hash == hash then
						Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = true
						Creator.Track.Current.AvailableVehicles[classid].index = i
						Creator.Track.Current.DefaultClass = classid
						found = true
						break
					end
				end
				if found then break end
			end
			if not found then
				Creator.Track.Current.DefaultClass = nil
			end
			if Creator.Multiplayer.InSession then
				Creator.Multiplayer.ModificationCount.testVehicle = Creator.Multiplayer.ModificationCount.testVehicle + 1
				TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {testVehicle = Creator.Track.Current.TestVehicle, modificationCount = Creator.Multiplayer.ModificationCount.testVehicle}, "test-vehicle-sync")
			end
		else
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("vehicle-hash-null"), text))
		end
	elseif Client.NUI.Callback == "blimp text" then
		local text = data.value:gsub("[\\/:\"*?<>|]", ""):gsub("%%s", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
		if Client.Function.Math.StringCount(text) > 100 then
			Client.Function.Message.Display(Client.Function.Translate.Get("blimp-text-limit"))
		elseif Client.Function.Math.StringCount(text) > 0 then
			Creator.Track.Current.BlimpText = text
			Client.Function.Blimp.SetText(Client.Blimp.Scaleform, Creator.Track.Current.BlimpText)
			if Creator.Multiplayer.InSession then
				Creator.Multiplayer.ModificationCount.blimpText = Creator.Multiplayer.ModificationCount.blimpText + 1
				TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {blimpText = Creator.Track.Current.BlimpText, modificationCount = Creator.Multiplayer.ModificationCount.blimpText}, "blimp-text-sync")
			end
		end
	elseif Client.NUI.Callback == "prop hash" then
		Creator.LastValidText = data.value
		local hash = tonumber(Creator.LastValidText) or GetHashKey(Creator.LastValidText)
		if IsModelInCdimage(hash) and IsModelValid(hash) then
			Creator.LastValidHash = hash
			Creator.GlobalVar.PropColor = nil
		else
			Creator.LastValidHash = nil
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("object-hash-null"), data.value))
		end
	elseif Client.NUI.Callback == "checkpoint random custom" then
		if Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview then
			local str = string.gsub(data.value, "%s+", "")
			local result = {}
			for value in string.gmatch(str, "([^,]+)") do
				local hash = tonumber(value) or GetHashKey(value)
				if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
					table.insert(result, tonumber(value) or value)
				end
			end
			if Creator.Checkpoint.Current.isRandom and Creator.Checkpoint.Current.randomClass == -1 and Creator.Checkpoint.Current.randomCustom == 3 then
				if #result >= 2 then
					Creator.Checkpoint.Current.randomSetting = result
				else
					Creator.Checkpoint.Current.randomSetting = {"bmx", "t20", "xa21"}
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end
	elseif Client.NUI.Callback == "checkpoint transform vehicles" then
		if Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview then
			local str = string.gsub(data.value, "%s+", "")
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
			local previewHash = Creator.Checkpoint.Current.isTransform and Creator.Track.Current.TransformVehicles[Creator.Checkpoint.Current.transformIndex + 1] or false
			local vehicles = {}
			local vehicles_2 = {}
			if #Creator.Track.Current.Checkpoints > 0 then
				for i, checkpoint in ipairs(Creator.Track.Current.Checkpoints) do
					vehicles[i] = checkpoint.isTransform and Creator.Track.Current.TransformVehicles[checkpoint.transformIndex + 1] or false
					local checkpoint_2 = Creator.Track.Current.Checkpoints_2[i]
					if checkpoint_2 then
						vehicles_2[i] = checkpoint_2.isTransform and Creator.Track.Current.TransformVehicles[checkpoint_2.transformIndex + 1] or false
					end
				end
			end
			if #result == 0 then
				Creator.Track.Current.TransformVehicles = {0, -422877666, -731262150, "bmx", "xa21"}
				Client.Function.Message.Display(Client.Function.Translate.Get("reset-transformVehicles"))
			else
				Creator.Track.Current.TransformVehicles = result
			end
			if not Creator.Checkpoint.IsPickedUp and Creator.Checkpoint.Current.isTransform then
				local found = false
				for k, v in pairs(Creator.Track.Current.TransformVehicles) do
					if v == previewHash then
						Creator.Checkpoint.Current.transformIndex = k - 1
						found = true
						break
					end
				end
				if not found then
					Creator.Checkpoint.Current.transformIndex = 0
				end
			end
			if #Creator.Track.Current.Checkpoints > 0 then
				for i, checkpoint in ipairs(Creator.Track.Current.Checkpoints) do
					if checkpoint.isTransform then
						local found = false
						for j, hash in pairs(Creator.Track.Current.TransformVehicles) do
							if hash == vehicles[i] then
								checkpoint.transformIndex = j - 1
								found = true
								break
							end
						end
						if not found then
							checkpoint.transformIndex = 0
						end
					end
					local checkpoint_2 = Creator.Track.Current.Checkpoints_2[i]
					if checkpoint_2 and checkpoint_2.isTransform then
						local found = false
						for j, hash in pairs(Creator.Track.Current.TransformVehicles) do
							if hash == vehicles_2[i] then
								checkpoint_2.transformIndex = j - 1
								found = true
								break
							end
						end
						if not found then
							checkpoint_2.transformIndex = 0
						end
					end
				end
			end
			if Creator.Checkpoint.IsPickedUp and Creator.Checkpoint.Current.isTransform then
				Creator.Checkpoint.Current = Creator.GlobalVar.IsPrimaryCheckpointItems and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index]) or Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
			end
			if Creator.Multiplayer.InSession then
				Creator.Multiplayer.ModificationCount.transformVehicles = Creator.Multiplayer.ModificationCount.transformVehicles + 1
				TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {transformVehicles = Creator.Track.Current.TransformVehicles, checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.transformVehicles}, "transformVehicles-sync")
			end
		end
	else
		local value = tonumber(data.value)
		if value then
			if Client.NUI.Callback == "goto startingGrid" then
				local index = math.floor(value)
				if not Creator.StartingGrid.IsPickedUp or (Creator.StartingGrid.IsPickedUp and Creator.StartingGrid.Index ~= index) then
					local startingGrid = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.StartingGrid[index])
					if startingGrid then
						if Creator.StartingGrid.Select then
							Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
							if Creator.Multiplayer.InSession then
								Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
							end
							ResetEntityAlpha(Creator.StartingGrid.Select)
							SetEntityDrawOutlineColor(255, 255, 255, 125)
							SetEntityDrawOutlineShader(1)
							SetEntityDrawOutline(Creator.StartingGrid.Select, true)
						end
						if Creator.StartingGrid.Preview then
							DeleteVehicle(Creator.StartingGrid.Preview)
							Creator.StartingGrid.Preview = nil
						end
						Creator.StartingGrid.Index = index
						Creator.GlobalVar.IsSelectingStartingGridVehicle = true
						Creator.StartingGrid.IsPickedUp = true
						Creator.StartingGrid.Current = startingGrid
						Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
						Creator.StartingGrid.Select = Creator.StartingGrid.Current.handle
						SetEntityDrawOutline(Creator.StartingGrid.Select, false)
						SetEntityAlpha(Creator.StartingGrid.Select, 150)
					end
				end
				if Creator.StartingGrid.Select then
					local min, max = Client.Function.Shared.GetModelDimensionsInCaches(GetEntityModel(Creator.StartingGrid.Select))
					Creator.Camera.Position = vector3(Creator.StartingGrid.Current.x + (20.0 - min.z) * math.sin(math.rad(Creator.StartingGrid.Current.heading)), Creator.StartingGrid.Current.y - (20.0 - min.z) * math.cos(math.rad(Creator.StartingGrid.Current.heading)), Creator.StartingGrid.Current.z + (20.0 - min.z))
					Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.StartingGrid.Current.heading}
				end
			elseif Client.NUI.Callback == "startingGrid heading" then
				if Creator.StartingGrid.Current.handle then
					Creator.StartingGrid.Current.heading = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (Creator.StartingGrid.Current.heading <= -9999.0) or (Creator.StartingGrid.Current.heading >= 9999.0) then
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
						Creator.StartingGrid.Current.heading = 0.0
					end
					SetEntityRotation(Creator.StartingGrid.Current.handle, 0.0, 0.0, Creator.StartingGrid.Current.heading, 2, 0)
					if Creator.StartingGrid.IsPickedUp and Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] then
						Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
						Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
						end
					end
				end
			elseif Client.NUI.Callback == "goto checkpoint" then
				local index = math.floor(value)
				local checkpoint = (Creator.GlobalVar.IsPrimaryCheckpointItems and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[index])) or (not Creator.GlobalVar.IsPrimaryCheckpointItems and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[index]))
				if checkpoint then
					Creator.Checkpoint.Index = index
					Creator.Checkpoint.IsPickedUp = true
					Creator.Checkpoint.Preview = nil
					Creator.Checkpoint.Current = checkpoint
					Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading, 3)
					local d = Creator.Checkpoint.Current.diameterDraw
					local isRound = Creator.Checkpoint.Current.isRound
					local isAir = Creator.Checkpoint.Current.isAir
					local isFake = Creator.Checkpoint.Current.isFake
					local isRandom = Creator.Checkpoint.Current.isRandom
					local isTransform = Creator.Checkpoint.Current.isTransform
					local isPlaneRot = Creator.Checkpoint.Current.isPlaneRot
					local isWarp = Creator.Checkpoint.Current.isWarp
					local drawSize = ((isAir and (4.5 * d)) or ((isRound or isRandom or isTransform or isPlaneRot or isWarp) and (2.25 * d)) or d) * 10
					Creator.Camera.Position = vector3(Creator.Checkpoint.Current.x + (20.0 + drawSize) * math.sin(math.rad(Creator.Checkpoint.Current.heading)), Creator.Checkpoint.Current.y - (20.0 + drawSize) * math.cos(math.rad(Creator.Checkpoint.Current.heading)), Creator.Checkpoint.Current.z + (20.0 + drawSize))
					Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Checkpoint.Current.heading}
				else
					if not Creator.GlobalVar.IsPrimaryCheckpointItems then
						Client.Function.Message.Display(string.format(Client.Function.Translate.Get("checkpoints_2-null"), index))
					end
				end
			elseif Client.NUI.Callback == "place checkpoint" then
				if Creator.Checkpoint.Preview then
					local index = math.floor(value)
					local success = false
					if (index >= 1) then
						if Creator.GlobalVar.IsPrimaryCheckpointItems then
							if index <= #Creator.Track.Current.Checkpoints then
								Creator.Checkpoint.Index = index
								table.insert(Creator.Track.Current.Checkpoints, index, Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current))
								local checkpoints_2 = {}
								for k, v in pairs(Creator.Track.Current.Checkpoints_2) do
									if index > k then
										checkpoints_2[k] = v
									elseif index <= k then
										checkpoints_2[k + 1] = v
									end
								end
								Creator.Track.Current.Checkpoints_2 = Client.Function.Shared.TableDeepCopy(checkpoints_2)
								success = true
							elseif index > #Creator.Track.Current.Checkpoints then
								table.insert(Creator.Track.Current.Checkpoints, Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current))
								Creator.Checkpoint.Index = #Creator.Track.Current.Checkpoints
								success = true
							end
						else
							local checkpoint = Creator.Track.Current.Checkpoints[index]
							local checkpoint_2 = Creator.Track.Current.Checkpoints_2[index]
							if checkpoint and not checkpoint_2 then
								Creator.Checkpoint.Index = index
								Creator.Checkpoint.Current.diameterDraw = checkpoint.diameterDraw
								Creator.Track.Current.Checkpoints_2[index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
								success = true
							elseif checkpoint and checkpoint_2 then
								Client.Function.Message.Display(string.format(Client.Function.Translate.Get("checkpoints_2-exist"), index))
							elseif not checkpoint then
								Client.Function.Message.Display(Client.Function.Translate.Get("checkpoints_2-failed"))
							end
						end
						if success then
							Creator.Checkpoint.Preview = nil
							Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading, 3)
							Creator.Function.ResetGlobalVariable("checkpoint")
							Creator.Function.UpdateBlip("checkpoint")
							if Creator.Multiplayer.InSession then
								Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, insertIndex = Creator.Checkpoint.Index, isPrimaryCheckpoint = Creator.GlobalVar.IsPrimaryCheckpointItems, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
							end
						end
					end
				end
			elseif Client.NUI.Callback == "checkpoint x" then
				if Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview then
					Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if Creator.Checkpoint.IsPickedUp then
						if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						end
						Creator.Function.UpdateBlip("checkpoint")
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
						end
					end
				end
			elseif Client.NUI.Callback == "checkpoint y" then
				if Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview then
					Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if Creator.Checkpoint.IsPickedUp then
						if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						end
						Creator.Function.UpdateBlip("checkpoint")
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
						end
					end
				end
			elseif Client.NUI.Callback == "checkpoint z" then
				if Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview then
					Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if Creator.Checkpoint.IsPickedUp then
						if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						end
						Creator.Function.UpdateBlip("checkpoint")
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
						end
					end
				end
			elseif Client.NUI.Callback == "checkpoint heading" then
				if Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview then
					Creator.Checkpoint.Current.heading = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (Creator.Checkpoint.Current.heading <= -9999.0) or (Creator.Checkpoint.Current.heading >= 9999.0) then
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
						Creator.Checkpoint.Current.heading = 0.0
					end
					if Creator.Checkpoint.IsPickedUp then
						if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						end
						Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading, 3)
						Creator.Function.UpdateBlip("checkpoint")
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
						end
					end
				end
			elseif Client.NUI.Callback == "checkpoint pitch" then
				if Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview then
					Creator.Checkpoint.Current.pitch = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (Creator.Checkpoint.Current.pitch <= -9999.0) or (Creator.Checkpoint.Current.pitch >= 9999.0) then
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
						Creator.Checkpoint.Current.pitch = 0.0
					end
					if Creator.Checkpoint.IsPickedUp then
						if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						end
						Creator.Function.UpdateBlip("checkpoint")
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
						end
					end
				end
			elseif Client.NUI.Callback == "goto prop" then
				local index = math.floor(value)
				local object = Creator.Track.Current.Objects[index]
				if object then
					Creator.Object.Index = index
					Creator.Object.IsPickedUp = true
					if Creator.Object.Preview then
						if Creator.Object.PreviewEffect then
							StopParticleFxLooped(Creator.Object.PreviewEffect, true)
							Creator.Object.PreviewEffect = nil
						end
						DeleteObject(Creator.Object.Preview)
						Creator.Object.Preview = nil
					end
					Creator.Object.Current = object
					Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
					Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
					Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
					Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
					Creator.GlobalVar.PropColor = Creator.Object.Current.color
					Creator.LastValidHash = Creator.Object.Current.hash
					local found = false
					for k, v in pairs(Creator.Data.Category.List) do
						for i = 1, #v.model do
							local hash = tonumber(v.model[i]) or GetHashKey(v.model[i])
							if Creator.LastValidHash == hash then
								found = true
								Creator.LastValidText = v.model[i]
								v.index = i
								Creator.Data.Category.Index = k
								break
							end
						end
						if found then break end
					end
					if not found then
						local hash_2 = tonumber(Creator.LastValidText) or GetHashKey(Creator.LastValidText)
						if Creator.LastValidHash ~= hash_2 then
							Creator.LastValidText = tostring(Creator.LastValidHash) or ""
						end
					end
					local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Object.Current.hash)
					Creator.Camera.Position = vector3(Creator.Object.Current.x + (20.0 - min.z) * math.sin(math.rad(Creator.Object.Current.rotZ)), Creator.Object.Current.y - (20.0 - min.z) * math.cos(math.rad(Creator.Object.Current.rotZ)), Creator.Object.Current.z + (20.0 - min.z))
					Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Object.Current.rotZ}
				end
			elseif Client.NUI.Callback == "prop x" then
				if Creator.Object.Current.handle then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -16000.0) and (newValue < 16000.0) then
						local oldX = Creator.Object.Current.x
						local oldY = Creator.Object.Current.y
						Creator.Object.Current.x = newValue
						SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
						if Creator.Object.IsPickedUp then
							if Creator.Multiplayer.InSession then
								Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
							end
							Creator.Function.Pool.RefreshGirdForObject(oldX, oldY, Creator.Object.Current)
						end
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
					end
				end
			elseif Client.NUI.Callback == "prop y" then
				if Creator.Object.Current.handle then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -16000.0) and (newValue < 16000.0) then
						local oldX = Creator.Object.Current.x
						local oldY = Creator.Object.Current.y
						Creator.Object.Current.y = newValue
						SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
						if Creator.Object.IsPickedUp then
							if Creator.Multiplayer.InSession then
								Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
							end
							Creator.Function.Pool.RefreshGirdForObject(oldX, oldY, Creator.Object.Current)
						end
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
					end
				end
			elseif Client.NUI.Callback == "prop z" then
				if Creator.Object.Current.handle then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -200.0) and (newValue < 2700.0) then
						Creator.Object.Current.z = newValue
						SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
						Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
						if Creator.Object.IsPickedUp then
							if Creator.Multiplayer.InSession then
								Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
							end
						end
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
					end
				end
			elseif Client.NUI.Callback == "prop rotX" then
				if Creator.Object.Current.handle then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -9999.0) and (newValue < 9999.0) then
						Creator.Object.Current.rotX = newValue
						SetEntityRotation(Creator.Object.Current.handle, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, 2, 0)
						if Creator.Object.IsPickedUp then
							if Creator.Multiplayer.InSession then
								Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
							end
							Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
						end
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					end
				end
			elseif Client.NUI.Callback == "prop rotY" then
				if Creator.Object.Current.handle then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -9999.0) and (newValue < 9999.0) then
						Creator.Object.Current.rotY = newValue
						SetEntityRotation(Creator.Object.Current.handle, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, 2, 0)
						if Creator.Object.IsPickedUp then
							if Creator.Multiplayer.InSession then
								Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
							end
							Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
						end
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					end
				end
			elseif Client.NUI.Callback == "prop rotZ" then
				if Creator.Object.Current.handle then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -9999.0) and (newValue < 9999.0) then
						Creator.Object.Current.rotZ = newValue
						SetEntityRotation(Creator.Object.Current.handle, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, 2, 0)
						if Creator.Object.IsPickedUp then
							if Creator.Multiplayer.InSession then
								Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
							end
							Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
						end
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					end
				end
			elseif Client.NUI.Callback == "template x" then
				if #Creator.Template.Preview > 0 then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -16000.0) and (newValue < 16000.0) then
						local aPosNew, aRotNew = vector3(newValue, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
						local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
						Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
					end
				end
			elseif Client.NUI.Callback == "template y" then
				if #Creator.Template.Preview > 0 then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -16000.0) and (newValue < 16000.0) then
						local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, newValue, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
						local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
						Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
					end
				end
			elseif Client.NUI.Callback == "template z" then
				if #Creator.Template.Preview > 0 then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -200.0) and (newValue < 2700.0) then
						local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, newValue), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
						local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
						Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
						Creator.GlobalVar.TemplateZposLock = Creator.Template.Preview[1].z
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
					end
				end
			elseif Client.NUI.Callback == "template rotX" then
				if #Creator.Template.Preview > 0 then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -9999.0) and (newValue < 9999.0) then
						local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(newValue, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
						local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
						Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					end
				end
			elseif Client.NUI.Callback == "template rotY" then
				if #Creator.Template.Preview > 0 then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -9999.0) and (newValue < 9999.0) then
						local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, newValue, Creator.Template.Preview[1].rotZ)
						local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
						Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					end
				end
			elseif Client.NUI.Callback == "template rotZ" then
				if #Creator.Template.Preview > 0 then
					local newValue = Client.Function.Math.RoundedValue(value + 0.0, 3)
					if (newValue > -9999.0) and (newValue < 9999.0) then
						local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, newValue)
						local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
						Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
					else
						Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					end
				end
			elseif Client.NUI.Callback == "goto fixture" then
				local index = math.floor(value)
				local fixture = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Fixtures[index])
				if fixture then
					Creator.Fixture.Index = index
					Creator.Fixture.Current = fixture
					local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Fixture.Current.hash)
					Creator.Camera.Position = vector3(Creator.Fixture.Current.x, Creator.Fixture.Current.y, Creator.Fixture.Current.z + (10.0 + max.z - min.z))
					Creator.Camera.Rotation = {x = -89.9, y = 0.0, z = Creator.Camera.Rotation.z}
				end
			else
				Client.Function.Message.Display(Client.Function.Translate.Get("error-input"))
			end
		else
			local inputData = data.value:gsub("%s+", "")
			local x, y, z, rotX, rotY, rotZ = inputData:match("x=([+-]?%d+%.?%d*),y=([+-]?%d+%.?%d*),z=([+-]?%d+%.?%d*),rotX=([+-]?%d+%.?%d*),rotY=([+-]?%d+%.?%d*),rotZ=([+-]?%d+%.?%d*)")
			if tonumber(x) and tonumber(y) and tonumber(z) and tonumber(rotX) and tonumber(rotY) and tonumber(rotZ) then
				if Client.NUI.Callback == "prop override" then
					if Creator.Object.Current.handle then
						local overflow = false
						local newX = Client.Function.Math.RoundedValue(tonumber(x) + 0.0, 3)
						local newY = Client.Function.Math.RoundedValue(tonumber(y) + 0.0, 3)
						local newZ = Client.Function.Math.RoundedValue(tonumber(z) + 0.0, 3)
						local newRotX = Client.Function.Math.RoundedValue(tonumber(rotX) + 0.0, 3)
						local newRotY = Client.Function.Math.RoundedValue(tonumber(rotY) + 0.0, 3)
						local newRotZ = Client.Function.Math.RoundedValue(tonumber(rotZ) + 0.0, 3)
						if (newX <= -16000.0) or (newX >= 16000.0) or (newY <= -16000.0) or (newY >= 16000.0) then
							overflow = true
							Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
						end
						if (newZ <= -200.0) or (newZ >= 2700.0) then
							overflow = true
							Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
						end
						if (newRotX <= -9999.0) or (newRotX >= 9999.0) or (newRotY <= -9999.0) or (newRotY >= 9999.0) or (newRotZ <= -9999.0) or (newRotZ >= 9999.0) then
							overflow = true
							Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
						end
						if not overflow then
							local oldX = Creator.Object.Current.x
							local oldY = Creator.Object.Current.y
							Creator.Object.Current.x = newX
							Creator.Object.Current.y = newY
							Creator.Object.Current.z = newZ
							Creator.Object.Current.rotX = newRotX
							Creator.Object.Current.rotY = newRotY
							Creator.Object.Current.rotZ = newRotZ
							SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
							SetEntityRotation(Creator.Object.Current.handle, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, 2, 0)
							Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
							if Creator.Object.IsPickedUp then
								if Creator.Multiplayer.InSession then
									Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
									TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
								end
								Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
								Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
								Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
								Creator.Function.Pool.RefreshGirdForObject(oldX, oldY, Creator.Object.Current)
							end
						end
					end
				elseif Client.NUI.Callback == "template override" then
					if #Creator.Template.Preview > 0 then
						local overflow = false
						local newX = Client.Function.Math.RoundedValue(tonumber(x) + 0.0, 3)
						local newY = Client.Function.Math.RoundedValue(tonumber(y) + 0.0, 3)
						local newZ = Client.Function.Math.RoundedValue(tonumber(z) + 0.0, 3)
						local newRotX = Client.Function.Math.RoundedValue(tonumber(rotX) + 0.0, 3)
						local newRotY = Client.Function.Math.RoundedValue(tonumber(rotY) + 0.0, 3)
						local newRotZ = Client.Function.Math.RoundedValue(tonumber(rotZ) + 0.0, 3)
						if (newX <= -16000.0) or (newX >= 16000.0) or (newY <= -16000.0) or (newY >= 16000.0) then
							overflow = true
							Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
						end
						if (newZ <= -200.0) or (newZ >= 2700.0) then
							overflow = true
							Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
						end
						if (newRotX <= -9999.0) or (newRotX >= 9999.0) or (newRotY <= -9999.0) or (newRotY >= 9999.0) or (newRotZ <= -9999.0) or (newRotZ >= 9999.0) then
							overflow = true
							Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
						end
						if not overflow then
							local aPosNew, aRotNew = vector3(newX, newY, newZ), vector3(newRotX, newRotY, newRotZ)
							local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
							Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
							Creator.GlobalVar.TemplateZposLock = Creator.Template.Preview[1].z
						end
					end
				end
			else
				Client.Function.Message.Display(Client.Function.Translate.Get("error-input"))
			end
		end
	end
	Client.NUI.CallbackDisable = true
	CreateThread(function()
		Wait(50)
		SetNuiFocus(false, false)
		Client.NUI.Callback = ""
		Client.NUI.CallbackDisable = false
	end)
end)

RegisterNUICallback("nuiLoaded", function(data, cb)
	Client.NUI.Loaded = true
end)