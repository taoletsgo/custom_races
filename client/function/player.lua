function Client.Function.Player.SetBlipAndName()
	CreateThread(function()
		while true do
			local myId = PlayerId()
			local myPed = PlayerPedId()
			local myCoords = GetEntityCoords(myPed)
			local validPlayers = {}
			for _, player in pairs(Client.Player.List) do
				local id = player[1]
				if id ~= Client.ServerId then
					validPlayers[id] = true
					local name = player[3]
					local inRace = player[4]
					local inCreator = player[5]
					local inTestMode = player[6]
					local inSpectator = player[7]
					local playerId = GetPlayerFromServerId(id)
					local _playerPed = (playerId ~= -1) and (playerId ~= myId) and GetPlayerPed(playerId)
					local playerPed = _playerPed and (_playerPed ~= 0) and (_playerPed ~= myPed) and _playerPed or nil
					local playerCoords = playerPed and GetEntityCoords(playerPed)
					local playerHeading = playerPed and GetEntityHeading(playerPed)
					local playerPosition = playerCoords and playerHeading and {x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, heading = playerHeading} or {x = player[2][1], y = player[2][2], z = player[2][3], heading = player[2][4]}
					Client.Player.Blips[id] = Client.Player.Blips[id] or {type = "", handle = nil}
					Client.Player.Names[id] = Client.Player.Names[id] or {tag = nil, ped = nil}
					if playerPed then
						if not Client.Player.Names[id].tag or (Client.Player.Names[id].ped ~= playerPed) or not IsMpGamerTagActive(Client.Player.Names[id].tag) then
							if Client.Player.Names[id].tag then
								RemoveMpGamerTag(Client.Player.Names[id].tag)
							end
							Client.Player.Names[id].tag = CreateFakeMpGamerTag(playerPed, name, false, false, "", 0)
							Client.Player.Names[id].ped = playerPed
						end
						if not IsPauseMenuActive() and not IsPlayerSwitchInProgress() and not Client.IsCreatorInQuiting and (not inCreator or (inCreator and inTestMode)) and not inSpectator and (Client.IsInSpectator and (#(myCoords - playerCoords) < 100.0) or ((#(myCoords - playerCoords) < 30.0) and HasEntityClearLosToEntity(myPed, playerPed, 17))) then
							SetMpGamerTagVisibility(Client.Player.Names[id].tag, 0, true)
						else
							SetMpGamerTagVisibility(Client.Player.Names[id].tag, 0, false)
						end
					else
						if Client.Player.Names[id].tag then
							RemoveMpGamerTag(Client.Player.Names[id].tag)
							Client.Player.Names[id].tag = nil
						end
					end
					local blipData = not inSpectator and {
						playerPed = not inCreator and playerPed or nil,
						positionX = (not playerPed or inCreator) and playerPosition.x or nil,
						positionY = (not playerPed or inCreator) and playerPosition.y or nil,
						positionZ = (not playerPed or inCreator) and playerPosition.z or nil,
						sprite = inCreator and 398 or 1,
						name = name or nil,
						scale = 0.8,
						rotation = (not playerPed or inCreator) and playerPosition.heading or nil,
						colour = inRace and 2 or 0,
						asFriendly = inRace and true or nil,
						priority = inCreator and 10 or nil,
						display = 2,
						category = 7,
						shrink = true,
						asShortRange = false,
						showHeading = true
					}
					if playerPed then
						if (not Client.Player.Blips[id].handle or (Client.Player.Blips[id].handle and not DoesBlipExist(Client.Player.Blips[id].handle))) then
							if not inSpectator then
								if inRace then
									Client.Player.Blips[id].type = "entity-race"
								elseif inCreator then
									Client.Player.Blips[id].type = "coord-creator"
								else
									Client.Player.Blips[id].type = "entity-freemode"
								end
								Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
							end
						elseif Client.Player.Blips[id].handle and DoesBlipExist(Client.Player.Blips[id].handle) then
							if not inSpectator then
								if inRace then
									if Client.Player.Blips[id].type == "entity-freemode" or Client.Player.Blips[id].type == "coord-race" or Client.Player.Blips[id].type == "coord-freemode" or Client.Player.Blips[id].type == "coord-creator" then
										RemoveBlip(Client.Player.Blips[id].handle)
										Client.Player.Blips[id].type = "entity-race"
										Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
									end
								elseif inCreator then
									if Client.Player.Blips[id].type == "entity-race" or Client.Player.Blips[id].type == "entity-freemode" or Client.Player.Blips[id].type == "coord-race" or Client.Player.Blips[id].type == "coord-freemode" then
										RemoveBlip(Client.Player.Blips[id].handle)
										Client.Player.Blips[id].type = "coord-creator"
										Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
									elseif Client.Player.Blips[id].type == "coord-creator" then
										SetBlipCoords(Client.Player.Blips[id].handle, playerPosition.x, playerPosition.y, playerPosition.z)
										SetBlipRotation(Client.Player.Blips[id].handle, math.max(1, math.min(math.ceil(playerPosition.heading), 359)))
									end
								else
									if Client.Player.Blips[id].type == "entity-race" or Client.Player.Blips[id].type == "coord-race" or Client.Player.Blips[id].type == "coord-freemode" or Client.Player.Blips[id].type == "coord-creator" then
										RemoveBlip(Client.Player.Blips[id].handle)
										Client.Player.Blips[id].type = "entity-freemode"
										Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
									end
								end
							else
								RemoveBlip(Client.Player.Blips[id].handle)
								Client.Player.Blips[id].type = ""
								Client.Player.Blips[id].handle = nil
							end
						end
					else
						if (not Client.Player.Blips[id].handle or (Client.Player.Blips[id].handle and not DoesBlipExist(Client.Player.Blips[id].handle))) then
							if not inSpectator then
								if inRace then
									Client.Player.Blips[id].type = "coord-race"
								elseif inCreator then
									Client.Player.Blips[id].type = "coord-creator"
								else
									Client.Player.Blips[id].type = "coord-freemode"
								end
								Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
							end
						elseif Client.Player.Blips[id].handle and DoesBlipExist(Client.Player.Blips[id].handle) then
							if not inSpectator then
								if inRace then
									if Client.Player.Blips[id].type == "entity-race" or Client.Player.Blips[id].type == "entity-freemode" or Client.Player.Blips[id].type == "coord-freemode" or Client.Player.Blips[id].type == "coord-creator" then
										RemoveBlip(Client.Player.Blips[id].handle)
										Client.Player.Blips[id].type = "coord-race"
										Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
									elseif Client.Player.Blips[id].type == "coord-race" then
										SetBlipCoords(Client.Player.Blips[id].handle, playerPosition.x, playerPosition.y, playerPosition.z)
										SetBlipRotation(Client.Player.Blips[id].handle, math.max(1, math.min(math.ceil(playerPosition.heading), 359)))
									end
								elseif inCreator then
									if Client.Player.Blips[id].type == "entity-race" or Client.Player.Blips[id].type == "entity-freemode" or Client.Player.Blips[id].type == "coord-race" or Client.Player.Blips[id].type == "coord-freemode" then
										RemoveBlip(Client.Player.Blips[id].handle)
										Client.Player.Blips[id].type = "coord-creator"
										Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
									elseif Client.Player.Blips[id].type == "coord-creator" then
										SetBlipCoords(Client.Player.Blips[id].handle, playerPosition.x, playerPosition.y, playerPosition.z)
										SetBlipRotation(Client.Player.Blips[id].handle, math.max(1, math.min(math.ceil(playerPosition.heading), 359)))
									end
								else
									if Client.Player.Blips[id].type == "entity-race" or Client.Player.Blips[id].type == "entity-freemode" or Client.Player.Blips[id].type == "coord-race" or Client.Player.Blips[id].type == "coord-creator" then
										RemoveBlip(Client.Player.Blips[id].handle)
										Client.Player.Blips[id].type = "coord-freemode"
										Client.Player.Blips[id].handle = Client.Function.Player.CreateBlip(blipData)
									elseif Client.Player.Blips[id].type == "coord-freemode" then
										SetBlipCoords(Client.Player.Blips[id].handle, playerPosition.x, playerPosition.y, playerPosition.z)
										SetBlipRotation(Client.Player.Blips[id].handle, math.max(1, math.min(math.ceil(playerPosition.heading), 359)))
									end
								end
							else
								RemoveBlip(Client.Player.Blips[id].handle)
								Client.Player.Blips[id].type = ""
								Client.Player.Blips[id].handle = nil
							end
						end
					end
				end
			end
			for k, v in pairs(Client.Player.Blips) do
				if not validPlayers[k] then
					if v.handle and DoesBlipExist(v.handle) then
						RemoveBlip(v.handle)
					end
					Client.Player.Blips[k] = nil
				end
			end
			for k, v in pairs(Client.Player.Names) do
				if not validPlayers[k] then
					if Client.Player.Names[k].tag then
						RemoveMpGamerTag(Client.Player.Names[k].tag)
						Client.Player.Names[k].tag = nil
					end
					Client.Player.Names[k] = nil
				end
			end
			Wait(0)
		end
	end)
end

function Client.Function.Player.CreateBlip(data)
	if not data then return end
	local blip = 0
	if data.playerPed ~= nil then
		blip = AddBlipForEntity(data.playerPed)
	elseif data.positionX ~= nil and data.positionY ~= nil and data.positionZ ~= nil then
		blip = AddBlipForCoord(data.positionX, data.positionY, data.positionZ)
	end
	if data.sprite ~= nil then
		SetBlipSprite(blip, data.sprite)
	end
	if data.scale ~= nil then
		SetBlipScale(blip, data.scale)
	end
	if data.rotation ~= nil then
		SetBlipRotation(blip, math.max(1, math.min(math.ceil(data.rotation), 359)))
	end
	if data.colour ~= nil then
		SetBlipColour(blip, data.colour)
	end
	if data.asFriendly ~= nil then
		SetBlipAsFriendly(blip, data.asFriendly)
	end
	if data.priority ~= nil then
		SetBlipPriority(blip, priority)
	end
	if data.display ~= nil then
		SetBlipDisplay(blip, data.display)
	end
	if data.category ~= nil then
		SetBlipCategory(blip, data.category)
	end
	if data.shrink ~= nil then
		SetBlipShrink(blip, data.shrink)
	end
	if data.asShortRange ~= nil then
		SetBlipAsShortRange(blip, data.asShortRange)
	end
	if data.showHeading ~= nil then
		ShowHeadingIndicatorOnBlip(blip, data.showHeading)
	end
	if data.name ~= nil then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(data.name)
		EndTextCommandSetBlipName(blip)
	end
	return blip
end