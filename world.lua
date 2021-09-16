local world = {}

local tilemaps = require 'tilemaps'

world.images = {
  walls = love.graphics.newImage('world.png'),
  items = love.graphics.newImage('items.png'),
  enemies = love.graphics.newImage('enemies.png'),
}

world.map = {}
world.quads = {}
for _, v in pairs(world.images) do
    world.map[_] = {}
    world.quads[_] = {}
end

local size
local tile
local empty_pos = {}

function world.init(world_size, tile_size)
  local w, h, t = 0, 0, tile_size
  for _,v in pairs(world.images) do
    w, h = v:getWidth(), v:getHeight()
    for i = 1, math.floor(w/t) do
      world.quads[_][i] = love.graphics.newQuad(t*(i-1), 0, t, t, w, h)
    end
  end
  size = world_size
  tile = tile_size
end

function world.start()
  for _,v in pairs(world.map) do
    world.map[_] = {}
    for i = 1, size do
      local line = {}
      for j = 1, size do
        line[j] = 0
      end
      world.map[_][i] = line
    end
  end
  world.generate()
end

function world.update(dt)
end

function world.draw()
  local n
  for i = 1, size do
    for j = 1, size do
      love.graphics.draw(world.images['walls'], world.quads['walls'][1], tile*i, tile*j)
      for _,v in pairs(world.images) do
        n = world.map[_][i][j]
        if n > 0 then
          love.graphics.draw(v, world.quads[_][n], tile*i, tile*j)
        end
      end
    end
  end
end

function world.get(x, y) -- возвращает таблицу 'объект'=значение в позиции x y
  local g = {}
  for _,v in pairs(world.map) do
    g[_] = -1
  end
  if x > 0 and x <= size and y > 0 and y <= size then
    for _,v in pairs(world.map) do
      g[_] = world.map[_][x][y]
    end
  end
  return g
end

function world.get_pos() -- возвращает рандомную пустую позицию и удаляет ее из списка
  local random_pos = love.math.random(1, #empty_pos)
  local p = empty_pos[random_pos]
    empty_pos[random_pos] = empty_pos[#empty_pos]
    empty_pos[#empty_pos] = nil
  return p
end

function world.generate() -- генератор уровней
  local p, x, y
  -- создаем карту и стенки из кусков tilemaps
  p = math.floor(size/tilemaps.size)
  for x = 1, p do
    for y = 1, p do
      local r = love.math.random(1, #tilemaps)
      world.generate_walls(x, y, r)
    end
  end
  -- создаем список пустых позиций
  empty_pos = {}
  for i = 1, size do
    for j = 1, size do
      if world.map['walls'][i][j] == 0 then
        table.insert(empty_pos, {i,j})
      end
    end
  end
  -- расставляем вещи и врагов
  for i = 1, size do
    for _,v in pairs(world.images) do
--      if _ ~= 'walls' then
      if _ == 'items' then
        p = world.get_pos()
        x, y = p[1], p[2]
        world.map[_][x][y] = love.math.random(1, #world.quads[_])
      end
    end
  end
end

function world.generate_walls(x, y, r) -- создание стен
  for i = 1, tilemaps.size do
    for j = 1, tilemaps.size do
      if tilemaps[r][j][i] == '#' then
        local qx, qy = i + (x - 1) * tilemaps.size, j + (y - 1) * tilemaps.size
        world.map['walls'][qx][qy] = love.math.random(2, #world.quads['walls'])
      end
    end
  end
end

function world.print() -- отрисовщик для тестов в консоли
  for i = 1, size do
    local line = {}
    for j = 1, size do
      line[j] = world.map['walls'][j][i]
      if world.map['walls'][j][i] > 0 then
        line[j] = 'w'
      end
      if world.map['items'][j][i] > 0 then
        line[j] = world.map['items'][j][i]
      end
    end
    print(table.concat(line, ' '))
  end
  print()
end

return world