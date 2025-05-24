races_data_front = {}
allVehModels = {}
local vehiclelist = {
	["Favorite"] = {},
	["Personal"] = {}
}
local fav_vehs = {}
local per_vehs = {}
local previewVehicle = 0
local cam = 0
local firstLoad = true

Citizen.CreateThread(function()
	Citizen.Wait(3000)
	allVehModels = GetAllVehicleModels()
	TriggerServerCallback("custom_races:server:getRacesData", function(result)
		if Count(result) > 0 then
			races_data_front = result
		else
			print("Error: can't load race data for you, please re-connect to this server or ignore this error message")
			print("Error: if it keeps happening, please contact the server admin to add the race tracks")
		end
		firstLoad = false
	end)
end)

RegisterNetEvent("custom_races:client:updateRacesData", function(category, index, data)
	if races_data_front[category] and races_data_front[category][index] then
		races_data_front[category][index] = data
	end
end)

RegisterNetEvent("custom_races:client:dataOutdated", function()
	while firstLoad do Citizen.Wait(0) end
	dataOutdated = true
end)

RegisterNUICallback('custom_races:nui:getCategoryList', function(data, cb)
	local list = {
		translatedText = {
			["Favorite"] = GetTranslate("Favorite"),
			["Personal"] = GetTranslate("Personal")
		},
		CategoryList = {}
	}
	for i = 0, #Config.VehsClass do
		table.insert(list.CategoryList, GetTranslate(Config.VehsClass[i]))
	end
	cb(list)
end)

RegisterNUICallback('custom_races:nui:getCategory', function(data, cb)
	local category = GetOriginalText(data.category)
	cb(vehiclelist[category])
end)

