#!/bin/bash

# ZATTOO PLUS FOR TVHEADEND - ADDITIONAL SCRIPT (2)
# https://github.com/sunsettrack4/zattoo_tvh

# CONVERT TVG CHANNEL IDs TO RYTEC FORMAT
# INPUT FILE: zattoo_fullepg.xml

# Run the following command to change the name of the input file:
# sed -i 's/zattoo_fullepg.xml/.../g' ch-zattoo2rytec.sh
  

if [ -e zattoo_fullepg.xml ]
then
	echo "Converting channel IDs..."
else
	echo "- ERROR: INPUT FILE NOT FOUND! -"
fi


# ZATTOO SWITZERLAND - CHANNEL LIST - 2018/12/15

# ##############################
# ALLGEMEIN                    #
# ##############################

sed -i 's/="sf-1">/="SRF1.ch">/g' zattoo_fullepg.xml							# SRF 1 HD
sed -i 's/="sf-2">/="SRF2.ch">/g' zattoo_fullepg.xml							# SRF zwei HD
sed -i 's/="sf-info">/="SRFinfo.ch">/g' zattoo_fullepg.xml						# SRF info HD
sed -i 's/="3plus">/="3plus.ch">/g' zattoo_fullepg.xml							# 3+ HD
sed -i 's/="4plus">/="4plus.ch">/g' zattoo_fullepg.xml							# 4+ HD
sed -i 's/="ard">/="ARD.de">/g' zattoo_fullepg.xml								# Das Erste HD
sed -i 's/="zdf">/="ZDF.de">/g' zattoo_fullepg.xml								# ZDF HD
sed -i 's/="tv24">/="TV24.ch">/g' zattoo_fullepg.xml							# TV24
sed -i 's/="rtl">/="RTL.ch">/g' zattoo_fullepg.xml								# RTL HD
sed -i 's/="prosieben">/="Pro7.ch">/g' zattoo_fullepg.xml						# Pro7 Schweiz HD
sed -i 's/="sat1">/="Sat1.ch">/g' zattoo_fullepg.xml							# Sat.1 Schweiz HD
sed -i 's/="vox">/="Vox.ch">/g' zattoo_fullepg.xml								# VOX HD
sed -i 's/="rtl-2">/="RTL2.ch">/g' zattoo_fullepg.xml							# RTL II HD
sed -i 's/="kabel-eins">/="Kabel.ch">/g' zattoo_fullepg.xml						# kabel eins HD
sed -i 's/="kabel1_doku">/="KabelEinsDoku.de">/g' zattoo_fullepg.xml			# Kabel 1 Doku
sed -i 's/="telezueri">/="TeleZuri.ch">/g' zattoo_fullepg.xml					# Telezüri
sed -i 's/="tv25">/="TV25.ch">/g' zattoo_fullepg.xml							# TV25
sed -i 's/="s1">/="S1.ch">/g' zattoo_fullepg.xml								# S1 HD
sed -i 's/="puls8">/="Puls8.ch">/g' zattoo_fullepg.xml							# Puls 8 HD
sed -i 's/="swiss_1">/="Swiss1.ch">/g' zattoo_fullepg.xml						# Swiss 1 HD
sed -i 's/="startv">/="StarTV.ch">/g' zattoo_fullepg.xml						# Star TV
sed -i 's/="orf-1">/="ORF1.at">/g' zattoo_fullepg.xml							# ORF1 HD
sed -i 's/="orf-2">/="ORF2.at">/g' zattoo_fullepg.xml							# ORF2 HD
sed -i 's/="dmax">/="DMax.ch">/g' zattoo_fullepg.xml							# DMAX
sed -i 's/="pro7maxx">/="ProSiebenMaxx.de">/g' zattoo_fullepg.xml				# ProSieben MAXX HD
sed -i 's/="rtlnitro">/="RTLNitro.ch">/g' zattoo_fullepg.xml					# NITRO HD
sed -i 's/="comedycentral">/="ComedyCentral\/VIVA.ch">/g' zattoo_fullepg.xml	# Comedy Central HD
sed -i 's/="rocketbeans">/="RocketBeans.de">/g' zattoo_fullepg.xml				# Rocket Beans TV
sed -i 's/="n24_doku">/="N24Doku.de">/g' zattoo_fullepg.xml						# N24 Doku
sed -i 's/="weltderwunder">/="WeltDerWunder.de">/g' zattoo_fullepg.xml			# Welt der Wunder
sed -i 's/="sat1gold">/="Sat1Gold.de">/g' zattoo_fullepg.xml					# SAT.1 Gold HD
sed -i 's/="de_sixx">/="Sixx.ch">/g' zattoo_fullepg.xml							# Sixx HD
sed -i 's/="tlc">/="TLC.de">/g' zattoo_fullepg.xml								# TLC
sed -i 's/="tele-5">/="Tele5.de">/g' zattoo_fullepg.xml							# TELE 5 HD
sed -i 's/="rtl_plus">/="RTLPlus.de">/g' zattoo_fullepg.xml						# RTLplus
sed -i 's/="anixe">/="Anixe.de">/g' zattoo_fullepg.xml							# Anixe
sed -i 's/="anixe_hd">/="AnixeHD.de">/g' zattoo_fullepg.xml						# Anixe HD
sed -i 's/="servus_tv">/="ServusHD.de">/g' zattoo_fullepg.xml					# Servus TV HD
sed -i 's/="eotv">/="eoTV.de">/g' zattoo_fullepg.xml							# eoTV HD
sed -i 's/="channel_55">/="Channel55.ch">/g' zattoo_fullepg.xml					# Channel 55
sed -i 's/="super-rtl">/="SuperRTL.ch">/g' zattoo_fullepg.xml					# Super RTL Schweiz HD
sed -i 's/="disney">/="disneychannel.de">/g' zattoo_fullepg.xml					# Disney Channel
sed -i 's/="nick">/="Nickelodeon.ch">/g' zattoo_fullepg.xml						# Nick HD
sed -i 's/="kika">/="Kika.de">/g' zattoo_fullepg.xml							# KikA HD
sed -i 's/="ric">/="RiC.de">/g' zattoo_fullepg.xml								# RiC
sed -i 's/="toggo_plus">/="TOGGOplus.de">/g' zattoo_fullepg.xml					# TOGGO plus
sed -i 's/="DE_arte">/="ARTE.de">/g' zattoo_fullepg.xml							# ARTE HD
sed -i 's/="3sat">/="3sat.de">/g' zattoo_fullepg.xml							# 3Sat HD
sed -i 's/="phoenix">/="phoenix.de">/g' zattoo_fullepg.xml						# Phoenix HD
sed -i 's/="br">/="BR.de">/g' zattoo_fullepg.xml								# BR Fernsehen Süd HD
sed -i 's/="hr">/="HR.de">/g' zattoo_fullepg.xml								# HR HD
sed -i 's/="mdr-sachsen">/="MDRSachsen.de">/g' zattoo_fullepg.xml				# MDR SACHSEN HD
sed -i 's/="ndr-niedersachsen">/="ndrnds.de">/g' zattoo_fullepg.xml				# NDR Niedersachsen HD
sed -i 's/="rbb">/="rbbBerlin.de">/g' zattoo_fullepg.xml						# rbb Berlin HD
sed -i 's/="sr-fernsehen">/="SRFernsehen.de">/g' zattoo_fullepg.xml				# SR Fernsehen HD
sed -i 's/="swr-fernsehen-bw">/="SWR.de">/g' zattoo_fullepg.xml					# SWR BW HD
sed -i 's/="wdr-koeln">/="WDR.de">/g' zattoo_fullepg.xml						# WDR Köln HD
sed -i 's/="radio-bremen-tv">/="RadioBremen.de">/g' zattoo_fullepg.xml			# Radio Bremen TV
sed -i 's/="einsextra">/="tagesschau24.de">/g' zattoo_fullepg.xml				# tagesschau24 HD
sed -i 's/="einsfestival">/="One.de">/g' zattoo_fullepg.xml						# ONE HD
sed -i 's/="br-alpha">/="ARD-alpha.de">/g' zattoo_fullepg.xml					# ARD-alpha
sed -i 's/="zdf-info">/="ZDFinfo.de">/g' zattoo_fullepg.xml						# ZDFinfo HD
sed -i 's/="zdfneo">/="ZDFneo.de">/g' zattoo_fullepg.xml						# ZDFneo HD
sed -i 's/="hse24">/="HSE24.de">/g' zattoo_fullepg.xml							# HSE 24
sed -i 's/="hse24_extra">/="HSE24Extra.de">/g' zattoo_fullepg.xml				# HSE24 Extra
sed -i 's/="hse24_trend">/="HSE24Trend.de">/g' zattoo_fullepg.xml				# HSE24 Trend


