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
# EXTRACT REQUIRED DATA
#

# SET UP DELIMITERS
printf "\rSetting up delimiters...                             "
sed -i 's/|/\\u007c/g' workfile
sed -i 's/":null,"/":null|"/g' workfile
sed -i 's/","/"|"/g' workfile
sed -i 's/\],/]|/g' workfile
sed -i 's/},"success":true}/|,|,|/g' workfile
sed -i '/</d' workfile

# START/END TIME + CHANNEL ID
printf "\rCreating strings: Start, End, Channel ID             "
sed -i 's/\(.*\)\("cid":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i 's/\(.*\)\("end":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i 's/\(.*\)\("start":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"start":"/<programme start="/g' -e 's/"|"end":"/ +0000" end="/g' -e 's/"|"cid":"/ +0000" channel="/g' -e 's/"|:{/">\n:{/g' workfile
sed -i 's/\([0-9][0-9][0-9][0-9]\)-\([0-2][0-9]\)-\([0-3][0-9]\)T\([0-2][0-9]\):\([0-5][0-9]\):\([0-5][0-9]\)Z/\1\2\3\4\5\6/g' workfile

# IMAGE
printf "\rCreating strings: Image_URL                          "
sed -i 's/\(:{.*\)\("image_url":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"image_url":null|//g' -e 's/"image_url":"/  <icon src="/g' -e 's/"|:{/" \/>\n:{/g' workfile

# TITLE
printf "\rCreating strings: Title                              "
sed -i 's/\(:{.*\)\("title":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"title":"/  <title>/g' -e 's/"|:{/<\/title>\n:{/g' workfile 

# COUNTRY
printf "\rCreating strings: Country                            "
sed -i 's/\(:{.*\)\("country":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"country":""|//g' -e 's/"country":"/  <country>/g' -e 's/"|:{/<\/country>\n:{/g' workfile

# DESCRIPTION
printf "\rCreating strings: Description                        "
sed -i 's/\(:{.*\)\("description":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"description":""|//g' -e 's/"description":"/  <desc lang="de">/g' -e 's/"|:{/<\/desc>\n:{/g' workfile
sed -i '/<desc lang="de"/s/"|/",/g' workfile

# SUBTITLE
printf "\rCreating strings: Sub-Title                          "
sed -i 's/\(:{.*\)\("episode_title":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"episode_title":null|//g' -e 's/"episode_title":""|//g' -e 's/"episode_title":"/  <sub-title>/g' -e 's/"|:{/<\/sub-title>\n:{/g' workfile

# AGE RATING
printf "\rCreating strings: Age Rating                         "
sed -i 's/\(:{.*\)\("youth_protection_rating":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"youth_protection_rating":null|//g' -e 's/"youth_protection_rating":"/  <rating>\n    <age>/g' -e 's/"|:{/<\/age>\n  <\/rating>\n:{/g' workfile

# CREDITS
printf "\rCreating strings: Credits                            "
sed -i 's/\(:{.*\)\("credits":[^]]*\]\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"credits":\[\]//g' -e 's/{"person":/\n&/g' -e 's/"credits":\[/  <credits>/g' -e 's/}\]:{/},\n  <\/credits>\n:{/g' workfile
sed -i -e 's/\({"person":"\)\(.*\)\("|"role":"director"},\)/    <director>\2<\/director>/g' workfile
sed -i -e 's/\({"person":"\)\(.*\)\("|"role":"actor"},\)/    <actor>\2<\/actor>/g' workfile

# GENRE/CATEGORY
printf "\rCreating strings: Category                           "
sed -i -e 's/\(:{.*\)\("categories":[^]]*\]\)\(.*\)/\2|\1|\3/g' -e 's/\("categories":.*\)\("genres":[^]]*\]\)\(.*\)/\2|\1|\3/g' -e 's/|:{/|\n:{/g' workfile
sed -i -e 's/"genres":\[\]|//g' -e 's/"categories":\[\]|//g' workfile
sed -i -e 's/"genres":\["/  <category lang="de">/g' -e 's/"\]|".*/<\/category>/g' -e 's/"categories":\["/  <category lang="de">/g' -e 's/"\]|/<\/category>/g' workfile
sed -i '/<category lang="de">/s/"|"/ \/ /g' workfile

# SEASON + EPISODE
printf "\rCreating strings: Season, Episode                    "
sed -i -e 's/"episode_number":null|//g' -e 's/"season_number":null|//g' workfile 
sed -i -e 's/\(:{.*\)\("episode_number":[^,]*,\)\(.*\)/\2\1|\3/g' -e 's/\("episode_number":.*\)\("season_number":[^,]*,\)\(.*\)/\2\1|\3/g' -e 's/\(:{.*\)\("season_number":[^,]*,\)\(.*\)/\2\1|\3/g' -e 's/,:{/,\n:{/g' workfile
sed -i -e '/"episode_number":/s/|//g' -e '/"season_number":/s/|//g' workfile
sed -i 's/\("season_number":\)\(.*\)\(,"episode_number":\)\(.*\),/  <episode num="onscreen">S\2 E\4<\/episode>/g' workfile
sed -i -e 's/\("season_number":\)\(.*\),/  <episode num="onscreen">S\2<\/episode>/g' -e 's/\("episode_number":\)\(.*\),/  <episode num="onscreen">E\2<\/episode>/g' workfile

# YEAR
printf "\rCreating strings: Date                               "
sed -i 's/\(:{.*\)\("year":[0-9][0-9][0-9][0-9]\),\(.*\)/\2|\1|\3/g' workfile
sed -i -e 's/"year":null|//g' -e 's/"year":/  <year>/g' -e 's/|:{/<\/year>\n:{/g' workfile

# END OF PROGRAMME
printf "\rFinalizing string creation...                        "
sed -i -e 's/:{.*/<\/programme>/g' -e '/^\s*$/d' workfile
	

#
# CONVERT UNICODE CHARACTERS
#

printf "\rConverting special Unicode characters...             "
sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' workfile
ascii2uni -a U -q workfile > workfile2
mv workfile2 workfile
sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' workfile
	

#
# ADD CHANNEL LIST AND TV STRING
#

printf "\rAdding channel list to EPG file...                   "
sed -i '/"cid"/!d' ~/ztvh/work/channels_file
sed -i 's/\(.*\)\("title":.*\)\("cid":.*\)\("recording":.*\)/\3\n\2/g' ~/ztvh/work/channels_file
sed -i '/"cid"/{s/"cid": /<channel id=/g;s/",/">/g;}' ~/ztvh/work/channels_file
sed -i '/"title"/{s/"title": "/  <display-name lang="de">/g;s/",/<\/display-name>\n<\/channel>/g;}' ~/ztvh/work/channels_file
sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' ~/ztvh/work/channels_file
ascii2uni -a U -q ~/ztvh/work/channels_file > workfile2 && rm ~/ztvh/work/channels_file
sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' workfile2
cat workfile >> workfile2

printf "\rSetting XMLTV file type...                           "
sed -i '1i<?xml version="1.0" encoding="UTF-8" ?>\n<tv>' workfile2
sed -i '$s/.*/&\n<\/tv>/g' workfile2


#
# SETUP CATEGORIES
#

printf "\rConverting category strings to DVB format...         "

sed -i '/category lang/s/>Filme<.*/>Movie \/ Drama<\/category>/g' workfile2
sed -i '/category lang/s/>Dokumentationen<.*/>Documentary<\/category>/g' workfile2
sed -i "/category lang/s/>Kinderprogramm<.*/>Children's \/ Youth programs<\/category>/g" workfile2
sed -i '/category lang/s/>Sport<.*/>Sports<\/category>/g' workfile2
sed -i '/category lang/s/>Information<.*/>Magazines \/ Reports \/ Documentary<\/category>/g' workfile2
sed -i '/category lang/s/>Unterhaltung<.*/>Show \/ Game show<\/category>/g' workfile2
sed -i '/category lang/s/>Serien<.*/>Movie \/ Drama<\/category>/g' workfile2

sed -i '/category lang/s/>Wirtschaft.*/>Social \/ Political issues \/ Economics<\/category>/g' workfile2
sed -i '/category lang/s/>Spielshow.*/>Show \/ Game show<\/category>/g' workfile2
sed -i '/category lang/s/>Wissen.*/>Education \/ Science \/ Factual topics<\/category>/g' workfile2
sed -i '/category lang/s/>Fußball.*/>Football \/ Soccer<\/category>/g' workfile2
sed -i '/category lang/s/>Handball.*/>Team sports (excluding football)<\/category>/g' workfile2
sed -i '/category lang/s/>Wintersport.*/>Winter sports<\/category>/g' workfile2
sed -i '/category lang/s/>Wassersport.*/>Water sport<\/category>/g' workfile2
sed -i '/category lang/s/>Reality.*/>Soap \/ Melodrama \/ Folkloric<\/category>/g' workfile2
sed -i '/category lang/s/>Gerichtsshow.*/>Soap \/ Melodrama \/ Folkloric<\/category>/g' workfile2
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
sed -i '/category lang/s/>Theater.*/>Performing arts<\/category>/g' workfile2
sed -i '/category lang/s/>Musical.*/>Performing arts<\/category>/g' workfile2
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

printf "\rFinalizing XMLTV file creation...                    "
sed -i -e 's/\&/\&amp;/g' -e 's/\\"/"/g' -e 's/\\n/\n/g' -e 's/\\r//g' -e 's/\\t//g' -e 's/\\\\/\\/g' workfile2
mv workfile2 ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml && cp ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ~/ztvh/zattoo_fullepg.xml && rm workfile

printf "\r- EPG XMLTV FILE CREATED SUCCESSFULLY! -             " && echo "" && echo ""
