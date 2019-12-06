
local testgame = require("snakegame")
local screensize={640,480}
local games={testgame}
function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setMode(screensize[1]*#games,screensize[2])
  testgame.setup(screensize)
  frame1=love.graphics.newImage("frame1.png")
  frame2=love.graphics.newImage("frame2.png")
  frame3=love.graphics.newImage("frame3.png")
end

function love.update(dt)
  testgame.on_focused(dt)
end

function love.draw()
  for i,g in ipairs(games) do
    g.render({(i-1)*screensize[1],0},screensize)
    love.graphics.draw(frame1,(i-1)*screensize[1],0,0,5,5)
  end
end
