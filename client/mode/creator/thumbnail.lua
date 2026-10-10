RegisterNUICallback("urlValid", function(data, cb)
	Creator.GlobalVar.ThumbnailValid = true
	Creator.GlobalVar.QueryingThumbnail = false
end)

RegisterNUICallback("urlError", function(data, cb)
	Creator.GlobalVar.ThumbnailValid = false
	Creator.GlobalVar.QueryingThumbnail = false
	Client.Function.Message.Display(Client.Function.Translate.Get("thumbnail-error"))
end)