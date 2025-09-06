races_data_front = {}
allVehModels = {}
local vehicleList = {
	["Favorite"] = {},
	["Personal"] = {}
}
local fav_vehs = {}
local per_vehs = {}
local previewVehicle = 0
local cam = 0
local firstLoad = true
local isQueryingInProgress = false

Citizen.CreateThread(function()
	Citizen.Wait(3000)
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
	cb(vehicleList[category])
end)

RegisterNUICallback('custom_races:nui:addToFavorite', function(data, cb)
	table.insert(vehicleList["Favorite"], { model = tonumber(data.model) or data.model, label = data.label, category = data.category })
	local category = GetOriginalText(data.category)
	for k, v in pairs(vehicleList[category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = true
		end
	end
	fav_vehs[tonumber(data.model) or data.model] = true
	TriggerServerEvent("custom_races:server:setFavorite", fav_vehs)
end)

RegisterNUICallback('custom_races:nui:removeFromFavorite', function(data, cb)
	for k, v in pairs(vehicleList["Favorite"]) do
		if v.model == (tonumber(data.model) or data.model) then
			table.remove(vehicleList["Favorite"], k)
		end
	end
	local category = GetOriginalText(data.category)
	for k, v in pairs(vehicleList[category]) do
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
	if DoesEntityExist(joinRaceVehicle) then
		SetEntityVisible(joinRaceVehicle, false)
		SetEntityCollision(joinRaceVehicle, false, false)
		FreezeEntityPosition(joinRaceVehicle, true)
	end
	-- Get player latest vehicles
	fav_vehs = {}
	per_vehs = {}
	vehicleList = {
		["Favorite"] = {},
		["Personal"] = {}
	}
	for k, v in pairs(Config.VehsClass) do
		vehicleList[v] = {}
	end
	local querying = true
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
					table.insert(vehicleList["Favorite"], { model = hash, label = label:gsub("µ", " "), category = category })
					fav_vehs[hash] = v
				end
			elseif per_vehs[k] then
				local hash = per_vehs[k].model
				local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
				if not Config.BlacklistedVehs[hash] and (label ~= "NULL") then
					table.insert(vehicleList["Favorite"], { model = k, label = label:gsub("µ", " "), category = GetTranslate("Personal") })
					fav_vehs[k] = v
				end
			end
		end
		for k, v in pairs(personals) do
			local hash = v.model
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			if not Config.BlacklistedVehs[hash] and (label ~= "NULL") then
				table.insert(vehicleList["Personal"], { model = v.plate, label = label:gsub("µ", " "), favorite = fav_vehs[v.plate] or false })
			end
		end
		for k, v in pairs(allVehModels) do
			local hash = GetHashKey(v)
			local label = GetLabelText(GetDisplayNameFromVehicleModel(hash))
			local class = GetVehicleClassFromName(hash)
			if not Config.BlacklistedVehs[hash] and (label ~= "NULL") and Config.VehsClass[class] then
				table.insert(vehicleList[Config.VehsClass[class]], { model = hash, label = label:gsub("µ", " "), favorite = fav_vehs[hash] or false })
			end
		end
		for k, v in pairs(vehicleList) do
			table.sort(v, function(a, b)
				return string.lower(a.label) < string.lower(b.label)
			end)
		end
		querying = false
	end)
	Citizen.Wait(1000)
	while querying do Citizen.Wait(0) end
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
		vehicle.label = tonumber(data.model)
		vehicle.mods = tonumber(data.model)
	else
		-- plate
		vehicle.label = tonumber(per_vehs[data.model].model)
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
	if joinRaceVehicle ~= 0 then
		if DoesEntityExist(joinRaceVehicle) then
			SetEntityCoords(joinRaceVehicle, joinRacePoint)
			SetEntityHeading(joinRaceVehicle, joinRaceHeading)
			SetEntityVisible(joinRaceVehicle, true)
			SetEntityCollision(joinRaceVehicle, true, true)
			SetPedIntoVehicle(ped, joinRaceVehicle, -1)
		else
			SetEntityCoords(ped, joinRacePoint)
			SetEntityHeading(ped, joinRaceHeading)
		end
	else
		SetEntityCoordsNoOffset(ped, joinRacePoint)
		SetEntityHeading(ped, joinRaceHeading)
	end
	SetGameplayCamRelativeHeading(0)
	FreezeEntityPosition(ped, false)
	if DoesEntityExist(joinRaceVehicle) then
		FreezeEntityPosition(joinRaceVehicle, false)
		ActivatePhysics(joinRaceVehicle)
	end
end)

RegisterNUICallback("custom_races:nui:getBestTimes", function(data, cb)
	TriggerServerCallback('custom_races:server:getBestTimes',function(besttimes)
		for k, v in pairs(besttimes) do
			v.vehicle = (v.vehicle == "parachute" and GetTranslate("transform-parachute")) or (v.vehicle == "beast" and GetTranslate("transform-beast")) or (GetLabelText(v.vehicle) ~= "NULL" and GetLabelText(v.vehicle):gsub("µ", " ")) or GetTranslate("unknown-vehicle")
		end
		cb(besttimes)
	end, data.raceid)
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

RegisterNUICallback("custom_races:nui:searchRaces", function(data, cb)
	if isQueryingInProgress then
		cb(nil)
		return
	end
	isQueryingInProgress = true
	local text = data and data.text or ""
	if #text > 0 then
		if string.find(text, "^https://prod.cloud.rockstargames.com/ugc/gta5mission/") and string.find(text, "jpg$") then
			TriggerServerCallback("custom_races:server:searchUGC", function(name, maxplayers, reason)
				if name and maxplayers then
					cb({
						createRoom = true,
						img = text,
						name = name,
						maxplayers = maxplayers
					})
					Citizen.Wait(3000)
					isQueryingInProgress = false
				else
					if reason == "cancel" then
						SendNUIMessage({
							action = "nui_msg:showNotification",
							message = GetTranslate("msg-search-cancel")
						})
					elseif reason == "failed" then
						SendNUIMessage({
							action = "nui_msg:showNotification",
							message = GetTranslate("msg-search-failed")
						})
					elseif reason == "timed-out" then
						SendNUIMessage({
							action = "nui_msg:showNotification",
							message = GetTranslate("msg-search-timed-out")
						})
					end
					cb(nil)
					isQueryingInProgress = false
				end
			end, text)
		else
			local str = string.lower(text)
			local races = {}
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
			if #races >= 200 then
				SendNUIMessage({
					action = "nui_msg:showNotification",
					message = GetTranslate("msg-result-limit")
				})
			end
			cb(races)
			isQueryingInProgress = false
		end
	else
		cb(nil)
		isQueryingInProgress = false
	end
end)

RegisterNUICallback("custom_races:nui:cancelSearch", function(data, cb)
	TriggerServerEvent("custom_races:server:cancelSearch")
end)