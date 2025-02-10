<h1 align="center">
custom_races🏁 + custom_creator⚒️
</h1>
<p align="center">
Scripts for loading and creating GTA:Online races in FiveM.
</p>

## 📺YouTube Overview

[![IMAGE ALT TEXT HERE](https://i.ytimg.com/vi/RekC1AshOfo/maxresdefault.jpg)](https://www.youtube.com/watch?v=RekC1AshOfo)

## 🤖Features
- Support to create races (coming soon)

https://github.com/user-attachments/assets/0a4383c5-8624-4c82-8a42-9cf8b3e96aac

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

#### 1 Requirements
- **oxmysql**: https://github.com/overextended/oxmysql
- **framework**: 
  - **esx-core**: https://github.com/esx-framework/esx_core
  - **qb-core**: https://github.com/qbcore-framework/qb-core
  - **standalone**

#### 2.1 Create a Database
```sql
CREATE TABLE IF NOT EXISTS `custom_race_list` (
  `raceid` int(11) NOT NULL AUTO_INCREMENT,
  `route_file` varchar(100) DEFAULT NULL,
  `route_image` varchar(100) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `besttimes` longtext DEFAULT '{}',
  PRIMARY KEY (`raceid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

#### 2.2 Import Your Data
```sql
INSERT INTO `custom_race_list` (`raceid`, `route_file`, `route_image`, `category`, `besttimes`) VALUES
  (1, 'local_files/abc.json', 'https://img.com/abc.jpg', 'category1', '[]'),
  (2, 'local_files/def.json', 'https://img.com/def.jpg', 'category2', '[]');
```
Support JSON links, but you need to modify the `RaceRoom.LoadNewRace` function in `server/races_room.lua`. And I recommend using JSON files.

#### 2.3 Add Table 
- **for esx-core**
```sql
ALTER TABLE users
ADD `fav_vehs` LONGTEXT;
```
- **for qb-core**
```sql
ALTER TABLE players
ADD `fav_vehs` LONGTEXT;
```

- **for standalone**
```
Modify "sql_server.lua" or keep as is
```

#### 3 Get the JSON File
You can use `convert tools/json-web-search.py` to get a single file from Rockstar Social Club. The method for batch obtaining JSON files is not open to the public, you can use ChatGPT to write one for you or **contribute to this project** to get the automated script.

#### 4 Download `main script/custom_races` and modify your `server.cfg` file
```
set onesync_distanceCullvehicles off
set onesync_distanceCulling off
ensure oxmysql
ensure [framework] #esx-core or qb-core
ensure custom_races
```
#### 5 Some key bindings and commands
- `F5` = open creator (coming soon)
- `F6` = open lobby
- `F7` = accept invitation
- `Z` = enable / disable position UI
- `ESC` = quit when player in racing
- `/tpn` = teleport to next checkpoint
- `/tpp` = teleport to previous checkpoint

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
- Support to create races
- ...
