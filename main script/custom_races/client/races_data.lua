races_data_front = {}
local vehiclelist = {
	["Favoritos"] = {},
	["Personales"] = {}
}
local fake_fav = {}
local fake_per = {}
local currentveh = 0
local cam = 0
local lastcoords = vector3(0, 0, 0)
local mystats = {}

local hasData = false
Citizen.CreateThread(function()
	Citizen.Wait(3000)

	if not hasData then
		ESX.TriggerServerCallback("custom_races:GetRacesData_Front", function(result)
			races_data_front = result
			hasData = true
		end)
		Citizen.Wait(10000)
		SendNUIMessage({
			action = "SyncData",
			races_data_front = races_data_front
		})
	end
end)

RegisterNetEvent("custom_races:client:UpdateRacesData_Front", function(data)
	races_data_front = data
end)

RegisterNetEvent("custom_races:client:UpdateRacesData_Front_S", function(category, index, data)
	races_data_front[category][index] = data
end)

Citizen.CreateThread(function()
	while not ESX.GetPlayerData() or not ESX.GetPlayerData().identifier do
		Citizen.Wait(1000)
	end
	ESX.TriggerServerCallback('custom_races:callback:favoritesvehs_personalvehs_mystats', function(favorites, personals, _mystats)
		mystats = _mystats

		for k, v in pairs(Config.VehsClass) do
			vehiclelist[v] = {}
		end

		local models = GetAllVehicleModels()

		for k, v in pairs(personals) do
			fake_per[v.plate] = json.decode(v.mods)
		end

		for k, v in pairs(favorites) do
			local hash = tonumber(k)
			if hash then
				local class = GetVehicleClassFromName(hash)
				table.insert(vehiclelist["Favoritos"], { model = hash, label = GetLabelText(GetDisplayNameFromVehicleModel(hash)), category = Config.VehsClass[class] })
				fake_fav[hash] = v
			else
				table.insert(vehiclelist["Favoritos"], { model = k, label = fake_per[k] and GetLabelText(GetDisplayNameFromVehicleModel(fake_per[k].model)) or "Error al cargar", category = "Personales" })
				fake_fav[k] = v
			end
		end

		--[[for k, v in pairs(personals) do
			table.insert(vehiclelist["Personales"], { model = v.plate, label = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(fake_per[v.plate].model))), favorite = fake_fav[v.plate] or false })
		end]]

		for k, v in pairs(models) do
			local hash = GetHashKey(v)
			local class = GetVehicleClassFromName(hash)
			if not Config.BlacklistedVehs[v] and Config.VehsClass[class] then
				local hash = GetHashKey(v)
				table.insert(vehiclelist[Config.VehsClass[class]], { model = hash, label = GetLabelText(GetDisplayNameFromVehicleModel(hash)), favorite = fake_fav[hash] or false })
			end
		end

		for k, v in pairs(vehiclelist) do
			table.sort(v, function(a, b)
				return a.label < b.label
			end)
		end
	end, ESX.GetPlayerData().identifier)
end)


RegisterNUICallback('GetCategoryList', function(data, cb)
	cb(Config.VehsClass)
end)

RegisterNUICallback('GetCategory', function(data, cb)
	cb(vehiclelist[data.category])
end)

RegisterNUICallback('AddToFavorite', function(data, cb)
	table.insert(vehiclelist["Favoritos"], data)
	for k, v in pairs(vehiclelist[data.category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = true
		end
	end
	fake_fav[tonumber(data.model) or data.model] = true
	TriggerServerEvent("custom_races:SetFavorite", fake_fav)
end)

RegisterNUICallback('RemoveFromFavorite', function(data, cb)
	for k, v in pairs(vehiclelist["Favoritos"]) do
		if v.model == (tonumber(data.model) or data.model) then
			table.remove(vehiclelist["Favoritos"], k)
		end
	end
	for k, v in pairs(vehiclelist[data.category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = false
		end
	end
	fake_fav[tonumber(data.model) or data.model] = nil
	TriggerServerEvent("custom_races:SetFavorite", fake_fav)
end)

RegisterNUICallback('PreviewVeh', function(data, cb)
	while DoesEntityExist(currentveh) do
		Citizen.Wait(0)
		DeleteVehicle(currentveh)
	end

	if tonumber(data.model) then
		RequestModel(tonumber(data.model))
		while not HasModelLoaded(tonumber(data.model)) do
			Wait(500)
		end
		currentveh = CreateVehicle(tonumber(data.model), Config.PreviewVehs.Spawn.xyz, Config.PreviewVehs.Spawn.w, true, false)
		SetModelAsNoLongerNeeded(tonumber(data.model))
	else
		RequestModel(tonumber(data.model))
		while not HasModelLoaded(tonumber(data.model)) do
			Wait(500)
		end
		local mods = fake_per[data.model]
		currentveh = CreateVehicle(tonumber(data.model), Config.PreviewVehs.Spawn.xyz, Config.PreviewVehs.Spawn.w, true, false)
		ESX.Game.SetVehicleProperties(currentveh, mods)
		SetModelAsNoLongerNeeded(tonumber(data.model))
	end
	SetEntityHeading(currentveh, Config.PreviewVehs.Spawn.w)
	TaskWarpPedIntoVehicle(PlayerPedId(), currentveh, -1)
	SetVehicleHandbrake(currentveh, true)
	FreezeEntityPosition(currentveh, true)
	SetEntityCoords(currentveh, Config.PreviewVehs.Spawn.xyz)


	local vehicleData = {
		traction = math.ceil(10 * GetVehicleMaxTraction(currentveh) * 1.6),
		maxSpeed = math.ceil(GetVehicleEstimatedMaxSpeed(currentveh) * 0.9650553 * 1.4),
		acceleration = math.ceil(GetVehicleAcceleration(currentveh) * 2.6 * 100),
		breaking = math.ceil(GetVehicleMaxBraking(currentveh) * 0.9650553 * 100),
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

RegisterNUICallback('SelectVehicleCam', function(data, cb)
	lastcoords = GetEntityCoords(PlayerPedId())
	SetEntityCoords(PlayerPedId(), Config.PreviewVehs.PedHidden.xyz)
	SetEntityHeading(PlayerPedId(), Config.PreviewVehs.PedHidden.w)
	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityVisible(PlayerPedId(), false, false)
	Citizen.Wait(1000)
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	while IsPlayerSwitchInProgress() do
		Citizen.Wait(100)
	end

	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.PreviewVehs.CamPos, Config.PreviewVehs.CamRot, GetGameplayCamFov())
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 1000, true, false)
	SetCamAffectsAiming(cam, false)

	cb({})
end)

RegisterNUICallback('SelectVeh', function(data, cb)
	TriggerServerEvent("custom_races:server:setplayercar", data)
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(cam, false)
	Citizen.Wait(1000)
	SwitchOutPlayer(PlayerPedId(), 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	Citizen.Wait(1000)

	while DoesEntityExist(currentveh) do
		Citizen.Wait(0)
		DeleteVehicle(currentveh)
	end

	SetEntityCoords(PlayerPedId(), lastcoords)
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityVisible(PlayerPedId(), true, true)

	cb({})
end)

RegisterNUICallback("get-race-times", function(data, cb)
	for k, v in pairs(races_data_front) do
		for i = 1, #v do
			if v[i].raceid == data.raceid then
				return cb(v[i].besttimes)
			end
		end
	end
end)

RegisterNetEvent("custom_races:client:updatemytop", function(_mystats)
	mystats = _mystats
end)