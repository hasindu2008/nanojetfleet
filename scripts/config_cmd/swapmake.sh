dd if=/dev/zero of=/swapfile bs=1024 count=2097152
mkswap /swapfile
swapon /swapfile
chmod 600 /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

