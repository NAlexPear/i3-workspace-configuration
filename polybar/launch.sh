#! /bin/bash
MONITORS=($(xrandr --query | grep " connected " | cut -d" " -f1))
BARS=("left" "right")

for i in "${!MONITORS[@]}"; do
  MONITOR="${MONITORS[$i]}" polybar --config=$HOME/.config/i3/polybar/config --reload "${BARS[$i]}" &
done
