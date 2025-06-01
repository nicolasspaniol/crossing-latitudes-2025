local inspect = require "inspect/inspect"
local MoveSource = require "move_source"

DISTANCE_TO_CLOSE = 20
DASH_INCREMENT = .1


--- @class CollageSource
local CollageSource = {}
CollageSource.__index = CollageSource


function CollageSource:intersectPolyPoints(poly)
  local tris = love.math.triangulate(poly)
  for i, tri in ipairs(tris) do
    tris[i] = love.physics.newPolygonShape(tri)
  end

  local contains = {}
  for label, ps in pairs(self.points) do
    contains[label] = 0

    for _, tri in ipairs(tris) do
      for i = 1, #ps, 2 do
        local x, y = self.transform:inverseTransformPoint(ps[i], ps[i + 1])
        if tri:testPoint(0, 0, 0, x, y) then
          contains[label] = contains[label] + 1
        end
      end
    end

    contains[label] = contains[label] * 2 / #ps
  end

  print(inspect(contains))
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
  local blendMode = {love.graphics.getBlendMode()}
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.cnv, self.transform)
  love.graphics.setBlendMode(unpack(blendMode))

  self:drawLine()
end


function CollageSource:drawLine()
  if #self.coords == 0 then return end

  love.graphics.setColor(1, 1, 1)

  local mx, my = love.mouse.getPosition()
  local lx, ly = self.transform:transformPoint(unpack(self.coords[1]))

  for _, c in ipairs(self.coords) do
    local x, y = self.transform:transformPoint(unpack(c))
    drawDashedLine(lx, ly, x, y)
    lx, ly = x, y
  end

  -- transform everything to screen coords
  local fx, fy = self.transform:transformPoint(unpack(self.coords[1]))

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
  if self.closed then return end

  local mx, my = self.transform:inverseTransformPoint(x, y)
  local isInside = insideRect(mx, my, 0, 0, self.cnv:getDimensions())

  if not button == 1 then return end

  if #self.coords > 0 then
    local cx, cy = self.transform:transformPoint(unpack(self.coords[1]))
    if dist(x, y, cx, cy) < DISTANCE_TO_CLOSE and #self.coords > 2 then
      self.closed = true
      return
    end
  end

  if isInside then
    table.insert(self.coords, {self.transform:inverseTransformPoint(x, y)})
  end
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
  local sliceCnv = love.graphics.newCanvas(w, h)

  sliceCnv:renderTo(function()
    -- love.graphics.setBlendMode("add", "premultiplied")

    love.graphics.clear(0,0,0,0)

    love.graphics.setColor(1,1,1,1)

    for _, tri in ipairs(tris) do
      love.graphics.polygon("fill", tri)
    end

    love.graphics.setBlendMode("multiply", "premultiplied")

    love.graphics.draw(self.cnv)
  end)

  self.cnv:renderTo(function()
    for _, tri in ipairs(tris) do
      love.graphics.setBlendMode("replace", "premultiplied")
      love.graphics.setColor(0,0,0,0)
      love.graphics.polygon("fill", tri)
    end
  end)

  self:intersectPolyPoints(poly)

  -- reset poly selection
  self.closed = false
  self.coords = {}

  return MoveSource.new(sliceCnv, self.transform)
end


return CollageSource
