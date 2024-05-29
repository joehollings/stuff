#! /bin/bash

hana_sid_upper=$(echo $SID | tr '[:lower:]' '[:upper:]')
data_disk_no=4
data_disks='/dev/sdd /dev/sde /dev/sdf /dev/sdg'
log_disk_no=5
log_disks='/dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl'

### Register System ###
if [[ $(sudo SUSEConnect -s | grep '"subscription_status":"ACTIVE"') ]]; then
    echo "System already registered"
else
    echo "Registering system..."
    sudo registercloudguest --clean
    sudo zypper rm -y cloud-regionsrv-client
    sudo SUSEConnect --cleanup --url https://scc.suse.com
    sudo SUSEConnect -e dean.johnson@opalwave.com -r $reg_key
fi

### Set timezone ###
sudo timedatectl set-timezone Europe/London

# configure storage

# /usr/sap
if [[ $(df -k | grep /dev/sdb) ]]; then
    echo "usr sap already configured"
else
    echo "creating usr sap"
    sudo mkfs.xfs -f /dev/sdb
fi
# /hana/shared
if [[ $(df -k | grep /dev/sdc) ]]; then
    echo "hana shared already configured"
else
    echo "creating hana shared"
    sudo mkfs.xfs -f /dev/sdc
fi
# /hana/data
if [[ $(sudo grep md0 /proc/mdstat) ]]; then
    echo "hana data already configured"
else
    sudo mdadm --create /dev/md0 --run --level=0 --chunk=256 --raid-devices=$data_disk_no $data_disks
    sudo mkfs.xfs -f /dev/md0
fi
# /hana/log
if [[ $(sudo grep md1 /proc/mdstat) ]]; then
    echo "hana log already configured"
else
    sudo mdadm --create /dev/md1 --run --level=0 --chunk=64 --raid-devices=$log_disk_no $log_disks
    sudo mkfs.xfs -f /dev/md1
fi

if [[ $(df -k | grep /dev/sdb) ]]; then
    echo "usr sap already mounted"
else
    echo "Mounting usr sap"
    sudo mount /dev/sdb /usr/sap
fi

if [[ $(df -k | grep /dev/sdc) ]]; then
    echo "hana shared already mounted"
else
    echo "Mounting hana shared"
    sudo mount /dev/sdc /hana/shared
fi

if [[ $(df -k | grep /dev/md0) ]]; then
    echo "hana data already mounted"
else
    echo "Mounting hana data"
    sudo mount /dev/md0 /hana/data
fi

if [[ $(df -k | grep /dev/md1) ]]; then
    echo "hana log already mounted"
else
    echo "Mounting hana log"
    sudo mount /dev/md1 /hana/log
fi

# mount data drives
if [[ $(grep /usr/sap /etc/fstab) ]]; then
    echo ""
else
    echo /dev/sdb /usr/sap xfs defaults 1 2 | sudo tee -a /etc/fstab
fi
if [[ $(grep /hana/shared /etc/fstab) ]]; then
    echo ""
else
    echo /dev/sdc /hana/shared xfs defaults 1 2 | sudo tee -a /etc/fstab
fi
if [[ $(grep /hana/data /etc/fstab) ]]; then
    echo ""
else
    echo /dev/md0 /hana/data xfs defaults 1 2 | sudo tee -a /etc/fstab
fi
if [[ $(grep /hana/log /etc/fstab) ]]; then
    echo ""
else
    echo /dev/md1 /hana/log xfs defaults 1 2 | sudo tee -a /etc/fstab
fi

# configure hana

# run sap tune
sudo saptune daemon start
sudo saptune solution apply HANA

# install hana db
cat /nas/HANA/hdb_password.xml | /nas/HANA/SAP_HANA_DATABASE_NEW/hdblcm --ignore=check_signature_file --sid=$hana_sid_upper --number=00 --volume_encryption=on --custom_cfg=/nas/HANA/CONFIG --read_password_from_stdin=xml --batch
