local hasCursorShow = false
local nuiFramerateMoveFix = 0.01
local loopGetNUIFramerate = false

function XboxControlSimulation()
	if not IsUsingKeyboard() then
		local x, y = GetNuiCursorPosition()
		local resolutionX, resolutionY = GetActiveScreenResolution()
		local cursorX = x / resolutionX
		local cursorY = y / resolutionY
		SendNUIMessage({
			action = "nui_msg:updateCursorPosition",
			x = cursorX,
			y = cursorY
		})
		SendNUIMessage({
			action = "nui_msg:showCursor"
		})
		hasCursorShow = true
	end
	SetNuiFocus(true, not hasCursorShow)
	SetNuiFocusKeepInput(hasCursorShow)
	Citizen.CreateThread(function()
		while enableXboxController do
			DisableAllControlActions(0)
			if not IsUsingKeyboard() then
				local x, y = GetNuiCursorPosition()
				local resolutionX, resolutionY = GetActiveScreenResolution()
				local cursorX = x / resolutionX
				local cursorY = y / resolutionY
				local scrollY = GetDisabledControlNormal(0, 2)
				local fix_left_stick_w = GetDisabledControlNormal(0, 32)
				local fix_left_stick_s = GetDisabledControlNormal(0, 33)
				local fix_left_stick_a = GetDisabledControlNormal(0, 34)
				local fix_left_stick_d = GetDisabledControlNormal(0, 35)
				local moveX = (fix_left_stick_a ~= 0.0 and -fix_left_stick_a) or (fix_left_stick_d ~= 0.0 and fix_left_stick_d) or 0.0
				local moveY = (fix_left_stick_w ~= 0.0 and -fix_left_stick_w) or (fix_left_stick_s ~= 0.0 and fix_left_stick_s) or 0.0
				cursorX = math.max(0.0, math.min(1.0, cursorX + moveX * nuiFramerateMoveFix))
				cursorY = math.max(0.0, math.min(1.0, cursorY + moveY * nuiFramerateMoveFix))
				SetCursorLocation(cursorX, cursorY)
				SendNUIMessage({
					action = "nui_msg:updateCursorPosition",
					x = cursorX,
					y = cursorY
				})
				if IsDisabledControlJustPressed(0, 201) then
					SendNUIMessage({
						action = "nui_msg:triggerClick",
						x = cursorX,
						y = cursorY
					})
				elseif IsDisabledControlJustPressed(0, 202) then
					SendNUIMessage({
						action = "nui_msg:closeNUI"
					})
				end
				if scrollY ~= 0.0 then
					SendNUIMessage({
						action = "nui_msg:scroll",
						x = cursorX,
						y = cursorY,
						scrollY = scrollY
					})
				end
				if not hasCursorShow then
					SendNUIMessage({
						action = "nui_msg:showCursor"
					})
					hasCursorShow = true
					SetNuiFocus(true, false)
					SetNuiFocusKeepInput(true)
				end
			else
				if hasCursorShow then
					SendNUIMessage({
						action = "nui_msg:hideCursor"
					})
					hasCursorShow = false
					SetNuiFocus(true, true)
					SetNuiFocusKeepInput(false)
				end
			end
			Citizen.Wait(0)
		end
		if hasCursorShow then
			SendNUIMessage({
				action = "nui_msg:hideCursor"
			})
			hasCursorShow = false
		end
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
	end)
end

function LoopGetNUIFramerateMoveFix()
	if not loopGetNUIFramerate then
		loopGetNUIFramerate = true
		Citizen.CreateThread(function()
			while enableXboxController do
				local startCount = GetFrameCount()
				Citizen.Wait(1000)
				local endCount = GetFrameCount()
				local fps = endCount - startCount - 1
				if fps <= 0 then fps = 1 end
				nuiFramerateMoveFix = (60 / fps) * 0.01
			end
			loopGetNUIFramerate = false
		end)
	end
end