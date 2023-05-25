#!/bin/bash

# fail if an error occurs on any of the commands
set -e

# check if run as sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo!"
  exit
fi

###########################################################
# SETUP DEBUG STUFF
###########################################################
# set to 1 if on RPI, 0 on desktop
RPI=1

LMS="http://downloads.slimdevices.com/LogitechMediaServer_v8.3.0/logitechmediaserver_8.3.0_arm.deb"
SQUEEZE="https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/squeezelite-1.9.9.1430-armhf.tar.gz/download"

if [ "$RPI" -eq "0" ];
then
    LMS="http://downloads.slimdevices.com/LogitechMediaServer_v8.3.0/logitechmediaserver_8.3.0_amd64.deb"
    SQUEEZE="https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/squeezelite-1.9.9.1414-x86_64.tar.gz/download"
fi

###########################################################
# INSTALL LMS
###########################################################
# get new packages
apt-get update

# get the LMS debian package
wget ${LMS} -O lms.deb
# install it
dpkg -i lms.deb
rm lms.deb
apt --fix-broken install
systemctl daemon-reload
systemctl enable logitechmediaserver.service
systemctl start logitechmediaserver.service
###########################################################
# INSTALL SQUEEZELITE
###########################################################
# get the squeezelite archive
wget ${SQUEEZE}
# extract the files from the archive and go into the folder
tar -xzf download
# move the squeezelite application to somewhere
mv squeezelite /usr/bin/squeezelite -f
# clean up downloaded files
rm LICENSE.txt
rm download
###########################################################
# INSTALL AUTOSTART
###########################################################
if [ "$RPI" -eq "0" ];
then
    exit 0
fi
# copy modified system files for autostart
cp desktop.conf /etc/xdg/lxsession/LXDE-pi/desktop.conf -f
cp autostart /etc/xdg/openbox/autostart -f
