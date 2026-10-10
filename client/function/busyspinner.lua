function Client.Function.Busyspinner.Display(str, coefficient, len)
	Client.Busyspinner.Status = str
	Client.Busyspinner.Coefficient = coefficient
	Client.Busyspinner.Len = len
	Client.Busyspinner.LoadCount = 0.0
	Client.Busyspinner.LastCount = nil
	if not Client.Busyspinner.Showed then
		Client.Busyspinner.Showed = true
		CreateThread(function()
			while Client.Busyspinner.Status do
				local displayCount = math.floor(Client.Busyspinner.LoadCount * Client.Busyspinner.Coefficient * 100 / Client.Busyspinner.Len)
				if not Client.Busyspinner.LastCount or Client.Busyspinner.LastCount ~= displayCount then
					Client.Busyspinner.LastCount = displayCount
					local text = displayCount .. "%"
					if Client.Busyspinner.Status == "load" then
						text = string.format(Client.Function.Translate.Get("load-progress"), displayCount)
					elseif Client.Busyspinner.Status == "download" then
						text = string.format(Client.Function.Translate.Get("download-progress"), displayCount)
					elseif Client.Busyspinner.Status == "parse" then
						text = string.format(Client.Function.Translate.Get("parse-progress"), displayCount)
					elseif Client.Busyspinner.Status == "sync" then
						text = string.format(Client.Function.Translate.Get("sync-progress"), displayCount)
					elseif Client.Busyspinner.Status == "upload" then
						text = string.format(Client.Function.Translate.Get("upload-progress"), displayCount)
					elseif Client.Busyspinner.Status == "refresh" then
						text = string.format(Client.Function.Translate.Get("refresh-progress"), displayCount)
					end
					RemoveLoadingPrompt()
					BeginTextCommandBusyString("STRING")
					AddTextComponentSubstringPlayerName(text)
					EndTextCommandBusyString(4)
				end
				if (Client.Busyspinner.LoadCount + 0.1) * Client.Busyspinner.Coefficient <= Client.Busyspinner.Len then
					Client.Busyspinner.LoadCount = Client.Busyspinner.LoadCount + 0.1
				end
				Wait(100)
			end
			Client.Busyspinner.Showed = false
		end)
	end
end