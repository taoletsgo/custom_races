Client = {}
Race = {}
Creator = {}

-- ======================================
-- Client variables
-- ======================================
Client.FirstLoad = true
Client.CurrentLanguage = GetCurrentLanguage()
Client.ServerId = 0
Client.IsInRace = false
Client.IsInSpectator = false
Client.IsInCreator = false
Client.IsTeleportingInProgress = false
Client.IsNetworkInitialized = false
Client.IsChatInputActive = false
Client.IsVehicleSpawning = false
Client.IsPedSpawning = true
Client.IsCreatorInQuiting = false
Client.IsGameEnhancedVersion = IsGameEnhancedVersion()

Client.Permission = {}
Client.Permission.SpawnVanillaVehicles = false
Client.Permission.SpawnAddOnVehicles = false
Client.Permission.CustomVehicle = false
Client.Permission.SpawnPedAsPlayerModel = false
Client.Permission.Weapon = false
Client.Permission.TeleportInRace = false
Client.Permission.SetConvar = false

Client.Function = {}
Client.Function.Translate = {}
Client.Function.Noclip = {}
Client.Function.Blimp = {}
Client.Function.Busyspinner = {}
Client.Function.Control = {}
Client.Function.Environment = {}
Client.Function.HUD = {}
Client.Function.Math = {}
Client.Function.Message = {}
Client.Function.Player = {}
Client.Function.Recording = {}
Client.Function.Scaleform = {}
Client.Function.Shared = {}
Client.Function.Skin = {}
Client.Function.Stunt = {}
Client.Function.Tattoo = {}
Client.Function.Tuning = {}
Client.Function.Vehicle = {}
Client.Function.Weapon = {}

Client.OpenMenuStart = nil
Client.OpenMenuPressedTime = nil
Client.IsAnyClientMenuVisible = false
Client.IsSkinMenuVisible = false
Client.IsWeaponMenuVisible = false
Client.Menu = {}

Client.Hud = {}
Client.Hud.Loaded = false
Client.Hud.ResetNextFrame = false
Client.Hud.DisableInfoUINextFrame = false
Client.Hud.LastUpdateScaleformTime = nil
Client.Hud.Data = {}
Client.Hud.Data.Logo = nil
Client.Hud.Data.Name = nil
Client.Hud.Data.Discord = nil
Client.Hud.Data.Web = nil
Client.Hud.Data.Count = nil
Client.Hud.Data.Ping = nil
Client.Hud.Race = {}
Client.Hud.Race.InTop = false
Client.Hud.Race.InBottom = true
Client.Hud.Race.LastInTopTime = nil

Client.Player = {}
Client.Player.List = {}
Client.Player.Blips = {}
Client.Player.Names = {}

Client.NUI = {}
Client.NUI.Picker = {}
Client.NUI.Picker.Enable = false
Client.NUI.Picker.Primary = false
Client.NUI.Picker.Secondary = false
Client.NUI.Callback = ""
Client.NUI.CallbackDisable = false
Client.NUI.Loaded = false

Client.Stunt = {}
Client.Stunt.Vehicle = nil
Client.Stunt.VehicleNetId = nil
Client.Stunt.TeleportData = {}
Client.Stunt.TeleportData.X = nil
Client.Stunt.TeleportData.Y = nil
Client.Stunt.TeleportData.Z = nil
Client.Stunt.TeleportData.Heading = nil
Client.Stunt.TeleportData.Speed = 0.0
Client.Stunt.TeleportData.Rotation = vector3(0.0, 0.0, 0.0)
Client.Stunt.TeleportData.Velocity = vector3(0.0, 0.0, 0.0)
Client.Stunt.TeleportData.CamHeading = 0.0
Client.Stunt.TeleportData.HasAdvancedData = false

Client.Noclip = {}
Client.Noclip.Enable = false
Client.Noclip.Index = 3

Client.Vehicle = {}
Client.Vehicle.Preview = {}
Client.Vehicle.Preview.Model = nil
Client.Vehicle.Preview.Props = nil
Client.Vehicle.Preview.Entity = nil
Client.Vehicle.MaxEntitys = 10
Client.Vehicle.SpawnedEntitys = {}
Client.Vehicle.MaxSaves = 50
Client.Vehicle.Model = {}
Client.Vehicle.Model.Vanilla = {}
Client.Vehicle.Model.AddOn = {}
Client.Vehicle.Model.BMX = {}
Client.Vehicle.Model.Crashed = {}
Client.Vehicle.Tuning = {}
Client.Vehicle.Tuning.Entity = 0
Client.Vehicle.Tuning.DoorOpened = false
Client.Vehicle.Tuning.MenuLocked = false
Client.Vehicle.Fix = {}
Client.Vehicle.Fix.LastBmxHandle = nil
Client.Vehicle.Fix.LastBmxJumpTime = nil
Client.Vehicle.Fix.LastBmxVelocityZ = 0.0
Client.Vehicle.List = {}
Client.Vehicle.Classes = {
	[0] = "Compact",
	[1] = "Sedan",
	[2] = "SUV",
	[3] = "Coupe",
	[4] = "Muscle",
	[5] = "Classic",
	[6] = "Sport",
	[7] = "Super",
	[8] = "Motorcycle",
	[9] = "Off-road",
	[10] = "Industrial",
	[11] = "Utility",
	[12] = "Van",
	[13] = "Cycle",
	[14] = "Boat",
	[15] = "Helicopter",
	[16] = "Plane",
	[17] = "Service",
	[18] = "Emergency",
	[19] = "Military",
	[20] = "Commercial",
	[22] = "OpenWheel"
}
Client.Vehicle.FavoriteVehicles = {}
Client.Vehicle.SavedVehicles = {}
Client.Vehicle.AddOnVehicles = {}
Client.Vehicle.Menu = {}
Client.Vehicle.Menu["modEngine"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modBrakes"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modTransmission"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modSuspension"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modArmor"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modTurbo"] = {IsChecked = false}
Client.Vehicle.Menu["modSpoilers"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modFrontBumper"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modRearBumper"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modSideSkirt"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modExhaust"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modFrame"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modGrille"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modHood"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modFender"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modRightFender"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modRoof"] = {List = {}, Index = 1}
Client.Vehicle.Menu["color1"] = {List = {}, Index = 1}
Client.Vehicle.Menu["color2"] = {List = {}, Index = 1}
Client.Vehicle.Menu["pearlescentColor"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modFrontWheelsTypes"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modFrontWheelsTypes_Next"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modCustomFrontWheels"] = {IsChecked = false}
Client.Vehicle.Menu["modCustomBackWheels"] = {IsChecked = false}
Client.Vehicle.Menu["wheelColor"] = {List = {}, Index = 1}
Client.Vehicle.Menu["tyreSmokeColor"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modHorns"] = {List = {}, Index = 1}
Client.Vehicle.Menu["neonColor"] = {List = {}, Index = 1}
Client.Vehicle.Menu["xenonColor"] = {List = {}, Index = 1}
Client.Vehicle.Menu["plateIndex"] = {List = {}, Index = 1}
Client.Vehicle.Menu["windowTint"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modPlateHolder"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modVanityPlate"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modTrimA"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modOrnaments"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modDashboard"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modDial"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modDoorSpeaker"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modSeats"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modSteeringWheel"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modShifterLeavers"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modAPlate"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modSpeakers"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modTrunk"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modHydrolic"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modEngineBlock"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modAirFilter"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modStruts"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modArchCover"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modAerials"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modTrimB"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modTank"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modWindows"] = {List = {}, Index = 1}
Client.Vehicle.Menu["modLivery"] = {List = {}, Index = 1}

Client.Skin = {}
Client.Skin.Saved = {}
Client.Skin.Saved.Data = {}
Client.Skin.Saved.Index = 1
Client.Skin.Camera = {}
Client.Skin.Camera.Handle = nil
Client.Skin.Camera.ZoomOffset = 0.0
Client.Skin.Camera.CamOffset = 0.0
Client.Skin.Camera.RotationAngle = nil
Client.Skin.Camera.RotationSpeed = 2.0
Client.Skin.Slots = {}
Client.Skin.Components = {
	{Id = 2, 			Item1 = "hair_1", 			Item2 = "hair_2", 			ZoomOffset = 0.6, 			CamOffset = 0.65},
	{Id = false, 		Item1 = "hair_color_1", 	Item2 = "hair_color_2", 	ZoomOffset = 0.6, 			CamOffset = 0.65},
	{Id = 8, 			Item1 = "tshirt_1", 		Item2 = "tshirt_2", 		ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 11, 			Item1 = "torso_1", 			Item2 = "torso_2", 			ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 10, 			Item1 = "decals_1", 		Item2 = "decals_2", 		ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 3, 			Item1 = "arms", 			Item2 = "arms_2", 			ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 4, 			Item1 = "pants_1", 			Item2 = "pants_2", 			ZoomOffset = 1.0, 			CamOffset = -0.5},
	{Id = 6, 			Item1 = "shoes_1", 			Item2 = "shoes_2", 			ZoomOffset = 0.8, 			CamOffset = -0.8},
	{Id = 1, 			Item1 = "mask_1", 			Item2 = "mask_2", 			ZoomOffset = 0.6, 			CamOffset = 0.65},
	{Id = 9, 			Item1 = "bproof_1", 		Item2 = "bproof_2", 		ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 7, 			Item1 = "chain_1", 			Item2 = "chain_2", 			ZoomOffset = 0.6, 			CamOffset = 0.65},
	{Id = 5, 			Item1 = "bags_1", 			Item2 = "bags_2", 			ZoomOffset = 0.75, 			CamOffset = 0.15}
}
Client.Skin.Props = {
	{Id = 0, 			Item1 = "helmet_1", 		Item2 = "helmet_2", 		ZoomOffset = 0.6, 			CamOffset = 0.65},
	{Id = 1, 			Item1 = "glasses_1", 		Item2 = "glasses_2", 		ZoomOffset = 0.6, 			CamOffset = 0.65},
	{Id = 6, 			Item1 = "watches_1", 		Item2 = "watches_2", 		ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 7, 			Item1 = "bracelets_1", 		Item2 = "bracelets_2", 		ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 2, 			Item1 = "ears_1", 			Item2 = "ears_2", 			ZoomOffset = 0.4, 			CamOffset = 0.65}
}
Client.Skin.Overlays = {
	{Id = false, 		Item1 = "eye_color", 		Item2 = false, 				Color1 = false, 			Color2 = false, 			ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 2, 			Item1 = "eyebrows_1", 		Item2 = "eyebrows_2", 		Color1 = "eyebrows_3", 		Color2 = "eyebrows_4", 		ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 4, 			Item1 = "makeup_1", 		Item2 = "makeup_2", 		Color1 = "makeup_3", 		Color2 = "makeup_4", 		ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 8, 			Item1 = "lipstick_1", 		Item2 = "lipstick_2", 		Color1 = "lipstick_3", 		Color2 = "lipstick_4", 		ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 10, 			Item1 = "chest_1", 			Item2 = "chest_2", 			Color1 = "chest_3", 		Color2 = false, 			ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 11, 			Item1 = "bodyb_1", 			Item2 = "bodyb_2", 			Color1 = false, 			Color2 = false, 			ZoomOffset = 0.75, 			CamOffset = 0.15},
	{Id = 3, 			Item1 = "age_1", 			Item2 = "age_2", 			Color1 = false, 			Color2 = false, 			ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 0, 			Item1 = "blemishes_1", 		Item2 = "blemishes_2", 		Color1 = false, 			Color2 = false, 			ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 5, 			Item1 = "blush_1", 			Item2 = "blush_2", 			Color1 = "blush_3", 		Color2 = false, 			ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 6, 			Item1 = "complexion_1", 	Item2 = "complexion_2", 	Color1 = false, 			Color2 = false, 			ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 7, 			Item1 = "sun_1", 			Item2 = "sun_2", 			Color1 = false, 			Color2 = false, 			ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 9, 			Item1 = "moles_1", 			Item2 = "moles_2", 			Color1 = false, 			Color2 = false, 			ZoomOffset = 0.4, 			CamOffset = 0.65},
	{Id = 1, 			Item1 = "beard_1", 			Item2 = "beard_2", 			Color1 = "beard_3", 		Color2 = "beard_4", 		ZoomOffset = 0.4, 			CamOffset = 0.65}
}
Client.Skin.Tattoo = {}
Client.Skin.Tattoo.Zones = {"ZONE_TORSO", "ZONE_HEAD", "ZONE_LEFT_ARM", "ZONE_RIGHT_ARM", "ZONE_LEFT_LEG", "ZONE_RIGHT_LEG"}
Client.Skin.Tattoo.ZoneData = {}
Client.Skin.Tattoo.ZoneData.Male = {}
Client.Skin.Tattoo.ZoneData.Female = {}
Client.Skin.Tattoo.Current = {}
Client.Skin.Model = {}
Client.Skin.Model.Animal = {}
Client.Skin.Model.Animal.FilterStr = ""
Client.Skin.Model.Animal.FilterCount = 0
Client.Skin.Model.Animal.Data = {
	{label = "animal_boar", 						model = `a_c_boar`},
	{label = "animal_cat_01", 						model = `a_c_cat_01`},
	{label = "animal_cat_02", 						model = `a_c_cat_02`},
	{label = "animal_chickenhawk", 					model = `a_c_chickenhawk`},
	{label = "animal_chimp", 						model = `a_c_chimp`},
	{label = "animal_chop", 						model = `a_c_chop`},
	{label = "animal_cormorant", 					model = `a_c_cormorant`},
	{label = "animal_cow", 							model = `a_c_cow`},
	{label = "animal_coyote", 						model = `a_c_coyote`},
	{label = "animal_crow", 						model = `a_c_crow`},
	{label = "animal_deer", 						model = `a_c_deer`},
	{label = "animal_dolphin", 						model = `a_c_dolphin`},
	{label = "animal_fish", 						model = `a_c_fish`},
	{label = "animal_hen", 							model = `a_c_hen`},
	{label = "animal_humpback", 					model = `a_c_humpback`},
	{label = "animal_husky", 						model = `a_c_husky`},
	{label = "animal_killerwhale", 					model = `a_c_killerwhale`},
	{label = "animal_mtlion", 						model = `a_c_mtlion`},
	{label = "animal_pig", 							model = `a_c_pig`},
	{label = "animal_pigeon", 						model = `a_c_pigeon`},
	{label = "animal_poodle", 						model = `a_c_poodle`},
	{label = "animal_pug", 							model = `a_c_pug`},
	{label = "animal_rabbit_01", 					model = `a_c_rabbit_01`},
	{label = "animal_rat", 							model = `a_c_rat`},
	{label = "animal_retriever", 					model = `a_c_retriever`},
	{label = "animal_rhesus", 						model = `a_c_rhesus`},
	{label = "animal_rottweiler", 					model = `a_c_rottweiler`},
	{label = "animal_rottweiler_02", 				model = `a_c_rottweiler_02`},
	{label = "animal_seagull", 						model = `a_c_seagull`},
	{label = "animal_sharkhammer", 					model = `a_c_sharkhammer`},
	{label = "animal_sharktiger", 					model = `a_c_sharktiger`},
	{label = "animal_shepherd", 					model = `a_c_shepherd`},
	{label = "animal_stingray", 					model = `a_c_stingray`},
	{label = "animal_westy", 						model = `a_c_westy`}
}
Client.Skin.Model.AddOn = {}
Client.Skin.Model.AddOn.FilterStr = ""
Client.Skin.Model.AddOn.FilterCount = 0
Client.Skin.Model.AddOn.Data = {}
Client.Skin.Menu = {}
Client.Skin.Menu["sex"] = {List = {}, Index = 0}
Client.Skin.Menu["face"] = {List = {}, Index = 0}
Client.Skin.Menu["face2"] = {List = {}, Index = 0}
Client.Skin.Menu["faceMix"] = {List = {}, Index = 0}
Client.Skin.Menu["skin"] = {List = {}, Index = 0}
Client.Skin.Menu["skin2"] = {List = {}, Index = 0}
Client.Skin.Menu["skinMix"] = {List = {}, Index = 0}
for i = 0, 19 do
	Client.Skin.Menu["faceFeature_" .. i] = {List = {}, Index = 0}
end
Client.Skin.Menu["hair_1"] = {List = {}, Index = 0}
Client.Skin.Menu["hair_2"] = {List = {}, Index = 0}
Client.Skin.Menu["hair_color_1"] = {List = {}, Index = 0}
Client.Skin.Menu["hair_color_2"] = {List = {}, Index = 0}
Client.Skin.Menu["tshirt_1"] = {List = {}, Index = 0}
Client.Skin.Menu["tshirt_2"] = {List = {}, Index = 0}
Client.Skin.Menu["torso_1"] = {List = {}, Index = 0}
Client.Skin.Menu["torso_2"] = {List = {}, Index = 0}
Client.Skin.Menu["decals_1"] = {List = {}, Index = 0}
Client.Skin.Menu["decals_2"] = {List = {}, Index = 0}
Client.Skin.Menu["arms"] = {List = {}, Index = 0}
Client.Skin.Menu["arms_2"] = {List = {}, Index = 0}
Client.Skin.Menu["pants_1"] = {List = {}, Index = 0}
Client.Skin.Menu["pants_2"] = {List = {}, Index = 0}
Client.Skin.Menu["shoes_1"] = {List = {}, Index = 0}
Client.Skin.Menu["shoes_2"] = {List = {}, Index = 0}
Client.Skin.Menu["mask_1"] = {List = {}, Index = 0}
Client.Skin.Menu["mask_2"] = {List = {}, Index = 0}
Client.Skin.Menu["bproof_1"] = {List = {}, Index = 0}
Client.Skin.Menu["bproof_2"] = {List = {}, Index = 0}
Client.Skin.Menu["chain_1"] = {List = {}, Index = 0}
Client.Skin.Menu["chain_2"] = {List = {}, Index = 0}
Client.Skin.Menu["bags_1"] = {List = {}, Index = 0}
Client.Skin.Menu["bags_2"] = {List = {}, Index = 0}
Client.Skin.Menu["helmet_1"] = {List = {1}, Index = -1}
Client.Skin.Menu["helmet_2"] = {List = {}, Index = 0}
Client.Skin.Menu["glasses_1"] = {List = {1}, Index = -1}
Client.Skin.Menu["glasses_2"] = {List = {}, Index = 0}
Client.Skin.Menu["watches_1"] = {List = {1}, Index = -1}
Client.Skin.Menu["watches_2"] = {List = {}, Index = 0}
Client.Skin.Menu["bracelets_1"] = {List = {1}, Index = -1}
Client.Skin.Menu["bracelets_2"] = {List = {}, Index = 0}
Client.Skin.Menu["ears_1"] = {List = {1}, Index = -1}
Client.Skin.Menu["ears_2"] = {List = {}, Index = 0}
Client.Skin.Menu["eye_color"] = {List = {}, Index = 0}
Client.Skin.Menu["eyebrows_1"] = {List = {}, Index = 0}
Client.Skin.Menu["eyebrows_2"] = {List = {}, Index = 0}
Client.Skin.Menu["eyebrows_3"] = {List = {}, Index = 0}
Client.Skin.Menu["eyebrows_4"] = {List = {}, Index = 0}
Client.Skin.Menu["makeup_1"] = {List = {}, Index = 0}
Client.Skin.Menu["makeup_2"] = {List = {}, Index = 0}
Client.Skin.Menu["makeup_3"] = {List = {}, Index = 0}
Client.Skin.Menu["makeup_4"] = {List = {}, Index = 0}
Client.Skin.Menu["lipstick_1"] = {List = {}, Index = 0}
Client.Skin.Menu["lipstick_2"] = {List = {}, Index = 0}
Client.Skin.Menu["lipstick_3"] = {List = {}, Index = 0}
Client.Skin.Menu["lipstick_4"] = {List = {}, Index = 0}
Client.Skin.Menu["chest_1"] = {List = {}, Index = 0}
Client.Skin.Menu["chest_2"] = {List = {}, Index = 0}
Client.Skin.Menu["chest_3"] = {List = {}, Index = 0}
Client.Skin.Menu["bodyb_1"] = {List = {}, Index = 0}
Client.Skin.Menu["bodyb_2"] = {List = {}, Index = 0}
Client.Skin.Menu["age_1"] = {List = {}, Index = 0}
Client.Skin.Menu["age_2"] = {List = {}, Index = 0}
Client.Skin.Menu["blemishes_1"] = {List = {}, Index = 0}
Client.Skin.Menu["blemishes_2"] = {List = {}, Index = 0}
Client.Skin.Menu["blush_1"] = {List = {}, Index = 0}
Client.Skin.Menu["blush_2"] = {List = {}, Index = 0}
Client.Skin.Menu["blush_3"] = {List = {}, Index = 0}
Client.Skin.Menu["complexion_1"] = {List = {}, Index = 0}
Client.Skin.Menu["complexion_2"] = {List = {}, Index = 0}
Client.Skin.Menu["sun_1"] = {List = {}, Index = 0}
Client.Skin.Menu["sun_2"] = {List = {}, Index = 0}
Client.Skin.Menu["moles_1"] = {List = {}, Index = 0}
Client.Skin.Menu["moles_2"] = {List = {}, Index = 0}
Client.Skin.Menu["beard_1"] = {List = {}, Index = 0}
Client.Skin.Menu["beard_2"] = {List = {}, Index = 0}
Client.Skin.Menu["beard_3"] = {List = {}, Index = 0}
Client.Skin.Menu["beard_4"] = {List = {}, Index = 0}

Client.Ped = {}
Client.Ped.Config = {}
Client.Ped.Config.FastSwim = false
Client.Ped.Config.FastRun = false
Client.Ped.Config.SuperJump = false
Client.Ped.Config.BeastMode = false
Client.Ped.Status = {}
Client.Ped.Status.Visible = true
Client.Ped.Status.IsJumping = false
Client.Ped.Status.IsFalling = false
Client.Ped.Status.WasJumping = false
Client.Ped.Status.WasFalling = false
Client.Ped.Status.WasDoingBeastJump = false

Client.Weapon = {}
Client.Weapon.Categories = {}
Client.Weapon.All = {}
Client.Weapon.Saved = {}
Client.Weapon.Changed = {}
Client.Weapon.LastEditing = {}
Client.Weapon.LastEditing.Name = nil
Client.Weapon.LastEditing.Hash = nil
Client.Weapon.CurrentEditing = {}
Client.Weapon.CurrentEditing.Name = nil
Client.Weapon.CurrentEditing.Hash = nil
Client.Weapon.EditingEnable = false

Client.Busyspinner = {}
Client.Busyspinner.Status = nil
Client.Busyspinner.Coefficient = 0
Client.Busyspinner.Len = 0
Client.Busyspinner.LoadCount = 0.0
Client.Busyspinner.LastCount = nil
Client.Busyspinner.Showed = false

Client.Blimp = {}
Client.Blimp.Scaleform = nil
Client.Blimp.Rendertarget = nil

Client.Preference = {}
Client.Preference.AdvancedTeleport = false
Client.Preference.Traffic = false
Client.Preference.EnableAmbientSound = false
Client.Preference.SimulateAltF4 = true
Client.Preference.DisableMotoMelee = true
Client.Preference.FixBmxFloat = true
Client.Preference.EnableOnlineMap = true
Client.Preference.EnableVanillaMinimap = true
Client.Preference.DeleteWhenSpawnVehicle = true
Client.Preference.KeepVehicleInvincible = false
Client.Preference.RepairVehicleWhenTp = false
Client.Preference.WeaponLoaded = false
Client.Preference.InfiniteAmmo = false
Client.Preference.ObjectLowerAlphaChecked = false
Client.Preference.EnableWeaponInTest = false

Client.Time = {}
Client.Time.Lock = false
Client.Time.CurrentHour = 12
Client.Time.Hours = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23}
Client.Time.CurrentMinute = 0
Client.Time.Minutes = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59}
Client.Time.CurrentSecond = 0
Client.Time.Seconds = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59}
Client.Time.ServerSide = {}
Client.Time.ServerSide.SyncDrivers = nil
Client.Time.ServerSide.SyncPlayers = nil
Client.Time.ServerSide.ScriptStartTime = 0

