#!/bin/sh

echo 'Copyright (C) 2008-2009  Mario Danic <mario.danic@gmail.com>'
echo 'Ramaze stack is copyright (c) 2008-2009 Pistos'
echo "Welcome to Webby's fireplace"
echo 'This tiny script is a wrapper around various'
echo 'provided server deployment scripts.'

echo 'This is beta!!'

do_work ()
{
cd $1-stack
./build-$1-stack $2 $3
}

user input ()
{
PS3="Your choice: "

select stackname in "ramaze" "gitosis" "trac" "grails" "mysql" "postgresql" "lamp" "subversion" "quit"
  do
  [ $stackname = "quit" ]  && exit 0
  
done
}

if [ $# -ne 1 -a $# -ne 3 ]; then
  user_input
else
  do_work $1 $2 $3
fi