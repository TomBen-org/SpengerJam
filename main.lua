function love.load()
  global.units = {
    {button='a',type='press'},
    {button='b',type='press'},
    {button='c',type='press'},
    {button='d',type='press'}
  }
end

function love.draw()
end

function love.resize()
end

function love.keypressed(key)
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
    --simulation.update(state)
    accumulatedDeltaTime = accumulatedDeltaTime - tickTime
  end

end
