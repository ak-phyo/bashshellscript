#!/bin/bash 

id="UUID=\"B139-C839\""

usb(){
sid=$(blkid | grep "$id" | awk '{print $2}') 
if [ $sid == $id ] 2> /dev/null
then
	gnome-screensaver-command --deactivate && sleep 10
else
	zenity --notification --text="USB device is not plugged in! Will lock off " && sleep 2 && gnome-screensaver-command --lock
fi
}

while :
do
usb
sleep 10
done
