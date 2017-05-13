#!/bin/bash

##
# Utility methods
##
NC="\033[0m"
INFO_COLOR="\033[0;33m"
SUCCESS_COLOR="\033[0;32m"
INFO_MESSAGE="[INFO] server-setup: "
SUCCESS_MESSAGE="[SUCCESS] server-setup: "

infoMessage() {
    echo -e $INFO_COLOR$INFO_MESSAGE$NC $1
}

successMessage() {
    echo -e $SUCCESS_COLOR$SUCCESS_MESSAGE$NC $1
}

infoMessage "info"
successMessage "success"

##
# Global variables
##
TEMP_DIR="/home/odroid/server-setup-temp"

CONFIG_REPO_NAME="odroid-server-config"
CONFIG_REPO_URL="https://github.com/AlexBondor/odroid-server-config.git"
GIT_EMAIL="alexandru.viorel.bondor@gmail.com"
GIT_NAME="Alex Bondor"

BOOT_INI_PATH="/media/boot/boot.ini.default"

TEAMCITY_DOWNLOAD_URL="https://download.jetbrains.com/teamcity/TeamCity-2017.1.1.tar.gz"
YOUTRACK_DOWNLOAD_URL="https://download.jetbrains.com/charisma/youtrack-2017.2.33063.zip"

TOOLS_DIR="/home/odroid/Tools/"
TEAMCITY_DIR=$TOOLS_DIR"TeamCity"
YOUTRACK_DIR=$TOOLS_DIR"YouTrack"

##
# Server setup files
##
SERVER_SETUP_DIR="/server-setup-files/"
SWAP=$SERVER_SETUP_DIR"swap"
NETWORK=$SERVER_SETUP_DIR"newtwork"
UPDATE=$SERVER_SETUP_DIR"update"
GIT=$SERVER_SETUP_DIR"git"
TEMP=$SERVER_SETUP_DIR"temp"
CLONE=$SERVER_SETUP_DIR"clone"
MYSQL=$SERVER_SETUP_DIR"mysql"
UFW=$SERVER_SETUP_DIR"ufw"
NGINX=$SERVER_SETUP_DIR"nginx"
JAVA=$SERVER_SETUP_DIR"java"
TEAMCITY=$SERVER_SETUP_DIR"teamcity"
YOUTRACK=$SERVER_SETUP_DIR"youtrack"
if [ -d $SERVER_SETUP_DIR ]; then
    infoMessage "Clearing server setup filed dir: "$SERVER_SETUP_DIR
else
    infoMessage $SERVER_SETUP_DIR" not found"
    mkdir $SERVER_SETUP_DIR
    successMessage $SERVER_SETUP_DIR" created"
fi

##
# Increase swap memory
##
if [ ! -f $SWAP ]; then
    infoMessage "Increasing swap memory.."
    swapoff /var/swap
    rm /var/swap
    touch /var/swap
    infoMessage "Formatting swap drive"
    dd if=/dev/zero of=/var/swap bs=1024 count=1048576
    mkswap -f /var/swap
    swapon /var/swap
    successMessage "Increased swap memory"

    touch $SWAP
fi

##
# Configure network
##
if [ ! -f $NETWORK ]; then
    NAME="eth0"
    IP="192.168.1.200"
    MASK="255.255.255.0"
    GATEWAY="192.168.1.1"
    DNS="8.8.8.8"

    infoMessage "Configuring network.. "
    infoMessage "Interface name: "$NAME
    infoMessage "IP: "$IP
    infoMessage "Mask: "$MASK
    infoMessage "Gateway: "$GATEWAY
    infoMessage "DNS: "$DNS
    ifconfig $NAME down;
    ifconfig $NAME $IP netmask $MASK;
    ifconfig $NAME up
    route add default gw $GATEWAY;
    echo nameserver $DNS > /etc/resolv.conf; 
    successMessage "Network configured"

    touch $NETWORK
fi

##
# Update repos
##
if [ ! -f $UPDATE ]; then
    infoMessage "Update reposs.."
    apt-get update --yes
    apt-get upgrade --yes
    successMessage "Repos updated"

    touch $UPDATE
