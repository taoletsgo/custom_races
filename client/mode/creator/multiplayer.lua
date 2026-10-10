function Creator.Function.Multiplayer.LoadSessionData(data, data_2)
	Creator.ObjectPool.IsRefreshing = true
	Client.Function.Busyspinner.Display("parse", 10000, #data.Objects + 10000)
	for classid = 0, 27 do
		for i = 1, #data.AvailableVehicles[classid].vehicles do
			data.AvailableVehicles[classid].vehicles[i].name = GetLabelText(GetDisplayNameFromVehicleModel(data.AvailableVehicles[classid].vehicles[i].hash))
		end
	end
	Creator.Track.Current = data
	Creator.Multiplayer.ModificationCount = data_2
	Client.Function.Blimp.SetText(Client.Blimp.Scaleform, Creator.Track.Current.BlimpText)
	Creator.Firework.ParticleIndex = 1
	for i = 1, #Creator.Firework.Particles do
		if Creator.Firework.Particles[i] == Creator.Track.Current.Firework.Name then
			Creator.Firework.ParticleIndex = i
			break
		end
	end
	Creator.StartingGrid.Index = #Creator.Track.Current.StartingGrid
	for k, v in pairs(Creator.Track.Current.StartingGrid) do
		v.handle = nil
	end
	Creator.Checkpoint.Index = #Creator.Track.Current.Checkpoints
	Creator.Blips.Checkpoints = {}
	Creator.Blips.Checkpoints_2 = {}
	for k, v in pairs(Creator.Track.Current.Checkpoints) do
		Creator.Blips.Checkpoints[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
	end
	for k, v in pairs(Creator.Track.Current.Checkpoints_2) do
		Creator.Blips.Checkpoints_2[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
	end
	Creator.Fixture.Index = #Creator.Track.Current.Fixtures
	Wait(1000)
	local count = 0
	for k, v in pairs(Creator.Track.Current.Objects) do
		v.handle = nil
		local gx = math.floor(v.x / 100.0)
		local gy = math.floor(v.y / 100.0)
		Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
		Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
		Creator.ObjectPool.Grids[gx][gy][v.uniqueId] = v
		Creator.ObjectPool.All[v.uniqueId] = gx .. "-" .. gy
		if Client.Shared.Object.Effect[v.hash] then
			Creator.ObjectPool.Effects[v.uniqueId] = {ptfxHandle = nil, object = v, style = Client.Shared.Object.Effect[v.hash]}
		end
		count = count + 1
		if count >= 10000 then
			count = 0
			Wait(1000)
		end
	end
	Creator.Object.Index = #Creator.Track.Current.Objects
	Creator.ObjectPool.IsRefreshing = false
	if Creator.Track.Current.StartingGrid[1] then
		local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
		local model = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
		local min, max = Client.Function.Shared.GetModelDimensionsInCaches(model)
		Creator.Camera.Position = vector3(Creator.Track.Current.StartingGrid[1].x + (20.0 - min.z) * math.sin(math.rad(Creator.Track.Current.StartingGrid[1].heading)), Creator.Track.Current.StartingGrid[1].y - (20.0 - min.z) * math.cos(math.rad(Creator.Track.Current.StartingGrid[1].heading)), Creator.Track.Current.StartingGrid[1].z + (20.0 - min.z))
		Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Track.Current.StartingGrid[1].heading}
	elseif Creator.Track.Current.Objects[1] then
		local model = tonumber(Creator.Track.Current.Objects[1].hash) or GetHashKey(Creator.Track.Current.Objects[1].hash)
		local min, max = Client.Function.Shared.GetModelDimensionsInCaches(model)
		Creator.Camera.Position = vector3(Creator.Track.Current.Objects[1].x + (20.0 - min.z) * math.sin(math.rad(Creator.Track.Current.Objects[1].rotZ)), Creator.Track.Current.Objects[1].y - (20.0 - min.z) * math.cos(math.rad(Creator.Track.Current.Objects[1].rotZ)), Creator.Track.Current.Objects[1].z + (20.0 - min.z))
		Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Track.Current.Objects[1].rotZ}
	end
end

function Creator.Function.Multiplayer.UpdateStartingGrid(data)
	if Creator.StartingGrid.IsMenuVisible then
		for k, v in pairs(Creator.Track.Current.StartingGrid) do
			if v.handle then
				SetEntityDrawOutline(v.handle, false)
				DeleteVehicle(v.handle)
			end
		end
	end
	Creator.Track.Current.StartingGrid = data.startingGrid
	if Creator.StartingGrid.IsMenuVisible then
		for k, v in pairs(Creator.Track.Current.StartingGrid) do
			local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
			local model = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
			v.handle = Creator.Function.CreateVehicle(model, v.x, v.y, v.z, v.heading)
			ResetEntityAlpha(v.handle)
			SetEntityDrawOutlineColor(255, 255, 255, 125)
			SetEntityDrawOutlineShader(1)
			SetEntityDrawOutline(v.handle, true)
		end
	end
	if Creator.StartingGrid.IsPickedUp then
		if not data.deleteIndex then
			if Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] then
				Creator.StartingGrid.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index])
				Creator.StartingGrid.Select = Creator.StartingGrid.Current.handle
				SetEntityDrawOutline(Creator.StartingGrid.Select, false)
				SetEntityAlpha(Creator.StartingGrid.Select, 150)
			else
				Creator.StartingGrid.IsPickedUp = false
				Creator.StartingGrid.Select = nil
				Creator.Function.ResetGlobalVariable("startingGrid")
			end
		else
			if data.deleteIndex == Creator.StartingGrid.Index then
				Creator.StartingGrid.IsPickedUp = false
				Creator.StartingGrid.Select = nil
				Creator.Function.ResetGlobalVariable("startingGrid")
			elseif data.deleteIndex > Creator.StartingGrid.Index then
				if Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] then
					Creator.StartingGrid.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index])
					Creator.StartingGrid.Select = Creator.StartingGrid.Current.handle
					SetEntityDrawOutline(Creator.StartingGrid.Select, false)
					SetEntityAlpha(Creator.StartingGrid.Select, 150)
				else
					Creator.StartingGrid.IsPickedUp = false
					Creator.StartingGrid.Select = nil
					Creator.Function.ResetGlobalVariable("startingGrid")
				end
			elseif data.deleteIndex < Creator.StartingGrid.Index then
				if Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index - 1] then
					Creator.StartingGrid.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index - 1])
					Creator.StartingGrid.Select = Creator.StartingGrid.Current.handle
					SetEntityDrawOutline(Creator.StartingGrid.Select, false)
					SetEntityAlpha(Creator.StartingGrid.Select, 150)
					Creator.StartingGrid.Index = Creator.StartingGrid.Index - 1
				else
					Creator.StartingGrid.IsPickedUp = false
					Creator.StartingGrid.Select = nil
					Creator.Function.ResetGlobalVariable("startingGrid")
				end
			end
		end
	end
	if (Creator.StartingGrid.Index > #Creator.Track.Current.StartingGrid) or (Creator.StartingGrid.Index == 0 and #Creator.Track.Current.StartingGrid > 0) then
		Creator.StartingGrid.Index = #Creator.Track.Current.StartingGrid
	end
end

function Creator.Function.Multiplayer.UpdateCheckpoint(data)
	Creator.Track.Current.Checkpoints = data.checkpoints
	Creator.Track.Current.Checkpoints_2 = data.checkpoints_2
	if Creator.Checkpoint.IsPickedUp then
		if not data.insertIndex and not data.deleteIndex then
			if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
				Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index])
			elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
				Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
			else
				Creator.Checkpoint.IsPickedUp = false
				Creator.Function.ResetGlobalVariable("checkpoint")
			end
		elseif data.insertIndex then
			if data.insertIndex <= Creator.Checkpoint.Index then
				if Creator.GlobalVar.IsPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index + 1] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index + 1])
						Creator.Checkpoint.Index = Creator.Checkpoint.Index + 1
					elseif not data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index])
					else
						Creator.Checkpoint.IsPickedUp = false
						Creator.Function.ResetGlobalVariable("checkpoint")
					end
				else
					if data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index + 1] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index + 1])
						Creator.Checkpoint.Index = Creator.Checkpoint.Index + 1
					elseif not data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
					else
						Creator.Checkpoint.IsPickedUp = false
						Creator.Function.ResetGlobalVariable("checkpoint")
					end
				end
			elseif data.insertIndex > Creator.Checkpoint.Index then
				if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
					Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index])
				elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
					Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
				else
					Creator.Checkpoint.IsPickedUp = false
					Creator.Function.ResetGlobalVariable("checkpoint")
				end
			end
		elseif data.deleteIndex then
			if data.deleteIndex == Creator.Checkpoint.Index then
				if Creator.GlobalVar.IsPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint then
						Creator.Checkpoint.IsPickedUp = false
						Creator.Function.ResetGlobalVariable("checkpoint")
					else
						if Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
							Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index])
						else
							Creator.Checkpoint.IsPickedUp = false
							Creator.Function.ResetGlobalVariable("checkpoint")
						end
					end
				else
					Creator.Checkpoint.IsPickedUp = false
					Creator.Function.ResetGlobalVariable("checkpoint")
				end
			elseif data.deleteIndex < Creator.Checkpoint.Index then
				if Creator.GlobalVar.IsPrimaryCheckpointItems then
					if data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index - 1] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index - 1])
						Creator.Checkpoint.Index = Creator.Checkpoint.Index - 1
					elseif not data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index])
					else
						Creator.Checkpoint.IsPickedUp = false
						Creator.Function.ResetGlobalVariable("checkpoint")
					end
				else
					if data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index - 1] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index - 1])
						Creator.Checkpoint.Index = Creator.Checkpoint.Index - 1
					elseif not data.isPrimaryCheckpoint and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
					else
						Creator.Checkpoint.IsPickedUp = false
						Creator.Function.ResetGlobalVariable("checkpoint")
					end
				end
			elseif data.deleteIndex > Creator.Checkpoint.Index then
				if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
					Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index])
				elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
					Creator.Checkpoint.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
				else
					Creator.Checkpoint.IsPickedUp = false
					Creator.Function.ResetGlobalVariable("checkpoint")
				end
			end
		end
	end
	if (Creator.Checkpoint.Index > #Creator.Track.Current.Checkpoints) or (Creator.Checkpoint.Index == 0 and #Creator.Track.Current.Checkpoints > 0) then
		Creator.Checkpoint.Index = #Creator.Track.Current.Checkpoints
	end
	if not Creator.GlobalVar.EnableTest then
		Creator.Function.UpdateBlip("checkpoint")
	else
		if Creator.GlobalVar.RespawnData then
			if data.insertIndex then
				if data.insertIndex <= Creator.GlobalVar.RespawnData.Index then
					Creator.GlobalVar.RespawnData.Index = ((Creator.GlobalVar.RespawnData.Index + 1) <= #Creator.Track.Current.Checkpoints) and (Creator.GlobalVar.RespawnData.Index + 1) or #Creator.Track.Current.Checkpoints
				end
				if data.insertIndex < Creator.GlobalVar.RespawnData.DrawIndex then
					Creator.GlobalVar.RespawnData.DrawIndex = ((Creator.GlobalVar.RespawnData.DrawIndex + 1) <= #Creator.Track.Current.Checkpoints) and (Creator.GlobalVar.RespawnData.DrawIndex + 1) or #Creator.Track.Current.Checkpoints
				end
			elseif data.deleteIndex then
				if data.deleteIndex <= Creator.GlobalVar.RespawnData.Index then
					Creator.GlobalVar.RespawnData.Index = ((Creator.GlobalVar.RespawnData.Index - 1) >= 0) and (Creator.GlobalVar.RespawnData.Index - 1) or 0
				end
				if data.deleteIndex < Creator.GlobalVar.RespawnData.DrawIndex then
					Creator.GlobalVar.RespawnData.DrawIndex = ((Creator.GlobalVar.RespawnData.DrawIndex - 1) >= 1) and (Creator.GlobalVar.RespawnData.DrawIndex - 1) or 1
				end
			end
		end
		if Creator.GlobalVar.TipsRendered then
			Creator.Function.ResetCheckpointAndBlip()
			Creator.GlobalVar.TestData.Checkpoints = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints) or {}
			Creator.GlobalVar.TestData.Checkpoints_2 = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2) or {}
			Creator.Function.CreateCheckpointBlip(Creator.GlobalVar.RespawnData.DrawIndex)
			Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, false)
			Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, true)
		end
	end
