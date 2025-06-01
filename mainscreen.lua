local json = require "json/json"
local Button = require "buttons"
local Animation = require "animation"

--- @class MainScreen
local MainScreen = {}
MainScreen.__index = MainScreen
MainScreen.spriteInfo = json.decode(love.filesystem.read("assets/animations/dims.json"))


function MainScreen.new(func)
  local w, h = love.graphics.getDimensions()
  local backImage = Animation:new(love.graphics.newImage("assets/animations/main_menu_spritesheet.png"),
    MainScreen.spriteInfo["main_menu_spritesheet.png"].width, MainScreen.spriteInfo["main_menu_spritesheet.png"].height,
    1, "linear")
  local o = {
    w = w,
    h = h,
    background = backImage,
    buttons = {}
    }
  o.buttons[1] = Button:new(love.graphics.newImage("assets/play.png"), w/2-w/5, 7*h/12-h/24, w/5, h/6, func)
  o.buttons[1].inScreen = true
  o.buttons[2] = Button:new(love.graphics.newImage("assets/quit.png"), w/2, 7*h/12-h/24, w/5, h/6, love.event.quit)
  o.buttons[2].inScreen = true
  setmetatable(o, MainScreen)
  return o
end

function MainScreen:update(dt)
  local mx, my = love.mouse.getPosition()
  self.background:update(dt)
  for _, btn in ipairs(self.buttons) do
    btn:update(mx, my, dt)
  end
end

function MainScreen:draw()
  self.background:draw(0,0,0,self.spriteInfo["main_menu_spritesheet.png"].scale, self.spriteInfo["main_menu_spritesheet.png"].scale)
  for i, btn in ipairs(self.buttons) do
    btn:draw()
  end
end

function MainScreen:mousepressed(x, y, key)
  for _, btn in ipairs(self.buttons) do
    btn:mousepressed(x, y, key)
  end
end

return MainScreen
