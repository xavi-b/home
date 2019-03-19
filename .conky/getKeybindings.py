#!/usr/bin/python

import xml.etree.ElementTree as etree;

keybindings = [];
ns = {"openbox_config": "http://openbox.org/3.4/rc"};
root = etree.parse("/home/xavier/.config/openbox/rc.xml").getroot();
keyboard = root.find("openbox_config:keyboard", ns);
for keybind in keyboard.findall("openbox_config:keybind", ns):
    if keybind.get("export") == "true":
        kbdg = [];
        kbdg.append(keybind.get("key"));
        action = keybind[0];
        if action is not None:
            startup = action[0];
            if startup is not None and len(startup) > 0:
                name = startup[1];
                if name is not None and name.text is not None:
                    kbdg.append(name.text);

        if len(kbdg) < 2:
            kbdg.append(keybind.find("openbox_config:action", ns).get("name"));
        keybindings.append(kbdg);
        print("${color grey}"+kbdg[0]+"${tab 20}$color "+kbdg[1]);
#print(keybindings)
