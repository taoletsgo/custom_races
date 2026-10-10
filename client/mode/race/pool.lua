local maxFilter = 1024
local maxScanRadius = 50 -- 50 * 100 meters
local maxObjects = 350
local maxEffects = 10
local sleep = 250 -- 0 = 5+ ms, 250 = 0.3 ms, 1000 = 0.02 ms (but not recommended)
local speedup = {15, 25, 35, 45, 100}
local speedupDuration = {0.3, 0.4, 0.5, 0.5, 0.5}
local slowDown = {44, 30, 16}

Race.ObjectPool = {}
Race.ObjectPool.ForceLoad = {x = nil, y = nil, z = nil}
Race.ObjectPool.All = {}
Race.ObjectPool.Grids = {}
Race.ObjectPool.Effects = {}
Race.ObjectPool.Requests = {}
Race.ObjectPool.Filter = {}
Race.ObjectPool.FilterAdded = {}
Race.ObjectPool.FilterKeep = {}
Race.ObjectPool.EffectsFilter = {}
Race.ObjectPool.EffectsFilterKeep = {}
Race.ObjectPool.ActiveGrids = {}
Race.ObjectPool.ActiveObjects = {}
Race.ObjectPool.ActiveEffects = {}

function Race.Function.Pool.IsNearbyGridReady(gx, gy)
	if not Race.ObjectPool.Grids[gx] or not Race.ObjectPool.Grids[gx][gy] or Client.Function.Math.TableCount(Race.ObjectPool.Grids[gx][gy]) == 0 then
		return true, 0
	end
	if Race.ObjectPool.ActiveGrids[gx .. "-" .. gy] then
		return true, 1
	end
	local totalCount = 0
	local explodedCount = 0
	for uniqueId, object in pairs(Race.ObjectPool.Grids[gx][gy]) do
		totalCount = totalCount + 1
		explodedCount = explodedCount + (object.exploded and 1 or 0)
	end
	return totalCount == explodedCount, totalCount
end

function Race.Function.Pool.IsNearbyObjectsSpawned(x, y)
	local gxCenter = math.floor(x / 100.0)
	local gyCenter = math.floor(y / 100.0)
	local okCenter, countCenter = Race.Function.Pool.IsNearbyGridReady(gxCenter, gyCenter)
	if not okCenter then
		return false
	end
	if countCenter > 0 then
		return true
	end
	local readyCount = 0
	local offsets = {{-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}}
	for i = 1, #offsets do
		local ok, count = Race.Function.Pool.IsNearbyGridReady(gxCenter + offsets[i][1], gyCenter + offsets[i][2])
		if ok then
			if count > 0 then
				return true
			end
			readyCount = readyCount + 1
		end
	end
	return readyCount == #offsets
end

function Race.Function.Pool.GetNearbyObjects(pos, gx, gy)
	if Race.ObjectPool.Grids[gx] and Race.ObjectPool.Grids[gx][gy] and Client.Function.Math.TableCount(Race.ObjectPool.Grids[gx][gy]) > 0 then
		for uniqueId, object in pairs(Race.ObjectPool.Grids[gx][gy]) do
			if not Race.ObjectPool.FilterAdded[object.uniqueId] and not object.exploded then
				local _, _, radius = Client.Function.Shared.GetModelDimensionsInCaches(object.hash)
				Race.ObjectPool.Filter[#Race.ObjectPool.Filter + 1] = {
					distance = #(pos - vector3(object.x, object.y, object.z)) - radius,
					object = object
				}
				Race.ObjectPool.FilterAdded[object.uniqueId] = true
				if #Race.ObjectPool.Filter >= maxFilter then return true end
			end
		end
	end
	return false
end

