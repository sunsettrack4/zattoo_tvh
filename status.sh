#!/bin/bash

#      Copyright (C) 2017-2019 Jan-Luca Neumann
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

# ########################
# ADD PROGRESS BAR       #
# ########################

cd ~/ztvh/work

x=$(wc -l < ~/ztvh/epg/scriptfile_00)
y=20
h=100

if [ $x -gt $h ]
then
	z5=$(expr $x / $y)
	z10=$(expr $x / $y \* 2)
	z15=$(expr $x / $y \* 3)
	z20=$(expr $x / $y \* 4)
	z25=$(expr $x / $y \* 5)
	z30=$(expr $x / $y \* 6)
	z35=$(expr $x / $y \* 7)
	z40=$(expr $x / $y \* 8)
	z45=$(expr $x / $y \* 9)
	z50=$(expr $x / $y \* 10)
	z55=$(expr $x / $y \* 11)
	z60=$(expr $x / $y \* 12)
	z65=$(expr $x / $y \* 13)
	z70=$(expr $x / $y \* 14)
	z75=$(expr $x / $y \* 15)
	z80=$(expr $x / $y \* 16)
	z85=$(expr $x / $y \* 17)
	z90=$(expr $x / $y \* 18)
	z95=$(expr $x / $y \* 19)

	echo "#!/bin/bash" > progressbar
	echo "cd ~/ztvh/epg" >> progressbar

	# START
	echo "sed -i '2i\\" >> progressbar
	echo "Progress: [                    ]   0%%' scriptfile_00" >> progressbar

	# 5%
	echo "sed -i '$z5 i\\" >> progressbar
	echo "Progress: [#                   ]   5%%' scriptfile_00" >> progressbar

	# 10%
	echo "sed -i '$z10 i\\" >> progressbar
	echo "Progress: [##                  ]  10%%' scriptfile_00" >> progressbar
	
	# 15%
	echo "sed -i '$z15 i\\" >> progressbar
	echo "Progress: [###                 ]  15%%' scriptfile_00" >> progressbar

	# 20%
	echo "sed -i '$z20 i\\" >> progressbar
	echo "Progress: [####                ]  20%%' scriptfile_00" >> progressbar

	# 25%
	echo "sed -i '$z25 i\\" >> progressbar
	echo "Progress: [#####               ]  25%%' scriptfile_00" >> progressbar

	# 30%
	echo "sed -i '$z30 i\\" >> progressbar
	echo "Progress: [######              ]  30%%' scriptfile_00" >> progressbar

	# 35%
	echo "sed -i '$z35 i\\" >> progressbar
	echo "Progress: [#######             ]  35%%' scriptfile_00" >> progressbar

	# 40%
	echo "sed -i '$z40 i\\" >> progressbar
	echo "Progress: [########            ]  40%%' scriptfile_00" >> progressbar

	# 45%
	echo "sed -i '$z45 i\\" >> progressbar
	echo "Progress: [#########           ]  45%%' scriptfile_00" >> progressbar

	# 50%
	echo "sed -i '$z50 i\\" >> progressbar
	echo "Progress: [##########          ]  50%%' scriptfile_00" >> progressbar

	# 55%
	echo "sed -i '$z55 i\\" >> progressbar
	echo "Progress: [###########         ]  55%%' scriptfile_00" >> progressbar

	# 60%
	echo "sed -i '$z60 i\\" >> progressbar
	echo "Progress: [############        ]  60%%' scriptfile_00" >> progressbar

	# 65%
	echo "sed -i '$z65 i\\" >> progressbar
	echo "Progress: [#############       ]  65%%' scriptfile_00" >> progressbar

	# 70%
	echo "sed -i '$z70 i\\" >> progressbar
	echo "Progress: [##############      ]  70%%' scriptfile_00" >> progressbar

	# 75%
	echo "sed -i '$z75 i\\" >> progressbar
	echo "Progress: [###############     ]  75%%' scriptfile_00" >> progressbar

	# 80%
	echo "sed -i '$z80 i\\" >> progressbar
	echo "Progress: [################    ]  80%%' scriptfile_00" >> progressbar

	# 85%
	echo "sed -i '$z85 i\\" >> progressbar
	echo "Progress: [#################   ]  85%%' scriptfile_00" >> progressbar

	# 90%
	echo "sed -i '$z90 i\\" >> progressbar
	echo "Progress: [##################  ]  90%%' scriptfile_00" >> progressbar

	# 95%
	echo "sed -i '$z95 i\\" >> progressbar
	echo "Progress: [################### ]  95%%' scriptfile_00" >> progressbar

	# 100%
	echo "sed -i '\$i\\" >> progressbar
	echo "Progress: [####################] 100%%' scriptfile_00" >> progressbar

	sed -i 's/ i/i/g' progressbar
	bash progressbar
	sed -i -e 's/Progress/printf "\\rProgress/g' -e '/Progress/s/.*/&"/g' ~/ztvh/epg/scriptfile_00
	rm progressbar
fi
