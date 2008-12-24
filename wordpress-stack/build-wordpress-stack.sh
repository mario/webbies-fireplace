#!/bin/sh
# build-wordpress-stack: Wordpress installer.

# Assumptions: This script assumes that you have a fresh linux install on your Webby.
#               If Apache, MySQL, or PHP have not been installed they will be.
#               Because this script creates a db and user MySQL cannot be preinstalled.
#               If MySQL is installed this script will exit.

if [ which mysqld ]
  # exit if MySQL is found
  echo 'MySQL is installed, Exiting'
  exit
fi

# Import utils { misc, apache, db, php } 
source utils-misc.sh
source utils-apache.sh
source utils-db.sh
source utils-php.sh

echo 'Done'