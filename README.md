Monitoring + autobuy: wget https://raw.githubusercontent.com/bobu4/massa/main/bal_tel.sh ; chmod +x bal_tel.sh ; crontab -l > mycron ; echo '* * * * * ~/bal_tel.sh' >> mycron ; crontab mycron ; rm mycron
Autoinstall: wget https://github.com/bobu4/massa/raw/main/patched_install.sh && chmod +x patched_install.sh && ./patched_install.sh
Install: wget https://raw.githubusercontent.com/bobu4/massa/main/install.sh && chmod +x install.sh && ./install.sh
Massa: wget https://raw.githubusercontent.com/bobu4/massa/main/massa.sh && chmod +x massa.sh && ./massa.sh
Auto: wget https://raw.githubusercontent.com/bobu4/massa/main/auto.sh ; chmod +x auto.sh ; crontab -l > mycron ; echo '* * * * * ~/auto.sh' >> mycron ; crontab mycron ; rm mycron
Auto with previous: https://raw.githubusercontent.com/bobu4/massa/main/auto.sh ; chmod +x auto.sh ; crontab -l > mycron ; sed -i 's/bal_tel/auto/' >> mycron ; crontab mycron ; rm mycron