Client.Weather = {}
Client.Weather.Current = "CLEAR"
Client.Weather.Types = {"CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST", "RAIN", "CLEARING", "THUNDER", "SMOG", "FOGGY", "XMAS", "SNOW", "SNOWLIGHT", "BLIZZARD", "HALLOWEEN", "NEUTRAL"}

Client.Shared = {}
Client.Shared.Dimensions = {}
Client.Shared.Dimensions.Min = {}
Client.Shared.Dimensions.Max = {}
Client.Shared.Dimensions.Radius = {}
Client.Shared.Object = {
	Speedup = {
		[GetHashKey("stt_prop_track_speedup")] = true,
		[GetHashKey("stt_prop_track_speedup_t1")] = true,
		[GetHashKey("stt_prop_track_speedup_t2")] = true,
		[GetHashKey("stt_prop_stunt_tube_speed")] = true,
		[GetHashKey("stt_prop_stunt_tube_speedb")] = true,
		[GetHashKey("ar_prop_ar_speed_ring")] = true,
		[GetHashKey("ar_prop_ar_tube_speed")] = true,
		[GetHashKey("ar_prop_ar_tube_2x_speed")] = true,
		[GetHashKey("ar_prop_ar_tube_4x_speed")] = true
	},
	SlowDown = {
		[GetHashKey("gr_prop_gr_target_1_01a")] = true,
		[GetHashKey("gr_prop_gr_target_2_04a")] = true,
		[GetHashKey("gr_prop_gr_target_3_03a")] = true,
		[GetHashKey("gr_prop_gr_target_4_01a")] = true,
		[GetHashKey("gr_prop_gr_target_5_01a")] = true,
		[GetHashKey("gr_prop_gr_target_small_01a")] = true,
		[GetHashKey("gr_prop_gr_target_small_03a")] = true,
		[GetHashKey("gr_prop_gr_target_small_02a")] = true,
		[GetHashKey("gr_prop_gr_target_small_06a")] = true,
		[GetHashKey("gr_prop_gr_target_small_07a")] = true,
		[GetHashKey("gr_prop_gr_target_small_04a")] = true,
		[GetHashKey("gr_prop_gr_target_small_05a")] = true,
		[GetHashKey("gr_prop_gr_target_long_01a")] = true,
		[GetHashKey("gr_prop_gr_target_large_01a")] = true,
		[GetHashKey("gr_prop_gr_target_trap_01a")] = true,
		[GetHashKey("gr_prop_gr_target_trap_02a")] = true,
		[GetHashKey("stt_prop_track_slowdown")] = true,
		[GetHashKey("stt_prop_track_slowdown_t1")] = true,
		[GetHashKey("stt_prop_track_slowdown_t2")] = true
	},
	Arena = {
		[GetHashKey("xs_prop_arena_flipper_small_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_flipper_xl_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_flipper_large_01a")] = true,
		[GetHashKey("xs_prop_arena_flipper_xl_01a")] = true,
		[GetHashKey("xs_prop_arena_flipper_large_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_flipper_small_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_flipper_xl_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_flipper_large_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_flipper_small_01a")] = true,
		[GetHashKey("xs_prop_arena_wall_rising_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_wall_rising_01a")] = true,
		[GetHashKey("xs_prop_arena_wall_rising_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_wall_01b")] = true,
		[GetHashKey("xs_prop_arena_wall_02a")] = true,
		[GetHashKey("xs_prop_arena_wall_01c")] = true,
		[GetHashKey("xs_prop_arena_wall_01a")] = true,
		[GetHashKey("xs_prop_arena_wall_rising_02a_sf")] = true,
		[GetHashKey("xs_prop_arena_wall_rising_02a_wl")] = true,
		[GetHashKey("xs_prop_arena_wall_02a_wl")] = true,
		[GetHashKey("xs_prop_arena_wall_02c_wl")] = true,
		[GetHashKey("xs_prop_arena_wall_02b_wl")] = true,
		[GetHashKey("xs_prop_arena_wall_02a_sf")] = true,
		[GetHashKey("xs_prop_arena_wall_rising_02a")] = true,
		[GetHashKey("xs_prop_arena_bollard_side_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_bollard_side_01a")] = true,
		[GetHashKey("xs_prop_arena_bollard_side_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_bollard_rising_01a")] = true,
		[GetHashKey("xs_prop_arena_bollard_rising_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_bollard_rising_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_bollard_rising_01b")] = true,
		[GetHashKey("xs_prop_arena_bollard_rising_01b_sf")] = true,
		[GetHashKey("xs_prop_arena_bollard_rising_01b_wl")] = true,
		[GetHashKey("xs_prop_arena_turntable_03a")] = true,
		[GetHashKey("xs_prop_arena_turntable_02a")] = true,
		[GetHashKey("xs_prop_arena_turntable_01a")] = true,
		[GetHashKey("xs_prop_arena_turntable_b_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_turntable_b_01a")] = true,
		[GetHashKey("xs_prop_arena_turntable_03a_sf")] = true,
		[GetHashKey("xs_prop_arena_turntable_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_turntable_02a_wl")] = true,
		[GetHashKey("xs_prop_arena_turntable_03a_wl")] = true,
		[GetHashKey("xs_prop_arena_turntable_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_turntable_02a_sf")] = true,
		[GetHashKey("xs_prop_arena_turntable_b_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_01a_wl")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_02a")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_03a_sf")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_04a")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_02a_sf")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_03a_wl")] = true,
		[GetHashKey("xs_prop_arena_pit_double_01b_wl")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_01a")] = true,
		[GetHashKey("xs_prop_arena_pit_double_01b")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_03a")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_04a_sf")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_04a_wl")] = true,
		[GetHashKey("xs_prop_arena_pit_fire_02a_wl")] = true,
		[GetHashKey("xs_prop_arena_pit_double_01a_sf")] = true,
		[GetHashKey("xs_prop_arena_pit_double_01b_sf")] = true,
		[GetHashKey("xs_prop_arena_pit_double_01a_wl")] = true
	},
	Explode = {
		[GetHashKey("xm_prop_x17_mine_01a")] = true,
		[GetHashKey("xm_prop_x17_mine_02a")] = true,
		[GetHashKey("xm_prop_x17_mine_03a")] = true
	},
	Firework = {
		[GetHashKey("ind_prop_firework_01")] = true,
		[GetHashKey("ind_prop_firework_02")] = true,
		[GetHashKey("ind_prop_firework_03")] = true,
		[GetHashKey("ind_prop_firework_04")] = true
	},
	NoCollision = {
		[GetHashKey("ar_prop_ar_checkpoint_xxs")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_xs")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_s")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_m")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_l")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_crn")] = true,
		[GetHashKey("ar_prop_ar_checkpoints_crn_5d")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_crn_15d")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_crn_30d")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_crn02")] = true,
		[GetHashKey("ar_prop_ar_checkpoint_fork")] = true
	},
	Effect = {
		[GetHashKey("stt_prop_hoop_small_01")] = 1,
		[GetHashKey("ar_prop_ar_hoop_med_01")] = 2,
		[GetHashKey("stt_prop_hoop_constraction_01a")] = 3
	}
}
Client.Shared.Vanilla = {
	-- copyright @ JoraEmin52's modTool
	-- After the game update, we can find new vehicles from modTool and manually add them here
	[0] = {
		class = "Compacts",
		aveh = {"blista", "dilettante", "issi2", "prairie"},
		adlc = {"rhapsody", "panto", "brioso", "issi3", "kanjo", "asbo", "club", "brioso2", "weevil", "brioso3", "blista"}
	},
	[1] = {
		class = "Sedans",
		aveh = {"asea", "asterope", "fugitive", "premier", "primo", "schafter2", "stanier", "superd", "surge", "tailgater", "washington"},
		adlc = {"glendale", "warrener", "primo2", "schafter3", "schafter5", "schafter4", "schafter6", "cog55", "cog552", "cognoscenti", "cognoscenti2", "stafford", "glendale2", "warrener2", "tailgater2", "deity", "cinquemila", "rhinehart", "asterope2", "vorschlaghammer", "chavosv6", "hardy", "minimus", "sentinel6", "ingot", "intruder", "stratum", "merula"}
	},
	[2] = {
		class = "SUV",
		aveh = {"baller", "baller2", "bjxl", "cavalcade2", "crusader", "dubsta", "granger", "gresley", "landstalker", "mesa", "pranger", "radi", "seminole", "serrano", "dubsta3"},
		adlc = {"huntley", "baller3", "baller4", "baller5", "baller6", "xls", "xls2", "contender", "patriot2", "fq2", "habanero", "toros", "novak", "rebla", "landstalker2", "seminole2", "squaddie", "granger2", "astron", "baller7", "jubilee", "iwagen", "issi8", "aleutian", "cavalcade3", "baller8", "dorado", "vivanite", "castigator", "woodlander", "everon3", "cavalcade", "dubsta2", "rocoto", "warden", "estride"}
	},
	[3] = {
		class = "Coupes",
		aveh = {"cogcabrio", "exemplar", "f620", "felon2", "jackal", "oracle2", "sentinel2"},
		adlc = {"windsor", "windsor2", "previon", "kanjosj", "postlude", "fr36", "eurosx32", "felon", "oracle", "sentinel", "zion", "zion2"}
	},
	[4] = {
		class = "Mucle",
		aveh = {"buccaneer", "dominator", "gauntlet", "phoenix", "picador", "ruiner", "sabregt", "vigero", "hotknife"},
		adlc = {"blade", "ratloader2", "slamvan", "dukes", "stalion", "virgo", "coquette3", "chino", "faction", "faction2", "moonbeam2", "chino2", "voodoo", "buccaneer2", "nightshade", "faction3", "slamvan3", "virgo3", "virgo2", "sabregt2", "dominator2", "gauntlet2", "stalion2", "dukes2", "yosemite", "hermes", "hustler", "ellie", "dominator3", "vamos", "impaler", "deviant", "tulip", "clique", "gauntlet3", "gauntlet4", "peyote2", "yosemite2", "dukes3", "gauntlet5", "manana2", "dominator7", "dominator8", "buffalo4", "weevil2", "vigero2", "ruiner4", "greenwood", "eudora", "tulip2", "tahoma", "broadway", "brigham", "clique2", "buffalo5", "dominator9", "impaler6", "vigero3", "dominator10", "impaler5", "tampa4"}
	},
	[5] = {
		class = "Classics",
		aveh = {"jb700", "monroe", "stinger", "ztype"},
		adlc = {"btype", "pigalle", "coquette2", "casco", "feltzer3", "mamba", "tornado5", "tornado6", "infernus2", "turismo2", "cheetah2", "torero", "retinue", "rapidgt3", "savestra", "viseris", "gt500", "z190", "fagaloa", "cheburek", "michelli", "jester3", "swinger", "zion3", "dynasty", "nebula", "retinue2", "btype2", "peyote3", "ardent", "jb7002", "coquette5", "uranus", "cheetah3", "gt750", "itali2", "btype3", "astrale"}
	},
	[6] = {
		class = "Sports",
		aveh = {"ninef2", "banshee", "carbonizzare", "comet2", "coquette", "feltzer2", "fusilade", "futo", "rapidgt2", "sultan", "khamelion"},
		adlc = {"alpha", "jester", "massacro", "furoregt", "jester2", "massacro2", "blista2", "kuruma", "kuruma2", "verlierer2", "bestiagts", "seven70", "omnis", "tropos", "lynx", "tampa2", "buffalo3", "raptor", "elegy2", "elegy", "comet3", "specter", "specter2", "ruston", "raiden", "pariah", "comet4", "sentinel3", "streiter", "revolter", "neon", "comet5", "hotring", "gb200", "flashgt", "schlagen", "italigto", "drafter", "issi7", "neo", "locust", "jugular", "paragon", "schwarzer", "imorgon", "sugoi", "vstr", "komoda", "sultan2", "penumbra2", "coquette4", "italirsx", "calico", "jester4", "zr350", "remus", "vectre", "cypher", "comet6", "rt3000", "sultan3", "futo2", "euros", "growler", "comet7", "paragon2", "corsita", "tenf", "tenf2", "sm722", "sentinel4", "omnisegt", "panthere", "everon2", "r300", "gauntlet6", "stingertt", "coureur", "envisage", "niobe", "paragon3", "jester5", "coquette6", "banshee3", "sentinel5", "rapidgt4", "keitora", "ninef", "buffalo2", "buffalo", "penumbra", "rapidgt", "surano", "blista3", "cartuccia"}
	},
	[7] = {
		class = "Super",
		aveh = {"adder", "bullet", "cheetah", "entityxf", "infernus", "vacca", "voltic"},
		adlc = {"turismor", "zentorno", "osiris", "t20", "banshee2", "sultanrs", "reaper", "fmj", "prototipo", "pfister811", "le7b", "tyrus", "sheava", "penetrator", "tempesta", "italigtb", "italigtb2", "nero", "nero2", "gp1", "vagner", "xa21", "visione", "cyclone", "sc1", "autarch", "taipan", "entity2", "tezeract", "tyrant", "deveste", "thrax", "zorrusso", "krieger", "emerus", "s80", "furia", "tigon", "ignus", "zeno", "champion", "lm87", "torero2", "entity3", "virtue", "turismo3", "pipistrello", "suzume", "luiva", "xtreme", "fmj2", "velenogt", "lrcgt", "horus"}
	},
	[8] = {
		class = "Bikes",
		aveh = {"akuma", "bagger", "bati", "bati2", "blazer", "daemon", "double", "nemesis", "pcj", "ruffian", "sanchez2", "sanchez", "vader", "carbonrs"},
		adlc = {"thrust", "sovereign", "innovation", "hakuchou", "enduro", "lectro", "vindicator", "bf400", "gargoyle", "cliffhanger", "hakuchou2", "defiler", "chimera", "zombieb", "avarus", "nightblade", "zombiea", "wolfsbane", "manchez", "ratbike", "faggio3", "faggio", "daemon2", "vortex", "shotaro", "esskey", "diablous", "diablous2", "fcr", "fcr2", "sanctus", "rrocket", "stryder", "manchez2", "shinobi", "reever", "powersurge", "sanchez2", "pizzaboy"}
	},
	[9] = {
		class = "OffRoad",
		aveh = {"bfinjection", "baller", "blazer", "dloader", "dune", "patriot", "sanchez2", "sandking", "bodhi2", "dubsta", "mesa", "rebel", "sandking2", "tornado4", "sanchez", "dubsta3"},
		adlc = {"bifta", "kalahari", "paradise", "monster", "marshall", "insurgent2", "guardian", "brawler", "trophytruck", "trophytruck2", "bf400", "rallytruck", "blazer4", "riata", "kamacho", "freecrawler", "menacer", "hellion", "caracara2", "rancherxl", "outlaw", "everon", "zhaba", "vagrant", "yosemite3", "rebel2", "winky", "verus", "manchez2", "nightshark", "patriot3", "draugur", "boor", "l35", "ratel", "monstrociti", "terminus", "yosemite1500", "firebolt", "l352", "blazer3"}
	},
	[10] = {
		class = "Industrial",
		aveh = {"bulldozer", "cutter", "dump", "handler", "mixer"}
	},
	[11] = {
		class = "Utility",
		aveh = {"airtug", "caddy", "faggio2", "tractor2", "mower"},
		adlc = {"slamtruck", "keitora", "caddy2", "docktug", "tractor3", "tractor", "utillitruck", "utillitruck2", "utillitruck3"}
	},
	[12] = {
		class = "Vans",
		aveh = {"boxville", "burrito2", "camper", "speedo2", "journey", "pony", "minivan", "rumpo", "surfer", "taco", "youga", "mule3", "surfer3"},
		adlc = {"gburrito2", "minivan2", "rumpo3", "youga2", "speedo4", "mule4", "bison3", "boxville", "burrito", "burrito2", "pony", "youga3", "speedo2", "journey2", "surfer3", "benson2", "boxville6", "bobcatxl", "laufer"}
	},
	[13] = {
		class = "Cycles",
		aveh = {"bmx", "cruiser", "scorcher", "tribike", "tribike2", "tribike3"},
		adlc = {"inductor", "inductor2", "fixter"}
	},
	[14] = {
		class = ""
	},
	[15] = {
		class = "Special",
		adlc = {"blazer5", "ruiner2", "voltic2", "deluxo", "stromberg", "thruster", "oppressor", "vigilante", "oppressor2", "scramjet", "rcbandito", "toreador", "dune2"}
	},
	[16] = {
		class = "Weaponised",
		adlc = {"technical2", "technical3", "technical", "dune3", "boxville5", "limo2", "barrage", "halftrack", "apc", "caracara", "insurgent3", "insurgent", "menacer", "caracara3"}
	},
	[17] = {
		class = "Contender",
		adlc = {"bruiser", "brutus", "cerberus", "deathbike", "dominator4", "impaler2", "imperator", "issi4", "monster3", "scarab", "slamvan4", "zr380"}
	},
	[18] = {
		class = "Open Wheel",
		adlc = {"formula", "formula2", "openwheel1", "openwheel2"}
	},
	[19] = {
		class = "Go-Kart",
		adlc = {"veto", "veto2"}
	},
	[20] = {
		class = "Car Club",
		adlc = {"calico", "jester4", "zr350", "remus", "vectre", "cypher", "dominator7", "comet6", "warrener2", "rt3000", "tailgater2", "sultan3", "futo2", "dominator8", "previon", "euros", "growler", "kanjosj", "postlude", "jester5", "hardy", "cheetah3"}
	},
	-- ==============================================================================================================
	-- To be added later, I'm lazy
	-- Perhaps you can find the correct names from modTool and add them here
	[21] = {
		class = "HSW"
	},
	[22] = {
		class = "HSWT1"
	},
	[23] = {
		class = "HSWT2"
	},
	[24] = {
		class = "HSWT3"
	},
	-- ==============================================================================================================
	[25] = {
		class = "Drift",
		adlc = {"drifttampa", "driftyosemite", "drifteuros", "driftfuto", "driftjester", "driftremus", "driftzr350", "driftfr36", "driftcypher", "driftvorschlag", "driftsentinel", "driftnebula", "driftfuto2", "driftcheburek", "driftjester3", "driftdominator10", "driftgauntlet4", "driftl352", "driftchavosv6", "drifthardy", "driftkeitora", "driftdominator9", "driftrt3000", "driftsentinel2", "driftcoquette", "driftdominator8", "driftelegy"}
	},
	[26] = {
		class = ""
	},
	[27] = {
		class = ""
	}
}

