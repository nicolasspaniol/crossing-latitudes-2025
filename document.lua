local Buttons = require "buttons"

--- @class Document
local Document = {}
Document.__index = Document


Document.isMoving = false

Document.new = function(x, y, width, height, image, dType)
  local bttFunction = function(self, collages, selCollIdx)
    if collages[selCollIdx] then
      table.insert(Document.collages, collages[selCollIdx])
    else
      Document.isMoving = not Document.isMoving
    end
  end

  Document.type = dType
  Document.collages = {}
  Document.canva = love.graphics.newCanvas(width, height)
  Document.recorded_pos = { x = 0, y = 0 }
  Document.button = Buttons:new(image, x, y, width, height, bttFunction)
  Document.dx = 0
  Document.dy = 0
  
  Document.button.draw = function(self, inCanvas, xCanvas, yCanvas)
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

  return Document
end


Document.update = function(mx, my, dt)
  Document.button:update(mx, my, dt)
end


Document.draw = function()
  local xm, ym = love.mouse.getPosition()
  if Document.isMoving then
    Document.button.coords.x = xm - Document.dx
    Document.button.coords.y = ym - Document.dy
  end
  Document.button:draw(true, Document.button.coords.x, Document.button.coords.y)
  if #Document.collages > 0 then
    for _, collage in Document.collages do
      if Document.isMoving then
        collage.transform:translate(xm, ym)
      end
      collage.draw()
    end
  end
end


Document.mousepressed = function(x, y, key, collages, selCollIdx)

  if key == 1 then
    local xp = Document.button.coords.x
    local yp = Document.button.coords.y
    if Document.isMoving then
      Document.isMoving = false
    elseif (x > xp and x < xp + Document.canva:getWidth()) and (y > yp and y < yp + Document.canva:getHeight()) then
      Document.bttFunction(Document, collages, selCollIdx)
      Document.dx = x - xp
      Document.dy = y - yp
      if #Document.collages > 0 then
        for _, collage in ipairs(Document.collages) do
          local xc, yc = collage.transform:transformPoint(0,0)
          collage.dx = x - xc
          collage.dy = y - yc
        end
      end
    end
  end
end


return Document