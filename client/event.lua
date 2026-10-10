AddEventHandler("custom_chat:open", function()
	Client.IsChatInputActive = true
end)

AddEventHandler("custom_chat:close", function()
	Client.IsChatInputActive = false
end)

RegisterNetEvent("client:core:init", function()
	Client.IsNetworkInitialized = true
end)

RegisterNetEvent("client:core:syncData", function(count, ping, playerList)
	Client.Hud.Data.Count = count
	Client.Hud.Data.Ping = ping
	Client.Player.List = playerList
end)

RegisterNetEvent("client:core:joining", function(name)
	if not Client.FirstLoad then
		Client.Function.Message.Display(string.format(Client.Function.Translate.Get("player-joining"), name))
	end
end)

RegisterNetEvent("client:core:dropped", function(name, reason)
	if not Client.FirstLoad then
		if reason == 0 then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("player-dropped-left"), name))
		elseif reason == 1 then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("player-dropped-timed-out"), name))
		elseif reason == 2 then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("player-dropped-crashed"), name))
		elseif reason == 3 then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("player-dropped-unknown-reason"), name))
		end
	end
end)