#!/bin/bash

# ZATTOO PLUS FOR TVHEADEND - ADDITIONAL SCRIPT (1)
# https://github.com/sunsettrack4/zattoo_tvh

# CONVERT TVG CHANNEL IDs TO RYTEC FORMAT
# INPUT FILE: zattoo_fullepg.xml

# Run the following command to change the name of the input file:
# sed -i 's/zattoo_fullepg.xml/.../g' de-zattoo2rytec.sh
  

if [ -e zattoo_fullepg.xml ]
then
	echo "Converting channel IDs..."
else
	echo "- ERROR: INPUT FILE NOT FOUND! -"
fi


# ZATTOO GERMANY - CHANNEL LIST

# ##############################
# NATIONAL                     #
# ##############################

sed -i 's/="ard">/="ARD.de">/g' zattoo_fullepg.xml						# Das Erste
sed -i 's/="zdf">/="ZDF.de">/g' zattoo_fullepg.xml						# ZDF
sed -i 's/="dsf">/="Sport1HD.de">/g' zattoo_fullepg.xml						# Sport1
sed -i 's/="comedycentral_de">/="ComedyCentral\/VIVA.de">/g' zattoo_fullepg.xml			# Comedy Central
sed -i 's/="n24">/="WELT.de">/g' zattoo_fullepg.xml						# WELT
sed -i 's/="tele-5">/="Tele5.de">/g' zattoo_fullepg.xml						# TELE 5
sed -i 's/="nickelodeon">/="Nickelodeon.de">/g' zattoo_fullepg.xml				# Nick
sed -i 's/="kika">/="Kika.de">/g' zattoo_fullepg.xml						# KiKA
sed -i 's/="mtvgermany">/="MTVGermany.de">/g' zattoo_fullepg.xml				# MTV Germany
sed -i 's/="viva_de">/="ComedyCentral\/VIVA.de">/g' zattoo_fullepg.xml				# VIVA
sed -i 's/="deutschesmusikfernsehen">/="DeutschesMusikFernsehen.de">/g' zattoo_fullepg.xml	# Deutsches Musik Fernsehen
sed -i 's/="3sat">/="3sat.de">/g' zattoo_fullepg.xml						# 3sat
sed -i 's/="DE_arte">/="ARTE.de">/g' zattoo_fullepg.xml						# ARTE
sed -i 's/="phoenix">/="phoenix.de">/g' zattoo_fullepg.xml					# PHOENIX
sed -i 's/="ndr-niedersachsen">/="ndr.de">/g' zattoo_fullepg.xml				# NDR Niedersachsen
sed -i 's/="mdr-sachsen">/="MDRSachsen.de">/g' zattoo_fullepg.xml				# MDR SACHSEN
sed -i 's/="wdr-koeln">/="WDR.de">/g' zattoo_fullepg.xml					# WDR Köln
sed -i 's/="br">/="BR.de">/g' zattoo_fullepg.xml						# BR Fernsehen Süd
sed -i 's/="swr-fernsehen-bw">/="SWR.de">/g' zattoo_fullepg.xml					# SWR Fernsehen BW
sed -i 's/="hr">/="HR.de">/g' zattoo_fullepg.xml						# HR
sed -i 's/="rbb">/="rbbBerlin.de">/g' zattoo_fullepg.xml					# rbb Berlin
sed -i 's/="sr-fernsehen">/="SRFernsehen.de">/g' zattoo_fullepg.xml				# SR Fernsehen
sed -i 's/="radio-bremen-tv">/="RadioBremen.de">/g' zattoo_fullepg.xml				# Radio Bremen TV
sed -i 's/="zdfneo">/="ZDFneo.de">/g' zattoo_fullepg.xml					# ZDFneo
sed -i 's/="einsextra">/="tagesschau24.de">/g' zattoo_fullepg.xml				# tagesschau24
sed -i 's/="euronewsgerman">/="Euronews.nws">/g' zattoo_fullepg.xml				# Euronews [ger]
sed -i 's/="einsfestival">/="One.de">/g' zattoo_fullepg.xml					# ONE
sed -i 's/="zdf-info">/="ZDFinfo.de">/g' zattoo_fullepg.xml					# ZDFinfo
sed -i 's/="br-alpha">/="ARD-alpha.de">/g' zattoo_fullepg.xml					# ARD alpha
sed -i 's/="weltderwunder">/="WeltDerWunder.de">/g' zattoo_fullepg.xml				# Welt der Wunder
sed -i 's/="ric">/="RiC.de">/g' zattoo_fullepg.xml						# RiC
sed -i 's/="eotv">/="eoTV.de">/g' zattoo_fullepg.xml						# eoTV
# sed -i 's/="qs24_ch">/&/g' zattoo_fullepg.xml							### QS24
# sed -i 's/="health_tv_de">/&/g' zattoo_fullepg.xml						### Health.tv
sed -i 's/="sonnenklartv">/="SonnenKlar.de">/g' zattoo_fullepg.xml				# Sonnenklar TV
# sed -i 's/="daf">/&/g' zattoo_fullepg.xml							### Der Aktionär TV
sed -i 's/="familytv">/="FamilyTV.de">/g' zattoo_fullepg.xml					# Family TV
sed -i 's/="fashiontv">/="FashionTV.eu">/g' zattoo_fullepg.xml					# Fashion TV
sed -i 's/="deluxe-music">/="DeLuxeMusic.de">/g' zattoo_fullepg.xml				# DELUXE MUSIC
# sed -i 's/="timm">/&/g' zattoo_fullepg.xml							### TIMM
sed -i 's/="hse24">/="HSE24.de">/g' zattoo_fullepg.xml						# HSE 24
# sed -i 's/="hse24_extra">/&/g' zattoo_fullepg.xml						### HSE24 Extra
# sed -i 's/="hse24_trend">/&/g' zattoo_fullepg.xml						### HSE24 Trend
sed -i 's/="123tv">/="123.tv.de">/g' zattoo_fullepg.xml						# 1-2-3 TV
sed -i 's/="qvc_germany">/="QVC.de">/g' zattoo_fullepg.xml					# QVC
sed -i 's/="qvcplus">/="QVCPlus.de">/g' zattoo_fullepg.xml					# QVC 2
# sed -i 's/="qvc_beauty_de">/&/g' zattoo_fullepg.xml						### QVC Style
# sed -i 's/="pearltv">/&/g' zattoo_fullepg.xml							### Pearl.tv
sed -i 's/="bibeltv">/="BibelTV.de">/g' zattoo_fullepg.xml					# Bibel TV


