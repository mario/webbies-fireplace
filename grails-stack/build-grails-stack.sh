#!/bin/bash


# Update list of available packages

echo 'Fetching updated list of available packages'
apt-get update
echo 'Done'

# Somebody missed essential packages

echo 'Fetching and installing essential log packages'
apt-get install syslog-ng logrotate
echo 'Done'

# Fetching and installing apache

echo 'Fetching and installing apache'
apt-get install apache2
echo 'Done'

# Fetching and installing apache modules

echo 'Fetching and installing apache mods'
apt-get install libapache2-mod-jk
echo 'Done'

# Restart apache
echo 'Restarting apache'
/etc/init.d/apache2 restart
echo 'Done'

# Fetching and installing openJDK

echo 'Fetching and installing apache mods'
sudo apt-get install openjdk-6-jdk
echo 'Done'

# Doing stuff with Tomcat
echo 'Doing stuff with Tomcat'
cd /usr/share
wget http://mirror.nyi.net/apache/tomcat/tomcat-6/v6.0.18/bin/apache-tomcat-6.0.18.tar.gz
tar zxvf apache-tomcat-6.0.18.tar.gz
mv apache-tomcat-6.0.18 tomcat-6.0.18
adduser tomcat && addgroup tomcat
cd tomcat-6.0.18
chown -R tomcat:tomcat webapps; chmod -R 775 webapps
usermod -aG tomcat www-data
cd bin && chmod 755 shutdown.sh startup.sh && cd ..

echo 'Done'

# Lets throw in Apache 
echo 'Throwing apache more in the mix'
cp ~/webbies-fireplace/grails-stack/sources/etc/apache2/workers.properties /etc/apache2
chown tomcat.tomcat /etc/apache2/workers.properties
cp ~/webbies-fireplace/grails-stack/sources/etc/apache2/sites-available/java_example /etc/apache2/sites-available
cp ~/webbies-fireplace/grails-stack/sources/usr/share/tomcat-6.0.18/conf/server.xml /usr/share/tomcat-6.0.18/conf/server.xml
echo "Include /usr/share/tomcat/conf/jk/mod_jk.conf-auto" >> /etc/apache2/apache2.conf

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

# Restarting tomcat and apache
echo 'Restarting tomcat and apache'
/etc.init.d/tomcat start
/etc/init.d/apache2 start
echo 'Done'

# Fetching and installing grails
echo 'Fetching and installing grails'
wget http://dist.codehaus.org/grails/grails-bin-1.0.4.tar.gz
mkdir /usr/lib/grails
cd /usr/lib/grails/
mv ~/grails-bin-1.0.4.tar.gz .
tar -zxvf grails-bin-1.0.4.tar.gz
echo 'Done'
