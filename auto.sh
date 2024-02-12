#!/usr/bin/env bash
cd massa/massa-client
address=$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.address')
if [ $(echo "$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.final_balance') > 101" | bc) -ne 0 ]
then
echo "Buy one more roll"
balance_tokens=$(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.final_balance')
float_rolls=$(awk "BEGIN { printf(\"%.2f\", $balance_tokens / 100) }")
rolls_to_buy=$(echo ${float_rolls%%.*})
./massa-client -p $passwd buy_rolls $address $rolls_to_buy 0
else
echo $(./massa-client -p $passwd wallet_info -j | jq -r '.[].address_info.final_balance')
fi
