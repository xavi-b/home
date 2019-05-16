#!/bin/bash

export DISPLAY=:0.0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

if [ $battery_level -le 30 ]; then
    /usr/bin/notify-send -a "Battery notify" "Battery low" "${battery_level}%"
elif [ $battery_level -le 10 ]; then
    /usr/bin/notify-send -a "Battery notify" "Battery low" "${battery_level}%" -u critical
fi
