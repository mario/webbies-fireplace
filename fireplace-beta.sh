#!/bin/bash

echo 'Copyright (C) 2008-2009  Mario Danic <mario.danic@gmail.com>'
echo 'Ramaze stack is copyright (c) 2008-2009 Pistos'
echo "Welcome to Webby's fireplace"
echo 'This tiny script is a wrapper around various'
echo 'provided server deployment scripts.'

echo 'This is beta!!'

PS3="Your choice: "

select stackname in "ramaze" "gitosis" "trac" "grails" "mysql" "postgresql" "lamp" "subversion" "quit"; do

   if [ "$stackname" = "quit" ]; then
	    exit 0
   elif [ "$stackname" = "trac" -o "$stackname" = "subversion" ]; then
	    echo 'Project name:'
		read $PROJECT
		echo 'Developer name:'
		read $DEVELOPER
		cd "$stackname"-stack
		./build-"$stackname"-stack $PROJECT $DEVELOPER
   elif [ "$stackname" = "ramaze" -o "$stackname" = "gitosis" \
         -o "$stackname" = "grails" -o "$stackname" = "mysql"  \
		 -o "$stackname" = "postgresql" -o "$stackname" = "lamp" ]; then
		cd "$stackname"-stack
		./build-"$stackname"-stack
   else 
		echo "Bad choice, going out for a walk!"
		exit 2
   fi
done
