-- copyright @ https://github.com/esx-framework/esx_core/tree/1.10.2

local serverCallbacks = {}

CreateServerCallback = function(eventName, callback)
	serverCallbacks[eventName] = callback
end

RegisterNetEvent('custom_creator:server:callback', function(eventName, requestId, ...)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	if not serverCallbacks[eventName] or not playerName then return end
	serverCallbacks[eventName](playerId, function(...)
		TriggerClientEvent('custom_creator:client:callback', playerId, requestId, ...)
	end, ...)
end)