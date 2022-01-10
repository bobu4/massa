Monitoring + autobuy: wget https://raw.githubusercontent.com/bobu4/massa/main/bal_tel.sh ; chmod +x bal_tel.sh ; crontab -l > mycron ; echo '* * * * * ~/bal_tel.sh' >> mycron ; crontab mycron ; rm mycron
Autoinstall: wget https://github.com/bobu4/massa/raw/main/patched_install.sh && chmod +x patched_install.sh && ./patched_install.sh
Install: wget https://raw.githubusercontent.com/bobu4/massa/main/install.sh && chmod +x install.sh && ./install.sh
