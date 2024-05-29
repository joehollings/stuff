#! /bin/bash

# Script config - THESE MUST BE FILLED IN OR THE SCRIPT WONT WORK!!!!!

# Environment sids
dev_sid=""
qas_sid=""
prod_sid=""
# Backup mount point
basepath="/hana/backup"
# Archive folder - Only complete this if you want backups archived, leave empty for just clean ups.
archive=""
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
#------------------------------------------------------------------

# Get current day of the week.
today=$(date +%A)
# Get current hour
current_hour=$(date +%H)
# archive path
archive_path="$basepath/$archive"
# dev data path
dev_data="$basepath/$dev_sid/data/DB_$dev_sid"
# qas data path
qas_data="$basepath/$qas_sid/data/DB_$qas_sid"
# prod data path
prod_data="$basepath/$prod_sid/data/DB_$prod_sid"
# dev log path
dev_log="$basepath/$dev_sid/log"
# qas log path
qas_log="$basepath/$qas_sid/log"
# dev log path
prod_log="$basepath/$prod_sid/log"
# backup log path
backup_log="/var/log/hana_backup_manager.log"

# Source function scripts here for use below.
source $basepath/hana_backup_manager/system_config.sh
source $basepath/hana_backup_manager/file_manager.sh

# Setup backup environment on first run. If additional environments are added these will be picked up automatically.

if [ ! -f $backup_log ]
then
    # Create log file
    start_logging $backup_log
fi

# Create cron job
if [[ ! $(cat /etc/crontab | grep "$basepath/hana_backup_manager/hana_backup_manager.sh") ]]
then
    create_cron_job $backup_minute $backup_hour $basepath
fi

# Create archive folders

# Dev
if [ ! -z $dev_sid ] && [ ! -d $basepath/$archive/$dev_sid ] && [ ! -z $archive ] 
then    # If Dev backup is configured, but file system doesn't exist, it is created.
    if [ ! -z $dev_sid ] && [ ! -d $basepath/$archive/$dev_sid ]
    then
        # Creates archive for Dev SYSTEMDB and DB_SID
        create_archive $basepath $archive $dev_sid $backup_log
        # Checks archive folder was created and stops script if not.
        if [ ! -d $basepath/$archive/$dev_sid ]
        then
            time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
            message="$basepath/$archive/$dev_sid creation failed, please investigate why and resolve issue, script will now terminate"
            echo "$time_stamp: $message" | tee -a $backup_log
            exit 0
        fi
    fi
fi
# QAS
if [ ! -z $qas_sid ] && [ ! -d $basepath/$archive/$qas_sid ] && [ ! -z $archive ]
then    # If QAS backup is configured, but file system doesn't exist, it is created.
    if [ ! -z $qas_sid ] && [ ! -d $basepath/$archive/$qas_sid ]
    then
        # Creates archive for QAS SYSTEMDB and DB_SID
        create_archive $basepath $archive $qas_sid $backup_log
        # Checks archive folder was created and stops script if not.
        if [ ! -d $basepath/$archive/$qas_sid ]
        then
            time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
            message="$basepath/$archive/$qas_sid creation failed, please investigate why and resolve issue, script will now terminate"
            echo "$time_stamp: $message" | tee -a $backup_log
            exit 0
        fi
    fi
fi
# Prod
if [ ! -z $prod_sid ] && [ ! -d $basepath/$archive/$prod_sid ] && [ ! -z $archive ]
then    # If Prod backup is configured, but file system doesn't exist, it is created.
    if [ ! -z $prod_sid ] && [ ! -d $basepath/$archive/$prod_sid ]
    then
        # Creates archive for Prod SYSTEMDB and DB_SID
        create_archive $basepath $archive $prod_sid $backup_log
        # Checks archive folder was created and stops script if not.
        if [ ! -d $basepath/$archive/$prod_sid ]
        then
            time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
            message="$basepath/$archive/$prod_sid creation failed, please investigate why and resolve issue, script will now terminate"
            echo "$time_stamp: $message" | tee -a $backup_log
            exit 0
        fi
    fi
fi

# Backup folder structure

