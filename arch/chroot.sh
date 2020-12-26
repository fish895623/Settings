#!/bin/bash
echo "Enter your root passwd..."
passwd root &&

echo "Setup Locale..."
echo "en_US.UTF-8" >> /etc/locale.gen &&
locale-gen &&

echo "Setup Language..."
echo LANG=en_US.UTF-8 > /etc/locale.conf

echo "Setup hostname (default localhost)..."
read hostname &&
if [[ $hostname == '' ]]; then hostname="localhost"; fi

echo -n "Create New User..."
echo -n "New Username: "; read -r USER    &&
echo -n "Default shell: "; read -r SHELL  &&
if [[ $shell == ""  ]]; then SHELL="/bin/bash"; fi
useradd -m -g users -G wheel -s $SHELL $USER &&
passwd $USER &&

# Install Bootloader
echo "Install Bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot -bootloader-id=arch --recheck &&
grub-mkconfig -o /boot/grub/grub.cfg &&

echo "Enable NetworkManager"
systemctl enable NetworkManager.service

sed -i "s/curl https\:\/\/raw.githubusercontent.com\/fish895623\/Settings\/main\/arch\/install.sh | bash -s chroot//" /root/.bashrc