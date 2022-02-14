# WMGTSS-Database
Database implementation

# Installation inscructions

1. Install postgresql version 14 for windows. it is recommended to follow the guide https://www.postgresqltutorial.com/install-postgresql/
2. When prompted make sure postgres is configured to use port 5432, make a note of the postgresql password you set up, you'll need this later
3. Unpack the source fro mthe provided zip or download it from GitHub
4. Next start a windows cmd window in the repo's base folder 
5. Run the command "createdb datafiledb postgres" to create the db. When prompted enter the postgresql password you set up earlier.
6. Next run the command "\c datafiledb;" to connect to the db.
7. Now run the databse set up script using th command "\i create_database_script.sql"
8. The database should now be operational  
