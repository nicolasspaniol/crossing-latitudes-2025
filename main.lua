local CollageSource = require "collage_source"
local takePoints = require "takePoints"

--- @type CollageSource
local colSrc = nil

--- @type takePoints
local tkp = nil


function love.load()
  love.window.setMode(1280, 720)
  local img = love.graphics.newImage("imagem.png")
  colSrc = CollageSource.new(img)
  colSrc:setTransform(love.math.newTransform(10, 10, 0, .3, .3))
  tkp = takePoints.new(0, 0, img:getWidth(), img:getHeight())
end


function love.update(dt)

end


function love.draw()
  colSrc:draw()
  tkp:draw()
end


function love.mousepressed(x, y, key)
  colSrc:mousepressed(x, y, key)
  tkp:mousepressed(x, y, key, colSrc)

  local maybeSliceCnv = colSrc:getSlice()
end


function love.keypressed(key)
  tkp:keypressed(key)
end