#!/bin/sh
# build-wordpress-stack: Wordpress installer.

# Assumptions: This script assumes that you have a fresh linux install on your Webby.
#               If Apache, MySQL, or PHP have not been installed they will be.
#               Because this script creates a db and user MySQL cannot be preinstalled.
#               If MySQL is installed this script will exit.

which mysql

if [ $? -eq 0 ]; then
  # exit if MySQL is found
  echo 'MySQL is installed, Exiting'
  exit
fi

# Import utils { misc, apache, db, php } 
source utils-misc.sh
source utils-apache.sh
source utils-db.sh
source utils-php.sh

# once the LAMP Stack is finished this will be replaced
misc_apt_update
misc_install_syslog
ufw_install_configure
ufw_openssh
ufw_apache_full
apache_install_configure
apache_module_install 1
php_install 2
php_module_install 2 1
db_mysql_install_configure
apache_module_enable 1
misc_phpmyadmin_configure
apache_manage 1

# Download Wordpress Latest
echo 'Downloading and uncompressing Wordpress'
mkdir ~/WPinstall
cd ~/WPinstall
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cd wordpress
echo 'WP downloaded and uncompressed'


echo 'Done'