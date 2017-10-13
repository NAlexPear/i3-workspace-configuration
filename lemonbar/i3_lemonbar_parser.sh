#!/bin/bash
#
# Input parser for i3 bar
# 14 ago 2015 - Electro7

# config
. $(dirname $0)/i3_lemonbar_config

# min init
irc_n_high=0

# parser
while read -r line ; do
  case $line in
    SYS*)
      # conky=, 0 = wday, 1 = mday, 2 = month, 3 = time, 4 = cpu, 5 = mem, 6 = disk /, 7 = disk /home, 8-9 = up/down wlan, 10-11 = up/down eth, 12-13=speed
      sys_arr=(${line#???})

      # date
      date="${sys_arr[0]} ${sys_arr[1]} ${sys_arr[2]}"
      date="%{B${color_bgdarkhl} T2}   ${icon_calendar} %{T1} ${date}"

      # time
      time="%{T2}${icon_clock}  %{T1}${sys_arr[3]}   %{F- B-}"

      # cpu
      cpu="%{T2}  ${icon_cpu}  %{T1}${sys_arr[4]}% %{F- B-}"

      # wlan
      if [ "${sys_arr[8]}" == "down" ]; then
        wland_v="×"; wlanu_v="×";
        wlan_cback=${color_sec_b2}; wlan_cicon=${color_sec_b3}; wlan_cfore=${color_sec_b3};
      else
        wland_v=${sys_arr[8]}K; wlanu_v=${sys_arr[9]}K;
        if [ ${wland_v:0:-3} -gt ${net_alert} ] || [ ${wlanu_v:0:-3} -gt ${net_alert} ]; then
          wlan_cback=${color_net}; wlan_cicon=${color_back}; wlan_cfore=${color_back};
        else
          wlan_cback=${color_sec_b2}; wlan_cicon=${color_icon}; wlan_cfore=${color_fore};
        fi
      fi
      wland="%{F${color_fgdark} T2}  ${icon_dl} %{T1} ${wland_v}  "
      wlanu="%{T2}  ${icon_ul} %{T1} ${wlanu_v}  "
      ;;

    VOL*)
      # Volume:
      #   [0] Muted indicator: (M=Muted / (anything else)=Unmuted)
      #   [1] On/off (muted) status (1=Unmuted / 0=Muted)
      vol_arr=(${line#???})
      vol_frg=-
      vol_oln=-
      vol_ico=$icon_vol
      vol_txt=${vol_arr[1]}

      if [[ ${vol_arr[0]} == "M" ]]; then
        vol_frg=${color_fgdark}
        vol_ico="${icon_mute}  "
      fi
      vol="%{B- F${vol_frg} T2}  ${vol_ico} %{T1} ${vol_txt}%{F- B-}"
      ;;


    WSP*)
      # I3 Workspaces
      wsp="%{F${color_fglight} B${color_bgdark} T1}"
      set -- ${line#???}
      while [ $# -gt 0 ] ; do
        case $1 in
         FOC*)
           wsp="${wsp}%{+u B${color_bgdarkhl} U${color_accent1} T1}   ${1##????}   %{-u B${color_bgdark} F${color_fglight}}"
           ;;
         INA*|URG*|ACT*)
           wsp="${wsp}%{F${color_fglight} T1}   ${1##????}   "
           ;;
        esac
        shift
      done
      ;;

    SID*)
      ssid="%{F${color_fgdark} T2}  ${icon_ssid}  %{T1}${line#???}"
      ;;

  esac

  # And finally, output
  printf "%s\n" "%{U${color_accent1} l}${wsp} %{r}${ssid}${stab}${cpu}${stab}${vol}${stab}${batamt}${date}${stab}${time}"
done
