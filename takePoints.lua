local json = require "json/json"
-- local inspect = require "inspect/inspect"

local points = {}
local setPoints = {}
local name = ''
local numSets = 0
local img = nil

function love.load()
  love.window.setMode(1280, 720)
  img = love.graphics.newImage("imagem.png")
end


function love.draw()
    love.graphics.draw(img)
    for i = 1,#points/2 do
      love.graphics.circle("fill", points[2*i-1], points[2*i], 5)
    end
end


function love.update(dt)
end


function love.mousepressed(x, y, key)
  if key == 1 then
    if x > 0 and x < img:getWidth() then
        if y > 0 and y < img:getHeight() then
          points[#points+1] = x
          points[#points+1] = y
        end
    end
  end
end


local function savePoints()
  local file = io.open("setPoints.json", "w")
  if file then
    file:write(json.encode(setPoints))
    file:close()
  else
    print("error creating file")
  end
end


function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
  if key == 'n' then
    if #points > 0 then
      -- name = io.read("l")  // Não tava funcionando
      name = 'teste'..numSets
      numSets = numSets + 1
      setPoints[name] = points
      points = {}
    end
  end
  if key == 's' then
    if #points > 0 then
      numSets = numSets + 1
      name = 'teste'..numSets
      setPoints[name] = points
    end
    savePoints()
  end
end