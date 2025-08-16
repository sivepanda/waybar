#!/bin/bash

# Get player status
status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    arturl=$(playerctl metadata mpris:artUrl 2>/dev/null)
    player=$(playerctl -l 2>/dev/null | head -n 1)

    # Fallbacks
    artist=${artist:-"Unknown Artist"}
    title=${title:-"Unknown Title"}

    tooltip='<img src="$arturl"></img>'

    # Escape &, <, > to HTML-safe entities
    escape() {
        echo "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
    }

    artist=$(escape "$artist")
    title=$(escape "$title")
    text="$artist - $title"

    icon="default"
    [[ "$player" == *spotify* ]] && icon="spotify"

    jq -nc \
        --arg text "$text" \
        --arg class "$status" \
        --arg alt "$player" \
        --arg tooltip "$tooltip" \
        --arg icon "$icon" \
        '{text: $text, class: $class, alt: $alt, tooltip: $tooltip, icon: $icon}'

elif [ "$status" = "Paused" ]; then
    jq -nc '{"text": "Paused", "class": "paused", "icon": "default"}'
else
    # jq -nc '{"text": "", "class": "stopped", "spotify": "spotify","icon": "spotify"}'
    jq -nc \
        --arg text "" \
        --arg class "stopped" \
        --arg alt "notplaying" \
        --arg tooltip "test" \
        --arg icon "notplaying" \
        '{text: $text, class: $class, alt: $alt, tooltip: $tooltip, icon: $icon}'
fi

