#!/bin/sh
#  _   ___     __
# | \ | \ \   / /  Noctivox
# |  \| |\ \ / /   https://www.github.com/VoxT1
# | |\  | \ V /    https://www.twitter.com/VoxNoctivox
# |_| \_|  \_/     nv#9827
#
# My .xinitrc configuration

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -n "`/etc/X11/chooser.sh`" ]; then
 command="`/etc/X11/chooser.sh`"
else
 failsafe="yes"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?* ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

## MOUSE SIZE/THEME ##
xrdb ~/.Xresources &
xset m 3/4 

## DWM ##
#if [[ $(xrandr -q | grep 'DP-2 connected') ]]; then
#	xrandr --output DP-2 --mode 2560x1440 --rate 165 --pos 440x0 --output DP-0 --mode 3440x1440 --rate 144 --pos 0x1440 &
#else
#	xrandr --output DP-0 --mode 3440x1440 --rate 144 &
#fi
#picom --experimental-backend &
#nitrogen --restore &
#clipmenud &
#exec dbus-launch --sh-syntax --exit-with-session dwm

## HERBSTLUFTWM ##
#picom --experimental-backend &
#nitrogen --restore & 
#exec herbstluftwm --locked

## BSPWM ##
#exec dbus-launch --sh-syntax --exit-with-session bspwm

## XMONAD ##
/usr/libexec/polkit-gnome-authentication-agent-1 &
exec dbus-launch --sh-syntax --exit-with-session xmonad

## GNOME ##
# Fix Missing Applications in GNOME #
#export XDG_MENU_PREFIX=gnome-
# Pipewire #
#/usr/bin/gentoo-pipewire-launcher &
#exec gnome-shell

## XFCE ##
#picom --experimental-backend &
#exec dbus-launch --sh-syntax --exit-with-session startxfce4
