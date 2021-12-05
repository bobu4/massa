!#bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
wget -qO massa.zip https://github.com/massalabs/massa/releases/latest/download/release_linux.zip
unzip massa.zip
rm -rf massa.zip
cp /root/backup/node_privkey.key $HOME/massa/massa-node/config
cp /root/backup/wallet.dat $HOME/massa/massa-client
rm -rf backup


sudo tee <<EOF >/dev/null /etc/systemd/system/massad.service
[Unit]
Description=Massa Node
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/massa/massa-node
ExecStart=$HOME/massa/massa-node/massa-node
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable massad
sudo systemctl daemon-reload
sudo systemctl restart massad
