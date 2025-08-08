#!/bin/bash

killall swaync

sleep 0.2

swaync &

sleep 0.1

swaync-client -t -sw
