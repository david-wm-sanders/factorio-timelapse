#!/bin/bash
# Create a mp4 video from timelapse images using ffmpeg
# Takes one argument: the seed of the world
ffmpeg \
-framerate 8 \
-pattern_type glob -i "../../script-output/timelapse/$1*.png" \
-c:v libx264 \
-vf "fps=24,format=yuv420p" \
-preset veryslow \
"../../script-output/timelapse/timelapse_$1_$(date +%s).mp4"
