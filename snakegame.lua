 -- remember to make a load and and update and stuff
local game={}
 function game.setup(size)

	math.randomseed(os.time())

	backgroundImage = love.graphics.newImage("assets/background.jpg")
	appleImage = love.graphics.newImage("assets/apple1.png")
	font = love.graphics.newFont("assets/Amagro-bold.ttf", 12)
	love.graphics.setFont(font)

	display_size = {}
	display_size.x = size[1]
	display_size.y = size[2]

	apple = {}
	-- set apple.x and apple.y but need the random thing for it
	apple.x = math.random(50, display_size.x - 50)
	apple.y = math.random(50, display_size.y - 50)
	apple.size = appleImage:getHeight();

	head = {}
	head.x = display_size.x / 2
	head.y = display_size.y / 2

	dir = 0 -- 0L 1D 2R 3U

	step = 15 -- the number of pixels the box moves by


	body = {}

	gameExit = false


 end

 function Snake_Update(dt)
	if (not gameExit) then
		Snake_update(dt)
	end

	if (love.keyboard.isDown("p")) then
		Snake_load()
	end
end


function game.on_focused(dt)
	love.timer.sleep(1/30)

	if love.keyboard.isDown("left") then
		dir = 0
	elseif love.keyboard.isDown("right") then
		dir = 2
	elseif love.keyboard.isDown("up") then
		dir = 3
	elseif love.keyboard.isDown("down") then
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

	gameExit = gameExit or collionSelf()

	-- now need to update the body and remove the latest value
	if (not eatingFood()) then
		table.remove(body, 1)
	else
		-- assign a new position for the food
		apple.x = math.random(50, display_size.x - 50)
		apple.y = math.random(50, display_size.y - 50)
		love.graphics.print("ate food")
	end

 end

function game.render(offset)
	-- love.graphics.setColor(0,0,1)
	-- drawBackground()
	love.graphics.setBackgroundColor(0, 0, 0)
	-- cleared the screen

	love.graphics.setColor(0, 1, 0)
	love.graphics.rectangle('fill', head.x, head.y, step, step) -- put the head on screen
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('line', head.x, head.y, step, step)

	-- st = ""

	for i = 1, #body do -- putting all the bodies onto the screen
		local part = body[i]
		-- love.graphics.print(" " .. i .. " " .. #body)
		love.graphics.setColor(0, 1, 0)
		love.graphics.rectangle('fill', part.x, part.y, step, step)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle('line', part.x, part.y, step, step)
		-- st = st .. part.x .. " " .. part.y .. " "
	end
	-- love.graphics.print(st)

	love.graphics.setColor(1, 1, 1)
	-- love.graphics.rectangle('fill', apple.x, apple.y, apple.size, apple.size)
	love.graphics.draw(appleImage, apple.x, apple.y)

	love.graphics.print("Score: " .. #body, 20, 20, 0, 2)

	if (gameExit) then
		love.graphics.print("Game Over", display_size.x / 2 - 200, display_size.y / 2-30, 0, 5)
		love.graphics.print("Press p to play again", display_size.x / 2 - 200, display_size.y / 2 + 100, 0, 3)
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
