function Client.Function.HUD.Toggle()
	CreateThread(function()
		local enableVanillaMinimap = Client.Preference.EnableVanillaMinimap
		local hasShowRedbox = false
		local hasShowRadar = true
		local hasShowMinimap = false
		local hasShowHelp = false
		local hasShowInfo = false
		local language = nil
		local defaultAspectRatio = 1920 / 1080
		local resolutionX, resolutionY = GetActiveScreenResolution()
		local aspectRatio = resolutionX / resolutionY
		local minimapXOffset = 0.0
		if aspectRatio > defaultAspectRatio then
			local aspectDifference = defaultAspectRatio - aspectRatio
			minimapXOffset = aspectDifference / 3.52
		end
		local minimap = RequestScaleformMovie("minimap")
		while not HasScaleformMovieLoaded(minimap) do Wait(0) end
		DisplayRadar(true)
		--[[
		<minimap v="1.0">
			<data name="minimap"			alignX="L"		alignY="B"		posX="-0.0045"		posY="0.002"		sizeX="0.150"		sizeY="0.188888" /> <!-- WARNING! Feed MUST match posX and PosY -->
			<data name="minimap_mask"		alignX="L"		alignY="B"		posX="0.020"		posY="0.032"		sizeX="0.111"		sizeY="0.159" />
			<data name="minimap_blur"		alignX="L"		alignY="B"		posX="-0.03"		posY="0.022"		sizeX="0.266"		sizeY="0.237" />
			<data name="bigmap"				alignX="L"		alignY="B"		posX="-0.003975"	posY="0.022"		sizeX="0.364"		sizeY="0.460416666" />
			<data name="bigmap_mask"		alignX="L"		alignY="B"		posX="0.145"		posY="0.015"		sizeX="0.176"		sizeY="0.395" />
			<data name="bigmap_blur"		alignX="L"		alignY="B"		posX="-0.019"		posY="0.022"		sizeX="0.262"		sizeY="0.464" />
			<data name="pausemap"			alignX="I"		alignY="I"		posX="0.0"			posY="0.0"			sizeX="1.0"			sizeY="1.0" />
			<data name="pausemap_mask"		alignX="I"		alignY="I"		posX="0.161"		posY="0.22"			sizeX="0.679"		sizeY="0.598"/>
			<data name="gallery"			alignX="I"		alignY="I"		posX="0.492180"		posY="0.222"		sizeX="0.471875"	sizeY="0.599" />
			<data name="gallery_mask"		alignX="I"		alignY="I"		posX="0.697"		posY="0.222"		sizeX="0.178"		sizeY="0.599" />
			<data name="golf_courses"		alignX="L"		alignY="B"		posX="0.003"		posY="-0.038"		sizeX="0.27375"		sizeY="0.347" />
		</minimap>
		]]
		SetMinimapComponentPosition("minimap", "L", "B", -0.0045 + minimapXOffset, enableVanillaMinimap and 0.002 or -0.0060, 0.150, enableVanillaMinimap and 0.188888 or 0.3542)
		SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020 + minimapXOffset, enableVanillaMinimap and 0.032 or 0.001, 0.111, enableVanillaMinimap and 0.159 or 0.3542)
		SetMinimapComponentPosition("minimap_blur", "L", "B", -0.030 + minimapXOffset, enableVanillaMinimap and 0.022 or 0.050, 0.266, enableVanillaMinimap and 0.237 or 0.466)
		SetMinimapComponentPosition("bigmap", "L", "B", -0.003975 + minimapXOffset, 0.022, 0.364, 0.460416666)
		SetMinimapComponentPosition("bigmap_mask", "L", "B", 0.145 + minimapXOffset, 0.015, 0.176, 0.395)
		SetMinimapComponentPosition("bigmap_blur", "L", "B", -0.019 + minimapXOffset, 0.022, 0.262, 0.464)
		SetRadarBigmapEnabled(true, false)
		Wait(0)
		SetRadarBigmapEnabled(false, false)
		Wait(0)
		Client.Hud.Loaded = true
		while true do
			if not IsBigmapActive() then
				SetRadarZoom(1200)
				local _resolutionX, _resolutionY = GetActiveScreenResolution()
				if resolutionX ~= _resolutionX or resolutionY ~= _resolutionY or enableVanillaMinimap ~= Client.Preference.EnableVanillaMinimap then
					resolutionX = _resolutionX
					resolutionY = _resolutionY
					enableVanillaMinimap = Client.Preference.EnableVanillaMinimap
					CreateThread(function()
						aspectRatio = resolutionX / resolutionY
						minimapXOffset = 0.0
						if aspectRatio > defaultAspectRatio then
							local aspectDifference = defaultAspectRatio - aspectRatio
							minimapXOffset = aspectDifference / 3.52
						end
						minimap = RequestScaleformMovie("minimap")
						while not HasScaleformMovieLoaded(minimap) or IsPauseMenuActive() do Wait(0) end
						SetMinimapComponentPosition("minimap", "L", "B", -0.0045 + minimapXOffset, enableVanillaMinimap and 0.002 or -0.0060, 0.150, enableVanillaMinimap and 0.188888 or 0.3542)
						SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020 + minimapXOffset, enableVanillaMinimap and 0.032 or 0.001, 0.111, enableVanillaMinimap and 0.159 or 0.3542)
						SetMinimapComponentPosition("minimap_blur", "L", "B", -0.030 + minimapXOffset, enableVanillaMinimap and 0.022 or 0.050, 0.266, enableVanillaMinimap and 0.237 or 0.466)
						SetMinimapComponentPosition("bigmap", "L", "B", -0.003975 + minimapXOffset, 0.022, 0.364, 0.460416666)
						SetMinimapComponentPosition("bigmap_mask", "L", "B", 0.145 + minimapXOffset, 0.015, 0.176, 0.395)
						SetMinimapComponentPosition("bigmap_blur", "L", "B", -0.019 + minimapXOffset, 0.022, 0.262, 0.464)
						SetRadarBigmapEnabled(true, false)
						Wait(0)
						SetRadarBigmapEnabled(false, false)
					end)
				end
			end
			if not hasShowRedbox then
				if (math.abs(GetSafeZoneSize() - 0.9899999499321) > 1e-10) and not Client.Preference.EnableVanillaMinimap then
					language = Client.CurrentLanguage
					SendNUIMessage({
						action = "redbox on",
						safezone = Client.Function.Translate.Get("hud-redbox-on")
					})
					hasShowRedbox = true
				end
			else
				if (math.abs(GetSafeZoneSize() - 0.9899999499321) <= 1e-10) or Client.Preference.EnableVanillaMinimap then
					SendNUIMessage({
						action = "redbox off"
					})
					hasShowRedbox = false
				else
					if language ~= Client.CurrentLanguage then
						language = Client.CurrentLanguage
						SendNUIMessage({
							action = "redbox on",
							safezone = Client.Function.Translate.Get("hud-redbox-on")
						})
					end
				end
			end
			if not hasShowRadar then
				if not IsPauseMenuActive() and not IsPlayerSwitchInProgress() and not Client.IsCreatorInQuiting then
					DisplayRadar(true)
					hasShowRadar = true
				end
			else
				if IsPauseMenuActive() or IsPlayerSwitchInProgress() or Client.IsCreatorInQuiting then
					DisplayRadar(false)
					hasShowRadar = false
				end
			end
			if not hasShowMinimap then
				if not IsBigmapActive() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() and not Client.IsCreatorInQuiting and not Client.Preference.EnableVanillaMinimap then
					SendNUIMessage({
						action = "minimap on"
					})
					hasShowMinimap = true
				end
			else
				if IsBigmapActive() or IsPauseMenuActive() or IsPlayerSwitchInProgress() or Client.IsCreatorInQuiting or Client.Preference.EnableVanillaMinimap then
					SendNUIMessage({
						action = "minimap off"
					})
					hasShowMinimap = false
				end
			end
			if not hasShowHelp then
				if not IsBigmapActive() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() and not Client.IsCreatorInQuiting and not Client.Preference.EnableVanillaMinimap then
					SendNUIMessage({
						action = "help on"
					})
					hasShowHelp = true
				end
			else
				if IsBigmapActive() or IsPauseMenuActive() or IsPlayerSwitchInProgress() or Client.IsCreatorInQuiting or Client.Preference.EnableVanillaMinimap then
					SendNUIMessage({
						action = "help off"
					})
					hasShowHelp = false
				end
			end
			if not hasShowInfo then
				if not Client.IsAnyClientMenuVisible and not Client.IsInCreator and not Client.Hud.DisableInfoUINextFrame then
					SendNUIMessage({
						action = "info on"
					})
					hasShowInfo = true
				end
			else
				if Client.IsAnyClientMenuVisible or Client.IsInCreator then
					SendNUIMessage({
						action = "info off"
					})
					hasShowInfo = false
				end
			end
			if not Client.Preference.EnableVanillaMinimap then
				BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
				ScaleformMovieMethodAddParamInt(3)
				EndScaleformMovieMethod()
			end
			Wait(0)
		end
	end)
