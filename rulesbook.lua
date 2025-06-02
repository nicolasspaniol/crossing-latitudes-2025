RB = {}
RB.drawUI = false
RB.drawAB = true
RB.Book = {}
RB.AccessButton = {}
RB.buttonHovered = false
RB.nextHovered = false
RB.prevHovered = false
RB.closeHovered = false
RB.currPage = 1
RB.pageNum = 1
RB.drawPageUpdate = false
RB.pages = {}
RB.pageTurned = false
RB.pageButtons = {}
-- RB.AccessButtonIm = {}


RB.createEntities = function(pages, prevI, nextI, closeI, aButton)
  local sw, sh = love.graphics.getDimensions()
  local cw, ch = sw*0.6, sh*0.8
  local whratio = cw/ch
  local cbw, cbh = sw*0.2, sw*0.2/whratio
  RB.ScreenCanvas = love.graphics.newCanvas(sw, sh)
  RB.ABUpdate = true;
  RB.BookCanvas = love.graphics.newCanvas(cw, love.graphics.getHeight())-- - (sh-ch)/2)
  RB.AccessButtonCanvas = love.graphics.newCanvas(cbw, cbh)
  RB.Book.coords = { x = (sw-cw)/2, y =  (sh-ch)/2} 
  RB.AccessButton.coords = { x = sw*0.95 - cbw, y = sh*0.95 - cbh}
  RB.Book.size = { width = cw, height = ch }
  RB.AccessButton.size = { width = cbw, height = cbh }
  RB.Book.next = {
    coords = { x = RB.Book.size.width*0.8,  y = RB.Book.size.height - RB.Book.size.width*0.2},
    size = { width = RB.Book.size.width*0.2, height = RB.Book.size.width*0.2 }
  }
  RB.Book.prev = {
    coords = { x = 0,  y = RB.Book.size.height - RB.Book.size.width*0.2},
    size = { width = RB.Book.size.width*0.2, height = RB.Book.size.width*0.2 }
  }
  RB.Book.close = {
    coords = { x = RB.Book.size.width*0.9,  y = 0},
    size = { width = RB.Book.size.width*0.1, height = RB.Book.size.width*0.1 }
  }
  RB.pageNum = #pages
  for i=1,#pages do
    RB.pages[#RB.pages+1] = pages[i]
  end
  RB.AccessButton.Image = aButton
  RB.pageButtons = { prevI, nextI, closeI }
  
end

RB.update = function(self, mx, my, dt)
  if self.AccessButton.Image.type == "animation" then self.AccessButton.Image:update(dt) end
  if self.pages[1].type == "animation" then self.pages[1]:update(dt) end
  if self.drawUI then
    
    local x1, x2 = self.Book.coords.x, self.Book.coords.x + self.Book.size.width
    local y1, y2 = self.Book.coords.y, self.Book.coords.y + self.Book.size.height
    local cx1, cx2 = x1 + self.Book.close.coords.x, x1 + self.Book.close.coords.x + self.Book.close.size.width
    local cy1, cy2 = y1 + self.Book.close.coords.y, y1 + self.Book.close.coords.y + self.Book.close.size.height
    local px1, px2 = x1 + self.Book.prev.coords.x,  x1 + self.Book.prev.coords.x + self.Book.prev.size.width
    local py1, py2 = y1 + self.Book.prev.coords.y,  y1 + self.Book.prev.coords.y + self.Book.prev.size.height
    local nx1, nx2 = x1 + self.Book.next.coords.x,  x1 + self.Book.next.coords.x + self.Book.next.size.width
    local ny1, ny2 = y1 + self.Book.next.coords.y,  y1 + self.Book.next.coords.y + self.Book.next.size.height

    if mx > cx1 and mx < cx2 and my > cy1 and my < cy2 then
      if self.pageTurned then
        self.drawPageUpdate = true
        self.pageTurned = false
      elseif not self.closeHovered then self.drawPageUpdate = true else self.drawPageUpdate = false end
      self.nextHovered = false
      self.prevHovered = false
      self.closeHovered = true
    elseif mx > nx1 and mx < nx2 and my > ny1 and my < ny2 then
      -- if self.pageTurned then
      --   self.drawPageUpdate = true
      --   self.pageTurned = false
      -- elseif not self.nextHovered then self.drawPageUpdate = true else self.drawPageUpdate = false end
      -- self.nextHovered = true
      -- self.prevHovered = false
      -- self.closeHovered = false
    elseif mx > px1 and mx < px2 and my > py1 and my < py2 then
      -- if self.pageTurned then
      --   self.drawPageUpdate = true
      --   self.pageTurned = false
      -- elseif not self.prevHovered then self.drawPageUpdate = true else self.drawPageUpdate = false end
      -- self.nextHovered = false
      -- self.prevHovered = true
      -- self.closeHovered = false
    else
      if self.pageTurned then
        self.drawPageUpdate = true
        self.pageTurned = false
      elseif self.nextHovered or self.prevHovered or self.closeHovered or self.buttonHovered
      then self.drawPageUpdate = true else self.drawPageUpdate = false end
      self.nextHovered = false
      self.prevHovered = false
      self.closeHovered = false
    end
    self.buttonHovered = false
  else
    self.drawPageUpdate = false
    self.nextHovered = false
    self.prevHovered = false
    self.closeHovered = false

    local x1, x2 = self.AccessButton.coords.x, self.AccessButton.coords.x + self.AccessButton.size.width
    local y1, y2 = self.AccessButton.coords.y, self.AccessButton.coords.y + self.AccessButton.size.height
    if mx > x1 + 50 and mx < x2 + 50 and my > y1 + 50 and my < y2 + 50 then 
      if not self.buttonHovered then self.ABUpdate = true end
      self.buttonHovered = true
      -- self.drawPageUpdate = true
    else 
      if self.buttonHovered then self.ABUpdate = true end
      self.buttonHovered = false
    end
  end
end

RB.ChangeBookState = function(self, open)
  if open then 
    
    self.drawUI = true
    self.drawAB = false
    self.currPage = 1
  elseif not open then 
    self.drawUI = false
    self.drawAB = true
  end
end

RB.TurnPage = function(self, isNext)
  if isNext then
    self.currPage = self.currPage % 3 + 1
  else
    self.currPage = self.currPage - 1 % 3
    if self.currPage == 0 then self.currPage = 3 end
  end
  self.pageTurned = true
end



RB.drawRulesButton = function(self, canvas)
  love.graphics.setCanvas(self.AccessButtonCanvas)
  love.graphics.clear(0,0,0,0)
  love.graphics.setColor(1,1,1,1)
  if self.AccessButton.Image then
    local _, _, w, h = self.AccessButton.Image.quads[1]:getViewport()
    local sx, sy = self.AccessButton.size.width/w, self.AccessButton.size.height/h
    if self.buttonHovered then
      love.graphics.setColor(1,1,1,1)--0.5)
      self.AccessButton.Image:draw(0,0,0,sx,sy)
      -- love.graphics.draw(self.AccessButton.Image,0,0,0,sx,sy)
    else
      love.graphics.setColor(1,1,1,1)
      self.AccessButton.Image:draw(self.AccessButton.size.width*0.05,self.AccessButton.size.height*0.05,0,0.9*sx,0.9*sy)
      -- love.graphics.draw(self.AccessButton.Image,self.AccessButton.size.width*0.05,self.AccessButton.size.height*0.05,0,0.9*sx,0.9*sy)
    end
    
    
  end
  love.graphics.setCanvas()
  love.graphics.draw(self.AccessButtonCanvas, self.AccessButton.coords.x + 55, self.AccessButton.coords.y + 50)
