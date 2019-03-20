#!/bin/python

import subprocess;
import os;

with open(".gitignore","r") as file:
    for line in file:
        if line.startswith("!") and not os.path.basename(__file__) in line:
            print("Copying " + line[1:-1]);
            subprocess.call("cp -r " + line[1:-1] + " ~/", shell=True);
print("Done");
