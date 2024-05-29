#! /bin/bash

### Map NAS drive ###
sudo mkdir /mnt/nas
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/owscsafs01.cred" ]; then
    sudo bash -c 'echo "username=owscsafs01" >> /etc/smbcredentials/owscsafs01.cred'
    sudo bash -c 'echo "password=U+/4/vQg0m8Z0vAbOu+8weZX5mxmH0LropQfj9lApX6iQekE10QfgokgL7aOMfCzM0AjeNhphYZ0Tn/RXNbdUQ==" >> /etc/smbcredentials/owscsafs01.cred'
fi
sudo chmod 600 /etc/smbcredentials/owscsafs01.cred

sudo bash -c 'echo "//owscsafs01.file.core.windows.net/nas /mnt/nas cifs nofail,vers=3.0,credentials=/etc/smbcredentials/owscsafs01.cred,dir_mode=0777,file_mode=0777,serverino"'
sudo mount -t cifs //owscsafs01.file.core.windows.net/nas /mnt/nas -o vers=3.0,credentials=/etc/smbcredentials/owscsafs01.cred,dir_mode=0777,file_mode=0777,serverino

### Register System ###
sudo registercloudguest --clean
sudo zypper rm -y cloud-regionsrv-client
sudo SUSEConnect --cleanup --url https://scc.suse.com
sudo SUSEConnect -e dean.johnson@opalwave.com -r 26FC7A5C44C2DA75

### Add local host entry ###
echo "127.0.0.1    "${host_name} >> /etc/hosts

### Update system ###
sudo zypper -n up

### Install and configure Blobfuse ###
# sudo zypper install blobfuse
# sudo mkdir /mnt/blobfusetmp -p
# sudo chown root /mnt/blobfusetmp
# mkdir /backups
# blobfuse /restore --tmp-path=/mnt/blobfusetmp  --config-file=/mnt/nas/fuse_connection.cfg -o attr_timeout=240 -o entry_timeout=240 -o negative_timeout=120