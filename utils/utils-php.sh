#!/bin/sh
# utils-php.sh: Installing, configuring and managing PHP.

# Install PHP

php_install () {
# Argument $1 is version, Argument $2 is what to do

echo 'Installing PHP'

case $1 in
  1)
    phpver=php4
    ;;
  2)
    phpver=php5
    ;;
  *)
    echo 'Not a version'
    exit
    ;;
esac

if [ $2 = 1 ]; then
  # remove php
  
  apt-get -y remove $phpver 
  
else
 # install php
 
 apt-get -y install $phpver
 
fi

echo 'Done'
}

php_module_install () {
# install/remove modules
# Argument $1 is version, Argument $2 is module, Argument $3 is what to do

case $1 in
  1)
    phpver=php4
    ;;
  2)
    phpver=php5
    ;;
  *)
    echo 'Not a version option'
    exit
    ;;
esac

case $2 in
  1)
    phpmod=$phpver-mysql
    ;;
  2)
    phpmod=$phpver-cgi
    ;;
  3)
    phpmod=$phpver-gd
    ;;
  *)
    echo 'Not a module'
    exit
    ;;
esac

echo 'Install/Remove PHP modules'

if [ $3 = 1 ]
  # remove module
  
  apt-get -y remove $phpmod
  
else
  # install module
  
  apt-get -y install $phpmod
  
fi

echo 'Done'

}

php_enable () {
# enable/diable php
# Argument $1 is version, Argument $2 is what to do

case $1 in
  1)
    phpver=php4
    ;;
  2)
    phpver=php5
    ;;
  *)
    echo 'Not a version'
    exit
    ;;
esac

echo 'Enable/Disable PHP'

if [ $2 = 1 ]
  # disable php
  
  a2dismod $phpver
  
else
  # enable php
  
  a2enmod $phpver
  
fi

echo 'Done'

}