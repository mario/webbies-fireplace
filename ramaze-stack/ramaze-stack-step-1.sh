#!/bin/bash

#EMERGE_OPTIONS="-tv"
EMERGE_OPTIONS="-atv"

cat sources/etc/make.conf.appendum >> /etc/make.conf
cp sources/etc/portage/* /etc/portage

emerge ${EMERGE_OPTIONS} "=app-shells/bash-3.2_p17-r1" portage

echo 'rm_opts=""' >> /etc/etc-update.conf
echo 'mv_opts=""' >> /etc/etc-update.conf
echo 'cp_opts=""' >> /etc/etc-update.conf

emerge ${EMERGE_OPTIONS} syslog-ng logrotate
emerge ${EMERGE_OPTIONS} ruby postgresql nginx

