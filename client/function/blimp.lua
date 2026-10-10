function Client.Function.Blimp.Init(callback)
	CreateThread(function()
		local scaleform = RequestScaleformMovie("blimp_text")
		while not HasScaleformMovieLoaded(scaleform) do Wait(0) end
		local rendertarget = 0
		if not IsNamedRendertargetRegistered("blimp_text") then
			RegisterNamedRendertarget("blimp_text", false)
		end
		if not IsNamedRendertargetLinked(1575467428) then
			LinkNamedRendertarget(1575467428)
		end
		if IsNamedRendertargetRegistered("blimp_text") then
			rendertarget = GetNamedRendertargetRenderId("blimp_text")
		end
		Client.Blimp.Scaleform = scaleform
		Client.Blimp.Rendertarget = rendertarget
		callback()
	end)
end

function Client.Function.Blimp.Render(scaleform, rendertarget)
	if not scaleform or not rendertarget then return end
	SetTextRenderId(rendertarget)
	SetScriptGfxDrawOrder(4)
	SetScriptGfxDrawBehindPausemenu(true)
	SetScaleformMovieToUseSuperLargeRt(scaleform, true)
	DrawScaleformMovie(scaleform, 0.0, -0.08, 1.0, 1.7, 255, 255, 255, 255, 0)
	SetTextRenderId(GetDefaultScriptRendertargetRenderId())
end

function Client.Function.Blimp.SetText(scaleform, msg)
	if not scaleform then return end
	BeginScaleformMovieMethod(scaleform, "SET_MESSAGE")
	ScaleformMovieMethodAddParamLiteralString(msg or "")
	EndScaleformMovieMethod()
end

function Client.Function.Blimp.SetColor(scaleform, color)
	if not scaleform then return end
	BeginScaleformMovieMethod(scaleform, "SET_COLOUR")
	ScaleformMovieMethodAddParamInt(color or 1)
	EndScaleformMovieMethod()
end

function Client.Function.Blimp.SetSpeed(scaleform, speed)
	if not scaleform then return end
	BeginScaleformMovieMethod(scaleform, "SET_SCROLL_SPEED")
	ScaleformMovieMethodAddParamFloat(speed or 100.0)
	EndScaleformMovieMethod()
end

function Client.Function.Blimp.Release()
	ReleaseNamedRendertarget("blimp_text")
end