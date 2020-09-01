#!/bin/python

import subprocess;
import os;
import shutil;

with open(".gitignore","r") as file:
    for line in file:
        line = line.strip();
        if line.startswith("!") and not line.endswith("*") and not ".gitignore" in line and not os.path.basename(__file__) in line:
            line = line.strip("/");
            print("Copying " + line[1:] + " : " + str(subprocess.call("cp -rT " + line[1:] + " ~/" + line[1:], shell=True)));
if not os.path.exists(os.path.expanduser("~/.bash/hostcolor.sh")):
    shutil.copy("hostcolor.sh", os.path.expanduser("~/.bash"));
print("Done");