-- ======================================
-- Race variables
-- ======================================
Race.Function = {}
Race.Function.Camera = {}
Race.Function.Player = {}
Race.Function.Pool = {}
Race.Function.Teleport = {}
Race.Function.Xbox = {}

Race.Status = "freemode"
Race.EnableXboxController = false

Race.Cache = {}
Race.Cache.InRoom = false
Race.Cache.InVehicleUI = false
Race.Cache.JoinPoint = nil
Race.Cache.JoinHeading = nil
Race.Cache.JoinVehicleNetId = nil
Race.Cache.IsSyncLocked = false
Race.Cache.IsRespawningInProgress = false
Race.Cache.IsTransformingInProgress = false
Race.Cache.IsTeleportingInProgress = false
Race.Cache.IsOverClouds = false
Race.Cache.HasCheated = false
Race.Cache.Camera = nil
Race.Cache.VehicleProps = {}

Race.ArenaProps = {}
Race.ExplodeProps = {}
Race.FireworkProps = {}

Race.HUD = {}
Race.HUD.Bottom = {}
Race.HUD.Position = {}
Race.HUD.Position.Showed = false
Race.HUD.Position.Page = 1
Race.HUD.Respawn = {}
Race.HUD.Respawn.Showed = false
Race.HUD.Respawn.Time = 0
Race.HUD.Respawn.TimeStart = 0
Race.HUD.Respawn.Holding = false
Race.HUD.Respawn.HasRespawned = false

Race.GlobalVar = {}
Race.GlobalVar.TransformIsParachute = false
Race.GlobalVar.TransformIsBeast = false
Race.GlobalVar.WasDoingBeastJump = false
Race.GlobalVar.TotalCheckpointsTouched = 0
Race.GlobalVar.ActualCheckpoint = 0
Race.GlobalVar.LastCheckpointPair = 0 -- 0 = primary / 1 = secondary
Race.GlobalVar.ActualLap = 0
Race.GlobalVar.StartLapTime = 0
Race.GlobalVar.ActualLapTime = 0
Race.GlobalVar.TotalTimeStart = 0
Race.GlobalVar.TotalRaceTime = 0

Race.SpectateData = {}
Race.SpectateData.IsFadeOut = false
Race.SpectateData.FadeOutTime = nil
Race.SpectateData.PlayerId = nil
Race.SpectateData.Ped = nil
Race.SpectateData.Index = 0
Race.SpectateData.Players = {}

Race.SyncData = {}
Race.SyncData.ActualLap = 1
Race.SyncData.ActualCheckpoint = 1
Race.SyncData.Vehicle = ""
Race.SyncData.LastLap = 0
Race.SyncData.BestLap = 0
Race.SyncData.TotalRaceTime = 0
Race.SyncData.TotalCheckpointsTouched = 0
Race.SyncData.LastCheckpointPair = 0

Race.Track = {}
Race.Track.Data = {}
Race.Track.DataOutdated = true
Race.Track.IsQueryingData = false
Race.Track.Bookmarked = {}
Race.Track.Played = {}
Race.Track.Finished = {}
Race.Track.Current = {}
Race.Track.Current.RoomId = nil
Race.Track.Current.OwnerName = ""
Race.Track.Current.Title = ""
Race.Track.Current.BlimpText = ""
Race.Track.Current.Laps = 1
Race.Track.Current.Mode = ""
Race.Track.Current.RoomData = nil
Race.Track.Current.PlayerCount = 1
Race.Track.Current.Drivers = {}
Race.Track.Current.LastVehicle = nil
Race.Track.Current.DefaultVehicle = nil
Race.Track.Current.RandomVehicles = {}
Race.Track.Current.GridPositionIndex = 1
Race.Track.Current.StartingGrid = {}
Race.Track.Current.StartingGrid[1] = {}
Race.Track.Current.StartingGrid[1].x = 0.0
Race.Track.Current.StartingGrid[1].y = 0.0
Race.Track.Current.StartingGrid[1].z = 0.0
Race.Track.Current.StartingGrid[1].heading = 0.0
Race.Track.Current.Checkpoints = {}
Race.Track.Current.Checkpoints_2 = {}
Race.Track.Current.TransformVehicles = {}
Race.Track.Current.Fixtures = {}
Race.Track.Current.Firework = {}
Race.Track.Current.Firework.Name = "scr_indep_firework_trailburst"
Race.Track.Current.Firework.R = 255
Race.Track.Current.Firework.G = 255
Race.Track.Current.Firework.B = 255

-- ======================================
-- Creator variables
-- ======================================
Creator.Menu = {}

Creator.Function = {}
Creator.Function.Camera = {}
Creator.Function.Multiplayer = {}
Creator.Function.Object = {}
Creator.Function.Pool = {}
Creator.Function.Track = {}

Creator.Camera = {}
Creator.Camera.Handle = nil
Creator.Camera.Position = nil
Creator.Camera.Rotation = nil

Creator.Track = {}
Creator.Track.Index = 1
Creator.Track.FilterStr = ""
Creator.Track.All = {
	[1] = {
		class = "published-races",
		data = {}
	},
	[2] = {
		class = "saved-races",
		data = {}
	}
}
Creator.Track.Current = {}
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

Creator.Speed = {}
Creator.Speed.Key = nil
Creator.Speed.CamPos = {}
Creator.Speed.CamPos.Index = 1
Creator.Speed.CamPos.Value = {
	{"1x", 0.5},
	{"2x", 1.0},
	{"5x", 2.5},
	{"10x", 5.0},
	{"20x", 10.0}
}
Creator.Speed.CamRot = {}
Creator.Speed.CamRot.Index = 1
Creator.Speed.CamRot.Value = {
	{"1x", 1.0},
	{"2x", 2.0},
	{"5x", 5.0}
}
Creator.Speed.GridOffset = {}
Creator.Speed.GridOffset.Index = 3
Creator.Speed.GridOffset.Value = {
	{"0.001x", 0.001},
	{"0.01x", 0.01},
	{"0.1x", 0.1},
	{"1x", 1.0},
	{"10x", 10.0}
}
Creator.Speed.CheckpointOffset = {}
Creator.Speed.CheckpointOffset.Index = 3
Creator.Speed.CheckpointOffset.Value = {
	{"0.001x", 0.001},
	{"0.01x", 0.01},
	{"0.1x", 0.1},
	{"1x", 1.0},
	{"10x", 10.0},
	{"100x", 100.0}
}
Creator.Speed.PropOffset = {}
Creator.Speed.PropOffset.Index = 3
Creator.Speed.PropOffset.Value = {
	{"0.001x", 0.001},
	{"0.01x", 0.01},
	{"0.1x", 0.1},
	{"1x", 1.0},
	{"10x", 10.0},
	{"100x", 100.0}
}
Creator.Speed.TemplateOffset = {}
Creator.Speed.TemplateOffset.Index = 3
Creator.Speed.TemplateOffset.Value = {
	{"0.001x", 0.001},
	{"0.01x", 0.01},
	{"0.1x", 0.1},
	{"1x", 1.0},
	{"10x", 10.0},
	{"100x", 100.0}
}
Creator.Speed.MoveOffset = {}
Creator.Speed.MoveOffset.Index = 5
Creator.Speed.MoveOffset.Value = {
	{"0.001x", 0.001},
	{"0.01x", 0.01},
	{"0.1x", 0.1},
	{"1x", 1.0},
	{"10x", 10.0},
	{"100x", 100.0}
}

Creator.Multiplayer = {}
Creator.Multiplayer.InSession = false
Creator.Multiplayer.LockSession = false
Creator.Multiplayer.GlobalUniqueId = 0
Creator.Multiplayer.LoadingPlayers = {}
Creator.Multiplayer.AvailablePlayers = {}
Creator.Multiplayer.InvitationList = {}
Creator.Multiplayer.InSessionPlayers = {}
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

Creator.StartingGrid = {}
Creator.StartingGrid.IsMenuVisible = false
Creator.StartingGrid.IsPickedUp = false
Creator.StartingGrid.Index = 0
Creator.StartingGrid.Select = nil
Creator.StartingGrid.Preview = nil
Creator.StartingGrid.Current = {
	handle = nil,
	x = nil,
	y = nil,
	z = nil,
	heading = nil
}

Creator.MarkerDrawCount = 0
Creator.TextDrawCount = 0

Creator.Checkpoint = {}
Creator.Checkpoint.IsMenuVisible = false
Creator.Checkpoint.IsPickedUp = false
Creator.Checkpoint.Index = 0
Creator.Checkpoint.Preview = nil
Creator.Checkpoint.PreviewCoordsChanged = false
Creator.Checkpoint.OverrideRelativeEnable = false
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

Creator.LastValidHash = nil
Creator.LastValidText = ""

Creator.Object = {}
Creator.Object.IsMenuVisible = false
Creator.Object.IsPickedUp = false
Creator.Object.Index = 0
Creator.Object.Preview = nil
Creator.Object.PreviewEffect = nil
Creator.Object.PreviewCoordsChanged = false
Creator.Object.OverrideRelativeEnable = false
Creator.Object.DeleteActive = false
Creator.Object.OverrideRotIndex = -1
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

Creator.Snapping = {}
Creator.Snapping.Enable = false
Creator.Snapping.SphericalMode = false
Creator.Snapping.CanInsertData = false
Creator.Snapping.Handle = nil
Creator.Snapping.ObjectData = nil
Creator.Snapping.NextObjectUniqueId = nil
Creator.Snapping.BoneIndexParent = -1
Creator.Snapping.BoneIndexChild = -1
Creator.Snapping.Offset = {
	steps = {},
	x = 0.0,
	y = 0.0,
	z = 0.0,
	rotX = 0.0,
	rotY = 0.0,
	rotZ = 0.0
}

Creator.Template = {}
Creator.Template.IsMenuVisible = false
Creator.Template.IsPickedUp = false
Creator.Template.PreviewCoordsChanged = false
Creator.Template.OverrideRelativeEnable = false
Creator.Template.Preview = {}
Creator.Template.Current = {}

Creator.MoveAll = {}
Creator.MoveAll.IsMenuVisible = false

Creator.Fixture = {}
Creator.Fixture.IsMenuVisible = false
Creator.Fixture.Index = 0
Creator.Fixture.Current = {
	hash = nil,
	handle = nil,
	x = nil,
	y = nil,
	z = nil
}

Creator.ArenaProps = {}
Creator.ExplodeProps = {}
Creator.FireworkProps = {}

Creator.Firework = {}
Creator.Firework.IsMenuVisible = false
Creator.Firework.LastHour = 0
Creator.Firework.LastMinute = 0
Creator.Firework.LastSecond = 0
Creator.Firework.Preview = false
Creator.Firework.ParticleIndex = 1
Creator.Firework.Particles = {"scr_indep_firework_trailburst", "scr_indep_firework_starburst", "scr_indep_firework_shotburst", "scr_indep_firework_fountain"}

Creator.Cache = {}
Creator.Cache.JoinPoint = nil
Creator.Cache.JoinHeading = nil
Creator.Cache.JoinVehicleNetId = nil
Creator.Cache.VehicleProps = {}

Creator.ButtonToDraw = 0

Creator.GlobalRot = {}
Creator.GlobalRot.X = 0.0
Creator.GlobalRot.Y = 0.0
Creator.GlobalRot.Z = 0.0

Creator.GlobalVar = {}
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

Creator.Blips = {}
Creator.Blips.Checkpoints = {}
Creator.Blips.Checkpoints_2 = {}
Creator.Blips.Objects = {}

Creator.Colors = {
	{255, 255, 255},
	{240, 240, 240},
	{155, 155, 155},
	{205, 205, 205},
	{224, 50, 50},
	{240, 153, 153},
	{93, 182, 229},
	{174, 219, 242},
	{240, 200, 80},
	{254, 235, 169},
	{255, 133, 85},
	{255, 194, 170},
	{114, 204, 114},
	{185, 230, 185},
	{132, 102, 226},
	{192, 179, 239},
	{203, 54, 148},
	{235, 36, 39},
	{194, 80, 80},
	{156, 110, 175},
	{255, 123, 196},
	{247, 159, 123},
	{178, 144, 132},
	{141, 206, 167},
	{113, 169, 175},
	{211, 209, 231},
	{144, 127, 153},
	{106, 196, 191},
	{214, 196, 153},
	{234, 142, 80},
	{152, 203, 234},
	{178, 98, 135},
	{144, 142, 122},
	{166, 117, 94},
	{175, 168, 168},
	{232, 142, 155},
	{187, 214, 91},
	{123, 196, 255},
	{171, 60, 230},
	{206, 169, 13},
	{71, 99, 173},
	{42, 166, 185},
	{186, 157, 125},
	{201, 225, 255},
	{240, 240, 150},
	{237, 140, 161},
	{249, 138, 138},
	{252, 239, 166},
	{240, 240, 240},
	{159, 201, 166},
	{140, 140, 140},
	{240, 160, 0},
	{140, 140, 140},
	{140, 140, 140},
	{100, 112, 127},
	{120, 120, 75},
	{152, 76, 93},
	{124, 69, 69},
	{180, 130, 97},
	{150, 153, 161},
	{214, 181, 99},
	{166, 221, 190},
	{29, 100, 153},
	{214, 116, 15},
	{135, 125, 142},
	{229, 119, 185},
	{252, 239, 166},
	{45, 110, 185},
	{93, 182, 229},
	{194, 80, 80},
	{154, 154, 154},
	{194, 80, 80},
	{252, 115, 201},
	{252, 177, 49},
	{109, 247, 204},
	{241, 101, 34},
	{214, 189, 97},
	{234, 153, 28},
	{146, 200, 62},
	{234, 153, 28},
	{66, 89, 148},
	{164, 76, 242},
	{101, 180, 212},
	{171, 237, 171},
	{255, 163, 87},
	{235, 239, 30},
	{255, 149, 14},
	{246, 60, 161},
	{210, 166, 249},
	{82, 38, 121},
	{127, 81, 43},
	{240, 240, 240},
	{234, 153, 28},
	{225, 140, 8},
	{48, 255, 255},
	{48, 255, 0},
	{176, 80, 0},
	{53, 166, 224},
	{162, 79, 157},
	{104, 192, 141},
	{29, 100, 153},
	{234, 153, 28},
	{240, 160, 1},
	{247, 159, 123},
	{226, 134, 187},
	{239, 238, 151},
	{113, 169, 175},
	{160, 140, 193},
	{141, 206, 167},
	{181, 214, 234},
	{178, 144, 132},
	{0, 132, 114},
	{216, 85, 117},
	{30, 100, 152},
	{43, 181, 117},
	{233, 141, 79},
	{137, 210, 215},
	{134, 125, 141},
	{109, 34, 33},
	{255, 0, 0},
	{255, 255, 0},
	{0, 255, 0},
	{0, 255, 255},
	{0, 0, 255},
	{255, 0, 255},
	{38, 136, 234},
	{154, 178, 54},
	{93, 107, 45},
	{206, 169, 13},
	{0, 151, 151}
}

