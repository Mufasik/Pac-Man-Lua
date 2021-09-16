-- Project 1

local t = {jit.status()}
for i,v in ipairs(t) do	print(tostring(v)) end

local world = require 'world'
local player = require 'player'

local TILE_SIZE = 50
local WORLD_SIZE = 10

local game_started = false

function love.load(arg)
  world.init(WORLD_SIZE, TILE_SIZE)
  player.init(WORLD_SIZE, TILE_SIZE)
  game_start()
  game_started = true
end

function love.update(dt)
  if game_started then
    world.update(dt)
    local mx = (love.keyboard.isDown('d') and 1 or 0) - (love.keyboard.isDown('a') and 1 or 0)
    local my = (love.keyboard.isDown('s') and 1 or 0) - (love.keyboard.isDown('w') and 1 or 0)
    if (mx==0 and my~=0) or (mx~=0 and my==0) then 
      local x, y = player.x + mx, player.y + my
      local objects = world.get(x, y)
      player.move(mx, my, objects)
    end
    player.update(dt)
--    использование и удаление предметов и врагов доделать
    if world.map['items'][player.x][player.y] ~= 0 then
      world.map['items'][player.x][player.y] = 0
    end
    if world.map['enemies'][player.x][player.y] ~= 0 then
      world.map['enemies'][player.x][player.y] = 0
    end
  end
end

function love.draw()
  if game_started then
    --world.draw()
    player.draw()
  end
end

function love.keypressed(key, s, r)
  if key == 'escape' then
    love.event.quit()
  end
  if key == 'space' then
    game_start()
  end
end

function game_start()
  world.start()
--  world.print()
  player.start(world.get_pos())
end

function love.mousepressed(x, y, button)
  local px, py = math.floor(x/TILE_SIZE), math.floor(y/TILE_SIZE)
  if game_started and button == 1 then
  end
end

--[[
TO DO list
жизнь игрока
система уровней
цель? таймер жизни?

враги ходят и атакуют (какой тип атаки?)

]]--