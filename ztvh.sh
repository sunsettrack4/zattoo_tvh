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

clear

echo "                                                                        "
echo "ZattooUNLIMITED for VLC and tvheadend                                   "
echo "(c) 2017-2019 Jan-Luca Neumann                        I             +   "
echo "Script v0.5.4 2019/05/11 | Zattoo v2.13.1       I    I         +        "
echo "                                                 I  I             +     "
echo "                                                  II                    "
echo "ZZZZZZZZZ       AA     TTTTTTTTTT TTTTTTTTTT    888888        888888    "
echo "      ZZ        AA         TT         TT      88      88    88      88  "
echo "     ZZ        A  A        TT         TT     88        88  88        88 "
echo "    ZZ        AA  AA       TT         TT    88           888          88"
echo "   ZZ        AAAAAAAA      TT         TT    88           888          88"
echo "  ZZ        AA      AA     TT         TT     88        88  88        88 "
echo " ZZ         AA      AA     TT         TT      88      88    88      88  "
echo "ZZZZZZZZZ  AA        AA    TT         TT        888888        888888    "
echo ""
echo "                                                      ~ WATCH YOU WANT ~"
echo ""

# ##################
# CHECK CONDITIONS #
# ##################

#
# Existence of required programs
#

command -v dialog >/dev/null 2>&1 || { echo "dialog is required but it's not installed! Aborting." >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "curl is required but it's not installed! Aborting." >&2; exit 1; }
command -v phantomjs >/dev/null 2>&1 || { echo "PhantomJS is required but it's not installed!  Aborting." >&2; exit 1; }
command -v uni2ascii >/dev/null 2>&1 || { echo "uni2ascii is required but it's not installed!  Aborting." >&2; exit 1; }
command -v xmllint >/dev/null 2>&1 || { echo "libxml2-utils is required but it's not installed!  Aborting." >&2; exit 1; }
command -v perl >/dev/null 2>&1 || { echo "perl is required but it's not installed!  Aborting." >&2; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo "ffmpeg is required for watching Live TV but it's not installed!" && sleep 1s; }
command -v vlc >/dev/null 2>&1 || { echo "VLC is required but for watching Live TV on desktop but it's not installed!" && sleep 1s; }
command -v perldoc >/dev/null 2>&1 || { printf "\nperl-doc is required but it's not installed!" >&2; ERROR2="true"; }
command -v cpan >/dev/null 2>&1 || { printf "\ncpan is required but it's not installed!" >&2; ERROR2="true"; }

if command -v perldoc >/dev/null
then
	perldoc -l JSON >/dev/null 2>&1 || { printf "\nJSON module for perl is requried but not installed!" >&2; ERROR2="true"; }
	perldoc -l utf8 >/dev/null 2>&1 || { printf "\nuft8 module for perl is requried but not installed!" >&2; ERROR2="true"; }
else
	ERROR2="true"
fi

printf "Starting script..."
sleep 2s


#
# Existence of internet connectivity
#

if ! ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2> /dev/null
then
	printf "\r- ERROR: NO INTERNET CONNECTION AVAILABLE! -\n"
	exit 1
else
	curl --silent -H "user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36" https://goo.gl/iyX1KE > /dev/null
fi


#
# Existence of all required scripts and its executable permissions
#

# FOLDER + FILES missing

if ls -ld ~/ztvh | grep -q "drwxrwxrwx" 2> /dev/null
then
	cd ~/ztvh
elif [ -e ~/ztvh ]
then
	printf "\r- ERROR: SCRIPT FOLDER DOES NOT HAVE THE CORRECT PERMISSION VALUES! -\n"
	if chmod 0777 ~/ztvh 2> /dev/null
	then
		echo "Permission issue fixed, please restart the script to proceed."
	fi
	exit 1
else
	printf "\r- ERROR: SCRIPT FOLDER NOT EXISTING IN HOME DIRECTORY! -\n"
	exit 1
fi


# FILES missing

if [ ! -e ztvh.sh ]
then
	printf "\r- ERROR: MAIN SCRIPT MUST BE LOCATED IN MAIN FOLDER! -\n"
	exit 1
elif [ ! -x ztvh.sh ]
then
	printf "\r- ERROR: MAIN SCRIPT IS NOT EXECUTABLE! -\n"
	if chmod 0777 ztvh.sh 2> /dev/null
	then
		echo "Permission issue fixed, please restart the script to proceed."
	fi
	exit 1
fi

