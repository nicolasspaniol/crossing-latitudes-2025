local CollageSource = require "collage_source"


--- @type CollageSource
local colSrc = nil

function love.load()
  love.window.setMode(1280, 720)
  colSrc = CollageSource.new(love.graphics.newImage("imagem.png"))
  colSrc:setTransform(love.math.newTransform(10, 10, 0, .3, .3))
end


function love.update(dt)

end


function love.draw()
  colSrc:draw()
  colSrc:debugPoints()
end


function love.mousepressed(x, y, key)
  colSrc:mousepressed(x, y, key)

  local maybeSliceCnv = colSrc:getSlice()
end


function love.mousemoved(x, y)
  colSrc:mousemoved(x, y)
end
