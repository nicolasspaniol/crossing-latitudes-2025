local Animation = {}
Animation.type = "animation"

Animation.new = function(self, image, width, height, duration, filterMode)
    local animation = {}
    animation.spriteSheet = image;
    animation.spriteSheet:setFilter(filterMode or "linear", filterMode or "linear")
    animation.quads = {};
    setmetatable(animation, self)
    self.__index = self

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end


Animation.update = function(self, dt)
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end
end

Animation.draw = function(self, x, y, rt, sx, sy)
    local spriteNum = math.floor(self.currentTime / self.duration * #self.quads) + 1
    love.graphics.draw(self.spriteSheet, self.quads[spriteNum], x or 0, y or 0, rt or 0, sx or 0, sy or 0)--, 0, 4)
end

return Animation