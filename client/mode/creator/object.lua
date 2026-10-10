function Creator.Function.Object.UpdateBySingleAxis(pos, q, axis, value)
	local posNew = pos
	local quatNew = q
	if axis == "x" then
		posNew = pos + Client.Function.Math.RotateVectorByQuaternion(q, vector3(1, 0, 0)) * value
	elseif axis == "y" then
		posNew = pos + Client.Function.Math.RotateVectorByQuaternion(q, vector3(0, 1, 0)) * value
	elseif axis == "z" then
		posNew = pos + Client.Function.Math.RotateVectorByQuaternion(q, vector3(0, 0, 1)) * value
	elseif axis == "rotX" then
		quatNew = q * quat(value, vector3(1, 0, 0))
	elseif axis == "rotY" then
		quatNew = q * quat(value, vector3(0, 1, 0))
	elseif axis == "rotZ" then
		quatNew = q * quat(value, vector3(0, 0, 1))
	end
	return posNew, quatNew
end

function Creator.Function.Object.GetBoneName(handle, boneIndex)
	if boneIndex == -28 then
		return Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneName-Center")
	elseif boneIndex >= -27 and boneIndex < -21 then
		return string.format(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneName-Face"), boneIndex + 28)
	elseif boneIndex >= -21 and boneIndex < -9 then
		return string.format(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneName-Edge"), boneIndex + 22)
	elseif boneIndex >= -9 and boneIndex < -1 then
		return string.format(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneName-Vertex"), boneIndex + 10)
	elseif boneIndex == -1 then
		return Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneName-Default")
	elseif boneIndex >= 0 and boneIndex <= GetEntityBoneCount(handle) - 1 then
		return string.format(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneName-Bone"), boneIndex + 1)
	else
		return ""
	end
end

function Creator.Function.Object.GetRelativePositionAndRotation(hash, handle, x, y, z, rotX, rotY, rotZ, boneIndex)
	local min, max = Client.Function.Shared.GetModelDimensionsInCaches(hash)
	if boneIndex == -28 then
		return GetOffsetFromEntityInWorldCoords(handle, (max.x + min.x) * 0.5, (max.y + min.y) * 0.5, (max.z + min.z) * 0.5), vector3(rotX, rotY, rotZ)
	elseif boneIndex >= -27 and boneIndex < -21 then
		if boneIndex == -27 then
			return GetOffsetFromEntityInWorldCoords(handle, (max.x + min.x) * 0.5, (max.y + min.y) * 0.5, max.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -26 then
			return GetOffsetFromEntityInWorldCoords(handle, (max.x + min.x) * 0.5, (max.y + min.y) * 0.5, min.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -25 then
			return GetOffsetFromEntityInWorldCoords(handle, (max.x + min.x) * 0.5, max.y, (max.z + min.z) * 0.5), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -24 then
			return GetOffsetFromEntityInWorldCoords(handle, (max.x + min.x) * 0.5, min.y, (max.z + min.z) * 0.5), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -23 then
			return GetOffsetFromEntityInWorldCoords(handle, max.x, (max.y + min.y) * 0.5, (max.z + min.z) * 0.5), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -22 then
			return GetOffsetFromEntityInWorldCoords(handle, min.x, (max.y + min.y) * 0.5, (max.z + min.z) * 0.5), vector3(rotX, rotY, rotZ)
		end
	elseif boneIndex >= -21 and boneIndex < -9 then
		local corners = {
			GetOffsetFromEntityInWorldCoords(handle, max.x, max.y, max.z),
			GetOffsetFromEntityInWorldCoords(handle, min.x, max.y, max.z),
			GetOffsetFromEntityInWorldCoords(handle, max.x, min.y, max.z),
			GetOffsetFromEntityInWorldCoords(handle, min.x, min.y, max.z),
			GetOffsetFromEntityInWorldCoords(handle, max.x, max.y, min.z),
			GetOffsetFromEntityInWorldCoords(handle, min.x, max.y, min.z),
			GetOffsetFromEntityInWorldCoords(handle, max.x, min.y, min.z),
			GetOffsetFromEntityInWorldCoords(handle, min.x, min.y, min.z)
		}
		local lines = {
			{1, 2}, {2, 4}, {4, 3}, {3, 1},
			{5, 6}, {6, 8}, {8, 7}, {7, 5},
			{1, 5}, {2, 6}, {3, 7}, {4, 8}
		}
		local p1, p2 = corners[lines[boneIndex + 22][1]], corners[lines[boneIndex + 22][2]]
		return (p1 + p2) * 0.5, vector3(rotX, rotY, rotZ)
	elseif boneIndex >= -9 and boneIndex < -1 then
		if boneIndex == -9 then
			return GetOffsetFromEntityInWorldCoords(handle, max.x, max.y, max.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -8 then
			return GetOffsetFromEntityInWorldCoords(handle, min.x, max.y, max.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -7 then
			return GetOffsetFromEntityInWorldCoords(handle, max.x, min.y, max.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -6 then
			return GetOffsetFromEntityInWorldCoords(handle, min.x, min.y, max.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -5 then
			return GetOffsetFromEntityInWorldCoords(handle, max.x, max.y, min.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -4 then
			return GetOffsetFromEntityInWorldCoords(handle, min.x, max.y, min.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -3 then
			return GetOffsetFromEntityInWorldCoords(handle, max.x, min.y, min.z), vector3(rotX, rotY, rotZ)
		elseif boneIndex == -2 then
			return GetOffsetFromEntityInWorldCoords(handle, min.x, min.y, min.z), vector3(rotX, rotY, rotZ)
		end
	elseif boneIndex == -1 then
		return vector3(x, y, z), vector3(rotX, rotY, rotZ)
	elseif boneIndex >= 0 and boneIndex <= GetEntityBoneCount(handle) - 1 then
		return GetWorldPositionOfEntityBone(handle, boneIndex), GetEntityBoneRotation(handle, boneIndex)
	else
		return nil, nil
	end
end

function Creator.Function.Object.GetNewPositionAndQuaternion(aPos, aQuat, bPos, bQuat, aPosNew, aQuatNew, axis, value)
	local relQuat = inv(aQuat) * bQuat
	local relPos = Client.Function.Math.RotateVectorByQuaternion(inv(aQuat), bPos - aPos)
	local aPosFinal, aQuatFinal, bPosFinal, bQuatFinal = nil, nil, nil, nil
	if aPosNew and aQuatNew then
		aPosFinal, aQuatFinal = aPosNew, aQuatNew
	elseif axis and value then
		aPosFinal, aQuatFinal = Creator.Function.Object.UpdateBySingleAxis(aPos, aQuat, axis, value)
	end
	if aPosFinal and aQuatFinal then
		bPosFinal = aPosFinal + Client.Function.Math.RotateVectorByQuaternion(aQuatFinal, relPos)
		bQuatFinal = aQuatFinal * relQuat
		return aPosFinal, aQuatFinal, bPosFinal, bQuatFinal
	else
		return aPos, aQuat, bPos, bQuat
	end
end

function Creator.Function.Object.GetOffsetPositionAndRotation()
	if Creator.Snapping.BoneIndexParent > GetEntityBoneCount(Creator.Snapping.Handle) - 1 then
		Creator.Snapping.BoneIndexParent = -1
	end
	local pos, rot = Creator.Function.Object.GetRelativePositionAndRotation(Creator.Snapping.ObjectData.hash, Creator.Snapping.ObjectData.handle, Creator.Snapping.ObjectData.x, Creator.Snapping.ObjectData.y, Creator.Snapping.ObjectData.z, Creator.Snapping.ObjectData.rotX, Creator.Snapping.ObjectData.rotY, Creator.Snapping.ObjectData.rotZ, Creator.Snapping.BoneIndexParent)
	if pos and rot then
		local q = Client.Function.Math.RotationToQuaternion(rot)
		local posInit, quatInit = pos, q
		for i = 1, #Creator.Snapping.Offset.steps do
			if Creator.Snapping.Offset.steps[i].sphericalMode then
				local _, _, posFinal, quatFinal = Creator.Function.Object.GetNewPositionAndQuaternion(posInit, quatInit, pos, q, nil, nil, Creator.Snapping.Offset.steps[i].axis, Creator.Snapping.Offset.steps[i].value)
				pos, q = posFinal, quatFinal
			else
				pos, q = Creator.Function.Object.UpdateBySingleAxis(pos, q, Creator.Snapping.Offset.steps[i].axis, Creator.Snapping.Offset.steps[i].value)
			end
		end
		Creator.Snapping.Offset.x = Client.Function.Math.RoundedValue(pos.x - posInit.x, 3)
		Creator.Snapping.Offset.y = Client.Function.Math.RoundedValue(pos.y - posInit.y, 3)
		Creator.Snapping.Offset.z = Client.Function.Math.RoundedValue(pos.z - posInit.z, 3)
		local deltaRot = Client.Function.Math.QuaternionToRotation(inv(quatInit) * q)
		Creator.Snapping.Offset.rotX = Client.Function.Math.RoundedValue(deltaRot.x, 3)
		Creator.Snapping.Offset.rotY = Client.Function.Math.RoundedValue(deltaRot.y, 3)
		Creator.Snapping.Offset.rotZ = Client.Function.Math.RoundedValue(deltaRot.z, 3)
	end
end

function Creator.Function.Object.SetNewPositionAndRotation(axis, value)
	if Creator.Object.OverrideRotIndex > GetEntityBoneCount(Creator.Object.Current.handle) - 1 then
		Creator.Object.OverrideRotIndex = -1
	end
	local aPos, aRot = Creator.Function.Object.GetRelativePositionAndRotation(Creator.Object.Current.hash, Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, Creator.Object.OverrideRotIndex)
	local bPos, bRot = vector3(Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z), vector3(Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ)
	if aPos and aRot then
		local aPosFinal, aQuatFinal, bPosFinal, bQuatFinal = Creator.Function.Object.GetNewPositionAndQuaternion(aPos, Client.Function.Math.RotationToQuaternion(aRot), bPos, Client.Function.Math.RotationToQuaternion(bRot), nil, nil, axis, value)
		local aRotFinal, bRotFinal = Client.Function.Math.QuaternionToRotation(aQuatFinal), Client.Function.Math.QuaternionToRotation(bQuatFinal)
		local overflow = false
		local newX = Client.Function.Math.RoundedValue(bPosFinal.x, 3)
		local newY = Client.Function.Math.RoundedValue(bPosFinal.y, 3)
		local newZ = Client.Function.Math.RoundedValue(bPosFinal.z, 3)
		local newRotX = Client.Function.Math.RoundedValue(bRotFinal.x, 3)
		local newRotY = Client.Function.Math.RoundedValue(bRotFinal.y, 3)
		local newRotZ = Client.Function.Math.RoundedValue(bRotFinal.z, 3)
		if (newX <= -16000.0) or (newX >= 16000.0) or (newY <= -16000.0) or (newY >= 16000.0) then
			overflow = true
			Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
		end
		if (newZ <= -200.0) or (newZ >= 2700.0) then
			overflow = true
			Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
		end
		if newRotX == -180.0 then newRotX = 180.0 end
		if newRotY == -180.0 then newRotY = 180.0 end
		if newRotZ == -180.0 then newRotZ = 180.0 end
		if not overflow then
			Creator.Object.Current.x = newX
			Creator.Object.Current.y = newY
			Creator.Object.Current.z = newZ
			Creator.Object.Current.rotX = newRotX
			Creator.Object.Current.rotY = newRotY
			Creator.Object.Current.rotZ = newRotZ
			SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
			SetEntityRotation(Creator.Object.Current.handle, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, 2, 0)
		end
	end
end

function Creator.Function.Object.SetNewPositionAndRotationEnhanced()
	if not Creator.Snapping.Handle or not Creator.Object.Current.handle or Creator.Object.IsPickedUp then return end
	local oldX = Creator.Object.Current.x
	local oldY = Creator.Object.Current.y
	local oldZ = Creator.Object.Current.z
	if Creator.Snapping.BoneIndexParent > GetEntityBoneCount(Creator.Snapping.Handle) - 1 then
		Creator.Snapping.BoneIndexParent = -1
	end
	if Creator.Snapping.BoneIndexChild > GetEntityBoneCount(Creator.Object.Current.handle) - 1 then
		Creator.Snapping.BoneIndexChild = -1
	end
	local aPosNew, aRotNew = Creator.Function.Object.GetRelativePositionAndRotation(Creator.Snapping.ObjectData.hash, Creator.Snapping.ObjectData.handle, Creator.Snapping.ObjectData.x, Creator.Snapping.ObjectData.y, Creator.Snapping.ObjectData.z, Creator.Snapping.ObjectData.rotX, Creator.Snapping.ObjectData.rotY, Creator.Snapping.ObjectData.rotZ, Creator.Snapping.BoneIndexParent)
	local aPos, aRot = Creator.Function.Object.GetRelativePositionAndRotation(Creator.Object.Current.hash, Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, Creator.Snapping.BoneIndexChild)
	local bPos, bRot = vector3(Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z), vector3(Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ)
	if aPos and aRot and aPosNew and aRotNew then
		local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
		local posInit, quatInit = aPosNew, aQuatNew
		for i = 1, #Creator.Snapping.Offset.steps do
			if Creator.Snapping.Offset.steps[i].sphericalMode then
				local _, _, posFinal, quatFinal = Creator.Function.Object.GetNewPositionAndQuaternion(posInit, quatInit, aPosNew, aQuatNew, nil, nil, Creator.Snapping.Offset.steps[i].axis, Creator.Snapping.Offset.steps[i].value)
				aPosNew, aQuatNew = posFinal, quatFinal
			else
				aPosNew, aQuatNew = Creator.Function.Object.UpdateBySingleAxis(aPosNew, aQuatNew, Creator.Snapping.Offset.steps[i].axis, Creator.Snapping.Offset.steps[i].value)
			end
		end
		local aPosFinal, aQuatFinal, bPosFinal, bQuatFinal = Creator.Function.Object.GetNewPositionAndQuaternion(aPos, Client.Function.Math.RotationToQuaternion(aRot), bPos, Client.Function.Math.RotationToQuaternion(bRot), aPosNew, aQuatNew, nil, nil)
		local aRotFinal, bRotFinal = Client.Function.Math.QuaternionToRotation(aQuatFinal), Client.Function.Math.QuaternionToRotation(bQuatFinal)
		local overflow = false
		local newX = Client.Function.Math.RoundedValue(bPosFinal.x, 3)
		local newY = Client.Function.Math.RoundedValue(bPosFinal.y, 3)
		local newZ = Client.Function.Math.RoundedValue(bPosFinal.z, 3)
		local newRotX = Client.Function.Math.RoundedValue(bRotFinal.x, 3)
		local newRotY = Client.Function.Math.RoundedValue(bRotFinal.y, 3)
		local newRotZ = Client.Function.Math.RoundedValue(bRotFinal.z, 3)
		if (newX <= -16000.0) or (newX >= 16000.0) or (newY <= -16000.0) or (newY >= 16000.0) then
			overflow = true
			Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
		end
		if (newZ <= -200.0) or (newZ >= 2700.0) then
			overflow = true
			Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
		end
		if newRotX == -180.0 then newRotX = 180.0 end
		if newRotY == -180.0 then newRotY = 180.0 end
		if newRotZ == -180.0 then newRotZ = 180.0 end
		if not overflow then
			Creator.Object.Current.x = newX
			Creator.Object.Current.y = newY
			Creator.Object.Current.z = newZ
			Creator.Object.Current.rotX = newRotX
			Creator.Object.Current.rotY = newRotY
			Creator.Object.Current.rotZ = newRotZ
			SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
			SetEntityRotation(Creator.Object.Current.handle, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, 2, 0)
			SetEntityCollision(Creator.Object.Current.handle, false, false)
			if oldZ ~= Creator.Object.Current.z then
				Creator.Object.PreviewCoordsChanged = true
				Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
			elseif oldX ~= Creator.Object.Current.x or oldY ~= Creator.Object.Current.y then
				Creator.Object.PreviewCoordsChanged = true
			end
		end
	end
end

function Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
	local aPos, aRot = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
	for i = 1, #Creator.Template.Preview do
		local bPos, bRot = vector3(Creator.Template.Preview[i].x, Creator.Template.Preview[i].y, Creator.Template.Preview[i].z), vector3(Creator.Template.Preview[i].rotX, Creator.Template.Preview[i].rotY, Creator.Template.Preview[i].rotZ)
		local aPosFinal, aQuatFinal, bPosFinal, bQuatFinal = Creator.Function.Object.GetNewPositionAndQuaternion(aPos, Client.Function.Math.RotationToQuaternion(aRot), bPos, Client.Function.Math.RotationToQuaternion(bRot), aPosNew, aQuatNew, nil, nil)
		local aRotFinal, bRotFinal = Client.Function.Math.QuaternionToRotation(aQuatFinal), Client.Function.Math.QuaternionToRotation(bQuatFinal)
		local newRotX = Client.Function.Math.RoundedValue(bRotFinal.x, 3)
		local newRotY = Client.Function.Math.RoundedValue(bRotFinal.y, 3)
		local newRotZ = Client.Function.Math.RoundedValue(bRotFinal.z, 3)
		if newRotX == -180.0 then newRotX = 180.0 end
		if newRotY == -180.0 then newRotY = 180.0 end
		if newRotZ == -180.0 then newRotZ = 180.0 end
		Creator.Template.Preview[i].x = Client.Function.Math.RoundedValue(bPosFinal.x, 3)
		Creator.Template.Preview[i].y = Client.Function.Math.RoundedValue(bPosFinal.y, 3)
		Creator.Template.Preview[i].z = Client.Function.Math.RoundedValue(bPosFinal.z, 3)
		Creator.Template.Preview[i].rotX = newRotX
		Creator.Template.Preview[i].rotY = newRotY
		Creator.Template.Preview[i].rotZ = newRotZ
		if (Creator.Template.Preview[i].x > -16000.0) and (Creator.Template.Preview[i].x < 16000.0) and (Creator.Template.Preview[i].y > -16000.0) and (Creator.Template.Preview[i].y < 16000.0) and (Creator.Template.Preview[i].z > -200.0) and (Creator.Template.Preview[i].z < 2700.0) then
			SetEntityCoordsNoOffset(Creator.Template.Preview[i].handle, Creator.Template.Preview[i].x, Creator.Template.Preview[i].y, Creator.Template.Preview[i].z)
			SetEntityRotation(Creator.Template.Preview[i].handle, Creator.Template.Preview[i].rotX, Creator.Template.Preview[i].rotY, Creator.Template.Preview[i].rotZ, 2, 0)
		end
	end
end