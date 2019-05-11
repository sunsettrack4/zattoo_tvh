#!/bin/bash

#      Copyright (C) 2017-2019 Jan-Luca Neumann
#      https://github.com/sunsettrack4/zattoo_tvh/
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with zattoo_tvh. If not, see <http://www.gnu.org/licenses/>.

#
# INITIAL FOLDER INITIALIZATION
#

if cd ~/ztvh
then 
	mkdir work 2> /dev/null
else
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		dialog --backtitle "[M12E0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "[1] ERROR" --infobox "Script platform could not be initialized!" 3 50
	else
		dialog --backtitle "[M12E0] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "[1] ERROR" --infobox "Script platform could not be initialized!" 3 50
	fi
	sleep 1s
	rm work/value 2> /dev/null
	exit 1
fi


#
# LOAD SESSION ID
#

if ! session=$(<user/session)
then
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		dialog --backtitle "[M12E0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "[2] ERROR" --infobox "Failed to load session ID!" 3 50
	else
		dialog --backtitle "[M12E0] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "[2] ERROR" --infobox "Failed to load session ID!" 3 50
	fi
	sleep 1s
	rm work/value 2> /dev/null
	exit 1
fi


#
# CHECK PVR FOLDER AND SETUP
#

# Use standard folder if no value is defined in options file
if ! grep -q "recfolder" ~/ztvh/user/options
then
	sed -i "/recfolder=/d" ~/ztvh/user/options
	echo "recfolder=$PWD/pvr" >> ~/ztvh/user/options
	mkdir pvr 2> /dev/null
	chmod 0777 pvr 2> /dev/null
fi

# Check if PVR folder still exists
cd /
if ! chmod 0777 $(grep "recfolder" ~/ztvh/user/options | sed "s/recfolder=//g") 2> /dev/null
then
	if ! mkdir $(grep "recfolder" ~/ztvh/user/options | sed "s/recfolder=//g") 2> /dev/null
	then
		cd ~/ztvh
		sed -i "/recfolder=/d" ~/ztvh/user/options
		echo "recfolder=$PWD/pvr" >> ~/ztvh/user/options
		mkdir pvr 2> /dev/null
		chmod 0777 pvr 2> /dev/null
	else
		chmod 0777 $(grep "recfolder" ~/ztvh/user/options | sed "s/recfolder=//g")
	fi
fi
cd ~/ztvh

# Cleanup workfolder
rm work/output work/recvalue work/broadcast work/final_broadcast work/cloudfile 2> /dev/null

# Load provider
provider=$(sed "2,5d;s/provider=//g" ~/ztvh/user/userfile)


#
# MENU CREATION AND OUTPUT
#

