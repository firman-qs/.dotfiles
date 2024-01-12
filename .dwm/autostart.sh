xrdb -merge ~/.Xresources &&
xdotool key Super+Shift+F5 &
dwmblocks &
/usr/bin/emacs --daemon &
lxsession &
sleep 5 && xmodmap -e "pointer = 1 2 3 4 5 6 7 8 9 10" &
