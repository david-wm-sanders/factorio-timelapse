# factorio-timelapse

Timelapse is a mod for Factorio that takes screenshots of the world at the specified interval.

The screenshots are written to:
* `__PATH__system-write-data__/script-output/timelapse`
* `/home/user/.factorio/script-output/timelapse` on Linux
* `Users/Name/AppData/Roaming/Factorio/script-output/timelapse` on Windows

## Attention
The output of this mod can grow into GBs quite quickly! Keep an eye on the **script-output/timelapse** folder!

## Installation
0. Download the [latest release](https://github.com/david-wm-sanders/factorio-timelapse/releases).
0. Extract the folder in the archive to:
  * `__PATH__system-write-data__/mods`
  * `/home/user/.factorio/mods` on Linux
  * `Users/Name/AppData/Roaming/Factorio/mods` on Windows
0. Rename the folder from **factorio-timelapse-x.y.z** to **timelapse_x.y.z**.  
   For example, **factorio-timelapse-1.2.3** would become **timelapse_1.2.3**.
0. The next time Factorio is started it should automatically detect and enable the mod.

## Making a video from the timelapse images
### Linux
Use the **make_timelapse.sh** script to command ffmpeg to stitch timelapse images into a video.
