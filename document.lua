local Buttons = require "buttons"

--- @class Document
local Document = {}
Document.__index = Document


function Document.new(x, y, width, height, image, dType)
  local bttFunction = function(doc, collages, selCollIdx)
    if collages[selCollIdx] then
      table.insert(doc.collages, collages[selCollIdx])
    else
      doc.isMoving = not doc.isMoving
    end
  end

  local o = {
    type = dType,
    collages = {},
    canva = love.graphics.newCanvas(width, height),
    recorded_pos = { x = 0, y = 0 },
    button = Buttons:new(image, x, y, width, height, bttFunction),
    dx = 0,
    dy = 0,
    bttFunction = bttFunction
  }

  o.button.draw = function(self, inCanvas, xCanvas, yCanvas)
    self.drawUpdate = false
    local sM = 1
    if (self.image.type or "") == "animation" then
        self.drawUpdate = true
        local _, _, qw, qh = self.image.quads[1]:getViewport()
        local sx, sy = self.size.width/qw, self.size.height/qh
        local x, y = (xCanvas or 0) + (1-sM)/2 * self.size.width, (yCanvas or 0) + (1-sM)/2 * self.size.height
        if not inCanvas then x, y = self.coords.x + (1-sM)/2 * self.size.width, self.coords.y + (1-sM)/2 * self.size.height end
        self.image:draw(x, y, 0, sM*sx, sM*sy)
    else
        local iw, ih = self.image:getDimensions()
        local x, y = (xCanvas or 0) + (1-sM)/2 * self.size.width, (yCanvas or 0) + (1-sM)/2 * self.size.height
        if not inCanvas then x, y = self.coords.x + (1-sM)/2 * self.size.width, self.coords.y + (1-sM)/2 * self.size.height end
        love.graphics.draw(self.image, x, y , 0, sM*self.size.width/iw, sM*self.size.height/ih) 
    end
  end

  setmetatable(o, Document)
  return o
end


function Document:update(mx, my, dt)
  self.button:update(mx, my, dt)
end


function Document:draw()
  local xm, ym = love.mouse.getPosition()
  if self.isMoving then
    self.button.coords.x = xm - self.dx
    self.button.coords.y = ym - self.dy
  end
  self.button:draw(true, self.button.coords.x, self.button.coords.y)
  if #self.collages > 0 then
    for _, collage in ipairs(self.collages) do
      if self.isMoving then
        collage.moved:setTransformation(xm - self.dx, ym - self.dy)
      end
      collage:draw()
    end
  end
end


function Document:mousepressed(x, y, key, collages, selCollIdx)
  if key == 1 then
    local xp = self.button.coords.x
    local yp = self.button.coords.y
    if self.isMoving then
      self.isMoving = false
    elseif (x > xp and x < xp + self.canva:getWidth()) and (y > yp and y < yp + self.canva:getHeight()) then
      self.isMoving = true
      self.dx = x - xp
      self.dy = y - yp
    end
  end
end


function Document:isHovering(x, y)
  local xp = self.button.coords.x
  local yp = self.button.coords.y

  return (x > xp and x < xp + self.canva:getWidth()) and (y > yp and y < yp + self.canva:getHeight())
end


return Document
