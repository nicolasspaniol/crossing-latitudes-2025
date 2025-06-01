local json = require "json/json"
local inspect = require "inspect/inspect"

--- @class takePoints
local takePoints = {}
takePoints.__index = takePoints


function takePoints.new(x, y, width, height)
  local o = {
    topLeft = {x, y},
    bottomRight = {width, height},
    points = {},
    setPoints = {},
    name = '',
    numSets = 0,
  }
  setmetatable(o, takePoints)
  return o
end


local function savePoints(self)
  local file = nil
  file = io.open("setPoints.json", "w")
  if file then
    file:write(json.encode(self.setPoints))
    file:close()
  else
    print("error creating file")
  end
end


local function takeName(self)
  if #self.points > 0 then
    print("digite um nome para o conjunto:")
    self.name = io.read()
    self.numSets = self.numSets + 1
    self.setPoints[self.name] = self.points
    self.points = {}
  end
end


function takePoints:draw()
    for i = 1,#self.points/2 do
      love.graphics.circle("fill", self.points[2*i-1], self.points[2*i], 5)
    end
end


function takePoints:mousepressed(x, y, key, collage)
  if key == 1 then
    if x > self.topLeft[1] and x < self.bottomRight[1] then
        if y > self.topLeft[2] and y < self.bottomRight[2] then
          self.points[#self.points+1] = x
          self.points[#self.points+1] = y
        end
    end
  end
end


function takePoints:keypressed(key)
  if key == 'escape' then
    if #self.points > 0 then
      takePoints:keypressed('s')
    end
    love.event.quit()
  end
  if key == 'n' then
    takeName(self)
  end
  if key == 's' then
    if #self.points > 0 then
      takeName(self)
    end
    savePoints(self)
  end
end

return takePoints