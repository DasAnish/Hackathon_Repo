local testgame = require("asteroids")
local screensize={512,384}
function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setMode(unpack(screensize))
  testgame.setup(screensize)
  frame1=love.graphics.newImage("frame1.png")
  frame2=love.graphics.newImage("frame2.png")
end

function love.update(dt)
  testgame.on_focused(dt)
end

function love.draw()
  testgame.render({0,0},screensize)
  love.graphics.draw(frame1,0,0,0,4,4)
end
