import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"
import "CoreLibs/graphics"

import "Fonts"

local pd = playdate
local gfx = pd.graphics

TextClass = {}

function TextClass:new(textString, x, y, z, font, alignment)
    local o = {}   
    setmetatable(o, self)
    o.MyImage = gfx.imageWithText(textString, 400,240, gfx.kColorClear, nil, nil, kTextAlignment.left, font)
    o.MyTextSprite = gfx.sprite.new(o.MyImage)
    if alignment ~= nil and alignment == "left" then
        o.MyTextSprite:setCenter(0, 0.5)
    else
        o.MyTextSprite:setCenter(0.5,0.5)
    end
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

function TextClass:moveTo(x,y)
    self.MyTextSprite:moveTo(x,y)
end


function TextClass:update()
end 

function TextClass:Draw()
end

function TextClass:add()
    self.MyTextSprite:add()
end

function TextClass:remove()
    self.MyTextSprite:remove()
end

function TextClass.__index(tab, key)
    return TextClass[key]
end