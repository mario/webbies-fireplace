#!/bin/bash
# utils-db.sh: Databases.

# Import misc utils 
source ../utils/utils-misc.sh

db_mysql_install_configure () {

# Lets install mysql-server in silent mode
echo 'Mysql server installation'
DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
echo 'Done'
 
# Generate mysql password
echo 'Generating mysql root pass'
misc_genpass
echo 'Done'

# creating socket link

ln -s /var/run/mysqld/mysqld.sock /tmp/mysqld.sock

# Setting up root pass for mysql
echo 'Setting up root mysql pass'
mysqladmin -u root password $PASS
echo 'Done'

}

db_postgresql_install_configure () {

# Installing postgresql
echo 'Installing PostgreSQL'
sudo apt-get -y install postgresql 
echo 'Done'
 
# Generate postgresql password
echo 'Generating postgresql user pass'
misc_genpass
echo 'Done'
 
# Setting up postgres user pass
echo 'Setting up postgres user pass'
sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD $PASS;"
echo 'Done'

}