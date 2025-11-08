function OpenCreatorMenu()
	RageUI.Visible(MainMenu, true)
	Audio.PlaySound(RageUI.Settings.Audio.Back.audioName, RageUI.Settings.Audio.Back.audioRef)
end

function CreateCreatorFreeCam(ped)
	FreezeEntityPosition(ped, true)
	SetEntityVisible(ped, false)
	SetEntityCollision(ped, false, false)
	SetEntityCompletelyDisableCollision(ped, false, false)
	cameraPosition = cameraPosition or GetEntityCoords(ped)
	cameraRotation = cameraRotation or {x = -30.0, y = 0.0, z = GetEntityHeading(ped)}
	camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", cameraPosition.x, cameraPosition.y, cameraPosition.z, cameraRotation.x, cameraRotation.y, cameraRotation.z, 60.0)
	SetCamActive(camera, true)
	RenderScriptCams(true, false, 0, true, true)
end

function LoopGetCameraFramerateMoveFix()
	if not loopGetCameraFramerate then
		loopGetCameraFramerate = true
		Citizen.CreateThread(function()
			while global_var.enableCreator do
				local startCount = GetFrameCount()
				Citizen.Wait(1000)
				local endCount = GetFrameCount()
				local fps = endCount - startCount - 1
				if fps <= 0 then fps = 1 end
				cameraFramerateMoveFix = (60 / fps) * 1.0
			end
			loopGetCameraFramerate = false
		end)
	end
end

function GetCameraForwardVector()
	local heading = cameraRotation.z
	local x = -math.sin(math.rad(heading))
	local y = math.cos(math.rad(heading))
	local z = 0.0
	return vector3(x, y, z)
end

function GetCameraForwardVector_2()
	local heading = cameraRotation.z
	local pitch = cameraRotation.x
	local x = -math.sin(math.rad(heading)) * math.cos(math.rad(pitch))
	local y = math.cos(math.rad(heading)) * math.cos(math.rad(pitch))
	local z = math.sin(math.rad(pitch))
	return vector3(x, y, z)
end

function GetCameraRightVector()
	local heading = cameraRotation.z
	local x = math.cos(math.rad(heading))
	local y = math.sin(math.rad(heading))
	return vector3(x, y, 0.0)
end

function GetEntityInView(flag)
	if camera ~= nil then
		local x, y, z = cameraPosition.x + 0.0, cameraPosition.y + 0.0, cameraPosition.z + 0.0
		local forwardVector = GetCameraForwardVector_2()
		local endX, endY, endZ = x + forwardVector.x * 1000, y + forwardVector.y * 1000, z + forwardVector.z * 1000
		--[[
		None = 0,
		IntersectWorld = 1,
		IntersectVehicles = 2,
		IntersectPeds = 4,
		IntersectRagdolls = 8,
		IntersectObjects = 16,
		IntersectWater = 32,
		IntersectGlass = 64,
		IntersectRiver = 128,
		IntersectFoliage = 256,
		IntersectEverything = -1
		]]
		local ray = StartShapeTestRay(x, y, z, endX, endY, endZ, flag, startingGridVehiclePreview or startingGridVehicleSelect or (not objectPreview_coords_change and objectPreview), 0)
		local _, hit, endCoords, surfaceNormal, entity = GetShapeTestResult(ray)
		if hit == 1 then
			return entity, endCoords, surfaceNormal
		else
			return nil, nil, nil
		end
	else
		return nil, nil, nil
	end
end

function GetEndXYInView(targetZ)
	if camera ~= nil then
		local x, y = cameraPosition.x + 0.0, cameraPosition.y + 0.0
		local forwardVector = GetCameraForwardVector_2()
		local num = (targetZ - cameraPosition.z) / forwardVector.z
		if (num > 0) and (num <= 1000) then
			return RoundedValue(x + forwardVector.x * num, 3), RoundedValue(y + forwardVector.y * num, 3)
		else
			return nil, nil
		end
	else
		return nil, nil
	end
end

function DrawFixtureLines(fixture, hash)
	local min, max = GetModelDimensions(hash)
	local corners = {
		{x = min.x, y = min.y, z = min.z},
		{x = min.x, y = min.y, z = max.z},
		{x = min.x, y = max.y, z = min.z},
		{x = min.x, y = max.y, z = max.z},
		{x = max.x, y = min.y, z = min.z},
		{x = max.x, y = min.y, z = max.z},
		{x = max.x, y = max.y, z = min.z},
		{x = max.x, y = max.y, z = max.z},
	}
	local worldCorners = {}
	for i, corner in ipairs(corners) do
		local worldPos = GetOffsetFromEntityInWorldCoords(fixture, corner.x, corner.y, corner.z)
		table.insert(worldCorners, worldPos)
	end
	local lines = {
		{1, 2}, {1, 3}, {1, 5},
		{2, 4}, {2, 6},
		{3, 4}, {3, 7},
		{4, 8},
		{5, 6}, {5, 7},
		{6, 8},
		{7, 8}
	}
	for _, line in ipairs(lines) do
		local p1 = worldCorners[line[1]]
		local p2 = worldCorners[line[2]]
		DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, 255, 0, 0, 255)
	end
end

function setBit(x, n)
	return x | (1 << n)
end

function isBitSet(x, n)
	return (x & (1 << n)) ~= 0
end

function clearBit(x, n)
	return x & ~(1 << n)
end

function tableDeepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[tableDeepCopy(orig_key)] = tableDeepCopy(orig_value)
		end
		setmetatable(copy, tableDeepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

function tableCount(t)
	local c = 0
	for _, _ in pairs(t) do
		c = c + 1
	end
	return c
end

function strinCount(str)
	local c = 0
	for _ in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		c = c + 1
	end
	return c
end

function createProp(hash, x, y, z, rotX, rotY, rotZ, color, prpsba)
	if IsModelInCdimage(hash) and IsModelValid(hash) then
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			Citizen.Wait(0)
		end
		local obj = CreateObjectNoOffset(hash, x, y, z, false, true, false)
		-- Create object of door type
		-- https://docs.fivem.net/natives/?_0x9A294B2138ABB884
		if obj == 0 then
			obj = CreateObjectNoOffset(hash, x, y, z, false, true, true)
		end
		if obj ~= 0 then
			SetEntityRotation(obj, rotX or 0.0, rotY or 0.0, rotZ or 0.0, 2, 0)
			if speedUpObjects[hash] then
				local speed = 25
				if prpsba == 1 then
					speed = 15
				elseif prpsba == 2 then
					speed = 25
				elseif prpsba == 3 then
					speed = 35
				elseif prpsba == 4 then
					speed = 45
				elseif prpsba == 5 then
					speed = 100
				end
				local duration = 0.4
				if prpsba == 1 then
					duration = 0.3
				elseif prpsba == 2 then
					duration = 0.4
				elseif prpsba == 3 then
					duration = 0.5
				elseif prpsba == 4 then
					duration = 0.5
				elseif prpsba == 5 then
					duration = 0.5
				end
				SetObjectStuntPropSpeedup(obj, speed)
				SetObjectStuntPropDuration(obj, duration)
			end
			if slowDownObjects[hash] then
				local speed = 30
				if prpsba == 1 then
					speed = 44
				elseif prpsba == 2 then
					speed = 30
				elseif prpsba == 3 then
					speed = 16
				end
				SetObjectStuntPropSpeedup(obj, speed)
			end
			SetObjectTextureVariant(obj, color or 0)
			SetEntityAlpha(obj, 150)
			SetEntityLodDist(obj, 16960)
			FreezeEntityPosition(obj, true)
			return obj
		else
			return nil
		end
	end
	return nil
end

function createVeh(hash, x, y, z, heading, combination)
	if IsModelInCdimage(hash) and IsModelValid(hash) then
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			Citizen.Wait(0)
		end
		local veh = CreateVehicle(hash, x, y, z, newHeading, false, false)
		SetModelAsNoLongerNeeded(hash)
		if veh ~= 0 then
			SetEntityRotation(veh, 0.0, 0.0, heading, 2, 0)
			FreezeEntityPosition(veh, true)
			SetEntityAlpha(veh, 150)
			if combination then
				SetVehicleColourCombination(veh, combination)
			end
			return veh
		end
	end
	return nil
end

function createBlip(x, y, z, scale, id, color, entity)
	local blip = nil
	if entity then
		blip = AddBlipForEntity(entity)
	else
		blip = AddBlipForCoord(x, y, z)
		SetBlipPriority(blip, 9)
	end
	SetBlipScale(blip, scale)
	SetBlipSprite(blip, id)
	SetBlipColour(blip, color)
	SetBlipShrink(blip, true)
	SetBlipDisplay(blip, 8)
	return blip
end

function updateBlips(str)
	if str == "checkpoint" then
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
	elseif str == "object" then
		for k, v in pairs(blips.objects) do
			RemoveBlip(v)
		end
		blips.objects = {}
		for k, v in pairs(currentRace.objects) do
			blips.objects[k] = createBlip(v.x, v.y, v.z, 0.60, 271, 50, v.handle)
		end
	end
end

function ResetCheckpointAndBlipForCreator()
	if global_var.testData and global_var.testData.checkpoints then
		for i, checkpoint in ipairs(global_var.testData.checkpoints) do
			if checkpoint.draw_id then
				DeleteCheckpoint(checkpoint.draw_id)
				checkpoint.draw_id = nil
			end
			if checkpoint.blip_id then
				RemoveBlip(checkpoint.blip_id)
				checkpoint.blip_id = nil
			end
			local checkpoint_2 = global_var.testData.checkpoints_2[i]
			if checkpoint_2 then
				if checkpoint_2.draw_id then
					DeleteCheckpoint(checkpoint_2.draw_id)
					checkpoint_2.draw_id = nil
				end
				if checkpoint_2.blip_id then
					RemoveBlip(checkpoint_2.blip_id)
					checkpoint_2.blip_id = nil
				end
			end
		end
	end
end

function CreateCheckpointForCreator(index, pair)
	local checkpoint = pair and global_var.testData.checkpoints_2[index] or global_var.testData.checkpoints[index]
	if not checkpoint then return end
	local checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(13)
	local checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
	local checkpointA_1, checkpointA_2 = 150, 150
	if not checkpoint.draw_id then
		local draw_size = checkpoint.is_restricted and (7.5 * 0.66) or (((checkpoint.is_air and (4.5 * checkpoint.d_draw)) or ((checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) and (2.25 * checkpoint.d_draw)) or checkpoint.d_draw) * 10)
		local checkpointNearHeight = checkpoint.is_lower and 6.0 or 9.5
		local checkpointFarHeight = checkpoint.is_tall and 250.0 or (checkpoint.is_lower and 6.0) or 9.5
		local checkpointRangeHeight = checkpoint.is_tall and checkpoint.tall_range or 100.0
		local drawHigher = false
		local updateZ = (checkpoint.is_round and (checkpoint.is_air and 0.0 or draw_size/2) or draw_size/2)
		local checkpoint_next = pair and (global_var.testData.checkpoints_2[index + 1] or global_var.testData.checkpoints[index + 1] or global_var.testData.checkpoints_2[1] or global_var.testData.checkpoints[1]) or (global_var.testData.checkpoints[index + 1] or global_var.testData.checkpoints[1]) or {x = 0.0, y = 0.0, z = 0.0}
		local checkpoint_prev = pair and (global_var.testData.checkpoints_2[index - 1] or global_var.testData.checkpoints[index - 1] or global_var.testData.checkpoints_2[#global_var.testData.checkpoints] or global_var.testData.checkpoints[#global_var.testData.checkpoints]) or (global_var.testData.checkpoints[index - 1] or global_var.testData.checkpoints[#global_var.testData.checkpoints]) or {x = 0.0, y = 0.0, z = 0.0}
		local checkpointIcon = 6
		if checkpoint.is_pit then
			checkpointIcon = 11
		elseif checkpoint.is_random then
			checkpointIcon = 56
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.is_transform then
			local vehicleHash = currentRace.transformVehicles[checkpoint.transform_index + 1]
			local vehicleClass = GetVehicleClassFromName(vehicleHash)
			if vehicleHash == -422877666 then
				checkpointIcon = 64
			elseif vehicleHash == -731262150 then
				checkpointIcon = 55
			elseif vehicleClass >= 0 and vehicleClass <= 7 or vehicleClass >= 9 and vehicleClass <= 12 or vehicleClass == 17 or vehicleClass == 18 or vehicleClass == 22 then
				checkpointIcon = 60
			elseif vehicleClass == 8 then
				checkpointIcon = 61
			elseif vehicleClass == 13 then
				checkpointIcon = 62
			elseif vehicleClass == 14 then
				checkpointIcon = 59
			elseif vehicleClass == 15 then
				checkpointIcon = 58
			elseif vehicleClass == 16 then
				checkpointIcon = 57
			elseif vehicleClass == 20 then
				checkpointIcon = 63
			elseif vehicleClass == 19 then
				if vehicleHash == GetHashKey("thruster") then
					checkpointIcon = 65
				else
					checkpointIcon = 60
				end
			elseif vehicleClass == 21 then
				checkpointIcon = 60
			end
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.is_warp then
			checkpointIcon = 66
		elseif checkpoint.is_planeRot then
			if checkpoint.plane_rot == 0 then
				checkpointIcon = 37
			elseif checkpoint.plane_rot == 1 then
				checkpointIcon = 39
			elseif checkpoint.plane_rot == 2 then
				checkpointIcon = 40
			elseif checkpoint.plane_rot == 3 then
				checkpointIcon = 38
			end
			if checkpoint.is_planeRot then
				local ped = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(ped, false)
				if vehicle ~= 0 and GetVehicleCanSlowDown(checkpoint, vehicle) then
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(6)
				else
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
				end
			end
		else
			if checkpoint.is_round then
				checkpointIcon = 12
			else
				local diffPrev = vector3(checkpoint_prev.x, checkpoint_prev.y, checkpoint_prev.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
				local diffNext = vector3(checkpoint_next.x, checkpoint_next.y, checkpoint_next.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
				local checkpointAngle = GetAngleBetween_2dVectors(diffPrev.x, diffPrev.y, diffNext.x, diffNext.y)
				checkpointAngle = checkpointAngle > 180.0 and (360.0 - checkpointAngle) or checkpointAngle
				local foundGround, groundZ = GetGroundZExcludingObjectsFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false)
				if foundGround then
					if math.abs(groundZ - checkpoint.z) > 15.0 then
						drawHigher = true
						checkpointNearHeight = checkpointNearHeight - 4.5
						checkpointFarHeight = checkpointFarHeight - 4.5
						updateZ = 0.0
					end
				end
				if checkpointAngle < 80.0 then
					checkpointIcon = drawHigher == true and 2 or 8
				elseif checkpointAngle < 140.0 then
					checkpointIcon = drawHigher == true and 1 or 7
				elseif checkpointAngle <= 180.0 then
					checkpointIcon = drawHigher == true and 0 or 6
				end
			end
		end
		local hour = GetClockHours()
		if hour > 6 and hour < 20 and not (checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) then
			checkpointA_1 = 210
			checkpointA_2 = 180
		end
		local pos_1 = vector3(checkpoint.x, checkpoint.y, checkpoint.z + updateZ)
		local pos_2 = vector3(checkpoint_next.x, checkpoint_next.y, checkpoint_next.z)
		if not (checkpoint.offset.x == 0.0 and checkpoint.offset.y == 0.0 and checkpoint.offset.z == 0.0) then
			pos_2 = pos_1 + vector3(checkpoint.offset.x, checkpoint.offset.y, checkpoint.offset.z)
		end
		checkpoint.draw_id = CreateCheckpoint(
			checkpointIcon,
			pos_1.x, pos_1.y, pos_1.z,
			pos_2.x, pos_2.y, pos_2.z,
			draw_size, checkpointR_2, checkpointG_2, checkpointB_2, checkpointA_2, 0
		)
		if (checkpoint.is_round or checkpoint.is_random or checkpoint.is_transform or checkpoint.is_planeRot or checkpoint.is_warp) then
			if checkpoint.lock_dir then
				local dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
				local pos_3 = checkpoint.is_planeRot and (pos_1 - dirVec) or (pos_1 + dirVec)
				N_0xdb1ea9411c8911ec(checkpoint.draw_id) -- SET_CHECKPOINT_FORCE_DIRECTION
				N_0x3c788e7f6438754d(checkpoint.draw_id, pos_3.x, pos_3.y, pos_3.z) -- SET_CHECKPOINT_DIRECTION
			end
		else
			if drawHigher then
				SetCheckpointIconHeight(checkpoint.draw_id, 0.5) -- SET_CHECKPOINT_INSIDE_CYLINDER_HEIGHT_SCALE
			end
			if checkpoint.is_lower then
				SetCheckpointIconScale(checkpoint.draw_id, 0.85) -- SET_CHECKPOINT_INSIDE_CYLINDER_SCALE
			end
			SetCheckpointCylinderHeight(checkpoint.draw_id, checkpointNearHeight, checkpointFarHeight, checkpointRangeHeight)
		end
		SetCheckpointRgba(checkpoint.draw_id, checkpointR_1, checkpointG_1, checkpointB_1, checkpointA_1)
	end
end

function CreateBlipForCreator(index)
	local function createData(checkpoint, isNext)
		local x, y, z = checkpoint.x, checkpoint.y, checkpoint.z
		local sprite = (checkpoint.is_random and 66) or (checkpoint.is_transform and 570) or 1
		local scale = isNext and 0.65 or 0.9
		local alpha = (isNext or (checkpoint.low_alpha)) and 125 or 255
		local colour = (checkpoint.is_random or checkpoint.is_transform) and 1 or 5
		local display = 8
		return {
			x = x,
			y = y,
			z = z,
			sprite = sprite,
			scale = scale,
			alpha = alpha,
			colour = colour,
			display = display
		}
	end
	local function createBlip(data)
		local blip = 0
		if data.x ~= nil and data.y ~= nil and data.z ~= nil then
			blip = AddBlipForCoord(data.x, data.y, data.z)
		end
		if data.sprite ~= nil then
			SetBlipSprite(blip, data.sprite)
		end
		if data.scale ~= nil then
			SetBlipScale(blip, data.scale)
		end
		if data.alpha ~= nil then
			SetBlipAlpha(blip, data.alpha)
		end
		if data.colour ~= nil then
			SetBlipColour(blip, data.colour)
		end
		if data.display ~= nil then
			SetBlipDisplay(blip, data.display)
		end
		return blip
	end
	local checkpoint = global_var.testData.checkpoints[index]
	if checkpoint then
		checkpoint.blip_id = createBlip(createData(checkpoint, false))
	end
	local checkpoint_2 = global_var.testData.checkpoints_2[index]
	if checkpoint_2 then
		checkpoint_2.blip_id = createBlip(createData(checkpoint_2, false))
	end
	local checkpoint_next = global_var.testData.checkpoints[index + 1]
	if checkpoint_next then
		checkpoint_next.blip_id = createBlip(createData(checkpoint_next, true))
	end
	local checkpoint_2_next = global_var.testData.checkpoints_2[index + 1]
	if checkpoint_2_next then
		checkpoint_2_next.blip_id = createBlip(createData(checkpoint_2_next, true))
	end
end

function DrawCheckpointForCreator(x, y, z, heading, d, is_round, is_air, is_fake, is_random, randomClass, is_transform, transform_index, is_planeRot, plane_rot, is_warp, is_preview, highlight, index, is_pair)
	local diameter = ((is_air and (4.5 * d)) or ((is_round or is_random or is_transform or is_planeRot or is_warp) and (2.25 * d)) or d) * 10
	local updateZ = 0.0
	if is_air then
		updateZ = 0.0
	else
		updateZ = diameter / 2
	end
	local marker_1 = (is_round or is_random or is_transform or is_planeRot or is_warp) and 6 or 1
	local x_1 = x
	local y_1 = y
	local z_1 = z
	local dirX_1 = 0.0
	local dirY_1 = 0.0
	local dirZ_1 = 0.0
	local rotX_1 = 0.0
	local rotY_1 = 0.0
	local rotZ_1 = 0.0
	local scaleX_1 = 0.0
	local scaleY_1 = 0.0
	local scaleZ_1 = 0.0
	local red_1 = 255
	local green_1 = 255
	local blue_1 = 255
	local alpha_1 = 255
	local marker_2 = 20
	local x_2 = x
	local y_2 = y
	local z_2 = z
	local dirX_2 = 0.0
	local dirY_2 = 0.0
	local dirZ_2 = 0.0
	local rotX_2 = 0.0
	local rotY_2 = 0.0
	local rotZ_2 = 0.0
	local scaleX_2 = 0.0
	local scaleY_2 = 0.0
	local scaleZ_2 = 0.0
	local red_2 = 255
	local green_2 = 255
	local blue_2 = 255
	local alpha_2 = 255
	if is_random then
		z_1 = z_1 + updateZ
		rotX_1 = heading
		rotY_1 = 270.0
		rotZ_1 = 0.0
		scaleX_1 = diameter
		scaleY_1 = diameter
		scaleZ_1 = diameter
		red_1 = 255
		green_1 = 50
		blue_1 = 50
		alpha_1 = 125
		marker_2 = 32
		z_2 = z_2 + updateZ
		rotX_2 = 0.0
		rotY_2 = 0.0
		rotZ_2 = heading
		scaleX_2 = diameter / 2
		scaleY_2 = diameter / 2
		scaleZ_2 = diameter / 2
		red_2 = 62
		green_2 = 182
		blue_2 = 245
		alpha_2 = 125
	elseif is_transform then
		z_1 = z_1 + updateZ
		rotX_1 = heading
		rotY_1 = 270.0
		rotZ_1 = 0.0
		scaleX_1 = diameter
		scaleY_1 = diameter
		scaleZ_1 = diameter
		red_1 = 255
		green_1 = 50
		blue_1 = 50
		alpha_1 = 125
		local vehicleHash = currentRace.transformVehicles[transform_index + 1]
		local vehicleClass = GetVehicleClassFromName(vehicleHash)
		if vehicleHash == -422877666 then
			marker_2 = 40
		elseif vehicleHash == -731262150 then
			marker_2 = 31
		elseif vehicleClass == 0 or vehicleClass == 1 or vehicleClass == 2 or vehicleClass == 3 or vehicleClass == 4 or vehicleClass == 5 or vehicleClass == 6 or vehicleClass == 7 or vehicleClass == 9 or vehicleClass == 10 or vehicleClass == 11 or vehicleClass == 12 or vehicleClass == 17 or vehicleClass == 18 or vehicleClass == 22 then
			marker_2 = 36
		elseif vehicleClass == 8 then
			marker_2 = 37
		elseif vehicleClass == 13 then
			marker_2 = 38
		elseif vehicleClass == 14 then
			marker_2 = 35
		elseif vehicleClass == 15 then
			marker_2 = 34
		elseif vehicleClass == 16 then
			marker_2 = 33
		elseif vehicleClass == 20 then
			marker_2 = 39
		elseif vehicleClass == 19 then
			if vehicleHash == GetHashKey("thruster") then
				marker_2 = 41
			else
				marker_2 = 36
			end
		elseif vehicleClass == 21 then
		end
		z_2 = z_2 + updateZ
		rotX_2 = 0.0
		rotY_2 = 0.0
		rotZ_2 = heading
		scaleX_2 = diameter / 2
		scaleY_2 = diameter / 2
		scaleZ_2 = diameter / 2
		red_2 = 62
		green_2 = 182
		blue_2 = 245
		alpha_2 = 125
	elseif is_planeRot then
		z_1 = z_1 + updateZ
		rotX_1 = heading
		rotY_1 = 270.0
		rotZ_1 = 0.0
		scaleX_1 = diameter
		scaleY_1 = diameter
		scaleZ_1 = diameter
		red_1 = 254
		green_1 = 235
		blue_1 = 169
		alpha_1 = 125
		marker_2 = 7
		z_2 = z_2 + updateZ
		if plane_rot == 0 then
			rotX_2 = 0.0
			rotY_2 = 0.0
			rotZ_2 = 180 + heading
		elseif plane_rot == 1 then
			rotX_2 = heading - 180
			rotY_2 = 270.0
			rotZ_2 = 0.0
		elseif plane_rot == 2 then
			rotX_2 = 180.0
			rotY_2 = 0.0
			rotZ_2 = -heading
		elseif plane_rot == 3 then
			rotX_2 = heading
			rotY_2 = -90.0
			rotZ_2 = 180.0
		end
		scaleX_2 = diameter / 2
		scaleY_2 = diameter / 2
		scaleZ_2 = diameter / 2
		red_2 = 62
		green_2 = 182
		blue_2 = 245
		alpha_2 = 125
	elseif is_warp then
		z_1 = z_1 + updateZ
		rotX_1 = heading
		rotY_1 = 270.0
		rotZ_1 = 0.0
		scaleX_1 = diameter
		scaleY_1 = diameter
		scaleZ_1 = diameter
		red_1 = 254
		green_1 = 235
		blue_1 = 169
		alpha_1 = 125
		marker_2 = 42
		z_2 = z_2 + updateZ
		rotX_2 = 0.0
		rotY_2 = 0.0
		rotZ_2 = heading
		scaleX_2 = diameter / 2
		scaleY_2 = diameter / 2
		scaleZ_2 = diameter / 2
		red_2 = 62
		green_2 = 182
		blue_2 = 245
		alpha_2 = 125
	elseif is_round then
		z_1 = z_1 + updateZ
		rotX_1 = heading
		rotY_1 = 270.0
		rotZ_1 = 0.0
		scaleX_1 = diameter
		scaleY_1 = diameter
		scaleZ_1 = diameter
		red_1 = 254
		green_1 = 235
		blue_1 = 169
		alpha_1 = 125
		marker_2 = 20
		z_2 = z_2 + updateZ
		dirZ_2 = -90.0
		rotX_2 = 0.0
		rotY_2 = heading
		rotZ_2 = 0.0
		scaleX_2 = diameter / 2
		scaleY_2 = diameter / 2
		scaleZ_2 = diameter / 2
		red_2 = 62
		green_2 = 182
		blue_2 = 245
		alpha_2 = 125
	else
		z_1 = z_1
		rotX_1 = 0.0
		rotY_1 = 0.0
		rotZ_1 = 0.0
		scaleX_1 = diameter
		scaleY_1 = diameter
		scaleZ_1 = diameter / 2
		red_1 = 254
		green_1 = 235
		blue_1 = 169
		alpha_1 = 30
		marker_2 = 20
		z_2 = z_2 + diameter / 2
		dirZ_2 = -90.0
		rotX_2 = 0.0
		rotY_2 = heading
		rotZ_2 = 0.0
		scaleX_2 = diameter / 2
		scaleY_2 = diameter / 2
		scaleZ_2 = diameter / 2
		red_2 = 62
		green_2 = 182
		blue_2 = 245
		alpha_2 = 125
	end

	if (textDrawCount < 30) and not is_preview then
		local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z + (diameter / 3))
		if onScreen and index then
			local handle = StartShapeTestRay(cameraPosition.x, cameraPosition.y, cameraPosition.z, x, y, z + (diameter / 3), -1, 0)
			local _, hit, _, _, _ = GetShapeTestResult(handle)
			if hit == 0 then
				textDrawCount = textDrawCount + 1
				DrawFloatingTextForCreator(x_2, y_2, z_2, diameter, index, is_pair)
			end
		end
	end

	if (markerDrawCount < 60) or is_preview then
		local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)
		if onScreen or is_preview then
			if not is_preview then
				markerDrawCount = markerDrawCount + 1
			end
			DrawMarker(
				marker_1,
				x_1,
				y_1,
				z_1,
				dirX_1,
				dirY_1,
				dirZ_1,
				rotX_1,
				rotY_1,
				rotZ_1,
				scaleX_1,
				scaleY_1,
				scaleZ_1,
				red_1,
				green_1,
				blue_1,
				alpha_1,
				false,
				false,
				2,
				nil,
				nil,
				false
			)
			DrawMarker(
				marker_2,
				x_2,
				y_2,
				z_2,
				dirX_2,
				dirY_2,
				dirZ_2,
				rotX_2,
				rotY_2,
				rotZ_2,
				scaleX_2,
				scaleY_2,
				scaleZ_2,
				red_2,
				green_2,
				blue_2,
				alpha_2,
				false,
				false,
				2,
				nil,
				nil,
				false
			)
			if highlight then
				DrawMarker(
					26,
					x_1,
					y_1,
					z_1,
					0.0,
					0.0,
					0.0,
					0.0,
					0.0,
					heading,
					scaleX_1,
					scaleY_1,
					scaleZ_1,
					255,
					255,
					255,
					150,
					false,
					false,
					2,
					nil,
					nil,
					false
				)
			end
		end
	end
end

function DrawFloatingTextForCreator(x, y, z, diameter, text, is_pair, color)
	local distance = (isFireworkMenuVisible and #((vector3(0.0, 60.0, 1050.0)) - vector3(x, y, z + (diameter / 3)))) or (global_var.enableTest and #(GetGameplayCamCoords() - vector3(x, y, z + (diameter / 3)))) or #((vector3(cameraPosition.x, cameraPosition.y, cameraPosition.z)) - vector3(x, y, z + (diameter / 3)))
	local scale = diameter / (distance * 0.2)
	SetTextScale(0.0, scale)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	if not color then
		if not is_pair then
			SetTextColour(255, 255, 255, 255)
		else
			SetTextColour(255, 255, 125, 255)
		end
	else
		SetTextColour(color[1], color[2], color[3], 255)
	end
	SetTextOutline()
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z + (diameter * 5 / 6), 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function InitScrollTextOnBlimp()
	Citizen.CreateThread(function()
		local scaleform = RequestScaleformMovie("blimp_text")
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		local rendertarget = 0
		if not IsNamedRendertargetRegistered("blimp_text") then
			RegisterNamedRendertarget("blimp_text", false)
		end
		if not IsNamedRendertargetLinked(1575467428) then
			LinkNamedRendertarget(1575467428)
		end
		if IsNamedRendertargetRegistered("blimp_text") then
			rendertarget = GetNamedRendertargetRenderId("blimp_text")
		end
		blimp.scaleform = scaleform
		blimp.rendertarget = rendertarget
		SetScrollTextOnBlimp()
		SetScrollColorOnBlimp()
		SetScrollSpeedOnBlimp()
	end)
end

function SetScrollTextOnBlimp(msg)
	PushScaleformMovieFunction(blimp.scaleform, "SET_MESSAGE")
	PushScaleformMovieFunctionParameterString(msg or "")
	PopScaleformMovieFunctionVoid()
end

function SetScrollColorOnBlimp(color)
	PushScaleformMovieFunction(blimp.scaleform, "SET_COLOUR")
	PushScaleformMovieFunctionParameterInt(color or 1)
	PopScaleformMovieFunctionVoid()
end

function SetScrollSpeedOnBlimp(speed)
	PushScaleformMovieFunction(blimp.scaleform, "SET_SCROLL_SPEED")
	PushScaleformMovieFunctionParameterFloat(speed or 100.0)
	PopScaleformMovieFunctionVoid()
end

function TestCurrentCheckpoint(respawnData)
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		local x, y, z, heading, hash = respawnData.x, respawnData.y, respawnData.z, respawnData.heading, respawnData.model
		global_var.autoRespawn = true
		global_var.enableBeastMode = false
		local model = (hash and hash ~= 0) and (tonumber(hash) or GetHashKey(hash)) or ((currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle))) or GetHashKey("bmx")
		if model == -422877666 then
			global_var.autoRespawn = false
			if global_var.testVehicleHandle then
				local vehId = NetworkGetNetworkIdFromEntity(global_var.testVehicleHandle)
				DeleteEntity(global_var.testVehicleHandle)
				TriggerServerEvent("custom_creator:server:deleteVehicle", vehId)
				global_var.testVehicleHandle = nil
			end
			ClearPedBloodDamage(ped)
			ClearPedWetness(ped)
			GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
			SetEntityCoords(ped, x, y, z)
			SetEntityHeading(ped, heading)
			SetGameplayCamRelativeHeading(0)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			if global_var.tipsRendered then
				global_var.respawnData.checkpointIndex_draw = global_var.respawnData.checkpointIndex + 1
				ResetCheckpointAndBlipForCreator()
				CreateBlipForCreator(global_var.respawnData.checkpointIndex_draw)
				CreateCheckpointForCreator(global_var.respawnData.checkpointIndex_draw, false)
				CreateCheckpointForCreator(global_var.respawnData.checkpointIndex_draw, true)
			end
			global_var.isRespawning = false
			return
		end
		if model == -731262150 then
			global_var.autoRespawn = false
			global_var.enableBeastMode = true
			if global_var.testVehicleHandle then
				local vehId = NetworkGetNetworkIdFromEntity(global_var.testVehicleHandle)
				DeleteEntity(global_var.testVehicleHandle)
				TriggerServerEvent("custom_creator:server:deleteVehicle", vehId)
				global_var.testVehicleHandle = nil
			end
			ClearPedBloodDamage(ped)
			ClearPedWetness(ped)
			RemoveAllPedWeapons(ped, false)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
			SetEntityCoords(ped, x, y, z)
			SetEntityHeading(ped, heading)
			SetGameplayCamRelativeHeading(0)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
			if global_var.tipsRendered then
				global_var.respawnData.checkpointIndex_draw = global_var.respawnData.checkpointIndex + 1
				ResetCheckpointAndBlipForCreator()
				CreateBlipForCreator(global_var.respawnData.checkpointIndex_draw)
				CreateCheckpointForCreator(global_var.respawnData.checkpointIndex_draw, false)
				CreateCheckpointForCreator(global_var.respawnData.checkpointIndex_draw, true)
			end
			global_var.isRespawning = false
			return
		end
		if not IsModelInCdimage(model) or not IsModelValid(model) then
			model = ((currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle))) or GetHashKey("bmx")
		end
		RemoveAllPedWeapons(ped, false)
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		-- Spawn vehicle at the top of the player, fix OneSync culling
		local pos = GetEntityCoords(ped)
		local newVehicle = CreateVehicle(model, pos.x, pos.y, pos.z + 50.0, heading, true, false)
		local vehNetId = NetworkGetNetworkIdFromEntity(newVehicle)
		TriggerServerEvent("custom_creator:server:spawnVehicle", vehNetId)
		SetModelAsNoLongerNeeded(model)
		FreezeEntityPosition(newVehicle, true)
		SetEntityCollision(newVehicle, false, false)
		SetVehRadioStation(newVehicle, "OFF")
		SetVehicleDoorsLocked(newVehicle, 10)
		SetVehicleColourCombination(newVehicle, 0)
		SetVehicleProperties(newVehicle, creatorVehicle)
		Citizen.Wait(0) -- Do not delete! Vehicle still has collisions before this. BUG?
		if global_var.tipsRendered then
			global_var.respawnData.checkpointIndex_draw = global_var.respawnData.checkpointIndex + 1
			ResetCheckpointAndBlipForCreator()
			CreateBlipForCreator(global_var.respawnData.checkpointIndex_draw)
			CreateCheckpointForCreator(global_var.respawnData.checkpointIndex_draw, false)
			CreateCheckpointForCreator(global_var.respawnData.checkpointIndex_draw, true)
		end
		if global_var.testVehicleHandle then
			local vehId = NetworkGetNetworkIdFromEntity(global_var.testVehicleHandle)
			DeleteEntity(global_var.testVehicleHandle)
			TriggerServerEvent("custom_creator:server:deleteVehicle", vehId)
		end
		ClearPedBloodDamage(ped)
		ClearPedWetness(ped)
		SetEntityCoords(newVehicle, x, y, z)
		SetEntityHeading(newVehicle, heading)
		SetPedIntoVehicle(ped, newVehicle, -1)
		SetEntityCollision(newVehicle, true, true)
		SetVehicleFuelLevel(newVehicle, 100.0)
		SetVehicleDirtLevel(newVehicle, 0.0)
		SetVehicleEngineOn(newVehicle, true, true, false)
		SetGameplayCamRelativeHeading(0)
		Citizen.Wait(0) -- Do not delete! Respawn under fake water
		FreezeEntityPosition(newVehicle, false)
		ActivatePhysics(newVehicle)
		if IsThisModelAPlane(model) or IsThisModelAHeli(model) then
			ControlLandingGear(newVehicle, 3)
			SetHeliBladesSpeed(newVehicle, 1.0)
			SetHeliBladesFullSpeed(newVehicle)
			SetVehicleForwardSpeed(newVehicle, 30.0)
		end
		if model == GetHashKey("avenger") or model == GetHashKey("hydra") then
			SetVehicleFlightNozzlePositionImmediate(newVehicle, 0.0)
		end
		global_var.testVehicleHandle = newVehicle
		global_var.isRespawning = false
	end)
