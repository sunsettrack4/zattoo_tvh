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

# ######################
# DOWNLOAD EPG DETAILS #
# ######################

cd ~/ztvh/work

rm ~/ztvh/epg/datafile* 2> /dev/null
rm ~/ztvh/epg/filecheck* 2> /dev/null

session=$(<session)
powerid=$(<powerid)

echo "" && echo "Checking EPG manifest files..."


# ################
# DOWNLOAD DAY 1 #
# ################

if grep -q "epgdata [1-7]" ~/ztvh/user/options 2> /dev/null
then
	until grep -q '"success":true' ~/ztvh/epg/datafile_1 2> /dev/null
	do
		date '+%Y-%m-%d 06:00:00' > date0
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date0
		date0=$(bash date0)

		date '+%Y-%m-%d 12:00:00' > date1
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date1
		date1=$(bash date1)
		
		date '+%Y-%m-%d 18:00:00' > date2
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date2
		date2=$(bash date2)

		date -d '1 day' '+%Y-%m-%d 00:00:00' > date3
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date3
		date3=$(bash date3)

		date -d '1 day' '+%Y-%m-%d 06:00:00' > date4
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date4
		date4=$(bash date4)

		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date1&start=$date0" > ~/ztvh/epg/datafile_1 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date2&start=$date1" >> ~/ztvh/epg/datafile_1 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date3&start=$date2" >> ~/ztvh/epg/datafile_1 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date4&start=$date3" >> ~/ztvh/epg/datafile_1 2> /dev/null
		rm date*
	
		if tr ' ' '\n' < ~/ztvh/epg/datafile_1 | grep '"success":true' | wc -l | grep -q 4 2> /dev/null
		then :
		else
			echo ""
			echo "- ERROR: FAILED TO LOAD EPG MAIN FILE! -"
			echo "DAY 1 - $(date '+%Y%m%d'): Failed to check EPG manifest file!"
			echo "Retry in 30 secs..." && echo ""
			sleep 30s
		fi
	done
	
	if [ -e ~/ztvh/epg/$(date '+%Y%m%d')_manifest_new ]
	then
		echo ""
		echo "DAY 1 - $(date '+%Y%m%d'): EPG manifest file updated!"
		mv ~/ztvh/epg/$(date '+%Y%m%d')_manifest_new ~/ztvh/epg/$(date '+%Y%m%d')_manifest_old 2> /dev/null
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_1 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date '+%Y%m%d')_manifest_new
		
		# Create file checker to download changed/new broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date +%Y%m%d)_manifest_new) <(sort ~/ztvh/epg/$(date +%Y%m%d)_manifest_old 2> /dev/null) > workfile
		sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile && cp workfile workfile2
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null/g' workfile
		if grep -q "curl" workfile
		then 
			sed '1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date +%Y%m%d)' workfile > ~/ztvh/epg/filecheck
		fi
	
		# Add commands to file checker to remove deleted broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date +%Y%m%d)_manifest_old 2> /dev/null) <(sort ~/ztvh/epg/$(date +%Y%m%d)_manifest_new) > workfile
		if [ -s workfile2 ]
		then
			sed -i -e 's/.*/sed -i "\/&\/d" workfile/g' -e '1i#\!\/bin\/bash' workfile2
			bash workfile2
		fi
		if [ -s workfile ]
		then
			sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile
			sed -i 's/.*/rm epg\/\$date\/&/g' workfile
			if [ -s ~/ztvh/epg/filecheck ]
			then
				cat workfile >> ~/ztvh/epg/filecheck
				mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_1
				echo "- NEW CLOUD FILES TO BE ADDED -"
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date +%Y%m%d) finished//g" ~/ztvh/epg/status 2> /dev/null
			else
				echo "#!/bin/bash" > ~/ztvh/epg/datafile_1
				echo "date=$(date +%Y%m%d)" >> ~/ztvh/epg/datafile_1
				cat workfile >> ~/ztvh/epg/datafile_1
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date +%Y%m%d) finished//g" ~/ztvh/epg/status 2> /dev/null
			fi
		elif [ -s ~/ztvh/epg/filecheck ]
		then
			echo "- NEW CLOUD FILES TO BE ADDED -"
			touch ~/ztvh/epg/stats
			touch ~/ztvh/epg/stats2
			sed -i "s/$(date +%Y%m%d) finished//g" ~/ztvh/epg/status 2> /dev/null
			mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_1
		else
			echo "- NO CHANGES FOUND -"
			rm ~/ztvh/epg/datafile_1
			echo "$(date +%Y%m%d) finished" >> ~/ztvh/epg/status
		fi
	else
		echo ""
		echo "DAY 1 - $(date '+%Y%m%d'): EPG manifest file created!"
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_1 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date '+%Y%m%d')_manifest_new
		sed 's/"id":/\n&/g' ~/ztvh/epg/datafile_1 > workfile
		sed -i '/"id":/!d' workfile
		sed -i 's/,.*//g' workfile
		sed -i 's/"id"://g' workfile
		sed -i 's/}.*//g' workfile
		sed -i 's/.*/if \[ -e epg\/\$date\/& \]\nthen :\nelse\ncurl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null\nfi/g' workfile
		sed -i '1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date +%Y%m%d)\nmkdir epg\/\$date 2> \/dev\/null' workfile
		mv workfile ~/ztvh/epg/datafile_1
		echo "- COMPLETE DATABASE TO BE SYNCED -"
		touch ~/ztvh/epg/stats
		touch ~/ztvh/epg/stats2
		sed -i "s/$(date +%Y%m%d) finished//g" ~/ztvh/epg/status 2> /dev/null
	fi
