#!/bin/sh
# utils-db.sh: Databases.

# Import misc utils 
source utils-misc.sh

db_install_mysql () {

# Lets install mysql-server in silent mode
echo 'Mysql server installation'
DEBIAN_FRONTEND=noninteractive apt-get install mysql-server -y
echo 'Done'
 
# Generate mysql password
echo 'Generating mysql root pass'
misc_genpass
echo 'Done'
 
# Setting up root pass for mysql
echo 'Setting up root mysql pass'
mysqladmin -u root password $PASS
echo 'Done'

}

db_install_postgresql () {

# Installing postgresql
echo 'Installing PostgreSQL'
sudo apt-get install postgresql -y
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