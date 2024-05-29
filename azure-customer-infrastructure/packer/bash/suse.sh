#! /bin/bash

### Create file system mount points ###
sudo mkdir -p /usr/sap
sudo mkdir -p /hana/shared
sudo mkdir -p /hana/data
sudo mkdir -p /hana/log

### Map NAS drive ###
sudo mkdir /nas
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/owscsafs01.cred" ]; then
    sudo bash -c 'echo "username=owscsafs01" >> /etc/smbcredentials/owscsafs01.cred'
	sudo chmod 777 /etc/smbcredentials/owscsafs01.cred
    sudo echo "password=$access_key" >> /etc/smbcredentials/owscsafs01.cred
fi

sudo bash -c 'echo "//owscsafs01.file.core.windows.net/nas /nas cifs nofail,credentials=/etc/smbcredentials/owscsafs01.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //owscsafs01.file.core.windows.net/nas /nas -o vers=3.0,credentials=/etc/smbcredentials/owscsafs01.cred,dir_mode=0777,file_mode=0777,serverino

### Register System ###
sudo registercloudguest --clean
sudo zypper rm -y cloud-regionsrv-client
sudo SUSEConnect --cleanup --url https://scc.suse.com
sudo SUSEConnect -e dean.johnson@opalwave.com -r $reg_key

### Install HANA Pattern ###
sudo zypper ar -c -f "dir:/nas/SUSE/Repos/SLES_15_SP3" "SAP SLES 15"
sudo zypper -n in -t pattern --force-resolution sap-hana

sudo zypper install -y mdadm

#sudo zypper install -y blobfuse2
sudo mkdir /backup_archive
chmod 777 /backup_archive

sudo zypper -n up

