#!/bin/bash
if   [[ $1 == "" ]];        then curl https://raw.githubusercontent.com/fish895623/Settings/main/arch/btrfs.sh  | bash;
elif [[ $1 == "chroot" ]];  then curl https://raw.githubusercontent.com/fish895623/Settings/main/arch/chroot.sh | bash;
fi