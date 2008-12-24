#!/bin/sh
# utils-sslcert.sh: Various useful utilities.

misc_genpass () {
# only argument is number of chars password should have
# please use 16 for DB stuff and 5 for more regular things
if [ $1 = ""]; then 
  $1 = 16
fi
    
echo 'Generating a password'
PASS=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c $1)
echo 'Done'

}