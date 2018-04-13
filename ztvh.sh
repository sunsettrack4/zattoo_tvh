#!/bin/bash

#      Copyright (C) 2017-2018 Jan-Luca Neumann
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


echo "ZattooPLUS for tvheadend"
echo "(c) 2017-2018 Jan-Luca Neumann"
echo "Version 0.3.7 2018/03/31"
echo ""

# ##################
# CHECK CONDITIONS #
# ##################

#
# Existence of required programs
#

command -v phantomjs >/dev/null 2>&1 || { echo "PhantomJS is required but it's not installed!  Aborting." >&2; exit 1; }
command -v uni2ascii >/dev/null 2>&1 || { echo "uni2ascii is required but it's not installed!  Aborting." >&2; exit 1; }
command -v xmllint >/dev/null 2>&1 || { echo "libxml2-utils is required but it's not installed!  Aborting." >&2; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo "ffmpeg is required for watching Live TV but it's not installed!" && echo ""; }


#
# Existence of internet connectivity
#

echo "Checking internet connectivity..."
if ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2> /dev/null
then :
else
	echo "- ERROR: NO INTERNET CONNECTION AVAILABLE! -"
	exit 1
fi

if ping -q -w 1 -c 1 www.zattoo.com > /dev/null 2> /dev/null
then :
else
	echo "- ERROR: ZATTOO WEBSERVICE UNAVAILABLE! -"
	exit 1
fi


#
# Existence of all required scripts and its executable permissions
#

echo "Checking file existence and permissions..."

# FOLDER + FILES missing

if ls -ld ~/ztvh | grep -q "drwxrwxrwx" 2> /dev/null
then
	cd ~/ztvh
elif [ -e ~/ztvh ]
then
	echo "- ERROR: SCRIPT FOLDER DOES NOT HAVE THE CORRECT PERMISSION VALUES! -"
	if chmod 0777 ~/ztvh 2> /dev/null
	then
		echo "Permission issue fixed, please restart the script to proceed."
	fi
	exit 1
else
	echo "- ERROR: SCRIPT FOLDER NOT EXISTING IN HOME DIRECTORY! -"
	exit 1
fi


# FILES missing

if [ ! -e ztvh.sh ]
then
	echo "- ERROR: MAIN SCRIPT MUST BE LOCATED IN MAIN FOLDER! -"
	exit 1
elif [ ! -x ztvh.sh ]
then
	echo "- ERROR: MAIN SCRIPT IS NOT EXECUTABLE! -"
	if chmod 0777 ztvh.sh 2> /dev/null
	then
		echo "Permission issue fixed, please restart the script to proceed."
	fi
	exit 1
fi

