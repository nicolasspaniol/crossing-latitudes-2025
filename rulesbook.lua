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
RB.pageNum = 3
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
  RB.BookCanvas = love.graphics.newCanvas(cw, ch)
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
    coords = { x = RB.Book.size.width*0.8,  y = 0},
    size = { width = RB.Book.size.width*0.2, height = RB.Book.size.width*0.2 }
  }
  RB.pageNum = #pages
  for i=1,#pages do
    RB.pages[#RB.pages+1] = pages[i]
  end
  RB.AccessButton.Image = aButton
  RB.pageButtons = { prevI, nextI, closeI }
  
end

RB.update = function(mx, my)
  print(RB.currPage)
  if RB.drawUI then
    
    local x1, x2 = RB.Book.coords.x, RB.Book.coords.x + RB.Book.size.width
    local y1, y2 = RB.Book.coords.y, RB.Book.coords.y + RB.Book.size.height
    local cx1, cx2 = x1 + RB.Book.close.coords.x, x1 + RB.Book.close.coords.x + RB.Book.close.size.width
    local cy1, cy2 = y1 + RB.Book.close.coords.y, y1 + RB.Book.close.coords.y + RB.Book.close.size.height
    local px1, px2 = x1 + RB.Book.prev.coords.x,  x1 + RB.Book.prev.coords.x + RB.Book.prev.size.width
    local py1, py2 = y1 + RB.Book.prev.coords.y,  y1 + RB.Book.prev.coords.y + RB.Book.prev.size.height
    local nx1, nx2 = x1 + RB.Book.next.coords.x,  x1 + RB.Book.next.coords.x + RB.Book.next.size.width
    local ny1, ny2 = y1 + RB.Book.next.coords.y,  y1 + RB.Book.next.coords.y + RB.Book.next.size.height

    if mx > cx1 and mx < cx2 and my > cy1 and my < cy2 then
      if RB.pageTurned then
        RB.drawPageUpdate = true
        RB.pageTurned = false
      elseif not RB.closeHovered then RB.drawPageUpdate = true else RB.drawPageUpdate = false end
      RB.nextHovered = false
      RB.prevHovered = false
      RB.closeHovered = true
    elseif mx > nx1 and mx < nx2 and my > ny1 and my < ny2 then
      if RB.pageTurned then
        RB.drawPageUpdate = true
        RB.pageTurned = false
      elseif not RB.nextHovered then RB.drawPageUpdate = true else RB.drawPageUpdate = false end
      RB.nextHovered = true
      RB.prevHovered = false
      RB.closeHovered = false
    elseif mx > px1 and mx < px2 and my > py1 and my < py2 then
      if RB.pageTurned then
        RB.drawPageUpdate = true
        RB.pageTurned = false
      elseif not RB.prevHovered then RB.drawPageUpdate = true else RB.drawPageUpdate = false end
      RB.nextHovered = false
      RB.prevHovered = true
      RB.closeHovered = false
    else
      if RB.pageTurned then
        RB.drawPageUpdate = true
        RB.pageTurned = false
      elseif RB.nextHovered or RB.prevHovered or RB.closeHovered or RB.buttonHovered
      then RB.drawPageUpdate = true else RB.drawPageUpdate = false end
      RB.nextHovered = false
      RB.prevHovered = false
      RB.closeHovered = false
    end
    RB.buttonHovered = false
  else
    RB.drawPageUpdate = false
    RB.nextHovered = false
    RB.prevHovered = false
    RB.closeHovered = false

    local x1, x2 = RB.AccessButton.coords.x, RB.AccessButton.coords.x + RB.AccessButton.size.width
    local y1, y2 = RB.AccessButton.coords.y, RB.AccessButton.coords.y + RB.AccessButton.size.height
    print(x1,x2,y1,y2,mx,my)
    if mx > x1 and mx < x2 and my > y1 and my < y2 then 
      if not RB.buttonHovered then RB.ABUpdate = true end
      RB.buttonHovered = true
      -- RB.drawPageUpdate = true
    else 
      if RB.buttonHovered then RB.ABUpdate = true end
      RB.buttonHovered = false
    end
  end
end

RB.ChangeBookState = function(open)
  if open then 
    
    RB.drawUI = true
    RB.drawAB = false
    RB.currPage = 1
  elseif not open then 
    RB.drawUI = false
    RB.drawAB = true
  end
end

RB.TurnPage = function(isNext)
  if isNext then
    RB.currPage = RB.currPage % 3 + 1
  else
    RB.currPage = RB.currPage - 1 % 3
    if RB.currPage == 0 then RB.currPage = 3 end
  end
  RB.pageTurned = true
end



RB.drawRulesButton = function(canvas)
  love.graphics.setCanvas(RB.AccessButtonCanvas)
  love.graphics.clear(0,0,0)
  love.graphics.setColor(1,1,1)
  if RB.AccessButton.Image then
    local sx, sy = RB.AccessButton.size.width/RB.AccessButton.Image:getWidth(), RB.AccessButton.size.height/RB.AccessButton.Image:getHeight()
    if RB.buttonHovered then
      love.graphics.setColor(1,1,1,1)--0.5)
      love.graphics.draw(RB.AccessButton.Image,0,0,0,sx,sy)
    else
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(RB.AccessButton.Image,RB.AccessButton.size.width*0.05,RB.AccessButton.size.height*0.05,0,0.9*sx,0.9*sy)
    end
    
    
  end
  love.graphics.setCanvas()
  love.graphics.draw(RB.AccessButtonCanvas, RB.AccessButton.coords.x, RB.AccessButton.coords.y)