end

function Client.Function.HUD.Minimap()
	CreateThread(function()
		local hour = nil
		local minute = nil
		local ping = nil
		local record = nil
		local language = nil
		while true do
			if (hour ~= Client.Time.CurrentHour) or (minute ~= Client.Time.CurrentMinute) or (ping ~= Client.Hud.Data.Ping) or (record ~= IsRecording()) or (language ~= Client.CurrentLanguage) then
				hour = Client.Time.CurrentHour
				minute = Client.Time.CurrentMinute
				ping = Client.Hud.Data.Ping
				record = IsRecording()
				language = Client.CurrentLanguage
				SendNUIMessage({
					action = "minimap data",
					time = "⏱️" .. (hour < 10 and "0" or "") .. hour .. ":" .. (minute < 10 and "0" or "") .. minute,
					ping = string.format(Client.Function.Translate.Get("hud-minimap-ping"), ping),
					bottom = record and Client.Function.Translate.Get("hud-minimap-bottom-record") or Client.Function.Translate.Get("hud-minimap-bottom")
				})
			end
			Wait(0)
		end
	end)
end

function Client.Function.HUD.Help()
	CreateThread(function()
		local keyboard = nil
		local language = nil
		while true do
			if (language ~= Client.CurrentLanguage) or (keyboard ~= IsUsingKeyboard()) or Client.Hud.ResetNextFrame then
				Client.Hud.ResetNextFrame = false
				language = Client.CurrentLanguage
				keyboard = IsUsingKeyboard()
				local tips = {}
				if Client.IsInCreator then
					tips = {
						{button = "T", tip = Client.Function.Translate.Get("hud-help-button-t")}
					}
				else
					if Client.IsInRace then
						if Client.IsInSpectator then
							tips = {
								{button = "T", tip = Client.Function.Translate.Get("hud-help-button-t")}
							}
						else
							tips = {
								{button = "T", tip = Client.Function.Translate.Get("hud-help-button-t")},
								{button = keyboard and "M" or "⏹️", tip = Client.Function.Translate.Get("hud-help-button-m")},
								{button = keyboard and "Z" or "🔽", tip = Client.Function.Translate.Get("hud-help-button-z")}
							}
						end
					else
						tips = {
							{button = "T", tip = Client.Function.Translate.Get("hud-help-button-t")},
							{button = keyboard and "M" or "⏹️", tip = Client.Function.Translate.Get("hud-help-button-m")}
						}
					end
				end
				SendNUIMessage({
					action = "help data",
					tips = tips
				})
			end
			Wait(0)
		end
	end)
