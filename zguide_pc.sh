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

# ###################
# EPG PROCESS CHECK #
# ###################

cd ~/ztvh/epg

echo "Checking process status..."


#
# First checks: EPG Downloader + XMLTV Creator
#

if [ -e stats2 ]
then
	echo "- [EPG DOWNLOADER] INFO: Process interrupted in previous try! -"
	rm stats2 2> /dev/null
fi
if [ -s ~/ztvh/errorlog ]
then
	echo "- [XMLTV CREATOR] INFO: Process failed in previous try! -"
fi


#
# Further checks: EPG cache
#

# DAY 1
if grep -q "$(date +%Y%m%d) finished" status 2> /dev/null
then 
	echo "DAY 1 - $(date +%Y%m%d): DATA FOUND!"
else
	rm -rf $(date +%Y%m%d)* 2> /dev/null
fi

# DAY 2
if grep -q "$(date -d '1 day' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 2 - $(date -d '1 day' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '1 day' '+%Y%m%d')* 2> /dev/null
fi

# DAY 3
if grep -q "$(date -d '2 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 3 - $(date -d '2 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '2 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 4
if grep -q "$(date -d '3 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 4 - $(date -d '3 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '3 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 5
if grep -q "$(date -d '4 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 5 - $(date -d '4 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '4 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 6
if grep -q "$(date -d '5 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 6 - $(date -d '5 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '5 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 7
if grep -q "$(date -d '6 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 7 - $(date -d '6 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '6 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 8
if grep -q "$(date -d '7 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 8 - $(date -d '7 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '7 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 9
if grep -q "$(date -d '8 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 9 - $(date -d '8 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '8 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 10
if grep -q "$(date -d '9 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 10 - $(date -d '9 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '9 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 11
if grep -q "$(date -d '10 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 11 - $(date -d '10 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '10 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 12
if grep -q "$(date -d '11 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 12 - $(date -d '11 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '11 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 13
if grep -q "$(date -d '12 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 13 - $(date -d '12 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '12 days' '+%Y%m%d')* 2> /dev/null
fi

# DAY 14
if grep -q "$(date -d '13 days' '+%Y%m%d') finished" status 2> /dev/null
then
	echo "DAY 14 - $(date -d '13 days' '+%Y%m%d'): DATA FOUND!"
else
	rm -rf $(date -d '13 days' '+%Y%m%d')* 2> /dev/null
fi
