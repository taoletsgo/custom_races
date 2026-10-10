Creator.Menu.Main = RageUI.CreateMenu(Client.Function.Translate.Get("Menu-Creator-Main-Title"), Client.Function.Translate.Get("Menu-Creator-Main-Subtitle"), true)
Creator.Menu.RaceDetail = {}
Creator.Menu.RaceDetail.Main = RageUI.CreateSubMenu(Creator.Menu.Main, "", Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Subtitle"), false)
Creator.Menu.RaceDetail.Class = {}
Creator.Menu.RaceDetail.Class.Main = RageUI.CreateSubMenu(Creator.Menu.RaceDetail.Main, "", Client.Function.Translate.Get("Menu-Creator-RaceDetail-Class-Subtitle"), false)
Creator.Menu.RaceDetail.Class.Vehicles = {}
for classid = 0, 27 do
	Creator.Menu.RaceDetail.Class.Vehicles[classid] = RageUI.CreateSubMenu(Creator.Menu.RaceDetail.Class.Main, "", Client.Function.Translate.Get("Menu-Creator-RaceDetail-Class-" .. classid), false)
end
Creator.Menu.Placement = {}
Creator.Menu.Placement.Main = RageUI.CreateSubMenu(Creator.Menu.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Main-Subtitle"), false)
Creator.Menu.Placement.StartingGrid = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-StartingGrid-Subtitle"), false)
Creator.Menu.Placement.Checkpoint = {}
Creator.Menu.Placement.Checkpoint.Main = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Subtitle"), false)
Creator.Menu.Placement.Checkpoint.ExtraRandomSetting = RageUI.CreateSubMenu(Creator.Menu.Placement.Checkpoint.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-ExtraRandomSetting-Subtitle"), false)
Creator.Menu.Placement.Prop = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Prop-Subtitle"), false)
Creator.Menu.Placement.Template = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Template-Subtitle"), false)
-- Creator.Menu.Placement.Pickup = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Pickup-Subtitle"), false)
Creator.Menu.Placement.MoveAll = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-MoveAll-Subtitle"), false)
Creator.Menu.Placement.Fixture = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Fixture-Subtitle"), false)
Creator.Menu.Placement.Firework = RageUI.CreateSubMenu(Creator.Menu.Placement.Main, "", Client.Function.Translate.Get("Menu-Creator-Placement-Firework-Subtitle"), false)
Creator.Menu.Multiplayer = {}
Creator.Menu.Multiplayer.Main = RageUI.CreateSubMenu(Creator.Menu.Main, "", Client.Function.Translate.Get("Menu-Creator-Multiplayer-Main-Subtitle"), false)
Creator.Menu.Multiplayer.Invite = RageUI.CreateSubMenu(Creator.Menu.Multiplayer.Main, "", Client.Function.Translate.Get("Menu-Creator-Multiplayer-Invite-Subtitle"), false)
Creator.Menu.Weather = RageUI.CreateSubMenu(Creator.Menu.Main, "", Client.Function.Translate.Get("Menu-Creator-Weather-Subtitle"), false)
Creator.Menu.Time = RageUI.CreateSubMenu(Creator.Menu.Main, "", Client.Function.Translate.Get("Menu-Creator-Time-Subtitle"), false)
Creator.Menu.Misc = RageUI.CreateSubMenu(Creator.Menu.Main, "", Client.Function.Translate.Get("Menu-Creator-Misc-Subtitle"), false)

Creator.Menu.Main.WidthOffset = 160
Creator.Menu.RaceDetail.Main.WidthOffset = 160
Creator.Menu.RaceDetail.Class.Main.WidthOffset = 160
for classid = 0, 27 do
	Creator.Menu.RaceDetail.Class.Vehicles[classid].WidthOffset = 160
end
Creator.Menu.Placement.Main.WidthOffset = 160
Creator.Menu.Placement.StartingGrid.WidthOffset = 160
Creator.Menu.Placement.Checkpoint.Main.WidthOffset = 160
Creator.Menu.Placement.Checkpoint.ExtraRandomSetting.WidthOffset = 160
Creator.Menu.Placement.Prop.WidthOffset = 160
Creator.Menu.Placement.Template.WidthOffset = 160
Creator.Menu.Placement.MoveAll.WidthOffset = 160
Creator.Menu.Placement.Fixture.WidthOffset = 160
Creator.Menu.Placement.Firework.WidthOffset = 160
Creator.Menu.Multiplayer.Main.WidthOffset = 160
Creator.Menu.Multiplayer.Invite.WidthOffset = 160
Creator.Menu.Weather.WidthOffset = 160
Creator.Menu.Time.WidthOffset = 160
Creator.Menu.Misc.WidthOffset = 160

function RageUI.PoolMenus:Creator()
	Creator.Menu.Main:IsVisible(function(Items)
		if Creator.Track.Current.Title == "" then
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Create"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock}, function(onSelected)
				if onSelected then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "input open",
						value = Creator.Track.Current.Title
					})
					Client.NUI.Callback = "race title"
				end
				if Creator.GlobalVar.PreviewThumbnail ~= "" then
					Creator.GlobalVar.PreviewThumbnail = ""
					SendNUIMessage({
						action = "thumbnail preview off"
					})
				end
			end)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Import"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock}, function(onSelected)
				if onSelected then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "input open",
						value = Client.Function.Translate.Get("paste-url")
					})
					Client.NUI.Callback = "import ugc"
				end
			end)

			if Creator.GlobalVar.Querying then
				Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Cancel"), nil, {IsDisabled = false}, function(onSelected)
					if onSelected then
						Creator.GlobalVar.Querying = false
						TriggerServerEvent("server:creator:cancelSearch")
					end
				end)
			end

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Multiplayer"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Multiplayer.Main)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Weather"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Weather)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Time"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Time)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Misc"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Misc)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Exit"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock}, function(onSelected)
				if onSelected then
					RageUI.QuitIndex = nil
					Creator.Function.Exit()
				end
			end)

			Items:AddSeparator(Client.Function.Translate.Get("Menu-Creator-Main-Separator-Load"), false)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Filter"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock}, function(onSelected)
				if onSelected then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "input open",
						value = Creator.Track.FilterStr
					})
					Client.NUI.Callback = "filter races"
				end
			end)

			local categoryList = {}
			for i = 1, #Creator.Track.All do
				categoryList[i] = (i == #Creator.Track.All and Client.Function.Translate.Get("filter-races")) or (i == 1 and Client.Function.Translate.Get("published-races")) or (i == 2 and Client.Function.Translate.Get("saved-races")) or Creator.Track.All[i].class
			end
			Items:AddList("", categoryList, Creator.Track.Index, nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock}, function(Index, onSelected, onListChange)
				if onListChange then
					Creator.Track.Index = Index
				end
				if Creator.GlobalVar.PreviewThumbnail ~= "" then
					Creator.GlobalVar.PreviewThumbnail = ""
					SendNUIMessage({
						action = "thumbnail preview off"
					})
				end
			end)

			for i = 1, #Creator.Track.All[Creator.Track.Index].data do
				Items:CheckBox(Creator.Track.All[Creator.Track.Index].data[i].name, nil, true, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock, Style = Creator.Track.All[Creator.Track.Index].data[i].published and 1 or 2}, function(onSelected)
					if Creator.GlobalVar.PreviewThumbnail ~= Creator.Track.All[Creator.Track.Index].data[i].img and not IsNuiFocused() and not Creator.GlobalVar.Lock then
						Creator.GlobalVar.PreviewThumbnail = Creator.Track.All[Creator.Track.Index].data[i].img
						SendNUIMessage({
							action = "thumbnail preview",
							url = Creator.GlobalVar.PreviewThumbnail
						})
					end
					if onSelected then
						Creator.GlobalVar.Lock = true
						RageUI.QuitIndex = RageUI.CurrentMenu.Index
						CreateThread(function()
							Client.Busyspinner.Status = "download"
							RemoveLoadingPrompt()
							BeginTextCommandBusyString("STRING")
							AddTextComponentSubstringPlayerName(string.format(Client.Function.Translate.Get("download-progress"), 0))
							EndTextCommandBusyString(4)
							TriggerServerCallback("server:creator:getTrack", function(data, data_2, inSessionPlayers)
								if data and not data_2 then
									Creator.Function.Track.ConvertFromData(data)
									Creator.GlobalVar.ThumbnailValid = false
									Creator.GlobalVar.PreviewThumbnail = ""
									SendNUIMessage({
										action = "thumbnail preview off"
									})
									SendNUIMessage({
										action = "thumbnail url",
										url = Creator.Track.Current.Thumbnail
									})
									Client.Function.Message.Display(Client.Function.Translate.Get("load-success"))
									if not Creator.Multiplayer.InSession and Creator.Track.Current.RaceId then
										Creator.Multiplayer.InSession = true
										Creator.Multiplayer.LockSession = true
										Creator.Multiplayer.InSessionPlayers = {}
										table.insert(Creator.Multiplayer.InSessionPlayers, {playerId = Client.ServerId, playerName = GetPlayerName(PlayerId())})
										TriggerServerCallback("server:creator:sessionData", function()
											if #Creator.Multiplayer.LoadingPlayers == 0 then
												Creator.Multiplayer.LockSession = false
											end
											RemoveLoadingPrompt()
											Client.Busyspinner.Status = nil
										end, Creator.Track.Current.RaceId, Creator.Track.Current)
										Client.Function.Busyspinner.Display("sync", 65536, #json.encode(Creator.Track.Current) * 1.02)
									end
								elseif data and data_2 then
									Creator.Multiplayer.InSession = true
									Creator.Multiplayer.LockSession = true
									Creator.Function.Multiplayer.LoadSessionData(data, data_2)
									Creator.GlobalVar.ThumbnailValid = false
									Creator.GlobalVar.PreviewThumbnail = ""
									SendNUIMessage({
										action = "thumbnail preview off"
									})
									SendNUIMessage({
										action = "thumbnail url",
										url = Creator.Track.Current.Thumbnail
									})
									Client.Function.Message.Display(Client.Function.Translate.Get("join-session-success"))
									TriggerServerEvent("server:creator:loadDone", Creator.Track.Current.RaceId)
									for i = 1, #inSessionPlayers do
										table.insert(Creator.Multiplayer.InSessionPlayers, inSessionPlayers[i])
									end
									if #Creator.Multiplayer.LoadingPlayers == 0 then
										Creator.Multiplayer.LockSession = false
									end
									RemoveLoadingPrompt()
									Client.Busyspinner.Status = nil
								else
									RemoveLoadingPrompt()
									Client.Busyspinner.Status = nil
									Client.Function.Message.Display(Client.Function.Translate.Get("json-not-exist"))
								end
								while Creator.GlobalVar.Lock_2 do Wait(0) end
								Creator.GlobalVar.Lock = false
							end, Creator.Track.All[Creator.Track.Index].data[i].raceId)
						end)
					end
				end)
			end
		else
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-RaceDetail"), nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.RaceDetail.Main)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Placement"), nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Placement.Main)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Multiplayer"), nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Multiplayer.Main)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Weather"), nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Weather)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Time"), nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Time)

			if Creator.Track.Current.Published then
				Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Update"), (not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown")) and Client.Function.Translate.Get("Menu-Creator-Main-Button-Save-Desc") or nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown") or Creator.Multiplayer.LockSession}, function(onSelected)
					if onSelected then
						Creator.GlobalVar.Lock = true
						CreateThread(function()
							TriggerServerCallback("server:creator:saveTrack", function(str, raceId, ownerName)
								if str == "success" then
									Client.Function.Message.Display(Client.Function.Translate.Get("update-success"))
									Creator.Track.Current.RaceId = raceId
									Creator.Track.Current.Published = true
									Creator.Track.Current.OwnerName = ownerName
								end
								RemoveLoadingPrompt()
								Client.Busyspinner.Status = nil
								Creator.GlobalVar.Lock = false
							end, Creator.Function.Track.ConvertToData(), "update")
						end)
					end
				end)

				Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-CancelPublish"), (not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown")) and Client.Function.Translate.Get("Menu-Creator-Main-Button-Save-Desc") or Client.Function.Translate.Get("Menu-Creator-Main-Button-CancelPublish-Desc"), {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown") or Creator.Multiplayer.LockSession}, function(onSelected)
					if onSelected then
						Creator.GlobalVar.Lock = true
						CreateThread(function()
							TriggerServerCallback("server:creator:saveTrack", function(str, raceId, ownerName)
								if str == "success" then
									Client.Function.Message.Display(Client.Function.Translate.Get("cancel-success"))
									Creator.Track.Current.RaceId = raceId
									Creator.Track.Current.Published = false
									Creator.Track.Current.OwnerName = ownerName
								end
								RemoveLoadingPrompt()
								Client.Busyspinner.Status = nil
								Creator.GlobalVar.Lock = false
							end, Creator.Function.Track.ConvertToData(), "cancel")
						end)
					end
				end)
			else
				Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Save"), (not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown")) and Client.Function.Translate.Get("Menu-Creator-Main-Button-Save-Desc") or nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown") or Creator.Multiplayer.LockSession}, function(onSelected)
					if onSelected then
						Creator.GlobalVar.Lock = true
						CreateThread(function()
							TriggerServerCallback("server:creator:saveTrack", function(str, raceId, ownerName)
								if str == "success" then
									Client.Function.Message.Display(Client.Function.Translate.Get("save-success"))
									Creator.Track.Current.RaceId = raceId
									Creator.Track.Current.Published = false
									Creator.Track.Current.OwnerName = ownerName
								end
								if not Creator.Multiplayer.InSession and Creator.Track.Current.RaceId then
									Creator.Multiplayer.InSession = true
									Creator.Multiplayer.LockSession = true
									Creator.Multiplayer.InSessionPlayers = {}
									table.insert(Creator.Multiplayer.InSessionPlayers, {playerId = Client.ServerId, playerName = GetPlayerName(PlayerId())})
									TriggerServerEvent("server:creator:createSession", Creator.Track.Current.RaceId)
									Wait(3000)
									TriggerServerCallback("server:creator:sessionData", function()
										if #Creator.Multiplayer.LoadingPlayers == 0 then
											Creator.Multiplayer.LockSession = false
										end
										RemoveLoadingPrompt()
										Client.Busyspinner.Status = nil
										Creator.GlobalVar.Lock = false
									end, Creator.Track.Current.RaceId, Creator.Track.Current)
									Client.Function.Busyspinner.Display("sync", 65536, #json.encode(Creator.Track.Current) * 1.02)
								else
									RemoveLoadingPrompt()
									Client.Busyspinner.Status = nil
									Creator.GlobalVar.Lock = false
								end
							end, Creator.Function.Track.ConvertToData(), "save")
						end)
					end
				end)

				Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Publish"), (not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown")) and Client.Function.Translate.Get("Menu-Creator-Main-Button-Save-Desc") or nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown") or Creator.Multiplayer.LockSession}, function(onSelected)
					if onSelected then
						Creator.GlobalVar.Lock = true
						CreateThread(function()
							TriggerServerCallback("server:creator:saveTrack", function(str, raceId, ownerName)
								if str == "success" then
									Client.Function.Message.Display(Client.Function.Translate.Get("publish-success"))
									Creator.Track.Current.RaceId = raceId
									Creator.Track.Current.Published = true
									Creator.Track.Current.OwnerName = ownerName
								end
								if not Creator.Multiplayer.InSession and Creator.Track.Current.RaceId then
									Creator.Multiplayer.InSession = true
									Creator.Multiplayer.LockSession = true
									Creator.Multiplayer.InSessionPlayers = {}
									table.insert(Creator.Multiplayer.InSessionPlayers, {playerId = Client.ServerId, playerName = GetPlayerName(PlayerId())})
									TriggerServerEvent("server:creator:createSession", Creator.Track.Current.RaceId)
									Wait(3000)
									TriggerServerCallback("server:creator:sessionData", function()
										if #Creator.Multiplayer.LoadingPlayers == 0 then
											Creator.Multiplayer.LockSession = false
										end
										RemoveLoadingPrompt()
										Client.Busyspinner.Status = nil
										Creator.GlobalVar.Lock = false
									end, Creator.Track.Current.RaceId, Creator.Track.Current)
									Client.Function.Busyspinner.Display("sync", 65536, #json.encode(Creator.Track.Current) * 1.02)
								else
									RemoveLoadingPrompt()
									Client.Busyspinner.Status = nil
									Creator.GlobalVar.Lock = false
								end
							end, Creator.Function.Track.ConvertToData(), "publish")
						end)
					end
				end)
			end

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Export"), (not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown")) and Client.Function.Translate.Get("Menu-Creator-Main-Button-Save-Desc") or nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or not Creator.GlobalVar.ThumbnailValid or (#Creator.Track.Current.StartingGrid == 0) or (#Creator.Track.Current.Checkpoints < 10) or (#Creator.Track.Current.Objects == 0) or (Creator.Track.Current.Title == "unknown") or Creator.Multiplayer.LockSession}, function(onSelected)
				if onSelected then
					Creator.GlobalVar.Lock = true
					CreateThread(function()
						TriggerServerCallback("server:creator:exportFile", function(str)
							if str == "success" then
								Client.Function.Message.Display(Client.Function.Translate.Get("export-success"))
							elseif str == "failed" then
								Client.Function.Message.Display(Client.Function.Translate.Get("export-failed"))
							end
							RemoveLoadingPrompt()
							Client.Busyspinner.Status = nil
							Creator.GlobalVar.Lock = false
						end, Creator.Function.Track.ConvertToData())
					end)
				end
			end)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Misc"), nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.Misc)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Main-Button-Exit"), nil, {IsDisabled = Creator.ObjectPool.IsRefreshing or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession}, function(onSelected)
				if onSelected then
					Creator.Function.Exit()
				end
			end)
		end
	end, function(Panels)
	end)

	Creator.Menu.RaceDetail.Main:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Button-Title"), (Creator.Track.Current.Title == "unknown") and Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Button-Title-Desc"), {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession, Color = (Creator.Track.Current.Title == "unknown") and {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Creator.Track.Current.Title
				})
				Client.NUI.Callback = "race title"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Button-Thumbnail"), not Creator.GlobalVar.ThumbnailValid and Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Button-Thumbnail-Desc"), {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession, Color = not Creator.GlobalVar.ThumbnailValid and {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Creator.Track.Current.Thumbnail
				})
				Client.NUI.Callback = "race thumbnail"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Button-InputVehicle"), nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
				})
				Client.NUI.Callback = "input vehicle"
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-List-DefaultClass"), {Creator.Track.Current.DefaultClass and Client.Function.Translate.Get("Menu-Creator-RaceDetail-Class-" .. Creator.Track.Current.DefaultClass) or ""}, 1, nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Track.Current.DefaultClass or 0
				local validClasses = {}
				for classid = 0, 27 do
					for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
						if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
							validClasses[classid] = true
							break
						end
					end
				end
				local found = false
				local found_2 = false
				for i = index - 1, 0, -1 do
					if validClasses[i] then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = 27, 0, -1 do
						if validClasses[i] then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					Creator.Track.Current.DefaultClass = index
					if Creator.Track.Current.AvailableVehicles[index].index then
						Creator.Track.Current.TestVehicle = Creator.Track.Current.AvailableVehicles[index].vehicles[Creator.Track.Current.AvailableVehicles[index].index].model
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.testVehicle = Creator.Multiplayer.ModificationCount.testVehicle + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {testVehicle = Creator.Track.Current.TestVehicle, modificationCount = Creator.Multiplayer.ModificationCount.testVehicle}, "test-vehicle-sync")
						end
					end
				else
					Creator.Track.Current.DefaultClass = nil
				end
			elseif onListChange == "right" then
				local index = Creator.Track.Current.DefaultClass or 0
				local validClasses = {}
				for classid = 0, 27 do
					for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
						if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
							validClasses[classid] = true
							break
						end
					end
				end
				local found = false
				local found_2 = false
				for i = index + 1, 27, 1 do
					if validClasses[i] then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = 0, 27, 1 do
						if validClasses[i] then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					Creator.Track.Current.DefaultClass = index
					if Creator.Track.Current.AvailableVehicles[index].index then
						Creator.Track.Current.TestVehicle = Creator.Track.Current.AvailableVehicles[index].vehicles[Creator.Track.Current.AvailableVehicles[index].index].model
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.testVehicle = Creator.Multiplayer.ModificationCount.testVehicle + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {testVehicle = Creator.Track.Current.TestVehicle, modificationCount = Creator.Multiplayer.ModificationCount.testVehicle}, "test-vehicle-sync")
						end
					end
				else
					Creator.Track.Current.DefaultClass = nil
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-List-DefaultVehicle"), {Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].name or ""}, 1, nil, {IsDisabled = not Creator.Track.Current.DefaultClass or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index or 0
				local found = false
				local found_2 = false
				for i = index - 1, 1, -1 do
					if Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[i].enabled then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = #Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles, 1, -1 do
						if Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[i].enabled then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index = index
					Creator.Track.Current.TestVehicle = Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[index].model
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.testVehicle = Creator.Multiplayer.ModificationCount.testVehicle + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {testVehicle = Creator.Track.Current.TestVehicle, modificationCount = Creator.Multiplayer.ModificationCount.testVehicle}, "test-vehicle-sync")
					end
				else
					Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index = nil
				end
			elseif onListChange == "right" then
				local index = Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index or 0
				local found = false
				local found_2 = false
				for i = index + 1, #Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles, 1 do
					if Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[i].enabled then
						index = i
						found = true
						break
					end
				end
				if not found then
					for i = 1, #Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles do
						if Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[i].enabled then
							index = i
							found_2 = true
							break
						end
					end
				end
				if (found or found_2) then
					Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index = index
					Creator.Track.Current.TestVehicle = Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[index].model
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.testVehicle = Creator.Multiplayer.ModificationCount.testVehicle + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {testVehicle = Creator.Track.Current.TestVehicle, modificationCount = Creator.Multiplayer.ModificationCount.testVehicle}, "test-vehicle-sync")
					end
				else
					Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index = nil
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Button-AvailableClass"), nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

		end, Creator.Menu.RaceDetail.Class.Main)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Main-Button-Blimp"), nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Creator.Track.Current.BlimpText
				})
				Client.NUI.Callback = "blimp text"
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.RaceDetail.Class.Main:IsVisible(function(Items)
		for classid = 0, 27 do
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Class-" .. classid), nil, {IsDisabled = #Creator.Track.Current.AvailableVehicles[classid].vehicles == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

			end, Creator.Menu.RaceDetail.Class.Vehicles[classid])
		end
	end, function(Panels)
	end)

	for classid = 0, 27 do
		Creator.Menu.RaceDetail.Class.Vehicles[classid]:IsVisible(function(Items)
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-RaceDetail-Class-Vehicles-Button-Select"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.FixEventSizeOverflow or Creator.Multiplayer.LockSession}, function(onSelected)
				if onSelected then
					local defaultClass = nil
					local found = false
					for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
						if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
							found = true
							break
						end
					end
					if found then
						for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
							Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = false
						end
						Creator.Track.Current.AvailableVehicles[classid].index = nil
						local validClasses = {}
						for _classid = 0, 27 do
							for i = 1, #Creator.Track.Current.AvailableVehicles[_classid].vehicles do
								if Creator.Track.Current.AvailableVehicles[_classid].vehicles[i].enabled then
									validClasses[_classid] = true
									break
								end
							end
						end
						local found_2 = false
						for i = 0, 27, 1 do
							if validClasses[i] then
								defaultClass = i
								found_2 = true
								break
							end
						end
						if not found_2 then
							defaultClass = nil
						end
					else
						local valid = false
						for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
							local hash = Creator.Track.Current.AvailableVehicles[classid].vehicles[i].hash
							if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
								Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = true
								valid = true
							end
						end
						if valid then
							Creator.Track.Current.AvailableVehicles[classid].index = 1
							defaultClass = classid
						else
							Creator.Track.Current.AvailableVehicles[classid].index = nil
							local validClasses = {}
							for _classid = 0, 27 do
								for i = 1, #Creator.Track.Current.AvailableVehicles[_classid].vehicles do
									if Creator.Track.Current.AvailableVehicles[_classid].vehicles[i].enabled then
										validClasses[_classid] = true
										break
									end
								end
							end
							local found_2 = false
							for i = 0, 27, 1 do
								if validClasses[i] then
									defaultClass = i
									found_2 = true
									break
								end
							end
							if not found_2 then
								defaultClass = nil
							end
						end
					end
					Creator.Track.Current.DefaultClass = defaultClass
					if Creator.Multiplayer.InSession then
						Creator.GlobalVar.FixEventSizeOverflow = true
						Creator.GlobalVar.FixEventSizeOverflowTimer = GetGameTimer()
						Creator.Multiplayer.ModificationCount.availableVehicles = Creator.Multiplayer.ModificationCount.availableVehicles + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {defaultClass = Creator.Track.Current.DefaultClass, availableVehicles = Creator.Track.Current.AvailableVehicles, modificationCount = Creator.Multiplayer.ModificationCount.availableVehicles}, "available-vehicles-sync")
					end
				end
			end)

			for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
				Items:CheckBox(Creator.Track.Current.AvailableVehicles[classid].vehicles[i].name, nil, Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled, {Style = 1}, function(onSelected, IsChecked)
					if onSelected and not Creator.GlobalVar.FixEventSizeOverflow and not IsNuiFocused() and not Creator.Multiplayer.LockSession then
						local hash = Creator.Track.Current.AvailableVehicles[classid].vehicles[i].hash
						if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
							Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled = IsChecked
							local defaultClass = nil
							if IsChecked then
								Creator.Track.Current.AvailableVehicles[classid].index = i
								defaultClass = classid
							else
								local found = false
								for j = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles, 1 do
									if Creator.Track.Current.AvailableVehicles[classid].vehicles[j].enabled then
										Creator.Track.Current.AvailableVehicles[classid].index = j
										found = true
										break
									end
								end
								if not found then
									Creator.Track.Current.AvailableVehicles[classid].index = nil
								end
								local validClasses = {}
								for _classid = 0, 27 do
									for j = 1, #Creator.Track.Current.AvailableVehicles[_classid].vehicles do
										if Creator.Track.Current.AvailableVehicles[_classid].vehicles[j].enabled then
											validClasses[_classid] = true
											break
										end
									end
								end
								local found_2 = false
								if validClasses[classid] then
									defaultClass = classid
									found_2 = true
								else
									for j = 0, 27, 1 do
										if validClasses[j] then
											defaultClass = j
											found_2 = true
											break
										end
									end
								end
								if not found_2 then
									defaultClass = nil
								end
							end
							Creator.Track.Current.DefaultClass = defaultClass
						else
							Client.Function.Message.Display(string.format(Client.Function.Translate.Get("vehicle-hash-null"), Creator.Track.Current.AvailableVehicles[classid].vehicles[i].model))
						end
						if Creator.Multiplayer.InSession then
							Creator.GlobalVar.FixEventSizeOverflow = true
							Creator.GlobalVar.FixEventSizeOverflowTimer = GetGameTimer()
							Creator.Multiplayer.ModificationCount.availableVehicles = Creator.Multiplayer.ModificationCount.availableVehicles + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {defaultClass = Creator.Track.Current.DefaultClass, availableVehicles = Creator.Track.Current.AvailableVehicles, modificationCount = Creator.Multiplayer.ModificationCount.availableVehicles}, "available-vehicles-sync")
						end
					end
				end)
			end
		end, function(Panels)
		end)
	end

	Creator.Menu.Placement.Main:IsVisible(function(Items)
		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-StartingGrid"), (#Creator.Track.Current.StartingGrid == 0) and Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-StartingGrid-Desc"), {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→", Color = (#Creator.Track.Current.StartingGrid == 0) and {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}}, function(onSelected)

		end, Creator.Menu.Placement.StartingGrid)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Checkpoint"), (#Creator.Track.Current.Checkpoints < 10) and Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Checkpoint-Desc"), {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→", Color = (#Creator.Track.Current.Checkpoints < 10) and {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}}, function(onSelected)

		end, Creator.Menu.Placement.Checkpoint.Main)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Prop"), (#Creator.Track.Current.Objects == 0) and Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Prop-Desc"), {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→", Color = (#Creator.Track.Current.Objects == 0) and {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}}, function(onSelected)

		end, Creator.Menu.Placement.Prop)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Template"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

		end, Creator.Menu.Placement.Template)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-MoveAll"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

		end, Creator.Menu.Placement.MoveAll)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-FixtureRemover"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

		end, Creator.Menu.Placement.Fixture)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Firework"), nil, {IsDisabled = IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

		end, Creator.Menu.Placement.Firework)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Import"), not Creator.Multiplayer.InSession and Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Import-Desc"), {IsDisabled = not Creator.Multiplayer.InSession or IsNuiFocused() or Creator.GlobalVar.Lock or Creator.GlobalVar.RunningMainThread or Creator.Multiplayer.LockSession, Color = not Creator.Multiplayer.InSession and {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Client.Function.Translate.Get("paste-url")
				})
				Client.NUI.Callback = "import ugc"
			end
		end)

		if Creator.GlobalVar.Querying then
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Main-Button-Cancel"), nil, {IsDisabled = false}, function(onSelected)
				if onSelected then
					Creator.GlobalVar.Querying = false
					TriggerServerEvent("server:creator:cancelSearch")
				end
			end)
		end
	end, function(Panels)
	end)

	Creator.Menu.Placement.StartingGrid:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-StartingGrid-List-CycleItems"), {Creator.StartingGrid.Index .. " / " .. #Creator.Track.Current.StartingGrid}, 1, nil, {IsDisabled = #Creator.Track.Current.StartingGrid == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				if Creator.StartingGrid.Select then
					Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
					end
					ResetEntityAlpha(Creator.StartingGrid.Select)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutlineShader(1)
					SetEntityDrawOutline(Creator.StartingGrid.Select, true)
				end
				if Creator.StartingGrid.Preview then
					DeleteVehicle(Creator.StartingGrid.Preview)
					Creator.StartingGrid.Preview = nil
				end
				local index = Creator.StartingGrid.Index - 1
				if index < 1 then
					index = #Creator.Track.Current.StartingGrid
				elseif index > #Creator.Track.Current.StartingGrid then
					index = 1
				end
				Creator.StartingGrid.Index = index
				Creator.GlobalVar.IsSelectingStartingGridVehicle = true
				Creator.StartingGrid.IsPickedUp = true
				Creator.StartingGrid.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index])
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
				Creator.StartingGrid.Select = Creator.StartingGrid.Current.handle
				SetEntityDrawOutline(Creator.StartingGrid.Select, false)
				SetEntityAlpha(Creator.StartingGrid.Select, 150)
				local min, max = Client.Function.Shared.GetModelDimensionsInCaches(GetEntityModel(Creator.StartingGrid.Select))
				Creator.Camera.Position = vector3(Creator.StartingGrid.Current.x + (20.0 - min.z) * math.sin(math.rad(Creator.StartingGrid.Current.heading)), Creator.StartingGrid.Current.y - (20.0 - min.z) * math.cos(math.rad(Creator.StartingGrid.Current.heading)), Creator.StartingGrid.Current.z + (20.0 - min.z))
				Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.StartingGrid.Current.heading}
			elseif onListChange == "right" then
				if Creator.StartingGrid.Select then
					Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
					end
					ResetEntityAlpha(Creator.StartingGrid.Select)
					SetEntityDrawOutlineColor(255, 255, 255, 125)
					SetEntityDrawOutlineShader(1)
					SetEntityDrawOutline(Creator.StartingGrid.Select, true)
				end
				if Creator.StartingGrid.Preview then
					DeleteVehicle(Creator.StartingGrid.Preview)
					Creator.StartingGrid.Preview = nil
				end
				local index = Creator.StartingGrid.Index + 1
				if index < 1 then
					index = #Creator.Track.Current.StartingGrid
				elseif index > #Creator.Track.Current.StartingGrid then
					index = 1
				end
				Creator.StartingGrid.Index = index
				Creator.GlobalVar.IsSelectingStartingGridVehicle = true
				Creator.StartingGrid.IsPickedUp = true
				Creator.StartingGrid.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index])
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
				Creator.StartingGrid.Select = Creator.StartingGrid.Current.handle
				SetEntityDrawOutline(Creator.StartingGrid.Select, false)
				SetEntityAlpha(Creator.StartingGrid.Select, 150)
				local min, max = Client.Function.Shared.GetModelDimensionsInCaches(GetEntityModel(Creator.StartingGrid.Select))
				Creator.Camera.Position = vector3(Creator.StartingGrid.Current.x + (20.0 - min.z) * math.sin(math.rad(Creator.StartingGrid.Current.heading)), Creator.StartingGrid.Current.y - (20.0 - min.z) * math.cos(math.rad(Creator.StartingGrid.Current.heading)), Creator.StartingGrid.Current.z + (20.0 - min.z))
				Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.StartingGrid.Current.heading}
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.StartingGrid.Index)
				})
				Client.NUI.Callback = "goto startingGrid"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-StartingGrid-Button-Place"), (#Creator.Track.Current.StartingGrid >= 48) and Client.Function.Translate.Get("Menu-Creator-Placement-StartingGrid-Button-startingGridLimit-Desc") or nil, {IsDisabled = (#Creator.Track.Current.StartingGrid >= 48) or IsNuiFocused() or not Creator.StartingGrid.Preview or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				ResetEntityAlpha(Creator.StartingGrid.Preview)
				SetEntityDrawOutlineColor(255, 255, 255, 125)
				SetEntityDrawOutlineShader(1)
				SetEntityDrawOutline(Creator.StartingGrid.Preview, true)
				table.insert(Creator.Track.Current.StartingGrid, Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current))
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, insertIndex = #Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
				end
				Creator.StartingGrid.Index = #Creator.Track.Current.StartingGrid
				Creator.StartingGrid.Preview = nil
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
				Creator.Function.ResetGlobalVariable("startingGrid")
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-StartingGrid-List-Heading"), {Creator.StartingGrid.Current.handle and Creator.StartingGrid.Current.heading or ""}, 1, nil, {IsDisabled = IsNuiFocused() or not Creator.StartingGrid.Current.handle or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.StartingGrid.Current.heading = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading - Creator.Speed.GridOffset.Value[Creator.Speed.GridOffset.Index][2], 3)
				if (Creator.StartingGrid.Current.heading <= -9999.0) or (Creator.StartingGrid.Current.heading >= 9999.0) then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					Creator.StartingGrid.Current.heading = 0.0
				end
				SetEntityRotation(Creator.StartingGrid.Current.handle, 0.0, 0.0, Creator.StartingGrid.Current.heading, 2, 0)
				if Creator.StartingGrid.IsPickedUp and Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] then
					Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
					Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
					end
				end
			elseif onListChange == "right" then
				Creator.StartingGrid.Current.heading = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading + Creator.Speed.GridOffset.Value[Creator.Speed.GridOffset.Index][2], 3)
				if (Creator.StartingGrid.Current.heading <= -9999.0) or (Creator.StartingGrid.Current.heading >= 9999.0) then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					Creator.StartingGrid.Current.heading = 0.0
				end
				SetEntityRotation(Creator.StartingGrid.Current.handle, 0.0, 0.0, Creator.StartingGrid.Current.heading, 2, 0)
				if Creator.StartingGrid.IsPickedUp and Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] then
					Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
					Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
					end
				end
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.StartingGrid.Current.heading)
				})
				Client.NUI.Callback = "startingGrid heading"
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-StartingGrid-List-ChangeSpeed"), {Creator.Speed.GridOffset.Value[Creator.Speed.GridOffset.Index][1]}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Speed.GridOffset.Index - 1
				if index < 1 then
					index = #Creator.Speed.GridOffset.Value
				end
				Creator.Speed.GridOffset.Index = index
			elseif onListChange == "right" then
				local index = Creator.Speed.GridOffset.Index + 1
				if index > #Creator.Speed.GridOffset.Value then
					index = 1
				end
				Creator.Speed.GridOffset.Index = index
			end
		end)

		Items:AddSeparator("x = " .. (Creator.StartingGrid.Current.x or 0.0) .. ", y = " .. (Creator.StartingGrid.Current.y or 0.0) .. ", z = " .. (Creator.StartingGrid.Current.z or 0.0), false)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-StartingGrid-Button-Delete"), nil, {IsDisabled = IsNuiFocused() or not Creator.StartingGrid.IsPickedUp or Creator.Multiplayer.LockSession, Color = {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}, Emoji = "⚠️"}, function(onSelected)
			if onSelected then
				Creator.StartingGrid.Select = nil
				Creator.StartingGrid.IsPickedUp = false
				DeleteVehicle(Creator.StartingGrid.Current.handle)
				local deleteIndex = 0
				for k, v in pairs(Creator.Track.Current.StartingGrid) do
					if Creator.StartingGrid.Current.handle == v.handle then
						deleteIndex = k
						table.remove(Creator.Track.Current.StartingGrid, k)
						break
					end
				end
				if Creator.StartingGrid.Index > #Creator.Track.Current.StartingGrid then
					Creator.StartingGrid.Index = #Creator.Track.Current.StartingGrid
				end
				Creator.Function.ResetGlobalVariable("startingGrid")
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, deleteIndex = deleteIndex, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
				end
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.Placement.Checkpoint.Main:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-CycleItems"), {Creator.Checkpoint.Index .. " / " .. #Creator.Track.Current.Checkpoints}, 1, nil, {IsDisabled = (Creator.GlobalVar.IsPrimaryCheckpointItems and (#Creator.Track.Current.Checkpoints == 0)) or (not Creator.GlobalVar.IsPrimaryCheckpointItems and (Client.Function.Math.TableCount(Creator.Track.Current.Checkpoints_2) == 0)) or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				if Creator.GlobalVar.IsPrimaryCheckpointItems then
					local index = Creator.Checkpoint.Index - 1
					if index < 1 then
						index = #Creator.Track.Current.Checkpoints
					elseif index > #Creator.Track.Current.Checkpoints then
						index = 1
					end
					Creator.Checkpoint.Index = index
				else
					local found = false
					for i = Creator.Checkpoint.Index - 1, 1, -1 do
						if Creator.Track.Current.Checkpoints_2[i] then
							Creator.Checkpoint.Index = i
							found = true
							break
						end
					end
					if not found then
						for i = #Creator.Track.Current.Checkpoints, 1, -1 do
							if Creator.Track.Current.Checkpoints_2[i] then
								Creator.Checkpoint.Index = i
								break
							end
						end
					end
				end
				Creator.Checkpoint.IsPickedUp = true
				Creator.Checkpoint.Preview = nil
				Creator.Checkpoint.Current = Creator.GlobalVar.IsPrimaryCheckpointItems and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index]) or Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading, 3)
				local d = Creator.Checkpoint.Current.diameterDraw
				local isRound = Creator.Checkpoint.Current.isRound
				local isAir = Creator.Checkpoint.Current.isAir
				local isFake = Creator.Checkpoint.Current.isFake
				local isRandom = Creator.Checkpoint.Current.isRandom
				local isTransform = Creator.Checkpoint.Current.isTransform
				local isPlaneRot = Creator.Checkpoint.Current.isPlaneRot
				local isWarp = Creator.Checkpoint.Current.isWarp
				local drawSize = ((isAir and (4.5 * d)) or ((isRound or isRandom or isTransform or isPlaneRot or isWarp) and (2.25 * d)) or d) * 10
				Creator.Camera.Position = vector3(Creator.Checkpoint.Current.x + (20.0 + drawSize) * math.sin(math.rad(Creator.Checkpoint.Current.heading)), Creator.Checkpoint.Current.y - (20.0 + drawSize) * math.cos(math.rad(Creator.Checkpoint.Current.heading)), Creator.Checkpoint.Current.z + (20.0 + drawSize))
				Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Checkpoint.Current.heading}
			elseif onListChange == "right" then
				if Creator.GlobalVar.IsPrimaryCheckpointItems then
					local index = Creator.Checkpoint.Index + 1
					if index < 1 then
						index = #Creator.Track.Current.Checkpoints
					elseif index > #Creator.Track.Current.Checkpoints then
						index = 1
					end
					Creator.Checkpoint.Index = index
				else
					local found = false
					for i = Creator.Checkpoint.Index + 1, #Creator.Track.Current.Checkpoints, 1 do
						if Creator.Track.Current.Checkpoints_2[i] then
							Creator.Checkpoint.Index = i
							found = true
							break
						end
					end
					if not found then
						for i = 1, #Creator.Track.Current.Checkpoints, 1 do
							if Creator.Track.Current.Checkpoints_2[i] then
								Creator.Checkpoint.Index = i
								break
							end
						end
					end
				end
				Creator.Checkpoint.IsPickedUp = true
				Creator.Checkpoint.Preview = nil
				Creator.Checkpoint.Current = Creator.GlobalVar.IsPrimaryCheckpointItems and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index]) or Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading, 3)
				local d = Creator.Checkpoint.Current.diameterDraw
				local isRound = Creator.Checkpoint.Current.isRound
				local isAir = Creator.Checkpoint.Current.isAir
				local isFake = Creator.Checkpoint.Current.isFake
				local isRandom = Creator.Checkpoint.Current.isRandom
				local isTransform = Creator.Checkpoint.Current.isTransform
				local isPlaneRot = Creator.Checkpoint.Current.isPlaneRot
				local isWarp = Creator.Checkpoint.Current.isWarp
				local drawSize = ((isAir and (4.5 * d)) or ((isRound or isRandom or isTransform or isPlaneRot or isWarp) and (2.25 * d)) or d) * 10
				Creator.Camera.Position = vector3(Creator.Checkpoint.Current.x + (20.0 + drawSize) * math.sin(math.rad(Creator.Checkpoint.Current.heading)), Creator.Checkpoint.Current.y - (20.0 + drawSize) * math.cos(math.rad(Creator.Checkpoint.Current.heading)), Creator.Checkpoint.Current.z + (20.0 + drawSize))
				Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Checkpoint.Current.heading}
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Checkpoint.Index)
				})
				Client.NUI.Callback = "goto checkpoint"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Button-Test"), nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.IsPickedUp or (Creator.Checkpoint.IsPickedUp and (Creator.GlobalVar.IsPrimaryCheckpointItems and not Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index]) or (not Creator.GlobalVar.IsPrimaryCheckpointItems and not Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index])) or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				TriggerServerEvent("server:core:inTestMode", true)
				Creator.GlobalVar.JoiningTest = true
				Creator.GlobalVar.EnableTest = true
				Creator.GlobalVar.IsRespawning = true
				Creator.GlobalVar.TipsRendered = false
				CreateThread(function()
					SetRadarBigmapEnabled(false, false)
					Wait(0)
					SetRadarZoom(1200)
				end)
				DoScreenFadeOut(0)
				SendNUIMessage({
					action = "fade out",
					time = 0
				})
				UnlockMinimapAngle()
				UnlockMinimapPosition()
				SetBlipAlpha(GetMainPlayerBlipId(), 255)
				RemoveBlip(Creator.GlobalVar.CreatorBlipHandle)
				Creator.GlobalVar.CreatorBlipHandle = nil
				for k, v in pairs(Creator.Blips.Checkpoints) do
					RemoveBlip(v)
				end
				for k, v in pairs(Creator.Blips.Checkpoints_2) do
					RemoveBlip(v)
				end
				Creator.Blips.Checkpoints = {}
				Creator.Blips.Checkpoints_2 = {}
				Creator.ArenaProps = {}
				Creator.ExplodeProps = {}
				Creator.FireworkProps = {}
				for k, v in pairs(Creator.Track.Current.Objects) do
					if v.dynamic then
						if Client.Shared.Object.Arena[v.hash] then
							Creator.ArenaProps[#Creator.ArenaProps + 1] = v
						end
						if Client.Shared.Object.Explode[v.hash] then
							Creator.ExplodeProps[#Creator.ExplodeProps + 1] = v
						end
					end
					if Client.Shared.Object.Firework[v.hash] then
						Creator.FireworkProps[#Creator.FireworkProps + 1] = v
					end
				end
				for uniqueId, effectData in pairs(Creator.ObjectPool.ActiveEffects) do
					if effectData.ptfxHandle then
						StopParticleFxLooped(effectData.ptfxHandle, true)
						effectData.ptfxHandle = nil
					end
					Creator.ObjectPool.ActiveEffects[uniqueId] = nil
				end
				for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
					if object.handle then
						DeleteObject(object.handle)
						object.handle = nil
					end
					Creator.ObjectPool.ActiveObjects[uniqueId] = nil
				end
				Creator.ObjectPool.ActiveGrids = {}
				Creator.Function.UpdateBlip("object", nil)
				CreateThread(function()
					RageUI.CloseAll()
					Wait(500)
					Client.Function.Message.Display(string.format(Client.Function.Translate.Get("respawn-tip"), IsUsingKeyboard() and "F" or "Y"))
					Wait(100)
					BeginTextCommandDisplayHelp("THREESTRINGS")
					AddTextComponentSubstringPlayerName(Client.Function.Translate.Get("quit-test"))
					AddTextComponentSubstringPlayerName("")
					AddTextComponentSubstringPlayerName("")
					EndTextCommandDisplayHelp(0, true, true, -1)
					Creator.GlobalVar.TestData.Checkpoints = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints) or {}
					Creator.GlobalVar.TestData.Checkpoints_2 = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2) or {}
					Creator.Function.CreateCheckpointBlip(Creator.GlobalVar.RespawnData.DrawIndex)
					Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, false)
					Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, true)
					Creator.GlobalVar.TipsRendered = true
				end)
				Creator.GlobalVar.RespawnData = {
					Index = Creator.Checkpoint.Index,
					DrawIndex = Creator.Checkpoint.Index + 1
				}
				local checkpoint = {}
				if Creator.GlobalVar.IsPrimaryCheckpointItems then
					checkpoint = Creator.Track.Current.Checkpoints[Creator.GlobalVar.RespawnData.Index] and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints[Creator.GlobalVar.RespawnData.Index]) or {}
				else
					checkpoint = Creator.Track.Current.Checkpoints_2[Creator.GlobalVar.RespawnData.Index] and Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Checkpoints_2[Creator.GlobalVar.RespawnData.Index]) or {}
				end
				Creator.GlobalVar.RespawnData.x = checkpoint.x or 0.0
				Creator.GlobalVar.RespawnData.y = checkpoint.y or 0.0
				Creator.GlobalVar.RespawnData.z = checkpoint.z or 0.0
				Creator.GlobalVar.RespawnData.heading = checkpoint.heading or 0.0
				Creator.GlobalVar.RespawnData.model = checkpoint.isTransform and Creator.Track.Current.TransformVehicles[checkpoint.transformIndex + 1]
				Creator.GlobalVar.JoiningTest = false
				Creator.Function.TestCurrentCheckpoint(Creator.GlobalVar.RespawnData, function(ped)
					FreezeEntityPosition(ped, false)
					SetEntityVisible(ped, true)
					SetEntityCollision(ped, true, true)
					SetEntityCompletelyDisableCollision(ped, true, true)
					RenderScriptCams(false, false, 0, true, false)
					DestroyCam(Creator.Camera.Handle, false)
					Creator.Camera.Handle = nil
				end)
			end
		end)

		Items:AddList("", {Creator.GlobalVar.IsPrimaryCheckpointItems and Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Primary") or Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Secondary")}, 1, nil, {IsDisabled = IsNuiFocused() or Creator.Checkpoint.IsPickedUp or not Creator.Checkpoint.Preview or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange then
				Creator.GlobalVar.IsPrimaryCheckpointItems = not Creator.GlobalVar.IsPrimaryCheckpointItems
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Button-Place"), nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.Preview or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.GlobalVar.IsPrimaryCheckpointItems and (#Creator.Track.Current.Checkpoints + 1) or Creator.Checkpoint.Index)
				})
				Client.NUI.Callback = "place checkpoint"
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Alignment"), {Creator.Checkpoint.OverrideRelativeEnable and Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Alignment-Relative") or Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Alignment-World")}, 1, nil, {IsDisabled = IsNuiFocused() or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange then
				Creator.Checkpoint.OverrideRelativeEnable = not Creator.Checkpoint.OverrideRelativeEnable
			end
		end)

		Items:AddList("X:", {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.x or ""}, 1, nil, {IsDisabled = IsNuiFocused() or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				if not Creator.Checkpoint.OverrideRelativeEnable then
					Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.x - Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(Creator.Checkpoint.Current.x, Creator.Checkpoint.Current.y, Creator.Checkpoint.Current.z, Creator.Checkpoint.Current.heading, -Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 0.0, 0.0)
					Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(coords.x, 3)
					Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(coords.y, 3)
					Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(coords.z, 3)
				end
			elseif onListChange == "right" then
				if not Creator.Checkpoint.OverrideRelativeEnable then
					Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.x + Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(Creator.Checkpoint.Current.x, Creator.Checkpoint.Current.y, Creator.Checkpoint.Current.z, Creator.Checkpoint.Current.heading, Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 0.0, 0.0)
					Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(coords.x, 3)
					Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(coords.y, 3)
					Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(coords.z, 3)
				end
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Checkpoint.Current.x)
				})
				Client.NUI.Callback = "checkpoint x"
			end
			if onListChange or onSelected then
				Creator.Checkpoint.PreviewCoordsChanged = true
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList("Y:", {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.y or ""}, 1, nil, {IsDisabled = IsNuiFocused() or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				if not Creator.Checkpoint.OverrideRelativeEnable then
					Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.y - Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(Creator.Checkpoint.Current.x, Creator.Checkpoint.Current.y, Creator.Checkpoint.Current.z, Creator.Checkpoint.Current.heading, 0.0, -Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 0.0)
					Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(coords.x, 3)
					Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(coords.y, 3)
					Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(coords.z, 3)
				end
			elseif onListChange == "right" then
				if not Creator.Checkpoint.OverrideRelativeEnable then
					Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.y + Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				else
					local coords = GetOffsetFromCoordAndHeadingInWorldCoords(Creator.Checkpoint.Current.x, Creator.Checkpoint.Current.y, Creator.Checkpoint.Current.z, Creator.Checkpoint.Current.heading, 0.0, Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 0.0)
					Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(coords.x, 3)
					Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(coords.y, 3)
					Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(coords.z, 3)
				end
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Checkpoint.Current.y)
				})
				Client.NUI.Callback = "checkpoint y"
			end
			if onListChange or onSelected then
				Creator.Checkpoint.PreviewCoordsChanged = true
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList("Z:", {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.z or ""}, 1, nil, {IsDisabled = IsNuiFocused() or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.z - Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.z + Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Checkpoint.Current.z)
				})
				Client.NUI.Callback = "checkpoint z"
			end
			if onListChange or onSelected then
				Creator.Checkpoint.PreviewCoordsChanged = true
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-LockDirection"), nil, Creator.Checkpoint.Current.lockDirection, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.lockDirection = IsChecked
				if IsChecked then
					Creator.Checkpoint.Current.isRound = true
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Heading"), {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.heading or ""}, 1, nil, {IsDisabled = IsNuiFocused() or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.heading = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading - Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				if (Creator.Checkpoint.Current.heading <= -9999.0) or (Creator.Checkpoint.Current.heading >= 9999.0) then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					Creator.Checkpoint.Current.heading = 0.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading, 3)
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.heading = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading + Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				if (Creator.Checkpoint.Current.heading <= -9999.0) or (Creator.Checkpoint.Current.heading >= 9999.0) then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					Creator.Checkpoint.Current.heading = 0.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.heading, 3)
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Checkpoint.Current.heading)
				})
				Client.NUI.Callback = "checkpoint heading"
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Pitch"), {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.pitch or ""}, 1, nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.Current.lockDirection or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.pitch = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.pitch - Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				if (Creator.Checkpoint.Current.pitch <= -9999.0) or (Creator.Checkpoint.Current.pitch >= 9999.0) then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					Creator.Checkpoint.Current.pitch = 0.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.pitch = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.pitch + Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][2], 3)
				if (Creator.Checkpoint.Current.pitch <= -9999.0) or (Creator.Checkpoint.Current.pitch >= 9999.0) then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					Creator.Checkpoint.Current.pitch = 0.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Checkpoint.Current.pitch)
				})
				Client.NUI.Callback = "checkpoint pitch"
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-ChangeSpeed"), {Creator.Speed.CheckpointOffset.Value[Creator.Speed.CheckpointOffset.Index][1]}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Speed.CheckpointOffset.Index - 1
				if index < 1 then
					index = #Creator.Speed.CheckpointOffset.Value
				end
				Creator.Speed.CheckpointOffset.Index = index
			elseif onListChange == "right" then
				local index = Creator.Speed.CheckpointOffset.Index + 1
				if index > #Creator.Speed.CheckpointOffset.Value then
					index = 1
				end
				Creator.Speed.CheckpointOffset.Index = index
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-DiameterDraw"), {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.diameterDraw or ""}, 1, nil, {IsDisabled = IsNuiFocused() or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.diameterDraw = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.diameterDraw - 0.25, 3)
				if Creator.Checkpoint.Current.diameterDraw < 0.5 then
					Creator.Checkpoint.Current.diameterDraw = 5.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						local checkpoint_2 = Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index]
						if checkpoint_2 then
							checkpoint_2.diameterDraw = Creator.Checkpoint.Current.diameterDraw
						end
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						local checkpoint = Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index]
						if checkpoint then
							checkpoint.diameterDraw = Creator.Checkpoint.Current.diameterDraw
						end
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.diameterDraw = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.diameterDraw + 0.25, 3)
				if Creator.Checkpoint.Current.diameterDraw > 5.0 then
					Creator.Checkpoint.Current.diameterDraw = 0.5
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						local checkpoint_2 = Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index]
						if checkpoint_2 then
							checkpoint_2.diameterDraw = Creator.Checkpoint.Current.diameterDraw
						end
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						local checkpoint = Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index]
						if checkpoint then
							checkpoint.diameterDraw = Creator.Checkpoint.Current.diameterDraw
						end
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-DiameterCollect"), {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.diameterCollect or ""}, 1, nil, {IsDisabled = IsNuiFocused() or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.diameterCollect = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.diameterCollect - 0.25, 3)
				if Creator.Checkpoint.Current.diameterCollect < 0.5 then
					Creator.Checkpoint.Current.diameterCollect = 5.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.diameterCollect = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.diameterCollect + 0.25, 3)
				if Creator.Checkpoint.Current.diameterCollect > 5.0 then
					Creator.Checkpoint.Current.diameterCollect = 0.5
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-LowerAlpha"), nil, Creator.Checkpoint.Current.lowerAlpha, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.lowerAlpha = IsChecked
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Air"), nil, Creator.Checkpoint.Current.isAir, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isAir = IsChecked
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Fake"), nil, Creator.Checkpoint.Current.isFake, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isFake = IsChecked
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Tall"), nil, Creator.Checkpoint.Current.isTall, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isTall = IsChecked
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-TallRadius"), {(Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and Creator.Checkpoint.Current.isTall and Creator.Checkpoint.Current.tallRadius or ""}, 1, nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.Current.isTall or (not Creator.Checkpoint.IsPickedUp and not Creator.Checkpoint.Preview) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.tallRadius = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.tallRadius - 100.0, 3)
				if Creator.Checkpoint.Current.tallRadius < 100.0 then
					Creator.Checkpoint.Current.tallRadius = 1000.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.tallRadius = Client.Function.Math.RoundedValue(Creator.Checkpoint.Current.tallRadius + 100.0, 3)
				if Creator.Checkpoint.Current.tallRadius > 1000.0 then
					Creator.Checkpoint.Current.tallRadius = 100.0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Pit"), nil, Creator.Checkpoint.Current.isPit, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isPit = IsChecked
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Round"), nil, Creator.Checkpoint.Current.isRound, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				if Creator.Checkpoint.Current.isRandom or Creator.Checkpoint.Current.isTransform or Creator.Checkpoint.Current.isPlaneRot or Creator.Checkpoint.Current.isWarp then
					Client.Function.Message.Display(Client.Function.Translate.Get("checkpoints-round-lock"))
				else
					Creator.Checkpoint.Current.isRound = IsChecked
					if not IsChecked then
						Creator.Checkpoint.Current.lockDirection = false
					end
					if Creator.Checkpoint.IsPickedUp then
						if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
							Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
						end
						Creator.Function.UpdateBlip("checkpoint")
						if Creator.Multiplayer.InSession then
							Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
						end
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Random"), nil, Creator.Checkpoint.Current.isRandom, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isRandom = IsChecked
				if IsChecked then
					Creator.Checkpoint.Current.isRound = true
					Creator.Checkpoint.Current.randomClass = 0
					Creator.Checkpoint.Current.randomCustom = nil
					Creator.Checkpoint.Current.randomSetting = nil
					Creator.Checkpoint.Current.isTransform = nil
					Creator.Checkpoint.Current.transformIndex = nil
				else
					Creator.Checkpoint.Current.randomClass = nil
					Creator.Checkpoint.Current.randomCustom = nil
					Creator.Checkpoint.Current.randomSetting = nil
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Random"), {(Creator.Checkpoint.Current.randomClass == 0 and Client.Function.Translate.Get("RandomClass-0")) or (Creator.Checkpoint.Current.randomClass == 1 and Client.Function.Translate.Get("RandomClass-1")) or (Creator.Checkpoint.Current.randomClass == 2 and Client.Function.Translate.Get("RandomClass-2")) or (Creator.Checkpoint.Current.randomClass == 3 and Client.Function.Translate.Get("RandomClass-3")) or (Creator.Checkpoint.Current.randomClass == -1 and Client.Function.Translate.Get("RandomClass-Custom")) or (Creator.Checkpoint.Current.randomClass == -2 and Client.Function.Translate.Get("RandomClass-Transform")) or (Creator.Checkpoint.Current.randomClass and "NULL") or ""}, 1, nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.Current.isRandom or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.randomClass = Creator.Checkpoint.Current.randomClass - 1
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.randomClass = Creator.Checkpoint.Current.randomClass + 1
			end
			if onListChange then
				if Creator.Checkpoint.Current.randomClass < -2 then
					Creator.Checkpoint.Current.randomClass = 3
				elseif Creator.Checkpoint.Current.randomClass > 3 then
					Creator.Checkpoint.Current.randomClass = -2
				end
				if Creator.Checkpoint.Current.randomClass == -1 then
					Creator.Checkpoint.Current.randomCustom = 1
					Creator.Checkpoint.Current.randomSetting = "Compact"
				else
					Creator.Checkpoint.Current.randomCustom = nil
					Creator.Checkpoint.Current.randomSetting = nil
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		if Creator.Checkpoint.Current.isRandom and not Creator.Checkpoint.Current.isTransform then
			if Creator.Checkpoint.Current.randomClass == -1 and Creator.Checkpoint.Current.randomCustom then
				Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-ExtraRandomSetting"), {(Creator.Checkpoint.Current.randomCustom == 1 and Client.Function.Translate.Get("ExtraRandomSetting-1")) or (Creator.Checkpoint.Current.randomCustom == 2 and Client.Function.Translate.Get("ExtraRandomSetting-2")) or (Creator.Checkpoint.Current.randomCustom == 3 and Client.Function.Translate.Get("ExtraRandomSetting-3")) or (Creator.Checkpoint.Current.randomCustom == 4 and Client.Function.Translate.Get("ExtraRandomSetting-4")) or ""}, 1, nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
					if onListChange == "left" then
						Creator.Checkpoint.Current.randomCustom = Creator.Checkpoint.Current.randomCustom - 1
					elseif onListChange == "right" then
						Creator.Checkpoint.Current.randomCustom = Creator.Checkpoint.Current.randomCustom + 1
					end
					if onListChange then
						if Creator.Checkpoint.Current.randomCustom < 1 then
							Creator.Checkpoint.Current.randomCustom = 4
						elseif Creator.Checkpoint.Current.randomCustom > 4 then
							Creator.Checkpoint.Current.randomCustom = 1
						end
						if Creator.Checkpoint.Current.randomCustom == 1 then
							Creator.Checkpoint.Current.randomSetting = "Compact"
						elseif Creator.Checkpoint.Current.randomCustom == 2 then
							Creator.Checkpoint.Current.randomSetting = 1
						elseif Creator.Checkpoint.Current.randomCustom == 3 then
							Creator.Checkpoint.Current.randomSetting = {"bmx", "t20", "xa21"}
						elseif Creator.Checkpoint.Current.randomCustom == 4 then
							Creator.Checkpoint.Current.randomSetting = true
						end
						if Creator.Checkpoint.IsPickedUp then
							if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
								Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
							elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
								Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
							end
							Creator.Function.UpdateBlip("checkpoint")
							if Creator.Multiplayer.InSession then
								Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
							end
						end
					end
				end)

				if Creator.Checkpoint.Current.randomCustom == 1 then
					Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Button-ExtraRandomSetting-1"), nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

					end, Creator.Menu.Placement.Checkpoint.ExtraRandomSetting)
				elseif Creator.Checkpoint.Current.randomCustom == 2 then
					Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Button-ExtraRandomSetting-2"), nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession, RightLabel = "→→→"}, function(onSelected)

					end, Creator.Menu.Placement.Checkpoint.ExtraRandomSetting)
				elseif Creator.Checkpoint.Current.randomCustom == 3 then
					Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Button-ExtraRandomSetting-3"), nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(onSelected)
						if onSelected then
							SetNuiFocus(true, true)
							SendNUIMessage({
								action = "input open",
								value = Creator.Checkpoint.Current.randomSetting
							})
							Client.NUI.Callback = "checkpoint random custom"
						end
					end)
				end
			end
		end

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Transform"), nil, Creator.Checkpoint.Current.isTransform, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isTransform = IsChecked
				if IsChecked then
					Creator.Checkpoint.Current.isRound = true
					Creator.Checkpoint.Current.transformIndex = 0
					Creator.Checkpoint.Current.isRandom = nil
					Creator.Checkpoint.Current.randomClass = nil
					Creator.Checkpoint.Current.randomCustom = nil
					Creator.Checkpoint.Current.randomSetting = nil
				else
					Creator.Checkpoint.Current.transformIndex = nil
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		local vehName = ""
		if Creator.Checkpoint.Current.isTransform and (#Creator.Track.Current.TransformVehicles > 0) then
			if Creator.Track.Current.TransformVehicles[Creator.Checkpoint.Current.transformIndex + 1] == -422877666 then
				vehName = Client.Function.Translate.Get("Transform-Parachute")
			elseif Creator.Track.Current.TransformVehicles[Creator.Checkpoint.Current.transformIndex + 1] == -731262150 then
				vehName = Client.Function.Translate.Get("Transform-Beast")
			elseif Creator.Track.Current.TransformVehicles[Creator.Checkpoint.Current.transformIndex + 1] == 0 then
				vehName = Client.Function.Translate.Get("Transform-Default")
			else
				local transformVehicle = Creator.Track.Current.TransformVehicles[Creator.Checkpoint.Current.transformIndex + 1]
				local model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
				vehName = GetLabelText(GetDisplayNameFromVehicleModel(model))
			end
		elseif #Creator.Track.Current.TransformVehicles == 0 then
			vehName = "No Valid Vehicles"
		end
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-Transform"), {vehName}, 1, nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.Current.isTransform or (#Creator.Track.Current.TransformVehicles == 0) or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.transformIndex = Creator.Checkpoint.Current.transformIndex - 1
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.transformIndex = Creator.Checkpoint.Current.transformIndex + 1
			end
			if onListChange then
				if Creator.Checkpoint.Current.transformIndex < 0 then
					Creator.Checkpoint.Current.transformIndex = #Creator.Track.Current.TransformVehicles - 1
				elseif Creator.Checkpoint.Current.transformIndex > (#Creator.Track.Current.TransformVehicles - 1) then
					Creator.Checkpoint.Current.transformIndex = 0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		if not Creator.Checkpoint.Current.isRandom and Creator.Checkpoint.Current.isTransform then
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Button-Transform"), nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(onSelected)
				if onSelected then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "input open",
						value = Creator.Track.Current.TransformVehicles
					})
					Client.NUI.Callback = "checkpoint transform vehicles"
				end
			end)
		end

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-PlaneRot"), nil, Creator.Checkpoint.Current.isPlaneRot, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isPlaneRot = IsChecked
				if IsChecked then
					Creator.Checkpoint.Current.isRound = true
					Creator.Checkpoint.Current.planeRot = 0
				else
					Creator.Checkpoint.Current.planeRot = nil
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-List-PlaneRot"), {(Creator.Checkpoint.Current.planeRot == 0 and Client.Function.Translate.Get("PlaneRot-0")) or (Creator.Checkpoint.Current.planeRot == 1 and Client.Function.Translate.Get("PlaneRot-1")) or (Creator.Checkpoint.Current.planeRot == 2 and Client.Function.Translate.Get("PlaneRot-2")) or (Creator.Checkpoint.Current.planeRot == 3 and Client.Function.Translate.Get("PlaneRot-3")) or ""}, 1, nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.Current.isPlaneRot or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Checkpoint.Current.planeRot = Creator.Checkpoint.Current.planeRot - 1
			elseif onListChange == "right" then
				Creator.Checkpoint.Current.planeRot = Creator.Checkpoint.Current.planeRot + 1
			end
			if onListChange then
				if Creator.Checkpoint.Current.planeRot < 0 then
					Creator.Checkpoint.Current.planeRot = 3
				elseif Creator.Checkpoint.Current.planeRot > 3 then
					Creator.Checkpoint.Current.planeRot = 0
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-CheckBox-Warp"), nil, Creator.Checkpoint.Current.isWarp, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and (Creator.Checkpoint.IsPickedUp or Creator.Checkpoint.Preview) and not Creator.Multiplayer.LockSession then
				Creator.Checkpoint.Current.isWarp = IsChecked
				if IsChecked then
					Creator.Checkpoint.Current.isRound = true
				end
				if Creator.Checkpoint.IsPickedUp then
					if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
						Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
					end
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Checkpoint-Main-Button-Delete"), nil, {IsDisabled = IsNuiFocused() or not Creator.Checkpoint.IsPickedUp or Creator.Multiplayer.LockSession, Color = {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}, Emoji = "⚠️"}, function(onSelected)
			if onSelected then
				local deleteIndex = Creator.Checkpoint.Index
				local success = false
				if Creator.GlobalVar.IsPrimaryCheckpointItems then
					if Creator.Track.Current.Checkpoints[deleteIndex] then
						success = true
						table.remove(Creator.Track.Current.Checkpoints, deleteIndex)
						local checkpoints_2 = {}
						for k, v in pairs(Creator.Track.Current.Checkpoints_2) do
							if deleteIndex > k then
								checkpoints_2[k] = v
							elseif deleteIndex < k then
								checkpoints_2[k - 1] = v
							end
						end
						Creator.Track.Current.Checkpoints_2 = Client.Function.Shared.TableDeepCopy(checkpoints_2)
						if Creator.Checkpoint.Index > #Creator.Track.Current.Checkpoints then
							Creator.Checkpoint.Index = #Creator.Track.Current.Checkpoints
						end
					end
				else
					success = true
					Creator.Track.Current.Checkpoints_2[deleteIndex] = nil
				end
				if success then
					Creator.Checkpoint.IsPickedUp = false
					Creator.Function.ResetGlobalVariable("checkpoint")
					Creator.Function.UpdateBlip("checkpoint")
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, deleteIndex = deleteIndex, isPrimaryCheckpoint = Creator.GlobalVar.IsPrimaryCheckpointItems, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
					end
				end
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.Placement.Checkpoint.ExtraRandomSetting:IsVisible(function(Items)
		if Creator.Checkpoint.Current.isRandom and Creator.Checkpoint.Current.randomClass == -1 and Creator.Checkpoint.Current.randomCustom == 1 and type(Creator.Checkpoint.Current.randomSetting) == "string" then
			for i = 0, 22 do
				if Client.Vehicle.Classes[i] then
					Items:CheckBox(Client.Function.Translate.Get(Client.Vehicle.Classes[i]), nil, Creator.Checkpoint.Current.randomSetting == Client.Vehicle.Classes[i], {Style = 1}, function(onSelected, IsChecked)
						if onSelected and Creator.Checkpoint.Current.randomSetting ~= Client.Vehicle.Classes[i] and IsChecked and not IsNuiFocused() and not Creator.Multiplayer.LockSession then
							Creator.Checkpoint.Current.randomSetting = Client.Vehicle.Classes[i]
							if Creator.Checkpoint.IsPickedUp then
								if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
									Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
								elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
									Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
								end
								Creator.Function.UpdateBlip("checkpoint")
								if Creator.Multiplayer.InSession then
									Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
									TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
								end
							end
						end
					end)
				end
			end
		elseif Creator.Checkpoint.Current.isRandom and Creator.Checkpoint.Current.randomClass == -1 and Creator.Checkpoint.Current.randomCustom == 2 and type(Creator.Checkpoint.Current.randomSetting) == "number" then
			for i = 0, 22 do
				if Client.Vehicle.Classes[i] then
					Items:CheckBox(Client.Function.Translate.Get(Client.Vehicle.Classes[i]), nil, Client.Function.Math.IsBitSetValue(Creator.Checkpoint.Current.randomSetting, i), {Style = 1}, function(onSelected, IsChecked)
						if onSelected and not IsNuiFocused() and not Creator.Multiplayer.LockSession then
							local randomSetting = Creator.Checkpoint.Current.randomSetting
							if IsChecked then
								randomSetting = Client.Function.Math.SetBitValue(randomSetting, i)
							else
								randomSetting = Client.Function.Math.ClearBitValue(randomSetting, i)
							end
							if randomSetting > 0 then
								Creator.Checkpoint.Current.randomSetting = randomSetting
								if Creator.Checkpoint.IsPickedUp then
									if Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] then
										Creator.Track.Current.Checkpoints[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
									elseif not Creator.GlobalVar.IsPrimaryCheckpointItems and Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] then
										Creator.Track.Current.Checkpoints_2[Creator.Checkpoint.Index] = Client.Function.Shared.TableDeepCopy(Creator.Checkpoint.Current)
									end
									Creator.Function.UpdateBlip("checkpoint")
									if Creator.Multiplayer.InSession then
										Creator.Multiplayer.ModificationCount.checkpoints = Creator.Multiplayer.ModificationCount.checkpoints + 1
										TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {checkpoints = Creator.Track.Current.Checkpoints, checkpoints_2 = Creator.Track.Current.Checkpoints_2, modificationCount = Creator.Multiplayer.ModificationCount.checkpoints}, "checkpoints-sync")
									end
								end
							end
						end
					end)
				end
			end
		else
			RageUI.GoBack(true)
		end
	end, function(Panels)
	end)

	Creator.Menu.Placement.Prop:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-CycleItems"), {Creator.Object.Index .. " / " .. #Creator.Track.Current.Objects}, 1, nil, {IsDisabled = Creator.Snapping.Enable or #Creator.Track.Current.Objects == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Object.Index - 1
				if index < 1 then
					index = #Creator.Track.Current.Objects
				elseif index > #Creator.Track.Current.Objects then
					index = 1
				end
				Creator.Object.Index = index
				Creator.Object.IsPickedUp = true
				if Creator.Object.Preview then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
				end
				Creator.Object.Current = Creator.Track.Current.Objects[Creator.Object.Index]
				Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
				Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
				Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
				Creator.GlobalVar.PropColor = Creator.Object.Current.color
				Creator.LastValidHash = Creator.Object.Current.hash
				local found = false
				for k, v in pairs(Creator.Data.Category.List) do
					for i = 1, #v.model do
						local hash = tonumber(v.model[i]) or GetHashKey(v.model[i])
						if Creator.LastValidHash == hash then
							found = true
							Creator.LastValidText = v.model[i]
							v.index = i
							Creator.Data.Category.Index = k
							break
						end
					end
					if found then break end
				end
				if not found then
					local hash_2 = tonumber(Creator.LastValidText) or GetHashKey(Creator.LastValidText)
					if Creator.LastValidHash ~= hash_2 then
						Creator.LastValidText = tostring(Creator.LastValidHash) or ""
					end
				end
				local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Object.Current.hash)
				Creator.Camera.Position = vector3(Creator.Object.Current.x + (20.0 - min.z) * math.sin(math.rad(Creator.Object.Current.rotZ)), Creator.Object.Current.y - (20.0 - min.z) * math.cos(math.rad(Creator.Object.Current.rotZ)), Creator.Object.Current.z + (20.0 - min.z))
				Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Object.Current.rotZ}
			elseif onListChange == "right" then
				local index = Creator.Object.Index + 1
				if index < 1 then
					index = #Creator.Track.Current.Objects
				elseif index > #Creator.Track.Current.Objects then
					index = 1
				end
				Creator.Object.Index = index
				Creator.Object.IsPickedUp = true
				if Creator.Object.Preview then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
				end
				Creator.Object.Current = Creator.Track.Current.Objects[Creator.Object.Index]
				Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
				Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
				Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
				Creator.GlobalVar.PropColor = Creator.Object.Current.color
				Creator.LastValidHash = Creator.Object.Current.hash
				local found = false
				for k, v in pairs(Creator.Data.Category.List) do
					for i = 1, #v.model do
						local hash = tonumber(v.model[i]) or GetHashKey(v.model[i])
						if Creator.LastValidHash == hash then
							found = true
							Creator.LastValidText = v.model[i]
							v.index = i
							Creator.Data.Category.Index = k
							break
						end
					end
					if found then break end
				end
				if not found then
					local hash_2 = tonumber(Creator.LastValidText) or GetHashKey(Creator.LastValidText)
					if Creator.LastValidHash ~= hash_2 then
						Creator.LastValidText = tostring(Creator.LastValidHash) or ""
					end
				end
				local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Object.Current.hash)
				Creator.Camera.Position = vector3(Creator.Object.Current.x + (20.0 - min.z) * math.sin(math.rad(Creator.Object.Current.rotZ)), Creator.Object.Current.y - (20.0 - min.z) * math.cos(math.rad(Creator.Object.Current.rotZ)), Creator.Object.Current.z + (20.0 - min.z))
				Creator.Camera.Rotation = {x = -45.0, y = 0.0, z = Creator.Object.Current.rotZ}
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Object.Index)
				})
				Client.NUI.Callback = "goto prop"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-Button-EnterModelHash"), Client.Function.Translate.Get("Menu-Creator-Placement-Prop-Button-EnterModelHash-Desc"), {IsDisabled = IsNuiFocused() or Creator.Object.IsPickedUp or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				if Creator.Object.Preview then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
					Creator.Function.ResetGlobalVariable("object")
				end
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = Creator.LastValidText or ""
				})
				Client.NUI.Callback = "prop hash"
			end
		end)

		Items:AddList(string.format(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-Category"), Creator.Data.Category.Index, #Creator.Data.Category.List), {Creator.Data.Category.List[Creator.Data.Category.Index].class}, 1, nil, {IsDisabled = IsNuiFocused() or Creator.Object.IsPickedUp or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Data.Category.Index = Creator.Data.Category.Index - 1
				if Creator.Data.Category.Index < 1 then
					Creator.Data.Category.Index = #Creator.Data.Category.List
				end
				if Creator.Object.Preview then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
					Creator.Function.ResetGlobalVariable("object")
				end
				Creator.LastValidHash = nil
				Creator.GlobalVar.PropColor = nil
			elseif onListChange == "right" then
				Creator.Data.Category.Index = Creator.Data.Category.Index + 1
				if Creator.Data.Category.Index > #Creator.Data.Category.List then
					Creator.Data.Category.Index = 1
				end
				if Creator.Object.Preview then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
					Creator.Function.ResetGlobalVariable("object")
				end
				Creator.LastValidHash = nil
				Creator.GlobalVar.PropColor = nil
			end
		end)

		Items:AddList(string.format(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-Model"), Creator.Data.Category.List[Creator.Data.Category.Index].index, #Creator.Data.Category.List[Creator.Data.Category.Index].model), {#Creator.Data.Category.List[Creator.Data.Category.Index].model == 0 and "" or (Client.Function.Translate.GetObjectLabelText(Creator.Data.Category.List[Creator.Data.Category.Index].model[Creator.Data.Category.List[Creator.Data.Category.Index].index]) .. (Creator.Data.Category.Index < #Creator.Data.Category.List and Creator.Data.Favorite[tonumber(Creator.Data.Category.List[Creator.Data.Category.Index].model[Creator.Data.Category.List[Creator.Data.Category.Index].index]) or GetHashKey(Creator.Data.Category.List[Creator.Data.Category.Index].model[Creator.Data.Category.List[Creator.Data.Category.Index].index])] and "★" or ""))}, 1, nil, {IsDisabled = #Creator.Data.Category.List[Creator.Data.Category.Index].model == 0 or IsNuiFocused() or Creator.Object.IsPickedUp or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Data.Category.List[Creator.Data.Category.Index].index - 1
				if index < 1 then
					index = #Creator.Data.Category.List[Creator.Data.Category.Index].model
				end
				Creator.Data.Category.List[Creator.Data.Category.Index].index = index
			elseif onListChange == "right" then
				local index = Creator.Data.Category.List[Creator.Data.Category.Index].index + 1
				if index > #Creator.Data.Category.List[Creator.Data.Category.Index].model then
					index = 1
				end
				Creator.Data.Category.List[Creator.Data.Category.Index].index = index
			end
			if onListChange or onSelected then
				if Creator.Object.Preview then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
					Creator.Function.ResetGlobalVariable("object")
				end
				Creator.LastValidHash = nil
				Creator.GlobalVar.PropColor = nil
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-Button-Place"), nil, {IsDisabled = (Creator.Snapping.Enable and not Creator.Snapping.Handle) or IsNuiFocused() or not Creator.Object.Preview or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				if Creator.Object.PreviewEffect then
					StopParticleFxLooped(Creator.Object.PreviewEffect, true)
					Creator.Object.PreviewEffect = nil
				end
				DeleteObject(Creator.Object.Preview)
				Creator.Object.Preview = nil
				local object = Creator.Object.Current
				object.handle = nil
				local gx = math.floor(object.x / 100.0)
				local gy = math.floor(object.y / 100.0)
				Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
				Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
				if Client.Function.Math.TableCount(Creator.ObjectPool.Grids[gx][gy]) < 300 then
					Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
					Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
					if Client.Shared.Object.Effect[object.hash] then
						Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
					end
					Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
					if Creator.Snapping.Enable and not Creator.Snapping.SphericalMode then
						Creator.Snapping.Handle = nil
						Creator.Snapping.ObjectData = nil
						Creator.Snapping.NextObjectUniqueId = object.uniqueId
					end
					if Creator.Multiplayer.InSession then
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-place")
					end
					Creator.Object.Index = #Creator.Track.Current.Objects
				else
					Client.Function.Message.Display(Client.Function.Translate.Get("300-limit"))
				end
				Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
				Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
				Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
				Creator.GlobalVar.PropColor = Creator.Object.Current.color
				Creator.Function.ResetGlobalVariable("object")
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-CheckBox-Snapping"), nil, Creator.Snapping.Enable, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and not Creator.Multiplayer.LockSession then
				Creator.Snapping.Enable = IsChecked
				if Creator.Snapping.Enable then
					if Creator.Object.IsPickedUp then
						Creator.Object.IsPickedUp = false
						Creator.Function.ResetGlobalVariable("object")
					end
				else
					if Creator.Snapping.Handle then
						Creator.Snapping.Handle = nil
						Creator.Snapping.ObjectData = nil
					end
				end
				Creator.Snapping.NextObjectUniqueId = nil
			end
		end)

		if Creator.Snapping.Enable then
			if Creator.Snapping.Handle then
				if Creator.Snapping.BoneIndexParent > GetEntityBoneCount(Creator.Snapping.Handle) - 1 then
					Creator.Snapping.BoneIndexParent = -1
				end
			end
			if Creator.Object.Current.handle then
				if Creator.Snapping.BoneIndexChild > GetEntityBoneCount(Creator.Object.Current.handle) - 1 then
					Creator.Snapping.BoneIndexChild = -1
				end
			end
			Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneIndexParent"), {Creator.Snapping.Handle and Creator.Function.Object.GetBoneName(Creator.Snapping.Handle, Creator.Snapping.BoneIndexParent) or ""}, 1, nil, {IsDisabled = not Creator.Snapping.Handle or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if onListChange == "left" then
					local index = Creator.Snapping.BoneIndexParent - 1
					if index < -28 then
						index = GetEntityBoneCount(Creator.Snapping.Handle) - 1
					end
					Creator.Snapping.BoneIndexParent = index
					Creator.Function.Object.SetNewPositionAndRotationEnhanced()
				elseif onListChange == "right" then
					local index = Creator.Snapping.BoneIndexParent + 1
					if index > GetEntityBoneCount(Creator.Snapping.Handle) - 1 then
						index = -28
					end
					Creator.Snapping.BoneIndexParent = index
					Creator.Function.Object.SetNewPositionAndRotationEnhanced()
				end
			end)

			Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-BoneIndexChild"), {Creator.Object.Current.handle and Creator.Function.Object.GetBoneName(Creator.Object.Current.handle, Creator.Snapping.BoneIndexChild) or ""}, 1, nil, {IsDisabled = not Creator.Object.Current.handle or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if onListChange == "left" then
					local index = Creator.Snapping.BoneIndexChild - 1
					if index < -28 then
						index = GetEntityBoneCount(Creator.Object.Current.handle) - 1
					end
					Creator.Snapping.BoneIndexChild = index
					Creator.Function.Object.SetNewPositionAndRotationEnhanced()
				elseif onListChange == "right" then
					local index = Creator.Snapping.BoneIndexChild + 1
					if index > GetEntityBoneCount(Creator.Object.Current.handle) - 1 then
						index = -28
					end
					Creator.Snapping.BoneIndexChild = index
					Creator.Function.Object.SetNewPositionAndRotationEnhanced()
				end
			end)

			Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-CheckBox-Spherical"), nil, Creator.Snapping.SphericalMode, {Style = 1}, function(onSelected, IsChecked)
				if onSelected and not IsNuiFocused() and not Creator.Multiplayer.LockSession then
					Creator.Snapping.SphericalMode = IsChecked
					Creator.Snapping.NextObjectUniqueId = nil
				end
			end)

			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-Button-Reset"), nil, {IsDisabled = false}, function(onSelected)
				if onSelected then
					Creator.Snapping.Offset.steps = {}
					Creator.Snapping.Offset.x = 0.0
					Creator.Snapping.Offset.y = 0.0
					Creator.Snapping.Offset.z = 0.0
					Creator.Snapping.Offset.rotX = 0.0
					Creator.Snapping.Offset.rotY = 0.0
					Creator.Snapping.Offset.rotZ = 0.0
					Creator.Function.Object.SetNewPositionAndRotationEnhanced()
				end
			end)
		else
			Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-Alignment"), {Creator.Object.OverrideRelativeEnable and Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-Alignment-Relative") or Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-Alignment-World")}, 1, nil, {IsDisabled = not Creator.Object.Current.handle or not Creator.Object.Current.x or not Creator.Object.Current.y or not Creator.Object.Current.z or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if onListChange then
					Creator.Object.OverrideRelativeEnable = not Creator.Object.OverrideRelativeEnable
				end
			end)

			if Creator.Object.OverrideRelativeEnable then
				if Creator.Object.Current.handle then
					if Creator.Object.OverrideRotIndex > GetEntityBoneCount(Creator.Object.Current.handle) - 1 then
						Creator.Object.OverrideRotIndex = -1
					end
				end
				Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-AlignmentEnhanced"), {Creator.Object.Current.handle and Creator.Function.Object.GetBoneName(Creator.Object.Current.handle, Creator.Object.OverrideRotIndex) or ""}, 1, nil, {IsDisabled = not Creator.Object.Current.handle or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
					if onListChange == "left" then
						local index = Creator.Object.OverrideRotIndex - 1
						if index < -28 then
							index = GetEntityBoneCount(Creator.Object.Current.handle) - 1
						end
						Creator.Object.OverrideRotIndex = index
					elseif onListChange == "right" then
						local index = Creator.Object.OverrideRotIndex + 1
						if index > GetEntityBoneCount(Creator.Object.Current.handle) - 1 then
							index = -28
						end
						Creator.Object.OverrideRotIndex = index
					end
				end)
			end
		end

		Creator.Snapping.CanInsertData = false

		local lists = {
			{label = "X", key = "x"},
			{label = "Y", key = "y"},
			{label = "Z", key = "z"},
			{label = "Rot X", key = "rotX"},
			{label = "Rot Y", key = "rotY"},
			{label = "Rot Z", key = "rotZ"}
		}
		for i = 1, #lists do
			Items:AddList(Creator.Snapping.Enable and (Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-Offset") .. " " .. lists[i].label .. ":") or (lists[i].label .. ":"), {(Creator.Snapping.Enable and Creator.Snapping.Handle and Creator.Object.Current.handle and Creator.Snapping.Offset[lists[i].key]) or (not Creator.Snapping.Enable and Creator.Object.Current.handle and Creator.Object.Current[lists[i].key]) or ""}, 1, nil, {IsDisabled = (Creator.Snapping.Enable and (not Creator.Snapping.Handle or not Creator.Object.Current.handle)) or (not Creator.Snapping.Enable and (not Creator.Object.Current.handle or not Creator.Object.Current[lists[i].key])) or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if Creator.Snapping.Enable then
					if onListChange then
						local stepIndex = #Creator.Snapping.Offset.steps
						if stepIndex > 0 and Creator.Snapping.Offset.steps[stepIndex].axis == lists[i].key and Creator.Snapping.Offset.steps[stepIndex].sphericalMode == Creator.Snapping.SphericalMode then
							local value = Creator.Snapping.Offset.steps[stepIndex].value + (onListChange == "left" and -Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2] or Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2])
							if value ~= 0.0 then
								Creator.Snapping.Offset.steps[stepIndex].value = value
							else
								Creator.Snapping.Offset.steps[stepIndex] = nil
							end
						else
							Creator.Snapping.Offset.steps[stepIndex + 1] = {axis = lists[i].key, value = onListChange == "left" and -Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2] or Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2], sphericalMode = Creator.Snapping.SphericalMode}
						end
						Creator.Function.Object.GetOffsetPositionAndRotation()
						Creator.Function.Object.SetNewPositionAndRotationEnhanced()
					end
					if not Creator.Object.IsPickedUp and Creator.Object.Preview then
						Creator.Snapping.CanInsertData = true
						if onSelected then
							if Creator.Object.PreviewEffect then
								StopParticleFxLooped(Creator.Object.PreviewEffect, true)
								Creator.Object.PreviewEffect = nil
							end
							DeleteObject(Creator.Object.Preview)
							Creator.Object.Preview = nil
							local object = Creator.Object.Current
							object.handle = nil
							local gx = math.floor(object.x / 100.0)
							local gy = math.floor(object.y / 100.0)
							Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
							Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
							if Client.Function.Math.TableCount(Creator.ObjectPool.Grids[gx][gy]) < 300 then
								Creator.ObjectPool.Grids[gx][gy][object.uniqueId] = object
								Creator.ObjectPool.All[object.uniqueId] = gx .. "-" .. gy
								if Client.Shared.Object.Effect[object.hash] then
									Creator.ObjectPool.Effects[object.uniqueId] = {ptfxHandle = nil, object = object, style = Client.Shared.Object.Effect[object.hash]}
								end
								Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = object
								if not Creator.Snapping.SphericalMode then
									Creator.Snapping.Handle = nil
									Creator.Snapping.ObjectData = nil
									Creator.Snapping.NextObjectUniqueId = object.uniqueId
								end
								if Creator.Multiplayer.InSession then
									TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-place")
								end
								Creator.Object.Index = #Creator.Track.Current.Objects
							else
								Client.Function.Message.Display(Client.Function.Translate.Get("300-limit"))
							end
							Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
							Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
							Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
							Creator.GlobalVar.PropColor = Creator.Object.Current.color
							Creator.Function.ResetGlobalVariable("object")
						end
					end
				else
					if onListChange then
						local oldX = Creator.Object.Current.x
						local oldY = Creator.Object.Current.y
						local oldZ = Creator.Object.Current.z
						if not Creator.Object.OverrideRelativeEnable then
							local newValue = Client.Function.Math.RoundedValue(Creator.Object.Current[lists[i].key] + (onListChange == "left" and -Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2] or Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2]), 3)
							if i == 1 or i == 2 then
								if (newValue > -16000.0) and (newValue < 16000.0) then
									Creator.Object.Current[lists[i].key] = newValue
									SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
								else
									Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
								end
							elseif i == 3 then
								if (newValue > -200.0) and (newValue < 2700.0) then
									Creator.Object.Current[lists[i].key] = newValue
									SetEntityCoordsNoOffset(Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
								else
									Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
								end
							else
								if (newValue > -9999.0) and (newValue < 9999.0) then
									Creator.Object.Current[lists[i].key] = newValue
									SetEntityRotation(Creator.Object.Current.handle, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, 2, 0)
								else
									Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
								end
							end
						else
							Creator.Function.Object.SetNewPositionAndRotation(lists[i].key, onListChange == "left" and -Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2] or Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2])
						end
						if oldZ ~= Creator.Object.Current.z then
							Creator.Object.PreviewCoordsChanged = true
							Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
						elseif oldX ~= Creator.Object.Current.x or oldY ~= Creator.Object.Current.y then
							Creator.Object.PreviewCoordsChanged = true
						end
						if Creator.Object.IsPickedUp then
							if Creator.Multiplayer.InSession then
								Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
							end
							Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
							Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
							Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
							Creator.Function.Pool.RefreshGirdForObject(oldX, oldY, Creator.Object.Current)
						end
					end
					if onSelected then
						Creator.Object.PreviewCoordsChanged = true
						SetNuiFocus(true, true)
						SendNUIMessage({
							action = "input open",
							value = tostring(Creator.Object.Current[lists[i].key])
						})
						Client.NUI.Callback = "prop " .. lists[i].key
					end
				end
			end)
		end

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-ChangeSpeed"), {Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][1]}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Speed.PropOffset.Index - 1
				if index < 1 then
					index = #Creator.Speed.PropOffset.Value
				end
				Creator.Speed.PropOffset.Index = index
			elseif onListChange == "right" then
				local index = Creator.Speed.PropOffset.Index + 1
				if index > #Creator.Speed.PropOffset.Value then
					index = 1
				end
				Creator.Speed.PropOffset.Index = index
			end
		end)

		if not Creator.Snapping.Enable then
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-Button-Override"), nil, {IsDisabled = not Creator.Object.Current.handle or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(onSelected)
				if onSelected then
					Creator.Object.PreviewCoordsChanged = true
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "input open",
						value = "x = " .. (Creator.Object.Current.x) .. ", y = " .. (Creator.Object.Current.y) .. ", z = " .. (Creator.Object.Current.z) .. ", rotX = " .. (Creator.Object.Current.rotX) .. ", rotY = " .. (Creator.Object.Current.rotY) .. ", rotZ = " .. (Creator.Object.Current.rotZ)
					})
					Client.NUI.Callback = "prop override"
				end
			end)
		end

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-Color"), {Creator.Object.Current.handle and Creator.Object.Current.color or ""}, 1, nil, {IsDisabled = not Creator.Object.Current.handle or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Object.Current.color = Creator.Object.Current.color - 1
				if Creator.Object.Current.color < 0 then
					Creator.Object.Current.color = 15
				end
				SetObjectTextureVariation(Creator.Object.Current.handle, Creator.Object.Current.color)
				if Creator.Object.IsPickedUp then
					if Creator.Multiplayer.InSession then
						Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
					end
					Creator.GlobalVar.PropColor = Creator.Object.Current.color
				end
			elseif onListChange == "right" then
				Creator.Object.Current.color = Creator.Object.Current.color + 1
				if Creator.Object.Current.color > 15 then
					Creator.Object.Current.color = 0
				end
				SetObjectTextureVariation(Creator.Object.Current.handle, Creator.Object.Current.color)
				if Creator.Object.IsPickedUp then
					if Creator.Multiplayer.InSession then
						Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
					end
					Creator.GlobalVar.PropColor = Creator.Object.Current.color
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-CheckBox-Visible"), nil, Creator.Object.Current.visible, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and Creator.Object.Current.handle and not Creator.Multiplayer.LockSession then
				if Creator.Object.Current.dynamic then
					Client.Function.Message.Display(Client.Function.Translate.Get("visible-dynamic"))
				else
					Creator.Object.Current.visible = IsChecked
					if IsChecked then
						ResetEntityAlpha(Creator.Object.Current.handle)
					else
						SetEntityAlpha(Creator.Object.Current.handle, 150)
					end
					if Creator.Object.IsPickedUp then
						if Creator.Multiplayer.InSession then
							Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
						end
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-CheckBox-Collision"), nil, Creator.Object.Current.collision, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and Creator.Object.Current.handle and not Creator.Multiplayer.LockSession then
				Creator.Object.Current.collision = IsChecked
				if IsChecked then
					SetEntityCollision(Creator.Object.Current.handle, true, true)
				else
					SetEntityCollision(Creator.Object.Current.handle, false, false)
				end
				if Creator.Object.IsPickedUp then
					if Creator.Multiplayer.InSession then
						Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
					end
				end
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-CheckBox-Dynamic"), nil, Creator.Object.Current.dynamic, {Style = 1}, function(onSelected, IsChecked)
			if onSelected and not IsNuiFocused() and Creator.Object.Current.handle and not Creator.Multiplayer.LockSession then
				Creator.Object.Current.dynamic = IsChecked
				if IsChecked then
					if not Creator.Object.Current.visible then
						ResetEntityAlpha(Creator.Object.Current.handle)
						Creator.Object.Current.visible = true
						Client.Function.Message.Display(Client.Function.Translate.Get("visible-dynamic"))
					end
					Creator.Object.Current.prpsba = 2
				end
				if Creator.Object.IsPickedUp then
					if Creator.Multiplayer.InSession then
						Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
					end
				end
			end
		end)

		if Creator.Object.Current.hash and Client.Shared.Object.Speedup[Creator.Object.Current.hash] and not Creator.Object.Current.dynamic then
			Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-SpeedPad"), {Creator.Object.Current.handle and ((Creator.Object.Current.prpsba == 1 and Client.Function.Translate.Get("Speedup-1")) or (Creator.Object.Current.prpsba == 2 and Client.Function.Translate.Get("Speedup-2")) or (Creator.Object.Current.prpsba == 3 and Client.Function.Translate.Get("Speedup-3")) or (Creator.Object.Current.prpsba == 4 and Client.Function.Translate.Get("Speedup-4")) or (Creator.Object.Current.prpsba == 5 and Client.Function.Translate.Get("Speedup-5"))) or ""}, 1, nil, {IsDisabled = not Creator.Object.Current.handle or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if onListChange == "left" then
					Creator.Object.Current.prpsba = Creator.Object.Current.prpsba - 1
					if Creator.Object.Current.prpsba < 1 then
						Creator.Object.Current.prpsba = 5
					end
					if Creator.Object.IsPickedUp then
						if Creator.Multiplayer.InSession then
							Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
						end
					end
				elseif onListChange == "right" then
					Creator.Object.Current.prpsba = Creator.Object.Current.prpsba + 1
					if Creator.Object.Current.prpsba > 5 then
						Creator.Object.Current.prpsba = 1
					end
					if Creator.Object.IsPickedUp then
						if Creator.Multiplayer.InSession then
							Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
						end
					end
				end
			end)
		end

		if Creator.Object.Current.hash and Client.Shared.Object.SlowDown[Creator.Object.Current.hash] and not Creator.Object.Current.dynamic then
			Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-List-DragPad"), {Creator.Object.Current.handle and ((Creator.Object.Current.prpsba == 1 and Client.Function.Translate.Get("Speedup-1")) or (Creator.Object.Current.prpsba == 2 and Client.Function.Translate.Get("Speedup-2")) or (Creator.Object.Current.prpsba == 3 and Client.Function.Translate.Get("Speedup-3"))) or ""}, 1, nil, {IsDisabled = not Creator.Object.Current.handle or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if onListChange == "left" then
					Creator.Object.Current.prpsba = Creator.Object.Current.prpsba - 1
					if Creator.Object.Current.prpsba < 1 then
						Creator.Object.Current.prpsba = 3
					end
					if Creator.Object.IsPickedUp then
						if Creator.Multiplayer.InSession then
							Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
						end
					end
				elseif onListChange == "right" then
					Creator.Object.Current.prpsba = Creator.Object.Current.prpsba + 1
					if Creator.Object.Current.prpsba > 3 then
						Creator.Object.Current.prpsba = 1
					end
					if Creator.Object.IsPickedUp then
						if Creator.Multiplayer.InSession then
							Creator.Object.Current.modificationCount = Creator.Object.Current.modificationCount + 1
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-change")
						end
					end
				end
			end)
		end

		Creator.Object.DeleteActive = false
		if not Creator.Snapping.Enable then
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Prop-Button-Delete"), nil, {IsDisabled = IsNuiFocused() or not Creator.Object.IsPickedUp or Creator.Multiplayer.LockSession, Color = {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}, Emoji = "⚠️"}, function(onSelected)
				Creator.Object.DeleteActive = true
				if onSelected and Creator.Object.Current.uniqueId then
					if Creator.Multiplayer.InSession then
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, Creator.Object.Current, "objects-delete")
					end
					Creator.Object.IsPickedUp = false
					for k, v in pairs(Creator.Track.Current.Objects) do
						if v.uniqueId == Creator.Object.Current.uniqueId then
							table.remove(Creator.Track.Current.Objects, k)
							break
						end
					end
					Creator.ObjectPool.All[Creator.Object.Current.uniqueId] = nil
					Creator.ObjectPool.Effects[Creator.Object.Current.uniqueId] = nil
					for uniqueId, effectData in pairs(Creator.ObjectPool.ActiveEffects) do
						if uniqueId == Creator.Object.Current.uniqueId then
							if effectData.ptfxHandle then
								StopParticleFxLooped(effectData.ptfxHandle, true)
								effectData.ptfxHandle = nil
							end
							Creator.ObjectPool.ActiveEffects[uniqueId] = nil
							break
						end
					end
					for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
						if uniqueId == Creator.Object.Current.uniqueId then
							if object.handle then
								DeleteObject(object.handle)
								object.handle = nil
							end
							Creator.ObjectPool.ActiveObjects[uniqueId] = nil
							break
						end
					end
					local gx = math.floor(Creator.Object.Current.x / 100.0)
					local gy = math.floor(Creator.Object.Current.y / 100.0)
					if Creator.ObjectPool.Grids[gx] and Creator.ObjectPool.Grids[gx][gy] then
						Creator.ObjectPool.Grids[gx][gy][Creator.Object.Current.uniqueId] = nil
					end
					if Creator.Object.Index > #Creator.Track.Current.Objects then
						Creator.Object.Index = #Creator.Track.Current.Objects
					end
					Creator.Function.ResetGlobalVariable("object")
				end
			end)
		end
	end, function(Panels)
	end)

	Creator.Menu.Placement.Template:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Template-List-Templates"), {Creator.Data.Template.Index .. " / " .. #Creator.Data.Template.List}, 1, nil, {IsDisabled = (#Creator.Template.Current > 0) or (#Creator.Data.Template.List == 0) or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Data.Template.Index = Creator.Data.Template.Index - 1
				if Creator.Data.Template.Index < 1 then
					Creator.Data.Template.Index = #Creator.Data.Template.List
				end
				if #Creator.Template.Preview > 0 then
					for i = 1, #Creator.Template.Preview do
						DeleteObject(Creator.Template.Preview[i].handle)
					end
					Creator.Template.Preview = {}
				end
			elseif onListChange == "right" then
				Creator.Data.Template.Index = Creator.Data.Template.Index + 1
				if Creator.Data.Template.Index > #Creator.Data.Template.List then
					Creator.Data.Template.Index = 1
				end
				if #Creator.Template.Preview > 0 then
					for i = 1, #Creator.Template.Preview do
						DeleteObject(Creator.Template.Preview[i].handle)
					end
					Creator.Template.Preview = {}
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Template-Button-SaveTemplate"), (#Creator.Data.Template.List >= 30) and Client.Function.Translate.Get("Menu-Creator-Placement-Template-Button-SaveTemplate-Desc") or nil, {IsDisabled = (#Creator.Template.Current <= 1) or IsNuiFocused() or (#Creator.Data.Template.List >= 30) or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				for i = 1, #Creator.Template.Current do
					if DoesEntityExist(Creator.Template.Current[i].handle) then
						SetEntityDrawOutline(Creator.Template.Current[i].handle, false)
					end
				end
				TriggerServerEvent("server:creator:saveData", {template = Client.Function.Shared.TableDeepCopy(Creator.Template.Current)})
				table.insert(Creator.Data.Template.List, Client.Function.Shared.TableDeepCopy(Creator.Template.Current))
				Creator.Data.Template.Index = #Creator.Data.Template.List
				Creator.Template.IsPickedUp = false
				Creator.Function.ResetGlobalVariable("template")
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Template-Button-PlaceTemplate"), nil, {IsDisabled = #Creator.Template.Preview == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				local invalidX = false
				local invalidY = false
				local invalidZ = false
				local invalidRot = false
				local maxLimit = false
				local validObjects = {}
				for i = 1, #Creator.Template.Preview do
					DeleteObject(Creator.Template.Preview[i].handle)
					Creator.Template.Preview[i].handle = nil
					local gx = math.floor(Creator.Template.Preview[i].x / 100.0)
					local gy = math.floor(Creator.Template.Preview[i].y / 100.0)
					Creator.ObjectPool.Grids[gx] = Creator.ObjectPool.Grids[gx] or {}
					Creator.ObjectPool.Grids[gx][gy] = Creator.ObjectPool.Grids[gx][gy] or {}
					if Client.Function.Math.TableCount(Creator.ObjectPool.Grids[gx][gy]) < 300 then
						local overflow = false
						if (Creator.Template.Preview[i].x <= -16000.0) or (Creator.Template.Preview[i].x >= 16000.0) then
							overflow = true
							invalidX = true
						end
						if (Creator.Template.Preview[i].y <= -16000.0) or (Creator.Template.Preview[i].y >= 16000.0) then
							overflow = true
							invalidY = true
						end
						if (Creator.Template.Preview[i].z <= -200.0) or (Creator.Template.Preview[i].z >= 2700.0) then
							overflow = true
							invalidZ = true
						end
						if (Creator.Template.Preview[i].rotX <= -9999.0) or (Creator.Template.Preview[i].rotX >= 9999.0) or (Creator.Template.Preview[i].rotY <= -9999.0) or (Creator.Template.Preview[i].rotY >= 9999.0) or (Creator.Template.Preview[i].rotZ <= -9999.0) or (Creator.Template.Preview[i].rotZ >= 9999.0) then
							overflow = true
							invalidRot = true
						end
						if not overflow then
							Creator.ObjectPool.Grids[gx][gy][Creator.Template.Preview[i].uniqueId] = Creator.Template.Preview[i]
							Creator.ObjectPool.All[Creator.Template.Preview[i].uniqueId] = gx .. "-" .. gy
							if Client.Shared.Object.Effect[Creator.Template.Preview[i].hash] then
								Creator.ObjectPool.Effects[Creator.Template.Preview[i].uniqueId] = {ptfxHandle = nil, object = Creator.Template.Preview[i], style = Client.Shared.Object.Effect[Creator.Template.Preview[i].hash]}
							end
							Creator.Track.Current.Objects[#Creator.Track.Current.Objects + 1] = Creator.Template.Preview[i]
							table.insert(validObjects, Creator.Template.Preview[i])
						end
					else
						maxLimit = true
					end
				end
				if #validObjects >= 1 then
					if Creator.Multiplayer.InSession then
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, validObjects, "template-place")
					end
					Creator.Object.Index = #Creator.Track.Current.Objects
				end
				if invalidX or invalidY then
					Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
				end
				if invalidZ then
					Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
				end
				if invalidRot then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
				end
				if maxLimit then
					Client.Function.Message.Display(Client.Function.Translate.Get("300-limit"))
				end
				Creator.Template.Preview = {}
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Template-List-Alignment"), {Creator.Template.OverrideRelativeEnable and Client.Function.Translate.Get("Menu-Creator-Placement-Template-List-Alignment-Relative") or Client.Function.Translate.Get("Menu-Creator-Placement-Template-List-Alignment-World")}, 1, nil, {IsDisabled = #Creator.Template.Preview == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange then
				Creator.Template.OverrideRelativeEnable = not Creator.Template.OverrideRelativeEnable
			end
		end)

		local lists = {
			{label = "X", key = "x"},
			{label = "Y", key = "y"},
			{label = "Z", key = "z"},
			{label = "Rot X", key = "rotX"},
			{label = "Rot Y", key = "rotY"},
			{label = "Rot Z", key = "rotZ"}
		}
		for i = 1, #lists do
			Items:AddList(lists[i].label .. ":", {Creator.Template.Preview[1] and Creator.Template.Preview[1][lists[i].key] or ""}, 1, nil, {IsDisabled = #Creator.Template.Preview == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if onListChange then
					if not Creator.Template.OverrideRelativeEnable then
						local newValue = Client.Function.Math.RoundedValue(Creator.Template.Preview[1][lists[i].key] + (onListChange == "left" and -Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2] or Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2]), 3)
						if i == 1 then
							if (newValue > -16000.0) and (newValue < 16000.0) then
								local aPosNew, aRotNew = vector3(newValue, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
								local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
								Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
							else
								Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
							end
						elseif i == 2 then
							if (newValue > -16000.0) and (newValue < 16000.0) then
								local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, newValue, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
								local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
								Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
							else
								Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
							end
						elseif i == 3 then
							if (newValue > -200.0) and (newValue < 2700.0) then
								local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, newValue), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
								local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
								Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
							else
								Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
							end
						else
							if (newValue > -9999.0) and (newValue < 9999.0) then
								if i == 4 then
									local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(newValue, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
									local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
									Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
								elseif i == 5 then
									local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, newValue, Creator.Template.Preview[1].rotZ)
									local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
									Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
								elseif i == 6 then
									local aPosNew, aRotNew = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, newValue)
									local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
									Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
								end
							else
								Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
							end
						end
					else
						local aPosNew, aQuatNew = Creator.Function.Object.UpdateBySingleAxis(vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), Client.Function.Math.RotationToQuaternion(vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)), lists[i].key, onListChange == "left" and -Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2] or Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2])
						Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
					end
					Creator.GlobalVar.TemplateZposLock = Creator.Template.Preview[1].z
				end
				if onSelected then
					SetNuiFocus(true, true)
					SendNUIMessage({
						action = "input open",
						value = tostring(Creator.Template.Preview[1] and Creator.Template.Preview[1][lists[i].key])
					})
					Client.NUI.Callback = "template " .. lists[i].key
				end
				if onListChange or onSelected then
					Creator.Template.PreviewCoordsChanged = true
					for j = 1, #Creator.Template.Preview do
						if Creator.Template.Preview[j].collision then
							SetEntityCollision(Creator.Template.Preview[j].handle, true, true)
						end
					end
				end
			end)
		end

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Template-List-ChangeSpeed"), {Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][1]}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Speed.TemplateOffset.Index - 1
				if index < 1 then
					index = #Creator.Speed.TemplateOffset.Value
				end
				Creator.Speed.TemplateOffset.Index = index
			elseif onListChange == "right" then
				local index = Creator.Speed.TemplateOffset.Index + 1
				if index > #Creator.Speed.TemplateOffset.Value then
					index = 1
				end
				Creator.Speed.TemplateOffset.Index = index
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Template-Button-Override"), nil, {IsDisabled = #Creator.Template.Preview == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				Creator.Template.PreviewCoordsChanged = true
				for i = 1, #Creator.Template.Preview do
					if Creator.Template.Preview[i].collision then
						SetEntityCollision(Creator.Template.Preview[i].handle, true, true)
					end
				end
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = "x = " .. (Creator.Template.Preview[1] and Creator.Template.Preview[1].x) .. ", y = " .. (Creator.Template.Preview[1] and Creator.Template.Preview[1].y) .. ", z = " .. (Creator.Template.Preview[1] and Creator.Template.Preview[1].z) .. ", rotX = " .. (Creator.Template.Preview[1] and Creator.Template.Preview[1].rotX) .. ", rotY = " .. (Creator.Template.Preview[1] and Creator.Template.Preview[1].rotY) .. ", rotZ = " .. (Creator.Template.Preview[1] and Creator.Template.Preview[1].rotZ)
				})
				Client.NUI.Callback = "template override"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Template-Button-Delete"), nil, {IsDisabled = (#Creator.Template.Current > 0) or (#Creator.Data.Template.List == 0) or IsNuiFocused() or Creator.Multiplayer.LockSession, Color = {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}, Emoji = "⚠️"}, function(onSelected)
			if onSelected then
				if #Creator.Template.Preview > 0 then
					for i = 1, #Creator.Template.Preview do
						DeleteObject(Creator.Template.Preview[i].handle)
					end
					Creator.Template.Preview = {}
				end
				if Creator.Data.Template.List[Creator.Data.Template.Index] then
					TriggerServerEvent("server:creator:saveData", {template = Creator.Data.Template.Index})
					table.remove(Creator.Data.Template.List, Creator.Data.Template.Index)
				end
				if Creator.Data.Template.Index > #Creator.Data.Template.List then
					Creator.Data.Template.Index = #Creator.Data.Template.List
				end
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.Placement.MoveAll:IsVisible(function(Items)
		local lists = {
			{label = "X", key = "x"},
			{label = "Y", key = "y"},
			{label = "Z", key = "z"}
		}
		for i = 1, #lists do
			Items:AddList(lists[i].label .. ":", {""}, 1, nil, {IsDisabled = Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
				if onListChange then
					local overflow = false
					local value = onListChange == "left" and -Creator.Speed.MoveOffset.Value[Creator.Speed.MoveOffset.Index][2] or Creator.Speed.MoveOffset.Value[Creator.Speed.MoveOffset.Index][2]
					for k, v in pairs(Creator.Track.Current.StartingGrid) do
						if not Creator.Function.IsValueValid(i, Client.Function.Math.RoundedValue(v[lists[i].key] + value, 3)) then
							overflow = true
							break
						end
					end
					if not overflow then
						for k, v in pairs(Creator.Track.Current.Checkpoints) do
							if not Creator.Function.IsValueValid(i, Client.Function.Math.RoundedValue(v[lists[i].key] + value, 3)) then
								overflow = true
								break
							end
							local v_2 = Creator.Track.Current.Checkpoints_2[k]
							if v_2 then
								if not Creator.Function.IsValueValid(i, Client.Function.Math.RoundedValue(v_2[lists[i].key] + value, 3)) then
									overflow = true
									break
								end
							end
						end
					end
					if not overflow then
						for k, v in pairs(Creator.Track.Current.Objects) do
							if not Creator.Function.IsValueValid(i, Client.Function.Math.RoundedValue(v[lists[i].key] + value, 3)) then
								overflow = true
								break
							end
						end
					end
					if not overflow then
						for k, v in pairs(Creator.Track.Current.StartingGrid) do
							v[lists[i].key] = Client.Function.Math.RoundedValue(v[lists[i].key] + value, 3)
						end
						for k, v in pairs(Creator.Track.Current.Checkpoints) do
							v[lists[i].key] = Client.Function.Math.RoundedValue(v[lists[i].key] + value, 3)
							local v_2 = Creator.Track.Current.Checkpoints_2[k]
							if v_2 then
								v_2[lists[i].key] = Client.Function.Math.RoundedValue(v_2[lists[i].key] + value, 3)
							end
						end
						Creator.Function.UpdateBlip("checkpoint")
						for k, v in pairs(Creator.Track.Current.Objects) do
							v[lists[i].key] = Client.Function.Math.RoundedValue(v[lists[i].key] + value, 3)
							if v.handle then
								SetEntityCoordsNoOffset(v.handle, v.x, v.y, v.z)
							end
						end
						if Creator.Multiplayer.InSession then
							TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {offsetX = i == 1 and value or 0.0, offsetY = i == 2 and value or 0.0, offsetZ = i == 3 and value or 0.0}, "move-all")
						end
					else
						if i == 1 or i == 2 then
							Client.Function.Message.Display(Client.Function.Translate.Get("xy-limit"))
						elseif i == 3 then
							Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
						end
					end
				end
			end)
		end

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-MoveAll-List-ChangeSpeed"), {Creator.Speed.MoveOffset.Value[Creator.Speed.MoveOffset.Index][1]}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Speed.MoveOffset.Index - 1
				if index < 1 then
					index = #Creator.Speed.MoveOffset.Value
				end
				Creator.Speed.MoveOffset.Index = index
			elseif onListChange == "right" then
				local index = Creator.Speed.MoveOffset.Index + 1
				if index > #Creator.Speed.MoveOffset.Value then
					index = 1
				end
				Creator.Speed.MoveOffset.Index = index
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.Placement.Fixture:IsVisible(function(Items)
		local selectFixtureAvailable = false
		local deselectFixtureAvailable = false
		local foundFixture = false
		if Creator.Fixture.Current.handle then
			for k, v in pairs(Creator.Track.Current.Fixtures) do
				if v.hash == Creator.Fixture.Current.hash then
					foundFixture = true
					break
				end
			end
		end
		if not foundFixture then
			selectFixtureAvailable = true
		else
			deselectFixtureAvailable = true
		end
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Fixture-List-CycleItems"), {Creator.Fixture.Index .. " / " .. #Creator.Track.Current.Fixtures}, 1, nil, {IsDisabled = #Creator.Track.Current.Fixtures == 0 or IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Fixture.Index - 1
				if index < 1 then
					index = #Creator.Track.Current.Fixtures
				elseif index > #Creator.Track.Current.Fixtures then
					index = 1
				end
				Creator.Fixture.Index = index
				Creator.Fixture.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Fixtures[Creator.Fixture.Index])
				local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Fixture.Current.hash)
				Creator.Camera.Position = vector3(Creator.Fixture.Current.x, Creator.Fixture.Current.y, Creator.Fixture.Current.z + (10.0 + max.z - min.z))
				Creator.Camera.Rotation = {x = -89.9, y = 0.0, z = Creator.Camera.Rotation.z}
			elseif onListChange == "right" then
				local index = Creator.Fixture.Index + 1
				if index < 1 then
					index = #Creator.Track.Current.Fixtures
				elseif index > #Creator.Track.Current.Fixtures then
					index = 1
				end
				Creator.Fixture.Index = index
				Creator.Fixture.Current = Client.Function.Shared.TableDeepCopy(Creator.Track.Current.Fixtures[Creator.Fixture.Index])
				local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Fixture.Current.hash)
				Creator.Camera.Position = vector3(Creator.Fixture.Current.x, Creator.Fixture.Current.y, Creator.Fixture.Current.z + (10.0 + max.z - min.z))
				Creator.Camera.Rotation = {x = -89.9, y = 0.0, z = Creator.Camera.Rotation.z}
			end
			if onSelected then
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = "input open",
					value = tostring(Creator.Fixture.Index)
				})
				Client.NUI.Callback = "goto fixture"
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Fixture-Button-Select"), nil, {IsDisabled = IsNuiFocused() or not Creator.Fixture.Current.handle or not selectFixtureAvailable or Creator.Multiplayer.LockSession}, function(onSelected)
			if onSelected then
				table.insert(Creator.Track.Current.Fixtures, Client.Function.Shared.TableDeepCopy(Creator.Fixture.Current))
				Creator.Fixture.Index = #Creator.Track.Current.Fixtures
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.fixtures = Creator.Multiplayer.ModificationCount.fixtures + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {fixtures = Creator.Track.Current.Fixtures, modificationCount = Creator.Multiplayer.ModificationCount.fixtures}, "fixtures-sync")
				end
			end
		end)

		Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Placement-Fixture-Button-Deselect"), nil, {IsDisabled = IsNuiFocused() or not Creator.Fixture.Current.handle or not deselectFixtureAvailable or Creator.Multiplayer.LockSession, Color = {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}, Emoji = "⚠️"}, function(onSelected)
			if onSelected then
				for k, v in pairs(Creator.Track.Current.Fixtures) do
					if v.hash == Creator.Fixture.Current.hash then
						table.remove(Creator.Track.Current.Fixtures, k)
						break
					end
				end
				if Creator.Fixture.Index > #Creator.Track.Current.Fixtures then
					Creator.Fixture.Index = #Creator.Track.Current.Fixtures
				end
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.fixtures = Creator.Multiplayer.ModificationCount.fixtures + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {fixtures = Creator.Track.Current.Fixtures, modificationCount = Creator.Multiplayer.ModificationCount.fixtures}, "fixtures-sync")
				end
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.Placement.Firework:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Placement-Firework-List-ParticleName"), Creator.Firework.Particles, Creator.Firework.ParticleIndex, nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange then
				Creator.Firework.ParticleIndex = Index
				Creator.Track.Current.Firework.Name = Creator.Firework.Particles[Creator.Firework.ParticleIndex]
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.firework = Creator.Multiplayer.ModificationCount.firework + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {firework = Creator.Track.Current.Firework, modificationCount = Creator.Multiplayer.ModificationCount.firework}, "firework-sync")
				end
			end
		end)

		Items:AddList("R", {Creator.Track.Current.Firework.R}, 1, nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Track.Current.Firework.R = Creator.Track.Current.Firework.R - 1
				if Creator.Track.Current.Firework.R < 0 then
					Creator.Track.Current.Firework.R = 255
				end
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.firework = Creator.Multiplayer.ModificationCount.firework + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {firework = Creator.Track.Current.Firework, modificationCount = Creator.Multiplayer.ModificationCount.firework}, "firework-sync")
				end
			elseif onListChange == "right" then
				Creator.Track.Current.Firework.R = Creator.Track.Current.Firework.R + 1
				if Creator.Track.Current.Firework.R > 255 then
					Creator.Track.Current.Firework.R = 0
				end
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.firework = Creator.Multiplayer.ModificationCount.firework + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {firework = Creator.Track.Current.Firework, modificationCount = Creator.Multiplayer.ModificationCount.firework}, "firework-sync")
				end
			end
		end)

		Items:AddList("G", {Creator.Track.Current.Firework.G}, 1, nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Track.Current.Firework.G = Creator.Track.Current.Firework.G - 1
				if Creator.Track.Current.Firework.G < 0 then
					Creator.Track.Current.Firework.G = 255
				end
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.firework = Creator.Multiplayer.ModificationCount.firework + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {firework = Creator.Track.Current.Firework, modificationCount = Creator.Multiplayer.ModificationCount.firework}, "firework-sync")
				end
			elseif onListChange == "right" then
				Creator.Track.Current.Firework.G = Creator.Track.Current.Firework.G + 1
				if Creator.Track.Current.Firework.G > 255 then
					Creator.Track.Current.Firework.G = 0
				end
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.firework = Creator.Multiplayer.ModificationCount.firework + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {firework = Creator.Track.Current.Firework, modificationCount = Creator.Multiplayer.ModificationCount.firework}, "firework-sync")
				end
			end
		end)

		Items:AddList("B", {Creator.Track.Current.Firework.B}, 1, nil, {IsDisabled = IsNuiFocused() or Creator.Multiplayer.LockSession}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				Creator.Track.Current.Firework.B = Creator.Track.Current.Firework.B - 1
				if Creator.Track.Current.Firework.B < 0 then
					Creator.Track.Current.Firework.B = 255
				end
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.firework = Creator.Multiplayer.ModificationCount.firework + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {firework = Creator.Track.Current.Firework, modificationCount = Creator.Multiplayer.ModificationCount.firework}, "firework-sync")
				end
			elseif onListChange == "right" then
				Creator.Track.Current.Firework.B = Creator.Track.Current.Firework.B + 1
				if Creator.Track.Current.Firework.B > 255 then
					Creator.Track.Current.Firework.B = 0
				end
				if Creator.Multiplayer.InSession then
					Creator.Multiplayer.ModificationCount.firework = Creator.Multiplayer.ModificationCount.firework + 1
					TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {firework = Creator.Track.Current.Firework, modificationCount = Creator.Multiplayer.ModificationCount.firework}, "firework-sync")
				end
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.Multiplayer.Main:IsVisible(function(Items)
		if Creator.Track.Current.Title == "" then
			if #Creator.Multiplayer.InvitationList > 0 then
				for k, v in pairs(Creator.Multiplayer.InvitationList) do
					Items:AddButton(v.title, nil, {IsDisabled = Creator.GlobalVar.Lock or Creator.Multiplayer.InSession}, function(onSelected)
						if onSelected then
							Creator.GlobalVar.Lock = true
							CreateThread(function()
								Client.Busyspinner.Status = "download"
								RemoveLoadingPrompt()
								BeginTextCommandBusyString("STRING")
								AddTextComponentSubstringPlayerName(string.format(Client.Function.Translate.Get("download-progress"), 0))
								EndTextCommandBusyString(4)
								TriggerServerCallback("server:creator:joinPlayerSession", function(data, data_2, inSessionPlayers)
									if data and data_2 then
										Creator.Multiplayer.InSession = true
										Creator.Multiplayer.LockSession = true
										Creator.Function.Multiplayer.LoadSessionData(data, data_2)
										Creator.GlobalVar.ThumbnailValid = false
										SendNUIMessage({
											action = "thumbnail url",
											url = Creator.Track.Current.Thumbnail
										})
										RageUI.QuitIndex = nil
										RageUI.GoBack(true)
										Client.Function.Message.Display(Client.Function.Translate.Get("join-session-success"))
										TriggerServerEvent("server:creator:loadDone", Creator.Track.Current.RaceId)
										for i = 1, #inSessionPlayers do
											table.insert(Creator.Multiplayer.InSessionPlayers, inSessionPlayers[i])
										end
										if #Creator.Multiplayer.LoadingPlayers == 0 then
											Creator.Multiplayer.LockSession = false
										end
									else
										Client.Function.Message.Display(Client.Function.Translate.Get("join-session-failed"))
									end
									RemoveLoadingPrompt()
									Client.Busyspinner.Status = nil
									Creator.GlobalVar.Lock = false
									table.remove(Creator.Multiplayer.InvitationList, k)
								end, v.sessionId)
							end)
						end
					end)
				end
			else
				Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Multiplayer-Main-Button-No-Invitation"), nil, {IsDisabled = true}, function(onSelected)

				end)
			end
		else
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Multiplayer-Main-Button-Invite"), not Creator.Multiplayer.InSession and Client.Function.Translate.Get("Menu-Creator-Multiplayer-Main-Button-Invite-Desc"), {IsDisabled = not Creator.Multiplayer.InSession, RightLabel = "→→→", Color = not Creator.Multiplayer.InSession and {BackgroundColor = {255, 50, 50, 125}, HightLightColor = {255, 50, 50, 255}}}, function(onSelected)
				if onSelected then
					Creator.GlobalVar.Lock = true
					CreateThread(function()
						TriggerServerCallback("server:creator:getPlayerList", function(players)
							Creator.Multiplayer.AvailablePlayers = players
							Creator.GlobalVar.Lock = false
						end, Creator.Track.Current.RaceId)
					end)
				end
			end, Creator.Menu.Multiplayer.Invite)

			for k, v in pairs(Creator.Multiplayer.InSessionPlayers) do
				Items:AddButton(v.playerName or v.playerId, nil, {IsDisabled = Client.ServerId == v.playerId or Creator.GlobalVar.Lock}, function(onSelected)
					if onSelected then
						Creator.GlobalVar.Lock = true
						CreateThread(function()
							TriggerServerCallback("server:creator:getPlayerCoords", function(coords)
								if coords then
									Creator.Camera.Position = vector3(coords.x + 0.0, coords.y + 0.0, coords.z + 20.0)
									Creator.Camera.Rotation = {x = -89.9, y = 0.0, z = Creator.Camera.Rotation.z}
								end
								Creator.GlobalVar.Lock = false
							end, v.playerId)
						end)
					end
				end)
			end
		end
	end, function(Panels)
	end)

	Creator.Menu.Multiplayer.Invite:IsVisible(function(Items)
		if #Creator.Multiplayer.AvailablePlayers > 0 then
			for k, v in pairs(Creator.Multiplayer.AvailablePlayers) do
				Items:AddButton(v.playerName, nil, {IsDisabled = Creator.GlobalVar.Lock}, function(onSelected)
					if onSelected then
						TriggerServerEvent("server:creator:invitePlayer", v.playerId, Creator.Track.Current.Title, Creator.Track.Current.RaceId)
						table.remove(Creator.Multiplayer.AvailablePlayers, k)
					end
				end)
			end
		else
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Multiplayer-Invite-Button-No-Result"), nil, {IsDisabled = true}, function(onSelected)

			end)
		end
	end, function(Panels)
	end)

	Creator.Menu.Weather:IsVisible(function(Items)
		for i = 1, #Client.Weather.Types do
			local weatherType = Client.Weather.Types[i]
			Items:AddButton(Client.Function.Translate.Get(weatherType), nil, {IsDisabled = false}, function(onSelected)
				if onSelected then
					Client.Function.Environment.SetWeather(weatherType)
				end
			end)
		end
	end, function(Panels)
	end)

	Creator.Menu.Time:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Hours"), Client.Time.Hours, Client.Time.CurrentHour + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Function.Environment.SetTime(Index - 1, Client.Time.CurrentMinute, Client.Time.CurrentSecond)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Minutes"), Client.Time.Minutes, Client.Time.CurrentMinute + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Function.Environment.SetTime(Client.Time.CurrentHour, Index - 1, Client.Time.CurrentSecond)
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Seconds"), Client.Time.Seconds, Client.Time.CurrentSecond + 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange then
				Client.Function.Environment.SetTime(Client.Time.CurrentHour, Client.Time.CurrentMinute, Index - 1)
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("lock-time"), nil, Client.Time.Lock, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Time.Lock = IsChecked
			end
		end)
	end, function(Panels)
	end)

	Creator.Menu.Misc:IsVisible(function(Items)
		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Misc-List-CamMoveSpeed"), {Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][1]}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Speed.CamPos.Index - 1
				if index < 1 then
					index = #Creator.Speed.CamPos.Value
				end
				Creator.Speed.CamPos.Index = index
			elseif onListChange == "right" then
				local index = Creator.Speed.CamPos.Index + 1
				if index > #Creator.Speed.CamPos.Value then
					index = 1
				end
				Creator.Speed.CamPos.Index = index
			end
		end)

		Items:AddList(Client.Function.Translate.Get("Menu-Creator-Misc-List-CamRotateSpeed"), {Creator.Speed.CamRot.Value[Creator.Speed.CamRot.Index][1]}, 1, nil, {IsDisabled = false}, function(Index, onSelected, onListChange)
			if onListChange == "left" then
				local index = Creator.Speed.CamRot.Index - 1
				if index < 1 then
					index = #Creator.Speed.CamRot.Value
				end
				Creator.Speed.CamRot.Index = index
			elseif onListChange == "right" then
				local index = Creator.Speed.CamRot.Index + 1
				if index > #Creator.Speed.CamRot.Value then
					index = 1
				end
				Creator.Speed.CamRot.Index = index
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Misc-CheckBox-DisableNpc"), nil, not Client.Preference.Traffic, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Function.Environment.SetTraffic(not Client.Preference.Traffic)
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Misc-CheckBox-RadarBigmap"), nil, Creator.GlobalVar.RadarBigmapChecked, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Creator.GlobalVar.RadarBigmapChecked = IsChecked
				CreateThread(function()
					SetRadarBigmapEnabled(Creator.GlobalVar.RadarBigmapChecked, false)
					Wait(0)
					if Creator.GlobalVar.RadarBigmapChecked then
						SetRadarZoom(500)
					else
						SetRadarZoom(1200)
					end
				end)
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Misc-CheckBox-ObjectLowerAlpha"), nil, Client.Preference.ObjectLowerAlphaChecked, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.ObjectLowerAlphaChecked = IsChecked
				TriggerServerEvent("server:core:preferences", {ObjectLowerAlphaChecked = Client.Preference.ObjectLowerAlphaChecked})
			end
		end)

		Items:CheckBox(Client.Function.Translate.Get("Menu-Creator-Misc-CheckBox-EnableWeapon"), Client.Function.Translate.Get("Menu-Creator-Misc-CheckBox-EnableWeapon-Desc"), Client.Preference.EnableWeaponInTest, {Style = 1}, function(onSelected, IsChecked)
			if onSelected then
				Client.Preference.EnableWeaponInTest = IsChecked
				TriggerServerEvent("server:core:preferences", {EnableWeaponInTest = Client.Preference.EnableWeaponInTest})
			end
		end)

		if Creator.Track.Current.Title ~= "" then
			Items:AddButton(Client.Function.Translate.Get("Menu-Creator-Misc-Button-RefreshGrids"), Client.Function.Translate.Get("Menu-Creator-Misc-Button-RefreshGrids-Desc"), {IsDisabled = Creator.ObjectPool.IsRefreshing}, function(onSelected)
				if onSelected then
					Creator.ObjectPool.IsRefreshing = true
					Creator.Function.Pool.RefreshAllGirds()
				end
			end)
		end
	end, function(Panels)
	end)
end