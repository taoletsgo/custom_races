local maxFilter = 1024
local maxScanRadius = 50 -- 50 * 100 meters
local maxObjects = 350
local maxEffects = 10
local sleep = 250 -- 0 = 5+ ms, 250 = 0.3 ms, 1000 = 0.02 ms (but not recommended)
local speedup = {15, 25, 35, 45, 100}
local speedup_duration = {0.3, 0.4, 0.5, 0.5, 0.5}
local slowdown = {44, 30, 16}

objectPool = {
	forceLoad = {x = nil, y = nil, z = nil},
	all = {},
	grids = {},
	effects = {},
	requests = {},
	filter = {},
	filterAdded = {},
	filterKeep = {},
	effectsFilter = {},
	effectsFilterKeep = {},
	activeGrids = {},
	activeObjects = {},
	activeEffects = {}
}

function IsNearbyGridReady(gx, gy)
	if not objectPool.grids[gx] or not objectPool.grids[gx][gy] or TableCount(objectPool.grids[gx][gy]) == 0 then
		return true, 0
	end
	if objectPool.activeGrids[gx .. "-" .. gy] then
		return true, 1
	end
	local totalCount = 0
	local explodedCount = 0
	for uniqueId, object in pairs(objectPool.grids[gx][gy]) do
		totalCount = totalCount + 1
		explodedCount = explodedCount + (object.exploded and 1 or 0)
	end
	return totalCount == explodedCount, totalCount
end

function IsNearbyObjectsSpawned(x, y)
	local gx_center = math.floor(x / 100.0)
	local gy_center = math.floor(y / 100.0)
	local ok_center, count_center = IsNearbyGridReady(gx_center, gy_center)
	if not ok_center then
		return false
	end
	if count_center > 0 then
		return true
	end
	local readyCount = 0
	local offsets = {{-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}}
	for i = 1, #offsets do
		local ok, count = IsNearbyGridReady(gx_center + offsets[i][1], gy_center + offsets[i][2])
		if ok then
			if count > 0 then
				return true
			end
			readyCount = readyCount + 1
		end
	end
	return readyCount == #offsets
end

function GetNearbyObjects(pos, gx, gy)
	if objectPool.grids[gx] and objectPool.grids[gx][gy] and TableCount(objectPool.grids[gx][gy]) > 0 then
		for uniqueId, object in pairs(objectPool.grids[gx][gy]) do
			if not objectPool.filterAdded[object.uniqueId] and not object.exploded then
				local _, _, radius = GetModelDimensionsInCaches(object.hash)
				objectPool.filter[#objectPool.filter + 1] = {
					distance = #(pos - vector3(object.x, object.y, object.z)) - radius,
					object = object
				}
				objectPool.filterAdded[object.uniqueId] = true
				if #objectPool.filter >= maxFilter then return true end
			end
		end
	end
	return false
end

