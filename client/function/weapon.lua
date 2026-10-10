local categories = {
	["weapon-category-1"] = {
		weapons = {"WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_CROWBAR", "WEAPON_GOLFCLUB", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_KNUCKLE", "WEAPON_MACHETE", "WEAPON_FLASHLIGHT", "WEAPON_SWITCHBLADE", "WEAPON_BATTLEAXE", "WEAPON_POOLCUE", "WEAPON_WRENCH", "WEAPON_STONE_HATCHET", "WEAPON_CANDYCANE", "WEAPON_STUNROD"},
		order = 1
	},
	["weapon-category-2"] = {
		weapons = {"WEAPON_PUMPSHOTGUN", "WEAPON_PUMPSHOTGUN_MK2", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_DBSHOTGUN", "WEAPON_AUTOSHOTGUN", "WEAPON_COMBATSHOTGUN"},
		order = 2
	},
	["weapon-category-3"] = {
		weapons = {"WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG", "WEAPON_MINIGUN", "WEAPON_FIREWORK", "WEAPON_RAILGUNXM3", "WEAPON_HOMINGLAUNCHER", "WEAPON_COMPACTLAUNCHER", "WEAPON_RAYMINIGUN", "WEAPON_EMPLAUNCHER", "WEAPON_RAILGUN", "WEAPON_SNOWLAUNCHER"},
		order = 3
	},
	["weapon-category-4"] = {
		weapons = {"WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_PROXMINE", "WEAPON_PIPEBOMB", "WEAPON_SMOKEGRENADE", "WEAPON_BZGAS", "WEAPON_MOLOTOV", "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_HAZARDCAN", "WEAPON_FERTILIZERCAN", "WEAPON_BALL", "WEAPON_SNOWBALL", "WEAPON_ACIDPACKAGE", "WEAPON_FLARE"},
		order = 4
	},
	["weapon-category-5"] = {
		weapons = {"WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_SNSPISTOL_MK2", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_CERAMICPISTOL", "WEAPON_MARKSMANPISTOL", "WEAPON_REVOLVER", "WEAPON_REVOLVER_MK2", "WEAPON_DOUBLEACTION", "WEAPON_NAVYREVOLVER", "WEAPON_GADGETPISTOL", "WEAPON_PISTOLXM3", "WEAPON_APPISTOL", "WEAPON_FLAREGUN", "WEAPON_RAYPISTOL", "WEAPON_STUNGUN", "WEAPON_STUNGUN_MP"},
		order = 5
	},
	["weapon-category-6"] = {
		weapons = {"WEAPON_TECPISTOL", "WEAPON_MINISMG", "WEAPON_MACHINEPISTOL", "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_SMG_MK2", "WEAPON_ASSAULTSMG", "WEAPON_COMBATPDW", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_COMBATMG_MK2", "WEAPON_GUSENBERG", "WEAPON_RAYCARBINE"},
		order = 6
	},
	["weapon-category-7"] = {
		weapons = {"WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE", "WEAPON_CARBINERIFLE_MK2", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_SPECIALCARBINE_MK2", "WEAPON_BULLPUPRIFLE", "WEAPON_BULLPUPRIFLE_MK2", "WEAPON_COMPACTRIFLE", "WEAPON_MILITARYRIFLE", "WEAPON_HEAVYRIFLE", "WEAPON_TACTICALRIFLE", "WEAPON_BATTLERIFLE"},
		order = 7
	},
	["weapon-category-8"] = {
		weapons = {"WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_MARKSMANRIFLE", "WEAPON_MARKSMANRIFLE_MK2", "WEAPON_PRECISIONRIFLE"},
		order = 8
	},
	["weapon-category-9"] = {
		weapons = {"GADGET_PARACHUTE"},
		order = 9
	}
}

function Client.Function.Weapon.InitData()
	Client.Menu.Weapon.Categories = {}
	Client.Menu.Weapon.All = {}
	Client.Weapon.Categories = {}
	Client.Weapon.All = {}
	local liveryColors = {}
	for i = 0, 31 do
		liveryColors[#liveryColors + 1] = {Name = GetLabelText("WCT_C_TINT_" .. i), Value = i}
	end
	for weaponName, weaponData in pairs(json.decode(LoadResourceFile(GetCurrentResourceName(), "data/weapon.json"))) do
		local weaponHash = GetHashKey(weaponName)
		if weaponHash ~= 0 and IsWeaponValid(weaponHash) then
			if weaponData.Tints then
				local weaponTints = {}
				for i = 1, #weaponData.Tints do
					local tint = weaponData.Tints[i]
					local tintIndex = tint.Value
					if tintIndex < GetWeaponTintCount(weaponHash) then
						local tintName = tint.Name and GetLabelText(tint.Name)
						tint.Name = tintName ~= "NULL" and tintName or ""
						weaponTints[#weaponTints + 1] = tint
					end
				end
				weaponData.Tints = weaponTints
			end
			if weaponData.Liveries then
				local weaponLiveries = {{Camo = "", Name = Client.Function.Translate.Get("weapon-livery-default"), Label = Client.Function.Translate.Get("weapon-livery-default")}}
				local weaponLiveries2 = nil
				for i = 1, 11 do
					local livery = weaponData.Liveries[i]
					if not livery then break end
					if DoesWeaponTakeWeaponComponent(weaponHash, GetHashKey(livery.Name)) then
						local liveryLabel = livery.Label and GetLabelText(livery.Label)
						livery.Camo = livery.Name
						livery.Name = liveryLabel ~= "NULL" and liveryLabel or ""
						livery.Label = nil
						weaponLiveries[#weaponLiveries + 1] = livery
					end
				end
				if #weaponData.Liveries > 11 then
					weaponLiveries2 = {{Camo = "", Name = Client.Function.Translate.Get("weapon-livery-default"), Label = Client.Function.Translate.Get("weapon-livery-default")}}
					for i = 12, 22 do
						local livery = weaponData.Liveries[i]
						if not livery then break end
						if DoesWeaponTakeWeaponComponent(weaponHash, GetHashKey(livery.Name)) then
							local liveryLabel = livery.Label and GetLabelText(livery.Label)
							livery.Camo = livery.Name
							livery.Name = liveryLabel ~= "NULL" and liveryLabel or ""
							livery.Label = nil
							weaponLiveries2[#weaponLiveries2 + 1] = livery
						end
					end
				end
				weaponData.Colors = liveryColors
				weaponData.Liveries = weaponLiveries
				weaponData.Liveries2 = weaponLiveries2
			end
			if weaponData.Components then
				local seen = {}
				local weaponComponents = {}
				for i = 1, #weaponData.Components do
					local component = weaponData.Components[i]
					local componentName = component.Name
					local componentHash = GetHashKey(componentName)
					if DoesWeaponTakeWeaponComponent(weaponHash, componentHash) then
						local componentLabel = component.Label and GetLabelText(component.Label)
						componentLabel = componentLabel ~= "NULL" and componentLabel or ""
						if componentLabel ~= "" then
							seen[componentLabel] = seen[componentLabel] or 0
							seen[componentLabel] = seen[componentLabel] + 1
							if seen[componentLabel] > 1 then
								componentLabel = componentLabel .. " " .. seen[componentLabel]
							end
						end
						component.Label = componentLabel
						weaponComponents[#weaponComponents + 1] = component
					end
				end
				weaponData.Components = weaponComponents
			end
			Client.Weapon.All[weaponName] = weaponData
		end
	end
	for categoryName, categoryData in pairs(categories) do
		local weaponList = {}
		local categoryLabel = Client.Function.Translate.Get(categoryName)
		Client.Menu.Weapon.Categories[categoryName] = RageUI.CreateSubMenu(Client.Menu.Weapon.Category, "", categoryLabel, false)
		Client.Menu.Weapon.Categories[categoryName].WidthOffset = 120
		for i = 1, #categoryData.weapons do
			local weaponName = categoryData.weapons[i]
			local weaponData = Client.Weapon.All[weaponName]
			if weaponData then
				local weaponLabel = weaponData.Label and GetLabelText(weaponData.Label)
				weaponLabel = weaponLabel ~= "NULL" and weaponLabel or weaponName
				weaponList[#weaponList + 1] = {Name = weaponName, Label = weaponLabel}
				Client.Menu.Weapon.All[weaponName] = RageUI.CreateSubMenu(Client.Menu.Weapon.Categories[categoryName], "", weaponLabel, false)
				Client.Menu.Weapon.All[weaponName].WidthOffset = 120
			end
		end
		Client.Weapon.Categories[categoryData.order] = {Name = categoryName, Label = categoryLabel, List = weaponList}
	end
end

function Client.Function.Weapon.CanAddAmmo(ped)
	for weaponName, weaponData in pairs(Client.Weapon.All) do
		local weaponHash = GetHashKey(weaponName)
		if HasPedGotWeapon(ped, weaponHash, 0) then
			return true
		end
	end
	return false
end

function Client.Function.Weapon.AddAmmo(ped, weaponHash)
	local success, maxAmmo = GetMaxAmmo(ped, weaponHash)
	if success and maxAmmo and maxAmmo > 0 then
		AddAmmoToPed(ped, weaponHash, maxAmmo)
	end
end

function Client.Function.Weapon.AddAmmoForAll(ped)
	for weaponName, weaponData in pairs(Client.Weapon.All) do
		local weaponHash = GetHashKey(weaponName)
		if HasPedGotWeapon(ped, weaponHash, 0) then
			Client.Function.Weapon.AddAmmo(ped, weaponHash)
		end
	end
end

function Client.Function.Weapon.CanLoadSaved()
	for weaponName, savedWeapon in pairs(Client.Weapon.Saved) do
		local weaponHash = GetHashKey(weaponName)
		if weaponHash ~= 0 and IsWeaponValid(weaponHash) then
			if savedWeapon.Enable then
				return true
			end
		end
	end
	return false
end

function Client.Function.Weapon.LoadData(ped, weaponHash, savedWeapon)
	if not ped or not weaponHash or not savedWeapon then return end
	if savedWeapon.Livery and savedWeapon.Livery.Camo and savedWeapon.Livery.Color then
		local liveryHash = GetHashKey(savedWeapon.Livery.Camo)
		local liveryColor = savedWeapon.Livery.Color
		if DoesWeaponTakeWeaponComponent(weaponHash, liveryHash) and not HasPedGotWeaponComponent(ped, weaponHash, liveryHash) then
			GiveWeaponComponentToPed(ped, weaponHash, liveryHash)
			SetPedWeaponLiveryColor(ped, weaponHash, liveryHash, liveryColor)
		end
	end
	if savedWeapon.Livery2 and savedWeapon.Livery2.Camo and savedWeapon.Livery2.Color then
		local liveryHash2 = GetHashKey(savedWeapon.Livery2.Camo)
		local liveryColor2 = savedWeapon.Livery2.Color
		if DoesWeaponTakeWeaponComponent(weaponHash, liveryHash2) and not HasPedGotWeaponComponent(ped, weaponHash, liveryHash2) then
			GiveWeaponComponentToPed(ped, weaponHash, liveryHash2)
			SetPedWeaponLiveryColor(ped, weaponHash, liveryHash2, liveryColor2)
		end
	end
	if savedWeapon.Components then
		for componentName, value in pairs(savedWeapon.Components) do
			local componentHash = GetHashKey(componentName)
			if DoesWeaponTakeWeaponComponent(weaponHash, componentHash) then
				if value == 1 and not HasPedGotWeaponComponent(ped, weaponHash, componentHash) then
					GiveWeaponComponentToPed(ped, weaponHash, componentHash)
				elseif value == 0 and HasPedGotWeaponComponent(ped, weaponHash, componentHash) then
					RemoveWeaponComponentFromPed(ped, weaponHash, componentHash)
				end
			end
		end
	end
	if savedWeapon.TintIndex and savedWeapon.TintIndex < GetWeaponTintCount(weaponHash) then
		SetPedWeaponTintIndex(ped, weaponHash, savedWeapon.TintIndex)
	end
end

function Client.Function.Weapon.LoadSaved(ped)
	for weaponName, savedWeapon in pairs(Client.Weapon.Saved) do
		local weaponHash = GetHashKey(weaponName)
		if weaponHash ~= 0 and IsWeaponValid(weaponHash) and not HasPedGotWeapon(ped, weaponHash, 0) then
			if savedWeapon.Enable then
				GiveWeaponToPed(ped, weaponHash, 1, false, false)
				Client.Function.Weapon.LoadData(ped, weaponHash, savedWeapon)
				Client.Function.Weapon.AddAmmo(ped, weaponHash)
			end
		end
	end
end

function Client.Function.Weapon.RemoveAll(ped)
	RemoveAllPedWeapons(ped, false)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
end

function Client.Function.Weapon.GetEditedData(ped, weaponName, weaponHash, saveToServer)
	if not ped or not weaponName or not weaponHash then return end
	local changed = Client.Weapon.Changed[weaponName]
	local savedWeapon = Client.Weapon.Saved[weaponName] or {}
	if changed and changed == 1 and HasPedGotWeapon(ped, weaponHash, 0) then
		local weaponData = Client.Weapon.All[weaponName]
		if weaponData.Tints then
			savedWeapon.TintIndex = GetPedWeaponTintIndex(ped, weaponHash)
		else
			savedWeapon.TintIndex = nil
		end
		if weaponData.Liveries then
			local liveryIndex = 1
			for i = 2, #weaponData.Liveries do
				if HasPedGotWeaponComponent(ped, weaponHash, GetHashKey(weaponData.Liveries[i].Camo)) then
					liveryIndex = i
					break
				end
			end
			savedWeapon.Livery = savedWeapon.Livery or {}
			savedWeapon.Livery.Camo = liveryIndex > 1 and weaponData.Liveries[liveryIndex].Camo
			savedWeapon.Livery.Color = liveryIndex > 1 and GetPedWeaponLiveryColor(ped, weaponHash, GetHashKey(weaponData.Liveries[liveryIndex].Camo))
		else
			savedWeapon.Livery = nil
		end
		if weaponData.Liveries2 then
			local liveryIndex2 = 1
			for i = 2, #weaponData.Liveries2 do
				if HasPedGotWeaponComponent(ped, weaponHash, GetHashKey(weaponData.Liveries2[i].Camo)) then
					liveryIndex2 = i
					break
				end
			end
			savedWeapon.Livery2 = savedWeapon.Livery2 or {}
			savedWeapon.Livery2.Camo = liveryIndex2 > 1 and weaponData.Liveries2[liveryIndex2].Camo
			savedWeapon.Livery2.Color = liveryIndex2 > 1 and GetPedWeaponLiveryColor(ped, weaponHash, GetHashKey(weaponData.Liveries2[liveryIndex2].Camo))
		else
			savedWeapon.Livery2 = nil
		end
		if weaponData.Components then
			local components = {}
			for i = 1, #weaponData.Components do
				components[weaponData.Components[i].Name] = HasPedGotWeaponComponent(ped, weaponHash, GetHashKey(weaponData.Components[i].Name)) and 1 or 0
			end
			savedWeapon.Components = components
		else
			savedWeapon.Components = nil
		end
		savedWeapon.Enable = savedWeapon.Enable and true or false
		Client.Weapon.Saved[weaponName] = savedWeapon
		Client.Weapon.Changed[weaponName] = 0
	end
	if savedWeapon.Enable then
		if HasPedGotWeapon(ped, weaponHash, 0) then
			Client.Function.Weapon.AddAmmo(ped, weaponHash)
			if saveToServer then
				CreateThread(function()
					RefillAmmoInstantly(PlayerPedId())
				end)
			end
		end
	else
		if HasPedGotWeapon(ped, weaponHash, 0) then
			RemoveWeaponFromPed(ped, weaponHash)
		end
		if saveToServer then
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
		end
	end
	if saveToServer then
		local changed = {}
		for weaponName, _ in pairs(Client.Weapon.Changed) do
			changed[#changed + 1] = {weaponName = weaponName, weaponData = Client.Weapon.Saved[weaponName]}
			Client.Weapon.Changed[weaponName] = nil
		end
		if #changed >= 1 then
			TriggerLatentServerEvent("server:core:saveWeapon", 65536, changed)
		end
	end
end

function Client.Function.Weapon.Editing()
	CreateThread(function()
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local cameraRotationAngle = GetEntityHeading(ped) + 90.0
		local cameraHandle = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 60.0, true, 2)
		local currentEditingName = nil
		local currentEditingHash = nil
		local lastEditingName = nil
		local lastEditingHash = nil
		SetCamActive(cameraHandle, true)
		RenderScriptCams(true, false, 0, true, true)
		while Client.IsWeaponMenuVisible do
			ped = PlayerPedId()
			pos = GetEntityCoords(ped)
			FreezeEntityPosition(ped, true)
			if IsDisabledControlPressed(0, 205) then
				cameraRotationAngle = cameraRotationAngle - 2.0
			end
			if IsDisabledControlPressed(0, 206) then
				cameraRotationAngle = cameraRotationAngle + 2.0
			end
			SetCamCoord(cameraHandle, pos.x + (2.0 * math.cos(math.rad(cameraRotationAngle))), pos.y + (2.0 * math.sin(math.rad(cameraRotationAngle))), pos.z + 0.0)
			PointCamAtCoord(cameraHandle, pos.x + (2.0 * math.cos(math.rad(cameraRotationAngle + 180.0))), pos.y + (2.0 * math.sin(math.rad(cameraRotationAngle + 180.0))), pos.z + 0.0)
			currentEditingName = Client.Weapon.CurrentEditing.Name
			currentEditingHash = Client.Weapon.CurrentEditing.Hash
			lastEditingName = Client.Weapon.LastEditing.Name
			lastEditingHash = Client.Weapon.LastEditing.Hash
			Client.Weapon.EditingEnable = false
			if currentEditingName and currentEditingHash then
				if lastEditingName ~= currentEditingName then
					Client.Function.Weapon.GetEditedData(ped, lastEditingName, lastEditingHash, false)
					Client.Weapon.LastEditing.Name = currentEditingName
					Client.Weapon.LastEditing.Hash = currentEditingHash
				end
				if HasPedGotWeapon(ped, currentEditingHash, 0) then
					if currentEditingHash == GetHashKey("GADGET_PARACHUTE") then
						Client.Weapon.EditingEnable = true
						SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"))
					else
						if GetSelectedPedWeapon(ped) == currentEditingHash then
							Client.Weapon.EditingEnable = true
						else
							SetCurrentPedWeapon(ped, currentEditingHash)
						end
					end
				else
					GiveWeaponToPed(ped, currentEditingHash, 1, false, true)
					Client.Function.Weapon.LoadData(ped, currentEditingHash, Client.Weapon.Saved[currentEditingName])
				end
			end
			Wait(0)
		end
		Client.Function.Weapon.GetEditedData(PlayerPedId(), Client.Weapon.CurrentEditing.Name, Client.Weapon.CurrentEditing.Hash, true)
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(cameraHandle, false)
		FreezeEntityPosition(PlayerPedId(), false)
		SetGameplayCamRelativeHeading(0)
		Client.Weapon.LastEditing.Name = nil
		Client.Weapon.LastEditing.Hash = nil
		Client.Weapon.CurrentEditing.Name = nil
		Client.Weapon.CurrentEditing.Hash = nil
		Client.Weapon.EditingEnable = false
	end)
end

function Client.Function.Weapon.ReloadForRaceAndCreator(ped, parachute, beast, reload)
	Client.Function.Weapon.RemoveAll(ped)
	if reload and Client.Permission.Weapon then
		Client.Function.Weapon.LoadSaved(ped)
	end
	if parachute then
		if not HasPedGotWeapon(ped, GetHashKey("GADGET_PARACHUTE"), 0) then
			GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false, false)
		end
	elseif beast then
		if HasPedGotWeapon(ped, GetHashKey("GADGET_PARACHUTE"), 0) then
			RemoveWeaponFromPed(ped, GetHashKey("GADGET_PARACHUTE"))
		end
	end
end