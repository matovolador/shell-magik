#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt -y install mysql-server-5.7 --install-recommends
service mysql start
# remove the fucking password validation plugin
mysql_secure_installation <<EOF
n
secret
secret
y
y
y
y
EOF
service mysql restart
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'secret'"