RegisterNetEvent("custom_races:client:receiveInvitation", function(roomId, nickname, name)
	while not hasNUILoaded do Citizen.Wait(0) end
	SendNUIMessage({
		action = "nui_msg:receiveInvitation",
		info = {
			roomid = roomId,
			title = nickname .. GetTranslate("invite-title"),
			name = name,
			accept = GetTranslate("invite-accept"),
			cancel = GetTranslate("invite-cancel")
		}
	})
end)

RegisterNetEvent("custom_races:client:removeinvitation", function(roomId)
	while not hasNUILoaded do Citizen.Wait(0) end
	SendNUIMessage({
		action = "nui_msg:removeInvitation",
		roomid = roomId
	})
end)

RegisterNetEvent("custom_races:client:roomNull", function()
	SendNUIMessage({
		action = "nui_msg:showNotification",
		message = GetTranslate("msg-room-null")
	})
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	enableXboxController = false
end)

RegisterNetEvent("custom_races:client:joinPlayerRoom", function(data, bool)
	inRoom = true
	SendNUIMessage({
		action = "nui_msg:joinPlayerRoom",
		data = data,
		bool = bool
	})
	local ped = PlayerPedId()
	joinRacePoint = GetEntityCoords(ped)
	joinRaceHeading = GetEntityHeading(ped)
	joinRaceVehicle = GetVehiclePedIsIn(ped, false)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent("custom_races:client:joinPublicRoom", function(data, bool)
	inRoom = true
	SendNUIMessage({
		action = "nui_msg:joinPublicRoom",
		data = data,
		bool = bool
	})
	local ped = PlayerPedId()
	joinRacePoint = GetEntityCoords(ped)
	joinRaceHeading = GetEntityHeading(ped)
	joinRaceVehicle = GetVehiclePedIsIn(ped, false)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent("custom_races:client:maxplayers", function()
	SendNUIMessage({
		action = "nui_msg:showNotification",
		message = GetTranslate("msg-room-full")
	})
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	TriggerServerCallback("custom_races:server:getRoomList", function(result)
		SendNUIMessage({
			action = "nui_msg:updateRoomList",
			result = result
		})
	end)
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	enableXboxController = false
end)

RegisterNetEvent("custom_races:client:exitRoom", function(_str)
	inRoom = false
	while inVehicleUI do Citizen.Wait(0) end
	SendNUIMessage({
		action = "nui_msg:exitRoom",
		races_data_front = races_data_front
	})
	Citizen.Wait(0)
	if _str == "kick" then
		SendNUIMessage({
			action = "nui_msg:showNotification",
			message = GetTranslate("msg-host-kick")
		})
	elseif _str == "leave" then
		SendNUIMessage({
			action = "nui_msg:showNotification",
			message = GetTranslate("msg-host-leave")
		})
	elseif _str == "file-not-exist" then
		SendNUIMessage({
			action = "nui_msg:showNotification",
			message = GetTranslate("msg-file-not-exist")
		})
	elseif _str == "file-not-valid" then
		SendNUIMessage({
			action = "nui_msg:showNotification",
			message = GetTranslate("msg-file-not-valid")
		})
	end
end)

RegisterNetEvent("custom_races:client:syncPlayers", function(players, invitations, maxplayers, vehicle, _gameTimer)
	if not timeServerSide["syncPlayers"] or timeServerSide["syncPlayers"] < _gameTimer then
		timeServerSide["syncPlayers"] = _gameTimer
		for k, v in pairs(players) do
			v.vehicle = v.vehicle and GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle)):gsub("µ", " ")
		end
		SendNUIMessage({
			action = "nui_msg:updatePlayersRoom",
			players = players,
			invitations = invitations,
			playercount = #players .. "/" .. maxplayers,
			vehicle = vehicle
		})
	end
end)

RegisterNetEvent("custom_races:client:countDown", function()
	SendNUIMessage({
		action = "nui_msg:countDown"
	})
	EndCam2()
end)

RegisterNUICallback("custom_races:nui:createRace", function(data, cb)
	inRoom = true
	TriggerServerEvent("custom_races:server:createRace", data)
	local ped = PlayerPedId()
	joinRacePoint = GetEntityCoords(ped)
	joinRaceHeading = GetEntityHeading(ped)
	joinRaceVehicle = GetVehiclePedIsIn(ped, false)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNUICallback("custom_races:nui:getPlayerList", function(data, cb)
	TriggerServerCallback("custom_races:server:getPlayerList",function(playerList)
		cb(playerList)
	end)
end)

RegisterNUICallback("custom_races:nui:invitePlayer", function(data, cb)
	TriggerServerEvent("custom_races:server:invitePlayer", data.player)
end)

RegisterNUICallback("custom_races:nui:cancelInvitation", function(data, cb)
	TriggerServerEvent("custom_races:server:cancelInvitation", data.player)
end)

RegisterNUICallback("custom_races:nui:kickPlayer", function(data, cb)
	TriggerServerEvent("custom_races:server:kickPlayer", data.player)
end)

RegisterNUICallback("custom_races:nui:acceptInvitation", function(data, cb)
	TriggerServerEvent("custom_races:server:acceptInvitation", data.src)
end)

RegisterNUICallback("custom_races:nui:denyInvitation", function(data, cb)
	TriggerServerEvent("custom_races:server:denyInvitation", data.src)
end)

RegisterNUICallback("custom_races:nui:joinPublicRoom", function(data, cb)
	TriggerServerEvent("custom_races:server:joinPublicRoom", data.src)
	TriggerServerCallback("custom_races:server:getRoomList", function(result)
		SendNUIMessage({
			action = "nui_msg:updateRoomList",
			result = result
		})
	end)
end)

RegisterNUICallback("custom_races:nui:roomLoaded", function(data, cb)
	TriggerServerEvent("custom_races:server:roomLoaded")
end)

RegisterNUICallback("custom_races:nui:leaveRoom", function(data, cb)
	TriggerServerEvent("custom_races:server:leaveRoom")
end)

RegisterNUICallback("custom_races:nui:startRace", function(data, cb)
	TriggerServerEvent("custom_races:server:startRace")
end)

RegisterNUICallback("custom_races:nui:leaveRace", function(data, cb)
	LeaveRace()
end)

RegisterNUICallback("custom_races:nui:joinSpectator", function(data, cb)
	EnableSpecMode()
end)

RegisterNUICallback("custom_races:nui:getRoomList", function(data, cb)
	TriggerServerCallback("custom_races:server:getRoomList", function(result)
		cb(result)
	end)
end)

RegisterNUICallback("custom_races:nui:closeMenu", function(data, cb)
	Citizen.Wait(300)
	if status == "freemode" then
		StopScreenEffect("MenuMGIn")
		SwitchInPlayer(PlayerPedId())
		EndCam()
	end
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	enableXboxController = false
end)

RegisterNUICallback("custom_races:nui:closeNUI", function(data, cb)
	Citizen.Wait(300)
	enableXboxController = false
end)