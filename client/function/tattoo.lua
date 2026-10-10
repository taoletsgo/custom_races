function Client.Function.Tattoo.InitData()
	local data = json.decode(LoadResourceFile(GetCurrentResourceName(), "data/tattoo.json"))
	Client.Skin.Tattoo.ZoneData.Male = data.Male
	for _, zoneData in pairs(Client.Skin.Tattoo.ZoneData.Male) do
		for i = 1, #zoneData do
			local tattooData = zoneData[i]
			local tattooLabel = tattooData.Label
			local tattooLabelText = tattooLabel and GetLabelText(tattooLabel)
			tattooData.Label = tattooLabelText ~= "NULL" and tattooLabelText or tattooLabel
		end
	end
	Client.Skin.Tattoo.ZoneData.Female = data.Female
	for _, zoneData in pairs(Client.Skin.Tattoo.ZoneData.Female) do
		for i = 1, #zoneData do
			local tattooData = zoneData[i]
			local tattooLabel = tattooData.Label
			local tattooLabelText = tattooLabel and GetLabelText(tattooLabel)
			tattooData.Label = tattooLabelText ~= "NULL" and tattooLabelText or tattooLabel
		end
	end
end

function Client.Function.Tattoo.Change(changedData)
	local totalCount = 0
	local changedTattooCollection = changedData.Collection
	local changedTattooOverlay = changedData.Overlay
	local changedTattooCount = changedData.Count
	local oldTattooData = Client.Skin.Tattoo.Current[changedTattooOverlay]
	if changedTattooCount < 0 then
		changedTattooCount = 10
	elseif changedTattooCount > 10 then
		changedTattooCount = 0
	end
	if changedTattooCount >= 1 then
		Client.Skin.Tattoo.Current[changedTattooOverlay] = {
			Collection = changedTattooCollection,
			Overlay = changedTattooOverlay,
			Count = changedTattooCount
		}
	else
		Client.Skin.Tattoo.Current[changedTattooOverlay] = nil
	end
	for _, tattooData in pairs(Client.Skin.Tattoo.Current) do
		local tattooCount = tattooData.Count
		totalCount = totalCount + tattooCount
	end
	if totalCount <= 60 then
		Client.Function.Tattoo.Set(PlayerPedId(), Client.Skin.Tattoo.Current)
	else
		Client.Skin.Tattoo.Current[changedTattooOverlay] = oldTattooData
		Client.Function.Message.Display(Client.Function.Translate.Get("tattoo-limit"))
	end
end

function Client.Function.Tattoo.Current(ped, tattoo, isMale, isFemale)
	local allValidTattoo = {}
	local currentTattoo = {}
	local totalCount = 0
	if tattoo and type(tattoo) == "table" then
		for _, zoneData in pairs((isMale and Client.Skin.Tattoo.ZoneData.Male) or (isFemale and Client.Skin.Tattoo.ZoneData.Female) or {}) do
			for i = 1, #zoneData do
				local tattooData = zoneData[i]
				local tattooCollection = tattooData.Collection
				local tattooOverlay = tattooData.Overlay
				allValidTattoo[tattooOverlay] = tattooCollection
			end
		end
		for _, tattooData in pairs(tattoo) do
			if type(tattooData) == "table" then
				local tattooCollection = tattooData.Collection
				local tattooOverlay = tattooData.Overlay
				local tattooCount = tattooData.Count
				if type(tattooCollection) == "string" and type(tattooOverlay) == "string" and type(tattooCount) == "number" and tattooCollection ~= "" and tattooOverlay ~= "" then
					if allValidTattoo[tattooOverlay] == tattooCollection then
						tattooCount = math.max(0, math.min(10, tattooCount))
						if tattooCount >= 1 then
							totalCount = totalCount + tattooCount
							if totalCount <= 60 then
								currentTattoo[tattooOverlay] = {
									Collection = tattooCollection,
									Overlay = tattooOverlay,
									Count = tattooCount
								}
							else
								break
							end
						end
					end
				end
			end
		end
	end
	Client.Skin.Tattoo.Current = currentTattoo
	Client.Function.Tattoo.Set(ped, Client.Skin.Tattoo.Current)
end

function Client.Function.Tattoo.Set(ped, tattoo)
	ClearPedDecorations(ped)
	for _, tattooData in pairs(tattoo) do
		local tattooCollection = tattooData.Collection
		local tattooOverlay = tattooData.Overlay
		local tattooCount = tattooData.Count
		for i = 1, tattooCount do
			AddPedDecorationFromHashes(ped, GetHashKey(tattooCollection), GetHashKey(tattooOverlay))
		end
	end
end

function Client.Function.Tattoo.GetRandomData(random)
	local ped = PlayerPedId()
	local data = Client.Function.Skin.GetCurrent()
	data.tattoo = {}
	if random then
		if #Client.Skin.Tattoo.Zones > 0 then
			local totalCount = 0
			local dataPool = GetEntityModel(ped) == `mp_m_freemode_01` and Client.Skin.Tattoo.ZoneData.Male or Client.Skin.Tattoo.ZoneData.Female
			for i = 1, 512 do
				local randomZoneName = Client.Skin.Tattoo.Zones[math.random(#Client.Skin.Tattoo.Zones)]
				local randomZoneData = dataPool[randomZoneName]
				if #randomZoneData > 0 then
					local randomTattooData = randomZoneData[math.random(#randomZoneData)]
					local randomTattooCollection = randomTattooData.Collection
					local randomTattooOverlay = randomTattooData.Overlay
					local randomTattooCount = math.random(10) == 10 and math.random(3)
					if randomTattooCount and not data.tattoo[randomTattooOverlay] then
						totalCount = totalCount + randomTattooCount
						if totalCount <= 60 then
							data.tattoo[randomTattooOverlay] = {
								Collection = randomTattooCollection,
								Overlay = randomTattooOverlay,
								Count = randomTattooCount
							}
						else
							break
						end
					end
				end
			end
		end
	end
	return data
end