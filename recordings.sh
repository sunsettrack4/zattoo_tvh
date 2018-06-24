#!/bin/bash

# ZATTOO PLUS FOR TVHEADEND - ADDITIONAL SCRIPT (3)
# https://github.com/sunsettrack4/zattoo_tvh

# VIEW/SAVE PVR CLOUD RECORDINGS
# INPUT FILE: session

if cd ~/ztvh
then 
	mkdir work 2> /dev/null
else
	echo "ERROR: Script platform could not be initialized! (ztvh folder missing)"
	exit 1
fi

if session=$(<work/session)
then
	printf "Loading cloud recordings..."
else
	echo "ERROR: Failed to load session ID, please login via main script first!"
	exit 1
fi

#
# DOWNLOAD LIST
#

curl -i -X GET -H "Content-Type: application/json" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" https://zattoo.com/zapi/playlist > work/cloudfile 2> /dev/null

if grep -q '"success": true' work/cloudfile
then
	printf "\rLoading cloud recordings... OK!\n\n"
	sleep 0.5s
else
	printf "\rLoading cloud recordings... FAILED!\n"
	exit 1
fi


#
# CREATE MENU
#

grep '"recordings": ' work/cloudfile > work/recordings_list
sed 's/{"recordings": \[//g;s/}, {/}\n{/g;' work/recordings_list > work/recmenu

sed -i -e 's/\(.*"title": "\)/"/g' -e 's/", "cid": "/ | CH: /g' -e 's/", "program_id".*"start": "/ | UTC: /g' -e 's/", ".*//g' -e 's/\(.*\)\([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\)T\([0-2][0-9]:[0-5][0-9]:[0-5][0-9]\)Z/\1\2 \3" \\/g' work/recmenu
nl work/recmenu > work/recmenu2 && mv work/recmenu2 work/recmenu
sed -i -e '1idialog --backtitle "ZATTOO PVR" --title "RECORDINGS" --menu "Please choose the broadcast you want to watch:" 14 100 10 \\' work/recmenu
echo "2>value" >> work/recmenu

sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' work/recmenu
ascii2uni -a U -q work/recmenu > work/recmenu2
mv work/recmenu2 work/recmenu
sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' work/recmenu

bash work/recmenu

if [ -s value ]
then 
	dialog --backtitle "ZATTOO PVR" --title "WATCH VIA VLC PLAYER" --infobox "Opening stream..." 4 30
	sed -i 's/{"recordings": \[//g;s/}, {/}\n{/g;' work/recordings_list
	sed -i -n "$(<value)p" work/recordings_list
	sed -i 's/.*"id": //g;s/, ".*//g' work/recordings_list
	curl -i -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" --cookie "$session" --data "stream_type=hls&https_watch_urls=True" "https://zattoo.com/zapi/watch/recording/$(<work/recordings_list)" | grep "{" > work/broadcast 2> /dev/null
	sed -i 's/.*"watch_urls": \[{"url": "//g;s/", "maxrate": .*//g' work/broadcast
	curl -s $(<work/broadcast) > work/final_broadcast 2> /dev/null
	sed -i 's/\/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].m3u8.*//g' work/broadcast
	sed -i -n "3p" work/final_broadcast
	ffmpeg -loglevel fatal -i "$(<work/broadcast)/$(<work/final_broadcast)" -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1 | vlc --fullscreen - 2> /dev/null
	dialog --backtitle "ZATTOO PVR" --title "WATCH VIA VLC PLAYER" --msgbox "Player closed!" 5 30 
fi
