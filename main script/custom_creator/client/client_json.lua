function convertJsonData(data)
	currentRace.raceid = data.raceid
	currentRace.published = data.published
	currentRace.thumbnail = data.thumbnail
	local isValid = false
	if data.test_vehicle and data.test_vehicle ~= "" then
		local hash = tonumber(data.test_vehicle) or GetHashKey(data.test_vehicle)
		if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
			isValid = true
		end
	end
	currentRace.test_vehicle = (isValid and data.test_vehicle) or (currentRace.test_vehicle ~= "" and currentRace.test_vehicle) or "bmx"
	local found = false
	if data.mission.race and data.mission.race.trfmvm then
		for k,v in pairs(data.mission.race.trfmvm) do
			if v ~= 0 then
				found = true
				break
			end
		end
	end
	currentRace.transformVehicles = found and data.mission.race.trfmvm or {0, -422877666, -731262150, "bmx", "xa21"}
	currentRace.owner_name = data.mission.gen.ownerid
	local title = data.mission.gen.nm:gsub("[\\/:\"*?<>|]", ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""):gsub("custom_files", ""):gsub("local_files", "")
	if strinCount(title) > 0 then
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
	currentRace.blimp_text = data.mission.gen.blmpmsg or ""
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
	if data.mission.veh and data.mission.veh.loc then
		for i = 1, #data.mission.veh.loc do
			table.insert(currentRace.startingGrid, {
				index = i,
				handle = nil,
				x = RoundedValue(data.mission.veh.loc[i].x, 3),
				y = RoundedValue(data.mission.veh.loc[i].y, 3),
				z = RoundedValue(data.mission.veh.loc[i].z, 3),
				heading = RoundedValue(data.mission.veh.head[i], 3)
			})
		end
	end
	startingGridVehicleIndex = #currentRace.startingGrid
	currentRace.checkpoints = {}
	currentRace.checkpoints_2 = {}
	if data.mission.race and data.mission.race.chp then
		for i = 1, data.mission.race.chp, 1 do
			local chl = data.mission.race.chl and data.mission.race.chl[i] or {}
			chl.x = chl.x or 0.0
			chl.y = chl.y or 0.0
			chl.z = chl.z or 0.0
			local chh = data.mission.race.chh and data.mission.race.chh[i] or 0.0
			local chs = data.mission.race.chs and data.mission.race.chs[i] or 1.0
			local chvs = data.mission.race.chvs and data.mission.race.chvs[i] or chs
			local chstR = data.mission.race.chstR and data.mission.race.chstR[i] or 500.0
			local cpado = data.mission.race.cpado and data.mission.race.cpado[i] or {}
			cpado.x = cpado.x or 0.0
			cpado.y = cpado.y or 0.0
			cpado.z = cpado.z or 0.0
			local chpp = data.mission.race.chpp and data.mission.race.chpp[i] or 0.0
			local cpbs1 = data.mission.race.cpbs1 and data.mission.race.cpbs1[i] or nil
			local cpbs2 = data.mission.race.cpbs2 and data.mission.race.cpbs2[i] or nil
			local cpbs3 = data.mission.race.cpbs3 and data.mission.race.cpbs3[i] or nil
			local cppsst = data.mission.race.cppsst and data.mission.race.cppsst[i] or nil
			local is_random_temp = data.mission.race.cptfrm and data.mission.race.cptfrm[i] == -2 and true
			local is_transform_temp = not is_random_temp and (data.mission.race.cptfrm and data.mission.race.cptfrm[i] >= 0 and true)
			currentRace.checkpoints[i] = {
				x = RoundedValue(chl.x, 3),
				y = RoundedValue(chl.y, 3),
				z = RoundedValue(chl.z, 3),
				heading = RoundedValue(chh, 3),
				d_collect = RoundedValue(chs >= 0.5 and chs or 1.0, 3),
				d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
				offset = cpado,
				pitch = chpp,
				lock_dir = cpbs1 and (isBitSet(cpbs1, 16) and not (cpado.x == 0.0 and cpado.y == 0.0 and cpado.z == 0.0)) or isBitSet(cpbs1, 18),
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
				randomClass = is_random_temp and data.mission.race.cptrtt and data.mission.race.cptrtt[i] or 0,
				is_transform = is_transform_temp,
				transform_index = is_transform_temp and data.mission.race.cptfrm and data.mission.race.cptfrm[i] or 0,
				is_planeRot = cppsst and ((isBitSet(cppsst, 0)) or (isBitSet(cppsst, 1)) or (isBitSet(cppsst, 2)) or (isBitSet(cppsst, 3))),
				plane_rot = cppsst and ((isBitSet(cppsst, 0) and 0) or (isBitSet(cppsst, 1) and 1) or (isBitSet(cppsst, 2) and 2) or (isBitSet(cppsst, 3) and 3)),
				is_warp = cpbs1 and isBitSet(cpbs1, 27)
			}
			if currentRace.checkpoints[i].is_random or currentRace.checkpoints[i].is_transform or currentRace.checkpoints[i].is_planeRot or currentRace.checkpoints[i].is_warp then
				currentRace.checkpoints[i].is_round = true
			end
			local sndchk = data.mission.race.sndchk and data.mission.race.sndchk[i] or {}
			sndchk.x = sndchk.x or 0.0
			sndchk.y = sndchk.y or 0.0
			sndchk.z = sndchk.z or 0.0
			if not (sndchk.x == 0.0 and sndchk.y == 0.0 and sndchk.z == 0.0) then
				local sndrsp = data.mission.race.sndrsp and data.mission.race.sndrsp[i] or 0.0
				local chs2 = data.mission.race.chs2 and data.mission.race.chs2[i] or chs
				local chstRs = data.mission.race.chstRs and data.mission.race.chstRs[i] or 500.0
				local cpados = data.mission.race.cpados and data.mission.race.cpados[i] or {}
				cpados.x = cpados.x or 0.0
				cpados.y = cpados.y or 0.0
				cpados.z = cpados.z or 0.0
				local chpps = data.mission.race.chpps and data.mission.race.chpps[i] or 0.0
				local is_random_temp_2 = data.mission.race.cptfrms and data.mission.race.cptfrms[i] == -2 and true
				local is_transform_temp_2 = not is_random_temp_2 and (data.mission.race.cptfrms and data.mission.race.cptfrms[i] >= 0 and true)
				currentRace.checkpoints_2[i] = {
					x = RoundedValue(sndchk.x, 3),
					y = RoundedValue(sndchk.y, 3),
					z = RoundedValue(sndchk.z, 3),
					heading = RoundedValue(sndrsp, 3),
					d_collect = RoundedValue(chs2 >= 0.5 and chs2 or 1.0, 3),
					d_draw = RoundedValue(chvs >= 0.5 and chvs or 1.0, 3),
					offset = cpados,
					pitch = chpps,
					lock_dir = cpbs1 and (isBitSet(cpbs1, 17) and not (cpados.x == 0.0 and cpados.y == 0.0 and cpados.z == 0.0)) or isBitSet(cpbs1, 19),
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
					randomClass = is_random_temp_2 and data.mission.race.cptrtts and data.mission.race.cptrtts[i] or 0,
					is_transform = is_transform_temp_2,
					transform_index = is_transform_temp_2 and data.mission.race.cptfrms and data.mission.race.cptfrms[i] or 0,
					is_planeRot = cppsst and ((isBitSet(cppsst, 4)) or (isBitSet(cppsst, 5)) or (isBitSet(cppsst, 6)) or (isBitSet(cppsst, 7))),
					plane_rot = cppsst and ((isBitSet(cppsst, 4) and 0) or (isBitSet(cppsst, 5) and 1) or (isBitSet(cppsst, 6) and 2) or (isBitSet(cppsst, 7) and 3)),
					is_warp = cpbs1 and isBitSet(cpbs1, 28)
				}
				if currentRace.checkpoints_2[i].is_random or currentRace.checkpoints_2[i].is_transform or currentRace.checkpoints_2[i].is_planeRot or currentRace.checkpoints_2[i].is_warp then
					currentRace.checkpoints_2[i].is_round = true
				end
			end
		end
	end
	checkpointIndex = #currentRace.checkpoints
	blips.checkpoints = {}
	blips.checkpoints_2 = {}
	for k, v in pairs(currentRace.checkpoints) do
		blips.checkpoints[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	for k, v in pairs(currentRace.checkpoints_2) do
		blips.checkpoints_2[k] = createBlip(v.x, v.y, v.z, 0.9, (v.is_random or v.is_transform) and 570 or 1, (v.is_random or v.is_transform) and 1 or 5)
	end
	currentRace.fixtures = {}
	if not data.mission.dhprop then
		data.mission.dhprop = {
			no = 0
		}
	end
	if not data.mission.dhprop.no then
		data.mission.dhprop.no = 0
	end
	local seen = {}
	for i = 1, data.mission.dhprop.no do
		if not seen[data.mission.dhprop.mn[i]] and IsModelInCdimage(data.mission.dhprop.mn[i]) and IsModelValid(data.mission.dhprop.mn[i]) then
			seen[data.mission.dhprop.mn[i]] = true
			local _index = #currentRace.fixtures + 1
			currentRace.fixtures[_index] = {
				hash = data.mission.dhprop.mn[i],
				handle = nil,
				x = data.mission.dhprop.pos[i].x,
				y = data.mission.dhprop.pos[i].y,
				z = data.mission.dhprop.pos[i].z
			}
		end
	end
	fixtureIndex = #currentRace.fixtures
	local invalidObjects = {}
	currentRace.objects = {}
	if not data.mission.prop then
		data.mission.prop = {
			no = 0
		}
	end
	if not data.mission.prop.no then
		data.mission.prop.no = 0
	end
	for i = 1, data.mission.prop.no do
		local _index = #currentRace.objects + 1
		local _hash = data.mission.prop.model[i]
		local _x = RoundedValue(data.mission.prop.loc[i].x, 3)
		local _y = RoundedValue(data.mission.prop.loc[i].y, 3)
		local _z = RoundedValue(data.mission.prop.loc[i].z, 3)
		local _rotX = RoundedValue(data.mission.prop.vRot[i].x, 3)
		local _rotY = RoundedValue(data.mission.prop.vRot[i].y, 3)
		local _rotZ = RoundedValue(data.mission.prop.vRot[i].z, 3)
		local _color = data.mission.prop.prpclr and data.mission.prop.prpclr[i] or 0
		local _prpsba = data.mission.prop.prpsba and data.mission.prop.prpsba[i] or 2
		local _visible = not (data.mission.prop.prpbs and isBitSet(data.mission.prop.prpbs[i], 9)) and (not data.mission.prop.pLODDist or (data.mission.prop.pLODDist and (data.mission.prop.pLODDist[i] ~= 1)))
		local _collision = not data.mission.prop.collision or (data.mission.prop.collision and (data.mission.prop.collision[i] == 1))
		local _handle = createProp(_hash, _x, _y, _z, _rotX, _rotY, _rotZ, _color, _prpsba)
		if _handle then
			if _visible then
				ResetEntityAlpha(_handle)
			end
			if not _collision then
				SetEntityCollision(_handle, false, false)
			end
			uniqueId = uniqueId + 1
			currentRace.objects[_index] = {
				uniqueId = myServerId .. "-" .. uniqueId,
				modificationCount = 0,
				index = _index,
				hash = _hash,
				handle = _handle,
				x = _x,
				y = _y,
				z = _z,
				rotX = _rotX,
				rotY = _rotY,
				rotZ = _rotZ,
				color = _color,
				prpsba = _prpsba,
				visible = _visible,
				collision = _collision,
				dynamic = false
			}
		else
			invalidObjects[_hash] = true
		end
	end
	if not data.mission.dprop then
		data.mission.dprop = {
			no = 0
		}
	end
	if not data.mission.dprop.no then
		data.mission.dprop.no = 0
	end
	for i = 1, data.mission.dprop.no do
		local _index = #currentRace.objects + 1
		local _hash = data.mission.dprop.model[i]
		local _x = RoundedValue(data.mission.dprop.loc[i].x, 3)
		local _y = RoundedValue(data.mission.dprop.loc[i].y, 3)
		local _z = RoundedValue(data.mission.dprop.loc[i].z, 3)
		local _rotX = RoundedValue(data.mission.dprop.vRot[i].x, 3)
		local _rotY = RoundedValue(data.mission.dprop.vRot[i].y, 3)
		local _rotZ = RoundedValue(data.mission.dprop.vRot[i].z, 3)
		local _color = data.mission.dprop.prpdclr and data.mission.dprop.prpdclr[i] or 0
		local _prpsba = 2
		local _collision = not data.mission.dprop.collision or (data.mission.dprop.collision and (data.mission.dprop.collision[i] == 1))
		local _handle = createProp(_hash, _x, _y, _z, _rotX, _rotY, _rotZ, _color, _prpsba)
		if _handle then
			ResetEntityAlpha(_handle)
			if not _collision then
				SetEntityCollision(_handle, false, false)
			end
			uniqueId = uniqueId + 1
			currentRace.objects[_index] = {
				uniqueId = myServerId .. "-" .. uniqueId,
				modificationCount = 0,
				index = _index,
				hash = _hash,
				handle = _handle,
				x = _x,
				y = _y,
				z = _z,
				rotX = _rotX,
				rotY = _rotY,
				rotZ = _rotZ,
				color = _color,
				prpsba = _prpsba,
				visible = true,
				collision = _collision,
				dynamic = true
			}
		else
			invalidObjects[_hash] = true
		end
	end
	for k, v in pairs(invalidObjects) do
		print("model (" .. k .. ") does not exist or is invalid!")
		DisplayCustomMsgs(string.format(GetTranslate("object-hash-null"), k))
	end
	if tableCount(invalidObjects) > 0 then
		print("Ask the server owner to stream invalid models")
		print("Tutorial: https://github.com/taoletsgo/custom_races/issues/9#issuecomment-2552734069")
		print("Or you can just ignore this message")
	end
	objectIndex = #currentRace.objects
	blips.objects = {}
	for k, v in pairs(currentRace.objects) do
		blips.objects[k] = createBlip(v.x, v.y, v.z, 0.60, 271, 50, v.handle)
	end
	if currentRace.startingGrid[1] then
		local min, max = GetModelDimensions(tonumber(currentRace.test_vehicle) or GetHashKey(currentRace.test_vehicle))
		cameraPosition = vector3(currentRace.startingGrid[1].x + (20.0 - min.z) * math.sin(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].y - (20.0 - min.z) * math.cos(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].z + (20.0 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.startingGrid[1].heading}
	elseif currentRace.objects[1] then
		local min, max = GetModelDimensions(tonumber(currentRace.objects[1].hash) or GetHashKey(currentRace.objects[1].hash))
		cameraPosition = vector3(currentRace.objects[1].x + (20.0 - min.z) * math.sin(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].y - (20.0 - min.z) * math.cos(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].z + (20.0 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.objects[1].rotZ}
	end
end

function convertRaceToUGC()
	local data = {
		raceid = currentRace.raceid,
		published = currentRace.published,
		thumbnail = currentRace.thumbnail,
		test_vehicle = currentRace.test_vehicle ~= "" and currentRace.test_vehicle or "bmx",
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
				blmpmsg = currentRace.blimp_text
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
				no = 0
			},
			race = {
				-- Primary
				chl = {},
				chh = {},
				chs = {},
				chstR = {},
				cptfrm = {},
				cptrtt = {},
				-- Secondary
				sndchk = {},
				sndrsp = {},
				chs2 = {},
				chstRs = {},
				cptfrms = {},
				cptrtts = {},
				-- Other Settings
				chvs = {},
				cpbs1 = {},
				cpbs2 = {},
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
		table.insert(data.mission.race.chstR, checkpoint.chstR)
		table.insert(data.mission.race.cptfrm, (checkpoint.is_random and -2) or (checkpoint.is_transform and checkpoint.transform_index) or -1)
		table.insert(data.mission.race.cptrtt, checkpoint.is_random and checkpoint.randomClass or 0)
		table.insert(data.mission.race.sndchk, {
			x = checkpoint_2 and checkpoint_2.x or 0.0,
			y = checkpoint_2 and checkpoint_2.y or 0.0,
			z = checkpoint_2 and checkpoint_2.z or 0.0
		})
		table.insert(data.mission.race.sndrsp, checkpoint_2 and checkpoint_2.heading or 0.0)
		table.insert(data.mission.race.chs2, checkpoint_2 and checkpoint_2.d_collect or 1.0)
		table.insert(data.mission.race.chstRs, checkpoint_2 and checkpoint_2.chstRs or 500.0)
		table.insert(data.mission.race.cptfrms, checkpoint_2 and ((checkpoint_2.is_random and -2) or (checkpoint_2.is_transform and checkpoint_2.transform_index)) or -1)
		table.insert(data.mission.race.cptrtts, checkpoint_2 and (checkpoint_2.is_random and checkpoint_2.randomClass) or 0)
		table.insert(data.mission.race.chvs, checkpoint.d_draw)
		local cpbs1 = 1
		if checkpoint.is_round then
			cpbs1 = setBit(cpbs1, 1)
		end
		if checkpoint.is_air then
			cpbs1 = setBit(cpbs1, 9)
		end
		if checkpoint.is_fake then
			cpbs1 = setBit(cpbs1, 10)
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
		if checkpoint_2 and checkpoint_2.is_warp then
			cpbs1 = setBit(cpbs1, 28)
		end
		if checkpoint.is_restricted then
			cpbs1 = setBit(cpbs1, 5)
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