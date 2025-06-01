local PopUp = require "popups"
local Stamps = require "stamps"


local Drawer = {}


Drawer.createStamps = function(bx, by, bw, bh, images, openImage, closeImage, UIImage, stampWidthRatio, stampHeightRatio)
  Drawer.coords = { x = bx, y = by }
  Drawer.size = { width = bw, height = bh }

  local stampSize = math.min(math.ceil(bh*0.9/2), bw*0.9/2)
  local stx1, sty1 = bx + bw*0.05, by + bh*0.05
  
  Drawer.stamps = {}
  for i = 1, #images do
    table.insert(Drawer.stamps, Stamps:new(stx1 + bw*((i+1) % 2)/2, sty1 + stampSize*(i-1), stampSize, stampSize, 
      bx, by, bw, bh, stampWidthRatio*stampSize, stampHeightRatio*stampSize, images[i][1], images[i][2]))
  end
  local buttonSize = bh*0.3
  Drawer.popUp = PopUp:new(bx, by, bw, bh, bx, by + (bh - buttonSize)/2, buttonSize, buttonSize, closeImage, openImage, UIImage)
  Drawer.inScreen = true

end

Drawer.update = function(mx, my, dt)
  if Drawer.inScreen then
    Drawer.popUp:update(mx, my, dt)
    if Drawer.popUp.UI.inScreen then
      for i = 1, #Drawer.stamps do
        if not Drawer.stamps[i].inScreen then
          Drawer.stamps[i].inScreen = true
          Drawer.stamps[i].drawUpdate = true
        end
      end
    else
      for i = 1, #Drawer.stamps do
        Drawer.stamps[i].inScreen = false
      end
    end
    for i=1, #Drawer.stamps do
      Drawer.stamps[i]:update(mx, my, dt)
    end
  else
    for i = 1, #Drawer.stamps do
        Drawer.stamps[i].inScreen = false
        Drawer.stamps[i].Stamp.inScreen = false
          -- Drawer.stamps[i].drawUpdate = true
        
    end
    Drawer.popUp.UI.inScreen = false
    Drawer.popUp.Btt.drawUpdate = false
    for i=1, #Drawer.stamps do
      Drawer.stamps[i]:update(mx, my, dt)
    end
  end
end

Drawer.draw = function(inCanvas, xCanvas, yCanvas, Canvas)
  Drawer.popUp:draw()
  for i=1,#Drawer.stamps do
    Drawer.stamps[i]:drawStamps(inCanvas, xCanvas, yCanvas, Canvas)
  end
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(Canvas, xCanvas, yCanvas)
  for i=1,#Drawer.stamps do
    Drawer.stamps[i]:drawButtons(inCanvas, xCanvas, yCanvas, Canvas)
  end
end

Drawer.mousepressed = function()
  if Drawer.inScreen then
    Drawer.popUp:mousepressed()
    for i=1,#Drawer.stamps do
      Drawer.stamps[i]:mousepressed()
    end
  end
end

return Drawer


