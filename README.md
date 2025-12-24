<h1 align="center">
custom_races🏁 + custom_creator⚒️
</h1>
<p align="center">
Scripts for loading and creating GTA:Online races in FiveM
</p>

## 📺YouTube Overview
[![IMAGE ALT TEXT HERE](https://i.ytimg.com/vi/wBwX8a3b1YY/maxresdefault.jpg)](https://www.youtube.com/watch?v=wBwX8a3b1YY)

## 🤖Features
- ☑ Create races in FiveM with [multiple players](https://www.youtube.com/watch?v=rYjyW5i3Z4c)!
- ☑ All GTA:Online racing features
- ☑ Full support for Xbox controller
- ☑ Teleport / Invitation / Join-midway, and more
- ☑ 13 languages

## 🛠️Installation
Before you install this script, if you are a beginner, I need to tell you that I do not provide any help

#### 1. Requirements
- **oxmysql**: https://github.com/overextended/oxmysql

#### 2. Download [latest release](https://github.com/taoletsgo/custom_races/releases) and modify your `server.cfg` file
```
ensure oxmysql
ensure custom_races
ensure custom_creator
```

_**Optional:** 500 stream add-on props from [gta5-mods/A1Draco](https://www.gta5-mods.com/tools/increased-props-add-on), download FiveM version here >>> [Google Drive 1GB](https://drive.google.com/file/d/1bEcgqjccRhoXV0uHHX2lJZfKZuktmxha/view?usp=sharing)_

```
ensure custom_creator_props
```

## 📥Import & 📤Export

#### 1. Import GTA Online tracks to FiveM
- **Plan A (Recommended)**

Import racing data files with `custom_creator`

- **Plan B**

Install [Tampermonkey](https://www.tampermonkey.net/) and [Rockstar ID On Member Pages](https://github.com/taoletsgo/custom_races/raw/refs/heads/main/convert%20tools/Rockstar%20ID%20On%20Member%20Pages-0.1.user.js) / [Rockstar ID On Job Pages](https://github.com/taoletsgo/custom_races/raw/refs/heads/main/convert%20tools/Rockstar%20ID%20On%20Job%20Pages-0.1.user.js)

Run `convert tools/json-web-search-batch.py` to batch fetch files from Rockstar Social Club

- **Plan C**

Run `convert tools/json-web-search.py` to fetch a single file from Rockstar Social Club

#### 2. Export FiveM tracks to GTA Online
With modTool you can export FiveM tracks to GTA Online

[modTool Documentation](https://oleg52.github.io/ModToolDocs/)

[modTool Discord](https://discord.gg/q9MyqMHdVf)

https://github.com/user-attachments/assets/fcb14bbf-3e52-4b49-ac05-70023284bf50

## 🎮Commands & ⏫Function exports

#### 1. Execute the commands
- `open_creator`
- `open_race`
- `check_invitation`
- `quit_race`

Example (in client scripts):
```lua
-- Put this in any client-side script
Citizen.CreateThread(function()
	while true do
		if IsControlJustReleased(0, 166) --[[F5]] then
			ExecuteCommand("open_creator") -- to create/import/load a track
		elseif IsControlJustReleased(0, 167) --[[F6]] then
			ExecuteCommand("open_race") -- to create/join a room
		elseif IsControlJustReleased(0, 168) --[[F7]] then
			ExecuteCommand("check_invitation") -- to accept/deny an invitation
		elseif IsControlJustReleased(0, 200) --[[Esc]] then
			ExecuteCommand("quit_race") -- to quit race room when in racing or spectating
		end
		Citizen.Wait(0)
	end
end)
```

- `setgroup_creator_permission`

Example (in server console, not client console!):
```
setgroup_creator_permission 527da3929c52c0e443805fb668s686s7a0d admin
setgroup_creator_permission 527da3929c52c0e443805fb668s686s7a0d racer
setgroup_creator_permission license:527da3929c52c0e443805fb668s686s7a0d vip
```

#### 2. Function exports to lock / unlock / set when you need it
- `exports["custom_races"]:lockRace()`
- `exports["custom_races"]:unlockRace()`
- `exports["custom_races"]:setWeather(weather)`
- `exports["custom_races"]:setTime(hour, minute, second)`
- `exports["custom_creator"]:lockCreator()`
- `exports["custom_creator"]:unlockCreator()`

## 🗒️To-do List
- ~Support to convert from Menyoo (.xml files)~ ❌ (Cancelled due to insufficient sample data)
- ~Support to join race midway even if it has already started~ ☑
- ~Support fake checkpoints~ ☑
- ~Support beast race mode~ ☑ (Make sure FPS <= 45, otherwise the race will be difficult to finish)
- ~Support random race mode~ ☑
- ~Support 13 languages~ ☑
- ~Support standalone~ ☑
- ~Support filtering races by keyword~ ☑
- ~Support filtering a random race by click button~ ☑
- ~Support to create races~ ☑
- ~Support to create with multiple players~ ☑
- ~Support to set arena prop physics~ ☑
- ~Support to set firework effects~ ☑
- ~Support to display blimp text~ ☑
- ~Support to remove fixtures~ ☑
- ~Fix widescreen UI~ ☑
- ~Compatible with Xbox controller~ ☑
- ~Full support for OneSync~ ☑
- ~Dynamic loading and unloading of objects~ ❌ (Cancelled due to conflicts with the multiplayer creator)
- Advanced parsing / setting rockstar json
	- ~checkpoint params --- icon、color、collect size、draw size、alpha、height and more~
	- ~prop params --- rotation by bone、advanced collision、accelerate & decelerate value、destroy and respawn broken object、dprop multiplayer sync and more~
	- ~vehicle params --- adlc、adlc2、adlc3、aveh、clbs、icv、ivm and more~
	- unit params --- ped、vehicle、scenario and more
	- zone and pickup params, it may take months to years to support both creator and race script
- ~Advanced options for random checkpoint~ ☑
	- ~Random Transform List~
	- ~Random Vehicle List~
	- ~Random Select~
	- ~Random Classes~
	- ~Random All~
- ...

*I have given up ownership of the code, which means you are free to modify, sell, etc., but you are not allowed to obfuscate the code or use FiveM escrow system to encrypt it. **BE NICE MAN!***
