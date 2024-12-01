-- copyright @ https://github.com/esx-framework/esx_core/tree/1.10.2

local RequestId = 0
local serverRequests = {}

TriggerServerCallback = function(eventName, callback, ...)
	serverRequests[RequestId] = callback

	TriggerServerEvent('custom_races:server:callback', eventName, RequestId, ...)

	RequestId = RequestId + 1
end

RegisterNetEvent('custom_races:client:callback', function(requestId, ...)
	if not serverRequests[requestId] then return end

	serverRequests[requestId](...)
	serverRequests[requestId] = nil
end)