local anim8 = require 'anim8'

local render_mouse = function(mouse)
  if mouse.infection == 'healthy' then
    love.graphics.setColor(1, 1, 1)
  elseif mouse.infection == 'albino' then
    love.graphics.setColor(1, 0.4, 0.4)
  elseif mouse.infection == 'zombie' then
    love.graphics.setColor(0.2, 1, 0.2)
  end
  local ox = 70
  local oy = 84
  local scale = 1
  love.graphics.setColor(1,1,1)
  if mouse.animation then
    if mouse.infection == 'healthy' then
      mouse.animation:draw(images.rat_normal.png,mouse.pos.x-ox,mouse.pos.y-oy,0,scale,scale)
    elseif mouse.infection == 'albino' then
      mouse.animation:draw(images.rat_albino.png,mouse.pos.x-ox,mouse.pos.y-oy,0,scale,scale)
    elseif mouse.infection == 'zombie' then
      mouse.animation:draw(images.rat_zombie.png,mouse.pos.x-ox,mouse.pos.y-oy,0,scale,scale)
    end
  end
  if mouse.heart then
    love.graphics.draw(images.heart.png, mouse.pos.x - 15, mouse.pos.y - 70)
  end
  --love.graphics.rectangle("line", mouse.pos.x-constants.mouse_width/2, mouse.pos.y-constants.mouse_width/2, constants.mouse_width, constants.mouse_height)
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
  trapdoor.animation:draw(images.trapdoor.png,trapdoor.pos.x-offset,trapdoor.pos.y-offset,0,2,2)
end

local renderer = {}

renderer.on_load = function()
  the_font = love.graphics.newFont('/assets/font-regular.ttf',16)
  images = {}
  images.trapdoor = {
  png = love.graphics.newImage('assets/trapdoor-sheet.png'),
  grid = anim8.newGrid(128,128,128*8,128)
  }
  images.room = {
    png = love.graphics.newImage('assets/floor/floor.png')
  }
  images.rat_normal = {
    png = love.graphics.newImage('assets/rat-normal.png'),
    grid = anim8.newGrid(128,128,128*16,128)
  }
  images.rat_albino = {
    png = love.graphics.newImage('assets/rat-albino.png'),
    grid = anim8.newGrid(128,128,128*16,128)
  }
  images.rat_zombie = {
    png = love.graphics.newImage('assets/rat-zombie.png'),
    grid = anim8.newGrid(128,128,128*16,128)
  }
  images.cheese = {
    png = love.graphics.newImage('assets/cheese.png')
  }
  images.heart =
  {
    png = love.graphics.newImage("assets/heart-icon/heart pixel art 32x32.png")
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
      if mouse.infection == 'healthy' then
        mouse.animation = anim8.newAnimation(images.rat_normal.grid('1-16',1), 0.04)
        mouse.animation:gotoFrame(math.random(1,16))
      elseif mouse.infection == 'albino' then
        mouse.animation = anim8.newAnimation(images.rat_albino.grid('1-16',1), 0.04)
        mouse.animation:gotoFrame(math.random(1,16))
      elseif mouse.infection == 'zombie' then
        mouse.animation = anim8.newAnimation(images.rat_zombie.grid('1-16',1), 0.04)
        mouse.animation:gotoFrame(math.random(1,16))
      end
    end
    mouse.animation:update(dt)
  end
end

renderer.render_state = function(state)

  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(images.room.png,0,0,0,1,1)


  for _, trapdoor in pairs(state.trapdoors) do
    love.graphics.setColor(0, 1, 0)
    render_trapdoor(trapdoor)
    --love.graphics.setColor(1,1,1)
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
  love.graphics.print("score: "..state.score,0,15)
  love.graphics.print("lives: ".. state.lives .. "/" .. constants.max_lives,0,25)


  love.graphics.setColor(0, 1, 0, 0.2)
  --love.graphics.circle("fill", love.mouse.getX(), love.mouse.getY(), constants.max_push_distance)



  --love.graphics.setColor(1,1,0, 0.8)
  --love.graphics.rectangle("fill", 0, 0, constants.screen_w, constants.clip_top)
  --love.graphics.rectangle("fill", 0, constants.screen_h - constants.clip_bottom, constants.screen_w, constants.clip_bottom)


  love.graphics.setColor(1, 0, 0, state.blood_alpha)
  love.graphics.rectangle("fill", 0, 0, constants.screen_w, constants.screen_h)

  local click_text = love.graphics.newText(the_font,"Left click for cheese")
  love.graphics.setColor(0,0,0)
  local margin = 15
  local x,y = (constants.screen_w/2)-(click_text:getWidth()/2),constants.screen_h-50
  love.graphics.rectangle("fill",x-margin,y-margin,click_text:getWidth()+margin*2,click_text:getHeight()+margin*2)
  love.graphics.setColor(1,1,1)
  love.graphics.draw(click_text,x,y)

  if state.push_pull == 2 then
    love.mouse.setVisible(false)
    love.graphics.draw(images.cheese.png,love.mouse.getX()-16,love.mouse.getY()-16)
  else
    love.mouse.setVisible(true)
  end

  end

renderer.render_before_game = function(maybe_state)
  love.graphics.setColor(1,1,1)

  if maybe_state then
    love.graphics.print("You Lose!", 100, 70)
    love.graphics.print("Score: " .. maybe_state.score, 100, 80)
  end

  love.graphics.print("Click to start", 100, 100)
end

return renderer