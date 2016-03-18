require "defines"

-- Derived from util.formattime
function ftime(ticks)
  local seconds = ticks / 60
  local min = math.floor(seconds / 60)
  local sec = math.floor(seconds - 60 * min)
  return string.format("%d_%02d", min, sec)
end

function init_timelapse()
  global.timelapse = {
    resolution = {2500, 2500},
    zoom = 0.29,
    show_gui = false,
    show_entity_info = false,
  }
end

script.on_init(function()
  init_timelapse()
end)

script.on_event(defines.events.on_tick, function(event)
  if (game.tick % 1800 == 0 and game.tick > 0) then
    local player = game.player
    local spawnpos = player.force.get_spawn_position(1)
    local seed = player.surface.map_gen_settings.seed
    game.player.print("x")
    game.take_screenshot{
      player = nil,
      position = spawnpos,
      resolution = global.timelapse.resolution,
      zoom = global.timelapse.zoom,
      path = "timelapse/"..seed.."_"..game.tick.."_"..ftime(game.tick)..".png",
      show_gui = global.timelapse.show_gui,
      show_entity_info = global.timelapse.show_entity_info}
    end
end)
