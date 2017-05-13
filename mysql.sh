#BOOT_INI_PATH="/media/boot/boot.ini.default"
#echo "" >> $BOOT_INI_PATH
#echo "# Custom mesontimer value" >> $BOOT_INI_PATH
#echo "mesontimer=0" >> $BOOT_INI_PATH
#echo "" >> $BOOT_INI_PATH

#bootini

#debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password password root"
#debconf-set-selections <<< "mysql-server-5.7 mysql-server/root_password_again password root"
apt-get install mysql-server-5.7
