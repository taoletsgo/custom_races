function Client.Function.Noclip.Enable()
	CreateThread(function()
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped, false)
		local entity = vehicle > 0 and vehicle or ped
		local speeds = {0, 0.5, 2, 4, 6, 10, 20, 25}
		SetEntityCollision(entity, false, false)
		FreezeEntityPosition(entity, true)
		SetEntityInvincible(entity, true)
		while Client.Noclip.Enable do
			DrawScaleformMovieFullscreen(Client.Function.Scaleform.Update("instructional_buttons", "noclip"))
			if IsNuiFocused() or IsPauseMenuActive() or IsPlayerSwitchInProgress() then
				Client.Noclip.Enable = false
			elseif IsDisabledControlJustPressed(0, 177) or not DoesEntityExist(entity) or (vehicle > 0 and GetVehiclePedIsIn(ped, false) == 0) then
				Client.Noclip.Enable = false
				Client.Function.Control.DisableActionsWhenQuitNoclip()
			else
				if IsDisabledControlJustPressed(0, 131) then
					local index = Client.Noclip.Index + 1
					if index > #speeds then
						index = 1
					end
					Client.Noclip.Index = index
				end
				local offsetY = 0.0
				local offsetZ = 0.0
				local speed = speeds[Client.Noclip.Index]
				local heading = GetEntityHeading(entity)
				if IsDisabledControlPressed(0, 32) then
					offsetY = offsetY + 0.5
				end
				if IsDisabledControlPressed(0, 33) then
					offsetY = offsetY - 0.5
				end
				if IsDisabledControlPressed(0, 34) then
					heading = heading + 3.0
				end
				if IsDisabledControlPressed(0, 35) then
					heading = heading - 3.0
				end
				if IsDisabledControlPressed(0, 188) then
					offsetZ = offsetZ + 0.2
					SetGameplayCamRelativeHeading(0)
				end
				if IsDisabledControlPressed(0, 187) then
					offsetZ = offsetZ - 0.2
					SetGameplayCamRelativeHeading(0)
				end
				local newPos = GetOffsetFromEntityInWorldCoords(entity, 0.0, offsetY * (speed + 0.3), offsetZ * (speed + 0.3))
				SetEntityCoordsNoOffset(entity, newPos.x, newPos.y, newPos.z, true, true, true)
				SetEntityHeading(entity, heading)
			end
			Wait(0)
		end
		if DoesEntityExist(entity) and not Client.Noclip.Enable then
			SetEntityCollision(entity, true, true)
			FreezeEntityPosition(entity, false)
			SetEntityInvincible(entity, false)
		end
	end)
end