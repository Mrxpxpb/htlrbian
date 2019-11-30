#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

set -e
trap exit 1 ERR

export LANGUAGE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
export LANG=en_GB=UTF-8
locale-gen en_GB.UTF-8

apt update -qq
apt upgrade -qqy
apt install -qqy shellinabox samba samba-common-bin vim python3-gpiozero python3-rpi.gpio python3-pigpio

# copy htl.txt
cp /usr/share/htl_setup/htl.txt /boot

# enable services
systemctl enable ssh
systemctl enable shellinabox
systemctl enable smbd
systemctl enable nmbd

# temporary fix for WPA Enterprise on Raspbian Buster
apt remove wpasupplicant -y
mv -f /etc/apt/sources.list /etc/apt/sources.list.bak
echo 'deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi' > /etc/apt/sources.list
apt update
apt install wpasupplicant -y
apt-mark hold wpasupplicant
cp -f /etc/apt/sources.list.bak /etc/apt/sources.list
apt-get update
