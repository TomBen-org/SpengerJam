local anim8 = require 'anim8'

local render_mouse = function(mouse)
  if mouse.infection == 'healthy' then
    love.graphics.setColor(1, 1, 1)
  elseif mouse.infection == 'albino' then
    love.graphics.setColor(1, 0.4, 0.4)
  elseif mouse.infection == 'zombie' then
    love.graphics.setColor(0.2, 1, 0.2)
  end
  local ox = 128+64
  local oy = 128+86
  local scale = 0.6
  love.graphics.setColor(1,1,1)
  if mouse.animation then
    if mouse.infection == 'healthy' then
      mouse.animation:draw(images.rat_normal.png,mouse.pos.x-ox,mouse.pos.y-oy)
    elseif mouse.infection == 'albino' then
      mouse.animation:draw(images.rat_albino.png,mouse.pos.x-ox,mouse.pos.y-oy)
    elseif mouse.infection == 'zombie' then
      mouse.animation:draw(images.rat_zombie.png,mouse.pos.x-ox,mouse.pos.y-oy)
    end
  end
  love.graphics.rectangle("line", mouse.pos.x-constants.mouse_width/2, mouse.pos.y-constants.mouse_width/2, constants.mouse_width, constants.mouse_height)
end

local render_trapdoor = function(trapdoor)
  love.graphics.setColor(1, 1, 1)

  if trapdoor.target == "zombie" then
    love.graphics.setColor(0.5,1,0.5)
  end
  if trapdoor.target == "albino" then
    love.graphics.setColor(1,0.5,0.5)
  end

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
  images.room = {
    png = love.graphics.newImage('assets/floor/floor.png')
  }
  images.rat_normal = {
    png = love.graphics.newImage('assets/rat-normal.png'),
    grid = anim8.newGrid(384,384,384*8,384)
  }
  images.rat_albino = {
    png = love.graphics.newImage('assets/rat-albino.png'),
    grid = anim8.newGrid(384,384,384*8,384)
  }
  images.rat_zombie = {
    png = love.graphics.newImage('assets/rat-zombie.png'),
    grid = anim8.newGrid(384,384,384*8,384)
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
  
  for _, mouse in pairs(state.mice) do
    if not mouse.animation then
      mouse.animation = anim8.newAnimation(images.rat_zombie.grid('1-8',1), 0.08)
      mouse.animation:gotoFrame(math.random(1,8))
    end
    mouse.animation:update(dt)
  end
end

renderer.render_state = function(state)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.clear()

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(images.room.png,0,0)


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

  love.graphics.setColor(1, 1, 1)
  love.graphics.print("mice in pool: "..#state.mice_pool,0,15)
  love.graphics.print("lives: ".. state.lives .. "/" .. constants.max_lives,0,25)


  love.graphics.setColor(0, 1, 0, 0.2)
  --love.graphics.circle("fill", love.mouse.getX(), love.mouse.getY(), constants.max_push_distance)



--  love.graphics.setColor(1,1,0, 0.8)
--  love.graphics.rectangle("fill", 0, 0, constants.screen_w, constants.clip_top)
--  love.graphics.rectangle("fill", 0, constants.screen_h - constants.clip_bottom, constants.screen_w, constants.clip_bottom)


  love.graphics.setColor(1, 0, 0, state.blood_alpha)
  love.graphics.rectangle("fill", 0, 0, constants.screen_w, constants.screen_h)
end

return renderer