end

function TransformVehicle(checkpoint, speed, rotation, velocity)
	global_var.isTransforming = true
	Citizen.CreateThread(function()
		local model = 0
		if checkpoint.is_random == -2 then
			model = GetRandomVehicleModel(checkpoint.randomClass)
		else
			model = currentRace.transformVehicles[checkpoint.transform_index + 1]
		end
		local ped = PlayerPedId()
		local copyVelocity = true
		if not global_var.autoRespawn then
			copyVelocity = ((math.abs(velocity.x) > 0.0) or (math.abs(velocity.y) > 0.0) or (math.abs(velocity.z) > 0.0)) and true or false
			speed = speed > 0.03 and speed or 30.0
		end
		global_var.autoRespawn = true
		global_var.enableBeastMode = false
		if model == -422877666 then
			global_var.autoRespawn = false
			if global_var.testVehicleHandle then
				local vehId = NetworkGetNetworkIdFromEntity(global_var.testVehicleHandle)
				DeleteEntity(global_var.testVehicleHandle)
				TriggerServerEvent("custom_creator:server:deleteVehicle", vehId)
				global_var.testVehicleHandle = nil
			end
			DisplayCustomMsgs(GetTranslate("Transform-Parachute"))
			GiveWeaponToPed(ped, "GADGET_PARACHUTE", 1, false, false)
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
			global_var.isTransforming = false
			return
		elseif model == -731262150 then
			global_var.autoRespawn = false
			global_var.enableBeastMode = true
			if global_var.testVehicleHandle then
				local vehId = NetworkGetNetworkIdFromEntity(global_var.testVehicleHandle)
				DeleteEntity(global_var.testVehicleHandle)
				TriggerServerEvent("custom_creator:server:deleteVehicle", vehId)
				global_var.testVehicleHandle = nil
			end
			DisplayCustomMsgs(GetTranslate("Transform-Beast"))
			RemoveAllPedWeapons(ped, false)
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
			global_var.isTransforming = false
			return
		end
		if model == 0 then
			model = ((currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle))) or GetHashKey("bmx")
		else
			if not IsModelInCdimage(model) or not IsModelValid(model) then
				model = ((currentRace.test_vehicle ~= "") and (tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle))) or GetHashKey("bmx")
			end
		end
		RemoveAllPedWeapons(ped, false)
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		local pos = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local newVehicle = CreateVehicle(model, pos.x, pos.y, pos.z + 50.0, heading, true, false)
		local vehNetId = NetworkGetNetworkIdFromEntity(newVehicle)
		TriggerServerEvent("custom_creator:server:spawnVehicle", vehNetId)
		SetModelAsNoLongerNeeded(model)
		if global_var.testVehicleHandle then
			local vehId = NetworkGetNetworkIdFromEntity(global_var.testVehicleHandle)
			DeleteEntity(global_var.testVehicleHandle)
			TriggerServerEvent("custom_creator:server:deleteVehicle", vehId)
		end
		SetVehRadioStation(newVehicle, "OFF")
		SetVehicleDoorsLocked(newVehicle, 10)
		SetVehicleColourCombination(newVehicle, 0)
		SetVehicleProperties(newVehicle, creatorVehicle)
		SetPedIntoVehicle(ped, newVehicle, -1)
		SetEntityCoords(newVehicle, pos.x, pos.y, pos.z)
		SetEntityHeading(newVehicle, heading)
		SetVehicleFuelLevel(newVehicle, 100.0)
		SetVehicleDirtLevel(newVehicle, 0.0)
		SetVehicleEngineOn(newVehicle, true, true, false)
		if IsThisModelAPlane(model) or IsThisModelAHeli(model) then
			ControlLandingGear(newVehicle, 3)
			SetHeliBladesSpeed(newVehicle, 1.0)
			SetHeliBladesFullSpeed(newVehicle)
			speed = speed > 0.03 and speed or 30.0
		end
		if model == GetHashKey("avenger") or model == GetHashKey("hydra") then
			SetVehicleFlightNozzlePositionImmediate(newVehicle, 0.0)
		end
		SetVehicleForwardSpeed(newVehicle, speed)
		if copyVelocity then
			SetEntityVelocity(newVehicle, velocity.x, velocity.y, velocity.z)
		end
		SetEntityRotation(newVehicle, rotation, 2)
		DisplayCustomMsgs(GetLabelText(GetDisplayNameFromVehicleModel(model)))
		global_var.testVehicleHandle = newVehicle
		global_var.isTransforming = false
	end)
