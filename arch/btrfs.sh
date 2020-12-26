#!/bin/bash
pacstrap_list="base linux linux-firmware vim networkmanager base-devel man-db man-pages sudo zsh grub efibootmgr"
echo -n "Select root device (Must): ";              read DEV        &&
echo -n "Select mount dir (default /mnt): ";        read MNT_DIR    &&
echo -n "Put DIR (you must exclude, swap var lib)"; read DIR        &&
echo -n "Put DIR with nocowdata ex) swap var";      read DIR_NOCOW  &&

if [[ ${MNT_DIR} == '' ]];    then MNT_DIR="/mnt";                          fi
if [[ ${DIR} == '' ]];        then DIR=".snapshots home opt root srv tmp";  fi
if [[ ${DIR_NOCOW} == '' ]];  then DIR_NOCOW="swap var";                    fi  &&

echo "Mount root dev..."
mount ${DEV} ${MNT_DIR} &&

echo "Make Subvolume..."
btrfs subvolume create ${MNT_DIR}/@   # root directory
for i in ${DIR} ${DIR_NOCOW}; do
    btrfs subvolume create ${MNT_DIR}/@${i}
done

echo "Unmount directory..."
umount -R ${MNT_DIR}  &&

# Mount Dir
echo "Mount root directory..."
mount -o noatime,compress=lzo,space_cache,subvol=@ ${DEV} ${MNT_DIR} &&

echo "Mount '"${DIR}"'..."
for i in ${DIR}; do
    mkdir -p ${MNT_DIR}/${i}
    mount -o noatime,compress=lzo,space_cache,subvol=@${i} ${DEV} ${MNT_DIR}/${i} &&
done

echo "Mount '"${DIR_NOCOW}"'..."
for i in ${DIR_NOCOW}; do
    mkdir -p ${MNT_DIR}/${i}
    mount -o nodatacow,subvol=@${i} ${DEV} ${MNT_DIR}/${i} &&
done

pacstrap ${MNT_DIR} $pacstrap_list &&
genfstab -U ${MNT_DIR} >> ${MNT_DIR}/etc/fstab

echo "curl https://raw.githubusercontent.com/fish895623/Settings/main/arch/install.sh | bash -s chroot" >> ${MNT_DIR}/root/.bashrc &&

arch-chroot ${MNT_DIR}
