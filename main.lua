local GS = require "gamescreen"

local CollageSource = require "collage_source"
local Document = require "document"
local ms = require "mainscreen"

--- @type CollageSource
local colSrc = nil

--- @type MoveSource
local mvSrc = nil

--- @type Document
local doc = nil

MS = nil


function love.load()
  love.window.setMode(1280, 720)
  audio = love.audio.newSource("assets/chiphead64-11pm.ogg", "static")
  audio:setLooping(true)
  love.audio.play(audio)
  

  screen = 1
  local function func() screen = screen%2 + 1 end
  MS = ms.new(func)
  GS.load("assets/news/0.jpg", "assets/reqPass0.png", "assets/points1.json", "assets/passport_template.jpg")
end


function love.update(dt)
  
  if screen == 2 then
    local mx, my = love.mouse.getPosition()
  
    GS.update(dt)
  else
    MS:update(dt)
  end
end


function love.draw()
  -- love.graphics.setCanvas(doc.canva)
  -- love.graphics.clear(1,1,1,1)
  -- love.graphics.draw(doc.button.image, 0,0,0,doc.button.size.width/doc.button.image:getWidth(),doc.button.size.height/doc.button.image:getHeight())
  -- love.graphics.setCanvas()
  
  
  if screen == 2 then
    GS.draw1()
  
    GS.draw2(true, GS.doc.button.coords.x, GS.doc.button.coords.y, GS.doc.canva)
  else
    MS:draw()
  end
end


function love.mousepressed(x, y, key)
  
  
  if screen == 2 then
    GS.mousepressed(x, y, key)
  else
    MS:mousepressed(x, y, key)
  end
end


function love.keypressed(key)
  GS.keypressed(key)
  
  if key == 'm' then
    screen = 1
  end
  -- if key == 'escape' then
  --   colSrc:cancelSelection()
  -- end
end
