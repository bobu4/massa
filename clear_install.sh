#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.13.0/massa_TEST.13.0_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
read -sp 'Enter the password for your massa wallet: ' passwd
sed -i "/ massa_password=/d" $HOME/.bash_profile
echo 'export massa_password="$passwd"' >> $HOME/.bash_profile
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/Massa/main/multi_tool.sh) \
-rb

sudo tee <<EOF >/dev/null /etc/systemd/system/massad.service
[Unit]
Description=Massa Node
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/massa/massa-node
ExecStart=$HOME/massa/massa-node/massa-node -p "passwd"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable massad
sudo systemctl restart massad
