#!/bin/bash
# build-wordpress-stack.sh: Wordpress installer.

# Assumptions: This script assumes that you have a fresh linux install on your VPS.
#               If Apache, MySQL, or PHP have not been installed they will be.
#               Because this script creates a db and user MySQL cannot be preinstalled.
#               If MySQL is installed this script will exit.

# TODO: add user email as argument, we need it for installations

which mysql

if [ $? -eq 0 ]; then
  # exit if MySQL is found
  echo 'MySQL is installed, Exiting'
  exit
fi

if [ $# -eq 0 ]; then
  # exit if the user doesn't give an email
  echo 'Required email address as an argument, exiting.'
  exit
fi

# regex validation for email (inprogress)
# USEREMAIL=$1
# REGEX="\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b"
# if [ $USEREMAIL =~ $REGEX ]; then
  # stuff
# fi

# Import utils { misc, apache, db, php, ufw } 
source ../utils/utils-misc.sh
source ../utils/utils-apache.sh
source ../utils/utils-db.sh
source ../utils/utils-php.sh
source ../utils/utils-ufw.sh

# once the LAMP Stack is finished this will be replaced
misc_apt_update
misc_install_syslog
ufw_install_configure
ufw_openssh
ufw_enable
apache_install_configure
ufw_apache_full
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
tar -xzf latest.tar.gz
mkdir /var/www/blog
cp -r wordpress/* /var/www/blog
echo 'WP downloaded and uncompressed'

# Creating database and user
echo 'Creating Database and User'
mysql -e "CREATE DATABASE wordpress;" -u root -p$PASS
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* to 'WP_user'@'localhost' IDENTIFIED BY '$PASS' WITH GRANT OPTION;" -u root -p$PASS

# cleaning up files
cd /var/www/blog
rm -rf ~/WPinstall

# creating wp-config.php
cat wp-config-sample.php | \
sed -e 's/putyourdbnamehere/wordpress/' \
 -e 's/usernamehere/WP_user/' \
 -e 's/yourpasswordhere/'$PASS'/' > wp-config.php
  
# Run WP install steps
#ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
# curl whatismyip.org
# editing install.php to make it happen
cd /var/www/blog/wp-admin
cp install.php install.php.bak
cat install.php | \
sed 's/_POST/_GET/g' > install.php

# wget "127.0.0.1/blog/wp-admin/install.php?step=1"
apt-get install lynx
lynx "127.0.0.1/blog/wp-admin/install.php?step=2&weblog_title=Blog&admin_email=$USEREMAIL"


# Remove install.php
mv /var/www/blog/wp-admin/install.php /var/www/blog/wp-admin/install.php.bak2

echo 'Done Installing Wordpress'
echo 'Your MySQL root password is '"$PASS"
echo 'Your Wordpress database is "wordpress"'
echo 'Your Wordpress database user is "WP_user"'
echo 'Your Wordpress database password is '"$PASS"
