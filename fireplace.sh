#!/bin/bash

echo 'Copyright 2008-2009 @ Mario Danic <mario.danic@gmail.com>'
echo 'Ramaze stack is copyright 2008-2009 @ Pistos'
echo "Welcome to Webby's fireplace"
echo 'This tiny script is a wrapper around various'
echo 'provided server deployment scripts.'

user_input () {
echo 'Please select desired stack:'
echo '1)Ramaze stack'
echo '2)Gitosis stack'
echo '3)Trac stack'
echo '4)Grails stack'
echo '5)Mysql stack'
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
./build-trac-stack.sh
;;
4)
cd grails-stack
./build-grails-stack.sh
;;
5)
cd mysql-stack
./build-mysql-stack.sh
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

