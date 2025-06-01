local inspect = require "inspect/inspect"
local MoveSource = require "move_source"
local Poly = require "poly"


DISTANCE_TO_CLOSE = 20
DASH_INCREMENT = .1


--- @class CollageSource
local CollageSource = {}
CollageSource.__index = CollageSource


--- @param poly Poly
function CollageSource:intersectPolyPoints()
  local contains = {}
  for label, ps in pairs(self.points) do
    contains[label] = 0

    for i = 1, #ps, 2 do
      local x, y = self.transform:inverseTransformPoint(ps[i], ps[i + 1])
      if self.poly:isInside(x, y) then
        contains[label] = contains[label] + 1
      end
    end

    contains[label] = contains[label] * 2 / #ps
  end
end


local function dist(xa, ya, xb, yb)
  local dx = xa - xb
  local dy = ya - yb

  return math.sqrt(dx * dx + dy * dy)
end


local function insideRect(x, y, xa, ya, xb, yb)
  return x <= xb and x >= xa and y <= yb and y >= ya
end


local function drawDashedLine(xa, ya, xb, yb)
  local dx = xb - xa
  local dy = yb - ya

  local fill = false
  local x, y = xa, ya
  local lx, ly = xa, ya
  local n = dist(xa, ya, xb, yb) / 100
  local i = (2 * love.timer.getTime() % 1) * 2 * DASH_INCREMENT / n

  while i < 1 do
    fill = not fill

    x = xa + dx * i
    y = ya + dy * i

    if fill then
      love.graphics.line(lx, ly, x, y)
    end

    lx, ly = x, y

    i = i + DASH_INCREMENT / n
  end

  if fill then
    love.graphics.line(lx, ly, xb, yb)
  end
end


--- @param img love.Image
function CollageSource.new(img, points)
  local w, h = img:getDimensions()

  local o = {
    points = points,
    cnv = love.graphics.newCanvas(w, h),
    transform = love.math.newTransform(),
    poly = Poly.new(),
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
  local blendMode = {love.graphics.getBlendMode()}
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.cnv, self.transform)
  love.graphics.setBlendMode(unpack(blendMode))

  self:drawLines()
end


function CollageSource:drawLines()
  if self.poly:len() == 0 then return end

  love.graphics.setColor(1, 1, 1)

  local mx, my = love.mouse.getPosition()
  local lx, ly = self.transform:transformPoint(unpack(self.poly[1]))

  for i = 1, self.poly:len() do
    local c = self.poly[i]
    local x, y = self.transform:transformPoint(unpack(c))
    drawDashedLine(lx, ly, x, y)
    lx, ly = x, y
  end

  -- transform everything to screen coords
  local fx, fy = self.transform:transformPoint(unpack(self.poly[1]))

  if dist(fx, fy, mx, my) < DISTANCE_TO_CLOSE then
    drawDashedLine(lx, ly, fx, fy)
  else
    drawDashedLine(lx, ly, mx, my)
  end
end


--- @param transform love.Transform
function CollageSource:setTransform(transform)
  self.transform = transform
end


function CollageSource:mousepressed(x, y, button)
  if self.poly.closed then return end

  local mx, my = self.transform:inverseTransformPoint(x, y)
  local isInside = insideRect(mx, my, 0, 0, self.cnv:getDimensions())

  if not button == 1 then return end

  if self.poly:len() > 0 then
    local cx, cy = self.transform:transformPoint(unpack(self.poly[1]))
    if dist(x, y, cx, cy) < DISTANCE_TO_CLOSE and self.poly:len() > 2 then
      self.poly.closed = true
      return
    end
  end

  if isInside then
    self.poly:add(self.transform:inverseTransformPoint(x, y))
  end
end


--- @return love.Canvas | nil
function CollageSource:getSlice()
  if not self.poly.closed then return nil end

  local w, h = self.cnv:getDimensions()
  local sliceCnv = love.graphics.newCanvas(w, h)

  sliceCnv:renderTo(function()
    -- love.graphics.setBlendMode("add", "premultiplied")

    love.graphics.clear(0,0,0,0)

    love.graphics.setColor(1,1,1,1)

    self.poly:draw("fill")

    love.graphics.setBlendMode("multiply", "premultiplied")

    love.graphics.draw(self.cnv)
  end)

  self.cnv:renderTo(function()
    love.graphics.setBlendMode("replace", "premultiplied")
    love.graphics.setColor(0,0,0,0)
    self.poly:draw("fill")
  end)

  local slice = MoveSource.new(
    sliceCnv,
    self.transform,
    self.poly,
    self:intersectPolyPoints()
  )

  -- reset poly selection
  self.poly = Poly:new()

  return slice
end


return CollageSource
