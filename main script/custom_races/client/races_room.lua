local cantAccpetInvite = false

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
				action = "openMenu",
				races_data_front = races_data_front,
				inrace = true
			})
			SetNuiFocus(true, true)
		end
	end
end)

--- Register key mapping for checking invitations
RegisterKeyMapping('checkinvitations', 'Check your invitations', 'keyboard', Config.CheckInvitationKey)

--- Command to handle checking invitations
RegisterCommand('checkinvitations', function()
	if not cantAccpetInvite then
		if IsNuiFocused() then return end
		SendNUIMessage({
			action = "openNotifications"
		})
		SetNuiFocus(true, true)
	else
		local message = ""
		if GetCurrentLanguage() == 12 then
			message = "退出本场比赛才能接受邀请"
		else
			message = "You need to quit this race before accepting an invitation"
		end
		SendNUIMessage({
			action = "showNoty",
			message = message
		})
	end
end)

--- Event handler to handle race loading
AddEventHandler('custom_races:loadrace', function()
	cantAccpetInvite = true
end)

--- Event handler to handle race unloading
AddEventHandler('custom_races:unloadrace', function()
	Citizen.Wait(5000)
	cantAccpetInvite = false
end)

--- Event handler to receive room ID
--- @param roomId number The room ID received from the server
RegisterNetEvent("custom_races:hereIsRoomId", function(roomId)
	roomServerId = roomId
end)

--- Event handler to receive an invitation
--- @param roomId number The ID of the room inviting the player
--- @param nickname string The nickname of the player who sent the invitation
--- @param nameRace string The name of the race associated with the invitation
RegisterNetEvent('custom_races:client:receiveInvitation', function(roomId, nickname, nameRace)
	local message = ""
	if GetCurrentLanguage() == 12 then
		message = "按F7接受邀请"
	else
		message = "Press F7 to accept the invitation"
	end
	SendNUIMessage({
		action = "showNoty",
		message = message
	})
	SendNUIMessage({
		action = "receiveInvitationClient",
		data = {
			roomid = roomId,
			nickname = nickname,
			nameRace = nameRace
		}
	})
end)

--- Event handler to remove an invitation
--- @param roomId number The ID of the room whose invitation is to be removed
RegisterNetEvent('custom_races:client:removeinvitation', function(roomId)
	SendNUIMessage({
		action = "removeInvitation",
		roomid = roomId
	})
end)

--- Event handler for room not found
RegisterNetEvent("custom_races:RoomNull", function()
	local message = ""
	if GetCurrentLanguage() == 12 then
		message = "房间不存在"
	else
		message = "Room does not exist"
	end
	SendNUIMessage({
		action = "showNoty",
		message = message
	})
	SetNuiFocus(false)
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	inMenu = false
end)

