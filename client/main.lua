CreateThread(function()
	DoScreenFadeOut(0)
	SetBlipAlpha(GetNorthRadarBlip(), 0)
	DisplayRadar(false)
	SetPlayerTalkingOverride(PlayerId(), false)
	MumbleSetActive(false)
	Client.Function.Control.DisableActions()
	Client.Function.Environment.SetWeather("CLEAR")
	Client.Function.Environment.SetTime(12, 0, 0)
	Client.Function.Environment.DisableTraffic()
	Client.Function.Environment.DisableScenarios()
	Client.Function.Environment.DisableWantedLevel()
	Client.Function.Vehicle.AddBMXsToData()
	Client.Function.Vehicle.AddCrashedModelsToData()
	Client.Function.Tattoo.InitData()
	while not Client.IsNetworkInitialized do
		if NetworkIsSessionStarted() then
			TriggerLatentServerEvent("server:core:init", 65536)
		end
		Wait(500)
	end
	TriggerServerCallback("server:core:getMyData", function(serverId, permission, myData)
		Client.ServerId = serverId
		Client.Permission = permission
		Client.Hud.Data.Logo = myData.Logo
		Client.Hud.Data.Name = myData.Name
		Client.Hud.Data.Discord = myData.Info.Discord
		Client.Hud.Data.Web = myData.Info.Web
		Client.Hud.Data.Count = myData.Count
		Client.Hud.Data.Ping = myData.Ping
		Client.Function.Translate.Add("hud-info-welcome", myData.Info.Welcome)
		AddTextEntry("FE_THDR_GTAO", myData.Info.Title)
		Race.Track.Bookmarked = myData.Race.bookmarked
		Race.Track.Played = myData.Race.played
		Race.Track.Finished = myData.Race.finished
		for model, _ in pairs(myData.Creator.favorite) do
			Creator.Data.Favorite[tonumber(model) or "error"] = true
		end
		Creator.Data.Template.List = myData.Creator.templates
		Creator.Data.Template.Index = #Creator.Data.Template.List
		SetEntityCoordsNoOffset(PlayerPedId(), myData.Position.x, myData.Position.y, myData.Position.z)
		SetEntityHeading(PlayerPedId(), myData.Position.heading)
		Client.Skin.Saved.Data = myData.Skin.data
		Client.Skin.Saved.Index = myData.Skin.index
		Client.Weapon.Saved = myData.Weapon
		Client.Vehicle.FavoriteVehicles = myData.Vehicle.favorite
		Client.Vehicle.SavedVehicles = myData.Vehicle.saved
		for key, value in pairs(myData.Preference) do
			if value == 0 then
				Client.Preference[key] = false
			elseif value == 1 then
				Client.Preference[key] = true
			end
		end
		if not Client.Preference.EnableAmbientSound then
			StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
		end
		if not IsPauseMenuActive() then
			SetInstancePriorityHint(Client.Preference.EnableOnlineMap and 4 or 0)
		end
		for k, v in pairs(myData.AddOn.Vehicle) do
			Client.Vehicle.Model.AddOn[GetHashKey(v)] = true
		end
		for k, v in pairs(myData.AddOn.Ped) do
			Client.Skin.Model.AddOn.Data[#Client.Skin.Model.AddOn.Data + 1] = {label = v, model = GetHashKey(v)}
		end
		Client.Vehicle.MaxSaves = myData.Slots.Vehicle
		if myData.Slots.Skin >= 1 then
			for i = 1, myData.Slots.Skin do
				Client.Skin.Slots[#Client.Skin.Slots + 1] = i
			end
		else
			Client.Skin.Slots = {1, 2, 3, 4, 5}
		end
		Client.Time.ServerSide.ScriptStartTime = myData.ScriptStartTime
		if permission.SpawnPedAsPlayerModel and myData.Skin.hash and IsModelValid(myData.Skin.hash) and IsModelAPed(myData.Skin.hash) then
			CreateThread(function()
				RequestModel(myData.Skin.hash)
				while not HasModelLoaded(myData.Skin.hash) do Wait(0) end
				SetPlayerModel(PlayerId(), myData.Skin.hash)
				SetPedRandomComponentVariation(PlayerPedId())
				SetModelAsNoLongerNeeded(myData.Skin.hash)
				if Client.Permission.Weapon and Client.Preference.WeaponLoaded then
					Client.Function.Weapon.RemoveAll(PlayerPedId())
					Client.Function.Weapon.LoadSaved(PlayerPedId())
				end
				Client.IsPedSpawning = false
			end)
		else
			Client.Function.Skin.Set(Client.Skin.Saved.Data[Client.Skin.Saved.Index])
		end
		CreateThread(function()
			for hash, _ in pairs(Client.Vehicle.Model.AddOn) do
				if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
					local startTime = GetGameTimer()
					RequestModel(hash)
					while not HasModelLoaded(hash) and (GetGameTimer() - startTime < 10000) do Wait(1000) end
					SetModelAsNoLongerNeeded(hash)
				end
			end
		end)
	end)
end)

CreateThread(function()
	while not Client.NUI.Loaded or not Client.Hud.Data.Logo or not Client.Hud.Data.Name or not Client.Hud.Data.Discord or not Client.Hud.Data.Web or not Client.Hud.Data.Count or not Client.Hud.Data.Ping or Client.IsPedSpawning do
		DisableControlAction(0, 245, true)
		DisableControlAction(0, 246, true)
		SetEntityVisible(PlayerPedId(), false)
		FreezeEntityPosition(PlayerPedId(), true)
		Wait(0)
	end
	Client.Menu.Main.Title = Client.Hud.Data.Name
	SetAutoGiveParachuteWhenEnterPlane(PlayerId(), true)
	NetworkSetFriendlyFireOption(true)
	SetCanAttackFriendly(PlayerPedId(), true, true)
	SetEntityVisible(PlayerPedId(), true)
	FreezeEntityPosition(PlayerPedId(), false)
	SetFollowPedCamViewMode(2)
	SetFollowVehicleCamViewMode(2)
	SetGameplayCamRelativeHeading(0)
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()
	local pos = GetEntityCoords(PlayerPedId())
	ClearAreaLeaveVehicleHealth(pos.x, pos.y, pos.z, 100000000000000000000000.0, false, false, false, false, false)
	TriggerServerEvent("server:core:loaded")
	TriggerServerEvent("server:core:setFlag", Client.CurrentLanguage)
	Wait(500)
	StatSetInt(`MP0_SHOOTING_ABILITY`, 100, true)
	StatSetInt(`MP0_STEALTH_ABILITY`, 100, true)
	StatSetInt(`MP0_FLYING_ABILITY`, 100, true)
	StatSetInt(`MP0_WHEELIE_ABILITY`, 100, true)
	StatSetInt(`MP0_LUNG_CAPACITY`, 100, true)
	StatSetInt(`MP0_STRENGTH`, 100, true)
	StatSetInt(`MP0_STAMINA`, 100, true)
	RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_01", false, -1)
	RequestScriptAudioBank("DLC_AIRRACES/AIR_RACE_02", false, -1)
	SendNUIMessage({
		action = "translate html",
		texts = Client.Function.Translate.GetHtmlTexts()
	})
	Client.Function.Player.SetBlipAndName()
	Client.Function.HUD.Minimap()
	Client.Function.HUD.Help()
	Client.Function.HUD.Info()
	Client.Function.HUD.Race()
	Client.Function.HUD.HideComponents()
	Client.Function.HUD.Speedometer()
	Client.Function.Vehicle.SetAddOnNames()
	Client.Function.Vehicle.GetAllForMenu()
	Client.Function.Vehicle.SetSavedForMenu()
	Client.Function.Weapon.InitData()
	Client.Function.Vehicle.Preview()
	Client.Function.StartMainThread()
	DoScreenFadeIn(500)
	Client.FirstLoad = false
	Wait(2000)
	Client.Function.HUD.Toggle()
	Client.Function.Translate.UpdateCurrentLanguage()
end)

CreateThread(function()
	while true do
		if Creator.Firework.IsMenuVisible then
			Client.Function.Environment.SetTime(0, 0, 0)
		elseif Client.Time.Lock or Client.IsInRace then
			NetworkOverrideClockTime(Client.Time.CurrentHour, Client.Time.CurrentMinute, Client.Time.CurrentSecond)
		else
			Client.Time.CurrentHour = GetClockHours()
			Client.Time.CurrentMinute = GetClockMinutes()
			Client.Time.CurrentSecond = GetClockSeconds()
		end
		ExtendWorldBoundaryForPlayer(-100000000000000000000000.0, -100000000000000000000000.0, 100000000000000000000000.0)
		ExtendWorldBoundaryForPlayer(100000000000000000000000.0, 100000000000000000000000.0, 100000000000000000000000.0)
		Wait(0)
	end
end)

function Client.Function.OpenMenu()
	if RageUI.CurrentMenu ~= nil then
		return
	end
	if not Client.OpenMenuStart then
		Client.OpenMenuStart = GetGameTimer()
	end
	Client.OpenMenuPressedTime = GetGameTimer() - Client.OpenMenuStart
	if Client.OpenMenuPressedTime >= 250 then
		RageUI.Visible(Client.Menu.Main, not RageUI.Visible(Client.Menu.Main))
		Audio.PlaySound(RageUI.Settings.Audio.Back.audioName, RageUI.Settings.Audio.Back.audioRef)
		if Client.IsInRace and Client.Preference.SimulateAltF4 then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
			if vehicle > 0 then
				SetVehicleForwardSpeed(vehicle, 0.0)
			end
		end
		Client.Noclip.Enable = false
		Client.OpenMenuStart = nil
		Client.OpenMenuPressedTime = nil
	end
end

function Client.Function.StartMainThread()
	CreateThread(function()
		while true do
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			local vehicle = GetVehiclePedIsIn(ped, false)
			local pressable = true

			SetPedConfigFlag(ped, 35, false)
			SetPedConfigFlag(ped, 422, Client.Preference.DisableMotoMelee and vehicle > 0 and GetVehicleClassFromName(GetEntityModel(vehicle)) == 8 and true or false)
			SetPedInfiniteAmmoClip(ped, Client.Preference.InfiniteAmmo)

			if not Client.IsInRace and not Client.IsInCreator then
				local player = PlayerId()
				if IsEntityDead(ped) or IsPlayerDead(player) then
					local heading = GetEntityHeading(ped)
					NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, heading, true, false)
					SetEntityHealth(ped, 200)
				end
				SetEntityInvincible(ped, true)
				SetPedArmour(ped, 100)
				SetPlayerCanDoDriveBy(player, true)
				SetSwimMultiplierForPlayer(player, (vehicle > 0 or not Client.Ped.Config.FastSwim) and 1.0 or 1.49)
				SetRunSprintMultiplierForPlayer(player, (vehicle > 0 or not Client.Ped.Config.FastRun) and 1.0 or 1.49)
				if vehicle > 0 then
					if not Client.Noclip.Enable then
						SetEntityInvincible(vehicle, Client.Preference.KeepVehicleInvincible and true or false)
					end
					Client.Ped.Status.WasDoingBeastJump = false
				else
					if Client.Ped.Config.SuperJump then
						SetSuperJumpThisFrame(player)
					end
					if Client.Ped.Config.BeastMode then
						SetBeastModeActive(player)
						Client.Ped.Status.IsJumping = IsPedDoingBeastJump(ped)
						Client.Ped.Status.IsFalling = IsPedFalling(ped)
						if Client.Ped.Status.IsJumping and not Client.Ped.Status.WasJumping then
							Client.Ped.Status.WasDoingBeastJump = true
							PlaySoundFromEntity(-1, "Beast_Jump", ped, "DLC_AR_Beast_Soundset", true, 60)
						end
						if not Client.Ped.Status.IsFalling and Client.Ped.Status.WasFalling and Client.Ped.Status.WasDoingBeastJump then
							Client.Ped.Status.WasDoingBeastJump = false
							PlaySoundFromEntity(-1, "Beast_Jump_Land", ped, "DLC_AR_Beast_Soundset", true, 60)
						end
						Client.Ped.Status.WasJumping = Client.Ped.Status.IsJumping
						Client.Ped.Status.WasFalling = Client.Ped.Status.IsFalling
					end
				end
			end

			if Client.Preference.FixBmxFloat and vehicle > 0 and Client.Vehicle.Model.BMX[GetEntityModel(vehicle)] and not Client.IsTeleportingInProgress then
				local velocity = GetEntityVelocity(vehicle)
				local currentTime = GetGameTimer()
				if Client.Vehicle.Fix.LastBmxHandle == vehicle and Client.Vehicle.Fix.LastBmxJumpTime and currentTime - Client.Vehicle.Fix.LastBmxJumpTime < 1000 and velocity.z > 0.0 and velocity.z < 2e-5 and velocity.z < Client.Vehicle.Fix.LastBmxVelocityZ then
					Client.Vehicle.Fix.LastBmxJumpTime = nil
					SetEntityVelocity(vehicle, velocity.x, velocity.y, 0.0)
				end
				if Client.Vehicle.Fix.LastBmxHandle ~= vehicle then
					Client.Vehicle.Fix.LastBmxHandle = vehicle
					Client.Vehicle.Fix.LastBmxJumpTime = nil
				end
				if IsControlJustReleased(0, 102) then
					Client.Vehicle.Fix.LastBmxJumpTime = currentTime
				end
				Client.Vehicle.Fix.LastBmxVelocityZ = velocity.z
			else
				Client.Vehicle.Fix.LastBmxHandle = nil
				Client.Vehicle.Fix.LastBmxJumpTime = nil
				Client.Vehicle.Fix.LastBmxVelocityZ = 0.0
			end

			if not IsPauseMenuActive() then
				SetInstancePriorityHint(Client.Preference.EnableOnlineMap and 4 or 0)
			end

			if not Client.IsTeleportingInProgress then
				Client.Ped.Status.Visible = IsEntityVisible(ped)
			end

			if not Client.IsInCreator then
				if (IsNuiFocused() and not Client.NUI.Picker.Enable and Client.NUI.Callback == "") or IsPauseMenuActive() or IsPlayerSwitchInProgress() or Client.IsInSpectator then
					RageUI.CloseAll()
					pressable = false
				end
			else
				pressable = false
			end

			if IsControlPressed(0, 244) and pressable then
				Client.Function.OpenMenu()
			else
				Client.OpenMenuStart = nil
				Client.OpenMenuPressedTime = nil
			end

			if RageUI.CurrentMenu ~= nil and not Client.IsInCreator then
				DrawScaleformMovieFullscreen(Client.Function.Scaleform.Update("instructional_buttons", "client"))
				Client.IsAnyClientMenuVisible = true
			else
				if Client.IsAnyClientMenuVisible then
					Client.IsAnyClientMenuVisible = false
					Client.Vehicle.Preview.Model = nil
					Client.Vehicle.Preview.Props = nil
					Client.Function.Control.DisableActionsWhenQuitMenu()
				end
			end

			if IsNuiFocused() then
				if Client.NUI.Picker.Enable and not RageUI.Visible(Client.Menu.Vehicle.Custom.Respray) then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "close color picker"
					})
					Client.NUI.Picker.Enable = false
					Client.NUI.Picker.Primary = false
					Client.NUI.Picker.Secondary = false
				end
				if ((Client.NUI.Callback == "spawn vehicle by model name" or Client.NUI.Callback == "spawn vehicle by plate") and not RageUI.Visible(Client.Menu.Spawn.Main)) or (Client.NUI.Callback == "plate text" and not RageUI.Visible(Client.Menu.Vehicle.Custom.Main)) or (Client.NUI.Callback == "skin import" and not RageUI.Visible(Client.Menu.Ped.Skin.Main)) or (Client.NUI.Callback == "ped model filter" and not RageUI.Visible(Client.Menu.Ped.Animal) and not RageUI.Visible(Client.Menu.Ped.AddOn)) then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "input off"
					})
					Client.NUI.Callback = ""
				end
				if Client.NUI.Callback ~= "" and not IsUsingKeyboard() and IsDisabledControlJustPressed(0, 255) and not (Client.IsInCreator and Creator.GlobalVar.Lock) then
					SendNUIMessage({
						action = "accept controller"
					})
				end
			end

			if Client.Vehicle.Tuning.DoorOpened and not RageUI.Visible(Client.Menu.Vehicle.Custom.Main) and not RageUI.Visible(Client.Menu.Vehicle.Custom.BodyPart) then
				if DoesEntityExist(Client.Vehicle.Tuning.Entity) then
					SetVehicleDoorsShut(Client.Vehicle.Tuning.Entity, false)
				end
				Client.Vehicle.Tuning.DoorOpened = false
			end

			Wait(0)
		end
	end)
end