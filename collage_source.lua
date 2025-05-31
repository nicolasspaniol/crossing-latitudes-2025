local inspect = require "inspect/inspect"


--- @class CollageSource
local CollageSource = {}
CollageSource.__index = CollageSource


local function dist(xa, ya, xb, yb)
  local dx = xa - xb
  local dy = ya - yb

  return math.sqrt(dx * dx + dy * dy)
end


--- @param img love.Image
function CollageSource.new(img)
  local w, h = img:getDimensions()

  local o = {
    cnv = love.graphics.newCanvas(w, h),
    transform = love.math.newTransform(),
    coords = {},
    closed = false
  }

  o.cnv:renderTo(function()
    local col = {love.graphics.getColor()}
    love.graphics.setColor(1,1,1)
    love.graphics.draw(img, 0, 0, 0)
    love.graphics.setColor(col)
  end)

  setmetatable(o, CollageSource)
  return o
end


function CollageSource:draw()
  love.graphics.setColor(1,1,1)

  love.graphics.draw(self.cnv, self.transform)
end


function CollageSource:debugPoints()
  if #self.coords == 0 then return end

  love.graphics.setColor(1,1,1)

  local mx, my = love.mouse.getPosition()
  local lx, ly = self.transform:transformPoint(unpack(self.coords[1]))

  for _, c in ipairs(self.coords) do
    local x, y = self.transform:transformPoint(unpack(c))
    love.graphics.line(lx, ly, x, y)
    lx, ly = x, y
  end

  if self.closed then
    love.graphics.line(lx, ly, unpack(self.coords[1]))
  else
    love.graphics.line(lx, ly, mx, my)
  end
end


--- @param transform love.Transform
function CollageSource:setTransform(transform)
  self.transform = transform
end


function CollageSource:mousepressed(x, y, button)
  if self.closed then return end

  local transform = self.transform:inverse()
  x, y = transform:transformPoint(x, y)

  if button == 1 then
    for _, c in ipairs(self.coords) do
      if dist(x, y, unpack(c)) < 200 and #self.coords > 2 then
        self.closed = true
        return
      end
    end

    table.insert(self.coords, {x, y})
  end
end


function CollageSource:mousemoved(x, y)
  if not self.closed then return end
end


--- @return love.Canvas | nil
function CollageSource:getSlice()
  if not self.closed then return nil end

  local poly = {}
  for _, c in ipairs(self.coords) do
    table.insert(poly, c[1])
    table.insert(poly, c[2])
  end

  local tris = love.math.triangulate(poly)

  local w, h = self.cnv:getDimensions()
  local cnv = love.graphics.newCanvas(w, h)

  cnv:renderTo(function()
    local bMode = love.graphics.getBlendMode()
    local col = {love.graphics.getColor()}

    love.graphics.clear(0,0,0)

    love.graphics.setColor(1,1,1)

    for _, tri in ipairs(tris) do
      love.graphics.polygon("fill", tri)
    end

    love.graphics.setBlendMode("multiply", "premultiplied")

    love.graphics.draw(self.cnv)

    love.graphics.setColor(col)
    love.graphics.setBlendMode(bMode)
  end)

  self.cnv:renderTo(function()
    love.graphics.setColor(0,0,0)

    for _, tri in ipairs(tris) do
      love.graphics.polygon("fill", tri)
    end
  end)

  -- reset poly selection
  self.closed = false
  self.coords = {}

  return nil
end


return CollageSource
