#!/bin/sh
# utils-apache.sh: Installing, configuring and managing apache with its modules.


apache_manage () {

# Manage (restart/reload) apache

echo 'Managing apache'

if [ $1 = 1 ]
  /etc/init.d/apache2 restart
else
  /etc/init.d/apache2 reload
fi

echo 'Done'

}

apache_install_configure () {
# Hint: You'll need ufw :)

# Fetching and installing apache

echo 'Fetching and installing apache'
apt-get -y install apache2 
echo 'Done'

# We don't like apache errors

echo 'Doing some magic to remove apache warnings'
echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn
echo 'Done'

}