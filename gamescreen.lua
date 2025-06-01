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
GS.DocImages = {
  love.graphics.newImage("assets/driver_template.jpg"), 
  love.graphics.newImage("assets/identity_template.jpg"), 
  love.graphics.newImage("assets/passport_template.jpg")
}


GS.load = function()
  local img = love.graphics.newImage("assets/news/0.jpg")
  local f = io.open("setPoints.json", "r")
  local points = json.decode(f:read("*a"))
  f:close()
  x1, y1 = 300, 50
  GS.doc = Document.new(800, 200, 300, 200, love.graphics.newImage("assets/passport_template.jpg"))
  GS.colSrc = CollageSource.new(love.graphics.newImage("assets/news/0.jpg"), points)
  GS.colSrc:setTransform(love.math.newTransform(x1, y1, 0, .31, .31))
  GS.collages = {}
  GS.currentCollage = nil

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
  GS.spriteInfo["reset_button_spritesheet.png"].width*scale, GS.spriteInfo["reset_button_spritesheet.png"].height*scale, function() GS.load() end)
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
  GS.RB:draw()
  
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
  if GS.currentCollage then
    print(inspect(GS.currentCollage))
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
  if key == 'q' then
    love.event.quit()
  end
  if key == 'escape' then
    GS.colSrc:cancelSelection()
  end
end

GS.ScanDocument = function()
  local x = GS.doc.button.coords.x + GS.doc.button.size.width/2
  local y = GS.doc.button.coords.y + GS.doc.button.size.height/2
  if x > 1102 and  x < 1202 and y > 126 and y < 226 then
    local points_sum = 0
    local v_number = 0
    for i=1, #GS.collages do
      
      v_number = v_number + 1
      for name, value in pairs(GS.collages[i].labels)  do
        
        print(points_sum, name)
        if string.find(name, "widearea") then
          points_sum = points_sum - value
        else
          points_sum = points_sum + value
        end
      end
      if v_number == 0 then v_number = 1 end
     
      print(points_sum, #GS.collages[i].labels)
    end
     points_sum = points_sum / v_number
    print(points_sum)
    if points_sum > 0.6 then
      love.graphics.setFont(love.graphics.newFont(40))
      love.graphics.printf("YOU'VE DONE IT!!", 0, 0, 100000)
    else
      love.graphics.setFont(love.graphics.newFont(40))
      love.graphics.printf("TOO BAD. AGAIN...", 0, 0, 100000)
      GS.load()
    end


  end

end

return GS
