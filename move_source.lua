--- @class MoveSource
local MoveSource = {}
MoveSource.__index = MoveSource


--- @param cnv love.Canvas
--- @param transform love.Transform
function MoveSource.new(cnv, transform)
  local t = {
    cnv = cnv,
    tfm = transform:clone(),
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
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.cnv, self.tfm)
end


function MoveSource:mousemoved()
  local x, y = love.mouse.getPosition()
  if self.pressed then
    local xs = math.min(math.max(x-self.dx, 0), self.winw-self.dx)
    local ys = math.min(math.max(y-self.dy, 0), self.winh-self.dy)
    local xo, yo = self.tfm:transformPoint(0,0)
    self.tfm = self.tfm:translate(xs-xo, ys-yo)
    if (x < 1 or x > self.winw-2) or (y < 1 or y > self.winh-2) then
      self.pressed = false
    end
  end
end


function MoveSource:mousepressed(x, y, key)
  if key == 1 then
    if self.pressed then
      local xo, yo = self.tfm:transformPoint(0,0)
      self.tfm = self.tfm:translate(x-xo-self.dx, y-yo-self.dy)
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
