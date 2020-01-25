* install `youtube-dl`
* clone this into `/usr/local/scripts/youtube`
* setup cronjob. for example: `*/15 * * * *     flock --no-fork --exclusive --nonblock /var/lock/plex-youtube.lock -c '/usr/local/scripts/youtube/download.sh > /var/log/plex-youtube.log'`
* setup subscriptions webinterface:
  * `cp subscriptions-web.service /etc/systemd/system/`
  * `systemctl daemon-reload`
  * `systemctl enable --now subscriptions-web`

this script downloads to `/storage/plex/media/youtube/` and deletes old files after 14 days. this can be configured in `download.sh` and `youtube-dl.sh`

you may need to change the path to `youtube-dl` in `youtube-dl.sh`

Subscription URLs can be Youtube Channel URLs or any other URL that is supported by `youtube-dl`

Subscription Web Interface is listening on Port 8080 by default. Can be changed in `subscription-web.service`
