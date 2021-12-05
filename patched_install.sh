!#bin/bash
systemctl stop massad
rm -rf massa-client
rm -rf massa-node
wget -qO massa.zip https://github.com/massalabs/massa/releases/latest/download/release_linux.zip
unzip $HOME/massa.zip -d $HOME/massa/
rm -rf massa.zip
chmod +x $HOME/massa/massa-node/massa-node $HOME/massa/massa-client/massa-client
cp /root/backup/node_privkey.key $HOME/massa/massa-node/config
cp /root/backup/wallet.dat $HOME/massa/massa-client
rm -rf backup
systemctl start massad
