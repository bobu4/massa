#!/usr/bin/env bash
cd massa/massa-client
address=$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.address')
if [ $(echo "$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.final_balance') > 101" | bc) -ne 0 ]
then
echo "Buy one more roll"
./massa-client -p $passwd buy_rolls $address 1 0
else
echo $(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.final_balance')
fi
