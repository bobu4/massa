#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/TEST.10.0/massa_TEST.10.0_release_linux.tar.gz
tar -xvf $HOME/massa.tar.gz
rm -rf $HOME/massa.tar.gz
read -p 'Enter ip from previous server: ' ip
read -sp 'Enter password from previous server: ' pass
scp -pw $pass root@"$ip":/root/massa/massa-node/config/node_privkey.key $HOME/massa/massa-node/config/node_privkey.key
scp -pw $pass root@"$ip":/root/massa/massa-client/wallet.dat $HOME/massa/massa-client/wallet.dat
cp $HOME/backup/wallet.dat $HOME/massa/massa-client
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
bootstrap_list=`wget -qO- https://raw.githubusercontent.com/SecorD0/Massa/main/bootstrap_list.txt`;
perl -i -0pe 's/bootstrap_list = \[\n.*\[.*].*\n.*\[.*].*\n.*\[.*].*\n.*\[.*].*\n.*]\n.*# \[optionnal]/'"$bootstrap_list"'\n    # \[optionnal]/' $HOME/massa/massa-node/base_config/config.toml

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
cd massa/massa-client
sleep 10
./massa-client node_add_staking_private_keys $(./massa-client wallet_info | grep 'Private key' | cut -d\    -f3) ; ./massa-client node_get_staking_addresses
read -p 'Enter discord id, obtained in massa bot: ' discord
./massa-client node_testnet_rewards_program_ownership_proof $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) $discord
./massa-client buy_rolls $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) 1 0
./massa-client wallet_info
cd
