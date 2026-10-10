local maxFilter = 1024
local maxScanRadius = 50 -- 50 * 100 meters
local maxObjects = 350
local maxEffects = 10
local sleep = 250 -- 0 = 5+ ms, 250 = 0.3 ms, 1000 = 0.02 ms (but not recommended)
local speedup = {15, 25, 35, 45, 100}
local speedupDuration = {0.3, 0.4, 0.5, 0.5, 0.5}
local slowDown = {44, 30, 16}

Creator.ObjectPool = {}
Creator.ObjectPool.IsRefreshing = false
Creator.ObjectPool.ForceLoad = {x = nil, y = nil, z = nil}
Creator.ObjectPool.All = {}
Creator.ObjectPool.Grids = {}
Creator.ObjectPool.Effects = {}
Creator.ObjectPool.Requests = {}
Creator.ObjectPool.Filter = {}
Creator.ObjectPool.FilterAdded = {}
Creator.ObjectPool.FilterKeep = {}
Creator.ObjectPool.EffectsFilter = {}
Creator.ObjectPool.EffectsFilterKeep = {}
Creator.ObjectPool.ActiveGrids = {}
Creator.ObjectPool.ActiveObjects = {}
Creator.ObjectPool.ActiveEffects = {}
Creator.ObjectPool.ChangedObjects = {}

function Creator.Function.Pool.RefreshGirdForObject(x, y, object)
	if not x or not y or not object or not object.uniqueId then return end
	local gxOld = math.floor(x / 100.0)
	local gyOld = math.floor(y / 100.0)
	local gxNew = math.floor(object.x / 100.0)
	local gyNew = math.floor(object.y / 100.0)
	if (gxOld ~= gxNew) or (gyOld ~= gyNew) then
		if Creator.ObjectPool.Grids[gxOld] and Creator.ObjectPool.Grids[gxOld][gyOld] then
			Creator.ObjectPool.Grids[gxOld][gyOld][object.uniqueId] = nil
		end
		Creator.ObjectPool.Grids[gxNew] = Creator.ObjectPool.Grids[gxNew] or {}
		Creator.ObjectPool.Grids[gxNew][gyNew] = Creator.ObjectPool.Grids[gxNew][gyNew] or {}
		Creator.ObjectPool.Grids[gxNew][gyNew][object.uniqueId] = object
		Creator.ObjectPool.All[object.uniqueId] = gxNew .. "-" .. gyNew
	end
end

