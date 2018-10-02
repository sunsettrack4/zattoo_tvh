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

cd ~/ztvh/work

if ! grep -q "favorites" ~/ztvh/user/options
then
	echo "favorites=false" >> ~/ztvh/user/options
fi

if [ ! -e ~/ztvh/favorites.m3u ]
then
	sed -i "s/favorites=true/favorites=false/g" ~/ztvh/user/options
fi

if grep -q "favorites=false" ~/ztvh/user/options
then
	grep "#EXTINF" ~/ztvh/channels.m3u | sed -e 's/.*, /"/g' -e 's/.*/&" \\/g' > livemenu
	nl livemenu > livemenu2 && mv livemenu2 livemenu
	
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		sed -i '1idialog --backtitle "[M1110] [INSECURE] ZATTOO UNLIMITED BETA > LIVE TV" --title "CHANNELS" --menu "Please choose the channel you want to watch:" 18 40 10 \\' livemenu
	else
		sed -i '1idialog --backtitle "[M1110] ZATTOO UNLIMITED BETA > LIVE TV" --title "CHANNELS" --menu "Please choose the channel you want to watch:" 18 40 10 \\' livemenu
	fi
	
	if [ -e ~/ztvh/favorites.m3u ]
	then
		echo '	Y "<VIEW FAVORITE CHANNELS>" \' >> livemenu
	fi
	
	echo "2>value" >> livemenu
	bash livemenu
elif grep -q "favorites=true" ~/ztvh/user/options
then
	grep "#EXTINF" ~/ztvh/favorites.m3u | sed -e 's/.*, /"/g' -e 's/.*/&" \\/g' > livemenu
	nl livemenu > livemenu2 && mv livemenu2 livemenu
	
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		sed -i '1idialog --backtitle "[M1120] [INSECURE] ZATTOO UNLIMITED BETA > LIVE TV" --title "FAVORITE CHANNELS" --menu "Please choose the channel you want to watch:" 18 40 10 \\' livemenu
	else
		sed -i '1idialog --backtitle "[M1120] ZATTOO UNLIMITED BETA > LIVE TV" --title "FAVORITE CHANNELS" --menu "Please choose the channel you want to watch:" 18 40 10 \\' livemenu
	fi
	
	echo '	Y "<VIEW ALL CHANNELS>" \' >> livemenu
	echo "2>value" >> livemenu
	bash livemenu
fi

if grep -q "Y" value
then
	if grep -q "favorites=false" ~/ztvh/user/options
	then
		sed -i "s/favorites=false/favorites=true/g" ~/ztvh/user/options
		bash ~/ztvh/live.sh
		exit 0
	elif grep -q "favorites=true" ~/ztvh/user/options
	then
		sed -i "s/favorites=true/favorites=false/g" ~/ztvh/user/options
		bash ~/ztvh/live.sh
		exit 0
	fi
elif [ -s value ]
then
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		dialog --backtitle "[M11W0] [INSECURE] ZATTOO UNLIMITED BETA > LIVE TV" --title "PLAYER" --infobox "Starting stream..." 4 30
	else
		dialog --backtitle "[M11W0] ZATTOO UNLIMITED BETA > LIVE TV" --title "PLAYER" --infobox "Starting stream..." 4 30
	fi
	
	if grep -q "favorites=false" ~/ztvh/user/options
	then
		grep "pipe://" ~/ztvh/channels.m3u > watchtv
	elif grep -q "favorites=true" ~/ztvh/user/options
	then
		grep "pipe://" ~/ztvh/favorites.m3u > watchtv
	fi
	
	sed -i -n "$(<value)p" watchtv
	sed -i 's/.*\///g' watchtv
	sed -i 's/.*/#\!\/bin\/bash\nsed "s\/pipe:1\/pipe:1 | vlc - 2> \\\\\\\\\\\/dev\\\\\\\\\\\/null \\\\\\\\\\\& disown\/g" ~\/ztvh\/chpipe\/& > test.sh\nbash test.sh/g' watchtv
	bash watchtv
	
	if grep -q "insecure=true" ~/ztvh/user/userfile
	then
		dialog --backtitle "[M11S0] [INSECURE] ZATTOO UNLIMITED BETA > LIVE TV" --title "PLAYER" --infobox "Playback started!" 4 30
	else
		dialog --backtitle "[M11S0] ZATTOO UNLIMITED BETA > LIVE TV" --title "PLAYER" --infobox "Playback started!" 4 30
	fi
	
	echo "M1100" > value
	sleep 3s
	rm watchtv
else
	rm value
fi
