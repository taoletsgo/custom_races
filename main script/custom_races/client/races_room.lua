--- Register key mapping for quitting the race
RegisterKeyMapping('quitmenu', 'Quit race', 'keyboard', Config.QuitRaceKey)

--- Command to handle opening the quit menu
RegisterCommand('quitmenu', function()
	if status ~= "freemode" then
		while IsControlPressed(0, 200) or IsDisabledControlPressed(0, 200) do
			Citizen.Wait(0)
			DisableControlAction(0, 200, true)
		end
		DisableControlAction(0, 200, true)

		-- Check if player is racing or spectating and if the pause menu is not active
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

--- Event handler to receive room ID
--- @param roomId number The room ID received from the server
RegisterNetEvent("custom_races:client:roomId", function(roomId)
	roomServerId = roomId
end)

--- Event handler to receive an invitation
--- @param roomId number The ID of the room inviting the player
--- @param nickname string The nickname of the player who sent the invitation
--- @param nameRace string The name of the race associated with the invitation
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

--- Event handler to remove an invitation
--- @param roomId number The ID of the room whose invitation is to be removed
RegisterNetEvent('custom_races:client:removeinvitation', function(roomId)
	SendNUIMessage({
		action = "nui_msg:removeInvitation",
		roomid = roomId
	})
end)

--- Event handler for room not found
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

--- Event handler for joining a race from invitation
--- @param players table List of players in the race
--- @param invitations table List of invitations
--- @param maxplayers number Maximum number of players allowed in the race
--- @param nameRace string Name of the race
--- @param data table Additional data related to the race
--- @param bool boolean Determine whether the race is waiting (true) or has started (false)
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

--- Event handler for joining a race from lobby
--- @param players table List of players in the race
--- @param invitations table List of invitations
--- @param maxplayers number Maximum number of players allowed in the race
--- @param nameRace string Name of the race
--- @param data table Additional data related to the race
--- @param bool boolean Determine whether the race is waiting (true) or has started (false)
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

--- Event handler for maximum players in a race room
RegisterNetEvent('custom_races:client:maxplayers', function()
	SendNUIMessage({
		action = "nui_msg:showNoty",
		message = GetTranslate("msg-room-full")
	})

	-- Reset UI focus and state
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())

	-- Update the race list
	TriggerServerCallback('custom_races:server:getRaceList', function(result)
		SendNUIMessage({
			action = "nui_msg:updateRaceList",
			result = result
		})
	end)
	while IsPlayerSwitchInProgress() do Citizen.Wait(0) end
	SetNuiFocus(false)
end)

--- Event handler for exiting the room (be kicked or host left)
--- @param _str string How to exit this room
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

--- Event handler for synchronizing the player list
--- @param players table List of players in the room
--- @param invitations table List of invitations
--- @param maxplayers number Maximum number of players allowed in the room
--- @param _gameTimer number The game timer in server
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

--- Event handler for starting count down 3 2 1
RegisterNetEvent("custom_races:client:countDown", function()
	SendNUIMessage({
		action = "nui_msg:countDown"
	})
	EndCam2()
end)

--- NUI callback for creating a new race
--- @param data table Information about the new race
--- @param cb function Callback function to send data back to the NUI
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

--- NUI callback to list players for invitation
--- @param data table Data from NUI
--- @param cb function Callback function to send player list back to the NUI
RegisterNUICallback('custom_races:nui:getPlayerList', function(data, cb)
	TriggerServerCallback('custom_races:server:getPlayerList',function(playerList)
		cb(playerList)
	end)
end)

--- NUI callback to invite a player
--- @param data table Player data for invitation
RegisterNUICallback('custom_races:nui:invitePlayer', function(data)
	TriggerServerEvent('custom_races:server:invitePlayer', data)
end)

--- NUI callback to cancel an invitation
--- @param data table Data for cancellation
RegisterNUICallback('custom_races:nui:cancelInvitation', function(data)
	TriggerServerEvent('custom_races:server:cancelInvitation', data)
end)

--- NUI callback to kick a player from the race
--- @param data table Data containing player information to kick
RegisterNUICallback('custom_races:nui:kickPlayer', function(data)
	TriggerServerEvent('custom_races:server:kickPlayer', data.player)
end)

--- NUI callback to accept an invitation
--- @param data table Data containing invitation information
RegisterNUICallback('custom_races:nui:acceptInvitation', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:acceptInvitation', src)
end)

--- NUI callback to deny an invitation
--- @param data table Data containing invitation information
RegisterNUICallback('custom_races:nui:denyInvitation', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:denyInvitation', src)
end)

--- NUI callback for joining a room form public lobby
--- @param data table Contains information about the room to join
RegisterNUICallback('custom_races:nui:joinPublicRoom', function(data)
	TriggerServerEvent('custom_races:server:joinPublicRoom', data.src)
	TriggerServerCallback('custom_races:server:getRaceList', function(result)
		SendNUIMessage({
			action = "nui_msg:updateRaceList",
			result = result
		})
	end)
end)

--- NUI callback for leaving a room
--- @param cb function Callback function to send data back to the NUI
RegisterNUICallback('custom_races:nui:leaveRoom', function(data, cb)
	cb({last_data = races_data_front})
	TriggerServerEvent('custom_races:server:leaveRoom', roomServerId)
end)

--- NUI callback for starting a race
RegisterNUICallback('custom_races:nui:startRace', function()
	TriggerServerEvent("custom_races:server:startRace")
end)

--- NUI callback for leaving a race
RegisterNUICallback("custom_races:nui:leaveRace", function()
	LeaveRace()
end)

--- NUI callback for enable spectator mode
RegisterNUICallback("custom_races:nui:joinSpectator", function()
	EnableSpecMode()
end)

--- NUI callback for retrieving the race list
--- @param data table Contains any additional data for the callback (not used here)
--- @param cb function Callback function to send the result back to the NUI
RegisterNUICallback('custom_races:nui:getRaceList', function(data, cb)
	TriggerServerCallback('custom_races:server:getRaceList', function(result)
		cb(result)
	end)
end)

--- NUI callback for closing the menu
--- @param data table Contains any additional data for the callback (not used here)
RegisterNUICallback('custom_races:nui:closeMenu', function(data)
	Citizen.Wait(300)
	SetNuiFocus(false)
	if status == "freemode" then
		StopScreenEffect("MenuMGIn")
		SwitchInPlayer(PlayerPedId())
		EndCam()
	end
end)

--- NUI callback for closing the NUI focus
--- @param data table Contains any additional data for the callback (not used here)
RegisterNUICallback('custom_races:nui:closeNUI', function(data)
	Citizen.Wait(300)
	SetNuiFocus(false)
end)