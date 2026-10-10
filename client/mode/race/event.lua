RegisterNetEvent("client:race:info", function(str, data)
	if str == "data-outdated" then
		Race.Track.DataOutdated = true
	elseif str == "track-list" and data and data.len then
		if Client.Busyspinner.Status == "load" then
			Client.Function.Busyspinner.Display("load", 65536, data.len)
		end
	elseif str == "track-download" and data and data.len then
		if Race.Status == "freemode" then
			Client.Function.Busyspinner.Display("download", 65536, data.len)
		end
		if not data.joinMidway then
			Race.Cache.InRoom = false
			SendNUIMessage({
				action = "count down"
			})
		end
		Wait(5000)
		StopScreenEffect("MenuMGIn")
		SendNUIMessage({
			action = "hide loading"
		})
	elseif str == "msg-join-room" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-join-room")
		})
	elseif str == "msg-join-race" and data and data.name then
		SendNUIMessage({
			action = "show notification",
			message = string.format(Client.Function.Translate.Get("msg-join-race"), data.name)
		})
	elseif str == "msg-left-race" and data and data.name then
		SendNUIMessage({
			action = "show notification",
			message = string.format(Client.Function.Translate.Get("msg-left-race"), data.name)
		})
	elseif str == "msg-drop-server" and data and data.name then
		SendNUIMessage({
			action = "show notification",
			message = string.format(Client.Function.Translate.Get("msg-drop-server"), data.name)
		})
	elseif str == "a-spectate-b" and data and data.nameA and data.nameB then
		Client.Function.Message.Display_2(string.format(Client.Function.Translate.Get("msg-spectate"), data.nameA, data.nameB), false, nil)
	end
end)

RegisterNetEvent("client:race:startRace", function()
	while Race.EnableXboxController do Wait(0) end
	RemoveLoadingPrompt()
	Client.Busyspinner.Status = nil
	Race.Function.Start()
end)

RegisterNetEvent("client:race:showFinalResult", function()
	if Race.Status == "leaving" or Race.Status == "ending" then return end
	Race.Status = "ending"
	Race.Function.Reset(true)
end)

RegisterNetEvent("client:race:startDNFCountdown", function(roomId)
	SendNUIMessage({
		action = "start dnf countdown",
		endTime = 30000
	})
	Wait(30000)
	while Race.Cache.IsRespawningInProgress or Race.Cache.IsTransformingInProgress or Race.Cache.IsTeleportingInProgress do Wait(0) end
	if Race.Status == "racing" and roomId == Race.Track.Current.RoomId then
		Race.Function.Finish("dnf")
	end
end)

RegisterNetEvent("client:race:syncDrivers", function(drivers, gameTimer)
	if not Client.Time.ServerSide.SyncDrivers or Client.Time.ServerSide.SyncDrivers < gameTimer then
		Client.Time.ServerSide.SyncDrivers = gameTimer
		local _drivers = {}
		local count = 0
		for k, v in pairs(drivers) do
			count = count + 1
			_drivers[v[1]] = {
				playerId = v[1],
				playerName = v[2],
				ping = v[3],
				fps = v[4],
				actualLap = v[5],
				actualCheckpoint = v[6],
				vehicle = v[7],
				lastLap = v[8],
				bestLap = v[9],
				totalRaceTime = v[10],
				totalCheckpointsTouched = v[11],
				lastCheckpointPair = v[12],
				hasFinished = v[13],
				currentCoords = v[14],
				finishCoords = v[15],
				dnf = v[16],
				keyboard = v[17],
				flag = v[18]
			}
		end
		Race.Track.Current.PlayerCount = count
		Race.Track.Current.Drivers = _drivers
	end
end)

