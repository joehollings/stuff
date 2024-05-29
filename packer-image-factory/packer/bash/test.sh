#! /bin/bash

### Register System ###
if [[ $(sudo SUSEConnect -s | grep '"subscription_status":"ACTIVE"') ]]; then
    echo "System already registered"
else
    echo "Registering system..."
fi

### Set timezone ###
echo "Set time zone"

# configure storage

# /usr/sap
if [[ $(df -k | grep /dev/sdb) ]]; then
    echo "usr sap already configured"
else
    echo "creating usr sap"
fi
# /hana/shared
if [[ $(df -k | grep /dev/sdc) ]]; then
    echo "hana shared already configured"
else
    echo "creating hana shared"
fi
# /hana/data
if [[ $(sudo grep md0 /proc/mdstat) ]]; then
    echo "hana data already configured"
else
    echo "md0"
fi
# /hana/log
if [[ $(sudo grep md1 /proc/mdstat) ]]; then
    echo "hana log already configured"
else
    echo "md1"
fi

if [[ $(df -k | grep /dev/sdb) ]]; then
    echo "usr sap already mounted"
else
    echo "Mounting usr sap"
fi

if [[ $(df -k | grep /dev/sdc) ]]; then
    echo "hana shared already mounted"
else
    echo "Mounting hana shared"
fi

if [[ $(df -k | grep /dev/md0) ]]; then
    echo "hana data already mounted"
else
    echo "Mounting hana data"
fi

if [[ $(df -k | grep /dev/md1) ]]; then
    echo "hana log already mounted"
else
    echo "Mounting hana log"
fi

# mount data drives
if [[ $(grep /usr/sap /etc/fstab) ]]; then
    echo ""
else
    echo "/usr/sap"
fi
if [[ $(grep /hana/shared /etc/fstab) ]]; then
    echo ""
else
    echo "/hana/shared"
fi
if [[ $(grep /hana/data /etc/fstab) ]]; then
    echo ""
else
    echo "/hana/data"
fi
if [[ $(grep /hana/log /etc/fstab) ]]; then
    echo ""
else
    echo "/hana/log"
fi