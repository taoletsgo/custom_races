CreateServerCallback("server:race:getTracks", function(currentPlayer, callback)
	while Server.Track.IsUpdating do Wait(0) end
	TriggerClientEvent("client:race:info", currentPlayer.id, "track-list", {len = #json.encode(Server.Track.Data) * 1.02})
	callback(Server.Track.Data)
end)

CreateServerCallback("server:race:getBestTimes", function(currentPlayer, callback, raceId)
	local result = MySQL.query.await("SELECT * FROM tracks WHERE id = ?", {raceId})
	local responseData = result and result[1] and json.decode(result[1].data) or {}
	local bestTimes = responseData.bestTimes or {}
	callback(bestTimes)
end)