# ##############################
# ZATTOO+                      #
# ##############################

sed -i 's/="pro7_fun">/="ProSiebenFun.de">/g' zattoo_fullepg.xml				# ProSieben FUN HD
sed -i 's/="kabel_eins_classics">/="KabelEinsClassic.de">/g' zattoo_fullepg.xml	# Kabel eins CLASSICS
sed -i 's/="sat1_emotions">/="Sat1Comedy.de">/g' zattoo_fullepg.xml				# Sat.1 emotions
sed -i 's/="automotorsporttv">/="AutoMotorSport.de">/g' zattoo_fullepg.xml		# auto motor und sport Channel HD
sed -i 's/="motorvision_tv"/="MotorVision.de">/g' zattoo_fullepg.xml			# Motorvision TV
sed -i 's/="planet">/="PLANET.de">/g' zattoo_fullepg.xml						# Planet HD
sed -i 's/="kinowelt">/="Kinowelt.de">/g' zattoo_fullepg.xml					# Kinowelt
sed -i 's/="fueltv">/="FuelTV.pt">/g' zattoo_fullepg.xml						# Fuel TV HD
sed -i 's/="hustlerblue">/="BlueHustler.ero">/g' zattoo_fullepg.xml				# Blue Hustler
sed -i 's/="rcktv">/="RCKTV.de">/g' zattoo_fullepg.xml							# RCK.TV HD
sed -i 's/="cmusic">/="CMusic.eu">/g' zattoo_fullepg.xml						# C Music
sed -i 's/="yourfamily">/="FixFoxi.de">/g' zattoo_fullepg.xml					# Fix & Foxi
sed -i 's/="jukebox">/="Jukebox.de">/g' zattoo_fullepg.xml						# Jukebox HD
sed -i 's/="gute_laune_tv">/="GuteLauneTV.de">/g' zattoo_fullepg.xml			# Gute Laune TV HD
sed -i 's/="spiegeltvwissen">/="SpiegelTV.de">/g' zattoo_fullepg.xml			# Spiegel TV Wissen


