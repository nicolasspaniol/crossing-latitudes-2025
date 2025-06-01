local PopUp = {}
local Buttons = require "buttons"
PopUp.UI = {}
PopUp.Btt = {}
-- PopUp.UIOpen = false


PopUp.new = function(self, ux, uy, uw, uh, bx, by, bw, bh, closeImage, bttImage, UIImage , object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    local bttFunction = function(self)
        object:ChangeUIState(not object.UI.inScreen)
    end

    object.UI.canvas = love.graphics.newCanvas(uw, uh)
    object.UI.coords = { x = ux, y = uy}
    object.UI.size = { width = uw, height = uh }
    object.UI.drawUpdate = false
    object.UI.inScreen = false
    object.UI.image = UIImage
    
    object.Btt = Buttons:new(bttImage, bx, by, bw, bh, bttFunction)
    local cx, cy = object.UI.coords.x + object.UI.size.width*0.8, object.UI.coords.y
    local cw, ch = object.UI.size.width*0.2, object.UI.size.width*0.2
    object.UI.close = Buttons:new(closeImage, cx, cy, cw, ch, bttFunction)
    object.Btt.canvas = love.graphics.newCanvas(bw, bh)
    object.Btt.inScreen = true
    return object
end


PopUp.update = function(self, mx, my, dt)
    if self.UI.inScreen then
        self.Btt.isHovered = false
        self:updateUI(mx, my, dt)
        self.UI.close:update(mx, my, dt)
        if self.UI.close.drawUpdate then
            self.UI.drawUpdate = true
        end
    elseif self.Btt.inScreen then
        self.UI.close.isHovered = false
        self.Btt:update(mx, my, dt)
    end
end


PopUp.updateUI = function(self, mx, my, dt) 
end

PopUp.changeUIState = function(self, open)
    if open then
        self.UI.inScreen = true
        self.Btt.inScreen = false
        self.UI.close.inScreen = true
        self.UI.close.drawUpdate = true
    else
        self.UI.inScreen = false
        self.Btt.inScreen = true
        self.UI.close.inScreen = false
        self.Btt.drawUpdate = true
    end
end

PopUp.drawUIClose = function(self)
    if self.UI.close.drawUpdate then
        self.UI.close:draw(true, self.UI.close.coords.x-self.UI.coords.x, self.UI.close.coords.y-self.UI.coords.y)
    end
end

PopUp.drawUI = function(self)

    
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", 0, 0, 5000, 5000)
    
end


PopUp.draw = function(self)
    if self.UI.inScreen then
        if self.UI.drawUpdate then
            self.UI.drawUpdate = false
            if ((self.UI.image or self).type or "") == "animation" then self.UI.drawUpdate = true end
            love.graphics.setCanvas(self.UI.canvas)
            love.graphics.clear(0,0,0,0)

            if self.UI.image then
                local iw, ih = self.UI.image:getDimensions()
                local sx, sy = self.UI.size.width/iw, self.UI.size.height/ih

                love.graphics.draw(self.UI.image, 0, sx, sy)
            end
            self:drawUI()
            self:drawUIClose()
            love.graphics.setCanvas()
        end
        love.graphics.draw(self.UI.canvas, self.UI.coords.x, self.UI.coords.y)
    else
        if self.Btt.drawUpdate then
            
            love.graphics.setColor(1,1,1,1)
            love.graphics.setCanvas(self.Btt.canvas)
            love.graphics.clear(0,0,0,0)
            self.Btt:draw(true)
            love.graphics.setCanvas()
        end
        love.graphics.setColor(1,1,1,1)
        if self.Btt.inScreen then love.graphics.draw(self.Btt.canvas, self.Btt.coords.x, self.Btt.coords.y) end
    end
end

        
PopUp.mousepressed = function(self)
    if self.UI.close.isHovered then
        self:changeUIState(false)
    elseif self.Btt.isHovered then
        self:changeUIState(true)
    end
end
            
return PopUp

