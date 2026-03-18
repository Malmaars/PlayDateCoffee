import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

MapPin = {}

local moveSpeed = 0.2


function MapPin:new()
    local o = {}   
    setmetatable(o, self)
        --Image of the Pin on the Map
    self.myImage = gfx.image.new("images/MapPin")
    self.mySprite = gfx.sprite.new(self.myImage)
    self.mySprite:setZIndex(4)
    self.mySprite:moveTo(200,120)

    self.targetXLocation = 200
    self.targetYLocation = 120

    return o
end

function MapPin:SetNewLocation(x, y)
    self.targetXLocation = x
    self.targetYLocation = y
end


function MapPin:update()
    if self.targetXLocation ~= nil and self.targetYLocation ~= nil then
        self.mySprite:moveTo(
        playdate.math.lerp(self.mySprite.x, self.targetXLocation, moveSpeed), 
        playdate.math.lerp(self.mySprite.y, self.targetYLocation, moveSpeed))
    end

end 

function MapPin:activate()
    self.mySprite:add()
end

function MapPin:destroy()
   self.mySprite:remove()
end

function MapPin.__index(tab, key)
    return MapPin[key]
end