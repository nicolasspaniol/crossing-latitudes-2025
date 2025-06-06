local json = require "json/json"
local GS = {}
local Animation = require "animation"
local Buttons = require "buttons"
local Document = require "document"
-- local json = require "json/json"
local CollageSource = require "collage_source"
local inspect = require "inspect/inspect"

GS.spriteInfo = json.decode(love.filesystem.read("assets/animations/dims.json"))
GS.Drawer = require "drawer"
GS.RB = require "rulesbook"
GS.document = {"assets/passport_template.jpg", "assets/driver_template.jpg", "assets/identity_template.jpg"}
GS.news = {"assets/news/0.jpg", "assets/news/1.jpg", "assets/news/9.jpg"}
GS.request = {"assets/reqPass0.png", "assets/reqCNH01.png", "assets/reqId09.png"}
GS.json = {"assets/points1.json", "assets/points2.json", "assets/points3.json"}
GS.currIDX = 1
GS.printSomething = nil
GS.timerPS = 0
GS.font = love.graphics.newFont("assets/pixelated.ttf", 80)
GS.font:setFilter("nearest", "nearest")

GS.load = function(news, request, cjson, document)
  local img = love.graphics.newImage(news)
  local points = json.decode(love.filesystem.read(cjson))
  x1, y1 = 300, 50
  GS.doc = Document.new(800, 200, 300, 200, love.graphics.newImage(document))
  GS.colSrc = CollageSource.new(love.graphics.newImage(news), points)
  GS.colSrc:setTransform(love.math.newTransform(x1, y1, 0, .31, .31))
  GS.collages = {}
  GS.currentCollage = nil
  GS.aRequest = love.graphics.newImage(request)

  local closedDrawer =  Animation:new(love.graphics.newImage("assets/animations/stamps_closed_spritesheet.png"), 
  GS.spriteInfo["stamps_closed_spritesheet.png"].width, GS.spriteInfo["stamps_closed_spritesheet.png"].height, 
  GS.spriteInfo["stamps_closed_spritesheet.png"].duration, "linear")

  local openDrawer = Animation:new(love.graphics.newImage("assets/animations/stamps_spritesheet.png"), 
  GS.spriteInfo["stamps_spritesheet.png"].width, GS.spriteInfo["stamps_spritesheet.png"].height, 
  GS.spriteInfo["stamps_spritesheet.png"].duration, "linear")

  local xSign = love.graphics.newImage("assets/x_close.png")


  GS.Drawer.createEntities(GS.spriteInfo["stamps_spritesheet.png"].x, GS.spriteInfo["stamps_spritesheet.png"].y, 
  GS.spriteInfo["stamps_spritesheet.png"].width, GS.spriteInfo["stamps_spritesheet.png"].height, 
  {{love.graphics.newImage("assets/br.png"), love.graphics.newImage("assets/br.png")}, 
  {love.graphics.newImage("assets/fi.png"), love.graphics.newImage("assets/fi.png")}, 
  {love.graphics.newImage("assets/nl.png"), love.graphics.newImage("assets/nl.png")}}, closedDrawer, xSign, openDrawer, 1, 1
  )


  local RuleBookPages = Animation:new(love.graphics.newImage("assets/animations/manual_spritesheet.png"),
  GS.spriteInfo["manual_spritesheet.png"].width, GS.spriteInfo["manual_spritesheet.png"].height,
  GS.spriteInfo["manual_spritesheet.png"].duration, "linear")

  local RuleBookAcc = Animation:new(love.graphics.newImage("assets/animations/rulebook_spritesheet.png"),
  GS.spriteInfo["rulebook_spritesheet.png"].width, GS.spriteInfo["rulebook_spritesheet.png"].height,
  GS.spriteInfo["rulebook_spritesheet.png"].duration, "linear")

  local RuleBookNext = love.graphics.newImage("assets/Empty.png")

  local RuleBookClose = love.graphics.newImage("assets/x_close.png")

  GS.RB.createEntities({RuleBookPages}, RuleBookNext, RuleBookNext, RuleBookClose, RuleBookAcc)


  GS.backImage = Animation:new(love.graphics.newImage("assets/animations/game_bg_spritesheet.png"), 
    GS.spriteInfo["game_bg_spritesheet.png"].width, GS.spriteInfo["game_bg_spritesheet.png"].height, 
    1, "linear")

  


  -- GS.backImage = Animation:new(love.graphics.newImage("game_bg_spritesheet.png"),)


  local resBtt = Animation:new(love.graphics.newImage("assets/animations/reset_button_spritesheet.png"), 
    GS.spriteInfo["reset_button_spritesheet.png"].width, GS.spriteInfo["reset_button_spritesheet.png"].height, 
    GS.spriteInfo["reset_button_spritesheet.png"].duration, "linear")
    -- print(love.graphics.newImage("assets/animations/game_bg_spritesheet.jpg"), 
    -- GS.spriteInfo["game_bg_spritesheet.jpg"].width == 1920, GS.spriteInfo["game_bg_spritesheet.jpg"].height == 1080, 
    -- GS.spriteInfo["game_bg_spritesheet.jpg"].duration == 5, "linear")
  -- local pages = {}
  -- GS.RB.createEntities( {} GS.spriteInfo["rulebook_spritesheet.png"], )
  local scale = GS.spriteInfo["reset_button_spritesheet.png"].scale
  GS.ResetButton = Buttons:new(resBtt, GS.spriteInfo["reset_button_spritesheet.png"].x,GS.spriteInfo["reset_button_spritesheet.png"].y,
  GS.spriteInfo["reset_button_spritesheet.png"].width*scale, GS.spriteInfo["reset_button_spritesheet.png"].height*scale, function() GS.load(news, request, cjson, document) end)
  GS.ResetButton.inScreen = true


  local sendBtt = Animation:new(love.graphics.newImage("assets/animations/send_button_spritesheet.png"),
    GS.spriteInfo["send_button_spritesheet.png"].width,  GS.spriteInfo["send_button_spritesheet.png"].height,
    GS.spriteInfo["send_button_spritesheet.png"].duration, "linear")

  local scale2 = GS.spriteInfo["send_button_spritesheet.png"].scale
  GS.SendButton = Buttons:new(sendBtt, GS.spriteInfo["send_button_spritesheet.png"].x, GS.spriteInfo["send_button_spritesheet.png"].y,
  GS.spriteInfo["send_button_spritesheet.png"].width*scale, GS.spriteInfo["send_button_spritesheet.png"].height*scale,
  function() GS.ScanDocument() end
  )
  GS.SendButton.inScreen = true

