#!/usr/bin/env bash
cd massa/massa-client
staking_registered_address=$(./massa-client node_get_staking_addresses)
staking_address=$(./massa-client wallet_info | grep 'Address' | cut -d\   -f2)
candidate_rolls=$(./massa-client wallet_info | grep 'Candidate rolls' | cut -d\   -f3)
warn_message_rolls=$(journalctl -u massad.service --since "1 hour ago" | grep -e "roll sale")
if [ "$staking_registered_address" = "$staking_address" ]; then
echo "Node was registered"
else
echo "Node wasn't registered"
./massa-client node_add_staking_private_keys $(./massa-client wallet_info | grep 'Private key' | cut -d\    -f3)
fi
if [ $candidate_rolls -gt "0" ]; then
echo "More than 0"
elif [ $candidate_rolls -lt "1" ]; then
address=$(./massa-client wallet_info | grep 'Address' | cut -d\   -f2)
./massa-client buy_rolls $address 1 0
fi
if [[ $warn_message_rolls =~ "roll sale" ]]
then
if [ $(echo "$(./massa-client wallet_info | grep 'Final balance' | cut -d\   -f3) > 99.99" | bc) -ne 0 ]
then
echo "Roll will be sell"
address=$(./massa-client wallet_info | grep 'Address' | cut -d\   -f2)
./massa-client buy_rolls $address 1 0
fi
fi
