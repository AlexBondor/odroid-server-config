#!/bin/bash

# global variables
INFO_MESSAGE="[INFO] server-setup: "
SUCCESS_MESSAGE="[SUCCESS] server-setup: "

TEMP_DIR="/home/server-setup-temp"

CONFIG_REPO_NAME="odroid-server-config"
CONFIG_REPO_URL="https://github.com/AlexBondor/odroid-server-config.git"

# configure network
NAME=eth0
IP=192.168.1.200
MASK=255.255.255.0
GATEWAY=192.168.1.1
DNS=8.8.8.8

ifconfig $NAME down;
ifconfig $NAME $IP $MASK;
ifconfig $NAME up
route add default gw $GATEWAY;
echo nameserver $DNS > /etc/resolv.conf; 

# create temp directory
mkdir $TEMP_DIR
cd $TEMP_DIR

# update repos
apt-get update

# enable ssh

# install git
echo $INFO_MESSAGE "Installing git.."
apt-get install --yes git
echo $SUCCESS_MESSAGE "git installed"

# clone config repository
git clone $CONFIG_REPO_URL

# install mysql

# install nginx

# install teamcity

# install youtrack