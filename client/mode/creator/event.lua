RegisterNetEvent("client:creator:info", function(str, info)
	if str == "ugc-wait" then
		Client.Function.Message.Display(string.format(Client.Function.Translate.Get("ugc-wait"), info))
	elseif str == "join-session-trying" then
		Client.Function.Message.Display(Client.Function.Translate.Get("join-session-trying"))
	elseif str == "track-list" then
		if Client.Busyspinner.Status == "load" then
			Client.Function.Busyspinner.Display("load", 65536, info)
		end
	elseif str == "track-download" then
		if Client.Busyspinner.Status == "download" then
			Client.Function.Busyspinner.Display("download", 65536, info)
		end
	end
end)