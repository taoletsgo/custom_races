local RequestId = 0
local serverRequests = {}

TriggerServerCallback = function(eventName, callback, ...)
	serverRequests[RequestId] = callback
	TriggerLatentServerEvent("server:core:callback", 65536, eventName, RequestId, ...)
	RequestId = RequestId + 1
end

RegisterNetEvent("client:core:callback", function(requestId, ...)
	if not serverRequests[requestId] then return end
	serverRequests[requestId](...)
	serverRequests[requestId] = nil
end)