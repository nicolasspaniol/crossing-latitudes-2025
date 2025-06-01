local inspect = require "inspect/inspect"


--- @class MoveSource
local MoveSource = {}
MoveSource.__index = MoveSource


--- @param cnv love.Canvas
--- @param transform love.Transform
function MoveSource.new(cnv, transform, poly, labels)
  local t = {
    cnv = cnv,
    tfm = transform:clone(),
    moved = love.math.newTransform(),
    rel = love.math.newTransform(),
    poly = poly,
    labels = labels,
    pressed = false,
  }
  setmetatable(t, MoveSource)
  return t
end


function MoveSource:draw()
  love.graphics.replaceTransform(love.math.newTransform())

  local x, y = love.mouse.getPosition()
  if self.pressed then
    self.moved:setTransformation(x, y)
  end

  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.cnv, self.rel * self.moved * self.tfm)

  love.graphics.replaceTransform(self.rel * self.moved * self.tfm)
  love.graphics.setLineWidth(3)
  local lc = self.poly[1]

  for i = 2, self.poly:len() do
    local c = self.poly[i]
    love.graphics.setColor(1,1,1,1)
    love.graphics.line(lc[1], lc[2], c[1], c[2])
    lc = c
  end
  love.graphics.line(lc[1], lc[2], unpack(self.poly[1]))

  love.graphics.replaceTransform(love.math.newTransform())
end


function MoveSource:mousepressed(x, y, key)
  if key == 1 then
    local ix, iy = self.tfm:inverseTransformPoint(x, y)
    local ox, oy = self.tfm:transformPoint(0, 0)

    if not self.pressed and self.poly:isInside(ix, iy) then
      self.pressed = true
      self.rel:setTransformation(ox - x, oy - y)
    else
      self.pressed = false
      self.moved:setTransformation(0, 0)
      self.rel:setTransformation(0, 0)
    end
  end
end


return MoveSource
