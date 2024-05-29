# /etc/systemd/system/github-runner.service
[Unit]
Description=GitHub Runner

[Service]
User=githubrunner1
Type=oneshot
Environment="RESOURCE_GROUP=owscs-rsg-prod"
Environment="TOKEN_KEY_VAULT_NAME=kv-owscs-hub"
Environment="TOKEN_KEY_VAULT_SECRET_NAME=githubpat"
ExecStart=-/bin/bash /opt/githubrunner/reg_runner.sh
ExecStart=/bin/bash /opt/githubrunner/completed_cycle.sh

[Install]
WantedBy=multi-user.target