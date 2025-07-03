<h1 align="center">
custom_races🏁 + custom_creator⚒️
</h1>
<p align="center">
Scripts for loading and creating GTA:Online races in FiveM
</p>

## 📺YouTube Overview
[![IMAGE ALT TEXT HERE](https://i.ytimg.com/vi/wBwX8a3b1YY/maxresdefault.jpg)](https://www.youtube.com/watch?v=wBwX8a3b1YY)

## 🤖Features
- ☑ Create races in FiveM with multiple players!
- ☑ All GTA:Online racing features
- ☑ Teleport system
- ☑ Invitation system
- ☑ 13 languages

## 🛠️Installation
Before you install this script, if you are a beginner, I need to tell you that I do not provide any help

#### 1. Requirements
- **oxmysql**: https://github.com/overextended/oxmysql

#### 2. Download [latest release](https://github.com/taoletsgo/custom_races/releases) and modify your `server.cfg` file
```
set onesync_distanceCullvehicles off
set onesync_distanceCulling off
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

Install [Tampermonkey](https://www.tampermonkey.net/) and [Rockstar ID On Member Pages](https://github.com/taoletsgo/custom_races/raw/refs/heads/dev/convert%20tools/Rockstar%20ID%20On%20Member%20Pages-0.1.user.js)

Run `convert tools/json-web-search-batch.py` to batch fetch files from Rockstar Social Club

- **Plan C**

Run `convert tools/json-web-search.py` to fetch a single file from Rockstar Social Club

#### 2. Export FiveM tracks to GTA Online
With modTool you can export FiveM tracks to GTA Online

[modTool Documentation](https://oleg52.github.io/ModToolDocs/)

[modTool Discord](https://discord.gg/q9MyqMHdVf)

https://github.com/user-attachments/assets/fcb14bbf-3e52-4b49-ac05-70023284bf50

## 🎮Key bindings
- `F5` = open creator
- `F6` = open race
- `F7` = accept invitation
- `Z` = toggle position UI
- `ESC` = quit when player in racing

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
- ...

*I have given up ownership of the code, which means you are free to modify, sell, etc., but you are not allowed to obfuscate the code or use FiveM escrow system to encrypt it. **BE NICE MAN!***
