#!/bin/bash

echo 'Copyright 2008 @ Mario Danic <mario.danic@gmail.com>'
echo 'Ramaze stack is copyright 2008 @ Pistos'
echo "Welcome to Webby's fireplace"
echo 'This tiny script is a wrapper around various'
echo 'provided server deployment scripts.'

if [ $# -ne 1 ]; then
  user_input
else
  do_work $1
fi

function user_input (
echo 'Please select desired stack:'
echo '1)Ramaze stack'
echo '2)Gitosis stack'
echo '3)Trac stack'
echo '4)Grails stack'
read stack
do_work $stack
)

function do_work (
case "$1" in
1)
cd ramaze-stack
./build-ramaze-stack.sh
;;
2)
./build-gitosis-stack.sh
;;
3)
./build-trac-stack.sh
;;
4)
./build-grails-stack.sh
;;
*)
echo 'Wrong selection'
exit 2
;;
esac
)