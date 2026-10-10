function Server.Function.Shared.ConvertToTimestamp(date)
	local pattern = "(%d+)%/(%d+)%/(%d+) (%d+):(%d+):(%d+)"
	local year, month, day, hour, min, sec = date:match(pattern)
	return os.time{year = year, month = month, day = day, hour = hour, min = min, sec = sec}
end