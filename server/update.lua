CreateThread(function()
	Wait(3000)
	PerformHttpRequest("https://raw.githubusercontent.com/taoletsgo/custom_races/refs/heads/main/version.json", function(statusCode, response, headers)
		local data = json.decode(response)
		local version = GetResourceMetadata(Server.ResourceName, "version", 0)
		if data and data.version and data.version ~= version then
			print("^1=======================================================================================^0")
			print("^1(" .. Server.ResourceName .. ") is outdated!^0")
			print("Latest version: (^2" .. data.version .. "^0) https://github.com/taoletsgo/custom_races/releases/")
			print("^1=======================================================================================^0")
		end
	end, "GET", "")
end)