# ##############################
# FERNSEHEN MIT HERZ           #
# ##############################

sed -i 's/="goldstar_tv">/="GoldstarTV.de">/g' zattoo_fullepg.xml					# GoldStar TV
sed -i 's/="heimatkanal">/="Heimatkanal.de">/g' zattoo_fullepg.xml					# Heimatkanal
sed -i 's/="romance_tv">/="Romance.de">/g' zattoo_fullepg.xml						# Romance TV


# ##############################
# REGIONALE KANÄLE             #
# ##############################

sed -i 's/="tele_top">/="TeleTop.ch">/g' zattoo_fullepg.xml							# Tele Top
sed -i 's/="telebaern">/="TeleBaern.ch">/g' zattoo_fullepg.xml						# TeleBärn
sed -i 's/="telebasel">/="TeleBasel.ch">/g' zattoo_fullepg.xml						# TeleBasel
sed -i 's/="telebielingue">/="TeleBielingue.ch">/g' zattoo_fullepg.xml				# TeleBielingue
sed -i 's/="telem1">/="TeleM1.ch">/g' zattoo_fullepg.xml							# Tele M1
sed -i 's/="tele1">/="Tele1.ch">/g' zattoo_fullepg.xml								# Tele 1 HD
sed -i 's/="becurioustv">/="BeCuriousTV.ch">/g' zattoo_fullepg.xml					# beCuriousTV
sed -i 's/="canal9">/="Canal9.ch">/g' zattoo_fullepg.xml							# Canal9
sed -i 's/="latele">/="LaTele.ch">/g' zattoo_fullepg.xml							# LaTele
sed -i 's/="lemanbleu">/="LemanBleu.ch">/g' zattoo_fullepg.xml						# Leman Bleu
sed -i 's/="canalalpha">/="CanalAlpha.ch">/g' zattoo_fullepg.xml					# Canal Alpha NE HD
sed -i 's/="booster_tv">/="BoosterTV.ch">/g' zattoo_fullepg.xml						# Booster TV
sed -i 's/="teleostschweiz">/="TVO.ch">/g' zattoo_fullepg.xml						# TVO
sed -i 's/="telesuedostschweiz">/="TSO.ch">/g' zattoo_fullepg.xml					# TeleSüdostschweiz HD
sed -i 's/="teleticino">/="TeleTicino.ch">/g' zattoo_fullepg.xml					# teleticino
sed -i 's/="kanal9">/="Kanal9.ch">/g' zattoo_fullepg.xml							# Kanal9
sed -i 's/="tvm3">/="TVM3.ch">/g' zattoo_fullepg.xml								# TVM3
sed -i 's/="r9_at">/="R9Osterreich.at">/g' zattoo_fullepg.xml						# R9 Österreich HD


# ##############################
# SPORT                        #
# ##############################

sed -i 's/="dsf">/="Sport1HD.de">/g' zattoo_fullepg.xml							# Sport1 HD
sed -i 's/="eurosport">/="Eurosport1.de">/g' zattoo_fullepg.xml					# Eurosport 1
sed -i 's/="sky_sport_news_de">/="SkySportNewsHD.de">/g' zattoo_fullepg.xml		# Sky Sport News HD
sed -i 's/="teleclub_zoom">/="TCZoom.ch">/g' zattoo_fullepg.xml					# Teleclub Zoom HD


# ##############################
# EROTIK                       #
# ##############################

sed -i 's/="hustlertv">/="HustlerHD.ero">/g' zattoo_fullepg.xml						# Hustler TV
sed -i 's/="daringtv">/="PrivateTV.ero">/g' zattoo_fullepg.xml						# Private TV
sed -i 's/="visitx">/="VisitX.de">/g' zattoo_fullepg.xml							# VISIT-X.TV


# ##############################
# NACHRICHTEN                  #
# ##############################

