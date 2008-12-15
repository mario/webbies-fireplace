#!/bin/bash
# utils-cecho.sh: Echoing text messages in color.

# Modify this script for your own purposes.
# It's easier than hand-coding color.

# Fetched from http://www.faqs.org/docs/abs/HTML/colorizing.html

black='\E[30;47m'
red='\E[31;47m'
green='\E[32;47m'
yellow='\E[33;47m'
blue='\E[34;47m'
magenta='\E[35;47m'
cyan='\E[36;47m'
white='\E[37;47m'

alias Reset="tput sgr0"      #  Reset text attributes to normal
							 #+ without clearing screen.

cecho ()                     # Color-echo.
                             # Argument $1 = message
                             # Argument $2 = color
{
local default_msg="No message passed."
                              # Doesn't really need to be a local variable.
 
message=${1:-$default_msg}   # Defaults to default message.
color=${2:-$black}           # Defaults to black, if not specified.
 
  echo -e "$color"
  echo "$message"
  Reset                      # Reset to normal.

  return
}  
