local HC = require("HC")

local collisions = {}

collisions.create_empty = function()
  local collider = HC.new(150)

  local offscreen = 200
  collider:rectangle(-offscreen, 0, constants.screen_w + offscreen * 2, constants.clip_top)
  collider:rectangle(-offscreen, constants.screen_h - constants.clip_bottom, constants.screen_w + offscreen * 2, constants.clip_bottom)

  return collider
end

collisions.try_add_mouse = function(collider, mouse)
  print(mouse.pos.x-constants.mouse_width/2, mouse.pos.y-constants.mouse_width/2, constants.mouse_width, constants.mouse_height)
  local mouse_collider = collider:rectangle(mouse.pos.x-constants.mouse_width/2, mouse.pos.y-constants.mouse_width/2, constants.mouse_width, constants.mouse_height)

  if next(collider:collisions(mouse_collider)) then
    collider:remove(mouse_collider)
    return false
  end

  return true
end

collisions.add_all_mice = function(collider, state)
  for _, mouse in pairs(state.mice) do
    mouse.collider_tmp = collider:rectangle(mouse.pos.x-constants.mouse_width/2, mouse.pos.y-constants.mouse_width/2, constants.mouse_width, constants.mouse_height)
  end
end

return collisions