# ##############################
# VERFÜGBAR MIT ZATTOO PREMIUM #
# ##############################

sed -i 's/="rtl_deutschland">/="RTL.de">/g' zattoo_fullepg.xml					# RTL Deutschland
sed -i 's/="pro7_deutschland">/="Pro7.de">/g' zattoo_fullepg.xml				# Pro7 Deutschland HD
sed -i 's/="sat1_deutschland">/="Sat1.de">/g' zattoo_fullepg.xml				# Sat.1 Deutschland HD
sed -i 's/="vox_deutschland">/="Vox.de">/g' zattoo_fullepg.xml					# Vox Deutschland
sed -i 's/="kabel_eins_deutschland">/="Kabel.de">/g' zattoo_fullepg.xml				# kabel eins Deutschland HD
sed -i 's/="rtl2_deutschland">/="RTL2.de">/g' zattoo_fullepg.xml				# RTL2 Deutschland
sed -i 's/="super_rtl_deutschland">/="SuperRTL.de">/g' zattoo_fullepg.xml			# Super RTL Deutschland
sed -i 's/="sixx_deutschland">/="Sixx.de">/g' zattoo_fullepg.xml				# Sixx HD
sed -i 's/="pro7maxx">/="ProSiebenMaxx.de">/g' zattoo_fullepg.xml				# ProSieben MAXX HD
sed -i 's/="ntv_de">/="ntv.de">/g' zattoo_fullepg.xml						# n-tv
sed -i 's/="sat1gold">/="Sat1Gold.de">/g' zattoo_fullepg.xml					# SAT.1 Gold HD
sed -i 's/="toggo_plus">/="TOGGOplus.de">/g' zattoo_fullepg.xml					# TOGGO plus
sed -i 's/="rtl_plus">/="RTLPlus.de">/g' zattoo_fullepg.xml					# RTLplus
sed -i 's/="kabel1_doku">/="KabelEinsDoku.de">/g' zattoo_fullepg.xml				# Kabel 1 Doku
sed -i 's/="dmax">/="DMax.de">/g' zattoo_fullepg.xml						# DMAX HD
sed -i 's/="tlc">/="TLC.de">/g' zattoo_fullepg.xml						# TLC HD


# ##############################
# REGIONAL                     #
# ##############################

