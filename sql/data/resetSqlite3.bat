::Assume that:
::the SQL script to ingest data is in "create" folder
::the bat script to reset data is in "data" folder, same level as "create" folder

del college.db
sqlite3 college.db < ..\create\college.sql