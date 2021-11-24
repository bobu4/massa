Auto-buy: wget https://raw.githubusercontent.com/bobu4/massa/main/bal.sh && chmod +x bal.sh && tmux new-session -d -s rolls './bal.sh'
Auto-install: wget https://raw.githubusercontent.com/bobu4/massa/main/install.sh && chmod +x install.sh && ./install.sh
Monitoring + autobuy: wget https://raw.githubusercontent.com/bobu4/massa/main/bal_tel.sh && chmod +x bal_tel.sh && crontab -l > mycron && echo '* * * * * ~/bal_tel.sh.sh >> mycron && crontab mycron && rm mycron
