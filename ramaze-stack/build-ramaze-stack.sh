#!/bin/bash

# Update system config

EMERGE_OPTIONS="-tv"
#EMERGE_OPTIONS="-atv"
cat sources/etc/make.conf.appendum >> /etc/make.conf
cp sources/etc/portage/* /etc/portage
echo 'rm_opts=""' >> /etc/etc-update.conf
echo 'mv_opts=""' >> /etc/etc-update.conf
echo 'cp_opts=""' >> /etc/etc-update.conf

# Install major packages

emerge ${EMERGE_OPTIONS} "=app-shells/bash-3.2_p17-r1" portage

echo '-3' | etc-update

emerge ${EMERGE_OPTIONS} syslog-ng logrotate
emerge ${EMERGE_OPTIONS} ruby "=postgresql-8.3.1" nginx screen

emerge --config =postgresql-8.3.1
rc-update add postgresql default

# Install Rubygems

wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar zxvf rubygems-1.3.1.tgz
cd rubygems-1.3.1
/usr/bin/ruby setup.rb
cd ..
ln -s /usr/bin/gem18 /usr/bin/gem

/usr/bin/gem install --no-rdoc --no-ri ramaze mongrel thin pg m4dbi dbd-pg

# User

useradd -m ramaze

# Install Hello World

cp -r sources/home/ramaze/hello /home/ramaze
chown -R ramaze:ramaze /home/ramaze/hello/

# Nginx

sed -r '/^\s+server \{/ r sources/etc/nginx/nginx.conf.appendum' < /etc/nginx/nginx.conf > new.nginx.conf
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
mv new.nginx.conf /etc/nginx/nginx.conf

/etc/init.d/nginx start
rc-update add nginx default

# Hello World

su ramaze -c 'cd /home/ramaze/hello && /usr/bin/screen -d -m /usr/bin/ruby start.rb'

echo '*****************************************************'
echo
echo 'ALL DONE!'
echo 'Browse to http://your-webbys-ip to see a hello world app.'
echo
echo '*****************************************************'