Creator.Data = {}
Creator.Data.ObjectLabels = {}
Creator.Data.ObjectModels = {}
Creator.Data.Favorite = {}
Creator.Data.Template = {}
Creator.Data.Template.Index = 0
Creator.Data.Template.List = {}
Creator.Data.Check = {}
Creator.Data.Check.Done = false
Creator.Data.Check.CurrentCount = 0
Creator.Data.Check.TotalCount = 0
Creator.Data.Category = {}
Creator.Data.Category.Index = 1
Creator.Data.Category.List = {
	{
		class = "1",
		model = {"prop_const_fence02b", "prop_offroad_bale03", "prop_offroad_bale02", "prop_offroad_bale01", "lts_prop_lts_offroad_tyres01", "prop_offroad_tyres02", "prop_barier_conc_02a", "prop_barier_conc_05c", "prop_barier_conc_05a", "prop_barier_conc_05b", "prop_barier_conc_01a", "prop_barrier_work05", "prop_fnclink_03gate5", "prop_fnclink_02gate3", "prop_mb_sandblock_01", "prop_mb_sandblock_02", "prop_mb_sandblock_05_cr", "prop_mb_sandblock_04", "prop_mb_sandblock_03_cr", "prop_mb_hesco_06", "prop_plas_barier_01a", "prop_barier_conc_02b", "prop_barrier_work06a", "prop_barrier_work04a", "prop_fnclink_06a", "prop_fnclink_06b", "prop_fnclink_06c", "prop_fnclink_06d", "prop_fnccorgm_03a", "prop_fnccorgm_03b", "prop_fnccorgm_03c", "prop_fnccorgm_02a", "prop_fnccorgm_02b", "prop_fnccorgm_02c", "prop_fnccorgm_02d", "prop_fnccorgm_02e", "prop_const_fence03a_cr", "prop_gate_cult_01_l", "prop_gate_cult_01_r", "prop_const_fence03b_cr", "prop_const_fence02a", "prop_const_fence01b_cr", "prop_fncwood_16b", "prop_fncwood_16c", "prop_fnc_farm_01b", "prop_fnc_farm_01c", "prop_fnc_farm_01d", "prop_fnc_farm_01e", "prop_fnc_farm_01f", "prop_hayb_st_01_cr", "prop_haybale_03", "prop_haybale_02", "prop_haybale_01", "prop_tyre_wall_01", "prop_tyre_wall_02", "prop_tyre_wall_03", "prop_tyre_wall_04", "prop_tyre_wall_05", "prop_tyre_wall_01b", "prop_tyre_wall_02b", "prop_tyre_wall_03b", "prop_tyre_wall_01c", "prop_tyre_wall_02c", "prop_tyre_wall_03c", "prop_start_gate_01b", "prop_beachf_01_cr", "prop_sec_gate_01d", "prop_vault_shutter", "vw_prop_vw_barrier_rope_01a", "vw_prop_vw_barrier_rope_02a", "ch_prop_ch_casino_shutter01x", "ch_prop_ch_tunnel_door01a", "h4_prop_h4_fence_seg_x1_01a", "h4_prop_h4_fence_seg_x3_01a", "h4_prop_h4_fence_seg_x5_01a", "h4_prop_h4_fence_arches_x2_01a", "h4_prop_h4_fence_arches_x3_01a", "m23_1_prop_m31_haybales_01a", "m23_1_prop_m31_haybales_01b", "m23_1_prop_m31_haybales_01c", "prop_fncsec_04a", "m23_2_prop_m32_securityfence3_01a", "m23_2_prop_m32_securityfence5_01a", "m23_2_prop_m32_securityfence7_01a", "m23_2_prop_m32_barrier_wat_01a", "m23_2_prop_m32_plasticbarrier_01a", "m23_2_prop_m32_plasticbarrier_02a", "m23_2_prop_m32_plasticbarrier_03a", "m23_2_prop_m32_plasticbarrier_04a", "tr_prop_tr_races_barrel_01a", "m26_1_prop_m61_door_whs_01a"},
		index = 1
	},
	{
		class = "2",
		model = {"prop_bench_05", "prop_bench_07", "prop_bench_01a", "prop_bench_08", "prop_bleachers_04_cr", "prop_bleachers_05_cr"},
		index = 1
	},
	{
		class = "3",
		model = {"prop_dock_bouy_1", "prop_dock_bouy_2", "prop_byard_float_02", "prop_ind_barge_01_cr", "xm_prop_x17_barge_01"},
		index = 1
	},
	{
		class = "4",
		model = {"prop_elecbox_24", "prop_elecbox_24b", "prop_portacabin01", "prop_air_monhut_03_cr", "prop_air_sechut_01", "prop_tollbooth_1", "prop_parking_hut_2", "prop_makeup_trail_02_cr", "prop_makeup_trail_01_cr", "xm_prop_x17_trail_01a", "xm_prop_x17_trail_02a"},
		index = 1
	},
	{
		class = "5",
		model = {"prop_cementbags01", "prop_conc_blocks01a", "prop_cons_crate", "prop_jyard_block_01a", "prop_conc_sacks_02a", "prop_byard_sleeper01", "prop_shuttering01", "prop_shuttering02", "prop_shuttering03", "prop_shuttering04", "prop_woodpile_01a", "prop_woodpile_01b", "prop_woodpile_01c", "prop_woodpile_03a", "prop_conc_blocks01c", "prop_cons_cements01", "prop_pipes_conc_01", "gr_prop_gr_bunkeddoor", "prop_worklight_01a", "prop_worklight_02a", "prop_worklight_03a", "prop_worklight_03b", "prop_worklight_04b", "prop_worklight_04d", "prop_ind_coalcar_02", "xm_prop_x17_osphatch_27m", "gr_prop_gr_bench_03a", "gr_prop_gr_bench_04a", "gr_prop_gr_bench_04b", "prop_pallettruck_01", "prop_rub_cardpile_04", "prop_rub_cardpile_06", "prop_skid_box_01", "prop_cons_plyboard_01", "prop_cons_plank", "prop_barrier_work01c", "prop_food_cb_tray_01", "prop_food_bs_tray_06", "prop_cs_envolope_01", "prop_cs_binder_01", "m23_2_prop_m32_flourbags_01a", "m25_1_prop_m51_scaffold_01a"},
		index = 1
	},
	{
		class = "6",
		model = {"prop_rub_cont_01b", "prop_rail_boxcar4", "prop_rub_railwreck_2", "prop_contr_03b_ld", "prop_container_ld2", "prop_rail_boxcar", "prop_rail_boxcar3", "prop_container_01mb", "prop_container_03mb", "sm_prop_smug_cont_01a", "m24_1_prop_m41_container_01a", "m25_1_prop_m51_containersmall_01c"},
		index = 1
	},
	{
		class = "7",
		model = {"prop_byard_floatpile", "prop_boxpile_07a", "prop_watercrate_01", "prop_box_wood01a", "prop_box_wood03a", "prop_box_wood04a", "prop_cash_crate_01", "prop_mb_cargo_03a", "prop_mb_cargo_04a", "prop_air_cargo_04a", "prop_mb_crate_01b", "prop_air_cargo_01a", "prop_mb_cargo_04b", "prop_mb_cargo_02a", "prop_pallet_pile_02", "prop_pallet_pile_01", "prop_cratepile_07a", "prop_boxpile_04a", "vw_prop_vw_barrel_01a", "vw_prop_vw_barrel_pile_01a", "vw_prop_vw_barrel_pile_02a", "imp_prop_impexp_boxpile_01", "hei_prop_carrier_cargo_01a", "sr_prop_sr_boxpile_03", "xm_prop_rsply_crate04a", "prop_mb_crate_01a", "m23_2_prop_m32_armycrate_01a", "m23_2_prop_m32_prof_crate_01a", "m23_2_prop_m32_tallcabinet_01a", "m24_1_prop_m41_palletcrates_01a", "ex_prop_crate_closed_sc", "hei_prop_hei_warehousetrolly", "prop_flattruck_01c", "sm_prop_smug_crate_01a", "prop_sacktruck_02b", "prop_boxpile_01a", "m24_2_prop_m42_waterprfcase_01a", "bkr_prop_weed_pallet"},
		index = 1
	},
	{
		class = "8",
		model = {"prop_bin_13a", "prop_bin_14a", "prop_dumpster_3a", "prop_dumpster_4b", "prop_dumpster_01a", "prop_dumpster_02a", "prop_dumpster_02b", "prop_skip_06a", "prop_bin_03a"},
		index = 1
	},
	{
		class = "9",
		model = {"prop_elecbox_02a", "prop_elecbox_16", "prop_elecbox_14", "prop_elecbox_10_cr", "prop_elecbox_15_cr", "prop_elecbox_17_cr", "prop_ind_deiseltank", "prop_ind_mech_02a", "prop_ind_mech_02b", "prop_sub_trans_01a", "prop_sub_trans_02a", "prop_sub_trans_04a", "prop_generator_03b", "prop_feeder1_cr", "prop_set_generator_01_cr", "sm_prop_smug_jammer"},
		index = 1
	},
	{
		class = "10",
		model = {"lts_prop_lts_ramp_01", "prop_skip_04", "lts_prop_lts_ramp_02", "lts_prop_lts_ramp_03", "prop_skip_08a", "prop_skip_03", "prop_jetski_ramp_01", "ar_prop_ar_jetski_ramp_01_dev", "prop_byard_rampold_cr", "prop_water_ramp_01", "prop_water_ramp_02", "prop_water_ramp_03", "reh_prop_reh_platform_b_01a", "tr_prop_tr_skip_ramp_01a", "tr_prop_tr_pile_dirt_01a", "tr_prop_tr_trailer_ramp_01a", "xs_prop_x18_flatbed_ramp"},
		index = 1
	},
	{
		class = "11",
		model = {"prop_trafficdiv_01", "prop_sign_road_09a", "prop_sign_road_09b", "prop_sign_road_09c", "prop_sign_road_09d", "prop_sign_road_06q", "prop_sign_road_06r", "prop_sign_road_05c", "prop_sign_road_05d", "prop_sign_road_05e", "prop_sign_road_05f", "prop_air_taxisign_01a", -46243042},
		index = 1
	},
	{
		class = "12",
		model = {"prop_food_van_01", "prop_food_van_02", "prop_tanktrailer_01a", "prop_truktrailer_01a", "prop_old_farm_03", "m23_2_prop_m32_flattrailer_01a", "m23_2_prop_m32_truktrailer_01a", "m23_2_prop_m32_truktrailer_02a", "tr_prop_tr_truktrailer_01a"},
		index = 1
	},
	{
		class = "13",
		model = {"prop_rub_buswreck_01", "prop_rub_buswreck_06", "prop_rub_carwreck_11", "prop_rub_carwreck_12", "prop_rub_carwreck_13", "prop_rub_carwreck_14", "prop_rub_carwreck_9", "prop_rub_couch02", "prop_rub_carwreck_2", "prop_rub_carwreck_3", "prop_rub_carwreck_5", "prop_rub_carwreck_7", "prop_rub_carwreck_8", "prop_rub_carwreck_10", "prop_rub_carwreck_15", "prop_rub_carwreck_16", "m25_1_prop_m51_rub_truck_01a", "m25_1_prop_m51_tank_rusty_01a", "prop_rub_bike_01", "prop_rub_bike_02", "prop_rub_bike_03"},
		index = 1
	},
	{
		class = "14",
		model = {"prop_plant_group_04_cr", "prop_bush_lrg_01c_cr", "prop_bush_lrg_01e_cr2", "prop_bush_med_03_cr2", "prop_joshua_tree_01a", "prop_cactus_01e", "prop_pot_plant_05c", "prop_pot_plant_04c", "prop_pot_plant_05d", "prop_pot_plant_03b_cr2", "prop_pot_plant_04b", "prop_rock_4_big2", "prop_rock_4_big", "prop_rock_4_c_2", "prop_tree_olive_cr2", "prop_tree_eng_oak_cr2", "prop_log_break_01", "prop_tree_fallen_02", "sum_prop_ac_rock_01a", "sum_prop_ac_rock_01b", "sum_prop_ac_rock_01c", "sum_prop_ac_rock_01d", "sum_prop_ac_rock_01e", "xm3_prop_xm3_prop_tree_01a"},
		index = 1
	},
	{
		class = "15",
		model = {"prop_offroad_barrel01", "prop_offroad_barrel02", "prop_barrel_exp_01a", "prop_fire_exting_1b", "prop_roadcone02c", "prop_roadcone02a", "prop_roadcone01a", "prop_roadpole_01a", "prop_postbox_01a", "prop_news_disp_02d", "prop_vend_water_01", "prop_vend_snak_01_tu", "prop_train_ticket_02_tu", "prop_boxpile_02b", "prop_mc_conc_barrier_01", "prop_fncsec_03b", "prop_table_08_side", "prop_container_ld_pu", "prop_mb_ordnance_02", "prop_storagetank_02b", "prop_logpile_01", "prop_logpile_03", "prop_pipes_02b", "prop_barrel_pile_01", "prop_barrel_exp_01b", "prop_barrel_exp_01c", "prop_gas_tank_02a", "prop_gas_tank_04a", "prop_gas_tank_02b", "prop_jerrycan_01a", "prop_gascyl_01a", "prop_gascyl_04a", "prop_gascyl_03a", "prop_gascyl_03b", "prop_gascyl_02a", "prop_gascyl_02b", "prop_fruitstand_b", "prop_rub_tyre_03", "stt_prop_stunt_bowling_pin", "stt_prop_stunt_bowling_ball", "stt_prop_stunt_soccer_sball", "stt_prop_stunt_soccer_ball", "stt_prop_stunt_soccer_lball", "imp_prop_groupbarrel_01", "imp_prop_groupbarrel_02", "imp_prop_groupbarrel_03", "sr_prop_sr_boxwood_01", "sr_prop_sr_boxpile_02", "sr_prop_sr_track_wall", "sr_prop_sr_tube_wall", "sr_mp_spec_races_ammu_sign", "ar_prop_ar_ammu_sign", "xm_prop_x17_mine_01a", "xm_prop_x17_mine_02a", "xm_prop_x17_mine_03a", "p_ld_stinger_s", "xs_prop_arena_bomb_s", "xs_prop_arena_bomb_m", "xs_prop_arena_bomb_l", "prop_wine_red", "prop_drink_redwine", "prop_bikerset", "reh_prop_reh_jammer_01a", "m23_1_prop_m31_stack_pk_01a", "m23_1_prop_m31_stack_pk_01b", "m23_1_prop_m31_stack_pk_01c", "m23_1_prop_m31_crate_pk_01a", "m23_2_prop_m32_roadcone_01a", "m23_2_prop_m32_roadcone_02a", "m23_2_prop_m32_roadcone_03a", "m23_2_prop_m32_roadcone_04a", "m23_2_prop_m32_roadpole_01a", "m23_2_prop_m32_roadcone_05a", "m23_2_prop_m32_roadcone_06a", "m23_2_prop_m32_roadcone_07a", "m24_1_prop_m41_highway_paddle_3", "m24_1_prop_m41_highway_paddle_5", "m24_1_prop_m41_highway_paddle_7", "prop_portaloo_01a", "m25_1_prop_m51_biometriccase_01a", "m25_1_prop_m51_biometriccase_01b", "m25_1_prop_m51_lock_01a", "m25_1_prop_m51_lock_01b", "m25_2_prop_m52_box_ammo_01a"},
		index = 1
	},
	{
		class = "16",
		model = {"ch_prop_ch_room_trolly_01a", "h4_prop_h4_boxpile_01a", "h4_prop_office_desk_01", "prop_box_wood02a_pu", "tr_prop_tr_container_01a", "tr_prop_tr_container_01b", "tr_prop_tr_container_01c", "tr_prop_tr_container_01d", "tr_prop_tr_container_01e", "tr_prop_tr_container_01f", "tr_prop_tr_container_01g", "tr_prop_tr_container_01h", "tr_prop_tr_container_01i", "prop_container_03_ld", "hei_prop_cntrdoor_mph_l", "hei_prop_cntrdoor_mph_r", "xm_prop_x17_screens_01a", "prop_beach_ring_01", "prop_beachball_01", "prop_beach_lilo_02", "prop_beach_volball02", "tr_prop_tr_crates_sam_01a", "gr_prop_gr_crates_pistols_01a", "gr_prop_gr_crates_rifles_01a", "gr_prop_gr_crates_rifles_02a", "gr_prop_gr_crates_rifles_03a", "gr_prop_gr_crates_rifles_04a", "gr_prop_gr_crates_sam_01a", "gr_prop_gr_crates_weapon_mix_01a", "gr_prop_gr_gunsmithsupl_01a", "gr_prop_gr_gunsmithsupl_02a", "gr_prop_gr_gunsmithsupl_03a", "gr_prop_gr_target_02b", "gr_prop_gr_target_02a", "gr_prop_gr_rsply_crate01a", "gr_prop_gr_rsply_crate02a", "gr_prop_gr_rsply_crate03a", "xm_prop_x17_labvats", "xm_prop_x17_tool_draw_01a", "prop_tool_box_04", "tr_prop_tr_military_pickup_01a", "hei_prop_hei_cash_trolly_03", "prop_gold_cont_01", "prop_large_gold_empty", "ex_prop_crate_expl_sc", "ex_prop_crate_expl_bc", "ex_prop_crate_ammo_bc", "ex_prop_crate_ammo_sc", "ex_prop_crate_biohazard_bc", "ex_prop_crate_biohazard_sc", "ex_prop_crate_minig", "tr_prop_tr_med_table_01a", "prop_parasol_01", "prop_rub_binbag_03b", "prop_rub_binbag_06", "prop_rub_boxpile_06", "prop_bench_06", "prop_bin_05a", "prop_picnictable_01", "hei_prop_heist_emp", "ch_prop_emp_01b", "gr_prop_gr_bench_02b", "ex_prop_crate_shide", "ex_prop_crate_art_bc", "ex_prop_crate_art_sc", "ex_prop_crate_art_02_bc", "ex_prop_crate_art_02_sc", "p_rcss_folded", "prop_power_cell", "prop_biotech_store", "prop_alien_egg_01", "hei_prop_heist_off_chair", "tr_prop_tr_monitor_01a", "tr_prop_tr_monitor_01b", "prop_cs_mouse_01", "tr_prop_tr_mule_mt_01a", "sf_prop_sf_tanker_crash_01a", "sf_prop_sf_gas_tank_01a", "sf_prop_sf_speaker_stand_01a", "sf_prop_sf_fncsec_01a", "sf_prop_sf_swift2_01a", "sum_prop_ac_aircon_02a", "xm3_prop_xm3_container_01d", "xm3_prop_xm3_spkr_wall_01a", "m23_2_prop_m32_crt_mon_01a", "m23_2_prop_m32_watercrate_01a", "m23_2_prop_m32_box_wood_01a", "m23_2_prop_m32_cbcrate_01a", "m23_2_prop_m32_cbcrate_01b", "m23_2_prop_m32_cbcrate_01c", "m24_2_prop_m42_gascage_01a", "m24_2_prop_m42_gascage_01b", "m24_2_prop_m42_explosivedrop_01a", "m24_2_prop_m42_lantern_01a", "m24_2_prop_m42_lantern_01b", "m24_2_prop_m42_lanterns_10", "m24_2_prop_m42_lanterns_20", "m24_2_prop_m42_lanterns_30", "m25_1_prop_m51_containersmall_01b"},
		index = 1
	},
	{
		class = "17",
		model = {"prop_ld_alarm_01", "ind_prop_dlc_flag_02", "prop_flare_01", "hei_prop_bank_plug", "hei_prop_wall_alarm_on", "hei_prop_wall_alarm_off", "hei_prop_carrier_docklight_01", "hei_prop_carrier_docklight_02", "hei_prop_wall_light_10a_cr", "hei_prop_heist_apecrate", "hei_prop_cc_metalcover_01", "hei_prop_bank_alarm_01", "prop_road_memorial_02", "prop_boombox_01", "prop_ghettoblast_02", "prop_tapeplayer_01", "prop_radio_01", "prop_shamal_crash", "apa_mp_apa_crashed_usaf_01a", "ind_prop_firework_01", "ba_prop_battle_mast_01a", "sr_prop_spec_target_s_01a", "sr_prop_spec_target_m_01a", "sr_prop_spec_target_b_01a", "w_ar_railgun", "prop_cs_heist_bag_01", "prop_champset", "xm_prop_x17_desk_cover_01a", "xm_prop_x17_filecab_01a", "xm_prop_x17_seat_cover_01a", "xm_prop_x17_tv_stand_01a", "xm_prop_x17_bag_01a", "xm_prop_x17_bag_med_01a", "xm_prop_x17_sub", "xm_prop_base_cabinet_door_01", "xm_prop_x17_corpse_01", "xm_prop_x17_corpse_02", "xm_prop_x17_corpse_03", "xm_prop_x17_shovel_01b", "xm_prop_x17_shovel_01a", "xm_prop_x17_note_paper_01a", "xm_prop_x17_chest_closed", "xm_prop_x17_chest_open", "xm_prop_gr_console_01", "prop_cabinet_01b", "xm_prop_base_jet_01", "xm_prop_base_jet_02", "xm_prop_x17_shamal_crash", "w_pi_pistol", "sm_prop_smug_cover_01a", "xm_prop_x17_cover_01", "xm_prop_x17_bunker_door", "prop_sm1_11_garaged", "prop_conslift_lift", "reh_prop_reh_keypad_01a", "m23_1_prop_m31_ladder_01a", 361923596},
		index = 1
	},
	{
		class = "18",
		model = {"stt_prop_stunt_jump_s", "bkr_prop_biker_jump_s", "stt_prop_stunt_jump_m", "bkr_prop_biker_jump_m", "stt_prop_stunt_jump_l", "bkr_prop_biker_jump_l", "stt_prop_stunt_jump_sb", "bkr_prop_biker_jump_sb", "stt_prop_stunt_jump_mb", "bkr_prop_biker_jump_mb", "stt_prop_stunt_jump_lb", "bkr_prop_biker_jump_lb", "stt_prop_ramp_jump_xs", "stt_prop_ramp_jump_s", "stt_prop_ramp_jump_m", "stt_prop_ramp_jump_l", "stt_prop_ramp_jump_xl", "stt_prop_ramp_jump_xxl", "stt_prop_track_jump_01a", "bkr_prop_biker_jump_01a", "stt_prop_track_jump_01b", "bkr_prop_biker_jump_01b", "stt_prop_track_jump_01c", "bkr_prop_biker_jump_01c", "stt_prop_track_jump_02a", "bkr_prop_biker_jump_02a", "stt_prop_track_jump_02b", "bkr_prop_biker_jump_02b", "stt_prop_track_jump_02c", "bkr_prop_biker_jump_02c", "stt_prop_ramp_adj_flip_mb", "stt_prop_ramp_adj_flip_s", "stt_prop_ramp_adj_flip_sb", "stt_prop_ramp_adj_flip_m", "stt_prop_stunt_ramp", "stt_prop_stunt_wideramp", "stt_prop_stunt_bblock_qp3", "imp_prop_impexp_bblock_qp3", "stt_prop_stunt_bblock_qp2", "bkr_prop_biker_bblock_qp2", "stt_prop_stunt_bblock_qp", "bkr_prop_biker_bblock_qp", "stt_prop_stunt_bblock_hump_01", "bkr_prop_biker_bblock_hump_01", "stt_prop_stunt_bblock_hump_02", "bkr_prop_biker_bblock_hump_02", "bkr_prop_biker_bblock_cor_03", "bkr_prop_biker_bblock_cor_02", "bkr_prop_biker_bblock_cor"},
		index = 1
	},
	{
		class = "19",
		model = {"stt_prop_stunt_bblock_sml1", "bkr_prop_biker_bblock_sml1", "stt_prop_stunt_bblock_sml2", "bkr_prop_biker_bblock_sml2", "stt_prop_stunt_bblock_sml3", "bkr_prop_biker_bblock_sml3", "stt_prop_stunt_bblock_mdm1", "bkr_prop_biker_bblock_mdm1", "stt_prop_stunt_bblock_mdm2", "bkr_prop_biker_bblock_mdm2", "stt_prop_stunt_bblock_mdm3", "bkr_prop_biker_bblock_mdm3", "stt_prop_stunt_bblock_lrg1", "bkr_prop_biker_bblock_lrg1", "stt_prop_stunt_bblock_lrg2", "bkr_prop_biker_bblock_lrg2", "stt_prop_stunt_bblock_lrg3", "bkr_prop_biker_bblock_lrg3", "stt_prop_stunt_bblock_xl1", "bkr_prop_biker_bblock_xl1", "stt_prop_stunt_bblock_xl2", "bkr_prop_biker_bblock_xl2", "stt_prop_stunt_bblock_xl3", "bkr_prop_biker_bblock_xl3", "stt_prop_stunt_bblock_huge_01", "bkr_prop_biker_bblock_huge_01", "stt_prop_stunt_bblock_huge_02", "bkr_prop_biker_bblock_huge_02", "stt_prop_stunt_bblock_huge_03", "bkr_prop_biker_bblock_huge_03", "stt_prop_stunt_bblock_huge_04", "bkr_prop_biker_bblock_huge_04", "stt_prop_stunt_bblock_huge_05", "bkr_prop_biker_bblock_huge_05", "imp_prop_impexp_bblock_huge_01", "imp_prop_impexp_bblock_sml1", "imp_prop_impexp_bblock_mdm1", "imp_prop_impexp_bblock_lrg1", "imp_prop_impexp_bblock_xl1"},
		index = 1
	},
	{
		class = "20",
		model = {"stt_prop_ramp_adj_hloop", "stt_prop_ramp_adj_loop", "stt_prop_ramp_multi_loop_rb", "stt_prop_stunt_jump_loop", "ar_prop_ar_jump_loop", "stt_prop_ramp_spiral_s", "stt_prop_ramp_spiral_l_s", "stt_prop_ramp_spiral_m", "stt_prop_ramp_spiral_l_m", "stt_prop_ramp_spiral_l", "stt_prop_ramp_spiral_l_l", "stt_prop_ramp_spiral_xxl", "stt_prop_ramp_spiral_l_xxl", "stt_prop_wallride_45r", "stt_prop_wallride_45ra", "stt_prop_wallride_45l", "stt_prop_wallride_45la", "stt_prop_wallride_90r", "stt_prop_wallride_90rb", "stt_prop_wallride_90l", "stt_prop_wallride_90lb", "stt_prop_wallride_04", "stt_prop_wallride_01", "stt_prop_wallride_01b", "stt_prop_wallride_05", "stt_prop_wallride_05b", "stt_prop_wallride_02", "stt_prop_wallride_02b", "stt_prop_stunt_target_small", "bkr_prop_biker_target_small", "stt_prop_stunt_target", "bkr_prop_biker_target", "stt_prop_stunt_bowlpin_stand", "bkr_prop_biker_bowlpin_stand", "stt_prop_stunt_soccer_goal", "stt_prop_stunt_landing_zone_01", "bkr_prop_biker_landing_zone_01", "ch_prop_stunt_landing_zone_01a", "stt_prop_hoop_tyre_01a", "sr_prop_sr_track_jumpwall", "ar_prop_ar_start_01a"},
		index = 1
	},
	{
		class = "21",
		model = {"stt_prop_track_speedup", "stt_prop_track_speedup_t2", "stt_prop_track_speedup_t1", "stt_prop_track_slowdown", "stt_prop_track_slowdown_t2", "stt_prop_track_slowdown_t1", "sr_prop_track_refill", "sr_prop_track_refill_t2", "sr_prop_track_refill_t1", "m24_2_prop_m42_track_refill_01a", "ar_prop_ar_speed_ring", "ind_prop_firework_03", "stt_prop_hoop_small_01", "ar_prop_ar_hoop_med_01", "stt_prop_hoop_constraction_01a", "stt_prop_race_tannoy", "stt_prop_speakerstack_01a"},
		index = 1
	},
	{
		class = "22",
		model = {"as_prop_as_target_small_02", "as_prop_as_target_small", "as_prop_as_target_medium", "as_prop_as_target_big", "as_prop_as_target_scaffold_01a", "as_prop_as_target_scaffold_01b", "as_prop_as_target_scaffold_02a", "as_prop_as_target_scaffold_02b"},
		index = 1
	},
	{
		class = "23",
		model = {"stt_prop_track_stop_sign", "stt_prop_corner_sign_01", "stt_prop_corner_sign_02", "stt_prop_corner_sign_03", "stt_prop_corner_sign_04", "stt_prop_corner_sign_05", "stt_prop_corner_sign_06", "stt_prop_corner_sign_07", "stt_prop_corner_sign_08", "stt_prop_corner_sign_09", "stt_prop_corner_sign_10", "stt_prop_corner_sign_11", "stt_prop_corner_sign_12", "stt_prop_corner_sign_13", "stt_prop_corner_sign_14", "ch_prop_pit_sign_01a", "sum_prop_ac_pit_sign_left", "stt_prop_sign_circuit_01", "stt_prop_sign_circuit_02", "stt_prop_sign_circuit_03", "stt_prop_sign_circuit_05", "stt_prop_sign_circuit_04", "stt_prop_sign_circuit_06", "stt_prop_sign_circuit_07", "stt_prop_sign_circuit_08", "stt_prop_sign_circuit_09", "stt_prop_sign_circuit_10", "stt_prop_sign_circuit_11", "stt_prop_sign_circuit_12", "stt_prop_sign_circuit_13", "stt_prop_sign_circuit_14", "stt_prop_sign_circuit_15", "sum_prop_ac_wall_sign_01", "sum_prop_ac_wall_sign_0l1", "sum_prop_ac_wall_sign_0r1", "sum_prop_ac_wall_sign_02", "sum_prop_ac_wall_sign_04", "sum_prop_ac_wall_sign_03", "sum_prop_ac_wall_sign_05", "sum_prop_ac_tyre_wall_lit_01", "sum_prop_ac_tyre_wall_lit_0r1", "sum_prop_ac_tyre_wall_lit_0l1", "sum_prop_ac_tyre_wall_pit_l", "sum_prop_ac_tyre_wall_pit_r", "sum_prop_ac_tyre_wall_u_l", "sum_prop_ac_tyre_wall_u_r", "stt_prop_tyre_wall_02", "stt_prop_tyre_wall_03", "stt_prop_tyre_wall_04", "stt_prop_tyre_wall_05", "stt_prop_tyre_wall_06", "stt_prop_tyre_wall_07", "stt_prop_tyre_wall_08", "stt_prop_tyre_wall_09", "stt_prop_tyre_wall_010", "stt_prop_tyre_wall_011", "stt_prop_tyre_wall_012", "stt_prop_tyre_wall_013", "stt_prop_tyre_wall_014", "stt_prop_tyre_wall_015", "stt_prop_tyre_wall_0r2", "stt_prop_tyre_wall_0r06", "stt_prop_tyre_wall_0r07", "stt_prop_tyre_wall_0r011", "stt_prop_tyre_wall_0r012", "stt_prop_tyre_wall_0r013", "stt_prop_tyre_wall_0r014", "stt_prop_tyre_wall_0r019", "stt_prop_tyre_wall_0r3", "stt_prop_tyre_wall_0r04", "stt_prop_tyre_wall_0r05", "stt_prop_tyre_wall_0r08", "stt_prop_tyre_wall_0r09", "stt_prop_tyre_wall_0r010", "stt_prop_tyre_wall_0r015", "stt_prop_tyre_wall_0r016", "stt_prop_tyre_wall_0r017", "stt_prop_tyre_wall_0r018", "stt_prop_tyre_wall_0l2", "stt_prop_tyre_wall_0l06", "stt_prop_tyre_wall_0l07", "stt_prop_tyre_wall_0l013", "stt_prop_tyre_wall_0l014", "stt_prop_tyre_wall_0l015", "stt_prop_tyre_wall_0l020", "stt_prop_tyre_wall_0l3", "stt_prop_tyre_wall_0l04", "stt_prop_tyre_wall_0l05", "stt_prop_tyre_wall_0l08", "stt_prop_tyre_wall_0l010", "stt_prop_tyre_wall_0l012", "stt_prop_tyre_wall_0l16", "stt_prop_tyre_wall_0l17", "stt_prop_tyre_wall_0l018", "stt_prop_tyre_wall_0l019", "stt_prop_race_gantry_01", "ch_prop_ch_race_gantry_02", "ch_prop_ch_race_gantry_03", "ch_prop_ch_race_gantry_04", "ch_prop_ch_race_gantry_05", "sr_mp_spec_races_blimp_sign", "sr_mp_spec_races_take_flight_sign", "sr_mp_spec_races_ron_sign", "sr_mp_spec_races_xero_sign", "sum_prop_archway_01", "sum_prop_archway_02", "sum_prop_archway_03", "sum_prop_ac_pit_sign_r_01a", "sum_prop_ac_pit_sign_l_01a", "m24_2_prop_m42_tyre_wall_nos"},
		index = 1
	},
	{
		class = "24",
		model = {"ar_prop_ar_arrow_thin_m", "ar_prop_ar_arrow_wide_m", "ar_prop_ar_arrow_thin_l", "ar_prop_ar_arrow_wide_l", "ar_prop_ar_arrow_thin_xl", "ar_prop_ar_arrow_wide_xl"},
		index = 1
	},
	{
		class = "25",
		model = {"stt_prop_track_start", "stt_prop_track_start_02", "stt_prop_race_start_line_01", "stt_prop_race_start_line_01b", "sr_prop_sr_start_line_02", "stt_prop_race_start_line_02b", "stt_prop_race_start_line_03", "stt_prop_race_start_line_03b", "sum_prop_ac_track_pit_stop_16l", "sum_prop_ac_track_pit_stop_16r", "sum_prop_ac_track_pit_stop_30l", "ch_prop_track_pit_stop_01", "sum_prop_ac_track_pit_stop_30r", "m24_1_prop_m41_track_straight_xs", "stt_prop_track_straight_s", "stt_prop_track_straight_m", "ba_prop_track_straight_lm", "stt_prop_track_straight_l", "sum_prop_ac_track_pit_stop_01", "stt_prop_track_bend_m", "stt_prop_track_bend_l", "ba_prop_track_bend_l_b", "stt_prop_track_bend2_l", "stt_prop_track_bend2_l_b", "stt_prop_track_bend_5d", "stt_prop_track_bend_15d", "stt_prop_track_bend_30d", "ch_prop_track_ch_bend_45", "sum_prop_track_ac_bend_45", "sum_prop_track_ac_bend_lc", "ch_prop_track_ch_bend_135", "sum_prop_track_ac_bend_135", "stt_prop_track_bend_180d", "sum_prop_track_ac_bend_180d", "stt_prop_track_fork", "stt_prop_track_cross", "stt_prop_track_link", "stt_prop_track_chicane_l", "stt_prop_track_chicane_l_02", "stt_prop_track_chicane_r", "stt_prop_track_chicane_r_02", "stt_prop_track_block_03", "sr_prop_track_straight_l_d5", "sr_prop_track_straight_l_d15", "sr_prop_track_straight_l_d30", "sr_prop_track_straight_l_d45", "sr_prop_track_straight_l_u5", "sr_prop_track_straight_l_u15", "sr_prop_track_straight_l_u30", "sr_prop_track_straight_l_u45", "m24_2_prop_m42_track_lbendinc15d", "m24_2_prop_m42_track_rbendinc15d", "m24_2_prop_m42_track_lbenddec15d", "m24_2_prop_m42_track_rbenddec15d", "m25_2_prop_m52_track_lbendinc5d", "m25_2_prop_m52_track_rbendinc5d", "m25_2_prop_m52_track_lbenddec5d", "m25_2_prop_m52_track_rbenddec5d"},
		index = 1
	},
	{
		class = "26",
		model = {"m24_1_prop_m41_track_strgt_bar_xs", "stt_prop_track_straight_bar_s", "stt_prop_track_straight_bar_m", "stt_prop_track_straight_lm_bar", "stt_prop_track_straight_bar_l", "stt_prop_track_bend_bar_m", "stt_prop_track_bend_bar_l", "stt_prop_track_bend_bar_l_b", "stt_prop_track_bend2_bar_l", "stt_prop_track_bend2_bar_l_b", "stt_prop_track_bend_5d_bar", "stt_prop_track_bend_15d_bar", "stt_prop_track_bend_30d_bar", "ch_prop_track_ch_bend_bar_45d", "sum_prop_track_ac_bend_bar_45", "ch_prop_track_bend_bar_lc", "ch_prop_track_ch_bend_bar_135", "sum_prop_track_ac_bend_bar_135", "stt_prop_track_bend_180d_bar", "sum_prop_track_ac_bend_bar_180d", "m24_1_prop_m41_track_fork_bar", "stt_prop_track_fork_bar", "stt_prop_track_cross_bar", "stt_prop_track_funnel", "stt_prop_track_funnel_ads_01a", "stt_prop_track_funnel_ads_01b", "stt_prop_track_funnel_ads_01c", "stt_prop_track_block_01", "stt_prop_track_block_02"},
		index = 1
	},
	{
		class = "27",
		model = {"stt_prop_stunt_track_start_02", "stt_prop_stunt_track_st_02", "stt_prop_stunt_track_start", "stt_prop_stunt_track_st_01", "stt_prop_stunt_track_exshort", "stt_prop_stunt_track_short", "stt_prop_stunt_track_straight", "stt_prop_stunt_track_turn", "m24_1_prop_m41_stnt_trk_sh5", "stt_prop_stunt_track_sh15", "stt_prop_stunt_track_sh30", "xm3_prop_stunt_track_sh45", "stt_prop_stunt_track_sh45_a", "stt_prop_stunt_track_uturn", "stt_prop_stunt_track_cutout", "stt_prop_stunt_track_otake", "m24_1_prop_m41_stnt_trk_fork_xs", "stt_prop_stunt_track_fork", "stt_prop_stunt_track_funnel", "stt_prop_stunt_track_funlng", "stt_prop_stunt_track_slope15", "stt_prop_stunt_track_slope30", "stt_prop_stunt_track_slope45", "stt_prop_stunt_track_hill", "stt_prop_stunt_track_hill2", "stt_prop_stunt_track_bumps", "stt_prop_stunt_track_jump", "stt_prop_stunt_jump15", "stt_prop_stunt_jump30", "stt_prop_stunt_jump45", "stt_prop_stunt_track_link", "stt_prop_stunt_track_dwlink", "stt_prop_stunt_track_dwlink_02", "stt_prop_stunt_track_dwshort", "m24_1_prop_m41_stunt_track_dwlong", "m24_1_prop_m41_stnt_trk_dwsh5", "stt_prop_stunt_track_dwsh15", "stt_prop_stunt_track_dwturn", "stt_prop_stunt_track_dwuturn", "stt_prop_stunt_track_dwslope15", "as_prop_as_dwslope30", "stt_prop_stunt_track_dwslope45", "stt_prop_track_tube_02", "ba_prop_battle_track_exshort", "ba_prop_battle_track_short"},
		index = 1
	},
	{
		class = "28",
		model = {"sum_prop_race_barrier_01_sec", "sum_prop_race_barrier_02_sec", "sum_prop_race_barrier_04_sec", "sum_prop_race_barrier_08_sec", "sum_prop_race_barrier_16_sec", "sum_prop_ac_short_barrier_05d", "sum_prop_ac_short_barrier_15d", "sum_prop_ac_short_barrier_30d", "sum_prop_ac_short_barrier_45d", "sum_prop_ac_short_barrier_90d", "sum_prop_ac_long_barrier_05d", "sum_prop_ac_long_barrier_15d", "sum_prop_ac_long_barrier_30d", "sum_prop_ac_long_barrier_45d", "sum_prop_ac_long_barrier_90d", "sum_prop_barrier_ac_bend_05d", "sum_prop_barrier_ac_bend_15d", "sum_prop_barrier_ac_bend_30d", "sum_prop_barrier_ac_bend_45d", "sum_prop_barrier_ac_bend_90d", "sum_prop_track_ac_straight_bar_s_s", "sum_prop_track_ac_straight_bar_s", "ch_prop_track_ch_straight_bar_m", "sum_prop_track_ac_bend_bar_m_out", "sum_prop_track_ac_bend_bar_m_in", "sum_prop_track_ac_bend_bar_l_out", "sum_prop_track_ac_bend_bar_l_b"},
		index = 1
	},
	{
		class = "29",
		model = {"stt_prop_stunt_tube_xxs", "bkr_prop_biker_tube_xxs", "stt_prop_stunt_tube_xs", "bkr_prop_biker_tube_xs", "stt_prop_stunt_tube_s", "bkr_prop_biker_tube_s", "stt_prop_stunt_tube_m", "bkr_prop_biker_tube_m", "stt_prop_stunt_tube_l", "bkr_prop_biker_tube_l", "stt_prop_stunt_tube_crn", "bkr_prop_biker_tube_crn", "stt_prop_stunt_tube_crn_5d", "stt_prop_stunt_tube_crn_15d", "stt_prop_stunt_tube_crn_30d", "stt_prop_stunt_tube_crn2", "bkr_prop_biker_tube_crn2", "stt_prop_stunt_tube_fork", "stt_prop_stunt_tube_cross", "bkr_prop_biker_tube_cross", "stt_prop_stunt_tube_gap_01", "bkr_prop_biker_tube_gap_01", "stt_prop_stunt_tube_gap_02", "bkr_prop_biker_tube_gap_02", "stt_prop_stunt_tube_gap_03", "bkr_prop_biker_tube_gap_03", "stt_prop_stunt_tube_qg", "stt_prop_stunt_tube_hg", "stt_prop_stunt_tube_jmp", "stt_prop_stunt_tube_jmp2", "ba_prop_battle_tube_fn_01", "ba_prop_battle_tube_fn_02", "ba_prop_battle_tube_fn_03", "ba_prop_battle_tube_fn_04", "ba_prop_battle_tube_fn_05", "stt_prop_stunt_tube_ent", "stt_prop_stunt_tube_end", "sr_prop_sr_tube_end", "stt_prop_stunt_tube_speed", "sr_prop_spec_tube_refill", "stt_prop_track_tube_01", "as_prop_as_tube_gap_03", "as_prop_as_tube_xxs"},
		index = 1
	},
	{
		class = "30",
		model = {"bkr_prop_weed_bigbag_01a", "bkr_prop_meth_smallbag_01a", "bkr_prop_weed_bucket_01a", "bkr_prop_coke_boxeddoll", "prop_keg_01", "bkr_prop_coke_table01a", "bkr_prop_meth_table01a", "bkr_prop_meth_phosphorus", "prop_meth_setup_01", "bkr_prop_meth_pseudoephedrine", "bkr_prop_weed_table_01a", "bkr_prop_weed_bigbag_open_01a", "bkr_prop_weed_scales_01a", "bkr_prop_weed_lrg_01a", "bkr_prop_weed_lrg_01b", "bkr_prop_weed_med_01a", "bkr_prop_weed_med_01b", "bkr_prop_weed_01_small_01a", "bkr_prop_weed_smallbag_01a", "xm3_prop_xm3_shelves_01a", "ch_prop_ch_service_trolley_01a", "bkr_prop_weed_table_01b"},
		index = 1
	},
	{
		class = "31",
		model = {"hei_heist_apart2_door", "prop_target_ora_purp_01", "gr_prop_gr_target_01a", "gr_prop_gr_target_01b", "gr_prop_gr_bench_01a", "gr_prop_gr_bench_01b", "gr_prop_gr_bench_02a", "gr_prop_gr_speeddrill_01a", "gr_prop_gr_vertmill_01a", "gr_prop_gr_cratespile_01a", "imp_prop_covered_vehicle_01a", "imp_prop_covered_vehicle_04a", "imp_prop_covered_vehicle_02a", "imp_prop_covered_vehicle_05a", "imp_prop_covered_vehicle_03a", "imp_prop_covered_vehicle_06a", "gr_prop_gunlocker_ammo_01a", "prop_box_ammo02a"},
		index = 1
	},
	{
		class = "32",
		model = {"sr_prop_spec_tube_xxs_01a", "sr_prop_stunt_tube_xs_01a", "sr_prop_spec_tube_s_01a", "sr_prop_spec_tube_m_01a", "sr_prop_spec_tube_l_01a", "sr_prop_spec_tube_crn_01a", "sr_prop_stunt_tube_crn_5d_01a", "sr_prop_stunt_tube_crn_15d_01a", "sr_prop_spec_tube_crn_30d_01a", "sr_prop_stunt_tube_crn2_01a", "sr_prop_spec_tube_xxs_02a", "sr_prop_stunt_tube_xs_02a", "sr_prop_spec_tube_s_02a", "sr_prop_spec_tube_m_02a", "sr_prop_spec_tube_l_02a", "sr_prop_spec_tube_crn_02a", "sr_prop_stunt_tube_crn_5d_02a", "sr_prop_stunt_tube_crn_15d_02a", "sr_prop_spec_tube_crn_30d_02a", "sr_prop_stunt_tube_crn2_02a", "sr_prop_spec_tube_xxs_03a", "sr_prop_stunt_tube_xs_03a", "sr_prop_spec_tube_s_03a", "sr_prop_spec_tube_m_03a", "sr_prop_spec_tube_l_03a", "sr_prop_spec_tube_crn_03a", "sr_prop_stunt_tube_crn_5d_03a", "sr_prop_stunt_tube_crn_15d_03a", "sr_prop_spec_tube_crn_30d_03a", "sr_prop_stunt_tube_crn2_03a", "sr_prop_spec_tube_xxs_04a", "sr_prop_stunt_tube_xs_04a", "sr_prop_spec_tube_s_04a", "sr_prop_spec_tube_m_04a", "sr_prop_spec_tube_l_04a", "sr_prop_spec_tube_crn_04a", "sr_prop_stunt_tube_crn_5d_04a", "sr_prop_stunt_tube_crn_15d_04a", "sr_prop_spec_tube_crn_30d_04a", "sr_prop_stunt_tube_crn2_04a", "sr_prop_spec_tube_xxs_05a", "sr_prop_stunt_tube_xs_05a", "sr_prop_spec_tube_s_05a", "sr_prop_spec_tube_m_05a", "sr_prop_spec_tube_l_05a", "sr_prop_spec_tube_crn_05a", "sr_prop_stunt_tube_crn_5d_05a", "sr_prop_stunt_tube_crn_15d_05a", "sr_prop_spec_tube_crn_30d_05a", "sr_prop_stunt_tube_crn2_05a"},
		index = 1
	},
	{
		class = "33",
		model = {"sr_prop_special_bblock_sml1", "sr_prop_special_bblock_mdm1", "sr_prop_special_bblock_lrg11", "sr_prop_special_bblock_xl1", "sr_prop_special_bblock_sml2", "sr_prop_special_bblock_mdm2", "sr_prop_special_bblock_lrg2", "sr_prop_special_bblock_xl2", "sr_prop_special_bblock_sml3", "sr_prop_special_bblock_mdm3", "sr_prop_special_bblock_lrg3", "sr_prop_special_bblock_xl3", "sr_prop_special_bblock_xl3_fixed", "vw_prop_vw_bblock_huge_01", "vw_prop_vw_bblock_huge_02", "vw_prop_vw_bblock_huge_03", "vw_prop_vw_bblock_huge_04", "vw_prop_vw_bblock_huge_05", "ar_prop_ar_stunt_block_01a", "ar_prop_ar_stunt_block_01b"},
		index = 1
	},
	{
		class = "34",
		model = {"gr_prop_gr_target_1_01a", "gr_prop_gr_target_1_01b", "gr_prop_gr_target_2_04a", "gr_prop_gr_target_2_04b", "gr_prop_gr_target_3_03a", "gr_prop_gr_target_3_03b", "gr_prop_gr_target_4_01a", "gr_prop_gr_target_4_01b", "gr_prop_gr_target_5_01a", "gr_prop_gr_target_5_01b", "gr_prop_gr_target_small_01a", "gr_prop_gr_target_small_01b", "gr_prop_gr_target_small_03a", "gr_prop_gr_target_small_02a", "gr_prop_gr_target_small_06a", "gr_prop_gr_target_small_07a", "gr_prop_gr_target_small_04a", "gr_prop_gr_target_small_05a", "gr_prop_gr_target_long_01a", "gr_prop_gr_target_large_01a", "gr_prop_gr_target_large_01b", "gr_prop_gr_target_trap_01a", "gr_prop_gr_target_trap_02a", "as_prop_as_stunt_target", "as_prop_as_stunt_target_small"},
		index = 1
	},
	{
		class = "35",
		model = {"ar_prop_ar_tube_xxs", "ar_prop_ar_tube_xs", "ar_prop_ar_tube_s", "ar_prop_ar_tube_m", "ar_prop_ar_tube_l", "ar_prop_ar_tube_crn", "ar_prop_ar_tube_crn_5d", "ar_prop_ar_tube_crn_15d", "ar_prop_ar_tube_crn_30d", "ar_prop_ar_tube_crn2", "ar_prop_ar_tube_qg", "ar_prop_ar_tube_hg", "ar_prop_ar_tube_jmp", "as_prop_as_tube_gap_02", "ar_prop_ar_tube_speed", "ar_prop_ar_tube_fork", "ar_prop_ar_tube_cross", "ar_prop_ar_tube_2x_xxs", "ar_prop_ar_tube_2x_xs", "ar_prop_ar_tube_2x_s", "ar_prop_ar_tube_2x_m", "ar_prop_ar_tube_2x_l", "ar_prop_ar_tube_2x_gap_02", "ar_prop_ar_tube_2x_crn", "ar_prop_ar_tube_2x_crn2", "ar_prop_ar_tube_2x_crn_30d", "ar_prop_ar_tube_2x_crn_15d", "ar_prop_ar_tube_2x_crn_5d", "ar_prop_ar_tube_2x_speed", "ar_prop_ar_tube_4x_xxs", "ar_prop_ar_tube_4x_xs", "ar_prop_ar_tube_4x_s", "ar_prop_ar_tube_4x_m", "ar_prop_ar_tube_4x_l", "ar_prop_ar_tube_4x_gap_02", "ar_prop_ar_tube_4x_crn", "ar_prop_ar_tube_4x_crn2", "ar_prop_ar_tube_4x_crn_30d", "ar_prop_ar_tube_4x_crn_15d", "ar_prop_ar_tube_4x_crn_5d", "ar_prop_ar_tube_4x_speed"},
		index = 1
	},
	{
		class = "36",
		model = {"ar_prop_ar_checkpoint_xxs", "ar_prop_ar_checkpoint_xs", "ar_prop_ar_checkpoint_s", "ar_prop_ar_checkpoint_m", "ar_prop_ar_checkpoint_l", "ar_prop_ar_checkpoint_crn", "ar_prop_ar_checkpoints_crn_5d", "ar_prop_ar_checkpoint_crn_15d", "ar_prop_ar_checkpoint_crn_30d", "ar_prop_ar_checkpoint_crn02", "ar_prop_ar_checkpoint_fork"},
		index = 1
	},
	{
		class = "37",
		model = {"ar_prop_ar_neon_gate_01a", "ar_prop_ar_neon_gate_01b", "ar_prop_ar_neon_gate_02a", "ar_prop_ar_neon_gate_02b", "ar_prop_ar_neon_gate_03a", "ar_prop_ar_neon_gate_04a", "ar_prop_ar_neon_gate_05a"},
		index = 1
	},
	{
		class = "38",
		model = {"ar_prop_inflategates_cp", "ar_prop_inflategates_cp_h1", "ar_prop_inflategates_cp_h2", "ar_prop_inflategates_cp_loop", "ar_prop_inflategates_cp_loop_h1", "ar_prop_inflategates_cp_loop_h2", "ar_prop_inflategates_cp_loop_01a", "ar_prop_inflategates_cp_loop_01b", "ar_prop_inflategates_cp_loop_01c", "ar_prop_gate_cp_90d", "ar_prop_gate_cp_90d_h1", "ar_prop_gate_cp_90d_h2", "ar_prop_gate_cp_90d_01a", "ar_prop_gate_cp_90d_01b", "ar_prop_gate_cp_90d_01c", "ar_prop_ig_sprunk_cp_single", "ar_prop_ig_raine_cp_single", "ar_prop_ig_flow_cp_single", "ar_prop_ig_shark_cp_single", "ar_prop_ig_jackal_cp_single", "ar_prop_ig_metv_cp_single", "ar_prop_ig_sprunk_cp_b", "ar_prop_ig_raine_cp_b", "ar_prop_ig_flow_cp_b", "ar_prop_ig_shark_cp_b", "ar_prop_ig_jackal_cp_b", "ar_prop_ig_metv_cp_b"},
		index = 1
	},
	{
		class = "39",
		model = {"sum_prop_track_pit_garage_05a", "sum_prop_track_pit_garage_04a", "sum_prop_track_pit_garage_03a", "sum_prop_track_pit_garage_02a", "ch_prop_track_pit_garage_01a", "sum_prop_ac_track_paddock_01", "sum_prop_ac_pit_garage_01a", "sum_prop_ac_grandstand_01a"},
		index = 1
	},
	{
		class = "40",
		model = {"prop_crate_11e", "v_ret_ml_beerpat1", "v_ret_ml_beerpis2", "ba_prop_battle_crate_beer_01", "ba_prop_battle_crate_beer_02", "ba_prop_battle_crate_beer_03", "ba_prop_battle_crate_beer_04", "prop_dyn_pc", "prop_dummy_01", "prop_ped_gib_01", "ba_prop_battle_ps_box_01", "prop_wall_light_09a", "ba_prop_battle_emis_rig_01", "ba_prop_battle_emis_rig_02", "ba_prop_battle_emis_rig_03", "ba_prop_battle_emis_rig_04", "vw_prop_vw_radiomast_01a", "vw_prop_vw_valet_01a", "ch_prop_boring_machine_01a", "ch_prop_boring_machine_01b", "ch_prop_ch_cctv_wall_atta_01a", "ch_prop_fingerprint_scanner_01a", "ch_prop_fingerprint_scanner_01b", "ch_prop_fingerprint_scanner_01c", "ch_prop_fingerprint_scanner_01d", "ch_prop_fingerprint_scanner_error_01b", "ch_prop_ch_sec_cabinet_02a", "ch_prop_ch_trolly_01a", "ch_prop_ch_laundry_trolley_01a", "ch_prop_ch_laundry_trolley_01b", "ch_prop_ch_maint_sign_01", "sum_prop_ac_barge_01", "sum_prop_ac_ind_light_02a", "sum_prop_ac_ind_light_03c", "sum_prop_ac_ind_light_04", "sum_prop_ac_wall_light_09a", "h4_prop_h4_tannoy_01a", "h4_prop_h4_sign_cctv_01a", "h4_prop_h4_sub_kos", "h4_prop_h4_sec_cabinet_dum", "h4_prop_h4_loch_monster", "h4_prop_h4_cctv_pole_04", "h4_prop_h4_t_bottle_02a", "h4_prop_h4_neck_disp_01a", "h4_prop_h4_necklace_01a", "h4_prop_h4_art_pant_01a", "h4_prop_h4_diamond_disp_01a", "h4_prop_h4_diamond_01a", "gr_prop_inttruck_door_01", "gr_prop_gr_trailer_tv", "gr_prop_gr_trailer_tv_02", "gr_prop_gr_trailer_monitor_01", "gr_prop_gr_trailer_monitor_02", "gr_prop_gr_trailer_monitor_03", "tr_prop_tr_ramp_01a", "v_ilev_gb_vauldr", "tr_prop_tr_iaa_door_01a", "tr_prop_tr_sand_01a", "tr_prop_tr_sand_01b", "tr_prop_tr_sand_cs_01a", "tr_prop_tr_sand_cs_01b", "tr_prop_tr_notice_01a", "sf_prop_sf_door_hangar_01a", "sf_prop_sf_dj_desk_01a", "prop_air_stair_01", "prop_air_stair_02", "prop_air_trailer_1b", "prop_air_bagloader2_cr", "sf_prop_sf_laptop_01a", "sf_prop_sf_speaker_l_01a", "sf_prop_sf_spa_doors_01a", "sf_prop_sf_art_guns_01a", "sf_prop_sf_dj_desk_02a", "sf_prop_sf_box_wood_01a", "sf_prop_sf_structure_01a", "sf_prop_sf_fnc_01a", "sf_prop_sf_wall_block_01a", "sf_prop_sf_hydro_platform_01a", "sf_prop_sf_carrier_jet", "sf_prop_sf_air_generator_01", "prop_cctv_cam_07a", "sf_prop_sf_lamp_studio_02a", "reh_prop_reh_bomb_tech_01b", "reh_prop_reh_case_drone_01a", "reh_prop_reh_bomb_tech_01a", "xm3_prop_xm3_walloverlay", "xm3_prop_xm3_door_whs_01a", "xm3_prop_xm3_tent_01a", "xm3_prop_xm3_sign_plate_01a", "xm3_prop_xm3_bag_grinder_01a", "xm3_prop_xm3_box_pharma_01a", "m23_1_prop_m31_railstack_01a", "m23_1_prop_m31_mogul_crashed", "m23_2_prop_m32_desk_01a", "m23_2_prop_m32_poster_01a", "m23_2_prop_m32_bag_marabunta_01a", "m23_2_prop_m32_bag_professionals_01a", "m23_2_prop_m32_bag_army_01a", "m23_2_prop_m32_cfdoor_back_01a", "m23_2_prop_m32_cfdoor_front_01a", "m23_2_prop_m32_lgt_off_01a", "m24_1_prop_m41_door_whs_01a", "m24_1_prop_m41_radiomast_01a", "xm3_prop_xm3_cover_veh_01a", "xm3_prop_xm3_cover_veh_02a", "m24_1_farm_extra_dressing", "m24_1_prop_m41_farm_door_01a", "m24_1_prop_m41_hull_gap_01a", "m24_1_prop_m41_lift_01a", "m24_1_prop_m41_elevatorpanel_01a", "m24_1_prop_m41_outofordersign_01a", "prop_aircon_m_10", "m24_1_prop_m41_orbital_screen_01a", "m24_2_prop_m42_shipwreck_01a", "m24_2_prop_m42_shipdebris_01a", "m24_2_prop_m42_shipdebris_02a", "m24_2_prop_m42_shipdebris_03a", "m24_2_prop_m42_drone_station_01a", "reh_prop_reh_serversml_01a", "m25_1_prop_m51_curtainpenthouse_01a", "m25_1_prop_m51_ladder_block_01a", "m25_1_prop_m51_dock_crane_01a", "m25_1_prop_m51_curtainbdrm_01a", "m25_1_prop_m51_curtainbdrm_02a", "prop_cleaning_trolly", "m23_2_prop_m32_arena_wall", "xm_prop_base_staff_desk_01", "sf_prop_sf_phonebox_01b_s", "v_res_filebox01", "sf_prop_sf_monitor_01a", "tr_prop_tr_ser_storage_01a", "m24_1_prop_m41_server_01b", "m25_2_prop_m52_planter_low", "m25_2_prop_m52_planter_02_low", "m25_2_prop_m52_planter_03_low", "m25_2_prop_m52_planter_mid", "m25_2_prop_m52_planter_02_mid", "m25_2_prop_m52_planter_03_mid", "m25_2_prop_m52_planter_tall", "m25_2_prop_m52_planter_02_tall", "m25_2_prop_m52_planter_03_tall", "m26_1_prop_m61_trolly_01a", "m26_1_prop_m61_cctvstation_01a", "m26_1_prop_m61_cctvstation_02a", "m26_1_prop_m61_cctvmount_02a"},
		index = 1
	},
	{
		class = "41",
		model = {"prop_studio_light_01", "prop_studio_light_02", "prop_studio_light_03", "prop_kino_light_02", "prop_kino_light_03", "prop_scrim_02", "p_tv_cam_02_s", "m24_1_prop_m41_film_cam_01a", "m24_1_prop_m41_dolly_01a", "m24_1_prop_m41_dolly_02a", "prop_direct_chair_01", "m24_1_prop_m41_movie_trailer_01a", "m24_1_prop_m41_studiocard_01a", "m24_1_prop_m41_emblmtable_01a", "prop_clothes_rail_01", "m24_1_prop_m41_rug_01a", "prop_ven_market_stool", "prop_ven_market_table1"},
		index = 1
	},
	{
		class = "42",
		model = {"xs_prop_arena_pit_fire_01a", "xs_prop_arena_pit_fire_02a", "xs_prop_arena_pit_fire_03a", "xs_prop_arena_pit_fire_04a", "xs_prop_arena_flipper_small_01a", "xs_prop_arena_flipper_large_01a", "xs_prop_arena_flipper_xl_01a", "xs_prop_arena_bollard_rising_01a", "xs_prop_arena_bollard_rising_01b", "xs_prop_arena_bollard_side_01a", "xs_prop_arena_pit_double_01b", "xs_prop_arena_landmine_01a", "xs_prop_arena_barrel_01a", "xs_prop_arena_landmine_03a", "xs_prop_arena_landmine_01c", "xs_prop_arena_turntable_01a", "xs_prop_arena_turntable_02a", "xs_prop_arena_turntable_03a", "xs_prop_arena_wall_rising_01a", "xs_prop_arena_wall_rising_02a"},
		index = 1
	},
	{
		class = "43",
		model = {"xs_prop_arena_pit_fire_01a_sf", "xs_prop_arena_pit_fire_02a_sf", "xs_prop_arena_pit_fire_03a_sf", "xs_prop_arena_pit_fire_04a_sf", "xs_prop_arena_flipper_small_01a_sf", "xs_prop_arena_flipper_large_01a_sf", "xs_prop_arena_flipper_xl_01a_sf", "xs_prop_arena_bollard_rising_01a_sf", "xs_prop_arena_bollard_rising_01b_sf", "xs_prop_arena_bollard_side_01a_sf", "xs_prop_arena_pit_double_01b_sf", "xs_prop_arena_landmine_01c_sf", "xs_prop_arena_barrel_01a_sf", "xs_prop_arena_landmine_03a_sf", "xs_prop_arena_turntable_01a_sf", "vw_prop_arena_turntable_02f_sf", "xs_prop_arena_turntable_03a_sf", "xs_prop_arena_wall_rising_01a_sf", "xs_prop_arena_wall_rising_02a_sf"},
		index = 1
	},
	{
		class = "44",
		model = {"xs_prop_arena_pit_fire_01a_wl", "xs_prop_arena_pit_fire_02a_wl", "xs_prop_arena_pit_fire_03a_wl", "xs_prop_arena_pit_fire_04a_wl", "xs_prop_arena_flipper_small_01a_wl", "xs_prop_arena_flipper_large_01a_wl", "xs_prop_arena_flipper_xl_01a_wl", "xs_prop_arena_bollard_rising_01a_wl", "xs_prop_arena_bollard_rising_01b_wl", "xs_prop_arena_bollard_side_01a_wl", "xs_prop_arena_pit_double_01b_wl", "xs_prop_arena_landmine_01c_wl", "xs_prop_arena_barrel_01a_wl", "xs_prop_arena_landmine_03a_wl", "xs_prop_arena_turntable_01a_wl", "xs_prop_arena_turntable_02a_wl", "xs_prop_arena_turntable_03a_wl", "xs_prop_arena_wall_rising_01a_wl", "xs_prop_arena_wall_rising_02a_wl"},
		index = 1
	},
	{
		class = "45",
		model = {"xs_prop_arena_pressure_plate_01a", "xs_prop_arena_car_wall_01a", "xs_prop_arena_car_wall_02a", "xs_prop_arena_car_wall_03a", "xs_prop_arena_station_01a", "xs_prop_arena_station_02a", "xs_prop_arena_wedge_01a", "xs_prop_arena_oil_jack_01a", "xs_prop_arena_oil_jack_02a", "xs_prop_arena_wall_01c", "xs_prop_arena_wall_01b", "xs_prop_arena_wall_01a", "xs_prop_arena_building_01a", "xs_prop_arena_industrial_a", "xs_prop_arena_industrial_b", "xs_prop_arena_industrial_c", "xs_prop_arena_industrial_d", "xs_prop_arena_industrial_e", "xs_prop_arena_1bay_01a", "xs_prop_arena_2bay_01a", "xs_prop_arena_3bay_01a", "xs_prop_arena_goal", "xs_prop_arena_gate_01a", "xs_prop_arena_tower_01a", "xs_prop_arena_tower_02a", "xs_prop_arena_startgate_01a", "xs_prop_arena_arrow_01a", "xs_prop_arena_wall_02a", "xs_prop_arena_tower_04a", "xs_prop_wall_tyre_01a", "xs_prop_wall_tyre_l_01a", "xs_prop_wall_tyre_start_01a", "xs_prop_wall_tyre_end_01a", "xs_prop_arrow_tyre_01a", "xs_prop_arrow_tyre_01b", "xs_prop_arena_turntable_b_01a", "xs_prop_arena_pipe_track_c_01a", "xs_prop_arena_pipe_track_c_01b", "xs_prop_arena_pipe_track_c_01c", "xs_prop_arena_pipe_track_c_01d", "xs_prop_arena_pipe_track_s_01a", "xs_prop_arena_pipe_track_s_01b", "xs_prop_arena_pipe_bend_01a", "xs_prop_arena_pipe_bend_01b", "xs_prop_arena_pipe_bend_01c", "xs_prop_arena_pipe_bend_02a", "xs_prop_arena_pipe_bend_02b", "xs_prop_arena_pipe_bend_02c", "xs_prop_arena_pipe_end_01a", "xs_prop_arena_pipe_end_02a", "xs_prop_arena_pipe_machine_01a", "xs_prop_arena_pipe_machine_02a", "xs_prop_arena_pipe_straight_01a", "xs_prop_arena_pipe_straight_01b", "xs_prop_arena_pipe_straight_02a", "xs_prop_arena_pipe_straight_02b", "xs_prop_arena_pipe_straight_02c", "xs_prop_arena_pipe_straight_02d", "xs_prop_arena_pipe_transition_01a", "xs_prop_arena_pipe_transition_01b", "xs_prop_arena_pipe_transition_01c", "xs_prop_arena_pipe_transition_02a", "xs_prop_arena_pipe_transition_02b", "xs_prop_barrier_5m_01a", "xs_prop_barrier_10m_01a", "xs_prop_barrier_15m_01a", "xs_prop_ar_tunnel_01a", "xs_prop_arena_spikes_01a"},
		index = 1
	},
	{
		class = "46",
		model = {"xs_prop_arena_jump_xs_01a", "xs_prop_arena_jump_s_01a", "xs_prop_arena_jump_m_01a", "xs_prop_arena_jump_l_01a", "xs_prop_arena_jump_xl_01a", "xs_prop_arena_jump_xxl_01a", "xs_prop_arena_adj_hloop", "xs_prop_arena_jump_02b", "xs_prop_arena_pipe_ramp_01a", "xs_prop_arena_jump_xs_01a_sf", "xs_prop_arena_jump_s_01a_sf", "xs_prop_arena_jump_m_01a_sf", "xs_prop_arena_jump_l_01a_sf", "xs_prop_arena_jump_xl_01a_sf", "xs_prop_arena_jump_xxl_01a_sf", "xs_prop_arena_adj_hloop_sf", "xs_prop_arena_jump_xs_01a_wl", "xs_prop_arena_jump_s_01a_wl", "xs_prop_arena_jump_m_01a_wl", "xs_prop_arena_jump_l_01a_wl", "xs_prop_arena_jump_xl_01a_wl", "xs_prop_arena_jump_xxl_01a_wl", "xs_prop_arena_adj_hloop_wl"},
		index = 1
	},
	{
		class = "47",
		model = {"xs_prop_arena_pressure_plate_01a_sf", "xs_prop_arena_wedge_01a_sf", "xs_prop_arena_goal_sf", "xs_prop_arena_wall_02a_sf", "xs_prop_arrow_tyre_01a_sf", "xs_prop_arrow_tyre_01b_sf", "xs_prop_arena_arrow_01a_sf", "xs_prop_arena_startgate_01a_sf", "xs_prop_ar_planter_s_45a_sf", "xs_prop_ar_planter_s_90a_sf", "xs_prop_ar_planter_s_180a_sf", "xs_prop_ar_planter_m_30a_sf", "xs_prop_ar_planter_m_30b_sf", "xs_prop_ar_planter_m_60a_sf", "xs_prop_ar_planter_m_60b_sf", "xs_prop_ar_planter_m_90a_sf", "xs_prop_ar_tower_01a_sf", "xs_prop_ar_pipe_conn_01a_sf", "xs_prop_ar_stand_thick_01a_sf", "xs_prop_ar_pipe_01a_sf", "xs_prop_ar_gate_01a_sf", "xs_prop_ar_planter_xl_01a_sf", "xs_prop_ar_planter_m_01a_sf", "xs_prop_ar_planter_s_01a_sf", "xs_prop_ar_planter_c_01a_sf", "xs_prop_ar_planter_c_02a_sf", "xs_prop_ar_planter_c_03a_sf", "xs_prop_ar_buildingx_01a_sf", "xs_prop_ar_tunnel_01a_sf", "xs_prop_arena_spikes_01a_sf"},
		index = 1
	},
	{
		class = "48",
		model = {"xs_prop_arena_pressure_plate_01a_wl", "xs_prop_arena_wedge_01a_wl", "xs_prop_arena_wall_02a_wl", "xs_prop_arrow_tyre_01a_wl", "xs_prop_arrow_tyre_01b_wl", "xs_prop_arena_arrow_01a_wl", "xs_prop_ar_tunnel_01a_wl", "xs_prop_lplate_01a_wl", "xs_prop_lplate_bend_01a_wl", "xs_prop_lplate_wall_01a_wl", "xs_prop_lplate_wall_01b_wl", "xs_prop_lplate_wall_01c_wl", "xs_prop_beer_bottle_wl", "xs_prop_burger_meat_wl", "xs_prop_can_tunnel_wl", "xs_prop_can_wl", "xs_prop_chips_tube_wl", "xs_prop_chopstick_wl", "xs_prop_gate_tyre_01a_wl", "xs_prop_hamburgher_wl", "xs_prop_nacho_wl"},
		index = 1
	},
	{
		class = "49",
		model = {"xs_prop_arena_fence_01a", "xs_prop_arena_fence_01a_sf", "xs_prop_arena_fence_01a_wl"},
		index = 1
	},
	{
		class = "50",
		model = {"xs_prop_arena_turret_01a", "xs_prop_arena_turret_01a_sf", "xs_prop_arena_turret_01a_wl", "xs_prop_arena_finish_line"},
		index = 1
	},
	{
		class = "51",
		model = {"ch_prop_ch_cctv_cam_01a", "ch_prop_ch_cctv_cam_02a", "xm_prop_x17_server_farm_cctv_01", "hei_prop_bank_cctv_01", "hei_prop_bank_cctv_02", "prop_cctv_cam_05a", 825790471},
		index = 1
	},
	{
		class = "52",
		model = {"tr_prop_tr_wall_sign_0l1", "tr_prop_tr_wall_sign_0l1_b", "m23_2_prop_m32_tyre_wall_u_l", "tr_prop_tr_tyre_wall_u_l", "tr_prop_tr_wall_sign_0r1", "tr_prop_tr_wall_sign_0r1_b", "m23_2_prop_m32_tyre_wall_u_r", "tr_prop_tr_tyre_wall_u_r", "tr_prop_tr_wall_sign_01", "tr_prop_tr_wall_sign_01_b", "tr_prop_tr_start_grid_01a", "tr_prop_tr_finish_line_01a", "tr_prop_tr_sign_gf_ml_01a", "tr_prop_tr_sign_gf_mr_01a", "tr_prop_tr_sign_gf_mul_01a", "tr_prop_tr_sign_gf_mur_01a", "tr_prop_tr_sign_gf_ms_01a", "tr_prop_tr_sign_gf_ll_01a", "tr_prop_tr_sign_gf_lr_01a", "tr_prop_tr_sign_gf_lul_01a", "tr_prop_tr_sign_gf_lur_01a", "tr_prop_tr_sign_gf_ls_01a", "m23_2_prop_m32_tyre_wall_gs_01a", "m23_2_prop_m32_wall_sign_0r1", "m23_2_prop_m32_wall_sign_0l1"},
		index = 1
	},
	{
		class = "53",
		model = {"m23_1_prop_m31_coffin_pile_01a", "m23_1_prop_m31_gravestones_01a", "m23_1_prop_m31_gravestones_02a", "m23_1_prop_m31_gravestones_07a", "m23_1_prop_m31_gravetomb_01a", "m23_1_prop_m31_orn_bat_01a", "reh_prop_reh_lantern_pk_01a", "reh_prop_reh_lantern_pk_01b", "reh_prop_reh_lantern_pk_01c", "m23_2_prop_m32_candycane_01a", "m23_2_prop_m32_giftbox_small_01a", "m23_2_prop_m32_giftbox_med_01a", "m23_2_prop_m32_giftbox_long_01a", "m23_2_prop_m32_giftbox_lar_01a", "m23_2_prop_m32_giftbox_xlar_01a", "m23_2_prop_m32_lights_xsmall_01a", "m23_2_prop_m32_lights_small_01a", "m23_2_prop_m32_lights_med_01a", "m23_2_prop_m32_lights_lar_01a", "m23_2_prop_m32_lights_xlar_01a", "m23_2_prop_m32_ice_block_01a", "m23_2_prop_m32_ice_block_02a", "m23_2_prop_m32_ice_block_03a", "m23_2_prop_m32_ice_block_04a", "m23_2_prop_m32_ice_block_05a", "m23_2_prop_m32_ice_block_01b", "m23_2_prop_m32_ice_block_02b", "m23_2_prop_m32_ice_block_03b", "m23_2_prop_m32_ice_block_04b", "m23_2_prop_m32_ice_block_05b", "m23_2_prop_m32_snowwall_s_01a", "m23_2_prop_m32_snowwall_m_01a", "m23_2_prop_m32_snowwall_l_01a", "m23_2_prop_m32_snowwall_xl_01a", "m23_2_prop_m32_snowfort_01a", "m23_2_prop_m32_xmaxtree_s_01a", "m23_2_prop_m32_xmaxtree_m_01a", "m23_2_prop_m32_xmaxtree_l_01a", "m23_2_prop_m32_sleigh_01a", "m24_2_prop_m42_gantry_01a", "m24_2_prop_m42_gantry_02a", "m24_2_prop_m42_start_gantry_01a", "m24_2_prop_am_fence_bamboo_sht", "m24_2_prop_am_fence_bamboo_med", "m24_2_prop_am_fence_bamboo_lng", "m24_2_prop_am_fence_bamboo_xl", "m24_2_prop_m42_lunar_sign_01", "m24_2_prop_m42_lunar_sign_02", "m24_2_prop_m42_lunar_sign_03", "m24_2_prop_m42_lunar_sign_04", "m24_2_prop_m42_lunar_sign_06", "m24_2_prop_m42_lunar_sign_07", "m24_2_prop_m42_lunar_sign_08", "m24_2_prop_m42_lunar_sign_09", "m24_2_prop_m42_lunar_sign_10", "m24_2_prop_m42_lunar_sign_11", "m24_2_prop_m42_lunar_sign_12", "m24_2_prop_m42_lunar_sign_13", "m24_2_prop_m42_lunar_sign_01b", "m24_2_prop_m42_lunar_sign_02b", "m24_2_prop_m42_lunar_sign_03b", "m24_2_prop_m42_lunar_sign_04b", "m24_2_prop_m42_lunar_sign_06b", "m24_2_prop_m42_lunar_sign_07b", "m24_2_prop_m42_lunar_sign_08b", "m24_2_prop_m42_lunar_sign_09b", "m24_2_prop_m42_lunar_sign_10b", "m24_2_prop_m42_lunar_sign_11b", "m24_2_prop_m42_lunar_sign_12b", "m24_2_prop_m42_lunar_sign_13b", "m24_2_prop_m42_foo_statue_01a", "m24_2_prop_m42_pagoda_base_01a", "m24_2_prop_m42_pagoda_roof_01a", "m25_2_prop_m52_pagoda_base_01a", "m25_2_prop_m52_pagoda_roof_01a"},
		index = 1
	},
	{
		class = "54",
		model = {"m23_2_prop_m32_curb_str_s_01a", "m23_2_prop_m32_curb_str_m_01a", "m23_2_prop_m32_curb_str_l_01a", "m23_2_prop_m32_curb_str_xl_01a", "m24_1_prop_m41_curb_5_01a", "m24_1_prop_m41_curb_15_01a", "m24_1_prop_m41_curb_45_01a", "m23_2_prop_m32_curb_90_01a", "m23_2_prop_m32_curb_str_s_01b", "m23_2_prop_m32_curb_str_m_01b", "m23_2_prop_m32_curb_str_l_01b", "m23_2_prop_m32_curb_str_xl_01b", "m24_1_prop_m41_curb_5_01b", "m24_1_prop_m41_curb_15_01b", "m24_1_prop_m41_curb_45_01b", "m23_2_prop_m32_curb_90_01b", "m23_2_prop_m32_curb_str_s_01c", "m23_2_prop_m32_curb_str_m_01c", "m23_2_prop_m32_curb_str_l_01c", "m23_2_prop_m32_curb_str_xl_01c", "m24_1_prop_m41_curb_5_01c", "m24_1_prop_m41_curb_15_01c", "m24_1_prop_m41_curb_45_01c", "m23_2_prop_m32_curb_90_01c", "m23_2_prop_m32_curb_str_s_01d", "m23_2_prop_m32_curb_str_m_01d", "m23_2_prop_m32_curb_str_l_01d", "m23_2_prop_m32_curb_str_xl_01d", "m24_1_prop_m41_curb_5_01d", "m24_1_prop_m41_curb_15_01d", "m24_1_prop_m41_curb_45_01d", "m23_2_prop_m32_curb_90_01d", "m23_2_prop_m32_curb_str_s_01e", "m23_2_prop_m32_curb_str_m_01e", "m23_2_prop_m32_curb_str_l_01e", "m23_2_prop_m32_curb_str_xl_01e", "m24_1_prop_m41_curb_5_01e", "m24_1_prop_m41_curb_15_01e", "m24_1_prop_m41_curb_45_01e", "m23_2_prop_m32_curb_90_01e"},
		index = 1
	},
	{
		class = "55",
		model = {"m23_2_prop_m32_lgt_on_01a"},
		index = 1
	},
	{
		class = "56",
		model = {"p_spinning_anus_s", "imp_prop_ship_01a", "gr_prop_damship_01a", "sum_prop_dufocore_01a", "p_tram_crash_s", "prop_med_jet_01", "prop_aircon_l_01", "prop_aircon_l_02", "prop_aircon_l_04", "prop_asteroid_01", "prop_beachflag_01", "prop_temp_carrier", "prop_sec_barier_01a", "prop_skid_pillar_01", "prop_barrier_wat_03b", "prop_inflategate_01", "prop_dock_crane_02_ld", "prop_dock_crane_02_cab", "prop_dock_rtg_ld", "xm_prop_base_blast_door_02_l", "xm_prop_base_blast_door_02_r", "sum_prop_hangerdoor_01a", "prop_inflatearch_01", "xm_prop_x17_rig_osphatch", "prop_crashed_heli", "p_crahsed_heli_s", "hei_prop_carrier_light_01", "prop_skid_pillar_02", "prop_pipes_03a", "prop_pipes_ld_01", "p_oil_pjack_01_s", "p_oil_pjack_02_s", "p_oil_pjack_03_s", "prop_ld_dstplanter_02", "prop_ld_dstplanter_01", "prop_plate_stand_01", "prop_pile_dirt_07_cr", "prop_offroad_tyres01_tu", "prop_mp_barrier_01b", "prop_test_boulder_01", "prop_test_boulder_02", "prop_test_boulder_03", "prop_test_boulder_04", "prop_test_rocks03", "hei_prop_carrier_radar_2", "xs_prop_arena_turret_post_01a", "prop_ind_crusher", "prop_beer_neon_01", "prop_pharm_sign_01", "xm_prop_x17_silo_door_r_01a", "prop_skate_flatramp_cr", "prop_skate_halfpipe_cr", "prop_lev_des_barge_02", "prop_prlg_snowpile", "prop_start_finish_line_01", "prop_triple_grid_line", "prop_streetlight_16a", "prop_streetlight_12b", "prop_streetlight_05_b", "prop_streetlight_03d", "prop_rub_pile_04", "prop_air_blastfence_01", "prop_air_blastfence_02", "prop_ld_fragwall_01b", "prop_windmill_01", "prop_rural_windmill"},
		index = 1
	},
	{
		class = "57",
		model = {"m25_1_prop_m51_bed_01a", "m25_1_prop_m51_bed_02a", "m25_1_prop_m51_dinetable_01a", "prop_fbi3_coffee_table", "m25_1_prop_m51_coffeetable_01a", "h4_mp_h_yacht_coffee_table_01", "m25_1_prop_m51_lowtable_01a", "sum_mp_h_yacht_coffee_table_02", "m25_1_prop_m51_smallsidetable_01a", "m25_2_prop_m52_desk_01a", "m25_2_prop_m52_table_square_01a", "m25_2_prop_m52_table_round_01a", "gr_dlc_gr_yacht_props_table_03", "prop_table_04", "hei_prop_yah_table_01", "prop_table_tennis", "prop_ld_farm_chair01", "m25_1_prop_m51_chairarm_01a", "m25_1_prop_m51_dinechair_01a", "prop_chair_07", "prop_off_chair_05", "sm_prop_smug_offchair_01a", "h4_prop_battle_club_chair_03", "ex_prop_offchair_exec_04", "p_yacht_chair_01_s", "m25_2_prop_m52_armchair_01", "v_ilev_p_easychair", "m25_1_prop_m51_sofa_01a", "m25_1_prop_m51_couchlarge_01a", "m25_1_prop_m51_couchlarge_02a", "m25_1_prop_m51_couchsmall_01a", "m25_1_prop_m51_couchsmall_02a", "m25_2_prop_m52_sofa_round_01a", "m25_2_prop_m52_sofa_corner_01a", "m25_2_prop_m52_sofa_small_01a", "p_yacht_sofa_01_s", "m25_2_prop_m52_sofa_01a", "m25_2_prop_m52_r_sofa_01", "m25_1_prop_m51_shelfwallm_01a", "m25_1_prop_m51_shelffloor_01a", "m25_1_prop_m51_tvstand_01a", "m25_1_prop_m51_storageunit_01a", "m25_1_prop_m51_bedsidetable_01a", "m25_1_prop_m51_bedsidetable_02a", "m25_1_prop_m51_cabinet_01a", "m25_1_prop_m51_wardrobe_01a", "m25_2_prop_m52_offshelfdark", "m25_2_prop_m52_cash_trolly_empty"},
		index = 1
	},
	{
		class = "58",
		model = {"m25_1_prop_m51_posters_01a", "m25_1_prop_m51_pornmag_01a", "m25_1_prop_m51_basketmess_01a", "m25_1_prop_m51_paper_news_quik", "m25_1_prop_m51_mlaundry_01a", "m25_1_prop_m51_sculpt_01a", "m25_1_prop_m51_sculpt_02a"},
		index = 1
	},
	{
		class = "59",
		model = {"m24_1_prop_m41_kino_light_01a", "m24_1_prop_m41_scrim_01a", "m24_1_prop_m41_rm_crate_s_01a", "m24_1_prop_m41_rm_crate_m_01a", "m24_1_prop_m41_rm_crate_l_01a", "m24_1_prop_m41_camera_01a", "m25_2_prop_m52_fakebloodcan_hl_01a", "m25_2_prop_m52_greenscreen_01a", "prop_ld_greenscreen_01", "m24_1_prop_m41_greenscreen_01b", "m24_1_prop_m41_greenscreen_01a", "m24_1_prop_m41_greenscreen_01c", "m24_1_prop_m41_greenscreen_01d"},
		index = 1
	},
	{
		class = "60",
		model = {"m26_1_prop_m61_jewel_01a", "m26_1_prop_m61_jewel_01b", "m26_1_prop_m61_jewel_01c", "m26_1_prop_m61_jewel_01d", "m26_1_prop_m61_jewel_01e", "m26_1_prop_m61_jewel_01f", "m26_1_prop_m61_jewel_01g", "m26_1_prop_m61_art_statue_01a", "m26_1_prop_m61_art_statue_01b", "m26_1_prop_m61_art_statue_01c", "m26_1_prop_m61_art_statue_01d", "m26_1_prop_m61_art_statue_01e", "m26_1_prop_m61_art_horse_01a", "m26_1_prop_m61_art_horse_01b", "m26_1_prop_m61_art_horse_01c", "m26_1_prop_m61_art_horse_01d", "m26_1_prop_m61_art_horse_01e", "m26_1_prop_m61_art_skull_01a", "m26_1_prop_m61_art_skull_01b", "m26_1_prop_m61_art_skull_01c", "m26_1_prop_m61_art_skull_01d", "m26_1_prop_m61_art_skull_01e", "m26_1_prop_m61_art_skull_01f", "m26_1_prop_m61_loot_rings_01a", "m26_1_prop_m61_loot_rings_01b", "m26_1_prop_m61_loot_rings_02a", "m26_1_prop_m61_loot_rings_02b", "m26_1_prop_m61_loot_rings_03a", "m26_1_prop_m61_loot_rings_03b", "m26_1_prop_m61_meteorite_01a", "m26_1_prop_m61_necklace_01a", "m26_1_prop_m61_necklace_01b", "m26_1_prop_m61_necklace_01c", "m26_1_prop_m61_necklace_01d", "m26_1_prop_m61_necklace_01e", "m26_1_prop_m61_necklace_01f", "m26_1_prop_m61_loot_bracelet_01a", "m26_1_prop_m61_loot_bracelet_02a", "m26_1_prop_m61_loot_bracelet_03a", "m26_1_prop_m61_loot_bracelet_04a", "m26_1_prop_m61_loot_bracelet_05a", "m26_1_prop_m61_papersign_01a", "m26_1_prop_m61_shinystones_01a", "m26_1_prop_m61_shinystones_02a", 261236581, -1487844143, 1605620817, -27934041, 2130847538, "m26_1_prop_m61_glass_disp_01b"},
		index = 1
	},
	{
		-- custom_creator_prop_1
		class = "61",
		model = {"building_airbridge01", "building_airport01", "building_airport02", "building_airport03", "building_airport04", "building_airport05", "building_airtower01", "building_airtower02", "building_apartment01", "building_apartment02", "building_apartment03", "building_apartment04", "building_apartment05", "building_apartment06", "building_apartment07", "building_apartment08", "building_apartment09", "building_apartment10", "building_apartment11", "building_apartment12", "building_apartment13", "building_apartment14", "building_apartment15", "building_apartment16", "building_apartment17", "building_apartment18", "building_apartment19", "building_apartment20", "building_apartment20_burntfront", "building_apartment20_warehouse", "building_apartment22", "building_apartment23", "building_apartment24", "building_apartment25", "building_apartment26", "building_autoshop01", "building_carpark01", "building_casino01", "building_church01", "building_church02", "building_cinema01", "building_cinema02", "building_cinema03", "building_cinema04", "building_cityhall", "building_dam01", "building_dam02", "building_dock_crane", "building_druglockup", "building_factory01", "building_factory02", "building_factory03", "building_factory04", "building_factory05", "building_factory06", "building_factory07", "building_factory08", "building_fakeshop01", "building_fakeshop02", "building_firestation01", "building_garage01", "building_gasstation01", "building_golfhouse", "building_gopostal01", "building_hanger01", "building_hospital01", "building_hotel01", "building_hotel02a", "building_hotel02b", "building_hotel02c", "building_hotel02d", "building_hotel02e", "building_hotel02f", "building_hotel02g", "building_hotel02h", "building_hotel02i", "building_hotel02j", "building_house01", "building_house02", "building_house03", "building_house04", "building_house05", "building_house06", "building_house07", "building_house08", "building_house09", "building_house10", "building_house11", "building_house12", "building_house13", "building_house14", "building_lighthouse01", "building_lighthouse02", "building_lodge", "building_nut_tower01", "building_nut_tower02", "building_nut_tower03", "building_nut_tower04", "building_pipes_01", "building_pipes_02", "building_pipes_03", "building_pipes_04", "building_policestation01", "building_policestation02", "building_radiotower01", "building_restaurant01", "building_safe_wall01", "building_satellite_dish01", "building_shack01", "building_shed01", "building_shed02", "building_sign01", "building_silo", "building_skatepark", "building_skyrise01", "building_skyrise02", "building_skyrise02b", "building_skyrise03", "building_skyrise04", "building_snowbank01", "building_snowbarn01", "building_snowbarn02", "building_snowchurch01", "building_snowcinema01", "building_snowhouse01", "building_snowwarehouse01", "building_snowwarehouse02", "building_stables01", "building_stables02", "building_stables03", "building_staircase01", "building_staircase02", "building_stands01", "building_stands02", "building_store01", "building_store02", "building_store03", "building_store04", "building_store05", "building_store06", "building_store07", "building_store08", "building_store09", "building_store10", "building_store11", "building_store12", "building_store13", "building_store14", "building_store15", "building_store16", "building_store17", "building_store18", "building_store19", "building_store20", "building_store21", "building_store22", "building_store23", "building_store24", "building_store25", "building_store26", "building_substation01", "building_tank01", "building_tank02", "building_tower_stack", "building_turbine_engine", "building_warehouse01", "building_warehouse02", "building_watchtower01", "building_watchtower02", "eg_map"},
		index = 1
	},
	{
		-- custom_creator_prop_2
		class = "62",
		model = {"interior_apartment01", "interior_apartment02", "interior_apartment03", "interior_autoshop", "interior_bathroomdetail01", "interior_bathroomdetail02", "interior_bathroomdetail03", "interior_bathroomdetail04", "interior_booth", "interior_booth_seat", "interior_car_meet", "interior_cinema", "interior_cinema_chairs_01", "interior_cinema_chairs_02", "interior_cinema_rail_01", "interior_cinema_rail_02", "interior_cinema_single_chair_01", "interior_closet", "interior_curtains_closed", "interior_curtains_open", "interior_drawers", "interior_fireplace", "interior_fridge", "interior_fumesink", "interior_growroom", "interior_hospital01", "interior_kitchendetail01", "interior_kitchendetail02", "interior_kitchendetail03", "interior_kitchendetail04", "interior_kitchendetail05", "interior_kitchendetail06", "interior_kitchendetail07", "interior_kitchendetail08", "interior_kitchendetail09", "interior_kitchendetail10", "interior_kitchendetail11", "interior_mines01", "interior_mines02", "interior_mines03", "interior_mines04", "interior_mines05", "interior_mines06", "interior_mines07", "interior_mines08", "interior_mugshot", "interior_multigarage01", "interior_multigarage02", "interior_multigarage03", "interior_multigarage04", "interior_neon_tubes", "interior_officedetail_01", "interior_officedetail_02", "interior_server_room_tower", "interior_sever_room", "interior_stairs01", "interior_windows", "interior_winning_room", "interior_xray"},
		index = 1
	},
	{
		-- custom_creator_prop_3
		class = "63",
		model = {"prop_balloons", "prop_barbed_wire01", "prop_barbed_wire02", "prop_barbed_wire03", "prop_beaver", "prop_block", "prop_desk01", "prop_dino", "prop_dusterwreck01", "prop_elevator01", "prop_fire01", "prop_fishtank", "prop_floor01", "prop_floor02", "prop_floor03", "prop_floor04", "prop_floor05", "prop_floor06", "prop_floor07", "prop_floor08", "prop_floor09", "prop_floor10", "prop_floor11", "prop_floor12", "prop_floor13", "prop_floor14", "prop_floor15", "prop_floor16", "prop_floor17", "prop_floor18", "prop_floor19", "prop_floor20", "prop_frozen_alien01", "prop_hatch", "prop_hospitaldetail01", "prop_hospitaldoor01", "prop_hospitaldoor02", "prop_housetruck", "prop_interiormines01", "prop_interiormines02", "prop_interiormines03", "prop_interiormines04", "prop_interiormines05", "prop_interiormines06", "prop_interiormines07", "prop_interiormines08", "prop_logger", "prop_LSIA", "prop_manaquin", "prop_old_xmaslights01", "prop_old_xmaslights02", "prop_old_xmaslights03", "prop_old_xmaslights04", "prop_ramp01", "prop_rcoasterentrance", "prop_rcoasterrail01", "prop_rcoasterrail02", "prop_red_carpet", "prop_rocket", "prop_sculpture01", "prop_sculpture02", "prop_sea_rubble01", "prop_ship01", "prop_ship02", "prop_shipwreck01", "prop_shipwreck02", "prop_sign01", "prop_stage", "prop_subwreck01", "prop_subwreck02", "prop_trainingplane", "prop_transmissiontower", "prop_tree_lights_blue01", "prop_tree_lights_blue02", "prop_tree_lights_blue03", "prop_tree_lights_green01", "prop_tree_lights_green02", "prop_tree_lights_green03", "prop_tree_lights_orange01", "prop_tree_lights_orange02", "prop_tree_lights_orange03", "prop_tree_lights_pink01", "prop_tree_lights_pink02", "prop_tree_lights_pink03", "prop_tree_lights_purple01", "prop_tree_lights_purple02", "prop_tree_lights_purple03", "prop_tree_lights_red01", "prop_tree_lights_red02", "prop_tree_lights_red03", "prop_tree_lights_white01", "prop_tree_lights_white02", "prop_tree_lights_white03", "prop_tree_lights_xmas01", "prop_tree_lights_yellow01", "prop_tree_lights_yellow02", "prop_tree_lights_yellow03", "prop_tube_blue", "prop_tube_green", "prop_tube_orange", "prop_tube_pink", "prop_tube_purple", "prop_tube_red", "prop_tube_white", "prop_tube_yellow", "prop_ufocar", "prop_water_wall_01", "prop_water_wall_02", "prop_weedtarp", "prop_xmaslights01", "prop_xmaslights02", "prop_xmaslights03", "prop_yacht01", "prop_yacht02"},
		index = 1
	},
	{
		-- custom_creator_prop_4
		class = "64",
		model = {"road_bridge01", "road_bridge01b", "road_bridge01c", "road_bridge01d", "road_bridge01e", "road_bridge02", "road_bridge03", "road_broken_bridge", "road_curved_snow01", "road_curved_snow02", "road_curved_snow03", "road_curved_snow04", "road_curved_snow05", "road_curved_snow06", "road_curved_snow07", "road_curved_snow08", "road_curved_snow09", "road_curved_snow10", "road_intersection_snow01", "road_intersection_snow02", "road_railbridge_snow01", "road_straight01", "road_straight_snow01", "road_straight_snow02", "road_straight_snow03", "road_straight_snow04", "road_straight_snow05", "road_straight_snow06", "road_straight_snow07", "road_straight_snow08", "road_straight_snow09", "road_town_snow01", "road_train_intersection_snow01", "road_trainrails_01", "road_trainrails_02", "road_trainrails_03", "road_trainrails_04", "road_trainrails_05", "road_trainrails_06", "road_trainrails_07", "road_trainrails_08", "road_trainrails_bridge_01", "road_trainrails_snow01", "road_trainrails_snow02", "road_trainrails_snow03", "road_trainrails_snow04", "road_tunnel01", "road_windy_snow01"},
		index = 1
	},
	{
		-- custom_creator_prop_5
		class = "65",
		model = {"terrain_alienmonument", "terrain_cave01", "terrain_dirthill01", "terrain_dirthill02", "terrain_dirthill03", "terrain_dirthill04", "terrain_forestgrasshill01", "terrain_forestgrasshill02", "terrain_forestgrasshill03", "terrain_forestgrasshill04", "terrain_frozen_river01", "terrain_frozen_river02", "terrain_frozen_river03", "terrain_grasshill01", "terrain_grasshill02", "terrain_grasshill03", "terrain_grasshill04", "terrain_graveclosed01", "terrain_graveopen01", "terrain_graveopen02", "terrain_grounddirt01", "terrain_groundforestgrass01", "terrain_groundgrass01", "terrain_groundsand01", "terrain_groundsnow01", "terrain_islanddirt01", "terrain_islanddirt02", "terrain_islanddirt03", "terrain_islanddirt04", "terrain_islanddirt05", "terrain_islanddirt06", "terrain_islanddirt07", "terrain_islanddirt08", "terrain_islanddirt09", "terrain_islanddirt10", "terrain_islandforestgrass01", "terrain_islandforestgrass02", "terrain_islandforestgrass03", "terrain_islandforestgrass04", "terrain_islandforestgrass05", "terrain_islandforestgrass06", "terrain_islandforestgrass07", "terrain_islandforestgrass08", "terrain_islandforestgrass09", "terrain_islandforestgrass10", "terrain_islandgrass01", "terrain_islandgrass02", "terrain_islandgrass03", "terrain_islandgrass04", "terrain_islandgrass05", "terrain_islandgrass06", "terrain_islandgrass07", "terrain_islandgrass08", "terrain_islandgrass09", "terrain_islandgrass10", "terrain_islandsand01", "terrain_islandsand02", "terrain_islandsand03", "terrain_islandsand04", "terrain_islandsand05", "terrain_islandsand06", "terrain_islandsand07", "terrain_islandsand08", "terrain_islandsand09", "terrain_islandsand10", "terrain_islandsnow01", "terrain_islandsnow02", "terrain_islandsnow03", "terrain_islandsnow04", "terrain_islandsnow05", "terrain_islandsnow06", "terrain_islandsnow07", "terrain_islandsnow08", "terrain_islandsnow09", "terrain_islandsnow10", "terrain_sandhill01", "terrain_sandhill02", "terrain_sandhill03", "terrain_sandhill04", "terrain_seawall01", "terrain_seawall02", "terrain_seawall03", "terrain_seawall04", "terrain_seawall05", "terrain_seawall06", "terrain_seawall07", "terrain_sewage_water01", "terrain_sewage_water02", "terrain_sewage_water03", "terrain_sewage_water04", "terrain_sewage_water05", "terrain_sewage_water06", "terrain_sewage_water07", "terrain_sewage_water08", "terrain_sewage_water09", "terrain_sewage_water10", "terrain_sewage_water11", "terrain_sewage_water12", "terrain_snowhill01", "terrain_snowhill02", "terrain_snowhill03", "terrain_snowhill04", "terrain_water01", "terrain_water02", "terrain_water03", "terrain_water04", "terrain_water05", "terrain_water06", "terrain_waterfountain"},
		index = 1
	}
}