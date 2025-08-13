#!/usr/bin/env bash

dir="$HOME/.config/rofi/"
theme='vertical-left'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
