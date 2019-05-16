#!/bin/bash

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

if [ $battery_level -le 30 ]; then
    notify-send -a "Battery notify" "Battery low" "${battery_level}%"
elif [ $battery_level -le 10 ]; then
    notify-send -a "Battery notify" "Battery low" "${battery_level}%" -u critical
fi
