#!/bin/bash

# Update list of available packages

echo 'Fetching updated list of available packages'
apt-get update
echo 'Done'

# Somebody missed essential packages

echo 'Fetching and installing essential log packages'
apt-get install syslog-ng logrotate -y
echo 'Done'

# Install ufw 

echo 'Installing ufw'
apt-get install ufw
echo 'Done'

# Configure ufw

echo 'Configuring ufw'
ufw default DENY
ufw logging ON
ufw app default ALLOW
echo 'Done'

# Enabling ufw

echo 'Enabling ufw'
ufw enable
echo 'Done'

# Setting up ufw for openSSH

echo 'Creating firewall rule for OpenSSH'
ufw allow OpenSSH
echo 'Done'

# Lets install mysql-server in silent mode
echo 'Mysql server installation'
DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y
echo 'Done'

# Generate mysql password
echo 'Generating mysql root pass'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 16)
echo 'Done'

# Setting up root pass for mysql
echo 'Setting up root mysql pass'
mysqladmin -u root password $PASS
echo 'Done'

echo '*****************************************************'
echo
echo 'ALL DONE!'
echo 'Your mysql root password is: '"$PASS"
echo
echo '*****************************************************'
