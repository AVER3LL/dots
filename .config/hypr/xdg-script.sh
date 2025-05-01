#!/usr/bin/env bash
sleep 1
# Kill all running xdg-desktop-portal variants
killall xdg-desktop-portal-hyprland xdg-desktop-portal-gnome \
        xdg-desktop-portal-kde xdg-desktop-portal-lxqt \
        xdg-desktop-portal-wlr xdg-desktop-portal 2>/dev/null
sleep 1
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &
