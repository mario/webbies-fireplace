#!/bin/sh
# utils-apache.sh: Installing, configuring and managing apache with its modules.


apache_manage () {

# Manage (restart/reload) apache

echo 'Managing apache'

if [ $1 = 1 ]
  /etc/init.d/apache2 restart
else
  /etc/init.d/apache2 reload
fi

echo 'Done'

}

apache_install_configure () {
# Hint: You'll need ufw :)

# Fetching and installing apache

echo 'Fetching and installing apache'
apt-get -y install apache2 
echo 'Done'

# We don't like apache errors

echo 'Doing some magic to remove apache warnings'
echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn
echo 'Done'

}

apache_module_install () {
# install/remove module
# Argument $1 is module, Argument $2 is what to do

echo 'Install/Remove apache modules'

case "${1}" in
  1)
    modname=libapache2-mod-auth-mysql
    ;;
  2)
    modname=libapache2-mod-php5
    ;;
  3)
    modname=libapache2-mod-jk
    ;;
  4)
    modname=libapache2-mod-python
    ;;
  5)
    modname=libapache2-svn
    ;;
  *)
    echo 'Not an option'
    exit
    ;;
esac

if [ $2 = 1 ]
  # removing module
  
  apt-get -y remove $modname
  
else
  # installing module
  
  apt-get -y install $modname 
  
fi

echo 'Done'

}

apache_module_enable () {
# enable/disable module
# Argument $1 is module, Argument $2 is what to do

echo 'Enable/Disable apache modules'

case "${1}" in
  1)
    modname=rewrite
    ;;
  2)
    modname=ssl
    ;;
  *)
    echo 'Not an option'
    exit
    ;;
esac

if [ $2 = 1 ]
  # disable module

  a2dismod $modname

else
  # enable module
  
  a2enmod $modname

fi

echo 'Done'

}

apache_site_enable () {
# enable/disable site
# Argument $1 is site, Argument $2 is what to do

echo 'Enable/Disable site'

if [ $2 = 1 ]
  # disable site

  a2dissite $1

else
  # enable site
  
  a2ensite $1

fi

echo 'Done'

}