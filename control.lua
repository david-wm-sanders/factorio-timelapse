require "defines"

remote.add_interface("timelapse",
{
  active = function(bool)
    global.timelapse.active = bool
  end,

  interval = function(seconds)
    global.timelapse.interval = 60 * seconds
  end,

  position = function(position)
    global.timelapse.position = position
  end,

  resolution = function(resolution)
    global.timelapse.resolution = resolution
  end,

  zoom = function(zoom)
    global.timelapse.zoom = zoom
  end,

  show_entity_info = function(bool)
    global.timelapse.show_entity_info = bool
  end,

  data = function()
    d = global.timelapse
    s = string.format("Timelapse: \z
                      Count = %i, Active = %s, Interval = %i, \z
                      Position = {x=%.2f, y=%.2f}, Resolution = %ix%i, \z
                      Zoom = %.2f, Show Entity Info = %s",
                      d.count, d.active, d.interval / 60,
                      d.position.x, d.position.y, d.resolution.x, d.resolution.y,
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
    -- interval = 60 ticks per seconds * number of seconds between shots
    interval = 60 * 30,
    -- position = game.player.force.get_spawn_position(1)
    -- The spawn is at {0, 0} by default
    position = {x=0, y=0},
    -- resolution = {x, y}
    resolution = {x=1920, y=1080},
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
  local outf = string.format("timelapse/%i_%010i_%s.png", seed, game.tick, ftime(game.tick))
  game.player.print(string.format("x%i -> %q", global.timelapse.count, outf))
  game.take_screenshot{
    player = nil,
    position = global.timelapse.position,
    resolution = global.timelapse.resolution,
    zoom = global.timelapse.zoom,
    path = outf,
    show_gui = false,
    show_entity_info = global.timelapse.show_entity_info}
end

script.on_event(defines.events.on_tick, function(event)
  if global.timelapse.active then
    if game.tick % global.timelapse.interval == 0 then
      take_shot()
    end
  end
end)
