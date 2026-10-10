local isRecording = false
local actionReplay = false

function Client.Function.Recording.Toggle()
	if IsRecording() then
		if actionReplay then
			StopRecordingAndSaveClip()
			if SaveRecordingClip() then
				Client.Function.Message.Display(Client.Function.Translate.Get("recording-replay-saved"))
			end
		else
			isRecording = false
			StopRecordingAndSaveClip()
			if SaveRecordingClip() then
				Client.Function.Message.Display(Client.Function.Translate.Get("recording-clip-saved"))
			end
		end
	else
		isRecording = true
		StartRecording(1)
		Wait(100)
		if IsRecording() then
			PlaySoundFrontend(-1, "INFO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
		end
	end
end

function Client.Function.Recording.ActionReplay()
	if IsRecording() then
		if not isRecording then
			actionReplay = false
			StopRecordingAndDiscardClip()
			Client.Function.Message.Display(Client.Function.Translate.Get("recording-replay-stop"))
		else
			Client.Function.Message.Display(Client.Function.Translate.Get("recording-in-progress"))
		end
	else
		actionReplay = true
		StartRecording(0)
		Wait(100)
		if IsRecording() then
			Client.Function.Message.Display(Client.Function.Translate.Get("recording-replay-start"))
			PlaySoundFrontend(-1, "INFO", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
		end
	end
end

function Client.Function.Recording.Cancel()
	if IsRecording() then
		if actionReplay then
			Client.Function.Message.Display(Client.Function.Translate.Get("recording-replay-stop"))
		else
			Client.Function.Message.Display(Client.Function.Translate.Get("recording-discarded"))
		end
		StopRecordingAndDiscardClip()
	else
		Client.Function.Message.Display(Client.Function.Translate.Get("recording-not-in-progress"))
	end
	actionReplay = false
	isRecording = false
end