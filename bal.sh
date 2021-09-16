#!/bin/bash
cd massa/massa-client
while true
do
	balance=$(./massa-client --cli true wallet_info | jq -r '.balances[].final_ledger_data.balance')
	int_balance=${balance%%.*}
	if [ $int_balance -gt "99" ]; then
		echo "More than 99"
		resp=$(./massa-client buy_rolls $massa_wallet_address $(($int_balance/100)) 0)
		echo $resp
	elif [ $int_balance -lt "100" ]; then
		echo "Less than 100"
	fi
	printf "sleep"
	for((sec=0; sec<60; sec++))
	do
		printf "."
		sleep 1
	done
	printf "\n"
done
