function Client.Function.Scaleform.Update(scaleformName, str)
	local scaleform = RequestScaleformMovie(scaleformName)

	while not HasScaleformMovieLoaded(scaleform) do Wait(0) end

	BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
	ScaleformMovieMethodAddParamInt(200)
	EndScaleformMovieMethod()

	local buttons = {}
	if str == "client" then
		if Client.IsSkinMenuVisible then
			table.insert(buttons, {control = {206, 205}, message = Client.Function.Translate.Get("skin-cam-rotate")})
		elseif Client.IsWeaponMenuVisible then
			table.insert(buttons, {control = {206, 205}, message = Client.Function.Translate.Get("weapon-cam-rotate")})
		end
		table.insert(buttons, {control = {176}, message = Client.Function.Translate.Get("Select")})
		table.insert(buttons, {control = {177}, message = Client.Function.Translate.Get("Back")})
	elseif str == "noclip" then
		table.insert(buttons, {control = {188}, message = Client.Function.Translate.Get("noclip-go-up")})
		table.insert(buttons, {control = {187}, message = Client.Function.Translate.Get("noclip-go-down")})
		table.insert(buttons, {control = {35, 34}, message = Client.Function.Translate.Get("noclip-turn-left-right")})
		table.insert(buttons, {control = {33, 32}, message = Client.Function.Translate.Get("noclip-go-forward-backward")})
		table.insert(buttons, {control = {131}, message = string.format(Client.Function.Translate.Get("noclip-change-speed"), Client.Function.Translate.Get("noclip-speed-" .. Client.Noclip.Index))})
		table.insert(buttons, {control = {177}, message = Client.Function.Translate.Get("noclip-quit")})
	elseif str == "creator" then
		if Creator.ButtonToDraw == -1 then
			table.insert(buttons, {control = {35, 33, 34, 32}, message = Client.Function.Translate.Get("CamMove")})
			table.insert(buttons, {control = {253, 252}, message = Client.Function.Translate.Get("CamZoom")})
			table.insert(buttons, {control = {IsUsingKeyboard() and 254 or 226}, message = string.format(Client.Function.Translate.Get("CamMoveSpeed"), Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][1])})
			table.insert(buttons, {control = {IsUsingKeyboard() and 326 or 227}, message = string.format(Client.Function.Translate.Get("CamRotateSpeed"), Creator.Speed.CamRot.Value[Creator.Speed.CamRot.Index][1])})
			table.insert(buttons, {control = {201}, message = Client.Function.Translate.Get("Select")})
		elseif Creator.ButtonToDraw == 5 then
			if not Creator.Firework.IsMenuVisible then
				table.insert(buttons, {control = {35, 33, 34, 32}, message = Client.Function.Translate.Get("CamMove")})
				table.insert(buttons, {control = {253, 252}, message = Client.Function.Translate.Get("CamZoom")})
				if Creator.Speed.Key then
					table.insert(buttons, {control = {IsUsingKeyboard() and 326 or 226}, message = string.format(Client.Function.Translate.Get("-ChangeSpeed"), Creator.Speed[Creator.Speed.Key].Value[Creator.Speed[Creator.Speed.Key].Index][1])})
					table.insert(buttons, {control = {IsUsingKeyboard() and 254 or 227}, message = string.format(Client.Function.Translate.Get("+ChangeSpeed"), Creator.Speed[Creator.Speed.Key].Value[Creator.Speed[Creator.Speed.Key].Index][1])})
				else
					table.insert(buttons, {control = {IsUsingKeyboard() and 254 or 226}, message = string.format(Client.Function.Translate.Get("CamMoveSpeed"), Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][1])})
					table.insert(buttons, {control = {IsUsingKeyboard() and 326 or 227}, message = string.format(Client.Function.Translate.Get("CamRotateSpeed"), Creator.Speed.CamRot.Value[Creator.Speed.CamRot.Index][1])})
				end
			end
			table.insert(buttons, {control = {194}, message = Client.Function.Translate.Get("Back")})
		else
			if Creator.ButtonToDraw == 3 and not Creator.Object.IsPickedUp and (not Creator.Object.Preview or (Creator.Object.Preview and not Creator.Object.PreviewCoordsChanged and Creator.Object.Current.z)) then
				table.insert(buttons, {control = {251, 250}, message = Client.Function.Translate.Get("PreviewHeight")})
			elseif Creator.ButtonToDraw == 4 and not Creator.Template.IsPickedUp and (#Creator.Template.Preview == 0 or (Creator.Template.Preview[1] and not Creator.Template.PreviewCoordsChanged and Creator.Template.Preview[1].z)) then
				table.insert(buttons, {control = {251, 250}, message = Client.Function.Translate.Get("PreviewHeight")})
			end
			if Creator.ButtonToDraw == 1 then
				if Creator.StartingGrid.IsPickedUp then
					table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("UpdateStartingGrid")})
				elseif #Creator.Track.Current.StartingGrid > 0 then
					table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("SelectStartingGrid")})
				end
			elseif Creator.ButtonToDraw == 2 then
				if Creator.Checkpoint.IsPickedUp then
					table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("DeselectCheckpoint")})
				end
			elseif Creator.ButtonToDraw == 3 then
				if Creator.Snapping.Enable then
					if Creator.Snapping.Handle then
						table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("DeselectParentObject")})
					elseif #Creator.Track.Current.Objects > 0 then
						table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("SelectParentObject")})
					end
				else
					if Creator.Object.IsPickedUp then
						table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("DeselectObject")})
					elseif #Creator.Track.Current.Objects > 0 then
						table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("SelectObject")})
					end
					if Creator.Object.Current.handle and Creator.Object.Current.hash then
						if not Creator.Data.Favorite[Creator.Object.Current.hash] then
							table.insert(buttons, {control = {204}, message = "☆"})
						else
							table.insert(buttons, {control = {204}, message = "★"})
						end
					end
				end
			elseif Creator.ButtonToDraw == 4 then
				if Creator.Template.IsPickedUp then
					table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("DeselectObject")})
				elseif #Creator.Track.Current.Objects > 0 then
					table.insert(buttons, {control = {203}, message = Client.Function.Translate.Get("SelectObject")})
				end
			end
			table.insert(buttons, {control = {35, 33, 34, 32}, message = Client.Function.Translate.Get("CamMove")})
			table.insert(buttons, {control = {253, 252}, message = Client.Function.Translate.Get("CamZoom")})
			if Creator.Speed.Key then
				table.insert(buttons, {control = {IsUsingKeyboard() and 326 or 226}, message = string.format(Client.Function.Translate.Get("-ChangeSpeed"), Creator.Speed[Creator.Speed.Key].Value[Creator.Speed[Creator.Speed.Key].Index][1])})
				table.insert(buttons, {control = {IsUsingKeyboard() and 254 or 227}, message = string.format(Client.Function.Translate.Get("+ChangeSpeed"), Creator.Speed[Creator.Speed.Key].Value[Creator.Speed[Creator.Speed.Key].Index][1])})
			else
				table.insert(buttons, {control = {IsUsingKeyboard() and 254 or 226}, message = string.format(Client.Function.Translate.Get("CamMoveSpeed"), Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][1])})
				table.insert(buttons, {control = {IsUsingKeyboard() and 326 or 227}, message = string.format(Client.Function.Translate.Get("CamRotateSpeed"), Creator.Speed.CamRot.Value[Creator.Speed.CamRot.Index][1])})
			end
			table.insert(buttons, {control = {201}, message = Client.Function.Translate.Get(Creator.ButtonToDraw == 3 and Creator.Snapping.CanInsertData and "Place" or "Select")})
			table.insert(buttons, {control = {194}, message = Client.Function.Translate.Get("Back")})
		end
	elseif str == "spectator" then
		table.insert(buttons, {control = {173, 172}, message = Client.Function.Translate.Get("racing-spectator-select")})
		table.insert(buttons, {control = {202}, message = Client.Function.Translate.Get("racing-spectator-quit")})
	end

	for i = 1, #buttons do
		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(#buttons - i)
		for j = 1, #buttons[i].control do
			ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(2, buttons[i].control[j], true))
		end
		BeginTextCommandScaleformString("STRING")
		AddTextComponentSubstringKeyboardDisplay(buttons[i].message)
		EndTextCommandScaleformString()
		EndScaleformMovieMethod()
	end

	BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(80)
	EndScaleformMovieMethod()

	Client.Hud.LastUpdateScaleformTime = GetGameTimer()
	return scaleform
end