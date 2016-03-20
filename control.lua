require "defines"

function init_timelapse()
  global.timelapse = {
    count = 0,
    -- interval = 60 ticks per seconds * number of seconds between shots
    interval = 60 * 60,
    -- position = game.player.force.get_spawn_position(1)
    -- The spawn is at {0, 0} by default
    position = {0, 0},
    -- resolution = {x, y}
    resolution = {2000, 2000},
    -- zoom (default: 1, minimum scrollable to in game: 0.29)
    zoom = 0.29,
    show_gui = false,
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
    show_gui = global.timelapse.show_gui,
    show_entity_info = global.timelapse.show_entity_info}
end

script.on_event(defines.events.on_tick, function(event)
  if (game.tick % global.timelapse.interval == 0 and game.tick > 0) then
    take_shot()
  end
end)
