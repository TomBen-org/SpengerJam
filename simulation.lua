local misc_math = require("misc_math")
local vector = require("vector")


local activate_mouse = function(state)
  local next_mouse = table.remove(state.mice_pool,1)
  table.insert(state.mice,{
    pos = {0,math.random(1,constants.screen_h)},
    direction = {1,0},
    speed = constants.mouse_speed,
    infection = next_mouse.infection,
    active = true,
    to_pool = false,
  })
end

local check_spawn_mouse = function(state)
  if #state.mice_pool > 0 and state.last_spawn_update + constants.spawn_delay < state.ticks_played  then
    for k = 1, math.random(1,math.min(4,#state.mice_pool)) do
      activate_mouse(state)
    end
    state.last_spawn_update = state.ticks_played
  end
end

local simulation = {}

simulation.add_mice_to_pool = function (state,quantity,type)
  for k = 1, quantity do
  table.insert(state.mice_pool, {
    infection = type
  })
  end
end

simulation.create = function()
  return
  {
    ticks_played = 0,
    last_spawn_update = 0,
    mice_pool = {},

    mice = {},

    trapdoors =
    {
      {
        pos = vector.new(constants.screen_w - constants.trapdoor_width - 100, 300)
      }
    },

    trapdoors_open = false,
  }
end

simulation.update = function(state)
  for mouse_index, mouse in pairs(state.mice) do
    local newpos = mouse.pos + mouse.direction * mouse.speed

    if newpos[1] >= constants.screen_w then
      mouse.active = false
      mouse.to_pool = true
    elseif not misc_math.point_in_box(newpos, vector.zero-100, constants.screen_w+200, constants.screen_h) then
      mouse.direction = misc_math.random_direction_vector()
    else
      mouse.pos = newpos
    end

    for _, trapdoor in pairs(state.trapdoors) do
      if state.trapdoors_open and misc_math.point_in_box(
        mouse.pos,
        trapdoor.pos - vector.new(constants.trapdoor_width/2, constants.trapdoor_height/2),
        constants.trapdoor_width,
        constants.trapdoor_height)
      then
        mouse.active = false
      end
    end
  end

  for mouse_index, mouse in pairs(state.mice) do
    if mouse.to_pool then
      table.insert(state.mice_pool,{infection=mouse.infection})
    end
    if mouse.active == false then
      table.remove(state.mice,mouse_index)
    end
  end

  check_spawn_mouse(state)
  state.ticks_played = state.ticks_played + 1
end

return simulation