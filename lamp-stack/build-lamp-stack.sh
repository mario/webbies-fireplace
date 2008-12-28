#!/bin/sh

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
apt-get install ufw -y
echo 'Done'

# Configure ufw

echo 'Configuring ufw'
ufw default DENY
ufw logging ON
ufw app default ALLOW
echo 'Done'

# Enabling ufw

echo 'Enabling ufw'
echo y | ufw enable
echo 'Done'

# Setting up ufw for openSSH

echo 'Creating firewall rule for OpenSSH'
ufw allow OpenSSH
echo 'Done'

# Lets install lamp server in silent mode
echo 'Installing LAMP server'
DEBIAN_FRONTEND=noninteractive apt-get install apache2 php5-mysql libapache2-mod-auth-mysql php5 mysql-server -y
echo 'Done'

# Setting up ufw for apache

echo 'Creating firewall rule for apache2'
ufw allow "Apache Full"
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
mysqladmin -u root password $PASS
echo 'Done'

# Most people need mod_rewrite

echo 'Enabling mod_rewrite'
a2enmod rewrite
echo 'Done'

# Installing phpmysqladmin

echo 'Getting up and ready with phpmysqladmin'
DEBIAN_FRONTEND=noninteractive apt-get install phpmyadmin -y
echo 'Done'

# Setting up phpmysqladmin

echo 'Setting up phpmysqladmin'
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
echo 'Done'

# Restarting apache

echo 'Restarting apache'
/etc/init.d/apache2 restart
echo 'Done'

echo '*****************************************************'
echo
echo 'ALL DONE!'
echo 'Browse to http://your-webbys-ip to see a apache welcome page.'
echo 'Browse to http://your-webbys-ip/phpmyadmin to see a phpmyadmin login page.'
echo 'Your mysql root password is: '"$PASS"
echo
echo '*****************************************************'