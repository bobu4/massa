#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget jq unzip git build-essential pkg-config libssl-dev -y
rm -rf backup
mkdir backup
cp /root/massa/massa-node/config/node_privkey.key /root/backup/node_privkey.key
cp /root/massa/massa-client/wallets/wallet_AU12UkG6j7QHS6VviWB4jikGVB7tBpxNRxv6RFyKDfNeVbH7Cn5as.yaml /root/backup/wallet_AU12UkG6j7QHS6VviWB4jikGVB7tBpxNRxv6RFyKDfNeVbH7Cn5as.yaml
rm -rf massa
wget -qO massa.tar.gz https://github.com/massalabs/massa/releases/download/MAIN.2.1/massa_MAIN.2.1_release_linux.tar.gz
tar -xzvf massa.tar.gz
rm -rf massa.tar.gz
chmod +x /root/massa/massa-node/massa-node /root/massa/massa-client/massa-client
read -sp 'Enter the password for your massa wallet: ' passwd
sed -i "/ passwd=/d" $HOME/.bash_profile
echo "export passwd=\"${passwd}\"" >> $HOME/.bash_profile
cp /root/backup/node_privkey.key /root/massa/massa-node/config/node_privkey.key
cp /root/backup/wallet_AU12UkG6j7QHS6VviWB4jikGVB7tBpxNRxv6RFyKDfNeVbH7Cn5as.yaml /root/massa/massa-client/wallets/wallet_AU12UkG6j7QHS6VviWB4jikGVB7tBpxNRxv6RFyKDfNeVbH7Cn5as.yaml
sudo tee <<EOF >/dev/null /etc/systemd/system/massad.service
[Unit]
Description=Massa Node
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$path/massa/massa-node
ExecStart=$path/massa/massa-node/massa-node -p "$passwd"
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
./massa-client -p $passwd node_start_staking $(./massa-client -p $passwd wallet_info | grep 'Address' | cut -d\   -f2) ; ./massa-client -p $passwd node_get_staking_addresses