if chmod 0777 ~/ztvh/* 2> /dev/null
then :
else
	echo "- WARNING: FILE PERMISSIONS COULD NOT BE SET! -"
fi

if [ ! -e save_page.js ]
then
	echo "Missing file: save_page.js"
	touch fakefile
elif [ ! -x save_page.js ]
then
	echo "File not executable: savepage.js"
	touch fakefile
fi

if [ ! -e zguide_dl.sh ]
then
	echo "Missing file: zguide_dl.sh"
	touch fakefile
elif [ ! -x zguide_dl.sh ]
then
	echo "File not executable: zguide_dl.sh"
	touch fakefile
fi

if [ ! -e zguide_fc.sh ]
then
	echo "Missing file: zguide_fc.sh"
	touch fakefile
elif [ ! -x zguide_fc.sh ]
then
	echo "File not executable: zguide_fc.sh"
	touch fakefile
fi

if [ ! -e zguide_pc.sh ]
then
	echo "Missing file: zguide_pc.sh"
	touch fakefile
elif [ ! -x zguide_pc.sh ]
then
	echo "File not executable: zguide_pc.sh"
	touch fakefile
fi

if [ ! -e zguide_su.sh ]
then
	echo "Missing file: zguide_su.sh"
	touch fakefile
elif [ ! -x zguide_su.sh ]
then
	echo "File not executable: zguide_su.sh"
	touch fakefile
fi

if [ ! -e zguide_xmltv.sh ]
then
	echo "Missing file: zguide_xmltv.sh"
	touch fakefile
elif [ ! -x zguide_xmltv.sh ]
then
	echo "File not executable: zguide_xmltv.sh"
	touch fakefile
fi

if [ ! -e pipe.sh ]
then
	echo "Missing file: pipe.sh"
	touch fakefile
elif [ ! -r pipe.sh ]
then
	echo "File not readable: pipe.sh"
	touch fakefile
fi

if [ ! -e status.sh ]
then
	echo "Missing file: status.sh"
	touch fakefile
elif [ ! -x status.sh ]
then
	echo "File not executable: status.sh"
	touch fakefile
fi

if [ -e fakefile ]
then
	echo "- ERROR: FAILED TO LOAD REQUIRED SCRIPT(S)! -"
	rm fakefile
	exit 1
fi


#
# Further actions
#

export QT_QPA_PLATFORM=offscreen
echo ""


# ################
# MENU OPTIONS   #
# ################

if [ -e user/options ]
then
	echo "Press [ENTER] to open the options menu. Script continues in 5 secs..." && echo ""
	if read -t 5
	then
		while true
		do
			echo "--- OPTIONS MENU ---"
			until grep -q "chlogo [0-1]" user/options
			do
				sed -i 's/chlogo.*//g' user/options
				sed -i '/^\s*$/d' user/options
				echo "chlogo 0"  >> user/options
			done
			if grep -q "chlogo 1" user/options
			then
				echo "[1] Disable ZATTOO CHANNEL LOGOS"
			elif grep -q "chlogo 0" user/options
			then
				echo "[1] Enable ZATTOO CHANNEL LOGOS"
			fi
			if grep -q -E "epgdata [1-9]-|epgdata 1[0-4]-" user/options
			then
				echo "[2] Change time period for ZATTOO EPG GRABBER (current: $(sed '/epgdata/!d;s/epgdata //g;s/-//g;' ~/ztvh/user/options) day(s))"
			elif grep -q "epgdata 0-" user/options
			then
				echo "[2] Enable ZATTOO EPG GRABBER"
			else
				sed -i 's/epgdata.*//g' user/options
				sed -i '/^\s*$/d' user/options
				echo "[2] Enable ZATTOO EPG GRABBER"
				echo "epgdata 0-" >> user/options
			fi
			echo "[3] Change streaming quality/bandwidth"
			if grep -q "chpipe 3" user/options
			then
				echo "    (current: MAXIMUM @ 3-5 Mbit/s)"
			elif grep -q "chpipe 2" user/options
			then
				echo "    (current: MEDIUM @ 1,5 Mbit/s)"
			elif grep -q "chpipe 1" user/options
			then
				echo "    (current: LOW @ 600 kbit/s)"
			else
				sed -i 's/chpipe.*//g' user/options
				sed -i '/^\s*$/d' user/options
				echo "chpipe 3" >> user/options
				echo "    (current: MAXIMUM @ 3-5 Mbit/s"
			fi
			echo "[4] Restart script"
			echo "[5] Exit script"
			echo "[9] Logout from Zattoo and exit script" && echo ""
			read -p "Number....: " -n1 n && echo ""
			echo ""
			case $n in
			1)	if grep -q "chlogo 1" user/options
				then
					sed -i 's/chlogo 1/chlogo 0/g' user/options
					echo "ZATTOO CHANNEL LOGOS disabled!" && echo ""
				else
					sed -i 's/chlogo 0/chlogo 1/g' user/options
					echo "ZATTOO CHANNEL LOGOS enabled!" && echo ""
				fi;;
			2)	sed -i 's/epgdata.*//g' user/options
				sed -i '/^\s*$/d' user/options
				until grep -q -E "epgdata [0-9]-|epgdata 1[0-4]-" user/options 2> /dev/null
				do
					echo "Please enter the number of days you want to retrieve the EPG information."
					echo "[0] - DISABLE /// [1-14] - ENABLE"
					read -e -p "Number....: " -n2 epgnum && echo ""
					sed -i 's/epgdata.*//g' user/options
					sed -i '/^\s*$/d' user/options
					echo "epgdata $epgnum-" >> user/options
					if grep -q -E "epgdata [1-9]-|epgdata 1[0-4]-" user/options 2> /dev/null
					then
						echo "ZATTOO EPG GRABBER enabled for $(sed '/epgdata/!d;s/epgdata //g;s/-//g;' ~/ztvh/user/options) day(s)!" && echo ""
						mv ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg_OLD.xml 2> /dev/null 
					elif grep -q "epgdata 0-" user/options
					then
						echo "ZATTOO EPG GRABBER disabled!" && echo ""
					else
						echo "- ERROR: INVALID VALUE! -" && echo ""
						sed -i 's/epgdata.*//g' user/options
						sed -i '/^\s*$/d' user/options
					fi
				done;;
			3)	sed -i 's/chpipe.*//g' user/options
				sed -i '/^\s*$/d' user/options
				until grep -q "chpipe [1-3]" user/options 2> /dev/null
				do
					echo "Please choose the streaming quality you want to use."
					echo "[1] - LOW @ 600 kbit/s"
					echo "[2] - MEDIUM @ 1,5 Mbit/s"
					echo "[3] - MAXIMUM @ 3-5 Mbit/s"
					read -p "Number....: " -n1 pipenum && echo ""
					echo "chpipe $pipenum" >> ~/ztvh/user/options
					if grep -q "chpipe 3" ~/ztvh/user/options 2> /dev/null
					then
						echo "Streaming quality set to MAXIMUM" && echo ""
					elif grep -q "chpipe 2" ~/ztvh/user/options 2> /dev/null
					then
						echo "Streaming quality set to MEDIUM" && echo ""
					elif grep -q "chpipe 1" ~/ztvh/user/options 2> /dev/null
					then
						echo "Streaming quality set to LOW" && echo ""
					else
						echo "- ERROR: INVALID VALUE! -" && echo ""
						sed -i 's/chpipe.*//g' ~/ztvh/user/options
						sed -i '/^\s*$/d' ~/ztvh/user/options
					fi
				done;;
			4)	bash ztvh.sh
				exit;;
			5)	echo "GOODBYE" && exit;;
			9)	echo "Logging out..."
				rm channels.m3u chpipe.sh zattoo_fullepg.xml -rf user -rf work -rf epg -rf logos -rf chpipe 2> /dev/null
				echo "GOODBYE" && exit;;
			esac
		done
	fi
