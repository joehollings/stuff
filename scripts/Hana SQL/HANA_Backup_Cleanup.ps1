$dbs = Get-Content "C:\HANA_Scripts\NCLHAN03.txt"
Foreach ($db in $dbs)
{
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n nclhan03 -i $db -u BACKUP_ADMIN -p 8@ckUP!2019 -d SYSTEMDB -I C:\HANA_Scripts\Backup_Cleanup.sql
}

$dbs = Get-Content "C:\HANA_Scripts\NCLHAN02.txt"
Foreach ($db in $dbs)
{
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n nclhan02 -i $db -u BACKUP_ADMIN -p 8@ckUP!2019 -d SYSTEMDB -I C:\HANA_Scripts\Backup_Cleanup.sql
}

$dbs = Get-Content "C:\HANA_Scripts\NCLHAN06_07.txt"
Foreach ($db in $dbs)
{
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n nclhan04 -i $db -u BACKUP_ADMIN -p 8@ckUP!2019 -d SYSTEMDB -I C:\HANA_Scripts\Backup_Cleanup.sql
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n nclhan05 -i $db -u BACKUP_ADMIN -p 8@ckUP!2019 -d SYSTEMDB -I C:\HANA_Scripts\Backup_Cleanup.sql
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n nclhan06 -i $db -u BACKUP_ADMIN -p 8@ckUP!2019 -d SYSTEMDB -I C:\HANA_Scripts\Backup_Cleanup.sql
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n nclhan07 -i $db -u BACKUP_ADMIN -p 8@ckUP!2019 -d SYSTEMDB -I C:\HANA_Scripts\Backup_Cleanup.sql
}

cmd /c "C:\Program Files\sap\hdbclient\hdbsql.exe" -n 10.0.2.6 -i 96 -u BACKUP_ADMIN -p 8@ckUP!2019 -d SYSTEMDB -I C:\HANA_Scripts\Backup_Cleanup.sql
