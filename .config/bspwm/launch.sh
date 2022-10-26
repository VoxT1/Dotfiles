#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

echo "---" | tee -a /tmp/polybar1.log
polybar mainBar 2>&1 | tee -a /tmp/polybar1.log & disown
polybar secBar 2>&1 | tee -a /tmp/polybar1.log & disown
