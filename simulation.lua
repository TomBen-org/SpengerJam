local misc_math = require("misc_math")
local vector = require("vector")


local simulation = {}

simulation.create = function()
  local state =
  {
    mice =
    {
    },

    trapdoors =
    {
      {
        pos = vector.new(constants.screen_w - constants.trapdoor_width - 100, 300)
      }
    },

    trapdoors_open = false,
    push_pull = 0,
  }

  for k=1,100 do
    table.insert(state.mice,
      {
        pos = vector.new(math.random(10,600),math.random(10,600)),
        direction = vector.new(1,0),
      })
  end

  return state
end

simulation.update = function(state)
  local to_remove = {}

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


    for _, trapdoor in pairs(state.trapdoors) do
      if state.trapdoors_open and misc_math.point_in_box(
        mouse.pos,
        trapdoor.pos - vector.new(constants.trapdoor_width/2, constants.trapdoor_height/2),
        constants.trapdoor_width,
        constants.trapdoor_height)
      then
        to_remove[mouse_index] = 1
      end
    end

  end

  for mouse_index, _ in pairs(to_remove) do
    table.remove(state.mice, mouse_index)
  end

end

return simulation