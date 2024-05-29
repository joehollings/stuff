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