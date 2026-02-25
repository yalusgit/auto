#!/bin/bash

# Set wallpaper (nitrogen picks a random one from ~/Pictures/wallpaper/)
nitrogen --random --set-zoom-fill &

# Compositor
picom -b -f &

# Launch i3
exec i3
