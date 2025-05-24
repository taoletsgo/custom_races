RegisterKeyMapping('quitmenu', 'Quit race', 'keyboard', Config.QuitRaceKey)
RegisterCommand('quitmenu', function()
	if status ~= "freemode" then
		while IsControlPressed(0, 200) or IsDisabledControlPressed(0, 200) do
			Citizen.Wait(0)
			DisableControlAction(0, 200, true)
		end
		DisableControlAction(0, 200, true)
		if (status == "racing" or status == "spectating") and not IsPauseMenuActive() then
			if IsNuiFocused() then return end
			SendNUIMessage({
				action = "nui_msg:openMenu",
				races_data_front = races_data_front,
				inrace = true,
				needRefresh = dataOutdated
			})
			SetNuiFocus(true, true)
		end
	end
end)

RegisterNetEvent("custom_races:client:roomId", function(roomId)
	roomServerId = roomId
end)

RegisterNetEvent('custom_races:client:receiveInvitation', function(roomId, nickname, nameRace)
	SendNUIMessage({
		action = "nui_msg:showNoty",
		message = GetTranslate("msg-receive-invitation")
	})
	SendNUIMessage({
		action = "nui_msg:receiveInvitation",
		info = {
			roomid = roomId,
			title = nickname .. GetTranslate("invite-title"),
			race = nameRace,
			accept = GetTranslate("invite-accept"),
			cancel = GetTranslate("invite-cancel")
		}
	})
end)

RegisterNetEvent('custom_races:client:removeinvitation', function(roomId)
	SendNUIMessage({
		action = "nui_msg:removeInvitation",
		roomid = roomId
	})
end)

RegisterNetEvent("custom_races:client:roomNull", function()
	SendNUIMessage({
		action = "nui_msg:showNoty",
		message = GetTranslate("msg-room-null")
	})
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	SetNuiFocus(false)
end)

