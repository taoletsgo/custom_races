RegisterNetEvent("client:race:loadTrack", function(roomData, data, roomId, gridPositionIndex, vehicle, joinMidway, gameTimer)
	if Client.Time.ServerSide.ScriptStartTime ~= gameTimer then return end
	TriggerServerEvent("server:core:inRace", true)
	Race.Status = "parse"
	Client.Function.Busyspinner.Display("parse", 10000, data.mission.prop.no + data.mission.dprop.no + 10000)
	Client.IsInRace = true
	Client.Hud.ResetNextFrame = true
	Client.Ped.Status.WasDoingBeastJump = false
	SetLocalPlayerAsGhost(true)
	SetEntityVisible(PlayerPedId(), true)
	FreezeEntityPosition(PlayerPedId(), false)
	SetSwimMultiplierForPlayer(PlayerId(), 1.0)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	Client.Function.Environment.SetWeather(roomData.weather)
	Client.Function.Environment.SetTime(tonumber(roomData.time), 0, 0)
	Client.Function.Environment.SetTraffic(roomData.traffic ~= "off" and true or false)
	Race.Track.Current.RoomId = roomId
	Race.Track.Current.OwnerName = data.mission.gen.ownerid
	Race.Track.Current.Title = data.mission.gen.nm
	Race.Track.Current.BlimpText = data.mission.gen.blmpmsg
	Race.Track.Current.Laps = tonumber(roomData.laps)
	Race.Track.Current.Mode = roomData.mode
	Race.Track.Current.RoomData = roomData
	Race.Track.Current.PlayerCount = 1
	Race.Track.Current.Drivers = {}
	Race.Track.Current.LastVehicle = nil
	Race.Track.Current.DefaultVehicle = nil
	Race.Track.Current.RandomVehicles = {}
	Race.Function.UpdatePauseMenuInfo()
	local adlcs = {data.mission.race.adlc, data.mission.race.adlc2, data.mission.race.adlc3}
	local aveh = data.mission.race.aveh
	local clbs = data.mission.race.clbs
	local icv = data.mission.race.icv
	local ivm = data.mission.gen.ivm
	for classid = 0, 27 do
		if Client.Function.Math.IsBitSetValue(clbs, classid) then
			if Client.Shared.Vanilla[classid].aveh then
				if aveh[classid + 1] then
					for i = 0, #Client.Shared.Vanilla[classid].aveh - 1 do
						if not Client.Function.Math.IsBitSetValue(aveh[classid + 1], i) then
							local model = Client.Shared.Vanilla[classid].aveh[i + 1]
							local hash = GetHashKey(model)
							if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
								Race.Track.Current.RandomVehicles[hash] = true
							end
						end
					end
				end
			end
			if Client.Shared.Vanilla[classid].adlc then
				for offset, adlc in ipairs(adlcs) do
					if adlc[classid + 1] then
						for i = 0, 30 do
							if Client.Function.Math.IsBitSetValue(adlc[classid + 1], i) then
								local model = Client.Shared.Vanilla[classid].adlc[(offset - 1) * 31 + i + 1]
								local hash = model and GetHashKey(model)
								if hash and IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
									Race.Track.Current.RandomVehicles[hash] = true
								end
							end
						end
					end
				end
			end
		end
	end
	if IsModelInCdimage(ivm) and IsModelValid(ivm) and IsModelAVehicle(ivm) then
		Race.Track.Current.DefaultVehicle = ivm
	else
		local defaultVehicle = Client.Shared.Vanilla[icv] and Client.Shared.Vanilla[icv].aveh and Client.Shared.Vanilla[icv].aveh[ivm + 1]
		if defaultVehicle then
			Race.Track.Current.DefaultVehicle = defaultVehicle
		else
			if data.testVehicle then
				Race.Track.Current.DefaultVehicle = data.testVehicle
			else
				local randomVehicles = {}
				for k, v in pairs(Race.Track.Current.RandomVehicles) do
					table.insert(randomVehicles, k)
				end
				if #randomVehicles > 0 then
					Race.Track.Current.DefaultVehicle = randomVehicles[math.random(#randomVehicles)]
				end
			end
		end
	end
	if roomData.vehicle ~= "default" then
		Race.Cache.VehicleProps = vehicle or "bmx"
	else
		if Race.Cache.JoinVehicleNetId and NetworkDoesNetworkIdExist(Race.Cache.JoinVehicleNetId) and NetworkDoesEntityExistWithNetworkId(Race.Cache.JoinVehicleNetId) then
			Race.Cache.VehicleProps = Client.Function.Tuning.GetProperties(NetworkGetEntityFromNetworkId(Race.Cache.JoinVehicleNetId), true)
		end
		if type(Race.Cache.VehicleProps) == "table" and not Race.Cache.VehicleProps.model then
			Race.Cache.VehicleProps = Race.Track.Current.DefaultVehicle or "bmx"
		end
	end
	if type(Race.Cache.VehicleProps) == "table" then
		Race.SyncData.Vehicle = Race.Cache.VehicleProps.model and GetDisplayNameFromVehicleModel(Race.Cache.VehicleProps.model) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(Race.Cache.VehicleProps.model) or "Unknown"
	elseif type(Race.Cache.VehicleProps) == "number" then
		Race.SyncData.Vehicle = GetDisplayNameFromVehicleModel(Race.Cache.VehicleProps) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(Race.Cache.VehicleProps) or "Unknown"
	elseif type(Race.Cache.VehicleProps) == "string" then
		Race.SyncData.Vehicle = GetDisplayNameFromVehicleModel(GetHashKey(Race.Cache.VehicleProps)) ~= "CARNOTFOUND" and GetDisplayNameFromVehicleModel(GetHashKey(Race.Cache.VehicleProps)) or "Unknown"
	end
	Race.Track.Current.TransformVehicles = data.mission.race.trfmvm
	Race.Track.Current.Firework.Name = data.firework.name
	Race.Track.Current.Firework.R = data.firework.r
	Race.Track.Current.Firework.G = data.firework.g
	Race.Track.Current.Firework.B = data.firework.b
	Race.Track.Current.GridPositionIndex = gridPositionIndex <= data.mission.veh.no and gridPositionIndex or math.random(data.mission.veh.no)
	Race.Track.Current.StartingGrid = {}
	for i = 1, data.mission.veh.no do
		local loc = data.mission.veh.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local head = data.mission.veh.head[i] or 0.0
		local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(Client.Function.Math.RoundedValue(loc.x, 3), Client.Function.Math.RoundedValue(loc.y, 3), Client.Function.Math.RoundedValue(loc.z, 3), false, false)
		Race.Track.Current.StartingGrid[i] = {
			x = x,
			y = y,
			z = z,
			heading = Client.Function.Math.RoundedValue(head, 3)
		}
	end
	Race.Track.Current.Checkpoints = {}
	Race.Track.Current.Checkpoints_2 = {}
	for i = 1, data.mission.race.chp, 1 do
		local chl = data.mission.race.chl[i] or {}
		chl.x = chl.x or 0.0
		chl.y = chl.y or 0.0
		chl.z = chl.z or 0.0
		local chh = data.mission.race.chh[i] or 0.0
		local chs = data.mission.race.chs[i] or 1.0
		local chvs = data.mission.race.chvs[i] or chs
		local chpp = data.mission.race.chpp[i] or 0.0
		local cpado = data.mission.race.cpado[i] or {}
		cpado.x = cpado.x or 0.0
		cpado.y = cpado.y or 0.0
		cpado.z = cpado.z or 0.0
		local chstR = data.mission.race.chstR[i] or 500.0
		local cptfrm = data.mission.race.cptfrm[i] or -1
		local cptrtt = data.mission.race.cptrtt[i] or -2
		local cptrst = data.mission.race.cptrst[i] or 0
		local cpbs1 = data.mission.race.cpbs1[i] or nil
		local cpbs2 = data.mission.race.cpbs2[i] or nil
		local cpbs3 = data.mission.race.cpbs3[i] or nil
		local cppsst = data.mission.race.cppsst[i] or nil
		Race.Track.Current.Checkpoints[i] = {
			x = Client.Function.Math.RoundedValue(chl.x, 3),
			y = Client.Function.Math.RoundedValue(chl.y, 3),
			z = Client.Function.Math.RoundedValue(chl.z, 3),
			heading = Client.Function.Math.RoundedValue(chh, 3),
			diameterCollect = Client.Function.Math.RoundedValue(chs >= 0.5 and chs or 1.0, 3),
			diameterDraw = Client.Function.Math.RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
			pitch = chpp,
			offset = cpado,
			lockDirection = cpbs1 and ((Client.Function.Math.IsBitSetValue(cpbs1, 16) and not (cpado.x == 0.0 and cpado.y == 0.0 and cpado.z == 0.0)) or Client.Function.Math.IsBitSetValue(cpbs1, 18)),
			isPit = cpbs2 and Client.Function.Math.IsBitSetValue(cpbs2, 16),
			isTall = cpbs2 and Client.Function.Math.IsBitSetValue(cpbs2, 20),
			tallRadius = chstR,
			lowerAlpha = cpbs2 and Client.Function.Math.IsBitSetValue(cpbs2, 24),
			isRound = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 1),
			isAir = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 9),
			isFake = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 10),
			isRandom = cptfrm == -2,
			randomClass = cptfrm == -2 and cptrtt,
			randomCustom = cptfrm == -2 and cptrtt == -1 and ((type(cptrst) == "string" and 1) or (type(cptrst) == "number" and 2) or (type(cptrst) == "table" and 3) or (type(cptrst) == "boolean" and 4)),
			randomSetting = cptfrm == -2 and cptrtt == -1 and cptrst,
			isTransform = cptfrm >= 0,
			transformIndex = cptfrm >= 0 and cptfrm,
			isPlaneRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 0)) or (Client.Function.Math.IsBitSetValue(cppsst, 1)) or (Client.Function.Math.IsBitSetValue(cppsst, 2)) or (Client.Function.Math.IsBitSetValue(cppsst, 3))),
			planeRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 0) and 0) or (Client.Function.Math.IsBitSetValue(cppsst, 1) and 1) or (Client.Function.Math.IsBitSetValue(cppsst, 2) and 2) or (Client.Function.Math.IsBitSetValue(cppsst, 3) and 3)),
			isWarp = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 27)
		}
		if Race.Track.Current.Checkpoints[i].isRandom or Race.Track.Current.Checkpoints[i].isTransform or Race.Track.Current.Checkpoints[i].isPlaneRot or Race.Track.Current.Checkpoints[i].isWarp then
			Race.Track.Current.Checkpoints[i].isRound = true
		end
		if Race.Track.Current.Checkpoints[i].lockDirection then
			Race.Track.Current.Checkpoints[i].isRound = true
		end
		local sndchk = data.mission.race.sndchk[i] or {}
		sndchk.x = sndchk.x or 0.0
		sndchk.y = sndchk.y or 0.0
		sndchk.z = sndchk.z or 0.0
		if not (sndchk.x == 0.0 and sndchk.y == 0.0 and sndchk.z == 0.0) then
			local sndrsp = data.mission.race.sndrsp[i] or 0.0
			local chs2 = data.mission.race.chs2[i] or chs
			local chpps = data.mission.race.chpps[i] or 0.0
			local cpados = data.mission.race.cpados[i] or {}
			cpados.x = cpados.x or 0.0
			cpados.y = cpados.y or 0.0
			cpados.z = cpados.z or 0.0
			local chstRs = data.mission.race.chstRs[i] or 500.0
			local cptfrms = data.mission.race.cptfrms[i] or -1
			local cptrtts = data.mission.race.cptrtts[i] or -2
			local cptrsts = data.mission.race.cptrsts[i] or 0
			Race.Track.Current.Checkpoints_2[i] = {
				x = Client.Function.Math.RoundedValue(sndchk.x, 3),
				y = Client.Function.Math.RoundedValue(sndchk.y, 3),
				z = Client.Function.Math.RoundedValue(sndchk.z, 3),
				heading = Client.Function.Math.RoundedValue(sndrsp, 3),
				diameterCollect = Client.Function.Math.RoundedValue(chs2 >= 0.5 and chs2 or 1.0, 3),
				diameterDraw = Client.Function.Math.RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
				pitch = chpps,
				offset = cpados,
				lockDirection = cpbs1 and ((Client.Function.Math.IsBitSetValue(cpbs1, 17) and not (cpados.x == 0.0 and cpados.y == 0.0 and cpados.z == 0.0)) or Client.Function.Math.IsBitSetValue(cpbs1, 19)),
				isPit = cpbs2 and Client.Function.Math.IsBitSetValue(cpbs2, 17),
				isTall = cpbs2 and Client.Function.Math.IsBitSetValue(cpbs2, 21),
				tallRadius = chstRs,
				lowerAlpha = cpbs2 and Client.Function.Math.IsBitSetValue(cpbs2, 25),
				isRound = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 2),
				isAir = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 13),
				isFake = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 11),
				isRandom = cptfrms == -2,
				randomClass = cptfrms == -2 and cptrtts,
				randomCustom = cptfrms == -2 and cptrtts == -1 and ((type(cptrsts) == "string" and 1) or (type(cptrsts) == "number" and 2) or (type(cptrsts) == "table" and 3) or (type(cptrsts) == "boolean" and 4)),
				randomSetting = cptfrms == -2 and cptrtts == -1 and cptrsts,
				isTransform = cptfrms >= 0,
				transformIndex = cptfrms >= 0 and cptfrms,
				isPlaneRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 4)) or (Client.Function.Math.IsBitSetValue(cppsst, 5)) or (Client.Function.Math.IsBitSetValue(cppsst, 6)) or (Client.Function.Math.IsBitSetValue(cppsst, 7))),
				planeRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 4) and 0) or (Client.Function.Math.IsBitSetValue(cppsst, 5) and 1) or (Client.Function.Math.IsBitSetValue(cppsst, 6) and 2) or (Client.Function.Math.IsBitSetValue(cppsst, 7) and 3)),
				isWarp = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 28)
			}
			if Race.Track.Current.Checkpoints_2[i].isRandom or Race.Track.Current.Checkpoints_2[i].isTransform or Race.Track.Current.Checkpoints_2[i].isPlaneRot or Race.Track.Current.Checkpoints_2[i].isWarp then
				Race.Track.Current.Checkpoints_2[i].isRound = true
			end
			if Race.Track.Current.Checkpoints_2[i].lockDirection then
				Race.Track.Current.Checkpoints_2[i].isRound = true
			end
		end
	end
	Race.Track.Current.Fixtures = {}
	local seen = {}
	for i = 1, data.mission.dhprop.no do
		local mn = data.mission.dhprop.mn[i]
		if mn and not seen[mn] and IsModelInCdimage(mn) and IsModelValid(mn) then
			seen[mn] = true
			Race.Track.Current.Fixtures[#Race.Track.Current.Fixtures + 1] = {
				hash = mn
			}
		end
	end
	Wait(1000)
	local count = 0
	local validModels = {}
	local invalidObjects = {}
	local globalUniqueId = 0
	for i = 1, data.mission.prop.no do
		local model = data.mission.prop.model[i] or 779917859
		if validModels[model] or (IsModelInCdimage(model) and IsModelValid(model)) then
			validModels[model] = true
			local loc = data.mission.prop.loc[i] or {}
			loc.x = loc.x or 0.0
			loc.y = loc.y or 0.0
			loc.z = loc.z or 0.0
			if loc.x <= -16000.0 or loc.x >= 16000.0 then
				loc.x = 0.0
			end
			if loc.y <= -16000.0 or loc.y >= 16000.0 then
				loc.y = 0.0
			end
			if loc.z <= -200.0 or loc.z >= 2700.0 then
				loc.z = 0.0
			end
			local vRot = data.mission.prop.vRot[i] or {}
			vRot.x = vRot.x or 0.0
			vRot.y = vRot.y or 0.0
			vRot.z = vRot.z or 0.0
			local prpclr = data.mission.prop.prpclr[i] or 0
			local pLODDist = data.mission.prop.pLODDist[i] or 16960
			local collision = data.mission.prop.collision[i] or (not Client.Shared.Object.NoCollision[model] and 1 or 0)
			local prpbs = data.mission.prop.prpbs[i] or 0
			local prpsba = data.mission.prop.prpsba[i] or 2
			globalUniqueId = globalUniqueId + 1
			local object = {
				uniqueId = Race.Track.Current.RoomId .. "-" .. globalUniqueId,
				hash = model,
				handle = nil,
				x = Client.Function.Math.RoundedValue(loc.x, 3),
				y = Client.Function.Math.RoundedValue(loc.y, 3),
				z = Client.Function.Math.RoundedValue(loc.z, 3),
				rotX = Client.Function.Math.RoundedValue(vRot.x, 3),
				rotY = Client.Function.Math.RoundedValue(vRot.y, 3),
				rotZ = Client.Function.Math.RoundedValue(vRot.z, 3),
				color = prpclr,
				prpsba = prpsba,
				lod = pLODDist > 1 and pLODDist or 16960,
				visible = not Client.Function.Math.IsBitSetValue(prpbs, 9) and (pLODDist ~= 1),
				collision = collision == 1,
				dynamic = false
			}
			if object.hash == 73742208 or object.hash == -977919647 or object.hash == -1081534242 or object.hash == 1243328051 then
				object.visible = true
				object.dynamic = true
			end
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Race.ObjectPool.Grids[gx] = Race.ObjectPool.Grids[gx] or {}
			Race.ObjectPool.Grids[gx][gy] = Race.ObjectPool.Grids[gx][gy] or {}
			Race.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Race.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			if Client.Shared.Object.Effect[object.hash] then
				Race.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
			end
			if Client.Shared.Object.Firework[object.hash] then
				Race.FireworkProps[#Race.FireworkProps + 1] = object
			end
			count = count + 1
			if count >= 10000 then
				count = 0
				Wait(1000)
			end
		else
			invalidObjects[model] = true
		end
	end
	for i = 1, data.mission.dprop.no do
		local model = data.mission.dprop.model[i] or 779917859
		if validModels[model] or (IsModelInCdimage(model) and IsModelValid(model)) then
			validModels[model] = true
			local loc = data.mission.dprop.loc[i] or {}
			loc.x = loc.x or 0.0
			loc.y = loc.y or 0.0
			loc.z = loc.z or 0.0
			if loc.x <= -16000.0 or loc.x >= 16000.0 then
				loc.x = 0.0
			end
			if loc.y <= -16000.0 or loc.y >= 16000.0 then
				loc.y = 0.0
			end
			if loc.z <= -200.0 or loc.z >= 2700.0 then
				loc.z = 0.0
			end
			local vRot = data.mission.dprop.vRot[i] or {}
			vRot.x = vRot.x or 0.0
			vRot.y = vRot.y or 0.0
			vRot.z = vRot.z or 0.0
			local prpdclr = data.mission.dprop.prpdclr[i] or 0
			local collision = data.mission.dprop.collision[i] or (not Client.Shared.Object.NoCollision[model] and 1 or 0)
			globalUniqueId = globalUniqueId + 1
			local object = {
				uniqueId = Race.Track.Current.RoomId .. "-" .. globalUniqueId,
				hash = model,
				handle = nil,
				x = Client.Function.Math.RoundedValue(loc.x, 3),
				y = Client.Function.Math.RoundedValue(loc.y, 3),
				z = Client.Function.Math.RoundedValue(loc.z, 3),
				rotX = Client.Function.Math.RoundedValue(vRot.x, 3),
				rotY = Client.Function.Math.RoundedValue(vRot.y, 3),
				rotZ = Client.Function.Math.RoundedValue(vRot.z, 3),
				color = prpdclr,
				prpsba = 2,
				lod = 16960,
				visible = true,
				collision = collision == 1,
				dynamic = true
			}
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Race.ObjectPool.Grids[gx] = Race.ObjectPool.Grids[gx] or {}
			Race.ObjectPool.Grids[gx][gy] = Race.ObjectPool.Grids[gx][gy] or {}
			Race.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Race.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			if Client.Shared.Object.Effect[object.hash] then
				Race.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
			end
			if Client.Shared.Object.Arena[object.hash] then
				Race.ArenaProps[#Race.ArenaProps + 1] = object
			end
			if Client.Shared.Object.Explode[object.hash] then
				Race.ExplodeProps[#Race.ExplodeProps + 1] = object
			end
			if Client.Shared.Object.Firework[object.hash] then
				Race.FireworkProps[#Race.FireworkProps + 1] = object
			end
			count = count + 1
			if count >= 10000 then
				count = 0
				Wait(1000)
			end
		else
			invalidObjects[model] = true
		end
	end
	for k, v in pairs(invalidObjects) do
		print("model (" .. k .. ") does not exist or is invalid!")
	end
	if Client.Function.Math.TableCount(invalidObjects) > 0 then
		print("Ask the server owner to stream invalid models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end
	Race.Function.Player.DisplayFinishedMessage()
	Race.Function.Pool.SpawnNearbyObjects()
	Client.Function.Blimp.Init(function()
		CreateThread(function()
			Client.Function.Blimp.SetText(Client.Blimp.Scaleform, Race.Track.Current.BlimpText)
			Client.Function.Blimp.SetColor(Client.Blimp.Scaleform, 1)
			Client.Function.Blimp.SetSpeed(Client.Blimp.Scaleform, 100.0)
			while Client.IsInRace do
				Client.Function.Blimp.Render(Client.Blimp.Scaleform, Client.Blimp.Rendertarget)
				Wait(0)
			end
			Client.Function.Blimp.Release()
			Client.Blimp.Scaleform = nil
			Client.Blimp.Rendertarget = nil
		end)
	end)
	Race.Function.SetFireworks()
	Race.Function.RemoveFixtures()
	RemoveLoadingPrompt()
	Client.Busyspinner.Status = nil
	Race.Function.Join()
	Race.Function.SyncData()
	Wait(1000)
	SwitchInPlayer(PlayerPedId())
	while IsPlayerSwitchInProgress() do Wait(0) end
	Race.EnableXboxController = false
	for k, v in pairs(invalidObjects) do
		Client.Function.Message.Display_2(string.format(Client.Function.Translate.Get("object-hash-null"), k), false, nil)
	end
	if joinMidway then
		if Race.Status == "ready" then
			Race.Function.Start()
		end
	else
		TriggerServerEvent("server:race:raceLoaded")
		Client.Busyspinner.Status = "wait"
		Wait(5000)
		if Client.Busyspinner.Status == "wait" then
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName(Client.Function.Translate.Get("wait-players"))
			EndTextCommandBusyString(4)
		end
	end
end)

RegisterNUICallback("getBestTimes", function(data, cb)
	TriggerServerCallback("server:race:getBestTimes", function(bestTimes)
		for k, v in pairs(bestTimes) do
			v.time = GetTimeAsString(v.time)
			v.vehicle = (v.vehicle == "parachute" and Client.Function.Translate.Get("Transform-Parachute")) or (v.vehicle == "beast" and Client.Function.Translate.Get("Transform-Beast")) or (GetLabelText(v.vehicle) ~= "NULL" and GetLabelText(v.vehicle):gsub("µ", " ")) or Client.Function.Translate.Get("unknown-vehicle")
		end
		cb(bestTimes)
	end, data.raceId)
end)

RegisterNUICallback("updateBookmarked", function(data, cb)
	Race.Track.Bookmarked[data.raceId] = data.bookmarked and true or nil
	local found = false
	for k, v in pairs(Race.Track.Data) do
		for i = 1, #v do
			if v[i].raceId == data.raceId then
				v[i].bookmarked = data.bookmarked and true or nil
				found = true
				break
			end
		end
		if found then break end
	end
	TriggerServerEvent("server:race:saveData", {bookmarked = data.bookmarked and 1 or 0, raceId = data.raceId})
	cb(Race.Track.Data)
end)

RegisterNUICallback("getBookmarkedRace", function(data, cb)
	local races = {}
	for k, v in pairs(Race.Track.Data) do
		for i = 1, #v do
			if v[i].bookmarked then
				table.insert(races, {raceId = v[i].raceId, name = v[i].name .. " (" .. k .. ")", img = v[i].img, maxPlayers = v[i].maxPlayers, bookmarked = v[i].bookmarked, played = v[i].played, finished = v[i].finished})
				if #races >= 200 then
					break
				end
			end
		end
		if #races >= 200 then
			break
		end
	end
	if #races >= 200 then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-result-limit")
		})
	end
	cb(races)
end)

RegisterNUICallback("getRandomRace", function(data, cb)
	local races = {}
	local raceIds = {}
	for k, v in pairs(Race.Track.Data) do
		for i = 1, #v do
			races[v[i].raceId] = {tag = k, data = v[i]}
			table.insert(raceIds, v[i].raceId)
		end
	end
	if #raceIds > 0 then
		local randomIndex = math.random(#raceIds)
		local randomRaceId = raceIds[randomIndex]
		local randomRace = races[randomRaceId]
		local randomRaceTag = randomRace.tag
		local randomRaceData = randomRace.data
		cb({{raceId = randomRaceData.raceId, name = randomRaceData.name .. " (" .. randomRaceTag .. ")", img = randomRaceData.img, maxPlayers = randomRaceData.maxPlayers, bookmarked = randomRaceData.bookmarked, played = randomRaceData.played, finished = randomRaceData.finished}})
	else
		cb({})
	end
end)

RegisterNUICallback("searchRace", function(data, cb)
	if Race.Track.IsQueryingData then
		cb(nil)
		return
	end
	Race.Track.IsQueryingData = true
	local text = data and data.text or ""
	if #text > 0 then
		if string.find(text, "^https://prod%.cloud%.rockstargames%.com/ugc/gta5mission/") and (string.find(text, "jpg$") or string.find(text, "json$")) then
			local ugcImg = string.find(text, "jpg$")
			local ugcJson = string.find(text, "json$")
			TriggerServerCallback("server:race:searchUGC", function(name, maxPlayers, reason)
				if name and maxPlayers then
					cb({
						createRoom = true,
						img = ugcImg and text or (ugcJson and ((text:match("(.-)/[^/]+$")) .. "/2_0.jpg")) or "",
						name = name,
						maxPlayers = maxPlayers
					})
					Wait(3000)
					Race.Track.IsQueryingData = false
				else
					if reason == "cancel" then
						SendNUIMessage({
							action = "show notification",
							message = Client.Function.Translate.Get("msg-search-cancel")
						})
					elseif reason == "failed" then
						SendNUIMessage({
							action = "show notification",
							message = Client.Function.Translate.Get("msg-search-failed")
						})
					elseif reason == "timed-out" then
						SendNUIMessage({
							action = "show notification",
							message = Client.Function.Translate.Get("msg-search-timed-out")
						})
					end
					cb(nil)
					Race.Track.IsQueryingData = false
				end
			end, text, ugcImg, ugcJson)
		else
			local str = string.lower(text)
			local races = {}
			for k, v in pairs(Race.Track.Data) do
				for i = 1, #v do
					if string.find(string.lower(v[i].name), str) then
						table.insert(races, {raceId = v[i].raceId, name = v[i].name .. " (" .. k .. ")", img = v[i].img, maxPlayers = v[i].maxPlayers, bookmarked = v[i].bookmarked, played = v[i].played, finished = v[i].finished})
						if #races >= 200 then
							break
						end
					end
				end
				if #races >= 200 then
					break
				end
			end
			if #races >= 200 then
				SendNUIMessage({
					action = "show notification",
					message = Client.Function.Translate.Get("msg-result-limit")
				})
			end
			cb(races)
			Race.Track.IsQueryingData = false
		end
	else
		cb(nil)
		Race.Track.IsQueryingData = false
	end
end)

RegisterNUICallback("cancelSearch", function(data, cb)
	TriggerServerEvent("server:race:cancelSearch")
end)