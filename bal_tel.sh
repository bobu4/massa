#!/bin/bash
cd massa/massa-client
active_rolls=$(./massa-client wallet_info | grep 'Active rolls' | cut -d\   -f3)
if [ $active_rolls -gt "0" ]; then
echo "More than 0"
cd ; python3 tz.py "Attention!Your massa node hasn't active rolls on $(hostname)!" ; cd massa/massa-client
elif [ $active_rolls -lt "1" ]; then
address=$(./massa-client wallet_info | grep 'Address' | cut -d\   -f2)
./massa-client buy_rolls $address 1 0
fi