fi


# ################
# DOWNLOAD DAY 2 #
# ################

if grep -q "epgdata [2-7]" ~/ztvh/user/options 2> /dev/null
then
	until grep -q '"success":true' ~/ztvh/epg/datafile_2 2> /dev/null
	do
		date -d '1 day' '+%Y-%m-%d 06:00:00' > date0
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date0
		date0=$(bash date0)

		date -d '1 day' '+%Y-%m-%d 12:00:00' > date1
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date1
		date1=$(bash date1)
		
		date -d '1 day' '+%Y-%m-%d 18:00:00' > date2
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date2
		date2=$(bash date2)
		
		date -d '2 days' '+%Y-%m-%d 00:00:00' > date3
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date3
		date3=$(bash date3)
		
		date -d '2 days' '+%Y-%m-%d 06:00:00' > date4
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date4
		date4=$(bash date4)
	
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date1&start=$date0" > ~/ztvh/epg/datafile_2 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date2&start=$date1" >> ~/ztvh/epg/datafile_2 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date3&start=$date2" >> ~/ztvh/epg/datafile_2 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date4&start=$date3" >> ~/ztvh/epg/datafile_2 2> /dev/null
		rm date*
	
		if tr ' ' '\n' < ~/ztvh/epg/datafile_2 | grep '"success":true' | wc -l | grep -q 4 2> /dev/null
		then :
		else
			echo ""
			echo "- ERROR: FAILED TO LOAD EPG MAIN FILE! -"
			echo "DAY 2 - $(date -d '1 day' '+%Y%m%d'): Failed to check EPG manifest file!"
			echo "Retry in 30 secs..." && echo ""
			sleep 30s
		fi
	done
	
	if [ -e ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_new ]
	then
		echo ""
		echo "DAY 2 - $(date -d '1 day' '+%Y%m%d'): EPG manifest file updated!"
		mv ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_new ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_old 2> /dev/null
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_2 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_new
		
		# Create file checker to download changed/new broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_new) <(sort ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_old 2> /dev/null) > workfile
		sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile && cp workfile workfile2
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null/g' workfile
		if grep -q "curl" workfile
		then 
			sed "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '1 day' '+%Y%m%d')" workfile > ~/ztvh/epg/filecheck
		fi
	
		# Add commands to file checker to remove deleted broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_old 2> /dev/null) <(sort ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_new) > workfile
		if [ -s workfile2 ]
		then
			sed -i -e 's/.*/sed -i "\/&\/d" workfile/g' -e '1i#\!\/bin\/bash' workfile2
			bash workfile2
		fi
		if [ -s workfile ]
		then
			sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile
			sed -i 's/.*/rm epg\/\$date\/&/g' workfile
			if [ -s ~/ztvh/epg/filecheck ]
			then
				cat workfile >> ~/ztvh/epg/filecheck
				mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_2
				echo "- NEW CLOUD FILES TO BE ADDED -"
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '1 day' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			else
				echo "#!/bin/bash" > ~/ztvh/epg/datafile_2
				echo "date=$(date -d '1 day' '+%Y%m%d')" >> ~/ztvh/epg/datafile_2
				cat workfile >> ~/ztvh/epg/datafile_2
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '1 day' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			fi
		elif [ -s ~/ztvh/epg/filecheck ]
		then
			echo "- NEW CLOUD FILES TO BE ADDED -"
			touch ~/ztvh/epg/stats
			touch ~/ztvh/epg/stats2
			sed -i "s/$(date -d '1 day' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_2
		else
			echo "- NO CHANGES FOUND -"
			rm ~/ztvh/epg/datafile_2
			echo "$(date -d '1 day' '+%Y%m%d') finished" >> ~/ztvh/epg/status
		fi
	else
		echo ""
		echo "DAY 2 - $(date -d '1 day' '+%Y%m%d'): EPG manifest file created!"
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_2 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')_manifest_new
		sed 's/"id":/\n&/g' ~/ztvh/epg/datafile_2 > workfile
		sed -i '/"id":/!d' workfile
		sed -i 's/,.*//g' workfile
		sed -i 's/"id"://g' workfile
		sed -i 's/}.*//g' workfile
		sed -i 's/.*/if \[ -e epg\/\$date\/& \]\nthen :\nelse\ncurl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null\nfi/g' workfile
		sed -i "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '1 day' '+%Y%m%d')\nmkdir epg\/\$date 2> \/dev\/null" workfile
		mv workfile ~/ztvh/epg/datafile_2
		echo "- COMPLETE DATABASE TO BE SYNCED -"
		touch ~/ztvh/epg/stats
		touch ~/ztvh/epg/stats2
		sed -i "s/$(date -d '1 day' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
	fi
