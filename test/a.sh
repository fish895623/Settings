echo a
echo -n "Select root device (Must): ";              read -r DEV
echo -n "Select mount dir (default /mnt): ";        read -r MNT_DIR
echo "${DEV} ${MNT_DIR}"