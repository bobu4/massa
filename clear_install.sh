#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.14.7/massa_TEST.14.7_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
read -sp 'Enter the password for your massa wallet: ' passwd
sed -i "/ passwd=/d" $HOME/.bash_profile
echo "export passwd=\"${passwd}\"" >> $HOME/.bash_profile
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/Massa/main/multi_tool.sh) \
-rb

sudo tee <<EOF >/dev/null /etc/systemd/system/massad.service
[Unit]
Description=Massa Node
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/massa/massa-node
ExecStart=$HOME/massa/massa-node/massa-node -p "$passwd"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable massad
sudo systemctl restart massad

sleep 10
cd massa/massa-client
./massa-client -p $passwd wallet_generate_secret_key
./massa-client -p $passwd node_add_staking_secret_keys $(./massa-client -p $passwd wallet_info | grep 'Secret key' | cut -d\   -f3) ; ./massa-client -p $passwd node_get_staking_addresses
read -p 'Enter discord id, obtained in massa bot: ' discord
signature=$(./massa-client -p $passwd node_testnet_rewards_program_ownership_proof $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) $discord)
./massa-client -p $passwd buy_rolls $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) 1 0
echo $signature
