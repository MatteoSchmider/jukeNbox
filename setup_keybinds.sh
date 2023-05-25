#!/bin/bash

# fail if an error occurs on any of the commands
set -e

# check if run as sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run with sudo!"
  exit
fi

# remove user specific keybind config
rm -rf /home/pi/.config/openbox
# replace system wide keybind config with our modified one
cp -f lxde-pi-rc.xml /etc/xdg/openbox/lxde-pi-rc.xml

# install dependency for keybinder script
pip install -U click pyyaml requests
# install the keybinder script as command line tool
cp -f keybinder /usr/local/bin/keybinder
# install the jukeboxcli script as command line tool
cp -f jukeboxcli /usr/local/bin/jukeboxcli

echo "Setup was successful!"
