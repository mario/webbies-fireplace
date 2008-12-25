#!/bin/sh
# build-wordpress-stack: Wordpress installer.

# Assumptions: This script assumes that you have a fresh linux install on your VPS.
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
. "../utils/utils-misc.sh"
. "../utils/utils-ufw.sh"
. "../utils/utils-apache.sh"
. "../utils/utils-db.sh"
. "../utils/utils-php.sh"

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

# Download Latest Wordpress
echo 'Downloading and uncompressing Wordpress'
mkdir ~/WPinstall
cd ~/WPinstall
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp -r wordpress/* /var/www
echo 'WP downloaded and uncompressed'

# Creating database and user
echo 'Creating Database and User'
echo CREATE DATABASE wordpress\; | mysql -u root -p$PASS
echo GRANT ALL PRIVILEGES ON wordpress.* to \'WP_user\'@\'%\' IDENTIFIED BY \'$PASS\' WITH GRANT OPTION\; | mysql -u root -p$PASS

cd /var/www
cat wp-config-sample.php | sed -e "s/putyourdbnamehere/wordpress/" | \
  sed -e "s/usernamehere/WP_user/" | \
  sed -e "s/yourpasswordhere/$PASS/" > wp-config.php
  
# Run WP install steps
#ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
curl whatismyip.org

wget -q $?/wp-admin/install.php?step=1
wget -q $?/wp-admin/install.php?step=2

echo 'Done Installing Wordpress'
echo 'Your MySQL root password is '"$PASS"
echo 'Your Wordpress database is "wordpress"'
echo 'Your Wordpress database user is "WP_user"'
echo 'Your Wordpress database password is '"$PASS"