fi

##
# Install git
##
if [ ! -f $GIT ]; then
    #infoMessage "Installing git.."
    #apt-get install --yes git
    #successMessage "Git installed"

    infoMessage "Configuring git.."
    git config --global user.email $GIT_EMAIL
    git config --global user.name $GIT_NAME
    successMessage "Git configured"

    touch $GIT
fi

##
# Create temp directory
##
if [ ! -f $TEMP ]; then
    infoMessage "Create temp directory "$TEMP_DIR".."
    mkdir $TEMP_DIR
    cd $TEMP_DIR
    successMessage "Temp directory created and moved into"

    touch $TEMP
fi

##
# Clone config repository
##
if [ ! -f $CLONE ]; then
    infoMessage "Cloning config repo from "$CONFIG_REPO_URL
    git clone $CONFIG_REPO_URL
    successMessage "Config repo cloned"

    touch $CLONE
fi

##
# Install mysql
##
if [ ! -f $MYSQL ]; then
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

    touch $MYSQL
fi

##
# Install ufw
##
if [ ! -f $UFW ]; then
    infoMessage "Installing ufw.."
    apt-get install --yes ufw
    successMessage "Ufw installed"
    infoMessage "Configuring ufw"
    ufw allow "OpenSSH"
    ufw allow "SSH"
    ufw allow "SMTP"
    ufw allow "DNS"
    successMessage "Ufw configured"

    touch $UFW
fi

##
# Install nginx
##
if [ ! -f $MYSQL ]; then
    infoMessage "Installing nginx.."
    apt-get install --yes nginx
    service nginx stop
    cd $TEMP_DIR
    cd $CONFIG_REPO_NAME
    rm /etc/nginx.conf
    cp ./nginx/nginx.conf /etc/nginx/nginx.conf
    mkdir /etc/nginx/log
    touch /etc/nginx/log/services.qaz123wsx.go.ro.log
    service nginx start
    successMessage "Nginx instaled and configured"
    infoMessage "Configuring ufw"
    ufw allow "Nginx Full"
    successMessage "Ufw configured"

    touch $NGINX
fi

##
# Install java
##
if [ ! -f $JAVA ]; then
    infoMessage "Installing java.."
    apt install --yes -t jessie-backports  openjdk-8-jre-headless ca-certificates-java
    JAVA_HOME="$(find /usr -name "jre")/bin/java"
    echo "JAVA_HOME=\""$JAVA_HOME"\"" >> /etc/environment
    source /etc/environment
    infoMessage "JAVA_HOME set to "$JAVA_HOME
    successMessage "Java installed"

    touch $JAVA
fi

if [ ! -d $TOOLS_DIR ]; then
    mkdir $TOOLS_DIR
    successMessage "Created "$TOOLS_DIR
fi

##
# Install youtrack
##
if [ ! -f $YOUTRACK ]; then
    infoMessage "Downloading youtrack from: "$YOUTRACK_DOWNLOAD_URL
    wget -P $TOOLS_DIR $YOUTRACK_DOWNLOAD_URL
    successMessage "Youtrack downloaded"
    infoMessage "Installing youtrack.."
    cd $TOOLS_DIR
    mkdir $YOUTRACK_DIR
    unzip ./*.zip -d $YOUTRACK_DIR
    mv $YOUTRACK_DIR/youtrack*/* $YOUTRACK_DIR
    rmdir $YOUTRACK_DIR/youtrack*
    successMessage "Youtrack installed"

    touch $YOUTRACK
fi

##
# Install teamcity
##
if [ ! -f $TEAMCITY ]; then
    infoMessage "Downloading teamcity from: "$TEAMCITY_DOWNLOAD_URL
    wget -P $TOOLS_DIR $TEAMCITY_DOWNLOAD_URL
    successMessage "Teamcity downloaded"
    infoMessage "Installing teamcity.."
    cd $TOOLS_DIR
    tar xfv ./*
    successMessage "Teamcity installed"

    touch $TEAMCITY
fi
