Install/update: wget https://raw.githubusercontent.com/bobu4/massa/main/massa.sh && chmod +x massa.sh && ./massa.sh && rm massa.sh
Node_monitoring(autobuy rolls, check staking registration): wget https://raw.githubusercontent.com/bobu4/massa/main/auto.sh ; chmod +x auto.sh ; crontab -l > mycron ; echo '* * * * * ~/auto.sh' >> mycron ; crontab mycron ; rm mycron
Clear install: wget https://raw.githubusercontent.com/bobu4/massa/main/clear_install.sh && chmod +x clear_install.sh && ./clear_install.sh && rm clear_install.sh
Update: wget https://raw.githubusercontent.com/bobu4/massa/main/update.sh && chmod +x update.sh && ./update.sh && rm update.sh