if chmod 0777 ~/ztvh/* 2> /dev/null
then :
else
	printf "\r- WARNING: FILE PERMISSIONS COULD NOT BE SET! -\n"
fi

if [ ! -e save_page.js ]
then
	printf "\rMissing file: save_page.js\n"
	touch fakefile
elif [ ! -x save_page.js ]
then
	printf "\rFile not executable: savepage.js\n"
	touch fakefile
fi

if [ ! -e zguide_dl.sh ]
then
	printf "\rMissing file: zguide_dl.sh\n"
	touch fakefile
elif [ ! -x zguide_dl.sh ]
then
	printf "\rFile not executable: zguide_dl.sh\n"
	touch fakefile
fi

if [ ! -e zguide_fc.sh ]
then
	printf "\rMissing file: zguide_fc.sh\n"
	touch fakefile
elif [ ! -x zguide_fc.sh ]
then
	printf "\rFile not executable: zguide_fc.sh\n"
	touch fakefile
fi

if [ ! -e zguide_pc.sh ]
then
	printf "\rMissing file: zguide_pc.sh\n"
	touch fakefile
elif [ ! -x zguide_pc.sh ]
then
	printf "\rFile not executable: zguide_pc.sh\n"
	touch fakefile
fi

if [ ! -e zguide_su.sh ]
then
	printf "\rMissing file: zguide_su.sh\n"
	touch fakefile
elif [ ! -x zguide_su.sh ]
then
	printf "\rFile not executable: zguide_su.sh\n"
	touch fakefile
fi

if [ ! -e zguide_xmltv.sh ]
then
	printf "\rMissing file: zguide_xmltv.sh\n"
	touch fakefile
elif [ ! -x zguide_xmltv.sh ]
then
	printf "\rFile not executable: zguide_xmltv.sh\n"
	touch fakefile
fi

if [ ! -e zguide_xmltv_simple.sh ]
then
	printf "\rMissing file: zguide_xmltv_simple.sh\n"
	touch fakefile
elif [ ! -x zguide_xmltv_simple.sh ]
then
	printf "\rFile not executable: zguide_xmltv_simple.sh\n"
	touch fakefile
fi

if [ ! -e status.sh ]
then
	printf "\rMissing file: status.sh\n"
	touch fakefile
elif [ ! -x status.sh ]
then
	printf "\rFile not executable: status.sh\n"
	touch fakefile
fi

if [ ! -e live.sh ]
then
	printf "\rMissing file: live.sh\n"
	touch fakefile
elif [ ! -x live.sh ]
then
	printf "\rFile not executable: live.sh\n"
	touch fakefile
fi

if [ ! -e recordings.sh ]
then
	printf "\rMissing file: recordings.sh\n"
	touch fakefile
elif [ ! -x recordings.sh ]
then
	printf "\rFile not executable: recordings.sh\n"
	touch fakefile
fi

if [ ! -e zchannels.pl ]
then
	printf "\rMissing file: zchannels.pl\n"
	touch fakefile
elif [ ! -x zchannels.pl ]
then
	printf "\rFile not executable: zchannels.pl\n"
	touch fakefile
fi

# if [ ! -e txt.sh ]
# then
#	printf "\rMissing file: txt.sh\n"
#	touch fakefile
# elif [ ! -x txt.sh ]
# then
#	printf "\rFile not executable: txt.sh\n"
#	touch fakefile
# fi

if [ -e fakefile ]
then
	printf "\r- ERROR: FAILED TO LOAD REQUIRED SCRIPT(S)! -\n"
	rm fakefile
	exit 1
fi


#
# Further actions
#

export QT_QPA_PLATFORM=offscreen

rm -rf work 2> /dev/null
mkdir work
chmod 0777 work

mkdir user 2> /dev/null
chmod 0777 user


# ###############
# LOGIN PROCESS #
# ###############

cd work
echo "MENU" > value

# retrieve user data
until grep -q '"success": true' login.txt 2> /dev/null
do
	mkdir ~/ztvh/user 2> /dev/null
	touch ~/ztvh/user/userfile
	
	if tr '\n' ' ' < ~/ztvh/user/userfile | grep "provider" | grep "login" | grep -q "password"
	then
		if grep -q "insecure=ask" ~/ztvh/user/userfile
		then
			dialog --backtitle "[L41A0] ZATTOO UNLIMITED BETA > LOGIN" --title "[2] WARNING" --infobox "Please note that the server verification failed last time.\nYou can still connect to the IPTV web service, but the server can't be verified as secure due to a problem with the certificate.\n\nMore information: https://curl.haxx.se/docs/sslcerts.html\n\nPress [ENTER] to disable SSL verification.\nScript will proceed in 10 seconds." 13 70
			
			if read -t 10 -n1
			then
				sed -i "s/insecure=ask/insecure=true/g" ~/ztvh/user/userfile
			else
				sed -i "/insecure=ask/d" ~/ztvh/user/userfile
			fi
		fi
		
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			dialog --backtitle "[L41A0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "[1] WARNING" --infobox "SSL verification disabled!" 3 40
			sleep 3s
			dialog --backtitle "[L41W0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login to webservice..." 3 40
		else
			dialog --backtitle "[L41W0] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login to webservice..." 3 40
		fi
		
		provider=$(sed "2,5d;s/provider=//g" ~/ztvh/user/userfile)
		
		if [ -e ~/ztvh/user/session ]
		then
			session=$(<~/ztvh/user/session)
		fi

		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			curl -k -i -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" --data-urlencode "$(grep 'login=' ~/ztvh/user/userfile)" --data-urlencode "$(grep 'password=' ~/ztvh/user/userfile)" https://$provider/zapi/v2/account/login > login.txt 2> /dev/null
		else
			curl -i -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" --data-urlencode "$(grep 'login=' ~/ztvh/user/userfile)" --data-urlencode "$(grep 'password=' ~/ztvh/user/userfile)" https://$provider/zapi/v2/account/login > login.txt 2> /dev/null
		fi

		if grep -q '"success": true' login.txt
		then
			sed '/Set-cookie/!d' login.txt > workfile
			sed -i 's/expires.*//g' workfile
			sed -i 's/Set-cookie: //g' workfile
			sed -i 's/Set-cookie: //g' workfile
			tr -d '\n' < workfile > ~/ztvh/user/session
			sed -i 's/; Path.*//g' ~/ztvh/user/session
			session=$(<~/ztvh/user/session)
			sleep 1s
		elif grep -q '400 Bad Request' login.txt
		then
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then 
				dialog --backtitle "[L41E0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "ERROR" --infobox "Login failed!\n\nPress [1] to enter new password or\n      [2] to logout and delete all data.\n\nWindow will be closed in 10 seconds." 8 50
			else
				dialog --backtitle "[L41E0] ZATTOO UNLIMITED BETA > LOGIN" --title "ERROR" --infobox "Login failed!\n\nPress [1] to enter new password or\n      [2] to logout and delete all data.\n\nWindow will be closed in 10 seconds." 8 50
			fi
			
			read -t 10 -n1 n
			echo "EXIT" > fakefile
			
			case $n in
			1) 	if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					password=$(dialog --backtitle "[L4100] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "PASSWORD" --passwordbox "Please enter your (new) password.\nPress [ESC] or cancel to exit the script." 8 50 3>&1 1>&2 2>&3 3>&-)
				else
					password=$(dialog --backtitle "[L4100] ZATTOO UNLIMITED BETA > LOGIN" --title "PASSWORD" --passwordbox "Please enter your (new) password.\nPress [ESC] or cancel to exit the script." 8 50 3>&1 1>&2 2>&3 3>&-)
				fi
			
				if test $? -eq 0
				then
					sed -i "/password=/d" ~/ztvh/user/userfile
					echo "password=$password" >> ~/ztvh/user/userfile
					rm fakefile
				else
					rm fakefile
					clear
					exit 0
				fi;;
			2) 	dialog --backtitle "[L42W0] ZATTOO UNLIMITED BETA > LOGOUT" --title "LOGOUT" --infobox "Logging out..." 3 40
				rm fakefile
				cd ~/ztvh
				rm channels.m3u favorites.m3u chpipe.sh zattoo_fullepg.xml zattoo_ext_fullepg.xml -rf user -rf work -rf epg -rf logos -rf chpipe 2> /dev/null
				dialog --backtitle "[L42S0] ZATTOO UNLIMITED BETA > LOGOUT" --title "LOGOUT" --infobox "Logging out... DONE" 3 40
				sleep 2s
				clear
				exit 0;;
			esac
			
			if [ -e fakefile ]
			then
				clear
				exit 1
			fi
		elif grep -q '403 Forbidden' login.txt
		then
			sed "s/PROVIDER/$provider/g" ~/ztvh/save_page.js > ~/ztvh/work/save_page.js
			
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				dialog --backtitle "[L41C0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login to webservice..." 3 40
				
				if phantomjs -platform offscreen --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
				then
					if phantomjs --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
					then
						export QT_QPA_PLATFORM=phantom
						if phantomjs -platform phantom --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
						then
							dialog --backtitle "[L41F0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "FATAL ERROR [1]" --infobox "PhantomJS failed to start!" 3 40
							sleep 2s
							clear
							echo "ERROR: PhantomJS failed to start - script stopped."
							exit 1
						fi
					fi
				fi
			else
				dialog --backtitle "[L41C0] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login to webservice..." 3 40
				
				if phantomjs -platform offscreen ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
				then
					if phantomjs ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
					then
						export QT_QPA_PLATFORM=phantom
						if phantomjs -platform phantom ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
						then
							dialog --backtitle "[L41F0] ZATTOO UNLIMITED BETA > LOGIN" --title "FATAL ERROR [1]" --infobox "PhantomJS failed to start!" 3 40
							sleep 2s
							clear
							echo "ERROR: PhantomJS failed to start - script stopped."
							exit 1
						fi
					fi
				fi
			fi
			
			rm fakefile 2> /dev/null
			touch fakefile
			
			until grep -q "beaker.session.id" cookie_list
			do
				if grep 'TRY' fakefile | wc -l | grep -q 3 2> /dev/null
				then
					if grep -q "insecure=true" ~/ztvh/user/userfile
					then
						dialog --backtitle "[L41F0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "[2] FATAL ERROR" --infobox "Service unavailable! Please try again later!" 5 50
					else
						dialog --backtitle "[L41F0] ZATTOO UNLIMITED BETA > LOGIN" --title "[2] FATAL ERROR" --infobox "Service unavailable! Please try again later!" 5 50
					fi
					sleep 2s
					exit 1
				fi
				
				echo "TRY" >> fakefile
				sleep 1s
				
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then 
					dialog --backtitle "[L41D0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --infobox "Waiting for required cookie data." 3 50
				else
					dialog --backtitle "[L41D0] ZATTOO UNLIMITED BETA > LOGIN" --infobox "Waiting for required cookie data." 3 50
				fi
				sleep 1s
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then 
					dialog --backtitle "[L41D0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --infobox "Waiting for required cookie data.." 3 50
				else
					dialog --backtitle "[L41D0] ZATTOO UNLIMITED BETA > LOGIN" --infobox "Waiting for required cookie data.." 3 50
				fi
				sleep 1s
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then 
					dialog --backtitle "[L41D0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --infobox "Waiting for required cookie data..." 3 50
				else
					dialog --backtitle "[L41D0] ZATTOO UNLIMITED BETA > LOGIN" --infobox "Waiting for required cookie data..." 3 50
				fi
									
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					if phantomjs -platform offscreen --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
					then
						if phantomjs --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
						then
							export QT_QPA_PLATFORM=phantom
							if phantomjs -platform phantom --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
							then
								dialog --backtitle "[L41F0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "FATAL ERROR [3]" --infobox "PhantomJS failed to start!" 3 50
								clear
								echo "ERROR: PhantomJS failed to start - script stopped."
								exit 1
							fi
						fi
					fi
				else
					if phantomjs -platform offscreen ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
					then
						if phantomjs ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
						then
							export QT_QPA_PLATFORM=phantom
							if phantomjs -platform phantom ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
							then
								dialog --backtitle "[L41F0] ZATTOO UNLIMITED BETA > LOGIN" --title "FATAL ERROR [3]" --infobox "PhantomJS failed to start!" 3 50
								sleep 2s
								clear
								echo "ERROR: PhantomJS failed to start - script stopped."
								exit 1
							fi
						fi
					fi
				fi
			done
			grep "beaker.session.id" cookie_list > ~/ztvh/user/session
			session=$(<~/ztvh/user/session)
		elif curl -v --silent https://$provider/ 2>&1 | grep -q -E "server certificate verification failed|SSL certificate problem" 2> /dev/null
		then
			echo "insecure=ask" >> ~/ztvh/user/userfile
			dialog --backtitle "[L41F0] ZATTOO UNLIMITED BETA > LOGIN" --title "[4] FATAL ERROR" --infobox "Server certificate verification failed!" 3 50
			sleep 2s
			exit 1
		else
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				dialog --backtitle "[L41F0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "[5] FATAL ERROR" --infobox "Service unavailable! Please try again later!" 5 50
			else
				dialog --backtitle "[L41F0] ZATTOO UNLIMITED BETA > LOGIN" --title "[5] FATAL ERROR" --infobox "Service unavailable! Please try again later!" 5 50
			fi
			sleep 2s
			exit 1
		fi
	else
		mkdir ~/ztvh/user 2> /dev/null
		
		#
		# PROVIDER
		#
		
		# L1000 MENU OVERLAY
		echo 'dialog --backtitle "[L1000] ZATTOO UNLIMITED BETA > PROVIDER" --title "PROVIDER" --menu "Please choose your IPTV provider based on Zattoo services:" 10 50 10 \' > menu
		
		# L1100 ZATTOO.COM
		echo '	1 "ZATTOO   | Zattoo Germany / Switzerland  " \' >> menu
		
		# L1200 RESELLER
		echo '	2 "RESELLER | 1&1 TV, EWE TV, NetCologne ..." \' >> menu

		echo "2>value" >> menu
		
		if grep -q "MENU" value 2> /dev/null
		then
			rm cookie_list ~/ztvh/user/userfile 2> /dev/null
			bash menu
			
			if test $? -eq 0
			then
				true
			else
				dialog --backtitle "[L1X00] ZATTOO UNLIMITED BETA"  --title "EXIT" --yesno "Do you want to quit?" 5 30
						
				response=$?
				
				if [ $response = 1 ]
				then
					echo "MENU" > value
				elif [ $response = 0 ]
				then
					clear
					exit 0
				else
					echo "MENU" > value
				fi
			fi
		fi

			#
			# L1100 PROVIDER CHECK
			#
			
			if grep -q -E "1|2" value 2> /dev/null
			then
				until grep -q "beaker.session.id" cookie_list 2> /dev/null
				do
					rm ~/ztvh/user/session 2> /dev/null
					
					if grep -q "insecure=ask" ~/ztvh/user/userfile 2> /dev/null
					then
						dialog --backtitle "[L11A0] ZATTOO UNLIMITED BETA > PROVIDER" --title "WARNING" --yesno "Please note that the server certification verification failed.\nYou are able to connect to the IPTV web service, but the server can't be verified as secure due to a problem with the certificate.\n\nMore information: https://curl.haxx.se/docs/sslcerts.html\n\nDo you want to disable SSL verification?" 13 70
					elif grep -q "1" value 
					then
						echo "provider=zattoo.com" > ~/ztvh/user/userfile
						provider=$(echo "zattoo.com")
					else
						provider=$(dialog --backtitle "[L1100] ZATTOO UNLIMITED BETA > PROVIDER" --title "PROVIDER" --inputbox "\nPlease enter the domain of your IPTV provider,\ne.g. '1und1.tv', 'tvonline.ewe.de' ..." 9 50 3>&1 1>&2 2>&3 3>&-)
					fi
					
					if test $? -eq 0
					then
						sed -i "s/insecure=ask/insecure=true/g" ~/ztvh/user/userfile 2> /dev/null
						
						if echo "$provider" | grep -q "zattoo.com"
						then
							echo "1" > value
						fi
						
						until echo "$provider" | grep -q ".*[.][cdnt][cehov]"
						do
							sed -i '/provider/d' ~/ztvh/user/userfile
							provider=$(dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "PROVIDER" --inputbox "PROVIDER invalid! | Syntax: domain.xxx\nPlease enter the domain of your IPTV provider,\ne.g. '1und1.tv', 'tvonline.ewe.de' ..." 9 50 3>&1 1>&2 2>&3 3>&-)
					
							if test $? -eq 0
							then 
								sed -i "s/insecure=ask/insecure=true/g" ~/ztvh/user/userfile 2> /dev/null
								
								if echo "$provider" | grep -q "zattoo.com"
								then
									echo "1" > value
								fi
							else
								echo "MENU" > value
								echo "beaker.session.id=dummy" > cookie_list
								provider=$(echo "dummy.com")
							fi
						done
					else
						echo "beaker.session.id=dummy" > cookie_list
						echo "MENU" > value
					fi
					
					if ! grep -q "beaker.session.id=dummy" cookie_list 2> /dev/null
					then	
						if grep -q "insecure=true" ~/ztvh/user/userfile 2> /dev/null
						then 
							dialog --backtitle "[L11W0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Checking availability of chosen provider..." 3 50
						else
							dialog --backtitle "[L11W0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Checking availability of chosen provider..." 3 50
						fi
						
						if ! grep -q "insecure=true" ~/ztvh/user/userfile 2> /dev/null
						then
							echo "provider=$provider" > ~/ztvh/user/userfile
						fi
						
						sed "s/PROVIDER/$provider/g" ~/ztvh/save_page.js > ~/ztvh/work/save_page.js 2> /dev/null
						
						if grep -q "insecure=true" ~/ztvh/user/userfile 2> /dev/null
						then
							if phantomjs -platform offscreen --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
							then
								if phantomjs --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
								then
									export QT_QPA_PLATFORM=phantom
									if phantomjs -platform phantom --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
									then
										dialog --backtitle "[L11F0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --title "[1] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
										sleep 2s
										clear
										echo "ERROR: PhantomJS failed to start - script stopped."
										exit 1
									fi
								fi
							fi
						else
							if phantomjs -platform offscreen ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
							then
								if phantomjs ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
								then
									export QT_QPA_PLATFORM=phantom
									if phantomjs -platform phantom ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
									then
										dialog --backtitle "[L11F0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[1] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
										sleep 2s
										clear
										echo "ERROR: PhantomJS failed to start - script stopped."
										exit 1
									fi
								fi
							fi
						fi
						
						if ! grep -q "beaker.session.id" cookie_list
						then
							if grep -q "uuid" cookie_list
							then
								if grep -q "insecure=true" ~/ztvh/user/userfile
								then 
									dialog --backtitle "[L11C0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data" 3 50
								else
									dialog --backtitle "[L11C0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data" 3 50
								fi
								
								rm fakefile 2> /dev/null
								touch fakefile
								
								until grep -q "beaker.session.id" cookie_list
								do
									if grep 'TRY' fakefile | wc -l | grep -q 3 2> /dev/null
									then
										if grep -q "1" value
										then
											echo "beaker.session.id=dummy1" > cookie_list
											echo "MENU" > value
										else
											echo "beaker.session.id=dummy2" > cookie_list
											echo "2" > value
										fi
									elif grep -q "uuid" cookie_list
									then
										echo "TRY" >> fakefile
										sleep 1s
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then 
											dialog --backtitle "[L11C0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data." 3 50
										else
											dialog --backtitle "[L11C0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data." 3 50
										fi
										sleep 1s
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then 
											dialog --backtitle "[L11C0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data.." 3 50
										else
											dialog --backtitle "[L11C0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data.." 3 50
										fi
										sleep 1s
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then 
											dialog --backtitle "[L11C0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data..." 3 50
										else
											dialog --backtitle "[L11C0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data..." 3 50
										fi
										
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then
											if phantomjs -platform offscreen --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
											then
												if phantomjs --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
												then
													export QT_QPA_PLATFORM=phantom 
													if phantomjs -platform phantom --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
													then
														dialog --backtitle "[L11F0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --title "[2] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
														sleep 2s
														clear
														echo "ERROR: PhantomJS failed to start - script stopped."
														exit 1
													fi
												fi
											fi
										else
											if phantomjs -platform offscreen ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
											then
												if phantomjs ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
												then
													export QT_QPA_PLATFORM=phantom 
													if phantomjs -platform phantom ~/ztvh/work/save_page.js https://$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
													then
														dialog --backtitle "[L11F0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[2] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
														sleep 2s
														clear
														echo "ERROR: PhantomJS failed to start - script stopped."
														exit 1
													fi
												fi
											fi
										fi
									else
										echo "beaker.session.id=dummy" > cookie_list
									fi
								done
								
								if grep -q "beaker.session.id=dummy[1-2]" cookie_list
								then
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[1] ERROR" --msgbox "Failed to load Session ID!" 5 50
								elif grep -q "beaker.session.id=dummy" cookie_list
								then
									sed -i "/beaker.session.id/d" cookie_list
								else
									rm fakefile 2> /dev/null
								fi
								
							elif ! grep -q "www." ~/ztvh/work/save_page.js
							then
								sed -i "s/https:\/\//&www./g" ~/ztvh/work/save_page.js
								sed -i "s/provider=/&www./g" ~/ztvh/user/userfile
																
								if grep -q "insecure=true" ~/ztvh/user/userfile
								then
									dialog --backtitle "[L11R0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Checking availability of chosen provider..." 3 50
									
									if phantomjs -platform offscreen --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
									then
										if phantomjs --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
										then
											export QT_QPA_PLATFORM=phantom 
											if phantomjs -platform phantom --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
											then
												dialog --backtitle "[L11F0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --title "[3] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
												sleep 2s
												clear
												echo "ERROR: PhantomJS failed to start - script stopped."
												exit 1
											fi
										fi
									fi
								else
									dialog --backtitle "[L11R0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Checking availability of chosen provider..." 3 50
									
									if phantomjs -platform offscreen ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
									then
										if phantomjs ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
										then
											export QT_QPA_PLATFORM=phantom 
											if phantomjs -platform phantom ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
											then
												dialog --backtitle "[L11F0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[3] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
												sleep 2s
												clear
												echo "ERROR: PhantomJS failed to start - script stopped."
												exit 1
											fi
										fi
									fi
								fi
							fi
						fi
						
						if ! grep -q "beaker.session.id" cookie_list
						then
							if grep -q "uuid" cookie_list
							then
								if grep -q "insecure=true" ~/ztvh/user/userfile
								then 
									dialog --backtitle "[L11D0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data" 3 50
								else
									dialog --backtitle "[L11D0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data" 3 50
								fi
								
								rm fakefile 2> /dev/null
								touch fakefile
								
								until grep -q "beaker.session.id" cookie_list
								do
									if grep 'TRY' fakefile | wc -l | grep -q 3 2> /dev/null
									then
										if grep -q "1" value
										then
											echo "beaker.session.id=dummy1" > cookie_list
											echo "MENU" > value
										else
											echo "beaker.session.id=dummy2" > cookie_list
											echo "2" > value
										fi
									elif grep -q "uuid" cookie_list
									then
										echo "TRY" >> fakefile
										sleep 1s
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then 
											dialog --backtitle "[L11D0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data." 3 50
										else
											dialog --backtitle "[L11D0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data." 3 50
										fi
										sleep 1s
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then 
											dialog --backtitle "[L11D0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data.." 3 50
										else
											dialog --backtitle "[L11D0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data.." 3 50
										fi
										sleep 1s
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then 
											dialog --backtitle "[L11D0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data..." 3 50
										else
											dialog --backtitle "[L11D0] ZATTOO UNLIMITED BETA > PROVIDER" --infobox "Waiting for required cookie data..." 3 50
										fi
										
										if grep -q "insecure=true" ~/ztvh/user/userfile
										then
											if phantomjs -platform offscreen --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
											then
												if phantomjs --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
												then
													export QT_QPA_PLATFORM=phantom 
													if phantomjs -platform phantom --ignore-ssl-errors=true ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
													then
														dialog --backtitle "[L11F0] [INSECURE] ZATTOO UNLIMITED BETA > PROVIDER" --title "[4] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
														sleep 2s
														clear
														echo "ERROR: PhantomJS failed to start - script stopped."
														exit 1
													fi
												fi
											fi
										else
											if phantomjs -platform offscreen ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
											then
												if phantomjs ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
												then
													export QT_QPA_PLATFORM=phantom 
													if phantomjs -platform phantom ~/ztvh/work/save_page.js https://www.$provider/login 2>&1 >cookie_list | grep -q "This application failed to start"
													then
														dialog --backtitle "[L11F0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[4] FATAL ERROR" --infobox "PhantomJS failed to start!" 3 50
														sleep 2s
														clear
														echo "ERROR: PhantomJS failed to start - script stopped."
														exit 1
													fi
												fi
											fi
										fi
									else
										echo "beaker.session.id=dummy" > cookie_list
									fi
								done
								
								if grep -q "beaker.session.id=dummy[1-2]" cookie_list
								then
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[2] ERROR" --msgbox "Failed to load Session ID!" 5 50
								elif grep -q "beaker.session.id=dummy" cookie_list
								then
									sed -i "/beaker.session.id/d" cookie_list
								else
									rm fakefile 2> /dev/null
								fi
								
							elif echo "$provider" | grep -q "www."
							then
								if curl -v --silent https://$provider/ 2>&1 | grep -q -E "server certificate verification failed|SSL certificate problem" 2> /dev/null
								then
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[3] ERROR" --infobox "Server certificate verification failed!" 3 50
									sleep 2s
									echo "insecure=ask" >> ~/ztvh/user/userfile
									
									if grep -q "1" value
									then
										echo "beaker.session.id=dummy" > cookie_list
										echo "MENU" > value
									else
										echo "2" > value
									fi
								elif ! ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2> /dev/null
								then
									dialog --backtitle "[L11F0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[5] FATAL ERROR" --msgbox "Internet connection unavailable! Please retry later!" 5 60
									exit 1
								else
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[4] ERROR" --msgbox "Service unavailable!" 5 50
									
									if grep -q "1" value
									then
										echo "beaker.session.id=dummy" > cookie_list
										echo "MENU" > value
									else
										echo "2" > value
									fi
								fi
							elif echo "$(<~/ztvh/user/userfile)" | grep -q "www."
							then
								if curl -v --silent https://www.$provider/ 2>&1 | grep -q -E "server certificate verification failed|SSL certificate problem" 2> /dev/null
								then
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[5] ERROR" --infobox "Server certificate verification failed!" 3 50
									sleep 2s
									echo "insecure=ask" >> ~/ztvh/user/userfile
									sed -i "s/www.//g" ~/ztvh/user/userfile
									sed -i "s/www.//g" ~/ztvh/work/save_page.js
									
									if grep -q "1" value
									then
										echo "beaker.session.id=dummy" > cookie_list
										echo "MENU" > value
									else
										echo "2" > value
									fi
								elif ! ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2> /dev/null
								then
									dialog --backtitle "[L11F0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[6] FATAL ERROR" --msgbox "Internet connection unavailable! Please retry later!" 5 60
									exit 1
								else
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[6] ERROR" --msgbox "Service unavailable!" 5 50
									
									if grep -q "1" value
									then
										echo "beaker.session.id=dummy" > cookie_list
										echo "MENU" > value
									else
										echo "2" > value
									fi
								fi
							else
								if curl -v --silent https://$provider/ 2>&1 | grep -q -E "server certificate verification failed|SSL certificate problem" 2> /dev/null
								then
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[7] ERROR" --infobox "Server certificate verification failed!" 3 50
									sleep 2s
									echo "insecure=ask" >> ~/ztvh/user/userfile
									sed -i "s/www.//g" ~/ztvh/user/userfile
									sed -i "s/www.//g" ~/ztvh/work/save_page.js
									
									if grep -q "1" value
									then
										echo "beaker.session.id=dummy" > cookie_list
										echo "MENU" > value
									else
										echo "2" > value
									fi
								elif ! ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2> /dev/null
								then
									dialog --backtitle "[L11F0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[7] FATAL ERROR" --msgbox "Internet connection unavailable! Please retry later!" 5 60
									exit 1
								else
									dialog --backtitle "[L11E0] ZATTOO UNLIMITED BETA > PROVIDER" --title "[8] ERROR" --msgbox "Service unavailable!" 5 50
									
									if grep -q "1" value
									then
										echo "beaker.session.id=dummy" > cookie_list
										echo "MENU" > value
									else
										echo "2" > value
									fi
								fi
							fi
						fi
					fi
					
					if grep -q "beaker.session.id=dummy2" cookie_list 2> /dev/null
					then
						sed -i "/beaker.session.id/d" cookie_list 2> /dev/null
					fi
				done
				grep "beaker.session.id" cookie_list > ~/ztvh/user/session
			fi
			
			
		#
		# L2100 ZATTOO EMAIL ADDRESS
		#
		
		if grep -q "1" value 2> /dev/null
		then
			sed -i "s/provider=www.zattoo.com/provider=zattoo.com/g" ~/ztvh/user/userfile 2> /dev/null
			sed -i "s/https:\/\/www.zattoo.com/https:\/\/zattoo.com/g" ~/ztvh/work/save_page.js 2> /dev/null
			provider=$(echo "zattoo.com")
			sed -i "/login=/d" ~/ztvh/user/userfile 2> /dev/null
			until grep -q '[A-Za-z0-9]@.*[A-Za-z0-9].*[.][a-z][a-z]' ~/ztvh/user/userfile
			do
				sed -i '/login/d' ~/ztvh/user/userfile
				
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					login=$(dialog --backtitle "[L2100] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --inputbox "\nPlease enter your email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
				else
					login=$(dialog --backtitle "[L2100] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --inputbox "\nPlease enter your email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
				fi
				
				if test $? -eq 0
				then 
					echo "login=$login" >> ~/ztvh/user/userfile
					echo "PASSI" > value
				else
					echo "MENU" > value
					echo "dummy@dummy.dummy" > ~/ztvh/user/userfile
				fi
				
				until grep -q '[A-Za-z0-9]@.*[A-Za-z0-9].*[.][a-z][a-z]' ~/ztvh/user/userfile
				do
					sed -i '/login/d' ~/ztvh/user/userfile
					
					if grep -q "insecure=true" ~/ztvh/user/userfile
					then
						login=$(dialog --backtitle "[L21E0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --inputbox "EMAIL invalid! | Syntax: name@domain.xxx\nPlease enter your email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
					else
						login=$(dialog --backtitle "[L21E0] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --inputbox "EMAIL invalid! | Syntax: name@domain.xxx\nPlease enter your email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
					fi
					
					if test $? -eq 0
					then 
						echo "login=$login" >> ~/ztvh/user/userfile
						echo "PASSI" > value
					else
						echo "MENU" > value
						echo "dummy@dummy.dummy" > ~/ztvh/user/userfile
					fi
				done
			done
		
		#
		# L2200 RESELLER LOGIN
		#
		
		elif grep -q "2" value 2> /dev/null
		then
			sed -i "/login=/d" ~/ztvh/user/userfile 2> /dev/null
			
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				login=$(dialog --backtitle "[L2200] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --inputbox "\nPlease enter your username or email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
			else
				login=$(dialog --backtitle "[L2200] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --inputbox "\nPlease enter your username or email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
			fi
			
			if test $? -eq 0
			then 
				echo "login=$login" >> ~/ztvh/user/userfile
				echo "PASS-II" > value
			else
				echo "MENU" > value
				echo "DUMMY" > checkfile
			fi
			
			if [ ! -e checkfile ]
			then
				grep "login=" ~/ztvh/user/userfile > checkfile
				sed -i "s/login=//g" checkfile
			fi
						
			until grep -q "[:punct:A-Za-z0-9]" checkfile
			do
				sed -i '/login/d' ~/ztvh/user/userfile
				
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					login=$(dialog --backtitle "[L22E0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --inputbox "No input detected!\nPlease enter your username or email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
				else
					login=$(dialog --backtitle "[L22E0] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --inputbox "No input detected!\nPlease enter your username or email address:" 8 50 3>&1 1>&2 2>&3 3>&-)
				fi
				
				if test $? -eq 0
				then 
					echo "login=$login" >> ~/ztvh/user/userfile
					echo "PASS-II" > value
					grep "login=" ~/ztvh/user/userfile > checkfile
					sed -i "s/login=//g" checkfile
				else
					echo "MENU" > value
					echo "DUMMY" > checkfile
				fi
			done
			
			rm checkfile
		fi
		
		#
		# L3100 ZATTOO PASSWORD
		#
		
		if grep -q "PASSI" value 2> /dev/null
		then
			
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				password=$(dialog --backtitle "[L3100] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --passwordbox "EMAIL: $login \nPlease enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
			else
				password=$(dialog --backtitle "[L3100] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --passwordbox "EMAIL: $login \nPlease enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
			fi
			
			if test $? -eq 0
			then 
				echo "password=$password" >> ~/ztvh/user/userfile
				echo "ID-ENTERED-1" > value
			else
				echo "1" > value
				echo "DUMMY" > checkfile
			fi
			
			if [ ! -e checkfile ]
			then
				grep "password=" ~/ztvh/user/userfile > checkfile
				sed -i "s/password=//g" checkfile
			fi
			
			until grep -q "[:punct:A-Za-z0-9]" checkfile
			do
				sed -i '/password/d' ~/ztvh/user/userfile
				
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					password=$(dialog --backtitle "[L31E0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --passwordbox "EMAIL: $login \nNo input detected! Please enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
				else
					password=$(dialog --backtitle "[L31E0] ZATTOO UNLIMITED BETA > LOGIN" --title "ZATTOO | LOGIN PAGE" --passwordbox "EMAIL: $login \nNo input detected! Please enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
				fi
				
				if test $? -eq 0
				then 
					echo "password=$password" >> ~/ztvh/user/userfile
					echo "ID-ENTERED-1" > value
					grep "password=" ~/ztvh/user/userfile > checkfile
					sed -i "s/password=//g" checkfile
				else
					echo "1" > value
					echo "DUMMY" > checkfile
				fi
			done
			
			rm checkfile
		
		#
		# L3200 RESELLER PASSWORD
		#
		
		elif grep -q "PASS-II" value 2> /dev/null
		then
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				password=$(dialog --backtitle "[L3200] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --passwordbox "LOGIN: $login \nPlease enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
			else
				password=$(dialog --backtitle "[L3200] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --passwordbox "LOGIN: $login \nPlease enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
			fi
			
			if test $? -eq 0
			then 
				echo "password=$password" >> ~/ztvh/user/userfile
				echo "ID-ENTERED-2" > value
			else
				echo "2" > value
				echo "DUMMY" > checkfile
			fi
			
			if [ ! -e checkfile ]
			then
				grep "password=" ~/ztvh/user/userfile > checkfile
				sed -i "s/password=//g" checkfile
			fi
			
			until grep -q "[:punct:A-Za-z0-9]" checkfile
			do
				sed -i '/password/d' ~/ztvh/user/userfile
				
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					password=$(dialog --backtitle "[L32E0] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --passwordbox "LOGIN: $login \nNo input detected! Please enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
				else
					password=$(dialog --backtitle "[L32E0] ZATTOO UNLIMITED BETA > LOGIN" --title "$provider | LOGIN PAGE" --passwordbox "LOGIN: $login \nNo input detected! Please enter your password:" 8 50 3>&1 1>&2 2>&3 3>&-)
				fi
				
				if test $? -eq 0
				then 
					echo "password=$password" >> ~/ztvh/user/userfile
					echo "ID-ENTERED-2" > value
					grep "password=" ~/ztvh/user/userfile > checkfile
					sed -i "s/password=//g" checkfile
				else
					echo "2" > value
					echo "DUMMY" > checkfile
				fi
			done
			
			rm checkfile
		fi
	fi

	if grep -q "ID-ENTERED" value 2> /dev/null
	then
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			dialog --backtitle "[L4W00] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login to webservice..." 3 40
		else
			dialog --backtitle "[L4W00] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login to webservice..." 3 40
		fi
	
		while grep -q "ID-ENTERED" value 2> /dev/null
		do
			session=$(<~/ztvh/user/session)
			provider=$(sed "2,5d;s/provider=//g" ~/ztvh/user/userfile)
		
			if grep -q "insecure=true" ~/ztvh/user/userfile
			then
				curl -k -i -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" --data-urlencode "$(grep 'login=' ~/ztvh/user/userfile)" --data-urlencode "$(grep 'password=' ~/ztvh/user/userfile)" https://$provider/zapi/v2/account/login > login.txt 2> /dev/null
			else
				curl -i -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" --data-urlencode "$(grep 'login=' ~/ztvh/user/userfile)" --data-urlencode "$(grep 'password=' ~/ztvh/user/userfile)" https://$provider/zapi/v2/account/login > login.txt 2> /dev/null
			fi

			if grep -q '"success": true' login.txt
			then
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					dialog --backtitle "[L4S00] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login successful!" 3 40
					sleep 1.5s
				else
					dialog --backtitle "[L4S00] ZATTOO UNLIMITED BETA > LOGIN" --title "LOGIN" --infobox "Login successful!" 3 40
					sleep 1.5s
				fi
				rm cookie_list
				sed '/Set-cookie/!d' login.txt > workfile
				sed -i 's/expires.*//g' workfile
				sed -i 's/Set-cookie: //g' workfile
				sed -i 's/Set-cookie: //g' workfile
				tr -d '\n' < workfile > ~/ztvh/user/session
				sed -i 's/; Path.*//g' ~/ztvh/user/session
				session=$(<~/ztvh/user/session)
				sleep 1s
				rm value
			elif grep -q '"success": false' login.txt
			then
				sed -i "/password=/d" ~/ztvh/user/userfile
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					dialog --backtitle "[L4E00] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "[1] ERROR" --msgbox "Login failed, please retry!" 5 40
				else
					dialog --backtitle "[L4E00] ZATTOO UNLIMITED BETA > LOGIN" --title "[1] ERROR" --msgbox "Login failed, please retry!" 5 40
				fi
				sed -i "s/ID-ENTERED-1/PASSI/g;s/ID-ENTERED-2/PASS-II/g" value
				sleep 1s
			elif grep -q "301 Moved Permanently" login.txt
			then
				sed -i "s/provider=/provider=www./g" ~/ztvh/user/userfile
				provider=$(sed "2,5d;s/provider=//g" ~/ztvh/user/userfile)
			elif [ ! -s login.txt ]
			then
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					dialog --backtitle "[L4E00] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "[2] ERROR" --msgbox "Service unavailable! Please try again later!" 5 50
					rm ~/ztvh/user/userfile
					echo "MENU" > value
				else
					dialog --backtitle "[L4E00] ZATTOO UNLIMITED BETA > LOGIN" --title "[2] ERROR" --msgbox "Service unavailable! Please try again later!" 5 50
					rm ~/ztvh/user/userfile
					echo "MENU" > value
				fi
			elif ! ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null 2> /dev/null
			then
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					dialog --backtitle "[L4F00] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "[1] FATAL ERROR" --msgbox "Internet connection unavailable! Please try again later!" 5 60
					rm ~/ztvh/user/userfile
				else
					dialog --backtitle "[L4F00] ZATTOO UNLIMITED BETA > LOGIN" --title "[1] FATAL ERROR" --msgbox "Internet connection unavailable! Please try again later!" 5 60
					rm ~/ztvh/user/userfile
				fi
				exit 1
			else
				if grep -q "insecure=true" ~/ztvh/user/userfile
				then
					dialog --backtitle "[L4F00] [INSECURE] ZATTOO UNLIMITED BETA > LOGIN" --title "[2] FATAL ERROR" --msgbox "Service unavailable! Please contact the developer!" 5 50
					rm ~/ztvh/user/userfile
				else
					dialog --backtitle "[L4F00] ZATTOO UNLIMITED BETA > LOGIN" --title "[2] FATAL ERROR" --msgbox "Service unavailable! Please contact the developer!" 5 50
					rm ~/ztvh/user/userfile
				fi
				exit 1
			fi
		done
	fi
done
	

# ##############
# CHANNEL LIST #
# ##############

cd ~/ztvh/work

if grep -q "insecure=true" ~/ztvh/user/userfile
then
	dialog --backtitle "[P1W00] [INSECURE] ZATTOO UNLIMITED BETA > CHANNELS" --title "PROCESSING" --infobox "Loading channel list..." 3 40
else
	dialog --backtitle "[P1W00] ZATTOO UNLIMITED BETA > CHANNELS" --title "PROCESSING" --infobox "Loading channel list..." 3 40
fi

sed 's/, "/\n/g' login.txt | grep "power_guide_hash" > powerid
sed -i 's/.*: "//g' powerid && sed -i 's/.$//g' powerid

powerid=$(<powerid)
session=$(<~/ztvh/user/session)
provider=$(sed "2,5d;s/provider=//g" ~/ztvh/user/userfile)

if grep -q "insecure=true" ~/ztvh/user/userfile
then
	curl -k -X GET --cookie "$session" https://$provider/zapi/v2/cached/channels/$powerid?details=False > channels_file 2> /dev/null
else
	curl -X GET --cookie "$session" https://$provider/zapi/v2/cached/channels/$powerid?details=False > channels_file 2> /dev/null
fi

if grep -q '"success": true' channels_file
then
	#
	# CREATE CHANNELS.M3U + PIPE SCRIPTS
	#
	
	mkdir ~/ztvh/chpipe 2> /dev/null
	chmod 0777 ~/ztvh/chpipe/* 2> /dev/null
	
	if [ ! -s ~/ztvh/user/options ]
	then
		echo "firstsetup=true" >> ~/ztvh/user/userfile
		echo "chpipe 4" > ~/ztvh/user/options
	elif ! grep -q "chpipe" ~/ztvh/user/options 2> /dev/null
	then
		echo "chpipe 4" >> ~/ztvh/user/options
	fi
	
	grep "provider=" ~/ztvh/user/userfile | sed "/^$/d;s/provider=//g" > provider
	perl ~/ztvh/zchannels.pl > ~/ztvh/channels.m3u
	rm channels_file provider 2> /dev/null
else
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		dialog --backtitle "[P1E00] [INSECURE] ZATTOO UNLIMITED BETA > CHANNELS" --title "ERROR" --infobox "Loading channel list... FAILED!" 3 50
	else
		dialog --backtitle "[P1E00] ZATTOO UNLIMITED BETA > CHANNELS" --title "ERROR" --infobox "Loading channel list... FAILED!" 3 50
	fi
	sleep 3s
	rm ~/ztvh/channels.m3u powerid login.txt 2> /dev/null
	exit 1
fi


# ###############
# FAVORITES     #
# ###############

cd ~/ztvh/work
session=$(<~/ztvh/user/session)
provider=$(sed "2,5d;s/provider=//g" ~/ztvh/user/userfile)

if grep -q "insecure=true" ~/ztvh/user/userfile
then
	dialog --backtitle "[P2W00] [INSECURE] ZATTOO UNLIMITED BETA > CHANNELS" --title "PROCESSING" --infobox "Loading favorites list..." 3 40
	curl -k -X GET --cookie "$session" https://$provider/zapi/channels/favorites > favorites_file 2> /dev/null
else
	dialog --backtitle "[P2W00] ZATTOO UNLIMITED BETA > CHANNELS" --title "PROCESSING" --infobox "Loading favorites list..." 3 40
	curl -X GET --cookie "$session" https://$provider/zapi/channels/favorites > favorites_file 2> /dev/null
fi

if grep -q '"success": true' favorites_file 2> /dev/null
then
	if grep -q '{"favorites": \["' favorites_file 2> /dev/null
	then
		sed -i -e 's/.*\["/"/g' -e 's/", "/"\n"/g' -e 's/"\].*/"/g' favorites_file
		sed ':a $!N;s/\npipe:\/\//pipe:\/\//;ta P;D' ~/ztvh/channels.m3u > workfile
		
		sed -i -e 's/.*/grep tvg-id=& workfile >> favorites.m3u/g' -e '1i#\!\/bin\/bash\n' favorites_file
		sed -i -e "s/tvg-id/'tvg-id/g" -e "s/ workfile/' workfile/g" favorites_file
		bash favorites_file 2> /dev/null
		
		sed -i -e 's/pipe:\/\/.*/\n&/g' -e '1i#EXTM3U' favorites.m3u
		sed -i 's/group-title="Zattoo"/group-title="Favorites"/g' favorites.m3u
		mv favorites.m3u ~/ztvh/favorites.m3u
		rm favorites_file workfile 2> /dev/null
	elif grep -q '{"favorites": \[\]' favorites_file 2> /dev/null
	then
		rm favorites_file ~/ztvh/favorites.m3u 2> /dev/null
	fi
else
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		dialog --backtitle "[P2E00] [INSECURE] ZATTOO UNLIMITED BETA > CHANNELS" --title "ERROR" --infobox "Loading favorites list... FAILED!" 3 50
	else
		dialog --backtitle "[P2E00] ZATTOO UNLIMITED BETA > CHANNELS" --title "ERROR" --infobox "Loading favorites list... FAILED!" 3 50
	fi
	sleep 2s
	rm favorites_file 2> /dev/null
fi


# ################
# NEW MENU       #
# ################

cd ~/ztvh/work

if [ ! -e ~/ztvh/user/options ]
then
	touch ~/ztvh/user/options
	echo "firstsetup=true" >> ~/ztvh/user/userfile
else
	if ! grep -q "chlogo [0-2]" ~/ztvh/user/options
	then
		echo "chlogo 0" >> ~/ztvh/user/options
	fi
	if ! grep -q -E "epgdata [0-9]-|epgdata 1[0-4]-" ~/ztvh/user/options
	then
		echo "epgdata 0-" >> ~/ztvh/user/options
	fi
	if ! grep -q "extepg [0-1]" ~/ztvh/user/options
	then
		if grep -q "zattoo.com" ~/ztvh/user/userfile
		then
			echo "extepg 1" >> ~/ztvh/user/options
		fi
	fi
	if ! grep -q "chpipe [0-4]" ~/ztvh/user/options
	then
		echo "chpipe 4" >> ~/ztvh/user/options
	fi
fi

if [ -e ~/ztvh/user/options ]
then
	if ! grep -q "firstsetup=true" ~/ztvh/user/userfile
	then
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			dialog --backtitle "[M1W00] [INSECURE] ZATTOO UNLIMITED BETA" --title "MAIN MENU" --infobox "Please press any button to enter the main menu.\n\nThe script will proceed in 5 seconds." 7 50
		else
			dialog --backtitle "[M1W00] ZATTOO UNLIMITED BETA" --title "MAIN MENU" --infobox "Please press any button to enter the main menu.\n\nThe script will proceed in 5 seconds." 7 50
		fi
		
		if read -t 5 -n1
		then
			echo "MAIN" > value
		fi
	else
		echo "MAIN" > value
	fi
	
	if grep -q "MAIN" value
	then
		echo "M1000" > value
		
		#
		# M1000 MAIN MENU
		#
		
		while grep -q "M1000" value
		do
		
		# M1000 MENU OVERLAY
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			echo 'dialog --backtitle "[M1000] ZATTOO UNLIMITED BETA" --title "MAIN MENU - INSECURE MODE" --menu "Welcome to Zattoo Unlimited! :)\n(c) 2017-2018 Jan-Luca Neumann\n\nIf you like this script, please support my work:\nhttps://paypal.me/sunsettrack4\n\nPlease choose a feature:" 19 55 10 \' > menu
		else
			echo 'dialog --backtitle "[M1000] ZATTOO UNLIMITED BETA" --title "MAIN MENU" --menu "Welcome to Zattoo Unlimited! :)\n(c) 2017-2018 Jan-Luca Neumann\n\nIf you like this script, please support my work:\nhttps://paypal.me/sunsettrack4\n\nPlease choose a feature:" 19 55 10 \' > menu
		fi
		
		# M1100 LIVE TV
		if xset q &>/dev/null
		then 
			if command -v ffmpeg >/dev/null
			then
				if command -v vlc >/dev/null
				then
					echo '	1 "LIVE TV" \' >> menu
				fi
			fi
		fi
		
		# M1200 PVR CLOUD
		if command -v ffmpeg >/dev/null
		then
			echo '	2 "PVR CLOUD" \' >> menu
		fi
		
		# M1300 TELETEXT
		# echo '	3 "TELETEXT" \' >> menu
		
		# M1400 SETTINGS
		echo '	4 "SETTINGS" \' >> menu
		
		# M1500 GRABBER
		echo '	5 "CONTINUE IN GRABBER MODE" \' >> menu
		
		# M1800 INSECURE MODE
		if grep -q "insecure=true" ~/ztvh/user/userfile
		then
			echo '	8 "DISABLE INSECURE MODE" \' >> menu
		fi
		
		# M1900 LOGOUT
		echo '	9 "LOGOUT AND DELETE DATA" \' >> menu
		
		echo "2>value" >> menu
		
		if ! grep -q "firstsetup=true" ~/ztvh/user/userfile
		then	
			bash menu
		else
			echo "4" > value
		fi
		
			#
			# M1100 LIVE TV
			#
			
			if grep -q "1" value
			then
				echo "M1100" > value
				
				while grep -q "M1100" value
				do
				bash ~/ztvh/live.sh
				
				#
				# M11X0 EXIT
				#
				
				if [ ! -s value ]
				then
					echo "M1000" > value
				fi
				done
			
			#
			# M1200 PVR CLOUD
			#
			
			elif grep -q "2" value
			then
				echo "M1200U" > value
				
				while grep -q "M1200" value
				do
				bash ~/ztvh/recordings.sh
				
				#
				# M12X0 EXIT
				#
				
				if [ ! -s value ]
				then
					echo "M1000" > value
				fi
				done
			
			#
			# M1300 TELETEXT
			#
			
			# elif grep -q "3" value
			# then
			#	echo "M1300" > value
			#	
			#	while grep -q "M1300" value
			#	do
			#	bash ~/ztvh/txt.sh
			#	
			#	#
			#	# M13X0 EXIT
			#	#
			#	
			#	if [ ! -s value ]
			#	then
			#		echo "M1000" > value
			#	fi
			#	done
			
			fi
			
			#
			# M1400 SETTINGS
			#
			
			if grep -q "4" value	
			then
				echo "M1400" > value
				
				while grep -q "M1400" value
				do
				
				# M1400 MENU OVERLAY
				if ! grep -q "firstsetup=true" ~/ztvh/user/userfile
				then
					echo 'dialog --backtitle "[M1400] ZATTOO UNLIMITED BETA > SETTINGS" --title "OPTIONS" --menu "Please choose a feature you want to change:" 11 50 10 \' > menu
				else
					echo 'dialog --backtitle "[M1400] ZATTOO UNLIMITED BETA > SETTINGS" --title "FIRST SETUP" --menu "Welcome to Zattoo Unlimited! :)\n\nPlease setup your script environment first to continue.\n\nHit <CANCEL> button to save your settings." 16 50 10 \' > menu
				fi
				
				# M1410 CHANNEL LOGO IMAGES
				if grep -q "chlogo 1" ~/ztvh/user/options
				then
					echo '	1 "CHANNEL LOGOS (white logos enabled)" \' >> menu
				elif grep -q "chlogo 2" ~/ztvh/user/options
				then
					echo '	1 "CHANNEL LOGOS (dark logos enabled)" \' >> menu
				elif grep -q "chlogo 0" ~/ztvh/user/options
				then
					echo '	1 "CHANNEL LOGOS (disabled)" \' >> menu
				else
					echo "chlogo 0" >> ~/ztvh/user/options
					echo '	1 "CHANNEL LOGOS (disabled)" \' >> menu
				fi
			
				# M1420 EPG GRABBER
				if grep -q "epgdata 1-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 1 day, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 1 day, extended)" \' >> menu
					fi
				elif grep -q "epgdata 2-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 2 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 2 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 3-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 3 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 3 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 4-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 4 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 4 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 5-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 5 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 5 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 6-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 6 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 6 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 7-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 7 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 7 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 8-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 8 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 8 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 9-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 9 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 9 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 10-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 10 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 10 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 11-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 11 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 11 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 12-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 12 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 12 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 13-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 13 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 13 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 14-" ~/ztvh/user/options
				then
					if grep -q "epgmode=simple" ~/ztvh/user/options
					then
						echo '	2 "EPG GRABBER (enabled: 14 days, simple)" \' >> menu
					else
						echo '	2 "EPG GRABBER (enabled: 14 days, extended)" \' >> menu
					fi
				elif grep -q "epgdata 0-" ~/ztvh/user/options
				then
					echo '	2 "EPG GRABBER (disabled)" \' >> menu
				else
					sed -i 's/epgdata.*//g' ~/ztvh/user/options
					sed -i '/^\s*$/d' ~/ztvh/user/options
					echo "epgdata 0-" >> ~/ztvh/user/options
					echo '	2 "EPG GRABBER (disabled)" \' >> menu
				fi
			
				# M1430 EXTERNAL EPG
				if grep -q "zattoo.com" ~/ztvh/user/userfile
				then
					if grep -q "extepg 0" ~/ztvh/user/options
					then
						echo '	3 "EPG DOWNLOADER (disabled)" \' >> menu
					elif grep -q "extepg 1" ~/ztvh/user/options
					then
						echo '	3 "EPG DOWNLOADER (enabled)" \' >> menu
					else
						echo '	3 "EPG DOWNLOADER (enabled)" \' >> menu
						sed -i 's/extepg.*//g' ~/ztvh/user/options
						sed -i '/^\s*$/d' ~/ztvh/user/options
						echo "extepg 1" >> ~/ztvh/user/options
					fi
				else
					sed -i 's/extepg.*//g' ~/ztvh/user/options
					sed -i '/^\s*$/d' ~/ztvh/user/options
					echo "extepg 0" >> ~/ztvh/user/options
				fi
			
				# M1440 STREAMING QUALITY
				if grep -q "chpipe 4" ~/ztvh/user/options
				then
					echo '	4 "STREAMING QUALITY (MAXIMUM @ 5-8 Mbit/s)" \' >> menu
				elif grep -q "chpipe 3" ~/ztvh/user/options
				then
					echo '	4 "STREAMING QUALITY (HIGH @ 3 Mbit/s)" \' >> menu
				elif grep -q "chpipe 2" ~/ztvh/user/options
				then
					echo '	4 "STREAMING QUALITY (MEDIUM @ 1,5 Mbit/s)" \' >> menu
				elif grep -q "chpipe 1" ~/ztvh/user/options
				then
					echo '	4 "STREAMING QUALITY (LOW @ 900 kbit/s)" \' >> menu
				elif grep -q "chpipe 0" ~/ztvh/user/options
				then
					echo '	4 "STREAMING QUALITY (MINIMUM @ 600 kbit/s)" \' >> menu
				else
					sed -i 's/chpipe.*//g' ~/ztvh/user/options
					sed -i '/^\s*$/d' ~/ztvh/user/options
					echo "chpipe 4" >> ~/ztvh/user/options
					echo '	4 "STREAMING QUALITY (MAXIMUM @ 3-8 Mbit/s)" \' >> menu
				fi
				
				echo "2>value" >> menu
			
				bash menu
				
					#
					# M1410 CHANNEL LOGO IMAGES
					#
					
					if grep -q "1" value	
					then
						grep "chlogo" ~/ztvh/user/options > recovery 2> /dev/null
						sed -i '/chlogo/d' ~/ztvh/user/options 2> /dev/null
				
						# M1410 MENU OVERLAY
						echo 'dialog --backtitle "[M1410] ZATTOO UNLIMITED BETA > SETTINGS > CHANNEL LOGOS" --title "CHANNEL LOGOS" --menu "Do you want to download and update the channel logo images from Zattoo?" 11 50 10 \' > menu
						
						# M1411 NO
						echo '	1 "NO" \' >> menu
						
						# M1412 YES - WHITE LOGOS
						echo '	2 "YES (for dark backgrounds)" \' >> menu
						
						# M1413 YES - DARK LOGOS
						echo '	3 "YES (for bright backgrounds)" \' >> menu
						
						echo "2>value" >> menu
			
						bash menu
						
							#
							# M1411 NO
							#

							if grep -q "1" value	
							then
								echo "chlogo 0" >> ~/ztvh/user/options
								dialog --backtitle "[M1411] ZATTOO UNLIMITED BETA > SETTINGS > CHANNEL LOGOS" --title "INFO" --msgbox "Channel logos disabled!" 5 30
								echo "M1400" > value
							
							#
							# M1412 YES - WHITE LOGOS
							#
							
							elif grep -q "2" value	
							then
								echo "chlogo 1" >> ~/ztvh/user/options
								dialog --backtitle "[M1412] ZATTOO UNLIMITED BETA > SETTINGS > CHANNEL LOGOS" --title "INFO" --msgbox "White channel logos for dark backgrounds enabled!" 5 60
								echo "M1400" > value
							
							#
							# M1413 YES - DARK LOGOS
							#

							elif grep -q "3" value	
							then
								echo "chlogo 2" >> ~/ztvh/user/options
								dialog --backtitle "[M1413] ZATTOO UNLIMITED BETA > SETTINGS > CHANNEL LOGOS" --title "INFO" --msgbox "Black channel logos for bright backgrounds enabled!" 5 60
								echo "M1400" > value
							
							#
							# M141X EXIT
							#
							
							elif [ ! -s value ]
							then
								echo "$(<recovery)" >> ~/ztvh/user/options
								echo "M1400" > value
							fi
					
					
					#
					# M1420 EPG GRABBER
					#
					
					elif grep -q "2" value	
					then
					
						echo "M1420" > value
						
						grep "epgdata" ~/ztvh/user/options > recovery 2> /dev/null
						sed -i '/epgdata/d' ~/ztvh/user/options 2> /dev/null
						
						while grep -q "M1420" value
						do
				
						# M1420 MENU OVERLAY
						dialog --backtitle "[M1420] ZATTOO UNLIMITED BETA > SETTINGS > EPG GRABBER" --title "EPG GRABBER" --inputbox "Please enter the number of days you want to retrieve the EPG information. (0=disable | 1-14=enable)" 10 46 2>value
						
						# M1421 DAY INPUT
						sed -i 's/.*/epgdata &-/g' value
						if grep -q "epgdata 0-" value
						then
							echo "epgdata 0-" >> ~/ztvh/user/options
							dialog --backtitle "[M1421] ZATTOO UNLIMITED BETA > SETTINGS > EPG GRABBER" --title "INFO" --msgbox "EPG grabber disabled!" 5 26 
							echo "M1400" > value
						elif grep -q -E "epgdata 1-" value
						then
							echo "$(<value)" >> ~/ztvh/user/options
							dialog --backtitle "[M1422] ZATTOO UNLIMITED BETA > SETTINGS > EPG GRABBER" --title "INFO" --msgbox "EPG grabber is enabled for 1 day!" 5 42
							echo "M1425" > value
						elif grep -q -E "epgdata [2-9]-|epgdata 1[0-4]-" value
						then
							echo "$(<value)" >> ~/ztvh/user/options
							dialog --backtitle "[M1423] ZATTOO UNLIMITED BETA > SETTINGS > EPG GRABBER" --title "INFO" --msgbox "EPG grabber is enabled for $(sed '/epgdata/!d;s/epgdata //g;s/-//g;' ~/ztvh/user/options) days!" 5 42
							echo "M1425" > value
						elif [ -s value ]
						then
							dialog --backtitle "[M1424] ZATTOO UNLIMITED BETA > SETTINGS > EPG GRABBER" --title "ERROR" --msgbox "Wrong input detected!" 5 30 
							echo "M1420" > value
						fi
						
						if grep -q "M1425" value
						then
							# M1425 MENU OVERLAY
							dialog --backtitle "[M1425] ZATTOO UNLIMITED BETA > SETTINGS > EPG GRABBER" --title "EPG GRABBER" --yesno "Do you want to save data/time by using simple grabber mode?\n(without description, credits, year etc.)" 7 46 2>value
						
							response=$?
						
							# M1426 NO
							if [ $response = 1 ]
							then
								sed -i "/epgmode=simple/d" ~/ztvh/user/options
								dialog --backtitle "[M1426] ZATTOO UNLIMITED BETA > SETTINGS > EPG DOWNLOADER" --title "INFO" --msgbox "EPG simple grabber mode disabled!" 5 40
								echo "M1400" > value
						
							# M1427 YES
							elif [ $response = 0 ] 
							then
								echo "epgmode=simple" >> ~/ztvh/user/options
								dialog --backtitle "[M1427] ZATTOO UNLIMITED BETA > SETTINGS > EPG DOWNLOADER" --title "INFO" --msgbox "EPG simple grabber mode enabled!" 5 40
								echo "M1400" > value
							
							# M1428 EXIT
							elif [ $response = 255 ]
							then
								dialog --backtitle "[M1428] ZATTOO UNLIMITED BETA > SETTINGS > EPG DOWNLOADER" --title "INFO" --msgbox "No changes applied!" 5 30
								echo "M1400" > value
							fi
						fi
						
						#
						# M142X EXIT
						#
						
						if [ ! -s value ]
						then
							echo "$(<recovery)" >> ~/ztvh/user/options
							echo "M1400" > value
						fi
						done
						
					#
					# EPG DOWNLOADER
					#
					
					elif grep -q "3" value	
					then
						grep "extepg" ~/ztvh/user/options > recovery 2> /dev/null
						sed -i '/extepg/d' ~/ztvh/user/options 2> /dev/null
					
						# M1430 MENU OVERLAY
						dialog --backtitle "[M1430] ZATTOO UNLIMITED BETA > SETTINGS > EPG DOWNLOADER" --title "EPG DOWNLOADER" --yesno "Do you want to download the EPG data from GitHub?" 5 60
						
						response=$?
						
						# M1431 NO
						if [ $response = 1 ]
						then
							dialog --backtitle "[M1431] ZATTOO UNLIMITED BETA > SETTINGS > EPG DOWNLOADER" --title "INFO" --msgbox "EPG Downloader disabled!" 5 30
							echo "extepg 0" >> ~/ztvh/user/options
							echo "M1400" > value
						
						# M1432 YES
						elif [ $response = 0 ] 
						then
							dialog --backtitle "[M1432] ZATTOO UNLIMITED BETA > SETTINGS > EPG DOWNLOADER" --title "INFO" --msgbox "EPG Downloader enabled!" 5 30
							echo "extepg 1" >> ~/ztvh/user/options
							echo "M1400" > value
							
						# M1433 EXIT
						elif [ $response = 255 ]
						then
							dialog --backtitle "[M1433] ZATTOO UNLIMITED BETA > SETTINGS > EPG DOWNLOADER" --title "INFO" --msgbox "No changes applied!" 5 30
							 echo "$(<recovery)" >> ~/ztvh/user/options
							 echo "M1400" > value
						fi
						
					#
					# M1440 STREAMING QUALITY
					#
					
					elif grep -q "4" value	
					then
						grep "chpipe" ~/ztvh/user/options > recovery 2> /dev/null
						sed -i '/chpipe/d' ~/ztvh/user/options 2> /dev/null
				
						# M1440 MENU OVERLAY
						echo 'dialog --backtitle "[M1440] ZATTOO UNLIMITED BETA > SETTINGS > STREAMING QUALITY" --title "STREAMING QUALITY" --menu "Please choose the streaming quality you want to use." 13 50 10 \' > menu
						
						# M1441 MINIMUM
						echo '	1 "MINIMUM | 600 kbit/s" \' >> menu
						
						# M1442 LOW
						echo '	2 "LOW     | 900 kbit/s" \' >> menu
						
						# M1443 MEDIUM
						echo '	3 "MEDIUM  | 1,5 Mbit/s" \' >> menu
						
						# M1444 HIGH
						echo '	4 "HIGH    | 3 Mbit/s" \' >> menu
						
						# M1445 MINIMUM
						echo '	5 "MAXIMUM | 5-8 Mbit/s" \' >> menu
						
						echo "2>value" >> menu
			
						bash menu
						
						#
						# M1441 MINIMUM
						#

						if grep -q "1" value	
						then
							echo "chpipe 0" >> ~/ztvh/user/options
							sed -i 's/grep -E "[^"]*"/grep -E "live-600"/g' ~/ztvh/chpipe/*
							dialog --backtitle "[M1441] ZATTOO UNLIMITED BETA > SETTINGS > STREAMING QUALITY" --title "INFO" --msgbox "Streaming quality set to MINIMUM!" 5 40
							echo "M1400" > value
						
						#
						# M1442 LOW
						#

						elif grep -q "2" value	
						then
							echo "chpipe 1" >> ~/ztvh/user/options
							sed -i 's/grep -E "[^"]*"/grep -E "live-900"/g' ~/ztvh/chpipe/*
							dialog --backtitle "[M1442] ZATTOO UNLIMITED BETA > SETTINGS > STREAMING QUALITY" --title "INFO" --msgbox "Streaming quality set to LOW!" 5 40
							echo "M1400" > value
							
						#
						# M1443 MEDIUM
						#

						elif grep -q "3" value	
						then
							echo "chpipe 2" >> ~/ztvh/user/options
							sed -i 's/grep -E "[^"]*"/grep -E "live-1500"/g' ~/ztvh/chpipe/*
							dialog --backtitle "[M1443] ZATTOO UNLIMITED BETA > SETTINGS > STREAMING QUALITY" --title "INFO" --msgbox "Streaming quality set to MEDIUM!" 5 40
							echo "M1400" > value
					
						#
						# M1444 HIGH
						#

						elif grep -q "4" value	
						then
							echo "chpipe 3" >> ~/ztvh/user/options
							sed -i 's/grep -E "[^"]*"/grep -E "live-3000|live-2999|live-1500"/g' ~/ztvh/chpipe/*
							dialog --backtitle "[M1444] ZATTOO UNLIMITED BETA > SETTINGS > STREAMING QUALITY" --title "INFO" --msgbox "Streaming quality set to HIGH!" 5 40
							echo "M1400" > value
							
						#
						# M1445 MAXIMUM
						#

						elif grep -q "5" value	
						then
							echo "chpipe 4" >> ~/ztvh/user/options
							sed -i 's/grep -E "[^"]*"/grep -E "live-8000|live-5000|live-3000|live-2999|live-1500"/g' ~/ztvh/chpipe/*
							dialog --backtitle "[M1445] ZATTOO UNLIMITED BETA > SETTINGS > STREAMING QUALITY" --title "INFO" --msgbox "Streaming quality set to MAXIMUM!" 5 40
							echo "M1400" > value
							
						#
						# M144X EXIT
						#
							
						elif [ ! -s value ]
						then
							echo "$(<recovery)" >> ~/ztvh/user/options
							echo "M1400" > value
						fi
					
					#
					# M14X0 EXIT
					#
					
					elif [ ! -s value ]
					then
						echo "M1000" > value
						sed -i "/firstsetup=true/d" ~/ztvh/user/userfile
					fi
					
					done
			
			#
			# M1500 GRABBER MODE
			#
			
			elif grep -q "5" value
			then
				rm value
			
			
			#
			# M1800 INSECURE MODE
			#
			
			elif grep -q "8" value
			then
				dialog --backtitle "[M18A0] ZATTOO UNLIMITED BETA > SETTINGS > INSECURE MODE"  --title "WARNING" --yesno "Are you sure to disable insecure mode?\nThe script might not work afterwards!" 7 50
						
				response=$?
				
				if [ $response = 1 ]
				then
					echo "M1000" > value
				elif [ $response = 0 ]
				then
					sed -i "/insecure=true/d" ~/ztvh/user/userfile
					dialog --backtitle "[M1800] ZATTOO UNLIMITED BETA > SETTINGS > INSECURE MODE" --title "INFO" --msgbox "Insecure mode disabled!\nPlease restart the script to continue." 7 50
					clear
					exit 0
				else
					echo "M1000" > value
				fi
				
			#
			# M1900 LOGOUT
			#
			
			elif grep -q "9" value	
			then
				dialog --backtitle "[M19A0] ZATTOO UNLIMITED BETA > SETTINGS > LOGOUT"  --title "LOGOUT" --yesno "Are you sure to logout?" 5 30
						
				response=$?
				
				if [ $response = 1 ]
				then
					echo "M1000" > value
				elif [ $response = 0 ]
				then
					dialog --backtitle "[M19W0] ZATTOO UNLIMITED BETA > LOGOUT" --title "LOGOUT" --infobox "Logging out..." 3 40
					cd ~/ztvh
					rm channels.m3u favorites.m3u chpipe.sh zattoo_fullepg.xml zattoo_ext_fullepg.xml -rf user -rf work -rf epg -rf logos -rf chpipe -rf pvr 2> /dev/null
					dialog --backtitle "[M19S0] ZATTOO UNLIMITED BETA > LOGOUT" --title "LOGOUT" --infobox "Logging out... DONE!" 3 40
					sleep 1s
					clear
					exit 0
				else
					echo "M1000" > value
				fi
			
			#
			# M1X00 EXIT
			#
		
			elif [ ! -s value ]
			then
				dialog --backtitle "[M1X00] ZATTOO UNLIMITED BETA"  --title "EXIT" --yesno "Do you want to quit?" 5 30
						
				response=$?
				
				if [ $response = 1 ]
				then
					echo "M1000" > value
				elif [ $response = 0 ]
				then
					clear
					exit 0
				else
					echo "M1000" > value
				fi
			fi 
		done
	fi
fi	


# #################
# GRABBER STARTUP #
# #################

clear

echo "ZattooUNLIMITED for VLC and tvheadend"
echo "(c) 2017-2019 Jan-Luca Neumann"
echo "Script v0.5.3 | Zattoo v2.13.1"
echo ""
echo "=== GRABBER STARTUP ==="
echo ""

if grep -q "insecure=true" ~/ztvh/user/userfile
then
	echo "- WARNING: INSECURE MODE IS ENABLED! -" && echo ""
fi


# ###############
# CHANNEL LOGOS #
# ###############

echo "--- ZATTOO CHANNEL LOGOS ---"

if grep -q "chlogo 0" ~/ztvh/user/options 2> /dev/null
then
	sed -i 's/ tvg-logo=".*84x48.png"//g' ~/ztvh/channels.m3u
	echo "- LOGO GRABBER DISABLED! -" && echo ""
elif grep -q "chlogo 1" ~/ztvh/user/options 2> /dev/null
then 
	printf "Collecting/updating channel logo images..."
	mkdir ~/ztvh/logos 2> /dev/null
	chmod 0777 ~/ztvh/logos
	sed 's/#EXTINF.*\(tvg-id=".*"\).*\(tvg-logo=".*"\).*/\2 \1/g' ~/ztvh/channels.m3u > workfile
	sed -i '/pipe/d' workfile
	sed -i 's/tvg-logo="/curl /g' workfile
	sed -i 's/" tvg-id="/ > ~\/ztvh\/logos\//g' workfile
	sed -i 's/" group.*/.png 2> \/dev\/null/g' workfile
	sed -i 's/#EXTM3U/#\!\/bin\/bash/g' workfile
	bash workfile
	sed -i 's/\(.*\)\(tvg-id=".*\)\(group-title=".*\)\(tvg-logo=".*\)\(",.*\)/\1\2\3xyz\2\5/g' ~/ztvh/channels.m3u
	sed -i 's/xyztvg-id="/tvg-logo="logos\//g' ~/ztvh/channels.m3u
	sed -i 's/" ",/.png",/g' ~/ztvh/channels.m3u
	
	if [ -e ~/ztvh/favorites.m3u ]
	then
		sed -i 's/\(.*\)\(tvg-id=".*\)\(group-title=".*\)\(tvg-logo=".*\)\(",.*\)/\1\2\3xyz\2\5/g' ~/ztvh/favorites.m3u
		sed -i 's/xyztvg-id="/tvg-logo="logos\//g' ~/ztvh/favorites.m3u
		sed -i 's/" ",/.png",/g' ~/ztvh/favorites.m3u
	fi
	
	chmod 0777 ~/ztvh/logos/*
	printf "\rCollecting/updating channel logo images... OK!" && echo ""
	echo "- CHANNEL LOGO IMAGES SAVED! -" && echo ""
	rm workfile
elif grep -q "chlogo 2" ~/ztvh/user/options 2> /dev/null
then 
	printf "Collecting/updating channel logo images..."
	mkdir ~/ztvh/logos 2> /dev/null
	chmod 0777 ~/ztvh/logos
	sed 's/#EXTINF.*\(tvg-id=".*"\).*\(tvg-logo=".*"\).*/\2 \1/g' ~/ztvh/channels.m3u > workfile
	sed -i 's/\/black\//\/white\//g' workfile
	sed -i '/pipe/d' workfile
	sed -i 's/tvg-logo="/curl /g' workfile
	sed -i 's/" tvg-id="/ > ~\/ztvh\/logos\//g' workfile
	sed -i 's/" group.*/.png 2> \/dev\/null/g' workfile
	sed -i 's/#EXTM3U/#\!\/bin\/bash/g' workfile
	bash workfile
	sed -i 's/\(.*\)\(tvg-id=".*\)\(group-title=".*\)\(tvg-logo=".*\)\(",.*\)/\1\2\3xyz\2\5/g' ~/ztvh/channels.m3u
	sed -i 's/xyztvg-id="/tvg-logo="logos\//g' ~/ztvh/channels.m3u
	sed -i 's/" ",/.png",/g' ~/ztvh/channels.m3u
	
	if [ -e ~/ztvh/favorites.m3u ]
	then
		sed -i 's/\(.*\)\(tvg-id=".*\)\(group-title=".*\)\(tvg-logo=".*\)\(",.*\)/\1\2\3xyz\2\5/g' ~/ztvh/favorites.m3u
		sed -i 's/xyztvg-id="/tvg-logo="logos\//g' ~/ztvh/favorites.m3u
		sed -i 's/" ",/.png",/g' ~/ztvh/favorites.m3u
	fi
	
	chmod 0777 ~/ztvh/logos/*
	printf "\rCollecting/updating channel logo images... OK!" && echo ""
	echo "- CHANNEL LOGO IMAGES SAVED! -" && echo ""
	rm workfile
fi


# ################
# EPG DOWNLOADER #
# ################

if grep -q "zattoo.com" ~/ztvh/user/userfile 2> /dev/null
then
	echo "--- ZATTOO EPG DOWNLOADER ---"

	if grep -q "extepg 0" ~/ztvh/user/options 2> /dev/null
	then
		echo "- EPG DOWNLOADER DISABLED! -" && echo ""
	elif grep -q '"service_region_country": "CH"' ~/ztvh/work/login.txt
	then
		printf "\rDownloading EPG XMLTV file from GitHub..."
		wget https://github.com/sunsettrack4/xmltv_epg/raw/master/zattoo-epg-ch.gz 2> /dev/null
		if gzip -d zattoo-epg-ch.gz 2> /dev/null && mv zattoo-epg-ch ~/ztvh/zattoo_ext_fullepg.xml
		then
			printf "\rDownloading EPG XMLTV file from GitHub... FINISHED!" && echo "" && echo ""
		else
			printf "\rDownloading EPG XMLTV file from GitHub... FAILED!" && echo "" && echo ""
		fi
	elif grep -q '"service_region_country": "DE"' ~/ztvh/work/login.txt
	then
		printf "\rDownloading EPG XMLTV file from GitHub..."
		wget https://github.com/sunsettrack4/xmltv_epg/raw/master/zattoo-epg-de.gz 2> /dev/null 
		if gzip -d zattoo-epg-de.gz 2> /dev/null && mv zattoo-epg-de ~/ztvh/zattoo_ext_fullepg.xml
		then
			printf "\rDownloading EPG XMLTV file from GitHub... FINISHED!" && echo "" && echo ""
		else
			printf "\rDownloading EPG XMLTV file from GitHub... FAILED!" && echo "" && echo ""
		fi
	else
		printf "\rExternal EPG file not available for your country!" && echo "" && echo ""
	fi
fi


# ################
# EPG GRABBER    #
# ################

echo "--- ZATTOO EPG GRABBER ---"

if grep -q "epgdata 0-" ~/ztvh/user/options 2> /dev/null
then
	echo "- EPG GRABBER DISABLED! -" && echo ""
	
	# #####################
	# CLEAN UP WORKFOLDER #
	# #####################

	cd ~/ztvh/work
	rm login.txt workfile* powerid progressbar channels_file 2> /dev/null
	
	echo "--- DONE ---"
	exit 0
fi 

echo "Grabbing EPG data for $(sed '/epgdata/!d;s/epgdata //g;s/-//g;' ~/ztvh/user/options) day(s)!" && echo ""

mkdir ~/ztvh/epg 2> /dev/null
chmod 0777 ~/ztvh/epg


# ###############
# EPG SIMPLE    #
# ###############

if grep -q "epgmode=simple" ~/ztvh/user/options
then
	
	#
	# Check if EPG collection process was interrupted
	#

	cd ~/ztvh
	bash zguide_pc.sh

	#
	# Download EPG manifest files, create scripts to collect EPG details
	#
	
	cd ~/ztvh
	bash zguide_dl.sh
	rm ~/ztvh/epg/stats 2> /dev/null
	
	#
	# Create EPG XMLTV files
	#
	
	echo "Creating EPG XMLTV file..."
	echo "That may take a while..." && echo ""
	
	cd ~/ztvh/epg
	bash ~/ztvh/zguide_xmltv_simple.sh

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
	rm login.txt workfile* powerid progressbar channels_file 2> /dev/null

	echo "--- DONE ---"
	exit 0
fi


# ###############
# EPG EXTENDED  #
# ###############

#
# Check if EPG collection process was interrupted
#

cd ~/ztvh
bash zguide_pc.sh
touch ~/ztvh/epg/update


#
# Entering loop to keep EPG cache up to date
#

while [ -e ~/ztvh/epg/update ]
do
	rm ~/ztvh/epg/update ~/ztvh/epg/stats 2> /dev/null
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
	
		bash epg/scriptfile_00 2> /dev/null
	
		printf "\r- EPG DOWNLOAD FINISHED! -                   " && echo "" && echo ""
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
		rm work/datefile 2> /dev/null
	fi
	
	
	#
	# Repeat process: Keep manifest up to date
	#

	if [ -e ~/ztvh/epg/update ]
	then
		echo "Checking for updates..."
	elif [ -e ~/ztvh/epg/stats ]
	then
		echo "Update finished!" && echo ""
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
rm ~/ztvh/epg/stats 2> /dev/null


# 
# Sum up epg details
#

echo "Creating EPG XMLTV file..."
echo "That may take a while..." && echo ""

printf "\rMerging collected EPG details to a single EPG file..."

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
rm login.txt workfile* powerid progressbar channels_file 2> /dev/null
sort -u ~/ztvh/epg/status -o ~/ztvh/epg/status

echo "--- DONE ---"
