#!/bin/bash

echo '***********************************************************'
echo
echo 'IMPORTANT'
echo 'Before we begin, please create a ssh key pair locally, and '
echo 'upload the public key to /tmp under the name of: id_rsa.pub'
echo
echo '***********************************************************'
 
# Update list of available packages

echo 'Fetching updated list of available packages'
sudo apt-get update
echo 'Done'

# Somebody missed essential packages

echo 'Fetching and installing essential log packages'
sudo apt-get install syslog-ng logrotate
echo 'Done'

# Install git

echo 'Fetching and installing git'
sudo apt-get install git-core
echo 'Done'

# We will need python-setuptools

echo 'Fetching and installing python-setuptools'
sudo apt-get install python-setuptools
echo 'Done'

# Fetching and installing gitosis

echo 'Fetching and installing gitorious'
cd ~ && mkdir src && cd src
git clone git://eagain.net/gitosis.git
cd gitosis
python setup.py install
echo 'Done'

# Lets clean up after ourselves

echo 'Cleaning up...'
cd ../..
rm -r src
echo 'Done'

# Lets add a required git user

echo 'Adding required system user - git'
sudo adduser \
    --system \
    --shell /bin/sh \
    --gecos 'git version control' \
    --group \
    --disabled-password \
    --home /home/git \
    git
echo 'Done'
	
# Initialize gitosis by adding first (admin) user

echo 'Initializing gitosis by adding first (admin) user'
sudo -H -u git gitosis-init < /tmp/id_rsa.pub
echo 'Done'

# Minor performance trick

echo 'Applying minor performance trick'
sudo chmod 755 /home/git/repositories/gitosis-admin.git/hooks/post-update
echo 'Done'

# Start a git daemon for serving repositories anonymously

echo 'Starting git daemon'
sudo -u git git-daemon --base-path=/home/git/repositories/ --export-all
echo 'Done'

# Init script creation

echo 'Setting up git daemon init script'
sudo cp webbies-fireplace/gitosis-stack/sources/etc/init.d/git-daemon /etc/init.d
sudo chmod +x /etc/init.d/git-daemon
sudo invoke-rc.d git-daemon start
echo 'Done'

echo '*************************************************************************'
echo
echo 'ALL DONE!'
echo 'You should now be able to do your git stuff with your server '
echo 'at a git://your-webbys-ip/your_repo.git addy'
echo 'Please read:'
echo 'scie.nti.st/2007/11/14/hosting-git-repositories-the-easy-and-secure-way'
echo
echo '*************************************************************************'
