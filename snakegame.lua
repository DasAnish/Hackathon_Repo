 -- remember to make a load and and update and stuff
local game={}
game.done=false
game.strike=false
local spf=0.06
local game_font=nil
local frame_time=0
 function game.setup(size)

	math.randomseed(os.time())

	backgroundImage = love.graphics.newImage("assets/background.jpg")
	appleImage = love.graphics.newImage("assets/apple1.png")
	game_font = love.graphics.newFont("assets/Amagro-bold.ttf", 60)
  if size then
  	display_size = {}
  	display_size.x = size[1]
  	display_size.y = size[2]
  end

	apple = {}
	-- set apple.x and apple.y but need the random thing for it
	apple.x = math.random(50, display_size.x - 50)
	apple.y = math.random(50, display_size.y - 50)
	apple.size = appleImage:getHeight();

	head = {}
	head.x = display_size.x / 2
	head.y = display_size.y / 2
  target=10
	dir = 0 -- 0L 1D 2R 3U

	step = 15 -- the number of pixels the box moves by


	body = {}

	gameExit = false


 end

function game.on_focused(dt)
	if (not gameExit) then
		Snake_update(dt)
	end

	if (gameExit and love.keyboard.isDown("lctrl")) then
    game.setup()
	end
end


function Snake_update(dt)
  frame_time=frame_time+dt
  while frame_time>spf do
    frame_time=frame_time-spf
  	love.timer.sleep(1/30)

  	if love.keyboard.isDown("a") then
  		dir = 0
  	elseif love.keyboard.isDown("d") then
  		dir = 2
  	elseif love.keyboard.isDown("w") then
  		dir = 3
  	elseif love.keyboard.isDown("s") then
  		dir = 1
  	end

  	local temp = {}
  	temp.x = head.x
  	temp.y = head.y
  	table.insert(body, temp) -- adding the head pos to the body before updating head

  	if (dir == 2) then -- left
  		head.x = head.x + step
  	elseif (dir == 1) then -- down
  		head.y = head.y + step
  	elseif (dir == 0) then -- right
  		head.x = head.x - step
  	else -- up
  		head.y = head.y - step
  	end

  	head.y = head.y % display_size.y
  	head.x = head.x % display_size.x

    if not gameExit and collionSelf() then
      gameExit=true
      game.strike=true
    end

  	-- now need to update the body and remove the latest value
  	if (not eatingFood()) then
  		table.remove(body, 1)
  	else
  		-- assign a new position for the food
  		apple.x = math.random(50, display_size.x - 50)
  		apple.y = math.random(50, display_size.y - 50)
      game.done=#body==target
  	end
  end

 end

function game.render(offset)
  ox,oy=unpack(offset)
	-- love.graphics.setColor(0,0,1)
	-- drawBackground()
	love.graphics.setBackgroundColor(0, 0, 0)
	-- cleared the screen

	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle('fill', head.x+ox, head.y+oy, step, step) -- put the head on screen
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('line', head.x+ox, head.y+oy, step, step)

	-- st = ""

	for i = 1, #body do -- putting all the bodies onto the screen
		local part = body[i]
		-- love.graphics.print(" " .. i .. " " .. #body)
		love.graphics.setColor(0, 1, 0)
		love.graphics.rectangle('fill', part.x+ox, part.y+oy, step, step)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle('line', part.x+ox, part.y+oy, step, step)
		-- st = st .. part.x .. " " .. part.y .. " "
	end
	-- love.graphics.print(st)

	love.graphics.setColor(1, 1, 1)
	-- love.graphics.rectangle('fill', apple.x, apple.y, apple.size, apple.size)
	love.graphics.draw(appleImage, apple.x+ox, apple.y+oy)
  love.graphics.setFont(game_font)
	love.graphics.print("Score: " .. #body .. "/"..target, 20+ox, 20+oy, 0, 0.4)

	if (gameExit) then
		love.graphics.print("Game Over", display_size.x / 2 - 200+ox, display_size.y / 2-30+oy, 0, 1)
		love.graphics.print("Press lctrl to restart", display_size.x / 2 - 200+ox, display_size.y / 2 + 100+oy, 0, 0.6)
	end
 end

 function drawBackground()

	for i = 0, love.graphics.getHeight() / backgroundImage:getHeight() do
		for j = 0, love.graphics.getWidth() / backgroundImage:getWidth() do
			love.graphics.draw(backgroundImage, i*backgroundImage:getHeight(), j*backgroundImage:getWidth())
		end
	end

 end

 -- function to check for collision
 function collionSelf()

	for i = 1, #body, 1 do
		local part = body[i]
		if (head.x == part.x and head.y == part.y) then
			return true
		end
	end
	return false
 end

 function eatingFood()

	return (head.x > apple.x and head.x < apple.x + apple.size or
		head.x + step > apple.x and head.x + step < apple.x + apple.size) and
		(head.y > apple.y and head.y < apple.y + apple.size or
		head.y + step > apple.y and head.y + step < apple.y + apple.size)

 end
return game