RegisterNUICallback('custom_races:nui:addToFavorite', function(data, cb)
	table.insert(vehiclelist["Favorite"], { model = tonumber(data.model) or data.model, label = data.label, category = data.category })
	local category = GetOriginalText(data.category)
	for k, v in pairs(vehiclelist[category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = true
		end
	end
	fav_vehs[tonumber(data.model) or data.model] = true
	TriggerServerEvent("custom_races:server:setFavorite", fav_vehs)
end)

RegisterNUICallback('custom_races:nui:removeFromFavorite', function(data, cb)
	for k, v in pairs(vehiclelist["Favorite"]) do
		if v.model == (tonumber(data.model) or data.model) then
			table.remove(vehiclelist["Favorite"], k)
		end
	end
	local category = GetOriginalText(data.category)
	for k, v in pairs(vehiclelist[category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = false
		end
	end
	fav_vehs[tonumber(data.model) or data.model] = nil
	TriggerServerEvent("custom_races:server:setFavorite", fav_vehs)
end)

RegisterNUICallback('custom_races:nui:previewVeh', function(data, cb)
	local ped = PlayerPedId()
	if DoesEntityExist(previewVehicle) then
		DeleteVehicle(previewVehicle)
	end
	if tonumber(data.model) then
		-- hash
		RequestModel(tonumber(data.model))
		while not HasModelLoaded(tonumber(data.model)) do
			Citizen.Wait(0)
		end
		previewVehicle = CreateVehicle(tonumber(data.model), Config.PreviewVehs.Spawn.xyz, Config.PreviewVehs.Spawn.w, false, false)
		SetModelAsNoLongerNeeded(tonumber(data.model))
	else
		-- plate
		local mods = per_vehs[data.model]
		RequestModel(tonumber(mods.model))
		while not HasModelLoaded(tonumber(mods.model)) do
			Citizen.Wait(0)
		end
		previewVehicle = CreateVehicle(tonumber(mods.model), Config.PreviewVehs.Spawn.xyz, Config.PreviewVehs.Spawn.w, false, false)
		SetVehicleProperties(previewVehicle, mods)
		SetModelAsNoLongerNeeded(tonumber(mods.model))
	end
	SetEntityHeading(previewVehicle, Config.PreviewVehs.Spawn.w)
	SetPedIntoVehicle(ped, previewVehicle, -1)
	SetVehicleHandbrake(previewVehicle, true)
	FreezeEntityPosition(previewVehicle, true)
	SetEntityCoords(previewVehicle, Config.PreviewVehs.Spawn.xyz)
	-- Calculate vehicle stats for the preview
	local vehicleData = {
		traction = math.ceil(10 * GetVehicleMaxTraction(previewVehicle) * 1.6),
		maxSpeed = math.ceil(GetVehicleEstimatedMaxSpeed(previewVehicle) * 0.9650553 * 1.4),
		acceleration = math.ceil(GetVehicleAcceleration(previewVehicle) * 2.6 * 100),
		breaking = math.ceil(GetVehicleMaxBraking(previewVehicle) * 0.9650553 * 100),
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

RegisterNUICallback('custom_races:nui:selectVehicleCam', function(data, cb)
	inVehicleUI = true
	local ped = PlayerPedId()
	SetEntityCoords(ped, Config.PreviewVehs.PedHidden.xyz)
	SetEntityHeading(ped, Config.PreviewVehs.PedHidden.w)
	FreezeEntityPosition(ped, true)
	SetEntityVisible(ped, false, false)
	if DoesEntityExist(JoinRaceVehicle) then
		SetEntityVisible(JoinRaceVehicle, false)
		SetEntityCollision(JoinRaceVehicle, false, false)
		FreezeEntityPosition(JoinRaceVehicle, true)
	end
	-- Get player latest vehicles
	fav_vehs = {}
	per_vehs = {}
	vehiclelist = {
		["Favorite"] = {},
		["Personal"] = {}
	}
	for k, v in pairs(Config.VehsClass) do
		vehiclelist[v] = {}
	end
	TriggerServerCallback('custom_races:server:getVehicles', function(favorites, personals)
		allVehModels = GetAllVehicleModels()
		for k, v in pairs(personals) do
			per_vehs[v.plate] = v
		end
		for k, v in pairs(favorites) do
			if tonumber(k) then
				local hash = tonumber(k)
				local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
				local class = GetVehicleClassFromName(hash)
				local category = Config.VehsClass[class] and GetTranslate(Config.VehsClass[class])
				if not Config.BlacklistedVehs[hash] and (label ~= "NULL") and category then
					table.insert(vehiclelist["Favorite"], { model = hash, label = label, category = category })
					fav_vehs[hash] = v
				end
			elseif per_vehs[k] then
				local hash = per_vehs[k].model
				local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
				if not Config.BlacklistedVehs[hash] and (label ~= "NULL") then
					table.insert(vehiclelist["Favorite"], { model = k, label = label, category = GetTranslate("Personal") })
					fav_vehs[k] = v
				end
			end
		end
		for k, v in pairs(personals) do
			local hash = v.model
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			if not Config.BlacklistedVehs[hash] and (label ~= "NULL") then
				table.insert(vehiclelist["Personal"], { model = v.plate, label = label, favorite = fav_vehs[v.plate] or false })
			end
		end
		for k, v in pairs(allVehModels) do
			local hash = GetHashKey(v)
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			local class = GetVehicleClassFromName(hash)
			if not Config.BlacklistedVehs[hash] and (label ~= "NULL") and Config.VehsClass[class] then
				table.insert(vehiclelist[Config.VehsClass[class]], { model = hash, label = label, favorite = fav_vehs[hash] or false })
			end
		end
		for k, v in pairs(vehiclelist) do
			table.sort(v, function(a, b)
				return string.lower(a.label) < string.lower(b.label)
			end)
		end
	end)
	Citizen.Wait(1000)
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(ped)
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.PreviewVehs.CamPos, Config.PreviewVehs.CamRot, GetGameplayCamFov())
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 1000, true, false)
	SetCamAffectsAiming(cam, false)
	cb({})
end)

RegisterNUICallback('custom_races:nui:selectVeh', function(data, cb)
	cb({inroom = inRoom})
	inVehicleUI = false
	local ped = PlayerPedId()
	local vehicle = {}
	if tonumber(data.model) then
		-- hash
		vehicle.label = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(data.model)))
		vehicle.mods = tonumber(data.model)
	else
		-- plate
		vehicle.label = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(per_vehs[data.model].model)))
		vehicle.mods = per_vehs[data.model]
	end
	TriggerServerEvent("custom_races:server:setPlayerVehicle", vehicle)
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(cam, false)
	Citizen.Wait(1000)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	Citizen.Wait(1000)
	if DoesEntityExist(previewVehicle) then
		DeleteVehicle(previewVehicle)
	end
	SetEntityVisible(ped, true, true)
	if JoinRaceVehicle ~= 0 then
		if DoesEntityExist(JoinRaceVehicle) then
			SetEntityCoords(JoinRaceVehicle, JoinRacePoint)
			SetEntityHeading(JoinRaceVehicle, JoinRaceHeading)
			SetEntityVisible(JoinRaceVehicle, true)
			SetEntityCollision(JoinRaceVehicle, true, true)
			SetPedIntoVehicle(ped, JoinRaceVehicle, -1)
		else
			SetEntityCoords(ped, JoinRacePoint)
			SetEntityHeading(ped, JoinRaceHeading)
		end
	else
		SetEntityCoordsNoOffset(ped, JoinRacePoint)
		SetEntityHeading(ped, JoinRaceHeading)
	end
	SetGameplayCamRelativeHeading(0)
	FreezeEntityPosition(ped, false)
	if DoesEntityExist(JoinRaceVehicle) then
		FreezeEntityPosition(JoinRaceVehicle, false)
		ActivatePhysics(JoinRaceVehicle)
	end
end)

