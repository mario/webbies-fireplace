#!/bin/bash
# utils-distro.sh: Detect distribution flavour.

# General distribution info file
DIST_INFO="/etc/lsb-release"

# Detect distribution 
detect_distro()
{
  if [ -f $DIST_INFO ]; then
    . $DIST_INFO
  elif [ -f /etc/arch-release ]; then
    DISTRIB_ID="Arch Linux"
  elif [ -f /etc/debian_version ]; then
    DISTRIB_ID="Debian GNU/Linux"
  elif [ -f /etc/fedora-release ]; then
    DISTRIB_ID="Fedora"
  elif [ -f /etc/gentoo-release ]; then
    DISTRIB_ID="Gentoo"
  elif [ -f /etc/knoppix-version ]; then
    DISTRIB_ID="Knoppix"
  elif [ -f /etc/lfs-version ]; then
    DISTRIB_ID="Linux from scratch"
  elif [ -f /etc/mandriva-release ] || [ -f /etc/mandrake-release ]; then
    DISTRIB_ID="Mandriva"
  elif [ -f /etc/redhat-release ]; then
    DISTRIB_ID="RedHat"
  elif [ -f /etc/slackware-version ]; then
    DISTRIB_ID="Slackware"
  elif [ -f /etc/release ]; then
    DISTRIB_ID="Solaris"
  elif [ -f /etc/SuSE-release ]; then
    DISTRIB_ID="(open)SuSE"
  elif [ -f /etc/yellowdog-release ]; then
    DISTRIB_ID="YellowDog Linux"
  elif [ -f /etc/zenwalk-version  ]; then
    DISTRIB_ID="Zenwalk"
  else
    DISTRIB_ID="Unknown"
    DISTRIB_RELEASE="(no suitable info file found)"
  fi
}