#!/usr/bin/env bash
#
# Script Name: VoxGentoo1
# Author: Vox
# Dscrptn: The second VoxGentoo script, intended to be run after the first script has finished.

## Welcome
echo "                 ____            _ "
echo "__   _______  __/ ___| ___ _ __ | |_ ___   ___ "
echo "\ \ / / _ \ \/ / |  _ / _ \ '_ \| __/ _ \ / _ \ "
echo " \ V / (_) >  <| |_| |  __/ | | | || (_) | (_) | "
echo "  \_/ \___/_/\_\\____|\___|_| |_|\__\___/ \___/ "
echo
echo "#####################################################################"
echo "##  This script should only be run after VoxGentoo0 has completed  ##"
echo "##            and a bootable system has been achieved.             ##"
echo "#####################################################################"
echo
if [ "$(id -u)" = 0 ]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "                   This script MUST NOT be run as root!"
    echo "If you are running this as root, then you are using this script improperly!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit 1
fi
echo