function SpawnNearbyObjects()
	Citizen.CreateThread(function()
		while status ~= "freemode" do
			local pos = vector3(0.0, 0.0, 0.0)
			if objectPool.forceLoad.x and objectPool.forceLoad.y and objectPool.forceLoad.z then
				pos = vector3(objectPool.forceLoad.x, objectPool.forceLoad.y, objectPool.forceLoad.z)
			else
				local coords = GetEntityCoords(PlayerPedId())
				pos = vector3(RoundedValue(coords.x, 3), RoundedValue(coords.y, 3), RoundedValue(coords.z, 3))
			end
			local gx = math.floor(pos.x / 100.0)
			local gy = math.floor(pos.y / 100.0)
			objectPool.filter = {}
			objectPool.filterAdded = {}
			objectPool.filterKeep = {}
			objectPool.effectsFilter = {}
			objectPool.effectsFilterKeep = {}
			objectPool.activeGrids = {}
			if not GetNearbyObjects(pos, gx, gy) then
				for r = 1, maxScanRadius do
					for i = -r, r - 1 do
						if GetNearbyObjects(pos, gx + i, gy + r) then break end
					end
					if #objectPool.filter >= maxFilter then break end
					for i = r, -r + 1, -1 do
						if GetNearbyObjects(pos, gx + r, gy + i) then break end
					end
					if #objectPool.filter >= maxFilter then break end
					for i = r, -r + 1, -1 do
						if GetNearbyObjects(pos, gx + i, gy - r) then break end
					end
					if #objectPool.filter >= maxFilter then break end
					for i = -r, r - 1 do
						if GetNearbyObjects(pos, gx - r, gy + i) then break end
					end
					if #objectPool.filter >= maxFilter then break end
				end
			end
			if #objectPool.filter >= 2 then
				table.sort(objectPool.filter, function(a, b) return a.distance < b.distance end)
			end
			for i = 1, maxObjects do
				local data = objectPool.filter[i] or {}
				local object = data.object or {}
				local uniqueId = object.uniqueId
				if uniqueId and objectPool.all[uniqueId] then
					objectPool.filterKeep[uniqueId] = true
					objectPool.activeObjects[uniqueId] = object
					if objectPool.effects[uniqueId] then
						objectPool.effectsFilter[#objectPool.effectsFilter + 1] = objectPool.effects[uniqueId]
					end
				end
			end
			for i = 1, maxEffects do
				local effectData = objectPool.effectsFilter[i] or {}
				local object = effectData.object or {}
				local uniqueId = object.uniqueId
				if uniqueId and objectPool.effects[uniqueId] then
					objectPool.effectsFilterKeep[uniqueId] = true
					objectPool.activeEffects[uniqueId] = effectData
				end
			end
			local effectsCount = TableCount(objectPool.activeEffects)
			if effectsCount > maxEffects then
				for uniqueId, effectData in pairs(objectPool.activeEffects) do
					if not objectPool.effectsFilterKeep[uniqueId] then
						if effectData.ptfxHandle then
							StopParticleFxLooped(effectData.ptfxHandle, true)
							effectData.ptfxHandle = nil
						end
						objectPool.activeEffects[uniqueId] = nil
						effectsCount = effectsCount - 1
						if effectsCount <= maxEffects then break end
					end
				end
			end
			local objectsCount = TableCount(objectPool.activeObjects)
			if objectsCount > maxObjects then
				for uniqueId, object in pairs(objectPool.activeObjects) do
					if not objectPool.filterKeep[uniqueId] then
						if object.handle then
							DeleteObject(object.handle)
							object.handle = nil
						end
						objectPool.activeObjects[uniqueId] = nil
						objectsCount = objectsCount - 1
						if objectsCount <= maxObjects then break end
					end
				end
			end
			local requestsThisFrame = {}
			for uniqueId, object in pairs(objectPool.activeObjects) do
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
							if speedUpObjects[hash] then
								SetObjectStuntPropSpeedup(obj, speedup[prpsba or 2] or 25)
								SetObjectStuntPropDuration(obj, speedup_duration[prpsba or 2] or 0.4)
							end
							if slowDownObjects[hash] then
								SetObjectStuntPropSpeedup(obj, slowdown[prpsba or 2] or 30)
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
				objectPool.requests[hash] = true
				objectPool.activeGrids[objectPool.all[uniqueId] or "error"] = true
			end
			for uniqueId, effectData in pairs(objectPool.activeEffects) do
				if not effectData.ptfxHandle then
					StartEffectForObject(uniqueId, effectData.object, effectData.style)
				end
			end
			if status == "leaving" or status == "ending" then break end
			Citizen.Wait(sleep)
		end
		Citizen.Wait(3000)
		for uniqueId, effectData in pairs(objectPool.activeEffects) do
			if effectData.ptfxHandle then
				StopParticleFxLooped(effectData.ptfxHandle, true)
				effectData.ptfxHandle = nil
			end
		end
		for uniqueId, object in pairs(objectPool.activeObjects) do
			if object.handle then
				DeleteObject(object.handle)
				object.handle = nil
			end
		end
		for hash, _ in pairs(objectPool.requests) do
			SetModelAsNoLongerNeeded(hash)
		end
		objectPool.forceLoad.x = nil
		objectPool.forceLoad.y = nil
		objectPool.forceLoad.z = nil
		objectPool.all = {}
		objectPool.grids = {}
		objectPool.effects = {}
		objectPool.requests = {}
		objectPool.filter = {}
		objectPool.filterAdded = {}
		objectPool.filterKeep = {}
		objectPool.effectsFilter = {}
		objectPool.effectsFilterKeep = {}
		objectPool.activeGrids = {}
		objectPool.activeObjects = {}
		objectPool.activeEffects = {}
	end)
end

function StartEffectForObject(uniqueId, object, style)
	Citizen.CreateThread(function()
		local ptfxHandle = nil
		local fxName = (style == 1) and "core" or "scr_stunts"
		RequestNamedPtfxAsset(fxName)
		while not HasNamedPtfxAssetLoaded(fxName) do Citizen.Wait(0) end
		local handle = object and object.handle
		if handle and DoesEntityExist(handle) and objectPool.effects[uniqueId] then
			local effectData = objectPool.activeEffects[uniqueId]
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