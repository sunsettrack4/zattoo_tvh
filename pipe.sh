#!/bin/bash
cd ~/ztvh
session=$(<work/session)
curl -i -X POST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/x-www-form-urlencoded" -v --cookie "$session" --data "stream_type=hls&https_watch_urls=True&timeshift=10800" https://zattoo.com/zapi/watch/live/CID_CHANNEL | curl $(sed '/"url":/!d;s/.*"stream": {"url": "//g;s/", .*//g;') | \
# sed '3!d;s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i https:\/\/zba1-0-hls-live.zahs.tv\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;' > chpipe.sh
# sed '/live-1500/!d;s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i https:\/\/zba1-0-hls-live.zahs.tv\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;' > chpipe.sh
# sed '/live-600/!d;s/.*/#\!\/bin\/bash\n\/usr\/bin\/ffmpeg -loglevel fatal -i https:\/\/zba1-0-hls-live.zahs.tv\/& -vcodec copy -acodec copy -f mpegts -tune zerolatency -preset normal pipe:1/g;' > chpipe.sh
bash chpipe.sh
