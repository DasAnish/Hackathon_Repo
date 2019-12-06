
<<<<<<< HEAD
local testgame = require("flappy")
local testgame2 = require("asteroids")
local testgame3 = require("snakegame")
local screensize={640,480}
local games={testgame,testgame3,testgame2}
=======
local testgame = require("timer")
-- local testgame2 = require("asteroids")
local screensize={640,480}
local games={testgame}
>>>>>>> 7e9004813b9a21a36508a3a80aa73e005cb12ff8
local cgame=1
ROW_LENGTH=2
function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.window.setMode(screensize[1]*ROW_LENGTH,screensize[2]*math.ceil(#games/ROW_LENGTH))
  for i,g in ipairs(games) do
    g.setup(screensize)
  end
  frame1=love.graphics.newImage("frame1.png")
  frame2=love.graphics.newImage("frame2.png")
  frame3=love.graphics.newImage("frame3.png")
  frames={frame1,frame2,frame3}
  music=love.audio.newSource("tension.mp3","stream")
  music:play()
end

function love.update(dt)
  if love.mouse.isDown(1) then
    mx,my=love.mouse.getPosition()
    local n=math.floor(mx/screensize[1])%ROW_LENGTH+math.floor(my/screensize[2])*ROW_LENGTH+1
    if 0<n and n<=#games and not games[n].done then
      cgame=n
    end
  end
  if games[cgame].done then
    local n=cgame
    while true do
      n=n%#games+1
      if not games[n].done then
        cgame=n
        break
      elseif n~=cgame-1 or (cgame==1 and n==#games) then
        love.event.quit()
        break
      end
    end
  end

  games[cgame].on_focused(dt)
end

function love.draw()
  for i,g in ipairs(games) do
    g.render({(i-1)%ROW_LENGTH*screensize[1],screensize[2]*math.floor((i-1)/ROW_LENGTH)},screensize)
    local f=1
    if i==cgame then
      f=2
    end
    if g.done then
      f=3
    end
    love.graphics.draw(frames[f],(i-1)%ROW_LENGTH*screensize[1],screensize[2]*math.floor((i-1)/ROW_LENGTH),0,5,5)
  end
end
