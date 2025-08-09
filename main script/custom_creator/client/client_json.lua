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
			TriggerServerCallback('custom_creator:server:check_title', function(bool)
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
			local cpbs1 = data.mission.race.cpbs1 and data.mission.race.cpbs1[i] or nil
			local cppsst = data.mission.race.cppsst and data.mission.race.cppsst[i] or nil
			local is_random_temp = data.mission.race.cptfrm and data.mission.race.cptfrm[i] == -2 and true
			local is_transform_temp = not is_random_temp and (data.mission.race.cptfrm and data.mission.race.cptfrm[i] >= 0 and true)
			currentRace.checkpoints[i] = {
				index = i,
				x = RoundedValue(data.mission.race.chl[i].x, 3),
				y = RoundedValue(data.mission.race.chl[i].y, 3),
				z = RoundedValue(data.mission.race.chl[i].z, 3),
				heading = RoundedValue(data.mission.race.chh[i], 3),
				d = RoundedValue(data.mission.race.chs and data.mission.race.chs[i] or 1.0, 3),
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
			if data.mission.race.sndchk then
				if not (data.mission.race.sndchk[i].x == 0.0 and data.mission.race.sndchk[i].y == 0.0 and data.mission.race.sndchk[i].z == 0.0) then
					local is_random_temp = data.mission.race.cptfrms and data.mission.race.cptfrms[i] == -2 and true
					local is_transform_temp = not is_random_temp and (data.mission.race.cptfrms and data.mission.race.cptfrms[i] >= 0 and true)
					currentRace.checkpoints_2[i] = {
						index = i,
						x = RoundedValue(data.mission.race.sndchk[i].x, 3),
						y = RoundedValue(data.mission.race.sndchk[i].y, 3),
						z = RoundedValue(data.mission.race.sndchk[i].z, 3),
						heading = RoundedValue(data.mission.race.sndrsp[i], 3),
						d = RoundedValue(data.mission.race.chs2 and data.mission.race.chs2[i] or currentRace.checkpoints[i].d, 3),
						is_round = cpbs1 and isBitSet(cpbs1, 2),
						is_air = cpbs1 and isBitSet(cpbs1, 13),
						is_fake = cpbs1 and isBitSet(cpbs1, 11),
						is_random = is_random_temp,
						randomClass = is_random_temp and data.mission.race.cptrtts and data.mission.race.cptrtts[i] or 0,
						is_transform = is_transform_temp,
						transform_index = is_transform_temp and data.mission.race.cptfrms and data.mission.race.cptfrms[i] or 0,
						is_planeRot = nil,
						plane_rot = nil,
						is_warp = cpbs1 and isBitSet(cpbs1, 28)
					}
					if currentRace.checkpoints_2[i].is_random or currentRace.checkpoints_2[i].is_transform or currentRace.checkpoints_2[i].is_planeRot or currentRace.checkpoints_2[i].is_warp then
						currentRace.checkpoints_2[i].is_round = true
					end
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
		local _visible = not data.mission.prop.pLODDist or (data.mission.prop.pLODDist and (data.mission.prop.pLODDist[i] ~= 1))
		local _collision = not data.mission.prop.collision or (data.mission.prop.collision and (data.mission.prop.collision[i] == 1))
		local _handle = createProp(_hash, _x, _y, _z, _rotX, _rotY, _rotZ, _color)
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
		local _collision = not data.mission.dprop.collision or (data.mission.dprop.collision and (data.mission.dprop.collision[i] == 1))
		local _handle = createProp(_hash, _x, _y, _z, _rotX, _rotY, _rotZ, _color)
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
		cameraPosition = vector3(currentRace.startingGrid[1].x + (20 - min.z) * math.sin(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].y - (20 - min.z) * math.cos(math.rad(currentRace.startingGrid[1].heading)), currentRace.startingGrid[1].z + (20 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.startingGrid[1].heading}
	elseif currentRace.objects[1] then
		local min, max = GetModelDimensions(tonumber(currentRace.objects[1].hash) or GetHashKey(currentRace.objects[1].hash))
		cameraPosition = vector3(currentRace.objects[1].x + (20 - min.z) * math.sin(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].y - (20 - min.z) * math.cos(math.rad(currentRace.objects[1].rotZ)), currentRace.objects[1].z + (20 - min.z))
		cameraRotation = {x = -45.0, y = 0.0, z = currentRace.objects[1].rotZ}
	end
end

function convertRaceToUGC(currentRace)
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
				cptfrm = {},
				cptrtt = {},
				cppsst = {},
				-- Secondary
				sndchk = {},
				sndrsp = {},
				chs2 = {},
				cptfrms = {},
				cptrtts = {},
				-- Other Settings
				cpbs1 = {},
				trfmvm = {},
				chp = 0
			},
			veh = {
				loc = {},
				head = {},
				no = 0
			}
		}
	}
	for i = 1, #currentRace.fixtures do
		data.mission.dhprop.no = data.mission.dhprop.no + 1
		table.insert(data.mission.dhprop.mn, currentRace.fixtures[i].hash)
		table.insert(data.mission.dhprop.pos, {
			x = currentRace.fixtures[i].x,
			y = currentRace.fixtures[i].y,
			z = currentRace.fixtures[i].z
		})
	end
	local tf_veh = {}
	for i = 1, #currentRace.transformVehicles do
		table.insert(tf_veh, tonumber(currentRace.transformVehicles[i]) or GetHashKey(currentRace.transformVehicles[i]))
	end
	data.mission.race.trfmvm = tf_veh
	for i = 1, #currentRace.objects do
		if currentRace.objects[i].dynamic then
			data.mission.dprop.no = data.mission.dprop.no + 1
			table.insert(data.mission.dprop.model, currentRace.objects[i].hash)
			table.insert(data.mission.dprop.loc, {
				x = currentRace.objects[i].x,
				y = currentRace.objects[i].y,
				z = currentRace.objects[i].z
			})
			table.insert(data.mission.dprop.vRot, {
				x = currentRace.objects[i].rotX,
				y = currentRace.objects[i].rotY,
				z = currentRace.objects[i].rotZ
			})
			table.insert(data.mission.dprop.prpdclr, currentRace.objects[i].color)
			table.insert(data.mission.dprop.collision, currentRace.objects[i].collision and 1 or 0)
		else
			data.mission.prop.no = data.mission.prop.no + 1
			table.insert(data.mission.prop.model, currentRace.objects[i].hash)
			table.insert(data.mission.prop.loc, {
				x = currentRace.objects[i].x,
				y = currentRace.objects[i].y,
				z = currentRace.objects[i].z
			})
			table.insert(data.mission.prop.vRot, {
				x = currentRace.objects[i].rotX,
				y = currentRace.objects[i].rotY,
				z = currentRace.objects[i].rotZ
			})
			table.insert(data.mission.prop.prpclr, currentRace.objects[i].color)
			table.insert(data.mission.prop.pLODDist, currentRace.objects[i].visible and 16960 or 1)
			table.insert(data.mission.prop.collision, currentRace.objects[i].collision and 1 or 0)
		end
	end
	for i = 1, #currentRace.checkpoints do
		data.mission.race.chp = data.mission.race.chp + 1
		table.insert(data.mission.race.chl, {
			x = currentRace.checkpoints[i].x,
			y = currentRace.checkpoints[i].y,
			z = currentRace.checkpoints[i].z
		})
		table.insert(data.mission.race.chh, currentRace.checkpoints[i].heading)
		table.insert(data.mission.race.chs, currentRace.checkpoints[i].d)
		table.insert(data.mission.race.cptfrm, (currentRace.checkpoints[i].is_random and -2) or (currentRace.checkpoints[i].is_transform and currentRace.checkpoints[i].transform_index) or -1)
		table.insert(data.mission.race.cptrtt, currentRace.checkpoints[i].is_random and currentRace.checkpoints[i].randomClass or 0)
		table.insert(data.mission.race.cppsst, currentRace.checkpoints[i].is_planeRot and setBit(0, currentRace.checkpoints[i].plane_rot) or 0)
		table.insert(data.mission.race.sndchk, {
			x = currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].x or 0.0,
			y = currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].y or 0.0,
			z = currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].z or 0.0
		})
		table.insert(data.mission.race.sndrsp, currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].heading or 0.0)
		table.insert(data.mission.race.chs2, currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].d or 1.0)
		table.insert(data.mission.race.cptfrms, currentRace.checkpoints_2[i] and ((currentRace.checkpoints_2[i].is_random and -2) or (currentRace.checkpoints_2[i].is_transform and currentRace.checkpoints_2[i].transform_index)) or -1)
		table.insert(data.mission.race.cptrtts, currentRace.checkpoints_2[i] and (currentRace.checkpoints_2[i].is_random and currentRace.checkpoints_2[i].randomClass) or 0)
		local cpbs1 = 1
		if currentRace.checkpoints[i].is_round then
			cpbs1 = setBit(cpbs1, 1)
		end
		if currentRace.checkpoints[i].is_air then
			cpbs1 = setBit(cpbs1, 9)
		end
		if currentRace.checkpoints[i].is_fake then
			cpbs1 = setBit(cpbs1, 10)
		end
		if currentRace.checkpoints[i].is_warp then
			cpbs1 = setBit(cpbs1, 27)
		end
		if currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].is_round then
			cpbs1 = setBit(cpbs1, 2)
		end
		if currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].is_air then
			cpbs1 = setBit(cpbs1, 13)
		end
		if currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].is_fake then
			cpbs1 = setBit(cpbs1, 11)
		end
		if currentRace.checkpoints_2[i] and currentRace.checkpoints_2[i].is_warp then
			cpbs1 = setBit(cpbs1, 28)
		end
		table.insert(data.mission.race.cpbs1, cpbs1)
	end
	for i = 1, #currentRace.startingGrid do
		data.mission.veh.no = data.mission.veh.no + 1
		table.insert(data.mission.veh.loc, {
			x = currentRace.startingGrid[i].x,
			y = currentRace.startingGrid[i].y,
			z = currentRace.startingGrid[i].z
		})
		table.insert(data.mission.veh.head, currentRace.startingGrid[i].heading)
	end
	return data
end