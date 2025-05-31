Buttons = {}

Buttons.new = function(self, image, x, y, width, height, actionFunction, object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    object.coords = { x = x, y = y }
    object.size = { width = width, height = height }
    object.action = actionFunction
    object.isHovered = false
    object.inScreen = false
    object.drawUpdate = true
    object.image = image
    return object
end


Buttons.update = function(self, mx, my, dt)
    if self.inScreen then
        local x1, x2 = self.coords.x, self.coords.x + self.size.width
        local y1, y2 = self.coords.y, self.coords.y + self.size.height
        if mx > x1 and mx < x2 and my > y1 and my < y2 then
            if not self.isHovered then self.drawUpdate = true end
            self.isHovered = true
        else
            if self.isHovered then self.drawUpdate = true end
            self.isHovered = false
        end
        if (self.image.type or "") == "animation" then 
        self.image:update(dt)
        end
    else
        self.drawUpdate = false
        self.isHovered = false
    end
    
end

Buttons.draw = function(self, inCanvas, xCanvas, yCanvas)
    self.drawUpdate = false
    local sM = 0.9
    if self.isHovered then
        sM = 1
    end
    if (self.image.type or "") == "animation" then
        self.drawUpdate = true
        local _, _, qw, qh = self.image.quads[1]:getViewport()
        local sx, sy = self.size.width/qw, self.size.height/qh
        
        local x, y = (xCanvas or 0) + (1-sM)/2 * self.size.width, (yCanvas or 0) + (1-sM)/2 * self.size.height
        if not inCanvas then x, y = self.coords.x + (1-sM)/2 * self.size.width, self.coords.y + (1-sM)/2 * self.size.height end
        self.image:draw(x, y, 0, sM*sx, sM*sy)
    else
        local iw, ih = self.image:getDimensions()
        local x, y = (xCanvas or 0) + (1-sM)/2 * self.size.width, (yCanvas or 0) + (1-sM)/2 * self.size.height
        if not inCanvas then x, y = self.coords.x + (1-sM)/2 * self.size.width, self.coords.y + (1-sM)/2 * self.size.height end
        love.graphics.draw(self.image, x, y , 0, sM*self.size.width/iw, sM*self.size.height/ih) 
    end
end


Buttons.mousepressed = function(self)
    if self.isHovered then
        self:action()
    end
end

return Buttons