local flappyBird = {}
function flappyBird.setup()
  flappyBird.assets = {}
  flappyBird.assets.bird1 = love.graphics.newImage('assets/flappy-bird-white-blue/skeleton-01_fly_00.png')
  flappyBird.assets.bird2 = love.graphics.newImage('assets/flappy-bird-white-blue/skeleton-01_fly_04.png')
  flappyBird.assets.bird3 = love.graphics.newImage('assets/flappy-bird-white-blue/skeleton-01_fly_08.png')
  flappyBird.assets.bird4 = love.graphics.newImage('assets/flappy-bird-white-blue/skeleton-01_fly_12.png')
  flappyBird.assets.fontSmall = love.graphics.newFont('assets/earwig-factory/earwig factory rg.ttf', 32)
  flappyBird.assets.fontBig = love.graphics.newFont('assets/earwig-factory/earwig factory rg.ttf', 64)
  flappyBird.player = {}
  flappyBird.player.image = flappyBird.assets.bird1
  flappyBird.player.x = 100
  flappyBird.player.y = 300
  flappyBird.player.w = 30
  flappyBird.player.h = 30
  flappyBird.player.velocity = 0
  flappyBird.timer = 0
  flappyBird.obstacles = {}
  flappyBird.score = 0
  flappyBird.gameOver = false
  flappyBird.jump = false
  flappyBird.gap = 170
  flappyBird.width, flappyBird.height, flappyBird.flags = love.window.getMode()
end

function collide(x1, y1, w1, h1, x2, y2, w2, h2)
  return not (x1 + w1 <= x2 or x2 + w2 <= x1 or y1 + h1 <= y2 or y2 + h2 <= y1)
end

function flappyBird.update(dt)
  if not flappyBird.gameOver then
    flappyBird.player.y = flappyBird.player.y + flappyBird.player.velocity
    flappyBird.player.velocity = flappyBird.player.velocity + 0.5
    if flappyBird.player.y >= flappyBird.height - (flappyBird.player.h + 20) then
      flappyBird.player.y = flappyBird.height - (flappyBird.player.h + 20)
      flappyBird.player.velocity = 0
    elseif flappyBird.player.y <= 0 then
      flappyBird.player.y = 1
      flappyBird.player.velocity = 0
    end
    flappyBird.jump = false
    if love.keyboard.isDown('space') then
      flappyBird.player.velocity = -8
      flappyBird.jump = true
    end
    if flappyBird.timer == 0 then
      local obstacle = {}
      obstacle.x = flappyBird.width
      obstacle.y = math.random(0, flappyBird.height - flappyBird.gap)
      obstacle.w = 10
      obstacle.velocity = 5
      obstacle.red = math.random()
      obstacle.green = math.random()
      obstacle.blue = math.random()
      table.insert(flappyBird.obstacles, obstacle)
      flappyBird.timer = 100
    end
    for i = #flappyBird.obstacles, 1, -1 do
      flappyBird.obstacles[i].x = flappyBird.obstacles[i].x - flappyBird.obstacles[i].velocity
      if flappyBird.obstacles[i].x + 10 < 0 then
        table.remove(flappyBird.obstacles, i)
        flappyBird.score = flappyBird.score + 1
      end
      if collide(flappyBird.player.x + 20, flappyBird.player.y + 10, flappyBird.player.w, flappyBird.player.h, flappyBird.obstacles[i].x, 0, flappyBird.obstacles[i].w, flappyBird.obstacles[i].y) or
        collide(flappyBird.player.x + 20, flappyBird.player.y + 10, flappyBird.player.w, flappyBird.player.h, flappyBird.obstacles[i].x, flappyBird.obstacles[i].y + flappyBird.gap, flappyBird.obstacles[i].w, flappyBird.height) then
          flappyBird.gameOver = true
      end
    end
    flappyBird.timer = flappyBird.timer - 1
  elseif love.keyboard.isDown('lctrl') then
    flappyBird.player.x = 100
    flappyBird.player.y = 300
    flappyBird.player.w = 30
    flappyBird.player.h = 30
    flappyBird.player.velocity = 0
    flappyBird.timer = 0
    flappyBird.obstacles = {}
    flappyBird.score = 0
    flappyBird.gameOver = false
    flappyBird.jump = false
  end
end

function flappyBird.render()
  love.graphics.setBackgroundColor(0, 0, 1)
  if flappyBird.jump then
    love.graphics.draw(flappyBird.assets.bird1, flappyBird.player.x, flappyBird.player.y, 0, 0.1)
    love.graphics.draw(flappyBird.assets.bird2, flappyBird.player.x, flappyBird.player.y, 0, 0.1)
    love.graphics.draw(flappyBird.assets.bird3, flappyBird.player.x, flappyBird.player.y, 0, 0.1)
    love.graphics.draw(flappyBird.assets.bird4, flappyBird.player.x, flappyBird.player.y, 0, 0.1)
  else
    love.graphics.draw(flappyBird.player.image, flappyBird.player.x, flappyBird.player.y, 0, 0.1)
  end
  for i = 1, #flappyBird.obstacles, 1 do
    love.graphics.setColor(flappyBird.obstacles[i].red, flappyBird.obstacles[i].green, flappyBird.obstacles[i].blue)
    love.graphics.rectangle('fill', flappyBird.obstacles[i].x, 0, 10, flappyBird.obstacles[i].y)
    love.graphics.rectangle('fill', flappyBird.obstacles[i].x, flappyBird.obstacles[i].y + flappyBird.gap, flappyBird.obstacles[i].w, flappyBird.height)
  end
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(flappyBird.assets.fontSmall)
  if not flappyBird.gameOver then
    love.graphics.print('flappyBird.score: '..flappyBird.score, 10, 10)
  else
    love.graphics.setFont(flappyBird.assets.fontBig)
    love.graphics.print('flappyBird.score:'..flappyBird.score, flappyBird.width / 8, flappyBird.height / 6)
    if flappyBird.score >= 10 then
      love.graphics.print('YOU WIN', flappyBird.width / 8, flappyBird.height / 6 + 50)
    else
      love.graphics.print('YOU LOSE', flappyBird.width / 8, flappyBird.height / 6 + 50)
    end
    love.graphics.print('lctrl to play again', flappyBird.width / 8, flappyBird.height / 6 + 100)
  end
end
return flappyBird