RegisterNetEvent("client:race:respawning", function(playerId, playerPing, myPing)
	local time = GetGameTimer()
	if Race.Status == "spectating" and Race.SpectateData.PlayerId == playerId then
		DoScreenFadeOut(0)
		SendNUIMessage({
			action = "fade out",
			time = 0
		})
		Race.SpectateData.IsFadeOut = true
		Race.SpectateData.FadeOutTime = time
	end
	local offset = 0
	local ping = playerPing + myPing
	-- Fixed black screen duration under high latency
	if ping > 250 then
		offset = offset + ping * 2
	end
	Wait(500 + offset)
	if Race.Status == "spectating" and Race.SpectateData.PlayerId == playerId then
		if time == Race.SpectateData.FadeOutTime then
			DoScreenFadeIn(500)
			SendNUIMessage({
				action = "fade in",
				time = 500
			})
			Race.SpectateData.IsFadeOut = false
			Race.SpectateData.FadeOutTime = nil
			SetGameplayCamRelativeHeading(0)
		end
	end
end)

RegisterNetEvent("client:race:syncExplosion", function(index, hash)
	if Race.Status == "racing" or Race.Status == "spectating" then
		for k, v in pairs(Race.ExplodeProps) do
			if k == index and v.hash == hash and not v.exploded and DoesEntityExist(v.handle) then
				v.exploded = true
				FreezeEntityPosition(v.handle, true)
				SetEntityVisible(v.handle, false)
				SetEntityCollision(v.handle, false, false)
				SetEntityCompletelyDisableCollision(v.handle, false, false)
				break
			end
		end
	end
end)