end

GS.update = function(dt)
  if GS.timerPS then
    GS.timerPS = GS.timerPS + dt
  end
  if GS.timerPS > 3 then
    GS.printSomething = nil
    GS.timerPS = 0
  end
  local mx, my = love.mouse.getPosition()
  -- print(mx, my)
  GS.doc:update(mx, my, dt)
  GS.ResetButton:update(mx, my, dt)
  GS.SendButton:update(mx, my, dt)
  GS.backImage:update(dt)
  
  -- GS.resBtt:update(dt)
  if not GS.RB.drawUI then
    GS.Drawer:update(mx, my, dt)
  end
  GS.RB:update(mx, my, dt)
end

GS.draw1 = function()
  -- print(GS.spriteInfo["game_bg_spritessheet.jpg"].scale)
  GS.backImage:draw(0,0,0,GS.spriteInfo["game_bg_spritesheet.png"].scale, GS.spriteInfo["game_bg_spritesheet.png"].scale)
  -- GS.resBtt:draw(
  -- 0,GS.spriteInfo["reset_button_spritesheet.png"].scale,GS.spriteInfo["reset_button_spritesheet.png"].scale)
  GS.colSrc:draw()
  GS.doc:draw()
  if #GS.collages > 0 then
    for _, collage in ipairs(GS.collages) do
      collage:draw()
    end
  end

