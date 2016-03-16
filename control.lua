require "defines"

script.on_event(defines.events.on_tick, function(event)
  if (game.tick % 1800 == 0 and game.tick > 0) then
    local player = game.player
    local spawnpos = player.force.get_spawn_position(1)
    local res = {2500, 2500}
    local z = 0.29
    local seed = player.surface.map_gen_settings.seed
    game.player.print("x")
    game.take_screenshot{position=spawnpos, resolution=res, zoom=z, path="timelapse/"..seed.."_"..game.tick..".png", show_gui=false, show_entity_info=false}
    end
end)
