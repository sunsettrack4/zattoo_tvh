session=$(<work/session)
curl -i -s -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" --cookie "$session" --data "stream_type=hls&https_watch_urls=True&timeshift=10800" https://zattoo.com/zapi/watch/live/CID_CHANNEL | grep "{" | sed 's/.*"stream": {"url": "//g;s/", .*//g;' > work/chlink && PIPE=$(sed '/zahs/{s/https:/http:/g;s/zahs.tv.*/zahs.tv/g;s/\//\\\//g;}' work/chlink) && curl -s $(<work/chlink) | \
# grep -E "live-5000|live-3000|live-2999|live-1500" | sed "2,4d;s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i $PIPE\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;" > chpipe.sh
# grep "live-1500" | sed "s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i $PIPE\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;" > chpipe.sh
# grep "live-600" | sed "s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i $PIPE\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;" > chpipe.sh
bash chpipe.sh
