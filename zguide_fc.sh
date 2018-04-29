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

# DAY 1
if grep -q -E "epgdata [1-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 1)             "
	rm $(date '+%Y%m%d')/workfile 2> /dev/null
	cat $(date '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date +%Y%m%d)_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 1 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date +%Y%m%d)" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi

# DAY 2
if grep -q -E "epgdata [2-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 2)             "
	rm $(date -d '1 day' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '1 day' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '1 day' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 2 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '1 day' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '1 day' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 3
if grep -q -E "epgdata [3-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 3)             "
	rm $(date -d '2 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '2 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '2 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 3 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '2 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '2 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 4
if grep -q -E "epgdata [4-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 4)             "
	rm $(date -d '3 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '3 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '3 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 4 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '3 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '3 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 5
if grep -q -E "epgdata [5-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 5)             "
	rm $(date -d '4 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '4 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '4 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 5 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '4 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '4 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi

# DAY 6
if grep -q -E "epgdata [6-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 6)             "
	rm $(date -d '5 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '5 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '5 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 6 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '5 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '5 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 7
if grep -q -E "epgdata [7-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 7)             "
	rm $(date -d '6 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '6 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '6 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 7 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '6 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '6 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 8
if grep -q -E "epgdata [8-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 8)             "
	rm $(date -d '7 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '7 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '7 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 8 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '7 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '7 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 9
if grep -q -E "epgdata 9-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 9)             "
	rm $(date -d '8 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '8 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '8 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 9 IN PROGRESS) "
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '8 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '8 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 10
if grep -q "epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 10)            "
	rm $(date -d '9 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '9 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '9 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 10 IN PROGRESS)"
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '9 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '9 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 11
if grep -q "epgdata 1[1-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 11)            "
	rm $(date -d '10 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '10 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '10 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 11 IN PROGRESS)"
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '10 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '10 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 12
if grep -q "epgdata 1[2-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 12)            "
	rm $(date -d '11 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '11 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '11 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 12 IN PROGRESS)"
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '11 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '11 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 13
if grep -q "epgdata 1[3-4]-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 13)            "
	rm $(date -d '12 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '12 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '12 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 13 IN PROGRESS)"
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '12 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '12 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

# DAY 14
if grep -q "epgdata 14-" ~/ztvh/user/options 2> /dev/null
then
	printf "\rChecking cache for missing EPG files... (DAY 14)            "
	rm $(date -d '13 days' '+%Y%m%d')/workfile 2> /dev/null
	cat $(date -d '13 days' '+%Y%m%d')/* > workfile
	sed -i -e 's/</\n</g' -e '/{"program"/!d' workfile
	sed -i -e 's/{"program"/\n/g' -e '/^\s*$/d' workfile
	sed -e 's/.*"id"://g' -e 's/},.*//g' $(date -d '13 days' '+%Y%m%d')_manifest_new > manifest_file
	sed -e '/"id"/!d' -e 's/.*"id"://g' -e 's/,"categories".*//g' -e 's/,"description".*//g' workfile > cache_file 
	comm -2 -3 <(sort -u manifest_file) <(sort cache_file) > filecheck
	if [ -s filecheck ]
	then
		printf "\rChecking cache for missing EPG files... (DAY 14 IN PROGRESS)"
		sed -i 's/.*/curl -X GET --cookie "\$session" "https:\/\/zattoo.com\/zapi\/program\/details?program_id=&" | grep "{" > \$date\/& 2> \/dev\/null/g' filecheck
		sed -i "1i #\!\/bin\/bash\nsession=\$(<~\/ztvh\/work\/session)\ndate=\$(date -d '13 days' '+%Y%m%d')" filecheck
		bash filecheck 2> /dev/null
		rm filecheck manifest_file cache_file
	fi
	echo "$(date -d '13 days' '+%Y%m%d') finished" >> ~/ztvh/epg/status
fi	

printf "\rChecking cache for missing EPG files... OK!                 " && echo "" && echo ""

rm workfile filecheck manifest_file cache_file 2> /dev/null
