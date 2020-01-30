local misc_math = require("misc_math")
local vector = require("vector")
local collisions = require("collisions")

local set_difficulty = function(state)
  if state.difficulty == 0 then
    constants.max_wave = 1
    constants.mouse_x_speed = 2
    constants.mouse_y_speed = 3
    constants.mouse_drag = 1
    constants.max_push_distance = 250
    constants.spawn_delay = 100
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 1 and state.score > 10 then
    constants.max_wave = 1
    constants.mouse_x_speed = 1
    constants.mouse_y_speed = 0.5
    constants.spawn_delay = 100
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 2 and state.score > 20 then
    constants.max_wave = 1
    constants.mouse_x_speed = 3
    constants.mouse_y_speed = 1
    constants.spawn_delay = 80
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 3 and state.score > 30 then
    constants.max_wave = 2
    constants.mouse_x_speed = 3
    constants.mouse_y_speed = 2
    constants.spawn_delay = 220
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 4 and state.score > 40 then
    constants.max_wave = 2
    constants.mouse_x_speed = 3
    constants.spawn_delay = 200
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 5 and state.score > 50 then
    constants.max_wave = 1
    constants.mouse_x_speed = 4
    constants.spawn_delay = 40
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 6 and state.score > 70 then
    constants.max_wave = 1
    constants.mouse_x_speed = 4
    constants.mouse_y_speed = 1
    constants.spawn_delay = 80
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 7 and state.score > 90 then
    constants.max_wave = 2
    constants.mouse_x_speed = 2
    constants.spawn_delay = 200
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 8 and state.score > 110 then
    constants.max_wave = 1
    constants.mouse_x_speed = 3
    constants.mouse_y_speed = 2
    constants.spawn_delay = 60
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 9 and state.score > 150 then
    constants.max_wave = 2
    constants.mouse_x_speed = 3
    constants.spawn_delay = 200
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty == 10 and state.score > 200 then
    constants.max_wave = 2
    constants.mouse_x_speed = 5
    constants.spawn_delay = 150
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  elseif state.difficulty > 10 and state.difficulty*20 < state.score then
    constants.spawn_delay = constants.spawn_delay * 0.9
    constants.mouse_x_speed = constants.mouse_x_speed * 1.1
    state.difficulty = state.difficulty + 1
    state.lives = state.lives + 1
  end


end

local function shuffle(t)
    local rand = math.random
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

local activate_mouse = function(state, collider, x,y)
  --local next_mouse = table.remove(state.mice_pool,1)


  local infections = {"healthy", "zombie", "albino"}
  local next_mouse = {infection = infections[math.random(1, 3)]}

  local new_mouse
  for i=1,100 do
    new_mouse =
    {
      pos = vector.new(x, y + math.random(0, 100)),
      infection = next_mouse.infection,
      active = true,
      to_pool = false,
      animation = nil,
      heart = false,
    }
    if collisions.try_add_mouse(collider, new_mouse) then
      table.insert(state.mice, new_mouse)
      return
    end
  end

  ---- we failed, just put it back
  --table.insert(state.mice_pool, 1, next_mouse)
end

local check_spawn_mouse = function(state)
  --if #state.mice_pool > 0 and state.last_spawn_update + constants.spawn_delay < state.ticks_played  then
  if state.last_spawn_update + constants.spawn_delay < state.ticks_played  then
    local spacing = math.random(1,4) * 60
    local group_size = math.random(1,constants.max_wave)
    local starting_y = math.random(constants.clip_top,constants.screen_h-constants.clip_bottom-(spacing*group_size))

    local collider = collisions.create_empty()
    for _, mouse in pairs(state.mice) do
      assert(collisions.try_add_mouse(collider, mouse))
    end

    for k = 1, group_size do
      activate_mouse(state, collider, math.random(-100,-30),starting_y + k*spacing)
    end
    state.last_spawn_update = state.ticks_played
  end
end

local simulation = {}

simulation.shuffle_pool = function(state)
  shuffle(state.mice_pool)
end

simulation.add_mice_to_pool = function (state,quantity,type)
  for k = 1, quantity do
    table.insert(state.mice_pool, {
      infection = type
    })
  end
  state.infected_remaining = state.infected_remaining + quantity
end

