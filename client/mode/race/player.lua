function Race.Function.Player.GetDriversInfo(driversToSort)
	local sortedDrivers = {}
	for _, driver in pairs(driversToSort) do
		local checkpoint = driver.lastCheckpointPair == 1 and Race.Track.Current.Checkpoints_2[driver.actualCheckpoint] or Race.Track.Current.Checkpoints[driver.actualCheckpoint] or vector3(0.0, 0.0, 0.0)
		driver.dist = #((driver.finishCoords or driver.currentCoords) - vector3(checkpoint.x, checkpoint.y, checkpoint.z))
		table.insert(sortedDrivers, driver)
	end
	table.sort(sortedDrivers, function(a, b)
		if not a.dnf and not b.dnf then
			if not a.hasFinished and not b.hasFinished then
				if a.totalCheckpointsTouched == b.totalCheckpointsTouched then
					return a.dist < b.dist
				else
					return a.totalCheckpointsTouched > b.totalCheckpointsTouched
				end
			end
			if a.hasFinished and b.hasFinished then
				return a.totalRaceTime < b.totalRaceTime
			end
			if a.hasFinished ~= b.hasFinished then
				return a.hasFinished
			end
		end
		if a.dnf and b.dnf then
			if a.totalCheckpointsTouched == b.totalCheckpointsTouched then
				return a.dist < b.dist
			else
				return a.totalCheckpointsTouched > b.totalCheckpointsTouched
			end
		end
		if a.dnf ~= b.dnf then
			return not a.dnf
		end
	end)
	return sortedDrivers
end

function Race.Function.Player.GetPosition(driversInfo, playerId)
	for position, driver in ipairs(driversInfo) do
		if driver.playerId == playerId then
			return position
		end
	end
	return Race.Track.Current.PlayerCount
end

function Race.Function.Player.GetFinishedCount()
	local count = 0
	for k, v in pairs(Race.Track.Current.Drivers) do
		if v.hasFinished then
			count = count + 1
		end
	end
	return count
end

function Race.Function.Player.DisplayFinishedMessage()
	CreateThread(function()
		local finishedPlayer = {}
		local firstLoad = true
		while Client.IsInRace do
			if Race.Status == "racing" or Race.Status == "waiting" or Race.Status == "spectating" or Race.Status == "ending" then
				local driversInfo = Race.Function.Player.GetDriversInfo(Race.Track.Current.Drivers)
				if firstLoad then
					for k, v in pairs(Race.Track.Current.Drivers) do
						if v.hasFinished then
							finishedPlayer[v.playerId] = true
						end
					end
					firstLoad = false
				end
				for k, v in pairs(Race.Track.Current.Drivers) do
					if v.hasFinished and not finishedPlayer[v.playerId] then
						finishedPlayer[v.playerId] = true
						if not v.dnf then
							local name = v.playerName
							local position = Race.Function.Player.GetPosition(driversInfo, v.playerId)
							local message = string.format(Client.Function.Translate.Get("racing-info-finished"), name, position)
							Client.Function.Message.Display_2(message, false, nil)
							Wait(100)
						end
					elseif not v.hasFinished then
						finishedPlayer[v.playerId] = false
					end
				end
				Wait(500)
			else
				Wait(1000)
			end
		end
	end)
end