local previewVehicle = 0
local previewCamera = 0
local categories = {}
local vehicleList = {
	["Favorite"] = {},
	["Personal"] = {}
}

RegisterNUICallback("getCategoryList", function(data, cb)
	local texts = {}
	local favoriteText = Client.Function.Translate.Get("Favorite")
	local personalText = Client.Function.Translate.Get("Personal")
	categories[favoriteText] = "Favorite"
	categories[personalText] = "Personal"
	for i = 0, 22 do
		local class = Client.Vehicle.Classes[i]
		if class then
			local text = Client.Function.Translate.Get(class)
			categories[text] = class
			texts[#texts + 1] = text
		end
	end
	cb({
		translatedText = {
			["Favorite"] = favoriteText,
			["Personal"] = personalText
		},
		categoryList = texts
	})
end)

RegisterNUICallback("getCategory", function(data, cb)
	local category = categories[data.category]
	cb(vehicleList[category])
end)

RegisterNUICallback("addToFavorite", function(data, cb)
	local favorite = data.model
	table.insert(vehicleList["Favorite"], {model = favorite, label = data.label, category = data.category})
	local category = categories[data.category]
	for k, v in pairs(vehicleList[category] or {}) do
		if v.model == favorite then
			v.favorite = true
			break
		end
	end
	Client.Vehicle.FavoriteVehicles[favorite] = true
	TriggerServerEvent("server:race:saveFavorite", {favorite = favorite}, 1)
end)

RegisterNUICallback("removeFromFavorite", function(data, cb)
	local favorite = data.model
	for k, v in pairs(vehicleList["Favorite"]) do
		if v.model == favorite then
			table.remove(vehicleList["Favorite"], k)
			break
		end
	end
	local category = categories[data.category]
	for k, v in pairs(vehicleList[category] or {}) do
		if v.model == favorite then
			v.favorite = false
			break
		end
	end
	Client.Vehicle.FavoriteVehicles[favorite] = nil
	TriggerServerEvent("server:race:saveFavorite", {favorite = favorite}, 0)
end)

RegisterNUICallback("previewVeh", function(data, cb)
	local ped = PlayerPedId()
	if DoesEntityExist(previewVehicle) then
		DeleteVehicle(previewVehicle)
	end
	if tonumber(data.model) then
		local model = tonumber(data.model)
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(0) end
		previewVehicle = CreateVehicle(model, -74.9068, -819.0542, 326.1751, 250.0, false, false)
		SetModelAsNoLongerNeeded(model)
	else
		local plate = data.model
		local mods = nil
		for k, v in pairs(Client.Vehicle.SavedVehicles) do
			if v.plate == plate then
				mods = v
			end
		end
		local model = mods and mods.model and tonumber(mods.model) or GetHashKey("bmx")
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(0) end
		previewVehicle = CreateVehicle(model, -74.9068, -819.0542, 326.1751, 250.0, false, false)
		SetModelAsNoLongerNeeded(model)
		Client.Function.Tuning.SetProperties(previewVehicle, mods)
	end
	SetEntityHeading(previewVehicle, 250.0)
	SetPedIntoVehicle(ped, previewVehicle, -1)
	SetVehicleHandbrake(previewVehicle, true)
	FreezeEntityPosition(previewVehicle, true)
	SetEntityCoords(previewVehicle, -74.9068, -819.0542, 326.1751)
	local vehicleData = {
		traction = math.ceil(10 * GetVehicleMaxTraction(previewVehicle) * 1.6),
		maxSpeed = math.ceil(GetVehicleEstimatedMaxSpeed(previewVehicle) * 0.9650553 * 1.4),
		acceleration = math.ceil(GetVehicleAcceleration(previewVehicle) * 2.6 * 100),
		breaking = math.ceil(GetVehicleMaxBraking(previewVehicle) * 0.9650553 * 100)
	}
	if vehicleData.traction > 100.0 then
		vehicleData.traction = 100.0
	end
	if vehicleData.maxSpeed > 70.0 then
		vehicleData.maxSpeed = 70.0
	end
	if vehicleData.acceleration > 100.0 then
		vehicleData.acceleration = 100.0
	end
	if vehicleData.breaking > 100.0 then
		vehicleData.breaking = 100.0
	end
	cb(vehicleData)
end)

RegisterNUICallback("selectVehicleCam", function(data, cb)
	Race.Cache.InVehicleUI = true
	local ped = PlayerPedId()
	SetEntityCoords(ped, -75.1623, -818.9494, 332.9547)
	SetEntityHeading(ped, 139.5274)
	FreezeEntityPosition(ped, true)
	SetEntityVisible(ped, false)
	categories = {}
	vehicleList = {
		["Favorite"] = {},
		["Personal"] = {}
	}
	for k, v in pairs(Client.Vehicle.Classes) do
		vehicleList[v] = {}
	end
	local allVehModels = GetAllVehicleModels()
	local invalidFavorite = {}
	local personalVehicles = {}
	for k, v in pairs(Client.Vehicle.SavedVehicles) do
		if v.plate then
			personalVehicles[v.plate] = v
		end
	end
	for k, v in pairs(Client.Vehicle.FavoriteVehicles) do
		if tonumber(k) then
			local hash = tonumber(k)
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			local class = GetVehicleClassFromName(hash)
			local category = Client.Vehicle.Classes[class] and Client.Function.Translate.Get(Client.Vehicle.Classes[class])
			if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) and (label ~= "NULL") and category then
				table.insert(vehicleList["Favorite"], {model = tostring(hash), label = label:gsub("µ", " "), category = category})
			else
				invalidFavorite[tostring(hash)] = true
			end
		else
			if personalVehicles[k] then
				local hash = personalVehicles[k].model
				local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
				if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) and (label ~= "NULL") then
					table.insert(vehicleList["Favorite"], {model = k, label = label:gsub("µ", " "), category = Client.Function.Translate.Get("Personal")})
				end
			else
				invalidFavorite[k] = true
			end
		end
	end
	if Client.Function.Math.TableCount(invalidFavorite) > 0 then
		for k, v in pairs(invalidFavorite) do
			Client.Vehicle.FavoriteVehicles[k] = nil
		end
		TriggerServerEvent("server:race:saveFavorite", Client.Vehicle.FavoriteVehicles, 2)
	end
	for k, v in pairs(Client.Vehicle.SavedVehicles) do
		local hash = v.model
		local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
		if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) and (label ~= "NULL") then
			table.insert(vehicleList["Personal"], {model = v.plate, label = label:gsub("µ", " "), favorite = Client.Vehicle.FavoriteVehicles[v.plate] or false})
		end
	end
	for k, v in pairs(allVehModels) do
		local hash = GetHashKey(v)
		local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
		local class = GetVehicleClassFromName(hash)
		if (label ~= "NULL") and Client.Vehicle.Classes[class] then
			table.insert(vehicleList[Client.Vehicle.Classes[class]], {model = tostring(hash), label = label:gsub("µ", " "), favorite = Client.Vehicle.FavoriteVehicles[tostring(hash)] or false})
		end
	end
	for k, v in pairs(vehicleList) do
		table.sort(v, function(a, b)
			return string.lower(a.label) < string.lower(b.label)
		end)
	end
	Wait(1000)
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(ped)
	while IsPlayerSwitchInProgress() do Wait(0) end
	previewCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -66.3730, -818.9483, 330.1423, -20.0, 0.0, 90.0, GetGameplayCamFov())
	SetCamActive(previewCamera, true)
	RenderScriptCams(true, true, 1000, true, false)
	cb({})
