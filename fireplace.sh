#!/bin/bash

echo 'Copyright (C) 2008-2009  Mario Danic <mario.danic@gmail.com>'
echo 'Ramaze stack is copyright (c) 2008-2009 Pistos'
echo "Welcome to Webby's fireplace"
echo 'This tiny script is a wrapper around various'
echo 'provided server deployment scripts.'


help () {
echo "First argument to this script is stack's number to install"
echo '1)Ramaze stack'
echo '2)Gitosis stack'
echo '3)Trac stack'
echo '4)Grails stack'
echo '5)Mysql stack'
echo '6)PostgreSQL stack'
}

user_input () {
echo 'Please select desired stack:'
echo '1)Ramaze stack'
echo '2)Gitosis stack'
echo '3)Trac stack'
echo '4)Grails stack'
echo '5)Mysql stack'
echo '6)PostgreSQL stack'
read stack
do_work $stack
}

do_work () {
case "$1" in
1)
cd ramaze-stack
./build-ramaze-stack.sh
;;
2)
cd gitosis-stack
./build-gitosis-stack.sh
;;
3)
cd trac-stack
./build-trac-stack.sh $2 $3
;;
4)
cd grails-stack
./build-grails-stack.sh
;;
5)
cd mysql-stack
./build-mysql-stack.sh
;;
6)
cd postgresql-stack
./build-postgresql-stack.sh
;;
*)
echo 'Wrong selection'
exit 2
;;
esac
}

if [ $# -ne 1 ]; then
  user_input
else
  do_work $1
fi

