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
# CREATE XMLTV FILE #
# ###################

cd ~/ztvh/epg


#
# CONVERT UNICODE CHARACTERS
#

echo "Converting special Unicode characters..."
sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' workfile
ascii2uni -a U -q workfile > workfile2
mv workfile2 workfile
sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' workfile


#
# MOVEMENT: START TIME, END TIME, CHANNEL ID
#

echo "Moving strings to setup times and channels data..."
sed -i '/"youth_protection_rating"/s/\("genres":.*\)\("recording_eligible":.*\)\("series_recording_eligible":.*\)\("youth_protection_rating":.*\)\("image_token":.*\)/\1\3\2\5/g' workfile
sed -i '/"youth_protection_rating"/s/"blackout":true/"youth_blackout":true/g' workfile
sed -i '/"youth_blackout":true/s/\("series_recording_eligible":.*\)\("episode_number":.*\)\("youth_blackout":.*\)\("success":.*\)/\1"tv_series_id":0000,\2\4/g' workfile
sed -i '/"youth_protection_rating"/s/\("series_recording_eligible":.*\)\("year":.*\)\("genres":.*\)\("title":.*\)\("start":.*\)\("image_path":.*\)\("credits".*\)\("tv_series_id":.*\)\("country":.*\)/\1\3\6\4\7\9\2\5\8/g' workfile
sed -i '/"youth_protection_rating"/s/\("series_recording_eligible":.*\)\("episode_title":.*\)\("description":.*\)\("start":.*\)\("cid":.*\)/\1\3\5\2\4/g' workfile
sed -i '/"youth_protection_rating"/s/\("series_recording_eligible":.*\)\("episode_title":.*\)\("start":.*\)\("youth_protection_rating":.*\)\("tv_series_id":.*\)/\1\3\5\2\4/g' workfile
sed -i '/"youth_protection_rating"/s/\("series_recording_eligible":.*\)\("episode_number":.*\)\("episode_title":.*\)\("recording_eligible":.*\)\("success":.*\)\("year":.*\)\("id":.*\)\("image_token":.*\)/\1\3\6\4\8\2\5\7/g' workfile
sed -i '/"youth_protection_rating"/s/\("series_recording_eligible":.*\)\("season_number":.*\)\("episode_number":.*\)\("categories":.*\)\("id":.*\)\("youth_protection_rating":.*\)/\1\3\2\5\4\6/g' workfile
sed -i '/"youth_protection_rating"/s/},"image_token":/,"image_token":/g;s/","success":/"},"success":/g;s/"youth_protection_rating":.*//g' workfile 
sed -i 's/\("channel_name":.*\)\("cid".*\)\("blackout":.*\)/\2"new_blackout":true,\1/g' workfile
sed -i 's/,"channel_name".*//g' workfile
sed -i 's/\(.*\)\("cid":".*\)/\2\1/g' workfile
sed -i -e '/"new_blackout":true/s/\("cid".*\)\("country":.*\)\("start":.*\)\("image_token":.*\)\("tv_series_id":.*\)\("episode_number":.*\)/\1\3\5\2\4\6/g' -e '/"new_blackout":true/s/\("cid":.*\)\("country":.*\)\("episode_title":.*\)\("recording_eligible":.*\)\("new_blackout":.*\)\("year":.*\)\("id":.*\)\("image_token":.*\)/\1\3\6\4\8\2\5\7/g;' -e '/"new_blackout":true/s/\("cid".*\)\("season_number":.*\)\("image_path":.*\)\("episode_number":.*\)\("categories":.*\)\("country":.*\)\("id":.*\)\("description":.*\)/\1\4\2\7\5\3\6\8/g' -e '/"new_blackout":true/s/\("cid".*\)\("image_path":.*\)\("credits":.*\)\(:{"series_recording_eligible":.*\)\("description":.*\)\("genres":.*\)\("title":.*\)/\1\4\6\2\7\3\5/g' -e '/"new_blackout":true/s/\],:{"series/\]:{"series/g;s/"new_blackout":true//g' workfile
sed -i '/"blackout":true,/s/\("cid":".*\)\("end":.*\)\("year":.*\)\("blackout":.*\)\("image_path":.*\)/\1\3\2\5/g' workfile
sed -i -e 's/"tv_series_id":.*"episode_title/"episode_title/g' -e 's/"image_url":.*"year/"year/g' -e 's/"recording_eligible":.*"episode_number/"episode_number/g' workfile
sed -i -e 's/"series_recording_eligible":false,//g' -e 's/"series_recording_eligible":true,//g' workfile
sed -i 's/\(.*\)\("episode_title.*\)\("end":".*\)/\1\3\2/g' workfile
sed -i 's/\(.*\)\("episode_number.*\)\("end":".*\)/\1\3\2/g' workfile
sed -i 's/\("cid":".*\)\("start":".*\)\("end":".*\)\("image_path":.*\)/\2\3\n\1\n\4/g' workfile