end)

RegisterNUICallback("selectVeh", function(data, cb)
	local ped = PlayerPedId()
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(previewCamera, false)
	previewCamera = nil
	Wait(1000)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	Wait(1000)
	if DoesEntityExist(previewVehicle) then
		DeleteVehicle(previewVehicle)
	end
	if Race.Cache.JoinVehicleNetId then
		SetEntityCoords(ped, Race.Cache.JoinPoint)
		SetEntityHeading(ped, Race.Cache.JoinHeading)
	else
		SetEntityCoordsNoOffset(ped, Race.Cache.JoinPoint)
		SetEntityHeading(ped, Race.Cache.JoinHeading)
	end
	SetEntityVisible(ped, true)
	Wait(500)
	local veh = Race.Cache.JoinVehicleNetId and NetworkDoesNetworkIdExist(Race.Cache.JoinVehicleNetId) and NetworkDoesEntityExistWithNetworkId(Race.Cache.JoinVehicleNetId) and NetworkGetEntityFromNetworkId(Race.Cache.JoinVehicleNetId)
	if DoesEntityExist(veh) then
		SetPedIntoVehicle(ped, veh, -1)
	end
	SetGameplayCamRelativeHeading(0)
	FreezeEntityPosition(ped, false)
	if tonumber(data.model) then
		local model = tonumber(data.model)
		TriggerServerEvent("server:race:setPlayerVehicle", {
			label = model,
			mods = model
		})
	else
		local plate = data.model
		local mods = nil
		for k, v in pairs(Client.Vehicle.SavedVehicles) do
			if v.plate == plate then
				mods = v
			end
		end
		local model = mods and mods.model and tonumber(mods.model) or GetHashKey("bmx")
		TriggerServerEvent("server:race:setPlayerVehicle", {
			label = model,
			mods = mods or model
		})
	end
	cb({inRoom = Race.Cache.InRoom})
	Race.Cache.InVehicleUI = false
end)