fi


# ################
# DOWNLOAD DAY 3 #
# ################

if grep -q "epgdata [3-7]" ~/ztvh/user/options 2> /dev/null
then
	until grep -q '"success":true' ~/ztvh/epg/datafile_3 2> /dev/null
	do
		date -d '2 days' '+%Y-%m-%d 06:00:00' > date0
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date0
		date0=$(bash date0)

		date -d '2 days' '+%Y-%m-%d 12:00:00' > date1
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date1
		date1=$(bash date1)
		
		date -d '2 days' '+%Y-%m-%d 18:00:00' > date2
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date2
		date2=$(bash date2)
		
		date -d '3 days' '+%Y-%m-%d 00:00:00' > date3
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date3
		date3=$(bash date3)
		
		date -d '3 days' '+%Y-%m-%d 06:00:00' > date4
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date4
		date4=$(bash date4)
	
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date1&start=$date0" > ~/ztvh/epg/datafile_3 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date2&start=$date1" >> ~/ztvh/epg/datafile_3 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date3&start=$date2" >> ~/ztvh/epg/datafile_3 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date4&start=$date3" >> ~/ztvh/epg/datafile_3 2> /dev/null
		rm date*
		
		if tr ' ' '\n' < ~/ztvh/epg/datafile_3 | grep '"success":true' | wc -l | grep -q 4 2> /dev/null
		then :
		else
			echo ""
			echo "- ERROR: FAILED TO LOAD EPG MAIN FILE! -"
			echo "DAY 3 - $(date -d '2 days' '+%Y%m%d'): Failed to check EPG manifest file!"
			echo "Retry in 30 secs..." && echo ""
			sleep 30s
		fi
	done
	
	if [ -e ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_new ]
	then
		echo ""
		echo "DAY 3 - $(date -d '2 days' '+%Y%m%d'): EPG manifest file updated!"
		mv ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_new ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_old 2> /dev/null
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_3 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_new
		
		# Create file checker to download changed/new broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_new) <(sort ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_old 2> /dev/null) > workfile
		sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile && cp workfile workfile2
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null/g' workfile
		if grep -q "curl" workfile
		then 
			sed "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '2 days' '+%Y%m%d')" workfile > ~/ztvh/epg/filecheck
		fi
	
		# Add commands to file checker to remove deleted broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_old 2> /dev/null) <(sort ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_new) > workfile
		if [ -s workfile2 ]
		then
			sed -i -e 's/.*/sed -i "\/&\/d" workfile/g' -e '1i#\!\/bin\/bash' workfile2
			bash workfile2
		fi
		if [ -s workfile ]
		then
			sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile
			sed -i 's/.*/rm epg\/\$date\/&/g' workfile
			if [ -s ~/ztvh/epg/filecheck ]
			then
				cat workfile >> ~/ztvh/epg/filecheck
				mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_3
				echo "- NEW CLOUD FILES TO BE ADDED -"
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '2 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			else
				echo "#!/bin/bash" > ~/ztvh/epg/datafile_3
				echo "date=$(date -d '2 days' '+%Y%m%d')" >> ~/ztvh/epg/datafile_3
				cat workfile >> ~/ztvh/epg/datafile_3
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '2 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			fi
		elif [ -s ~/ztvh/epg/filecheck ]
		then
			echo "- NEW CLOUD FILES TO BE ADDED -"
			touch ~/ztvh/epg/stats
			touch ~/ztvh/epg/stats2
			sed -i "s/$(date -d '2 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_3
		else
			echo "- NO CHANGES FOUND -"
			rm ~/ztvh/epg/datafile_3
			echo "$(date -d '2 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
		fi
	else
		echo ""
		echo "DAY 3 - $(date -d '2 days' '+%Y%m%d'): EPG manifest file created!"
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_3 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')_manifest_new
		sed 's/"id":/\n&/g' ~/ztvh/epg/datafile_3 > workfile
		sed -i '/"id":/!d' workfile
		sed -i 's/,.*//g' workfile
		sed -i 's/"id"://g' workfile
		sed -i 's/}.*//g' workfile
		sed -i 's/.*/if \[ -e epg\/\$date\/& \]\nthen :\nelse\ncurl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null\nfi/g' workfile
		sed -i "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '2 days' '+%Y%m%d')\nmkdir epg\/\$date 2> \/dev\/null" workfile
		mv workfile ~/ztvh/epg/datafile_3
		echo "- COMPLETE DATABASE TO BE SYNCED -"
		touch ~/ztvh/epg/stats
		touch ~/ztvh/epg/stats2
		sed -i "s/$(date -d '2 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
	fi