sed -i 's/="al-jazeera">/="AlJazeera.nws">/g' zattoo_fullepg.xml					# Al Jazeera English HD
sed -i 's/="bloomberg-europe">/="Bloomberg.nws">/g' zattoo_fullepg.xml				# Bloomberg TV
sed -i 's/="cnn-international">/="CNN.nws">/g' zattoo_fullepg.xml					# CNN International HD
sed -i 's/="cnnmoney_switzerland">/="CNNMoney.ch">/g' zattoo_fullepg.xml			# CNNMoney Switzerland HD
sed -i 's/="bbc-world-service">/="BBCWorldNews.nws">/g' zattoo_fullepg.xml			# BBC World News HD
sed -i 's/="skynews-intl">/="SkyNews.uk">/g' zattoo_fullepg.xml						# Sky News
sed -i 's/="cnbceurope_b2c">/="CNBC.nws">/g' zattoo_fullepg.xml						# CNBC Europe
sed -i 's/="euronewsgerman">/="EuronewsDE.nws">/g' zattoo_fullepg.xml				# Euronews [ger]
sed -i 's/="euronews-en">/="Euronews.nws">/g' zattoo_fullepg.xml					# EuroNews [en] HD
sed -i 's/="france-24-en">/="France24.fr">/g' zattoo_fullepg.xml					# France 24 HD [en]
sed -i 's/="france-24-fr">/="France24fr.fr">/g' zattoo_fullepg.xml					# France 24 HD [fr]
sed -i 's/="n24">/="WELT.de">/g' zattoo_fullepg.xml									# WELT
sed -i 's/="n-tv">/="ntv.ch">/g' zattoo_fullepg.xml									# n-tv HD
sed -i 's/="daf">/="DAF.de">/g' zattoo_fullepg.xml									# Der Aktionär TV HD
sed -i 's/="deutschewelle_de">/="DeutscheWelleDE.de">/g' zattoo_fullepg.xml			# Deutsche Welle
sed -i 's/="deutsche-welle">/="DeutscheWelleEN.de">/g' zattoo_fullepg.xml			# Deutsche Welle [en]
sed -i 's/="deutschewelle_ar">/="DeutscheWelleAR.de">/g' zattoo_fullepg.xml			# Deutsche Welle Arabic
sed -i 's/="wetter_tv">/="Wetterfernsehen.ch">/g' zattoo_fullepg.xml				# wetter.tv
sed -i 's/="i24news_english">/="i24News.en.nws">/g' zattoo_fullepg.xml				# i24 News [en]
sed -i 's/="i24news_french">/="i24News.fr">/g' zattoo_fullepg.xml					# i24 News [fr]
sed -i 's/="bvn">/="BVN.be">/g' zattoo_fullepg.xml									# BVN


# ##############################
# MUSIK TV                     #
# ##############################

sed -i 's/="mtv">/="MTV.ch">/g' zattoo_fullepg.xml											# MTV HD
sed -i 's/="viva">/="ComedyCentral\/VIVA.ch">/g' zattoo_fullepg.xml							# VIVA HD
sed -i 's/="deluxe-music">/="DeLuxeMusic.de">/g' zattoo_fullepg.xml							# DELUXE MUSIC
sed -i 's/="deutschesmusikfernsehen">/="DeutschesMusikFernsehen.de">/g' zattoo_fullepg.xml	# Deutsches Musik Fernsehen
sed -i 's/="gotv_austria">/="go.tv">/g' zattoo_fullepg.xml									# GoTV
sed -i 's/="kiss_tv">/="KissTV.uk">/g' zattoo_fullepg.xml									# Kiss TV
sed -i 's/="clubland_tv">/="ClublandTV.uk">/g' zattoo_fullepg.xml							# Clubland TV
sed -i 's/="chilled_tv">/="ChilledTV.uk">/g' zattoo_fullepg.xml								# Now 90s
sed -i 's/="heat">/="BoxUpfront.uk">/g' zattoo_fullepg.xml									# Box Upfront
sed -i 's/="chart_show_tv_uk">/="ChartShowTV.uk">/g' zattoo_fullepg.xml						# Chart Show TV


# ##############################
# SPEZIELLES INTERESSE         #
# ##############################