end

function Creator.Function.Multiplayer.UpdateFixture(data)
	Creator.Track.Current.Fixtures = data.fixtures
	if (Creator.Fixture.Index > #Creator.Track.Current.Fixtures) or (Creator.Fixture.Index == 0 and #Creator.Track.Current.Fixtures > 0) then
		Creator.Fixture.Index = #Creator.Track.Current.Fixtures
	end
end

function Creator.Function.Multiplayer.UpdateFirework(data)
	Creator.Track.Current.Firework.Name = data.firework.Name or "scr_indep_firework_trailburst"
	Creator.Track.Current.Firework.R = data.firework.R or 255
	Creator.Track.Current.Firework.G = data.firework.G or 255
	Creator.Track.Current.Firework.B = data.firework.B or 255
	for i = 1, #Creator.Firework.Particles do
		if Creator.Firework.Particles[i] == Creator.Track.Current.Firework.Name then
			Creator.Firework.ParticleIndex = i
			break
		end
	end
end

function Creator.Function.Multiplayer.SendPreview()
	CreateThread(function()
		while Client.IsInCreator and not Client.IsCreatorInQuiting do
			local time = 1000
			if Creator.Multiplayer.InSession and Creator.Track.Current.RaceId and #Creator.Multiplayer.InSessionPlayers > 1 then
				if Creator.StartingGrid.Preview and Creator.StartingGrid.Current.x then
					time = 50
					local data = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
					data.playerId = Client.ServerId
					data.preview = "startingGrid"
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, data, "creator-preview")
				elseif Creator.Checkpoint.Preview and Creator.Checkpoint.Current.x then
					time = 50
					local data = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					data.playerId = Client.ServerId
					data.preview = "checkpoint"
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, data, "creator-preview")
				elseif Creator.Object.Preview and Creator.Object.Current.x then
					time = 50
					local data = Client.Function.Shared.TableDeepCopy(Creator.Object.Current)
					data.playerId = Client.ServerId
					data.preview = "object"
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, data, "creator-preview")
				else
					time = 200
				end
			end
			Wait(time)
		end
	end)
