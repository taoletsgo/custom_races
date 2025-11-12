function ConvertDataFromUGC(data)
	if not data or not data.mission then return end
	-- Info
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
	data.mission.gen.ivm = data.mission.gen.ivm or 0
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
	data.mission.race.icv = data.mission.race.icv or 0
	data.mission.race.chl = data.mission.race.chl or {}
	data.mission.race.chh = data.mission.race.chh or {}
	data.mission.race.chs = data.mission.race.chs or {}
	data.mission.race.chpp = data.mission.race.chpp or {}
	data.mission.race.cpado = data.mission.race.cpado or {}
	data.mission.race.chstR = data.mission.race.chstR or {}
	data.mission.race.cptfrm = data.mission.race.cptfrm or {}
	data.mission.race.cptrtt = data.mission.race.cptrtt or {}
	data.mission.race.sndchk = data.mission.race.sndchk or {}
	data.mission.race.sndrsp = data.mission.race.sndrsp or {}
	data.mission.race.chs2 = data.mission.race.chs2 or {}
	data.mission.race.chpps = data.mission.race.chpps or {}
	data.mission.race.cpados = data.mission.race.cpados or {}
	data.mission.race.chstRs = data.mission.race.chstRs or {}
	data.mission.race.cptfrms = data.mission.race.cptfrms or {}
	data.mission.race.cptrtts = data.mission.race.cptrtts or {}
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

	-- ===============================
	-- Convert ugc data to currentRace
	-- ===============================
	currentRace.raceid = data.raceid
	currentRace.published = data.published
	currentRace.thumbnail = data.thumbnail
	local adlcs = {data.mission.race.adlc, data.mission.race.adlc2, data.mission.race.adlc3}
	local aveh = data.mission.race.aveh
	local clbs = data.mission.race.clbs
	local icv = data.mission.race.icv
	local ivm = data.mission.gen.ivm
	currentRace.default_class = nil
	for classid = 0, 27 do
		currentRace.available_vehicles[classid].index = nil
		for i = 1, #currentRace.available_vehicles[classid].vehicles do
			currentRace.available_vehicles[classid].vehicles[i].enabled = false
		end
	end
	for classid = 0, 27 do
		if isBitSet(clbs, classid) then
			if vanilla[classid].aveh then
				if aveh[classid + 1] then
					for i = 0, #vanilla[classid].aveh - 1 do
						if not isBitSet(aveh[classid + 1], i) then
							local model = vanilla[classid].aveh[i + 1]
							local hash = GetHashKey(model)
							if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
								currentRace.available_vehicles[classid].vehicles[i + 1].enabled = true
								currentRace.available_vehicles[classid].index = currentRace.available_vehicles[classid].index or (i + 1)
							end
						end
					end
				end
			end
			if vanilla[classid].adlc then
				for offset, adlc in ipairs(adlcs) do
					if adlc[classid + 1] then
						for i = 0, 30 do
							if isBitSet(adlc[classid + 1], i) then
								local model = vanilla[classid].adlc[(offset - 1) * 31 + i + 1]
								local hash = model and GetHashKey(model)
								if hash and IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
									currentRace.available_vehicles[classid].vehicles[(vanilla[classid].aveh and #vanilla[classid].aveh or 0) + (offset - 1) * 31 + i + 1].enabled = true
									currentRace.available_vehicles[classid].index = currentRace.available_vehicles[classid].index or ((vanilla[classid].aveh and #vanilla[classid].aveh or 0) + (offset - 1) * 31 + i + 1)
								end
							end
						end
					end
				end
			end
		end
	end
	local default_vehicle = nil
	if IsModelInCdimage(ivm) and IsModelValid(ivm) and IsModelAVehicle(ivm) then
		local found = false
		for classid = 0, 27 do
			for i = 1, #currentRace.available_vehicles[classid].vehicles do
				if GetHashKey(currentRace.available_vehicles[classid].vehicles[i].model) == ivm then
					default_vehicle = currentRace.available_vehicles[classid].vehicles[i].model
					currentRace.available_vehicles[classid].vehicles[i].enabled = true
					currentRace.available_vehicles[classid].index = i
					currentRace.default_class = classid
					found = true
					break
				end
			end
			if found then break end
		end
		if not found then
			local default_class = nil
			local validClasses = {}
			for classid = 0, 27 do
				for i = 1, #currentRace.available_vehicles[classid].vehicles do
					if currentRace.available_vehicles[classid].vehicles[i].enabled then
						validClasses[classid] = true
						break
					end
				end
			end
			local found_2 = false
			if validClasses[icv] then
				default_class = icv
				found_2 = true
			else
				for i = 0, 27, 1 do
					if validClasses[i] then
						default_class = i
						found_2 = true
						break
					end
				end
			end
			if not found_2 then
				default_class = nil
			end
			if default_class and currentRace.available_vehicles[default_class].index and currentRace.available_vehicles[default_class].vehicles[currentRace.available_vehicles[default_class].index] then
				default_vehicle = currentRace.available_vehicles[default_class].vehicles[currentRace.available_vehicles[default_class].index].model
				currentRace.default_class = default_class
			else
				currentRace.default_class = nil
			end
		end
	else
		if currentRace.available_vehicles[icv] and currentRace.available_vehicles[icv].vehicles then
			if currentRace.available_vehicles[icv].vehicles[ivm + 1] then
				if currentRace.available_vehicles[icv].vehicles[ivm + 1].enabled then
					default_vehicle = currentRace.available_vehicles[icv].vehicles[ivm + 1].model
					currentRace.available_vehicles[icv].index = ivm + 1
					currentRace.default_class = icv
				else
					currentRace.default_class = nil
				end
			end
		end
	end
	if default_vehicle then
		currentRace.test_vehicle = default_vehicle
	else
		default_vehicle = data.test_vehicle or currentRace.test_vehicle
		local model = tonumber(default_vehicle) or GetHashKey(default_vehicle)
		if not IsModelInCdimage(model) or not IsModelValid(model) then
			currentRace.test_vehicle = "bmx"
			currentRace.available_vehicles[13].vehicles[1].enabled = true
			currentRace.available_vehicles[13].index = 1
			currentRace.default_class = 13
		else
			currentRace.test_vehicle = default_vehicle
			local found = false
			for classid = 0, 27 do
				for i = 1, #currentRace.available_vehicles[classid].vehicles do
					if GetHashKey(currentRace.available_vehicles[classid].vehicles[i].model) == model then
						currentRace.available_vehicles[classid].vehicles[i].enabled = true
						currentRace.available_vehicles[classid].index = i
						currentRace.default_class = classid
						found = true
						break
					end
				end
				if found then break end
			end
			if not found then
				currentRace.default_class = nil
			end
		end
	end
	local found = false
	for k,v in pairs(data.mission.race.trfmvm) do
		if v ~= 0 then
			found = true
			break
		end
	end
	currentRace.transformVehicles = found and data.mission.race.trfmvm or {0, -422877666, -731262150, "bmx", "xa21"}
	currentRace.owner_name = data.mission.gen.ownerid
	local title = data.mission.gen.nm:gsub("[\\/:\"*?<>|]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""):gsub("custom_files", ""):gsub("local_files", "")
	if StringCount(title) > 0 then
		if not currentRace.raceid then
			global_var.lock_2 = true
			TriggerServerCallback("custom_creator:server:check_title", function(bool)
				if bool then
					currentRace.title = title
				else
					currentRace.title = "unknown"
					DisplayCustomMsgs(GetTranslate("title-exist"))
				end
				global_var.lock_2 = false
			end, title)
		else
			currentRace.title = title
		end
	else
		currentRace.title = "unknown"
		DisplayCustomMsgs(GetTranslate("title-error"))
	end
	currentRace.blimp_text = data.mission.gen.blmpmsg
	SetScrollTextOnBlimp(currentRace.blimp_text)
	particleIndex = 1
	if data.firework and data.firework.name then
		for i = 1, #particles do
			if particles[i] == data.firework.name then
				particleIndex = i
				break
			end
		end
	end
	currentRace.firework.name = particles[particleIndex]
	currentRace.firework.r = data.firework and data.firework.r or 255
	currentRace.firework.g = data.firework and data.firework.g or 255
	currentRace.firework.b = data.firework and data.firework.b or 255
	currentRace.startingGrid = {}
	for i = 1, data.mission.veh.no do
		local loc = data.mission.veh.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local head = data.mission.veh.head[i] or 0.0
		currentRace.startingGrid[i] = {
			handle = nil,
			x = RoundedValue(loc.x, 3),
			y = RoundedValue(loc.y, 3),
			z = RoundedValue(loc.z, 3),
			heading = RoundedValue(head, 3)
		}
	end
	startingGridVehicleIndex = #currentRace.startingGrid
	currentRace.checkpoints = {}
	currentRace.checkpoints_2 = {}
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
		local cpbs1 = data.mission.race.cpbs1[i] or nil
		local cpbs2 = data.mission.race.cpbs2[i] or nil
		local cpbs3 = data.mission.race.cpbs3[i] or nil
		local cppsst = data.mission.race.cppsst[i] or nil
		local is_random_temp = data.mission.race.cptfrm[i] and data.mission.race.cptfrm[i] == -2 and true
		local is_transform_temp = not is_random_temp and (data.mission.race.cptfrm[i] and data.mission.race.cptfrm[i] >= 0 and true)
		currentRace.checkpoints[i] = {
			x = RoundedValue(chl.x, 3),
			y = RoundedValue(chl.y, 3),
			z = RoundedValue(chl.z, 3),
			heading = RoundedValue(chh, 3),
			d_collect = RoundedValue(chs >= 0.5 and chs or 1.0, 3),
			d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
			pitch = chpp,
			offset = cpado,
			lock_dir = cpbs1 and ((isBitSet(cpbs1, 16) and not (cpado.x == 0.0 and cpado.y == 0.0 and cpado.z == 0.0)) or isBitSet(cpbs1, 18)),
			is_restricted = cpbs1 and isBitSet(cpbs1, 5),
			is_pit = cpbs2 and isBitSet(cpbs2, 16),
			is_lower = cpbs2 and isBitSet(cpbs2, 18),
			is_tall = cpbs2 and isBitSet(cpbs2, 20),
			tall_range = chstR,
			low_alpha = cpbs2 and isBitSet(cpbs2, 24),
			is_round = cpbs1 and isBitSet(cpbs1, 1),
			is_air = cpbs1 and isBitSet(cpbs1, 9),
			is_fake = cpbs1 and isBitSet(cpbs1, 10),
			is_random = is_random_temp,
			randomClass = is_random_temp and data.mission.race.cptrtt[i] or 0,
			is_transform = is_transform_temp,
			transform_index = is_transform_temp and data.mission.race.cptfrm[i] or 0,
			is_planeRot = cppsst and ((isBitSet(cppsst, 0)) or (isBitSet(cppsst, 1)) or (isBitSet(cppsst, 2)) or (isBitSet(cppsst, 3))),
			plane_rot = cppsst and ((isBitSet(cppsst, 0) and 0) or (isBitSet(cppsst, 1) and 1) or (isBitSet(cppsst, 2) and 2) or (isBitSet(cppsst, 3) and 3)),
			is_warp = cpbs1 and isBitSet(cpbs1, 27)
		}
		if currentRace.checkpoints[i].is_random or currentRace.checkpoints[i].is_transform or currentRace.checkpoints[i].is_planeRot or currentRace.checkpoints[i].is_warp then
			currentRace.checkpoints[i].is_round = true
		end
		if currentRace.checkpoints[i].lock_dir then
			currentRace.checkpoints[i].is_round = true
			currentRace.checkpoints[i].is_air = true
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
			local is_random_temp_2 = data.mission.race.cptfrms[i] and data.mission.race.cptfrms[i] == -2 and true
			local is_transform_temp_2 = not is_random_temp_2 and (data.mission.race.cptfrms[i] and data.mission.race.cptfrms[i] >= 0 and true)
			currentRace.checkpoints_2[i] = {
				x = RoundedValue(sndchk.x, 3),
				y = RoundedValue(sndchk.y, 3),
				z = RoundedValue(sndchk.z, 3),
				heading = RoundedValue(sndrsp, 3),
				d_collect = RoundedValue(chs2 >= 0.5 and chs2 or 1.0, 3),
				d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
				pitch = chpps,
				offset = cpados,
				lock_dir = cpbs1 and ((isBitSet(cpbs1, 17) and not (cpados.x == 0.0 and cpados.y == 0.0 and cpados.z == 0.0)) or isBitSet(cpbs1, 19)),
				is_restricted = cpbs2 and isBitSet(cpbs2, 15),
				is_pit = cpbs2 and isBitSet(cpbs2, 17),
				is_lower = cpbs2 and isBitSet(cpbs2, 19),
				is_tall = cpbs2 and isBitSet(cpbs2, 21),
				tall_range = chstRs,
				low_alpha = cpbs2 and isBitSet(cpbs2, 25),
				is_round = cpbs1 and isBitSet(cpbs1, 2),
				is_air = cpbs1 and isBitSet(cpbs1, 13),
				is_fake = cpbs1 and isBitSet(cpbs1, 11),
				is_random = is_random_temp_2,
				randomClass = is_random_temp_2 and data.mission.race.cptrtts[i] or 0,
				is_transform = is_transform_temp_2,
				transform_index = is_transform_temp_2 and data.mission.race.cptfrms[i] or 0,
				is_planeRot = cppsst and ((isBitSet(cppsst, 4)) or (isBitSet(cppsst, 5)) or (isBitSet(cppsst, 6)) or (isBitSet(cppsst, 7))),
				plane_rot = cppsst and ((isBitSet(cppsst, 4) and 0) or (isBitSet(cppsst, 5) and 1) or (isBitSet(cppsst, 6) and 2) or (isBitSet(cppsst, 7) and 3)),
				is_warp = cpbs1 and isBitSet(cpbs1, 28)
			}
			if currentRace.checkpoints_2[i].is_random or currentRace.checkpoints_2[i].is_transform or currentRace.checkpoints_2[i].is_planeRot or currentRace.checkpoints_2[i].is_warp then
				currentRace.checkpoints_2[i].is_round = true
			end
			if currentRace.checkpoints_2[i].lock_dir then
				currentRace.checkpoints_2[i].is_round = true
				currentRace.checkpoints_2[i].is_air = true
			end
		end
	end
	checkpointIndex = #currentRace.checkpoints
	blips.checkpoints = {}
	blips.checkpoints_2 = {}
	for k, v in pairs(currentRace.checkpoints) do
		blips.checkpoints[k] = CreateBlipForCreator(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	for k, v in pairs(currentRace.checkpoints_2) do
		blips.checkpoints_2[k] = CreateBlipForCreator(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	currentRace.fixtures = {}
	local seen = {}
	for i = 1, data.mission.dhprop.no do
		local mn = data.mission.dhprop.mn[i]
		local pos = data.mission.dhprop.pos[i] or {}
		pos.x = pos.x or 0.0
		pos.y = pos.y or 0.0
		pos.z = pos.z or 0.0
		if mn and not seen[mn] and IsModelInCdimage(mn) and IsModelValid(mn) then
			seen[mn] = true
			currentRace.fixtures[#currentRace.fixtures + 1] = {
				hash = mn,
				handle = nil,
				x = pos.x,
				y = pos.y,
				z = pos.z
			}
		end
	end
	fixtureIndex = #currentRace.fixtures
	local invalidObjects = {}
	currentRace.objects = {}
	for i = 1, data.mission.prop.no do
		local model = data.mission.prop.model[i] or 779917859
		local loc = data.mission.prop.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local vRot = data.mission.prop.vRot[i] or {}
		vRot.x = vRot.x or 0.0
		vRot.y = vRot.y or 0.0
		vRot.z = vRot.z or 0.0
		local prpclr = data.mission.prop.prpclr[i] or 0
		local pLODDist = data.mission.prop.pLODDist[i] or 16960
		local collision = data.mission.prop.collision[i] or 1
		local prpbs = data.mission.prop.prpbs[i] or 0
		local prpsba = data.mission.prop.prpsba[i] or 2
		local object = {
			uniqueId = nil,
			modificationCount = nil,
			hash = model,
			handle = nil,
			x = RoundedValue(loc.x, 3),
			y = RoundedValue(loc.y, 3),
			z = RoundedValue(loc.z, 3),
			rotX = RoundedValue(vRot.x, 3),
			rotY = RoundedValue(vRot.y, 3),
			rotZ = RoundedValue(vRot.z, 3),
			color = prpclr,
			prpsba = prpsba,
			visible = not isBitSet(prpbs, 9) and (pLODDist ~= 1),
			collision = collision == 1,
			dynamic = false
		}
		object.handle = CreatePropForCreator(object.hash, object.x, object.y, object.z, object.rotX, object.rotY, object.rotZ, object.color, object.prpsba)
		if object.handle then
			if object.visible then
				ResetEntityAlpha(object.handle)
			end
			if not object.collision then
				SetEntityCollision(object.handle, false, false)
			end
			uniqueId = uniqueId + 1
			object.uniqueId = myServerId .. "-" .. uniqueId
			object.modificationCount = 0
			currentRace.objects[#currentRace.objects + 1] = object
		else
			invalidObjects[object.hash] = true
		end
	end
	for i = 1, data.mission.dprop.no do
		local model = data.mission.dprop.model[i] or 779917859
		local loc = data.mission.dprop.loc[i] or {}
		loc.x = loc.x or 0.0
		loc.y = loc.y or 0.0
		loc.z = loc.z or 0.0
		local vRot = data.mission.dprop.vRot[i] or {}
		vRot.x = vRot.x or 0.0
		vRot.y = vRot.y or 0.0
		vRot.z = vRot.z or 0.0
		local prpdclr = data.mission.dprop.prpdclr[i] or 0
		local collision = data.mission.dprop.collision[i] or 1
		local object = {
			uniqueId = nil,
			modificationCount = nil,
			hash = model,
			handle = nil,
			x = RoundedValue(loc.x, 3),
			y = RoundedValue(loc.y, 3),
			z = RoundedValue(loc.z, 3),
			rotX = RoundedValue(vRot.x, 3),
			rotY = RoundedValue(vRot.y, 3),
			rotZ = RoundedValue(vRot.z, 3),
			color = prpdclr,
			prpsba = 2,
			visible = true,
			collision = collision == 1,
			dynamic = true
		}
		object.handle = CreatePropForCreator(object.hash, object.x, object.y, object.z, object.rotX, object.rotY, object.rotZ, object.color, object.prpsba)
		if object.handle then
			ResetEntityAlpha(object.handle)
			if not object.collision then
				SetEntityCollision(object.handle, false, false)
			end
			uniqueId = uniqueId + 1
			object.uniqueId = myServerId .. "-" .. uniqueId
			object.modificationCount = 0
			currentRace.objects[#currentRace.objects + 1] = object
		else
			invalidObjects[object.hash] = true
		end
	end
	for k, v in pairs(invalidObjects) do
		print("model (" .. k .. ") does not exist or is invalid!")
		DisplayCustomMsgs(string.format(GetTranslate("object-hash-null"), k))
	end
	if TableCount(invalidObjects) > 0 then
		print("Ask the server owner to stream invalid models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end
	objectIndex = #currentRace.objects
	blips.objects = {}
	for k, v in pairs(currentRace.objects) do
		blips.objects[k] = CreateBlipForCreator(v.x, v.y, v.z, 0.60, 271, 50, v.handle)
	end
	if currentRace.startingGrid[1] then
		local default_vehicle = currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] and currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index] and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].model or currentRace.test_vehicle
		local model = tonumber(default_vehicle) or GetHashKey(default_vehicle)
		local min, max = GetModelDimensions(model)
		cameraPosition = vector3(currentRace.startingGrid[1].x + (20.0 - min.z) * math.sin(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].y - (20.0 - min.z) * math.cos(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].z + (20.0 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.startingGrid[1].heading}
	elseif currentRace.objects[1] then
		local model = tonumber(currentRace.objects[1].hash) or GetHashKey(currentRace.objects[1].hash)
		local min, max = GetModelDimensions(model)
		cameraPosition = vector3(currentRace.objects[1].x + (20.0 - min.z) * math.sin(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].y - (20.0 - min.z) * math.cos(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].z + (20.0 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.objects[1].rotZ}
	end
end

function ConvertDataToUGC()
	local data = {
		raceid = currentRace.raceid,
		published = currentRace.published,
		thumbnail = currentRace.thumbnail,
		test_vehicle = "",
		firework = {
			name = currentRace.firework.name,
			r = currentRace.firework.r,
			g = currentRace.firework.g,
			b = currentRace.firework.b
		},
		meta = {
			vehcl = {}
		},
		mission = {
			gen = {
				ownerid = currentRace.owner_name,
				nm = currentRace.title,
				dec = {"Create on FiveM"},
				type = 2,
				subtype = 6,
				start = {
					x = currentRace.startingGrid[1].x,
					y = currentRace.startingGrid[1].y,
					z = currentRace.startingGrid[1].z
				},
				blmpmsg = currentRace.blimp_text,
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
				-- Vehicle bitset, todo
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
				-- Secondary
				sndchk = {},
				sndrsp = {},
				chs2 = {},
				chpps = {},
				cpados = {},
				chstRs = {},
				cptfrms = {},
				cptrtts = {},
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
	local default_vehicle = nil
	if currentRace.default_class and currentRace.available_vehicles[currentRace.default_class] then
		if currentRace.available_vehicles[currentRace.default_class].index and currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index] then
			default_vehicle = currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].model
			if currentRace.available_vehicles[currentRace.default_class].vehicles[currentRace.available_vehicles[currentRace.default_class].index].aveh then
				data.mission.gen.ivm = currentRace.available_vehicles[currentRace.default_class].index - 1
			else
				data.mission.gen.ivm = GetHashKey(default_vehicle)
			end
			data.mission.race.icv = currentRace.default_class
		end
	end
	if default_vehicle then
		data.test_vehicle = default_vehicle
	else
		default_vehicle = currentRace.test_vehicle
		local model = tonumber(default_vehicle) or GetHashKey(default_vehicle)
		if not IsModelInCdimage(model) or not IsModelValid(model) then
			data.test_vehicle = "bmx"
			currentRace.available_vehicles[13].vehicles[1].enabled = true
			currentRace.available_vehicles[13].index = 1
			currentRace.default_class = 13
			data.mission.gen.ivm = 0
			data.mission.race.icv = 13
		else
			data.test_vehicle = default_vehicle
			local found = false
			for classid = 0, 27 do
				for i = 1, #currentRace.available_vehicles[classid].vehicles do
					if GetHashKey(currentRace.available_vehicles[classid].vehicles[i].model) == model then
						currentRace.available_vehicles[classid].vehicles[i].enabled = true
						currentRace.available_vehicles[classid].index = i
						currentRace.default_class = classid
						if currentRace.available_vehicles[classid].vehicles[i].aveh then
							data.mission.gen.ivm = i - 1
						else
							data.mission.gen.ivm = model
						end
						data.mission.race.icv = classid
						found = true
						break
					end
				end
				if found then break end
			end
			if not found then
				currentRace.default_class = nil
				data.mission.gen.ivm = 0
				data.mission.race.icv = 0
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
		for i = 1, #currentRace.available_vehicles[classid].vehicles do
			if currentRace.available_vehicles[classid].vehicles[i].aveh then
				if currentRace.available_vehicles[classid].vehicles[i].enabled then
					found = true
				else
					aveh = setBit(aveh, currentRace.available_vehicles[classid].vehicles[i].aveh)
				end
			elseif currentRace.available_vehicles[classid].vehicles[i].adlc then
				if currentRace.available_vehicles[classid].vehicles[i].enabled then
					found = true
					adlc = setBit(adlc, currentRace.available_vehicles[classid].vehicles[i].adlc)
				end
			elseif currentRace.available_vehicles[classid].vehicles[i].adlc2 then
				if currentRace.available_vehicles[classid].vehicles[i].enabled then
					found = true
					adlc2 = setBit(adlc2, currentRace.available_vehicles[classid].vehicles[i].adlc2)
				end
			elseif currentRace.available_vehicles[classid].vehicles[i].adlc3 then
				if currentRace.available_vehicles[classid].vehicles[i].enabled then
					found = true
					adlc3 = setBit(adlc3, currentRace.available_vehicles[classid].vehicles[i].adlc3)
				end
			end
		end
		if found then
			clbs = setBit(clbs, classid)
		end
		table.insert(data.mission.race.adlc, adlc)
		table.insert(data.mission.race.adlc2, adlc2)
		table.insert(data.mission.race.adlc3, adlc3)
		table.insert(data.mission.race.aveh, aveh)
	end
	data.mission.race.clbs = clbs
	for i, fixture in ipairs(currentRace.fixtures) do
		data.mission.dhprop.no = data.mission.dhprop.no + 1
		table.insert(data.mission.dhprop.mn, fixture.hash)
		table.insert(data.mission.dhprop.pos, {
			x = fixture.x,
			y = fixture.y,
			z = fixture.z
		})
	end
	local tf_veh = {}
	for i, model in ipairs(currentRace.transformVehicles) do
		table.insert(tf_veh, tonumber(model) or GetHashKey(model))
	end
	data.mission.race.trfmvm = tf_veh
	for i, object in ipairs(currentRace.objects) do
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
	for i, checkpoint in ipairs(currentRace.checkpoints) do
		data.mission.race.chp = data.mission.race.chp + 1
		local checkpoint_2 = currentRace.checkpoints_2[i]
		table.insert(data.mission.race.chl, {
			x = checkpoint.x,
			y = checkpoint.y,
			z = checkpoint.z
		})
		table.insert(data.mission.race.chh, checkpoint.heading)
		table.insert(data.mission.race.chs, checkpoint.d_collect)
		table.insert(data.mission.race.chpp, checkpoint.pitch)
		table.insert(data.mission.race.cpado, checkpoint.offset)
		table.insert(data.mission.race.chstR, checkpoint.tall_range)
		table.insert(data.mission.race.cptfrm, (checkpoint.is_random and -2) or (checkpoint.is_transform and checkpoint.transform_index) or -1)
		table.insert(data.mission.race.cptrtt, checkpoint.is_random and checkpoint.randomClass or 0)
		table.insert(data.mission.race.sndchk, {
			x = checkpoint_2 and checkpoint_2.x or 0.0,
			y = checkpoint_2 and checkpoint_2.y or 0.0,
			z = checkpoint_2 and checkpoint_2.z or 0.0
		})
		table.insert(data.mission.race.sndrsp, checkpoint_2 and checkpoint_2.heading or 0.0)
		table.insert(data.mission.race.chs2, checkpoint_2 and checkpoint_2.d_collect or 1.0)
		table.insert(data.mission.race.chpps, checkpoint_2 and checkpoint_2.pitch or 0.0)
		table.insert(data.mission.race.cpados, checkpoint_2 and checkpoint_2.offset or {x = 0.0, y = 0.0, z = 0.0})
		table.insert(data.mission.race.chstRs, checkpoint_2 and checkpoint_2.tall_range or 500.0)
		table.insert(data.mission.race.cptfrms, checkpoint_2 and ((checkpoint_2.is_random and -2) or (checkpoint_2.is_transform and checkpoint_2.transform_index)) or -1)
		table.insert(data.mission.race.cptrtts, checkpoint_2 and (checkpoint_2.is_random and checkpoint_2.randomClass) or 0)
		table.insert(data.mission.race.chvs, checkpoint.d_draw)
		local cpbs1 = 1
		if checkpoint.is_round then
			cpbs1 = setBit(cpbs1, 1)
		end
		if checkpoint.is_restricted then
			cpbs1 = setBit(cpbs1, 5)
		end
		if checkpoint.is_air then
			cpbs1 = setBit(cpbs1, 9)
		end
		if checkpoint.is_fake then
			cpbs1 = setBit(cpbs1, 10)
		end
		if checkpoint.lock_dir then
			cpbs1 = setBit(cpbs1, 16)
			cpbs1 = setBit(cpbs1, 18)
		end
		if checkpoint.is_warp then
			cpbs1 = setBit(cpbs1, 27)
		end
		if checkpoint_2 and checkpoint_2.is_round then
			cpbs1 = setBit(cpbs1, 2)
		end
		if checkpoint_2 and checkpoint_2.is_air then
			cpbs1 = setBit(cpbs1, 13)
		end
		if checkpoint_2 and checkpoint_2.is_fake then
			cpbs1 = setBit(cpbs1, 11)
		end
		if checkpoint_2 and checkpoint_2.lock_dir then
			cpbs1 = setBit(cpbs1, 17)
			cpbs1 = setBit(cpbs1, 19)
		end
		if checkpoint_2 and checkpoint_2.is_warp then
			cpbs1 = setBit(cpbs1, 28)
		end
		table.insert(data.mission.race.cpbs1, cpbs1)
		local cpbs2 = 0
		if checkpoint.is_pit then
			cpbs2 = setBit(cpbs2, 16)
		end
		if checkpoint.is_lower then
			cpbs2 = setBit(cpbs2, 18)
		end
		if checkpoint.is_tall then
			cpbs2 = setBit(cpbs2, 20)
		end
		if checkpoint.low_alpha then
			cpbs2 = setBit(cpbs2, 24)
		end
		if checkpoint_2 and checkpoint_2.is_restricted then
			cpbs2 = setBit(cpbs2, 15)
		end
		if checkpoint_2 and checkpoint_2.is_pit then
			cpbs2 = setBit(cpbs2, 17)
		end
		if checkpoint_2 and checkpoint_2.is_lower then
			cpbs2 = setBit(cpbs2, 19)
		end
		if checkpoint_2 and checkpoint_2.is_tall then
			cpbs2 = setBit(cpbs2, 21)
		end
		if checkpoint_2 and checkpoint_2.low_alpha then
			cpbs2 = setBit(cpbs2, 25)
		end
		table.insert(data.mission.race.cpbs2, cpbs2)
		table.insert(data.mission.race.cpbs3, 0)
		local cppsst = 0
		if checkpoint.is_planeRot then
			cppsst = setBit(cppsst, checkpoint.plane_rot)
		end
		if checkpoint_2 and checkpoint_2.is_planeRot then
			cppsst = setBit(cppsst, checkpoint_2.plane_rot + 4)
		end
		table.insert(data.mission.race.cppsst, cppsst)
	end
	for i, grid in ipairs(currentRace.startingGrid) do
		data.mission.veh.no = data.mission.veh.no + 1
		table.insert(data.mission.veh.loc, {
			x = grid.x,
			y = grid.y,
			z = grid.z
		})
		table.insert(data.mission.veh.head, grid.heading)
	end
	return data
end