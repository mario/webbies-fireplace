#!/bin/bash


# We need to check if we have a project name argument

if [ $# -ne 2 ]; then
  echo $1 'Please supply project name and developer username as arguments'
  exit 2
else
  echo 'Args check OK'
fi

echo 'Path to your repository will be: /var/svn/repositories/${1}'
echo 'Please remember this as you will need to enter it when configuring trac'
sleep 5

PROJECT = $1
DEVELOPER = $2

# Update list of available packages

echo 'Fetching updated list of available packages'
sudo apt-get update
echo 'Done'

# Somebody missed essential packages

echo 'Fetching and installing essential log packages'
sudo apt-get install syslog-ng logrotate
echo 'Done'

# Install Subversion

echo 'Fetching and installing svn'
sudo apt-get install subversion
echo 'Done'

# Create svn layout

echo 'Creating svn layout'
sudo mkdir -p /var/svn/repositories
echo 'Done'

# Creating repo for initial project

echo 'Creating svn repo for initial project'
sudo svnadmin create /var/svn/repositories/$PROJECT
echo 'Done'

# Fetching and installing apache

echo 'Fetching and installing apache'
sudo apt-get install apache2
echo 'Done'

# Fetching and installing apache modules

echo 'Fetching and installing apache modules'
sudo apt-get install libapache2-mod-python
sudo apt-get install libapache2-svn
echo 'Done'

# Lets setup subversion config

echo 'Setting up subversion'
sudo cp sources/etc/apache2/conf.d/subversion.conf /etc/apache2/conf.d
echo 'Done'

# Reloading apache

echo 'Reloading apache'
sudo /etc/init.d/apache2 reload
echo 'Done'

# Setting up permissions on svn repos

echo 'Applying permissions on svn repo'
sudo chown -R www-data.www-data /var/svn/repositories
find /var/svn/repositories/ -type d|xargs chmod g+sw
echo 'Done'

# We will need python-setuptools

echo 'Fetching and installing python-setuptools'
sudo apt-get install python-setuptools
echo 'Done'

# Installing trac

echo 'Fetching and installing trac 0.11.1'
sudo easy_install http://svn.edgewall.org/repos/trac/tags/trac-0.11.1/
echo 'Done'

# Moving on to python-sqlite

echo 'Installing python-sqlite'
sudo apt-get install python-sqlite
echo 'Done'

# Now py bindings to svn

echo 'Installing python-subversion'
sudo apt-get install python-subversion
echo 'Done'

# Creating trac layout

echo 'Creating trac layout'
sudo mkdir -p /var/trac/projects
echo 'Done'

# Creating initial trac project

echo 'Creating trac project'
sudo trac-admin /var/trac/projects/$PROJECT initenv
echo 'Done'

# Setting up trac config

echo 'Setting up trac config'
sudo cp sources/etc/apache2/conf.d/trac.conf /etc/apache2/conf.d
echo 'Done'

# Reloading apache

echo 'Reloading apache'
sudo /etc/init.d/apache2 reload
echo 'Done'

# Setting up permissions on trac projects

echo 'Applying permissions on trac'
sudo chown -R www-data.www-data /var/trac
find /var/trac/ -type d|xargs chmod g+sw
echo 'Done'

# Lets install openssl just in case

echo 'Installing openssl'
sudo apt-get install openssl
echo 'Done'

# Lets create apache private key

echo 'Creating private apache ssl key'
cd /etc/ssl/private
sudo openssl genrsa -out apache-trac-fireplace.key 1024
echo 'Done'

# We need certificate

echo 'Creating a certificate'
cd /etc/ssl/certs
sudo openssl req -new -x509 -days 365 -key ../private/apache-trac-fireplace.key  -out apache-trac-fireplace.crt
echo 'Done'

# Lets make things secure

echo 'Securing key'
cd /etc/ssl/private
chmod 400 apache-trac-fireplace.key
echo 'Done'

# Enabling ssl module

echo 'Enabling ssl module'
sudo a2enmod ssl
echo 'Done'

# Setting conf file where it should be

echo 'Doing some stuff with ssl conf'
sudo cp ~/webbies-fireplace/trac-stack/sources/apache2/conf.d/ssl.conf /etc/apache2/conf.d
echo 'Done'

# Creating apache dirs we need

echo 'Creating some apache dirs'
sudo mkdir -p /var/apache/apache-trac-fireplace/html
echo 'Done'

# Reloading apache

echo 'Reloading apache'
sudo /etc/init.d/apache2 reload
echo 'Done'

# Creating initial user

echo 'Creating initial user'
htpasswd -cm /var/apache/apache-trac-fireplace/htpasswd $DEVELOPER
echo 'Done'

# Setting admin user for trac project

echo 'Setting admin user for trac project'
echo 'NOTE!'
echo 'Please input the following when asked for input:'
echo 'permission add {$DEVELOPER} TRAC_ADMIN'
echo 'Then click ctrl+c to exit the console'
sudo trac-admin /var/trac/projects/$PROJECT
echo 'Done'

echo '*************************************************************************'
echo
echo 'ALL DONE!'
echo 'You should now be able to do your trac stuff with your server '
echo 'at a git://your-webbys-ip/projects/{$PROJECT} addy'
echo 'Your subversion repo is available at:'
echo 'https://your-webbys-ip/svn/{PROJECT}'
echo
echo '*************************************************************************'

