local Stamps = {}

local Buttons = require "buttons"

Stamps.new = function(self, x, y, width, height, bx, by, bw, bh, sw, sh, image, stampImage, object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self

  local bttFunction = function(self)
    
    -- object.lastMouseCoords.x, object.lastMouseCoords.y = love.mouse.getPosition()
    local mx, my = love.mouse.getPosition()
    local bx1, bx2 = object.Drawer.coords.x, object.Drawer.coords.x + object.Drawer.size.width
    local by1, by2 = object.Drawer.coords.y, object.Drawer.coords.y + object.Drawer.size.height
    
    if mx > bx1 and mx < bx2 and my > by1 and my < by2 then
      object.following = not object.following
    else
      object.Stamp.inScreen = true
      object.drawStamp = true
      object.Stamp.coords = { x = mx, y = my }
    end
    
    self.drawUpdate = true
    self.isHovered = true
  end

  
  object.Stamp = {}
  object.Stamp.inScreen = false
  object.Stamp.size = { width = sw, height = sh }
  object.Stamp.image = stampImage
  object.Stamp.coords = { x = -1, y = -1 }
  object.drawStamp = false
  object.Drawer = {}
  object.Drawer.coords = { x = bx, y = by }
  object.Drawer.size = { width = bw, height = bh }
  object.pos = { x = x, y = y}
  
  -- object.lastMouseCoords = { x = 0, y = 0 }
  object.Button = Buttons:new(image, x, y, width, height, bttFunction)
  object.following = false
  object.Button.inScreen = true
  object.Button.drawUpdate = true
  object.inScreen = object.Button.inScreen
  object.drawUpdate = object.Button.drawUpdate
  return object
end

Stamps.update = function(self, mx, my, dt)
  if self.inScreen then self.Button.inScreen = true end
  if self.inScreen then
    self.Button.inScreen = true
    if not (self.following) then self.Button:update(mx, my, dt)
    else
      self.Button.coords = {
        x = mx - self.Button.size.width/2,
        y = my - self.Button.size.height/2,
      }
      if (self.Button.image.type or "") == "animation" then self.Button.image:update(dt) end
    end
     
  else
    self.drawUpdate = false
    -- self.drawStamp = false
    self.Button.drawUpdate = false
    self.Button.inScreen = false
  end
  if not self.Stamp.inScreen then self.drawStamp = false end
  if self.Stamp.inScreen and (self.Stamp.image.type or "") == "animation" then self.Stamp.image:update(dt) end
end

Stamps.draw = function(self, inCanvas, xCanvas, yCanvas)
  if self.inScreen and (self.Stamp.image.type or "") == "animation" then self.drawStamp = true end
  if self.Button.drawUpdate then self.drawUpdate = true end
  if self.drawStamp and (self.Stamp.coords.x ~= -1 and self.Stamp.coords.y ~= -1) then
      if inCanvas then self.drawStamp = false end
      local iw, ih = 0, 0
      if (self.Stamp.image.type or "") == "animation" then 
        _, _, iw, ih = self.Stamp.image.quads[1]:getViewport()
      else
        iw, ih = self.Stamp.image:getDimensions()
      end
      local sx, sy = 0.9*self.Stamp.size.width/iw, 0.9*self.Stamp.size.height/ih
      local x, y = xCanvas or 0, yCanvas or 0
      if not inCanvas then x, y = self.Stamp.coords.x - self.Stamp.size.width/2, self.Stamp.coords.y - self.Stamp.size.height/2 end
      if (self.Stamp.image.type or "") == "animation" then 
        self.Stamp.image:draw(x, y, 0, sx, sy)
        self.Stamp.drawStamp = true
      else
        love.graphics.draw(self.Stamp.image, x, y, 0, sx, sy)
      end
    end
  if self.drawUpdate then
    
    if self.following then self.Button.isHovered = false end
    self.Button:draw(inCanvas, xCanvas, yCanvas)
    if self.following then self.Button.isHovered = true end
    if inCavas then self.drawUpdate = false end
  end
  
end

Stamps.mousepressed = function(self)
  self.Button:mousepressed()
end

return Stamps