#
# CONVERT INTO XMLTV FILE FORMAT
#

echo "Converting file into XMLTV file format..."
sed -i '/"start":/{s/-//g;s/T//g;s/://g;s/Z/ +0000/g;s/"start""/<programme start="/g;s/","end"/" stop=/g;}' workfile
sed -i ':a $!N;s/\n"cid"/ "cid"/;ta P;D' workfile
sed -i 's/", "cid":"/" channel="/g' workfile
sed -i '/<programme start/s/,/>/g' workfile
sed -i '/"image_path":/{s/\("image_path":.*\)\("title":.*\)\("credits":\[.*\)\("country":.*\)\("description":.*\)/  \1\n  \2\n  \3\n  \4\n  \5/g;}' workfile
sed -i '/"episode_title":/{s/\("description":.*\)\("episode_title":.*\)\("image_url":.*\)\("year":.*\)\("recording_eligible":.*\)\("image_token":.*\)\("episode_number:.*\)\("id":.*\)\("genres":\[.*\)/\1\n  \2\n  \4\n  \7\n  \9/g;}' workfile
sed -i '/"description".*"episode_number":/{s/\("description":.*\)\("episode_title":.*\)\("image_url":.*\)\("year":.*\)\("recording_eligible":.*\)\("episode_number":.*\)\("id":.*\)\("genres":\[.*\)/\1\n  \2\n  \4\n  \6\n  \8/g;}' workfile
sed -i '/"description".*"episode_number":/{s/\("description":.*\)\("episode_title":.*\)\("year":.*\)\("episode_number".*\)\("id":.*\)\("genres":\[.*\)/\1\n  \2\n  \3\n  \4\n  \6/g;}' workfile
sed -i -e 's/"image_path":null,//g' -e 's/"episode_number":null,//g' -e 's/"season_number":null,//g' -e 's/"year":null,//g' -e 's/"episode_title":null,//g' -e 's/"episode_title":"",//g' -e 's/"credits":\[\],//g' -e 's/"genres":\[\],//g' -e 's/"country":"",//g' -e 's/"description":"",//g' -e '/^\s*$/d' workfile
sed -i 's/<https:\/\/.*>//g' workfile

sed -i '/"image_path"/{s/"image_path":"/<icon src="http:\/\/images.zattic.com\//g;s/,/ \/>/g;s/format_480x360/original/g}' workfile
sed -i -e 's/\("title"\)\(.*\)/\1\2\1/g' -e 's/"title":"/<title lang="de">/g' -e 's/","title"/<\/title>/g' workfile
sed -i -e 's/\("country"\)\(.*\)/\1\2\1/g' -e 's/"country":"/<country>/g' -e 's/","country"/<\/country>/g' workfile
sed -i -e 's/\("description"\)\(.*\)/\1\2\1/g' -e 's/"description":"/<desc lang="de">/g' -e 's/","description"/<\/desc>/g' workfile
sed -i -e 's/\("genres"\)\(.*\)/\1\2\1/g' -e 's/"genres":\["/<category lang="de">/g' -e 's/"\],"genres"/<\/category>/g' -e '/<\/category>/s/","/ \/ /g' workfile
sed -i -e 's/"credits":\[/<credits>\n/g' -e 's/{"person".*/&\n  <\/credits>/g' -e 's/{"person":"/\n     "person":"/g' -e '/"person":"/{s/\}//g;s/\]//g;}' workfile
sed -i -e '/^\s*$/d' -e '/\"person":"/{s/\("person":"\)\(.*","role":\)\(.*\)/\3\]\2\3\]/g;}' -e 's/","role":"director",\]/<\/director>/g' -e 's/"director",\]/<director>/g' -e 's/","role":"actor",\]/<\/actor>/g' -e 's/"actor",\]/<actor>/g' workfile
sed -i -e 's/\("year"\)\(.*\)/\1\2\1/g' -e 's/"year":/<date>/g' -e 's/,"year"/<\/date>/g' workfile
sed -i -e 's/\("episode_title"\)\(.*\)/\1\2\1/g' -e 's/"episode_title":"/<sub-title>/g' -e 's/","episode_title"/<\/sub-title>/g' workfile
sed -i '/"episode_number".*"season_number"/{s/,"season_number":/ S/g;s/"episode_number":/&/g;}' workfile
sed -i -e 's/\("episode_number"\)\(.*\)/\1\2\1/g' -e 's/"episode_number":/<episode-num system="onscreen">E/g' -e 's/,"episode_number"/<\/episode-num>/g' workfile
sed -i 's/\(.*<episode-num system="onscreen">\)\(E.*\)\( \)\(S.*\)\(<\/episode-num>\)/\1\4\3\2\5/g' workfile
sed -i -e 's/<programme start=/<\/programme>\n&/g' -e '$s/.*/&\n<\/programme>/g' workfile
sed -i '1d' workfile

