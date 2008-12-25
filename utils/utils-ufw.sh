#!/bin/sh
# utils-ufw.sh: Installing and configuring ufw with its rules.

ufw_install_configure () {

# Install ufw 

echo 'Installing ufw'
apt-get -y install ufw 
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


}

ufw_openssh () {

# Setting up ufw for openSSH

echo 'Creating firewall rule for OpenSSH'

if [ $1 = 1 ]; then
  ufw deny OpenSSH
else
  ufw allow OpenSSH
fi

echo 'Done'

}

ufw_apache_full () {

# Setting up ufw for Apache full - 80/443
# Hint: You'll want ssl cert :)

echo "Creating firewall rule for Apache Full"

if [ $1 = 1 ]; then
  ufw deny "Apache Full"
else
  ufw allow "Apache Full"
fi

echo 'Done'

}

ufw_apache () {

# Setting up ufw for Apache full - 80

echo "Creating firewall rule for Apache"

if [ $1 = 1 ]; then
  ufw deny Apache
else
  ufw allow Apache
fi

echo 'Done'

}

ufw_apache_ssl () {

# Setting up ufw for Apache full - 443
# Hint: You'll want ssl cert :)

echo "Creating firewall rule for Apache Secure"

if [ $1 = 1 ]; then
  ufw deny "Apache Secure"
else
  ufw allow "Apache Secure"
fi

echo 'Done'

}

ufw_tcp () {

# Creating custom firewall tcp rule
# Argument $1 is port, Argument $2 is what to do

echo "Creating custom firewall rule"

if [ $2 = 1 ]; then
  ufw deny "$1/tcp"
else
  ufw allow "$1/tcp"
fi

echo 'Done'

}