sed -i 's/="zee_one">/="ZeeOne.de">/g' zattoo_fullepg.xml						# Zee.One HD
sed -i 's/="qs24_ch">/="QS24.ch">/g' zattoo_fullepg.xml							# QS24
sed -i 's/="health_tv_de">/="HealthTV.de">/g' zattoo_fullepg.xml				# Health.tv
sed -i 's/="fashiontv">/="FashionTV.eu">/g' zattoo_fullepg.xml					# Fashion TV
sed -i 's/="nasa_tv">/="NASA.us">/g' zattoo_fullepg.xml							# NASA TV
sed -i 's/="bibeltv">/="BibelTV.de">/g' zattoo_fullepg.xml						# Bibel TV
sed -i 's/="god-channel-tv">/="GODChannel.eu">/g' zattoo_fullepg.xml			# GOD Channel
sed -i 's/="sonlife">/="Sonlife.uk">/g' zattoo_fullepg.xml						# SONLife
sed -i 's/="ktv">/="KTV.de">/g' zattoo_fullepg.xml								# K-TV
sed -i 's/="kto">/="KTO.fr">/g' zattoo_fullepg.xml								# KTO
sed -i 's/="netviet_vn">/="NetViet.vn">/g' zattoo_fullepg.xml					# NETVIET
sed -i 's/="rt_doc">/="RTDocumentary.pl">/g' zattoo_fullepg.xml					# RT Doc


# ##############################
# ENGLISCH                     #
# ##############################

sed -i 's/="itv-1-london">/="ITV1London.uk">/g' zattoo_fullepg.xml				# ITV 1 HD
sed -i 's/="itv-2">/="ITV2.uk">/g' zattoo_fullepg.xml							# ITV 2
sed -i 's/="itv-3">/="ITV3.uk">/g' zattoo_fullepg.xml							# ITV 3
sed -i 's/="itv-4">/="ITV4.uk">/g' zattoo_fullepg.xml							# ITV 4
sed -i 's/="itvbe">/="ITVBe.uk">/g' zattoo_fullepg.xml							# ITVBe
sed -i 's/="bbc-one">/="BBC1London.uk">/g' zattoo_fullepg.xml					# BBC One HD
sed -i 's/="bbc2">/="BBC2.uk">/g' zattoo_fullepg.xml							# BBC Two HD
sed -i 's/="bbc-four">/="BBC4.uk">/g' zattoo_fullepg.xml						# BBC Four HD
sed -i 's/="bbc_news">/="BBCNews.nws">/g' zattoo_fullepg.xml					# BBC News HD
sed -i 's/="bbc-parliament">/="BBCParliament.uk">/g' zattoo_fullepg.xml			# BBC Parliament
sed -i 's/="bbc-arabic">/="BBCArabic.net">/g' zattoo_fullepg.xml				# BBC Arabic
sed -i 's/="cbbc">/="CBBC.uk">/g' zattoo_fullepg.xml							# CBBC HD
sed -i 's/="cbeebies">/="CBeebies.uk">/g' zattoo_fullepg.xml					# CBeebies
sed -i 's/="channel-4">/="Channel4.uk">/g' zattoo_fullepg.xml					# Channel 4 HD
sed -i 's/="five">/="Channel5.uk">/g' zattoo_fullepg.xml						# Channel 5 HD
sed -i 's/="5usa">/="FiveUSA.uk">/g' zattoo_fullepg.xml							# 5USA
sed -i 's/="5spike_uk">/="Spike.uk">/g' zattoo_fullepg.xml						# 5Spike
sed -i 's/="my5_uk">/="My5.uk">/g' zattoo_fullepg.xml							# 5SELECT
sed -i 's/="e4">/="E4.uk">/g' zattoo_fullepg.xml								# E4
sed -i 's/="film4">/="Film4.uk">/g' zattoo_fullepg.xml							# Film 4
sed -i 's/="more4">/="More4.uk">/g' zattoo_fullepg.xml							# More 4
sed -i 's/="4seven_uk">/="4Seven.uk">/g' zattoo_fullepg.xml						# 4Seven
sed -i 's/="s4c">/="S4C.uk">/g' zattoo_fullepg.xml								# S4C HD
sed -i 's/="4music_uk">/="4Music.uk">/g' zattoo_fullepg.xml						# 4Music
sed -i 's/="drama_uk">/="Drama.uk">/g' zattoo_fullepg.xml						# Drama
sed -i 's/="paramount_network_uk">/="Paramount.uk">/g' zattoo_fullepg.xml		# Paramount Network
sed -i 's/="dave_uk">/="Dave.uk">/g' zattoo_fullepg.xml							# Dave
sed -i 's/="yesterday_uk">/="Yesterday.uk">/g' zattoo_fullepg.xml				# Yesterday
sed -i 's/="pick_uk">/="PickTV.uk">/g' zattoo_fullepg.xml						# Pick
sed -i 's/="challenge_uk">/="Challenge.uk">/g' zattoo_fullepg.xml				# Challenge
sed -i 's/="food_network_uk">/="FoodNetwork.uk">/g' zattoo_fullepg.xml			# Food Network
sed -i 's/="travelchannel_en">/="TravelChannel.uk">/g' zattoo_fullepg.xml		# Travel Channel
sed -i 's/="pbs_america">/="PBS.uk">/g' zattoo_fullepg.xml						# PBS America
sed -i 's/="freesports_uk">/="FreeSports.uk">/g' zattoo_fullepg.xml				# FreeSports


# ##############################
# FRANZÖSISCH                  #
# ##############################

