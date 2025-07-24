local cursorX = 0.5
local cursorY = 0.5
local hasCursorShow = false
local nuiFramerateMoveFix = 0.01
local loopGetNUIFramerate = false

function XboxControlSimulation()
	local ready = not IsUsingKeyboard()
	Citizen.CreateThread(function()
		while enableXboxController do
			DisableAllControlActions(0)
			if not IsUsingKeyboard() then
				local moveX = GetDisabledControlNormal(0, 1)
				local moveY = GetDisabledControlNormal(0, 2)
				local fix_left_stick_w = GetDisabledControlNormal(0, 32)
				local fix_left_stick_s = GetDisabledControlNormal(0, 33)
				local fix_left_stick_a = GetDisabledControlNormal(0, 34)
				local fix_left_stick_d = GetDisabledControlNormal(0, 35)
				moveX = moveX + ((fix_left_stick_a ~= 0.0 and -fix_left_stick_a) or (fix_left_stick_d ~= 0.0 and fix_left_stick_d) or 0.0)
				moveY = moveY + ((fix_left_stick_w ~= 0.0 and -fix_left_stick_w) or (fix_left_stick_s ~= 0.0 and fix_left_stick_s) or 0.0)
				if ready or moveX ~= 0.0 or moveY ~= 0.0 then
					cursorX = math.max(0.0, math.min(1.0, cursorX + moveX * nuiFramerateMoveFix))
					cursorY = math.max(0.0, math.min(1.0, cursorY + moveY * nuiFramerateMoveFix))
					SendNUIMessage({
						action = "nui_msg:updateCursorPosition",
						cursorX = cursorX,
						cursorY = cursorY,
						showCursor = not hasCursorShow
					})
					if not hasCursorShow then
						hasCursorShow = true
						SetNuiFocus(true, false)
					end
				end
				if ready then
					ready = false
					Citizen.Wait(300)
				end
				if IsDisabledControlJustReleased(0, 201) then
					SendNUIMessage({
						action = "nui_msg:triggerClick",
						cursorX = cursorX,
						cursorY = cursorY
					})
				elseif IsDisabledControlJustReleased(0, 202) then
					SendNUIMessage({
						action = "nui_msg:closeNUI"
					})
				end
			else
				if hasCursorShow then
					SendNUIMessage({
						action = "nui_msg:hideCursor"
					})
					hasCursorShow = false
					SetNuiFocus(true, true)
				end
			end
			Citizen.Wait(0)
		end
		if hasCursorShow then
			SendNUIMessage({
				action = "nui_msg:hideCursor"
			})
			hasCursorShow = false
			cursorX = 0.5
			cursorY = 0.5
		end
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