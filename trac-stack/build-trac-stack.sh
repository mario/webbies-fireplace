#!/bin/bash


# We need to check if we have a project name argument

if [ "${1}" ]; then
 echo 'args is:' "${1}"
else
 echo $1 'Please supply project name as argument'
 exit 2
fi

echo 'Path to your repository will be: /var/svn/repositories/' "${1}"
echo 'Please remember this as you will need to enter it when configuring trac'
sleep 5

PROJECT = $1

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
sudo cp sources/etc/apache/conf.d/subversion.conf /etc/apache/conf.d
echo 'Done'

# Reloading apache

sudo /etc/init.d/apache reload

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

echo 'Installing python-subversionc
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