if grep -q "M1200U" work/value
then

	#
	# DOWNLOAD LIST
	#
	
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		dialog --backtitle "[M12W0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --infobox "Loading cloud recordings..." 3 40
		curl -k -i -X GET -H "Content-Type: application/json" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" https://$provider/zapi/playlist > work/cloudfile 2> /dev/null
	else
		dialog --backtitle "[M12W0] ZATTOO UNLIMITED BETA > PVR CLOUD" --infobox "Loading cloud recordings..." 3 40
		curl -i -X GET -H "Content-Type: application/json" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" https://$provider/zapi/playlist > work/cloudfile 2> /dev/null
	fi
	
	if grep -q '"success": true' work/cloudfile
	then
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			dialog --backtitle "[M12S0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --infobox "Loading cloud recordings... OK!" 3 40
		else
			dialog --backtitle "[M12S0] ZATTOO UNLIMITED BETA > PVR CLOUD" --infobox "Loading cloud recordings... OK!" 3 40
		fi
		sleep 0.5s
	else
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			dialog --backtitle "[M12E0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --infobox "Loading cloud recordings... FAILED!" 3 40
		else
			dialog --backtitle "[M12E0] ZATTOO UNLIMITED BETA > PVR CLOUD" --infobox "Loading cloud recordings... FAILED!" 3 40
		fi
		sleep 1s
		rm work/value 2> /dev/null
		exit 1
	fi


	#
	# CREATE MENU
	#
	
	# EXTRACT REC INFO TO SEPERATE LINES IN FILE AND SETUP DELIMITERS
	grep '"recordings": ' work/cloudfile > work/recmenu
	sed -i -e 's/.*"recordings": \[//g' -e 's/}, {/}\n{/g' -e 's/\], "success": true}//g' work/recmenu && cp work/recmenu work/recordings_full
	sed -i -e 's/|/\\u007c/g' -e 's/", "/"|"/g' -e 's/, "/|"/g' -e 's/}/|}/g' work/recmenu
	sed -e 's/\(.*\)\("id":[^|]*|\)\(.*\)/\2/g' -e 's/"id": //g' -e 's/|//g' work/recmenu > work/recordings_list 
	
	# SORT: TIME - TITLE - EP-TITLE - CID
	sed -i 's/\(.*\)\("cid":[^|]*|\)\(.*\)/\2\1|\3/g' work/recmenu
	sed	-i -e 's/"episode_title": null//g' -e 's/\(.*\)\("episode_title":[^|]*|\)\(.*\)/\2\1|\3/g' work/recmenu
	sed -i 's/\(.*\)\("title":[^|]*|\)\(.*\)/\2\1|\3/g' work/recmenu
	sed -i 's/\(.*\)\("start":[^|]*|\)\(.*\)/\2\1|\3/g' work/recmenu
	sed -i 's/|{.*/|/g' work/recmenu
	
	# CONVERT TIMESTRINGS FROM UTC TO LOCAL TIMEZONE
	sed -i -e 's/"start": "/#/g' -e 's/\(.*\)\([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\)T\([0-2][0-9]:[0-5][0-9]:[0-5][0-9]\)Z"|/\1\2 \3 UTC\n/g' work/recmenu
	while IFS= read -r i; do if [[ $i =~ ^#([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9] UTC)$ ]]; then printf '#%s\n' "$(date --date="${BASH_REMATCH[1]}" '+%Y-%m-%d %H:%M')"; else printf '%s\n' "$i"; fi; done <work/recmenu > work/convert
	while IFS= read -r i; do if [[ $i =~ ^#([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-2][0-9]:[0-5][0-9])$ ]]; then if [ $(date --date="${BASH_REMATCH[1]}" '+%s') -ge $(date '+%s') ]; then printf '%s\n' "$(date --date="${BASH_REMATCH[1]}" '+%d.%m.%Y %H:%M*')"; else printf '%s\n' "$(date --date="${BASH_REMATCH[1]}" '+%d.%m.%Y %H:%M')"; fi; else printf '%s\n' "$i"; fi; done <work/convert > work/recmenu
	
	# COMBINE TITLE AND EPISODE-TITLE
	sed -i -e ':a $!N;s/\n"title": "/  /;ta P;D' work/recmenu
	sed -i 's/\*  /* /g' work/recmenu
	sed -i 's/"|"episode_title": "/ - /g' work/recmenu
	
	# SETUP CHANNEL NAME
	sed -i -e 's/"|"cid": "/ (/g' -e 's/"|/)/g' work/recmenu
	grep "EXTINF" channels.m3u | sed -e 's/\//\\\//g' -e 's/\&/\\\&/g' -e 's/.*tvg-id="/sed -i "s\/(/g' -e 's/" group-title.*, /)\/(/g' -e 's/.*/&)\/g" work\/recmenu/g' -e '1i#\!\/bin\/bash\ncd ~\/ztvh' > work/cidchanger.sh
	bash work/cidchanger.sh
	
	# BUILD DIALOG MENU
	sed -i 's/.*/"&" \\/g' work/recmenu
	nl work/recmenu > work/recmenu2 && mv work/recmenu2 work/recmenu
	
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		sed -i -e '1idialog --backtitle "[M1200] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD * ONLINE" --title "RECORDINGS" --menu "Please choose a broadcast mentioned below.\nSwitch to next recordings by hitting [OK] button twice." 16 100 10 \\\n	"X" "             >>>  UPDATE PVR LIST" \\' work/recmenu
	else
		sed -i -e '1idialog --backtitle "[M1200] ZATTOO UNLIMITED BETA > PVR CLOUD * ONLINE" --title "RECORDINGS" --menu "Please choose a broadcast mentioned below.\nSwitch to next recordings by hitting [OK] button twice." 16 100 10 \\\n	"X" "             >>>  UPDATE PVR LIST" \\' work/recmenu
	fi

	echo "2>work/value" >> work/recmenu

	sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' work/recmenu
	ascii2uni -a U -q work/recmenu > work/recmenu2
	mv work/recmenu2 work/recmenu
	sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' work/recmenu
fi

rm work/value

until [ -e work/value ]
do
	# FILTER 1
	if [ -e work/recmenu_av ]
	then
		rm work/recmenu_up 2> /dev/null
		sed "/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]\*/d" work/recmenu > work/recmenu_av
		sed -i 's/--title "RECORDINGS"/--title "AVAILABLE RECORDINGS"/g' work/recmenu_av
		sed -i 's/Switch to next/Switch to planned/g' work/recmenu_av
		bash work/recmenu_av
	elif [ -e work/recmenu_up ]
	then
		rm work/recmenu_av 2> /dev/null
		sed "/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]  /d" work/recmenu > work/recmenu_up
		sed -i 's/\([0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]\)\(\* \)\(.*\)/\1  \3/g' work/recmenu_up
		sed -i 's/--title "RECORDINGS"/--title "PLANNED RECORDINGS"/g' work/recmenu_up
		sed -i 's/Switch to next/Switch to available/g' work/recmenu_up
		bash work/recmenu_up
	else
		rm work/recmenu_up 2> /dev/null
		
		if grep -q '""' work/recmenu
		then
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				dialog --backtitle "[M12A0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD * ONLINE" --title "RECORDINGS" --msgbox "No recordings available!" 5 30
			else
				dialog --backtitle "[M12A0] ZATTOO UNLIMITED BETA > PVR CLOUD * ONLINE" --title "RECORDINGS" --msgbox "No recordings available!" 5 30
			fi
			touch work/value
		else
			sed "/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]\*/d" work/recmenu > work/recmenu_av
			sed -i 's/--title "RECORDINGS"/--title "AVAILABLE RECORDINGS"/g' work/recmenu_av
			sed -i 's/Switch to next/Switch to planned/g' work/recmenu_av
			bash work/recmenu_av
		fi
	fi
	
	# FILTER 2
	if read -t 0.2 -n1
	then
		if [ -e work/recmenu_av ]
		then
			rm work/value work/recmenu_av 2> /dev/null
			sed "/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]  /d" work/recmenu > work/recmenu_up
			sed -i 's/\([0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]\)\(\* \)\(.*\)/\1  \3/g' work/recmenu_up
			sed -i 's/--title "RECORDINGS"/--title "PLANNED RECORDINGS"/g' work/recmenu_up
			sed -i 's/Switch to next/Switch to available/g' work/recmenu_up
			bash work/recmenu_up
		elif [ -e work/recmenu_up ]
		then
			rm work/value work/recmenu_up 2> /dev/null
			sed "/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]\*/d" work/recmenu > work/recmenu_av
			sed -i 's/--title "RECORDINGS"/--title "AVAILABLE RECORDINGS"/g' work/recmenu_av
			sed -i 's/Switch to next/Switch to planned/g' work/recmenu_av
			bash work/recmenu_av
		fi
	fi
	
	# FILTER 3
	if read -t 0.2 -n1
	then
		if [ -e work/recmenu_av ]
		then
			rm work/recmenu_av work/value 2> /dev/null
			touch work/recmenu_up
		elif [ -e work/recmenu_up ]
		then
			rm work/recmenu_up work/value 2> /dev/null
		fi
	fi
done


#
# MENU SELECTION
#

if grep -q "X" work/value
then
	echo "M1200U" > work/value
elif [ -s work/value ]
then
	if grep "[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]" work/recmenu | sed -n "$(<work\/value)p" | grep "[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9][*]"
	then
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then	
			dialog --backtitle "[M12E0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "ERROR [1]" --infobox "Stream not available yet!" 4 30
		else
			dialog --backtitle "[M12E0] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "ERROR [1]" --infobox "Stream not available yet!" 4 30
		fi
		echo "M1200" > work/value
		sleep 2s
	else
		if xset q &>/dev/null
		then
			if command -v vlc >/dev/null
			then
				dialog --backtitle "[M12I0] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "OUTPUT SELECTION" --menu "Please select your streaming output:" 9 40 20 \
				1	"WATCH PVR VIA VLC" \
				2 	"SAVE PVR TO LOCAL STORAGE" \
				2>work/output
			fi
		else
			dialog --backtitle "[M12I0] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "OUTPUT SELECTION" --menu "Please select your streaming output:" 9 40 20 \
			2 	"SAVE PVR TO LOCAL STORAGE" \
			2>work/output
		fi
	fi
		
	if grep -q "1" work/output 2> /dev/null
	then
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			dialog --backtitle "[M121W] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "PLAYER" --infobox "Starting stream..." 4 30
		else
			dialog --backtitle "[M121W] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "PLAYER" --infobox "Starting stream..." 4 30
		fi
	elif grep -q "2" work/output 2> /dev/null
	then
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			dialog --backtitle "[M122W] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "DOWNLOADER" --infobox "Starting file download..." 4 30
		else
			dialog --backtitle "[M122W] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "DOWNLOADER" --infobox "Starting file download..." 4 30
		fi
	else
		echo "M1200" > work/value
		rm work/output 2> /dev/null
	fi
fi

if [ -e work/output ]
then
	sed -n "$(<work\/value)p" work/recordings_list > work/rec_value

	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		curl -k -i -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" --cookie "$session" --data "stream_type=hls&https_watch_urls=True" "https://$provider/zapi/watch/recording/$(<work/rec_value)" | grep "{" > work/broadcast 2> /dev/null
	else
		curl -i -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" --cookie "$session" --data "stream_type=hls&https_watch_urls=True" "https://$provider/zapi/watch/recording/$(<work/rec_value)" | grep "{" > work/broadcast 2> /dev/null
	fi
	
	if grep -q '"success": false' work/broadcast
	then
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then	
			dialog --backtitle "[M12E0] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "ERROR [2]" --infobox "Stream not available!" 4 30
		else
			dialog --backtitle "[M12E0] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "ERROR [2]" --infobox "Stream not available!" 4 30
		fi
	
		echo "M1200U" > work/value
		rm work/output
		sleep 2s
	else
		sed -i 's/.*"watch_urls": \[{"url": "//g;s/", "maxrate": .*//g' work/broadcast
			
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			curl -k -s $(<work/broadcast) > work/broadcast_list 2> /dev/null
		else
			curl -s $(<work/broadcast) > work/broadcast_list 2> /dev/null
		fi
		
		sed -i 's/\/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].m3u8.*//g' work/broadcast
	
		if grep -q "chpipe 4" user/options
		then
			grep -E "8000.m3u8|5000.m3u8|3000.m3u8|2999.m3u8|1500.m3u8" work/broadcast_list | sed "2,5d" > work/final_broadcast
		elif grep -q "chpipe 3" user/options
		then
			grep -E "3000.m3u8|2999.m3u8|1500.m3u8" work/broadcast_list | sed "2,3d" > work/final_broadcast
		elif grep -q "chpipe 2" user/options
		then
			grep "1500.m3u8" work/broadcast_list > work/final_broadcast
		elif grep -q "chpipe 1" user/options
		then
			grep "900.m3u8" work/broadcast_list > work/final_broadcast
		elif grep -q "chpipe 0" user/options
		then
			grep "600.m3u8" work/broadcast_list > work/final_broadcast
		else
			grep -E "8000.m3u8|5000.m3u8|3000.m3u8|2999.m3u8|1500.m3u8" work/final_broadcast | sed "2,5d" > work/final_broadcast
		fi

		if grep -q "1" work/output
		then
			ffmpeg -loglevel fatal -i "$(<work/broadcast)/$(<work/final_broadcast)" -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1 | vlc - 2> /dev/null & disown
			
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				dialog --backtitle "[M121S] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "PLAYER" --infobox "Playback started!" 4 30
			else
				dialog --backtitle "[M121S] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "PLAYER" --infobox "Playback started!" 4 30
			fi
		elif grep -q "2" work/output
		then
			# Add manifest file + file size check here
			#
			# grep "$(<work/rec_value)" work/recordings_full > work/filecheck
			#
			# start=$(sed 's/.*"start": "//g;s/Z".*//g;s/T/ /g' work/filecheck)
			# end=$(sed 's/.*"end": "//g;s/Z".*//g;s/T/ /g' work/filecheck)
			#
			# date_start=$(date -d "$start UTC" +%s)
			# date_end=$(date -d "$end UTC" +%s)
			#
			# time_length=$(expr $date_end - $date_start)
			# file_size=$(echo "664.647 * $time_length" | bc -l)
			# printf "$file_size"
			# sleep 30s
			
			cd /
			
			if [ -e $(grep "recfolder" ~/ztvh/user/options | sed "s/recfolder=//g")/zattoo_rec_$(sed -n "$(<~/ztvh\/work\/value)p" ~/ztvh/work/recordings_list).ts ]
			then
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					dialog --backtitle "[M122E] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "ERROR" --infobox "File already exists in folder!" 4 40
				else
					dialog --backtitle "[M122E] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "ERROR" --infobox "File already exists in folder!" 4 40
				fi
			else
				ffmpeg -loglevel fatal -i "$(<~/ztvh/work/broadcast)/$(<~/ztvh/work/final_broadcast)" -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal $(grep "recfolder" ~/ztvh/user/options | sed "s/recfolder=//g")/zattoo_rec_$(sed -n "$(<~/ztvh\/work\/value)p" ~/ztvh/work/recordings_list).ts & disown
			
				cd ~/ztvh
			
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					dialog --backtitle "[M122S] [INSECURE] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "DOWNLOADER" --infobox "Download started!" 4 30
				else
					dialog --backtitle "[M122S] ZATTOO UNLIMITED BETA > PVR CLOUD" --title "DOWNLOADER" --infobox "Download started!" 4 30
				fi
			fi
		fi
		
		cd ~/ztvh
		sleep 3s
		echo "M1200" > work/value
		rm work/output
	fi
elif grep -q "M1200U" work/value
then
	:
elif [ -s work/value ]
then
	echo "M1200" > work/value
else
	rm work/value work/recmenu_* 2> /dev/null
fi