end
GS.draw2 = function(inCanvas, xCanvas, yCanvas, Canvas)
  GS.ResetButton:draw()
  GS.SendButton:draw()
  GS.Drawer:draw(inCanvas, xCanvas, yCanvas, Canvas)
  love.graphics.draw(GS.aRequest, 20, 400, 0, 1.5, 1.5)
  GS.RB:draw()
  

  if GS.printSomething == "vitoria" then
    love.graphics.setFont(GS.font)
    love.graphics.setBlendMode( "alpha", "alphamultiply")
    love.graphics.setColor(0,1,0,1)
    
    love.graphics.printf("YOU'VE DONE IT!", 300, 300, 100000, "left", 0)
  elseif GS.printSomething == "derrota" then
    love.graphics.setBlendMode( "alpha", "alphamultiply")
    -- love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.setFont(GS.font)
    love.graphics.setColor(1,0,0,1)
    -- GS.font:setFilter("nearest", "nearest")
    love.graphics.printf("TOO BAD. AGAIN...", 300, 300, 100000, "left", 0)--, 5, 5)
  else
    GS.timerPS = 0
  end


  
end

GS.mousepressed = function(x, y, key)
  if not GS.RB.drawUI then
    GS.Drawer:mousepressed()
  end
  GS.RB:mousepressed()
  GS.ResetButton:mousepressed()
  GS.SendButton:mousepressed()
  if key ~= 1 then return end
  for _, stamp in ipairs(GS.Drawer.stamps) do
    if stamp.following then return end
  end
  if GS.RB.drawUI then GS.colSrc:cancelSelection(); return end
  if GS.currentCollage then
    -- print(inspect(GS.currentCollage))
    if GS.doc:isHovering(x, y) then
      local x1, y1 = GS.colSrc.transform:transformPoint(0,0)
      GS.currentCollage.rel:translate(x - GS.doc.button.coords.x -x1, y - GS.doc.button.coords.y - y1)
      GS.currentCollage.fixed = true
      table.insert(GS.doc.collages, GS.currentCollage)
      GS.currentCollage = nil
      GS.doc:mousepressed(x, y, key, GS.collages, GS.currentCollage)
      GS.doc:draw()
      GS.doc:mousepressed(x, y, key, GS.collages, GS.currentCollage)
      
    else
      GS.currentCollage:mousepressed(x, y, key)
      GS.currentCollage = nil
    end
  else
    for _, collage in ipairs(GS.collages) do
      if not collage.fixed then
        collage:mousepressed(x, y, key)

        if collage.pressed then
          GS.currentCollage = collage
        end
      end
    end

    if not GS.currentCollage and not GS.doc:isHovering(x, y) then
      GS.colSrc:mousepressed(x, y, key)
    end

    local maybeSlice = GS.colSrc:getSlice()
    GS.collages[#GS.collages+1] = maybeSlice

    GS.doc:mousepressed(x, y, key, GS.collages, GS.currentCollage)
  end
end

GS.keypressed = function(key)
  -- if key == 'q' then
  --   love.event.quit()
  -- end
  if key == 'escape' then
    GS.colSrc:cancelSelection()
  end
end

GS.ScanDocument = function()
  local x = GS.doc.button.coords.x + GS.doc.button.size.width/2
  local y = GS.doc.button.coords.y + GS.doc.button.size.height/2
  if x > 1102 and  x < 1202 and y > 126 and y < 226 then
    local points_sum = 0
    local v_number = { 4, 6, 4 }
    for i=1, #GS.collages do
      
      -- v_number = v_number + 1
      for name, value in pairs(GS.collages[i].labels)  do
        
        
        if string.find(name, "widearea") then
          points_sum = points_sum - value 
        else
          points_sum = points_sum + value 
        end
        print(points_sum, name)
      end
      -- if v_number == 0 then v_number = 1 end
     
      print(points_sum, #GS.collages[i].labels)
    end
     points_sum = points_sum / v_number[GS.currIDX]
    print(points_sum)
    if points_sum > 0.6 then
      GS.printSomething = "vitoria"
      GS.currIDX = GS.currIDX % 3 + 1 
      GS.load(GS.news[GS.currIDX], GS.request[GS.currIDX], GS.json[GS.currIDX], GS.document[GS.currIDX])
      
    else
      GS.printSomething = "derrota"
      print(GS.news[GS.currIDX], GS.request[GS.currIDX], GS.json[GS.currIDX], GS.document[GS.currIDX])
      GS.load(GS.news[GS.currIDX], GS.request[GS.currIDX], GS.json[GS.currIDX], GS.document[GS.currIDX])
    end


  end

end

return GS