# sed -i 's/="br_nord">/="BR.de">/g' zattoo_fullepg.xml						### BR Fernsehen Nord
sed -i 's/="mdr-sachsen-anhalt">/="MDRS-Anhalt.de">/g' zattoo_fullepg.xml			# MDR SACHSEN-ANHALT
sed -i 's/="mdr-thueringen">/="MDRThuringen.de">/g' zattoo_fullepg.xml				# MDR THÜRINGEN
# sed -i 's/="ndr-hamburg">/="ndr.de">/g' zattoo_fullepg.xml					### NDR Hamburg ==> NDR Niedersachsen
# sed -i 's/="ndr-mv">/="ndr.de">/g' zattoo_fullepg.xml						### NDR Mecklenburg-Vorpommern ==> NDR Niedersachsen
# sed -i 's/="ndr-schleswig-holstein">/="ndr.de">/g' zattoo_fullepg.xml				### NDR Schleswig-Holstein ==> NDR Niedersachsen
sed -i 's/="rbb-brandenburg">/="rbbBrandenburg.de">/g' zattoo_fullepg.xml			# rbb Brandenburg
sed -i 's/="swr-fernsehen-rp">/="SWR-rp.de">/g' zattoo_fullepg.xml				# SWR Fernsehen RP
# sed -i 's/="wdr-aachen">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Aachen ==> WDR Köln
# sed -i 's/="wdr-bielefeld">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Bielefeld ==> WDR Köln
# sed -i 's/="wdr-bonn">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Bonn ==> WDR Köln
# sed -i 's/="wdr-dortmund">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Dortmund ==> WDR Köln
# sed -i 's/="wdr-duesseldorf">/="WDR.de">/g' zattoo_fullepg.xml				### WDR Düsseldorf ==> WDR Köln
# sed -i 's/="wdr-duisburg">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Duisburg ==> WDR Köln
# sed -i 's/="wdr-essen">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Essen ==> WDR Köln
# sed -i 's/="wdr-muenster">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Muenster ==> WDR Köln
# sed -i 's/="wdr-siegen">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Siegen ==> WDR Köln
# sed -i 's/="wdr-wuppertal">/="WDR.de">/g' zattoo_fullepg.xml					### WDR Wuppertal ==> WDR Köln
# sed -i 's/="nrwision">/&/g' zattoo_fullepg.xml						### nrwision
# sed -i 's/="saarland_fernsehen1">/&/g' zattoo_fullepg.xml					### Saarland Fernsehen 1


# ##############################
# INTERNATIONAL                #
# ##############################

sed -i 's/="orf2_europe">/="ORF2.at">/g' zattoo_fullepg.xml					# ORF 2 Europe
sed -i 's/="sf-info-intl">/="SRFinfo.ch">/g' zattoo_fullepg.xml					# SRF info HD
sed -i 's/="cnn-international">/="CNN.nws">/g' zattoo_fullepg.xml				# CNN International
sed -i 's/="france-24-fr">/="France24fr.fr">/g' zattoo_fullepg.xml				# France 24 [fr]
sed -i 's/="france-24-en">/="France24.fr">/g' zattoo_fullepg.xml				# France 24 [en]
sed -i 's/="bloomberg_europe">/="Bloomberg.nws">/g' zattoo_fullepg.xml				# Bloomberg TV
# sed -i 's/="euronews-en">/&/g' zattoo_fullepg.xml						### EuroNews [en] ==> Euronews [ger]
sed -i 's/="deutsche-welle">/="DeutscheWelleEN.de">/g' zattoo_fullepg.xml			# Deutsche Welle [en]
# sed -i 's/="r1">/&/g' zattoo_fullepg.xml							### R1
sed -i 's/="sonlife">/="Sonlife.uk">/g' zattoo_fullepg.xml					# SONLife
sed -i 's/="god-channel-tv">/="GODChannel.eu">/g' zattoo_fullepg.xml				# GOD Channel
sed -i 's/="tve">/="TVE.sp">/g' zattoo_fullepg.xml						# TVE
sed -i 's/="canal24horas">/="Canal24Horas.es">/g' zattoo_fullepg.xml				# 24H
sed -i 's/="rt_doc">/="RTDocumentary.pl">/g' zattoo_fullepg.xml					# RT Doc


# ##############################
# ZATTOO+                      #
# ##############################

sed -i 's/="pro7_fun">/="ProSiebenFun.de">/g' zattoo_fullepg.xml				# ProSieben FUN HD
sed -i 's/="sat1_emotions">/="Sat1Comedy.de">/g' zattoo_fullepg.xml				# Sat.1 emotions
sed -i 's/="kabel_eins_classics">/="KabelEinsClassic.de">/g' zattoo_fullepg.xml			# Kabel eins CLASSICS
sed -i 's/="sport1_us">/="Sport1US.de">/g' zattoo_fullepg.xml					# Sport1 US HD
sed -i 's/="sportdigital">/="sportdigital.de">/g' zattoo_fullepg.xml				# Sportdigital HD
sed -i 's/="automotorsporttv">/="AutoMotorSport.de">/g' zattoo_fullepg.xml			# auto motor und sport Channel HD
sed -i 's/="planet">/="PLANET.de">/g' zattoo_fullepg.xml					# Planet HD
sed -i 's/="fueltv">/="FuelTV.pt">/g' zattoo_fullepg.xml					# Fuel TV HD
sed -i 's/="yourfamily">/="FixFoxi.de">/g' zattoo_fullepg.xml					# Fix & Foxi
sed -i 's/="hustlerblue">/="BlueHustler.ero">/g' zattoo_fullepg.xml				# Blue Hustler
# sed -i 's/="rcktv">/&/g' zattoo_fullepg.xml							### RCK.TV HD
sed -i 's/="cmusic">/="CMusic.eu">/g' zattoo_fullepg.xml					# C Music
sed -i 's/="jukebox">/="Jukebox.de">/g' zattoo_fullepg.xml					# Jukebox HD
sed -i 's/="spiegeltvwissen">/="SpiegelTV.de">/g' zattoo_fullepg.xml				# Spiegel TV Wissen
sed -i 's/="wetter_com_tv">/="Wetterfernsehen.de">/g' zattoo_fullepg.xml			# wetter.com TV


