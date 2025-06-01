local json = require "json/json"
local MoveSource = require "move_source"
local CollageSource = require "collage_source"
local Document = require "document"

--- @type CollageSource
local colSrc = nil

--- @type MoveSource
local mvSrc = nil

--- @type Document
local doc = nil

function love.load()
  love.window.setMode(1280, 720)
  local img = love.graphics.newImage("imagem.png")
  local f = io.open("points.json", "r")
  local points = json.decode(f:read("*a"))
  f:close()
  
  doc = Document.new(800, 200, 200, 100, love.graphics.newImage("data/impres.png"))
  colSrc = CollageSource.new(love.graphics.newImage("imagem.png"), points)
  colSrc:setTransform(love.math.newTransform(10, 10, 0, .1, .1))
  collages = {}
  currentCollage = 0
end


function love.update(dt)
  local mx, my = love.mouse.getPosition()
  doc.update(mx, my, dt)
end


function love.draw()
  colSrc:draw()
  doc:draw()
  if #collages > 0 then
    for _, collage in ipairs(collages) do
      collage:draw()
    end
  end
end


function love.mousepressed(x, y, key)
  local onCol = false
  doc:mousepressed(x, y, key, collages, currentCollage)
  if #collages > 0 then
    if collages[currentCollage] and collages[currentCollage].pressed then
      collages[currentCollage]:mousepressed(x, y, key)
      currentCollage = 0
    else
      for i, collage in ipairs(collages) do
        collage:mousepressed(x, y, key)
        if collage.pressed then
          currentCollage = i
          onCol = true
          break
        end
      end
    end
  end
  if not onCol then
    colSrc:mousepressed(x, y, key)
    local maybeSliceCnv = colSrc:getSlice()
    collages[#collages+1] = maybeSliceCnv
  end
end


function love.keypressed(key)
  if key == 'q' then
    love.event.quit()
  end
  if key == 'escape' then
    colSrc:cancelSelection()
  end
end