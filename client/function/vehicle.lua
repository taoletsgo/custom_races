function Client.Function.Vehicle.AddBMXsToData()
	Client.Vehicle.Model.BMX[GetHashKey("bmx")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_1")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_2")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_3")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_4")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_5")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_6")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_7")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_8")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_9")] = true
	Client.Vehicle.Model.BMX[GetHashKey("bmx_10")] = true
end

function Client.Function.Vehicle.AddCrashedModelsToData()
	if GetGameBuildNumber() == 2699 then
		Client.Vehicle.Model.Crashed[GetHashKey("kosatka")] = true
		Client.Vehicle.Model.Crashed[GetHashKey("avisa")] = true
		Client.Vehicle.Model.Crashed[GetHashKey("submersible")] = true
		Client.Vehicle.Model.Crashed[GetHashKey("submersible2")] = true
	end
end

function Client.Function.Vehicle.SetAddOnNames()
	AddTextEntryByHash(GetHashKey("bmx 1"), Client.Function.Translate.Get("bmx-red-blue"))
	AddTextEntryByHash(GetHashKey("bmx 2"), Client.Function.Translate.Get("bmx-yellow"))
	AddTextEntryByHash(GetHashKey("bmx 3"), Client.Function.Translate.Get("bmx-pink"))
	AddTextEntryByHash(GetHashKey("bmx 4"), Client.Function.Translate.Get("bmx-blue"))
	AddTextEntryByHash(GetHashKey("bmx 5"), Client.Function.Translate.Get("bmx-blue-orange"))
	AddTextEntryByHash(GetHashKey("bmx 6"), Client.Function.Translate.Get("bmx-purple"))
	AddTextEntryByHash(GetHashKey("bmx 7"), Client.Function.Translate.Get("bmx-white"))
	AddTextEntryByHash(GetHashKey("bmx 8"), Client.Function.Translate.Get("bmx-red"))
	AddTextEntryByHash(GetHashKey("bmx 9"), Client.Function.Translate.Get("bmx-pink-blue"))
	AddTextEntryByHash(GetHashKey("bmx 10"), Client.Function.Translate.Get("bmx-grey"))
	-- set names for other add-on models
end

function Client.Function.Vehicle.GetAllForMenu()
	Client.Vehicle.AddOnVehicles = {}
	for _, class in pairs(Client.Vehicle.Classes) do
		Client.Vehicle.List[class] = {}
	end
	local models = GetAllVehicleModels()
	for k, v in pairs(models) do
		local hash = GetHashKey(v)
		local class = GetVehicleClassFromName(hash)
		local name = GetDisplayNameFromVehicleModel(hash)
		local label = GetLabelText(name)
		if Client.Vehicle.Model.AddOn[hash] then
			table.insert(Client.Vehicle.AddOnVehicles, {model = hash, label = label ~= "NULL" and label or name, rightLabel = "(" .. v .. ")"})
		elseif Client.Vehicle.Classes[class] and label ~= "NULL" then
			Client.Vehicle.Model.Vanilla[hash] = true
			table.insert(Client.Vehicle.List[Client.Vehicle.Classes[class]], {model = hash, label = label, rightLabel = "(" .. v .. ")"})
		end
	end
	table.sort(Client.Vehicle.AddOnVehicles, function(a, b) return string.lower(a.label) < string.lower(b.label) or (string.lower(a.label) == string.lower(b.label) and string.lower(a.rightLabel) < string.lower(b.rightLabel)) end)
	for k, v in pairs(Client.Vehicle.List) do
		table.sort(v, function(a, b) return string.lower(a.label) < string.lower(b.label) or (string.lower(a.label) == string.lower(b.label) and string.lower(a.rightLabel) < string.lower(b.rightLabel)) end)
	end
end

function Client.Function.Vehicle.SetSavedForMenu()
	Client.Menu.Spawn.SavedVehicles = {}
	for key, savedVehicle in pairs(Client.Vehicle.SavedVehicles) do
		local name = GetDisplayNameFromVehicleModel(savedVehicle.model)
		local label = GetLabelText(name)
		Client.Menu.Spawn.SavedVehicles[savedVehicle.plate] = RageUI.CreateSubMenu(Client.Menu.Spawn.Classes["saved-vehicles"], label ~= "NULL" and label or name, Client.Function.Translate.Get("menu-items"), true)
		if not Client.Vehicle.Model.AddOn[savedVehicle.model] then
			Client.Vehicle.Model.Vanilla[savedVehicle.model] = true
		end
	end
end

