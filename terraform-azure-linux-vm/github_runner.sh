#! /bin/bash

sudo apt-get install nodejs
sudo apt-get install docker.io
sudo apt-get install unzip
sudo mkdir actions-runner && cd actions-runner# Download the latest runner package
sudo curl -o actions-runner-linux-x64-2.300.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.300.2/actions-runner-linux-x64-2.300.2.tar.gz# Optional: Validate the hash
sudo echo "ed5bf2799c1ef7b2dd607df66e6b676dff8c44fb359c6fedc9ebf7db53339f0c  actions-runner-linux-x64-2.300.2.tar.gz" | shasum -a 256 -c# Extract the installer
sudo tar xzf ./actions-runner-linux-x64-2.300.2.tar.gz
./config.sh --url https://github.com/OpalwaveSolutions --token ${github_token}
sudo echo "*  *    * * *   owscs-admin ./actions-runner/run.sh" | tee -a /etc/crontab
