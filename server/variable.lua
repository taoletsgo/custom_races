Server = {}
Server.Players = {}
Server.PlayerCount = 0
Server.ScriptStartTime = GetGameTimer()
Server.ResourceName = GetCurrentResourceName()

Server.Race = {}
Server.Race.Rooms = {}
Server.Race.RoomId = 1000

Server.Track = {}
Server.Track.Data = {}
Server.Track.IsUpdating = false

Server.Creator = {}
Server.Creator.Sessions = {}

Server.Function = {}
Server.Function.Math = {}
Server.Function.Player = {}
Server.Function.Shared = {}
Server.Function.Track = {}
Server.Function.Webhook = {}
Server.Function.Room = {}