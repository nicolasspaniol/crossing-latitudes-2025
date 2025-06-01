local json = require "json/json"
local GS = require "gamescreen"
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
  
  doc = Document.new(800, 200, 300, 200, love.graphics.newImage("assets/passport_template.jpg"))
  colSrc = CollageSource.new(love.graphics.newImage("imagem.png"), points)
  colSrc:setTransform(love.math.newTransform(10, 10, 0, .2, .2))
  collages = {}
  currentCollage = nil

  GS.load()
end


function love.update(dt)
  local mx, my = love.mouse.getPosition()
  doc:update(mx, my, dt)
  GS.update(dt)
end


function love.draw()
  GS.draw()
  colSrc:draw()
  doc:draw()
  if #collages > 0 then
    for _, collage in ipairs(collages) do
      collage:draw()
    end
  end
end


function love.mousepressed(x, y, key)
  GS.mousepressed()
  if key ~= 1 then return end

  if currentCollage then
    if doc:isHovering(x, y) then
      currentCollage.rel:translate(x - doc.button.coords.x, y - doc.button.coords.y)
      currentCollage.fixed = true
      table.insert(doc.collages, currentCollage)
      currentCollage = nil
      doc:mousepressed(x, y, key, collages, currentCollage)
      doc:draw()
      doc:mousepressed(x, y, key, collages, currentCollage)
    else
      currentCollage:mousepressed(x, y, key)
      currentCollage = nil
    end
  else
    for _, collage in ipairs(collages) do
      if not collage.fixed then
        collage:mousepressed(x, y, key)

        if collage.pressed then
          currentCollage = collage
        end
      end
    end

    if not currentCollage and not doc:isHovering(x, y) then
      colSrc:mousepressed(x, y, key)
    end

    local maybeSlice = colSrc:getSlice()
    collages[#collages+1] = maybeSlice

    doc:mousepressed(x, y, key, collages, currentCollage)
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
