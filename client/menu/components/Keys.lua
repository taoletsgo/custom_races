---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- File created at [24/05/2021 00:00]
---

Keys = {};

---Register
---@param Controls string
---@param ControlName string
---@param Description string
---@param Action function
---@return Keys
---@public
function Keys.Register(bool, Controls, ControlName, Description, Action)
	if bool then
		RegisterKeyMapping(string.format('keys-%s', ControlName), Description, "keyboard", Controls)
		RegisterCommand(string.format('keys-%s', ControlName), function()
			if (Action ~= nil) then
				Action();
			end
		end, false)
	else
		RegisterKeyMapping(string.format('keys-%s', ControlName), Description, "PAD_ANALOGBUTTON", Controls)
		RegisterCommand(string.format('keys-%s', ControlName), function()
			if (Action ~= nil) then
				Action();
			end
		end, false)
	end
end