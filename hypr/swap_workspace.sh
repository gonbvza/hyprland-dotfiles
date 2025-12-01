#!/usr/bin/env bash

# Usage: ./swap_workspace.sh <ws1> <ws2>
WS1="$1"
WS2="$2"

if [ -z "$WS1" ] || [ -z "$WS2" ]; then
    echo "Usage: $0 <workspace1> <workspace2>"
    exit 1
fi

# Make sure jq and hyprctl exist
for cmd in hyprctl jq; do
    command -v $cmd >/dev/null 2>&1 || { echo "$cmd not found"; exit 1; }
done

# Get all window IDs in each workspace
WS1_WINDOWS=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id==$WS1) | .id")
WS2_WINDOWS=$(hyprctl clients -j | jq -r ".[] | select(.workspace.id==$WS2) | .id")

# Move windows from WS1 to WS2
for win in $WS1_WINDOWS; do
    hyprctl dispatch movetoworkspace $WS2 $win
done

# Move windows from WS2 to WS1
for win in $WS2_WINDOWS; do
    hyprctl dispatch movetoworkspace $WS1 $win
done

# Focus on WS1 (optional)
hyprctl dispatch workspace $WS1

