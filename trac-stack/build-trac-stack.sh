#!/bin/sh

# We need to check if we have a project name and developer as arguments

if [ $# -ne 2 ]; then
  echo $1 'Please supply project name and developer username as arguments'
  exit 2
else
  echo 'Args check OK'
fi


PROJECT=$1
DEVELOPER=$2
SVNPATH='/var/svn/repositories/'"$PROJECT"

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

# Install Subversion

echo 'Fetching and installing svn'
apt-get install subversion -y
echo 'Done'

# Create svn layout

echo 'Creating svn layout'
mkdir -p /var/svn/repositories
echo 'Done'

# Creating repo for initial project

echo 'Creating svn repo for initial project'
svnadmin create /var/svn/repositories/$PROJECT
echo 'Done'

# Fetching and installing apache

echo 'Fetching and installing apache'
apt-get install apache2 -y
echo 'Done'

# Setting up ufw for apache

echo 'Creating firewall rule for apache2'
ufw allow "Apache Full"
echo 'Done'

# We don't like apache errors
echo 'Doing some magic to remove apache warnings'
echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn
echo 'Done'

# Fetching and installing apache modules

echo 'Fetching and installing apache modules'
apt-get install libapache2-mod-python -y
apt-get install libapache2-svn -y
echo 'Done'

# Lets setup subversion config

echo 'Setting up subversion'
cp sources/etc/apache2/conf.d/subversion.conf /etc/apache2/conf.d
echo 'Done'

# Reloading apache

echo 'Reloading apache'
/etc/init.d/apache2 reload
echo 'Done'

# Setting up permissions on svn repos

echo 'Applying permissions on svn repo'
chown -R www-data.www-data /var/svn/repositories
find /var/svn/repositories/ -type d|xargs chmod g+sw
echo 'Done'

# We will need python-setuptools

echo 'Fetching and installing python-setuptools'
apt-get install python-setuptools -y
echo 'Done'

# Installing trac

echo 'Fetching and installing trac 0.11.1'
easy_install http://svn.edgewall.org/repos/trac/tags/trac-0.11.1/
echo 'Done'

# Moving on to python-sqlite

echo 'Installing python-sqlite'
apt-get install python-sqlite -y
echo 'Done'

# Now py bindings to svn

echo 'Installing python-subversion'
apt-get install python-subversion -y
echo 'Done'

# Creating trac layout

echo 'Creating trac layout'
mkdir -p /var/trac/projects
echo 'Done'

# Creating initial trac project

echo 'Creating trac project'
trac-admin /var/trac/projects/"$PROJECT" initenv $PROJECT sqlite:db/trac.db svn $SVNPATH

echo 'Done'

# Setting up trac config

echo 'Setting up trac config'
cp sources/etc/apache2/conf.d/trac.conf /etc/apache2/conf.d
echo 'Done'

# Reloading apache

echo 'Reloading apache'
/etc/init.d/apache2 reload
echo 'Done'

# Setting up permissions on trac projects

echo 'Applying permissions on trac'
chown -R www-data.www-data /var/trac
find /var/trac/ -type d|xargs chmod g+sw
echo 'Done'

# Lets install openssl just in case

echo 'Installing openssl'
apt-get install openssl -y
echo 'Done'

# Lets create apache private key

echo 'Creating private apache ssl key'
cd /etc/ssl/private
openssl genrsa -out apache-trac-fireplace.key 1024
echo 'Done'

# We need certificate

echo 'Creating a certificate'
cd /etc/ssl/certs
openssl req -batch -new -x509 -days 365 -key ../private/apache-trac-fireplace.key  -out apache-trac-fireplace.crt
echo 'Done'

# Lets make things secure

echo 'Securing key'
cd /etc/ssl/private
chmod 400 apache-trac-fireplace.key
echo 'Done'

# Enabling ssl module

echo 'Enabling ssl module'
a2enmod ssl
echo 'Done'

# Setting conf file where it should be

echo 'Doing some stuff with ssl conf'
cp ~/webbies-fireplace/trac-stack/sources/etc/apache2/conf.d/ssl.conf /etc/apache2/conf.d
echo 'Done'

# Creating apache dirs we need

echo 'Creating some apache dirs'
mkdir -p /var/apache/apache-trac-fireplace/html
echo 'Done'

# Reloading apache

echo 'Reloading apache'
/etc/init.d/apache2 reload
echo 'Done'


# Generate trac user password

echo 'Generating password for user'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 8)
echo 'Done'

# Creating initial user

echo 'Creating initial user'
htpasswd -bcm /var/apache/apache-trac-fireplace/htpasswd $DEVELOPER $PASS
echo 'Done'

# Setting admin user for trac project

echo 'Setting admin user for trac project '"$PROJECT"
trac-admin /var/trac/projects/$PROJECT permission add $DEVELOPER TRAC_ADMIN
echo 'Done'


echo '*************************************************************************'
echo
echo 'ALL DONE!'
echo 'You should now be able to do your trac stuff at: '
echo 'https://your-webbys-ip/projects/'"$PROJECT"
echo 'Your subversion repo is available at:'
echo 'https://your-webbys-ip/svn/'"$PROJECT"
echo 'Password for user '"$DEVELOPER"' at project '"$PROJECT"' is: '"$PASS"
echo
echo '*************************************************************************'

