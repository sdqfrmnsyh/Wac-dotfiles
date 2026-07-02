#!/bin/bash

set -e

# =====================================================
# DETECT WINDOWS
# =====================================================

# GUI monitor
GUI_MONITOR=$(wmctrl -l | grep -Ei \
"Mission Center" | awk '{print $1}' | head -n1)

# TUI monitor
TUI_MONITOR=$(wmctrl -l | grep -Ei \
"htop|btop|top" | awk '{print $1}' | head -n1)

# GUI music
GUI_MUSIC=$(wmctrl -l | grep -Ei \
"Resonance|DeaDBeeF|Rhythmbox|Strawberry|Audacious|YTMDesktop" \
| awk '{print $1}' | head -n1)

# TUI music
TUI_MUSIC=$(wmctrl -l | grep -Ei \
"cmus|ncmpcpp|moc" \
| awk '{print $1}' | head -n1)

# cava wajib ada
CAVA=$(wmctrl -l | grep -i "cava" | awk '{print $1}' | head -n1)

# =====================================================
# BORDER FIX
# =====================================================

GUI_BORDER=50
CAVA_BORDER=25

TUI_BORDER=26

# =====================================================
# MOVE FUNCTION
# =====================================================

move() {
    local w=$1
    local x=$2
    local y=$3
    local ww=$4
    local hh=$5

    [ -z "$w" ] && return

    wmctrl -ir "$w" -e "0,$x,$y,$ww,$hh"
}

# =====================================================
# NO CAVA = NO RICE
# =====================================================

if [ -z "$CAVA" ]; then
    echo "No cava detected."
    exit
fi

# =====================================================
# MODE 1
# GUI NORMAL
# =====================================================

if [ -n "$GUI_MONITOR" ] && [ -n "$GUI_MUSIC" ]; then

    echo "MODE 1: GUI NORMAL"
    
    C1_BORDER=25
    
    M1_BORDER=50

    move "$GUI_MONITOR" 10 10 630 670

    move "$GUI_MUSIC" \
        647 \
        $((60 - M1_BORDER)) \
        623 \
        304

    move "$CAVA" \
        647 \
        $((401 - C1_BORDER)) \
        623 \
        304

    exit
fi

# =====================================================
# MODE 2
# TUI NORMAL
# =====================================================

if [ -n "$TUI_MONITOR" ] && [ -n "$TUI_MUSIC" ]; then

    echo "MODE 2: TUI NORMAL"

    move "$TUI_MONITOR" \
        12 \
        $((62 - TUI_BORDER)) \
        618 \
        644

    move "$TUI_MUSIC" \
        640 \
        $((62 - TUI_BORDER)) \
        630 \
        309

    move "$CAVA" \
        640 \
        $((408 - TUI_BORDER)) \
        630 \
        298

    exit
fi

# =====================================================
# MODE 3
# GUI + TUI MUSIC
# =====================================================

if [ -n "$GUI_MONITOR" ] && [ -n "$TUI_MUSIC" ]; then

    echo "MODE 3: GUI + TUI MUSIC"
    
    C3_BORDER=25
    M3_BORDER=26

    move "$GUI_MONITOR" 10 10 630 670

    move "$TUI_MUSIC" \
        647 \
        $((62 - M3_BORDER)) \
        623 \
        304

    move "$CAVA" \
        647 \
        $((401 - C3_BORDER)) \
        623 \
        304

    exit
fi

# =====================================================
# MODE 4
# TUI + GUI MUSIC
# =====================================================

if [ -n "$TUI_MONITOR" ] && [ -n "$GUI_MUSIC" ]; then

    echo "MODE 4: TUI + GUI MUSIC"
    
    M4_BORDER=26
    C4_BORDER=26

    move "$TUI_MONITOR" \
        12 \
        $((62 - TUI_BORDER)) \
        618 \
        644

    move "$GUI_MUSIC" \
        640 \
        $((36 - M4_BORDER)) \
        630 \
        309

    move "$CAVA" \
        640 \
        $((408 - C4_BORDER)) \
        630 \
        298

    exit
fi

echo "No matching rice mode."
