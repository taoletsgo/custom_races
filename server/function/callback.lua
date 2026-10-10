local serverCallbacks = {}

CreateServerCallback = function(eventName, callback)
	serverCallbacks[eventName] = callback
end

RegisterNetEvent("server:core:callback", function(eventName, requestId, ...)
	if not serverCallbacks[eventName] then return end
	local playerId = tonumber(source)
	local currentPlayer = Server.Players[playerId]
	if not currentPlayer then
		local playerName = GetPlayerName(playerId)
		if playerName then
			currentPlayer = Server.Function.Player.Init(playerId, playerName)
		end
	end
	if currentPlayer then
		serverCallbacks[eventName](currentPlayer, function(...)
			TriggerLatentClientEvent("client:core:callback", currentPlayer.id, 65536, requestId, ...)
		end, ...)
	end
end)