end

function GetRandomVehicleModel(randomClass)
	local model = 0
	local allVehModels = GetAllVehicleModels()
	local vehicleList = {}
	local allVehClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22}
	for k, v in pairs(allVehClass) do
		vehicleList[v] = {}
	end
	for k, v in pairs(allVehModels) do
		local hash = GetHashKey(v)
		local modelClass = GetVehicleClassFromName(hash)
		local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
		if (hash ~= -376434238) and label ~= "NULL" and vehicleList[modelClass] then
			table.insert(vehicleList[modelClass], hash)
		end
	end
	local availableClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 22}
	if randomClass == 0 then -- land
		availableClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 17, 18, 19, 20, 22}
	elseif randomClass == 1 then -- plane
		availableClass = {15, 16}
	elseif randomClass == 2 then -- boat
		availableClass = {14}
	elseif randomClass == 3 then -- plane + land
		availableClass = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 22}
	end
	local availableVehModels = {}
	for i = 1, #availableClass do
		for j = 1, #vehicleList[availableClass[i]] do
			table.insert(availableVehModels, vehicleList[availableClass[i]][j])
		end
	end
	for i = 1, 10 do
		local randomIndex = math.random(#availableVehModels)
		local randomHash = availableVehModels[randomIndex]
		if transformedModel ~= randomHash and GetVehicleModelNumberOfSeats(randomHash) >= 1 then
			model = randomHash
			break
		end
	end
	return model
end

function PlayEffectAndSound(playerPed, effect_1, effect_2, vehicle_r, vehicle_g, vehicle_b)
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
			Citizen.CreateThread(function()
				if not AnimpostfxIsRunning("CrossLine") then
					AnimpostfxPlay("CrossLine", 0, true)
				end
				Citizen.Wait(1000)
				if AnimpostfxIsRunning("CrossLine") then
					AnimpostfxStop("CrossLine")
					AnimpostfxPlay("CrossLineOut", 0, false)
				end
			end)
		end
		if effect_2 == 1 or effect_2 == 2 then
			Citizen.CreateThread(function()
				local particleDictionary = "scr_as_trans"
				local particleName = "scr_as_trans_smoke"
				local scale = 2.0
				RequestNamedPtfxAsset(particleDictionary)
				while not HasNamedPtfxAssetLoaded(particleDictionary) do
					Citizen.Wait(0)
				end
				UseParticleFxAssetNextCall(particleDictionary)
				local effect = StartParticleFxLoopedOnEntity(particleName, playerPed, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, false, false, false)
				local r, g, b = tonumber(vehicle_r), tonumber(vehicle_g), tonumber(vehicle_b)
				if r and g and b then
					SetParticleFxLoopedColour(effect, (r / 255) + 0.0, (g / 255) + 0.0, (b / 255) + 0.0, true)
				end
				Citizen.Wait(500)
				StopParticleFxLooped(effect, true)
			end)
		end
	end
end

function WarpVehicle(checkpoint, entity)
	local entitySpeed = GetEntitySpeed(entity)
	local entityRotation = GetEntityRotation(entity, 2)
	SetEntityCoords(entity, checkpoint.x, checkpoint.y, checkpoint.z)
	SetEntityRotation(entity, entityRotation, 2)
	SetEntityHeading(entity, checkpoint.heading)
	SetVehicleForwardSpeed(entity, entitySpeed)
	SetGameplayCamRelativeHeading(0)
end

function SlowVehicle(entity)
	local speed = math.min(GetEntitySpeed(entity), GetVehicleEstimatedMaxSpeed(entity))
	SetVehicleForwardSpeed(entity, speed / 3.0)
end

function GetVehicleCanSlowDown(checkpoint, entity)
	local forward, right, up, vehPos = GetEntityMatrix(entity)
	local cpPos = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
	local dirVec
	if checkpoint.lock_dir then
		dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
	elseif Vdist2(vehPos.x, vehPos.y, vehPos.z, cpPos.x, cpPos.y, cpPos.z) > 20.0 then
		dirVec = cpPos - vehPos
	else
		dirVec = forward
	end
	dirVec = NormVec(dirVec)
	local rightVec = NormVec(CrossVec(dirVec, vector3(0.0, 0.0, 1.0)))
	local upVec = NormVec(-CrossVec(dirVec, rightVec))
	if checkpoint.plane_rot == 2 then
		upVec = -upVec
		rightVec = -rightVec
	elseif checkpoint.plane_rot == 3 then
		local tempUp = upVec
		local tempRight = rightVec
		upVec = -tempRight
		rightVec = tempUp
	elseif checkpoint.plane_rot == 1 then
		local tempUp = upVec
		local tempRight = rightVec
		upVec = tempRight
		rightVec = -tempUp
	end
	if ((DotVec(upVec, up) > (1.0 - 0.3) and DotVec(rightVec, right) > (1.0 - (0.3 * 1.5))) or
		(math.abs(dirVec.z) > 0.95 and DotVec(dirVec, forward) > (1.0 - 0.3))) then
		return false
	else
		return true
	end
end

function CrossVec(vecA, vecB)
	return vector3(
		(vecA.y * vecB.z) - (vecA.z * vecB.y),
		(vecA.z * vecB.x) - (vecA.x * vecB.z),
		(vecA.x * vecB.y) - (vecA.y * vecB.x)
	)
end

function NormVec(vec)
	local mag = #(vec)
	if mag ~= 0.0 then
		return vec / mag
	else
		return vector3(0.0, 0.0, 0.0)
	end
end

function DotVec(vecA, vecB)
	return (vecA.x * vecB.x) + (vecA.y * vecB.y) + (vecA.z * vecB.z)
end

function DisableTrafficAndNpc(pos)
	RemoveVehiclesFromGeneratorsInArea(pos[1] - 200.0, pos[2] - 200.0, pos[3] - 200.0, pos[1] + 200.0, pos[2] + 200.0, pos[3] + 200.0)
	SetVehicleDensityMultiplierThisFrame(0.0)
	SetRandomVehicleDensityMultiplierThisFrame(0.0)
	SetParkedVehicleDensityMultiplierThisFrame(0.0)
	SetGarbageTrucks(0)
	SetRandomBoats(0)
	SetPedDensityMultiplierThisFrame(0.0)
	SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
end

function ButtonMessage(text)
	BeginTextCommandScaleformString("STRING")
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

function Button(ControlButton)
	N_0xe83a3e3557a56640(ControlButton)
end

function SetupScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()
	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	if buttonToDraw == -1 then
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(4)
		Button(GetControlInstructionalButton(2, 35, true))
		Button(GetControlInstructionalButton(2, 33, true))
		Button(GetControlInstructionalButton(2, 34, true))
		Button(GetControlInstructionalButton(2, 32, true))
		ButtonMessage(GetTranslate("CamMove"))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(3)
		Button(GetControlInstructionalButton(2, 253, true))
		Button(GetControlInstructionalButton(2, 252, true))
		ButtonMessage(GetTranslate("CamZoom"))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(2)
		Button(GetControlInstructionalButton(2, global_var.IsUsingKeyboard and 254 or 226, true))
		ButtonMessage(string.format(GetTranslate("CamMoveSpeed"), speed.cam_pos.value[speed.cam_pos.index][1]))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(1)
		Button(GetControlInstructionalButton(2, global_var.IsUsingKeyboard and 326 or 227, true))
		ButtonMessage(string.format(GetTranslate("CamRotateSpeed"), speed.cam_rot.value[speed.cam_rot.index][1]))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(0)
		Button(GetControlInstructionalButton(2, 201, true))
		ButtonMessage(GetTranslate("Select"))
		PopScaleformMovieFunctionVoid()
	elseif buttonToDraw == 5 then
		if not isFireworkMenuVisible then
			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(4)
			Button(GetControlInstructionalButton(2, 35, true))
			Button(GetControlInstructionalButton(2, 33, true))
			Button(GetControlInstructionalButton(2, 34, true))
			Button(GetControlInstructionalButton(2, 32, true))
			ButtonMessage(GetTranslate("CamMove"))
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(3)
			Button(GetControlInstructionalButton(2, 253, true))
			Button(GetControlInstructionalButton(2, 252, true))
			ButtonMessage(GetTranslate("CamZoom"))
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(2)
			Button(GetControlInstructionalButton(2, global_var.IsUsingKeyboard and 254 or 226, true))
			ButtonMessage(string.format(GetTranslate("CamMoveSpeed"), speed.cam_pos.value[speed.cam_pos.index][1]))
			PopScaleformMovieFunctionVoid()

			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(1)
			Button(GetControlInstructionalButton(2, global_var.IsUsingKeyboard and 326 or 227, true))
			ButtonMessage(string.format(GetTranslate("CamRotateSpeed"), speed.cam_rot.value[speed.cam_rot.index][1]))
			PopScaleformMovieFunctionVoid()
		end
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(0)
		Button(GetControlInstructionalButton(2, 194, true))
		ButtonMessage(GetTranslate("Back"))
		PopScaleformMovieFunctionVoid()
	else
		local msg = ""
		if buttonToDraw == 1 then
			if isStartingGridVehiclePickedUp then
				msg = GetTranslate("UpdateStartingGrid")
			elseif #currentRace.startingGrid > 0 then
				msg = GetTranslate("SelectStartingGrid")
			end
		elseif buttonToDraw == 2 then
			if isCheckpointPickedUp then
				msg = GetTranslate("DeselectCheckpoint")
			end
		elseif buttonToDraw == 3 or buttonToDraw == 4 then
			if isPropPickedUp or isTemplatePropPickedUp then
				msg = GetTranslate("DeselectObject")
			elseif #currentRace.objects > 0 then
				msg = GetTranslate("SelectObject")
			end
		end

		if buttonToDraw == 3 and not isPropPickedUp and (not objectPreview or (objectPreview and not objectPreview_coords_change and currentObject.z)) then
			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(msg ~= "" and 7 or 6)
			Button(GetControlInstructionalButton(2, 251, true))
			Button(GetControlInstructionalButton(2, 250, true))
			ButtonMessage(GetTranslate("PreviewHeight"))
			PopScaleformMovieFunctionVoid()
		end

		if msg ~= "" then
			PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
			PushScaleformMovieFunctionParameterInt(6)
			Button(GetControlInstructionalButton(2, 203, true))
			ButtonMessage(msg)
			PopScaleformMovieFunctionVoid()
		end

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(5)
		Button(GetControlInstructionalButton(2, 35, true))
		Button(GetControlInstructionalButton(2, 33, true))
		Button(GetControlInstructionalButton(2, 34, true))
		Button(GetControlInstructionalButton(2, 32, true))
		ButtonMessage(GetTranslate("CamMove"))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(4)
		Button(GetControlInstructionalButton(2, 253, true))
		Button(GetControlInstructionalButton(2, 252, true))
		ButtonMessage(GetTranslate("CamZoom"))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(3)
		Button(GetControlInstructionalButton(2, global_var.IsUsingKeyboard and 254 or 226, true))
		ButtonMessage(string.format(GetTranslate("CamMoveSpeed"), speed.cam_pos.value[speed.cam_pos.index][1]))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(2)
		Button(GetControlInstructionalButton(2, global_var.IsUsingKeyboard and 326 or 227, true))
		ButtonMessage(string.format(GetTranslate("CamRotateSpeed"), speed.cam_rot.value[speed.cam_rot.index][1]))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(1)
		Button(GetControlInstructionalButton(2, 201, true))
		ButtonMessage(GetTranslate("Select"))
		PopScaleformMovieFunctionVoid()

		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(0)
		Button(GetControlInstructionalButton(2, 194, true))
		ButtonMessage(GetTranslate("Back"))
		PopScaleformMovieFunctionVoid()
	end

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()
	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()
	return scaleform
end

function DisplayCustomMsgs(msg)
	Citizen.CreateThread(function()
		BeginTextCommandThefeedPost("STRING")
		AddTextComponentSubstringPlayerName(msg)
		local item = EndTextCommandThefeedPostTicker(false, false)
		Citizen.Wait(5000)
		ThefeedRemoveItem(item)
	end)
end

function RoundedValue(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function TrimedValue(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function GetVehicleProperties(vehicle)
	if not DoesEntityExist(vehicle) then
		return
	end

	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local hasCustomPrimaryColor = GetIsVehiclePrimaryColourCustom(vehicle)
	local dashboardColor = GetVehicleDashboardColor(vehicle)
	local interiorColor = GetVehicleInteriorColour(vehicle)
	local customPrimaryColor = nil
	if hasCustomPrimaryColor then
		customPrimaryColor = { GetVehicleCustomPrimaryColour(vehicle) }
	end

	local hasCustomXenonColor, customXenonColorR, customXenonColorG, customXenonColorB = GetVehicleXenonLightsCustomColor(vehicle)
	local customXenonColor = nil
	if hasCustomXenonColor then
		customXenonColor = { customXenonColorR, customXenonColorG, customXenonColorB }
	end

	local hasCustomSecondaryColor = GetIsVehicleSecondaryColourCustom(vehicle)
	local customSecondaryColor = nil
	if hasCustomSecondaryColor then
		customSecondaryColor = { GetVehicleCustomSecondaryColour(vehicle) }
	end

	local extras = {}
	for extraId = 0, 20 do
		if DoesExtraExist(vehicle, extraId) then
			extras[tostring(extraId)] = IsVehicleExtraTurnedOn(vehicle, extraId)
		end
	end

	--[[
	local doorsBroken, windowsBroken, tyreBurst = {}, {}, {}
	local numWheels = tostring(GetVehicleNumberOfWheels(vehicle))

	local TyresIndex = {-- Wheel index list according to the number of vehicle wheels.
		["2"] = { 0, 4 }, -- Bike and cycle.
		["3"] = { 0, 1, 4, 5 }, -- Vehicle with 3 wheels (get for wheels because some 3 wheels vehicles have 2 wheels on front and one rear or the reverse).
		["4"] = { 0, 1, 4, 5 }, -- Vehicle with 4 wheels.
		["6"] = { 0, 1, 2, 3, 4, 5 } -- Vehicle with 6 wheels.
	}

	if TyresIndex[numWheels] then
		for _, idx in pairs(TyresIndex[numWheels]) do
			tyreBurst[tostring(idx)] = IsVehicleTyreBurst(vehicle, idx, false)
		end
	end

	for windowId = 0, 7 do -- 13
		RollUpWindow(vehicle, windowId) --fix when you put the car away with the window down
		windowsBroken[tostring(windowId)] = not IsVehicleWindowIntact(vehicle, windowId)
	end

	local numDoors = GetNumberOfVehicleDoors(vehicle)
	if numDoors and numDoors > 0 then
		for doorsId = 0, numDoors do
			doorsBroken[tostring(doorsId)] = IsVehicleDoorDamaged(vehicle, doorsId)
		end
	end
	]]

	return {
		model = GetEntityModel(vehicle),
		--doorsBroken = doorsBroken,
		--windowsBroken = windowsBroken,
		--tyreBurst = tyreBurst,
		--tyresCanBurst = GetVehicleTyresCanBurst(vehicle),
		plate = TrimedValue(GetVehicleNumberPlateText(vehicle)),
		plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

		--bodyHealth = RoundedValue(GetVehicleBodyHealth(vehicle), 1),
		--engineHealth = RoundedValue(GetVehicleEngineHealth(vehicle), 1),
		--tankHealth = RoundedValue(GetVehiclePetrolTankHealth(vehicle), 1),

		--fuelLevel = RoundedValue(GetVehicleFuelLevel(vehicle), 1),
		--dirtLevel = RoundedValue(GetVehicleDirtLevel(vehicle), 1),
		color1 = colorPrimary,
		color2 = colorSecondary,
		customPrimaryColor = customPrimaryColor,
		customSecondaryColor = customSecondaryColor,

		pearlescentColor = pearlescentColor,
		wheelColor = wheelColor,

		dashboardColor = dashboardColor,
		interiorColor = interiorColor,

		wheels = GetVehicleWheelType(vehicle),
		windowTint = GetVehicleWindowTint(vehicle),
		xenonColor = GetVehicleXenonLightsColor(vehicle),
		customXenonColor = customXenonColor,

		neonEnabled = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
		extras = extras,
		tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers = GetVehicleMod(vehicle, 0),
		modFrontBumper = GetVehicleMod(vehicle, 1),
		modRearBumper = GetVehicleMod(vehicle, 2),
		modSideSkirt = GetVehicleMod(vehicle, 3),
		modExhaust = GetVehicleMod(vehicle, 4),
		modFrame = GetVehicleMod(vehicle, 5),
		modGrille = GetVehicleMod(vehicle, 6),
		modHood = GetVehicleMod(vehicle, 7),
		modFender = GetVehicleMod(vehicle, 8),
		modRightFender = GetVehicleMod(vehicle, 9),
		modRoof = GetVehicleMod(vehicle, 10),
		modRoofLivery = GetVehicleRoofLivery(vehicle),

		modEngine = GetVehicleMod(vehicle, 11),
		modBrakes = GetVehicleMod(vehicle, 12),
		modTransmission = GetVehicleMod(vehicle, 13),
		modHorns = GetVehicleMod(vehicle, 14),
		modSuspension = GetVehicleMod(vehicle, 15),
		modArmor = GetVehicleMod(vehicle, 16),

		modTurbo = IsToggleModOn(vehicle, 18),
		modSmokeEnabled = IsToggleModOn(vehicle, 20),
		modXenon = IsToggleModOn(vehicle, 22),

		modFrontWheels = GetVehicleMod(vehicle, 23),
		modCustomFrontWheels = GetVehicleModVariation(vehicle, 23),
		modBackWheels = GetVehicleMod(vehicle, 24),
		modCustomBackWheels = GetVehicleModVariation(vehicle, 24),

		modPlateHolder = GetVehicleMod(vehicle, 25),
		modVanityPlate = GetVehicleMod(vehicle, 26),
		modTrimA = GetVehicleMod(vehicle, 27),
		modOrnaments = GetVehicleMod(vehicle, 28),
		modDashboard = GetVehicleMod(vehicle, 29),
		modDial = GetVehicleMod(vehicle, 30),
		modDoorSpeaker = GetVehicleMod(vehicle, 31),
		modSeats = GetVehicleMod(vehicle, 32),
		modSteeringWheel = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate = GetVehicleMod(vehicle, 35),
		modSpeakers = GetVehicleMod(vehicle, 36),
		modTrunk = GetVehicleMod(vehicle, 37),
		modHydrolic = GetVehicleMod(vehicle, 38),
		modEngineBlock = GetVehicleMod(vehicle, 39),
		modAirFilter = GetVehicleMod(vehicle, 40),
		modStruts = GetVehicleMod(vehicle, 41),
		modArchCover = GetVehicleMod(vehicle, 42),
		modAerials = GetVehicleMod(vehicle, 43),
		modTrimB = GetVehicleMod(vehicle, 44),
		modTank = GetVehicleMod(vehicle, 45),
		modWindows = GetVehicleMod(vehicle, 46),
		modLivery = GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) or GetVehicleMod(vehicle, 48),
		modLightbar = GetVehicleMod(vehicle, 49)
	}
end

function SetVehicleProperties(vehicle, props)
	if not DoesEntityExist(vehicle) or (type(props) ~= "table") then
		return
	end
	local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	SetVehicleModKit(vehicle, 0)

	if props.tyresCanBurst ~= nil then
		SetVehicleTyresCanBurst(vehicle, props.tyresCanBurst)
	end
	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end
	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end
	if props.bodyHealth ~= nil then
		SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
	end
	if props.engineHealth ~= nil then
		SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
	end
	if props.tankHealth ~= nil then
		SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0)
	end
	if props.fuelLevel ~= nil then
		SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
	end
	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
	end
	if props.customPrimaryColor ~= nil then
		SetVehicleCustomPrimaryColour(vehicle, props.customPrimaryColor[1], props.customPrimaryColor[2], props.customPrimaryColor[3])
	end
	if props.customSecondaryColor ~= nil then
		SetVehicleCustomSecondaryColour(vehicle, props.customSecondaryColor[1], props.customSecondaryColor[2], props.customSecondaryColor[3])
	end
	if props.color1 ~= nil then
		SetVehicleColours(vehicle, props.color1, colorSecondary)
	end
	if props.color2 ~= nil then
		SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2)
	end
	if props.pearlescentColor ~= nil then
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end
	if props.interiorColor ~= nil then
		SetVehicleInteriorColor(vehicle, props.interiorColor)
	end
	if props.dashboardColor ~= nil then
		SetVehicleDashboardColor(vehicle, props.dashboardColor)
	end
	if props.wheelColor ~= nil then
		SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
	end
	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end
	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end
	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end
	if props.extras ~= nil then
		for extraId, enabled in pairs(props.extras) do
			SetVehicleExtra(vehicle, tonumber(extraId), enabled and 0 or 1)
		end
	end
	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end
	if props.xenonColor ~= nil then
		SetVehicleXenonLightsColor(vehicle, props.xenonColor)
	end
	if props.customXenonColor ~= nil then
		SetVehicleXenonLightsCustomColor(vehicle, props.customXenonColor[1], props.customXenonColor[2],
			props.customXenonColor[3])
	end
	if props.modSmokeEnabled ~= nil then
		ToggleVehicleMod(vehicle, 20, true)
	end
	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end
	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end
	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end
	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end
	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end
	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end
	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end
	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end
	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end
	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end
	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end
	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end
	if props.modRoofLivery ~= nil then
		SetVehicleRoofLivery(vehicle, props.modRoofLivery)
	end
	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end
	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end
	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end
	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end
	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end
	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end
	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle, 18, props.modTurbo)
	end
	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle, 22, props.modXenon)
	end
	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomFrontWheels)
	end
	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomBackWheels)
	end
	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end
	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end
	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end
	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end
	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end
	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end
	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end
	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end
	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end
	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end
	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end
	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end
	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end
	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end
	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end
	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end
	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end
	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end
	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end
	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end
	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end
	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end
	if props.modLivery ~= nil then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end
	if props.windowsBroken ~= nil then
		for k, v in pairs(props.windowsBroken) do
			if v then
				RemoveVehicleWindow(vehicle, tonumber(k))
			end
		end
	end
	if props.doorsBroken ~= nil then
		for k, v in pairs(props.doorsBroken) do
			if v then
				SetVehicleDoorBroken(vehicle, tonumber(k), true)
			end
		end
	end
	if props.tyreBurst ~= nil then
		for k, v in pairs(props.tyreBurst) do
			if v then
				SetVehicleTyreBurst(vehicle, tonumber(k), true, 1000.0)
			end
		end
	end
end