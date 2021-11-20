..\mariadb\bin\mysql_install_db.exe --datadir=..\data\ --service=schild3_mariadb --port=3306
sc.exe start schild3_mariadb
..\mariadb\bin\mysql.exe -u root mysql < 01_CreateSchema_MariaDB.sql
..\mariadb\bin\mysql.exe -u root schild30 < 02_CreateTables.sql
..\mariadb\bin\mysql.exe -u root schild30 < 03_CreateIndizes.sql
..\mariadb\bin\mysql.exe -u root schild30 < 04_CreateForeignKeys.sql
