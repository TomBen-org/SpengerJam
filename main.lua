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

end

function love.draw()
  renderer.render_state(state)

  love.graphics.setColor(0,125,30)
  love.graphics.print("state.push_pull: "..state.push_pull,0,0)
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
  if state.push_pull == 0 and button == 2 then
    state.push_pull = 2
  elseif state.push_pull == 0 and button == 1 then
    state.push_pull = 1
  end
end

function love.mousereleased(x,y,button)
  if state.push_pull == 2 and button == 2 then
    state.push_pull = 0
  elseif state.push_pull == 1 and button == 1 then
    state.push_pull = 0
  end
end

function love.quit()

end

local mouse_update = function(mouse,dt)

end

local accumulatedDeltaTime = 0
function love.update(deltaTime)
  accumulatedDeltaTime = accumulatedDeltaTime + deltaTime
  for _, mouse in pairs(state.mice) do
    mouse_update(mouse,deltaTime)
  end
  local tickTime = 1/60

  while accumulatedDeltaTime > tickTime do
      simulation.update(state)
      accumulatedDeltaTime = accumulatedDeltaTime - tickTime
  end

end
