#!/bin/bash
DEV="/dev/sda2"
MNT_DIR="/mnt"
DIR=".snapshots home opt root srv tmp"
NOCOWDATA="swap var"
pacstrap_list="base linux linux-firmware vim networkmanager base-devel man-db man-pages sudo zsh"
localtime="Asia/Seoul"
hostname="localhost"

mount ${DEV} ${MNT_DIR}

# Make Subvolume
echo ${DIR} ${NOCOWDATA}
btrfs subvolume create ${MNT_DIR}/@
for i in ${DIR} ${NOCOWDATA}
do
	btrfs subvolume create ${MNT_DIR}/@${i}
done
umount ${MNT_DIR}

# Mount Dir
echo Mount root directory...
mount -o noatime,compress=lzo,space_cache,subvol=@ ${DEV} ${MNT_DIR}

echo Mount '""${DIR}""'
for i in ${DIR}
do
	mkdir -p ${MNT_DIR}/${i}
	mount -o noatime,compress=lzo,space_cache,subvol=@${i} ${DEV} ${MNT_DIR}/${i}
done

echo Mount '""${NOCOWDATA}""'
for i in ${NOCOWDATA}
do
	mkdir -p ${MNT_DIR}/${i}
	mount -o nodatacow,subvol=@${i} ${DEV} ${MNT_DIR}/${i}
done

mkdir -p ${MNT_DIR}/boot
mount /dev/sda1 $MNT_DIR/boot

# Install System
pacstrap ${MNT_DIR} ${pacstrap_list}

# Create fstab file
genfstab -U ${MNT_DIR} >> ${MNT_DIR}/etc/fstab

# Language
echo LANG=en_US.UTF-8 > ${MNT_DIR}/etc/locale.conf

# Locale
echo en_US.UTF-8 > ${MNT_DIR}/etc/locale.gen

# Localetime
ln -sf ${MNT_DIR}/usr/share/zoneinfo/${localtime} ${MNT_DIR}/etc/localtime

# Hostname
echo ${hostname} > ${MNT_DIR}/etc/hostname

# sudoers
sed -i "s/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/" ${MNT_DIR}/etc/sudoers

echo After Finish Install Arch, run bellow

arch-chroot ${MNT_DIR}
