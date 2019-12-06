local game={}
local player={}
local arrow={{50,0},{-25,50},{0,0},{-25,-50}}
local fire={{-12.5,25},{-12.5,-25},{-45,0}}
local asteroid={{10,0},{7,8},{-5,7},{-9,-1},{-3,-7},{7,-6}}
local laser_poly = {{5,1},{5,-1},{-5,-1},{-5,1}}
local K_THRUST=5
local K_LASER=512
local K_AST_SPEED=128
local player_thrusting=false
local asteroids={}
local laser=nil
local difficulty=10
local sx,sy
function draw_rot_poly(x,y,r,col,mode,poly,scale)
  scale=scale or 1
  love.graphics.setColor(unpack(col))
  local rotpoly={}
  for i,v in ipairs(poly) do
    rotpoly[i*2-1]=x+math.cos(r)*v[1]*scale+math.sin(r)*v[2]*scale
    rotpoly[i*2]=y+math.sin(r)*v[1]*scale-math.cos(r)*v[2]*scale
  end
  love.graphics.polygon(mode, unpack(rotpoly))
end
function newton(obj,dt,damp)
  if damp then
    obj.xv=obj.xv*damp
    obj.yv=obj.yv*damp
  end
  obj.x=obj.x+obj.xv*dt
  obj.y=obj.y+obj.yv*dt
end
function wrap(obj)
  obj.x=(obj.x+obj.csz*2)%(sx+obj.csz*4)-obj.csz*2
  obj.y=(obj.y+obj.csz*2)%(sy+obj.csz*4)-obj.csz*2
end
function off_screen(obj)
  return obj.x<0 or obj.x>sx or obj.y<0 or obj.y>sy
end
function collide(obj,olist)
  --super lazy
  local collided = {}
  for i,oo in ipairs(olist) do
    if math.pow(obj.x-oo.x,2)+math.pow(obj.y-oo.y,2)<math.pow(obj.csz+oo.csz,2) then
      table.insert(collided,i)
    end
  end
  return collided
end
function game.setup(size)
  sx,sy=unpack(size)
  player={x=sx/2,y=sy/2,xv=0,yv=0,r=0,csz=20}
  asteroids={}
  for i=1,difficulty do
    asteroids[i]={x=math.random(0, sx),y=math.random(0, sy),
    xv=(math.random()-0.5)*K_AST_SPEED,yv=(math.random()-0.5)*K_AST_SPEED,
    sz=math.pow(2,math.random(0, 2)),
    r=math.random()*math.pi*2,w=(math.random()-0.5)*0.1}
    asteroids[i].csz=asteroids[i].sz*14
  end
end
function game.render(offset,size)
  love.graphics.setLineWidth(2)
  if player_thrusting then
    draw_rot_poly(player.x,player.y,player.r,{255,200,0},"line",fire,0.4)
  end
  draw_rot_poly(player.x,player.y,player.r,{255,255,255},"line",arrow,0.4)
  --love.graphics.circle("line", player.x, player.y, player.csz, 100)
  for i,a in ipairs(asteroids) do
    draw_rot_poly(a.x,a.y,a.r,{0.5,0.5,0.5},"line",asteroid,a.sz*2)
    --love.graphics.circle("line", a.x, a.y, a.csz, 100)
  end
  if laser then
    draw_rot_poly(laser.x,laser.y,laser.r,{1,0,0},"fill",laser_poly,2)
  end
end
function game.on_focused(dt)
  local dr = 0
  if love.keyboard.isDown("a") then
    dr=-1
  elseif love.keyboard.isDown("d") then
    dr=1
  end
  player.r=player.r+dt*dr*5
  if love.keyboard.isDown("space") then
    player.xv=player.xv+math.cos(player.r)*K_THRUST
    player.yv=player.yv+math.sin(player.r)*K_THRUST
    player_thrusting=true
  else
    player_thrusting=false
  end
  if not laser and love.keyboard.isDown("lshift") then
    laser={x=player.x,y=player.y,xv=player.xv+K_LASER*math.cos(player.r),yv=player.yv+K_LASER*math.sin(player.r),r=player.r,csz=2}
  end
  newton(player,dt,0.99)
  for i,a in ipairs(asteroids) do
    a.r=a.r+a.w
    newton(a,dt)
    wrap(a)
  end
  if laser then
    newton(laser,dt)
    if off_screen(laser) then
      laser=nil
    end
  end
  if #collide(player,asteroids)>0 or off_screen(player) then
    game.setup({sx,sy})
  end
  if laser then
    local dead_asteroids=collide(laser,asteroids)
    if #dead_asteroids>0 then
      local delta=0
      for _,i in ipairs(dead_asteroids) do
        target=i+delta
        tar_asteroid=asteroids[target]
        if tar_asteroid.sz>1.5 then
          split_angle=laser.r-math.pi/2
          table.insert(asteroids,{x=tar_asteroid.x,y=tar_asteroid.y,
          xv=tar_asteroid.xv+K_AST_SPEED/2*math.cos(split_angle),yv=tar_asteroid.yv+K_AST_SPEED/2*math.sin(split_angle),
          r=math.random()*math.pi*2,w=(math.random()-0.5)*0.1,sz=tar_asteroid.sz/2,csz=tar_asteroid.csz/2})
          table.insert(asteroids,{x=tar_asteroid.x,y=tar_asteroid.y,
          xv=tar_asteroid.xv+K_AST_SPEED/2*math.cos(split_angle+math.pi),yv=tar_asteroid.yv+K_AST_SPEED/2*math.sin(split_angle+math.pi),
          r=math.random()*math.pi*2,w=(math.random()-0.5)*0.1,sz=tar_asteroid.sz/2,csz=tar_asteroid.csz/2})
        end
        delta=delta-1
        table.remove(asteroids,target)
      end
      laser=nil
    end
  end
end
return game
