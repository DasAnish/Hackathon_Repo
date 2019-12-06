local game={}
game.timeLeft = 1000
game.display = {}
game.lifeCount = 0
local prevTime = 0
local font=nil
local tmult={1,2,3,3}
function game.setup(size)
  --setup stuff
  -- game.timeLeft = size
  game.size = size
  font = love.graphics.newFont("assets/DS-DIGI.ttf",120)
  game.image = love.graphics.newImage("assets/cross.png")
  -- game.life = love.graphics.newImage("assets/life.png")
end
function game.render(offset)
  ox,oy=unpack(offset)
  --draw the module
  local t=math.ceil(game.timeLeft)
  st = "" .. (t - t % 60) / 60 .. " : "
  if (t % 60 < 10) then
    st = st .. 0 .. "" .. t % 60
  else
    st = st .. t % 60
  end
  love.graphics.setFont(font)
  love.graphics.setColor(1,0,0)
  love.graphics.print(st, game.size[1] / 2 - 150+ox, game.size[2] /2 - 150+oy, 0, 1)
  love.graphics.setColor(1,1,1)
  for i=1,game.lifeCount do
    love.graphics.draw(game.image, game.size[1]/2 - 300 + 150*i+ox, game.size[2]/2+oy)
  end

end
function game.update(dt)
  --update when module focused
  game.timeLeft = game.timeLeft - dt*tmult[game.lifeCount+1]

end
function game.on_focused(dt)
end
return game
