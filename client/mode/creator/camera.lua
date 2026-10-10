function Creator.Function.Camera.Create(ped, pos, rotZ)
	ClearPedTasksImmediately(ped)
	FreezeEntityPosition(ped, true)
	SetEntityVisible(ped, false)
	SetEntityCollision(ped, false, false)
	SetEntityCompletelyDisableCollision(ped, false, false)
	Creator.Camera.Position = Creator.Camera.Position or (pos + vector3(0.0, 0.0, 50.0))
	Creator.Camera.Rotation = Creator.Camera.Rotation or {x = -30.0, y = 0.0, z = rotZ}
	Creator.Camera.Handle = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Creator.Camera.Position.x, Creator.Camera.Position.y, Creator.Camera.Position.z, Creator.Camera.Rotation.x, Creator.Camera.Rotation.y, Creator.Camera.Rotation.z, 60.0)
	SetCamActive(Creator.Camera.Handle, true)
	RenderScriptCams(true, false, 0, true, true)
end

function Creator.Function.Camera.GetForwardVector()
	local heading = Creator.Camera.Rotation.z
	local x = -math.sin(math.rad(heading))
	local y = math.cos(math.rad(heading))
	local z = 0.0
	return vector3(x, y, z)
end

function Creator.Function.Camera.GetForwardVector_2()
	local heading = Creator.Camera.Rotation.z
	local pitch = Creator.Camera.Rotation.x
	local x = -math.sin(math.rad(heading)) * math.cos(math.rad(pitch))
	local y = math.cos(math.rad(heading)) * math.cos(math.rad(pitch))
	local z = math.sin(math.rad(pitch))
	return vector3(x, y, z)
end

function Creator.Function.Camera.GetRightVector()
	local heading = Creator.Camera.Rotation.z
	local x = math.cos(math.rad(heading))
	local y = math.sin(math.rad(heading))
	return vector3(x, y, 0.0)
end

function Creator.Function.Camera.GetEntityAndEndCoords(flag, ignore)
	if Creator.Camera.Handle ~= nil then
		local x, y, z = Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0
		local forwardVector = Creator.Function.Camera.GetForwardVector_2()
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
		local ray = StartShapeTestRay(x, y, z, endX, endY, endZ, flag, ignore, 0)
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

function Creator.Function.Camera.GetEndXY(targetZ)
	if Creator.Camera.Handle ~= nil then
		local forwardVector = Creator.Function.Camera.GetForwardVector_2()
		local num = forwardVector.z ~= 0.0 and ((targetZ - Creator.Camera.Position.z) / forwardVector.z)
		if num and num > 0.0 then
			local x, y = Client.Function.Math.RoundedValue(Creator.Camera.Position.x + forwardVector.x * num + 0.0, 3), Client.Function.Math.RoundedValue(Creator.Camera.Position.y + forwardVector.y * num + 0.0, 3)
			if (x > -16000.0) and (x < 16000.0) and (y > -16000.0) and (y < 16000.0) then
				return x, y
			end
		end
	end
	return nil, nil
end