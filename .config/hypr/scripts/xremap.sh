#!/usr/bin/env bash

sleep 3  # give time for polkit agent to load

# optional: log to check if we're getting this far
echo "Starting xremap with pkexec" >> /tmp/xremap.log

pkexec /usr/bin/xremap ~/.config/xremap/config.yml