simulation.create = function()
  local state =
  {
    ticks_played = 0,
    last_spawn_update = 0,
    mice_pool = {},

    mice = {},

    trapdoors =
    {
      {
        target = 'zombie',
        pos = vector.new(constants.screen_w - constants.trapdoor_width - 100, constants.clip_top + constants.trapdoor_height/2 + 50),
        direction = -1,
        open = false,
        key = 'lshift',
        last_update = 0,
      },
      {
        pos = vector.new(constants.screen_w - constants.trapdoor_width - 100, constants.screen_h - constants.clip_bottom - constants.trapdoor_height/2 - 50),
        target = 'albino',
        direction = -1,
        open = false,
        key = 'lctrl',
        last_update = 0,
      },
    },
    push_pull = 0,

    lives = constants.max_lives,
    infected_remaining = 0,
    blood_alpha = 0,
    score = 0,
    difficulty = 0,
  }

  return state
end

simulation.update = function(state)
  set_difficulty(state)
  state.blood_alpha = math.max(state.blood_alpha - 0.05, 0)

  local collider = collisions.create_empty()
  collisions.add_all_mice(collider, state)

  for _, door in pairs(state.trapdoors) do
    if state.ticks_played > door.last_update + 100 then
      door.open = true
      door.direction = 1
      door.animation:resume()
      door.last_update = state.ticks_played
    end
  end

  for mouse_index, mouse in pairs(state.mice) do
    mouse.heart = false
    local new_mouse_pos = vector.new(mouse.pos.x + constants.mouse_x_speed, mouse.pos.y)

    local target_y_position = love.mouse.getY()
    local distance = (mouse.pos - vector.new(love.mouse.getX(), target_y_position)):len()
    local y_distance = math.abs(mouse.pos.y - target_y_position)

    if distance > constants.max_push_distance then
      distance = 0
    else
      distance = constants.max_push_distance - distance
    end

    local push_pull_offset = 0.3 * math.sqrt(distance)

    if y_distance < 10 then
      push_pull_offset = 0
    end

    if mouse.pos.y > target_y_position then
      push_pull_offset = push_pull_offset * -1
    end

    if state.push_pull == 1 then
      -- push away
      push_pull_offset = push_pull_offset * -1
    end

    local try_place_positions =
    {
      new_mouse_pos,
      mouse.pos,
    }


    if state.push_pull == 2 and distance > 0 and mouse.pos.x < love.mouse.getX() then
      table.insert(try_place_positions, 1, vector.new(new_mouse_pos.x, mouse.pos.y + push_pull_offset * constants.mouse_y_speed))
      mouse.heart = true
    end

    -- don't collide with self
    collider:remove(mouse.collider_tmp)

    for _, newpos in pairs(try_place_positions) do
      mouse.pos = newpos
      if collisions.try_add_mouse(collider, mouse) then
        break
      end
    end

    if mouse.pos.x >= constants.screen_w then
      mouse.active = false
      --mouse.to_pool = true

      if mouse.infection ~= "healthy" then
        state.lives = math.max(state.lives - 1, 0)
        state.blood_alpha = 1
      else
        state.score = state.score + 1
        state.infected_remaining = state.infected_remaining - 1
        set_difficulty(state)
      end
    end


    for _, trapdoor in pairs(state.trapdoors) do
      if misc_math.point_in_box(
        mouse.pos,
        trapdoor.pos - vector.new(constants.trapdoor_width/2, constants.trapdoor_height/2),
        constants.trapdoor_width,
        constants.trapdoor_height)
      then
        trapdoor.open = false
        trapdoor.direction = -1
        trapdoor.animation:resume()
        trapdoor.last_update = state.ticks_played

        if trapdoor.target ~= mouse.infection then
          state.lives = math.max(state.lives - 1, 0)
          state.blood_alpha = 1
        else
          state.score = state.score + 1
        end
        mouse.active = false
      end
    end
  end

  for mouse_index, mouse in pairs(state.mice) do
    --if mouse.to_pool then
    --  table.insert(state.mice_pool,{infection=mouse.infection})
    --end
    if mouse.active == false then
      table.remove(state.mice,mouse_index)
    end
  end

  check_spawn_mouse(state)
  state.ticks_played = state.ticks_played + 1
end

return simulation