function Creator.Function.Pool.RefreshAllGirds()
	CreateThread(function()
		Client.Function.Busyspinner.Display("refresh", 10000, #Creator.Track.Current.Objects + 10000)
		Wait(1000)
		local count = 0
		Creator.ObjectPool.All = {}
		Creator.ObjectPool.Grids = {}
		for _, object in pairs(Creator.Track.Current.Objects) do
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
			Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
			Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			count = count + 1
			if count >= 10000 then
				count = 0
				Wait(1000)
			end
		end
		RemoveLoadingPrompt()
		Client.Busyspinner.Status = nil
		Creator.ObjectPool.IsRefreshing = false
	end)
end

function Creator.Function.Pool.IsNearbyGridReady(gx, gy)
	if not Creator.ObjectPool.Grids[gx] or not Creator.ObjectPool.Grids[gx][gy] or Client.Function.Math.TableCount(Creator.ObjectPool.Grids[gx][gy]) == 0 then
		return true, 0
	end
	if Creator.ObjectPool.ActiveGrids[gx .. "-" .. gy] then
		return true, 1
	end
	local totalCount = 0
	local explodedCount = 0
	for uniqueId, object in pairs(Creator.ObjectPool.Grids[gx][gy]) do
		totalCount = totalCount + 1
		explodedCount = explodedCount + (object.exploded and 1 or 0)
	end
	return totalCount == explodedCount, totalCount
end

function Creator.Function.Pool.IsNearbyObjectsSpawned(x, y)
	local gxCenter = math.floor(x / 100.0)
	local gyCenter = math.floor(y / 100.0)
	local okCenter, countCenter = Creator.Function.Pool.IsNearbyGridReady(gxCenter, gyCenter)
	if not okCenter then
		return false
	end
	if countCenter > 0 then
		return true
	end
	local readyCount = 0
	local offsets = {{-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}, {-1, 0}}
	for i = 1, #offsets do
		local ok, count = Creator.Function.Pool.IsNearbyGridReady(gxCenter + offsets[i][1], gyCenter + offsets[i][2])
		if ok then
			if count > 0 then
				return true
			end
			readyCount = readyCount + 1
		end
	end
	return readyCount == #offsets
end

function Creator.Function.Pool.GetNearbyObjects(pos, gx, gy)
	if Creator.ObjectPool.Grids[gx] and Creator.ObjectPool.Grids[gx][gy] and Client.Function.Math.TableCount(Creator.ObjectPool.Grids[gx][gy]) > 0 then
		for uniqueId, object in pairs(Creator.ObjectPool.Grids[gx][gy]) do
			if not Creator.ObjectPool.FilterAdded[object.uniqueId] and not object.exploded then
				local _, _, radius = Client.Function.Shared.GetModelDimensionsInCaches(object.hash)
				Creator.ObjectPool.Filter[#Creator.ObjectPool.Filter + 1] = {
					distance = #(pos - vector3(object.x, object.y, object.z)) - radius,
					object = object
				}
				Creator.ObjectPool.FilterAdded[object.uniqueId] = true
				if #Creator.ObjectPool.Filter >= maxFilter then return true end
			end
		end
	end
	return false
end

function Creator.Function.Pool.SpawnNearbyObjects()
	CreateThread(function()
		while Client.IsInCreator and not Client.IsCreatorInQuiting do
			if not Creator.GlobalVar.QuitingTest and not Creator.GlobalVar.JoiningTest and not Creator.ObjectPool.IsRefreshing then
				local pos = vector3(0.0, 0.0, 0.0)
				if Creator.ObjectPool.ForceLoad.x and Creator.ObjectPool.ForceLoad.y and Creator.ObjectPool.ForceLoad.z then
					pos = vector3(Creator.ObjectPool.ForceLoad.x, Creator.ObjectPool.ForceLoad.y, Creator.ObjectPool.ForceLoad.z)
				else
					local coords = GetEntityCoords(PlayerPedId())
					pos = vector3(Client.Function.Math.RoundedValue(coords.x, 3), Client.Function.Math.RoundedValue(coords.y, 3), Client.Function.Math.RoundedValue(coords.z, 3))
				end
				local gx = math.floor(pos.x / 100.0)
				local gy = math.floor(pos.y / 100.0)
				Creator.ObjectPool.Filter = {}
				Creator.ObjectPool.FilterAdded = {}
				Creator.ObjectPool.FilterKeep = {}
				Creator.ObjectPool.EffectsFilter = {}
				Creator.ObjectPool.EffectsFilterKeep = {}
				Creator.ObjectPool.ActiveGrids = {}
				if Creator.Object.IsPickedUp and Creator.Object.Current.uniqueId then
					if Creator.ObjectPool.All[Creator.Object.Current.uniqueId] then
						Creator.ObjectPool.Filter[#Creator.ObjectPool.Filter + 1] = {
							distance = -9999.0,
							object = Creator.Object.Current
						}
						Creator.ObjectPool.FilterAdded[Creator.Object.Current.uniqueId] = true
					end
				end
				if Creator.Snapping.Handle and Creator.Snapping.ObjectData.uniqueId then
					if Creator.ObjectPool.All[Creator.Snapping.ObjectData.uniqueId] then
						Creator.ObjectPool.Filter[#Creator.ObjectPool.Filter + 1] = {
							distance = -9999.0,
							object = Creator.Snapping.ObjectData
						}
						Creator.ObjectPool.FilterAdded[Creator.Snapping.ObjectData.uniqueId] = true
					end
				end
				if not Creator.Function.Pool.GetNearbyObjects(pos, gx, gy) then
					for r = 1, maxScanRadius do
						for i = -r, r - 1 do
							if Creator.Function.Pool.GetNearbyObjects(pos, gx + i, gy + r) then break end
						end
						if #Creator.ObjectPool.Filter >= maxFilter then break end
						for i = r, -r + 1, -1 do
							if Creator.Function.Pool.GetNearbyObjects(pos, gx + r, gy + i) then break end
						end
						if #Creator.ObjectPool.Filter >= maxFilter then break end
						for i = r, -r + 1, -1 do
							if Creator.Function.Pool.GetNearbyObjects(pos, gx + i, gy - r) then break end
						end
						if #Creator.ObjectPool.Filter >= maxFilter then break end
						for i = -r, r - 1 do
							if Creator.Function.Pool.GetNearbyObjects(pos, gx - r, gy + i) then break end
						end
						if #Creator.ObjectPool.Filter >= maxFilter then break end
					end
				end
				if #Creator.ObjectPool.Filter >= 2 then
					table.sort(Creator.ObjectPool.Filter, function(a, b) return a.distance < b.distance end)
				end
				for i = 1, maxObjects do
					local data = Creator.ObjectPool.Filter[i] or {}
					local object = data.object or {}
					local uniqueId = object.uniqueId
					if uniqueId and Creator.ObjectPool.All[uniqueId] then
						Creator.ObjectPool.FilterKeep[uniqueId] = true
						Creator.ObjectPool.ActiveObjects[uniqueId] = object
						if Creator.ObjectPool.Effects[uniqueId] then
							Creator.ObjectPool.EffectsFilter[#Creator.ObjectPool.EffectsFilter + 1] = Creator.ObjectPool.Effects[uniqueId]
						end
					end
				end
				for i = 1, maxEffects do
					local effectData = Creator.ObjectPool.EffectsFilter[i] or {}
					local object = effectData.object or {}
					local uniqueId = object.uniqueId
					if uniqueId and Creator.ObjectPool.Effects[uniqueId] then
						Creator.ObjectPool.EffectsFilterKeep[uniqueId] = true
						Creator.ObjectPool.ActiveEffects[uniqueId] = effectData
					end
				end
				local effectsCount = Client.Function.Math.TableCount(Creator.ObjectPool.ActiveEffects)
				if effectsCount > maxEffects then
					for uniqueId, effectData in pairs(Creator.ObjectPool.ActiveEffects) do
						if not Creator.ObjectPool.EffectsFilterKeep[uniqueId] then
							if effectData.ptfxHandle then
								StopParticleFxLooped(effectData.ptfxHandle, true)
								effectData.ptfxHandle = nil
							end
							Creator.ObjectPool.ActiveEffects[uniqueId] = nil
							effectsCount = effectsCount - 1
							if effectsCount <= maxEffects then break end
						end
					end
				end
				local objectsCount = Client.Function.Math.TableCount(Creator.ObjectPool.ActiveObjects)
				if objectsCount > maxObjects then
					for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
						if not Creator.ObjectPool.FilterKeep[uniqueId] then
							if object.handle then
								DeleteObject(object.handle)
								object.handle = nil
							end
							Creator.ObjectPool.ActiveObjects[uniqueId] = nil
							objectsCount = objectsCount - 1
							if objectsCount <= maxObjects then break end
						end
					end
				end
				local inTestMode = Creator.GlobalVar.EnableTest
				local requestsThisFrame = {}
				for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
					local hash, x, y, z, rotX, rotY, rotZ, color, prpsba, visible, collision, dynamic = object.hash, object.x, object.y, object.z, object.rotX, object.rotY, object.rotZ, object.color, object.prpsba, object.visible, object.collision, object.dynamic
					if not object.handle or Creator.ObjectPool.ChangedObjects[uniqueId] then
						if object.handle then
							local effectData = Creator.ObjectPool.ActiveEffects[uniqueId]
							if effectData and effectData.ptfxHandle then
								StopParticleFxLooped(effectData.ptfxHandle, true)
								effectData.ptfxHandle = nil
							end
							DeleteObject(object.handle)
							object.handle = nil
							Creator.ObjectPool.ChangedObjects[uniqueId] = nil
						end
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
									if inTestMode then
										SetEntityVisible(obj, false)
									else
										SetEntityAlpha(obj, 150)
										SetEntityLodDist(obj, 16960)
									end
								else
									SetEntityLodDist(obj, 16960)
								end
								SetEntityCollision(obj, collision and true or false, collision and true or false)
								FreezeEntityPosition(obj, (not inTestMode or not dynamic) and true or false)
								object.handle = obj
							end
						else
							if not requestsThisFrame[hash] then
								requestsThisFrame[hash] = true
								RequestModel(hash)
							end
						end
					end
					Creator.ObjectPool.Requests[hash] = true
					Creator.ObjectPool.ActiveGrids[Creator.ObjectPool.All[uniqueId] or "error"] = true
				end
				for uniqueId, effectData in pairs(Creator.ObjectPool.ActiveEffects) do
					if not effectData.ptfxHandle then
						Creator.Function.Pool.StartEffectForObject(uniqueId, effectData.object, effectData.style)
					end
				end
				Creator.Function.UpdateBlip("object", not inTestMode and Creator.ObjectPool.ActiveObjects or nil)
			end
			Wait(sleep)
		end
		for uniqueId, effectData in pairs(Creator.ObjectPool.ActiveEffects) do
			if effectData.ptfxHandle then
				StopParticleFxLooped(effectData.ptfxHandle, true)
				effectData.ptfxHandle = nil
			end
		end
		for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
			if object.handle then
				DeleteObject(object.handle)
				object.handle = nil
			end
		end
		for hash, _ in pairs(Creator.ObjectPool.Requests) do
			SetModelAsNoLongerNeeded(hash)
		end
		Creator.Function.UpdateBlip("object", nil)
		Creator.ObjectPool.ForceLoad.x = nil
		Creator.ObjectPool.ForceLoad.y = nil
		Creator.ObjectPool.ForceLoad.z = nil
		Creator.ObjectPool.All = {}
		Creator.ObjectPool.Grids = {}
		Creator.ObjectPool.Effects = {}
		Creator.ObjectPool.Requests = {}
		Creator.ObjectPool.Filter = {}
		Creator.ObjectPool.FilterAdded = {}
		Creator.ObjectPool.FilterKeep = {}
		Creator.ObjectPool.EffectsFilter = {}
		Creator.ObjectPool.EffectsFilterKeep = {}
		Creator.ObjectPool.ActiveGrids = {}
		Creator.ObjectPool.ActiveObjects = {}
		Creator.ObjectPool.ActiveEffects = {}
		Creator.ObjectPool.ChangedObjects = {}
	end)
end

function Creator.Function.Pool.StartEffectForObject(uniqueId, object, style)
	CreateThread(function()
		local ptfxHandle = nil
		local fxName = (style == 1) and "core" or "scr_stunts"
		RequestNamedPtfxAsset(fxName)
		while not HasNamedPtfxAssetLoaded(fxName) do Wait(0) end
		local handle = object and object.handle
		if handle and DoesEntityExist(handle) and Creator.ObjectPool.Effects[uniqueId] then
			local effectData = Creator.ObjectPool.ActiveEffects[uniqueId]
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