sed -i 's/="tsr1">/="RTSUn.ch">/g' zattoo_fullepg.xml							# RTS un HD
sed -i 's/="tsr2">/="RTSDeux.ch">/g' zattoo_fullepg.xml							# RTS deux HD
sed -i 's/="tf1">/="TF1.fr">/g' zattoo_fullepg.xml								# TF1 HD
sed -i 's/="m6-suisse">/="M6.fr">/g' zattoo_fullepg.xml							# M6 Suisse HD
sed -i 's/="france-2">/="France2.fr">/g' zattoo_fullepg.xml						# France 2 HD
sed -i 's/="france-3">/="France3.fr">/g' zattoo_fullepg.xml						# France 3 HD
sed -i 's/="france-4">/="France4.fr">/g' zattoo_fullepg.xml						# France 4 HD
sed -i 's/="france-5">/="France5.fr">/g' zattoo_fullepg.xml						# France 5 HD
sed -i 's/="tmc">/="TMC.fr">/g' zattoo_fullepg.xml								# TMC
sed -i 's/="direct-8">/="C8.fr">/g' zattoo_fullepg.xml							# C8 Suisse HD
sed -i 's/="w9suisse">/="W9.fr">/g' zattoo_fullepg.xml							# W9 Suisse
sed -i 's/="arte-france">/="ARTE.fr">/g' zattoo_fullepg.xml						# ARTE [fr] HD
sed -i 's/="gulli">/="Gulli.fr">/g' zattoo_fullepg.xml							# Gulli HD
sed -i 's/="nrj-12">/="NRJ12.fr">/g' zattoo_fullepg.xml							# NRJ 12 HD
sed -i 's/="tv5mondefbs">/="TV5MondeFBS.fr">/g' zattoo_fullepg.xml				# TV5 Monde FBS
sed -i 's/="tv5-monde">/="TV5MondeEurope.fr">/g' zattoo_fullepg.xml				# TV5 Monde
sed -i 's/="france-o">/="FranceO.fr">/g' zattoo_fullepg.xml						# France Ô HD
sed -i 's/="bfmtv">/="BFMTV.fr">/g' zattoo_fullepg.xml							# BFM TV
sed -i 's/="i_tele">/="CNews.fr">/g' zattoo_fullepg.xml							# CNEWS HD
sed -i 's/="d17">/="CStar.fr">/g' zattoo_fullepg.xml							# CSTAR HD
sed -i 's/="nt1">/="TFX.fr">/g' zattoo_fullepg.xml								# TFX
sed -i 's/="hd1">/="TF1SeriesFilms.fr">/g' zattoo_fullepg.xml					# TF1 Séries Films
sed -i 's/="lequipe21">/="EquipeTV.fr">/g' zattoo_fullepg.xml					# L'Equipe 21
sed -i 's/="6ter">/="6ter.fr">/g' zattoo_fullepg.xml							# 6ter
sed -i 's/="numero23">/="Numero23.fr">/g' zattoo_fullepg.xml					# RMC Story
sed -i 's/="rmcdecouverte">/="RMCdecouverte.fr">/g' zattoo_fullepg.xml			# RMC Découverte
sed -i 's/="cherie25">/="Cherie25.fr">/g' zattoo_fullepg.xml					# Chérie 25
sed -i 's/="lci">/="LCI.fr">/g' zattoo_fullepg.xml								# LCI HD
sed -i 's/="france_info">/="Franceinfo.fr">/g' zattoo_fullepg.xml				# France Info
sed -i 's/="rougetv">/="RougeTV.ch">/g' zattoo_fullepg.xml						# Rouge TV
sed -i 's/="euronews-fr">/="EuronewsFR.nws">/g' zattoo_fullepg.xml				# Euronews [fr]


# ##############################
# ITALIENISCH                  #
# ##############################

