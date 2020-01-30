local simulation = require("simulation")
local renderer = require("renderer")
local vector = require('vector')

--TODO: score feedback graphics
--TODO: lives/fuckups graphics

--BLOAT: background tiles
--BLOAT: random occasional mouse movement without player interaction
--BLOAT: placeable trapdoors
--BLOAT: Alapati facts

local music
local elevator_music


local state
local last_state
local alapati = -600

function love.load()
  math.randomseed(1)
  renderer.on_load()

  music = love.audio.newSource("SFX/Daler Mehndi - Tunak Tunak Tun Video.mp3", "static")
  music:setLooping(true)
  elevator_music = love.audio.newSource("SFX/Elevator-music.mp3", "static")
  elevator_music:setLooping(true)

  elevator_music:play()

  --math.randomseed(os.time()) UNCOMMENT ME IN FINAL VER

  --state = simulation.create()
  --simulation.add_mice_to_pool(state,50,'healthy')
  --simulation.add_mice_to_pool(state,50,'zombie')
  --simulation.add_mice_to_pool(state,50,'albino')
  --simulation.shuffle_pool(state)
end

function love.draw()
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.clear()

  if not state then
    renderer.render_before_game(last_state, alapati)
    return
  end
  renderer.render_state(state)
end

function love.resize()
end

function love.keypressed(key)
  --for _, door in pairs(state.trapdoors) do
  --  if door.key == key then
  --    door.open = true
  --    door.direction = 1
  --    door.animation:resume()
  --  end
  --end

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
  --for _, door in pairs(state.trapdoors) do
  --  if door.key == key then
  --    door.open = false
  --    door.direction = -1
  --    door.animation:resume()
  --  end
  --end

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
  if not state then
    state = simulation.create()
    music:play()
    elevator_music:stop()
  end

  if state.push_pull == 0 and button == 1 then
    state.push_pull = 2
  elseif state.push_pull == 0 and button == 2 then
    state.push_pull = 1
  end
end

function love.mousereleased(x,y,button)
  if not state then
    return
  end

  if state.push_pull == 2 and button == 1 then
    state.push_pull = 0
  elseif state.push_pull == 1 and button == 2 then
    state.push_pull = 0
  end
end

function love.quit()

end


local accumulatedDeltaTime = 0
function love.update(deltaTime)
  if not state then
    alapati = math.min(alapati + 4, -100)
    return
  end

  renderer.update(state,deltaTime)
  accumulatedDeltaTime = accumulatedDeltaTime + deltaTime
  local tickTime = 1/60

  while accumulatedDeltaTime > tickTime do
      simulation.update(state)
      accumulatedDeltaTime = accumulatedDeltaTime - tickTime
  end


  if state.lives == 0 then
    last_state = state
    state = nil
    music:stop()
    elevator_music:play()
    alapati = -600
  end
end
