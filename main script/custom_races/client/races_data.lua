races_data_front = {}
local vehiclelist = {
	["Favorite"] = {},
	["Personal"] = {}
}
local fake_fav = {}
local fake_per = {}
local currentveh = 0
local cam = 0
local lastcoords = vector3(0, 0, 0)
local hasData = false

--- Thread to fetch race data and sync it to nui
Citizen.CreateThread(function()
	Citizen.Wait(3000)

	if not hasData then
		-- Fetch race data from the server
		TriggerServerCallbackFunction("custom_races:GetRacesData_Front", function(result)
			races_data_front = result
			hasData = true
		end)

		-- Wait for data to be fetched, then sync it
		Citizen.Wait(10000)
		SendNUIMessage({
			action = "SyncData",
			races_data_front = races_data_front
		})
	end
end)

--- Event to update the entire race data front
--- @param data table The new race data
RegisterNetEvent("custom_races:client:UpdateRacesData_Front", function(data)
	races_data_front = data
end)

--- Event to update a specific race data entry
--- @param category string The category of the race
--- @param index number The index within the category
--- @param data table The updated data
RegisterNetEvent("custom_races:client:UpdateRacesData_Front_S", function(category, index, data)
	races_data_front[category][index] = data
end)

--- Thread to handle vehicle lists for a player
Citizen.CreateThread(function()
	local player_identifier = nil
	if "esx" == Config.Framework then
		while not ESX.GetPlayerData() or not ESX.GetPlayerData().identifier do
			Citizen.Wait(1000)
		end
		player_identifier = ESX.GetPlayerData().identifier
	elseif "qb" == Config.Framework then
		while not QBCore.Functions.GetPlayerData() or not QBCore.Functions.GetPlayerData().citizenid do
			Citizen.Wait(1000)
		end
		player_identifier = QBCore.Functions.GetPlayerData().citizenid
	end

	-- Fetch favorite and personal vehicles from the server
	TriggerServerCallbackFunction('custom_races:callback:favoritesvehs_personalvehs', function(favorites, personals)
		-- Initialize vehicle lists based on configured vehicle classes
		for k, v in pairs(Config.VehsClass) do
			vehiclelist[v] = {}
		end

		-- Get all vehicle models in the game
		local models = GetAllVehicleModels()

		-- Process personal vehicles, storing their modifications
		if "esx" == Config.Framework then
			for k, v in pairs(personals) do
				fake_per[v.plate] = json.decode(v.vehicle)
			end
		elseif "qb" == Config.Framework then
			for k, v in pairs(personals) do
				fake_per[v.plate] = json.decode(v.mods)
			end
		end

		-- Process favorite vehicles
		for k, v in pairs(favorites) do
			local hash = tonumber(k)
			if hash then
				local class = GetVehicleClassFromName(hash)
				table.insert(vehiclelist["Favorite"], { model = hash, label = GetLabelText(GetDisplayNameFromVehicleModel(hash)), category = Config.VehsClass[class] })
				fake_fav[hash] = v
			else
				table.insert(vehiclelist["Favorite"], { model = k, label = fake_per[k] and GetLabelText(GetDisplayNameFromVehicleModel(fake_per[k].model)) or "Error loading", category = "Personal" })
				fake_fav[k] = v
			end
		end

		-- Add personal vehicles to the vehicle list
		for k, v in pairs(personals) do
			table.insert(vehiclelist["Personal"], { model = v.plate, label = GetLabelText(GetDisplayNameFromVehicleModel(tonumber(fake_per[v.plate].model))), favorite = fake_fav[v.plate] or false })
		end

		-- Add all valid vehicle models to the vehicle list
		for k, v in pairs(models) do
			local hash = GetHashKey(v)
			local class = GetVehicleClassFromName(hash)
			if not Config.BlacklistedVehs[v] and Config.VehsClass[class] then
				local hash = GetHashKey(v)
				table.insert(vehiclelist[Config.VehsClass[class]], { model = hash, label = GetLabelText(GetDisplayNameFromVehicleModel(hash)), favorite = fake_fav[hash] or false })
			end
		end

		-- Sort the vehicle list alphabetically by label
		for k, v in pairs(vehiclelist) do
			table.sort(v, function(a, b)
				return a.label < b.label
			end)
		end
	end, player_identifier)
end)

--- Register NUI callback to get the category list
--- @param data table The data sent by the NUI
--- @param cb function The callback function to send the response
RegisterNUICallback('GetCategoryList', function(data, cb)
	cb(Config.VehsClass)
end)

--- Register NUI callback to get vehicles in a specific category
--- @param data table The data containing the selected category
--- @param cb function The callback function to send the response
RegisterNUICallback('GetCategory', function(data, cb)
	cb(vehiclelist[data.category])
end)

