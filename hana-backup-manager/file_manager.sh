#! /bin/bash

# Archives backup chain for selected environment to zip in configured archive folder 
function archive_backups {
    # environment
    sid=$1
    # data path
    data=$2
    # weeks to keep
    weeks_to_keep=$3
    # path to backup log file
    backup_log=$4
    # archive path
    archive_path=$5
    # basepath
    basepath=$6
    # systemdb path
    systemdb_path=$7
    # get todays date
    date=$(date +"%d-%m-%Y")

    # wc counts the files in the backup folder and runs the archive job if it isn't empty
    if [ $( ls $systemdb_path | wc -l ) -gt "0" ]
    then
        # Creates zip archive for SYSTEMDB
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Creating zip archive SYSTEMDB-backups-$date.zip"
        echo "$time_stamp: $message" | tee -a $backup_log
        message="Archive contains the following files:"
        echo "$time_stamp: $message" | tee -a $backup_log
        # Lists files in backup folder and adds to the log
        ls $systemdb_path/* | tee -a $backup_log
        # Creates zip archive
        zip -r $archive_path/$sid/SYSTEMDB/"SYSTEMDB-backups-$date.zip" $systemdb_path/* 2>&1 | tee -a $backup_log
        # Deletes backup chain from file system if zip archive creation is successful
        cleanup_db_system $sid $backup_log $archive_path $systemdb_path
    fi

    if [ $( ls $data | wc -l ) -gt "0" ]
    then
        # Creates zip archive for DB_SID
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Creating zip archive DB_$sid-backups-$date.zip"
        echo "$time_stamp: $message" | tee -a $backup_log
        message="Archive contains the following files:"
        echo "$time_stamp: $message" | tee -a $backup_log
        ls $data/* | tee -a $backup_log
        zip -r $archive_path/$sid/"DB_$sid/DB_$sid-backups-$date.zip" $data/* 2>&1 | tee -a $backup_log
        cleanup_db_sid $sid $data $weeks_to_keep $backup_log $archive_path $basepath
    fi
}

function cleanup_db_system {

    # environment
    sid=$1
    # path to backup log file
    backup_log=$2
    # archive path
    archive_path=$3
    # basepath
    basepath=$4
    # get todays date
    date=$(date +"%d-%m-%Y")

    # Checks archive was created successfully, then deletes backup chain or throws an error and cleans up any temp zip files left over
    if [ -f "$archive_path/$sid/SYSTEMDB/SYSTEMDB-backups-$date.zip" ]
    then 
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Success - Zip archive SYSTEMDB-backups-$date.zip created, deleting backup chain for week $date"
        echo "$time_stamp: $message" | tee -a $backup_log
        # Deletes backup chain from file system
        rm $basepath/* -f 2>&1 | tee -a $backup_log
    else
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Error - Zip archive SYSTEMDB-backups-$date.zip creation failed! Any error(s) have been logged in $backup_log"
        echo "$time_stamp: $message" | tee -a $backup_log
        # Deletes any temp files left over if the archive operation fails
        find $archive_path/$sid/SYSTEMDB/* -type f -mtime -1 -delete 2>&1 | tee -a $backup_log
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Failed archive zip file cleaned up"
        echo "$time_stamp: $message" | tee -a $backup_log
	fi
    
    # checks the archive folder for the oldest backup and deletes it based on number of weeks to keep
    if [ $( ls $archive_path/$sid/SYSTEMDB | wc -l ) -gt "1" ]
    then
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        files=$(find $archive_path/$sid/SYSTEMDB/* -type f -mtime +7)
        message="Clearing zip files for $sid SYSTEMDB over 7 days old, $files will be deleted"
        echo "$time_stamp: $message" | tee -a $backup_log
        find $archive_path/$sid/SYSTEMDB/* -type f -mtime +7 -delete 2>&1 | tee -a $backup_log
    fi

}
    
function cleanup_db_sid {   

    # environment
    sid=$1
    # data path
    data=$2
    # weeks to keep
    weeks_to_keep=$3
    # path to backup log file
    backup_log=$4
    # archive path
    archive_path=$5
    # basepath
    basepath=$6
    # get todays date
    date=$(date +"%d-%m-%Y")
    
    # Checks archive was created successfully, then deletes backup chain or throws an error and cleans up any temp zip files left over
	if [ -f $archive_path/$sid/"DB_$sid/DB_$sid-backups-$date.zip" ] && [ $( ls $data | wc -l ) -gt "0" ]
	then 
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Success - Zip archive DB_$sid-backups-$date.zip created, deleting backup chain for week $date"
        echo "$time_stamp: $message" | tee -a $backup_log
        rm $data/* -f 2>&1 | tee -a $backup_log
    else
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Error - Zip archive DB_$sid-backups-$date.zip creation failed! Any error(s) have been logged in $backup_log"
        echo "$time_stamp: $message" | tee -a $backup_log
        find $archive_path/$sid/DB_$sid/* -type f -mtime -1 -delete 2>&1 | tee -a $backup_log
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Failed archive zip file cleaned up"
        echo "$time_stamp: $message" | tee -a $backup_log
	fi
        
    # checks the archive folder for the oldest backup and deletes it based on number of weeks to keep
    if [ $( ls $archive_path/$sid/DB_$sid | wc -l ) -gt $weeks_to_keep ]
    then
        days=$(expr 7 \* $weeks_to_keep)
        files=$(find $archive_path/$sid/DB_$sid/* -type f -mtime +$days)
        time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
        message="Clearing zip files for DB_$sid over $days days, $files will be deleted"
        echo "$time_stamp: $message" | tee -a $backup_log
        find $archive_path/$sid/DB_$sid/* -type f -mtime +$days -delete 2>&1 | tee -a $backup_log
    fi
}

function clear_data_backups {
    # environment
    sid=$1
    # data path
    data=$2
    # system db path
    systemdb=$3
    # path to backup log file
    backup_log=$4

    # clear SID data backups
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    message="Clearing data backups for $sid older than 2 weeks"
    echo "$time_stamp: $message" | tee -a $backup_log
    find $data -type f -mtime +14 -delete 2>&1 | tee -a $backup_log
    # clear SYSTEMDB data backups
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    message="Clearing data backups for $sid SYSTEMDB older than 7 days"
    echo "$time_stamp: $message" | tee -a $backup_log
    find $systemdb -type f -mtime +7 -delete 2>&1 | tee -a $backup_log
}

function clear_log_backups {
    # environment
    sid=$1
    # log path
    log=$2
    # path to backup log file
    backup_log=$3

    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    message="Clearing log backups for $sid older than 48 hours"
    echo "$time_stamp: $message" | tee -a $backup_log
    find $log -type f -mtime +2 -delete 2>&1 | tee -a $backup_log
}

function clear_data_backups {
    # environment
    sid=$1
    # path to backup log file
    backup_log=$2
    # basepath
    db_sid_path=$3
    # systemdb path
    systemdb_path=$4
    # get todays date
    date=$(date +"%d-%m-%Y")

    # SYSYEM DB
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    message="Clearing $sid SYSTEM DB backups for week $date"
    echo "$time_stamp: $message" | tee -a $backup_log
    rm $systemdb_path/* -f 2>&1 | tee -a $backup_log

    # DB_SID
    time_stamp=$(date +"%d-%m-%Y %H:%M:%S")
    message="Clearing $sid DB_$sid backups for week $date"
    echo "$time_stamp: $message" | tee -a $backup_log
    rm $db_sid_path/* -f 2>&1 | tee -a $backup_log
}