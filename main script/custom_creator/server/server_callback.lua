-- copyright @ https://github.com/esx-framework/esx_core/tree/1.10.2

local serverCallbacks = {}

CreateServerCallback = function(eventName, callback)
	serverCallbacks[eventName] = callback
end

RegisterNetEvent("custom_creator:server:callback", function(eventName, requestId, ...)
	local playerId = tonumber(source)
	local playerName = GetPlayerName(playerId)
	if not serverCallbacks[eventName] or not playerName then return end
	serverCallbacks[eventName]({src = playerId, name = playerName}, function(...)
		TriggerClientEvent("custom_creator:client:callback", playerId, requestId, ...)
	end, ...)
end)

local RequestId = 0
local clientRequests = {}

TriggerClientCallback = function(player, eventName, callback, ...)
	clientRequests[RequestId] = callback
	TriggerClientEvent("custom_creator:client:callback_2", player, eventName, RequestId, ...)
	RequestId = RequestId + 1
end

RegisterNetEvent("custom_creator:server:callback_2", function(requestId, ...)
	if not clientRequests[requestId] then end
	clientRequests[requestId](...)
	clientRequests[requestId] = nil
end)