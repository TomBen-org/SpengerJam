local misc_math = require("misc_math")
local vector = require("vector")


local activate_mouse = function(state,x,y)
  local next_mouse = table.remove(state.mice_pool,1)
  table.insert(state.mice,{
    pos = vector.new(x, y),
    infection = next_mouse.infection,
    active = true,
    to_pool = false,
  })
end

local check_spawn_mouse = function(state)
  if #state.mice_pool > 0 and state.last_spawn_update + constants.spawn_delay < state.ticks_played  then
    local spacing = math.random(1,4) * 20
    local group_size = math.random(1,math.min(4,#state.mice_pool))
    local starting_y = math.random(10,constants.screen_h-(spacing*group_size))
    for k = 1, group_size do
      activate_mouse(state,math.random(-60,-10),starting_y + k*spacing)
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
  local state =
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
    push_pull = 0,
  }

  return state
end

simulation.update = function(state)
  for mouse_index, mouse in pairs(state.mice) do
    mouse.pos.x = mouse.pos.x + constants.mouse_x_speed

    local target_y_position = love.mouse.getY()
    local distance = (mouse.pos - vector.new(love.mouse.getX(), target_y_position)):len()
    local y_distance = math.abs(mouse.pos.y - target_y_position)


    if distance > constants.max_push_distance then
      distance = 0
    else
      distance = constants.max_push_distance - distance
    end

    local push_pull_offset = 0.3 * math.sqrt(distance)

    if y_distance < 10 then
      push_pull_offset = 0
    end

    if mouse.pos.y > target_y_position then
      push_pull_offset = push_pull_offset * -1
    end

    if state.push_pull == 1 then
      -- push away
      push_pull_offset = push_pull_offset * -1
    end


    if state.push_pull ~= 0 or push_pull_offset == 0 then
      mouse.pos.y = mouse.pos.y + push_pull_offset * constants.mouse_y_speed
    end

    if mouse.pos.x >= constants.screen_w then
      mouse.active = false
      mouse.to_pool = true
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