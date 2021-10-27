#!/bin/bash

set -x
find hooks -type f -exec sed -i "s@<USER_HOME>@$HOME@g" {} \;

sudo cp hooks/95-usb.rules /etc/udev/rules.d/95-usb.rules
sudo cp hooks/90-polybar /etc/NetworkManager/dispatcher.d/90-polybar
set +x
