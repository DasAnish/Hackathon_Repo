local alex = {}

function alex.setup()
  alex.assets = {}
  alex.assets.player = love.graphics.newImage('assets/Alien sprites/alienBeige_stand.png')
  alex.assets.jump = love.graphics.newImage('assets/Alien sprites/alienBeige_jump.png')
  alex.assets.crouch = love.graphics.newImage('assets/Alien sprites/alienBeige_duck.png')
  alex.assets.fontSmall = love.graphics.newFont('assets/earwig-factory/earwig factory rg.ttf', 32)
  alex.assets.fontBig = love.graphics.newFont('assets/earwig-factory/earwig factory rg.ttf', 64)
  alex.assets.bullet = love.graphics.newImage('assets/bullet_game_assets/bullet1.png')
  alex.assets.floor = love.graphics.newImage('assets/floor.png')
  alex.assets.fire = love.graphics.newImage('assets/Fiyah.png')
  alex.player = {}
 alex.player.image = alex.assets.player
 alex.player.velocity = 0
 alex.player.w = 50
 alex.player.h = 90
 alex.player.x = 200
 alex.player.y = 400
  alex.rate = 0.01
  alex.obstacles = {}
  alex.timer = 0
  alex.score = 0
  alex.gameOver = false
  alex.won = false
  alex.width, alex.height, alex.flags = love.window.getMode( )

end

function alex.collide(x1, y1, w1, h1, x2, y2, w2, h2)
  return not (x1 + w1 <= x2 or x2 + w2 <= x1 or y1 + h1 <= y2 or y2 + h2 <= y1)
end

function alex.touching(x1, y1, w1, h1, x2, y2, w2, h2)
  return (y1 + h1 == y2 and x1 + w1 >= x2)
end


function alex.on_focused(dt)
  if not alex.gameOver then
    if collide(alex.player.x, alex.player.y, alex.player.w, alex.player.h, 100,495,alex.width,alex.height) then
      alex.player.y = alex.player.y - 7
      alex.player.velocity = 0
    elseif touching(alex.player.x,alex.player.y,alex.player.w,alex.player.h, 100,495,alex.width, alex.height) then
     alex.player.velocity = 0
    else
     alex.player.y =alex.player.y +alex.player.velocity
     alex.player.velocity =alex.player.velocity + 1
    end
    if touching(alex.player.x,alex.player.y,alex.player.w,alex.player.h, 100,495,alex.width, alex.height)  then
      if love.keyboard.isDown('space') then
       alex.player.image = alex.assets.jump
       alex.player.velocity = -10
       alex.player.y =alex.player.y +alex.player.velocity
      elseif love.keyboard.isDown('lctrl') then
       alex.player.image = alex.assets.crouch
       alex.player.h = 70
      else
       alex.player.image = alex.assets.player
       alex.player.h = 90
      end
    end
    if alex.timer > 0 then
      alex.timer = alex.timer - 1
    end
    if alex.rate < 1 then
      alex.rate = alex.rate + 0.01/600
    end
    if math.random() < alex.rate and alex.timer == 0 then
      local obstacle = {}
      obstacle.x = alex.width
      obstacle.image = alex.assets.bullet
      if math.random() < 0.5 then
        obstacle.y = 410
      else
        obstacle.y = 485
      end
      obstacle.velocity = 10
      table.insert(alex.obstacles, obstacle)
      alex.timer = 15
    end
    for i = #alex.obstacles, 1, -1 do
      alex.obstacles[i].x = alex.obstacles[i].x - alex.obstacles[i].velocity
      if collide(alex.player.x,alex.player.y,alex.player.w,alex.player.h, alex.obstacles[i].x, alex.obstacles[i].y, 20, 5) then
       alex.player.x = alex.obstacles[i].x -alex.player.w
      end
      if alex.obstacles[i].x + 20 < 0 then
        table.remove(alex.obstacles, i)
        alex.score = alex.score + 1
      end
    end
    ifalex.player.y > alex.height then
      alex.gameOver = true
    end
  elseif love.keyboard.isDown('rctrl') then
   alex.player.velocity = 0
   alex.player.w = 50
   alex.player.h = 90
   alex.player.x = 200
   alex.player.y = 400
    alex.rate = 0.01
    alex.obstacles = {}
    alex.timer = 0
    alex.score = 0
    alex.gameOver = false
    alex.won = false
  end
end

function alex.render()
  love.graphics.setBackgroundColor(1, 0, 0)
  love.graphics.draw(alex.assets.floor, 100, 495, 0, 5, 1)
  love.graphics.draw(alex.assets.fire, 0, alex.height - 70, 0, 0.55)
  love.graphics.draw(alex.player.image,alex.player.x,alex.player.y)
  love.graphics.setFont(alex.assets.fontSmall)
  love.graphics.print('Alex\'s\nAmazing\nGame', alex.width * 3/4, 10, math.pi * 1/6)
  for i = 1, #alex.obstacles, 1 do
    love.graphics.draw(alex.obstacles[i].image, alex.obstacles[i].x, alex.obstacles[i].y, 0, 0.05)
  end
  if alex.gameOver then
    love.graphics.setFont(alex.assets.fontBig)
    love.graphics.print('alex.score: '..alex.score, alex.width / 8, alex.height / 6)
    if alex.score >= 25 then
      love.graphics.print('YOU WIN', alex.width / 8, alex.height / 6 + 50)
      alex.won = true
    else
      love.graphics.print('YOU LOSE', alex.width / 8, alex.height / 6 + 50)
    end
    love.graphics.print('rctrl to play again!', alex.width / 8, alex.height / 6 + 100)
  else
    love.graphics.print('alex.score: '..alex.score, 10, 10)
  end
end