fi

echo "Starting script..." && echo ""
rm -rf work 2> /dev/null
mkdir work
chmod 0777 work


# ###############
# LOGIN PROCESS #
# ###############

cd work
phantomjs ~/ztvh/save_page.js https://zattoo.com/login > cookie_list
grep "beaker.session.id" cookie_list > session

# retrieve user data
until grep -q '"success": true' login.txt 2> /dev/null
do
	if grep -q -E "login|password" ~/ztvh/user/userfile 2> /dev/null
	then true
	else
		echo "- ZATTOO LOGIN PAGE -"
		read -e -p "email.....: " login
		read -e -sp "password..: " password
		mkdir ~/ztvh/user 2> /dev/null
		echo "login=$login" > ~/ztvh/user/userfile
		echo "password=$password" >> ~/ztvh/user/userfile
		echo "OK"
		echo ""
	fi 

	echo "Login to Zattoo webservice..." && echo ""
	
	session=$(<session)

	curl -i -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" --data-urlencode "$(sed '2d' ~/ztvh/user/userfile)" --data-urlencode "$(sed '1d' ~/ztvh/user/userfile)" https://zattoo.com/zapi/v2/account/login > login.txt 2> /dev/null

	if grep -q '"success": true' login.txt
	then
		echo "- LOGIN SUCCESSFUL! -" && echo ""
		rm cookie_list
		sed '/Set-cookie/!d' login.txt > workfile
		sed -i 's/expires.*//g' workfile
		sed -i 's/Set-cookie: //g' workfile
		sed -i 's/Set-cookie: //g' workfile
		tr -d '\n' < workfile > session
		sed -i 's/; Path.*//g' session
		session=$(<session)
	else
		rm -rf ~/ztvh/user/userfile
		echo "- LOGIN FAILED! PLEASE RETRY! -" && echo ""
	fi
done


# ##############
# CHANNEL LIST #
# ##############

echo "Fetching channel list..."
sed 's/, "/\n/g' login.txt | grep "power_guide_hash" > powerid
sed -i 's/.*: "//g' powerid && sed -i 's/.$//g' powerid
powerid=$(<powerid)
curl -X GET --cookie "$session" https://zattoo.com/zapi/v2/cached/channels/$powerid?details=False > channels_file 2> /dev/null

