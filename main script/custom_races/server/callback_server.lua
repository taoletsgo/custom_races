-- copyright @ https://github.com/esx-framework/esx_core/tree/1.10.2

local serverCallbacks = {}

CreateServerCallback = function(eventName, callback)
	serverCallbacks[eventName] = callback
end

RegisterNetEvent('custom_races:server:callback', function(eventName, requestId, ...)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	if not serverCallbacks[eventName] or not playerName then return end
	serverCallbacks[eventName]({src = playerId, name = playerName}, function(...)
		TriggerClientEvent('custom_races:client:callback', playerId, requestId, ...)
	end, ...)
end)