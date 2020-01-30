local vector = require("vector")

local misc_math = {}


misc_math.point_in_box = function(point, box_top_left, w, h)
  return point.x>= box_top_left.x and point.x <= box_top_left.x + w and point.y >= box_top_left.y and point.y <= box_top_left.y + h
end

misc_math.random_direction_vector = function()
  local vec = vector.new(math.random()*2-1, math.random()*2-1)
  vec:normalizeInplace()
  return vec
end

misc_math.lerp = function(a, b, alpha)
  return a * alpha + b * (1-alpha)
end

return misc_math