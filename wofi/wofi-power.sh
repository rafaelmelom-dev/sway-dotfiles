#!/usr/bin/env bash

## Author: Your Name
## Description: Wofi-based power menu script

# Commands
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
shutdown=' shutdown'
reboot=' reboot'
lock=' lock screen'
suspend=' suspend'
logout=' logout'
hibernate=' hibernate'

# Wofi CMD
wofi_cmd() {
    wofi --dmenu --prompt="Power menu" --style="$HOME/.config/wofi/style.css" --width=300 --lines=7 --mesg="Uptime: $uptime"
}

# Pass variables to wofi dmenu
run_wofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | wofi_cmd
}

# Execute Command
run_cmd() {
    case $1 in
        --shutdown)
            systemctl poweroff
            ;;
        --reboot)
            systemctl reboot
            ;;
        --suspend)
            mpc -q pause
            amixer set Master mute
            systemctl suspend
            ;;
        --logout)
            loginctl terminate-user $USER
            ;;
    esac
}

# Actions
chosen="$(run_wofi)"
case "${chosen}" in
    "${shutdown}")
        run_cmd --shutdown
        ;;
    "${reboot}")
        run_cmd --reboot
        ;;
    "${lock}")
        swaylock 
        ;;
    "${suspend}")
        run_cmd --suspend
        ;;
    "${logout}")
        run_cmd --logout
        ;;
esac

