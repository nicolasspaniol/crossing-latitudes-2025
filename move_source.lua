--- @class MoveSource
local MoveSource = {}
MoveSource.__index = MoveSource


function MoveSource.new(object)
  local t = {
    cnv = object.cnv,
    tfm = object.transform,
    winw = love.graphics.getWidth(),
    winh = love.graphics.getHeight(),
    pressed = false,
    dx = 0,
    dy = 0,
    offset = 5
  }
  setmetatable(t, MoveSource)
  return t
end


function MoveSource:draw()
  love.graphics.draw(self.cnv, self.tfm)
end


function MoveSource:mousemoved()
  local x, y = love.mouse.getPosition()
  if self.pressed then
    local xs = math.min(math.max(x-self.dx, 0), self.winw-self.dx)
    local ys = math.min(math.max(y-self.dy, 0), self.winh-self.dy)
    self.tfm:setTransformation(xs, ys)
    if (x < 1 or x > self.winw-2) or (y < 1 or y > self.winh-2) then
      self.pressed = false
    end
  end
end


function MoveSource:mousepressed(x, y, key)
  if key == 1 then
    if self.pressed then
      self.tfm:setTransformation(x-self.dx, y-self.dy)
      self.pressed = false
    else
      local xls, yls = self.tfm:transformPoint(0,0)
      if (x > xls-self.offset and x < xls+self.cnv:getWidth()+self.offset) and (y > yls-self.offset and y < yls+self.cnv:getHeight()+self.offset) then
        self.dx = x - xls
        self.dy = y - yls
        self.pressed = true
      end
    end
  end
end


return MoveSource