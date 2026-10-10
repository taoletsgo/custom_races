RegisterNetEvent("client:race:receiveInvitation", function(roomId, playerName, roomName)
	while not Client.NUI.Loaded do Wait(0) end
	SendNUIMessage({
		action = "receive invitation",
		info = {
			roomId = roomId,
			title = string.format(Client.Function.Translate.Get("invite-title"), playerName),
			name = roomName,
			accept = Client.Function.Translate.Get("invite-accept"),
			cancel = Client.Function.Translate.Get("invite-cancel")
		}
	})
end)

RegisterNetEvent("client:race:removeinvitation", function(roomId)
	while not Client.NUI.Loaded do Wait(0) end
	SendNUIMessage({
		action = "remove invitation",
		roomId = roomId
	})
end)

RegisterNetEvent("client:race:joinPlayerRoom", function(data, bool)
	Race.Cache.InRoom = true
	SendNUIMessage({
		action = "join player room",
		data = data,
		bool = bool
	})
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped, false)
	Race.Cache.JoinPoint = GetEntityCoords(ped)
	Race.Cache.JoinHeading = GetEntityHeading(ped)
	if DoesEntityExist(veh) then
		Race.Cache.JoinVehicleNetId = NetworkGetNetworkIdFromEntity(veh)
		SetVehicleForwardSpeed(veh, 0.0)
	else
		Race.Cache.JoinVehicleNetId = nil
	end
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent("client:race:joinPublicRoom", function(data, bool)
	Race.Cache.InRoom = true
	SendNUIMessage({
		action = "join public room",
		data = data,
		bool = bool
	})
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped, false)
	Race.Cache.JoinPoint = GetEntityCoords(ped)
	Race.Cache.JoinHeading = GetEntityHeading(ped)
	if DoesEntityExist(veh) then
		Race.Cache.JoinVehicleNetId = NetworkGetNetworkIdFromEntity(veh)
		SetVehicleForwardSpeed(veh, 0.0)
	else
		Race.Cache.JoinVehicleNetId = nil
	end
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent("client:race:joinRoomFailed", function(str)
	if str == "race-loading" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-race-loading")
		})
	elseif str == "room-null" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-room-null")
		})
	elseif str == "room-full" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-room-full")
		})
		TriggerServerCallback("server:race:getRoomList", function(result)
			SendNUIMessage({
				action = "update room list",
				result = result
			})
		end)
	end
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	while IsPlayerSwitchInProgress() do Wait(0) end
	Race.EnableXboxController = false
end)

RegisterNetEvent("client:race:exitRoom", function(str)
	Race.Cache.InRoom = false
	while Race.Cache.InVehicleUI do Wait(0) end
	SendNUIMessage({
		action = "exit room",
		trackData = Race.Track.Data
	})
	Wait(0)
	if str == "kick" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-host-kick")
		})
	elseif str == "leave" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-host-leave")
		})
	elseif str == "file-not-exist" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-file-not-exist")
		})
	elseif str == "file-not-valid" then
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-file-not-valid")
		})
	end
end)

RegisterNetEvent("client:race:syncPlayers", function(players, invitations, maxPlayers, vehicle, gameTimer)
	if not Client.Time.ServerSide.SyncPlayers or Client.Time.ServerSide.SyncPlayers < gameTimer then
		Client.Time.ServerSide.SyncPlayers = gameTimer
		for k, v in pairs(players) do
			v.vehicle = v.vehicle and GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle)):gsub("µ", " ")
		end
		local _invitations = {}
		for k, v in pairs(invitations) do
			table.insert(_invitations, v)
		end
		SendNUIMessage({
			action = "update room players",
			players = players,
			invitations = _invitations,
			playerCount = #players .. "/" .. maxPlayers,
			vehicle = vehicle
		})
	end
end)

RegisterNUICallback("createRace", function(data, cb)
	Race.Cache.InRoom = true
	TriggerServerEvent("server:race:createRace", data)
	local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped, false)
	Race.Cache.JoinPoint = GetEntityCoords(ped)
	Race.Cache.JoinHeading = GetEntityHeading(ped)
	if DoesEntityExist(veh) then
		Race.Cache.JoinVehicleNetId = NetworkGetNetworkIdFromEntity(veh)
		SetVehicleForwardSpeed(veh, 0.0)
	else
		Race.Cache.JoinVehicleNetId = nil
	end
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNUICallback("getPlayerList", function(data, cb)
	TriggerServerCallback("server:race:getPlayerList", function(playerList)
		cb(playerList)
	end)
end)

RegisterNUICallback("invitePlayer", function(data, cb)
	TriggerServerEvent("server:race:invitePlayer", data.player)
end)

RegisterNUICallback("cancelInvitation", function(data, cb)
	TriggerServerEvent("server:race:cancelInvitation", data.player)
end)

RegisterNUICallback("kickPlayer", function(data, cb)
	TriggerServerEvent("server:race:kickPlayer", data.player)
end)

RegisterNUICallback("acceptInvitation", function(data, cb)
	TriggerServerEvent("server:race:acceptInvitation", data.src)
end)

RegisterNUICallback("denyInvitation", function(data, cb)
	TriggerServerEvent("server:race:denyInvitation", data.src)
end)

RegisterNUICallback("joinPublicRoom", function(data, cb)
	TriggerServerEvent("server:race:joinPublicRoom", data.src)
	TriggerServerCallback("server:race:getRoomList", function(result)
		SendNUIMessage({
			action = "update room list",
			result = result
		})
	end)
end)

RegisterNUICallback("roomLoaded", function(data, cb)
	TriggerServerEvent("server:race:roomLoaded")
end)

RegisterNUICallback("leaveRoom", function(data, cb)
	TriggerServerEvent("server:race:leaveRoom")
end)

RegisterNUICallback("startRace", function(data, cb)
	TriggerServerEvent("server:race:startRace")
end)

RegisterNUICallback("leaveRace", function(data, cb)
	if (Race.Status == "racing" and not Race.Cache.IsRespawningInProgress and not Race.Cache.IsTransformingInProgress and not Race.Cache.IsTeleportingInProgress) or Race.Status == "spectating" then
		Race.Status = "leaving"
		SendNUIMessage({
			action = "hide race hud"
		})
		TriggerServerEvent("server:race:leaveRace")
		Race.Function.Reset(false)
	end
end)

RegisterNUICallback("joinSpectator", function(data, cb)
	if Race.Status == "racing" and not Race.Cache.IsRespawningInProgress and not Race.Cache.IsTransformingInProgress and not Race.Cache.IsTeleportingInProgress then
		Race.Function.Finish("spectator")
	end
end)

RegisterNUICallback("getRoomList", function(data, cb)
	TriggerServerCallback("server:race:getRoomList", function(result)
		cb(result)
	end)
end)

RegisterNUICallback("closeMenu", function(data, cb)
	Wait(300)
	if Race.Status == "freemode" then
		StopScreenEffect("MenuMGIn")
		SwitchInPlayer(PlayerPedId())
	end
	while IsPlayerSwitchInProgress() do Wait(0) end
	Race.EnableXboxController = false
end)

RegisterNUICallback("closeNUI", function(data, cb)
	Wait(300)
	Race.EnableXboxController = false
end)