--- Event handler for joining a race from invitation
--- @param players table List of players in the race
--- @param invitations table List of invitations
--- @param maxplayers number Maximum number of players allowed in the race
--- @param nameRace string Name of the race
--- @param data table Additional data related to the race
--- @param bool boolean Determine whether the race is waiting (true) or has started (false)
RegisterNetEvent('custom_races:client:joinRace', function(players, invitations, maxplayers, nameRace, data, bool)
	SendNUIMessage({
		action = "joinPlayerRoom",
		data = data,
		players = players,
		invitations = invitations,
		playercount = #players ..  "/" .. maxplayers,
		nameRace = nameRace,
		bool = bool
	})
	local ped = PlayerPedId()
	JoinRacePoint = GetEntityCoords(ped)
	JoinRaceHeading = GetEntityHeading(ped)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

--- Event handler for joining a race from looby
--- @param players table List of players in the race
--- @param invitations table List of invitations
--- @param maxplayers number Maximum number of players allowed in the race
--- @param nameRace string Name of the race
--- @param data table Additional data related to the race
--- @param bool boolean Determine whether the race is waiting (true) or has started (false)
RegisterNetEvent('custom_races:client:joinPlayerLobby', function(players, invitations, maxplayers, nameRace, data, bool)
	SendNUIMessage({
		action = "joinPlayerLobby",
		data = data,
		players = players,
		invitations = invitations,
		playercount = #players ..  "/" .. maxplayers,
		nameRace = nameRace,
		bool = bool
	})
	local ped = PlayerPedId()
	JoinRacePoint = GetEntityCoords(ped)
	JoinRaceHeading = GetEntityHeading(ped)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

--- Event handler for maximum players in a race invitation
--- @param nameRace string Name of the race
RegisterNetEvent('custom_races:client:maxplayersinvitation', function(nameRace)
	local message = ""
	if GetCurrentLanguage() == 12 then
		message = "比赛房间满员 ("..nameRace..")"
	else
		message = "The room is full ("..nameRace..")"
	end
	SendNUIMessage({
		action = "showNoty",
		message = message
	})

	-- Reset UI focus and state
	SetNuiFocus(false)
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	inMenu = false

	-- Update the race list
	TriggerServerCallbackFunction('custom_races:raceList', function(result)
		SendNUIMessage({
			action = "updateRaceList",
			result = result
		})
	end)
end)

--- Event handler for maximum players in a public lobby
--- @param nameRace string Name of the race
RegisterNetEvent('custom_races:client:maxplayerspubliclobby', function(nameRace)
	local message = ""
	if GetCurrentLanguage() == 12 then
		message = "比赛房间满员 ("..nameRace..")"
	else
		message = "The room is full ("..nameRace..")"
	end
	SendNUIMessage({
		action = "showNoty",
		message = message
	})

	-- Reset UI focus and state
	SetNuiFocus(false)
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	inMenu = false

	-- Update the race list
	TriggerServerCallbackFunction('custom_races:raceList', function(result)
		SendNUIMessage({
			action = "updateRaceList",
			result = result
		})
	end)
end)

--- Event handler for exiting the room (be kicked or host left)
RegisterNetEvent('custom_races:client:exitRoom', function()
	SendNUIMessage({
		action = "exitRoom",
		syncData = races_data_front,
		hostLeaveRoom = true
	})
end)

--- Event handler for synchronizing the player list
--- @param players table List of players in the room
--- @param invitations table List of invitations
--- @param maxplayers number Maximum number of players allowed in the room
RegisterNetEvent('custom_races:client:SyncPlayerList', function(players, invitations, maxplayers)
	SendNUIMessage({
		action = "updatePlayersRoom",
		players = players,
		invitations = invitations,
		playercount = #players ..  "/" .. maxplayers
	})
end)

--- Event handler for starting countdown 3 2 1
RegisterNetEvent("custom_races:clientStartRace", function()
	SendNUIMessage({
		action = "clientStartRace"
	})
	EndCam2()
end)

--- NUI callback for creating a new race
--- @param data table Information about the new race
--- @param cb function Callback function to send data back to the NUI
RegisterNUICallback('new-race', function(data, cb)
	SetNuiFocus(false)
	TriggerServerEvent('custom_races:server:createRace', data)
	local ped = PlayerPedId()
	JoinRacePoint = GetEntityCoords(ped)
	JoinRaceHeading = GetEntityHeading(ped)
	SwitchOutPlayer(ped, 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	cb({nick = GetPlayerName(PlayerId()), src = GetPlayerServerId(PlayerId())})
	Citizen.Wait(3000)
	SetNuiFocus(true, true)
end)

--- NUI callback to list players for invitation
--- @param data table Data from NUI
--- @param cb function Callback function to send player list back to the NUI
RegisterNUICallback('listPlayersInvite', function(data, cb)
	TriggerServerCallbackFunction('custom_races:callback:getPlayerList',function(playerList)
		cb(playerList)
	end)
end)

--- NUI callback to invite a player
--- @param data table Player data for invitation
RegisterNUICallback('invitePlayer', function(data)
	TriggerServerEvent('custom_races:server:invitePlayer', data)
end)

--- NUI callback to cancel an invitation
--- @param data table Data for cancellation
RegisterNUICallback('cancelInvi', function(data)
	TriggerServerEvent('custom_races:cancelInvi', data)
end)

--- NUI callback to kick a player from the race
--- @param data table Data containing player information to kick
RegisterNUICallback('kickPlayer', function(data)
	TriggerServerEvent('custom_races:kickPlayer', data.player)
end)

--- NUI callback to accept an invitation
--- @param data table Data containing invitation information
RegisterNUICallback('acceptInvitationPlayer', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:acceptInvitation', src)
end)

--- NUI callback to deny an invitation
--- @param data table Data containing invitation information
RegisterNUICallback('denyInvitation', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:denyInvitation', src)
end)

--- NUI callback for joining a race form public lobby
--- @param data table Contains information about the room to join
RegisterNUICallback('joinRoom', function(data)
	TriggerServerEvent('custom_races:server:joinPublicLobby', data.src)
	TriggerServerCallbackFunction('custom_races:raceList', function(result)
		SendNUIMessage({
			action = "updateRaceList",
			result = result
		})
	end)
end)

--- NUI callback for leaving a room
RegisterNUICallback('leaveRoom', function()
	TriggerServerEvent('custom_races:leaveRoom', roomServerId)
end)

--- NUI callback for starting a race
RegisterNUICallback('start-race', function()
	TriggerServerEvent("custom_races:ownerStartRace")
end)

--- NUI callback for leaving a race
RegisterNUICallback("leaveRace", function()
	LeaveRace()
end)

--- NUI callback for retrieving the race list
--- @param data table Contains any additional data for the callback (not used here)
--- @param cb function Callback function to send the result back to the NUI
RegisterNUICallback('raceList', function(data, cb)
	TriggerServerCallbackFunction('custom_races:raceList', function(result)
		cb(result)
	end)
end)

--- NUI callback for closing the menu
--- @param data table Contains any additional data for the callback (not used here)
RegisterNUICallback('closeMenu', function(data)
	SetNuiFocus(false)
	if status == "freemode" then
		StopScreenEffect("MenuMGIn")
		SwitchInPlayer(PlayerPedId())
		EndCam()
	end
end)

--- NUI callback for closing the NUI focus
--- @param data table Contains any additional data for the callback (not used here)
RegisterNUICallback('CloseNUI', function(data)
	SetNuiFocus(false)
end)