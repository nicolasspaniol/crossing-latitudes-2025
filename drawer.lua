local PopUp = require "popups"
local Stamps = require "stamps"


local Drawer = {}


Drawer.createEntities = function(bx, by, bw, bh, images, openImage, closeImage, UIImage, stampWidthRatio, stampHeightRatio)
  Drawer.coords = { x = bx, y = by }
  Drawer.size = { width = bw, height = bh }

  local stampSize = math.min(math.ceil(bh*0.4/2), bw*0.5/2)
  local stx1, sty1 = bx + bw*0.225, by + bh*0.1
  
  Drawer.stamps = {}
  for i = 1, #images do
    table.insert(Drawer.stamps, Stamps:new(stx1 + 0.8*((i-1) %2)*(bx + bw)/4, sty1 + 0.5*stampSize*(i-1), stampSize, stampSize, 
      bx, by, bw, bh, stampWidthRatio*stampSize, stampHeightRatio*stampSize, images[i][1], images[i][2]))
  end
  local _, _, buttonSize1, buttonSize2 = openImage.quads[1]:getViewport()
  local pppw, ppph, pppx, pppy;
  if (UIImage.type or "") == "animation" then
    _, _, pppw, ppph = UIImage.quads[1]:getViewport()
    pppx, pppy = bx + (pppw - bw)/2, by - (ppph - bh)/2
  else
    pppw, ppph = UIImage:getWidth(), UIImage:getHeight()
    pppx, pppy = bx + (UIImage:getWidth() - bw)/2, by - (UIImage:getHeight() - bh)/2
  end
  -- print(pppw, ppph, pppx, pppy)
  -- Drawer.popUp = PopUp:new(pppx, pppy, pppw, ppph , pppx, pppy , buttonSize, buttonSize, closeImage, openImage, UIImage)
  Drawer.popUp = PopUp:new(bx, by, 0.66*bw, 0.66*bh, -7.8, 100, 0.66*buttonSize1, 0.66*buttonSize2, closeImage, openImage, UIImage)
  Drawer.inScreen = true
  Drawer.lastActive = 0

end

Drawer.update = function(self, mx, my, dt)
  if self.inScreen then
    self.popUp:update(mx, my, dt)
    if self.popUp.UI.inScreen then
      for i = 1, #self.stamps do
        if not self.stamps[i].inScreen then
          self.stamps[i].inScreen = true
          self.stamps[i].drawUpdate = true
        end
      end
    else
      for i = 1, #self.stamps do
        self.stamps[i].inScreen = false
      end
    end
    for i=1, #self.stamps do
      self.stamps[i]:update(mx, my, dt)
      if self.stamps[i].Stamp.active then
        for j=1,#self.stamps do
          if self.stamps[i] ~= self.stamps[j] then
            self.stamps[j].drawStamp = false
          end
        end
        self.stamps[i].Stamp.active = false
        self.lastActive = i
      end
    end
  else
    for i = 1, #self.stamps do
        self.stamps[i].inScreen = false
        self.stamps[i].Stamp.inScreen = false
          -- self.stamps[i].drawUpdate = true
        
    end
    self.popUp.UI.inScreen = false
    self.popUp.Btt.drawUpdate = false
    for i=1, #self.stamps do
      self.stamps[i]:update(mx, my, dt)
    end
  end
end

Drawer.draw = function(self, inCanvas, xCanvas, yCanvas, Canvas)
  self.popUp:draw()
  for i=1,#self.stamps do
    self.stamps[i]:drawStamps(inCanvas, xCanvas, yCanvas, Canvas)
  end
  love.graphics.setColor(1,1,1,1)
  if Canvas then love.graphics.draw(Canvas, xCanvas, yCanvas) end
  for i=1,#self.stamps do
    self.stamps[i]:drawButtons(inCanvas, xCanvas, yCanvas, Canvas)
  end
end

Drawer.mousepressed = function(self)
  if self.inScreen then
    self.popUp:mousepressed()
    for i=1,#self.stamps do
      self.stamps[i]:mousepressed()
    end
  end
end

return Drawer