end

RB.drawPage = function()
  local w, h = RB.pages[RB.currPage]:getDimensions()
  local x, y = (RB.Book.size.width - w)/2, (RB.Book.size.height - h)/2
  love.graphics.setColor(1,1,1,1)
  if RB.pages[RB.currPage] then love.graphics.draw(RB.pages[RB.currPage], x, y) end
end

RB.drawRulesBook = function()
  love.graphics.setCanvas(RB.ScreenCanvas)
  love.graphics.clear(0,0,0)

  love.graphics.setCanvas(RB.BookCanvas)
  love.graphics.clear(0,0,0)
  
  RB.drawPage()
  love.graphics.setColor(0,0,1)
  local pages = RB.pageButtons
  local nsx, nsy = RB.Book.next.size.width/pages[2]:getWidth(), RB.Book.next.size.height/pages[2]:getHeight()
  local psx, psy = RB.Book.prev.size.width/pages[1]:getWidth(), RB.Book.prev.size.height/pages[1]:getHeight()
  local csx, csy = RB.Book.close.size.width/pages[3]:getWidth(), RB.Book.close.size.height/pages[3]:getHeight()
  if RB.nextHovered then
    -- love.graphics.rectangle("fill", RB.Book.next.coords.x, RB.Book.next.coords.y, RB.Book.next.size.width, RB.Book.next.size.height )
    love.graphics.setColor(1,1,1,1)--0.5)
    
    love.graphics.draw(pages[2], RB.Book.next.coords.x, RB.Book.next.coords.y, 0, nsx, nsy)
  else
    -- love.graphics.rectangle("line", RB.Book.next.coords.x, RB.Book.next.coords.y, RB.Book.next.size.width, RB.Book.next.size.height )
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(pages[2],RB.Book.next.coords.x + RB.Book.next.size.width*0.05, RB.Book.next.coords.y + RB.Book.next.size.height*0.05, 0, 0.9*nsx, 0.9*nsy)
  end
  if RB.prevHovered then
    -- love.graphics.rectangle("fill", RB.Book.prev.coords.x, RB.Book.prev.coords.y, RB.Book.prev.size.width, RB.Book.prev.size.height )
    love.graphics.setColor(1,1,1,1)--0.5)
    love.graphics.draw(pages[1], RB.Book.prev.coords.x, RB.Book.prev.coords.y, 0, psx, psy)
  else
    -- love.graphics.rectangle("line", RB.Book.prev.coords.x, RB.Book.prev.coords.y, RB.Book.prev.size.width, RB.Book.prev.size.height )
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(pages[1], RB.Book.prev.coords.x + RB.Book.prev.size.width*0.05, RB.Book.prev.coords.y + RB.Book.prev.size.height*0.05, 0, 0.9*psx, 0.9*psy)
  end
  if RB.closeHovered then
    -- love.graphics.rectangle("fill", RB.Book.close.coords.x, RB.Book.close.coords.y, RB.Book.close.size.width, RB.Book.close.size.height )
    love.graphics.setColor(1,1,1,1)--0.5)
    love.graphics.draw(pages[3], RB.Book.close.coords.x, RB.Book.close.coords.y, 0, csx, csy)
  else
    -- love.graphics.rectangle("line", RB.Book.close.coords.x, RB.Book.close.coords.y, RB.Book.close.size.width, RB.Book.close.size.height )
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(pages[3], RB.Book.close.coords.x + RB.Book.close.size.width*0.05, RB.Book.close.coords.y + RB.Book.close.size.height*0.05, 0, 0.9*csx, 0.9*csy)
  end
  love.graphics.setColor(1,0,0)
  
  love.graphics.setCanvas()
end

RB.draw = function(canvas)
  local sw, sh = love.graphics.getDimensions()
  local cw, ch = RB.BookCanvas:getDimensions()
  local cbw, cbh = RB.AccessButtonCanvas:getDimensions()
  
  if RB.drawUI then
    if RB.drawPageUpdate then 
      -- print(1,1,1,1)
      RB.drawRulesBook()
    end
    love.graphics.setColor(1,1,1,1)--0.5)
    love.graphics.draw(RB.ScreenCanvas)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(RB.BookCanvas, RB.Book.coords.x, RB.Book.coords.y)
  elseif RB.drawAB then
    if RB.ABUpdate then
      RB.drawRulesButton()
    end
  end

end

RB.mousepressed = function(x,y)
  if RB.buttonHovered then 
    RB.ChangeBookState(not RB.drawUI) 
    RB.ABUpdate = true
  elseif RB.closeHovered then 
    RB.ChangeBookState(not RB.drawUI) 
    -- RB.ABUpdate = true
  elseif RB.nextHovered then 
    
    RB.TurnPage(true)
    RB.drawPageUpdate = true
  elseif RB.prevHovered then 
    
    RB.TurnPage(false) 
    RB.drawPageUpdate = true
  end
end

return RB