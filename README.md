<h1 align="center">
custom_races🏁 + custom_creator⚒️
</h1>
<p align="center">
Scripts for loading and creating GTA:Online races in FiveM.
</p>

## 📺YouTube Overview

[![IMAGE ALT TEXT HERE](https://i.ytimg.com/vi/wBwX8a3b1YY/maxresdefault.jpg)](https://www.youtube.com/watch?v=wBwX8a3b1YY)

## 🤖Features
- ☑ Support to create races in FiveM
- ☑ Support 13 languages
- ☑ Filter races system
- ☑ Invitation system
- ☑ Teleport system
- ☑ Non-collision system when racing
- ☑ All GTA:Online racing types and vehicles
  - Random Race
  - Transform Race
  - Stunt Race
  - Street Race
  - Open Wheel Race
  - Air Race
  - Bike Race
  - Land Race
  - Sea Race
  - ...

## 🛠️Installation
Before you install this script, if you are a beginner, I need to tell you that I do not provide any help.

#### 1. Requirements
- **oxmysql**: https://github.com/overextended/oxmysql
- **framework**: 
  - **esx-core**: https://github.com/esx-framework/esx_core
  - **qb-core**: https://github.com/qbcore-framework/qb-core
  - **standalone**

#### 2. Download [latest release](https://github.com/taoletsgo/custom_races/releases) and modify your `server.cfg` file
```
set onesync_distanceCullvehicles off
set onesync_distanceCulling off
ensure oxmysql
#ensure [framework]
ensure custom_races
ensure custom_creator
```

_**Optional:** 500 stream add-on props from [gta5-mods/A1Draco](https://www.gta5-mods.com/tools/increased-props-add-on), download FiveM version here >>> [Google Drive 1GB](https://drive.google.com/file/d/1bEcgqjccRhoXV0uHHX2lJZfKZuktmxha/view?usp=sharing)_

```
ensure custom_creator_props
```

#### 3. Import Tracks
- **Plan A**

Run `convert tools/json-web-search.py` to get a single file from Rockstar Social Club. And then:

```sql
INSERT INTO `custom_race_list` (`raceid`, `route_file`, `route_image`, `category`, `besttimes`) VALUES
  (1, 'local_files/abc.json', 'https://img.com/abc.jpg', 'category1', '[]'),
  (2, 'local_files/def.json', 'https://img.com/def.jpg', 'category2', '[]');
```

- **Plan B**

Import racing data files with `custom_creator`

> By the way, the method for batch obtaining JSON files is not open to the public. DO NOT REQUEST FOR IT!

## 🎮Key bindings
- `F5` = open creator
- `F6` = open lobby
- `F7` = accept invitation
- `Z` = enable / disable position UI
- `ESC` = quit when player in racing

## 🗒️To-do List [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com)
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
- ...

*I have given up ownership of the code, which means you are free to modify, sell, etc., but you are not allowed to obfuscate the code or use FiveM escrow system to encrypt it. **BE NICE MAN!***
