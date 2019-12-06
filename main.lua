local flappyBird = require('flappyBird')
local alex = require('alex')
function love.load()
  alex.setup()
  flappyBird.setup()
  game = ''
end

function love.update(dt)
  if game == 'alex' then
    alex.update(dt)
  elseif game == 'flappyBird' then
    flappyBird.update(dt)
  end
  if love.keyboard.isDown('escape') then
    game = ''
    alex.setup()
    flappyBird.setup()
  end
end

function love.draw()
  if game == '' then
    love.graphics.setBackgroundColor(1,0,1)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.print('Press 1 or 2 for a game')
    if love.keyboard.isDown('1') then
      game = 'alex'
    elseif love.keyboard.isDown('2') then
      game = 'flappyBird'
    end
  elseif game == 'alex' then
    alex.render()
  elseif game == 'flappyBird' then
      flappyBird.render()
  end
end
