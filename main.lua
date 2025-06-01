local json = require "json/json"
local GS = require "gamescreen"
local CollageSource = require "collage_source"

--- @type CollageSource
local colSrc = nil

function love.load()
  love.window.setMode(1280, 720)
  local img = love.graphics.newImage("imagem.png")
  local f = io.open("points.json", "r")
  local points = json.decode(f:read("*a"))
  f:close()
  GS.load()
  colSrc = CollageSource.new(love.graphics.newImage("imagem.png"), points)
  colSrc:setTransform(love.math.newTransform(10, 10, 0, .3, .3))
end


function love.update(dt)
  GS.update(dt)
end


function love.draw()
  colSrc:draw()
  GS.draw()
end


function love.mousepressed(x, y, key)
  colSrc:mousepressed(x, y, key)

  local maybeSliceCnv = colSrc:getSlice()

  GS.mousepressed()
end


function love.keypressed(key)
end
