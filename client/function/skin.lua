function Client.Function.Skin.Editing()
	CreateThread(function()
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		Client.Skin.Camera.RotationAngle = GetEntityHeading(ped) + 90.0
		Client.Skin.Camera.Handle = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 60.0, true, 2)
		SetCamActive(Client.Skin.Camera.Handle, true)
		RenderScriptCams(true, false, 0, true, true)
		while Client.IsSkinMenuVisible do
			ped = PlayerPedId()
			pos = GetEntityCoords(ped)
			SetIkTarget(ped, 1, ped, 12844, 0.0, 0.0, 0.0, 0, -1, -1)
			ForcePedMotionState(ped, `MotionState_None`, false, 1, true)
			FreezeEntityPosition(ped, true)
			if IsDisabledControlPressed(0, 205) then
				Client.Skin.Camera.RotationAngle = Client.Skin.Camera.RotationAngle - Client.Skin.Camera.RotationSpeed
			end
			if IsDisabledControlPressed(0, 206) then
				Client.Skin.Camera.RotationAngle = Client.Skin.Camera.RotationAngle + Client.Skin.Camera.RotationSpeed
			end
			SetCamCoord(Client.Skin.Camera.Handle, pos.x + (Client.Skin.Camera.ZoomOffset * math.cos(math.rad(Client.Skin.Camera.RotationAngle))), pos.y + (Client.Skin.Camera.ZoomOffset * math.sin(math.rad(Client.Skin.Camera.RotationAngle))), pos.z + Client.Skin.Camera.CamOffset)
			PointCamAtCoord(Client.Skin.Camera.Handle, pos.x + (Client.Skin.Camera.ZoomOffset * math.cos(math.rad(Client.Skin.Camera.RotationAngle + 180.0))), pos.y + (Client.Skin.Camera.ZoomOffset * math.sin(math.rad(Client.Skin.Camera.RotationAngle + 180.0))), pos.z + Client.Skin.Camera.CamOffset)
			Wait(0)
		end
		while Client.IsPedSpawning do Wait(0) end
		Client.Function.Skin.Set(Client.Skin.Saved.Data[Client.Skin.Saved.Index])
		while Client.IsPedSpawning do Wait(0) end
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(Client.Skin.Camera.Handle, false)
		FreezeEntityPosition(PlayerPedId(), false)
		SetGameplayCamRelativeHeading(0)
		Client.Skin.Camera.Handle = nil
		Client.Skin.Camera.ZoomOffset = 0.0
		Client.Skin.Camera.CamOffset = 0.0
		Client.Skin.Camera.RotationAngle = nil
	end)
end