RegisterNUICallback("custom_races:nui:getBestTimes", function(data, cb)
	for k, v in pairs(races_data_front) do
		for i = 1, #v do
			if v[i].raceid == data.raceid then
				for _, time in pairs(v[i].besttimes) do
					local vehNameFinal = time.vehicle
					time.vehicle = (GetLabelText(vehNameFinal) ~= "NULL" and GetLabelText(vehNameFinal)) or (vehNameFinal ~= "" and vehNameFinal) or "On Foot"
				end
				return cb(v[i].besttimes)
			end
		end
	end
	cb({})
end)

RegisterNUICallback("custom_races:nui:getRandomRace", function(data, cb)
	if Config.GetRandomRaceById then
		-- Random by id (The probability is more average)
		local races = {}
		local raceIds = {}
		for k, v in pairs(races_data_front) do
			for i = 1, #v do
				races[v[i].raceid] = v[i]
				table.insert(raceIds, v[i].raceid)
			end
		end
		if #raceIds > 0 then
			local randomIndex = math.random(#raceIds)
			local randomRaceId = raceIds[randomIndex]
			local randomRace = races[randomRaceId]
			cb({randomRace})
		else
			cb({})
		end
	else
		-- Random by category
		local categories = {}
		for category, _ in pairs(races_data_front) do
			table.insert(categories, category)
		end
		if #categories > 0 then
			local randomCategory = categories[math.random(#categories)]
			local randomRace = races_data_front[randomCategory][math.random(#races_data_front[randomCategory])]
			cb({randomRace})
		else
			cb({})
		end
	end
end)

RegisterNUICallback("custom_races:nui:filterRaces", function(data, cb)
	local races = {}
	local str = string.lower(data.name)
	if #str > 0 then
		for k, v in pairs(races_data_front) do
			for i = 1, #v do
				if string.find(string.lower(v[i].name), str) then
					table.insert(races, v[i])
					if #races >= 200 then
						break
					end
				end
			end
			if #races >= 200 then
				break
			end
		end
	end
	if #races >= 200 then
		SendNUIMessage({
			action = "nui_msg:showNoty",
			message = GetTranslate("msg-result-limit")
		})
	end
	cb(races)
end)