sed -i '/"cid"/!d' ~/ztvh/work/channels_file
sed -i 's/\(.*\)\("title":.*\)\("cid":.*\)\("recording":.*\)/\3\n\2/g' ~/ztvh/work/channels_file
sed -i '/"cid"/{s/"cid": /<channel id=/g;s/",/">/g;}' ~/ztvh/work/channels_file
sed -i '/"title"/{s/"title": "/  <display-name lang="de">/g;s/",/<\/display-name>\n<\/channel>/g;}' ~/ztvh/work/channels_file
sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' ~/ztvh/work/channels_file
ascii2uni -a U -q ~/ztvh/work/channels_file > workfile2 && rm ~/ztvh/work/channels_file
sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' workfile2
cat workfile >> workfile2
sed -i '1i<?xml version="1.0" encoding="UTF-8" ?>\n<tv>' workfile2
sed -i '$s/.*/&\n<\/tv>/g' workfile2


#
# SETUP CATEGORIES
#

echo "Converting category strings to DVB format..."
sed -i '/category lang/s/>Wirtschaft.*/>Social \/ Political issues \/ Economics<\/category>/g' workfile2
sed -i '/category lang/s/>Spielshow.*/>Show \/ Game show<\/category>/g' workfile2
sed -i '/category lang/s/>Wissen.*/>Education \/ Science \/ Factual topics<\/category>/g' workfile2
sed -i '/category lang/s/>Fußball.*/>Football \/ Soccer<\/category>/g' workfile2
sed -i '/category lang/s/>Wintersport.*/>Winter sports<\/category>/g' workfile2
sed -i '/category lang/s/>Wassersport.*/>Water sport<\/category>/g' workfile2
sed -i '/category lang/s/>Reality.*/>Soap \/ Melodrama \/ Folkloric<\/category>/g' workfile2
sed -i '/category lang/s/>Eishockey.*/>Team sports (excluding football)<\/category>/g' workfile2
sed -i '/category lang/s/>US-Sport.*/>Sports<\/category>/g' workfile2
sed -i '/category lang/s/>Boxen.*/>Sports<\/category>/g' workfile2
sed -i '/category lang/s/>Golf.*/>Sports<\/category>/g' workfile2
sed -i '/category lang/s/>Motorsport.*/>Motor sport<\/category>/g' workfile2
sed -i '/category lang/s/>Radsport.*/>Sports<\/category>/g' workfile2
sed -i '/category lang/s/>Drama.*/>Movie \/ Drama<\/category>/g' workfile2
sed -i '/category lang/s/>Kino.*/>Movie \/ Drama<\/category>/g' workfile2
sed -i '/category lang/s/>Heimat.*/>Movie \/ Drama<\/category>/g' workfile2
sed -i '/category lang/s/>Tennis.*/>Tennis \/ Squash<\/category>/g' workfile2
sed -i "/category lang/s/>Humor \/ Kinderserie.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Humor \/ Familie \/ Kinderserie.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Humor \/ Familie \/ Jugend.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Humor \/ Zeichentrick.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Humor.*/>Comedy<\/category>/g' workfile2
sed -i "/category lang/s/>Krimi \/ Jugend.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Krimi.*/>Detective \/ Thriller<\/category>/g' workfile2
sed -i '/category lang/s/>Reise.*/>Tourism \/ Travel<\/category>/g' workfile2
sed -i '/category lang/s/>Kochshow.*/>Cooking<\/category>/g' workfile2
sed -i '/category lang/s/>Nachrichten.*/>News \/ Current affairs<\/category>/g' workfile2
sed -i '/category lang/s/>Dokumentation.*/>Documentary<\/category>/g' workfile2
sed -i '/category lang/s/>Homeshopping.*/>Advertisement \/ Shopping<\/category>/g' workfile2
sed -i '/category lang/s/>Magazin.*/>Magazines \/ Reports \/ Documentary<\/category>/g' workfile2
sed -i '/category lang/s/>Soap.*/>Soap \/ Melodrama \/ Folkloric<\/category>/g' workfile2
sed -i '/category lang/s/>Talkshow.*/>Talk show<\/category>/g' workfile2
sed -i '/category lang/s/>Geschichte.*/>Documentary<\/category>/g' workfile2
sed -i '/category lang/s/>Zeichentrick.*/>Cartoons \/ Puppets<\/category>/g' workfile2
sed -i "/category lang/s/>Kinderserie.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Kindershow.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Kinderfilm.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Kindernachrichten.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Abenteuer \/ Zeichentrick.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Abenteuer \/ Kinderserie.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Abenteuer.*/>Adventure \/ Western \/ War<\/category>/g' workfile2
sed -i '/category lang/s/>Krankenhaus.*/>Medicine \/ Physiology \/ Psychology<\/category>/g' workfile2
sed -i "/category lang/s/>Mystery \& Horror \/ Jugend.*.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Mystery.*/>Science fiction \/ Fantasy \/ Horror<\/category>/g' workfile2
sed -i "/category lang/s/>Comedy \/ Kinderserie.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Comedy.*/>Comedy<\/category>/g' workfile2
sed -i '/category lang/s/>Musikshow \/ Kochshow.*/>Show \/ Game show<\/category>/g' workfile2
sed -i '/category lang/s/>Musikshow.*/>Music \/ Ballet \/ Dance<\/category>/g' workfile2
sed -i '/category lang/s/>Gesundheit.*/>Fitness and health<\/category>/g' workfile2
sed -i '/category lang/s/>Gymnastik.*/>Fitness and health<\/category>/g' workfile2
sed -i '/category lang/s/>Kultur.*/>Arts \/ Culture (without music)<\/category>/g' workfile2
sed -i "/category lang/s/>Jugend.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Familie \/ Zeichentrick.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Familie \/ Kinderserie.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Familie \/ Soap.*/>Soap \/ Melodrama \/ Folkloric<\/category>/g' workfile2
sed -i '/category lang/s/>Familie \/ Reality.*/>Soap \/ Melodrama \/ Folkloric<\/category>/g' workfile2
sed -i '/category lang/s/>Familie \/ Drama.*/>Movie \/ Drama<\/category>/g' workfile2
sed -i "/category lang/s/>Familie \/ Jugend.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i "/category lang/s/>Familie \/ Abenteuer.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Familie.*/>Soap \/ Melodrama \/ Folkloric<\/category>/g' workfile2
sed -i '/category lang/s/>Erotik.*/>Adult movie \/ Drama<\/category>/g' workfile2
sed -i '/category lang/s/>Romantik \& Liebe \/ Erotik.*/>Adult movie \/ Drama<\/category>/g' workfile2
sed -i '/category lang/s/>Romantik \& Liebe.*/>Romance<\/category>/g' workfile2
sed -i '/category lang/s/>Politik.*/>Social \/ Political issues \/ Economics<\/category>/g' workfile2
sed -i '/category lang/s/>Natur.*/>Nature \/ Animals \/ Environment<\/category>/g' workfile2
sed -i '/category lang/s/>Science Fiction.*/>Science fiction \/ Fantasy \/ Horror<\/category>/g' workfile2
sed -i '/category lang/s/>Action \/ Science Fiction.*/>Science fiction \/ Fantasy \/ Horror<\/category>/g' workfile2
sed -i '/category lang/s/>Action.*/>Adventure \/ Western \/ War<\/category>/g' workfile2
sed -i '/category lang/s/>Ratgeber.*/>Magazines \/ Reports \/ Documentary<\/category>/g' workfile2
sed -i '/category lang/s/>Thriller.*/>Detective \/ Thriller<\/category>/g' workfile2
sed -i '/category lang/s/>Western.*/>Adventure \/ Western \/ War<\/category>/g' workfile2
sed -i '/category lang/s/>Extremsport.*/>Martial Sports<\/category>/g' workfile2
sed -i '/category lang/s/>Volleyball.*/>Team Sports (excluding football)<\/category>/g' workfile2
sed -i '/category lang/s/>Reportage.*/>Magazines \/ Reports \/ Documentary<\/category>/g' workfile2
sed -i '/category lang/s/>Musikclips.*/>Music \/ Ballet \/ Dance<\/category>/g' workfile2
sed -i '/category lang/s/>Klassische Musik.*/>Music \/ Ballet \/ Dance<\/category>/g' workfile2
sed -i '/category lang/s/>Volksmusik.*/>Music \/ Ballet \/ Dance<\/category>/g' workfile2
sed -i '/category lang/s/>Pop \& Rock.*/>Music \/ Ballet \/ Dance<\/category>/g' workfile2
sed -i '/category lang/s/>Motor \& Verkehr.*/>Motoring<\/category>/g' workfile2
sed -i "/category lang/s/>Fantasy \/ Kinderserie.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Fantasy.*/>Science fiction \/ Fantasy \/ Horror<\/category>/g' workfile2


#
# FINALIZATION: FIX WRONG CHARACTERS, RENAME FILE
#

sed -i -e 's/\&/\&amp;/g' -e 's/\\"/"/g' -e 's/\\n/ /g' -e 's/\\r//g' -e 's/\\t//g' workfile2
mv workfile2 ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml && cp ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ~/ztvh/zattoo_fullepg.xml && rm workfile

echo "- EPG XMLTV FILE CREATED SUCCESSFULLY! -" && echo ""
