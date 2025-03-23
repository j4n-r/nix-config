#!/bin/sh

choice=$(printf "  Shutdown\n Reboot\n Sleep\n  Lock\n  Logout" | rofi -dmenu -p "Power")

case "$choice" in
  *Shutdown*) systemctl poweroff ;;
  *Reboot*) systemctl reboot ;;
  *Sleep*) systemctl suspend ;;
  *Lock*) hyprlock ;;
  *Logout*) hyprctl dispatch exit ;;
esac