fi


# ################
# DOWNLOAD DAY 4 #
# ################

if grep -q "epgdata [4-7]" ~/ztvh/user/options 2> /dev/null
then
	until grep -q '"success":true' ~/ztvh/epg/datafile_4 2> /dev/null
	do
		date -d '3 days' '+%Y-%m-%d 06:00:00' > date0
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date0
		date0=$(bash date0)

		date -d '3 days' '+%Y-%m-%d 12:00:00' > date1
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date1
		date1=$(bash date1)
		
		date -d '3 days' '+%Y-%m-%d 18:00:00' > date2
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date2
		date2=$(bash date2)
		
		date -d '4 days' '+%Y-%m-%d 00:00:00' > date3
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date3
		date3=$(bash date3)
		
		date -d '4 days' '+%Y-%m-%d 06:00:00' > date4
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date4
		date4=$(bash date4)
	
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date1&start=$date0" > ~/ztvh/epg/datafile_4 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date2&start=$date1" >> ~/ztvh/epg/datafile_4 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date3&start=$date2" >> ~/ztvh/epg/datafile_4 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date4&start=$date3" >> ~/ztvh/epg/datafile_4 2> /dev/null
		rm date*
		
		if tr ' ' '\n' < ~/ztvh/epg/datafile_4 | grep '"success":true' | wc -l | grep -q 4 2> /dev/null
		then :
		else
			echo ""
			echo "- ERROR: FAILED TO LOAD EPG MAIN FILE! -"
			echo "DAY 4 - $(date -d '3 days' '+%Y%m%d'): Failed to check EPG manifest file!"
			echo "Retry in 30 secs..." && echo ""
			sleep 30s
		fi
	done
	
	if [ -e ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_new ]
	then
		echo ""
		echo "DAY 4 - $(date -d '3 days' '+%Y%m%d'): EPG manifest file updated!"
		mv ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_new ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_old 2> /dev/null
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_4 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_new
		
		# Create file checker to download changed/new broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_new) <(sort ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_old 2> /dev/null) > workfile
		sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile && cp workfile workfile2
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null/g' workfile
		if grep -q "curl" workfile
		then 
			sed "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '3 days' '+%Y%m%d')" workfile > ~/ztvh/epg/filecheck
		fi
	
		# Add commands to file checker to remove deleted broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_old 2> /dev/null) <(sort ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_new) > workfile
		if [ -s workfile2 ]
		then
			sed -i -e 's/.*/sed -i "\/&\/d" workfile/g' -e '1i#\!\/bin\/bash' workfile2
			bash workfile2
		fi
		if [ -s workfile ]
		then
			sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile
			sed -i 's/.*/rm epg\/\$date\/&/g' workfile
			if [ -s ~/ztvh/epg/filecheck ]
			then
				cat workfile >> ~/ztvh/epg/filecheck
				mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_4
				echo "- NEW CLOUD FILES TO BE ADDED -"
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '3 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			else
				echo "#!/bin/bash" > ~/ztvh/epg/datafile_4
				echo "date=$(date -d '3 days' '+%Y%m%d')" >> ~/ztvh/epg/datafile_4
				cat workfile >> ~/ztvh/epg/datafile_4
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '3 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			fi
		elif [ -s ~/ztvh/epg/filecheck ]
		then
			echo "- NEW CLOUD FILES TO BE ADDED -"
			touch ~/ztvh/epg/stats
			touch ~/ztvh/epg/stats2
			sed -i "s/$(date -d '3 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_4
		else
			echo "- NO CHANGES FOUND -"
			rm ~/ztvh/epg/datafile_4
			echo "$(date -d '3 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
		fi
	else
		echo ""
		echo "DAY 4 - $(date -d '3 days' '+%Y%m%d'): EPG manifest file created!"
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_4 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')_manifest_new
		sed 's/"id":/\n&/g' ~/ztvh/epg/datafile_4 > workfile
		sed -i '/"id":/!d' workfile
		sed -i 's/,.*//g' workfile
		sed -i 's/"id"://g' workfile
		sed -i 's/}.*//g' workfile
		sed -i 's/.*/if \[ -e epg\/\$date\/& \]\nthen :\nelse\ncurl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null\nfi/g' workfile
		sed -i "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '3 days' '+%Y%m%d')\nmkdir epg\/\$date 2> \/dev\/null" workfile
		mv workfile ~/ztvh/epg/datafile_4
		echo "- COMPLETE DATABASE TO BE SYNCED -"
		touch ~/ztvh/epg/stats
		touch ~/ztvh/epg/stats2
		sed -i "s/$(date -d '3 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
	fi
