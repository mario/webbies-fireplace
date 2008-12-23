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

# Fetching and installing apache

echo 'Fetching and installing apache'
apt-get install apache2 -y
echo 'Done'

# We don't like apache errors
echo 'Doing some magic to remove apache warnings'
echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn
echo 'Done'

# Fetching and installing apache modules

echo 'Fetching and installing apache mods'
apt-get install libapache2-mod-jk -y
echo 'Done'

# Restart apache
echo 'Restarting apache'
/etc/init.d/apache2 restart
echo 'Done'

# Fetching and installing openJDK

echo 'Fetching and installing apache mods'
sudo apt-get install openjdk-6-jdk -y
echo 'Done'

# Fetching and unpacking tomcat6
echo 'Fetching and unpacking tomcat'
cd /usr/share
wget http://mirror.nyi.net/apache/tomcat/tomcat-6/v6.0.18/bin/apache-tomcat-6.0.18.tar.gz
tar zxvf apache-tomcat-6.0.18.tar.gz
echo 'Done'

# Lets remove apache- prefix
echo 'Renaming apache-tomcat dir'
mv apache-tomcat-6.0.18 tomcat-6.0.18
echo 'Done'

# We need user and a group
echo 'Creating tomcat user and group'
useradd -M tomcat
grupadd tomcat
echo 'Done'

# Webapps should be owned by tomcat
echo 'Making webapps owned by tomcat:tomcat'
cd tomcat-6.0.18
chown -R tomcat:tomcat webapps; chmod -R 775 webapps
echo 'Done'

# User tomcat goes into apache group
echo 'Messing with tomcat user'
usermod -aG tomcat www-data
echo 'Done'

# Making thing work 
echo '755 on shutdown and startup'
cd bin && chmod 755 shutdown.sh startup.sh && cd ..
echo 'Done'

# Lets throw in Apache 
echo 'Throwing apache more in the mix'
cp ~/webbies-fireplace/grails-stack/sources/etc/apache2/workers.properties /etc/apache2
chown tomcat.tomcat /etc/apache2/workers.properties
cp ~/webbies-fireplace/grails-stack/sources/etc/apache2/sites-available/java_example /etc/apache2/sites-available
cp ~/webbies-fireplace/grails-stack/sources/usr/share/tomcat-6.0.18/conf/server.xml /usr/share/tomcat-6.0.18/conf/server.xml
echo "Include /usr/share/tomcat-6.0.18/conf/auto/mod_jk.conf" >> /etc/apache2/apache2.conf
echo 'Done'

# Stop Apache
echo 'Stopping apache'
/etc/init.d/apache2 stop
echo 'Done'

# Create tomcat init scripts
echo 'Configure tomcat init scripts'
cp ~/webbies-fireplace/grails-stack/sources/etc/init.d/tomcat /etc/init.d
chmod +x /etc/init.d/tomcat
invoke-rc.d tomcat start
echo 'Done'

# Setting up GRAILS & Java environment
echo 'Setting up grails and java environment'
cp ~/webbies-fireplace/grails-stack/sources/etc/environment /etc/environment
echo 'Done'

# Setting up ufw for tomcat

echo 'Creating firewall rule for tomcat'
ufw allow 8080/tcp
echo 'Done'

# Setting up ufw for apache

echo 'Creating firewall rule for apache2'
ufw allow "Apache Full"
echo 'Done'

# Restarting tomcat and apache
echo 'Restarting tomcat and apache'
/etc/init.d/tomcat start
/etc/init.d/apache2 restart
echo 'Done'

# Fetching and installing grails
echo 'Fetching and installing grails'
cd ~
wget http://dist.codehaus.org/grails/grails-bin-1.0.4.tar.gz
mkdir /usr/lib/grails
cd /usr/lib/grails/
mv ~/grails-bin-1.0.4.tar.gz .
tar zxvf grails-bin-1.0.4.tar.gz
echo 'Done'

echo '*****************************************************'
echo
echo 'ALL DONE!'
echo 'Browse to http://your-webbys-ip to see a apache welcome page.'
echo 'Browse to http://your-webbys-ip:8080 to see a tomcat welcome page.'
echo
echo '*****************************************************'
