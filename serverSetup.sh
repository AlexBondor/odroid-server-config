#!/bin/bash

##
# Global variables
##
INFO_MESSAGE="[INFO] server-setup: "
SUCCESS_MESSAGE="[SUCCESS] server-setup: "

TEMP_DIR="/home/odroid/server-setup-temp"

CONFIG_REPO_NAME="odroid-server-config"
CONFIG_REPO_URL="https://github.com/AlexBondor/odroid-server-config.git"
GIT_EMAIL="alexandru.viorel.bondor@gmail.com"
GIT_NAME="Alex Bondor"

BOOT_INI_PATH="/media/boot/boot.ini.default"

##
# Increase swap memory
##
infoMessage "Increasing swap memory.."
swapoff /var/swap
rm /var/swap
touch /var/swap
infoMessage "Formatting swap drive"
dd if=/dev/zero of=/var/swap bs=1024 count=1048576
mkswap -f /var/swap
swapon /var/swap
successMessage "Increased swap memory"

##
# Configure network
##
NAME="eth0"
IP="192.168.1.200"
MASK="255.255.255.0"
GATEWAY="192.168.1.1"
DNS="8.8.8.8"

infoMessage "Configuring network.. "
infoMessage "Interface name: " $NAME
infoMessage "IP: " $IP
infoMessage "Mask: " $MASK
infoMessage "Gateway: " $GATEWAY
infoMessage "DNS: " $DNS
ifconfig $NAME down;
ifconfig $NAME $IP netmask $MASK;
ifconfig $NAME up
route add default gw $GATEWAY;
echo nameserver $DNS > /etc/resolv.conf; 
successMessage "Network configured"

##
# Update repos
##
infoMessage "Update reposs.."
apt-get update
successMessage "Repos updated"

##
# Install git
##
#infoMessage "Installing git.."
#apt-get install --yes git
#successMessage "Git installed"

infoMessage "Configuring git.."
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
successMessage "Git configured"

##
# Create temp directory
##
infoMessage "Create temp directory " $TEMP_DIR ".."
mkdir $TEMP_DIR
cd $TEMP_DIR
successMessage "Temp directory created and moved into"

##
# Clone config repository
##
infoMessage "Cloning config repo from " $CONFIG_REPO_URL
git clone $CONFIG_REPO_URL
successMessage "Config repo cloned"

##
# Install mysql
##
# change mesontimer value from "1" to "0"
# this is some bug that makes mysql instalation fail
#infoMessage "Setting up mesontimer in boot.ini"
#echo "" >> $BOOT_INI_PATH
#echo "# Custom mesontimer value" >> $BOOT_INI_PATH
#echo "mesontimer=0" >> $BOOT_INI_PATH
#echo "" >> $BOOT_INI_PATH
#bootini
#successMessage "Set up mesontimer"

infoMessage "Installing mysql.."
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password root"
debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password root"
apt-get install --yes mysql-server-5.5
successMessage "Mysql installed"

##
# Install nginx
##

##
# Install teamcity
##

##
# Install youtrack
##

##
# Utility methods
##
infoMessage() {
    echo $INFO_MESSAGE $1
}

successMessage() {
    echo $SUCCESS_MESSAGE $1
}