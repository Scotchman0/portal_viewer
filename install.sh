#!/bin/bash

#installation and config script

#update the system to ensure no missing packages before config
sudo apt-get update && sudo apt upgrade -y

#install necessary VLC command line interface handlers
sudo apt-get install libvlc-dev
sudo apt-get install vlc-plugin-base
sudo apt-get install vlc-plugin-video-output



########If I want to set up a kiosk web interface optional install can do the following:#####

kiosk_mode(){
#install chromium
sudo apt-get install --no-install-recommends chromium-browser

#set power management rules for the display: (using tee and -a to ensure append, not overwrite)
cp /etc/xdg/openbox/autostart /etc/xdg/openbox/autostart.orig
tee -a /etc/xdg/openbox/autostart << EOF
xset -dpms # turn off display power management system
xset s noblank # turn off screen blanking‎
xset s off # turn off screen saver

# Remove exit errors from the config files that could trigger a warning
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences

# Run Chromium in kiosk mode
chromium-browser  --noerrdialogs --disable-infobars --kiosk $KIOSK_URL
--check-for-update-interval=31536000
EOF


echo "KIOSK_URL= https://clockfaceonline.co.uk/clocks/morph/ #define base URL" >> /etc/xdg/openbox/environment
}

if $1 = '--kiosk=true'
then
	kiosk_mode
else
	echo "finished!"

exit 0