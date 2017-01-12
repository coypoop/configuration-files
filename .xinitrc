#!/bin/sh
dwm-status &
xrdb -merge ~/.Xresources &
setxkbmap -option grp:alt_shift_toggle us,il &
while true; do feh --randomize --bg-fill ~/.wallpaper/* && sleep 3600; done &
xset -b &
urxvt &
firefox &
dwm
