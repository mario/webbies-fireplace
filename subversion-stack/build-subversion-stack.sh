#!/bin/bash

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

# Moving configuration files

echo 'Moving configuration files'
mv sources/var/svn/repositories/passwd /var/svn/repositories/$PROJECT/conf
mv sources/var/svn/repositories/svnserve.conf /var/svn/repositories/$PROJECT/conf
echo 'Done'

# Generate subversion user password

echo 'Generating password for user'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 5)
echo 'Done'

# Configuring user

echo 'Configuring user'
echo "$DEVELOPER = $PASS" >> /var/svn/repositories/$PROJECT/conf/passwd
echo 'Done'

# Configuring svnserve

echo 'Configuring snvserve'
echo "password-db = /var/svn/repositories/$PROJECT/conf/passwd" >> /var/svn/repositories/$PROJECT/conf/svnserve.conf
echo "Realm = $PROJECT" >> /var/svn/repositories/$PROJECT/conf/svnserve.conf
echo 'Done'

# Setting up cron

echo 'Setting up cron'
crontab sources/crontab
echo 'Done'

echo '*************************************************************************'
echo
echo 'ALL DONE!'
echo 'Your subversion repo is available at:'
echo 'svn://your-webbys-ip/'"$PROJECT"
echo 'Password for user '"$DEVELOPER"' at project '"$PROJECT"' is: '"$PASS"
echo
echo '*************************************************************************'