# Dev
if [ ! -z $dev_sid ] && [ ! -d $dev_data ] && [ ! -d $dev_log ]
then
    # Creates folders for storing data and log backups
    create_folders $basepath $dev_data $dev_log $dev_sid $backup_log
    # Checks folder structure was created and stops script if not.
    if [ ! -d $dev_data ] && [ ! -d $dev_log ]
    then
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="$dev_sid folder structure creation failed, please investigate why and resolve issue, script will now terminate" 
        echo "$time_stamp: $message" | tee -a $backup_log
        exit 0
    fi
fi
# QAS
if [ ! -z $qas_sid ] && [ ! -d $qas_data ] && [ ! -d $qas_log ]
then
    # Creates folders for storing data and log backups
    create_folders $basepath $qas_data $qas_log $qas_sid $backup_log
    # Checks folder structure was created and stops script if not.
    if [ ! -d $qas_data ] && [ ! -d $qas_log ]
    then
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="$qas_sid folder structure creation failed, please investigate why and resolve issue, script will now terminate" 
        echo "$time_stamp: $message" | tee -a $backup_log
        exit 0
    fi
fi
# Prod
if [ ! -z $prod_sid ] && [ ! -d $prod_data ] && [ ! -d $prod_log ]
then
    # Creates folders for storing data and log backups
    create_folders $basepath $prod_data $prod_log $prod_sid $backup_log
    # Checks folder structure was created and stops script if not.
    if [ ! -d $prod_data ] && [ ! -d $prod_log ]
    then
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="$prod_sid folder structure creation failed, please investigate why and resolve issue, script will now terminate"
        echo "$time_stamp: $message" | tee -a $backup_log
        exit 0
    fi
fi

# Log start of data management job
time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
message="Hana Backup Manager run starting..."
echo "$time_stamp: $message" | tee -a $backup_log

# Use the day of the week to trigger the archive job.
if [ $today = $archive_day ]
then
    if [ ! -z $dev_sid ] && [ ! -z $archive ]
    then
        archive_backups $dev_sid $dev_data $weeks_to_keep_dev $backup_log $archive_path $basepath $dev_systemdb
    fi

    if [ ! -z $qas_sid ] && [ ! -z $archive ]
    then
        archive_backups $qas_sid $qas_data $weeks_to_keep_qas $backup_log $archive_path $basepath $qas_systemdb
    fi

    if [ ! -z $prod_sid ] && [ ! -z $archive ]
    then
        archive_backups $prod_sid $prod_data $weeks_to_keep_prod $backup_log $archive_path $basepath $prod_systemdb
    fi
fi

# Use the day of the week to trigger the clean up job.
if [ $today = $archive_day ]
then
    if [ ! -z $dev_sid ] && [ -z $archive ]
    then
        clear_data_backups $dev_sid $backup_log $dev_data $dev_systemdb
    fi

    if [ ! -z $qas_sid ] && [ -z $archive ]
    then
        clear_data_backups $qas_sid $backup_log $qas_data $qas_systemdb
    fi

    if [ ! -z $prod_sid ] && [ -z $archive ]
    then
        clear_data_backups $prod_sid $backup_log $prod_data $prod_systemdb
    fi
fi

# Call function from cli to clean up backup area when required
function cleanup_dev {
    clear_data_backups $dev_sid $dev_data $dev_systemdb $backup_log
}

function cleanup_qas {
    clear_data_backups $qas_sid $qas_data $qas_systemdb $backup_log
}

function cleanup_prod {
    clear_data_backups $prod_sid $prod_data $prod_systemdb $backup_log
}

function archive_systemdb_dev {
    archive_backups $dev_sid $dev_data $weeks_to_keep_dev $backup_log $archive_path $basepath $dev_systemdb
}

# Manage log backups

# If dev environment is configured and folder structure exists run clear log backup job.
if [ ! -z $dev_sid ] && [ -d $dev_log ] && [ $backup_hour == $current_hour ]
then
    clear_log_backups $dev_sid $dev_log $backup_log
fi
# If qas environment is configured and folder structure exists run clear log backup job.
if [ ! -z $qas_sid ] && [ -d $qas_log ] && [ $backup_hour == $current_hour ]
then
    clear_log_backups $qas_sid $qas_log $backup_log
fi
# If prod environment is configured and folder structure exists run clear log backup job.
if [ ! -z $prod_sid ] && [ -d $prod_log ] && [ $backup_hour == $current_hour ]
then
    clear_log_backups $prod_sid $prod_log $backup_log
fi

# Log end of code run
time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
message="Hana Backup Manager run completed"
echo "$time_stamp: $message" | tee -a $backup_log