function Race.Function.Camera.Create()
	local index = #Race.Track.Current.Checkpoints
	local checkpoint = Race.GlobalVar.LastCheckpointPair == 1 and Race.Track.Current.Checkpoints_2[index] or Race.Track.Current.Checkpoints[index]
	Race.Cache.Camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", checkpoint.x, checkpoint.y, checkpoint.z + 5.0, 0.0, 0.0, checkpoint.heading + 180.0, 90.0)
	SetCamActive(Race.Cache.Camera, true)
	RenderScriptCams(true, false, 0, true, false)
end

function Race.Function.Camera.Remove()
	if not Race.Cache.Camera then return end
	RenderScriptCams(false, false, 0, true, false)
	DestroyCam(Race.Cache.Camera, false)
	Race.Cache.Camera = nil
end