function Creator.Function.Track.ConvertFromData(data)
	if not data then return end
	-- Info
	data.meta = data.meta or {}
	data.meta.vehcl = data.meta.vehcl or {}
	data.mission = data.mission or {}
	data.mission.gen = data.mission.gen or {}
	data.mission.gen.ownerid = data.mission.gen.ownerid or ""
	data.mission.gen.nm = data.mission.gen.nm or ""
	data.mission.gen.dec = data.mission.gen.dec or {""}
	data.mission.gen.type = data.mission.gen.type or 2
	data.mission.gen.subtype = data.mission.gen.type or 6
	data.mission.gen.start = data.mission.gen.start or {}
	data.mission.gen.start.x = data.mission.gen.start.x or 0.0
	data.mission.gen.start.y = data.mission.gen.start.y or 0.0
	data.mission.gen.start.z = data.mission.gen.start.z or 0.0
	data.mission.gen.blmpmsg = data.mission.gen.blmpmsg or ""
	data.mission.gen.ivm = data.mission.gen.ivm or -1
	-- Fixtures
	data.mission.dhprop = data.mission.dhprop or {}
	data.mission.dhprop.mn = data.mission.dhprop.mn or {}
	data.mission.dhprop.pos = data.mission.dhprop.pos or {}
	data.mission.dhprop.no = data.mission.dhprop.no or 0
	-- Dynamic props
	data.mission.dprop = data.mission.dprop or {}
	data.mission.dprop.model = data.mission.dprop.model or {}
	data.mission.dprop.loc = data.mission.dprop.loc or {}
	data.mission.dprop.vRot = data.mission.dprop.vRot or {}
	data.mission.dprop.prpdclr = data.mission.dprop.prpdclr or {}
	data.mission.dprop.collision = data.mission.dprop.collision or {}
	data.mission.dprop.no = data.mission.dprop.no or 0
	-- Static props
	data.mission.prop = data.mission.prop or {}
	data.mission.prop.model = data.mission.prop.model or {}
	data.mission.prop.loc = data.mission.prop.loc or {}
	data.mission.prop.vRot = data.mission.prop.vRot or {}
	data.mission.prop.prpclr = data.mission.prop.prpclr or {}
	data.mission.prop.pLODDist = data.mission.prop.pLODDist or {}
	data.mission.prop.collision = data.mission.prop.collision or {}
	data.mission.prop.prpbs = data.mission.prop.prpbs or {}
	data.mission.prop.prpsba = data.mission.prop.prpsba or {}
	data.mission.prop.no = data.mission.prop.no or 0
	-- Checkpoints
	data.mission.race = data.mission.race or {}
	data.mission.race.adlc = data.mission.race.adlc or {}
	data.mission.race.adlc2 = data.mission.race.adlc2 or {}
	data.mission.race.adlc3 = data.mission.race.adlc3 or {}
	data.mission.race.aveh = data.mission.race.aveh or {}
	data.mission.race.clbs = data.mission.race.clbs or 0
	data.mission.race.icv = data.mission.race.icv or -1
	data.mission.race.chl = data.mission.race.chl or {}
	data.mission.race.chh = data.mission.race.chh or {}
	data.mission.race.chs = data.mission.race.chs or {}
	data.mission.race.chpp = data.mission.race.chpp or {}
	data.mission.race.cpado = data.mission.race.cpado or {}
	data.mission.race.chstR = data.mission.race.chstR or {}
	data.mission.race.cptfrm = data.mission.race.cptfrm or {}
	data.mission.race.cptrtt = data.mission.race.cptrtt or {}
	data.mission.race.cptrst = data.mission.race.cptrst or {}
	data.mission.race.sndchk = data.mission.race.sndchk or {}
	data.mission.race.sndrsp = data.mission.race.sndrsp or {}
	data.mission.race.chs2 = data.mission.race.chs2 or {}
	data.mission.race.chpps = data.mission.race.chpps or {}
	data.mission.race.cpados = data.mission.race.cpados or {}
	data.mission.race.chstRs = data.mission.race.chstRs or {}
	data.mission.race.cptfrms = data.mission.race.cptfrms or {}
	data.mission.race.cptrtts = data.mission.race.cptrtts or {}
	data.mission.race.cptrsts = data.mission.race.cptrsts or {}
	data.mission.race.chvs = data.mission.race.chvs or {}
	data.mission.race.cpbs1 = data.mission.race.cpbs1 or {}
	data.mission.race.cpbs2 = data.mission.race.cpbs2 or {}
	data.mission.race.cpbs3 = data.mission.race.cpbs3 or {}
	data.mission.race.trfmvm = data.mission.race.trfmvm or {}
	data.mission.race.cppsst = data.mission.race.cppsst or {}
	data.mission.race.chp = data.mission.race.chp or 0
	-- Vehicle grids
	data.mission.veh.loc = data.mission.veh.loc or {}
	data.mission.veh.head = data.mission.veh.head or {}
	data.mission.veh.no = data.mission.veh.no or #data.mission.veh.loc

	Creator.ObjectPool.IsRefreshing = true
	Client.Function.Busyspinner.Display("parse", 10000, data.mission.prop.no + data.mission.dprop.no + 10000)

	-- =================================
	-- Convert ugc data to current track
	-- =================================
	Creator.Track.Current.RaceId = data.raceId
	Creator.Track.Current.Thumbnail = data.thumbnail
	Creator.Track.Current.Published = data.published
	Creator.Track.Current.Category = data.category
	local adlcs = {data.mission.race.adlc, data.mission.race.adlc2, data.mission.race.adlc3}
	local aveh = data.mission.race.aveh
	local clbs = data.mission.race.clbs
	local icv = data.mission.race.icv
	local ivm = data.mission.gen.ivm
	Creator.Track.Current.DefaultClass = nil
	for classid = 0, 27 do
		Creator.Track.Current.AvailableVehicles[classid].index = nil
		for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
			Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = false
		end
	end
	for classid = 0, 27 do
		if Client.Function.Math.IsBitSetValue(clbs, classid) then
			if Client.Shared.Vanilla[classid].aveh then
				if aveh[classid + 1] then
					for i = 0, #Client.Shared.Vanilla[classid].aveh - 1 do
						if not Client.Function.Math.IsBitSetValue(aveh[classid + 1], i) then
							local model = Client.Shared.Vanilla[classid].aveh[i + 1]
							local hash = GetHashKey(model)
							if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
								Creator.Track.Current.AvailableVehicles[classid].vehicles[i + 1].enabled = true
								Creator.Track.Current.AvailableVehicles[classid].index = Creator.Track.Current.AvailableVehicles[classid].index or (i + 1)
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
									Creator.Track.Current.AvailableVehicles[classid].vehicles[(Client.Shared.Vanilla[classid].aveh and #Client.Shared.Vanilla[classid].aveh or 0) + (offset - 1) * 31 + i + 1].enabled = true
									Creator.Track.Current.AvailableVehicles[classid].index = Creator.Track.Current.AvailableVehicles[classid].index or ((Client.Shared.Vanilla[classid].aveh and #Client.Shared.Vanilla[classid].aveh or 0) + (offset - 1) * 31 + i + 1)
								end
							end
						end
					end
				end
			end
		end
	end
	local defaultVehicle = nil
	if IsModelInCdimage(ivm) and IsModelValid(ivm) and IsModelAVehicle(ivm) then
		local found = false
		for classid = 0, 27 do
			for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
				if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].hash == ivm then
					defaultVehicle = Creator.Track.Current.AvailableVehicles[classid].vehicles[i].model
					Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = true
					Creator.Track.Current.AvailableVehicles[classid].index = i
					Creator.Track.Current.DefaultClass = classid
					found = true
					break
				end
			end
			if found then break end
		end
		if not found then
			local defaultClass = nil
			local validClasses = {}
			for classid = 0, 27 do
				for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
					if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
						validClasses[classid] = true
						break
					end
				end
			end
			local found_2 = false
			if validClasses[icv] then
				defaultClass = icv
				found_2 = true
			else
				for i = 0, 27, 1 do
					if validClasses[i] then
						defaultClass = i
						found_2 = true
						break
					end
				end
			end
			if not found_2 then
				defaultClass = nil
			end
			if defaultClass and Creator.Track.Current.AvailableVehicles[defaultClass].index and Creator.Track.Current.AvailableVehicles[defaultClass].vehicles[Creator.Track.Current.AvailableVehicles[defaultClass].index] then
				defaultVehicle = Creator.Track.Current.AvailableVehicles[defaultClass].vehicles[Creator.Track.Current.AvailableVehicles[defaultClass].index].model
				Creator.Track.Current.DefaultClass = defaultClass
			else
				Creator.Track.Current.DefaultClass = nil
			end
		end
	else
		if Creator.Track.Current.AvailableVehicles[icv] and Creator.Track.Current.AvailableVehicles[icv].vehicles then
			if Creator.Track.Current.AvailableVehicles[icv].vehicles[ivm + 1] then
				if Creator.Track.Current.AvailableVehicles[icv].vehicles[ivm + 1].enabled then
					defaultVehicle = Creator.Track.Current.AvailableVehicles[icv].vehicles[ivm + 1].model
					Creator.Track.Current.AvailableVehicles[icv].index = ivm + 1
					Creator.Track.Current.DefaultClass = icv
				else
					Creator.Track.Current.DefaultClass = nil
				end
			end
		end
	end
	if defaultVehicle then
		Creator.Track.Current.TestVehicle = defaultVehicle
	else
		defaultVehicle = data.testVehicle or Creator.Track.Current.TestVehicle
		local hash = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
		if not IsModelInCdimage(hash) or not IsModelValid(hash) or not IsModelAVehicle(hash) then
			Creator.Track.Current.TestVehicle = "bmx"
			Creator.Track.Current.AvailableVehicles[13].vehicles[1].enabled = true
			Creator.Track.Current.AvailableVehicles[13].index = 1
			Creator.Track.Current.DefaultClass = 13
		else
			Creator.Track.Current.TestVehicle = defaultVehicle
			local found = false
			for classid = 0, 27 do
				for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
					if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].hash == hash then
						Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = true
						Creator.Track.Current.AvailableVehicles[classid].index = i
						Creator.Track.Current.DefaultClass = classid
						found = true
						break
					end
				end
				if found then break end
			end
			if not found then
				Creator.Track.Current.DefaultClass = nil
			end
		end
	end
	Creator.Track.Current.TransformVehicles = data.mission.race.trfmvm
	Creator.Track.Current.OwnerName = data.mission.gen.ownerid
	local title = data.mission.gen.nm:gsub("[\\/:\"*?<>|]", ""):gsub("%%s", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
	if Client.Function.Math.StringCount(title) > 0 and title ~= "unknown" then
		Creator.Track.Current.Title = title
	else
		Creator.Track.Current.Title = "unknown"
		Client.Function.Message.Display(Client.Function.Translate.Get("title-error"))
	end
	Creator.Track.Current.BlimpText = data.mission.gen.blmpmsg
	Client.Function.Blimp.SetText(Client.Blimp.Scaleform, Creator.Track.Current.BlimpText)
	Creator.Firework.ParticleIndex = 1
	if data.firework and data.firework.name then
		for i = 1, #Creator.Firework.Particles do
			if Creator.Firework.Particles[i] == data.firework.name then
				Creator.Firework.ParticleIndex = i
				break
			end
		end
	end
	Creator.Track.Current.Firework.Name = Creator.Firework.Particles[Creator.Firework.ParticleIndex]
	Creator.Track.Current.Firework.R = data.firework and data.firework.r or 255
	Creator.Track.Current.Firework.G = data.firework and data.firework.g or 255
	Creator.Track.Current.Firework.B = data.firework and data.firework.b or 255
	Creator.Track.Current.StartingGrid = {}
	for i = 1, data.mission.veh.no do
		local loc = data.mission.veh.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local head = data.mission.veh.head[i] or 0.0
		local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(Client.Function.Math.RoundedValue(loc.x, 3), Client.Function.Math.RoundedValue(loc.y, 3), Client.Function.Math.RoundedValue(loc.z, 3), false, false)
		Creator.Track.Current.StartingGrid[i] = {
			handle = nil,
			x = x,
			y = y,
			z = z,
			heading = Client.Function.Math.RoundedValue(head, 3)
		}
	end
	Creator.StartingGrid.Index = #Creator.Track.Current.StartingGrid
	Creator.Track.Current.Checkpoints = {}
	Creator.Track.Current.Checkpoints_2 = {}
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
		Creator.Track.Current.Checkpoints[i] = {
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
		if Creator.Track.Current.Checkpoints[i].isRandom or Creator.Track.Current.Checkpoints[i].isTransform or Creator.Track.Current.Checkpoints[i].isPlaneRot or Creator.Track.Current.Checkpoints[i].isWarp then
			Creator.Track.Current.Checkpoints[i].isRound = true
		end
		if Creator.Track.Current.Checkpoints[i].lockDirection then
			Creator.Track.Current.Checkpoints[i].isRound = true
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
			Creator.Track.Current.Checkpoints_2[i] = {
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
			if Creator.Track.Current.Checkpoints_2[i].isRandom or Creator.Track.Current.Checkpoints_2[i].isTransform or Creator.Track.Current.Checkpoints_2[i].isPlaneRot or Creator.Track.Current.Checkpoints_2[i].isWarp then
				Creator.Track.Current.Checkpoints_2[i].isRound = true
			end
			if Creator.Track.Current.Checkpoints_2[i].lockDirection then
				Creator.Track.Current.Checkpoints_2[i].isRound = true
			end
		end
	end
	Creator.Checkpoint.Index = #Creator.Track.Current.Checkpoints
	Creator.Blips.Checkpoints = {}
	Creator.Blips.Checkpoints_2 = {}
	for k, v in pairs(Creator.Track.Current.Checkpoints) do
		Creator.Blips.Checkpoints[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
	end
	for k, v in pairs(Creator.Track.Current.Checkpoints_2) do
		Creator.Blips.Checkpoints_2[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
	end
	Creator.Track.Current.Fixtures = {}
	local fakeHash = GetHashKey("stt_prop_stunt_bblock_sml1")
	local seen = {}
	for i = 1, data.mission.dhprop.no do
		local mn = data.mission.dhprop.mn[i]
		local pos = data.mission.dhprop.pos[i] or {}
		pos.x = pos.x or 0.0
		pos.y = pos.y or 0.0
		pos.z = pos.z or 0.0
		if mn and not seen[mn] and IsModelInCdimage(mn) and IsModelValid(mn) and (mn ~= fakeHash) then
			seen[mn] = true
			Creator.Track.Current.Fixtures[#Creator.Track.Current.Fixtures + 1] = {
				hash = mn,
				handle = nil,
				x = pos.x,
				y = pos.y,
				z = pos.z
			}
		end
	end
	Creator.Fixture.Index = #Creator.Track.Current.Fixtures
	Wait(1000)
	local count = 0
	local validModels = {}
	local invalidObjects = {}
	Creator.Track.Current.Objects = {}
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
			Creator.Multiplayer.GlobalUniqueId = Creator.Multiplayer.GlobalUniqueId + 1
			local object = {
				uniqueId = Client.ServerId .. "-" .. Creator.Multiplayer.GlobalUniqueId,
				modificationCount = 0,
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
				visible = not Client.Function.Math.IsBitSetValue(prpbs, 9) and (pLODDist ~= 1),
				collision = collision == 1,
				dynamic = false
			}
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
			Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
			Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			if Client.Shared.Object.Effect[object.hash] then
				Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
			end
			Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
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
			Creator.Multiplayer.GlobalUniqueId = Creator.Multiplayer.GlobalUniqueId + 1
			local object = {
				uniqueId = Client.ServerId .. "-" .. Creator.Multiplayer.GlobalUniqueId,
				modificationCount = 0,
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
				visible = true,
				collision = collision == 1,
				dynamic = true
			}
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
			Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
			Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			if Client.Shared.Object.Effect[object.hash] then
				Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
			end
			Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
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
		Client.Function.Message.Display(string.format(Client.Function.Translate.Get("object-hash-null"), k))
	end
	if Client.Function.Math.TableCount(invalidObjects) > 0 then
		print("Ask the server owner to stream invalid models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end
	Creator.Object.Index = #Creator.Track.Current.Objects
	Creator.ObjectPool.IsRefreshing = false
	if Creator.Track.Current.StartingGrid[1] then
		local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
		local model = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
		local min, max = Client.Function.Shared.GetModelDimensionsInCaches(model)
		Creator.Camera.Position = vector3(Creator.Track.Current.StartingGrid[1].x + (20.0 - min.z) * math.sin(math.rad(Creator.Track.Current.StartingGrid[1].heading)), Creator.Track.Current.StartingGrid[1].y - (20.0 - min.z) * math.cos(math.rad(Creator.Track.Current.StartingGrid[1].heading)), Creator.Track.Current.StartingGrid[1].z + (20.0 - min.z))
		Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Track.Current.StartingGrid[1].heading}
	elseif Creator.Track.Current.Objects[1] then
		local model = tonumber(Creator.Track.Current.Objects[1].hash) or GetHashKey(Creator.Track.Current.Objects[1].hash)
		local min, max = Client.Function.Shared.GetModelDimensionsInCaches(model)
		Creator.Camera.Position = vector3(Creator.Track.Current.Objects[1].x + (20.0 - min.z) * math.sin(math.rad(Creator.Track.Current.Objects[1].rotZ)), Creator.Track.Current.Objects[1].y - (20.0 - min.z) * math.cos(math.rad(Creator.Track.Current.Objects[1].rotZ)), Creator.Track.Current.Objects[1].z + (20.0 - min.z))
		Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Track.Current.Objects[1].rotZ}
	end
end

function Creator.Function.Track.AddFromData(data)
	if not data then return end
	-- Info
	data.mission = data.mission or {}
	-- Fixtures
	data.mission.dhprop = data.mission.dhprop or {}
	data.mission.dhprop.mn = data.mission.dhprop.mn or {}
	data.mission.dhprop.pos = data.mission.dhprop.pos or {}
	data.mission.dhprop.no = data.mission.dhprop.no or 0
	-- Dynamic props
	data.mission.dprop = data.mission.dprop or {}
	data.mission.dprop.model = data.mission.dprop.model or {}
	data.mission.dprop.loc = data.mission.dprop.loc or {}
	data.mission.dprop.vRot = data.mission.dprop.vRot or {}
	data.mission.dprop.prpdclr = data.mission.dprop.prpdclr or {}
	data.mission.dprop.collision = data.mission.dprop.collision or {}
	data.mission.dprop.no = data.mission.dprop.no or 0
	-- Static props
	data.mission.prop = data.mission.prop or {}
	data.mission.prop.model = data.mission.prop.model or {}
	data.mission.prop.loc = data.mission.prop.loc or {}
	data.mission.prop.vRot = data.mission.prop.vRot or {}
	data.mission.prop.prpclr = data.mission.prop.prpclr or {}
	data.mission.prop.pLODDist = data.mission.prop.pLODDist or {}
	data.mission.prop.collision = data.mission.prop.collision or {}
	data.mission.prop.prpbs = data.mission.prop.prpbs or {}
	data.mission.prop.prpsba = data.mission.prop.prpsba or {}
	data.mission.prop.no = data.mission.prop.no or 0
	-- Checkpoints
	data.mission.race = data.mission.race or {}
	data.mission.race.adlc = data.mission.race.adlc or {}
	data.mission.race.adlc2 = data.mission.race.adlc2 or {}
	data.mission.race.adlc3 = data.mission.race.adlc3 or {}
	data.mission.race.aveh = data.mission.race.aveh or {}
	data.mission.race.clbs = data.mission.race.clbs or 0
	data.mission.race.icv = data.mission.race.icv or -1
	data.mission.race.chl = data.mission.race.chl or {}
	data.mission.race.chh = data.mission.race.chh or {}
	data.mission.race.chs = data.mission.race.chs or {}
	data.mission.race.chpp = data.mission.race.chpp or {}
	data.mission.race.cpado = data.mission.race.cpado or {}
	data.mission.race.chstR = data.mission.race.chstR or {}
	data.mission.race.cptfrm = data.mission.race.cptfrm or {}
	data.mission.race.cptrtt = data.mission.race.cptrtt or {}
	data.mission.race.cptrst = data.mission.race.cptrst or {}
	data.mission.race.sndchk = data.mission.race.sndchk or {}
	data.mission.race.sndrsp = data.mission.race.sndrsp or {}
	data.mission.race.chs2 = data.mission.race.chs2 or {}
	data.mission.race.chpps = data.mission.race.chpps or {}
	data.mission.race.cpados = data.mission.race.cpados or {}
	data.mission.race.chstRs = data.mission.race.chstRs or {}
	data.mission.race.cptfrms = data.mission.race.cptfrms or {}
	data.mission.race.cptrtts = data.mission.race.cptrtts or {}
	data.mission.race.cptrsts = data.mission.race.cptrsts or {}
	data.mission.race.chvs = data.mission.race.chvs or {}
	data.mission.race.cpbs1 = data.mission.race.cpbs1 or {}
	data.mission.race.cpbs2 = data.mission.race.cpbs2 or {}
	data.mission.race.cpbs3 = data.mission.race.cpbs3 or {}
	data.mission.race.trfmvm = data.mission.race.trfmvm or {}
	data.mission.race.cppsst = data.mission.race.cppsst or {}
	data.mission.race.chp = data.mission.race.chp or 0

	Client.Function.Busyspinner.Display("parse", 1000, 2000)

	-- =================================
	-- Add ugc data to current track
	-- =================================
	local offsetIndex = #Creator.Track.Current.TransformVehicles
	local currentCheckpointsCount = #Creator.Track.Current.Checkpoints
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
		Creator.Track.Current.Checkpoints[currentCheckpointsCount + i] = {
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
			transformIndex = cptfrm >= 0 and (cptfrm + offsetIndex),
			isPlaneRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 0)) or (Client.Function.Math.IsBitSetValue(cppsst, 1)) or (Client.Function.Math.IsBitSetValue(cppsst, 2)) or (Client.Function.Math.IsBitSetValue(cppsst, 3))),
			planeRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 0) and 0) or (Client.Function.Math.IsBitSetValue(cppsst, 1) and 1) or (Client.Function.Math.IsBitSetValue(cppsst, 2) and 2) or (Client.Function.Math.IsBitSetValue(cppsst, 3) and 3)),
			isWarp = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 27)
		}
		if Creator.Track.Current.Checkpoints[currentCheckpointsCount + i].isRandom or Creator.Track.Current.Checkpoints[currentCheckpointsCount + i].isTransform or Creator.Track.Current.Checkpoints[currentCheckpointsCount + i].isPlaneRot or Creator.Track.Current.Checkpoints[currentCheckpointsCount + i].isWarp then
			Creator.Track.Current.Checkpoints[currentCheckpointsCount + i].isRound = true
		end
		if Creator.Track.Current.Checkpoints[currentCheckpointsCount + i].lockDirection then
			Creator.Track.Current.Checkpoints[currentCheckpointsCount + i].isRound = true
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
			Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i] = {
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
				transformIndex = cptfrms >= 0 and (cptfrms + offsetIndex),
				isPlaneRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 4)) or (Client.Function.Math.IsBitSetValue(cppsst, 5)) or (Client.Function.Math.IsBitSetValue(cppsst, 6)) or (Client.Function.Math.IsBitSetValue(cppsst, 7))),
				planeRot = cppsst and ((Client.Function.Math.IsBitSetValue(cppsst, 4) and 0) or (Client.Function.Math.IsBitSetValue(cppsst, 5) and 1) or (Client.Function.Math.IsBitSetValue(cppsst, 6) and 2) or (Client.Function.Math.IsBitSetValue(cppsst, 7) and 3)),
				isWarp = cpbs1 and Client.Function.Math.IsBitSetValue(cpbs1, 28)
			}
			if Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i].isRandom or Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i].isTransform or Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i].isPlaneRot or Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i].isWarp then
				Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i].isRound = true
			end
			if Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i].lockDirection then
				Creator.Track.Current.Checkpoints_2[currentCheckpointsCount + i].isRound = true
			end
		end
	end
	if #Creator.Track.Current.Checkpoints > currentCheckpointsCount then
		Creator.Function.UpdateBlip("checkpoint")
		for i = 1, #data.mission.race.trfmvm do
			Creator.Track.Current.TransformVehicles[#Creator.Track.Current.TransformVehicles + 1] = data.mission.race.trfmvm[i]
		end
		Creator.Multiplayer.ModificationCount.transformVehicles = Creator.Multiplayer.ModificationCount.transformVehicles + 1
		TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {transformVehicles = Creator.Track.Current.TransformVehicles, checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.transformVehicles}, "transformVehicles-sync")
		Creator.Checkpoint.Index = #Creator.Track.Current.Checkpoints
	end
	Wait(1000)
	local currentFixturesCount = #Creator.Track.Current.Fixtures
	local seen = {}
	for i = 1, data.mission.dhprop.no do
		local mn = data.mission.dhprop.mn[i]
		local pos = data.mission.dhprop.pos[i] or {}
		pos.x = pos.x or 0.0
		pos.y = pos.y or 0.0
		pos.z = pos.z or 0.0
		if mn and not seen[mn] and IsModelInCdimage(mn) and IsModelValid(mn) then
			seen[mn] = true
			Creator.Track.Current.Fixtures[#Creator.Track.Current.Fixtures + 1] = {
				hash = mn,
				handle = nil,
				x = pos.x,
				y = pos.y,
				z = pos.z
			}
		end
	end
	if #Creator.Track.Current.Fixtures > currentFixturesCount then
		Creator.Multiplayer.ModificationCount.fixtures = Creator.Multiplayer.ModificationCount.fixtures + 1
		TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {fixtures = Creator.Track.Current.Fixtures, modificationCount = Creator.Multiplayer.ModificationCount.fixtures}, "fixtures-sync")
		Creator.Fixture.Index = #Creator.Track.Current.Fixtures
	end
	Wait(1000)
	local validModels = {}
	local validObjects = {}
	local invalidObjects = {}
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
			Creator.Multiplayer.GlobalUniqueId = Creator.Multiplayer.GlobalUniqueId + 1
			local object = {
				uniqueId = Client.ServerId .. "-" .. Creator.Multiplayer.GlobalUniqueId,
				modificationCount = 0,
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
				visible = not Client.Function.Math.IsBitSetValue(prpbs, 9) and (pLODDist ~= 1),
				collision = collision == 1,
				dynamic = false
			}
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
			Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
			Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			if Client.Shared.Object.Effect[object.hash] then
				Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
			end
			Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
			validObjects[#validObjects + 1] = object
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
			Creator.Multiplayer.GlobalUniqueId = Creator.Multiplayer.GlobalUniqueId + 1
			local object = {
				uniqueId = Client.ServerId .. "-" .. Creator.Multiplayer.GlobalUniqueId,
				modificationCount = 0,
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
				visible = true,
				collision = collision == 1,
				dynamic = true
			}
			local gx = math.floor(object.x / 100.0)
			local gy = math.floor(object.y / 100.0)
			Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
			Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
			Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
			Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
			if Client.Shared.Object.Effect[object.hash] then
				Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
			end
			Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
			validObjects[#validObjects + 1] = object
		else
			invalidObjects[model] = true
		end
	end
	if #validObjects >= 1 then
		TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, validObjects, "template-place")
		Creator.Object.Index = #Creator.Track.Current.Objects
	end
	for k, v in pairs(invalidObjects) do
		print("model (" .. k .. ") does not exist or is invalid!")
		Client.Function.Message.Display(string.format(Client.Function.Translate.Get("object-hash-null"), k))
	end
	if Client.Function.Math.TableCount(invalidObjects) > 0 then
		print("Ask the server owner to stream invalid models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end
end

function Creator.Function.Track.ConvertToData()
	local data = {
		raceId = Creator.Track.Current.RaceId,
		thumbnail = Creator.Track.Current.Thumbnail,
		published = Creator.Track.Current.Published,
		category = Creator.Track.Current.Category,
		testVehicle = "",
		firework = {
			name = Creator.Track.Current.Firework.Name,
			r = Creator.Track.Current.Firework.R,
			g = Creator.Track.Current.Firework.G,
			b = Creator.Track.Current.Firework.B
		},
		meta = {
			vehcl = {}
		},
		mission = {
			gen = {
				ownerid = Creator.Track.Current.OwnerName,
				nm = Creator.Track.Current.Title,
				dec = {"Create on FiveM"},
				type = 2,
				subtype = 6,
				start = {
					x = Creator.Track.Current.StartingGrid[1].x,
					y = Creator.Track.Current.StartingGrid[1].y,
					z = Creator.Track.Current.StartingGrid[1].z
				},
				blmpmsg = Creator.Track.Current.BlimpText,
				ivm = 0
			},
			dhprop = {
				mn = {},
				pos = {},
				no = 0
			},
			dprop = {
				model = {},
				loc = {},
				vRot = {},
				prpdclr = {},
				collision = {},
				no = 0
			},
			prop = {
				model = {},
				loc = {},
				vRot = {},
				prpclr = {},
				pLODDist = {},
				collision = {},
				prpbs = {},
				prpsba = {},
				no = 0
			},
			race = {
				-- Vehicle bitset
				adlc = {},
				adlc2 = {},
				adlc3 = {},
				aveh = {},
				clbs = 0,
				icv = 0,
				-- Primary
				chl = {},
				chh = {},
				chs = {},
				chpp = {},
				cpado = {},
				chstR = {},
				cptfrm = {},
				cptrtt = {},
				cptrst = {},
				-- Secondary
				sndchk = {},
				sndrsp = {},
				chs2 = {},
				chpps = {},
				cpados = {},
				chstRs = {},
				cptfrms = {},
				cptrtts = {},
				cptrsts = {},
				-- Other Settings
				chvs = {},
				cpbs1 = {},
				cpbs2 = {},
				cpbs3 = {},
				trfmvm = {},
				cppsst = {},
				chp = 0
			},
			veh = {
				loc = {},
				head = {},
				no = 0
			}
		}
	}
	local defaultVehicle = nil
	if Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] then
		if Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] then
			defaultVehicle = Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model
			if Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].aveh then
				data.mission.gen.ivm = Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index - 1
			else
				data.mission.gen.ivm = GetHashKey(defaultVehicle)
			end
			data.mission.race.icv = Creator.Track.Current.DefaultClass
		end
	end
	if defaultVehicle then
		data.testVehicle = defaultVehicle
	else
		defaultVehicle = Creator.Track.Current.TestVehicle
		local hash = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
		if not IsModelInCdimage(hash) or not IsModelValid(hash) or not IsModelAVehicle(hash) then
			data.testVehicle = "bmx"
			Creator.Track.Current.AvailableVehicles[13].vehicles[1].enabled = true
			Creator.Track.Current.AvailableVehicles[13].index = 1
			Creator.Track.Current.DefaultClass = 13
			data.mission.gen.ivm = 0
			data.mission.race.icv = 13
		else
			data.testVehicle = defaultVehicle
			local found = false
			for classid = 0, 27 do
				for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
					if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].hash == hash then
						Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = true
						Creator.Track.Current.AvailableVehicles[classid].index = i
						Creator.Track.Current.DefaultClass = classid
						if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].aveh then
							data.mission.gen.ivm = i - 1
						else
							data.mission.gen.ivm = hash
						end
						data.mission.race.icv = classid
						found = true
						break
					end
				end
				if found then break end
			end
			if not found then
				Creator.Track.Current.DefaultClass = nil
				data.mission.gen.ivm = -1
				data.mission.race.icv = -1
			end
		end
	end
	local clbs = 0
	for classid = 0, 27 do
		local found = false
		local aveh = 0
		local adlc = 0
		local adlc2 = 0
		local adlc3 = 0
		for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
			if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].aveh then
				if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
					found = true
				else
					aveh = Client.Function.Math.SetBitValue(aveh, Creator.Track.Current.AvailableVehicles[classid].vehicles[i].aveh)
				end
			elseif Creator.Track.Current.AvailableVehicles[classid].vehicles[i].adlc then
				if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
					found = true
					adlc = Client.Function.Math.SetBitValue(adlc, Creator.Track.Current.AvailableVehicles[classid].vehicles[i].adlc)
				end
			elseif Creator.Track.Current.AvailableVehicles[classid].vehicles[i].adlc2 then
				if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
					found = true
					adlc2 = Client.Function.Math.SetBitValue(adlc2, Creator.Track.Current.AvailableVehicles[classid].vehicles[i].adlc2)
				end
			elseif Creator.Track.Current.AvailableVehicles[classid].vehicles[i].adlc3 then
				if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
					found = true
					adlc3 = Client.Function.Math.SetBitValue(adlc3, Creator.Track.Current.AvailableVehicles[classid].vehicles[i].adlc3)
				end
			end
		end
		if found then
			clbs = Client.Function.Math.SetBitValue(clbs, classid)
		else
			table.insert(data.meta.vehcl, Client.Shared.Vanilla[classid].class)
		end
		table.insert(data.mission.race.adlc, adlc)
		table.insert(data.mission.race.adlc2, adlc2)
		table.insert(data.mission.race.adlc3, adlc3)
		table.insert(data.mission.race.aveh, aveh)
	end
	data.mission.race.clbs = clbs
	for i, fixture in ipairs(Creator.Track.Current.Fixtures) do
		data.mission.dhprop.no = data.mission.dhprop.no + 1
		table.insert(data.mission.dhprop.mn, fixture.hash)
		table.insert(data.mission.dhprop.pos, {
			x = fixture.x,
			y = fixture.y,
			z = fixture.z
		})
	end
	local transformVehicles = {}
	for i, model in ipairs(Creator.Track.Current.TransformVehicles) do
		table.insert(transformVehicles, tonumber(model) or GetHashKey(model))
	end
	data.mission.race.trfmvm = transformVehicles
	for i, object in ipairs(Creator.Track.Current.Objects) do
		if object.dynamic then
			data.mission.dprop.no = data.mission.dprop.no + 1
			table.insert(data.mission.dprop.model, object.hash)
			table.insert(data.mission.dprop.loc, {
				x = object.x,
				y = object.y,
				z = object.z
			})
			table.insert(data.mission.dprop.vRot, {
				x = object.rotX,
				y = object.rotY,
				z = object.rotZ
			})
			table.insert(data.mission.dprop.prpdclr, object.color)
			table.insert(data.mission.dprop.collision, object.collision and 1 or 0)
		else
			data.mission.prop.no = data.mission.prop.no + 1
			table.insert(data.mission.prop.model, object.hash)
			table.insert(data.mission.prop.loc, {
				x = object.x,
				y = object.y,
				z = object.z
			})
			table.insert(data.mission.prop.vRot, {
				x = object.rotX,
				y = object.rotY,
				z = object.rotZ
			})
			table.insert(data.mission.prop.prpclr, object.color)
			table.insert(data.mission.prop.pLODDist, object.visible and 16960 or 1)
			table.insert(data.mission.prop.collision, object.collision and 1 or 0)
			table.insert(data.mission.prop.prpbs, 0)
			table.insert(data.mission.prop.prpsba, object.prpsba)
		end
	end
	for i, checkpoint in ipairs(Creator.Track.Current.Checkpoints) do
		data.mission.race.chp = data.mission.race.chp + 1
		local checkpoint_2 = Creator.Track.Current.Checkpoints_2[i]
		table.insert(data.mission.race.chl, {
			x = checkpoint.x,
			y = checkpoint.y,
			z = checkpoint.z
		})
		table.insert(data.mission.race.chh, checkpoint.heading)
		table.insert(data.mission.race.chs, checkpoint.diameterCollect)
		table.insert(data.mission.race.chpp, checkpoint.pitch)
		table.insert(data.mission.race.cpado, checkpoint.offset)
		table.insert(data.mission.race.chstR, checkpoint.tallRadius)
		table.insert(data.mission.race.cptfrm, (checkpoint.isRandom and -2) or (checkpoint.isTransform and checkpoint.transformIndex) or -1)
		table.insert(data.mission.race.cptrtt, checkpoint.isRandom and checkpoint.randomClass or 0)
		table.insert(data.mission.race.cptrst, checkpoint.isRandom and checkpoint.randomClass == -1 and checkpoint.randomSetting or 0)
		table.insert(data.mission.race.sndchk, {
			x = checkpoint_2 and checkpoint_2.x or 0.0,
			y = checkpoint_2 and checkpoint_2.y or 0.0,
			z = checkpoint_2 and checkpoint_2.z or 0.0
		})
		table.insert(data.mission.race.sndrsp, checkpoint_2 and checkpoint_2.heading or 0.0)
		table.insert(data.mission.race.chs2, checkpoint_2 and checkpoint_2.diameterCollect or 1.0)
		table.insert(data.mission.race.chpps, checkpoint_2 and checkpoint_2.pitch or 0.0)
		table.insert(data.mission.race.cpados, checkpoint_2 and checkpoint_2.offset or {x = 0.0, y = 0.0, z = 0.0})
		table.insert(data.mission.race.chstRs, checkpoint_2 and checkpoint_2.tallRadius or 500.0)
		table.insert(data.mission.race.cptfrms, checkpoint_2 and ((checkpoint_2.isRandom and -2) or (checkpoint_2.isTransform and checkpoint_2.transformIndex) or -1) or -1)
		table.insert(data.mission.race.cptrtts, checkpoint_2 and (checkpoint_2.isRandom and checkpoint_2.randomClass or 0) or 0)
		table.insert(data.mission.race.cptrsts, checkpoint_2 and (checkpoint_2.isRandom and checkpoint_2.randomClass == -1 and checkpoint_2.randomSetting or 0) or 0)
		table.insert(data.mission.race.chvs, checkpoint.diameterDraw)
		local cpbs1 = 1
		if checkpoint.isRound then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 1)
		end
		if checkpoint.isAir then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 9)
		end
		if checkpoint.isFake then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 10)
		end
		if checkpoint.lockDirection then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 16)
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 18)
		end
		if checkpoint.isWarp then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 27)
		end
		if checkpoint_2 and checkpoint_2.isRound then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 2)
		end
		if checkpoint_2 and checkpoint_2.isAir then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 13)
		end
		if checkpoint_2 and checkpoint_2.isFake then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 11)
		end
		if checkpoint_2 and checkpoint_2.lockDirection then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 17)
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 19)
		end
		if checkpoint_2 and checkpoint_2.isWarp then
			cpbs1 = Client.Function.Math.SetBitValue(cpbs1, 28)
		end
		table.insert(data.mission.race.cpbs1, cpbs1)
		local cpbs2 = 0
		if checkpoint.isPit then
			cpbs2 = Client.Function.Math.SetBitValue(cpbs2, 16)
		end
		if checkpoint.isTall then
			cpbs2 = Client.Function.Math.SetBitValue(cpbs2, 20)
		end
		if checkpoint.lowerAlpha then
			cpbs2 = Client.Function.Math.SetBitValue(cpbs2, 24)
		end
		if checkpoint_2 and checkpoint_2.isPit then
			cpbs2 = Client.Function.Math.SetBitValue(cpbs2, 17)
		end
		if checkpoint_2 and checkpoint_2.isTall then
			cpbs2 = Client.Function.Math.SetBitValue(cpbs2, 21)
		end
		if checkpoint_2 and checkpoint_2.lowerAlpha then
			cpbs2 = Client.Function.Math.SetBitValue(cpbs2, 25)
		end
		table.insert(data.mission.race.cpbs2, cpbs2)
		table.insert(data.mission.race.cpbs3, 0)
		local cppsst = 0
		if checkpoint.isPlaneRot then
			cppsst = Client.Function.Math.SetBitValue(cppsst, checkpoint.planeRot)
		end
		if checkpoint_2 and checkpoint_2.isPlaneRot then
			cppsst = Client.Function.Math.SetBitValue(cppsst, checkpoint_2.planeRot + 4)
		end
		table.insert(data.mission.race.cppsst, cppsst)
	end
	for i, grid in ipairs(Creator.Track.Current.StartingGrid) do
		data.mission.veh.no = data.mission.veh.no + 1
		table.insert(data.mission.veh.loc, {
			x = grid.x,
			y = grid.y,
			z = grid.z
		})
		table.insert(data.mission.veh.head, grid.heading)
	end
	Client.Function.Busyspinner.Display("upload", 65536, #json.encode(data) * 1.02)
	return data
end