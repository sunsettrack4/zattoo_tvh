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
sed -i 's/{"success": true, "programs": //g' workfile
sed -i 's/|/\\u007c/g' workfile
sed -i 's/": null, "/": null|"/g' workfile
sed -i 's/, "/|"/g' workfile
sed -i 's/\[...\]/(...)/g' workfile
sed -i 's/\], "/]|"/g' workfile
sed -i 's/\]}, "/]}|"/g' workfile
sed -i 's/}\]}/|&/g' workfile

# START/END TIME + CHANNEL ID
printf "\rCreating strings: Start, End, Channel ID             "
sed -i 's/\(.*\)\("cid":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i 's/\(.*\)\("e":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i 's/\(.*\)\("s":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i '$s/.*/&\n/g' workfile

sed -i -e 's/"s": /#/g' -e 's/|"e": /\n"e": /g' workfile
while IFS= read -r i; do if [[ $i =~ ^#([0-9]{10})$ ]]; then printf '#%s\n' "start $(date -u -d@"${BASH_REMATCH[1]}" '+%Y%m%d%H%M%S')"; else printf '%s\n' "$i"; fi; done <workfile > convert
sed -i -e 's/"e": /#/g' -e 's/|"cid": /\n"cid": /g' convert
while IFS= read -r i; do if [[ $i =~ ^#([0-9]{10})$ ]]; then printf '#%s\n' "end $(date -u -d@"${BASH_REMATCH[1]}" '+%Y%m%d%H%M%S')"; else printf '%s\n' "$i"; fi; done <convert > workfile && rm convert

sed -i 's/\(#start \)\(.*\)/<programme start="\2 +0000" /g' workfile
sed -i 's/\(#end \)\(.*\)/stop="\2 +0000" /g' workfile
sed -i ':a $!N;s/\nstop/stop/;ta P;D' workfile
sed -i 's/\("cid":[^|]*|\)\(.*\)/\1\n\2/g' workfile
sed -i 's/\("cid": \)\(.*\)|/channel=\2>/g' workfile
sed -i ':a $!N;s/\nchannel/channel/;ta P;D' workfile

# IMAGE
printf "\rCreating strings: Image_URL                          "
sed -i 's/\(\[{.*\)\("i_url":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"i_url": null|//g' -e 's/"i_url": "/  <icon src="/g' -e 's/"|\[{/" \/>\n[{/g' -e 's/format_480x360.jpg/original.jpg/g' workfile

# TITLE
printf "\rCreating strings: Title                              "
sed -i 's/\(\[{.*\)\("t":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"t": "/  <title lang="de">/g' -e 's/"|\[{/<\/title>\n[{/g' workfile 

# COUNTRY
printf "\rCreating strings: Country                            "
sed -i 's/\(\[{.*\)\("country":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"country": ""|//g' -e 's/"country": "/  <country>/g' -e 's/"|\[{/<\/country>\n[{/g' workfile

# DESCRIPTION
printf "\rCreating strings: Description                        "
sed -i 's/\(\[{.*\)\("d":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"d": ""|//g' -e 's/"d": "/  <desc lang="de">/g' -e 's/"|\[{/<\/desc>\n[{/g' workfile

# SUBTITLE
printf "\rCreating strings: Sub-Title                          "
sed -i 's/\(\[{.*\)\("et":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"et": null|//g' -e 's/"et": ""|//g' -e 's/"et": "/  <sub-title>/g' -e 's/"|\[{/<\/sub-title>\n[{/g' workfile

# AGE RATING
printf "\rCreating strings: Age Rating                         "
sed -i 's/\(\[{.*\)\("yp_r":[^|]*|\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"yp_r": null|//g' -e 's/"yp_r": "/  <rating system="FSK">\n    <value>/g' -e 's/"|\[{/<\/value>\n  <\/rating>\n[{/g' workfile

# CREDITS
printf "\rCreating strings: Credits                            "
sed -i 's/\(\[{.*\)\("cr":[^}]*\}\)\(.*\)/\2\1|\3/g' workfile
sed -i -e 's/"director": \[\]//g' -e 's/"actor": \[\]//g' -e 's/"cr": {|}//g' -e 's/"\]|}\[{"/"]|}\n[{"/g' -e 's/"\]}\[{"/"]}\n[{"/g' workfile
sed -i 's/\("cr": \)\(.*\)}/  <credits>\n\2\n  <\/credits>/g' workfile
sed -i -e 's/{|"actor": \[/{"actor": [/g' -e 's/|"actor": \[/|\n{"actor": [/g' workfile

sed -i '/{"director"/{s/{"director": \["/    <director>/g;s/"|"/<\/director>\n    <director>/g;s/"\]|/<\/director>/g}' workfile
sed -i '/{"actor"/{s/{"actor": \["/    <actor>/g;s/"|"/<\/actor>\n    <actor>/g;s/"\]/<\/actor>/g}' workfile

# GENRE/CATEGORY
printf "\rCreating strings: Category                           "
sed -i -e 's/\(\[{.*\)\("c":[^]]*\]\)\(.*\)/\2|\1|\3/g' -e 's/\("c":.*\)\("g":[^]]*\]\)\(.*\)/\2|\1|\3/g' -e 's/|\[{/|\n[{/g' workfile
sed -i -e 's/"g": \[\]|//g' -e 's/"c": \[\]|//g' workfile
sed -i -e 's/"g": \["/  <category lang="de">/g' -e 's/"\]|".*/<\/category>/g' -e 's/"c": \["/  <category lang="de">/g' -e 's/"\]|/<\/category>/g' workfile
sed -i '/<category lang="de">/s/"|"/ \/ /g' workfile

# SEASON + EPISODE
printf "\rCreating strings: Season, Episode                    "
sed -i -e 's/"e_no": null|//g' -e 's/"s_no": null|//g' workfile
sed -i -e 's/\(\[{.*\)\("e_no":[^|]*|\)\(.*\)/\2\1|\3/g' -e 's/\("e_no":.*\)\("s_no":[^|]*|\)\(.*\)/\2\1|\3/g' -e 's/\(\[{.*\)\("s_no":[^|]*|\)\(.*\)/\2\1|\3/g' -e 's/|\[{/|\n[{/g' workfile
sed -i 's/\("s_no": \)\(.*\)\(|"e_no": \)\(.*\)|/  <episode-num system="onscreen">S\2 E\4<\/episode-num>/g' workfile
sed -i -e 's/\("s_no": \)\(.*\)|/  <episode-num system="onscreen">S\2<\/episode-num>/g' -e 's/\("e_no": \)\(.*\)|/  <episode-num system="onscreen">E\2<\/episode-num>/g' workfile

# YEAR
printf "\rCreating strings: Date                               "
sed -i 's/\(\[{.*\)\("year":[0-9][0-9][0-9][0-9]\)|\(.*\)/\2|\1|\3/g' workfile
sed -i -e 's/"year":null|//g' -e 's/"year":/  <date>/g' -e 's/|\[{/<\/date>\n[{/g' workfile

# END OF PROGRAMME
printf "\rFinalizing string creation...                        "
sed -i -e 's/\[{.*/<\/programme>/g' -e '/^\s*$/d' workfile
	

#
# ADD CHANNEL LIST AND TV STRING
#

printf "\rAdding channel list to EPG file...                   "
sed 's/\(.*\)\("title": "[^"]*", \)\(.*\)/\2\1\3/g' ~/ztvh/work/epg_channels_file > workfile2
sed -i 's/\(.*\)\("cid": "[^"]*", \)\(.*\)/\2\1\3/g' workfile2
sed -i -e 's/\("cid": "[^"]*", \)\("title": "[^"]*", \)\(.*\)/\1\2-END-/g' -e  '/"level": "/d' workfile2
sed -i 's/"cid": "/<channel id="/g;s/", "title": "/">\n  <display-name lang="de">/g;s/", -END-/<\/display-name>\n<\/channel>/g' workfile2
cat workfile >> workfile2 && mv workfile2 workfile

printf "\rSetting XMLTV file type...                           "
sed -i '1i<?xml version="1.0" encoding="UTF-8" ?>\n<\!-- EPG XMLTV FILE CREATED BY ZATTOO UNLIMITED - (c) 2017-2018 Jan-Luca Neumann -->\n<tv>' workfile
sed -i "s/<tv>/<\!-- created on $(date) -->\n&/g" workfile
sed -i '$s/.*/&\n<\/tv>/g' workfile


#
# CONVERT UNICODE CHARACTERS
#

printf "\rConverting special Unicode characters...             "
sed -i 's/\\u[a-z0-9][a-z0-9][a-z0-9][a-z0-9]/\[>\[&\]<\]/g' workfile
ascii2uni -a U -q workfile > workfile2
sed -i -e 's/\[>\[//g' -e 's/\]<\]//g' workfile2


#
# SETUP CATEGORIES
#

if grep -q '"language": "de", ' ~/ztvh/work/login.txt
then
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
	sed -i '/category lang/s/>Leichtathletik.*/>Athletics<\/category>/g' workfile2
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
fi


#
# FINALIZATION: FIX WRONG CHARACTERS, RENAME FILE
#

printf "\rFinalizing XMLTV file creation...                    "
sed -i -e 's/\&/\&amp;/g' -e 's/\\"/"/g' -e 's/\\n/\n/g' -e 's/\\r//g' -e 's/\\t//g' -e 's/\\\\/\\/g' workfile2
while grep -q "<desc.*<http" workfile2
do
	sed -i "s/\(.*\)<http.*>\(.*\)\(<\/desc>\)/\1\2\3/g" workfile2
done
mv workfile2 ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml && cp ~/ztvh/epg/$(date +%Y%m%d)_zattoo_fullepg.xml ~/ztvh/zattoo_fullepg.xml && rm workfile

printf "\r- EPG XMLTV FILE CREATED SUCCESSFULLY! -             " && echo "" && echo ""