end

function Creator.Function.Multiplayer.ReceivePreview(data)
	if not data.x then return end
	if data.preview == "startingGrid" then
		for k, v in pairs(Creator.Multiplayer.InSessionPlayers) do
			if v.playerId == data.playerId then
				local oldVeh = v.vehiclePreview
				if oldVeh and DoesEntityExist(oldVeh) then
					DeleteVehicle(oldVeh)
				end
				local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
				local model = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
				local newVeh = Creator.Function.CreateVehicle(model, data.x, data.y, data.z, data.heading, 0)
				SetEntityCollision(newVeh, false, false)
				v.vehiclePreview = newVeh
				CreateThread(function()
					Wait(300)
					if newVeh and DoesEntityExist(newVeh) then
						DeleteVehicle(newVeh)
					end
				end)
				break
			end
		end
	elseif data.preview == "checkpoint" then
		for k, v in pairs(Creator.Multiplayer.InSessionPlayers) do
			if v.playerId == data.playerId then
				v.checkpointPreview = data
				v.receiveTime = GetGameTimer()
				break
			end
		end
	elseif data.preview == "object" then
		for k, v in pairs(Creator.Multiplayer.InSessionPlayers) do
			if v.playerId == data.playerId then
				local oldObj = v.objectPreview
				if oldObj and DoesEntityExist(oldObj) then
					DeleteObject(oldObj)
				end
				local newObj = Creator.Function.CreateObject(data.hash, data.x, data.y, data.z, data.rotX, data.rotY, data.rotZ, data.color)
				SetEntityAlpha(newObj, 150)
				SetEntityLodDist(newObj, 16960)
				SetEntityCollision(newObj, false, false)
				FreezeEntityPosition(newObj, true)
				v.objectPreview = newObj
				CreateThread(function()
					Wait(300)
					if newObj and DoesEntityExist(newObj) then
						DeleteObject(newObj)
					end
				end)
				break
			end
		end
	end