RegisterNetEvent('custom_races:client:joinPlayerRoom', function(players, invitations, maxplayers, nameRace, data, bool)
	inRoom = true
	SendNUIMessage({
		action = "nui_msg:joinPlayerRoom",
		data = data,
		players = players,
		invitations = invitations,
		playercount = #players .. "/" .. maxplayers,
		nameRace = nameRace,
		bool = bool
	})
	local ped = PlayerPedId()
	JoinRacePoint = GetEntityCoords(ped)
	JoinRaceHeading = GetEntityHeading(ped)
	JoinRaceVehicle = GetVehiclePedIsIn(ped, false)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent('custom_races:client:joinPublicRoom', function(players, invitations, maxplayers, nameRace, data, bool)
	inRoom = true
	SendNUIMessage({
		action = "nui_msg:joinPublicRoom",
		data = data,
		players = players,
		invitations = invitations,
		playercount = #players .. "/" .. maxplayers,
		nameRace = nameRace,
		bool = bool
	})
	local ped = PlayerPedId()
	JoinRacePoint = GetEntityCoords(ped)
	JoinRaceHeading = GetEntityHeading(ped)
	JoinRaceVehicle = GetVehiclePedIsIn(ped, false)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent('custom_races:client:maxplayers', function()
	SendNUIMessage({
		action = "nui_msg:showNoty",
		message = GetTranslate("msg-room-full")
	})
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	TriggerServerCallback('custom_races:server:getRaceList', function(result)
		SendNUIMessage({
			action = "nui_msg:updateRaceList",
			result = result
		})
	end)
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	SetNuiFocus(false)
end)

RegisterNetEvent('custom_races:client:exitRoom', function(_str)
	inRoom = false
	while inVehicleUI do Citizen.Wait(0) end
	SendNUIMessage({
		action = "nui_msg:exitRoom",
		syncData = races_data_front,
		boolean = true
	})
	Citizen.Wait(0)
	if _str == "kick" then
		SendNUIMessage({
			action = "nui_msg:showNoty",
			message = GetTranslate("msg-host-kick")
		})
	elseif _str == "leave" then
		SendNUIMessage({
			action = "nui_msg:showNoty",
			message = GetTranslate("msg-host-leave")
		})
	end
end)

RegisterNetEvent('custom_races:client:syncPlayers', function(players, invitations, maxplayers, _gameTimer)
	if not timeServerSide["syncPlayers"] or timeServerSide["syncPlayers"] < _gameTimer then
		timeServerSide["syncPlayers"] = _gameTimer
		SendNUIMessage({
			action = "nui_msg:updatePlayersRoom",
			players = players,
			invitations = invitations,
			playercount = #players .. "/" .. maxplayers
		})
	elseif timeServerSide["syncPlayers"] and timeServerSide["syncPlayers"] == _gameTimer then
		TriggerServerEvent("custom_races:server:re-sync", "syncPlayers")
	end
end)

RegisterNetEvent("custom_races:client:countDown", function()
	SendNUIMessage({
		action = "nui_msg:countDown"
	})
	EndCam2()
end)

RegisterNUICallback('custom_races:nui:createRace', function(data, cb)
	inRoom = true
	TriggerServerEvent('custom_races:server:createRace', data)
	local ped = PlayerPedId()
	JoinRacePoint = GetEntityCoords(ped)
	JoinRaceHeading = GetEntityHeading(ped)
	JoinRaceVehicle = GetVehiclePedIsIn(ped, false)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	cb({nick = GetPlayerName(PlayerId()), src = GetPlayerServerId(PlayerId())})
end)

RegisterNUICallback('custom_races:nui:getPlayerList', function(data, cb)
	TriggerServerCallback('custom_races:server:getPlayerList',function(playerList)
		cb(playerList)
	end)
end)

RegisterNUICallback('custom_races:nui:invitePlayer', function(data)
	TriggerServerEvent('custom_races:server:invitePlayer', data)
end)

RegisterNUICallback('custom_races:nui:cancelInvitation', function(data)
	TriggerServerEvent('custom_races:server:cancelInvitation', data)
end)

RegisterNUICallback('custom_races:nui:kickPlayer', function(data)
	TriggerServerEvent('custom_races:server:kickPlayer', data.player)
end)

RegisterNUICallback('custom_races:nui:acceptInvitation', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:acceptInvitation', src)
end)

RegisterNUICallback('custom_races:nui:denyInvitation', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:denyInvitation', src)
end)

RegisterNUICallback('custom_races:nui:joinPublicRoom', function(data)
	TriggerServerEvent('custom_races:server:joinPublicRoom', data.src)
	TriggerServerCallback('custom_races:server:getRaceList', function(result)
		SendNUIMessage({
			action = "nui_msg:updateRaceList",
			result = result
		})
	end)
end)

RegisterNUICallback('custom_races:nui:leaveRoom', function(data, cb)
	cb({last_data = races_data_front})
	TriggerServerEvent('custom_races:server:leaveRoom', roomServerId)
end)

RegisterNUICallback('custom_races:nui:startRace', function()
	TriggerServerEvent("custom_races:server:startRace")
end)

RegisterNUICallback("custom_races:nui:leaveRace", function()
	LeaveRace()
end)

RegisterNUICallback("custom_races:nui:joinSpectator", function()
	EnableSpecMode()
end)

RegisterNUICallback('custom_races:nui:getRaceList', function(data, cb)
	TriggerServerCallback('custom_races:server:getRaceList', function(result)
		cb(result)
	end)
end)

RegisterNUICallback('custom_races:nui:closeMenu', function(data)
	Citizen.Wait(300)
	SetNuiFocus(false)
	if status == "freemode" then
		StopScreenEffect("MenuMGIn")
		SwitchInPlayer(PlayerPedId())
		EndCam()
	end
end)

RegisterNUICallback('custom_races:nui:closeNUI', function(data)
	Citizen.Wait(300)
	SetNuiFocus(false)
end)