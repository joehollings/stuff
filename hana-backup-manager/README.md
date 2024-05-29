# Hana Backup Manager

Hana backuo manager does the following

* Creates the file system for storing the backups and sets file permissions
* Creates a cron job to run the script at the time specified in the parameters
* logging, logs can be found in /var/log/hana_backup_manager.log

Note, Hana Backup Manager has two modes:

* Archive - in this mode backup chains are archived ever week and retained based on the retension period set in weeks_to_keep parameter. Set the archive folder path to enable this mode.
* Cleanup - This is the default mode if no archive is configured. Backup chains are deleted on archive day.

## Usage

To install run the script below. Ensure the NAS and backup share are mounted first!

```bash
#! /bin/bash

naspath="/mnt/nas"
basepath="/hana/backup"

if [ ! -d "$naspath" ]
then
    echo "Error - NAS isn't mounted, please mount $naspath and retry!"
fi

if [ ! -d "$basepath" ]
then
    echo "Error - backup storage not mounted, please mount $basepath and retry!"
fi

if [ -d "$naspath" ] && [ -d "$basepath" ] && [ ! -d "$basepath/hana_backup_manager" ]
then
    mkdir $basepath/hana_backup_manager
    chmod 777 $basepath/hana_backup_manager
    cp $naspath/HANA/HANA_BACKUP_MANAGER/hana_backup_manager.sh $basepath/hana_backup_manager/hana_backup_manager.sh
    cp $naspath/HANA/HANA_BACKUP_MANAGER/system_config.sh $basepath/hana_backup_manager/system_config.sh
    cp $naspath/HANA/HANA_BACKUP_MANAGER/file_manager.sh $basepath/hana_backup_manager/file_manager.sh
    chmod 777 $basepath/hana_backup_manager/hana_backup_manager.sh
    chmod 777 $basepath/hana_backup_manager/system_config.sh
    chmod 777 $basepath/hana_backup_manager/file_manager.sh
    cd $basepath/hana_backup_manager
    vim hana_backup_manager.sh
    echo "Hana backup Manager configured, please run $basepath/hana_backup_manager/hana_backup_manager.sh to enable."
fi
```

Fill the parameters in hana_backup_manager.sh when prompted. Then cd to the Hana Backup Manager folder and run hana_backup_manager.sh.

```bash
# Environment sids
dev_sid="T01"
qas_sid="T02"
prod_sid="T03"
# Backup mount point
basepath="/hana/backup"
# Archive folder - Only complete this if you want backups archived, leave empty for just clean ups.
archive="archive"
# Path to dev SYSTEMDB may be DB_SYSTEMDB or just SYSTEMDB
dev_systemdb="$basepath/$dev_sid/data/SYSTEMDB"
# Path to qas SYSTEMDB
qas_systemdb="$basepath/$qas_sid/data/SYSTEMDB"
# Path to prod SYSTEMDB
prod_systemdb="$basepath/$prod_sid/data/SYSTEMDB"
# no of weeks to keep dev backups
weeks_to_keep_dev="1"
# no of weeks to keep qas backups
weeks_to_keep_qas="1"
# no of weeks to keep production backups
weeks_to_keep_prod="2"
# Hour number backup runs 00 - 23
backup_hour="01"
# Minute number backup runs 00 - 59
backup_minute="00"
# Day of the week for the last incremental backup in the chain.
archive_day="Friday"
```
