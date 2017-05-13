#!/bin/bash

# global variables
INFO_MESSAGE="[INFO] server-setup: "
SUCCESS_MESSAGE="[SUCCESS] server-setup: "

TEMP_DIR="/home/server-setup-temp"

CONFIG_REPO_NAME="odroid-server-config"
CONFIG_REPO_URL="https://github.com/AlexBondor/odroid-server-config.git"
GIT_EMAIL="alexandru.viorel.bondor@gmail.com"
GIT_NAME="Alex Bondor"

# configure network
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

# update repos
infoMessage "Update reposs.."
apt-get update
successMessage "Repos updated"

# enable ssh

# install git
infoMessage "Installing git.."
apt-get install --yes git
successMessage "Git installed"

infoMessage "Configuring git.."
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
successMessage "Git configured"


# create temp directory
infoMessage "Create temp directory " $TEMP_DIR ".."
mkdir $TEMP_DIR
cd $TEMP_DIR
successMessage "Temp directory created and moved into"

# clone config repository
infoMessage "Cloning config repo from " $CONFIG_REPO_URL
git clone $CONFIG_REPO_URL
successMessage "Config repo successfully cloned"

# install mysql

# install nginx

# install teamcity

# install youtrack

infoMessage() {
    echo $INFO_MESSAGE $1
}

successMessage() {
    echo $SUCCESS_MESSAGE $1
}