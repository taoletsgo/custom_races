CreateThread(function()
	local count = 0
	for i = 1, #Creator.Data.Category.List do
		count = count + #Creator.Data.Category.List[i].model
	end
	Creator.Data.Check.TotalCount = count
	local queueCount = 0
	local validModel = {}
	local validCategory = {}
	for i = 1, #Creator.Data.Category.List do
		queueCount = queueCount + 1
		validModel[i] = {}
		while queueCount > 10 do Wait(0) end
		CreateThread(function()
			for j = 1, #Creator.Data.Category.List[i].model do
				Creator.Data.Check.CurrentCount = Creator.Data.Check.CurrentCount + 1
				local hash = tonumber(Creator.Data.Category.List[i].model[j]) or GetHashKey(Creator.Data.Category.List[i].model[j])
				if IsModelInCdimage(hash) and IsModelValid(hash) then
					RequestModel(hash)
					while not HasModelLoaded(hash) do Wait(0) end
					table.insert(validModel[i], Creator.Data.Category.List[i].model[j])
					local min, max = GetModelDimensions(hash)
					Client.Shared.Dimensions.Min[hash] = min
					Client.Shared.Dimensions.Max[hash] = max
					Client.Shared.Dimensions.Radius[hash] = math.sqrt((max.x - min.x)^2 + (max.y - min.y)^2 + (max.z - min.z)^2) * 0.5
					SetModelAsNoLongerNeeded(hash)
				end
			end
			queueCount = queueCount - 1
		end)
	end
	while queueCount > 0 do Wait(0) end
	for i = 1, #validModel do
		if #validModel[i] > 0 then
			local currentCategory = #validCategory + 1
			validCategory[currentCategory] = {
				class = tostring(currentCategory),
				model = validModel[i],
				index = 1
			}
		end
	end
	while Client.FirstLoad do Wait(0) end
	local favoriteModels = {}
	for model, _ in pairs(Creator.Data.Favorite) do
		if IsModelInCdimage(model) and IsModelValid(model) then
			table.insert(favoriteModels, model)
		end
	end
	validCategory[#validCategory + 1] = {
		class = "★",
		model = favoriteModels,
		index = 1
	}
	Creator.Data.Category.List = validCategory
	Creator.Data.Check.Done = true
end)

