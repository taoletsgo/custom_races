<h1 align="center">
custom_races🏁
</h1>
<p align="center">
A script for loading GTA:Online races in FiveM.
</p>

## 📺YouTube Overview

[![IMAGE ALT TEXT HERE](https://i.ytimg.com/vi/yNL0O22wLsk/maxresdefault.jpg)](https://www.youtube.com/watch?v=yNL0O22wLsk)

## 🤖Features
- ☑ Invitation system
- ☑ Teleport system
- ☑ Non-collision system when racing
- ☑ All GTA:Online racing types and vehicles

## 🛠️Installation
Before you install this script, if you are a beginner, I need to tell you that I do not provide any help.

#### 1 Requirements
- **oxmysql**: https://github.com/overextended/oxmysql
- **esx-core**: https://github.com/esx-framework/esx_core
(Or qb-core. Theoretically, it's supported, but I'm not familiar with qb-core.)

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
```sql
CREATE TABLE IF NOT EXISTS `custom_race_stats` (
  `citizenid` varchar(50) NOT NULL,
  `level` int(11) DEFAULT 1,
  `experience` int(11) DEFAULT 0,
  `frst` int(11) DEFAULT 0,
  `scnd` int(11) DEFAULT 0,
  `thrd` int(11) DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`citizenid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
```

#### 2.2 Import Your Data
```sql
INSERT INTO `custom_race_list` (`raceid`, `route_file`, `route_image`, `category`, `besttimes`) VALUES
  (1, 'local_files/abc.json', 'https://img.com/abc.jpg', 'category1', '[]'),
  (2, 'local_files/def.json', 'https://img.com/def.jpg', 'category2', '[]');
```
Support JSON links, but you need to modify the `RaceRoom.LoadNewRace` function in `server/races_room.lua`. And I recommend using JSON files.

#### 2.3 Add Table (esx-core)
```sql
ALTER TABLE users
ADD `fav_vehs` LONGTEXT;
```

#### 3 Get the JSON File
You can use `convert tools/json-web-search.py` to get a single file from Rockstar Social Club. The method for batch obtaining JSON files is not open to the public, you can use ChatGPT to write one for you or **contribute to this project** to get the automated script.

#### 4 Download `main script/custom_races` and modify your `server.cfg` file
```
ensure oxmysql
ensure [core] #esx-core
ensure custom_races
```
#### 5 Some key bindings and commands
- `F6` = open lobby
- `F7` = accept invitation
- `ESC` = quit when player in racing
- `/tpn` = teleport to next checkpoint
- `/tpp` = teleport to previous checkpoint

## 🗒️To-do List [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com)
- Support to convert from Menyoo (.xml files)
- ~Support to join race midway even if it has already started~ ☑
- ~Support fake checkpoints~ ☑
- ~Support beast race mode~ ☑ (Make sure FPS <= 45, otherwise the race will be difficult to finish)
- ...

## ❓Why open source
I bought a nearly unusable encryption script from an irresponsible script dealer, so I fixed everything I knew and shared it with you guys. It would be better if more people could contribute.
