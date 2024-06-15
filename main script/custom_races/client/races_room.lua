RegisterNetEvent("custom_races:hereIsTheVehicle")
RegisterNetEvent("custom_races:LoadIndividualVehicle")
RegisterNetEvent("custom_races:raceHasStarted")
RegisterNetEvent("custom_races:raceHasEnded")
RegisterNetEvent("custom_races:hostleaverace")
RegisterNetEvent("custom_races:hostdropped")

local isRacing = false
local cantAccpetInvite = false
local canLeavingRace = false
local vueltas = 1
local weather = "EXTRASUNNY"
local time = {hour = 12, minute = 0, second = 0}
local weapons = {}
vehicle = {}

AddEventHandler('custom_races:loadrace', function()
	cantAccpetInvite = true
	canLeavingRace = true
end)

AddEventHandler('custom_races:unloadrace', function()
	Citizen.Wait(5000)
	cantAccpetInvite = false
end)

AddEventHandler('custom_races:canleavingrace', function()
	canLeavingRace = false
end)

function GetWeapons()
	local weaponsList = {
		"WEAPON_ANIMAL", "WEAPON_COUGAR", "WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB", "WEAPON_CROWBAR", "WEAPON_PISTOL",
		"WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_ASSAULTSMG", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE",
		"WEAPON_ADVANCEDRIFLE", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN",
		"WEAPON_STUNGUN", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_REMOTESNIPER", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG",
		"WEAPON_PASSENGER_ROCKET", "WEAPON_AIRSTRIKE_ROCKET", "WEAPON_STINGER", "WEAPON_MINIGUN", "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_SMOKEGRENADE",
		"WEAPON_BZGAS", "WEAPON_MOLOTOV", "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_DIGISCANNER", "WEAPON_BRIEFCASE", "WEAPON_BRIEFCASE_02", "WEAPON_BALL",
		"WEAPON_FLARE", "WEAPON_", "WEAPON_BARBED_WIRE", "WEAPON_DROWNING", "WEAPON_BLEEDING", "WEAPON_ELECTRIC_FENCE", "WEAPON_EXPLOSION",
		"WEAPON_FALL", "WEAPON_EXHAUSTION", "WEAPON_HIT_BY_WATER_CANNON", "WEAPON_RAMMED_BY_CAR", "WEAPON_RUN_OVER_BY_CAR", "WEAPON_HELI_CRASH", "WEAPON_FIRE",
		"WEAPON_SNSPISTOL", "WEAPON_BOTTLE", "WEAPON_GUSENBERG", "WEAPON_SPECIALCARBINE", "WEAPON_HEAVYPISTOL", "WEAPON_BULLPUPRIFLE", "WEAPON_DAGGER", "WEAPON_VINTAGEPISTOL",
		"WEAPON_FIREWORK", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_MARKSMANRIFLE", "WEAPON_HOMINGLAUNCHER", "WEAPON_PROXMINE", "WEAPON_SNOWBALL", "WEAPON_FLAREGUN",
		"WEAPON_GARBAGEBAG", "WEAPON_HANDCUFFS", "WEAPON_COMBATPDW", "WEAPON_MARKSMANPISTOL", "WEAPON_KNUCKLE", "WEAPON_HATCHET", "WEAPON_RAILGUN", "WEAPON_MACHETE",
		"WEAPON_MACHINEPISTOL", "WEAPON_AIR_DEFENCE_GUN", "WEAPON_SWITCHBLADE", "WEAPON_REVOLVER", "WEAPON_DBSHOTGUN", "WEAPON_COMPACTRIFLE", "WEAPON_AUTOSHOTGUN",
		"WEAPON_BATTLEAXE", "WEAPON_COMPACTLAUNCHER", "WEAPON_MINISMG", "WEAPON_PIPEBOMB", "WEAPON_POOLCUE", "WEAPON_WRENCH", "GADGET_NIGHTVISION", "GADGET_PARACHUTE",
		"GRENADE", "GRENADELAUNCHER", "STICKYBOMB", "MOLOTOV", "ROCKET", "TANKSHELL", "HI_OCTANE", "CAR", "PLANE", "PETROL_PUMP", "BIKE", "DIR_STEAM", "DIR_FLAME",
		"DIR_WATER_HYDRANT", "DIR_GAS_CANISTER", "BOAT", "SHIP_DESTROY", "TRUCK", "BULLET", "SMOKEGRENADELAUNCHER", "SMOKEGRENADE", "BZGAS", "FLARE", "GAS_CANISTER",
		"EXTINGUISHER", "PROGRAMMABLEAR", "TRAIN", "BARREL", "PROPANE", "BLIMP", "DIR_FLAME_EXPLODE", "TANKER", "PLANE_ROCKET", "GAS_TANK", "FIREWORK", "SNOWBALL",
		"PROXMINE", "VALKYRIE_CANNON",
	}
	local playerPed = PlayerPedId()

	weapons = {}

	for i=1, #weaponsList do
		if HasPedGotWeapon(playerPed, weaponsList[i], false) then
			table.insert(weapons, weaponsList[i])
		end
	end
