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

# ####################
# SUM UP EPG DETAILS #
# ####################

if grep -q -E "epgdata [1-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile > ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata [2-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata [3-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata [4-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata [5-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata [6-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata [7-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata [8-9]-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '7 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q -E "epgdata 9-|epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '8 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata 1[0-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '9 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata 1[1-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '10 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata 1[2-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '11 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata 1[3-4]-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '12 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata 14-" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '13 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

sed -i '/^\s*$/d' ~/ztvh/epg/workfile
sed -i 's/"success":true}:{"/"success":true}\n:{"/g' ~/ztvh/epg/workfile
