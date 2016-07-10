#!/bin/bash
# Create a mp4 video from timelapse images using ffmpeg
# Takes one argument: the seed of the world

# ffmpeg: Options Notes --------------------------------------------------------

# -framerate 24
# Display the images at a rate of 24 per second

# -pattern_type glob -i "../../script-output/timelapse/$1*.png"
# Select the input by matching all images with $1 in their name

# -c:v libx264
# Encode the video stream with the libx264 codec

# -s 1920x1080
# Scale the output to 1920x1080

# -vf "fps=24,format=yuv420p"
# Video filter: use a filterchain to set the output fps to 24 and format=yuv420p

# -preset medium
# Set the encoding speed to compression ratio preset, the options are:
# ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow
# Slower presets provide better compression, default is medium

# -crf 23
# Set the Constant Rate Factor, scale: 0-51 for 8-bit x264, default is 23
# Exponential range: +6: ~0.5x bitrate, -6: ~2x bitrate, visually lossless: ~18

# -f mpegts
# Set the output format to MPEG Transport Stream
# ------------------------------------------------------------------------------

echo "Encoding timelapse video..."

ffmpeg \
-framerate 24 \
-pattern_type glob -i "../../script-output/timelapse/$1*.png" \
-c:v libx264 \
-s 1920x1080 \
-vf "fps=24,format=yuv420p" \
-preset medium \
-crf 23 \
-f mpegts \
"../../script-output/timelapse/timelapse_$1_a.ts"

echo "Encoding timelapse video ending..."

LASTIMG="$(find "../../script-output/timelapse" -type f -name $1*.png | sort | tail -1)"

ffmpeg \
-loop 1 \
-i $LASTIMG \
-c:v libx264 \
-t 5 \
-s 1920x1080 \
-vf "fps=24,format=yuv420p" \
-preset medium \
-crf 23 \
-f mpegts \
"../../script-output/timelapse/timelapse_$1_b.ts"

echo "Stitching final cut..."

ffmpeg \
-i "concat:../../script-output/timelapse/timelapse_$1_a.ts|../../script-output/timelapse/timelapse_$1_b.ts" \
-c copy \
"../../script-output/timelapse/timelapse_$1_$(date +%s).mp4"

echo "Removing intermediate files..."

rm "../../script-output/timelapse/timelapse_$1_a.ts"
rm "../../script-output/timelapse/timelapse_$1_b.ts"

echo "Finished making timelapse video for world $1."
