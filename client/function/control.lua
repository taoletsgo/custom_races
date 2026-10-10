function Client.Function.Control.DisableActions()
	CreateThread(function()
		while true do
			InvalidateIdleCam()
			InvalidateVehicleIdleCam()
			if Client.IsInRace then
				DisableControlAction(0, 75, true) -- F
				DisableControlAction(0, 200, true) -- Esc
				if Race.Status == "racing" then
					if Race.Track.Current.Mode ~= "gta" then
						DisableControlAction(0, 24, true)
						DisableControlAction(0, 69, true)
						DisableControlAction(0, 70, true)
						DisableControlAction(0, 92, true)
						DisableControlAction(0, 114, true)
						DisableControlAction(0, 121, true)
						DisableControlAction(0, 140, true)
						DisableControlAction(0, 141, true)
						DisableControlAction(0, 142, true)
						DisableControlAction(0, 257, true)
						DisableControlAction(0, 263, true)
						DisableControlAction(0, 264, true)
						DisableControlAction(0, 331, true)
					end
				end
				if Race.Status == "spectating" then
					DisableControlAction(2, 24, true)
					DisableControlAction(2, 26, true)
					DisableControlAction(2, 32, true) -- W
					DisableControlAction(2, 33, true) -- S
					DisableControlAction(2, 34, true) -- A
					DisableControlAction(2, 35, true) -- D
					DisableControlAction(2, 37, true) -- TAB
					DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
					DisableControlAction(0, 80, true) -- VEH_CIN_CAM
				end
			end
			if Client.IsInCreator then
				if not Client.IsCreatorInQuiting and (not Creator.GlobalVar.TipsRendered or not Client.Preference.EnableWeaponInTest) then
					DisableControlAction(0, 24, true)
					DisableControlAction(0, 25, true)
					DisableControlAction(0, 26, true)
					DisableControlAction(0, 36, true)
					DisableControlAction(0, 37, true)
					DisableControlAction(0, 69, true)
					DisableControlAction(0, 70, true)
					DisableControlAction(0, 92, true)
					DisableControlAction(0, 114, true)
					DisableControlAction(0, 121, true)
					DisableControlAction(0, 140, true)
					DisableControlAction(0, 141, true)
					DisableControlAction(0, 142, true)
					DisableControlAction(0, 200, true)
					DisableControlAction(0, 257, true)
					DisableControlAction(0, 263, true)
					DisableControlAction(0, 264, true)
					DisableControlAction(0, 331, true)
				end
				if Creator.GlobalVar.EnableTest then
					DisableControlAction(0, 75, true)
				end
			end
			if Client.IsSkinMenuVisible or Client.IsWeaponMenuVisible or Race.EnableXboxController or Client.IsCreatorInQuiting then
				DisableAllControlActions(0)
			else
				DisableControlAction(0, 80, true) -- VEH_CIN_CAM
				DisableControlAction(0, 85, true) -- VEH_RADIO_WHEEL
				DisableControlAction(0, 249, true) -- INPUT_PUSH_TO_TALK / Disable voice chat
				DisableControlAction(0, 100, true) -- VEH_SELECT_PREV_WEAPON
				if not Client.Hud.Loaded then
					DisableControlAction(0, 199, true)
					DisableControlAction(0, 200, true)
				end
				if RageUI.CurrentMenu ~= nil and not Client.IsInCreator then
					DisableControlAction(0, 200, true)
					DisableControlAction(0, 245, true)
					DisableControlAction(0, 246, true)
					DisableControlAction(0, 0, true) -- INPUT_NEXT_CAMERA
					DisableControlAction(0, 70, true) -- VEH_ATTACK2
					DisableControlAction(0, 99, true) -- VEH_SELECT_NEXT_WEAPON
					DisableControlAction(0, 114, true) -- VEH_FLY_ATTACK
					DisableControlAction(0, 140, true) -- MELEE_ATTACK_LIGHT
					DisableControlAction(0, 48, true) -- Z
					DisableControlAction(0, 37, true) -- TAB
					if not IsUsingKeyboard() then
						DisableControlAction(0, 74, true) -- INPUT_VEH_HEADLIGHT
						DisableControlAction(0, 136, true) -- INPUT_VEH_PUSHBIKE_PEDAL
						DisableControlAction(0, 137, true) -- INPUT_VEH_PUSHBIKE_SPRINT
					end
				end
				if Client.Noclip.Enable then
					DisableControlAction(0, 23, true)
					DisableControlAction(0, 30, true)
					DisableControlAction(0, 31, true)
					DisableControlAction(0, 32, true)
					DisableControlAction(0, 33, true)
					DisableControlAction(0, 34, true)
					DisableControlAction(0, 35, true)
					DisableControlAction(0, 266, true)
					DisableControlAction(0, 267, true)
					DisableControlAction(0, 268, true)
					DisableControlAction(0, 269, true)
					DisableControlAction(0, 44, true)
					DisableControlAction(0, 20, true)
					DisableControlAction(0, 74, true)
					DisableControlAction(0, 75, true)
					DisableControlAction(0, 99, true)
					DisableControlAction(0, 177, true)
					DisableControlAction(0, 188, true)
					DisableControlAction(0, 187, true)
					DisableControlAction(0, 131, true)
					DisableControlAction(0, 140, true)
				end
				if Client.Preference.DisableMotoMelee then
					DisableControlAction(0, 345, true)
					DisableControlAction(0, 346, true)
					DisableControlAction(0, 347, true)
				end
			end
			Wait(0)
		end
	end)
end

function Client.Function.Control.DisableActionsWhenQuitMenu()
	Client.Hud.DisableInfoUINextFrame = true
	DisableControlAction(0, 0, true)
	DisableControlAction(0, 140, true)
	DisableControlAction(0, 200, true)
	DisableControlAction(0, 244, true)
	if not IsUsingKeyboard() then
		DisableControlAction(0, 136, true) -- INPUT_VEH_PUSHBIKE_PEDAL
		DisableControlAction(0, 137, true) -- INPUT_VEH_PUSHBIKE_SPRINT
	end
	CreateThread(function()
		local delay = GetGameTimer()
		while (GetGameTimer() - delay) <= 500 do
			DisableControlAction(0, 0, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 200, true)
			DisableControlAction(0, 244, true)
			if not IsUsingKeyboard() then
				DisableControlAction(0, 136, true) -- INPUT_VEH_PUSHBIKE_PEDAL
				DisableControlAction(0, 137, true) -- INPUT_VEH_PUSHBIKE_SPRINT
			end
			Wait(0)
		end
		Client.Hud.DisableInfoUINextFrame = false
	end)
end

function Client.Function.Control.DisableActionsWhenQuitNoclip()
	DisableControlAction(0, 0, true)
	DisableControlAction(0, 140, true)
	DisableControlAction(0, 200, true)
	DisableControlAction(0, 244, true)
	CreateThread(function()
		local delay = GetGameTimer()
		while (GetGameTimer() - delay) <= 500 do
			DisableControlAction(0, 0, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 200, true)
			DisableControlAction(0, 244, true)
			Wait(0)
		end
	end)
end