if grep -q '"success": true' channels_file
then
	echo "Creating channel list..."
	sed 's/"display_alias"/\n&/g' channels_file > workfile
	sed -i '1d' workfile
	sed -i 's/{/\n/g' workfile
	sed -i '/"availability": "subscribable"/d' workfile && cp workfile channels_file
	sed -i '/"drm_required"/s/\("drm_required": true, \)\("logo_black_84": ".*\)\("logo_white_42": ".*\)\("logo_white_84": ".*\)\("availability": "available", \)\("level": ".*\)\("logo_token": ".*\)\("logo_black_42": ".*\)\(}.*\)/\1\4\8, \2\6\3\5\7\9/g' workfile
	sed -i '/"drm_required"/s/\("drm_required": true, \)\("logo_white_84": ".*\)\(}\], "recommendations": .*\)\(, "logo_black_84": ".*\)/\2\4\3},/g' workfile
	sed -i -e '/"drm_required"/s/"drm_required": true, //g' -e '/"recommendations"/s/, }, //g' -e '/"logo_token"/s/, },/},/g' workfile
	sed -i ':a $!N;s/\n"logo_white_84"/ "logo_white_84"/;ta P;D' workfile
	sed -i '/level/!d' workfile
	sed -i 's/}.*//g' workfile
	sed -i 's/"sharing".*"cid"/"cid"/g' workfile
	sed -i 's/"recording".*"logo_black_84": "/"logo_black_84": "http:\/\/images.zattic.com/g' workfile
	sed -i 's/"level".*"title"/"title"/g' workfile
	sed -i 's/, "logo_white_42".*//g' workfile
	sed -i -e 's/,//g' -e 's/.*/& /g' workfile
	sed -i 's/\("display_alias": ".*" \)\("cid": ".*" \)\("logo_black_84": ".*" \)\("title": ".*" \)/\2\3\4\1/g' workfile
	sed -i 's/"cid": "/#EXTINF:0001 tvg-id="/g' workfile
	sed -i 's/"logo_black_84": "/group-title="Zattoo" tvg-logo="/g' workfile
	sed -i 's/ "title": "/, /g' workfile
	sed -i 's/" "display_alias": "/\npipe:\/\/-USER-\/chpipe\//g' workfile
	sed -i -e 's/pipe:\/\/.*/&.sh/g' -e 's/" .sh/.sh/g' workfile
	sed -i '1i #EXTM3U' workfile
	
	cd ~/ztvh
	echo $PWD > work/userfolder
	sed -i 's/\//\\\//g' work/userfolder
	sed -i 's/.*/#\!\/bin\/bash\nsed -i "s\/-USER-\/&/g' work/userfolder
	sed -i '/sed/s/.*/&\/g" work\/workfile/g' work/userfolder
	bash work/userfolder
	
	cd work
	sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' workfile
	ascii2uni -a U -q workfile > workfile2
	mv workfile2 workfile
	sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' workfile
	mv workfile ~/ztvh/channels.m3u
	rm login.txt userfolder
	echo "- CHANNEL LIST CREATED! -" && echo ""
else
	echo "- ERROR: UNABLE TO FETCH CHANNEL LIST -" && echo ""
	rm ~/ztvh/channels.m3u powerid login.txt 2> /dev/null
	exit 1
fi


# ###############
# CHANNEL LOGOS #
# ###############

echo "--- ZATTOO CHANNEL LOGOS ---"

until grep -q -E "chlogo 0|chlogo 1" ~/ztvh/user/options 2> /dev/null
do
	echo "Do you want to download and update the channel logo images from Zattoo?"
	echo "[1] - Yes /// [0] - No"
	read -p "Number....: " -n1 logonum
	echo "chlogo $logonum" > ~/ztvh/user/options
	if grep -q -E "chlogo 0|chlogo 1" ~/ztvh/user/options 2> /dev/null
	then
		echo ""
	else
		echo "- ERROR: INVALID VALUE! -" && echo ""
	fi
done

if grep -q "chlogo 0" ~/ztvh/user/options 2> /dev/null
then
	sed -i 's/ tvg-logo=".*84x48.png"//g' ~/ztvh/channels.m3u
	echo "- LOGO GRABBER DISABLED! -" && echo ""
