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

if grep -q "epgdata [1-7]" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	sed -i 's/{"program"/\n/g' workfile
	sed -i '1d' workfile
	cat workfile > ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata [2-7]" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '1 day' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	sed -i 's/{"program"/\n/g' workfile
	sed -i '1d' workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata [3-7]" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '2 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	sed -i 's/{"program"/\n/g' workfile
	sed -i '1d' workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata [4-7]" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '3 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	sed -i 's/{"program"/\n/g' workfile
	sed -i '1d' workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata [5-7]" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '4 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	sed -i 's/{"program"/\n/g' workfile
	sed -i '1d' workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata [6-7]" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '5 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	sed -i 's/{"program"/\n/g' workfile
	sed -i '1d' workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi

if grep -q "epgdata 7" ~/ztvh/user/options 2> /dev/null
then 
	cd ~/ztvh/epg/$(date -d '6 days' '+%Y%m%d')
	rm workfile 2> /dev/null
	cat * >> workfile
	sed -i 's/{"program"/\n/g' workfile
	sed -i '1d' workfile
	cat workfile >> ~/ztvh/epg/workfile
	sed -i '$i\ ' ~/ztvh/epg/workfile
fi
