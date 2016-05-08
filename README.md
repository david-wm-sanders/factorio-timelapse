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

## Usage
Timelapse is controlled via the in-game console.
### Activating Timelapse
Timelapse is deactivated by default when starting a new world or loading an old world with the mod for the first time.

To activate Timelapse, use:  
`/c remote.call("timelapse", "active", true)`

To deactivate Timelapse, use:  
`/c remote.call("timelapse", "active", false)`

### Controlling Timelapse
In extension to **active**, several other functions are provided:

* **interval**: to set the interval, use:  
`/c remote.call("timelapse", "interval", interval_in_seconds)`
* **position**: to set the position, use:  
`/c remote.call("timelapse", "position", {x=xpos, y=ypos})`  
*[Note: a Lua array {x, y} will also be accepted by the interface]*
* **resolution**: to set the resolution, use:  
`/c remote.call("timelapse", "resolution", {x=xres, y=yres})`  
*[Note: a Lua array {x, y} will also be accepted by the interface]*
* **zoom**: to set the zoom, use:  
`/c remote.call("timelapse", "zoom", zoom_level)`
* **show_entity_info**: to set show_entity_info, use:  
`/c remote.call("timelapse", "show_entity_info", boolean)`
* **data**: to get a summary of the current Timelapse configuration, use:  
`/c remote.call("timelapse", "data")`
* **reset**: to reset the Timelapse configuration back to the default settings, use:  
`/c remote.call("timelapse", "reset")`  
*[Note: resetting the configuration will set active to false i.e. deactivate Timelapse]*

With regards to **position**, centre on your current position by using:  
`/c remote.call("timelapse", "position", game.player.position)`

The **active**, **interval**, **position**, **resolution**, **zoom**, and **show_entity_info** functions can also be called without an argument to get their current value.

The mod attempts to provide helpful messages if you provide invalid input to the interface. In the event that you do manage to gum up the mod with some funky input, calling the **reset** function to restore the configuration to the default state is the best recourse.

## Making a video from the Timelapse images
### Linux
Use the **make_timelapse.sh** script to command ffmpeg to stitch Timelapse images into a video.
