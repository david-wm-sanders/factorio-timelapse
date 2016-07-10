require "defines"

local state = 0
local current_time = 1.0

function is_array(t)
    -- From: https://ericjmritz.name/2014/02/26/lua-is_array/
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

remote.add_interface("timelapse",
{
  active = function(bool)
    if bool == nil then
      game.player.print(string.format("Active = %s", global.timelapse.active))
    elseif type(bool) ~= "boolean" then
      game.player.print("Argument must be a boolean")
    else
      global.timelapse.active = bool
      if bool == true then
        game.player.print("Timelapse activated")
      else
        game.player.print("Timelapse deactivated")
      end
    end
  end,

  light_mode = function(mode)
    if mode == nil then
      game.player.print(string.format("Light Mode = %s", global.timelapse.light_mode))
    elseif type(mode) ~= "string" then
      game.player.print("Argument must be a string")
    else
      if mode == "fixed" or mode == "none" then
        global.timelapse.light_mode = mode
      else
        game.player.print("Argument must be \"fixed\" or \"none\".")
      end
    end
  end,

  fixed_light = function(light)
    if light == nil then
      game.player.print(string.format("Fixed Light = %.2f", global.timelapse.fixed_light))
    elseif type(light) ~= "number" then
      game.player.print("Argument must be a number")
    else
      if light < 0 or light > 1 then
        game.player.print("Argument must be a number >= 0 and <= 1")
      else
        global.timelapse.fixed_light = light
      end
    end
  end,

  interval = function(seconds)
    if seconds == nil then
      game.player.print(string.format("Interval = %is", global.timelapse.interval / 60))
    elseif type(seconds) ~= "number" then
      game.player.print("Argument must be a number")
    else
      if seconds < 10 then
        game.player.print("Argument must be >= 10")
      else
        global.timelapse.interval = 60 * seconds
      end
    end
  end,

  position = function(position)
    if position == nil then
      game.player.print(string.format("Position = {x=%.2f, y=%.2f}", global.timelapse.position.x, global.timelapse.position.y))
    elseif type(position) ~= "table" then
      game.player.print("Argument must be a table")
    else
      local x, y = 0, 0
      if is_array(position) then
        x, y = position[1], position[2]
      else
        x, y = position.x, position.y
      end
      if type(x) ~= "number" or type(y) ~= "number" then
        game.player.print("Argument must be a table whose values are numbers")
      else
        global.timelapse.position = {x=x, y=y}
      end
    end
  end,

  resolution = function(resolution)
    if resolution == nil then
      game.player.print(string.format("Resolution = %ix%i", global.timelapse.resolution.x, global.timelapse.resolution.y))
    elseif type(resolution) ~= "table" then
      game.player.print("Argument must be a table")
    else
      local x, y = 1920, 1080
      if is_array(resolution) then
        x, y = resolution[1], resolution[2]
      else
        x, y = resolution.x, resolution.y
      end
      if type(x) ~= "number" or type(y) ~= "number" then
        game.player.print("Argument must be a table whose values are numbers")
      elseif x < 10 or y < 10 then
        game.player.print("Argument must be a table whose values are >= 10")
      else
        global.timelapse.resolution = {x=x, y=y}
      end
    end
  end,

  zoom = function(zoom)
    if zoom == nil then
      game.player.print(string.format("Zoom = %.2f", global.timelapse.zoom))
    elseif type(zoom) ~= "number" then
      game.player.print("Argument must be a number")
    else
      if zoom >= 0.1 and zoom <= 3 then
        global.timelapse.zoom = zoom
      else
        game.player.print("Argument must be a number >= 0.1 and <= 3")
      end
    end
  end,

  show_entity_info = function(bool)
    if bool == nil then
      game.player.print(string.format("Show Entity Info = %s", global.timelapse.show_entity_info))
    elseif type(bool) ~= "boolean" then
      game.player.print("Argument must be a boolean")
    else
      global.timelapse.show_entity_info = bool
    end
  end,

  data = function()
    local d = global.timelapse
    local s = string.format("Timelapse: \z
                            Count = %i, Active = %s, \z
                            Light Mode = %s, Fixed Light = %.2f, \z
                            Interval = %is, \z
                            Position = {x=%.2f, y=%.2f}, \z
                            Resolution = %ix%i, \z
                            Zoom = %.2f, Show Entity Info = %s",
                            d.count, d.active,
                            d.light_mode, d.fixed_light,
                            d.interval / 60,
                            d.position.x, d.position.y,
                            d.resolution.x, d.resolution.y,
                            d.zoom, d.show_entity_info)
    game.player.print(s)
  end,

  reset = function()
    init_timelapse()
  end,
})

function init_timelapse()
  global.timelapse = {
    count = 0,
    active = false,
    light_mode = "fixed",
    fixed_light = 1.0,
    -- interval = 60 ticks per seconds * number of seconds between shots
    interval = 60 * 60 * 5,
    -- The spawn is at {0, 0} by default
    position = {x=0, y=0},
    resolution = {x=3840, y=2160},
    -- zoom (default: 1, minimum scrollable to in game: 0.29)
    zoom = 0.1,
    show_entity_info = false,
  }
end

script.on_init(function()
  init_timelapse()
end)

script.on_load(function()
  if global.timelapse == nil then
    init_timelapse()
  end
end)

script.on_configuration_changed(function(data)
  init_timelapse()
end)

-- Derived from util.formattime
function ftime(ticks)
  local sec = ticks / 60
  local hours = math.floor(sec / 3600)
  local minutes = math.floor(sec / 60 - hours * 60)
  local seconds = math.floor(sec - hours * 3600 - minutes * 60)
  return string.format("%02d_%02d_%02d", hours, minutes, seconds)
end

function take_shot()
  global.timelapse.count = global.timelapse.count + 1
  local seed = game.player.surface.map_gen_settings.seed
  local outf = string.format("timelapse/%u_%010u_%s.png", seed, game.tick, ftime(game.tick))
  game.player.print(string.format("x%u -> %q", global.timelapse.count, outf))
  game.take_screenshot{
    player = nil,
    position = global.timelapse.position,
    resolution = global.timelapse.resolution,
    zoom = global.timelapse.zoom,
    path = outf,
    show_gui = false,
    show_entity_info = global.timelapse.show_entity_info}
end

function light()
  local d = global.timelapse
  if d.light_mode == "fixed" then
    current_time = game.daytime
    game.daytime = d.fixed_light
  end
end

function unlight()
  local d = global.timelapse
  if d.light_mode == "fixed" then
    game.daytime = current_time
  end
end

script.on_event(defines.events.on_tick, function(event)
  if global.timelapse.active then
    if (game.tick + 1) % global.timelapse.interval == 0 then
      light()
      state = 1
    elseif state == 1 then
      take_shot()
      state = 2
    elseif state == 2 then
      unlight()
      state = 0
    end
  end
end)
