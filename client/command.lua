RegisterCommand("creator", function()
	if Client.FirstLoad or Client.IsInRace or Client.IsInCreator or Client.OpenMenuPressedTime or Client.IsAnyClientMenuVisible or Client.Noclip.Enable or Client.IsVehicleSpawning or Client.IsPedSpawning or IsNuiFocused() or IsPauseMenuActive() or IsPlayerSwitchInProgress() then return end
	if Creator.Data.Check.Done then
		TriggerServerEvent("server:core:inCreator", true)
		Client.IsInCreator = true
		Creator.Function.Open()
	else
		if (Creator.Data.Check.CurrentCount > 0) and (Creator.Data.Check.TotalCount > 0) then
			Client.Function.Message.Display(string.format(Client.Function.Translate.Get("wait-models"), Client.Function.Math.RoundedValue((Creator.Data.Check.CurrentCount / Creator.Data.Check.TotalCount) * 100, 2) .. "%"))
			if not Creator.GlobalVar.ShowAllModelCheckedMsg then
				Creator.GlobalVar.ShowAllModelCheckedMsg = true
				CreateThread(function()
					while not Creator.Data.Check.Done do Wait(0) end
					Client.Function.Message.Display(Client.Function.Translate.Get("wait-models-done"))
					Creator.GlobalVar.ShowAllModelCheckedMsg = false
				end)
			end
		end
	end
end)

RegisterCommand("race", function()
	if Client.FirstLoad or Client.IsInRace or Client.IsInCreator or Client.OpenMenuPressedTime or Client.IsAnyClientMenuVisible or Client.Noclip.Enable or Client.IsVehicleSpawning or Client.IsPedSpawning or IsNuiFocused() or IsPauseMenuActive() or IsPlayerSwitchInProgress() then return end
	if not Race.EnableXboxController then
		Race.EnableXboxController = true
		Race.Function.Xbox.ControlSimulation()
		if Race.Track.DataOutdated then
			Race.Track.DataOutdated = false
			Client.Busyspinner.Status = "load"
			RemoveLoadingPrompt()
			BeginTextCommandBusyString("STRING")
			AddTextComponentSubstringPlayerName(string.format(Client.Function.Translate.Get("load-progress"), 0))
			EndTextCommandBusyString(4)
			TriggerServerCallback("server:race:getTracks", function(newData)
				for k, v in pairs(newData) do
					for i = 1, #v do
						v[i].bookmarked = Race.Track.Bookmarked[v[i].raceId] and true or nil
						v[i].played = Race.Track.Played[v[i].raceId] and true or nil
						v[i].finished = Race.Track.Finished[v[i].raceId] and true or nil
					end
				end
				Race.Track.Data = newData
				SendNUIMessage({
					action = "open track list",
					trackData = Race.Track.Data,
					isInRace = false
				})
				RemoveLoadingPrompt()
				Client.Busyspinner.Status = nil
			end)
		else
			SendNUIMessage({
				action = "open track list",
				trackData = Race.Track.Data,
				isInRace = false
			})
		end
	end
end)

RegisterCommand("inv", function()
	Wait(500)
	if Client.FirstLoad or Client.IsInRace or Client.IsInCreator or Client.OpenMenuPressedTime or Client.IsAnyClientMenuVisible or Client.Noclip.Enable or Client.IsVehicleSpawning or Client.IsPedSpawning or IsNuiFocused() or IsPauseMenuActive() or IsPlayerSwitchInProgress() then return end
	if not Race.EnableXboxController then
		Race.EnableXboxController = true
		Race.Function.Xbox.ControlSimulation()
		SendNUIMessage({
			action = "open invitations"
		})
	end
end)

RegisterCommand("leave", function()
	if Client.FirstLoad or Client.IsInCreator or Client.OpenMenuPressedTime or Client.IsAnyClientMenuVisible or Client.Noclip.Enable or Client.IsVehicleSpawning or Client.IsPedSpawning or IsNuiFocused() or IsPauseMenuActive() or IsPlayerSwitchInProgress() then return end
	if Client.IsInRace and (Race.Status == "racing" or Race.Status == "spectating") and not Race.EnableXboxController then
		Race.EnableXboxController = true
		Race.Function.Xbox.ControlSimulation()
		SendNUIMessage({
			action = "open track list",
			trackData = Race.Track.Data,
			isInRace = true
		})
	end
end)

RegisterCommand("TeleportToCoords", function()
	Client.Function.Stunt.TeleportToCoords(false)
end, false)
RegisterKeyMapping("TeleportToCoords", "Teleport To Coords", "keyboard", "OEM_4")

RegisterCommand("TeleportToCoords_Controller", function()
	Client.Function.Stunt.TeleportToCoords(false)
end, false)
RegisterKeyMapping("TeleportToCoords_Controller", "Teleport To Coords (Controller)", "PAD_ANALOGBUTTON", "LDOWN_INDEX")

RegisterCommand("SaveTeleportCoords", function()
	Client.Function.Stunt.SaveTeleportCoords(false)
end, false)
RegisterKeyMapping("SaveTeleportCoords", "Save Teleport Coords", "keyboard", "RBRACKET")

RegisterCommand("SaveTeleportCoords_Controller", function()
	Client.Function.Stunt.SaveTeleportCoords(false)
end, false)
RegisterKeyMapping("SaveTeleportCoords_Controller", "Save Teleport Coords (Controller)", "PAD_ANALOGBUTTON", "LUP_INDEX")