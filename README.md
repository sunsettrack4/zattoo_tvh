# Zattoo Unlimited

## About this project
Use these scripts to retrieve ZATTOO Live TV channels, channel logo images and EPG files.
The created files can be processed by tvHeadend; the channels will be played back via Kodi etc.
Additionally, you can watch Live TV and PVR recordings via VLC on Linux desktop PCs.

#### Advantages
* Ad free channel switch also in Zattoo Free
* tvHeadend: Set PVR timers, unrestricted timeshift mode
* Download Zattoo recordings to local/external storage (watch recordings offline on all devices)

#### Supported platforms
* any Linux-based OS, e.g. Ubuntu, Debian

## Support my work
If you like my script, please [![Paypal Donation Page](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://paypal.me/sunsettrack4) - thank you! :-)

# Installation

## tvHeadend
[Please visit the tvHeadend project page to get more information.](https://tvheadend.org/projects/tvheadend/wiki/AptRepositories)

## ztvh script
Please run the commands below to setup the script. "Sudo" is not required on user "root".

```bash
# Install all recommended applications to setup the ztvh environment completely:
sudo apt-get install phantomjs uni2ascii libxml2-utils ffmpeg vlc socat iputils-ping crontab curl wget unzip dialog

# Create a directory called "ztvh" in your home folder:
mkdir ~/ztvh

# Download the .zip file and extract the files into the "ztvh" folder:
wget https://github.com/sunsettrack4/zattoo_tvh/archive/v0.5.2.zip

# Unzip the file:
unzip v0.5.2.zip

# Move all script files to the created ztvh folder
mv ~/zattoo_tvh-0.5.2/* ~/ztvh/

# Set system-wide permissions to the folder and its related files
sudo chmod 0777 ~/ztvh
sudo chmod 0777 ~/ztvh/*

# Run the main script to enter the setup screen in terminal
bash ~/ztvh/ztvh.sh
```

## Setup screens on first run

### PROVIDERS
#### 1) Zattoo Germany / Switzerland, to be used for the Zattoo main service (zattoo.com)
* If you choose option 1, please enter the email address and the password.
#### 2) Resellers, to be used for other websites using Zattoo's B2B  platform (e.g. 1und1.tv)
* If you choose option 2, please enter the website of your provider first, then enter the username and the password.

### FIRST SETUP (similar to SETTINGS option in main menu)
Please hit the CANCEL button to save the current settings.
#### 1) CHANNEL LOGOS (related files saved in "~/ztvh/logos")
* enable the option to grab channel logo images
#### 2) EPG GRABBER (final XMLTV file saved in "~/ztvh/zattoo_fullepg.xml")
* enable the option to grab EPG data and choose the related time period (1-14 days)
* use the simple mode to receive EPG faster (title, subtitle, image, genre)
* use the extended mode to also download broadcast decriptions
#### 3) EPG DOWNLOADER (final XMLTV file saved in "~/ztvh/zattoo_ext_fullepg.xml")
* enable the option to download XMLTV files with complete broadcast information (only available for Zattoo users)
#### 4) STREAMING QUALITY (set the bitrate to be used by tvHeadend or VLC)
* MINIMUM (600 kBit/s)
* LOW (900 kBit/s)
* MEDIUM (1,5 MBit/s)
* HIGH (3 MBit/s)
* MAXIMUM (5-8 MBit/s)

### MAIN MENU
Please hit the CANCEL button to exit the dialog menu of the script.
#### 1) LIVE TV (only available on desktop PCs with GUI)
* watch the channels via VLC media player
#### 2) PVR CLOUD
* retrieve the full list of available PVR recordings
* watch the broadcast of your choice via VLC media player (only available on desktop PCs with GUI)
* download the broadcast of your choice to local storage
* pro tip: change the download directory in file ~/ztvh/user/options (line: recfolder)
#### 4) SETTINGS (see FIRST SETUP sections above)
#### 5) CONTINUE IN GRABBER MODE (continue to grab EPG files and channel logo images)
#### 9) LOGOUT AND DELETE DATA 

## How to use the files for tvHeadend
1) Open the tvHeadend webpage - go to menu option "Configuration" > "DVB inputs" > "Networks"
2) Click on "Add" button to add a new IPTV source
3) Choose "IPTV Automatic Network" and enter a network name
4) Fill in the fields as follows:
```bash
"Maximum # input streams" = 1      # for Zattoo FREE
                          = 2      # for Zattoo PREMIUM
                          = 4      # for Zattoo ULTIMATE
```
```bash
"URL" = file:///home/<user>/ztvh/channels.m3u
# enter your PC username instead of "<user>"
```
```bash
"Icon base URL" = file:///home/<user>/ztvh
# enter your PC username instead of "<user>"
```
* Accept your settings by clicking on "Save" button. tvHeadend will do a channel scan automatically.
5) Go to menu option "Configuration" > "Channel/EPG" > "EPG Grabber Modules" and enable "External: XMLTV"
6) Go to menu option "Configuration" > "Channel/EPG" > "Channel" > "Map services" > "Map all services" and map the services
7) Run the following command:
```bash
cat /home/<user>/ztvh/<file> | socat - UNIX-CONNECT:/home/<user>/.hts/tvheadend/epggrab/xmltv.sock
# enter your PC name instead of "<user>"
# enter the file name "zattoo_fullepg.xml" or "zattoo_ext_fullepg.xml" instead of "<file>"
```
* tvHeadend will process the EPG XMLTV file automatically.

## Complete the setup
* Please use crontab to update the session ID cookie on your device
```bash
# Enter this command to enter the settings of crontab
crontab -e
```
```bash
# Setup to run the script daily at 3 AM
0 3 * * * ~/ztvh/ztvh.sh
```
* Please use sudo crontab to update the EPG data in tvHeadend automatically
```bash
# Enter this command to enter the admin settings of crontab ("sudo" not required for user "root")
sudo crontab -e
```
```bash
# Setup to update the EPG twice (recommended to update the EPG schedule times correcty)
0 6 * * * cat /home/<user>/ztvh/<file> | socat - UNIX-CONNECT:/home/hts/.hts/tvheadend/epggrab/xmltv.sock
5 6 * * * cat /home/<user>/ztvh/<file> | socat - UNIX-CONNECT:/home/hts/.hts/tvheadend/epggrab/xmltv.sock
# enter your PC name instead of "<user>"
# enter the file name "zattoo_fullepg.xml" or "zattoo_ext_fullepg.xml" instead of "<file>"
```

## Further support
Contact me for support via email: sunsettrack4@gmail.com

FAQ section to follow :-)