fi


# ################
# DOWNLOAD DAY 5 #
# ################

if grep -q "epgdata [5-7]" ~/ztvh/user/options 2> /dev/null
then
	until grep -q '"success":true' ~/ztvh/epg/datafile_5 2> /dev/null
	do
		date -d '4 days' '+%Y-%m-%d 06:00:00' > date0
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date0
		date0=$(bash date0)

		date -d '4 days' '+%Y-%m-%d 12:00:00' > date1
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date1
		date1=$(bash date1)
		
		date -d '4 days' '+%Y-%m-%d 18:00:00' > date2
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date2
		date2=$(bash date2)
		
		date -d '5 days' '+%Y-%m-%d 00:00:00' > date3
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date3
		date3=$(bash date3)
		
		date -d '5 days' '+%Y-%m-%d 06:00:00' > date4
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date4
		date4=$(bash date4)
	
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date1&start=$date0" > ~/ztvh/epg/datafile_5 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date2&start=$date1" >> ~/ztvh/epg/datafile_5 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date3&start=$date2" >> ~/ztvh/epg/datafile_5 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date4&start=$date3" >> ~/ztvh/epg/datafile_5 2> /dev/null
		rm date*
		
		if tr ' ' '\n' < ~/ztvh/epg/datafile_5 | grep '"success":true' | wc -l | grep -q 4 2> /dev/null
		then :
		else
			echo ""
			echo "- ERROR: FAILED TO LOAD EPG MAIN FILE! -"
			echo "DAY 5 - $(date -d '4 days' '+%Y%m%d'): Failed to check EPG manifest file!"
			echo "Retry in 30 secs..." && echo ""
			sleep 30s
		fi
	done
	
	if [ -e ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_new ]
	then
		echo ""
		echo "DAY 5 - $(date -d '4 days' '+%Y%m%d'): EPG manifest file updated!"
		mv ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_new ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_old 2> /dev/null
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_5 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_new
		
		# Create file checker to download changed/new broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_new) <(sort ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_old 2> /dev/null) > workfile
		sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile && cp workfile workfile2
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null/g' workfile
		if grep -q "curl" workfile
		then 
			sed "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '4 days' '+%Y%m%d')" workfile > ~/ztvh/epg/filecheck
		fi
	
		# Add commands to file checker to remove deleted broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_old 2> /dev/null) <(sort ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_new) > workfile
		if [ -s workfile2 ]
		then
			sed -i -e 's/.*/sed -i "\/&\/d" workfile/g' -e '1i#\!\/bin\/bash' workfile2
			bash workfile2
		fi
		if [ -s workfile ]
		then
			sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile
			sed -i 's/.*/rm epg\/\$date\/&/g' workfile
			if [ -s ~/ztvh/epg/filecheck ]
			then
				cat workfile >> ~/ztvh/epg/filecheck
				mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_5
				echo "- NEW CLOUD FILES TO BE ADDED -"
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '4 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			else
				echo "#!/bin/bash" > ~/ztvh/epg/datafile_5
				echo "date=$(date -d '4 days' '+%Y%m%d')" >> ~/ztvh/epg/datafile_5
				cat workfile >> ~/ztvh/epg/datafile_5
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '4 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			fi
		elif [ -s ~/ztvh/epg/filecheck ]
		then
			echo "- NEW CLOUD FILES TO BE ADDED -"
			touch ~/ztvh/epg/stats
			touch ~/ztvh/epg/stats2
			sed -i "s/$(date -d '4 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_5
		else
			echo "- NO CHANGES FOUND -"
			rm ~/ztvh/epg/datafile_5
			echo "$(date -d '4 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
		fi
	else
		echo ""
		echo "DAY 5 - $(date -d '4 days' '+%Y%m%d'): EPG manifest file created!"
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_5 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')_manifest_new
		sed 's/"id":/\n&/g' ~/ztvh/epg/datafile_5 > workfile
		sed -i '/"id":/!d' workfile
		sed -i 's/,.*//g' workfile
		sed -i 's/"id"://g' workfile
		sed -i 's/}.*//g' workfile
		sed -i 's/.*/if \[ -e epg\/\$date\/& \]\nthen :\nelse\ncurl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null\nfi/g' workfile
		sed -i "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '4 days' '+%Y%m%d')\nmkdir epg\/\$date 2> \/dev\/null" workfile
		mv workfile ~/ztvh/epg/datafile_5
		echo "- COMPLETE DATABASE TO BE SYNCED -"
		touch ~/ztvh/epg/stats
		touch ~/ztvh/epg/stats2
		sed -i "s/$(date -d '4 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
	fi
