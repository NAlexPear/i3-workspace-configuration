#! /bin/bash

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
  MONITOR=$m polybar --config=$HOME/.config/i3/polybar/config --reload main &
done