--- Register NUI callback to add a vehicle to favorites
--- @param data table The data containing the vehicle information
--- @param cb function The callback function to send the response
RegisterNUICallback('AddToFavorite', function(data, cb)
	-- Insert the vehicle into the "Favorite" category
	table.insert(vehiclelist["Favorite"], data)

	-- Mark the vehicle as favorite in its original category
	for k, v in pairs(vehiclelist[data.category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = true
		end
	end

	-- Update the fake_fav table with the new favorite vehicle
	fake_fav[tonumber(data.model) or data.model] = true

	-- Trigger server event to save the favorite vehicle list
	TriggerServerEvent("custom_races:SetFavorite", fake_fav)
end)

--- Register NUI callback to remove a vehicle from favorites
--- @param data table The data containing the vehicle information
--- @param cb function The callback function to send the response
RegisterNUICallback('RemoveFromFavorite', function(data, cb)
	-- Remove the vehicle from the "Favorite" category
	for k, v in pairs(vehiclelist["Favorite"]) do
		if v.model == (tonumber(data.model) or data.model) then
			table.remove(vehiclelist["Favorite"], k)
		end
	end

	-- Unmark the vehicle as favorite in its original category
	for k, v in pairs(vehiclelist[data.category]) do
		if v.model == (tonumber(data.model) or data.model) then
			v.favorite = false
		end
	end

	-- Update the fake_fav table to remove the favorite status
	fake_fav[tonumber(data.model) or data.model] = nil

	-- Trigger server event to update the favorite vehicle list
	TriggerServerEvent("custom_races:SetFavorite", fake_fav)
end)

--- Register NUI callback to preview a selected vehicle
--- @param data table The data containing the vehicle model
--- @param cb function The callback function to send the response
RegisterNUICallback('PreviewVeh', function(data, cb)
	-- Delete any existing preview vehicle
	while DoesEntityExist(currentveh) do
		Citizen.Wait(0)
		DeleteVehicle(currentveh)
	end

	-- Check if the model is a personal vehicle
	if tonumber(data.model) then
		RequestModel(tonumber(data.model))
		while not HasModelLoaded(tonumber(data.model)) do
			Citizen.Wait(0)
		end
		currentveh = CreateVehicle(tonumber(data.model), Config.PreviewVehs.Spawn.xyz, Config.PreviewVehs.Spawn.w, true, false)
		SetModelAsNoLongerNeeded(tonumber(data.model))
	else
		local mods = fake_per[data.model]
		RequestModel(tonumber(mods.model))
		while not HasModelLoaded(tonumber(mods.model)) do
			Citizen.Wait(0)
		end
		currentveh = CreateVehicle(tonumber(mods.model), Config.PreviewVehs.Spawn.xyz, Config.PreviewVehs.Spawn.w, true, false)
		SetVehicleProperties(currentveh, mods)
		SetModelAsNoLongerNeeded(tonumber(mods.model))
	end

	-- Set vehicle properties for the preview
	SetEntityHeading(currentveh, Config.PreviewVehs.Spawn.w)
	TaskWarpPedIntoVehicle(PlayerPedId(), currentveh, -1)
	SetVehicleHandbrake(currentveh, true)
	FreezeEntityPosition(currentveh, true)
	SetEntityCoords(currentveh, Config.PreviewVehs.Spawn.xyz)

	-- Calculate vehicle stats for the preview
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

--- Register NUI callback to switch to the vehicle preview camera
--- @param data table The data sent by the NUI
--- @param cb function The callback function to send the response
RegisterNUICallback('SelectVehicleCam', function(data, cb)
	-- Store the player's current coordinates
	lastcoords = GetEntityCoords(PlayerPedId())

	-- Hide the player model and prepare for vehicle preview
	SetEntityCoords(PlayerPedId(), Config.PreviewVehs.PedHidden.xyz)
	SetEntityHeading(PlayerPedId(), Config.PreviewVehs.PedHidden.w)
	FreezeEntityPosition(PlayerPedId(), true)
	SetEntityVisible(PlayerPedId(), false, false)
	Citizen.Wait(1000)

	-- Switch the view and prepare the camera
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	while IsPlayerSwitchInProgress() do
		Citizen.Wait(100)
	end

	-- Create and activate the camera for vehicle preview
	cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.PreviewVehs.CamPos, Config.PreviewVehs.CamRot, GetGameplayCamFov())
	SetCamActive(cam, true)
	RenderScriptCams(true, true, 1000, true, false)
	SetCamAffectsAiming(cam, false)

	cb({})
end)

--- Register NUI callback to select and finalize the vehicle choice
--- @param data table The data containing the vehicle selection
--- @param cb function The callback function to send the response
RegisterNUICallback('SelectVeh', function(data, cb)
	-- Notify the server of the selected vehicle
	TriggerServerEvent("custom_races:server:setplayercar", data)

	-- Deactivate and destroy the preview camera
	RenderScriptCams(false, true, 1000, true, false)
	DestroyCam(cam, false)
	Citizen.Wait(1000)
	SwitchOutPlayer(PlayerPedId(), 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	Citizen.Wait(1000)

	-- Delete the preview vehicle
	while DoesEntityExist(currentveh) do
		Citizen.Wait(0)
		DeleteVehicle(currentveh)
	end

	-- Restore the player's position and visibility
	SetEntityCoords(PlayerPedId(), lastcoords)
	FreezeEntityPosition(PlayerPedId(), false)
	SetEntityVisible(PlayerPedId(), true, true)

	cb({})
end)

--- Register NUI callback to get best times for a specific race
--- @param data table The data containing the race ID
--- @param cb function The callback function to send the race times
RegisterNUICallback("get-race-times", function(data, cb)
	-- Search for the race ID in the race data and send the best times as response
	for k, v in pairs(races_data_front) do
		for i = 1, #v do
			if v[i].raceid == data.raceid then
				return cb(v[i].besttimes)
			end
		end
	end
end)