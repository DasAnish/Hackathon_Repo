
local testgame = require("timer")
-- local testgame2 = require("asteroids")
local screensize={640,480}
local games={testgame}
local cgame=1
ROW_LENGTH=3
function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setMode(screensize[1]*#games,screensize[2])
  for i,g in ipairs(games) do
    g.setup(screensize)
  end
  frame1=love.graphics.newImage("frame1.png")
  frame2=love.graphics.newImage("frame2.png")
  frame3=love.graphics.newImage("frame3.png")
  frames={frame1,frame2,frame3}
end

function love.update(dt)
  if love.mouse.isDown(1) then
    mx,my=love.mouse.getPosition()
    local n=math.floor(mx/screensize[1])%ROW_LENGTH+math.floor(my/screensize[2])*ROW_LENGTH+1
    if 0<n and n<=#games then
      cgame=n
    end
  end
  games[cgame].on_focused(dt)
end

function love.draw()
  for i,g in ipairs(games) do
    g.render({(i-1)*screensize[1],0},screensize)
    local f=1
    if i==cgame then
      f=f+1
    end
    love.graphics.draw(frames[f],(i-1)*screensize[1],0,0,5,5)
  end
end
