local simulation = require("simulation")
local renderer = require("renderer")
local vector = require('vector')

--TODO: mice not collide
--TODO: mice pool (puzzle)
--TODO: puzzle generator



local state
function love.load()
  math.randomseed(1)
  --math.randomseed(os.time()) UNCOMMENT ME IN FINAL VER

  state = simulation.create()
  simulation.add_mice_to_pool(state,50,'healthy')

  mouse_state = 0

  max_push_distance = 150
  mice = {}
  --for k=1,100 do
  --  table.insert(mice,{pos=vector.new(math.random(10,600),math.random(10,600)),vector=vector.new(0,0)})
  --end
end

function love.draw()
  renderer.render_state(state)

  love.graphics.print("mouse_state: "..mouse_state,0,0)
  love.graphics.setColor(0,125,30)
  for _, mouse in pairs(mice) do
    love.graphics.circle("fill",mouse.pos.x,mouse.pos.y,5,15)
  end
  love.graphics.setColor(0,0,0)
end

function love.resize()
end

function love.keypressed(key)
  if key == "space" then
    state.trapdoors_open = true
  end
end

function love.keyreleased(key)
  if key == "space" then
    state.trapdoors_open = false
  end
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
  local relative_mouse_vector = vector.new(love.mouse.getX(),love.mouse.getY())
  relative_mouse_vector = relative_mouse_vector - mouse.pos

  local distance = max_push_distance-(math.min(relative_mouse_vector:len(),max_push_distance))
  if distance < 10 then
    relative_mouse_vector = vector.new(0,0)
  end
  relative_mouse_vector = relative_mouse_vector * dt * mouse_speed
  if mouse_state == 1 then
    --push away
    relative_mouse_vector = relative_mouse_vector * -1
  elseif mouse_state == 2 then
    --pull towards
  else
    --zero
    relative_mouse_vector = vector.new(0,0)
  end

  mouse.vector = mouse.vector + relative_mouse_vector
  mouse.pos = mouse.pos + mouse.vector*dt*mouse_speed*math.sqrt(distance)
  mouse.vector = mouse.vector * dt * mouse_drag
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
