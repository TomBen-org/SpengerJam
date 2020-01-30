local renderer = {}

renderer.render_state = function(state)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.clear()

  for _, trapdoor in pairs(state.trapdoors) do
    love.graphics.setColor(0, 1, 0)

    local mode = "fill"
    if state.trapdoors_open then
      mode = "line"
    end

    love.graphics.rectangle(mode,
      trapdoor.pos.x - constants.trapdoor_width/2,
      trapdoor.pos.y - constants.trapdoor_height/2,
      constants.trapdoor_width,
      constants.trapdoor_height)
  end

  for _, mouse in pairs(state.mice) do
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", mouse.pos.x, mouse.pos.y, constants.mouse_radius)
  end

  love.graphics.print("mice in pool: "..#state.mice_pool,0,15)
end

return renderer