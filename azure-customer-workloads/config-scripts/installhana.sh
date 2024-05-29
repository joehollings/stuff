#! /bin/bash

hostname=""
hana_sid=""
hana_sid_lower=$(echo ${hana_sid} | tr '[:upper:]' '[:lower:]')
adm="adm"
sidadm="$hana_sid_lower$adm"

### Paste customer backup storage mount script here!!! ###





### Set timezone ###
sudo timedatectl set-timezone GMT

## Format /usr/sap and /hana/shared drives ###
if [[ $(lsblk -f | grep "sdb    xfs") ]]; then
    echo "sdb already formated"
else
    echo "Formatting sdb"
    sudo mkfs.xfs -f /dev/sdb
fi

if [[ $(lsblk -f | grep "sdc    xfs") ]]; then
    echo "sdc already formated"
else
    echo "Formatting sdb"
    sudo mkfs.xfs -f /dev/sdc
fi


### Create RAID 0 for /hana/data and /hana/log and format ###
if [[ $(sudo cat /proc/mdstat | grep md0) ]]; then
    echo "RAID Array md0 already exists"
else
    echo "Creating RAID Array md0"
    sudo mdadm --create /dev/md0 --run --level=0 --chunk=256 --raid-devices=4 /dev/sdd /dev/sde /dev/sdf /dev/sdg
    sudo mkfs.xfs -f /dev/md0
fi

if [[ $(sudo cat /proc/mdstat | grep md1) ]]; then
    echo "RAID Array md1 already exists"
else
    echo "Creating RAID Array md1"
    sudo mdadm --create /dev/md1 --run --level=0 --chunk=64 --raid-devices=5 /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl
    sudo mkfs.xfs -f /dev/md1
fi

if [[ $(lsblk -f | grep "md0    xfs") ]]; then
    echo ""
else
    echo "Formatting md0"
    sudo mkfs.xfs -f /dev/md0
fi

if [[ $(lsblk -f | grep "md1    xfs") ]]; then
    echo ""
else
    echo "Formatting md1"
    sudo mkfs.xfs -f /dev/md1
fi

### Mount storage to mount points
if [[ $(mount | grep "/dev/sdb") ]]; then
    echo "/usr/sap already mounted"
else
    sudo mount /dev/sdb /usr/sap
fi
if [[ $(mount | grep "/dev/sdc") ]]; then
    echo "/hana/shared already mounted"
else
    sudo mount /dev/sdc /hana/shared
fi
if [[ $(mmount | grep "/dev/md0") ]]; then
       echo "/hana/data already mounted"
else
    sudo mount /dev/md0 /hana/data
fi
if [[ $(mmount | grep "/dev/md1") ]]; then
       echo "/hana/log already mounted"
else
    sudo mount /dev/md1 /hana/log
fi

### Add mount points to FSTAB ###
echo "Checking fstab for mounts"
if [[ $(sudo cat /etc/fstab | grep /dev/sdb) ]]; then
    echo ""
else
    echo /dev/sdb /usr/sap xfs defaults 1 2 | sudo tee -a /etc/fstab
fi
if [[ $(sudo cat /etc/fstab | grep /dev/sdc) ]]; then
    echo ""
else
    echo /dev/sdc /hana/shared xfs defaults 1 2 | sudo tee -a /etc/fstab
fi
if [[ $(sudo cat /etc/fstab | grep /dev/md0) ]]; then
    echo ""
else
    echo /dev/md0 /hana/data xfs defaults 1 2 | sudo tee -a /etc/fstab
fi
if [[ $(sudo cat /etc/fstab | grep /dev/md1) ]]; then
    echo ""
else
    echo /dev/md1 /hana/log xfs defaults 1 2 | sudo tee -a /etc/fstab
fi

### Enabling and configuring SLES Server for SAP HANA ###
sudo saptune daemon start
sudo saptune solution apply HANA

### Install HANA ###
if [ ! -d "/hana/shared/$hana_sid" ]: then
    cp /nas/HANA/CONFIG/TEMPLATE/global_no_backup.ini /nas/HANA/CONFIG/global.ini
    sed -i 's/$SID/${hana_sid}/' /nas/HANA/CONFIG/global.ini
    cat /nas/HANA/hdb_password.xml | /nas/HANA/SAP_HANA_DATABASE_NEW/hdblcm --ignore=check_signature_file --sid=${hana_sid} --number=${hana_id} --volume_encryption=on --custom_cfg=/nas/HANA/CONFIG --read_password_from_stdin=xml --batch
fi