import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"
import "CoreLibs/graphics"

import "Fonts"

local pd = playdate
local gfx = pd.graphics

TextClass = {}

function TextClass:new(textString, x, y, z)
    local o = {}   
    setmetatable(o, self)
    o.MyImage = gfx.imageWithText(textString, 400,240, gfx.kColorClear, nil, nil, kTextAlignment.left, FontAmmolite)
    o.MyTextSprite = gfx.sprite.new(o.MyImage)
    o.MyTextSprite:setCenter(0, 0.5)
    o.MyTextSprite:setZIndex(z)
    o.MyTextSprite:moveTo(x,y)
    o.myText = textString
    o.xPosition = x;
    o.yPosition = y

    return o
end

function TextClass:SetNewLocation(x, y)
    self.targetXLocation = x
    self.targetYLocation = y
end


function TextClass:update()
end 

function TextClass:Draw()
end

function TextClass:activate()
    self.MyTextSprite:add()
end

function TextClass:destroy()
    self.MyTextSprite:remove()
end

function TextClass.__index(tab, key)
    return TextClass[key]
end