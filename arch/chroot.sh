#!/bin/bash
echo -n "Enter your root passwd..."
passwd root

echo -n "Setup Locale..."
sleep 1
echo "en_US.UTF-8" >> /etc/locale.gen
locale-gen

echo -n "Setup Language..."
sleep 1
echo LANG=en_US.UTF-8 > /etc/locale.conf

echo -n "Setup hostname (default localhost)..."
sleep 1
read hostname
if [[ $hostname == '' ]]; then hostname="localhost"; fi

echo -n "Create New User..."
sleep 1
echo -n "New Username: "; read -r USER
echo -n "Default shell: "; read -r SHELL
if [[ $shell == ""  ]]; then SHELL="/bin/bash"; fi
useradd -m -g users -G wheel -s $SHELL $USER
passwd $USER

# Install Bootloader
echo -n "Install Bootloader"
sleep 1
grub-install --target=x86_64-efi --efi-directory=/boot -bootloader-id=arch --recheck
grub-mkconfig -o /boot/grub/grub.cfg

echo -n "Enable NetworkManager"
sleep 1
systemctl enable NetworkManager.service

sed -i "s/curl https\:\/\/raw.githubusercontent.com\/fish895623\/Settings\/main\/arch\/install.sh | bash -s chroot//" /root/.bashrc