#Install-Module -Name Az.NetAppFiles -Scope CurrentUser -Repository PSGallery -Force

#Install-Module -Name Az.NetAppFiles -RequiredVersion 0.1.3
 
Connect-AZAccount

# Create snapshot time stamp
$snapshotname = "SNAPSHOT_$(get-date -f yyyyMMdd_HHmmss)"

# Create script to generate snapshot
"BACKUP DATA FOR FULL SYSTEM CREATE SNAPSHOT COMMENT '$snapshotname';" > C:\HANA_Scripts\azrbackup.sql

# Run hdbsql script to create snapshot
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n 10.250.19.6 -i 03 -u SYSTEM -p 0p4lW4v3! -d SYSTEMDB -a -I C:\HANA_Scripts\azrbackup.sql

#Sleep for 10 seconds
Start-Sleep -s 10

# Create snapshot in ANF for the HANA data drive with correct snapshot name 
New-AzNetAppFilesSnapshot -ResourceGroupName cfxcrs-rsg-prod -Location EastUS -AccountName cfxcrs-anf-prod -PoolName cfxcrs-anf-ultra-prod -VolumeName hana-data-prod -SnapshotName $snapshotname

# Create script to get Backup_ID for snapshot
"SELECT BACKUP_ID FROM M_BACKUP_CATALOG WHERE COMMENT = '$snapshotname';" > C:\HANA_Scripts\azrbackup.sql

# Run hdbsql script to get Backup_ID for snapshot
$BackID = & "C:\Program Files\sap\hdbclient\hdbsql.exe" -n 10.250.19.6 -i 03 -u SYSTEM -p 0p4lW4v3! -d SYSTEMDB -a -I C:\HANA_Scripts\azrbackup.sql

# Create script to close snapshot
"BACKUP DATA FOR FULL SYSTEM CLOSE SNAPSHOT BACKUP_ID $BackID SUCCESSFUL '$snapshotname';" > C:\HANA_Scripts\azrbackup.sql

# Run hdbsql script to close snapshot
& "C:\Program Files\sap\hdbclient\hdbsql.exe" -n 10.250.19.6 -i 03 -u SYSTEM -p 0p4lW4v3! -d SYSTEMDB -a -I C:\HANA_Scripts\azrbackup.sql

