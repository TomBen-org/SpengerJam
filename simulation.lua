local misc_math = require("misc_math")

local simulation = {}

simulation.create = function()
  return
  {
    mice =
    {
      {
        pos = {100, 100},

        speed = 5,
        direction = misc_math.random_direction_vector()
      }
    },
  }
end

simulation.update = function(state)

  for _, mouse in pairs(state.mice) do
    local newpos =
    {
      mouse.pos[1] + mouse.direction[1] * mouse.speed,
      mouse.pos[2] + mouse.direction[2] * mouse.speed,
    }

    if not misc_math.point_in_box(newpos[1], newpos[2], 0, 0, constants.screen_w, constants.screen_h) then
      mouse.direction = misc_math.random_direction_vector()
    else
      mouse.pos = newpos
    end

  end

end

return simulation