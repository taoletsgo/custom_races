creator_status = {}

Citizen.CreateThread(function()
	local attempt = 0
	while GetResourceState("custom_races") ~= "started" and attempt < 3 do
		attempt = attempt + 1
		Citizen.Wait(1000)
	end
	if GetResourceState("custom_races") ~= "started" then
		print('^1================================================================================^0')
		print('^1custom_races does not exist or is not started.^0')
		print('^1================================================================================^0')
	end
	MySQL.Async.execute([[
		CREATE TABLE IF NOT EXISTS `custom_race_list` (
			`raceid` int(11) NOT NULL AUTO_INCREMENT,
			`route_file` varchar(200) DEFAULT NULL,
			`route_image` varchar(200) DEFAULT NULL,
			`category` varchar(50) DEFAULT NULL,
			`besttimes` longtext DEFAULT '[]',
			`published` varchar(100) DEFAULT NULL,
			`updated_time` varchar(100) DEFAULT NULL,
			`license` varchar(100) DEFAULT NULL,
			PRIMARY KEY (`raceid`) USING BTREE
		)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])
	MySQL.Async.execute([[
		CREATE TABLE IF NOT EXISTS `custom_race_users` (
			`license` varchar(100) DEFAULT NULL,
			`name` varchar(100) DEFAULT NULL,
			`fav_vehs` longtext DEFAULT NULL,
			`fav_colors` longtext DEFAULT NULL,
			`vehicle_mods` longtext DEFAULT NULL,
			`race_creator` longtext DEFAULT NULL,
			`group` varchar(50) DEFAULT NULL,
			PRIMARY KEY (`license`) USING BTREE
		)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
		]])
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			local version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
			if not string.find(version, "dev") then
				PerformHttpRequest('https://raw.githubusercontent.com/taoletsgo/custom_races/refs/heads/main/main%20script/version_check.json', function (err, updatedata, headers)
					if updatedata ~= nil then
						local data = json.decode(updatedata)
						if data.custom_creator ~= version then
							print('^1=======================================================================================^0')
							print('^1('..GetCurrentResourceName()..') is outdated!^0')
							print('Latest version: (^2'..data.custom_creator..'^0) https://github.com/taoletsgo/custom_races/releases/')
							print('^1=======================================================================================^0')
						end
					end
				end, 'GET', '')
			end
		end)
	end
end)

RegisterCommand('setgroup_creator_permission', function(src, args)
	if tonumber(src) == 0 then
		local identifier = args[1]
		local group = args[2]
		local result = MySQL.query.await("SELECT `group` FROM custom_race_users WHERE license = ?", {identifier})
		if result and result[1] then
			MySQL.update("UPDATE custom_race_users SET `group` = ? WHERE license = ?", {group, identifier})
		else
			MySQL.insert('INSERT INTO custom_race_users (license, `group`) VALUES (?, ?)', {identifier, group})
		end
	end
end)