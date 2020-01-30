local anim8 = require 'anim8'

local render_mouse = function(mouse)
  if mouse.infection == 'healthy' then
    love.graphics.setColor(1, 1, 1)
  elseif mouse.infection == 'albino' then
    love.graphics.setColor(1, 0.4, 0.4)
  elseif mouse.infection == 'zombie' then
    love.graphics.setColor(0.2, 1, 0.2)
  end
  love.graphics.circle("fill", mouse.pos.x, mouse.pos.y, constants.mouse_radius)
end

local renderer = {}

--image = love.graphics.newImage('graphics/Woodcutter_attack1.png')
--local g = anim8.newGrid(48, 48, image:getWidth(), image:getHeight())
--animation = anim8.newAnimation(g('1-6',1), 0.1)

renderer.render_trapdoor = function(trapdoor)

end

renderer.render_state = function(state)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.clear()

  for _, trapdoor in pairs(state.trapdoors) do
    love.graphics.setColor(0, 1, 0)

    local mode = "fill"
    if state.trapdoors_open then
      mode = "line"
    end

    love.graphics.rectangle(mode,
      trapdoor.pos.x - constants.trapdoor_width/2,
      trapdoor.pos.y - constants.trapdoor_height/2,
      constants.trapdoor_width,
      constants.trapdoor_height)
  end

  for _, mouse in pairs(state.mice) do
    render_mouse(mouse)
  end

  love.graphics.print("mice in pool: "..#state.mice_pool,0,15)
end

return renderer