sed -i 's/="rsi-la1">/="RSILa1.ch">/g' zattoo_fullepg.xml							# RSI La1 HD
sed -i 's/="rsi-la2">/="RSILa2.ch">/g' zattoo_fullepg.xml							# RSI La2 HD
sed -i 's/="canale-5">/="Canale5.it">/g' zattoo_fullepg.xml							# Canale 5
sed -i 's/="rai-uno">/="Rai1.it">/g' zattoo_fullepg.xml								# Rai Uno HD
sed -i 's/="rai-due">/="Rai2.it">/g' zattoo_fullepg.xml								# Rai Due HD
sed -i 's/="rai-tre">/="Rai3.it">/g' zattoo_fullepg.xml								# Rai Tre HD
sed -i 's/="rai_4">/="Rai4.it">/g' zattoo_fullepg.xml								# Rai 4
sed -i 's/="rai_5">/="Rai5.it">/g' zattoo_fullepg.xml								# Rai 5
sed -i 's/="rai_movie">/="RaiMovie.it">/g' zattoo_fullepg.xml						# Rai Movie
sed -i 's/="rai_premium">/="RaiPremium.it">/g' zattoo_fullepg.xml					# Rai Premium
sed -i 's/="rai_sport">/="RaiSport.it">/g' zattoo_fullepg.xml						# Rai Sport
sed -i 's/="rai_sport_plus">/="RaiSportPlus.it">/g' zattoo_fullepg.xml				# Rai Sport + HD
sed -i 's/="rainews">/="RaiNews.it">/g' zattoo_fullepg.xml							# RAI News
sed -i 's/="raigulp">/="RaiGulp.it">/g' zattoo_fullepg.xml							# Rai Gulp
sed -i 's/="rai_yoyo">/="RaiYoyo.it">/g' zattoo_fullepg.xml							# Rai Yoyo
sed -i 's/="rai_scuola">/="RaiScuola.it">/g' zattoo_fullepg.xml						# Rai Scuola
sed -i 's/="rai_storia">/="RaiStoria.it">/g' zattoo_fullepg.xml						# Rai Storia
sed -i 's/="paramount_channel_it">/="ParamountChannel.it">/g' zattoo_fullepg.xml	# Paramount Channel Italy
sed -i 's/="cine_sony_it">/="CineSonyItalia.it">/g' zattoo_fullepg.xml				# Cine Sony
sed -i 's/="italia-1">/="Italia1.it">/g' zattoo_fullepg.xml							# Italia 1
sed -i 's/="italia_2">/="Italia2.it">/g' zattoo_fullepg.xml							# Italia 2
sed -i 's/="rete-4">/="Rete4.it">/g' zattoo_fullepg.xml								# Rete 4
sed -i 's/="20_mediaset_it">/="20Mediaset.it">/g' zattoo_fullepg.xml				# 20 Mediaset
sed -i 's/="iris">/="Iris.it">/g' zattoo_fullepg.xml								# IRIS
sed -i 's/="la_5">/="LA5.it">/g' zattoo_fullepg.xml									# La5
sed -i 's/="la-7">/="La7.it">/g' zattoo_fullepg.xml									# La 7
sed -i 's/="la_7_d">/="La7d.it">/g' zattoo_fullepg.xml								# La 7 d
sed -i 's/="real_time_it">/="RealTime.it">/g' zattoo_fullepg.xml					# Real Time
sed -i 's/="class_tv_moda">/="ClassTVModa.it">/g' zattoo_fullepg.xml				# ClassTvModa
sed -i 's/="alice_it">/="Alice.it">/g' zattoo_fullepg.xml							# Alice
sed -i 's/="cielo">/="Cielo.it">/g' zattoo_fullepg.xml								# Cielo
sed -i 's/="rtl102_5">/="RTL102.5TV.it">/g' zattoo_fullepg.xml						# RTL 102.5
sed -i 's/="nove_it">/="Nove.it">/g' zattoo_fullepg.xml								# NOVE
sed -i 's/="mtvitalia">/="Tv8.it">/g' zattoo_fullepg.xml							# TV8
sed -i 's/="dmaxitalia">/="DMAX.it">/g' zattoo_fullepg.xml							# DMAX Italia
sed -i 's/="spike_italia">/="Spike.it">/g' zattoo_fullepg.xml						# Spike Italia
sed -i 's/="giallo_it">/="Giallo.it">/g' zattoo_fullepg.xml							# Giallo
sed -i 's/="marcopolo_it">/="Marcopolo.it">/g' zattoo_fullepg.xml					# Marcopolo
sed -i 's/="focus_it">/="Focus.it">/g' zattoo_fullepg.xml							# Focus
sed -i 's/="canale_italia">/="CanaleItalia.it">/g' zattoo_fullepg.xml				# Canale Italia
sed -i 's/="euronews_italian">/="EuronewsIT.nws">/g' zattoo_fullepg.xml				# Euronews [it]
sed -i 's/="sky_tg24_it">/="SkyTG24.it">/g' zattoo_fullepg.xml						# Sky TG24
sed -i 's/="uninettuno_it">/="UNINETTUNOUniversityTV.it">/g' zattoo_fullepg.xml		# UniNettuno University TV
sed -i 's/="telepace">/="Telepace.it">/g' zattoo_fullepg.xml						# Telepace HD
sed -i 's/="boing">/="Boing.it">/g' zattoo_fullepg.xml								# Boing
sed -i 's/="frisbee_it">/="Frisbee.it">/g' zattoo_fullepg.xml						# Frisbee
sed -i 's/="k2_it">/="K2.it">/g' zattoo_fullepg.xml									# K2
sed -i 's/="cartoonito_it">/="Cartoonito.it">/g' zattoo_fullepg.xml					# Cartoonito
sed -i 's/="super_it">/="Super!.it">/g' zattoo_fullepg.xml							# Super!


# ##############################
# SPANISCH                     #
# ##############################

