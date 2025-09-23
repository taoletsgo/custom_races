-- copyright @ https://github.com/esx-framework/esx_core/tree/1.10.2

local RequestId = 0
local serverRequests = {}

TriggerServerCallback = function(eventName, callback, ...)
	serverRequests[RequestId] = callback
	TriggerServerEvent("custom_creator:server:callback", eventName, RequestId, ...)
	RequestId = RequestId + 1
end

RegisterNetEvent("custom_creator:client:callback", function(requestId, ...)
	if not serverRequests[requestId] then return end
	serverRequests[requestId](...)
	serverRequests[requestId] = nil
end)

local clientCallbacks = {}

CreateClientCallback = function(eventName, callback)
	clientCallbacks[eventName] = callback
end

RegisterNetEvent("custom_creator:client:callback_2", function(eventName, requestId, ...)
	if not clientCallbacks[eventName] then return end
	clientCallbacks[eventName](function(...)
		TriggerServerEvent("custom_creator:server:callback_2", requestId, ...)
	end, ...)
end)