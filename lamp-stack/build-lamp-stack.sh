#!/bin/bash

# Update list of available packages

echo 'Fetching updated list of available packages'
apt-get update
echo 'Done'

# Somebody missed essential packages

echo 'Fetching and installing essential log packages'
apt-get install syslog-ng logrotate -y
echo 'Done'

# Lets install lamp server in silent mode
echo 'Installing LAMP server'
DEBIAN_FRONTEND=noninteractive apt-get install apache2 php5-mysql libapache2-mod-php5 mysql-server -y
echo 'Done'

# We don't like apache errors
echo 'Doing some magic to remove apache warnings'
echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn
echo 'Done'

# Generate mysql password
echo 'Generating mysql root pass'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 16)
echo 'Done'

# Setting up root pass for mysql
echo 'Setting up root mysql pass'
mysqladmin -u root password '$PASS'
echo 'Done'

echo '*****************************************************'
echo
echo 'ALL DONE!'
echo 'Browse to http://your-webbys-ip to see a apache welcome page.'
echo 'Your mysql root password is: '"$PASS"
echo
echo '*****************************************************'