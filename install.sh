!#bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
wget -qO massa.zip https://github.com/massalabs/massa/releases/download/TEST.6.5/release_linux.zip
unzip massa.zip -d $HOME/massa/
rm -rf massa.zip
cp $HOME/backup/node_privkey.key $HOME/massa/massa-node/config
cp $HOME/backup/wallet.dat $HOME/massa/massa-client
rm -rf backup
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client

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
./massa-client node_add_staking_private_keys $(./massa-client wallet_info | grep 'Private key' | cut -d\    -f3) ; ./massa-client node_get_staking_addresses
read -p 'Enter discord id, obtained in massa bot: ' discord
./massa-client node_testnet_rewards_program_ownership_proof $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) $(discord)
./massa-client buy_rolls $(./massa-client wallet_info | grep 'Address' | cut -d\   -f2) 1 0
./massa-client wallet_info
cd
