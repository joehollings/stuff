#! /bin/bash

# add runner user
sudo adduser githubrunner1 --system --group
if sudo bash -c '[[ ! -f "/home/githubrunner1/.netrc " ]]'; then
    sudo touch /home/githubrunner1/.netrc 
    sudo echo "machine github.com login joehollings password $github_token" >> /home/githubrunner1/.netrc
fi

# allow sudo for runner user
if [[ $(sudo cat /etc/sudoers | grep githubrunner1) ]]; then
    echo "githubrunner1 already exists in sudoers"
else
    echo 'githubrunner1 ALL = NOPASSWD:/usr/bin/apt-get, /usr/sbin/usermod, /usr/bin/gpg, /usr/bin/tee, /usr/bin/curl' | sudo EDITOR='tee -a' visudo
fi

# update system
echo "Checking for updates..."
sudo apt-get update

# install unzip
if ! command -v unzip; then
    sudo apt-get install -y unzip
fi

# install node.js
if ! command -v node; then
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    NODE_MAJOR=20
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt-get update
    sudo apt-get install nodejs -y
    # curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
    # echo "Node.js not available, installing..."
    # sudo apt-get -y install nodejs
fi

# install docker
if ! command -v docker; then
    echo "Docker not available, installing dependencies..."

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y \
        make \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
        sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker githubrunner1
fi

# install ansible
if ! command --version ansible; then
    echo "Ansible not available, installing..."

    sudo apt update
    sudo apt install software-properties-common -y
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt update
    sudo apt install ansible -y
fi

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

# install Packer and Terraform 

if ! command -v packer; then
    echo "Installing Hashicorp Packer..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y
    sudo apt-get update
    sudo apt-get install packer
fi

if ! command -v terraform; then
    echo "Installing Hashicorp Terraform..."
    sudo apt-get install terraform
fi

# install runner software
if sudo bash -c '[[ ! -f "/home/githubrunner1/actions-runner/actions-runner-linux-x64-2.304.0.tar.gz" ]]'; then
    echo "Downloading runner software..."
    sudo -u githubrunner1 bash -c '\
        mkdir -p ~/actions-runner && \
        cd ~/actions-runner && \
        curl -o actions-runner-linux-x64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-x64-2.304.0.tar.gz && \
        tar xzf ./actions-runner-linux-x64-2.304.0.tar.gz'
fi

# mount nas
if [ ! -d "/nas" ]; then
    sudo mkdir /nas
fi
if [ ! -d "/etc/smbcredentials" ]; then
    sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/owscsafs01.cred" ]; then
    sudo bash -c 'echo "username=owscsafs01" >> /etc/smbcredentials/owscsafs01.cred'
	sudo chmod 777 /etc/smbcredentials/owscsafs01.cred
    sudo echo "password=$access_key" >> /etc/smbcredentials/owscsafs01.cred
fi
if [ ! -d "/nas/gh_runner" ]; then
    echo "Mounting NAS..."
    sudo mount -t cifs //owscsafs01.file.core.windows.net/nas /nas -o vers=3.0,credentials=/etc/smbcredentials/owscsafs01.cred,dir_mode=0777,file_mode=0777,serverino
fi

# copy completed_cycle.sh from nas
if [ ! -d "/opt/githubrunner" ]; then
    sudo mkdir /opt/githubrunner
fi
if [ ! -f "/opt/githubrunner/completed_cycle.sh" ]; then
    sudo cp /nas/gh_runner/completed_cycle.sh /opt/githubrunner/completed_cycle.sh
fi

# copy reg_runner.sh from nas
if [ ! -d "/opt/githubrunner" ]; then
    echo "Creating /opt/githubrunner"
    sudo mkdir /opt/githubrunner
fi
if [ ! -f "/opt/githubrunner/reg_runner.sh" ]; then
    echo "Copying reg_runner.sh to /opt/githubrunner/reg_runner.sh"
    sudo cp /nas/gh_runner/reg_runner.sh /opt/githubrunner/reg_runner.sh
fi

# copy the runner service from the nas and enable
if [ ! -f "/etc/systemd/system/github-runner.service" ]; then
    echo "Creating github-runner.service"
    sudo cp /nas/gh_runner/github-runner.service /etc/systemd/system/github-runner.service  
fi
# enable the runner service
if [[ $(systemctl list-units --type=service -all | grep github) ]]; then
    echo "github-runner.service already enabled"
else
    echo "Enabling github-runner.service"
    sudo systemctl enable github-runner.service
fi