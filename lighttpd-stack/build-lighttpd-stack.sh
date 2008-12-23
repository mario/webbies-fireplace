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
ufw enable
echo 'Done'
 
# Setting up ufw for openSSH
 
echo 'Creating firewall rule for OpenSSH'
ufw allow OpenSSH
echo 'Done'
<<<<<<< HEAD:lighttpd-stack/build-lighttpd-stack.sh

# Setting up ufw for lighttpd

=======
 
>>>>>>> 046ee6e68ae0d8a44dc4ddee282ee392721138eb:lighttpd-stack/build-lighttpd-stack.sh
echo 'Creating firewall rule for lighttpd'
ufw allow http
echo 'Done'
 
<<<<<<< HEAD:lighttpd-stack/build-lighttpd-stack.sh
# Lets install llmp server in silent mode

=======
# Lets install lamp server in silent mode
>>>>>>> 046ee6e68ae0d8a44dc4ddee282ee392721138eb:lighttpd-stack/build-lighttpd-stack.sh
echo 'Installing Lighttpd/MySQL/PHP5'
DEBIAN_FRONTEND=noninteractive apt-get install lighttpd php5-cgi php5-mysql php5-gd php5 mysql-server -y
echo 'Done'

# Generate mysql password
echo 'Generating mysql root pass'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 16)
echo 'Done'
 
# Setting up root pass for mysql
echo 'Setting up root mysql pass'
mysqladmin -u root password $PASS
echo 'Done'
 
# Installing phpmysqladmin
echo 'Getting up and ready with phpmysqladmin'
DEBIAN_FRONTEND=noninteractive apt-get install phpmyadmin -y
ln -sf /etc/phpmyadmin/lighttpd.conf /etc/lighttpd/conf-enabled/
echo 'Done'

# Reloading lighttpd with php support
<<<<<<< HEAD:lighttpd-stack/build-lighttpd-stack.sh

echo 'Reloading lighttpd with php support'
lighttpd-enable-mod fastcgi
/etc/init.d/lighttpd reload
echo 'Done'
=======
lighttpd-enable-mod fastcgi
/etc/init.d/lighttpd reload
>>>>>>> 046ee6e68ae0d8a44dc4ddee282ee392721138eb:lighttpd-stack/build-lighttpd-stack.sh

echo '*****************************************************'
echo
echo 'ALL DONE!'
<<<<<<< HEAD:lighttpd-stack/build-lighttpd-stack.sh
echo 'Browse to http://your-webbys-ip to see a lighttpd welcome page.'
=======
echo 'Browse to http://your-webbys-ip to see a apache welcome page.'
>>>>>>> 046ee6e68ae0d8a44dc4ddee282ee392721138eb:lighttpd-stack/build-lighttpd-stack.sh
echo 'Browse to http://your-webbys-ip/phpmyadmin to see a phpmyadmin login page.'
echo 'Your mysql root password is: '"$PASS"
echo
echo '*****************************************************'
