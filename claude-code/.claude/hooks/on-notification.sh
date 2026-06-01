#!/usr/bin/env bash
TITLE="Claude-$CLAUDE_INSTANCE_ID"
CURRENT_ADDR=$(hyprctl clients -j | jq -r --arg t "$TITLE" '.[] | select(.title == $t) | .address')
FOCUSED_ADDR=$(hyprctl activewindow -j | jq -r .address)

if [[ "$CURRENT_ADDR" != "$FOCUSED_ADDR" ]]; then
    hyprctl dispatch "hl.dsp.window.tag({window = 'address:$CURRENT_ADDR', tag = '+urgent*'})"
    hyprctl dispatch "hl.dsp.event('claude-urgent')" 2>/dev/null || true
    notify-send 'Claude Code' 'Awaiting input' 2>/dev/null
fi

