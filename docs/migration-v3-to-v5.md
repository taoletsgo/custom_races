## Migrating from v3 to v5

- Copy the .json track files from the `local_files` and `custom_files` folders into the `tracks` folder

- Uncomment the code on the last line of [`server/sql.lua`](https://github.com/taoletsgo/custom_races/blob/main/server/sql.lua)
	```lua
	MigrationDataFromV3()
	```
- Refresh resources, then start the script (or restart the server)
	> The server console will print the start and completion of the migration, please wait patiently

- Comment out the code on the last line of [`server/sql.lua`](https://github.com/taoletsgo/custom_races/blob/main/server/sql.lua), to prevent re-triggering the migration, which would cause new data to be overwritten by old data ⚠️
	```lua
	--MigrationDataFromV3()
	```

- Restart the script (or restart the server)

- Manually delete old SQL tables (optional)

- Manually delete old track files (optional)