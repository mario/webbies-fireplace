#!/bin/sh
# utils-sslcert.sh: Various useful utilities.

misc_genpass () {
# only argument is number of chars password should have
# please use 16 for DB stuff and 5 for more regular things
if [ "$1" = ""]; then 
  $1 = 16
fi
    
echo 'Generating a password'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 16)
echo 'Done'

}

misc_apt_update () {

# Update list of available packages

echo 'Fetching updated list of available packages'
apt-get update
echo 'Done'

}

misc_install_syslog () {

# Essential packages

echo 'Fetching and installing essential log packages'
apt-get install syslog-ng logrotate -y
echo 'Done'

}
misc_apt_update () {

# Update list of available packages

echo 'Fetching updated list of available packages'
apt-get update
echo 'Done'

}

misc_install_syslog () {

# Essential packages

echo 'Fetching and installing essential log packages'
apt-get install syslog-ng logrotate -y
echo 'Done'

}
misc_phpmyadmin_configure () {

# Installing phpmysqladmin

echo 'Getting up and ready with phpmysqladmin'
DEBIAN_FRONTEND=noninteractive apt-get install phpmyadmin -y
echo 'Done'

# Setting up phpmysqladmin

echo 'Setting up phpmysqladmin'
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
echo 'Done'

}

misc_apt_update () {

# Update list of available packages

echo 'Fetching updated list of available packages'
apt-get update
echo 'Done'

}

misc_install_syslog () {

# Essential packages

echo 'Fetching and installing essential log packages'
apt-get install syslog-ng logrotate -y
echo 'Done'

}

misc_phpmyadmin_configure () {

# Installing phpmysqladmin

echo 'Getting up and ready with phpmysqladmin'
DEBIAN_FRONTEND=noninteractive apt-get install phpmyadmin -y
echo 'Done'

# Setting up phpmysqladmin

echo 'Setting up phpmysqladmin'
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
echo 'Done'

}