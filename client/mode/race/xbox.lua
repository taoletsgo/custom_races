local isNuiFocused = false
local hasCursorShow = false

function Race.Function.Xbox.ControlSimulation()
	if isNuiFocused then return end
	isNuiFocused = true
	if not IsUsingKeyboard() then
		local x, y = GetNuiCursorPosition()
		local resolutionX, resolutionY = GetActiveScreenResolution()
		local cursorX = x / resolutionX
		local cursorY = y / resolutionY
		SendNUIMessage({
			action = "update cursor position",
			x = cursorX,
			y = cursorY
		})
		SendNUIMessage({
			action = "show cursor"
		})
		hasCursorShow = true
	end
	SetNuiFocus(true, not hasCursorShow)
	SetNuiFocusKeepInput(hasCursorShow)
	CreateThread(function()
		while Race.EnableXboxController do
			if not IsUsingKeyboard() then
				local x, y = GetNuiCursorPosition()
				local resolutionX, resolutionY = GetActiveScreenResolution()
				local cursorX = x / resolutionX
				local cursorY = y / resolutionY
				local scrollY = GetDisabledControlNormal(0, 2)
				local w = GetDisabledControlNormal(0, 32)
				local s = GetDisabledControlNormal(0, 33)
				local a = GetDisabledControlNormal(0, 34)
				local d = GetDisabledControlNormal(0, 35)
				local moveX = (a ~= 0.0 and -a) or (d ~= 0.0 and d) or 0.0
				local moveY = (w ~= 0.0 and -w) or (s ~= 0.0 and s) or 0.0
				local framerateMoveFix = (60 * GetFrameTime()) * 0.01
				cursorX = math.max(0.0, math.min(1.0, cursorX + moveX * framerateMoveFix))
				cursorY = math.max(0.0, math.min(1.0, cursorY + moveY * framerateMoveFix))
				SetCursorLocation(cursorX, cursorY)
				SendNUIMessage({
					action = "update cursor position",
					x = cursorX,
					y = cursorY
				})
				if IsDisabledControlJustPressed(0, 201) then
					SendNUIMessage({
						action = "trigger click",
						x = cursorX,
						y = cursorY
					})
				elseif IsDisabledControlJustPressed(0, 202) then
					SendNUIMessage({
						action = "close nui"
					})
				end
				if scrollY ~= 0.0 then
					SendNUIMessage({
						action = "scroll",
						x = cursorX,
						y = cursorY,
						scrollY = scrollY
					})
				end
				if not hasCursorShow then
					SendNUIMessage({
						action = "show cursor"
					})
					hasCursorShow = true
					SetNuiFocus(true, false)
					SetNuiFocusKeepInput(true)
				end
			else
				if hasCursorShow then
					SendNUIMessage({
						action = "hide cursor"
					})
					hasCursorShow = false
					SetNuiFocus(true, true)
					SetNuiFocusKeepInput(false)
				end
			end
			Wait(0)
		end
		if hasCursorShow then
			SendNUIMessage({
				action = "hide cursor"
			})
			hasCursorShow = false
		end
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		isNuiFocused = false
	end)
end