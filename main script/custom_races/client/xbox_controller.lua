local hasCursorShow = false
local nuiFramerateMoveFix = 0.01
local loopGetNUIFramerate = false

function XboxControlSimulation()
	local xboxReady = not IsUsingKeyboard()
	Citizen.CreateThread(function()
		while enableXboxController do
			DisableAllControlActions(0)
			if IsDisabledControlJustReleased(0, 201) then
				SendNUIMessage({
					action = "nui_msg:triggerClick"
				})
			elseif IsDisabledControlJustReleased(0, 202) then
				SendNUIMessage({
					action = "nui_msg:closeNUI"
				})
			end
			if not IsUsingKeyboard() then
				local moveX = GetDisabledControlNormal(0, 1)
				local moveY = GetDisabledControlNormal(0, 2)
				local fix_left_stick_w = GetDisabledControlNormal(0, 32)
				local fix_left_stick_s = GetDisabledControlNormal(0, 33)
				local fix_left_stick_a = GetDisabledControlNormal(0, 34)
				local fix_left_stick_d = GetDisabledControlNormal(0, 35)
				moveX = moveX + ((fix_left_stick_a ~= 0.0 and -fix_left_stick_a) or (fix_left_stick_d ~= 0.0 and fix_left_stick_d) or 0.0)
				moveY = moveY + ((fix_left_stick_w ~= 0.0 and -fix_left_stick_w) or (fix_left_stick_s ~= 0.0 and fix_left_stick_s) or 0.0)
				if xboxReady or moveX ~= 0.0 or moveY ~= 0.0 then
					xboxReady = false
					SendNUIMessage({
						action = "nui_msg:updateCursorPosition",
						x = moveX * nuiFramerateMoveFix,
						y = moveY * nuiFramerateMoveFix,
						showCursor = not hasCursorShow
					})
					if not hasCursorShow then
						hasCursorShow = true
						SetNuiFocus(true, false)
						SetNuiFocusKeepInput(true)
					end
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