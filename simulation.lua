local simulation = {}

simulation.create = function()
  return
  {
    mice =
    {
      {
        x = 100,
        y = 100,
      }
    },
  }
end

simulation.update = function(state)

  for _, mouse in pairs(state.mice) do
    mouse.x = mouse.x + 1
  end

end

return simulation