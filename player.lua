local player = {}

player.x = 0
player.y = 0

local img = love.graphics.newImage('player.png')
local max_frame
local animation_speed = 24
local animation_frame = 1
local animation_state = {
  move = {},
  use = {},
  idle = {},
}

local vector2 = {0, 0}
local delta = {0, 0}
local direction = 0
local tile
local state = 'idle'

function player.init(world_size, tile_size)
	local w, h, t = img:getWidth(), img:getHeight(), tile_size
	tile = tile_size
	max_frame = math.floor(w/t)
	for i = 1, max_frame do
		animation_state['move'][i] = love.graphics.newQuad(t*(i-1), 0, t, t, w, h)
		animation_state['use'][i] = love.graphics.newQuad(t*(i-1), t, t, t, w, h)
		animation_state['idle'][i] = love.graphics.newQuad(0, 0, t, t, w, h)
	end
end

function player.update(dt)
  animation_frame = animation_frame + animation_speed * dt
  if animation_frame >= max_frame + 1 then
    animation_frame = 1
    player.x, player.y = player.x + vector2[1], player.y + vector2[2]
    vector2 = {0, 0}
    state = 'idle'
  end
	delta[1] = vector2[1] * (animation_frame - 1) / max_frame
	delta[2] = vector2[2] * (animation_frame - 1) / max_frame
end

function player.draw()
  local x = tile*(player.x + delta[1])
  local y = tile*(player.y + delta[2])
  local t = tile/2
  local frame = animation_state[state][math.floor(animation_frame)]
  love.graphics.draw(img, frame, x+t, y+t, direction, 1, 1, t, t)
end

function player.start(p)
  player.x, player.y = p[1], p[2]
  animation_frame = 1
  vector2 = {0, 0}
  delta = {0, 0}
  state = 'idle'
  direction = 0
end

function player.move(x, y, objects)
  if state ~= 'idle' then return end
  direction = player.get_direction(x, y)
  if objects['walls'] == 0 then
    vector2 = {x, y}
    state = 'move'
    animation_frame = 1
  end
  if objects['items'] > 0 then
    state = 'use'
  end
--  if objects['enemies'] > 0 then
--    state = 'use'
--  end
end

function player.get_direction(x, y)
  local v = -90 * x - 180 * y
  if y == 1 then v = 0 end
  return math.rad(v)
end

return player