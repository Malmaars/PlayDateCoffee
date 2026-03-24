import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

ParentedSprite = {}


function ParentedSprite:new(sprite, localX, localY)
    local o = {}   
    setmetatable(o, self)
    o.mySprite = sprite
    o.localX = localX
    o.localY = localY
    return o
end

function ParentedSprite:moveTo(targetX, targetY)
    self.mySprite:moveTo(targetX, targetY)
end

function ParentedSprite:add()
    self.mySprite:add()
end

function ParentedSprite:remove()
   self.mySprite:remove()
end 

function ParentedSprite.__index(tab, key)
    return ParentedSprite[key]
end