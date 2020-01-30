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

local render_trapdoor = function(trapdoor)
  love.graphics.setColor(1, 1, 1)
  local offset = 128
  trapdoor.animation:draw(images.trapdoor.png,trapdoor.pos.x-offset,trapdoor.pos.y-offset)
end

local renderer = {}

renderer.on_load = function()
  images = {}
  images.trapdoor = {
  png = love.graphics.newImage('assets/trapdoor-sheet.png'),
  grid = anim8.newGrid(256,256,2048,256)
  }
end

renderer.update = function(state,dt)
  for _, trapdoor in pairs(state.trapdoors) do
    if not trapdoor.animation then
      trapdoor.animation = anim8.newAnimation(images.trapdoor.grid('1-8',1), 0.08)
    end
    trapdoor.animation:update(dt*trapdoor.direction)
    if trapdoor.animation.position == 8 and trapdoor.direction > 0 then
      trapdoor.animation:pause()
    elseif trapdoor.animation.position == 1 and trapdoor.direction < 0 then
      trapdoor.animation:pause()
    end
  end
end

renderer.render_state = function(state)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.clear()

  love.graphics.setColor(1,1,0)
  love.graphics.rectangle("fill", 0, 0, constants.screen_w, constants.clip_top)
  love.graphics.rectangle("fill", 0, constants.screen_h - constants.clip_bottom, constants.screen_w, constants.clip_bottom)

  for _, trapdoor in pairs(state.trapdoors) do
    love.graphics.setColor(0, 1, 0)

    local mode = "fill"
    if state.trapdoors_open then
      mode = "line"
    end

    render_trapdoor(trapdoor)
    --love.graphics.rectangle("line",
    --trapdoor.pos.x - constants.trapdoor_width/2,
    --trapdoor.pos.y - constants.trapdoor_height/2,
    --constants.trapdoor_width,
    --constants.trapdoor_height)

  end

  for _, mouse in pairs(state.mice) do
    render_mouse(mouse)
  end

  love.graphics.print("mice in pool: "..#state.mice_pool,0,15)
end

return renderer