end

function Client.Function.HUD.Info()
	CreateThread(function()
		while true do
			SendNUIMessage({
				action = "info data",
				logo = Client.Hud.Data.Logo,
				name = Client.Hud.Data.Name,
				discord = Client.Hud.Data.Discord,
				web = Client.Hud.Data.Web,
				welcome = Client.Function.Translate.Get("hud-info-welcome"),
				players = "🕹️" .. Client.Hud.Data.Count .. "/48",
				fps = "💻" .. Client.Function.Math.RoundedValue(1.0 / GetFrameTime()) .. "FPS"
			})
			Wait(2000)
		end
	end)
end

function Client.Function.HUD.Race()
	CreateThread(function()
		while true do
			local currentTime = GetGameTimer()
			if IsPauseMenuActive() or Client.IsChatInputActive or (Client.Busyspinner.Status and Client.Busyspinner.Status ~= "wait") then
				Client.Hud.Race.LastInTopTime = currentTime
			end
			if not IsPauseMenuActive() and not Client.IsChatInputActive and not Client.Busyspinner.Status then
				if Client.Hud.Race.LastInTopTime and currentTime - Client.Hud.Race.LastInTopTime > 50 then
					Client.Hud.Race.LastInTopTime = nil
				end
			end
			if Client.Hud.LastUpdateScaleformTime and currentTime - Client.Hud.LastUpdateScaleformTime > 50 then
				Client.Hud.LastUpdateScaleformTime = nil
			end
			if (not Client.Hud.Race.LastInTopTime and not Client.Hud.LastUpdateScaleformTime) or Client.Preference.EnableVanillaMinimap then
				if not Client.Hud.Race.InBottom then
					SendNUIMessage({
						action = "adjust hud",
						bottom = "0.8vh"
					})
					Client.Hud.Race.InTop = false
					Client.Hud.Race.InBottom = true
				end
			else
				if not Client.Hud.Race.InTop then
					SendNUIMessage({
						action = "adjust hud",
						bottom = "4.5vh"
					})
					Client.Hud.Race.InTop = true
					Client.Hud.Race.InBottom = false
				end
			end
			Wait(0)
		end
	end)
