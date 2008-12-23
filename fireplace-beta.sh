#!/bin/sh

echo 'Copyright (C) 2008-2009  Mario Danic <mario.danic@gmail.com>'
echo 'Ramaze stack is copyright (c) 2008-2009 Pistos'
echo "Welcome to Webby's fireplace"
echo 'This tiny script is a wrapper around various'
echo 'provided server deployment scripts.'

echo 'This is beta!!'

PS3="Your choice: "

select stackname in "ramaze" "gitosis" "trac" "grails" "mysql" "postgresql" "lamp" "subversion" "quit"
  do
  [ "$stackname" = "quit" ]  && exit 0
  cd $stackname-stack
  ./build-$stackname-stack $2 $3
done