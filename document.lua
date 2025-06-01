local Buttons = require "buttons"
local Document = {}
Document.isMoving = false

Document.create = function(x, y, width, height, image)
  
  
  local bttFunction = function(self, collages, selCollIdx, dType)
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

  Document.button.draw = function(self, inCanvas, xCanvas, yCanvas)
    self.drawUpdate = false
    local sM = 1
    if self.isHovered then
        sM = 1
    end
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
end

Document.update = function(mx, my, dt)
  Document.button:update(mx, my, dt)
  --
end

Document.draw = function()
  Document.button:draw(true, unpack(Document.button.coords) )
end