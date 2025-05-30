local json = require "json/json"

local CollageSource = require "collage_source"

--- @type CollageSource
local colSrc = nil

function love.load()
  love.window.setMode(1280, 720)
  local img = love.graphics.newImage("imagem.png")
  local f = io.open("points.json", "r")
  local points = json.decode(f:read("*a"))
  f:close()
  
  colSrc = CollageSource.new(love.graphics.newImage("imagem.png"), points)
  colSrc:setTransform(love.math.newTransform(10, 10, 0, .3, .3))
end


function love.update(dt)

end


function love.draw()
  colSrc:draw()
end


function love.mousepressed(x, y, key)
  colSrc:mousepressed(x, y, key)

  local maybeSliceCnv = colSrc:getSlice()
end


function love.keypressed(key)
end
