# WMGTSS-Database
Database implementation

# Installation instructions

1. Install postgresql version 14 for windows. it is recommended to follow the guide https://www.postgresqltutorial.com/install-postgresql/
2. When prompted make sure postgres is configured to use port 5432, make a note of the postgresql password you set up, you'll need this later. 
3. Make sure that you add the postgres bin folder to your path variable. this will allow you to run psql commands from anywhere. By default the postgres bin folder has this path "C:\Program Files\PostgreSQL\14\bin"
4. You my now need to restart the PC.
4. Unpack the source from the provided zip or download it from GitHub
5. Next start a windows cmd window in the repo's base folder
7. Log into postgres using the command "psql -U postgres". When prompted enter the postgresql password you set up earlier.
8. Run the command "CREATE DATABASE datafiledb;" to create the db. 
9. Next run the command "\c datafiledb;" to connect to the db.
10. Now run the databse set up script using th command "\i create_database_script.sql"
11. The database should now be operational. 
