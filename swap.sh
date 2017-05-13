swapoff /var/swap
rm /var/swap
touch /var/swap
dd if=/dev/zero of=/var/swap bs=1024 count=1048576
mkswap -f /var/swap
swapon /var/swap
