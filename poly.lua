local inspect = require "inspect/inspect"


--- @class Poly
local Poly = {}
Poly.__index = Poly


function Poly.new(raw)
  local o = {
    raw = raw or {},
    tris = nil,
    triShapes = nil,
    closed = false
  }

  setmetatable(o, Poly)
  return o
end


function Poly:genTris()
  if not self.tris then
    self.tris = love.math.triangulate(unpack(self.raw))
  end

  self.triShapes = {}
  for _, tri in ipairs(self.tris) do
    table.insert(self.triShapes, love.physics.newPolygonShape(tri))
  end
end


function Poly:isInside(x, y)
  self:genTris()

  for _, shape in ipairs(self.triShapes) do
    if shape:testPoint(0, 0, 0, x, y) then return true end
  end

  return false
end


function Poly:draw(mode)
  self:genTris()

  for _, tri in ipairs(self.tris) do
    love.graphics.polygon(mode, tri)
  end
end


function Poly:add(x, y)
  table.insert(self.raw, x)
  table.insert(self.raw, y)
end


function Poly:__index(i)
  if type(i) == "number" then
    return {self.raw[i * 2 - 1], self.raw[i * 2]}
  else
    return rawget(Poly, i)
  end
end


function Poly:len()
  return #self.raw / 2
end


return Poly
