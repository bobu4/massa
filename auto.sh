#!/usr/bin/env bash
cd massa/massa-client
staking_registered_address=$(./massa-client -p $passwd node_get_staking_addresses)
staking_address=$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.address')
candidate_rolls=$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.candidate_rolls')
warn_message_rolls=$(journalctl -u massad.service --since "1 hour ago" | grep -e "roll sale")
if [ "$staking_registered_address" = "$staking_address" ]; then
echo "Node was registered"
else
echo "Node wasn't registered"
./massa-client -p $passwd node_add_staking_secret_keys $(./massa-client -p $passwd wallet_info -j | jq -r '.[].keypair.secret_key')
fi
if [ $candidate_rolls -gt "0" ]; then
echo "More than 0"
elif [ $candidate_rolls -lt "1" ]; then
address=$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.address')
./massa-client -p $passwd buy_rolls $address 1 0
fi
if [[ $warn_message_rolls =~ "roll sale" ]]
then
if [ $(echo "$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.final_sequential_balance') > 99.99" | bc) -ne 0 ]
then
echo "Roll will be sell"
address=$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.address')
./massa-client -p $passwd buy_rolls $address 1 0
fi
fi