function Client.Function.Vehicle.Spawn(model, props, label)
	CreateThread(function()
		if #Client.Vehicle.SpawnedEntitys >= Client.Vehicle.MaxEntitys then
			Client.Function.Message.Display(Client.Function.Translate.Get("spawn-vehicle-failed-1"))
		elseif (not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model)) or (not Client.Vehicle.Model.Vanilla[model] and not Client.Vehicle.Model.AddOn[model]) then
			Client.Function.Message.Display(Client.Function.Translate.Get("spawn-vehicle-failed-2"))
		elseif (Client.Vehicle.Model.Vanilla[model] and not Client.Permission.SpawnVanillaVehicles) or (Client.Vehicle.Model.AddOn[model] and not Client.Permission.SpawnAddOnVehicles) then
			Client.Function.Message.Display(Client.Function.Translate.Get("spawn-vehicle-failed-3"))
		elseif Client.Vehicle.Model.Crashed[model] then
			Client.Function.Message.Display(Client.Function.Translate.Get("spawn-vehicle-failed-4"))
		else
			local success = false
			local ped = PlayerPedId()
			local startTime = GetGameTimer()
			RequestModel(model)
			while not HasModelLoaded(model) and (GetGameTimer() - startTime < 3000) do Wait(0) end
			if HasModelLoaded(model) then
				local pos = GetEntityCoords(ped)
				local heading = GetEntityHeading(ped)
				local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z + 200.0, heading, true, false)
				if DoesEntityExist(vehicle) then
					success = true
					SetVehRadioStation(vehicle, "OFF")
					SetVehicleEngineOn(vehicle, true, true, false)
					Wait(0)
					local lastSpeed, lastRotation, lastVelocity = nil, nil, nil
					if Client.Preference.DeleteWhenSpawnVehicle then
						Client.Function.Vehicle.DeleteCurrent(function(_lastSpeed, _lastRotation, _lastVelocity)
							lastSpeed = _lastSpeed
							lastRotation = _lastRotation
							lastVelocity = _lastVelocity
						end)
					end
					if props then
						Client.Function.Tuning.SetProperties(vehicle, props)
					end
					if label then
						Client.Function.Message.Display(label)
					end
					SetVehicleFuelLevel(vehicle, 100.0)
					SetPedIntoVehicle(ped, vehicle, -1)
					SetEntityCoords(vehicle, pos.x, pos.y, pos.z)
					SetEntityHeading(vehicle, heading)
					if Client.Preference.DeleteWhenSpawnVehicle then
						if lastSpeed then
							SetVehicleForwardSpeed(vehicle, lastSpeed)
						end
						if lastVelocity then
							SetEntityVelocity(vehicle, lastVelocity.x or 0.0, lastVelocity.y or 0.0, lastVelocity.z or 0.0)
						end
						if lastRotation then
							SetEntityRotation(vehicle, lastRotation, 2)
						end
					end
					local netId = NetworkGetNetworkIdFromEntity(vehicle)
					TriggerServerEvent("server:core:spawnEntity", netId)
					Client.Stunt.Vehicle = vehicle
					Client.Stunt.VehicleNetId = netId
					Client.Vehicle.SpawnedEntitys[#Client.Vehicle.SpawnedEntitys + 1] = netId
				end
			end
			if not success then
				Client.Function.Message.Display(Client.Function.Translate.Get("spawn-vehicle-failed-5"))
			end
			SetModelAsNoLongerNeeded(model)
		end
		Client.IsVehicleSpawning = false
	end)
end

