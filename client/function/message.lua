function Client.Function.Message.Display(msg)
	CreateThread(function()
		BeginTextCommandThefeedPost("STRING")
		AddTextComponentSubstringPlayerName(msg)
		local item = EndTextCommandThefeedPostTicker(false, false)
		Wait(5000)
		ThefeedRemoveItem(item)
	end)
end

function Client.Function.Message.Display_2(msg, instantDelete, oldMsgItem)
	local newMsgItem = nil
	if instantDelete and oldMsgItem then
		ThefeedRemoveItem(oldMsgItem)
	end
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(msg)
	newMsgItem = EndTextCommandThefeedPostTicker(false, false)
	CreateThread(function()
		Wait(3000)
		ThefeedRemoveItem(newMsgItem)
	end)
	if instantDelete then
		return newMsgItem
	end
end