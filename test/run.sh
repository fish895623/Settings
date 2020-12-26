#!/bin/sh
if   [[ $1 == "" ]];        then bash a.sh;
elif [[ $1 == "chroot" ]];  then bash chroot.sh;
fi
