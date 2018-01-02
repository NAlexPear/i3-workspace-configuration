#!/bin/bash

title=`exec playerctl metadata xesam:title`
artist=`exec playerctl metadata xesam:artist`
info="$title by $artist"

if [ "$(playerctl status)" = "Playing" ]; then
  echo " $info"
else
  echo " $info"
fi