RegisterNetEvent("client:race:syncParticleFx", function(playerId, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
	Wait(100)
	local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
	if playerPed and playerPed ~= 0 and playerPed ~= PlayerPedId() then
		if Race.Status == "spectating" and Race.SpectateData.PlayerId == playerId then
			Client.Function.Shared.PlayEffectAndSound(playerPed, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
		else
			Client.Function.Shared.PlayEffectAndSound(playerPed, -1, effect_2 ~= 0 and effect_2 or -1, vehicleR, vehicleG, vehicleB)
		end
	end
end)

RegisterNetEvent("client:race:enableSpectatorMode", function(raceStatus)
	Wait(1000)
	if Race.Status ~= "waiting" then return end
	TriggerServerEvent("server:core:inSpectator", true)
	Race.Status = "spectating"
	Client.IsInSpectator = true
	Client.Hud.ResetNextFrame = true
	local actionFromUser = (raceStatus == "spectator") and true or false
	local timeOutCount = 0
	CreateThread(function()
		while Race.Status == "spectating" do
			Race.SpectateData.Players = {}
			local driversInfo = Race.Function.Player.GetDriversInfo(Race.Track.Current.Drivers)
			for _, driver in pairs(Race.Track.Current.Drivers) do
				if not driver.hasFinished and driver.playerId ~= Client.ServerId then
					driver.position = Race.Function.Player.GetPosition(driversInfo, driver.playerId)
					driver.flag = driver.flag or "US"
					driver.keyboard = driver.keyboard and "💻" or "🎮"
					table.insert(Race.SpectateData.Players, driver)
				end
			end
			table.sort(Race.SpectateData.Players, function(a, b)
				return a.position < b.position
			end)
			if #Race.SpectateData.Players > 0 then
				local canPlaySound = false
				if Race.SpectateData.PlayerId then
					for k, v in pairs(Race.SpectateData.Players) do
						if Race.SpectateData.PlayerId == v.playerId then
							Race.SpectateData.Index = k
							break
						end
					end
					if Race.SpectateData.Ped and not DoesEntityExist(Race.SpectateData.Ped) then
						Race.SpectateData.PlayerId = nil
					end
				end
				if Race.SpectateData.Players[Race.SpectateData.Index] == nil then
					Race.SpectateData.Index = 1
				end
				if Race.SpectateData.PlayerId ~= Race.SpectateData.Players[Race.SpectateData.Index].playerId then
					DoScreenFadeOut(500)
					SendNUIMessage({
						action = "fade out",
						time = 500
					})
					Race.SpectateData.IsFadeOut = true
					Race.SpectateData.FadeOutTime = GetGameTimer()
					Wait(500)
					canPlaySound = true
					Race.SpectateData.PlayerId = Race.SpectateData.Players[Race.SpectateData.Index].playerId
					Race.SpectateData.Ped = nil
					TriggerServerEvent("server:race:spectatePlayer", Race.SpectateData.PlayerId, actionFromUser)
					actionFromUser = false
				end
				local ped = PlayerPedId()
				SetEntityCoordsNoOffset(ped, Race.SpectateData.Players[Race.SpectateData.Index].currentCoords + vector3(0.0, 0.0, 50.0))
				if not Race.SpectateData.Ped or not NetworkIsInSpectatorMode() then
					Race.SpectateData.Ped = Race.SpectateData.PlayerId and GetPlayerPed(GetPlayerFromServerId(Race.SpectateData.PlayerId))
					if Race.SpectateData.Ped and DoesEntityExist(Race.SpectateData.Ped) and (Race.SpectateData.Ped ~= ped) then
						Race.Function.Camera.Remove()
						NetworkSetInSpectatorMode(true, Race.SpectateData.Ped)
						SetMinimapInSpectatorMode(true, Race.SpectateData.Ped)
						DoScreenFadeIn(500)
						SendNUIMessage({
							action = "fade in",
							time = 500
						})
						Race.SpectateData.IsFadeOut = false
						Race.SpectateData.FadeOutTime = nil
					else
						Race.SpectateData.Ped = nil
					end
				end
				local isFadeOut = Race.SpectateData.IsFadeOut
				local fadeOutTime = Race.SpectateData.FadeOutTime
				if isFadeOut and fadeOutTime and (GetGameTimer() - fadeOutTime > 3000) then
					DoScreenFadeIn(500)
					SendNUIMessage({
						action = "fade in",
						time = 500
					})
					Race.SpectateData.IsFadeOut = false
					Race.SpectateData.FadeOutTime = nil
				end
				local playersPerPage = 10
				local currentPage = math.floor((Race.SpectateData.Index - 1) / playersPerPage) + 1
				local startIdx = (currentPage - 1) * playersPerPage + 1
				local endIdx = math.min(startIdx + playersPerPage - 1, #Race.SpectateData.Players)
				local players = {}
				for i = startIdx, endIdx do
					table.insert(players, Race.SpectateData.Players[i])
				end
				SendNUIMessage({
					action = "show spectate",
					players = players,
					playerId = Race.SpectateData.PlayerId,
					sound = canPlaySound
				})
				timeOutCount = 0
			else
				timeOutCount = timeOutCount + 1
				if timeOutCount >= 5 then
					break
				end
			end
			Wait(500)
		end
		NetworkSetInSpectatorMode(false)
		SetMinimapInSpectatorMode(false)
		SendNUIMessage({
			action = "hide spectate"
		})
		if Race.SpectateData.IsFadeOut then
			DoScreenFadeIn(500)
			SendNUIMessage({
				action = "fade in",
				time = 500
			})
		end
		Race.SpectateData.IsFadeOut = false
		Race.SpectateData.FadeOutTime = nil
		Race.SpectateData.PlayerId = nil
		Race.SpectateData.Ped = nil
		Race.SpectateData.Index = 0
		Race.SpectateData.Players = {}
		TriggerServerEvent("server:core:inSpectator", false)
	end)
	CreateThread(function()
		local spectateLastTotalCheckpointsTouched = nil
		while Race.Status == "spectating" do
			if not IsNuiFocused() and not IsPauseMenuActive() and not IsPlayerSwitchInProgress() then
				DrawScaleformMovieFullscreen(Client.Function.Scaleform.Update("instructional_buttons", "spectator"))
			end
			if IsControlJustPressed(0, 202) --[[Esc/Backspace/B]] then
				ExecuteCommand("leave")
			end
			if #Race.SpectateData.Players >= 2 then
				if IsControlJustPressed(0, 172) --[[Up Arrow]] then
					Race.SpectateData.Index = Race.SpectateData.Index -1
					if Race.SpectateData.Index < 1 or Race.SpectateData.Index > #Race.SpectateData.Players then
						Race.SpectateData.Index = #Race.SpectateData.Players
					end
					Race.SpectateData.PlayerId = nil
					actionFromUser = true
				end
				if IsControlJustPressed(0, 173) --[[Down Arrow]] then
					Race.SpectateData.Index = Race.SpectateData.Index + 1
					if Race.SpectateData.Index > #Race.SpectateData.Players then
						Race.SpectateData.Index = 1
					end
					Race.SpectateData.PlayerId = nil
					actionFromUser= true
				end
			end
			if #Race.SpectateData.Players > 0 then
				local spectateDriverInfo = Race.SpectateData.PlayerId and Race.Track.Current.Drivers[Race.SpectateData.PlayerId]
				if spectateDriverInfo then
					local spectateTotalCheckpointsTouched = spectateDriverInfo.totalCheckpointsTouched
					local spectateActualCheckpoint = spectateDriverInfo.actualCheckpoint
					local spectateActualLap = spectateDriverInfo.actualLap
					local spectateVehicle = GetVehiclePedIsIn(DoesEntityExist(Race.SpectateData.Ped) and Race.SpectateData.Ped or PlayerPedId(), false)
					local spectateCheckpoint = Race.Track.Current.Checkpoints[spectateActualCheckpoint]
					local spectateCheckpoint_2 = Race.Track.Current.Checkpoints_2[spectateActualCheckpoint]
					if spectateCheckpoint and not (spectateActualCheckpoint == #Race.Track.Current.Checkpoints and spectateActualLap == Race.Track.Current.Laps) then
						if spectateCheckpoint.isPlaneRot and spectateCheckpoint.drawId then
							if spectateVehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(spectateCheckpoint, spectateVehicle) then
								local r, g, b = GetHudColour(6)
								SetCheckpointRgba2(spectateCheckpoint.drawId, r, g, b, 150)
							else
								local r, g, b = GetHudColour(134)
								SetCheckpointRgba2(spectateCheckpoint.drawId, r, g, b, 150)
							end
						end
					end
					if spectateCheckpoint_2 and not (spectateActualCheckpoint == #Race.Track.Current.Checkpoints and spectateActualLap == Race.Track.Current.Laps) then
						if spectateCheckpoint_2.isPlaneRot and spectateCheckpoint_2.drawId then
							if spectateVehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(spectateCheckpoint_2, spectateVehicle) then
								local r, g, b = GetHudColour(6)
								SetCheckpointRgba2(spectateCheckpoint_2.drawId, r, g, b, 150)
							else
								local r, g, b = GetHudColour(134)
								SetCheckpointRgba2(spectateCheckpoint_2.drawId, r, g, b, 150)
							end
						end
					end
					if spectateLastTotalCheckpointsTouched ~= spectateTotalCheckpointsTouched then
						Race.Function.ResetCheckpointAndBlip()
						Race.Function.CreateCheckpointBlip(spectateActualCheckpoint, spectateActualLap)
						Race.Function.CreateCheckpoint(spectateActualCheckpoint, false, spectateActualCheckpoint == #Race.Track.Current.Checkpoints and spectateActualLap == Race.Track.Current.Laps)
						Race.Function.CreateCheckpoint(spectateActualCheckpoint, true, spectateActualCheckpoint == #Race.Track.Current.Checkpoints and spectateActualLap == Race.Track.Current.Laps)
					end
					spectateLastTotalCheckpointsTouched = spectateTotalCheckpointsTouched
				end
			else
				if timeOutCount >= 5 then
					break
				end
			end
			Wait(0)
		end
	end)
end)