function Client.Function.Vehicle.Preview()
	local function spawnVehicle(model, props)
		local startTime = GetGameTimer()
		local vehicle = 0
		RequestModel(model)
		while not HasModelLoaded(model) and (GetGameTimer() - startTime < 3000) do Wait(0) end
		if HasModelLoaded(model) then
			local min, max = Client.Function.Shared.GetModelDimensionsInCaches(model)
			local heading = GetGameplayCamRot(2).z
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped) + (vector3(-math.sin(math.rad(heading)), math.cos(math.rad(heading)), 0.0) * math.max(5.0, (max.y - min.y)))
			vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, heading + 90.0, false, false)
			if DoesEntityExist(vehicle) then
				if props then
					Client.Function.Tuning.SetProperties(vehicle, props)
				end
				SetVehRadioStation(vehicle, "OFF")
				SetEntityCoords(vehicle, pos.x, pos.y, pos.z)
				SetEntityRotation(vehicle, 0.0, 0.0, heading + 90.0, 2, 0)
				SetVehicleDoorsLocked(vehicle, 10)
				SetEntityInvincible(vehicle, true)
				SetEntityCollision(vehicle, false, false)
				SetEntityCompletelyDisableCollision(vehicle, false, false)
				FreezeEntityPosition(vehicle, true)
			end
		end
		SetModelAsNoLongerNeeded(model)
		return vehicle
	end
	local function drawBoxes(vehicle)
		local model = GetEntityModel(vehicle)
		local min, max = Client.Function.Shared.GetModelDimensionsInCaches(model)
		local corners = {
			GetOffsetFromEntityInWorldCoords(vehicle, max.x, max.y, max.z),
			GetOffsetFromEntityInWorldCoords(vehicle, min.x, max.y, max.z),
			GetOffsetFromEntityInWorldCoords(vehicle, max.x, min.y, max.z),
			GetOffsetFromEntityInWorldCoords(vehicle, min.x, min.y, max.z),
			GetOffsetFromEntityInWorldCoords(vehicle, max.x, max.y, min.z),
			GetOffsetFromEntityInWorldCoords(vehicle, min.x, max.y, min.z),
			GetOffsetFromEntityInWorldCoords(vehicle, max.x, min.y, min.z),
			GetOffsetFromEntityInWorldCoords(vehicle, min.x, min.y, min.z)
		}
		local lines = {
			{1, 2}, {2, 4}, {4, 3}, {3, 1},
			{5, 6}, {6, 8}, {8, 7}, {7, 5},
			{1, 5}, {2, 6}, {3, 7}, {4, 8}
		}
		for _, line in ipairs(lines) do
			local p1, p2 = corners[line[1]], corners[line[2]]
			DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, 255, 255, 255, 255)
		end
		local faces = {
			{1, 2, 4}, {4, 3, 1},
			{2, 1, 5}, {5, 6, 2},
			{3, 4, 8}, {8, 7, 3},
			{7, 8, 6}, {6, 5, 7},
			{4, 2, 6}, {6, 8, 4},
			{1, 3, 7}, {7, 5, 1}
		}
		for _, face in ipairs(faces) do
			local p1, p2, p3 = corners[face[1]], corners[face[2]], corners[face[3]]
			DrawPoly(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p3.x, p3.y, p3.z, 255, 255, 255, 50)
		end
	end
	CreateThread(function()
		while true do
			if Client.Vehicle.Preview.Model and IsModelInCdimage(Client.Vehicle.Preview.Model) and IsModelValid(Client.Vehicle.Preview.Model) and IsModelAVehicle(Client.Vehicle.Preview.Model) then
				if Client.Vehicle.Preview.Entity and DoesEntityExist(Client.Vehicle.Preview.Entity) then
					drawBoxes(Client.Vehicle.Preview.Entity)
					if (GetEntityModel(Client.Vehicle.Preview.Entity) ~= Client.Vehicle.Preview.Model) or (Client.Vehicle.Preview.Props and (Client.Vehicle.Preview.Props.plate ~= Client.Function.Math.TrimedValue(GetVehicleNumberPlateText(Client.Vehicle.Preview.Entity)))) then
						DeleteVehicle(Client.Vehicle.Preview.Entity)
						Client.Vehicle.Preview.Entity = spawnVehicle(Client.Vehicle.Preview.Model, Client.Vehicle.Preview.Props)
					end
				else
					Client.Vehicle.Preview.Entity = spawnVehicle(Client.Vehicle.Preview.Model, Client.Vehicle.Preview.Props)
				end
			else
				if Client.Vehicle.Preview.Entity and DoesEntityExist(Client.Vehicle.Preview.Entity) then
					DeleteVehicle(Client.Vehicle.Preview.Entity)
					Client.Vehicle.Preview.Entity = nil
				end
			end
			Wait(0)
		end
	end)
end

function Client.Function.Vehicle.Fix(vehicle)
	if DoesEntityExist(vehicle) then
		SetVehicleUndriveable(vehicle, false)
		SetVehicleEngineCanDegrade(vehicle, false)
		SetVehicleEngineHealth(vehicle, 1000.0)
		SetVehiclePetrolTankHealth(vehicle, 1000.0)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleFixed(vehicle)
		StopEntityFire(vehicle)
		SetVehicleFuelLevel(vehicle, 100.0)
		SetVehicleOilLevel(vehicle, 1.0)
		SetVehicleDirtLevel(vehicle, 0.0)
		SetVehicleDeformationFixed(vehicle)
	end
end

function Client.Function.Vehicle.DeleteCurrent(cb)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if DoesEntityExist(vehicle) then
		local netId = NetworkGetNetworkIdFromEntity(vehicle)
		if cb ~= nil then
			local lastSpeed = GetEntitySpeed(vehicle)
			local lastRotation = GetEntityRotation(vehicle, 2)
			local lastVelocity = GetEntityVelocity(vehicle)
			cb(lastSpeed, lastRotation, lastVelocity)
		end
		SetVehicleAsNoLongerNeeded(vehicle)
		SetEntityAsMissionEntity(vehicle, true, true)
		DeleteVehicle(vehicle)
		DeleteEntity(vehicle)
		TriggerServerEvent("server:core:deleteEntity", netId)
		for k, v in pairs(Client.Vehicle.SpawnedEntitys) do
			if netId == v then
				table.remove(Client.Vehicle.SpawnedEntitys, k)
				break
			end
		end
	end
end

function Client.Function.Vehicle.DeleteAll()
	for k, v in pairs(Client.Vehicle.SpawnedEntitys) do
		local entity = NetworkDoesNetworkIdExist(v) and NetworkDoesEntityExistWithNetworkId(v) and NetworkGetEntityFromNetworkId(v)
		if DoesEntityExist(entity) then
			SetVehicleAsNoLongerNeeded(entity)
			SetEntityAsMissionEntity(entity, true, true)
			DeleteVehicle(entity)
			DeleteEntity(entity)
		end
	end
	Client.Vehicle.SpawnedEntitys = {}
	TriggerServerEvent("server:core:deleteAllEntitys")
end