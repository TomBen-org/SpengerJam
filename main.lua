local simulation = require("simulation")
local renderer = require("renderer")


local state
function love.load()
  state = simulation.create()
  units = {
    {button='a',type='press'},
    {button='b',type='press'},
    {button='c',type='press'},
    {button='d',type='press'}
  }
  mouse_state = 0
  mouse_speed = 100
  mice = {}
  for k=1,100 do
    table.insert(mice,{x=math.random(10,600),y=math.random(10,600),dx=0,dy=0})
  end
end

function love.draw()
  renderer.render_state(state)

  love.graphics.print("mouse_state: "..mouse_state,0,0)

  for _, mouse in pairs(mice) do
    love.graphics.circle("fill",mouse.x,mouse.y,5,15)
  end
end

function love.resize()
end

function love.keypressed(key)
end

function love.keyreleased(key)
end

function love.mousemoved(x,y)
end

function love.wheelmoved(x,y)

end

function love.mousepressed(x,y,button)
  if mouse_state == 0 and button == 2 then
    mouse_state = 2
  elseif mouse_state == 0 and button == 1 then
    mouse_state = 1
  end
end

function love.mousereleased(x,y,button)
  if mouse_state == 2 and button == 2 then
    mouse_state = 0
  elseif mouse_state == 1 and button == 1 then
    mouse_state = 0
  end
end

function love.quit()

end

local mouse_update = function(mouse,dt)
  mouse.x = mouse.x + mouse.dx*mouse_speed*dt
  mouse.y = mouse.y + mouse.dy*mouse_speed*dt

  if mouse_state == 1 then
    --push away
  elseif mouse_state == 2 then
    --pull towards
  end
end

local accumulatedDeltaTime = 0
function love.update(deltaTime)
  accumulatedDeltaTime = accumulatedDeltaTime + deltaTime
  for _, mouse in pairs(mice) do
    mouse_update(mouse,deltaTime)
  end
  local tickTime = 1/60

  while accumulatedDeltaTime > tickTime do
      simulation.update(state)
      accumulatedDeltaTime = accumulatedDeltaTime - tickTime
  end

end