end

function GetCarAndModifications(crr)
	local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), crr or false)
	vehicle = {}

	if playerVehicle == 0 then return end
	vehicle = ESX.Game.GetVehicleProperties(playerVehicle)

	return vehicle
end

AddEventHandler("custom_races:hereIsTheVehicle", function(_vehicle, name, source)
	if source then
		IdRace = source
	end
	SendNUIMessage({
		action = "clientStartRace"
	})
	vehicle = _vehicle
end)

AddEventHandler("custom_races:LoadIndividualVehicle", function()
	GetCarAndModifications(true)
end)

AddEventHandler("custom_races:raceHasStarted", function()
	isRacing = true
	EndCam2()
end)

AddEventHandler("custom_races:raceHasEnded", function()
	isRacing = false
end)

AddEventHandler("custom_races:hostleaverace", function()
	if GetCurrentLanguage() == 12 then
		ESX.ShowNotification("主持人退出了游戏，比赛即将终止")
	else
		ESX.ShowNotification("The host has exited the race and the race will be terminated.")
	end
end)

AddEventHandler("custom_races:hostdropped", function()
	if GetCurrentLanguage() == 12 then
		ESX.ShowNotification("主持人离开了服务器，比赛即将终止")
	else
		ESX.ShowNotification("The host has left the server and the race will be terminated.")
	end
end)

RegisterNUICallback('cerrarMenu', function(data, cb)
	SetNuiFocus(false)
	StopScreenEffect("MenuMGIn")
	SwitchInPlayer(PlayerPedId())
	EndCam()
	cb('ok')
end)

RegisterNUICallback('habilitar-raton', function(data)
	SetNuiFocus(true, true)
end)

