#! /bin/bash



## Create file system mount points ###
if [ ! -d "/usr/sap" ]; then
    sudo mkdir -p /usr/sap
fi
if [ ! -d "/hana/shared" ]; then
    sudo mkdir -p /hana/shared
fi
if [ ! -d "/hana/data" ]; then
    sudo mkdir -p /hana/data
fi
if [ ! -d "/hana/log" ]; then
    sudo mkdir -p /hana/log
fi

### Map NAS drive ###
if [ ! -d "/nas" ]; then
    sudo mkdir /nas
fi
if [ ! -d "/etc/smbcredentials" ]; then
    sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/owscsafs01.cred" ]; then
    echo "Creating owscsafs01.cred"
    sudo bash -c 'echo "username=owscsafs01" >> /etc/smbcredentials/owscsafs01.cred'
	sudo chmod 777 /etc/smbcredentials/owscsafs01.cred
    sudo echo "password=$access_key" >> /etc/smbcredentials/owscsafs01.cred
else
    echo "Refreshing owscsafs01.cred"
    sudo rm /etc/smbcredentials/owscsafs01.cred
    sudo bash -c 'echo "username=owscsafs01" >> /etc/smbcredentials/owscsafs01.cred'
	sudo chmod 777 /etc/smbcredentials/owscsafs01.cred
    sudo echo "password=$access_key" >> /etc/smbcredentials/owscsafs01.cred
fi
if [ ! -d "/nas/SUSE" ]; then
    echo "Mounting NAS..."
    sudo bash -c 'echo "//owscsafs01.file.core.windows.net/nas /nas cifs nofail,credentials=/etc/smbcredentials/owscsafs01.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
    sudo mount -t cifs //owscsafs01.file.core.windows.net/nas /nas -o vers=3.0,credentials=/etc/smbcredentials/owscsafs01.cred,dir_mode=0777,file_mode=0777,serverino
fi

### Register System ###
if [[ $(sudo SUSEConnect -s | grep '"subscription_status":"ACTIVE"') ]]; then
    echo "System already registered"
else
    echo "Registering system..."
    sudo registercloudguest --clean
    sudo zypper rm -y cloud-regionsrv-client
    sudo SUSEConnect --cleanup --url https://scc.suse.com
    sudo SUSEConnect -e dean.johnson@opalwave.com -r $reg_key
    echo "Updating system..."
    sudo zypper -n up
fi

echo "Installing applications..."
### Install HANA Pattern ###
if [[ $(sudo zypper repos | grep SAP-SLES-15-SP3) ]]; then
    echo "SUSE Repo already registered"
else
    sudo zypper ar -c -f "dir:/nas/SUSE/Repos/SLES_15_SP3" "SAP-SLES-15-SP3"
    echo "Installing sap-hana pattern..."
    sudo zypper -n in -t pattern --force-resolution sap-hana
    echo "Updating system..."
    sudo zypper -n up
fi

sudo zypper install -y mdadm

# install Azure CLI
if ! command -v az; then
    echo "Installing Azure CLI"
    sudo apt-get update
    sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

    curl -sL https://packages.microsoft.com/keys/microsoft.asc |
        gpg --dearmor |
        sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
        sudo tee /etc/apt/sources.list.d/azure-cli.list

    sudo apt-get update
    sudo apt-get install azure-cli
    sudo apt-get install jq -y
fi

# install blobfuse2
# if ! command -v blobfuse2; then
#     echo "Installing blobfuse2..."
#     sudo sudo rpm -Uvh https://packages.microsoft.com/config/sles/15/packages-microsoft-prod.rpm
#     sudo sudo zypper install -y blobfuse2
# fi