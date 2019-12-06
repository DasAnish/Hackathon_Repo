local game={}
game.timeLeft = 1000
game.display = {}
game.lifeCount = 0
local prevTime = 0
function game.setup(size)
  --setup stuff
  -- game.timeLeft = size
  game.size = size
  font = love.graphics.newFont("assets/Amagro-bold.ttf")
  love.graphics.setFont(font)
  game.image = love.graphics.newImage("assets/cross.png")
  -- game.life = love.graphics.newImage("assets/life.png")
end
function game.render(offset)
  --draw the module
  st = "" .. game.minutesLeft .. " : " 
  if (game.secondsLeft < 10) then 
    st = st .. 0 .. "" .. game.secondsLeft
  else 
    st = st .. game.secondsLeft
  end
  love.graphics.print (st, game.size[1] / 2 - 100, game.size[2] /2 - 150, 0, 5)
  for i=1,game.lifeCount do
    love.graphics.draw(game.image, game.size[1]/2 - 350 + 150*i, game.size[2]/2)
  end
  
end
function game.on_focused(dt)
  --update when module focused
  love.timer.sleep(0.1)
  game.timeLeft = game.timeLeft - 1
  game.secondsLeft = game.timeLeft % 60
  game.minutesLeft = (game.timeLeft - game.secondsLeft) / 60

end
return game
