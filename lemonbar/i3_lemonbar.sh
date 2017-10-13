#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar

. $(dirname $0)/i3_lemonbar_config

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    printf "%s\n" "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"


### EVENTS METERS

# i3 Workspaces, "WSP"
# @TODO: fix this for workspaces (currently showing as red bar)
# $(dirname $0)/i3_workspaces.py > ${panel_fifo} &

# Conky, "SYS"
conky -c $(dirname $0)/i3_lemonbar_conky > "${panel_fifo}" &

### UPDATE INTERVAL METERS
cnt_vol=${upd_vol}
cnt_ssid=${upd_ssid}

while :; do

  # Volume, "VOL"
  if [ $((cnt_vol++)) -ge ${upd_vol} ]; then
    echo "VOL$(pactl list sinks | grep -m 1 "Base Volume" | awk '{print $5}')" > "${panel_fifo}" &
    cnt_vol=0
  fi

  # SSID, "SID"
  if [ $((cnt_ssid++)) -ge ${upd_ssid} ]; then
    echo "SID$(iwgetid -r)" > "${panel_fifo}" &
    cnt_ssid=0
  fi

  # Finally, wait 1 second
  sleep 1s;

done &

#### LOOP FIFO
cat "${panel_fifo}" | $(dirname $0)/i3_lemonbar_parser.sh \
  | lemonbar -p -f "${font}" -f "${iconfont}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" -u 3 &

wait