elif grep -q "chlogo 1" ~/ztvh/user/options 2> /dev/null
then 
	echo "Collecting/updating channel logo images..."
	mkdir ~/ztvh/logos 2> /dev/null
	chmod 0777 ~/ztvh/logos
	sed 's/#EXTINF.*\(tvg-id=".*"\).*\(tvg-logo=".*"\).*/\2 \1/g' ~/ztvh/channels.m3u > workfile
	sed -i '/pipe/d' workfile
	sed -i 's/tvg-logo="/curl /g' workfile
	sed -i 's/" tvg-id="/ > ~\/ztvh\/logos\//g' workfile
	sed -i 's/" group.*/.png 2> \/dev\/null/g' workfile
	sed -i 's/#EXTM3U/#\!\/bin\/bash/g' workfile
	bash workfile
	sed -i 's/ group-title="Zattoo" tvg-logo=".*",/,/g' ~/ztvh/channels.m3u
	sed -i 's/tvg-id=".*"/& xyz&/g' ~/ztvh/channels.m3u
	sed -i 's/xyztvg-id="/tvg-logo="logos\//g' ~/ztvh/channels.m3u
	sed -i 's/", /.png" group-title="Zattoo", /g' ~/ztvh/channels.m3u
	chmod 0777 ~/ztvh/logos/*
	echo "- CHANNEL LOGO IMAGES SAVED! -" && echo ""
	rm workfile
fi


# ##############
# PIPE STREAMS #
# ##############

until grep -q "chpipe [1-3]" ~/ztvh/user/options 2> /dev/null
do
	echo "Please choose the streaming quality you want to use."
	echo "[1] - LOW @ 600 kbit/s"
	echo "[2] - MEDIUM @ 1,5 Mbit/s"
	echo "[3] - MAXIMUM @ 3-5 Mbit/s"
	read -p "Number....: " -n1 pipenum
	echo "chpipe $pipenum" >> ~/ztvh/user/options
	if grep -q "chpipe [1-3]" ~/ztvh/user/options 2> /dev/null
	then
		echo ""
	else
		echo "- ERROR: INVALID VALUE! -" && echo ""
		sed -i 's/chpipe.*//g' ~/ztvh/user/options
		sed -i '/^\s*$/d' ~/ztvh/user/options
	fi
done

echo "Creating pipe scripts..."

echo '#!/bin/bash' > pipe_workfile
echo "cd $PWD" >> pipe_workfile
sed -i "s/\/work//g" pipe_workfile
cat ~/ztvh/pipe.sh >> pipe_workfile

mkdir ~/ztvh/chpipe 2> /dev/null
chmod 0777 ~/ztvh/chpipe
sed 's/#EXTM3U/#\!\/bin\/bash/g' ~/ztvh/channels.m3u > workfile
sed -i '/#EXTINF/{s/.*tvg-id="/ch_id=\$(echo "/g;s/" tvg-logo.*/")/g;s/" group-title.*/")/g;}' workfile
sed -i '/pipe:\/\//{s/.*chpipe\//sed "s\/CID_CHANNEL\/\$ch_id\/g" ~\/ztvh\/work\/pipe_workfile > ~\/ztvh\/chpipe\//g;}' workfile
bash workfile

if grep -q "chpipe 3" ~/ztvh/user/options
then
	sed -i '5s/# //g' ~/ztvh/chpipe/*
elif grep -q "chpipe 2" ~/ztvh/user/options
then
	sed -i '6s/# //g' ~/ztvh/chpipe/*
else
	sed -i '7s/# //g' ~/ztvh/chpipe/*
fi

chmod 0777 ~/ztvh/chpipe/*
echo "- PIPE SCRIPTS CREATED! -" && echo ""
rm workfile pipe_workfile


# ################
# EPG DATA       #
# ################

echo "--- ZATTOO EPG GRABBER ---"

until grep -q -E "epgdata [0-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
do
	echo "Please enter the number of days you want to retrieve the EPG information."
	echo "[0] - DISABLE /// [1-14] - ENABLE"
	read -e -p "Number....: " -n2 epgnum
	echo "epgdata $epgnum-" >> ~/ztvh/user/options
	if grep -q -E "epgdata [0-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
	then
		echo ""
	else
		echo "- ERROR: INVALID VALUE! -" && echo ""
		sed -i 's/epgdata.*//g' ~/ztvh/user/options
		sed -i '/^\s*$/d' ~/ztvh/user/options
	fi
done

if grep -q "epgdata 0-" ~/ztvh/user/options 2> /dev/null
then
	echo "- EPG GRABBER DISABLED! -" && echo "--- DONE ---" && exit 0
