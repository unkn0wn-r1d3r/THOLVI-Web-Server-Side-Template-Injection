#!/bin/bash

# Create a vulnerable SUID binary
sudo install -m 4777 /bin/bash /usr/bin/flask-admin

# Add a cron job running as root
echo '* * * * * root /opt/backup.sh' | sudo tee /etc/cron.d/backup
sudo touch /opt/backup.sh
sudo chmod 777 /opt/backup.sh

# Set up flags
sudo mkdir -p /home/flask /root
echo "USER_FLAG: $(openssl rand -hex 16)" | sudo tee /home/flask/user.txt
echo "ROOT_FLAG: $(openssl rand -hex 16)" | sudo tee /root/root.txt
sudo chmod 644 /home/flask/user.txt