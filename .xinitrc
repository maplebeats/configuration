#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

eval `dbus-launch --sh-syntax --exit-with-session`

xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 &
xfce4-power-manager &
fcitx &
dropboxd &
syndaemon -i 2 -d

exec ck-launch-session awesome
