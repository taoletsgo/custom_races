function Race.Function.Teleport.GoToPreviousCheckpoint()
	if Race.Status == "racing" and not Race.Cache.IsRespawningInProgress and not Race.Cache.IsTransformingInProgress and not Race.Cache.IsTeleportingInProgress then
		if Race.GlobalVar.ActualCheckpoint - 2 > 0 then
			Race.Cache.IsTeleportingInProgress = true
			Race.GlobalVar.TotalCheckpointsTouched = Race.GlobalVar.TotalCheckpointsTouched - 1
			Race.GlobalVar.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint - 1
			Race.SyncData.TotalCheckpointsTouched = Race.GlobalVar.TotalCheckpointsTouched
			Race.SyncData.ActualCheckpoint = Race.GlobalVar.ActualCheckpoint
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			local prevCheckpoint = Race.GlobalVar.LastCheckpointPair == 1 and Race.Track.Current.Checkpoints_2[Race.GlobalVar.ActualCheckpoint - 1] or Race.Track.Current.Checkpoints[Race.GlobalVar.ActualCheckpoint - 1]
			local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(prevCheckpoint.x, prevCheckpoint.y, prevCheckpoint.z, false, true)
			SetEntityCoords(vehicle > 0 and vehicle or ped, x, y, z)
			SetEntityHeading(vehicle > 0 and vehicle or ped, prevCheckpoint.heading)
			PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
			Race.Function.ResetCheckpointAndBlip()
			Race.Function.CreateCheckpointBlip(Race.GlobalVar.ActualCheckpoint, Race.GlobalVar.ActualLap)
			Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, false, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
			Race.Function.CreateCheckpoint(Race.GlobalVar.ActualCheckpoint, true, Race.GlobalVar.ActualCheckpoint == #Race.Track.Current.Checkpoints and Race.GlobalVar.ActualLap == Race.Track.Current.Laps)
			SendNUIMessage({
				action = "show notification",
				message = Client.Function.Translate.Get("msg-tpp")
			})
			SetGameplayCamRelativeHeading(0)
			Race.Cache.IsTeleportingInProgress = false
		end
	end
end

function Race.Function.Teleport.GoToNextCheckpoint()
	if Race.Status == "racing" and not Race.Cache.IsRespawningInProgress and not Race.Cache.IsTransformingInProgress and not Race.Cache.IsTeleportingInProgress then
		Race.Cache.IsTeleportingInProgress = true
		Race.Cache.HasCheated = true
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		local checkpoint = Race.GlobalVar.LastCheckpointPair == 1 and Race.Track.Current.Checkpoints_2[Race.GlobalVar.ActualCheckpoint] or Race.Track.Current.Checkpoints[Race.GlobalVar.ActualCheckpoint]
		local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false, true)
		SetEntityCoords(vehicle > 0 and vehicle or ped, x, y, z)
		SetEntityHeading(vehicle > 0 and vehicle or ped, checkpoint.heading)
		SendNUIMessage({
			action = "show notification",
			message = Client.Function.Translate.Get("msg-tpn")
		})
		SetGameplayCamRelativeHeading(0)
		Race.Cache.IsTeleportingInProgress = false
	end
end