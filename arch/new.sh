#!/bin/bash
pacstrap_list="base linux linux-firmware vim networkmanager base-devel man-db man-pages sudo zsh grub efibootmgr"
echo -n "Select root device (Must): "; read -r DEV
echo -n "Select mount dir (default /mnt): "; read -r MNT_DIR
echo -n "Put DIR (you must exclude, swap var lib)"; read -r DIR
echo -n "Put DIR with nocowdata ex) swap var"; read -r DIR_NOCOW
if [[ $MNT_DIR == '' ]]; then 
    MNT_DIR="/mnt"
fi
echo "$MNT_DIR"
if [[ $DIR == '' ]]; then
    DIR=".snapshots home opt root srv tmp"
fi
if [[ $DIR_NOCOW == '' ]]; then
    DIR_NOCOW="swap var"
fi

echo -n "Mount root dev..."
mount "$DEV" "$MNT_DIR"

echo -n "Make Subvolume..."
btrfs subvolume create $MNT_DIR/@   # root directory
for i in $DIR $DIR_NOCOW; do
    btrfs subvolume create $MNT_DIR/@"$i"
done

echo -n "Unmount directory..."
umount -R $MNT_DIR

# Mount Dir
echo -n "Mount root directory..."
mount -o noatime,compress=lzo,space_cache,subvol=@ $DEV $MNT_DIR

echo -n "Mount '"$DIR"'..."
for i in $DIR; do
    mkdir -p $MNT_DIR/$i
    mount -o noatime,compress=lzo,space_cache,subvol=@$i $DEV $MNT_DIR/$i
done

echo -n "Mount '"$DIR_NOCOW"'..."
for i in $DIR_NOCOW; do
    mkdir -p $MNT_DIR/$i
    mount -o nodatacow,subvol=@$i $DEV $MNT_DIR/$i
done

pacstrap $MNT_DIR $pacstrap_list
