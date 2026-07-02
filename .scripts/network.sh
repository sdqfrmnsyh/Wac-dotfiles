#!/usr/bin/env sh
IFACE_WL="wlan0"

NET_ICON='󰖩'
NET_STAT="Disconnected"

WL_IP=$(ip addr show "$IFACE_WL" 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
if [ -n "$WL_IP" ]; then
    ESSID=$(iw dev "$IFACE_WL" link | grep SSID | awk '{print $2}')
    NET_ICON='󰖩'
    NET_STAT="${ESSID}@${IFACE_WL}"
else
	NET_ICON='󰖪'
	NET_STAT="$(echo $NET_STAT)"
fi

case "$1" in
    icon) echo "$NET_ICON" ;;
    status) echo "$NET_STAT" ;;
esac
