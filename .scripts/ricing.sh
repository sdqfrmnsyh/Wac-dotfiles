#!/bin/bash
MODE="$1"
DUNST="$HOME/.config/dunst/dunstrc"
ID=9993
if [ "$MODE" = "rice" ]; then

    killall /home/modz/.scripts/colorscheme.sh
    killall colorscheme.sh
    killall /home/modz/.scripts/autocolorscheme.sh
    killall autocolorscheme.sh
    killall sleep
    killall tint2
    killall dunst
    killall polybar
    killall plank
    killall picom
    swr /home/modz/.config/rofi/themes/nord.rasi
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 polybar -r &
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 plank &
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 picom &
    awk -v color="#000000" '
/background =/ {
    sub(/".*"/, "\""color"\"")
}
{print}
' "$DUNST" > "$DUNST.tmp" && mv "$DUNST.tmp" "$DUNST"
    sleep 1
    dunstify -r $ID -u normal "✨ Ricing Mode" "Beauty mode activated." -t 2000

elif [ "$MODE" = "normal" ]; then

    killall /home/modz/.scripts/colorscheme.sh
    killall colorscheme.sh
    killall /home/modz/.scripts/autocolorscheme.sh
    killall autocolorscheme.sh
    killall sleep
    killall polybar
    killall plank
    killall picom
    killall tint2
    killall dunst
    swr /home/modz/.config/rofi/themes/windows11-list-dark.rasi
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 /home/modz/.scripts/autocolorscheme.sh &
    sleep 2
    dunstify -r $ID "🖥️ Normal Mode" "Performance comes first." -t 2000

else
    if pgrep -x polybar >/dev/null; then
    killall polybar
    killall plank
    killall picom
    killall tint2
    killall dunst
    killall /home/modz/.scripts/colorscheme.sh
    killall colorscheme.sh
    killall /home/modz/.scripts/autocolorscheme.sh
    killall autocolorscheme.sh
    swr /home/modz/.config/rofi/themes/windows11-list-dark.rasi
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 /home/modz/.scripts/autocolorscheme.sh &
    sleep 2
    dunstify -r $ID "🖥️ Normal Mode" "Performance comes first." -t 2000
   else
    killall /home/modz/.scripts/colorscheme.sh
    killall colorscheme.sh
    killall /home/modz/.scripts/autocolorscheme.sh
    killall autocolorscheme.sh
    killall sleep
    killall tint2
    killall dunst
    killall polybar
    killall plank
    killall picom
    swr /home/modz/.config/rofi/themes/nord.rasi
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 polybar -r &
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 plank &
    taskset -c 0 nice -n 19 ionice -c3 stdbuf -oL -eL chrt --idle 0 picom &
    awk -v color="#000000" '
/background =/ {
    sub(/".*"/, "\""color"\"")
}
{print}
' "$DUNST" > "$DUNST.tmp" && mv "$DUNST.tmp" "$DUNST"
    sleep 1
    dunstify -r $ID -u normal "✨ Ricing Mode" "Beauty mode activated." -t 2000
   fi
fi


