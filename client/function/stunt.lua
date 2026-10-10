function Client.Function.Stunt.TeleportToCoords(bool)
	if Client.IsTeleportingInProgress then return end
	if not Client.IsInRace and not Client.IsInCreator and (not Client.IsAnyClientMenuVisible or bool) and not Client.Noclip.Enable and not IsControlPressed(0, 37) and not IsPlayerFreeAiming(PlayerId()) and not IsPauseMenuActive() and not IsNuiFocused() and not IsPlayerSwitchInProgress() then
		if Client.Stunt.TeleportData.X and Client.Stunt.TeleportData.Y and Client.Stunt.TeleportData.Z and Client.Stunt.TeleportData.Heading then
			Client.IsTeleportingInProgress = true
			CreateThread(function()
				Client.Stunt.Vehicle = Client.Stunt.VehicleNetId and NetworkDoesNetworkIdExist(Client.Stunt.VehicleNetId) and NetworkDoesEntityExistWithNetworkId(Client.Stunt.VehicleNetId) and NetworkGetEntityFromNetworkId(Client.Stunt.VehicleNetId)
				if Client.Stunt.Vehicle and DoesEntityExist(Client.Stunt.Vehicle) then
					if IsVehicleDriveable(Client.Stunt.Vehicle, false) then
						SetEntityVisible(Client.Stunt.Vehicle, false)
						SetEntityVisible(PlayerPedId(), false)
						SetPedIntoVehicle(PlayerPedId(), Client.Stunt.Vehicle, -1)
						if Client.Preference.RepairVehicleWhenTp and not Client.Vehicle.Tuning.MenuLocked then
							Client.Vehicle.Tuning.MenuLocked = true
							Client.Function.Vehicle.Fix(Client.Stunt.Vehicle)
							CreateThread(function()
								Wait(3000)
								Client.Vehicle.Tuning.MenuLocked = false
							end)
						end
						if not Client.Stunt.TeleportData.HasAdvancedData then
							SetEntityCoords(Client.Stunt.Vehicle, Client.Stunt.TeleportData.X, Client.Stunt.TeleportData.Y, Client.Stunt.TeleportData.Z)
							SetEntityHeading(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Heading)
							SetGameplayCamRelativeHeading(0)
							Wait(0)
							SetEntityCoords(Client.Stunt.Vehicle, Client.Stunt.TeleportData.X, Client.Stunt.TeleportData.Y, Client.Stunt.TeleportData.Z)
							SetEntityHeading(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Heading)
						else
							SetEntityCoordsNoOffset(Client.Stunt.Vehicle, Client.Stunt.TeleportData.X, Client.Stunt.TeleportData.Y, Client.Stunt.TeleportData.Z)
							SetEntityHeading(Client.Stunt.Vehicle, Client.Stunt.TeleportData.CamHeading)
							SetGameplayCamRelativeHeading(0)
							Wait(0)
							SetEntityCoordsNoOffset(Client.Stunt.Vehicle, Client.Stunt.TeleportData.X, Client.Stunt.TeleportData.Y, Client.Stunt.TeleportData.Z)
							SetEntityHeading(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Heading)
							SetVehicleForwardSpeed(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Speed)
							SetEntityVelocity(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Velocity)
							SetEntityRotation(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Rotation, 2)
							Wait(0)
							SetEntityCoordsNoOffset(Client.Stunt.Vehicle, Client.Stunt.TeleportData.X, Client.Stunt.TeleportData.Y, Client.Stunt.TeleportData.Z)
							SetEntityHeading(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Heading)
							SetVehicleForwardSpeed(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Speed)
							SetEntityVelocity(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Velocity)
							SetEntityRotation(Client.Stunt.Vehicle, Client.Stunt.TeleportData.Rotation, 2)
						end
						SetEntityVisible(Client.Stunt.Vehicle, true)
						SetEntityVisible(PlayerPedId(), Client.Ped.Status.Visible)
						Client.Function.Message.Display(Client.Function.Translate.Get("teleport-success"))
					else
						SetEntityCoords(PlayerPedId(), Client.Stunt.TeleportData.X, Client.Stunt.TeleportData.Y, Client.Stunt.TeleportData.Z)
						SetEntityHeading(PlayerPedId(), Client.Stunt.TeleportData.Heading)
						SetGameplayCamRelativeHeading(0)
						Client.Function.Message.Display(Client.Function.Translate.Get("teleport-failed-respawn"))
					end
				else
					Client.Function.Message.Display(Client.Function.Translate.Get("teleport-failed-no-vehicle"))
				end
				Client.IsTeleportingInProgress = false
			end)
		else
			Client.Function.Message.Display(Client.Function.Translate.Get("teleport-failed-no-coord"))
		end
	end
end

function Client.Function.Stunt.SaveTeleportCoords(bool)
	if not Client.IsInRace and not Client.IsInCreator and (not Client.IsAnyClientMenuVisible or bool) and not Client.Noclip.Enable and not IsControlPressed(0, 37) and not IsPlayerFreeAiming(PlayerId()) and not IsPauseMenuActive() and not IsNuiFocused() and not IsPlayerSwitchInProgress() then
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		Client.Stunt.TeleportData.X = pos.x
		Client.Stunt.TeleportData.Y = pos.y
		Client.Stunt.TeleportData.Z = pos.z
		Client.Stunt.TeleportData.Heading = GetEntityHeading(ped)
		Client.Stunt.Vehicle = Client.Stunt.VehicleNetId and NetworkDoesNetworkIdExist(Client.Stunt.VehicleNetId) and NetworkDoesEntityExistWithNetworkId(Client.Stunt.VehicleNetId) and NetworkGetEntityFromNetworkId(Client.Stunt.VehicleNetId)
		if Client.Preference.AdvancedTeleport and Client.Stunt.Vehicle and DoesEntityExist(Client.Stunt.Vehicle) and Client.Stunt.Vehicle == GetVehiclePedIsIn(ped, false) then
			Client.Stunt.TeleportData.Speed = GetEntitySpeed(Client.Stunt.Vehicle)
			Client.Stunt.TeleportData.Rotation = GetEntityRotation(Client.Stunt.Vehicle, 2)
			Client.Stunt.TeleportData.Velocity = GetEntityVelocity(Client.Stunt.Vehicle)
			Client.Stunt.TeleportData.CamHeading = GetGameplayCamRot(2).z
			Client.Stunt.TeleportData.HasAdvancedData = true
		else
			Client.Stunt.TeleportData.Speed = 0.0
			Client.Stunt.TeleportData.Rotation = vector3(0.0, 0.0, 0.0)
			Client.Stunt.TeleportData.Velocity = vector3(0.0, 0.0, 0.0)
			Client.Stunt.TeleportData.CamHeading = 0.0
			Client.Stunt.TeleportData.HasAdvancedData = false
		end
		Client.Function.Message.Display(Client.Function.Translate.Get("teleport-coord-update"))
	end
end