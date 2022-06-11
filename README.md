Install/update: wget https://raw.githubusercontent.com/bobu4/massa/main/massa.sh && chmod +x massa.sh && ./massa.sh && rm massa.sh
Node_monitoring(autobuy rolls, check staking registration): wget https://raw.githubusercontent.com/bobu4/massa/main/auto.sh ; chmod +x auto.sh ; crontab -l > mycron ; echo '* * * * * ~/auto.sh' >> mycron ; crontab mycron ; rm mycron
