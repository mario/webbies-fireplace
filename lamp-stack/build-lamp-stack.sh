#!/bin/bash
# build-lamp-stack2.sh: LAMP installer v2.

# Import utils { misc, apache, db, php, ufw } 
source ../utils/utils-misc.sh
source ../utils/utils-apache.sh
source ../utils/utils-db.sh
source ../utils/utils-php.sh
source ../utils/utils-ufw.sh

# LAMP stack
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
misc_phpmyadmin_install_configure
apache_manage 1

echo '*****************************************************************'
echo
echo 'Done!'
echo 'Your MySQL root password is: '"$PASS"
echo 'Visit http://your-ip to see your Apache Welcome page'
echo 'Visit http://your-ip/phpmyadmin to see your PHPMyAdmin install'
echo
echo '*****************************************************************'