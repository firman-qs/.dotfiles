#!/bin/bash

# nitrogen --set-zoom-fill $1 &&
wal -i $1 &&
xrdb -merge ~/.Xresources &&
xdotool key Super+Shift+F5 &
# convert $1 -crop 700x700+10+5 -gravity Center /home/fqs/Pictures/notification/notifimg.jpg &