sed -i 's/="tve">/="TVE.sp">/g' zattoo_fullepg.xml										# TVE
sed -i 's/="canal24horas">/="Canal24Horas.es">/g' zattoo_fullepg.xml					# 24H
sed -i 's/="deutschewelle_es">/="DeutscheWelleES.de">/g' zattoo_fullepg.xml				# Deutsche Welle Spanish


# ##############################
# BOSNISCH                     #
# ##############################

sed -i 's/="bntv">/="BNTV.hr">/g' zattoo_fullepg.xml						# BN-TV
sed -i 's/="cmc">/="CMC.hr">/g' zattoo_fullepg.xml							# CMC - Croatian Music Channel


# ##############################
# KROATISCH                    #
# ##############################

sed -i 's/="dmsat">/="DMSat.hr">/g' zattoo_fullepg.xml						# DM Sat
sed -i 's/="hrt1">/="HRTTV1.hr">/g' zattoo_fullepg.xml						# HRT 1
sed -i 's/="hrt4">/="HRT4.hr">/g' zattoo_fullepg.xml						# HRT 4
sed -i 's/="hrt5">/="HRT5.hr">/g' zattoo_fullepg.xml						# HRT 5
sed -i 's/="cmc">/="CMC.hr">/g' zattoo_fullepg.xml							# CMC - Croatian Music Channel


# ##############################
# POLNISCH                     #
# ##############################

sed -i 's/="itvn">/="iTVN.pl">/g' zattoo_fullepg.xml							# ITVN
sed -i 's/="tvn24">/="TVN24.pl">/g' zattoo_fullepg.xml							# TVN24


# ##############################
# TÜRKISCH                     #
# ##############################

sed -i 's/="tr_euro_d">/="EuroD.bg">/g' zattoo_fullepg.xml							# Euro D
sed -i 's/="tr_euro_star">/="EUROSTAR.il">/g' zattoo_fullepg.xml					# Euro Star
sed -i 's/="tr_kanal_7">/="Kanal7.tr">/g' zattoo_fullepg.xml						# Kanal 7 Avrupa
sed -i 's/="cnn_turk">/="CNN.tr">/g' zattoo_fullepg.xml								# CNN TÜRK
sed -i 's/="halk_tv">/="HalkTV.tr">/g' zattoo_fullepg.xml							# Halk TV
sed -i 's/="tr_show_turk">/="15.Show TV.digiturk.com.tr">/g' zattoo_fullepg.xml		# Show Turk
sed -i 's/="haber_turk">/="31.HaberTURK.digiturk.com.tr">/g' zattoo_fullepg.xml		# Haber Türk TV
sed -i 's/="tv8">/="TV8.tr">/g' zattoo_fullepg.xml									# TV8 Int
sed -i 's/="power_turk">/="PowerTurk.tr">/g' zattoo_fullepg.xml						# Power Turk TV
sed -i 's/="dream_turk">/="DreamTurk.tr">/g' zattoo_fullepg.xml						# dream TÜRK


# ##############################
# PORTUGIESISCH                #
# ##############################

sed -i 's/="rtpi">/="RTPi.pt">/g' zattoo_fullepg.xml								# RTP Internacional
sed -i 's/="rtp_3">/="RTP3.pt">/g' zattoo_fullepg.xml								# RTP3
sed -i 's/="recordinternacional">/="tvrecord.pt">/g' zattoo_fullepg.xml				# RecordTV
sed -i 's/="record_news">/="RecordNews.pt">/g' zattoo_fullepg.xml					# Record News
sed -i 's/="kuriakos_tv">/="KURIAKOSTV.pt">/g' zattoo_fullepg.xml					# Kuriakos TV HD


# ##############################
# PINK                         #
# ##############################

sed -i 's/="pinkplus">/="PINKPlus.hr">/g' zattoo_fullepg.xml					# Pink Plus
sed -i 's/="pinkextra">/="PinkExtra.si">/g' zattoo_fullepg.xml					# Pink Extra
sed -i 's/="pinkreality">/="PinkReality.rs">/g' zattoo_fullepg.xml				# Pink Reality
sed -i 's/="pinkfilm">/="PinkFilm.rs">/g' zattoo_fullepg.xml					# Pink Film
sed -i 's/="pink_serije_rs">/="PinkSerije.rs">/g' zattoo_fullepg.xml			# Pink Serije
sed -i 's/="pink_world_rs">/="PinkWorld.rs">/g' zattoo_fullepg.xml				# Pink World
sed -i 's/="pinkkids">/="PINKKids.rs">/g' zattoo_fullepg.xml					# Pink Kids
sed -i 's/="pink_koncert_rs">/="PinkLive.rs">/g' zattoo_fullepg.xml				# Pink Koncert
sed -i 's/="pinkfolk">/="PinkFolk1.rs">/g' zattoo_fullepg.xml					# Pink Folk
sed -i 's/="pinkmusic">/="PinkMusic.si">/g' zattoo_fullepg.xml					# Pink Music


# ##############################

echo "--- DONE ---"
