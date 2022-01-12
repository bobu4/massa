#!/bin/bash
cd massa/massa-client
candidate_rolls=$(./massa-client wallet_info | grep 'Candidate rolls' | cut -d\   -f3)
if [ $candidate_rolls -gt "0" ]; then
echo "More than 0"
elif [ $candidate_rolls -lt "1" ]; then
#cd ; python3 tz.py "Attention!Your massa node hasn't active rolls on $(hostname)!" ; cd massa/massa-client
address=$(./massa-client wallet_info | grep 'Address' | cut -d\   -f2)
./massa-client buy_rolls $address 1 0
fi
