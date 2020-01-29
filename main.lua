local simulation = require("simulation")
local renderer = require("renderer")


local state
function love.load()
  state = simulation.create()
  --global.units = {
  --  {button='a',type='press'},
  --  {button='b',type='press'},
  --  {button='c',type='press'},
  --  {button='d',type='press'}
  --}
end

function love.draw()
  renderer.render_state(state)
end

function love.resize()
end

local pressed = {}

function love.keypressed(key)
    pressed[key] = 1
end

function love.keyreleased(key)
    pressed[key] = nil
end

function love.mousemoved(x,y)
end

function love.wheelmoved(x,y)
end

function love.mousepressed(x,y,button)

end

function love.quit()

end

local accumulatedDeltaTime = 0
function love.update(deltaTime)
  accumulatedDeltaTime = accumulatedDeltaTime + deltaTime

  local tickTime = 1/60

  while accumulatedDeltaTime > tickTime do
      simulation.update(state)
      accumulatedDeltaTime = accumulatedDeltaTime - tickTime
  end

end