# ##############################
# FERNSEHEN MIT HERZ           #
# ##############################

sed -i 's/="goldstar_tv">/="GoldstarTV.de">/g' zattoo_fullepg.xml				# GoldStar TV
sed -i 's/="heimatkanal">/="Heimatkanal.de">/g' zattoo_fullepg.xml				# Heimatkanal
sed -i 's/="romance_tv">/="Romance.de">/g' zattoo_fullepg.xml					# Romance TV


# ##############################
# EROTIK                       #
# ##############################

# sed -i 's/="visitx">/&/g' zattoo_fullepg.xml							### VISIT-X.TV


# ##############################
# POLNISCH                     #
# ##############################

sed -i 's/="itvn">/="iTVN.pl">/g' zattoo_fullepg.xml						# ITVN
sed -i 's/="tvn24">/="TVN24.pl">/g' zattoo_fullepg.xml						# TVN24


# ##############################
# TÜRKISCH                     #
# ##############################

sed -i 's/="tr_euro_d">/="EuroD.bg">/g' zattoo_fullepg.xml					# Euro D
sed -i 's/="tr_euro_star">/="EUROSTAR.il">/g' zattoo_fullepg.xml				# Euro Star
sed -i 's/="tr_kanal_7">/="Kanal7.tr">/g' zattoo_fullepg.xml					# Kanal 7 Avrupa
sed -i 's/="cnn_turk">/="CNN.tr">/g' zattoo_fullepg.xml						# CNN TÜRK
# sed -i 's/="halk_tv">/&/g' zattoo_fullepg.xml							### Halk TV
sed -i 's/="tr_show_turk">/="15.Show TV.digiturk.com.tr">/g' zattoo_fullepg.xml			# Show Turk
sed -i 's/="haber_turk">/="31.HaberTURK.digiturk.com.tr">/g' zattoo_fullepg.xml			# Haber Türk TV
# sed -i 's/="tv8">/&/g' zattoo_fullepg.xml							### TV8
sed -i 's/="power_turk">/="PowerTurk.tr">/g' zattoo_fullepg.xml					# Power Turk TV
# sed -i 's/="dream_turk">/&/g' zattoo_fullepg.xml						### dream TÜRK


# ##############################
# BOSNISCH                     #
# ##############################

# sed -i 's/="bntv">/&/g' zattoo_fullepg.xml							### BN-TV
# sed -i 's/="cmc">/&/g' zattoo_fullepg.xml							### CMC - Croatian Music Channel


# ##############################
# KROATISCH                    #
# ##############################

# sed -i 's/="dmsat">/&/g' zattoo_fullepg.xml							### DM Sat
sed -i 's/="hrt1">/="HRTTV1.hr">/g' zattoo_fullepg.xml						# HRT 1
sed -i 's/="hrt4">/="HRT4.hr">/g' zattoo_fullepg.xml						# HRT 4
# sed -i 's/="cmc">/&/g' zattoo_fullepg.xml							### CMC - Croatian Music Channel


# ##############################
# PINK                         #
# ##############################

sed -i 's/="pinkplus">/="PINKPlus.hr">/g' zattoo_fullepg.xml					# Pink Plus
sed -i 's/="pinkextra">/="PinkExtra.si">/g' zattoo_fullepg.xml					# Pink Extra
sed -i 's/="pinkreality">/="PinkReality.rs">/g' zattoo_fullepg.xml				# Pink Reality
sed -i 's/="pinkfilm">/="PinkFilm.rs">/g' zattoo_fullepg.xml					# Pink Film
sed -i 's/="pinkfolk">/="PinkFolk1.rs">/g' zattoo_fullepg.xml					# Pink Folk
sed -i 's/="pinkmusic">/="PinkMusic.si">/g' zattoo_fullepg.xml					# Pink Music


# ##############################
# GLOBO                        #
# ##############################

sed -i 's/="tvglobo">/="TVGlobo.pt">/g' zattoo_fullepg.xml					# Globo


# ##############################

echo "--- DONE ---"
