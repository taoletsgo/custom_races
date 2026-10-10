CreateServerCallback("server:creator:exportFile", function(currentPlayer, callback, fileData)
	if not fileData or (Config.Discord.Webhook.ExportTrack.Url == "") then callback("failed") return end
	local raceId = fileData.raceId
	local currentSession = Server.Creator.Sessions[raceId]
	if currentSession then
		for k, v in pairs(currentSession.creators) do
			if v.playerId ~= currentPlayer.id then
				TriggerClientEvent("client:creator:syncSession", v.playerId, {published = currentSession.data.Published and "√" or "x", action = "export"}, "published-status", currentPlayer.name)
			end
		end
	end
	fileData.raceId = nil
	fileData.thumbnail = nil
	fileData.published = nil
	fileData.category = nil
	fileData.testVehicle = nil
	fileData.firework = nil
	fileData.mission.gen.ownerid = currentPlayer.name
	fileData.mission.dprop.collision = nil
	fileData.mission.prop.collision = nil
	for i = 1, #fileData.mission.race.cptrtt do
		fileData.mission.race.cptrtt[i] = fileData.mission.race.cptrtt[i] >= 0 and fileData.mission.race.cptrtt[i] or 0
	end
	fileData.mission.race.cptrst = nil
	for i = 1, #fileData.mission.race.cptrtts do
		fileData.mission.race.cptrtts[i] = fileData.mission.race.cptrtts[i] >= 0 and fileData.mission.race.cptrtts[i] or 0
	end
	fileData.mission.race.cptrsts = nil
	Server.Function.Webhook.ExportFile(fileData, currentPlayer.discord, function(statusCode)
		if statusCode == 200 then
			callback("success")
		else
			callback("failed")
		end
	end)
end)