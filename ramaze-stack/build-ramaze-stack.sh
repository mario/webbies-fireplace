#!/bin/bash

# Update system config

#EMERGE_OPTIONS="-tv"
EMERGE_OPTIONS="-atv"
cat sources/etc/make.conf.appendum >> /etc/make.conf
cp sources/etc/portage/* /etc/portage
echo 'rm_opts=""' >> /etc/etc-update.conf
echo 'mv_opts=""' >> /etc/etc-update.conf
echo 'cp_opts=""' >> /etc/etc-update.conf

# Install major packages

emerge ${EMERGE_OPTIONS} "=app-shells/bash-3.2_p17-r1" portage

echo '-3' | etc-update

emerge ${EMERGE_OPTIONS} syslog-ng logrotate
emerge ${EMERGE_OPTIONS} ruby "=postgresql-8.3.1" nginx

emerge --config =postgresql-8.3.1

# Install Rubygems

wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar zxvf rubygems-1.3.1.tgz
cd rubygems-1.3.1
ruby setup.rb
ln -s /usr/bin/gem18 /usr/bin/gem

gem install --no-rdoc --no-ri ramaze mongrel thin pg m4dbi dbd-pg