end

RB.drawPage = function(self)
  local _, _, w, h = self.pages[self.currPage].quads[1]:getViewport()
  local x, y = (self.Book.size.width - w)/2, (self.Book.size.height - h)/2
  love.graphics.setColor(1,1,1,1)
  if self.pages[1] then self.pages[1]:draw(-100,70,0,0.8,0.8) end--love.graphics.draw(self.pages[self.currPage], x, y) end
end

RB.drawRulesBook = function(self)
  love.graphics.setCanvas(self.ScreenCanvas)
  love.graphics.clear(0,0,0,0.5)

  love.graphics.setCanvas(self.BookCanvas)
  love.graphics.clear(0,0,0,0)
  
  self:drawPage()
  love.graphics.setColor(0,0,1)
  local pages = self.pageButtons
  local nsx, nsy = self.Book.next.size.width/pages[2]:getWidth(), self.Book.next.size.height/pages[2]:getHeight()
  local psx, psy = self.Book.prev.size.width/pages[1]:getWidth(), self.Book.prev.size.height/pages[1]:getHeight()
  local csx, csy = self.Book.close.size.width/pages[3]:getWidth(), self.Book.close.size.height/pages[3]:getHeight()
  if self.nextHovered then
    -- love.graphics.rectangle("fill", self.Book.next.coords.x, self.Book.next.coords.y, self.Book.next.size.width, self.Book.next.size.height )
    -- love.graphics.setColor(1,1,1,0)--0.5)
    
    -- love.graphics.draw(pages[2], self.Book.next.coords.x, self.Book.next.coords.y, 0, nsx, nsy)
  else
    -- love.graphics.rectangle("line", self.Book.next.coords.x, self.Book.next.coords.y, self.Book.next.size.width, self.Book.next.size.height )
    -- love.graphics.setColor(1,1,1,0)
    -- love.graphics.draw(pages[2],self.Book.next.coords.x + self.Book.next.size.width*0.05, self.Book.next.coords.y + self.Book.next.size.height*0.05, 0, 0.9*nsx, 0.9*nsy)
  end
  if self.prevHovered then
    -- love.graphics.rectangle("fill", self.Book.prev.coords.x, self.Book.prev.coords.y, self.Book.prev.size.width, self.Book.prev.size.height )
    -- love.graphics.setColor(1,1,1,0)--0.5)
    -- love.graphics.draw(pages[1], self.Book.prev.coords.x, self.Book.prev.coords.y, 0, psx, psy)
  else
    -- love.graphics.rectangle("line", self.Book.prev.coords.x, self.Book.prev.coords.y, self.Book.prev.size.width, self.Book.prev.size.height )
    -- love.graphics.setColor(1,1,1,0)
    -- love.graphics.draw(pages[1], self.Book.prev.coords.x + self.Book.prev.size.width*0.05, self.Book.prev.coords.y + self.Book.prev.size.height*0.05, 0, 0.9*psx, 0.9*psy)
  end
  if self.closeHovered then
    -- love.graphics.rectangle("fill", self.Book.close.coords.x, self.Book.close.coords.y, self.Book.close.size.width, self.Book.close.size.height )
    love.graphics.setColor(1,1,1,1)--0.5)
    love.graphics.draw(pages[3], self.Book.close.coords.x, self.Book.close.coords.y, 0, csx, csy)
  else
    -- love.graphics.rectangle("line", self.Book.close.coords.x, self.Book.close.coords.y, self.Book.close.size.width, self.Book.close.size.height )
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(pages[3], self.Book.close.coords.x + self.Book.close.size.width*0.05, self.Book.close.coords.y + self.Book.close.size.height*0.05, 0, 0.9*csx, 0.9*csy)
  end
  love.graphics.setColor(1,0,0)
  
  love.graphics.setCanvas()
end

RB.draw = function(self, canvas)
  local sw, sh = love.graphics.getDimensions()
  local cw, ch = self.BookCanvas:getDimensions()
  local cbw, cbh = self.AccessButtonCanvas:getDimensions()
  
  if self.drawUI then
    if self.drawPageUpdate or self.pages[1].type == "animation" then 
      -- print(1,1,1,1)
      self:drawRulesBook()
    end
    love.graphics.setColor(1,1,1,1)--0.5)
    love.graphics.draw(self.ScreenCanvas)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.BookCanvas, self.Book.coords.x, self.Book.coords.y)
  elseif self.drawAB then
    if self.ABUpdate then
      self:drawRulesButton()
    end
  end

end

RB.mousepressed = function(self, x,y)
  if self.buttonHovered then 
    self:ChangeBookState(not self.drawUI) 
    self.ABUpdate = true
  elseif self.closeHovered then 
    self:ChangeBookState(not self.drawUI) 
    -- self.ABUpdate = true
  elseif self.nextHovered then 
    
    self:TurnPage(true)
    self.drawPageUpdate = true
  elseif self.prevHovered then 
    
    self:TurnPage(false) 
    self.drawPageUpdate = true
  end
end

return RB