function Client.Function.Math.RoundedValue(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function Client.Function.Math.TrimedValue(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function Client.Function.Math.TableCount(t)
	local c = 0
	for k, v in pairs(t) do
		c = c + 1
	end
	return c
end

function Client.Function.Math.StringCount(str)
	local c = 0
	for _ in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		c = c + 1
	end
	return c
end

function Client.Function.Math.CrossVec(vecA, vecB)
	return vector3(
		(vecA.y * vecB.z) - (vecA.z * vecB.y),
		(vecA.z * vecB.x) - (vecA.x * vecB.z),
		(vecA.x * vecB.y) - (vecA.y * vecB.x)
	)
end

function Client.Function.Math.NormVec(vec)
	local mag = #(vec)
	if mag ~= 0.0 then
		return vec / mag
	else
		return vector3(0.0, 0.0, 0.0)
	end
end

function Client.Function.Math.DotVec(vecA, vecB)
	return (vecA.x * vecB.x) + (vecA.y * vecB.y) + (vecA.z * vecB.z)
end

function Client.Function.Math.SetBitValue(x, n)
	return x | (1 << n)
end

function Client.Function.Math.IsBitSetValue(x, n)
	return (x & (1 << n)) ~= 0
end

function Client.Function.Math.ClearBitValue(x, n)
	return x & ~(1 << n)
end

function Client.Function.Math.RotationToQuaternion(rot)
	SetEntityRotation(Creator.GlobalVar.FakeObject, rot.x, rot.y, rot.z, 2, 0)
	local x, y, z, w = GetEntityQuaternion(Creator.GlobalVar.FakeObject)
	return quat(w, x, y, z)
end

function Client.Function.Math.QuaternionToRotation(q)
	SetEntityQuaternion(Creator.GlobalVar.FakeObject, q.x, q.y, q.z, q.w)
	local rot = GetEntityRotation(Creator.GlobalVar.FakeObject, 2)
	return rot
end

function Client.Function.Math.RotateVectorByQuaternion(q, v)
	local resQuat = q * quat(0.0, v.x, v.y, v.z) * inv(q)
	return vector3(resQuat.x, resQuat.y, resQuat.z)
end