fi 

echo "Grabbing EPG data for $(sed '/epgdata/!d;s/epgdata //g;s/-//g;' ~/ztvh/user/options) day(s)!" && echo ""

mkdir ~/ztvh/epg 2> /dev/null
chmod 0777 ~/ztvh/epg


#
# Check if EPG collection process was interrupted
#

cd ~/ztvh
bash zguide_pc.sh
touch ~/ztvh/epg/stats


#
# Entering loop to keep EPG cache up to date
#

while [ -e ~/ztvh/epg/stats ]
do
	rm ~/ztvh/epg/stats
	cd ~/ztvh/work
	
	#
	# Cleanup EPG cache / delete old cache files
	#
	
	ls ~/ztvh/epg > epglist
	until sed '1!d' epglist | grep -q "$(date +%Y%m%d)"
	do
		if [ -s epglist ]
		then
			rm -rf ~/ztvh/epg/$(sed '1!d' epglist) 
			ls ~/ztvh/epg > epglist
		else
			echo "$(date +%Y%m%d)" > epglist
		fi
	done
	rm epglist
	rm ~/ztvh/epg/scriptbase 2> /dev/null
	rm ~/ztvh/epg/scriptfile_0* 2> /dev/null


	#
	# Download EPG manifest files, create scripts to collect EPG details
	#
	
	cd ~/ztvh
	bash zguide_dl.sh


	#
	# Add progress bar
	#
	
	bash status.sh 2> /dev/null
	

	#
	# Collect EPG details
	#
	
	if [ -e ~/ztvh/epg/stats ]
	then
		echo "Collecting EPG details..."
		echo "That may take a while..."	&& echo ""
	
		for i in {0..7..1}
		do
			bash epg/scriptfile_0${i} 2> /dev/null &
		done
		wait
	
		printf "\r- EPG DOWNLOAD FINISHED! -               " && echo "" && echo ""
		rm epg/scriptbase 2> /dev/null
		rm epg/scriptfile_0* 2> /dev/null
	fi
	

	# 
	# Check EPG cache for completeness
	#

	cd ~/ztvh
	
	if [ -e ~/ztvh/epg/stats ]
	then
		bash zguide_fc.sh
	fi
	
	
	#
	# Repeat process: Keep manifest up to date
	#

	if [ -e ~/ztvh/epg/stats ]
	then
		echo "Checking for updates..."
	elif [ -e ~/ztvh/epg/stats2 ]
	then
		echo "No updates found!" && echo ""
		mv ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg_OLD.xml 2> /dev/null
	elif [ -e ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ]
	then
		echo "No updates found! EPG XMLTV file up to date!" && echo ""
		cp ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ~/ztvh/zattoo_fullepg.xml 2> /dev/null
		sort -u ~/ztvh/epg/status -o ~/ztvh/epg/status
		echo "--- DONE ---"
		exit 0
	fi
done
echo "- EPG FILES COLLECTED SUCCESSFULLY! -" && echo ""
rm ~/ztvh/epg/stats2 2> /dev/null


# 
# Sum up epg details
#

echo "Creating EPG XMLTV file..."
echo "That may take a while..." && echo ""

echo "Merging collected EPG details to a single EPG file..."

bash ~/ztvh/zguide_su.sh


#
# Create EPG XMLTV files
#

cd ~/ztvh/epg
bash ~/ztvh/zguide_xmltv.sh


#
# Validate xml file
#

echo "Validating EPG XMLTV file..."

xmllint --noout ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml > ~/ztvh/errorlog 2>&1

if grep -q "parser error" ~/ztvh/errorlog
then
	echo "- ERROR: XMLTV FILE VALIDATION FAILED! -"
	rm ~/ztvh/zattoo_fullepg.xml
	mv ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg_ERROR.xml
else
	echo "- XMLTV FILE VALIDATION SUCCEEDED! -" && echo ""
	rm ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg_ERROR.xml 2> /dev/null
	rm ~/ztvh/errorlog 2> /dev/null
fi

# #####################
# CLEAN UP WORKFOLDER #
# #####################

cd ~/ztvh/work
rm workfile* powerid progressbar 2> /dev/null
rm ~/ztvh/epg/stats2 2> /dev/null
sort -u ~/ztvh/epg/status -o ~/ztvh/epg/status

echo "--- DONE ---"
