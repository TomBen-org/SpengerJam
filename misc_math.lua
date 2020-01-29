local vector_light = require("vector-light")

local misc_math = {}


misc_math.point_in_box = function(x, y, bx, by, w, h)
  return x >= bx and x <= bx + w and y >= by and y <= by + h
end

misc_math.random_direction_vector = function()
  local x = math.random()*2-1
  local y =math.random()*2-1
  x, y = vector_light.normalize(x, y)

  return {x, y}
end

return misc_math