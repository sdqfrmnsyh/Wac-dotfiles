#!/bin/bash

case "$1" in
    ena)
        mv ~/.scripts/tuturu1.ogg ~/.scripts/tuturu.ogg
        dunstify "Notification sound" "Enabled"
        ;;
    dis)
        mv ~/.scripts/tuturu.ogg ~/.scripts/tuturu1.ogg
        dunstify "Notification sound" "Disabled"
        ;;
    stat)
        if ls ~/.scripts/tuturu.ogg > /dev/null 2>&1; then
        dunstify "Notification sound" "Enabled"
        else
        dunstify "Notification sound" "Disabled"
        fi
        ;;
    *)
        echo "Usage: $0 {ena|dis|stat}"
        exit 1
        ;;
esac
