#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

#eval `dbus-launch --sh-syntax --exit-with-session`

xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 &
#syndaemon -i 2 -d

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

#exec ck-launch-session awesome
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session awesome >> ~/.awesome_stdout 2>> ~/.awesome_stderr