end

function Client.Function.HUD.HideComponents()
	CreateThread(function()
		while true do
			local hide = {}
			hide[1] = true
			if Client.IsWeaponMenuVisible then
				hide[2] = true
			end
			hide[3] = true
			hide[4] = true
			hide[6] = true
			hide[7] = true
			hide[8] = true
			hide[9] = true
			hide[13] = true
			if Client.IsInRace then
				if Race.Status == "racing" then
					hide[6] = true
					hide[7] = true
					hide[8] = true
					hide[9] = true
				end
				if Race.Status == "spectating" then
					hide[2] = true
					hide[14] = true
					hide[19] = true
				end
			end
			for component, _ in pairs(hide) do
				HideHudComponentThisFrame(component)
			end
			Wait(0)
		end
	end)
end

function Client.Function.HUD.Speedometer()
	CreateThread(function()
		while true do
			local vehicle = GetVehiclePedIsIn(Client.IsInSpectator and Race.SpectateData.Ped and DoesEntityExist(Race.SpectateData.Ped) and Race.SpectateData.Ped or PlayerPedId(), false)
			if not IsPauseMenuActive() and not IsPlayerSwitchInProgress() and not Client.IsCreatorInQuiting and vehicle > 0 then
				local useMiles = not (GetProfileSetting(227) == 1) and true or false
				local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
				local _, _, highBeam = GetVehicleLightsState(vehicle)
				SendNUIMessage({
					action = "show speedometer",
					useMiles = useMiles,
					speed = GetEntitySpeed(vehicle) * (useMiles and 2.236936 or 3.6),
					maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle) * (useMiles and 2.236936 or 3.6),
					fuel = GetVehicleFuelLevel(vehicle),
					hasMotor = maxFuel >= 5.0,
					electric = GetIsVehicleElectric(GetEntityModel(vehicle)) and true or false,
					maxFuel = maxFuel,
					highBeam = highBeam,
					engine = GetIsVehicleEngineRunning(vehicle),
					seatBelt = false
				})
			else
				SendNUIMessage({
					action = "hide speedometer"
				})
			end
			Wait(vehicle > 0 and 0 or 100)
		end
	end)
end