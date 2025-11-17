Citizen.CreateThread(function()
	local attempt = 0
	while GetResourceState("oxmysql") ~= "started" and attempt < 3 do
		attempt = attempt + 1
		Citizen.Wait(1000)
	end
	if GetResourceState("oxmysql") == "started" then
		MySQL.Async.execute([[
			CREATE TABLE IF NOT EXISTS `custom_race_list` (
				`raceid` int(11) NOT NULL AUTO_INCREMENT,
				`route_file` varchar(200) DEFAULT NULL,
				`route_image` varchar(200) DEFAULT NULL,
				`category` varchar(50) DEFAULT NULL,
				`besttimes` longtext DEFAULT "[]",
				`published` varchar(100) DEFAULT NULL,
				`updated_time` varchar(100) DEFAULT NULL,
				`license` longtext DEFAULT "[]",
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
	else
		print("^1================================================================================^0")
		print("^1oxmysql does not exist or is not started.^0")
		print("^1================================================================================^0")
	end
end)