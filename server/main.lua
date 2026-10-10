CreateThread(function()
	for convarName, convarValue in pairs(Config.Default.Convar) do
		SetConvar(convarName, convarValue)
	end
	for convarName, convarValue in pairs(Config.Default.ConvarReplicated) do
		SetConvarReplicated(convarName, convarValue)
	end
end)

CreateThread(function()
	while true do
		local playerList = {}
		for k, v in pairs(Server.Players) do
			if v.loaded then
				local ped = GetPlayerPed(v.id)
				if ped ~= 0 then
					local coords = GetEntityCoords(ped)
					local heading = GetEntityHeading(ped)
					playerList[#playerList + 1] = {
						v.id,
						{Server.Function.Math.RoundedValue(coords.x, 3), Server.Function.Math.RoundedValue(coords.y, 3), Server.Function.Math.RoundedValue(coords.z, 3), Server.Function.Math.RoundedValue(heading, 3)},
						v.name,
						v.inRace,
						v.inCreator,
						v.inTestMode,
						v.inSpectator,
						v.disableTraffic
					}
				end
			end
		end
		for k, v in pairs(Server.Players) do
			if v.loaded then
				TriggerClientEvent("client:core:syncData", v.id, Server.PlayerCount, GetPlayerPing(v.id), playerList)
			end
		end
		Wait(500)
	end
end)