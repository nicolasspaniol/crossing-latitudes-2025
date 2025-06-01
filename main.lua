local GS = require "gamescreen"


--- @type CollageSource
local colSrc = nil

--- @type MoveSource
local mvSrc = nil

--- @type Document
local doc = nil

function love.load()
  love.window.setMode(1280, 720)
  

  GS.load()
end


function love.update(dt)
  local mx, my = love.mouse.getPosition()
  
  GS.update(dt)
end


function love.draw()
  -- love.graphics.setCanvas(doc.canva)
  -- love.graphics.clear(1,1,1,1)
  -- love.graphics.draw(doc.button.image, 0,0,0,doc.button.size.width/doc.button.image:getWidth(),doc.button.size.height/doc.button.image:getHeight())
  -- love.graphics.setCanvas()
  GS.draw1()
  
  GS.draw2(true, GS.doc.button.coords.x, GS.doc.button.coords.y, GS.doc.canva)
  
end


function love.mousepressed(x, y, key)
  GS.mousepressed(x, y, key)
  
end


function love.keypressed(key)
  GS.keypressed(key)
  
end
