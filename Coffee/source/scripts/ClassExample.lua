import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

ClassExample = {}


function ClassExample:new()
    local o = {}   
    setmetatable(o, self)
    
    return o
end

function ClassExample:update()

end 

function ClassExample:activate()
    self.mySprite:add()
end

function ClassExample:destroy()
   self.mySprite:remove()
end

function ClassExample.__index(tab, key)
    return ClassExample[key]
end