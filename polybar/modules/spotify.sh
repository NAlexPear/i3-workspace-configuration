#!/bin/bash

config="polybar --config=$HOME/.config/i3/polybar/config"

primary=$($config --dump=primary left)
secondary=$($config --dump=secondary left)
alt=$($config --dump=foreground-alt left)

title=`exec playerctl metadata xesam:title`
artist=`exec playerctl metadata xesam:artist`
album=`exec playerctl metadata xesam:album`
length=`exec playerctl metadata mpris:length`

secs=$(($length/1000000))
timestamp=`printf ""%d:%02d"" $(($secs%3600/60)) $(($secs%60))`

cache="$artist $title $album $length"

function update_cache {
  if [ ! -f ~/.cache/spotify-nowplaying ]; then
    echo $cache > ~/.cache/spotify-nowplaying
  fi

  if [ "$cache" != "$(cat ~/.cache/spotify-nowplaying)" ]; then
    echo $cache > ~/.cache/spotify-nowplaying
    echo $length > ~/.cache/spotify-nowplaying-length
    date +%s > ~/.cache/spotify-nowplaying-start
  fi
}

function get_info {
  timethen=$(cat ~/.cache/spotify-nowplaying-start)
  timenow=$(date +%s)
  elapsed=$(($timenow-$timethen))
  position=`printf ""%d:%02d"" $(($elapsed%3600/60)) $(($elapsed%60))`

  echo "$title %{F$alt}by%{F-} $artist %{F$alt}%{F-} $album  %{F$alt}|%{F-}  $position %{F$alt}%{F-} $timestamp"
}

if [ "$(playerctl status)" = "Playing" ]; then
  update_cache

  echo "%{F$secondary}%{F-} $(get_info)"
else
  echo "%{F$primary}%{F-} $(get_info)"
fi
