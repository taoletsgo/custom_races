---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- created at [24/05/2021 10:02]
---

RageUI.LastControl = false

local ControlActions = {
	'Left',
	'Right',
	'Select',
	'Click',
}

---GoUp
---@param Options number
---@return nil
---@public
function RageUI.GoUp(Options)
	local CurrentMenu = RageUI.CurrentMenu;
	if CurrentMenu ~= nil then
		Options = CurrentMenu.Options
		if CurrentMenu() then
			if (Options ~= 0) then
				if Options > CurrentMenu.Pagination.Total then
					if CurrentMenu.Index <= CurrentMenu.Pagination.Minimum then
						if CurrentMenu.Index == 1 then
							CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
							CurrentMenu.Pagination.Maximum = Options
							CurrentMenu.Index = Options
						else
							CurrentMenu.Pagination.Minimum = (CurrentMenu.Pagination.Minimum - 1)
							CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum - 1)
							CurrentMenu.Index = CurrentMenu.Index - 1
						end
					else
						CurrentMenu.Index = CurrentMenu.Index - 1
					end
				else
					if CurrentMenu.Index == 1 then
						CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
						CurrentMenu.Pagination.Maximum = Options
						CurrentMenu.Index = Options
					else
						CurrentMenu.Index = CurrentMenu.Index - 1
					end
				end

				Audio.PlaySound(RageUI.Settings.Audio.UpDown.audioName, RageUI.Settings.Audio.UpDown.audioRef)
				RageUI.LastControl = true
				if (CurrentMenu.onIndexChange ~= nil) then
					CurrentMenu.onIndexChange(CurrentMenu.Index)
				end
			else

				Audio.PlaySound(RageUI.Settings.Audio.Error.audioName, RageUI.Settings.Audio.Error.audioRef)
			end
		end
	end
end

---GoDown
---@param Options number
---@return nil
---@public
function RageUI.GoDown(Options)
	local CurrentMenu = RageUI.CurrentMenu;
	if CurrentMenu ~= nil then
		Options = CurrentMenu.Options
		if CurrentMenu() then
			if (Options ~= 0) then
				if Options > CurrentMenu.Pagination.Total then
					if CurrentMenu.Index >= CurrentMenu.Pagination.Maximum then
						if CurrentMenu.Index == Options then
							CurrentMenu.Pagination.Minimum = 1
							CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
							CurrentMenu.Index = 1
						else
							CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum + 1)
							CurrentMenu.Pagination.Minimum = CurrentMenu.Pagination.Maximum - (CurrentMenu.Pagination.Total - 1)
							CurrentMenu.Index = CurrentMenu.Index + 1
						end
					else
						CurrentMenu.Index = CurrentMenu.Index + 1
					end
				else
					if CurrentMenu.Index == Options then
						CurrentMenu.Pagination.Minimum = 1
						CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
						CurrentMenu.Index = 1
					else
						CurrentMenu.Index = CurrentMenu.Index + 1
					end
				end

				Audio.PlaySound(RageUI.Settings.Audio.UpDown.audioName, RageUI.Settings.Audio.UpDown.audioRef)
				RageUI.LastControl = false
				if (CurrentMenu.onIndexChange ~= nil) then
					CurrentMenu.onIndexChange(CurrentMenu.Index)
				end
			else

				Audio.PlaySound(RageUI.Settings.Audio.Error.audioName, RageUI.Settings.Audio.Error.audioRef)
			end
		end
	end
end

function RageUI.GoActionControl(Controls, Action)
	if Controls[Action or 'Left'].Enabled then
		for Index = 1, #Controls[Action or 'Left'].Keys do
			if not Controls[Action or 'Left'].Pressed then
				if IsDisabledControlJustPressed(Controls[Action or 'Left'].Keys[Index][1], Controls[Action or 'Left'].Keys[Index][2]) then
					Controls[Action or 'Left'].Pressed = true
					Citizen.CreateThread(function()
						Controls[Action or 'Left'].Active = true
						Citizen.Wait(0.01)
						Controls[Action or 'Left'].Active = false
						Citizen.Wait(175)
						while Controls[Action or 'Left'].Enabled and IsDisabledControlPressed(Controls[Action or 'Left'].Keys[Index][1], Controls[Action or 'Left'].Keys[Index][2]) do
							Controls[Action or 'Left'].Active = true
							Citizen.Wait(1)
							Controls[Action or 'Left'].Active = false
							Citizen.Wait(124)
						end
						Controls[Action or 'Left'].Pressed = false
						if (Action ~= ControlActions[5]) then
							Citizen.Wait(10)
						end
					end)
					break
				end
			end
		end
	end
end

function RageUI.GoActionControlSlider(Controls, Action)
	if Controls[Action].Enabled then
		for Index = 1, #Controls[Action].Keys do
			if not Controls[Action].Pressed then
				if IsDisabledControlJustPressed(Controls[Action].Keys[Index][1], Controls[Action].Keys[Index][2]) then
					Controls[Action].Pressed = true
					Citizen.CreateThread(function()
						Controls[Action].Active = true
						Citizen.Wait(1)
						Controls[Action].Active = false
						while Controls[Action].Enabled and IsDisabledControlPressed(Controls[Action].Keys[Index][1], Controls[Action].Keys[Index][2]) do
							Controls[Action].Active = true
							Citizen.Wait(1)
							Controls[Action].Active = false
						end
						Controls[Action].Pressed = false
					end)
					break
				end
			end
		end
	end
