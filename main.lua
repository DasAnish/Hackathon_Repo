local testgame = require("asteroids")
function love.load()
  local w,h,f=love.window.getMode()
  testgame.setup({w,h})
end

function love.update(dt)
  testgame.on_focused(dt)
end

function love.draw()
  testgame.render({0,0},{1000,1000})
end