end

RegisterNetEvent("client:creator:receiveInvitation", function(title, sessionId, playerName)
	if title and sessionId and playerName then
		local found = false
		for k, v in pairs(Creator.Multiplayer.InvitationList) do
			if v.sessionId == sessionId then
				found = true
				break
			end
		end
		if not found then
			table.insert(Creator.Multiplayer.InvitationList, {title = title, sessionId = sessionId})
		end
		Client.Function.Message.Display(string.format(Client.Function.Translate.Get("receive-invitation"), playerName, title))
	end
end)

RegisterNetEvent("client:creator:playerJoinSession", function(playerName, id)
	if not Client.IsInCreator or Client.IsCreatorInQuiting then return end
	Creator.Multiplayer.LockSession = true
	table.insert(Creator.Multiplayer.LoadingPlayers, id)
	table.insert(Creator.Multiplayer.InSessionPlayers, {playerId = id, playerName = playerName})
	Client.Function.Message.Display(string.format(Client.Function.Translate.Get("join-session"), playerName or id))
	CreateThread(function()
		Wait(10000)
		while Creator.Multiplayer.LockSession do
			if not Client.Busyspinner.Status then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("join-session-wait"), playerName or id))
			end
			Wait(10000)
		end
	end)
end)

RegisterNetEvent("client:creator:loadDone", function(id)
	if not Client.IsInCreator or Client.IsCreatorInQuiting then return end
	for k, v in pairs(Creator.Multiplayer.LoadingPlayers) do
		if v == id then
			table.remove(Creator.Multiplayer.LoadingPlayers, k)
			break
		end
	end
	if #Creator.Multiplayer.LoadingPlayers == 0 then
		Creator.Multiplayer.LockSession = false
	end
end)

