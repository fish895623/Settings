#!/bin/bash
pacstrap_list="base linux linux-firmware vim networkmanager base-devel man-db man-pages sudo zsh grub efibootmgr"
echo -n "Select root device (Must): "; read -r DEV
echo -n "Select mount dir (default /mnt): "; read -r MNT_DIR
echo -n "Put DIR (you must exclude, swap var lib)"; read -r DIR
echo -n "Put DIR with nocowdata ex) swap var"; read -r DIR_NOCOW
if [[ $1 == '' ]]; then
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
    genfstab -U $MNT_DIR >> $MNT_DIR/etc/fstab

    echo "curl https://raw.githubusercontent.com/fish895623/Settings/main/arch/new.sh | bash -s archroot" >> $MNT_DIR/root/.bashrc

    arch-chroot $MNT_DIR

elif [[ $1 == "archroot" ]]; then
    echo -n "Enter your root passwd..."
    passwd root

    echo -n "Setup Locale..."
    echo "en_US.UTF-8" >> /etc/locale.gen
    locale-gen

    echo -n "Setup Language..."
    echo LANG=en_US.UTF-8 > /etc/locale.conf

    echo -n "Setup hostname (default localhost)..."
    read hostname
    if [[ $hostname == '' ]]; then hostname="localhost"; fi

    echo -n "Create New User..."
    echo -n "New Username: "; read -r USER
    echo -n "Default shell: "; read -r SHELL
    if [[ $shell == ""  ]]; then SHELL="/bin/bash"; fi
    useradd -m -g users -G wheel -s $SHELL $USER
    passwd $USER

    # Install Bootloader
    echo -n "Install Bootloader"
    grub-install --target=x86_64-efi --efi-directory=/boot -bootloader-id=arch --recheck
    grub-mkconfig -o /boot/grub/grub.cfg

    echo -n "Enable NetworkManager"
    systemctl enable NetworkManager.service

    sed -i "s/curl https\:\/\/raw.githubusercontent.com\/fish895623\/Settings\/main\/arch\/new.sh | bash -s archroot//" /root/.bashrc
fi