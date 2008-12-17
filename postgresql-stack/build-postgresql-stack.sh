#!/bin/bash

# Update list of available packages

echo 'Fetching updated list of available packages'
apt-get update
echo 'Done'

# Somebody missed essential packages

echo 'Fetching and installing essential log packages'
apt-get install syslog-ng logrotate -y
echo 'Done'

# Installing postgresql
echo 'Installing PostgreSQL'
sudo apt-get install postgresql -y
echo 'Done'

# Generate postgresql password
echo 'Generating postgresql user pass'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 16)
echo 'Done'

# Setting up postgres user pass
echo 'Setting up postgres user pass'
sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD $PASS;"
echo 'Done'

echo '*****************************************************'
echo
echo 'ALL DONE!'
echo 'Your postgres user password is: '"$PASS"
echo
echo '*****************************************************'