function Creator.Function.Open()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local veh = GetVehiclePedIsIn(ped, false)
	local wasJumping = false
	local wasFalling = false
	Client.Hud.ResetNextFrame = true
	Client.Ped.Status.WasDoingBeastJump = false
	Creator.Function.Multiplayer.SendPreview()
	SetSwimMultiplierForPlayer(PlayerId(), 1.0)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
	if IsRecording() then
		Client.Function.Recording.Cancel()
	end
	Client.Function.Environment.SetWeather("CLEAR")
	Client.Function.Environment.SetTime(12, 0, 0)
	Creator.Cache.JoinPoint = pos
	Creator.Cache.JoinHeading = GetEntityHeading(ped)
	if DoesEntityExist(veh) then
		Creator.Cache.VehicleProps = Client.Function.Tuning.GetProperties(veh, true)
		Creator.Track.Current.TestVehicle = Creator.Cache.VehicleProps.model ~= 0 and Creator.Cache.VehicleProps.model or ""
		Creator.Cache.JoinVehicleNetId = NetworkGetNetworkIdFromEntity(veh)
		SetVehicleForwardSpeed(veh, 0.0)
	end
	Client.Busyspinner.Status = "load"
	RemoveLoadingPrompt()
	BeginTextCommandBusyString("STRING")
	AddTextComponentSubstringPlayerName(string.format(Client.Function.Translate.Get("load-progress"), 0))
	EndTextCommandBusyString(4)
	Creator.GlobalVar.Lock = true
	TriggerServerCallback("server:creator:getData", function(result)
		Creator.Track.All = result
		if Creator.Track.Index > #result then
			Creator.Track.Index = 1
		end
		local races = {}
		local seen = {}
		local str = string.lower(Creator.Track.FilterStr)
		if #str > 0 then
			for i = 1, #Creator.Track.All - 1 do
				for j = 1, #Creator.Track.All[i].data do
					if string.find(string.lower(Creator.Track.All[i].data[j].name), str) and not seen[Creator.Track.All[i].data[j].raceId] then
						table.insert(races, Creator.Track.All[i].data[j])
						seen[Creator.Track.All[i].data[j].raceId] = true
						if #races >= 50 then
							break
						end
					end
				end
				if #races >= 50 then
					break
				end
			end
		end
		Creator.Track.All[#Creator.Track.All].data = races
		if RageUI.QuitIndex and RageUI.CurrentMenu ~= nil then
			if #Creator.Track.All[Creator.Track.Index].data >= 1 then
				if RageUI.QuitIndex < (10 + #Creator.Track.All[Creator.Track.Index].data) then
					RageUI.CurrentMenu.Index = RageUI.QuitIndex
				else
					RageUI.CurrentMenu.Index = 10 + #Creator.Track.All[Creator.Track.Index].data
				end
			else
				RageUI.CurrentMenu.Index = RageUI.CurrentMenu.Index
			end
		end
		RemoveLoadingPrompt()
		Client.Busyspinner.Status = nil
		Creator.GlobalVar.Lock = false
	end)
	Creator.Track.Current.AvailableVehicles = {}
	for classid = 0, 27 do
		local index = nil
		local vehicles = {}
		if Client.Shared.Vanilla[classid].aveh then
			for i = 0, #Client.Shared.Vanilla[classid].aveh - 1 do
				local model = Client.Shared.Vanilla[classid].aveh[i + 1]
				local hash = GetHashKey(model)
				table.insert(vehicles, {model = model, hash = hash, name = GetLabelText(GetDisplayNameFromVehicleModel(hash)), enabled = Creator.Track.Current.TestVehicle == hash, aveh = i})
				if Creator.Track.Current.TestVehicle == hash then
					index = i + 1
					Creator.Track.Current.DefaultClass = classid
				end
			end
		end
		if Client.Shared.Vanilla[classid].adlc then
			for i = 0, #Client.Shared.Vanilla[classid].adlc - 1 do
				local model = Client.Shared.Vanilla[classid].adlc[i + 1]
				local hash = GetHashKey(model)
				if (i >= (31 * 0)) and (i < (31 * (0 + 1))) then
					table.insert(vehicles, {model = model, hash = hash, name = GetLabelText(GetDisplayNameFromVehicleModel(hash)), enabled = Creator.Track.Current.TestVehicle == hash, adlc = i})
				elseif (i >= (31 * 1)) and (i < (31 * (1 + 1))) then
					table.insert(vehicles, {model = model, hash = hash, name = GetLabelText(GetDisplayNameFromVehicleModel(hash)), enabled = Creator.Track.Current.TestVehicle == hash, adlc2 = i - 31})
				elseif (i >= (31 * 2)) and (i < (31 * (2 + 1))) then
					table.insert(vehicles, {model = model, hash = hash, name = GetLabelText(GetDisplayNameFromVehicleModel(hash)), enabled = Creator.Track.Current.TestVehicle == hash, adlc3 = i - (31 * 2)})
				else
					table.insert(vehicles, {model = model, hash = hash, name = GetLabelText(GetDisplayNameFromVehicleModel(hash)), enabled = Creator.Track.Current.TestVehicle == hash, not_used = true})
				end
				if Creator.Track.Current.TestVehicle == hash then
					index = index or ((Client.Shared.Vanilla[classid].aveh and #Client.Shared.Vanilla[classid].aveh or 0) + i + 1)
					Creator.Track.Current.DefaultClass = classid
				end
			end
		end
		Creator.Track.Current.AvailableVehicles[classid] = {
			class = Client.Shared.Vanilla[classid].class,
			index = index,
			vehicles = vehicles
		}
	end
	local fakeHash = GetHashKey("stt_prop_stunt_bblock_sml1")
	RequestModel(fakeHash)
	while not HasModelLoaded(fakeHash) do Wait(0) end
	Creator.GlobalVar.FakeObject = CreateObjectNoOffset(fakeHash, 1000.0, 1000.0, 1000.0, false, true, false)
	FreezeEntityPosition(Creator.GlobalVar.FakeObject, true)
	SetEntityVisible(Creator.GlobalVar.FakeObject, false)
	SetEntityCollision(Creator.GlobalVar.FakeObject, false, false)
	SetModelAsNoLongerNeeded(fakeHash)
	SetBlipAlpha(GetMainPlayerBlipId(), 0)
	Creator.GlobalVar.CreatorBlipHandle = AddBlipForCoord(Creator.Cache.JoinPoint.x, Creator.Cache.JoinPoint.y, Creator.Cache.JoinPoint.z)
	SetBlipSprite(Creator.GlobalVar.CreatorBlipHandle, 398)
	SetBlipPriority(Creator.GlobalVar.CreatorBlipHandle, 11)
	SetLocalPlayerAsGhost(true)
	Client.Function.Weapon.RemoveAll(ped)
	DeleteWaypoint()
	RageUI.Visible(Creator.Menu.Main, true)
	Audio.PlaySound(RageUI.Settings.Audio.Back.audioName, RageUI.Settings.Audio.Back.audioRef)
	Creator.Function.Camera.Create(ped, Creator.Cache.JoinPoint, Creator.Cache.JoinHeading)
	Creator.Function.Pool.SpawnNearbyObjects()
	Client.Function.Blimp.Init(function()
		CreateThread(function()
			Client.Function.Blimp.SetText(Client.Blimp.Scaleform, Creator.Track.Current.BlimpText)
			Client.Function.Blimp.SetColor(Client.Blimp.Scaleform, 1)
			Client.Function.Blimp.SetSpeed(Client.Blimp.Scaleform, 100.0)
			while Client.IsInCreator and not Client.IsCreatorInQuiting do
				Client.Function.Blimp.Render(Client.Blimp.Scaleform, Client.Blimp.Rendertarget)
				Wait(0)
			end
			Client.Function.Blimp.Release()
			Client.Blimp.Scaleform = nil
			Client.Blimp.Rendertarget = nil
		end)
	end)
	ClearAreaLeaveVehicleHealth(Creator.Cache.JoinPoint.x + 0.0, Creator.Cache.JoinPoint.y + 0.0, Creator.Cache.JoinPoint.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
	RequestAdditionalText("FMMC", 2)
	CreateThread(function()
		for object, objectLabel in pairs(json.decode(LoadResourceFile(GetCurrentResourceName(), "data/label.json"))) do
			local objectHash = tonumber(object) or GetHashKey(object)
			Creator.Data.ObjectLabels[objectHash] = objectLabel
		end
		for _, model in pairs(json.decode(LoadResourceFile(GetCurrentResourceName(), "data/object.json"))) do
			Creator.Data.ObjectModels[GetHashKey(model)] = model
		end
		table.sort(Creator.Data.Category.List[#Creator.Data.Category.List].model, function(a, b) return string.lower(Client.Function.Translate.GetObjectLabelText(a)) < string.lower(Client.Function.Translate.GetObjectLabelText(b)) end)
	end)
	CreateThread(function()
		while Client.IsInCreator and not Client.IsCreatorInQuiting do
			ped = PlayerPedId()
			pos = GetEntityCoords(ped)
			Creator.GlobalVar.RunningMainThread = true

			SetEntityInvincible(ped, true)
			SetPedArmour(ped, 100)
			SetEntityHealth(ped, 200)

			if Creator.GlobalVar.IsUsingKeyboard ~= IsUsingKeyboard() then
				Creator.GlobalVar.IsUsingKeyboard = IsUsingKeyboard()
				if Creator.GlobalVar.EnableTest and Creator.GlobalVar.TipsRendered then
					ClearAllHelpMessages()
					BeginTextCommandDisplayHelp("THREESTRINGS")
					AddTextComponentSubstringPlayerName(Client.Function.Translate.Get("quit-test"))
					AddTextComponentSubstringPlayerName("")
					AddTextComponentSubstringPlayerName("")
					EndTextCommandDisplayHelp(0, true, false, -1)
				end
			end

			if not Creator.GlobalVar.EnableTest then
				if IsPauseMenuActive() then
					if not Creator.GlobalVar.TempClosed then
						Creator.GlobalVar.TempClosed = true
						RageUI.CloseAll()
					end
				else
					if Creator.GlobalVar.TempClosed then
						Creator.GlobalVar.TempClosed = false
						RageUI.Visible(Creator.Menu.Main, true)
						Audio.PlaySound(RageUI.Settings.Audio.Back.audioName, RageUI.Settings.Audio.Back.audioRef)
					end
				end
			end

			if Creator.GlobalVar.EnableTest then
				SetPlayerCanDoDriveBy(PlayerId(), true)
				local vehicle = GetVehiclePedIsIn(ped, false)
				local vehicleR, vehicleG, vehicleB = nil, nil, nil
				if vehicle > 0 then
					local rot = GetEntityRotation(vehicle, 2)
					local pitch, roll, yaw = table.unpack(rot)
					if math.abs(pitch) < 90.0 and math.abs(roll) < 45.0 and not IsEntityInWater(ped) then
						SetPedConfigFlag(ped, 151, false)
						SetPedCanBeKnockedOffVehicle(ped, 1)
					else
						SetPedConfigFlag(ped, 151, true)
						SetPedCanBeKnockedOffVehicle(ped, 3)
					end
					local model = GetEntityModel(vehicle)
					local class = GetVehicleClassFromName(model)
					if class ~= 8 and class ~= 13 and not IsThisModelAPlane(model) and not IsThisModelAHeli(model) and not (model == GetHashKey("submersible")) and not (model == GetHashKey("submersible2")) and not (model == GetHashKey("avisa")) then
						UseVehicleCamStuntSettingsThisUpdate()
					end
					vehicleR, vehicleG, vehicleB = GetVehicleColor(vehicle)
					if DoesVehicleHaveWeapons(vehicle) == 1 then
						local weapons = {2971687502, 1945616459, 3450622333, 3530961278, 1259576109, 4026335563, 1566990507, 1186503822, 2669318622, 3473446624, 4171469727, 1741783703, 2211086889}
						for i = 1, #weapons do
							DisableVehicleWeapon(true, weapons[i], vehicle, ped)
						end
					end
				end

				for k, v in pairs(Creator.ArenaProps) do
					if not v.touching and DoesEntityExist(v.handle) and IsEntityTouchingEntity(vehicle > 0 and vehicle or ped, v.handle) then
						v.touching = true
						CreateThread(function()
							if DoesEntityExist(v.handle) then
								SetEnableArenaPropPhysics(v.handle, true)
							end
							Wait(5000)
							if DoesEntityExist(v.handle) then
								SetEnableArenaPropPhysics(v.handle, false)
							end
							v.touching = nil
						end)
					end
				end

				for k, v in pairs(Creator.ExplodeProps) do
					if not v.exploded and DoesEntityExist(v.handle) and IsEntityTouchingEntity(vehicle > 0 and vehicle or ped, v.handle) then
						v.exploded = true
						local coords = GetEntityCoords(v.handle)
						FreezeEntityPosition(v.handle, true)
						SetEntityVisible(v.handle, false)
						SetEntityCollision(v.handle, false, false)
						SetEntityCompletelyDisableCollision(v.handle, false, false)
						AddExplosion(coords.x, coords.y, coords.z, 58, 1.0, true, false, 1.0, false)
					end
				end

				if Creator.GlobalVar.EnableBeastMode then
					SetSuperJumpThisFrame(PlayerId())
					SetBeastModeActive(PlayerId())
					local isJumping = IsPedDoingBeastJump(ped)
					local isFalling = IsPedFalling(ped)
					if isJumping and not wasJumping then
						Creator.GlobalVar.WasDoingBeastJump = true
						PlaySoundFromEntity(-1, "Beast_Jump", ped, "DLC_AR_Beast_Soundset", true, 60)
					end
					if not isFalling and wasFalling and Creator.GlobalVar.WasDoingBeastJump then
						Creator.GlobalVar.WasDoingBeastJump = false
						PlaySoundFromEntity(-1, "Beast_Jump_Land", ped, "DLC_AR_Beast_Soundset", true, 60)
					end
					wasJumping = isJumping
					wasFalling = isFalling
				end

				if #Creator.Track.Current.Fixtures > 0 then
					local hide = {}
					for k, v in pairs(Creator.Track.Current.Fixtures) do
						hide[v.hash] = true
					end
					local spawn = {}
					for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
						if object.handle then
							spawn[object.handle] = true
						end
					end
					local pool = GetGamePool("CObject")
					for i = 1, #pool do
						local fixture = pool[i]
						if fixture and not spawn[fixture] and DoesEntityExist(fixture) then
							local hash = GetEntityModel(fixture)
							if hide[hash] then
								SetEntityAsMissionEntity(fixture, true, true)
								DeleteEntity(fixture)
							end
						end
					end
					for k, v in pairs(Creator.Track.Current.Fixtures) do
						local fixture = GetClosestObjectOfType(pos.x, pos.y, pos.z, 300.0, v.hash, false)
						if fixture and not spawn[fixture] and DoesEntityExist(fixture) then
							SetEntityAsMissionEntity(fixture, true, true)
							DeleteEntity(fixture)
						end
					end
				end

				for k, v in pairs(Creator.FireworkProps) do
					if not v.playing and DoesEntityExist(v.handle) and (#(pos - GetEntityCoords(v.handle)) <= 50.0) then
						v.playing = true
						CreateThread(function()
							RequestNamedPtfxAsset("scr_indep_fireworks")
							while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do Wait(0) end
							UseParticleFxAssetNextCall("scr_indep_fireworks")
							local effect = StartParticleFxLoopedOnEntity(Creator.Track.Current.Firework.Name, v.handle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false)
							local r, g, b = tonumber(Creator.Track.Current.Firework.R), tonumber(Creator.Track.Current.Firework.G), tonumber(Creator.Track.Current.Firework.B)
							if r and g and b then
								SetParticleFxLoopedColour(effect, (r / 255) + 0.0, (g / 255) + 0.0, (b / 255) + 0.0, true)
							end
							Wait(2000)
							StopParticleFxLooped(effect, true)
							v.playing = nil
						end)
					end
				end

				local checkPointTouched = false
				local checkpoint = Creator.GlobalVar.RespawnData and Creator.GlobalVar.RespawnData.DrawIndex and Creator.GlobalVar.TestData.Checkpoints and Creator.GlobalVar.TestData.Checkpoints[Creator.GlobalVar.RespawnData.DrawIndex]
				local checkpoint_2 = Creator.GlobalVar.RespawnData and Creator.GlobalVar.RespawnData.DrawIndex and Creator.GlobalVar.TestData.Checkpoints_2 and Creator.GlobalVar.TestData.Checkpoints_2[Creator.GlobalVar.RespawnData.DrawIndex]
				local nextCheckpoint = Creator.GlobalVar.RespawnData and Creator.GlobalVar.RespawnData.DrawIndex and Creator.GlobalVar.TestData.Checkpoints and Creator.GlobalVar.TestData.Checkpoints[Creator.GlobalVar.RespawnData.DrawIndex + 1]
				local nextCheckpoint_2 = Creator.GlobalVar.RespawnData and Creator.GlobalVar.RespawnData.DrawIndex and Creator.GlobalVar.TestData.Checkpoints_2 and Creator.GlobalVar.TestData.Checkpoints_2[Creator.GlobalVar.RespawnData.DrawIndex + 1]

				local checkpointCoords = nil
				local collectSize = nil
				local checkpointRadius = nil
				local _checkpointCoords = nil
				local checkpointSlow = false
				if checkpoint and Creator.GlobalVar.TipsRendered then
					checkpointCoords = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
					collectSize = ((checkpoint.isAir and (4.5 * checkpoint.diameterCollect)) or ((checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) and (2.25 * checkpoint.diameterCollect)) or checkpoint.diameterCollect) * 10
					checkpointRadius = collectSize / 2
					_checkpointCoords = checkpointCoords
					if checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp then
						if not checkpoint.isAir then
							_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
						end
					else
						_checkpointCoords = checkpointCoords + vector3(0, 0, checkpointRadius)
					end
					if checkpoint.isPlaneRot and checkpoint.drawId then
						if vehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(checkpoint, vehicle) then
							local r, g, b = GetHudColour(6)
							SetCheckpointRgba2(checkpoint.drawId, r, g, b, 150)
							checkpointSlow = true
						else
							local r, g, b = GetHudColour(134)
							SetCheckpointRgba2(checkpoint.drawId, r, g, b, 150)
							checkpointSlow = false
						end
					end
				end

				local checkpointCoords_2 = nil
				local collectSize_2 = nil
				local checkpointRadius_2 = nil
				local _checkpointCoords_2 = nil
				local checkpointSlow_2 = false
				if checkpoint_2 and Creator.GlobalVar.TipsRendered then
					checkpointCoords_2 = vector3(checkpoint_2.x, checkpoint_2.y, checkpoint_2.z)
					collectSize_2 = ((checkpoint_2.isAir and (4.5 * checkpoint_2.diameterCollect)) or ((checkpoint_2.isRound or checkpoint_2.isRandom or checkpoint_2.isTransform or checkpoint_2.isPlaneRot or checkpoint_2.isWarp) and (2.25 * checkpoint_2.diameterCollect)) or checkpoint_2.diameterCollect) * 10
					checkpointRadius_2 = collectSize_2 / 2
					_checkpointCoords_2 = checkpointCoords_2
					if checkpoint_2.isRound or checkpoint_2.isRandom or checkpoint_2.isTransform or checkpoint_2.isPlaneRot or checkpoint_2.isWarp then
						if not checkpoint_2.isAir then
							_checkpointCoords_2 = checkpointCoords_2 + vector3(0, 0, checkpointRadius_2)
						end
					else
						_checkpointCoords_2 = checkpointCoords_2 + vector3(0, 0, checkpointRadius_2)
					end
					if checkpoint_2.isPlaneRot and checkpoint_2.drawId then
						if vehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(checkpoint_2, vehicle) then
							local r, g, b = GetHudColour(6)
							SetCheckpointRgba2(checkpoint_2.drawId, r, g, b, 150)
							checkpointSlow_2 = true
						else
							local r, g, b = GetHudColour(134)
							SetCheckpointRgba2(checkpoint_2.drawId, r, g, b, 150)
							checkpointSlow_2 = false
						end
					end
				end

				if checkpointCoords and collectSize and checkpointRadius and _checkpointCoords and ((#(pos - checkpointCoords) <= (checkpointRadius * 2.0)) or (#(pos - _checkpointCoords) <= (checkpointRadius * 1.5))) and not Creator.GlobalVar.IsRespawning and not Creator.GlobalVar.IsTransforming then
					checkPointTouched = true
					local effect_1 = 0
					local effect_2 = 0
					if checkpoint.isPlaneRot and vehicle > 0 then
						if checkpointSlow then
							effect_1 = 2
							Client.Function.Shared.SlowVehicle(vehicle)
						else
							effect_1 = 1
						end
					end
					if checkpoint.isWarp and nextCheckpoint then
						effect_2 = 1
						Client.Function.Shared.WarpVehicle(nextCheckpoint, vehicle > 0 and vehicle or ped)
					end
					if (checkpoint.isTransform or checkpoint.isRandom) then
						effect_2 = effect_2 == 0 and 2 or effect_2
						local speed = vehicle > 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
						local rotation = vehicle > 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
						local velocity = vehicle > 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
						Creator.Function.TransformVehicle(checkpoint, speed, rotation, velocity)
					else
						if checkpoint.isPit and vehicle > 0 then
							Client.Function.Vehicle.Fix(vehicle)
						end
					end
					Client.Function.Shared.PlayEffectAndSound(ped, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
				elseif checkpointCoords_2 and collectSize_2 and checkpointRadius_2 and _checkpointCoords_2 and ((#(pos - checkpointCoords_2) <= (checkpointRadius_2 * 2.0)) or (#(pos - _checkpointCoords_2) <= (checkpointRadius_2 * 1.5))) and not Creator.GlobalVar.IsRespawning and not Creator.GlobalVar.IsTransforming then
					checkPointTouched = true
					local effect_1 = 0
					local effect_2 = 0
					if checkpoint_2.isPlaneRot and vehicle > 0 then
						if checkpointSlow_2 then
							effect_1 = 2
							Client.Function.Shared.SlowVehicle(vehicle)
						else
							effect_1 = 1
						end
					end
					if checkpoint_2.isWarp and (nextCheckpoint_2 or nextCheckpoint) then
						effect_2 = 1
						Client.Function.Shared.WarpVehicle(nextCheckpoint_2 or nextCheckpoint, vehicle > 0 and vehicle or ped)
					end
					if (checkpoint_2.isTransform or checkpoint_2.isRandom) then
						effect_2 = effect_2 == 0 and 2 or effect_2
						local speed = vehicle > 0 and GetEntitySpeed(vehicle) or GetEntitySpeed(ped)
						local rotation = vehicle > 0 and GetEntityRotation(vehicle, 2) or GetEntityRotation(ped, 2)
						local velocity = vehicle > 0 and GetEntityVelocity(vehicle) or GetEntityVelocity(ped)
						Creator.Function.TransformVehicle(checkpoint_2, speed, rotation, velocity)
					else
						if checkpoint_2.isPit and vehicle > 0 then
							Client.Function.Vehicle.Fix(vehicle)
						end
					end
					Client.Function.Shared.PlayEffectAndSound(ped, effect_1, effect_2, vehicleR, vehicleG, vehicleB)
				end

				if checkPointTouched then
					Creator.GlobalVar.RespawnData.DrawIndex = Creator.GlobalVar.RespawnData.DrawIndex + 1
					Creator.Function.ResetCheckpointAndBlip()
					Creator.Function.CreateCheckpointBlip(Creator.GlobalVar.RespawnData.DrawIndex)
					Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, false)
					Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, true)
				end

				if (IsControlJustReleased(0, 75) or IsDisabledControlJustReleased(0, 75)) and not Creator.GlobalVar.IsRespawning and not Creator.GlobalVar.IsTransforming and not checkPointTouched then
					Creator.GlobalVar.IsRespawning = true
					Creator.Function.TestCurrentCheckpoint(Creator.GlobalVar.RespawnData)
				elseif Creator.GlobalVar.AutoRespawn and not Creator.GlobalVar.IsRespawning and not Creator.GlobalVar.IsTransforming and vehicle == 0 and not checkPointTouched then
					Creator.GlobalVar.IsRespawning = true
					Creator.Function.TestCurrentCheckpoint(Creator.GlobalVar.RespawnData)
				end

				if IsControlJustReleased(0, 48) and not Creator.GlobalVar.IsRespawning and not Creator.GlobalVar.IsTransforming and Creator.GlobalVar.TipsRendered and not checkPointTouched then
					TriggerServerEvent("server:core:inTestMode", false)
					Creator.GlobalVar.QuitingTest = true
					Creator.GlobalVar.EnableTest = false
					Creator.GlobalVar.TipsRendered = false
					if Creator.GlobalVar.TestVehicleHandle then
						local netId = NetworkGetNetworkIdFromEntity(Creator.GlobalVar.TestVehicleHandle)
						DeleteEntity(Creator.GlobalVar.TestVehicleHandle)
						TriggerServerEvent("server:core:deleteEntity", netId)
						Creator.GlobalVar.TestVehicleHandle = nil
					end
					Creator.GlobalVar.AutoRespawn = false
					Creator.GlobalVar.EnableBeastMode = false
					Creator.GlobalVar.WasDoingBeastJump = false
					Creator.Function.ResetCheckpointAndBlip()
					if IsWaypointActive() then
						DeleteWaypoint()
					end
					CreateThread(function()
						SetRadarBigmapEnabled(Creator.GlobalVar.RadarBigmapChecked, false)
						Wait(0)
						if Creator.GlobalVar.RadarBigmapChecked then
							SetRadarZoom(500)
						else
							SetRadarZoom(1200)
						end
					end)
					SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
					SetPedConfigFlag(ped, 151, true)
					SetPedCanBeKnockedOffVehicle(ped, 0)
					Client.Function.Weapon.RemoveAll(ped)
					ClearAllHelpMessages()
					RageUI.Visible(Creator.Menu.Main, true)
					Audio.PlaySound(RageUI.Settings.Audio.Back.audioName, RageUI.Settings.Audio.Back.audioRef)
					Creator.Function.Camera.Create(ped, Creator.Cache.JoinPoint, Creator.Cache.JoinHeading)
					SetEntityCoordsNoOffset(ped, pos.x + 1000.0, pos.y + 1000.0, pos.z)
					ClearAreaLeaveVehicleHealth(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0, 100000000000000000000000.0, false, false, false, false, false)
					for uniqueId, effectData in pairs(Creator.ObjectPool.ActiveEffects) do
						if effectData.ptfxHandle then
							StopParticleFxLooped(effectData.ptfxHandle, true)
							effectData.ptfxHandle = nil
						end
						Creator.ObjectPool.ActiveEffects[uniqueId] = nil
					end
					for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
						if object.handle then
							DeleteObject(object.handle)
							object.handle = nil
						end
						Creator.ObjectPool.ActiveObjects[uniqueId] = nil
					end
					Creator.ObjectPool.ActiveGrids = {}
					Wait(0)
					for k, v in pairs(Creator.Track.Current.Checkpoints) do
						Creator.Blips.Checkpoints[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
					end
					for k, v in pairs(Creator.Track.Current.Checkpoints_2) do
						Creator.Blips.Checkpoints_2[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
					end
					for k, v in pairs(Creator.ArenaProps) do
						v.touching = nil
					end
					Creator.ArenaProps = {}
					for k, v in pairs(Creator.ExplodeProps) do
						v.exploded = nil
					end
					Creator.ExplodeProps = {}
					for k, v in pairs(Creator.FireworkProps) do
						v.playing = nil
					end
					Creator.FireworkProps = {}
					SetBlipAlpha(GetMainPlayerBlipId(), 0)
					Creator.GlobalVar.CreatorBlipHandle = AddBlipForCoord(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0)
					SetBlipSprite(Creator.GlobalVar.CreatorBlipHandle, 398)
					SetBlipPriority(Creator.GlobalVar.CreatorBlipHandle, 11)
					Creator.GlobalVar.QuitingTest = false
				end
			end

			if RageUI.Visible(Creator.Menu.Main) then
				Creator.ButtonToDraw = -1
				if Creator.Track.Current.Title ~= "" then
					if Client.NUI.Callback == "import ugc" then
						SetNuiFocus(false, false)
						SendNUIMessage({
							action = "input off"
						})
						Client.NUI.Callback = ""
					end
					if Creator.GlobalVar.Querying then
						Creator.GlobalVar.Querying = false
						TriggerServerEvent("server:creator:cancelSearch")
					end
				end
			end

			if RageUI.Visible(Creator.Menu.RaceDetail.Main) then
				if not IsNuiFocused() then
					if Creator.GlobalVar.ThumbnailValid then
						if not Creator.GlobalVar.ShowThumbnail and not Creator.GlobalVar.QueryingThumbnail then
							Creator.GlobalVar.ShowThumbnail = true
							SendNUIMessage({
								action = "thumbnail on"
							})
						end
					else
						if Creator.GlobalVar.ShowThumbnail then
							Creator.GlobalVar.ShowThumbnail = false
							SendNUIMessage({
								action = "thumbnail off"
							})
						end
					end
				else
					if Creator.GlobalVar.ShowThumbnail then
						Creator.GlobalVar.ShowThumbnail = false
						SendNUIMessage({
							action = "thumbnail off"
						})
					end
				end
			else
				if Creator.GlobalVar.ShowThumbnail then
					Creator.GlobalVar.ShowThumbnail = false
					SendNUIMessage({
						action = "thumbnail off"
					})
				end
				if (Client.NUI.Callback == "race title" and Creator.Track.Current.Title ~= "") or Client.NUI.Callback == "race thumbnail" or Client.NUI.Callback == "input vehicle" or Client.NUI.Callback == "blimp text" then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "input off"
					})
					Client.NUI.Callback = ""
				end
			end

			if RageUI.Visible(Creator.Menu.Placement.StartingGrid) then
				Creator.StartingGrid.IsMenuVisible = true
				Creator.ButtonToDraw = 1
			else
				Creator.StartingGrid.IsMenuVisible = false
				Creator.StartingGrid.IsPickedUp = false
				if Creator.StartingGrid.Select then
					Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
					end
					Creator.StartingGrid.Select = nil
					Creator.Function.ResetGlobalVariable("startingGrid")
				end
				if Creator.StartingGrid.Preview then
					DeleteVehicle(Creator.StartingGrid.Preview)
					Creator.StartingGrid.Preview = nil
					Creator.Function.ResetGlobalVariable("startingGrid")
				end
				if Client.NUI.Callback == "goto startingGrid" or Client.NUI.Callback == "startingGrid heading" then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "input off"
					})
					Client.NUI.Callback = ""
				end
			end

			if RageUI.Visible(Creator.Menu.Placement.Checkpoint.Main) or RageUI.Visible(Creator.Menu.Placement.Checkpoint.ExtraRandomSetting) then
				Creator.Checkpoint.IsMenuVisible = true
				Creator.ButtonToDraw = 2
			else
				Creator.Checkpoint.IsMenuVisible = false
				if Creator.Checkpoint.IsPickedUp then
					Creator.Checkpoint.IsPickedUp = false
					Creator.Function.ResetGlobalVariable("checkpoint")
				end
				if Creator.Checkpoint.Preview then
					Creator.Checkpoint.Preview = nil
					Creator.Function.ResetGlobalVariable("checkpoint")
				end
				if Client.NUI.Callback == "goto checkpoint" or Client.NUI.Callback == "place checkpoint" or Client.NUI.Callback == "checkpoint x" or Client.NUI.Callback == "checkpoint y" or Client.NUI.Callback == "checkpoint z" or Client.NUI.Callback == "checkpoint heading" or Client.NUI.Callback == "checkpoint pitch" or Client.NUI.Callback == "checkpoint random custom" or Client.NUI.Callback == "checkpoint transform vehicles" then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "input off"
					})
					Client.NUI.Callback = ""
				end
			end

			if RageUI.Visible(Creator.Menu.Placement.Prop) then
				Creator.Object.IsMenuVisible = true
				Creator.ButtonToDraw = 3
			else
				Creator.Object.IsMenuVisible = false
				if Creator.Object.IsPickedUp then
					Creator.Object.IsPickedUp = false
					Creator.Function.ResetGlobalVariable("object")
				end
				if Creator.Snapping.Handle then
					Creator.Snapping.Handle = nil
					Creator.Snapping.ObjectData = nil
				end
				Creator.Snapping.NextObjectUniqueId = nil
				if Creator.Object.Preview then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
					Creator.Function.ResetGlobalVariable("object")
				end
				Creator.GlobalVar.PropZposLock = nil
				Creator.GlobalRot.X = 0.0
				Creator.GlobalRot.Y = 0.0
				Creator.GlobalVar.PropColor = nil
				if Client.NUI.Callback == "goto prop" or Client.NUI.Callback == "prop hash" or Client.NUI.Callback == "prop x" or Client.NUI.Callback == "prop y" or Client.NUI.Callback == "prop z" or Client.NUI.Callback == "prop rotX" or Client.NUI.Callback == "prop rotY" or Client.NUI.Callback == "prop rotZ" or Client.NUI.Callback == "prop override" then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "input off"
					})
					Client.NUI.Callback = ""
				end
			end

			if RageUI.Visible(Creator.Menu.Placement.Template) then
				Creator.Template.IsMenuVisible = true
				Creator.ButtonToDraw = 4
			else
				Creator.Template.IsMenuVisible = false
				Creator.Template.IsPickedUp = false
				if #Creator.Template.Current > 0 then
					for i = 1, #Creator.Template.Current do
						if DoesEntityExist(Creator.Template.Current[i].handle) then
							SetEntityDrawOutline(Creator.Template.Current[i].handle, false)
						end
					end
					Creator.Function.ResetGlobalVariable("template")
				end
				if #Creator.Template.Preview > 0 then
					for i = 1, #Creator.Template.Preview do
						DeleteObject(Creator.Template.Preview[i].handle)
					end
					Creator.Template.Preview = {}
				end
				Creator.GlobalVar.TemplateZposLock = nil
				if Client.NUI.Callback == "template x" or Client.NUI.Callback == "template y" or Client.NUI.Callback == "template z" or Client.NUI.Callback == "template rotX" or Client.NUI.Callback == "template rotY" or Client.NUI.Callback == "template rotZ" or Client.NUI.Callback == "template override" then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "input off"
					})
					Client.NUI.Callback = ""
				end
			end

			if RageUI.Visible(Creator.Menu.Placement.MoveAll) then
				Creator.ButtonToDraw = 5
				Creator.MoveAll.IsMenuVisible = true
				if not Creator.GlobalVar.IsBigmapActive then
					Creator.GlobalVar.IsBigmapActive = true
					CreateThread(function()
						SetRadarBigmapEnabled(true, false)
						Wait(0)
						SetRadarZoom(500)
					end)
				end
			else
				Creator.MoveAll.IsMenuVisible = false
				if Creator.GlobalVar.IsBigmapActive then
					Creator.GlobalVar.IsBigmapActive = false
					if not Creator.GlobalVar.RadarBigmapChecked then
						CreateThread(function()
							SetRadarBigmapEnabled(false, false)
							Wait(0)
							SetRadarZoom(1200)
						end)
					end
				end
			end

			if RageUI.Visible(Creator.Menu.Placement.Fixture) then
				Creator.Fixture.IsMenuVisible = true
				Creator.ButtonToDraw = 0
			else
				Creator.Fixture.IsMenuVisible = false
				if Creator.Fixture.Current.handle then
					Creator.Function.ResetGlobalVariable("fixture")
				end
				if Client.NUI.Callback == "goto fixture" then
					SetNuiFocus(false, false)
					SendNUIMessage({
						action = "input off"
					})
					Client.NUI.Callback = ""
				end
			end

			if RageUI.Visible(Creator.Menu.Placement.Firework) then
				if not Creator.Firework.IsMenuVisible then
					Creator.Firework.IsMenuVisible = true
					Creator.Firework.LastHour = Client.Time.CurrentHour
					Creator.Firework.LastMinute = Client.Time.CurrentMinute
					Creator.Firework.LastSecond = Client.Time.CurrentSecond
				end
				Creator.ButtonToDraw = 5
				if Creator.Camera.Handle ~= nil then
					SetCamCoord(Creator.Camera.Handle, 0.0, 60.0, 1050.0)
					SetCamRot(Creator.Camera.Handle, -15.0, 0.0, -180.0, 2)
					SetEntityCoordsNoOffset(ped, 0.0, 60.0, 1050.0)
					SetEntityHeading(ped, -180.0)
					LockMinimapAngle(180)
					LockMinimapPosition(0.0, 60.0)
					if Creator.GlobalVar.CreatorBlipHandle and DoesBlipExist(Creator.GlobalVar.CreatorBlipHandle) then
						SetBlipCoords(Creator.GlobalVar.CreatorBlipHandle, 0.0, 60.0, 1050.0)
					end
				end
				if not Creator.Firework.Preview then
					Creator.Firework.Preview = true
					CreateThread(function()
						RequestNamedPtfxAsset("scr_indep_fireworks")
						while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do Wait(0) end
						UseParticleFxAssetNextCall("scr_indep_fireworks")
						local effect = StartParticleFxLoopedAtCoord(Creator.Track.Current.Firework.Name, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
						local r, g, b = tonumber(Creator.Track.Current.Firework.R), tonumber(Creator.Track.Current.Firework.G), tonumber(Creator.Track.Current.Firework.B)
						if r and g and b then
							SetParticleFxLoopedColour(effect, (r / 255) + 0.0, (g / 255) + 0.0, (b / 255) + 0.0, true)
						end
						Wait(2000)
						StopParticleFxLooped(effect, true)
						Creator.Firework.Preview = false
					end)
				end
			else
				if Creator.Firework.IsMenuVisible then
					Creator.Firework.IsMenuVisible = false
					Client.Function.Environment.SetTime(Creator.Firework.LastHour, Creator.Firework.LastMinute, Creator.Firework.LastSecond)
				end
			end

			if RageUI.Visible(Creator.Menu.RaceDetail.Main) or RageUI.Visible(Creator.Menu.RaceDetail.Class.Main) or RageUI.Visible(Creator.Menu.Placement.Main) or RageUI.Visible(Creator.Menu.Multiplayer.Main) or RageUI.Visible(Creator.Menu.Multiplayer.Invite) or RageUI.Visible(Creator.Menu.Weather) or RageUI.Visible(Creator.Menu.Time) or RageUI.Visible(Creator.Menu.Misc) then
				Creator.ButtonToDraw = 0
			end

			--[[
			for classid = 0, 27 do
				if RageUI.Visible(Creator.Menu.RaceDetail.Class.Vehicles[classid]) then
					Creator.ButtonToDraw = 0
				end
			end
			]]

			if RageUI.CurrentMenu ~= nil and not Client.IsChatInputActive and not Client.Busyspinner.Status then
				DrawScaleformMovieFullscreen(Client.Function.Scaleform.Update("instructional_buttons", "creator"))
			end

			if Creator.StartingGrid.IsMenuVisible then
				Creator.Speed.Key = "GridOffset"
			elseif Creator.Checkpoint.IsMenuVisible then
				Creator.Speed.Key = "CheckpointOffset"
			elseif Creator.Object.IsMenuVisible then
				Creator.Speed.Key = "PropOffset"
			elseif Creator.Template.IsMenuVisible then
				Creator.Speed.Key = "TemplateOffset"
			elseif Creator.MoveAll.IsMenuVisible then
				Creator.Speed.Key = "MoveOffset"
			else
				Creator.Speed.Key = nil
			end

			if Creator.Camera.Handle ~= nil and not Creator.GlobalVar.EnableTest and not Creator.Firework.IsMenuVisible then
				if IsPauseMenuActive() and IsWaypointActive() then
					local waypoint = GetBlipInfoIdCoord(GetFirstBlipInfoId(GetWaypointBlipEnumId()))
					Creator.Camera.Position = vector3(waypoint.x + 0.0, waypoint.y + 0.0, Creator.Camera.Position.z + 0.0)
					DeleteWaypoint()
				end
				if (IsUsingKeyboard() and IsControlJustPressed(0, Creator.Speed.Key and 326 --[[LEFT CTRL]] or 254 --[[LEFT SHIFT]])) or (not IsUsingKeyboard() and IsDisabledControlJustPressed(0, 226 --[[LB]])) then
					if Creator.Speed.Key then
						local index = Creator.Speed[Creator.Speed.Key].Index - 1
						if index < 1 then
							index = #Creator.Speed[Creator.Speed.Key].Value
						end
						Creator.Speed[Creator.Speed.Key].Index = index
					else
						local index = Creator.Speed.CamPos.Index + 1
						if index > #Creator.Speed.CamPos.Value then
							index = 1
						end
						Creator.Speed.CamPos.Index = index
					end
				end
				if (IsUsingKeyboard() and IsControlJustPressed(0, Creator.Speed.Key and 254 --[[LEFT SHIFT]] or 326 --[[LEFT CTRL]])) or (not IsUsingKeyboard() and IsDisabledControlJustPressed(0, 227 --[[RB]])) then
					if Creator.Speed.Key then
						local index = Creator.Speed[Creator.Speed.Key].Index + 1
						if index > #Creator.Speed[Creator.Speed.Key].Value then
							index = 1
						end
						Creator.Speed[Creator.Speed.Key].Index = index
					else
						local index = Creator.Speed.CamRot.Index + 1
						if index > #Creator.Speed.CamRot.Value then
							index = 1
						end
						Creator.Speed.CamRot.Index = index
					end
				end
				local forward = RageUI.CurrentMenu ~= nil and Creator.Function.Camera.GetForwardVector() or vector3(0.0, 0.0, 0.0)
				local forward_2 = RageUI.CurrentMenu ~= nil and Creator.Function.Camera.GetForwardVector_2() or vector3(0.0, 0.0, 0.0)
				local right = RageUI.CurrentMenu ~= nil and Creator.Function.Camera.GetRightVector() or vector3(0.0, 0.0, 0.0)
				local framerateMoveFix = (60 * GetFrameTime()) * 1.0
				if IsUsingKeyboard() then
					if IsControlPressed(0, 32) then -- W
						Creator.Camera.Position = Creator.Camera.Position + forward * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix
					end
					if IsControlPressed(0, 33) then -- S
						Creator.Camera.Position = Creator.Camera.Position - forward * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix
					end
					if IsControlPressed(0, 34) then -- A
						Creator.Camera.Position = Creator.Camera.Position - right * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix
					end
					if IsControlPressed(0, 35) then -- D
						Creator.Camera.Position = Creator.Camera.Position + right * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix
					end
					if IsControlPressed(0, 252) then -- X
						Creator.Camera.Position = Creator.Camera.Position - forward_2 * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix
					end
					if IsControlPressed(0, 253) then -- C
						Creator.Camera.Position = Creator.Camera.Position + forward_2 * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix
					end
				else
					local w = GetDisabledControlNormal(0, 32)
					local s = GetDisabledControlNormal(0, 33)
					local a = GetDisabledControlNormal(0, 34)
					local d = GetDisabledControlNormal(0, 35)
					local lt = GetDisabledControlNormal(0, 252)
					local rt = GetDisabledControlNormal(0, 253)
					if w ~= 0.0 then
						Creator.Camera.Position = Creator.Camera.Position + forward * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix * w
					end
					if s ~= 0.0 then
						Creator.Camera.Position = Creator.Camera.Position - forward * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix * s
					end
					if a ~= 0.0 then
						Creator.Camera.Position = Creator.Camera.Position - right * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix * a
					end
					if d ~= 0.0 then
						Creator.Camera.Position = Creator.Camera.Position + right * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix * d
					end
					if lt ~= 0.0 then
						Creator.Camera.Position = Creator.Camera.Position - forward_2 * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix * lt
					end
					if rt ~= 0.0 then
						Creator.Camera.Position = Creator.Camera.Position + forward_2 * Creator.Speed.CamPos.Value[Creator.Speed.CamPos.Index][2] * framerateMoveFix * rt
					end
				end
				if Creator.Camera.Position.z + 0.0 > 3000.0 then
					Creator.Camera.Position = vector3(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, 3000.0)
				elseif Creator.Camera.Position.z + 0.0 < -200.0 then
					Creator.Camera.Position = vector3(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, -200.0)
				end
				local mouseX = RageUI.CurrentMenu ~= nil and GetDisabledControlNormal(0, 1) or 0.0 -- Mouse or Xbox Controller
				local mouseY = RageUI.CurrentMenu ~= nil and GetDisabledControlNormal(0, 2) or 0.0 -- Mouse or Xbox Controller
				Creator.Camera.Rotation.x = Creator.Camera.Rotation.x - mouseY * Creator.Speed.CamRot.Value[Creator.Speed.CamRot.Index][2] * (IsUsingKeyboard() and 2.0 or 1.0) * framerateMoveFix
				Creator.Camera.Rotation.z = Creator.Camera.Rotation.z - mouseX * Creator.Speed.CamRot.Value[Creator.Speed.CamRot.Index][2] * (IsUsingKeyboard() and 2.0 or 1.0) * framerateMoveFix
				if Creator.Camera.Rotation.x > 89.9 then
					Creator.Camera.Rotation.x = 89.9
				elseif Creator.Camera.Rotation.x < -89.9 then
					Creator.Camera.Rotation.x = -89.9
				end
				if (Creator.Camera.Rotation.z <= -9999.0) or (Creator.Camera.Rotation.z >= 9999.0) then
					Client.Function.Message.Display(Client.Function.Translate.Get("rot-limit"))
					Creator.Camera.Rotation.z = 0.0
				end
				if Creator.Object.IsMenuVisible and not Creator.Object.IsPickedUp then
					if (IsUsingKeyboard() and IsControlPressed(0, 251)) or (not IsUsingKeyboard() and IsDisabledControlPressed(0, 251)) then -- F or R3
						if not Creator.Object.Preview then
							Creator.GlobalVar.PropZposLock = Client.Function.Math.RoundedValue(Creator.Camera.Position.z + (((Creator.Camera.Rotation.x < 0) and -25.0) or ((Creator.Camera.Rotation.x >= 0) and 25.0)), 3)
							if (Creator.GlobalVar.PropZposLock <= -200.0) or (Creator.GlobalVar.PropZposLock >= 2700.0) then
								Creator.GlobalVar.PropZposLock = nil
							end
						elseif Creator.Object.Preview and not Creator.Object.PreviewCoordsChanged and Creator.Object.Current.z then
							local newPropZposLock = Client.Function.Math.RoundedValue((Creator.GlobalVar.PropZposLock or Creator.Object.Current.z) - Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2], 3)
							if newPropZposLock > -200.0 then
								Creator.GlobalVar.PropZposLock = newPropZposLock
								Creator.Camera.Position = vector3(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0 - Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2])
							end
						end
					end
					if (IsUsingKeyboard() and IsControlPressed(0, 250)) or (not IsUsingKeyboard() and IsDisabledControlPressed(0, 250)) then -- R or L3
						if not Creator.Object.Preview then
							Creator.GlobalVar.PropZposLock = Client.Function.Math.RoundedValue(Creator.Camera.Position.z + (((Creator.Camera.Rotation.x < 0) and -25.0) or ((Creator.Camera.Rotation.x >= 0) and 25.0)), 3)
							if (Creator.GlobalVar.PropZposLock <= -200.0) or (Creator.GlobalVar.PropZposLock >= 2700.0) then
								Creator.GlobalVar.PropZposLock = nil
							end
						elseif Creator.Object.Preview and not Creator.Object.PreviewCoordsChanged and Creator.Object.Current.z then
							local newPropZposLock = Client.Function.Math.RoundedValue((Creator.GlobalVar.PropZposLock or Creator.Object.Current.z) + Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2], 3)
							if newPropZposLock < 2700.0 then
								Creator.GlobalVar.PropZposLock = newPropZposLock
								Creator.Camera.Position = vector3(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0 + Creator.Speed.PropOffset.Value[Creator.Speed.PropOffset.Index][2])
							end
						end
					end
				end
				if Creator.Template.IsMenuVisible and not Creator.Template.IsPickedUp then
					if (IsUsingKeyboard() and IsControlPressed(0, 251)) or (not IsUsingKeyboard() and IsDisabledControlPressed(0, 251)) then -- F or R3
						if #Creator.Template.Preview == 0 then
							Creator.GlobalVar.TemplateZposLock = Client.Function.Math.RoundedValue(Creator.Camera.Position.z + (((Creator.Camera.Rotation.x < 0) and -25.0) or ((Creator.Camera.Rotation.x >= 0) and 25.0)), 3)
							if (Creator.GlobalVar.TemplateZposLock <= -200.0) or (Creator.GlobalVar.TemplateZposLock >= 2700.0) then
								Creator.GlobalVar.TemplateZposLock = nil
							end
						elseif Creator.Template.Preview[1] and not Creator.Template.PreviewCoordsChanged and Creator.Template.Preview[1].z then
							local newTemplateZposLock = Client.Function.Math.RoundedValue((Creator.GlobalVar.TemplateZposLock or Creator.Template.Preview[1].z) - Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2], 3)
							if newTemplateZposLock > -200.0 then
								Creator.GlobalVar.TemplateZposLock = newTemplateZposLock
								Creator.Camera.Position = vector3(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0 - Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2])
							end
						end
					end
					if (IsUsingKeyboard() and IsControlPressed(0, 250)) or (not IsUsingKeyboard() and IsDisabledControlPressed(0, 250)) then -- R or L3
						if #Creator.Template.Preview == 0 then
							Creator.GlobalVar.TemplateZposLock = Client.Function.Math.RoundedValue(Creator.Camera.Position.z + (((Creator.Camera.Rotation.x < 0) and -25.0) or ((Creator.Camera.Rotation.x >= 0) and 25.0)), 3)
							if (Creator.GlobalVar.TemplateZposLock <= -200.0) or (Creator.GlobalVar.TemplateZposLock >= 2700.0) then
								Creator.GlobalVar.TemplateZposLock = nil
							end
						elseif Creator.Template.Preview[1] and not Creator.Template.PreviewCoordsChanged and Creator.Template.Preview[1].z then
							local newTemplateZposLock = Client.Function.Math.RoundedValue((Creator.GlobalVar.TemplateZposLock or Creator.Template.Preview[1].z) + Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2], 3)
							if newTemplateZposLock < 2700.0 then
								Creator.GlobalVar.TemplateZposLock = newTemplateZposLock
								Creator.Camera.Position = vector3(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0 + Creator.Speed.TemplateOffset.Value[Creator.Speed.TemplateOffset.Index][2])
							end
						end
					end
				end
				if Creator.Object.IsMenuVisible or Creator.Template.IsMenuVisible then
					local gx = math.floor((Creator.Camera.Position.x) / 100.0)
					local gy = math.floor((Creator.Camera.Position.y) / 100.0)
					if Creator.ObjectPool.Grids[gx] and Creator.ObjectPool.Grids[gx][gy] and Client.Function.Math.TableCount(Creator.ObjectPool.Grids[gx][gy]) >= 300 then
						local r, g, b = GetHudColour(208)
						local minX, minY, minZ, maxX, maxY, maxZ = gx * 100, gy * 100, -200.0, gx * 100 + 100.0, gy * 100 + 100.0, 2700.0
						local corners = {vector3(maxX, maxY, maxZ), vector3(minX, maxY, maxZ), vector3(maxX, minY, maxZ), vector3(minX, minY, maxZ), vector3(maxX, maxY, minZ), vector3(minX, maxY, minZ), vector3(maxX, minY, minZ), vector3(minX, minY, minZ)}
						local lines = {{1, 2}, {2, 4}, {4, 3}, {3, 1}, {1, 5}, {2, 6}, {3, 7}, {4, 8}}
						for _, line in ipairs(lines) do
							local p1, p2 = corners[line[1]], corners[line[2]]
							DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, 255, 255, 255, 255)
						end
						local faces = {{1, 2, 4}, {4, 3, 1}, {2, 1, 5}, {5, 6, 2}, {3, 4, 8}, {8, 7, 3}, {7, 8, 6}, {6, 5, 7}, {4, 2, 6}, {6, 8, 4}, {1, 3, 7}, {7, 5, 1}}
						for _, face in ipairs(faces) do
							local p1, p2, p3 = corners[face[1]], corners[face[2]], corners[face[3]]
							DrawPoly(p3.x, p3.y, p3.z, p2.x, p2.y, p2.z, p1.x, p1.y, p1.z, r, g, b, 50)
						end
					end
				end
				SetCamCoord(Creator.Camera.Handle, Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0)
				SetCamRot(Creator.Camera.Handle, Creator.Camera.Rotation.x + 0.0, Creator.Camera.Rotation.y + 0.0, Creator.Camera.Rotation.z + 0.0, 2)
				SetEntityCoordsNoOffset(ped, Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, ((Creator.Camera.Position.z + 0.0) <= -200.0 and -199.999) or ((Creator.Camera.Position.z + 0.0) >= 2700.0 and 2699.999) or (Creator.Camera.Position.z + 0.0))
				SetEntityHeading(ped, Creator.Camera.Rotation.z + 0.0)
				local angle = Creator.Camera.Rotation.z + 0.0
				angle = ((angle % 360) + 360) % 360
				angle = math.floor(angle + 0.5)
				if angle == 360 then
					angle = 0
				end
				LockMinimapAngle(angle)
				LockMinimapPosition(Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0)
				if not IsEntityPositionFrozen(ped) then
					FreezeEntityPosition(ped, true)
				end
				if IsEntityVisible(ped) then
					SetEntityVisible(ped, false)
				end
				if not GetEntityCollisionDisabled(ped) then
					SetEntityCollision(ped, false, false)
					SetEntityCompletelyDisableCollision(ped, false, false)
				end
				if Creator.GlobalVar.CreatorBlipHandle and DoesBlipExist(Creator.GlobalVar.CreatorBlipHandle) then
					SetBlipCoords(Creator.GlobalVar.CreatorBlipHandle, Creator.Camera.Position.x + 0.0, Creator.Camera.Position.y + 0.0, Creator.Camera.Position.z + 0.0)
				end
			end

			local entity, endCoords, surfaceNormal = Creator.Function.Camera.GetEntityAndEndCoords(-1, Creator.StartingGrid.Preview or Creator.StartingGrid.Select or Creator.Object.Preview)

			if Creator.Fixture.IsMenuVisible then
				local spawn = {}
				for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
					if object.handle then
						spawn[object.handle] = true
					end
				end
				if entity and not spawn[entity] and IsEntityAnObject(entity) then
					if not Creator.Fixture.Current.handle or (Creator.Fixture.Current.handle ~= entity) then
						local hash = GetEntityModel(entity)
						if hash ~= fakeHash then
							local coords = GetEntityCoords(entity)
							Creator.Fixture.Current = {
								hash = hash,
								handle = entity,
								x = Client.Function.Math.RoundedValue(coords.x, 3),
								y = Client.Function.Math.RoundedValue(coords.y, 3),
								z = Client.Function.Math.RoundedValue(coords.z, 3)
							}
						else
							if Creator.Fixture.Current.handle then
								Creator.Function.ResetGlobalVariable("fixture")
							end
						end
					end
				else
					if Creator.Fixture.Current.handle then
						Creator.Function.ResetGlobalVariable("fixture")
					end
				end
				if Creator.Fixture.Current.handle then
					local r, g, b = GetHudColour(210)
					Creator.Function.DrawEntityBoxes(Creator.Fixture.Current.handle, Creator.Fixture.Current.hash, r, g, b, true)
				end
			end

			if IsControlJustReleased(0, 203) and not IsNuiFocused() and not Creator.Multiplayer.LockSession then
				if Creator.StartingGrid.IsMenuVisible then
					local found = false
					for k, v in pairs(Creator.Track.Current.StartingGrid) do
						if entity == v.handle then
							if Creator.StartingGrid.Preview then
								DeleteVehicle(Creator.StartingGrid.Preview)
								Creator.StartingGrid.Preview = nil
							end
							if Creator.StartingGrid.Select then
								Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
								if Creator.Multiplayer.InSession then
									Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
									TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
								end
								ResetEntityAlpha(Creator.StartingGrid.Select)
								SetEntityDrawOutlineColor(255, 255, 255, 125)
								SetEntityDrawOutlineShader(1)
								SetEntityDrawOutline(Creator.StartingGrid.Select, true)
							end
							SetEntityDrawOutline(entity, false)
							SetEntityAlpha(entity, 150)
							Creator.StartingGrid.Select = entity
							Creator.GlobalVar.IsSelectingStartingGridVehicle = true
							Creator.StartingGrid.IsPickedUp = true
							Creator.StartingGrid.Index = k
							Creator.StartingGrid.Current = Client.Function.Shared.TableDeepCopy(v)
							Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.StartingGrid.Current.heading, 3)
							found = true
							break
						end
					end
					if not found then
						if Creator.StartingGrid.Select then
							Creator.Track.Current.StartingGrid[Creator.StartingGrid.Index] = Client.Function.Shared.TableDeepCopy(Creator.StartingGrid.Current)
							if Creator.Multiplayer.InSession then
								Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
							end
							ResetEntityAlpha(Creator.StartingGrid.Select)
							SetEntityDrawOutlineColor(255, 255, 255, 125)
							SetEntityDrawOutlineShader(1)
							SetEntityDrawOutline(Creator.StartingGrid.Select, true)
							Creator.StartingGrid.IsPickedUp = false
							Creator.StartingGrid.Select = nil
							Creator.Function.ResetGlobalVariable("startingGrid")
						end
					end
				elseif Creator.Checkpoint.IsMenuVisible then
					if not Creator.Checkpoint.Preview and Creator.Checkpoint.IsPickedUp then
						Creator.Checkpoint.IsPickedUp = false
						Creator.Function.ResetGlobalVariable("checkpoint")
					end
				elseif Creator.Object.IsMenuVisible then
					if Creator.Snapping.Enable then
						if Creator.Object.IsPickedUp then
							Creator.Object.IsPickedUp = false
							Creator.Function.ResetGlobalVariable("object")
						end
					else
						if Creator.Snapping.Handle then
							Creator.Snapping.Handle = nil
							Creator.Snapping.ObjectData = nil
						end
					end
					Creator.Snapping.NextObjectUniqueId = nil
					local found = false
					local spawn = {}
					for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
						if object.handle then
							spawn[object.handle] = uniqueId
						end
					end
					local uniqueId = spawn[entity]
					if uniqueId then
						local object = Creator.ObjectPool.ActiveObjects[uniqueId]
						if object then
							local handle = object.handle
							if handle then
								if Creator.Snapping.Enable then
									if Creator.Snapping.Handle == entity then
										Creator.Snapping.Handle = nil
										Creator.Snapping.ObjectData = nil
									else
										Creator.Snapping.Handle = entity
										Creator.Snapping.ObjectData = object
										Creator.Function.Object.SetNewPositionAndRotationEnhanced()
									end
								else
									if Creator.Object.Current.handle == entity then
										Creator.Object.IsPickedUp = false
										Creator.Function.ResetGlobalVariable("object")
									else
										for k, v in pairs(Creator.Track.Current.Objects) do
											if v.uniqueId == uniqueId then
												Creator.Object.Index = k
												break
											end
										end
										Creator.Object.IsPickedUp = true
										if Creator.Object.Preview then
											if Creator.Object.PreviewEffect then
												StopParticleFxLooped(Creator.Object.PreviewEffect, true)
												Creator.Object.PreviewEffect = nil
											end
											DeleteObject(Creator.Object.Preview)
											Creator.Object.Preview = nil
										end
										Creator.Object.Current = object
										Creator.GlobalVar.PropZposLock = Creator.Object.Current.z
										Creator.GlobalRot.X = Client.Function.Math.RoundedValue(Creator.Object.Current.rotX, 3)
										Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(Creator.Object.Current.rotY, 3)
										Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(Creator.Object.Current.rotZ, 3)
										Creator.GlobalVar.PropColor = Creator.Object.Current.color
										Creator.LastValidHash = Creator.Object.Current.hash
										local found_2 = false
										for index, objects in pairs(Creator.Data.Category.List) do
											for i = 1, #objects.model do
												local hash = tonumber(objects.model[i]) or GetHashKey(objects.model[i])
												if Creator.LastValidHash == hash then
													found_2 = true
													Creator.LastValidText = objects.model[i]
													objects.index = i
													Creator.Data.Category.Index = index
													break
												end
											end
											if found_2 then break end
										end
										if not found_2 then
											local hash_2 = tonumber(Creator.LastValidText) or GetHashKey(Creator.LastValidText)
											if Creator.LastValidHash ~= hash_2 then
												Creator.LastValidText = tostring(Creator.LastValidHash) or ""
											end
										end
									end
								end
								found = true
							end
						end
					end
					if Creator.Snapping.Enable then
						if not found then
							if Creator.Snapping.Handle then
								Creator.Snapping.Handle = nil
								Creator.Snapping.ObjectData = nil
							end
						end
					else
						if not found then
							if Creator.Object.IsPickedUp then
								Creator.Object.IsPickedUp = false
								Creator.Function.ResetGlobalVariable("object")
							elseif entity and (entity ~= Creator.Object.Preview) and (IsEntityAnObject(entity) or IsEntityAVehicle(entity)) then
								local rotation = GetEntityRotation(entity, 2)
								Creator.GlobalRot.X = Client.Function.Math.RoundedValue(rotation.x, 3)
								Creator.GlobalRot.Y = Client.Function.Math.RoundedValue(rotation.y, 3)
								Creator.GlobalRot.Z = Client.Function.Math.RoundedValue(rotation.z, 3)
								Creator.GlobalVar.PropColor = GetObjectTextureVariation(entity)
								if Creator.Object.Preview then
									if Creator.Object.PreviewEffect then
										StopParticleFxLooped(Creator.Object.PreviewEffect, true)
										Creator.Object.PreviewEffect = nil
									end
									DeleteObject(Creator.Object.Preview)
									Creator.Object.Preview = nil
									Creator.Function.ResetGlobalVariable("object")
								end
								Creator.LastValidHash = GetEntityModel(entity)
								Creator.LastValidText = tostring(Creator.LastValidHash) or ""
								Client.Function.Message.Display(string.format(Client.Function.Translate.Get("add-hash"), Creator.LastValidText))
							end
						end
					end
				elseif Creator.Template.IsMenuVisible and entity then
					for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
						if object.handle and entity == object.handle then
							local found = false
							for i = 1, #Creator.Template.Current do
								if Creator.Template.Current[i].uniqueId == uniqueId then
									found = true
									SetEntityDrawOutline(entity, false)
									table.remove(Creator.Template.Current, i)
									break
								end
							end
							if not found then
								SetEntityDrawOutlineColor(255, 255, 255, 125)
								SetEntityDrawOutlineShader(1)
								SetEntityDrawOutline(entity, true)
								table.insert(Creator.Template.Current, Client.Function.Shared.TableDeepCopy(object))
							end
							if #Creator.Template.Current > 0 then
								if #Creator.Template.Preview > 0 then
									for i = 1, #Creator.Template.Preview do
										DeleteObject(Creator.Template.Preview[i].handle)
									end
									Creator.Template.Preview = {}
								end
								Creator.Template.IsPickedUp = true
							else
								Creator.Template.IsPickedUp = false
							end
							break
						end
					end
				end
			end

			local propZposLock = Creator.GlobalVar.PropZposLock
			local templateZposLock = Creator.GlobalVar.TemplateZposLock
			if endCoords or (propZposLock and Creator.Object.IsMenuVisible) or (templateZposLock and Creator.Template.IsMenuVisible) then
				local found, groundZ = false, -200.0
				if endCoords then
					found, groundZ = GetGroundZFor_3dCoord(endCoords.x, endCoords.y, endCoords.z, true)
					groundZ = found and (groundZ + 0.0) or -200.0
				end
				if Creator.StartingGrid.IsMenuVisible then
					if not Creator.StartingGrid.Preview and not Creator.StartingGrid.IsPickedUp then
						local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
						local model = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
						local min, max = Client.Function.Shared.GetModelDimensionsInCaches(model)
						local coordZ = Client.Function.Math.RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (coordZ > -200.0) and (coordZ < 2700.0) and ((#Creator.Track.Current.StartingGrid == 0) or (Creator.Track.Current.StartingGrid[1] and (#(vector3(Client.Function.Math.RoundedValue(endCoords.x, 3), Client.Function.Math.RoundedValue(endCoords.y, 3), coordZ) - vector3(Creator.Track.Current.StartingGrid[1].x, Creator.Track.Current.StartingGrid[1].y, Creator.Track.Current.StartingGrid[1].z)) < 200.0))) then
							Creator.StartingGrid.Preview = Creator.Function.CreateVehicle(model, Client.Function.Math.RoundedValue(endCoords.x, 3), Client.Function.Math.RoundedValue(endCoords.y, 3), coordZ, Creator.GlobalRot.Z)
							if Creator.StartingGrid.Preview then
								Creator.StartingGrid.Current = {
									handle = Creator.StartingGrid.Preview,
									x = Client.Function.Math.RoundedValue(endCoords.x, 3),
									y = Client.Function.Math.RoundedValue(endCoords.y, 3),
									z = coordZ,
									heading = Creator.GlobalRot.Z
								}
								SetEntityCoordsNoOffset(Creator.StartingGrid.Preview, Creator.StartingGrid.Current.x, Creator.StartingGrid.Current.y, Creator.StartingGrid.Current.z)
							end
						end
					elseif Creator.StartingGrid.Preview and not Creator.StartingGrid.IsPickedUp then
						local min, max = Client.Function.Shared.GetModelDimensionsInCaches(GetEntityModel(Creator.StartingGrid.Preview))
						local coordZ = Client.Function.Math.RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (coordZ > -200.0) and (coordZ < 2700.0) and ((#Creator.Track.Current.StartingGrid == 0) or (Creator.Track.Current.StartingGrid[1] and (#(vector3(Client.Function.Math.RoundedValue(endCoords.x, 3), Client.Function.Math.RoundedValue(endCoords.y, 3), coordZ) - vector3(Creator.Track.Current.StartingGrid[1].x, Creator.Track.Current.StartingGrid[1].y, Creator.Track.Current.StartingGrid[1].z)) < 200.0))) then
							Creator.StartingGrid.Current.x = Client.Function.Math.RoundedValue(endCoords.x, 3)
							Creator.StartingGrid.Current.y = Client.Function.Math.RoundedValue(endCoords.y, 3)
							Creator.StartingGrid.Current.z = coordZ
							SetEntityCoordsNoOffset(Creator.StartingGrid.Preview, Creator.StartingGrid.Current.x, Creator.StartingGrid.Current.y, Creator.StartingGrid.Current.z)
						else
							if Creator.StartingGrid.Preview then
								DeleteVehicle(Creator.StartingGrid.Preview)
								Creator.StartingGrid.Preview = nil
								Creator.Function.ResetGlobalVariable("startingGrid")
								if Client.NUI.Callback ~= "" then
									SetNuiFocus(false, false)
									SendNUIMessage({
										action = "input off"
									})
									Client.NUI.Callback = ""
								end
							end
							if (coordZ <= -200.0) or (coordZ >= 2700.0) then
								Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
							else
								Client.Function.Message.Display(Client.Function.Translate.Get("startingGrid-error1"))
							end
						end
					elseif Creator.StartingGrid.IsPickedUp and Creator.GlobalVar.IsSelectingStartingGridVehicle then
						Creator.GlobalVar.IsSelectingStartingGridVehicle = false
					elseif Creator.StartingGrid.IsPickedUp and not Creator.GlobalVar.IsSelectingStartingGridVehicle then
						local min, max = Client.Function.Shared.GetModelDimensionsInCaches(GetEntityModel(Creator.StartingGrid.Select))
						local coordZ = Client.Function.Math.RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						if (coordZ > -200.0) and (coordZ < 2700.0) and ((#Creator.Track.Current.StartingGrid == 0) or (Creator.Track.Current.StartingGrid[1] and (#(vector3(Client.Function.Math.RoundedValue(endCoords.x, 3), Client.Function.Math.RoundedValue(endCoords.y, 3), coordZ) - vector3(Creator.Track.Current.StartingGrid[1].x, Creator.Track.Current.StartingGrid[1].y, Creator.Track.Current.StartingGrid[1].z)) < 200.0))) then
							Creator.StartingGrid.Current.x = Client.Function.Math.RoundedValue(endCoords.x, 3)
							Creator.StartingGrid.Current.y = Client.Function.Math.RoundedValue(endCoords.y, 3)
							Creator.StartingGrid.Current.z = coordZ
							SetEntityCoordsNoOffset(Creator.StartingGrid.Select, Creator.StartingGrid.Current.x, Creator.StartingGrid.Current.y, Creator.StartingGrid.Current.z)
						else
							local deleteIndex = 0
							for k, v in pairs(Creator.Track.Current.StartingGrid) do
								if Creator.StartingGrid.Select == v.handle then
									deleteIndex = k
									table.remove(Creator.Track.Current.StartingGrid, k)
									break
								end
							end
							if Creator.StartingGrid.Index > #Creator.Track.Current.StartingGrid then
								Creator.StartingGrid.Index = #Creator.Track.Current.StartingGrid
							end
							if Creator.Multiplayer.InSession then
								Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
								TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, deleteIndex = deleteIndex, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
							end
							DeleteVehicle(Creator.StartingGrid.Select)
							Creator.StartingGrid.IsPickedUp = false
							Creator.StartingGrid.Select = nil
							Creator.Function.ResetGlobalVariable("startingGrid")
							if Client.NUI.Callback ~= "" then
								SetNuiFocus(false, false)
								SendNUIMessage({
									action = "input off"
								})
								Client.NUI.Callback = ""
							end
							if (coordZ <= -200.0) or (coordZ >= 2700.0) then
								Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
							else
								Client.Function.Message.Display(Client.Function.Translate.Get("startingGrid-error1"))
							end
						end
					end
				elseif Creator.Checkpoint.IsMenuVisible then
					if not Creator.Checkpoint.Preview and not Creator.Checkpoint.IsPickedUp then
						Creator.Checkpoint.PreviewCoordsChanged = false
						Creator.Checkpoint.Current = {
							x = Client.Function.Math.RoundedValue(endCoords.x, 3),
							y = Client.Function.Math.RoundedValue(endCoords.y, 3),
							z = Client.Function.Math.RoundedValue(groundZ > endCoords.z and groundZ or endCoords.z, 3),
							heading = Creator.GlobalRot.Z,
							diameterCollect = 1.0,
							diameterDraw = 1.0,
							pitch = 0.0,
							offset = {x = 0.0, y = 0.0, z = 0.0},
							lockDirection = nil,
							isPit = nil,
							isTall = nil,
							tallRadius = 500.0,
							lowerAlpha = nil,
							isRound = nil,
							isAir = nil,
							isFake = nil,
							isRandom = nil,
							randomClass = nil,
							randomCustom = nil,
							randomSetting = nil,
							isTransform = nil,
							transformIndex = nil,
							isPlaneRot = nil,
							planeRot = nil,
							isWarp = nil
						}
						Creator.Checkpoint.Preview = true
					elseif Creator.Checkpoint.Preview and not Creator.Checkpoint.IsPickedUp then
						if not Creator.Checkpoint.PreviewCoordsChanged then
							Creator.Checkpoint.Current.x = Client.Function.Math.RoundedValue(endCoords.x, 3)
							Creator.Checkpoint.Current.y = Client.Function.Math.RoundedValue(endCoords.y, 3)
							Creator.Checkpoint.Current.z = Client.Function.Math.RoundedValue(groundZ > endCoords.z and groundZ or endCoords.z, 3)
						end
					end
				elseif Creator.Object.IsMenuVisible then
					if not Creator.Object.Preview and not Creator.Object.IsPickedUp then
						local model = Creator.Data.Category.List[Creator.Data.Category.Index].model[Creator.Data.Category.List[Creator.Data.Category.Index].index]
						local hash = Creator.LastValidHash or tonumber(model) or GetHashKey(model)
						local min, max = Client.Function.Shared.GetModelDimensionsInCaches(hash)
						local coordX = not propZposLock and Client.Function.Math.RoundedValue(endCoords.x, 3) or nil
						local coordY = not propZposLock and Client.Function.Math.RoundedValue(endCoords.y, 3) or nil
						local coordZ = propZposLock or Client.Function.Math.RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xyValid = true
						if propZposLock then
							coordX, coordY = Creator.Function.Camera.GetEndXY(coordZ)
						end
						if not coordX or not coordY then
							xyValid = false
						end
						if (coordZ > -200.0) and (coordZ < 2700.0) and xyValid and not IsNuiFocused() then
							Creator.Object.Preview = Creator.Function.CreateObject(hash, coordX, coordY, coordZ, Creator.GlobalRot.X, Creator.GlobalRot.Y, Creator.GlobalRot.Z, Creator.GlobalVar.PropColor)
							if Creator.Object.Preview then
								Creator.Object.PreviewCoordsChanged = false
								Creator.Multiplayer.GlobalUniqueId = Creator.Multiplayer.GlobalUniqueId + 1
								Creator.Object.Current = {
									uniqueId = Client.ServerId .. "-" .. Creator.Multiplayer.GlobalUniqueId,
									modificationCount = 0,
									hash = hash,
									handle = Creator.Object.Preview,
									x = coordX,
									y = coordY,
									z = coordZ,
									rotX = Creator.GlobalRot.X,
									rotY = Creator.GlobalRot.Y,
									rotZ = Creator.GlobalRot.Z,
									color = GetObjectTextureVariation(Creator.Object.Preview),
									prpsba = 2,
									visible = true,
									collision = not Client.Shared.Object.NoCollision[hash] and true or false,
									dynamic = false
								}
								if Client.Preference.ObjectLowerAlphaChecked then
									SetEntityAlpha(Creator.Object.Preview, 150)
								end
								SetEntityLodDist(Creator.Object.Preview, 16960)
								SetEntityCollision(Creator.Object.Preview, false, false)
								FreezeEntityPosition(Creator.Object.Preview, true)
								if Client.Shared.Object.Effect[hash] then
									CreateThread(function()
										local style_1 = Creator.Object.Preview and Client.Shared.Object.Effect[GetEntityModel(Creator.Object.Preview)]
										if style_1 then
											local fxName = (style_1 == 1) and "core" or "scr_stunts"
											RequestNamedPtfxAsset(fxName)
											while not HasNamedPtfxAssetLoaded(fxName) do Wait(0) end
											local style_2 = Creator.Object.Preview and Client.Shared.Object.Effect[GetEntityModel(Creator.Object.Preview)]
											if style_2 and style_1 == style_2 then
												UseParticleFxAssetNextCall(fxName)
												if style_2 == 1 then
													Creator.Object.PreviewEffect = StartParticleFxLoopedOnEntity("ent_amb_fire_ring", Creator.Object.Preview, 0.0, 0.0, 4.5, 0.0, 0.0, 90.0, 3.5, false, false, false)
												elseif style_2 == 2 then
													Creator.Object.PreviewEffect = StartParticleFxLoopedOnEntity("scr_stunts_fire_ring", Creator.Object.Preview, 0.0, 0.0, 11.5, -2.0, 0.0, 0.0, 0.47, false, false, false)
												elseif style_2 == 3 then
													Creator.Object.PreviewEffect = StartParticleFxLoopedOnEntity("scr_stunts_fire_ring", Creator.Object.Preview, 0.0, 0.0, 25.0, -12.5, 0.0, 0.0, 1.0, false, false, false)
												end
											end
										end
									end)
								end
							end
						end
					elseif Creator.Object.Preview and not Creator.Object.IsPickedUp and not Creator.Object.PreviewCoordsChanged then
						local min, max = Client.Function.Shared.GetModelDimensionsInCaches(GetEntityModel(Creator.Object.Preview))
						local coordX = not propZposLock and Client.Function.Math.RoundedValue(endCoords.x, 3) or nil
						local coordY = not propZposLock and Client.Function.Math.RoundedValue(endCoords.y, 3) or nil
						local coordZ = propZposLock or Client.Function.Math.RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xyValid = true
						if propZposLock then
							coordX, coordY = Creator.Function.Camera.GetEndXY(coordZ)
						end
						if not coordX or not coordY then
							xyValid = false
						end
						if (coordZ > -200.0) and (coordZ < 2700.0) and xyValid then
							Creator.Object.Current.x = coordX
							Creator.Object.Current.y = coordY
							Creator.Object.Current.z = coordZ
							SetEntityCoordsNoOffset(Creator.Object.Preview, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z)
						else
							if Creator.Object.Preview then
								if Creator.Object.PreviewEffect then
									StopParticleFxLooped(Creator.Object.PreviewEffect, true)
									Creator.Object.PreviewEffect = nil
								end
								DeleteObject(Creator.Object.Preview)
								Creator.Object.Preview = nil
								Creator.Function.ResetGlobalVariable("object")
								if Client.NUI.Callback ~= "" then
									SetNuiFocus(false, false)
									SendNUIMessage({
										action = "input off"
									})
									Client.NUI.Callback = ""
								end
								if not xyValid then
									Client.Function.Message.Display(Client.Function.Translate.Get("object-error"))
								else
									Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
								end
							end
						end
					end
				elseif Creator.Template.IsMenuVisible then
					if #Creator.Template.Preview == 0 and Creator.Data.Template.List[Creator.Data.Template.Index] and #Creator.Data.Template.List[Creator.Data.Template.Index] >= 2 and not Creator.Template.IsPickedUp then
						local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Data.Template.List[Creator.Data.Template.Index][1].hash)
						local coordX = not templateZposLock and Client.Function.Math.RoundedValue(endCoords.x, 3) or nil
						local coordY = not templateZposLock and Client.Function.Math.RoundedValue(endCoords.y, 3) or nil
						local coordZ = templateZposLock or Client.Function.Math.RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xyValid = true
						if templateZposLock then
							coordX, coordY = Creator.Function.Camera.GetEndXY(coordZ)
						end
						if not coordX or not coordY then
							xyValid = false
						end
						if (coordZ > -200.0) and (coordZ < 2700.0) and xyValid then
							for i = 1, #Creator.Data.Template.List[Creator.Data.Template.Index] do
								local obj = Creator.Function.CreateObject(Creator.Data.Template.List[Creator.Data.Template.Index][i].hash, Creator.Data.Template.List[Creator.Data.Template.Index][i].x, Creator.Data.Template.List[Creator.Data.Template.Index][i].y, Creator.Data.Template.List[Creator.Data.Template.Index][i].z, Creator.Data.Template.List[Creator.Data.Template.Index][i].rotX, Creator.Data.Template.List[Creator.Data.Template.Index][i].rotY, Creator.Data.Template.List[Creator.Data.Template.Index][i].rotZ, Creator.Data.Template.List[Creator.Data.Template.Index][i].color or 0)
								if obj then
									Creator.Multiplayer.GlobalUniqueId = Creator.Multiplayer.GlobalUniqueId + 1
									Creator.Template.Preview[#Creator.Template.Preview + 1] = {
										uniqueId = Client.ServerId .. "-" .. Creator.Multiplayer.GlobalUniqueId,
										modificationCount = 0,
										handle = obj,
										hash = Creator.Data.Template.List[Creator.Data.Template.Index][i].hash,
										x = Creator.Data.Template.List[Creator.Data.Template.Index][i].x,
										y = Creator.Data.Template.List[Creator.Data.Template.Index][i].y,
										z = Creator.Data.Template.List[Creator.Data.Template.Index][i].z,
										rotX = Creator.Data.Template.List[Creator.Data.Template.Index][i].rotX,
										rotY = Creator.Data.Template.List[Creator.Data.Template.Index][i].rotY,
										rotZ = Creator.Data.Template.List[Creator.Data.Template.Index][i].rotZ,
										color = Creator.Data.Template.List[Creator.Data.Template.Index][i].color or 0,
										prpsba = Creator.Data.Template.List[Creator.Data.Template.Index][i].prpsba or 2,
										visible = Creator.Data.Template.List[Creator.Data.Template.Index][i].visible,
										collision = Creator.Data.Template.List[Creator.Data.Template.Index][i].collision,
										dynamic = Creator.Data.Template.List[Creator.Data.Template.Index][i].dynamic
									}
								end
							end
							if #Creator.Template.Preview >= 2 then
								Creator.Template.PreviewCoordsChanged = false
								for i = 1, #Creator.Template.Preview do
									SetEntityLodDist(Creator.Template.Preview[i].handle, 16960)
									SetEntityCollision(Creator.Template.Preview[i].handle, false, false)
									FreezeEntityPosition(Creator.Template.Preview[i].handle, true)
									if i >= 2 then
										if Client.Preference.ObjectLowerAlphaChecked or not Creator.Template.Preview[i].visible then
											SetEntityAlpha(Creator.Template.Preview[i].handle, 150)
										end
									end
								end
								local aPosNew, aRotNew = vector3(coordX, coordY, coordZ), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
								local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
								Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
							else
								if #Creator.Template.Preview > 0 then
									for i = 1, #Creator.Template.Preview do
										DeleteObject(Creator.Template.Preview[i].handle)
									end
									Creator.Template.Preview = {}
								end
								Creator.Data.Template.List[Creator.Data.Template.Index] = {}
							end
						end
					elseif #Creator.Template.Preview > 0 and not Creator.Template.IsPickedUp and not Creator.Template.PreviewCoordsChanged then
						local min, max = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Template.Preview[1].hash)
						local coordX = not templateZposLock and Client.Function.Math.RoundedValue(endCoords.x, 3) or nil
						local coordY = not templateZposLock and Client.Function.Math.RoundedValue(endCoords.y, 3) or nil
						local coordZ = templateZposLock or Client.Function.Math.RoundedValue((groundZ > endCoords.z and groundZ or endCoords.z) - min.z, 3)
						local xyValid = true
						if templateZposLock then
							coordX, coordY = Creator.Function.Camera.GetEndXY(coordZ)
						end
						if not coordX or not coordY then
							xyValid = false
						end
						if (coordZ > -200.0) and (coordZ < 2700.0) and xyValid then
							local aPosNew, aRotNew = vector3(coordX, coordY, coordZ), vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ)
							local aQuatNew = Client.Function.Math.RotationToQuaternion(aRotNew)
							Creator.Function.Object.SetTemplateNewPositionAndRotation(aPosNew, aQuatNew)
						else
							if #Creator.Template.Preview > 0 then
								for i = 1, #Creator.Template.Preview do
									DeleteObject(Creator.Template.Preview[i].handle)
								end
								Creator.Template.Preview = {}
								if Client.NUI.Callback ~= "" then
									SetNuiFocus(false, false)
									SendNUIMessage({
										action = "input off"
									})
									Client.NUI.Callback = ""
								end
								if not xyValid then
									Client.Function.Message.Display(Client.Function.Translate.Get("object-error"))
								else
									Client.Function.Message.Display(Client.Function.Translate.Get("z-limit"))
								end
							end
						end
					end
				end
				local markerX = nil
				local markerY = nil
				local markerZ = nil
				if (not Creator.Object.PreviewCoordsChanged and not Creator.Object.IsPickedUp) and propZposLock then
					markerZ = propZposLock
					markerX, markerY = Creator.Function.Camera.GetEndXY(markerZ)
				elseif (not Creator.Template.PreviewCoordsChanged and not Creator.Template.IsPickedUp) and templateZposLock then
					markerZ = templateZposLock
					markerX, markerY = Creator.Function.Camera.GetEndXY(markerZ)
				end
				if not markerX or not markerY or not markerZ then
					markerX = endCoords and endCoords.x
					markerY = endCoords and endCoords.y
					markerZ = endCoords and (groundZ > endCoords.z and groundZ or endCoords.z)
				end
				if markerX and markerY and markerZ and not Creator.GlobalVar.EnableTest then
					DrawMarker(
						25,
						markerX,
						markerY,
						markerZ,
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						0.0,
						2.0,
						2.0,
						2.0,
						255,
						255,
						255,
						255,
						false,
						false,
						2,
						nil,
						nil,
						false
					)
				end
			else
				if Creator.StartingGrid.Preview then
					DeleteVehicle(Creator.StartingGrid.Preview)
					Creator.StartingGrid.Preview = nil
					Creator.Function.ResetGlobalVariable("startingGrid")
					if Client.NUI.Callback ~= "" then
						SetNuiFocus(false, false)
						SendNUIMessage({
							action = "input off"
						})
						Client.NUI.Callback = ""
					end
					Client.Function.Message.Display(Client.Function.Translate.Get("startingGrid-error2"))
				end
				if Creator.StartingGrid.Select then
					local deleteIndex = 0
					for k, v in pairs(Creator.Track.Current.StartingGrid) do
						if Creator.StartingGrid.Select == v.handle then
							deleteIndex = k
							table.remove(Creator.Track.Current.StartingGrid, k)
							break
						end
					end
					if Creator.StartingGrid.Index > #Creator.Track.Current.StartingGrid then
						Creator.StartingGrid.Index = #Creator.Track.Current.StartingGrid
					end
					if Creator.Multiplayer.InSession then
						Creator.Multiplayer.ModificationCount.startingGrid = Creator.Multiplayer.ModificationCount.startingGrid + 1
						TriggerServerEvent("server:creator:syncSession", Creator.Track.Current.RaceId, {startingGrid = Creator.Track.Current.StartingGrid, deleteIndex = deleteIndex, modificationCount = Creator.Multiplayer.ModificationCount.startingGrid}, "startingGrid-sync")
					end
					DeleteVehicle(Creator.StartingGrid.Select)
					Creator.StartingGrid.IsPickedUp = false
					Creator.StartingGrid.Select = nil
					Creator.Function.ResetGlobalVariable("startingGrid")
					if Client.NUI.Callback ~= "" then
						SetNuiFocus(false, false)
						SendNUIMessage({
							action = "input off"
						})
						Client.NUI.Callback = ""
					end
					Client.Function.Message.Display(Client.Function.Translate.Get("startingGrid-error2"))
				end
				if Creator.Checkpoint.Preview and not Creator.Checkpoint.PreviewCoordsChanged then
					Creator.Checkpoint.Preview = nil
					Creator.Function.ResetGlobalVariable("checkpoint")
					if Client.NUI.Callback ~= "" then
						SetNuiFocus(false, false)
						SendNUIMessage({
							action = "input off"
						})
						Client.NUI.Callback = ""
					end
					Client.Function.Message.Display(Client.Function.Translate.Get("checkpoint-error"))
				end
				if Creator.Object.Preview and not Creator.Object.PreviewCoordsChanged then
					if Creator.Object.PreviewEffect then
						StopParticleFxLooped(Creator.Object.PreviewEffect, true)
						Creator.Object.PreviewEffect = nil
					end
					DeleteObject(Creator.Object.Preview)
					Creator.Object.Preview = nil
					Creator.Function.ResetGlobalVariable("object")
					if Client.NUI.Callback ~= "" then
						SetNuiFocus(false, false)
						SendNUIMessage({
							action = "input off"
						})
						Client.NUI.Callback = ""
					end
					Client.Function.Message.Display(Client.Function.Translate.Get("object-error"))
				end
				if #Creator.Template.Preview > 0 and not Creator.Template.PreviewCoordsChanged then
					for i = 1, #Creator.Template.Preview do
						DeleteObject(Creator.Template.Preview[i].handle)
					end
					Creator.Template.Preview = {}
					if Client.NUI.Callback ~= "" then
						SetNuiFocus(false, false)
						SendNUIMessage({
							action = "input off"
						})
						Client.NUI.Callback = ""
					end
					Client.Function.Message.Display(Client.Function.Translate.Get("object-error"))
				end
			end

			if Creator.StartingGrid.IsMenuVisible then
				for k, v in pairs(Creator.Track.Current.StartingGrid) do
					if v.handle then
						if v.handle ~= Creator.StartingGrid.Select and DoesEntityExist(v.handle) then
							local min, max = Client.Function.Shared.GetModelDimensionsInCaches(GetEntityModel(v.handle))
							local longestDiameter = math.sqrt((max.x - min.x)^2 + (max.y - min.y)^2 + (max.z - min.z)^2)
							DrawMarker(
								25,
								v.x,
								v.y,
								Client.Function.Math.RoundedValue(GetEntityCoords(v.handle).z + min.z, 3),
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								longestDiameter,
								longestDiameter,
								longestDiameter,
								255,
								0,
								0,
								125,
								false,
								false,
								2,
								nil,
								nil,
								false
							)
						end
					else
						local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
						local model = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
						v.handle = Creator.Function.CreateVehicle(model, v.x, v.y, v.z, v.heading)
						ResetEntityAlpha(v.handle)
						SetEntityDrawOutlineColor(255, 255, 255, 125)
						SetEntityDrawOutlineShader(1)
						SetEntityDrawOutline(v.handle, true)
					end
				end
			else
				for k, v in pairs(Creator.Track.Current.StartingGrid) do
					if v.handle then
						SetEntityDrawOutline(v.handle, false)
						DeleteVehicle(v.handle)
						v.handle = nil
					end
				end
			end

			if Creator.Checkpoint.IsMenuVisible and Creator.Checkpoint.Preview and not Creator.Checkpoint.IsPickedUp then
				local x = Creator.Checkpoint.Current.x
				local y = Creator.Checkpoint.Current.y
				local z = Creator.Checkpoint.Current.z
				local heading = Creator.Checkpoint.Current.heading
				local pitch = Creator.Checkpoint.Current.lockDirection and Creator.Checkpoint.Current.pitch or 0.0
				local diameterCollect = Creator.Checkpoint.Current.diameterCollect
				local diameterDraw = Creator.Checkpoint.Current.diameterDraw
				local isPit = Creator.Checkpoint.Current.isPit
				local isTall = Creator.Checkpoint.Current.isTall
				local isRound = Creator.Checkpoint.Current.isRound
				local isAir = Creator.Checkpoint.Current.isAir
				local isFake = Creator.Checkpoint.Current.isFake
				local isRandom = Creator.Checkpoint.Current.isRandom
				local randomClass = Creator.Checkpoint.Current.randomClass
				local isTransform = Creator.Checkpoint.Current.isTransform
				local transformIndex = Creator.Checkpoint.Current.transformIndex
				local isPlaneRot = Creator.Checkpoint.Current.isPlaneRot
				local planeRot = Creator.Checkpoint.Current.planeRot
				local isWarp = Creator.Checkpoint.Current.isWarp
				Creator.Function.DrawMarker(x, y, z, heading, pitch, diameterCollect, diameterDraw, isPit, isTall, isRound, isAir, isFake, isRandom, randomClass, isTransform, transformIndex, isPlaneRot, planeRot, isWarp, true, true, nil, false)
			end

			if Creator.Object.IsMenuVisible then
				if Creator.Snapping.Enable then
					if Creator.Object.Current.handle then
						if not Creator.Snapping.SphericalMode and not Creator.Object.IsPickedUp and Creator.Snapping.NextObjectUniqueId then
							local object = Creator.ObjectPool.ActiveObjects[Creator.Snapping.NextObjectUniqueId]
							if object and object.handle then
								Creator.Snapping.Handle = object.handle
								Creator.Snapping.ObjectData = object
								Creator.Snapping.NextObjectUniqueId = nil
								Creator.Function.Object.SetNewPositionAndRotationEnhanced()
							end
						end
					end
					if Creator.Snapping.Handle then
						if Creator.Snapping.BoneIndexParent > GetEntityBoneCount(Creator.Snapping.Handle) - 1 then
							Creator.Snapping.BoneIndexParent = -1
						end
						local _, _, radius = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Snapping.ObjectData.hash)
						local length = radius * 2.0
						local highlightPos, highlightRot = Creator.Function.Object.GetRelativePositionAndRotation(Creator.Snapping.ObjectData.hash, Creator.Snapping.ObjectData.handle, Creator.Snapping.ObjectData.x, Creator.Snapping.ObjectData.y, Creator.Snapping.ObjectData.z, Creator.Snapping.ObjectData.rotX, Creator.Snapping.ObjectData.rotY, Creator.Snapping.ObjectData.rotZ, Creator.Snapping.BoneIndexParent)
						if highlightPos and highlightRot then
							local highlightQuat = Client.Function.Math.RotationToQuaternion(highlightRot)
							if not Creator.Snapping.SphericalMode then
								local posInit, quatInit = highlightPos, highlightQuat
								for i = 1, #Creator.Snapping.Offset.steps do
									if Creator.Snapping.Offset.steps[i].sphericalMode then
										local _, _, posFinal, quatFinal = Creator.Function.Object.GetNewPositionAndQuaternion(posInit, quatInit, highlightPos, highlightQuat, nil, nil, Creator.Snapping.Offset.steps[i].axis, Creator.Snapping.Offset.steps[i].value)
										highlightPos, highlightQuat = posFinal, quatFinal
									else
										highlightPos, highlightQuat = Creator.Function.Object.UpdateBySingleAxis(highlightPos, highlightQuat, Creator.Snapping.Offset.steps[i].axis, Creator.Snapping.Offset.steps[i].value)
									end
								end
							end
							local right = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(1, 0, 0))
							local forward = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(0, 1, 0))
							local up = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(0, 0, 1))
							DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + right.x * length, highlightPos.y + right.y * length, highlightPos.z + right.z * length, 255, 0, 0, 255)
							DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + forward.x * length, highlightPos.y + forward.y * length, highlightPos.z + forward.z * length, 0, 255, 0, 255)
							DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + up.x * length, highlightPos.y + up.y * length, highlightPos.z + up.z * length, 0, 0, 255, 255)
						end
						Creator.Function.DrawEntityBoxes(Creator.Snapping.Handle, Creator.Snapping.ObjectData.hash, nil, nil, nil, false)
					end
				else
					if Creator.Object.Current.handle then
						if Creator.Object.OverrideRotIndex > GetEntityBoneCount(Creator.Object.Current.handle) - 1 then
							Creator.Object.OverrideRotIndex = -1
						end
						local _, _, radius = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Object.Current.hash)
						local length = radius * 2.0
						local highlightPos, highlightRot = nil, nil
						if Creator.Object.OverrideRelativeEnable then
							highlightPos, highlightRot = Creator.Function.Object.GetRelativePositionAndRotation(Creator.Object.Current.hash, Creator.Object.Current.handle, Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z, Creator.Object.Current.rotX, Creator.Object.Current.rotY, Creator.Object.Current.rotZ, Creator.Object.OverrideRotIndex)
						else
							highlightPos, highlightRot = vector3(Creator.Object.Current.x, Creator.Object.Current.y, Creator.Object.Current.z), vector3(0.0, 0.0, 0.0)
						end
						if highlightPos and highlightRot then
							local highlightQuat = Client.Function.Math.RotationToQuaternion(highlightRot)
							local right = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(1, 0, 0))
							local forward = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(0, 1, 0))
							local up = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(0, 0, 1))
							DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + right.x * length, highlightPos.y + right.y * length, highlightPos.z + right.z * length, 255, 0, 0, 255)
							DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + forward.x * length, highlightPos.y + forward.y * length, highlightPos.z + forward.z * length, 0, 255, 0, 255)
							DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + up.x * length, highlightPos.y + up.y * length, highlightPos.z + up.z * length, 0, 0, 255, 255)
						end
						if Creator.Object.IsPickedUp then
							if Creator.Object.DeleteActive then
								local r, g, b = GetHudColour(208)
								Creator.Function.DrawEntityBoxes(Creator.Object.Current.handle, Creator.Object.Current.hash, r, g, b, true)
							else
								Creator.Function.DrawEntityBoxes(Creator.Object.Current.handle, Creator.Object.Current.hash, nil, nil, nil, false)
							end
						end
						if Creator.Object.Current.hash and IsControlJustReleased(0, 204) and not IsNuiFocused() then
							if not Creator.Data.Favorite[Creator.Object.Current.hash] then
								table.insert(Creator.Data.Category.List[#Creator.Data.Category.List].model, Creator.Object.Current.hash)
								table.sort(Creator.Data.Category.List[#Creator.Data.Category.List].model, function(a, b) return string.lower(Client.Function.Translate.GetObjectLabelText(a)) < string.lower(Client.Function.Translate.GetObjectLabelText(b)) end)
								for i = 1, #Creator.Data.Category.List[#Creator.Data.Category.List].model do
									if Creator.Object.Current.hash == Creator.Data.Category.List[#Creator.Data.Category.List].model[i] then
										Creator.Data.Category.List[#Creator.Data.Category.List].index = i
										break
									end
								end
								Creator.Data.Favorite[Creator.Object.Current.hash] = true
								TriggerServerEvent("server:creator:saveData", {favorite = 1, model = tostring(Creator.Object.Current.hash)})
							else
								for i = 1, #Creator.Data.Category.List[#Creator.Data.Category.List].model do
									if Creator.Object.Current.hash == Creator.Data.Category.List[#Creator.Data.Category.List].model[i] then
										table.remove(Creator.Data.Category.List[#Creator.Data.Category.List].model, i)
										break
									end
								end
								if Creator.Data.Category.List[#Creator.Data.Category.List].index > #Creator.Data.Category.List[#Creator.Data.Category.List].model then
									Creator.Data.Category.List[#Creator.Data.Category.List].index = #Creator.Data.Category.List[#Creator.Data.Category.List].model
								end
								Creator.Data.Favorite[Creator.Object.Current.hash] = nil
								TriggerServerEvent("server:creator:saveData", {favorite = 0, model = tostring(Creator.Object.Current.hash)})
							end
						end
					end
				end
			end

			if Creator.Template.IsMenuVisible and #Creator.Template.Preview > 0 and Creator.Template.Preview[1].handle then
				local _, _, radius = Client.Function.Shared.GetModelDimensionsInCaches(Creator.Template.Preview[1].hash)
				local length = radius * 2.0
				local highlightPos, highlightRot = vector3(Creator.Template.Preview[1].x, Creator.Template.Preview[1].y, Creator.Template.Preview[1].z), Creator.Template.OverrideRelativeEnable and vector3(Creator.Template.Preview[1].rotX, Creator.Template.Preview[1].rotY, Creator.Template.Preview[1].rotZ) or vector3(0.0, 0.0, 0.0)
				local highlightQuat = Client.Function.Math.RotationToQuaternion(highlightRot)
				local right = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(1, 0, 0))
				local forward = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(0, 1, 0))
				local up = Client.Function.Math.RotateVectorByQuaternion(highlightQuat, vector3(0, 0, 1))
				DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + right.x * length, highlightPos.y + right.y * length, highlightPos.z + right.z * length, 255, 0, 0, 255)
				DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + forward.x * length, highlightPos.y + forward.y * length, highlightPos.z + forward.z * length, 0, 255, 0, 255)
				DrawLine(highlightPos.x, highlightPos.y, highlightPos.z, highlightPos.x + up.x * length, highlightPos.y + up.y * length, highlightPos.z + up.z * length, 0, 0, 255, 255)
				Creator.Function.DrawEntityBoxes(Creator.Template.Preview[1].handle, Creator.Template.Preview[1].hash, nil, nil, nil, false)
			end

			Creator.MarkerDrawCount = 0
			Creator.TextDrawCount = 0
			if Creator.Multiplayer.InSession then
				local time = GetGameTimer()
				local myLocalId = PlayerId()
				for k, v in pairs(Creator.Multiplayer.InSessionPlayers) do
					local id = GetPlayerFromServerId(v.playerId)
					local creatorPed = (id ~= -1) and (id ~= myLocalId) and GetPlayerPed(id)
					if creatorPed and (creatorPed ~= 0) and (ped ~= creatorPed) then
						if not v.color then
							v.color = Creator.Colors[math.random(#Creator.Colors)]
						end
						local color = v.color
						local creatorCoords = GetEntityCoords(creatorPed)
						local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(creatorCoords.x, creatorCoords.y, creatorCoords.z)
						if onScreen and IsEntityPositionFrozen(creatorPed) and not IsEntityVisible(creatorPed) then
							Creator.MarkerDrawCount = Creator.MarkerDrawCount + 1
							DrawMarker(
								28,
								creatorCoords.x,
								creatorCoords.y,
								creatorCoords.z,
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								0.0,
								0.5,
								0.5,
								0.5,
								color[1],
								color[2],
								color[3],
								125,
								false,
								false,
								2,
								nil,
								nil,
								false
							)
							if (#(creatorCoords - pos) > 3.6) and (#(creatorCoords - pos) < 36.0) then
								Creator.TextDrawCount = Creator.TextDrawCount + 1
								Creator.Function.DrawFloatingText(creatorCoords.x, creatorCoords.y, creatorCoords.z, 2.0, GetPlayerName(id) or "unknown", color[1], color[2], color[3], 255)
							end
						end
						local vehiclePreview = v.vehiclePreview
						if vehiclePreview and DoesEntityExist(vehiclePreview) then
							local vehiclePreviewCoords = GetEntityCoords(vehiclePreview)
							DrawLine(creatorCoords.x, creatorCoords.y, creatorCoords.z, vehiclePreviewCoords.x, vehiclePreviewCoords.y, vehiclePreviewCoords.z, color[1], color[2], color[3], 255)
						end
						if v.receiveTime and ((time - v.receiveTime) > 300) then
							v.checkpointPreview = nil
						end
						local checkpointPreview = v.checkpointPreview
						if checkpointPreview then
							Creator.Function.DrawMarker(checkpointPreview.x, checkpointPreview.y, checkpointPreview.z, checkpointPreview.heading, checkpointPreview.lockDirection and checkpointPreview.pitch or 0.0, checkpointPreview.diameterCollect, checkpointPreview.diameterDraw, checkpointPreview.isPit, checkpointPreview.isTall, checkpointPreview.isRound, checkpointPreview.isAir, checkpointPreview.isFake, checkpointPreview.isRandom, checkpointPreview.randomClass, checkpointPreview.isTransform, checkpointPreview.transformIndex, checkpointPreview.isPlaneRot, checkpointPreview.planeRot, checkpointPreview.isWarp, false, false, nil, false)
							DrawLine(creatorCoords.x, creatorCoords.y, creatorCoords.z, checkpointPreview.x, checkpointPreview.y, checkpointPreview.z, color[1], color[2], color[3], 255)
						end
						local objectPreview = v.objectPreview
						if objectPreview and DoesEntityExist(objectPreview) then
							local objectPreviewCoords = GetEntityCoords(objectPreview)
							DrawLine(creatorCoords.x, creatorCoords.y, creatorCoords.z, objectPreviewCoords.x, objectPreviewCoords.y, objectPreviewCoords.z, color[1], color[2], color[3], 255)
						end
					end
				end
				if Creator.GlobalVar.FixEventSizeOverflow and (time - Creator.GlobalVar.FixEventSizeOverflowTimer >= 500) then
					Creator.GlobalVar.FixEventSizeOverflow = false
				end
			end

			if Creator.Checkpoint.IsMenuVisible and not Creator.GlobalVar.EnableTest and #Creator.Track.Current.Checkpoints > 0 then
				for i, checkpoint in ipairs(Creator.Track.Current.Checkpoints) do
					local highlight = Creator.Checkpoint.IsPickedUp and Creator.Checkpoint.Index == i
					local x = checkpoint.x
					local y = checkpoint.y
					local z = checkpoint.z
					local heading = checkpoint.heading
					local pitch = checkpoint.lockDirection and checkpoint.pitch or 0.0
					local diameterCollect = checkpoint.diameterCollect
					local diameterDraw = checkpoint.diameterDraw
					local isPit = checkpoint.isPit
					local isTall = checkpoint.isTall
					local isRound = checkpoint.isRound
					local isAir = checkpoint.isAir
					local isFake = checkpoint.isFake
					local isRandom = checkpoint.isRandom
					local randomClass = checkpoint.randomClass
					local isTransform = checkpoint.isTransform
					local transformIndex = checkpoint.transformIndex
					local isPlaneRot = checkpoint.isPlaneRot
					local planeRot = checkpoint.planeRot
					local isWarp = checkpoint.isWarp
					local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)
					if onScreen and #(vector3(x, y, z) - pos) < 1500.0 then
						Creator.MarkerDrawCount = Creator.MarkerDrawCount + 1
						Creator.Function.DrawMarker(x, y, z, heading, pitch, diameterCollect, diameterDraw, isPit, isTall, isRound, isAir, isFake, isRandom, randomClass, isTransform, transformIndex, isPlaneRot, planeRot, isWarp, false, Creator.GlobalVar.IsPrimaryCheckpointItems and highlight, i, false)
						if Creator.MarkerDrawCount >= 60 then break end
					end

					local checkpoint_2 = Creator.Track.Current.Checkpoints_2[i]
					if checkpoint_2 then
						local highlight_2 = Creator.Checkpoint.IsPickedUp and Creator.Checkpoint.Index == i
						local x_2 = checkpoint_2.x
						local y_2 = checkpoint_2.y
						local z_2 = checkpoint_2.z
						local heading_2 = checkpoint_2.heading
						local pitch_2 = checkpoint_2.lockDirection and checkpoint_2.pitch or 0.0
						local diameterCollect_2 = checkpoint_2.diameterCollect
						local diameterDraw_2 = checkpoint_2.diameterDraw
						local isPit_2 = checkpoint_2.isPit
						local isTall_2 = checkpoint_2.isTall
						local isRound_2 = checkpoint_2.isRound
						local isAir_2 = checkpoint_2.isAir
						local isFake_2 = checkpoint_2.isFake
						local isRandom_2 = checkpoint_2.isRandom
						local randomClass_2 = checkpoint_2.randomClass
						local isTransform_2 = checkpoint_2.isTransform
						local transformIndex_2 = checkpoint_2.transformIndex
						local isPlaneRot_2 = checkpoint_2.isPlaneRot
						local planeRot_2 = checkpoint_2.planeRot
						local isWarp_2 = checkpoint_2.isWarp
						local onScreen_2, screenX_2, screenY_2 = GetScreenCoordFromWorldCoord(x_2, y_2, z_2)
						if onScreen_2 and #(vector3(x_2, y_2, z_2) - pos) < 1500.0 then
							Creator.MarkerDrawCount = Creator.MarkerDrawCount + 1
							Creator.Function.DrawMarker(x_2, y_2, z_2, heading_2, pitch_2, diameterCollect_2, diameterDraw_2, isPit_2, isTall_2, isRound_2, isAir_2, isFake_2, isRandom_2, randomClass_2, isTransform_2, transformIndex_2, isPlaneRot_2, planeRot_2, isWarp_2, false, not Creator.GlobalVar.IsPrimaryCheckpointItems and highlight_2, i, true)
							if Creator.MarkerDrawCount >= 60 then break end
						end
					end
				end
			end

			if Creator.Fixture.IsMenuVisible and #Creator.Track.Current.Fixtures > 0 then
				local highlight = {}
				local r, g, b = GetHudColour(208)
				for k, v in pairs(Creator.Track.Current.Fixtures) do
					highlight[v.hash] = true
				end
				local spawn = {}
				for uniqueId, object in pairs(Creator.ObjectPool.ActiveObjects) do
					if object.handle then
						spawn[object.handle] = true
					end
				end
				local pool = GetGamePool("CObject")
				for i = 1, #pool do
					local fixture = pool[i]
					if fixture and not spawn[fixture] and DoesEntityExist(fixture) then
						local hash = GetEntityModel(fixture)
						if highlight[hash] then
							local coords = GetEntityCoords(fixture)
							local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
							if onScreen then
								Creator.Function.DrawEntityBoxes(fixture, hash, r, g, b, true)
							end
						end
					end
				end
			end

			Creator.GlobalVar.RunningMainThread = false
			Wait(0)
		end
	end)
end

function Creator.Function.Exit()
	Client.IsCreatorInQuiting = true
	if Creator.Multiplayer.InSession then
		Creator.Multiplayer.InSession = false
		Creator.Multiplayer.ModificationCount = {
			title = 0,
			thumbnail = 0,
			testVehicle = 0,
			availableVehicles = 0,
			blimpText = 0,
			transformVehicles = 0,
			startingGrid = 0,
			checkpoints = 0,
			fixtures = 0,
			firework = 0
		}
		Creator.Multiplayer.InSessionPlayers = {}
		TriggerServerEvent("server:creator:leaveSession", Creator.Track.Current.RaceId)
	end
	DoScreenFadeOut(0)
	SendNUIMessage({
		action = "fade out",
		time = 0
	})
	CreateThread(function()
		RageUI.CloseAll(true)
		DeleteObject(Creator.GlobalVar.FakeObject)
		RemoveBlip(Creator.GlobalVar.CreatorBlipHandle)
		for k, v in pairs(Creator.Blips.Checkpoints) do
			RemoveBlip(v)
		end
		for k, v in pairs(Creator.Blips.Checkpoints_2) do
			RemoveBlip(v)
		end
		ClearAdditionalText(2, true)
		SetRadarBigmapEnabled(false, false)
		Wait(0)
		SetRadarZoom(1200)
	end)
	CreateThread(function()
		local ped = PlayerPedId()
		if Creator.Cache.JoinVehicleNetId then
			SetEntityCoords(ped, Creator.Cache.JoinPoint)
			SetEntityHeading(ped, Creator.Cache.JoinHeading)
		else
			SetEntityCoordsNoOffset(ped, Creator.Cache.JoinPoint)
			SetEntityHeading(ped, Creator.Cache.JoinHeading)
		end
		SetEntityInvincible(ped, false)
		SetEntityVisible(ped, true)
		SetEntityCollision(ped, true, true)
		SetEntityCompletelyDisableCollision(ped, true, true)
		UnlockMinimapAngle()
		UnlockMinimapPosition()
		SetBlipAlpha(GetMainPlayerBlipId(), 255)
		SetLocalPlayerAsGhost(false)
		Wait(500)
		local veh = Creator.Cache.JoinVehicleNetId and NetworkDoesNetworkIdExist(Creator.Cache.JoinVehicleNetId) and NetworkDoesEntityExistWithNetworkId(Creator.Cache.JoinVehicleNetId) and NetworkGetEntityFromNetworkId(Creator.Cache.JoinVehicleNetId)
		if DoesEntityExist(veh) then
			SetPedIntoVehicle(ped, veh, -1)
		end
		Wait(500)
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(Creator.Camera.Handle, false)
		SetGameplayCamRelativeHeading(0)
		FreezeEntityPosition(ped, false)
		DoScreenFadeIn(500)
		SendNUIMessage({
			action = "fade in",
			time = 500
		})
		Creator.Camera.Handle = nil
		Creator.Camera.Position = nil
		Creator.Camera.Rotation = nil
		Creator.Cache.JoinPoint = nil
		Creator.Cache.JoinHeading = nil
		Creator.Cache.JoinVehicleNetId = nil
		Creator.Cache.VehicleProps = {}
		Creator.Data.ObjectLabels = {}
		Creator.Data.ObjectModels = {}
		Creator.Blips.Checkpoints = {}
		Creator.Blips.Checkpoints_2 = {}
		Creator.Track.Current.RaceId = nil
		Creator.Track.Current.OwnerName = ""
		Creator.Track.Current.Thumbnail = ""
		Creator.Track.Current.Published = false
		Creator.Track.Current.Category = "Custom"
		Creator.Track.Current.Title = ""
		Creator.Track.Current.TestVehicle = ""
		Creator.Track.Current.DefaultClass = nil
		Creator.Track.Current.AvailableVehicles = {}
		Creator.Track.Current.BlimpText = ""
		Creator.Track.Current.StartingGrid = {}
		Creator.Track.Current.Checkpoints = {}
		Creator.Track.Current.Checkpoints_2 = {}
		Creator.Track.Current.TransformVehicles = {0, -422877666, -731262150, "bmx", "xa21"}
		Creator.Track.Current.Objects = {}
		Creator.Track.Current.Fixtures = {}
		Creator.Track.Current.Firework = {}
		Creator.Track.Current.Firework.Name = "scr_indep_firework_trailburst"
		Creator.Track.Current.Firework.R = 255
		Creator.Track.Current.Firework.G = 255
		Creator.Track.Current.Firework.B = 255
		Creator.StartingGrid.Index = 0
		Creator.Checkpoint.Index = 0
		Creator.Object.Index = 0
		Creator.Fixture.Index = 0
		Creator.Firework.ParticleIndex = 1
		Creator.GlobalRot.X = 0.0
		Creator.GlobalRot.Y = 0.0
		Creator.GlobalRot.Z = 0.0
		Creator.GlobalVar.IsUsingKeyboard = false
		Creator.GlobalVar.IsBigmapActive = false
		Creator.GlobalVar.RadarBigmapChecked = false
		Creator.GlobalVar.TempClosed = false
		Creator.GlobalVar.Lock = false
		Creator.GlobalVar.Lock_2 = false
		Creator.GlobalVar.Querying = false
		Creator.GlobalVar.PreviewThumbnail = ""
		Creator.GlobalVar.ShowThumbnail = false
		Creator.GlobalVar.ThumbnailValid = false
		Creator.GlobalVar.QueryingThumbnail = false
		Creator.GlobalVar.IsSelectingStartingGridVehicle = false
		Creator.GlobalVar.IsPrimaryCheckpointItems = true
		Creator.GlobalVar.PropColor = nil
		Creator.GlobalVar.PropZposLock = nil
		Creator.GlobalVar.TemplateZposLock = nil
		Creator.GlobalVar.TipsRendered = false
		Creator.GlobalVar.JoiningTest = false
		Creator.GlobalVar.QuitingTest = false
		Creator.GlobalVar.EnableTest = false
		Creator.GlobalVar.TestData = {}
		Creator.GlobalVar.TestVehicleHandle = nil
		Creator.GlobalVar.CreatorBlipHandle = nil
		Creator.GlobalVar.RespawnData = {}
		Creator.GlobalVar.AutoRespawn = true
		Creator.GlobalVar.IsRespawning = false
		Creator.GlobalVar.IsTransforming = false
		Creator.GlobalVar.EnableBeastMode = false
		Creator.GlobalVar.WasDoingBeastJump = false
		Creator.GlobalVar.ShowAllModelCheckedMsg = false
		Creator.GlobalVar.FixEventSizeOverflow = false
		Creator.GlobalVar.FixEventSizeOverflowTimer = 0
		Creator.GlobalVar.FakeObject = nil
		Creator.GlobalVar.RunningMainThread = false
		Client.IsInCreator = false
		Client.IsCreatorInQuiting = false
		Client.Hud.ResetNextFrame = true
		if Client.Permission.Weapon and Client.Preference.WeaponLoaded then
			Client.Function.Weapon.RemoveAll(PlayerPedId())
			Client.Function.Weapon.LoadSaved(PlayerPedId())
		end
		TriggerServerEvent("server:core:inCreator", false)
	end)
end

function Creator.Function.DrawEntityBoxes(handle, hash, r, g, b, forDebug)
	local min, max = Client.Function.Shared.GetModelDimensionsInCaches(hash)
	local corners = {
		GetOffsetFromEntityInWorldCoords(handle, max.x, max.y, max.z),
		GetOffsetFromEntityInWorldCoords(handle, min.x, max.y, max.z),
		GetOffsetFromEntityInWorldCoords(handle, max.x, min.y, max.z),
		GetOffsetFromEntityInWorldCoords(handle, min.x, min.y, max.z),
		GetOffsetFromEntityInWorldCoords(handle, max.x, max.y, min.z),
		GetOffsetFromEntityInWorldCoords(handle, min.x, max.y, min.z),
		GetOffsetFromEntityInWorldCoords(handle, max.x, min.y, min.z),
		GetOffsetFromEntityInWorldCoords(handle, min.x, min.y, min.z)
	}
	local lines = {
		{1, 2}, {2, 4}, {4, 3}, {3, 1},
		{5, 6}, {6, 8}, {8, 7}, {7, 5},
		{1, 5}, {2, 6}, {3, 7}, {4, 8}
	}
	for _, line in ipairs(lines) do
		local p1, p2 = corners[line[1]], corners[line[2]]
		DrawLine(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, 255, 255, 255, 255)
	end
	if forDebug and r and g and b then
		local faces = {
			{1, 2, 4}, {4, 3, 1},
			{2, 1, 5}, {5, 6, 2},
			{3, 4, 8}, {8, 7, 3},
			{7, 8, 6}, {6, 5, 7},
			{4, 2, 6}, {6, 8, 4},
			{1, 3, 7}, {7, 5, 1}
		}
		for _, face in ipairs(faces) do
			local p1, p2, p3 = corners[face[1]], corners[face[2]], corners[face[3]]
			DrawPoly(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z, p3.x, p3.y, p3.z, r, g, b, 80)
		end
	end
end

function Creator.Function.CreateObject(hash, x, y, z, rotX, rotY, rotZ, color)
	if IsModelInCdimage(hash) and IsModelValid(hash) then
		RequestModel(hash)
		while not HasModelLoaded(hash) do Wait(0) end
		local obj = CreateObjectNoOffset(hash, x, y, z, false, true, false)
		-- Create object of door type
		-- https://docs.fivem.net/natives/?_0x9A294B2138ABB884
		if obj == 0 then
			obj = CreateObjectNoOffset(hash, x, y, z, false, true, true)
		end
		if obj ~= 0 then
			SetEntityRotation(obj, rotX or 0.0, rotY or 0.0, rotZ or 0.0, 2, 0)
			SetObjectTextureVariation(obj, color or 0)
		end
		SetModelAsNoLongerNeeded(hash)
		return obj ~= 0 and obj or nil
	end
	return nil
end

function Creator.Function.CreateVehicle(hash, x, y, z, heading, combination)
	local model, validX, validY, validZ, vehicle = nil, x, y, 0.0, 0
	if validX <= -16000.0 or validX >= 16000.0 then
		validX = 0.0
	end
	if validY <= -16000.0 or validY >= 16000.0 then
		validY = 0.0
	end
	if (z > -200.0) and (z < 2700.0) then
		validZ = z
	else
		local found, groundZ = GetGroundZFor_3dCoord(validX, validY, z, true)
		validZ = found and (groundZ > -200.0) and (groundZ < 2700.0) and groundZ or 0.0
	end
	if IsModelInCdimage(hash) and IsModelValid(hash) and IsModelAVehicle(hash) then
		model = hash
	else
		model = GetHashKey("bmx")
	end
	RequestModel(model)
	while not HasModelLoaded(model) do Wait(0) end
	vehicle = CreateVehicle(model, validX, validY, validZ, heading, false, false)
	SetModelAsNoLongerNeeded(model)
	SetEntityRotation(vehicle, 0.0, 0.0, heading, 2, 0)
	FreezeEntityPosition(vehicle, true)
	SetEntityAlpha(vehicle, 150)
	if combination then
		SetVehicleColourCombination(vehicle, combination)
	end
	return vehicle
end

function Creator.Function.CreateBlip(x, y, z, scale, id, color, entity)
	local blip = nil
	if entity then
		blip = AddBlipForEntity(entity)
	else
		blip = AddBlipForCoord(x, y, z)
		SetBlipPriority(blip, 9)
	end
	SetBlipScale(blip, scale)
	SetBlipSprite(blip, id)
	SetBlipColour(blip, color)
	SetBlipShrink(blip, true)
	SetBlipDisplay(blip, 8)
	return blip
end

function Creator.Function.UpdateBlip(str, data)
	if str == "checkpoint" then
		for k, v in pairs(Creator.Blips.Checkpoints) do
			RemoveBlip(v)
		end
		for k, v in pairs(Creator.Blips.Checkpoints_2) do
			RemoveBlip(v)
		end
		Creator.Blips.Checkpoints = {}
		Creator.Blips.Checkpoints_2 = {}
		for k, v in pairs(Creator.Track.Current.Checkpoints) do
			Creator.Blips.Checkpoints[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
		end
		for k, v in pairs(Creator.Track.Current.Checkpoints_2) do
			Creator.Blips.Checkpoints_2[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.9, (v.isRandom and 66) or (v.isTransform and 570) or 1, (v.isRandom or v.isTransform) and 1 or 5)
		end
	elseif str == "object" then
		for k, v in pairs(Creator.Blips.Objects) do
			RemoveBlip(v)
		end
		Creator.Blips.Objects = {}
		if data then
			for k, v in pairs(data) do
				if v.handle then
					Creator.Blips.Objects[k] = Creator.Function.CreateBlip(v.x, v.y, v.z, 0.60, 271, 50, v.handle)
				end
			end
		end
	end
end

function Creator.Function.DrawMarker(x, y, z, heading, pitch, diameterCollect, diameterDraw, isPit, isTall, isRound, isAir, isFake, isRandom, randomClass, isTransform, transformIndex, isPlaneRot, planeRot, isWarp, isPreview, highlight, index, pair)
	local drawSize = ((isAir and (4.5 * diameterDraw)) or ((isRound or isRandom or isTransform or isPlaneRot or isWarp) and (2.25 * diameterDraw)) or diameterDraw) * 10
	local updateZ = isAir and 0.0 or (drawSize / 2)
	local marker_1 = (isRound or isRandom or isTransform or isPlaneRot or isWarp) and 6 or 1
	local x_1, y_1, z_1 = x, y, (isRound or isRandom or isTransform or isPlaneRot or isWarp) and (z + updateZ) or z
	local dirX_1 = (isRound or isRandom or isTransform or isPlaneRot or isWarp) and (-math.sin(math.rad(heading)) * math.cos(math.rad(pitch))) or 0.0
	local dirY_1 = (isRound or isRandom or isTransform or isPlaneRot or isWarp) and (math.cos(math.rad(heading)) * math.cos(math.rad(pitch))) or 0.0
	local dirZ_1 = (isRound or isRandom or isTransform or isPlaneRot or isWarp) and (math.sin(math.rad(pitch))) or 0.0
	local rotX_1 = 0.0
	local rotY_1 = 0.0
	local rotZ_1 = (isRound or isRandom or isTransform or isPlaneRot or isWarp) and 180.0 or 0.0
	local scaleX_1 = drawSize
	local scaleY_1 = drawSize
	local scaleZ_1 = ((isRound or isRandom or isTransform or isPlaneRot or isWarp) and drawSize) or (isTall and (drawSize * 0.375 * 50.0)) or (drawSize * 0.375)
	local red_1, green_1, blue_1 = GetHudColour((isRandom or isTransform) and 6 or 13)
	local alpha_1 = isFake and 75 or 150
	local marker_2 = 20
	local x_2, y_2, z_2 = x, y, (isRound or isRandom or isTransform or isPlaneRot or isWarp) and (z + updateZ) or (z + drawSize / 2)
	local dirX_2 = (isRandom or isTransform or isPlaneRot or isWarp) and (-math.sin(math.rad(heading)) * math.cos(math.rad(pitch))) or 0.0
	local dirY_2 = (isRandom or isTransform or isPlaneRot or isWarp) and (math.cos(math.rad(heading)) * math.cos(math.rad(pitch))) or 0.0
	local dirZ_2 = (isRandom or isTransform or isPlaneRot or isWarp) and (math.sin(math.rad(pitch))) or -1.0
	local rotX_2 = 0.0
	local rotY_2 = (isRandom and 0.0) or (isTransform and 0.0) or (isPlaneRot and ((planeRot == 1 and 270.0) or (planeRot == 2 and 180.0) or (planeRot == 3 and 90.0) or 0.0)) or (isWarp and 0.0) or heading
	local rotZ_2 = (isRandom and 180.0) or (isTransform and 180.0) or (isPlaneRot and 0.0) or (isWarp and 180.0) or 0.0
	local scaleX_2 = (isRandom or isTransform or isPlaneRot or isWarp) and (drawSize * 0.6) or (drawSize / 2)
	local scaleY_2 = (isRandom or isTransform or isPlaneRot or isWarp) and (drawSize * 0.6) or (drawSize / 2)
	local scaleZ_2 = (isRandom or isTransform or isPlaneRot or isWarp) and (drawSize * 0.6) or (drawSize / 2)
	local red_2, green_2, blue_2 = GetHudColour(134)
	local alpha_2 = isFake and 75 or 150
	if isRandom then
		marker_2 = 32
	elseif isTransform then
		local transformVehicle = Creator.Track.Current.TransformVehicles[transformIndex + 1]
		local model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
		local class = GetVehicleClassFromName(model)
		if model == -422877666 then
			marker_2 = 40
		elseif model == -731262150 then
			marker_2 = 31
		elseif class >= 0 and class <= 7 or class >= 9 and class <= 12 or class == 17 or class == 18 or class == 22 then
			marker_2 = 36
		elseif class == 8 then
			marker_2 = 37
		elseif class == 13 then
			marker_2 = 38
		elseif class == 14 then
			marker_2 = 35
		elseif class == 15 then
			marker_2 = 34
		elseif class == 16 then
			marker_2 = 33
		elseif class == 20 then
			marker_2 = 39
		elseif class == 19 then
			if model == GetHashKey("thruster") then
				marker_2 = 41
			else
				marker_2 = 36
			end
		elseif class == 21 then
			marker_2 = 36
		end
	elseif isPlaneRot then
		marker_2 = 7
	elseif isWarp then
		marker_2 = 42
	elseif isRound then
		marker_2 = 20
	else
		if isPit then
			marker_2 = 44
			dirX_2, dirY_2, dirZ_2, rotX_2, rotY_2, rotZ_2 = 0.0, 0.0, 0.0, 0.0, 0.0, heading
		else
			marker_2 = 20
		end
	end

	if (Creator.TextDrawCount < 30) and not isPreview then
		local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z + (drawSize / 3))
		if onScreen and index then
			local handle = StartShapeTestRay(Creator.Camera.Position.x, Creator.Camera.Position.y, Creator.Camera.Position.z, x, y, z + (drawSize / 3), -1, 0)
			local _, hit, _, _, _ = GetShapeTestResult(handle)
			if hit == 0 then
				Creator.TextDrawCount = Creator.TextDrawCount + 1
				Creator.Function.DrawFloatingText(x_2, y_2, z_2, drawSize, index, 255, 255, pair and 125 or 255, isFake and 150 or 255)
			end
		end
	end

	DrawMarker(
		marker_1,
		x_1,
		y_1,
		z_1,
		dirX_1,
		dirY_1,
		dirZ_1,
		rotX_1,
		rotY_1,
		rotZ_1,
		scaleX_1,
		scaleY_1,
		scaleZ_1,
		red_1,
		green_1,
		blue_1,
		alpha_1,
		false,
		false,
		4,
		nil,
		nil,
		false
	)
	DrawMarker(
		marker_2,
		x_2,
		y_2,
		z_2,
		dirX_2,
		dirY_2,
		dirZ_2,
		rotX_2,
		rotY_2,
		rotZ_2,
		scaleX_2,
		scaleY_2,
		scaleZ_2,
		red_2,
		green_2,
		blue_2,
		alpha_2,
		false,
		false,
		4,
		nil,
		nil,
		false
	)
	if highlight then
		local collectSize = ((isAir and (4.5 * diameterCollect)) or ((isRound or isRandom or isTransform or isPlaneRot or isWarp) and (2.25 * diameterCollect)) or diameterCollect) * 10
		DrawMarker(
			26,
			x_1,
			y_1,
			z_1,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			heading,
			collectSize,
			collectSize,
			(isRound or isRandom or isTransform or isPlaneRot or isWarp) and collectSize or (collectSize / 2),
			255,
			255,
			255,
			150,
			false,
			false,
			2,
			nil,
			nil,
			false
		)
	end
end

function Creator.Function.DrawFloatingText(x, y, z, drawSize, text, r, g, b, alpha)
	local distance = (Creator.Firework.IsMenuVisible and #((vector3(0.0, 60.0, 1050.0)) - vector3(x, y, z + (drawSize / 3)))) or (Creator.GlobalVar.EnableTest and #(GetGameplayCamCoords() - vector3(x, y, z + (drawSize / 3)))) or #((vector3(Creator.Camera.Position.x, Creator.Camera.Position.y, Creator.Camera.Position.z)) - vector3(x, y, z + (drawSize / 3)))
	local scale = drawSize / (distance * 0.2)
	SetTextScale(0.0, scale)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(r, g, b, alpha)
	SetTextOutline()
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z + (drawSize * 5 / 6), 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

function Creator.Function.ResetCheckpointAndBlip()
	if Creator.GlobalVar.TestData and Creator.GlobalVar.TestData.Checkpoints then
		for i, checkpoint in ipairs(Creator.GlobalVar.TestData.Checkpoints) do
			if checkpoint.drawId then
				DeleteCheckpoint(checkpoint.drawId)
				checkpoint.drawId = nil
			end
			if checkpoint.blipId then
				RemoveBlip(checkpoint.blipId)
				checkpoint.blipId = nil
			end
			local checkpoint_2 = Creator.GlobalVar.TestData.Checkpoints_2[i]
			if checkpoint_2 then
				if checkpoint_2.drawId then
					DeleteCheckpoint(checkpoint_2.drawId)
					checkpoint_2.drawId = nil
				end
				if checkpoint_2.blipId then
					RemoveBlip(checkpoint_2.blipId)
					checkpoint_2.blipId = nil
				end
			end
		end
	end
end

function Creator.Function.CreateCheckpoint(index, pair)
	local checkpoint = pair and Creator.GlobalVar.TestData.Checkpoints_2[index] or Creator.GlobalVar.TestData.Checkpoints[index]
	if not checkpoint then return end
	local checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(13)
	local checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
	local checkpointA_1, checkpointA_2 = 150, 150
	if not checkpoint.drawId then
		local drawSize = ((checkpoint.isAir and (4.5 * checkpoint.diameterDraw)) or ((checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) and (2.25 * checkpoint.diameterDraw)) or checkpoint.diameterDraw) * 10
		local checkpointNearHeight = 9.5
		local checkpointFarHeight = 9.5
		local checkpointRangeHeight = checkpoint.isTall and checkpoint.tallRadius or 100.0
		local drawHigher = false
		local updateZ = checkpoint.isRound and (checkpoint.isAir and 0.0 or (drawSize / 2)) or (drawSize / 2)
		local nextCheckpoint = pair and (Creator.GlobalVar.TestData.Checkpoints_2[index + 1] or Creator.GlobalVar.TestData.Checkpoints[index + 1] or Creator.GlobalVar.TestData.Checkpoints_2[1] or Creator.GlobalVar.TestData.Checkpoints[1]) or (Creator.GlobalVar.TestData.Checkpoints[index + 1] or Creator.GlobalVar.TestData.Checkpoints[1]) or {x = 0.0, y = 0.0, z = 0.0}
		local prevCheckpoint = pair and (Creator.GlobalVar.TestData.Checkpoints_2[index - 1] or Creator.GlobalVar.TestData.Checkpoints[index - 1] or Creator.GlobalVar.TestData.Checkpoints_2[#Creator.GlobalVar.TestData.Checkpoints] or Creator.GlobalVar.TestData.Checkpoints[#Creator.GlobalVar.TestData.Checkpoints]) or (Creator.GlobalVar.TestData.Checkpoints[index - 1] or Creator.GlobalVar.TestData.Checkpoints[#Creator.GlobalVar.TestData.Checkpoints]) or {x = 0.0, y = 0.0, z = 0.0}
		local checkpointIcon = 6
		if checkpoint.isRandom then
			checkpointIcon = 56
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.isTransform then
			local transformVehicle = Creator.Track.Current.TransformVehicles[checkpoint.transformIndex + 1]
			local model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
			local class = GetVehicleClassFromName(model)
			if model == -422877666 then
				checkpointIcon = 64
			elseif model == -731262150 then
				checkpointIcon = 55
			elseif class >= 0 and class <= 7 or class >= 9 and class <= 12 or class == 17 or class == 18 or class == 22 then
				checkpointIcon = 60
			elseif class == 8 then
				checkpointIcon = 61
			elseif class == 13 then
				checkpointIcon = 62
			elseif class == 14 then
				checkpointIcon = 59
			elseif class == 15 then
				checkpointIcon = 58
			elseif class == 16 then
				checkpointIcon = 57
			elseif class == 20 then
				checkpointIcon = 63
			elseif class == 19 then
				if model == GetHashKey("thruster") then
					checkpointIcon = 65
				else
					checkpointIcon = 60
				end
			elseif class == 21 then
				checkpointIcon = 60
			end
			checkpointR_1, checkpointG_1, checkpointB_1 = GetHudColour(6)
		elseif checkpoint.isPlaneRot then
			if checkpoint.planeRot == 0 then
				checkpointIcon = 37
			elseif checkpoint.planeRot == 1 then
				checkpointIcon = 39
			elseif checkpoint.planeRot == 2 then
				checkpointIcon = 40
			elseif checkpoint.planeRot == 3 then
				checkpointIcon = 38
			end
			if checkpoint.isPlaneRot then
				local ped = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(ped, false)
				if vehicle > 0 and Client.Function.Shared.GetVehicleShouldSlowDown(checkpoint, vehicle) then
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(6)
				else
					checkpointR_2, checkpointG_2, checkpointB_2 = GetHudColour(134)
				end
			end
		elseif checkpoint.isWarp then
			checkpointIcon = 66
		elseif checkpoint.isRound then
			checkpointIcon = 12
		else
			local diffPrev = vector3(prevCheckpoint.x, prevCheckpoint.y, prevCheckpoint.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
			local diffNext = vector3(nextCheckpoint.x, nextCheckpoint.y, nextCheckpoint.z) - vector3(checkpoint.x, checkpoint.y, checkpoint.z)
			local checkpointAngle = GetAngleBetween_2dVectors(diffPrev.x, diffPrev.y, diffNext.x, diffNext.y)
			checkpointAngle = checkpointAngle > 180.0 and (360.0 - checkpointAngle) or checkpointAngle
			local found, groundZ = GetGroundZExcludingObjectsFor_3dCoord(checkpoint.x, checkpoint.y, checkpoint.z, false)
			if found and math.abs(groundZ - checkpoint.z) > (drawSize * 0.3125) then
				drawHigher = true
				checkpointNearHeight = drawSize * 0.375
				checkpointFarHeight = checkpoint.isTall and (drawSize * 0.375 * 50.0) or (drawSize * 0.375)
				updateZ = 0.0
			else
				checkpointNearHeight = drawSize * 0.75
				checkpointFarHeight = checkpoint.isTall and (drawSize * 0.75 * 50.0) or (drawSize * 0.75)
			end
			if checkpointAngle < 80.0 then
				checkpointIcon = drawHigher == true and (checkpoint.isPit and 5 or 2) or (checkpoint.isPit and 11 or 8)
			elseif checkpointAngle < 140.0 then
				checkpointIcon = drawHigher == true and (checkpoint.isPit and 5 or 1) or (checkpoint.isPit and 11 or 7)
			elseif checkpointAngle <= 180.0 then
				checkpointIcon = drawHigher == true and (checkpoint.isPit and 5 or 0) or (checkpoint.isPit and 11 or 6)
			end
		end
		if not (checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) then
			local hour = GetClockHours()
			if hour > 6 and hour < 20 then
				checkpointA_1 = 210
				checkpointA_2 = 180
			end
		end
		local pos_1 = vector3(checkpoint.x, checkpoint.y, checkpoint.z)
		local pos_2 = vector3(nextCheckpoint.x, nextCheckpoint.y, nextCheckpoint.z)
		if not (checkpoint.offset.x == 0.0 and checkpoint.offset.y == 0.0 and checkpoint.offset.z == 0.0) then
			pos_2 = pos_1 + vector3(0.0, 0.0, updateZ) + vector3(checkpoint.offset.x, checkpoint.offset.y, checkpoint.offset.z)
		end
		checkpoint.drawId = CreateCheckpoint(
			checkpointIcon,
			pos_1.x, pos_1.y, pos_1.z + updateZ,
			pos_2.x, pos_2.y, pos_2.z,
			drawSize, checkpointR_2, checkpointG_2, checkpointB_2, checkpointA_2, 0
		)
		if (checkpoint.isRound or checkpoint.isRandom or checkpoint.isTransform or checkpoint.isPlaneRot or checkpoint.isWarp) then
			if checkpoint.lockDirection then
				local dirVec = vector3(-math.sin(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.cos(math.rad(checkpoint.heading)) * math.cos(math.rad(checkpoint.pitch)), math.sin(math.rad(checkpoint.pitch)))
				local pos_3 = pos_1 + vector3(0.0, 0.0, updateZ) - dirVec
				-- Rockstar does it this way, but there seems to be a display error for inside icons, WTF?
				-- local pos_3 = checkpoint.isPlaneRot and (pos_1 + vector3(0.0, 0.0, updateZ) - dirVec) or (pos_1 + vector3(0.0, 0.0, updateZ) + dirVec)
				N_0xdb1ea9411c8911ec(checkpoint.drawId) -- SET_CHECKPOINT_FORCE_DIRECTION
				N_0x3c788e7f6438754d(checkpoint.drawId, pos_3.x, pos_3.y, pos_3.z) -- SET_CHECKPOINT_DIRECTION
			end
		else
			if drawHigher then
				SetCheckpointIconHeight(checkpoint.drawId, checkpoint.isPit and 0.75 or 0.5) -- SET_CHECKPOINT_INSIDE_CYLINDER_HEIGHT_SCALE
				-- SetCheckpointIconScale(checkpoint.drawId, 0.85) -- SET_CHECKPOINT_INSIDE_CYLINDER_SCALE
			end
			SetCheckpointCylinderHeight(checkpoint.drawId, checkpointNearHeight, checkpointFarHeight, checkpointRangeHeight)
		end
		SetCheckpointRgba(checkpoint.drawId, checkpointR_1, checkpointG_1, checkpointB_1, checkpointA_1)
	end
end

function Creator.Function.CreateCheckpointBlip(cpIndex)
	local function createData(checkpoint, isNext)
		local x, y, z = checkpoint.x, checkpoint.y, checkpoint.z
		local sprite = (checkpoint.isRandom and 66) or (checkpoint.isTransform and 570) or 1
		local scale = isNext and 0.65 or 0.9
		local alpha = (isNext or checkpoint.lowerAlpha) and 125 or 255
		local colour = (checkpoint.isRandom or checkpoint.isTransform) and 1 or 5
		local display = 8
		return {
			x = x,
			y = y,
			z = z,
			sprite = sprite,
			scale = scale,
			alpha = alpha,
			colour = colour,
			display = display
		}
	end
	local function createBlip(data)
		local blip = 0
		if data.x ~= nil and data.y ~= nil and data.z ~= nil then
			blip = AddBlipForCoord(data.x, data.y, data.z)
		end
		if data.sprite ~= nil then
			SetBlipSprite(blip, data.sprite)
		end
		if data.scale ~= nil then
			SetBlipScale(blip, data.scale)
		end
		if data.alpha ~= nil then
			SetBlipAlpha(blip, data.alpha)
		end
		if data.colour ~= nil then
			SetBlipColour(blip, data.colour)
		end
		if data.display ~= nil then
			SetBlipDisplay(blip, data.display)
		end
		return blip
	end
	local checkpoint = Creator.GlobalVar.TestData.Checkpoints[cpIndex]
	if checkpoint then
		checkpoint.blipId = createBlip(createData(checkpoint, false))
	end
	local checkpoint_2 = Creator.GlobalVar.TestData.Checkpoints_2[cpIndex]
	if checkpoint_2 then
		checkpoint_2.blipId = createBlip(createData(checkpoint_2, false))
	end
	local nextCheckpoint = Creator.GlobalVar.TestData.Checkpoints[cpIndex + 1]
	if nextCheckpoint then
		nextCheckpoint.blipId = createBlip(createData(nextCheckpoint, true))
	end
	local nextCheckpoint_2 = Creator.GlobalVar.TestData.Checkpoints_2[cpIndex + 1]
	if nextCheckpoint_2 then
		nextCheckpoint_2.blipId = createBlip(createData(nextCheckpoint_2, true))
	end
end

function Creator.Function.TestCurrentCheckpoint(respawnData, callback)
	CreateThread(function()
		local ped = PlayerPedId()
		local x, y, z = Client.Function.Shared.GetValidXYZFor_3dCoord(respawnData.x, respawnData.y, respawnData.z, false, true)
		local heading = respawnData.heading
		local hash = respawnData.model
		local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
		local model = ((hash and hash ~= 0) and (tonumber(hash) or GetHashKey(hash))) or (tonumber(defaultVehicle) or GetHashKey(defaultVehicle))
		local parachute = (model == -422877666) and true or false
		local beast = (model == -731262150) and true or false
		Creator.GlobalVar.AutoRespawn = (not parachute and not beast) and true or false
		Creator.GlobalVar.EnableBeastMode = beast and true or false
		Creator.GlobalVar.WasDoingBeastJump = false
		if not Creator.Function.Pool.IsNearbyObjectsSpawned(x, y) or callback ~= nil then
			if callback == nil then
				DoScreenFadeOut(0)
				SendNUIMessage({
					action = "fade out",
					time = 0
				})
			end
			Creator.ObjectPool.ForceLoad.x = x
			Creator.ObjectPool.ForceLoad.y = y
			Creator.ObjectPool.ForceLoad.z = z
			local time = GetGameTimer()
			while not Creator.Function.Pool.IsNearbyObjectsSpawned(x, y) and (GetGameTimer() - time < 500) do Wait(0) end
		end
		if parachute or beast then
			if callback ~= nil then callback(ped) end
			if Creator.GlobalVar.TipsRendered then
				Creator.GlobalVar.RespawnData.DrawIndex = Creator.GlobalVar.RespawnData.Index + 1
				Creator.Function.ResetCheckpointAndBlip()
				Creator.Function.CreateCheckpointBlip(Creator.GlobalVar.RespawnData.DrawIndex)
				Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, false)
				Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, true)
			end
			if Creator.GlobalVar.TestVehicleHandle then
				local netId = NetworkGetNetworkIdFromEntity(Creator.GlobalVar.TestVehicleHandle)
				DeleteEntity(Creator.GlobalVar.TestVehicleHandle)
				TriggerServerEvent("server:core:deleteEntity", netId)
				Creator.GlobalVar.TestVehicleHandle = nil
			end
			ClearPedBloodDamage(ped)
			ClearPedWetness(ped)
			SetEntityCoords(ped, x, y, z)
			SetEntityHeading(ped, heading)
			SetRunSprintMultiplierForPlayer(PlayerId(), beast and 1.49 or 1.0)
			SetGameplayCamRelativeHeading(0)
			DoScreenFadeIn(500)
			SendNUIMessage({
				action = "fade in",
				time = 500
			})
			Client.Function.Weapon.ReloadForRaceAndCreator(ped, parachute, beast, Client.Preference.EnableWeaponInTest)
			Creator.ObjectPool.ForceLoad.x = nil
			Creator.ObjectPool.ForceLoad.y = nil
			Creator.ObjectPool.ForceLoad.z = nil
			Creator.GlobalVar.IsRespawning = false
			return
		end
		if not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model) then
			model = GetHashKey("bmx")
		end
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(0) end
		-- Spawn vehicle at the top of the player, fix OneSync culling
		local pos = GetEntityCoords(ped)
		local _x, _y, _z = Client.Function.Shared.GetValidXYZFor_3dCoord(pos.x, pos.y, pos.z, true, false)
		local newVehicle = CreateVehicle(model, _x, _y, _z, heading, true, false)
		local netId = NetworkGetNetworkIdFromEntity(newVehicle)
		TriggerServerEvent("server:core:spawnEntity", netId)
		SetModelAsNoLongerNeeded(model)
		FreezeEntityPosition(newVehicle, true)
		SetEntityCollision(newVehicle, false, false)
		SetVehRadioStation(newVehicle, "OFF")
		SetVehicleDoorsLocked(newVehicle, 10)
		SetVehicleColourCombination(newVehicle, 0)
		if Creator.Cache.VehicleProps and Creator.Cache.VehicleProps.model == model then
			Client.Function.Tuning.SetProperties(newVehicle, Creator.Cache.VehicleProps)
		else
			for k, v in pairs(Client.Vehicle.SavedVehicles) do
				if v.model == model then
					Client.Function.Tuning.SetProperties(newVehicle, v)
					break
				end
			end
		end
		Wait(0) -- Do not delete! Vehicle still has collisions before this. BUG?
		if callback ~= nil then callback(ped) end
		if Creator.GlobalVar.TipsRendered then
			Creator.GlobalVar.RespawnData.DrawIndex = Creator.GlobalVar.RespawnData.Index + 1
			Creator.Function.ResetCheckpointAndBlip()
			Creator.Function.CreateCheckpointBlip(Creator.GlobalVar.RespawnData.DrawIndex)
			Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, false)
			Creator.Function.CreateCheckpoint(Creator.GlobalVar.RespawnData.DrawIndex, true)
		end
		if Creator.GlobalVar.TestVehicleHandle then
			local netId = NetworkGetNetworkIdFromEntity(Creator.GlobalVar.TestVehicleHandle)
			DeleteEntity(Creator.GlobalVar.TestVehicleHandle)
			TriggerServerEvent("server:core:deleteEntity", netId)
		end
		ClearPedBloodDamage(ped)
		ClearPedWetness(ped)
		SetEntityCoords(newVehicle, x, y, z)
		SetEntityHeading(newVehicle, heading)
		SetPedIntoVehicle(ped, newVehicle, -1)
		SetEntityCollision(newVehicle, true, true)
		SetVehicleFuelLevel(newVehicle, 100.0)
		SetVehicleDirtLevel(newVehicle, 0.0)
		SetVehicleEngineOn(newVehicle, true, true, false)
		SetGameplayCamRelativeHeading(0)
		DoScreenFadeIn(500)
		SendNUIMessage({
			action = "fade in",
			time = 500
		})
		Wait(0) -- Do not delete! Respawn under fake water
		FreezeEntityPosition(newVehicle, false)
		ActivatePhysics(newVehicle)
		if IsThisModelAPlane(model) or IsThisModelAHeli(model) then
			ControlLandingGear(newVehicle, 3)
			SetHeliBladesSpeed(newVehicle, 1.0)
			SetHeliBladesFullSpeed(newVehicle)
			SetVehicleForwardSpeed(newVehicle, 30.0)
		end
		if model == GetHashKey("avenger") or model == GetHashKey("hydra") then
			SetVehicleFlightNozzlePositionImmediate(newVehicle, 0.0)
		end
		Client.Function.Weapon.ReloadForRaceAndCreator(ped, false, false, Client.Preference.EnableWeaponInTest)
		Creator.ObjectPool.ForceLoad.x = nil
		Creator.ObjectPool.ForceLoad.y = nil
		Creator.ObjectPool.ForceLoad.z = nil
		Creator.GlobalVar.TestVehicleHandle = newVehicle
		Creator.GlobalVar.IsRespawning = false
	end)
end

function Creator.Function.TransformVehicle(checkpoint, speed, rotation, velocity)
	Creator.GlobalVar.IsTransforming = true
	CreateThread(function()
		local transformVehicle = 0
		if checkpoint.isRandom then
			local randomVehicles = {}
			for classid = 0, 27 do
				for i = 1, #Creator.Track.Current.AvailableVehicles[classid].vehicles do
					if Creator.Track.Current.AvailableVehicles[classid].vehicles[i].enabled then
						randomVehicles[Creator.Track.Current.AvailableVehicles[classid].vehicles[i].hash] = true
					end
				end
			end
			transformVehicle = Client.Function.Shared.GetRandomVehicleModel(Creator.Track.Current.TransformVehicles, randomVehicles, checkpoint.randomClass, checkpoint.randomCustom, checkpoint.randomSetting)
		else
			transformVehicle = Creator.Track.Current.TransformVehicles[checkpoint.transformIndex + 1]
		end
		local model = transformVehicle and (tonumber(transformVehicle) or GetHashKey(transformVehicle)) or 0
		local ped = PlayerPedId()
		local copyVelocity = true
		if not Creator.GlobalVar.AutoRespawn then
			copyVelocity = ((math.abs(velocity.x) > 0.0) or (math.abs(velocity.y) > 0.0) or (math.abs(velocity.z) > 0.0)) and true or false
			speed = speed > 0.03 and speed or 30.0
		end
		local parachute = (model == -422877666) and true or false
		local beast = (model == -731262150) and true or false
		Creator.GlobalVar.AutoRespawn = (not parachute and not beast) and true or false
		Creator.GlobalVar.EnableBeastMode = beast and true or false
		Creator.GlobalVar.WasDoingBeastJump = false
		if parachute or beast then
			if Creator.GlobalVar.TestVehicleHandle then
				local netId = NetworkGetNetworkIdFromEntity(Creator.GlobalVar.TestVehicleHandle)
				DeleteEntity(Creator.GlobalVar.TestVehicleHandle)
				TriggerServerEvent("server:core:deleteEntity", netId)
				Creator.GlobalVar.TestVehicleHandle = nil
			end
			Client.Function.Message.Display(parachute and Client.Function.Translate.Get("Transform-Parachute") or Client.Function.Translate.Get("Transform-Beast"))
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
			SetRunSprintMultiplierForPlayer(PlayerId(), beast and 1.49 or 1.0)
			Client.Function.Weapon.ReloadForRaceAndCreator(ped, parachute, beast, Client.Preference.EnableWeaponInTest)
			Creator.GlobalVar.IsTransforming = false
			return
		end
		if model == 0 then
			local defaultVehicle = Creator.Track.Current.DefaultClass and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index] and Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].vehicles[Creator.Track.Current.AvailableVehicles[Creator.Track.Current.DefaultClass].index].model or Creator.Track.Current.TestVehicle
			model = tonumber(defaultVehicle) or GetHashKey(defaultVehicle)
		end
		if not IsModelInCdimage(model) or not IsModelValid(model) or not IsModelAVehicle(model) then
			model = GetHashKey("bmx")
		end
		SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
		RequestModel(model)
		while not HasModelLoaded(model) do Wait(0) end
		local pos = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		local x1, y1, z1 = Client.Function.Shared.GetValidXYZFor_3dCoord(pos.x, pos.y, pos.z, true, false)
		local x2, y2, z2 = Client.Function.Shared.GetValidXYZFor_3dCoord(pos.x, pos.y, pos.z, false, true)
		local newVehicle = CreateVehicle(model, x1, y1, z1, heading, true, false)
		local netId = NetworkGetNetworkIdFromEntity(newVehicle)
		TriggerServerEvent("server:core:spawnEntity", netId)
		SetModelAsNoLongerNeeded(model)
		if Creator.GlobalVar.TestVehicleHandle then
			local netId = NetworkGetNetworkIdFromEntity(Creator.GlobalVar.TestVehicleHandle)
			DeleteEntity(Creator.GlobalVar.TestVehicleHandle)
			TriggerServerEvent("server:core:deleteEntity", netId)
		end
		SetVehRadioStation(newVehicle, "OFF")
		SetVehicleDoorsLocked(newVehicle, 10)
		SetVehicleColourCombination(newVehicle, 0)
		for k, v in pairs(Client.Vehicle.SavedVehicles) do
			if v.model == model then
				Client.Function.Tuning.SetProperties(newVehicle, v)
				break
			end
		end
		SetPedIntoVehicle(ped, newVehicle, -1)
		SetEntityCoords(newVehicle, x2, y2, z2)
		SetEntityHeading(newVehicle, heading)
		SetVehicleFuelLevel(newVehicle, 100.0)
		SetVehicleDirtLevel(newVehicle, 0.0)
		SetVehicleEngineOn(newVehicle, true, true, false)
		if IsThisModelAPlane(model) or IsThisModelAHeli(model) then
			ControlLandingGear(newVehicle, 3)
			SetHeliBladesSpeed(newVehicle, 1.0)
			SetHeliBladesFullSpeed(newVehicle)
			speed = speed > 0.03 and speed or 30.0
		end
		if model == GetHashKey("avenger") or model == GetHashKey("hydra") then
			SetVehicleFlightNozzlePositionImmediate(newVehicle, 0.0)
		end
		SetVehicleForwardSpeed(newVehicle, speed)
		if copyVelocity then
			SetEntityVelocity(newVehicle, velocity.x, velocity.y, velocity.z)
		end
		SetEntityRotation(newVehicle, rotation, 2)
		Client.Function.Message.Display(GetLabelText(GetDisplayNameFromVehicleModel(model)))
		Client.Function.Weapon.ReloadForRaceAndCreator(ped, false, false, Client.Preference.EnableWeaponInTest)
		Creator.GlobalVar.TestVehicleHandle = newVehicle
		Creator.GlobalVar.IsTransforming = false
	end)
end

function Creator.Function.IsValueValid(axis, value)
	if axis == 1 or axis == 2 then
		if (value <= -16000.0) or (value >= 16000.0) then
			return false
		end
	elseif axis == 3 then
		if (value <= -200.0) or (value >= 2700.0) then
			return false
		end
	end
	return true
end

function Creator.Function.ResetGlobalVariable(str)
	if str == "startingGrid" then
		Creator.StartingGrid.Current = {
			handle = nil,
			x = nil,
			y = nil,
			z = nil,
			heading = nil
		}
	elseif str == "checkpoint" then
		Creator.Checkpoint.Current = {
			x = nil,
			y = nil,
			z = nil,
			heading = nil,
			diameterCollect = nil,
			diameterDraw = nil,
			pitch = nil,
			offset = nil,
			lockDirection = nil,
			isPit = nil,
			isTall = nil,
			tallRadius = nil,
			lowerAlpha = nil,
			isRound = nil,
			isAir = nil,
			isFake = nil,
			isRandom = nil,
			randomClass = nil,
			randomCustom = nil,
			randomSetting = nil,
			isTransform = nil,
			transformIndex = nil,
			isPlaneRot = nil,
			planeRot = nil,
			isWarp = nil
		}
	elseif str == "object" then
		Creator.Object.Current = {
			uniqueId = nil,
			modificationCount = 0,
			hash = nil,
			handle = nil,
			x = nil,
			y = nil,
			z = nil,
			rotX = nil,
			rotY = nil,
			rotZ = nil,
			color = nil,
			prpsba = nil,
			visible = nil,
			collision = nil,
			dynamic = nil
		}
	elseif str == "template" then
		Creator.Template.Current = {}
	elseif str == "fixture" then
		Creator.Fixture.Current = {
			hash = nil,
			handle = nil,
			x = nil,
			y = nil,
			z = nil
		}
	end
end