fi


# ################
# DOWNLOAD DAY 6 #
# ################

if grep -q "epgdata [6-7]" ~/ztvh/user/options 2> /dev/null
then
	until grep -q '"success":true' ~/ztvh/epg/datafile_6 2> /dev/null
	do
		date -d '5 days' '+%Y-%m-%d 06:00:00' > date0
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date0
		date0=$(bash date0)

		date -d '5 days' '+%Y-%m-%d 12:00:00' > date1
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date1
		date1=$(bash date1)
		
		date -d '5 days' '+%Y-%m-%d 18:00:00' > date2
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date2
		date2=$(bash date2)
		
		date -d '6 days' '+%Y-%m-%d 00:00:00' > date3
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date3
		date3=$(bash date3)
		
		date -d '6 days' '+%Y-%m-%d 06:00:00' > date4
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date4
		date4=$(bash date4)
	
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date1&start=$date0" > ~/ztvh/epg/datafile_6 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date2&start=$date1" >> ~/ztvh/epg/datafile_6 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date3&start=$date2" >> ~/ztvh/epg/datafile_6 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date4&start=$date3" >> ~/ztvh/epg/datafile_6 2> /dev/null
		rm date*
		
		if tr ' ' '\n' < ~/ztvh/epg/datafile_6 | grep '"success":true' | wc -l | grep -q 4 2> /dev/null
		then :
		else
			echo ""
			echo "- ERROR: FAILED TO LOAD EPG MAIN FILE! -"
			echo "DAY 6 - $(date -d '5 days' '+%Y%m%d'): Failed to check EPG manifest file!"
			echo "Retry in 30 secs..." && echo ""
			sleep 30s
		fi
	done
	
	if [ -e ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_new ]
	then
		echo ""
		echo "DAY 6 - $(date -d '5 days' '+%Y%m%d'): EPG manifest file updated!"
		mv ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_new ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_old 2> /dev/null
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_6 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_new
		
		# Create file checker to download changed/new broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_new) <(sort ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_old 2> /dev/null) > workfile
		sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile && cp workfile workfile2
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null/g' workfile
		if grep -q "curl" workfile
		then 
			sed "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '5 days' '+%Y%m%d')" workfile > ~/ztvh/epg/filecheck
		fi
	
		# Add commands to file checker to remove deleted broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_old 2> /dev/null) <(sort ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_new) > workfile
		if [ -s workfile2 ]
		then
			sed -i -e 's/.*/sed -i "\/&\/d" workfile/g' -e '1i#\!\/bin\/bash' workfile2
			bash workfile2
		fi
		if [ -s workfile ]
		then
			sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile
			sed -i 's/.*/rm epg\/\$date\/&/g' workfile
			if [ -s ~/ztvh/epg/filecheck ]
			then
				cat workfile >> ~/ztvh/epg/filecheck
				mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_6
				echo "- NEW CLOUD FILES TO BE ADDED -"
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '5 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			else
				echo "#!/bin/bash" > ~/ztvh/epg/datafile_6
				echo "date=$(date -d '5 days' '+%Y%m%d')" >> ~/ztvh/epg/datafile_6
				cat workfile >> ~/ztvh/epg/datafile_6
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '5 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			fi
		elif [ -s ~/ztvh/epg/filecheck ]
		then
			echo "- NEW CLOUD FILES TO BE ADDED -"
			touch ~/ztvh/epg/stats
			touch ~/ztvh/epg/stats2
			sed -i "s/$(date -d '5 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_6
		else
			echo "- NO CHANGES FOUND -"
			rm ~/ztvh/epg/datafile_6
			echo "$(date -d '5 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
		fi
	else
		echo ""
		echo "DAY 6 - $(date -d '5 days' '+%Y%m%d'): EPG manifest file created!"
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_6 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')_manifest_new
		sed 's/"id":/\n&/g' ~/ztvh/epg/datafile_6 > workfile
		sed -i '/"id":/!d' workfile
		sed -i 's/,.*//g' workfile
		sed -i 's/"id"://g' workfile
		sed -i 's/}.*//g' workfile
		sed -i 's/.*/if \[ -e epg\/\$date\/& \]\nthen :\nelse\ncurl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null\nfi/g' workfile
		sed -i "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '5 days' '+%Y%m%d')\nmkdir epg\/\$date 2> \/dev\/null" workfile
		mv workfile ~/ztvh/epg/datafile_6
		echo "- COMPLETE DATABASE TO BE SYNCED -"
		touch ~/ztvh/epg/stats
		touch ~/ztvh/epg/stats2
		sed -i "s/$(date -d '5 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
	fi
