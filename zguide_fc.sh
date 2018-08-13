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

# ##################
# EPG FILE CHECKER #
# ##################

cd ~/ztvh/epg
rm stats2 2> /dev/null

# DAY 1
if grep -q -E "epgdata [1-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 1)             "
		rm $(sed -n "1p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "1p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "1p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file 
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 1 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '1p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '1p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi

# DAY 2
if grep -q -E "epgdata [2-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 2)             "
		rm $(sed -n "2p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "2p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "2p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 2 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '2p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '2p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 3
if grep -q -E "epgdata [3-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 3)             "
		rm $(sed -n "3p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "3p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "3p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file 
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 3 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '3p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '3p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 4
if grep -q -E "epgdata [4-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 4)             "
		rm $(sed -n "4p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "4p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "4p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file 
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 4 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '4p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '4p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 5
if grep -q -E "epgdata [5-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 5)             "
		rm $(sed -n "5p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "5p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "5p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 5 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '5p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '5p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi

# DAY 6
if grep -q -E "epgdata [6-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 6)             "
		rm $(sed -n "6p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "6p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "6p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file  
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 6 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '6p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '6p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 7
if grep -q -E "epgdata [7-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 7)             "
		rm $(sed -n "7p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "7p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "7p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file 
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 7 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '7p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '7p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 8
if grep -q -E "epgdata [8-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 8)             "
		rm $(sed -n "8p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "8p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "8p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file  
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 8 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '8p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '8p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 9
if grep -q -E "epgdata 9-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 9)             "
		rm $(sed -n "9p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "9p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "9p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 9 IN PROGRESS) "
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '9p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '9p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 10
if grep -q "epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 10)            "
		rm $(sed -n "10p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "10p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "10p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file  
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 10 IN PROGRESS)"
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '10p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '10p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 11
if grep -q "epgdata 1[1-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 11)            "
		rm $(sed -n "11p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "11p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "11p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 11 IN PROGRESS)"
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '11p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '11p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 12
if grep -q "epgdata 1[2-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 12)            "
		rm $(sed -n "12p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "12p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "12p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file 
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 12 IN PROGRESS)"
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '12p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '12p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 13
if grep -q "epgdata 1[3-4]-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 13)            "
		rm $(sed -n "13p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "13p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "13p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file 
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 13 IN PROGRESS)"
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '13p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '13p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

# DAY 14
if grep -q "epgdata 14-" ~/ztvh/user/options 2> /dev/null
then
	until grep -q "loop 3" stats2 2> /dev/null
	do
		if grep -q "loop 1" stats2 2> /dev/null
		then
			sed -i 's/loop 1/loop 2/g' stats2
		elif grep -q "loop 2" stats2 2> /dev/null
		then
			sed -i 's/loop 2/loop 3/g' stats2
		else
			echo "loop 1" > stats2
		fi
		printf "\rChecking cache for missing EPG files... (DAY 14)            "
		rm $(sed -n "14p" ~/ztvh/work/datefile)/workfile 2> /dev/null
		cat $(sed -n "14p" ~/ztvh/work/datefile)/* > workfile
		sed -e 's/.*"id"://g' -e 's/},.*//g' $(sed -n "14p" ~/ztvh/work/datefile)_manifest_new > manifest_file
		sed 's/\(.*"id": \)\([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\(,.*\)/\2/g' workfile > cache_file 
		comm -2 -3 <(sort -u manifest_file) <(sort -u cache_file) > filecheck
		if [ -s filecheck ]
		then
			printf "\rChecking cache for missing EPG files... (DAY 14 IN PROGRESS)"
			sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/v2\/cached\/program\/power_details\/$powerid?program_ids=&" | grep ": true, " > \$date\/& 2> \/dev\/null/g' filecheck
			sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\npowerid=\$(<~\/ztvh\/work\/powerid)\ndate=\$(sed -n '14p' ~\/ztvh\/work\/datefile)" filecheck
			bash filecheck 2> /dev/null
			rm filecheck manifest_file cache_file
		else
			echo "loop 3" > stats2
			rm filecheck manifest_file cache_file
		fi
	done
	echo "$(sed -n '14p' ~/ztvh/work/datefile) finished" >> ~/ztvh/epg/status
	rm stats2 2> /dev/null
fi	

printf "\rChecking cache for missing EPG files... OK!                 " && echo "" && echo ""

rm workfile filecheck manifest_file cache_file 2> /dev/null
