function Client.Function.Shared.GetModelDimensionsInCaches(hash)
	if not Client.Shared.Dimensions.Min[hash] or not Client.Shared.Dimensions.Max[hash] then
		if IsModelInCdimage(hash) and IsModelValid(hash) then
			RequestModel(hash)
			while not HasModelLoaded(hash) do Wait(0) end
			local min, max = GetModelDimensions(hash)
			Client.Shared.Dimensions.Min[hash] = min
			Client.Shared.Dimensions.Max[hash] = max
			Client.Shared.Dimensions.Radius[hash] = math.sqrt((max.x - min.x)^2 + (max.y - min.y)^2 + (max.z - min.z)^2) * 0.5
			SetModelAsNoLongerNeeded(hash)
		end
	end
	return Client.Shared.Dimensions.Min[hash] or vector3(0.0, 0.0, 0.0), Client.Shared.Dimensions.Max[hash] or vector3(0.0, 0.0, 0.0), Client.Shared.Dimensions.Radius[hash] or 0.0
end

function Client.Function.Shared.TableDeepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[Client.Function.Shared.TableDeepCopy(orig_key)] = Client.Function.Shared.TableDeepCopy(orig_value)
		end
		setmetatable(copy, Client.Function.Shared.TableDeepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

function Client.Function.Shared.GetRandomVehicleModel(transformVehicles, randomVehicles, randomClass, randomCustom, randomSetting)
	local model = 0
	local availableVehModels = {}
	local allVehModels = GetAllVehicleModels()
	if randomClass >= 0 then
		if randomClass == 0 then -- land
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if randomVehicles[hash] and (class <= 13 or class >= 17) and (class ~= 21) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif randomClass == 1 then -- plane
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if class == 15 or class == 16 then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif randomClass == 2 then -- boat
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if class == 14 then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif randomClass == 3 then -- plane + land
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if (class == 15 or class == 16) or (randomVehicles[hash] and (class <= 13 or class >= 17) and (class ~= 21)) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		end
	elseif randomClass == -1 then
		if randomCustom == 1 then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if randomSetting == Client.Vehicle.Classes[class] then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif randomCustom == 2 then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				local class = GetVehicleClassFromName(hash)
				if Client.Function.Math.IsBitSetValue(randomSetting, class) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif randomCustom == 3 then
			for _, model in pairs(randomSetting) do
				local hash = tonumber(model) or GetHashKey(model)
				if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		elseif randomCustom == 4 then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				if IsThisModelACar(hash) then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		end
	elseif randomClass == -2 then
		local isKnownUnknowns = false
		for k, v in pairs(transformVehicles) do
			local hash = tonumber(v) or GetHashKey(v)
			if hash ~= 0 then
				isKnownUnknowns = true
				break
			end
		end
		if not isKnownUnknowns then
			for k, v in pairs(allVehModels) do
				local hash = GetHashKey(v)
				if randomVehicles[hash] then
					local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
					if label ~= "NULL" then
						table.insert(availableVehModels, hash)
					end
				end
			end
		else
			local seen = {}
			for k, v in pairs(transformVehicles) do
				local hash = tonumber(v) or GetHashKey(v)
				if not seen[hash] then
					seen[hash] = true
					table.insert(availableVehModels, hash)
				end
			end
		end
	end
	if #availableVehModels >= 2 then
		for i = 1, 10 do
			local randomIndex = math.random(#availableVehModels)
			local randomHash = availableVehModels[randomIndex]
			if GetVehicleModelNumberOfSeats(randomHash) >= 1 then
				model = randomHash
				break
			end
		end
	else
		for i = 1, 10 do
			local randomIndex = math.random(#allVehModels)
			local randomHash = GetHashKey(allVehModels[randomIndex])
			local label = GetLabelText(GetDisplayNameFromVehicleModel(randomHash))
			if label ~= "NULL" and IsThisModelACar(randomHash) then
				if GetVehicleModelNumberOfSeats(randomHash) >= 1 then
					model = randomHash
					break
				end
			end
		end
	end
	return model
end

function Client.Function.Shared.PlayEffectAndSound(playerPed, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
	if effect_1 == 0 and effect_2 == 0 then
		PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
	else
		if effect_1 == 1 then
			PlaySoundFrontend(-1, "Orientation_Success", "DLC_Air_Race_Sounds_Player", false)
		elseif effect_1 == 2 then
			PlaySoundFrontend(-1, "Orientation_Fail", "DLC_Air_Race_Sounds_Player", false)
		elseif effect_2 == 1 then
			PlaySoundFromEntity(-1, "Vehicle_Warp", playerPed, "DLC_Air_Race_Sounds_Player", false, 0)
		elseif effect_2 == 2 then
			PlaySoundFromEntity(-1, "Vehicle_Transform", playerPed, "DLC_Air_Race_Sounds_Player", false, 0)
		end
		if effect_1 == 1 then
			if AnimpostfxIsRunning("CrossLine") then
				AnimpostfxStop("CrossLine")
				AnimpostfxPlay("CrossLineOut", 0, false)
			end
			AnimpostfxPlay("MP_SmugglerCheckpoint", 1000, false)
		elseif effect_1 == 2 then
			CreateThread(function()
				if not AnimpostfxIsRunning("CrossLine") then
					AnimpostfxPlay("CrossLine", 0, true)
				end
				Wait(1000)
				if AnimpostfxIsRunning("CrossLine") then
					AnimpostfxStop("CrossLine")
					AnimpostfxPlay("CrossLineOut", 0, false)
				end
			end)
		end
		if effect_2 == 1 or effect_2 == 2 then
			CreateThread(function()
				RequestNamedPtfxAsset("scr_as_trans")
				while not HasNamedPtfxAssetLoaded("scr_as_trans") do Wait(0) end
				UseParticleFxAssetNextCall("scr_as_trans")
				local effect = StartParticleFxLoopedOnEntity("scr_as_trans_smoke", playerPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)
				local r, g, b = tonumber(vehicleR), tonumber(vehicleG), tonumber(vehicleB)
				if r and g and b then
					SetParticleFxLoopedColour(effect, (r / 255) + 0.0, (g / 255) + 0.0, (b / 255) + 0.0, true)
				end
				Wait(500)
				StopParticleFxLooped(effect, true)
			end)
		end
	end
end

function Client.Function.Shared.WarpVehicle(checkpoint, entity)
	local entitySpeed = GetEntitySpeed(entity)
	local entityRotation = GetEntityRotation(entity, 2)
	local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false, true)
	SetEntityCoords(entity, x, y, z)
	SetEntityRotation(entity, entityRotation, 2)
	SetEntityHeading(entity, checkpoint.heading)
	SetVehicleForwardSpeed(entity, entitySpeed)
	SetGameplayCamRelativeHeading(0)
end

function Client.Function.Shared.SlowVehicle(entity)
	local speed = math.min(GetEntitySpeed(entity), GetVehicleEstimatedMaxSpeed(entity))
	SetVehicleForwardSpeed(entity, speed / 3.0)
end

function Client.Function.Shared.GetVehicleShouldSlowDown(checkpoint, entity)
	local forward, right, up, vehPos = GetEntityMatrix(entity)
	local cpPos = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
	local dirVec
	if checkpoint.lockDirection then
		dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
	elseif Vdist2(vehPos.x, vehPos.y, vehPos.z, cpPos.x, cpPos.y, cpPos.z) > 20.0 then
		dirVec = cpPos - vehPos
	else
		dirVec = forward
	end
	dirVec = Client.Function.Math.NormVec(dirVec)
	local rightVec = Client.Function.Math.NormVec(Client.Function.Math.CrossVec(dirVec, vector3(0.0, 0.0, 1.0)))
	local upVec = Client.Function.Math.NormVec(-Client.Function.Math.CrossVec(dirVec, rightVec))
	if checkpoint.planeRot == 2 then
		upVec = -upVec
		rightVec = -rightVec
	elseif checkpoint.planeRot == 3 then
		local tempUp = upVec
		local tempRight = rightVec
		upVec = -tempRight
		rightVec = tempUp
	elseif checkpoint.planeRot == 1 then
		local tempUp = upVec
		local tempRight = rightVec
		upVec = tempRight
		rightVec = -tempUp
	end
	if ((Client.Function.Math.DotVec(upVec, up) > (1.0 - 0.3) and Client.Function.Math.DotVec(rightVec, right) > (1.0 - (0.3 * 1.5))) or
		(math.abs(dirVec.z) > 0.95 and Client.Function.Math.DotVec(dirVec, forward) > (1.0 - 0.3))) then
		return false
	else
		return true
	end
end

function Client.Function.Shared.GetValidXYZFor_3dCoord(posX, posY, posZ, forCreate, printLog)
	local validX = posX
	local validY = posY
	local validZ = 0.0
	if validX <= -16000.0 or validX >= 16000.0 then
		validX = 0.0
		if not forCreate and printLog then
			print("Failed to set player coords at the specified x. Please ensure the x is between -16000 and 16000")
		end
	end
	if validY <= -16000.0 or validY >= 16000.0 then
		validY = 0.0
		if not forCreate and printLog then
			print("Failed to set player coords at the specified y. Please ensure the y is between -16000 and 16000")
		end
	end
	if forCreate and (posZ + 50.0 > -200.0) and (posZ + 50.0 < 2700.0) then
		validZ = posZ + 50.0
	elseif forCreate and (posZ - 50.0 > -200.0) and (posZ - 50.0 < 2700.0) then
		validZ = posZ - 50.0
	elseif not forCreate and (posZ > -200.0) and (posZ < 2700.0) then
		validZ = posZ
	else
		local found, groundZ = GetGroundZFor_3dCoord(validX, validY, posZ, true)
		validZ = found and (groundZ > -200.0) and (groundZ < 2700.0) and groundZ or 0.0
		if not forCreate and printLog then
			print("Failed to set player coords at the specified z. Please ensure the z is between -200 and 2700")
		end
	end
	return validX, validY, validZ
end