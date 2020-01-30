local misc_math = require("misc_math")
local vector = require("vector")


local simulation = {}

simulation.create = function()
  return
  {
    mice =
    {
      {
        pos = vector.new(100, 100),

        speed = 5,
        direction = vector.new(1, 0),
      }
    },

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
  local to_remove = {}

  for mouse_index, mouse in pairs(state.mice) do
    local newpos = mouse.pos + mouse.direction * mouse.speed

    if not misc_math.point_in_box(newpos, vector.zero, constants.screen_w, constants.screen_h) then
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
        to_remove[mouse_index] = 1
      end
    end

  end

  for mouse_index, _ in pairs(to_remove) do
    table.remove(state.mice, mouse_index)
  end

end

return simulation