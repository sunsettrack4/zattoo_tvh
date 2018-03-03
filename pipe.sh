session=$(<work/session)
curl -i -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" --data "stream_type=hls&https_watch_urls=True&timeshift=10800" https://zattoo.com/zapi/watch/live/CID_CHANNEL | sed '/"url":/!d;s/.*"stream": {"url": "//g;s/", .*//g;' > work/chlink && PIPE=$(sed '/zahs/{s/zahs.tv.*/zahs.tv/g;s/\//\\\//g;}' work/chlink) && curl $(<work/chlink) | \
# sed "3!d;s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i $PIPE\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;" > chpipe.sh
# sed "/live-1500/!d;s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i $PIPE\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;" > chpipe.sh
# sed "/live-600/!d;s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i $PIPE\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;" > chpipe.sh
bash chpipe.sh
