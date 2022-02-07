!#bin/bash
cd massa/massa-client
staking_registered_address=$(./massa-client node_get_staking_addresses)
staking_address=$(./massa-client wallet_info | grep 'Address' | cut -d\   -f2)
if [ "$staking_registered_address" = "$staking_address" ]; then
echo "Node was registered"
else
echo "Node wasn't registered"
./massa-client node_add_staking_private_keys $(./massa-client wallet_info | grep 'Private key' | cut -d\    -f3)
fi