fi


# ################
# DOWNLOAD DAY 7 #
# ################

if grep -q "epgdata 7" ~/ztvh/user/options 2> /dev/null
then
	until grep -q '"success":true' ~/ztvh/epg/datafile_7 2> /dev/null
	do
		date -d '6 days' '+%Y-%m-%d 06:00:00' > date0
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date0
		date0=$(bash date0)

		date -d '6 days' '+%Y-%m-%d 12:00:00' > date1
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date1
		date1=$(bash date1)
		
		date -d '6 days' '+%Y-%m-%d 18:00:00' > date2
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date2
		date2=$(bash date2)
		
		date -d '7 days' '+%Y-%m-%d 00:00:00' > date3
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date3
		date3=$(bash date3)
		
		date -d '7 days' '+%Y-%m-%d 06:00:00' > date4
		sed -i 's/.*/#\!\/bin\/bash\ndate -d "&" +%s/g' date4
		date4=$(bash date4)
	
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date1&start=$date0" > ~/ztvh/epg/datafile_7 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date2&start=$date1" >> ~/ztvh/epg/datafile_7 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date3&start=$date2" >> ~/ztvh/epg/datafile_7 2> /dev/null
		curl -X GET --cookie "$session" "https://zattoo.com/zapi/v2/cached/program/power_guide/$powerid?end=$date4&start=$date3" >> ~/ztvh/epg/datafile_7 2> /dev/null
		rm date*
		
		if tr ' ' '\n' < ~/ztvh/epg/datafile_7 | grep '"success":true' | wc -l | grep -q 4 2> /dev/null
		then :
		else
			echo ""
			echo "- ERROR: FAILED TO LOAD EPG MAIN FILE! -"
			echo "DAY 7 - $(date -d '6 days' '+%Y%m%d'): Failed to check EPG manifest file!"
			echo "Retry in 30 secs..." && echo ""
			sleep 30s
		fi
	done
	
	if [ -e ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_new ]
	then
		echo ""
		echo "DAY 7 - $(date -d '6 days' '+%Y%m%d'): EPG manifest file updated!"
		mv ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_new ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_old 2> /dev/null
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_7 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_new
		
		# Create file checker to download changed/new broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_new) <(sort ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_old 2> /dev/null) > workfile
		sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile && cp workfile workfile2
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null/g' workfile
		if grep -q "curl" workfile
		then 
			sed "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '6 days' '+%Y%m%d')" workfile > ~/ztvh/epg/filecheck
		fi
	
		# Add commands to file checker to remove deleted broadcasts
		comm -2 -3 <(sort ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_old 2> /dev/null) <(sort ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_new) > workfile
		if [ -s workfile2 ]
		then
			sed -i -e 's/.*/sed -i "\/&\/d" workfile/g' -e '1i#\!\/bin\/bash' workfile2
			bash workfile2
		fi
		if [ -s workfile ]
		then
			sed -i -e 's/\(.*\)\("id":.*\)/\2/g' -e 's/"id"://g' -e 's/},//g' workfile
			sed -i 's/.*/rm epg\/\$date\/&/g' workfile
			if [ -s ~/ztvh/epg/filecheck ]
			then
				cat workfile >> ~/ztvh/epg/filecheck
				mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_7
				echo "- NEW CLOUD FILES TO BE ADDED -"
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '6 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			else
				echo "#!/bin/bash" > ~/ztvh/epg/datafile_7
				echo "date=$(date -d '6 days' '+%Y%m%d')" >> ~/ztvh/epg/datafile_7
				cat workfile >> ~/ztvh/epg/datafile_7
				echo "- SYNCED FILES TO BE DELETED -"
				touch ~/ztvh/epg/stats
				touch ~/ztvh/epg/stats2
				sed -i "s/$(date -d '6 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			fi
		elif [ -s ~/ztvh/epg/filecheck ]
		then
			echo "- NEW CLOUD FILES TO BE ADDED -"
			touch ~/ztvh/epg/stats
			touch ~/ztvh/epg/stats2
			sed -i "s/$(date -d '6 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
			mv ~/ztvh/epg/filecheck ~/ztvh/epg/datafile_7
		else
			echo "- NO CHANGES FOUND -"
			rm ~/ztvh/epg/datafile_7
			echo "$(date -d '6 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
		fi
	else
		echo ""
		echo "DAY 7 - $(date -d '6 days' '+%Y%m%d'): EPG manifest file created!"
		sed 's/{"i_url":/\n&/g' ~/ztvh/epg/datafile_7 | sed '1d' | sed 's/}\],"cid".*//g' > ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')_manifest_new
		sed 's/"id":/\n&/g' ~/ztvh/epg/datafile_7 > workfile
		sed -i '/"id":/!d' workfile
		sed -i 's/,.*//g' workfile
		sed -i 's/"id"://g' workfile
		sed -i 's/}.*//g' workfile
		sed -i 's/.*/if \[ -e epg\/\$date\/& \]\nthen :\nelse\ncurl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" > epg\/\$date\/& 2> \/dev\/null\nfi/g' workfile
		sed -i "1i #\!\/bin\/bash\nsession=\$(<work\/session)\ndate=\$(date -d '6 days' '+%Y%m%d')\nmkdir epg\/\$date 2> \/dev\/null" workfile
		mv workfile ~/ztvh/epg/datafile_7
		echo "- COMPLETE DATABASE TO BE SYNCED -"
		touch ~/ztvh/epg/stats
		touch ~/ztvh/epg/stats2
		sed -i "s/$(date -d '6 days' '+%Y%m%d') finished//g" ~/ztvh/epg/status 2> /dev/null
	fi
fi

rm ~/ztvh/epg/filecheck 2> /dev/null

echo "" && echo "- EPG MANIFEST FILES SAVED SUCCESSFULLY! -" && echo ""