function Client.Function.Skin.GetDataForMenu()
	local ped = PlayerPedId()
	local num = GetNumHairColors() or 0

	Client.Skin.Menu["sex"] = {
		List = {Client.Function.Translate.Get("skin-male"), Client.Function.Translate.Get("skin-female")},
		Index = GetEntityModel(ped) == `mp_m_freemode_01` and 0 or 1
	}

	Client.Skin.Menu["face"] = {List = {}, Index = 0}
	Client.Skin.Menu["face2"] = {List = {}, Index = 0}
	Client.Skin.Menu["faceMix"] = {List = {}, Index = 0}
	Client.Skin.Menu["skin"] = {List = {}, Index = 0}
	Client.Skin.Menu["skin2"] = {List = {}, Index = 0}
	Client.Skin.Menu["skinMix"] = {List = {}, Index = 0}
	for i = 0, 45 do
		Client.Skin.Menu["face"].List[#Client.Skin.Menu["face"].List + 1] = i + 1
		Client.Skin.Menu["face2"].List[#Client.Skin.Menu["face2"].List + 1] = i + 1
		Client.Skin.Menu["skin"].List[#Client.Skin.Menu["skin"].List + 1] = i + 1
		Client.Skin.Menu["skin2"].List[#Client.Skin.Menu["skin2"].List + 1] = i + 1
	end
	for i = 0, 10 do
		Client.Skin.Menu["faceMix"].List[#Client.Skin.Menu["faceMix"].List + 1] = (i * 10) .. "%"
		Client.Skin.Menu["skinMix"].List[#Client.Skin.Menu["skinMix"].List + 1] = (i * 10) .. "%"
	end
	local _unused1, face, face2, _unused2, skin, skin2, _unused3, faceMix, skinMix, _unused4 = false, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0
	if Client.IsGameEnhancedVersion then
		_unused1, face, face2, _unused2, skin, skin2, _unused3, faceMix, skinMix, _unused4 = Citizen.InvokeNative(0x2746BD9D88C5C5D0, ped, Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0))
	else
		face, face2, _unused2, skin, skin2, _unused3, faceMix, skinMix, _unused4 = Citizen.InvokeNative(0x2746BD9D88C5C5D0, ped, Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0))
	end
	Client.Skin.Menu["face"].Index = face and face >= 0 and face < #Client.Skin.Menu["face"].List and face or 0
	Client.Skin.Menu["face2"].Index = face2 and face2 >= 0 and face2 < #Client.Skin.Menu["face2"].List and face2 or 0
	Client.Skin.Menu["skin"].Index = skin and skin >= 0 and skin < #Client.Skin.Menu["skin"].List and skin or 0
	Client.Skin.Menu["skin2"].Index = skin2 and skin2 >= 0 and skin2 < #Client.Skin.Menu["skin2"].List and skin2 or 0
	Client.Skin.Menu["faceMix"].Index = math.floor(math.max(0.0, math.min(1.0, (faceMix or 0.0) + 0.05)) * 10)
	Client.Skin.Menu["skinMix"].Index = math.floor(math.max(0.0, math.min(1.0, (skinMix or 0.0) + 0.05)) * 10)

	for i = 0, 19 do
		Client.Skin.Menu["faceFeature_" .. i] = {List = {}, Index = 0}
		for j = 0, i >= 18 and 10 or 20 do
			Client.Skin.Menu["faceFeature_" .. i].List[#Client.Skin.Menu["faceFeature_" .. i].List + 1] = ((j - (i >= 18 and 0 or 10)) * 10) .. "%"
		end
		local value = GetPedFaceFeature(ped, i)
		Client.Skin.Menu["faceFeature_" .. i].Index = math.floor(math.max(i >= 18 and 0.0 or -1.0, math.min(1.0, (value or 0.0) + 0.05)) * 10) + (i >= 18 and 0 or 10)
	end

	for i = 1, #Client.Skin.Components do
		local component = Client.Skin.Components[i]
		if component.Id then
			Client.Skin.Menu[component.Item1] = {List = {}, Index = 0}
			for j = 0, GetNumberOfPedDrawableVariations(ped, component.Id) - 1 do
				Client.Skin.Menu[component.Item1].List[#Client.Skin.Menu[component.Item1].List + 1] = j + 1
			end
			local value = GetPedDrawableVariation(ped, component.Id)
			Client.Skin.Menu[component.Item1].Index = value and value >= 0 and value < #Client.Skin.Menu[component.Item1].List and value or 0

			Client.Skin.Menu[component.Item2] = {List = {}, Index = 0}
			for j = 0, GetNumberOfPedTextureVariations(ped, component.Id, Client.Skin.Menu[component.Item1].Index) - 1 do
				Client.Skin.Menu[component.Item2].List[#Client.Skin.Menu[component.Item2].List + 1] = j + 1
			end
			local value = GetPedTextureVariation(ped, component.Id)
			Client.Skin.Menu[component.Item2].Index = value and value >= 0 and value < #Client.Skin.Menu[component.Item2].List and value or 0
		else
			Client.Skin.Menu[component.Item1] = {List = {}, Index = 0}
			for j = 0, num - 1 do
				Client.Skin.Menu[component.Item1].List[#Client.Skin.Menu[component.Item1].List + 1] = j + 1
			end
			local value = GetPedHairColor(ped)
			Client.Skin.Menu[component.Item1].Index = value and value >= 0 and value < #Client.Skin.Menu[component.Item1].List and value or 0

			Client.Skin.Menu[component.Item2] = {List = {}, Index = 0}
			for j = 0, num - 1 do
				Client.Skin.Menu[component.Item2].List[#Client.Skin.Menu[component.Item2].List + 1] = j + 1
			end
			local value = GetPedHairHighlightColor(ped)
			Client.Skin.Menu[component.Item2].Index = value and value >= 0 and value < #Client.Skin.Menu[component.Item2].List and value or 0
		end
	end

	for i = 1, #Client.Skin.Props do
		local prop = Client.Skin.Props[i]
		Client.Skin.Menu[prop.Item1] = {List = {1}, Index = -1}
		for j = 0, GetNumberOfPedPropDrawableVariations(ped, prop.Id) - 1 do
			Client.Skin.Menu[prop.Item1].List[#Client.Skin.Menu[prop.Item1].List + 1] = j + 2
		end
		local value = GetPedPropIndex(ped, prop.Id)
		Client.Skin.Menu[prop.Item1].Index = value and value + 1 >= 0 and value + 1 < #Client.Skin.Menu[prop.Item1].List and value or -1

		Client.Skin.Menu[prop.Item2] = {List = {}, Index = 0}
		for j = 0, GetNumberOfPedPropTextureVariations(ped, prop.Id, Client.Skin.Menu[prop.Item1].Index) - 1 do
			Client.Skin.Menu[prop.Item2].List[#Client.Skin.Menu[prop.Item2].List + 1] = j + 1
		end
		local value = GetPedPropTextureIndex(ped, prop.Id)
		Client.Skin.Menu[prop.Item2].Index = value and value >= 0 and value < #Client.Skin.Menu[prop.Item2].List and value or 0
	end

	for i = 1, #Client.Skin.Overlays do
		local overlay = Client.Skin.Overlays[i]
		if overlay.Id then
			Client.Skin.Menu[overlay.Item1] = {List = {}, Index = 0}
			for j = 0, GetNumHeadOverlayValues(overlay.Id) - 1 do
				Client.Skin.Menu[overlay.Item1].List[#Client.Skin.Menu[overlay.Item1].List + 1] = j + 1
			end
			local value = GetPedHeadOverlayValue(ped, overlay.Id)
			Client.Skin.Menu[overlay.Item1].Index = value and value >= 0 and value < #Client.Skin.Menu[overlay.Item1].List and value or 0

			Client.Skin.Menu[overlay.Item2] = {List = {}, Index = 0}
			for j = 0, 10 do
				Client.Skin.Menu[overlay.Item2].List[#Client.Skin.Menu[overlay.Item2].List + 1] = (j * 10) .. "%"
			end
			local success, _, _, color1, color2, opacity = GetPedHeadOverlayData(ped, overlay.Id)
			Client.Skin.Menu[overlay.Item2].Index = math.floor(math.max(0.0, math.min(1.0, (success and opacity or 0.0) + 0.05)) * 10)

			if overlay.Color1 then
				Client.Skin.Menu[overlay.Color1] = {List = {}, Index = 0}
				for j = 0, num - 1 do
					Client.Skin.Menu[overlay.Color1].List[#Client.Skin.Menu[overlay.Color1].List + 1] = j + 1
				end
				Client.Skin.Menu[overlay.Color1].Index = success and color1 and color1 >= 0 and color1 < #Client.Skin.Menu[overlay.Color1].List and color1 or 0
			end

			if overlay.Color2 then
				Client.Skin.Menu[overlay.Color2] = {List = {}, Index = 0}
				for j = 0, num - 1 do
					Client.Skin.Menu[overlay.Color2].List[#Client.Skin.Menu[overlay.Color2].List + 1] = j + 1
				end
				Client.Skin.Menu[overlay.Color2].Index = success and color2 and color2 >= 0 and color2 < #Client.Skin.Menu[overlay.Color2].List and color2 or 0
			end
		else
			Client.Skin.Menu[overlay.Item1] = {List = {}, Index = 0}
			for j = 0, 32 - 1 do
				Client.Skin.Menu[overlay.Item1].List[#Client.Skin.Menu[overlay.Item1].List + 1] = j + 1
			end
			local value = GetPedEyeColor(ped)
			Client.Skin.Menu[overlay.Item1].Index = value and value >= 0 and value < #Client.Skin.Menu[overlay.Item1].List and value or 0
		end
	end
end

function Client.Function.Skin.SetHeadBlend(ped, face, face2, faceMix, skin, skin2, skinMix)
	face = math.max(0, math.min(45, face))
	face2 = math.max(0, math.min(45, face2))
	faceMix = math.max(0.0, math.min(1.0, faceMix))
	skin = math.max(0, math.min(45, skin))
	skin2 = math.max(0, math.min(45, skin2))
	skinMix = math.max(0.0, math.min(1.0, skinMix))
	SetPedHeadBlendData(ped, face, face2, nil, skin, skin2, nil, faceMix, skinMix, nil, true)
end

function Client.Function.Skin.SetFaceFeature(ped, index, scale)
	scale = math.max(index >= 18 and 0.0 or -1.0, math.min(1.0, scale))
	SetPedFaceFeature(ped, index, scale)
end

function Client.Function.Skin.SetComponent(ped, componentId, drawableId, textureId, paletteId)
	if not IsPedComponentVariationValid(ped, componentId, drawableId, textureId) then
		textureId = 0
	end
	if not IsPedComponentVariationValid(ped, componentId, drawableId, textureId) then
		drawableId = 0
	end
	SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
end

function Client.Function.Skin.SetProp(ped, propId, drawableId, textureId)
	if drawableId == -1 then
		ClearPedProp(ped, propId)
	else
		local maxDrawableVariations = GetNumberOfPedPropDrawableVariations(ped, propId)
		drawableId = drawableId >= 0 and drawableId < maxDrawableVariations and drawableId or 0
		local maxTextureVariations = GetNumberOfPedPropTextureVariations(ped, propId, drawableId)
		textureId = textureId >= 0 and textureId < maxTextureVariations and textureId or 0
		SetPedPropIndex(ped, propId, drawableId, textureId, true)
	end
end

function Client.Function.Skin.SetHeadOverlay(ped, overlayId, value, opacity)
	value = value >= 0 and value < GetNumHeadOverlayValues(overlayId) and value or 0
	opacity = math.max(0.0, math.min(1.0, opacity))
	SetPedHeadOverlay(ped, overlayId, value, opacity)
end

function Client.Function.Skin.SetHeadOverlayColor(ped, overlayId, colorType, colorId, colorId2)
	local maxColors = GetNumHairColors()
	colorId = colorId >= 0 and colorId < maxColors and colorId or 0
	colorId2 = colorId2 >= 0 and colorId2 < maxColors and colorId2 or 0
	SetPedHeadOverlayColor(ped, overlayId, colorType, colorId, colorId2)
end

function Client.Function.Skin.SetHairColor(ped, colorId, highlightColorId)
	local maxColors = GetNumHairColors()
	colorId = colorId >= 0 and colorId < maxColors and colorId or 0
	highlightColorId = highlightColorId >= 0 and highlightColorId < maxColors and highlightColorId or 0
	SetPedHairColor(ped, colorId, highlightColorId)
end

function Client.Function.Skin.SetEyeColor(ped, colorId)
	colorId = colorId >= 0 and colorId < 32 and colorId or 0
	SetPedEyeColor(ped, colorId)
end

function Client.Function.Skin.Set(skinData, refreshMenu)
	Client.IsPedSpawning = true
	CreateThread(function()
		local data = {}
		if skinData then
			for k, v in pairs(skinData) do
				if k == "tattoo" then
					data["tattoo"] = v
				else
					data[k] = type(v) == "number" and v or nil
				end
			end
		end
		data["sex"] = data["sex"] or 0
		local model = data["sex"] == 0 and `mp_m_freemode_01` or `mp_f_freemode_01`
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(0) end
		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
		local ped = PlayerPedId()
		Client.Function.Skin.SetHeadBlend(ped, data["face"] or (data["sex"] == 0 and 0 or 21), data["face2"] or 0, (data["faceMix"] or 0) / 10.0, data["skin"] or 0, data["skin2"] or 0, (data["skinMix"] or 0) / 10.0)
		for i = 0, 19 do
			Client.Function.Skin.SetFaceFeature(ped, i, ((data["faceFeature_" .. i] or (i >= 18 and 0 or 10)) - (i >= 18 and 0 or 10)) / 10.0)
		end
		Client.Function.Skin.SetComponent(ped, 2, data["hair_1"] or (data["sex"] == 0 and 0 or 3), data["hair_2"] or 0, 2)
		Client.Function.Skin.SetHairColor(ped, data["hair_color_1"] or 0, data["hair_color_2"] or 0)
		Client.Function.Skin.SetComponent(ped, 8, data["tshirt_1"] or (data["sex"] == 0 and 15 or 14), data["tshirt_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 11, data["torso_1"] or 15, data["torso_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 10, data["decals_1"] or 0, data["decals_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 3, data["arms"] or 15, data["arms_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 4, data["pants_1"] or (data["sex"] == 0 and 14 or 15), data["pants_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 6, data["shoes_1"] or 16, data["shoes_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 1, data["mask_1"] or 0, data["mask_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 9, data["bproof_1"] or 0, data["bproof_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 7, data["chain_1"] or 0, data["chain_2"] or 0, 2)
		Client.Function.Skin.SetComponent(ped, 5, data["bags_1"] or 0, data["bags_2"] or 0, 2)
		Client.Function.Skin.SetProp(ped, 0, data["helmet_1"] or -1, data["helmet_2"] or 0)
		Client.Function.Skin.SetProp(ped, 1, data["glasses_1"] or -1, data["glasses_2"] or 0)
		Client.Function.Skin.SetProp(ped, 6, data["watches_1"] or -1, data["watches_2"] or 0)
		Client.Function.Skin.SetProp(ped, 7, data["bracelets_1"] or -1, data["bracelets_2"] or 0)
		Client.Function.Skin.SetProp(ped, 2, data["ears_1"] or -1, data["ears_2"] or 0)
		Client.Function.Skin.SetEyeColor(ped, data["eye_color"] or 0)
		Client.Function.Skin.SetHeadOverlay(ped, 2, data["eyebrows_1"] or 0, (data["eyebrows_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlayColor(ped, 2, 1, data["eyebrows_3"] or 0, data["eyebrows_4"] or 0)
		Client.Function.Skin.SetHeadOverlay(ped, 4, data["makeup_1"] or 0, (data["makeup_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlayColor(ped, 4, 1, data["makeup_3"] or 0, data["makeup_4"] or 0)
		Client.Function.Skin.SetHeadOverlay(ped, 8, data["lipstick_1"] or 0, (data["lipstick_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlayColor(ped, 8, 1, data["lipstick_3"] or 0, data["lipstick_4"] or 0)
		Client.Function.Skin.SetHeadOverlay(ped, 10, data["chest_1"] or 0, (data["chest_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlayColor(ped, 10, 1, data["chest_3"] or 0, 0)
		Client.Function.Skin.SetHeadOverlay(ped, 11, data["bodyb_1"] or 0, (data["bodyb_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlay(ped, 3, data["age_1"] or 0, (data["age_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlay(ped, 0, data["blemishes_1"] or 0, (data["blemishes_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlay(ped, 5, data["blush_1"] or 0, (data["blush_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlayColor(ped, 5, 1, data["blush_3"] or 0, 0)
		Client.Function.Skin.SetHeadOverlay(ped, 6, data["complexion_1"] or 0, (data["complexion_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlay(ped, 7, data["sun_1"] or 0, (data["sun_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlay(ped, 9, data["moles_1"] or 0, (data["moles_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlay(ped, 1, data["beard_1"] or 0, (data["beard_2"] or 0) / 10.0)
		Client.Function.Skin.SetHeadOverlayColor(ped, 1, 1, data["beard_3"] or 0, data["beard_4"] or 0)
		Client.Function.Tattoo.Current(ped, data["tattoo"] or {}, data["sex"] == 0, data["sex"] == 1)
		if refreshMenu then
			Client.Function.Skin.GetDataForMenu()
		else
			if Client.Permission.Weapon and Client.Preference.WeaponLoaded then
				Client.Function.Weapon.RemoveAll(PlayerPedId())
				Client.Function.Weapon.LoadSaved(PlayerPedId())
			end
		end
		Client.IsPedSpawning = false
	end)
end

function Client.Function.Skin.GetCurrent()
	local data = {}
	data["sex"] = Client.Skin.Menu["sex"].Index
	data["face"] = Client.Skin.Menu["face"].Index
	data["face2"] = Client.Skin.Menu["face2"].Index
	data["faceMix"] = Client.Skin.Menu["faceMix"].Index
	data["skin"] = Client.Skin.Menu["skin"].Index
	data["skin2"] = Client.Skin.Menu["skin2"].Index
	data["skinMix"] = Client.Skin.Menu["skinMix"].Index
	for i = 0, 19 do
		data["faceFeature_" .. i] = Client.Skin.Menu["faceFeature_" .. i].Index
	end
	data["hair_1"] = Client.Skin.Menu["hair_1"].Index
	data["hair_2"] = Client.Skin.Menu["hair_2"].Index
	data["hair_color_1"] = Client.Skin.Menu["hair_color_1"].Index
	data["hair_color_2"] = Client.Skin.Menu["hair_color_2"].Index
	data["tshirt_1"] = Client.Skin.Menu["tshirt_1"].Index
	data["tshirt_2"] = Client.Skin.Menu["tshirt_2"].Index
	data["torso_1"] = Client.Skin.Menu["torso_1"].Index
	data["torso_2"] = Client.Skin.Menu["torso_2"].Index
	data["decals_1"] = Client.Skin.Menu["decals_1"].Index
	data["decals_2"] = Client.Skin.Menu["decals_2"].Index
	data["arms"] = Client.Skin.Menu["arms"].Index
	data["arms_2"] = Client.Skin.Menu["arms_2"].Index
	data["pants_1"] = Client.Skin.Menu["pants_1"].Index
	data["pants_2"] = Client.Skin.Menu["pants_2"].Index
	data["shoes_1"] = Client.Skin.Menu["shoes_1"].Index
	data["shoes_2"] = Client.Skin.Menu["shoes_2"].Index
	data["mask_1"] = Client.Skin.Menu["mask_1"].Index
	data["mask_2"] = Client.Skin.Menu["mask_2"].Index
	data["bproof_1"] = Client.Skin.Menu["bproof_1"].Index
	data["bproof_2"] = Client.Skin.Menu["bproof_2"].Index
	data["chain_1"] = Client.Skin.Menu["chain_1"].Index
	data["chain_2"] = Client.Skin.Menu["chain_2"].Index
	data["bags_1"] = Client.Skin.Menu["bags_1"].Index
	data["bags_2"] = Client.Skin.Menu["bags_2"].Index
	data["helmet_1"] = Client.Skin.Menu["helmet_1"].Index
	data["helmet_2"] = Client.Skin.Menu["helmet_2"].Index
	data["glasses_1"] = Client.Skin.Menu["glasses_1"].Index
	data["glasses_2"] = Client.Skin.Menu["glasses_2"].Index
	data["watches_1"] = Client.Skin.Menu["watches_1"].Index
	data["watches_2"] = Client.Skin.Menu["watches_2"].Index
	data["bracelets_1"] = Client.Skin.Menu["bracelets_1"].Index
	data["bracelets_2"] = Client.Skin.Menu["bracelets_2"].Index
	data["ears_1"] = Client.Skin.Menu["ears_1"].Index
	data["ears_2"] = Client.Skin.Menu["ears_2"].Index
	data["eye_color"] = Client.Skin.Menu["eye_color"].Index
	data["eyebrows_1"] = Client.Skin.Menu["eyebrows_1"].Index
	data["eyebrows_2"] = Client.Skin.Menu["eyebrows_2"].Index
	data["eyebrows_3"] = Client.Skin.Menu["eyebrows_3"].Index
	data["eyebrows_4"] = Client.Skin.Menu["eyebrows_4"].Index
	data["makeup_1"] = Client.Skin.Menu["makeup_1"].Index
	data["makeup_2"] = Client.Skin.Menu["makeup_2"].Index
	data["makeup_3"] = Client.Skin.Menu["makeup_3"].Index
	data["makeup_4"] = Client.Skin.Menu["makeup_4"].Index
	data["lipstick_1"] = Client.Skin.Menu["lipstick_1"].Index
	data["lipstick_2"] = Client.Skin.Menu["lipstick_2"].Index
	data["lipstick_3"] = Client.Skin.Menu["lipstick_3"].Index
	data["lipstick_4"] = Client.Skin.Menu["lipstick_4"].Index
	data["chest_1"] = Client.Skin.Menu["chest_1"].Index
	data["chest_2"] = Client.Skin.Menu["chest_2"].Index
	data["chest_3"] = Client.Skin.Menu["chest_3"].Index
	data["bodyb_1"] = Client.Skin.Menu["bodyb_1"].Index
	data["bodyb_2"] = Client.Skin.Menu["bodyb_2"].Index
	data["age_1"] = Client.Skin.Menu["age_1"].Index
	data["age_2"] = Client.Skin.Menu["age_2"].Index
	data["blemishes_1"] = Client.Skin.Menu["blemishes_1"].Index
	data["blemishes_2"] = Client.Skin.Menu["blemishes_2"].Index
	data["blush_1"] = Client.Skin.Menu["blush_1"].Index
	data["blush_2"] = Client.Skin.Menu["blush_2"].Index
	data["blush_3"] = Client.Skin.Menu["blush_3"].Index
	data["complexion_1"] = Client.Skin.Menu["complexion_1"].Index
	data["complexion_2"] = Client.Skin.Menu["complexion_2"].Index
	data["sun_1"] = Client.Skin.Menu["sun_1"].Index
	data["sun_2"] = Client.Skin.Menu["sun_2"].Index
	data["moles_1"] = Client.Skin.Menu["moles_1"].Index
	data["moles_2"] = Client.Skin.Menu["moles_2"].Index
	data["beard_1"] = Client.Skin.Menu["beard_1"].Index
	data["beard_2"] = Client.Skin.Menu["beard_2"].Index
	data["beard_3"] = Client.Skin.Menu["beard_3"].Index
	data["beard_4"] = Client.Skin.Menu["beard_4"].Index
	data["tattoo"] = Client.Skin.Tattoo.Current
	return data
end

function Client.Function.Skin.GetRandomFace(random)
	local ped = PlayerPedId()
	local data = Client.Function.Skin.GetCurrent()
	if random then
		data["face"] = math.random(46) - 1
		data["face2"] = math.random(46) - 1
		data["faceMix"] = math.random(11) - 1
		data["skin"] = math.random(46) - 1
		data["skin2"] = math.random(46) - 1
		data["skinMix"] = math.random(11) - 1
		for i = 0, 19 do
			data["faceFeature_" .. i] = math.random(i >= 18 and 11 or 21) - 1
		end
	else
		data["face"] = nil
		data["face2"] = nil
		data["faceMix"] = nil
		data["skin"] = nil
		data["skin2"] = nil
		data["skinMix"] = nil
		for i = 0, 19 do
			data["faceFeature_" .. i] = nil
		end
	end
	return data
end

function Client.Function.Skin.GetRandomComponent(random)
	local ped = PlayerPedId()
	local data = Client.Function.Skin.GetCurrent()
	if random then
		local num = GetNumHairColors() or 0
		for i = 1, #Client.Skin.Components do
			local component = Client.Skin.Components[i]
			if component.Id then
				data[component.Item1] = GetNumberOfPedDrawableVariations(ped, component.Id)
				data[component.Item1] = data[component.Item1] and data[component.Item1] > 0 and (math.random(data[component.Item1]) - 1) or 0
				data[component.Item2] = GetNumberOfPedTextureVariations(ped, component.Id, data[component.Item1])
				data[component.Item2] = data[component.Item2] and data[component.Item2] > 0 and (math.random(data[component.Item2]) - 1) or 0
			else
				data[component.Item1] = num > 0 and (math.random(num) - 1) or 0
				data[component.Item2] = num > 0 and (math.random(num) - 1) or 0
			end
		end
	else
		for i = 1, #Client.Skin.Components do
			local component = Client.Skin.Components[i]
			data[component.Item1] = nil
			data[component.Item2] = nil
		end
	end
	return data
end

function Client.Function.Skin.GetRandomProp(random)
	local ped = PlayerPedId()
	local data = Client.Function.Skin.GetCurrent()
	if random then
		for i = 1, #Client.Skin.Props do
			local prop = Client.Skin.Props[i]
			data[prop.Item1] = GetNumberOfPedPropDrawableVariations(ped, prop.Id)
			data[prop.Item1] = data[prop.Item1] and data[prop.Item1] > 0 and (math.random(data[prop.Item1] + 1) - 2) or -1
			data[prop.Item2] = data[prop.Item1] >= 0 and GetNumberOfPedPropTextureVariations(ped, prop.Id, data[prop.Item1]) or 0
			data[prop.Item2] = data[prop.Item2] and data[prop.Item2] > 0 and (math.random(data[prop.Item2]) - 1) or 0
		end
	else
		for i = 1, #Client.Skin.Props do
			local prop = Client.Skin.Props[i]
			data[prop.Item1] = nil
			data[prop.Item2] = nil
		end
	end
	return data
end

function Client.Function.Skin.GetRandomOverlay(random)
	local ped = PlayerPedId()
	local data = Client.Function.Skin.GetCurrent()
	if random then
		local num = GetNumHairColors() or 0
		for i = 1, #Client.Skin.Overlays do
			local overlay = Client.Skin.Overlays[i]
			if overlay.Id then
				data[overlay.Item1] = GetNumHeadOverlayValues(overlay.Id)
				data[overlay.Item1] = data[overlay.Item1] and data[overlay.Item1] > 0 and (math.random(data[overlay.Item1]) - 1) or 0
				data[overlay.Item2] = math.random(11) - 1
				if overlay.Color1 then
					data[overlay.Color1] = num > 0 and (math.random(num) - 1) or 0
				end
				if overlay.Color2 then
					data[overlay.Color2] = num > 0 and (math.random(num) - 1) or 0
				end
			else
				data[overlay.Item1] = math.random(32) - 1
			end
		end
	else
		for i = 1, #Client.Skin.Overlays do
			local overlay = Client.Skin.Overlays[i]
			data[overlay.Item1] = nil
			if overlay.Item2 then
				data[overlay.Item2] = nil
			end
			if overlay.Color1 then
				data[overlay.Color1] = nil
			end
			if overlay.Color2 then
				data[overlay.Color2] = nil
			end
		end
	end
	return data
end