#!/usr/bin/python

import subprocess;

mute = "off" in str(subprocess.check_output("amixer get Master | grep 'Right:'", shell=True)).strip();
volume = subprocess.check_output("amixer get Master | grep 'Right:' | awk -F'[][]' '{ print $2 }' | cut -d'%' -f1", shell=True).decode("ascii").strip();

if not mute:
    print("$color ON  ${execbar echo '" + volume + "'}");
else:
    print("${color grey} OFF ${execbar echo '0'}");