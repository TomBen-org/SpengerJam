local simulation = require("simulation")
local renderer = require("renderer")
local vector = require('vector')

--TODO: puzzle generator
--TODO: score feedback graphics
--TODO: lives/fuckups graphics
--TODO: background image (1280x720)
--TODO: trapdoor mouse interaction
--TODO: two trapdoors, three mouse types
--TODO: feedback when geting it right and wrong

--BLOAT: background tiles
--BLOAT: random occasional mouse movement without player interaction
--BLOAT: placeable trapdoors
--BLOAT: Alapati facts




local state
function love.load()
  math.randomseed(1)
  renderer.on_load()
  --math.randomseed(os.time()) UNCOMMENT ME IN FINAL VER

  state = simulation.create()
  simulation.add_mice_to_pool(state,50,'healthy')
  simulation.add_mice_to_pool(state,50,'zombie')
  simulation.add_mice_to_pool(state,50,'albino')
  simulation.shuffle_pool(state)
end

function love.draw()
  renderer.render_state(state)

  love.graphics.setColor(0,125,30)
  love.graphics.print("state.push_pull: "..state.push_pull,0,0)
end

function love.resize()
end

function love.keypressed(key)
  for _, door in pairs(state.trapdoors) do
    if door.key == key then
      door.open = true
      door.direction = 1
      door.animation:resume()
    end
  end

  --if key == "space" then
  --  state.trapdoors_open = true
  --  for _, door in pairs(state.trapdoors) do
  --    --door.animation:pauseAtStart()
  --    door.direction = 1
  --    door.animation:resume()
  --  end
  --end
end

function love.keyreleased(key)
  for _, door in pairs(state.trapdoors) do
    if door.key == key then
      door.open = false
      door.direction = -1
      door.animation:resume()
    end
  end

  --if key == "space" then
  --  state.trapdoors_open = false
  --  for _, door in pairs(state.trapdoors) do
  --    --door.animation:pauseAtEnd()
  --    door.direction = -1
  --    door.animation:resume()
  --  end
  --end
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
  renderer.update(state,deltaTime)
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