end

---Controls
---@return nil
---@public
function RageUI.Controls()
	local CurrentMenu = RageUI.CurrentMenu;
	if CurrentMenu ~= nil then
		if CurrentMenu() then
			if CurrentMenu.Open then

				local Controls = CurrentMenu.Controls;

				local Options = CurrentMenu.Options
				RageUI.Options = CurrentMenu.Options
				if CurrentMenu.EnableMouse then
					DisableAllControlActions(2)
				end

				if not IsInputDisabled(2) then
					for Index = 1, #Controls.Enabled.Controller do
						EnableControlAction(Controls.Enabled.Controller[Index][1], Controls.Enabled.Controller[Index][2], true)
					end
				else
					for Index = 1, #Controls.Enabled.Keyboard do
						EnableControlAction(Controls.Enabled.Keyboard[Index][1], Controls.Enabled.Keyboard[Index][2], true)
					end
				end

				if Controls.Up.Enabled then
					for Index = 1, #Controls.Up.Keys do
						if not Controls.Up.Pressed then
							if IsDisabledControlJustPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) then
								Controls.Up.Pressed = true
								Citizen.CreateThread(function()
									RageUI.GoUp(Options)
									Citizen.Wait(175)
									while Controls.Up.Enabled and IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
										RageUI.GoUp(Options)
										Citizen.Wait(50)
									end
									Controls.Up.Pressed = false
								end)
								break
							end
						end
					end
				end

				if Controls.Down.Enabled then
					for Index = 1, #Controls.Down.Keys do
						if not Controls.Down.Pressed then
							if IsDisabledControlJustPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) then
								Controls.Down.Pressed = true
								Citizen.CreateThread(function()
									RageUI.GoDown(Options)
									Citizen.Wait(175)
									while Controls.Down.Enabled and IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
										RageUI.GoDown(Options)
										Citizen.Wait(50)
									end
									Controls.Down.Pressed = false
								end)
								break
							end
						end
					end
				end

				for i = 1, #ControlActions do
					RageUI.GoActionControl(Controls, ControlActions[i])
				end

				RageUI.GoActionControlSlider(Controls, 'SliderLeft')
				RageUI.GoActionControlSlider(Controls, 'SliderRight')

				if Controls.Back.Enabled then
					for Index = 1, #Controls.Back.Keys do
						if not Controls.Back.Pressed then
							if IsDisabledControlJustPressed(Controls.Back.Keys[Index][1], Controls.Back.Keys[Index][2]) then
								Controls.Back.Pressed = true
								Citizen.CreateThread(function()
									Citizen.Wait(175)
									Controls.Down.Pressed = false
								end)
								break
							end
						end
					end
				end

			end
		end
	end
end

---Navigation
---@return nil
---@public
function RageUI.Navigation()
	local CurrentMenu = RageUI.CurrentMenu;
	if CurrentMenu ~= nil then
		if CurrentMenu() and (CurrentMenu.Display.Navigation) then
			if CurrentMenu.EnableMouse then
				SetMouseCursorActiveThisFrame()
			end
			if RageUI.Options > CurrentMenu.Pagination.Total then
				local UpHovered = false
				local DownHovered = false

				if not CurrentMenu.SafeZoneSize then
					CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

					if CurrentMenu.Safezone then
						CurrentMenu.SafeZoneSize = RageUI.GetSafeZoneBounds()

						SetScriptGfxAlign(76, 84)
						SetScriptGfxAlignParams(0, 0, 0, 0)
					end
				end

				if CurrentMenu.EnableMouse then
					UpHovered = Graphics.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height)
					DownHovered = Graphics.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height)

					if CurrentMenu.Controls.Click.Active then
						if UpHovered then
							RageUI.GoUp(RageUI.Options)
						elseif DownHovered then
							RageUI.GoDown(RageUI.Options)
						end
					end

					if UpHovered then
						Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
					else
						Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
					end

					if DownHovered then
						Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
					else
						Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
					end
				else
					Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
					Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + RageUI.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, RageUI.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
				end
				Graphics.Sprite(RageUI.Settings.Items.Navigation.Arrows.Dictionary, RageUI.Settings.Items.Navigation.Arrows.Texture, CurrentMenu.X + RageUI.Settings.Items.Navigation.Arrows.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + RageUI.Settings.Items.Navigation.Arrows.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, RageUI.Settings.Items.Navigation.Arrows.Width, RageUI.Settings.Items.Navigation.Arrows.Height)
				RageUI.ItemOffset = RageUI.ItemOffset + (RageUI.Settings.Items.Navigation.Rectangle.Height * 2)
			end
		end
	end
end

---GoBack
---@return nil
---@public
function RageUI.GoBack()
	local CurrentMenu = RageUI.CurrentMenu
	if CurrentMenu ~= nil then

		Audio.PlaySound(RageUI.Settings.Audio.Back.audioName, RageUI.Settings.Audio.Back.audioRef)
		if CurrentMenu.Parent ~= nil then
			if CurrentMenu.Parent() then
				RageUI.NextMenu = CurrentMenu.Parent
			else
				RageUI.NextMenu = nil
				RageUI.Visible(CurrentMenu, false)
			end
		else
			RageUI.NextMenu = nil
			RageUI.Visible(CurrentMenu, MainMenu and true or false)
		end
	end
end