RegisterCommand('quitmenu', function()
	if GetResourceState("custom_races") == "started" then
		status = exports["custom_races"]:hasStartRace()
	end

	if status ~= "freemode" then
		while IsControlPressed(0, 200) or IsDisabledControlPressed(0, 200) do
			Citizen.Wait(0)
			DisableControlAction(0, 200, true)
		end
		DisableControlAction(0, 200, true)
		if status == "racing" and not IsPauseMenuActive() and canLeavingRace then
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

RegisterCommand('checkinvitations', function()
	if not cantAccpetInvite then
		if IsNuiFocused() then return end
		SendNUIMessage({
			action = "openNotificaciones"
		})
		SetNuiFocus(true, true)
	else
		if GetCurrentLanguage() == 12 then
			ESX.ShowNotification("退出本场比赛才能接受下一场比赛的邀请")
		else
			ESX.ShowNotification("You need to quit this race before accepting an invitation to the next race.")
		end
	end
end)

RegisterNetEvent('custom_races:client:sendInvitation', function(src, nick, nameRace)
	Citizen.Wait(1000)
	if GetCurrentLanguage() == 12 then
		ESX.ShowNotification("按F7接受邀请")
	else
		ESX.ShowNotification("Press F7 to accept the invitation.")
	end
	SendNUIMessage({
		action = "receiveInvitationClient",
		data = {
			src = src,
			nick = nick,
			nameRace = nameRace
		}
	})
end)

RegisterNUICallback('acceptInvitationPlayer', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:acceptInvitation', src)
end)

RegisterNUICallback('denyInvitation', function(data)
	local src = tonumber(json.encode(data.src))
	TriggerServerEvent('custom_races:server:denyInvitation', src)
	SetNuiFocus(false)
end)

RegisterNetEvent("custom_races:hostLeaveRoom", function()
	if GetCurrentLanguage() == 12 then
		ESX.ShowNotification("房间不存在")
	else
		ESX.ShowNotification("Room does not exist.")
	end
end)

RegisterNetEvent('custom_races:client:joinRace', function(players, invitations, maxplayers, nameRace, data)
	SendNUIMessage({
		action = "joinPlayerRoom",
		data = data,
		players = players,
		invitations = invitations,
		playercount = #players ..  "/" .. maxplayers,
		nameRace = nameRace
	})
	JoinRacePoint = GetEntityCoords(PlayerPedId())
	JoinRaceHeading = GetEntityHeading(PlayerPedId())
	SwitchOutPlayer(PlayerPedId(), 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent('custom_races:client:joinPlayerLobby', function(players, invitations, maxplayers, nameRace, data)
	SendNUIMessage({
		action = "joinPlayerLobby",
		data = data,
		players = players,
		invitations = invitations,
		playercount = #players ..  "/" .. maxplayers,
		nameRace = nameRace
	})
	JoinRacePoint = GetEntityCoords(PlayerPedId())
	JoinRaceHeading = GetEntityHeading(PlayerPedId())
	SwitchOutPlayer(PlayerPedId(), 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
end)

RegisterNetEvent('custom_races:client:SyncPlayerList', function(players, invitations, maxplayers)
	SendNUIMessage({
		action = "updatePlayersRoom",
		players = players,
		invitations = invitations,
		playercount = #players ..  "/" .. maxplayers
	})
end)

RegisterKeyMapping('quitmenu', 'Quit race', 'keyboard', 'ESCAPE')
RegisterKeyMapping('checkinvitations', 'Check your invitations', 'keyboard', 'F7')

RegisterNUICallback('new-race', function(data, cb)
	TriggerServerEvent('custom_races:server:createRace', data)
	JoinRacePoint = GetEntityCoords(PlayerPedId())
	JoinRaceHeading = GetEntityHeading(PlayerPedId())
	SwitchOutPlayer(PlayerPedId(), 0, 1)
	StartScreenEffect("MenuMGIn", 1, true)
	cb({nick = GetPlayerName(PlayerId()), src = GetPlayerServerId(PlayerId())})
end)

RegisterNUICallback('start-race', function(data, cb)
	TriggerServerEvent("custom_races:server:sendVehicle", vehicle)
	Citizen.Wait(500)
	TriggerServerEvent("custom_races:server:LoadEveryIndividualVehicles")
	TriggerServerEvent('custom_races:server:startRace', vehicle)
	cb('ok')
end)

RegisterNUICallback('listarPlayersInvitar', function(data, cb)
	ESX.TriggerServerCallback('custom_races:callback:getPlayerList',function(playerList)
		cb(playerList)
	end)
end)

RegisterNUICallback('invitarPlayer', function(data)
	TriggerServerEvent('custom_races:server:invitePlayer', data)
end)

RegisterNUICallback('kickPlayer', function(data, cb)
	TriggerServerEvent('custom_races:kickPlayer', data.player)
end)

RegisterNUICallback('cancelInvi', function(data, cb)
	TriggerServerEvent('custom_races:cancelInvi', data)
end)

RegisterNUICallback('leaveRoom', function(data, cb)
	TriggerServerEvent('custom_races:leaveRoom', data.roomid)
end)

RegisterNetEvent('custom_races:client:exitRoom', function(kicked)
	SendNUIMessage({
		action = "exitRoom",
		kicked = kicked
	})
end)

RegisterNUICallback('raceList', function(data, cb)
	ESX.TriggerServerCallback('custom_races:raceList', function(result)
		cb(result)
	end)
end)

RegisterNetEvent('custom_races:client:removeinvitation', function(roomid)
	SendNUIMessage({
		action = "removeInvitation",
		roomid = roomid
	})
end)

RegisterNUICallback('joinRoom', function(data)
	TriggerServerEvent('custom_races:server:joinPublicLobby', data.src)
end)

RegisterNetEvent('custom_races:client:maxplayersinvitation', function(roomid)
	SendNUIMessage({
		action = "maxplayersinvitation",
		roomid = roomid
	})
end)

RegisterNetEvent('custom_races:client:maxplayerspubliclobby', function(roomid)
	SendNUIMessage({
		action = "maxplayerspubliclobby",
		roomid = roomid
	})
end)

RegisterNUICallback("leaveRace", function()
	ExecuteCommand("leaverace")
end)

-- Other Scripts
AddEventHandler('racemenu:opened', function()
	cantAccpetInvite = true
end)

AddEventHandler('racemenu:closed', function()
	cantAccpetInvite = false
end)

AddEventHandler("DarkRP_Racing:Loadmap", function()
	cantAccpetInvite = true
end)

AddEventHandler("DarkRP_Racing:Unloadmap", function()
	cantAccpetInvite = false
end)