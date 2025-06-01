local json = require "json/json"
local GS = {}
local Animation = require "animation"

GS.spriteInfo = json.decode(love.filesystem.read("assets/animations/dims.json"))
GS.Drawer = require "drawer"
GS.RB = require "rulesbook"
GS.DocImages = {
  love.graphics.newImage("assets/driver_template.jpg"), 
  love.graphics.newImage("assets/identity_template.jpg"), 
  love.graphics.newImage("assets/passport_template.jpg")
}


GS.load = function()
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


  GS.resBtt = Animation:new(love.graphics.newImage("assets/animations/reset_button_spritesheet.png"), 
    GS.spriteInfo["reset_button_spritesheet.png"].width, GS.spriteInfo["reset_button_spritesheet.png"].height, 
    GS.spriteInfo["reset_button_spritesheet.png"].duration, "linear")
    -- print(love.graphics.newImage("assets/animations/game_bg_spritesheet.jpg"), 
    -- GS.spriteInfo["game_bg_spritesheet.jpg"].width == 1920, GS.spriteInfo["game_bg_spritesheet.jpg"].height == 1080, 
    -- GS.spriteInfo["game_bg_spritesheet.jpg"].duration == 5, "linear")
  -- local pages = {}
  -- GS.RB.createEntities( {} GS.spriteInfo["rulebook_spritesheet.png"], )
end

GS.update = function(dt)
  local mx, my = love.mouse.getPosition()
  
  GS.backImage:update(dt)
  
  GS.resBtt:update(dt)
  if not GS.RB.drawUI then
    GS.Drawer:update(mx, my, dt)
  end
  GS.RB:update(mx, my, dt)
end

GS.draw = function()
  -- print(GS.spriteInfo["game_bg_spritessheet.jpg"].scale)
  GS.backImage:draw(0,0,0,GS.spriteInfo["game_bg_spritesheet.png"].scale, GS.spriteInfo["game_bg_spritesheet.png"].scale)
  GS.resBtt:draw(GS.spriteInfo["reset_button_spritesheet.png"].x,GS.spriteInfo["reset_button_spritesheet.png"].y,
  0,GS.spriteInfo["reset_button_spritesheet.png"].scale,GS.spriteInfo["reset_button_spritesheet.png"].scale)


  GS.Drawer:draw()
  GS.RB:draw()
  
end

GS.mousepressed = function()
  if not GS.RB.drawUI then
    GS.Drawer:mousepressed()
  end
  GS.RB:mousepressed()
end

return GS
