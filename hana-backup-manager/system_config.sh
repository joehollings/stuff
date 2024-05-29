#! /bin/bash

# Creates log file
function start_logging {
    backup_log=$1
    # Creates backup.log in /var/log.
    touch $backup_log
    # Sets permissions
    chmod 777 $backup_log
    # Creates time stamp for log entries.
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    # Displays log to console and redirects to backup.log.
    echo "$time_stamp: Logging started" | tee -a $backup_log
}

# Creates cron job to run backup manager at time specified in config
function create_cron_job {
    #write out new job to crontab
    echo "$1 $2 * * *   root  $3/hana_backup_manager/hana_backup_manager.sh" >> /etc/crontab
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    message="Cron job configured to run at $2:$1"
    echo "$time_stamp: $message" | tee -a $backup_log
}

# Creates backup archive file structure
function create_archive {
    basepath=$1
    archive=$2
    sid=$3
    backup_log=$4
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    echo "$time_stamp: $basepath/$archive/$sid not found, creating file system...." | tee -a $backup_log
    mkdir -p $basepath/$archive/$sid/DB_$sid 2>&1 | tee -a $backup_log
    mkdir -p $basepath/$archive/$sid/SYSTEMDB 2>&1 | tee -a $backup_log
    chmod 777 $basepath/$archive/$sid 2>&1 | tee -a $backup_log
    chmod 777 $basepath/$archive/$sid/DB_$sid 2>&1 | tee -a $backup_log
    chmod 777 $basepath/$archive/$sid/SYSTEMDB 2>&1 | tee -a $backup_log
    # Checks if backup archive file system was created successfully and terminates the script if not.
    if [ ! -d $basepath/$archive/$sid ]
    then
        echo "Backup archive file system creation failed for $3. Check $backup_log for errors" | tee -a $backup_log
        exit 0
    fi
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    echo "$time_stamp: $basepath/$archive/$sid created" | tee -a $backup_log
}

# Creates backup folder structure
function create_folders {
    basepath=$1
    data=$2
    log=$3
    sid=$4
    backup_log=$5
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    echo "$time_stamp: $sid backup file structure not found, creating...." | tee -a $backup_log
    # Data
    mkdir -p $data 2>&1 | tee -a $backup_log
    mkdir -p $basepath/$sid/data/SYSTEMDB 2>&1 | tee -a $backup_log
    chmod 777 $data 2>&1 | tee -a $backup_log
    chmod 777 $basepath/$sid/data/SYSTEMDB 2>&1 | tee -a $backup_log
    # Log
    mkdir -p $log/DB_$sid 2>&1 | tee -a $backup_log
    mkdir -p $log/SYSTEMDB 2>&1 | tee -a $backup_log
    chmod 777 $log/DB_$sid 2>&1 | tee -a $backup_log
    chmod 777 $log/SYSTEMDB 2>&1 | tee -a $backup_log
    # Checks if file system was created successfully and terminates the script if not.
    if [ ! -d $data ]
    then
        echo "Backup file system creation failed for $sid data backups. Check $backup_log for errors" | tee -a $backup_log
        exit 0
    fi

    if [ ! -d $log ]
    then
        echo "Backup file system creation failed for $sid log backups. Check $backup_log for errors" | tee -a $backup_log
        exit 0
    fi
    # Outputs folder paths for data and log backups.
    echo "$time_stamp: $sid backup file system created, please use the following paths for scheduling backups:" | tee -a $backup_log
    echo "$time_stamp: $sid SYSTEMDB Data backup path - $basepath/$sid/data/SYSTEMDB" | tee -a $backup_log
    echo "$time_stamp: $sid Tenant Data backup path - $data" | tee -a $backup_log
    echo "$time_stamp: $sid SYSTEMDB Log backup path - $basepath/$sid/log/SYSTEMDB" | tee -a $backup_log
    echo "$time_stamp: $sid Tenant Log backup path - $log" | tee -a $backup_log
}