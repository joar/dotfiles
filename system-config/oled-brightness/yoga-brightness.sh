#!/bin/sh
# Based on http://askubuntu.com/a/862575/22255

# Where the backlight brightness is stored

BR_DIR='/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight'
XRANDR_OUTPUT='eDP-1'

# Workarounds that allow xrandr, run as root, to modify the user's X11 session
XAUTHORITY='/run/user/1000/gdm/Xauthority'
DISPLAY=:0

export XAUTHORITY DISPLAY

test -d "$BR_DIR" || exit 0

MIN=0
MAX=$(cat "$BR_DIR/max_brightness")
VAL=$(cat "$BR_DIR/brightness")

if [ "$1" = down ]; then
    VAL=$((VAL-71))
else
    VAL=$((VAL+71))
fi

if [ "$VAL" -lt $MIN ]; then
    VAL=$MIN
elif [ "$VAL" -gt $MAX ]; then
    VAL=$MAX
fi

PERCENT=`echo "$VAL / $MAX" | bc -l`

BRIGHTNESS_COMMAND=xrandr\ --output\ $XRANDR_OUTPUT\ --brightness\ $PERCENT

echo $BRIGHTNESS_COMMAND > /tmp/yoga-brightness.log
command $BRIGHTNESS_COMMAND

echo $VAL > "$BR_DIR/brightness"
