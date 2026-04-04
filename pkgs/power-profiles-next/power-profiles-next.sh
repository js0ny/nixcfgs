#!/usr/bin/env bash

CURRENT_PROFILE=$(powerprofilesctl get)

case $CURRENT_PROFILE in
    "power-saver")
        NEXT_PROFILE="balanced"
        ICON="power-profile-balanced-symbolic"
        ;;
    "balanced")
        NEXT_PROFILE="performance"
        ICON="power-profile-performance-symbolic"
        ;;
    "performance" | *)
        NEXT_PROFILE="power-saver"
        ICON="power-profile-power-saver-symbolic"
        ;;
esac

powerprofilesctl set $NEXT_PROFILE

echo "Power profile set to: $NEXT_PROFILE"

notify-send -a "powerprofilesctl" "Power Profile" "$NEXT_PROFILE" -i $ICON -u low -t 2000