function Race.Function.Pool.SpawnNearbyObjects()
	CreateThread(function()
		while Client.IsInRace do
			local pos = vector3(0.0, 0.0, 0.0)
			if Race.ObjectPool.ForceLoad.x and Race.ObjectPool.ForceLoad.y and Race.ObjectPool.ForceLoad.z then
				pos = vector3(Race.ObjectPool.ForceLoad.x, Race.ObjectPool.ForceLoad.y, Race.ObjectPool.ForceLoad.z)
			else
				local coords = GetEntityCoords(PlayerPedId())
				pos = vector3(Client.Function.Math.RoundedValue(coords.x, 3), Client.Function.Math.RoundedValue(coords.y, 3), Client.Function.Math.RoundedValue(coords.z, 3))
			end
			local gx = math.floor(pos.x / 100.0)
			local gy = math.floor(pos.y / 100.0)
			Race.ObjectPool.Filter = {}
			Race.ObjectPool.FilterAdded = {}
			Race.ObjectPool.FilterKeep = {}
			Race.ObjectPool.EffectsFilter = {}
			Race.ObjectPool.EffectsFilterKeep = {}
			Race.ObjectPool.ActiveGrids = {}
			if not Race.Function.Pool.GetNearbyObjects(pos, gx, gy) then
				for r = 1, maxScanRadius do
					for i = -r, r - 1 do
						if Race.Function.Pool.GetNearbyObjects(pos, gx + i, gy + r) then break end
					end
					if #Race.ObjectPool.Filter >= maxFilter then break end
					for i = r, -r + 1, -1 do
						if Race.Function.Pool.GetNearbyObjects(pos, gx + r, gy + i) then break end
					end
					if #Race.ObjectPool.Filter >= maxFilter then break end
					for i = r, -r + 1, -1 do
						if Race.Function.Pool.GetNearbyObjects(pos, gx + i, gy - r) then break end
					end
					if #Race.ObjectPool.Filter >= maxFilter then break end
					for i = -r, r - 1 do
						if Race.Function.Pool.GetNearbyObjects(pos, gx - r, gy + i) then break end
					end
					if #Race.ObjectPool.Filter >= maxFilter then break end
				end
			end
			if #Race.ObjectPool.Filter >= 2 then
				table.sort(Race.ObjectPool.Filter, function(a, b) return a.distance < b.distance end)
			end
			for i = 1, maxObjects do
				local data = Race.ObjectPool.Filter[i] or {}
				local object = data.object or {}
				local uniqueId = object.uniqueId
				if uniqueId and Race.ObjectPool.All[uniqueId] then
					Race.ObjectPool.FilterKeep[uniqueId] = true
					Race.ObjectPool.ActiveObjects[uniqueId] = object
					if Race.ObjectPool.Effects[uniqueId] then
						Race.ObjectPool.EffectsFilter[#Race.ObjectPool.EffectsFilter + 1] = Race.ObjectPool.Effects[uniqueId]
					end
				end
			end
			for i = 1, maxEffects do
				local effectData = Race.ObjectPool.EffectsFilter[i] or {}
				local object = effectData.object or {}
				local uniqueId = object.uniqueId
				if uniqueId and Race.ObjectPool.Effects[uniqueId] then
					Race.ObjectPool.EffectsFilterKeep[uniqueId] = true
					Race.ObjectPool.ActiveEffects[uniqueId] = effectData
				end
			end
			local effectsCount = Client.Function.Math.TableCount(Race.ObjectPool.ActiveEffects)
			if effectsCount > maxEffects then
				for uniqueId, effectData in pairs(Race.ObjectPool.ActiveEffects) do
					if not Race.ObjectPool.EffectsFilterKeep[uniqueId] then
						if effectData.ptfxHandle then
							StopParticleFxLooped(effectData.ptfxHandle, true)
							effectData.ptfxHandle = nil
						end
						Race.ObjectPool.ActiveEffects[uniqueId] = nil
						effectsCount = effectsCount - 1
						if effectsCount <= maxEffects then break end
					end
				end
			end
			local objectsCount = Client.Function.Math.TableCount(Race.ObjectPool.ActiveObjects)
			if objectsCount > maxObjects then
				for uniqueId, object in pairs(Race.ObjectPool.ActiveObjects) do
					if not Race.ObjectPool.FilterKeep[uniqueId] then
						if object.handle then
							DeleteObject(object.handle)
							object.handle = nil
						end
						Race.ObjectPool.ActiveObjects[uniqueId] = nil
						objectsCount = objectsCount - 1
						if objectsCount <= maxObjects then break end
					end
				end
			end
			local requestsThisFrame = {}
			for uniqueId, object in pairs(Race.ObjectPool.ActiveObjects) do
				local hash, x, y, z, rotX, rotY, rotZ, color, prpsba, lod, visible, collision, dynamic = object.hash, object.x, object.y, object.z, object.rotX, object.rotY, object.rotZ, object.color, object.prpsba, object.lod, object.visible, object.collision, object.dynamic
				if not object.handle then
					if HasModelLoaded(hash) then
						local obj = CreateObjectNoOffset(hash, x, y, z, false, true, false)
						if obj == 0 then
							obj = CreateObjectNoOffset(hash, x, y, z, false, true, true)
						end
						if obj ~= 0 then
							SetEntityRotation(obj, rotX or 0.0, rotY or 0.0, rotZ or 0.0, 2, 0)
							SetObjectTextureVariation(obj, color or 0)
							if Client.Shared.Object.Speedup[hash] then
								SetObjectStuntPropSpeedup(obj, speedup[prpsba or 2] or 25)
								SetObjectStuntPropDuration(obj, speedupDuration[prpsba or 2] or 0.4)
							end
							if Client.Shared.Object.SlowDown[hash] then
								SetObjectStuntPropSpeedup(obj, slowDown[prpsba or 2] or 30)
							end
							if not visible then
								SetEntityVisible(obj, false)
							else
								SetEntityLodDist(obj, lod)
							end
							SetEntityCollision(obj, collision and true or false, collision and true or false)
							FreezeEntityPosition(obj, not dynamic and true or false)
							object.handle = obj
						end
					else
						if not requestsThisFrame[hash] then
							requestsThisFrame[hash] = true
							RequestModel(hash)
						end
					end
				end
				Race.ObjectPool.Requests[hash] = true
				Race.ObjectPool.ActiveGrids[Race.ObjectPool.All[uniqueId] or "error"] = true
			end
			for uniqueId, effectData in pairs(Race.ObjectPool.ActiveEffects) do
				if not effectData.ptfxHandle then
					Race.Function.Pool.StartEffectForObject(uniqueId, effectData.object, effectData.style)
				end
			end
			if Race.Status == "leaving" or Race.Status == "ending" then break end
			Wait(sleep)
		end
		Wait(3000)
		for uniqueId, effectData in pairs(Race.ObjectPool.ActiveEffects) do
			if effectData.ptfxHandle then
				StopParticleFxLooped(effectData.ptfxHandle, true)
				effectData.ptfxHandle = nil
			end
		end
		for uniqueId, object in pairs(Race.ObjectPool.ActiveObjects) do
			if object.handle then
				DeleteObject(object.handle)
				object.handle = nil
			end
		end
		for hash, _ in pairs(Race.ObjectPool.Requests) do
			SetModelAsNoLongerNeeded(hash)
		end
		Race.ObjectPool.ForceLoad.x = nil
		Race.ObjectPool.ForceLoad.y = nil
		Race.ObjectPool.ForceLoad.z = nil
		Race.ObjectPool.All = {}
		Race.ObjectPool.Grids = {}
		Race.ObjectPool.Effects = {}
		Race.ObjectPool.Requests = {}
		Race.ObjectPool.Filter = {}
		Race.ObjectPool.FilterAdded = {}
		Race.ObjectPool.FilterKeep = {}
		Race.ObjectPool.EffectsFilter = {}
		Race.ObjectPool.EffectsFilterKeep = {}
		Race.ObjectPool.ActiveGrids = {}
		Race.ObjectPool.ActiveObjects = {}
		Race.ObjectPool.ActiveEffects = {}
	end)
end

function Race.Function.Pool.StartEffectForObject(uniqueId, object, style)
	CreateThread(function()
		local ptfxHandle = nil
		local fxName = (style == 1) and "core" or "scr_stunts"
		RequestNamedPtfxAsset(fxName)
		while not HasNamedPtfxAssetLoaded(fxName) do Wait(0) end
		local handle = object and object.handle
		if handle and DoesEntityExist(handle) and Race.ObjectPool.Effects[uniqueId] then
			local effectData = Race.ObjectPool.ActiveEffects[uniqueId]
			if effectData and not effectData.ptfxHandle then
				UseParticleFxAssetNextCall(fxName)
				if style == 1 then
					ptfxHandle = StartParticleFxLoopedOnEntity("ent_amb_fire_ring", handle, 0.0, 0.0, 4.5, 0.0, 0.0, 90.0, 3.5, false, false, false)
				elseif style == 2 then
					ptfxHandle = StartParticleFxLoopedOnEntity("scr_stunts_fire_ring", handle, 0.0, 0.0, 11.5, -2.0, 0.0, 0.0, 0.47, false, false, false)
				elseif style == 3 then
					ptfxHandle = StartParticleFxLoopedOnEntity("scr_stunts_fire_ring", handle, 0.0, 0.0, 25.0, -12.5, 0.0, 0.0, 1.0, false, false, false)
				end
				if ptfxHandle and ptfxHandle ~= 0 then
					effectData.ptfxHandle = ptfxHandle
				end
			end
		end
	end)
end