RegisterNetEvent("client:creator:playerLeaveSession", function(playerName, id)
	if not Client.IsInCreator or Client.IsCreatorInQuiting then return end
	for k, v in pairs(Creator.Multiplayer.LoadingPlayers) do
		if v == id then
			table.remove(Creator.Multiplayer.LoadingPlayers, k)
			break
		end
	end
	if #Creator.Multiplayer.LoadingPlayers == 0 then
		Creator.Multiplayer.LockSession = false
	end
	for k, v in pairs(Creator.Multiplayer.InSessionPlayers) do
		if v.playerId == id then
			table.remove(Creator.Multiplayer.InSessionPlayers, k)
			break
		end
	end
	Client.Function.Message.Display(string.format(Client.Function.Translate.Get("left-session"), playerName or id))
end)

RegisterNetEvent("client:creator:syncSession", function(data, str, playerName, rollback)
	if not Client.IsInCreator or Client.IsCreatorInQuiting or not Creator.Multiplayer.InSession then return end
	while Creator.GlobalVar.QuitingTest or Creator.GlobalVar.JoiningTest or Creator.ObjectPool.IsRefreshing do Wait(0) end
	if rollback then
		Client.Function.Message.Display(Client.Function.Translate.Get("session-data-rollback"))
	end
	if str == "published-status" then
		if not data.published then return end
		Creator.Track.Current.Published = data.published == "√"
		if playerName and data.action then
			if data.action == "publish" then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("published-status-publish"), playerName))
			elseif data.action == "update" then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("published-status-update"), playerName))
			elseif data.action == "save" then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("published-status-save"), playerName))
			elseif data.action == "cancel" then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("published-status-cancel"), playerName))
			elseif data.action == "export" then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("published-status-export"), playerName))
			end
			if not (Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index]) then
				local hash = tonumber(Creator.Track.Current.TestVehicle) or GetHashKey(Creator.Track.Current.TestVehicle)
				if not IsModelInCdimage(hash) or not IsModelValid(hash) or not IsModelAVehicle(hash) then
					Creator.Track.Current.AvailableVehicles[13].vehicles[1].enabled = true
					Creator.Track.Current.AvailableVehicles[13].index = 1
					Creator.Track.Current.DefaultClass = 13
				else
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
				end
			end
		end
	elseif str == "title-sync" then
		if not data.title then return end
		Creator.Multiplayer.ModificationCount.title = data.modificationCount
		Creator.Track.Current.Title = data.title
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("title-sync"), playerName, data.title))
		end
	elseif str == "thumbnail-sync" then
		if not data.thumbnail then return end
		Creator.Multiplayer.ModificationCount.thumbnail = data.modificationCount
		Creator.Track.Current.Thumbnail = data.thumbnail
		SendNUIMessage({
			action = "thumbnail url",
			url = Creator.Track.Current.Thumbnail
		})
		Creator.GlobalVar.QueryingThumbnail = true
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("thumbnail-sync"), playerName))
		end
	elseif str == "test-vehicle-sync" then
		if not data.testVehicle then return end
		Creator.Multiplayer.ModificationCount.testVehicle = data.modificationCount
		local hash = tonumber(data.testVehicle) or GetHashKey(data.testVehicle)
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
		Creator.Track.Current.TestVehicle = data.testVehicle
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("test-vehicle-sync"), playerName, GetLabelText(GetDisplayNameFromVehicleModel(hash))))
		end
	elseif str == "available-vehicles-sync" then
		if not data.availableVehicles then return end
		Creator.Multiplayer.ModificationCount.availableVehicles = data.modificationCount
		Creator.Track.Current.DefaultClass = data.defaultClass
		for classid = 0, 27 do
			for i = 1, #data.availableVehicles[classid].vehicles do
				data.availableVehicles[classid].vehicles[i].name = GetLabelText(GetDisplayNameFromVehicleModel(data.availableVehicles[classid].vehicles[i].hash))
			end
		end
		Creator.Track.Current.AvailableVehicles = data.availableVehicles
	elseif str == "blimp-text-sync" then
		if not data.blimpText then return end
		Creator.Multiplayer.ModificationCount.blimpText = data.modificationCount
		Creator.Track.Current.BlimpText = data.blimpText
		Client.Function.Blimp.SetText(Client.Blimp.Scaleform, Creator.Track.Current.BlimpText)
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("blimp-text-sync"), playerName, data.blimpText))
		end
	elseif str == "transformVehicles-sync" then
		if not data.transformVehicles then return end
		Creator.Multiplayer.ModificationCount.transformVehicles = data.modificationCount
		if not Creator.Checkpoint.IsPickedUp and Creator.Checkpoint.Current.isTransform then
			local previewHash = Creator.Track.Current.TransformVehicles[Creator.Checkpoint.Current.transformIndex + 1]
			local found = false
			for k, v in pairs(data.transformVehicles) do
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
		Creator.Track.Current.TransformVehicles = data.transformVehicles
		Creator.Function.Multiplayer.UpdateCheckpoint(data)
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("transformVehicles-sync"), playerName))
		end
	elseif str == "startingGrid-sync" then
		if not data.startingGrid then return end
		Creator.Multiplayer.ModificationCount.startingGrid = data.modificationCount
		Creator.Function.Multiplayer.UpdateStartingGrid(data)
		if playerName then
			if data.insertIndex then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("startingGrid-insert"), playerName, data.insertIndex))
			elseif data.deleteIndex then
				Client.Function.Message.Display(string.format(Client.Function.Translate.Get("startingGrid-delete"), playerName, data.deleteIndex))
			end
		end
	elseif str == "checkpoints-sync" then
		if not data.checkpoints then return end
		Creator.Multiplayer.ModificationCount.checkpoints = data.modificationCount
		Creator.Function.Multiplayer.UpdateCheckpoint(data)
		if playerName then
			if data.insertIndex then
				if data.isPrimaryCheckpoint then
					Client.Function.Message.Display(string.format(Client.Function.Translate.Get("checkpoints-insert-primary"), playerName, data.insertIndex))
				else
					Client.Function.Message.Display(string.format(Client.Function.Translate.Get("checkpoints-insert-secondary"), playerName, data.insertIndex))
				end
			elseif data.deleteIndex then
				if data.isPrimaryCheckpoint then
					Client.Function.Message.Display(string.format(Client.Function.Translate.Get("checkpoints-delete-primary"), playerName, data.deleteIndex))
				else
					Client.Function.Message.Display(string.format(Client.Function.Translate.Get("checkpoints-delete-secondary"), playerName, data.deleteIndex))
				end
			end
		end
	elseif str == "fixtures-sync" then
		if not data.fixtures then return end
		Creator.Multiplayer.ModificationCount.fixtures = data.modificationCount
		Creator.Function.Multiplayer.UpdateFixture(data)
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("fixtures-sync"), playerName))
		end
	elseif str == "firework-sync" then
		if not data.firework then return end
		Creator.Multiplayer.ModificationCount.firework = data.modificationCount
		Creator.Function.Multiplayer.UpdateFirework(data)
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("firework-sync"), playerName))
		end
	elseif str == "creator-preview" then
		if (type(data) ~= "table") then return end
		Creator.Function.Multiplayer.ReceivePreview(data)
	elseif str == "objects-place" then
		if (type(data) ~= "table") then return end
		local object = data
		object.handle = nil
		local gx = math.floor(object.x / 100.0)
		local gy = math.floor(object.y / 100.0)
		Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
		Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
		Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
		Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
		if Client.Shared.Object.Effect[object.hash] then
			Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
		end
		Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
		if Creator.Object.Index == 0 and #Creator.Track.Current.Objects > 0 then
			Creator.Object.Index = #Creator.Track.Current.Objects
		end
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("objects-place"), playerName, Client.Function.Translate.GetObjectLabelText(data.hash), data.hash, data.x, data.y, data.z))
		end
	elseif str == "objects-change" then
		if (type(data) ~= "table") then return end
		for k, v in pairs(Creator.Track.Current.Objects) do
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
				Creator.ObjectPool.ChangedObjects[v.uniqueId] = true
				Creator.Function.Pool.RefreshGirdForObject(x, y, v)
				break
			end
		end
	elseif str == "objects-delete" then
		if (type(data) ~= "table") or not data.uniqueId then return end
		for k, v in pairs(Creator.Track.Current.Objects) do
			if v.uniqueId == data.uniqueId then
				if playerName then
					Client.Function.Message.Display(string.format(Client.Function.Translate.Get("objects-delete"), playerName, k, Client.Function.Translate.GetObjectLabelText(v.hash), v.hash, v.x, v.y, v.z))
				end
				table.remove(Creator.Track.Current.Objects, k)
				break
			end
		end
		Creator.ObjectPool.All[data.uniqueId] = nil
		Creator.ObjectPool.Effects[data.uniqueId] = nil
		for uniqueId, effectData in pairs(Creator.ObjectPool.ActiveEffects) do
			if uniqueId == data.uniqueId then
				if effectData.ptfxHandle then
					StopParticleFxLooped(effectData.ptfxHandle, true)
					effectData.ptfxHandle = nil
				end
				Creator.ObjectPool.ActiveEffects[uniqueId] = nil
				break
			end
		end
		for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
			if uniqueId == data.uniqueId then
				if object.handle then
					DeleteObject(object.handle)
					object.handle = nil
				end
				Creator.ObjectPool.ActiveObjects[uniqueId] = nil
				break
			end
		end
		local gx = math.floor(data.x / 100.0)
		local gy = math.floor(data.y / 100.0)
		if Creator.ObjectPool.Grids[gx] and Creator.ObjectPool.Grids[gx][gy] then
			Creator.ObjectPool.Grids[gx][gy][data.uniqueId] = nil
		end
		if Creator.Object.IsPickedUp then
			if Creator.Object.Current.uniqueId == data.uniqueId then
				Creator.Object.IsPickedUp = false
				Creator.Function.ResetGlobalVariable("object")
			else
				for k, v in pairs(Creator.Track.Current.Objects) do
					if v.uniqueId == Creator.Object.Current.uniqueId then
						Creator.Object.Index = k
						break
					end
				end
			end
		end
		if Creator.Object.Index > #Creator.Track.Current.Objects then
			Creator.Object.Index = #Creator.Track.Current.Objects
		end
	elseif str == "template-place" then
		if (type(data) ~= "table") then return end
		for i = 1, #data do
			local object = data[i]
			object.handle = nil
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
			Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
			Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			if Client.Shared.Object.Effect[object.hash] then
				Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
			end
			Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
		end
		if Creator.Object.Index == 0 and #Creator.Track.Current.Objects > 0 then
			Creator.Object.Index = #Creator.Track.Current.Objects
		end
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("template-place"), playerName, #data))
		end
	elseif str == "move-all" then
		if (type(data) ~= "table") then return end
		for k, v in pairs(Creator.Track.Current.StartingGrid) do
			v.x = Client.Function.Math.RoundedValue(v.x + data.offsetX, 3)
			v.y = Client.Function.Math.RoundedValue(v.y + data.offsetY, 3)
			v.z = Client.Function.Math.RoundedValue(v.z + data.offsetZ, 3)
		end
		Creator.StartingGrid.Current = Creator.StartingGrid.IsPickedUp and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index]) or Creator.StartingGrid.Current
		for k, v in pairs(Creator.Track.Current.Checkpoints) do
			v.x = Client.Function.Math.RoundedValue(v.x + data.offsetX, 3)
			v.y = Client.Function.Math.RoundedValue(v.y + data.offsetY, 3)
			v.z = Client.Function.Math.RoundedValue(v.z + data.offsetZ, 3)
			local v_2 = Creator.Track.Current.Checkpoints_2[k]
			if v_2 then
				v_2.x = Client.Function.Math.RoundedValue(v_2.x + data.offsetX, 3)
				v_2.y = Client.Function.Math.RoundedValue(v_2.y + data.offsetY, 3)
				v_2.z = Client.Function.Math.RoundedValue(v_2.z + data.offsetZ, 3)
			end
		end
		Creator.Checkpoint.Current = Creator.Checkpoint.IsPickedUp and (Creator.GlobalVar.IsPrimaryCheckpointItems and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index]) or Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])) or Creator.Checkpoint.Current
		for k, v in pairs(Creator.Track.Current.Objects) do
			v.x = Client.Function.Math.RoundedValue(v.x + data.offsetX, 3)
			v.y = Client.Function.Math.RoundedValue(v.y + data.offsetY, 3)
			v.z = Client.Function.Math.RoundedValue(v.z + data.offsetZ, 3)
			Creator.ObjectPool.ChangedObjects[v.uniqueId] = true
		end
		if not Creator.GlobalVar.EnableTest then
			Creator.Function.UpdateBlip("checkpoint")
		else
			if Creator.GlobalVar.TipsRendered then
				Creator.Function.ResetCheckpointAndBlip()
				Creator.GlobalVar.TestData.Checkpoints = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints) or {}
				Creator.GlobalVar.TestData.Checkpoints_2 = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2) or {}
				Creator.Function.CreateCheckpointBlip(Creator.GlobalVar.RespawnData.DrawIndex)
				Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, false)
				Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, true)
			end
		end
		if playerName then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("move-all"), playerName, data.offsetX, data.offsetY, data.offsetZ))
		end
	end
end)