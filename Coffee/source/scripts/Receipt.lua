import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "ParentedSprite"
import "Fonts"

local pd = playdate
local gfx = pd.graphics

Receipt = {}

function Receipt:new(startPosX, startPosY, zIndex)
    local o = {}   
    setmetatable(o, self)
    local bigReceiptImage = gfx.image.new("images/BigReceipt")

    o.mySprite = gfx.sprite.new(bigReceiptImage)
    o.mySprite:setZIndex(zIndex)
    o.mySprite:moveTo(startPosX,startPosY)

    o.CoffeeStatsBar = playdate.graphics.imagetable.new("images/CoffeeStatsBar")
    local barMP = playdate.graphics.tilemap.new()
    barMP:setImageTable(o.CoffeeStatsBar)
    local AcidityBarSprite = playdate.graphics.sprite.new(barMP)
    AcidityBarSprite:setZIndex(zIndex + 1)
    AcidityBarSprite:setImage(o.CoffeeStatsBar:getImage(1))
    o.AcidityBar = ParentedSprite:new(AcidityBarSprite, 21, -30)

    local AcidityBarText = TextClass:new("ACIDITY", 102, 22, zIndex + 1, FontAmmolite)
    o.AcidityText = ParentedSprite:new(AcidityBarText, -10, -30)
    
    o.allMyLocalSprites = {o.AcidityBar, o.AcidityText}
    
    return o
end

function Receipt:update()

end 


function Receipt:moveTo(targetX, targetY)
    self.mySprite:moveTo(targetX, targetY)
        for _, localSprite in pairs(self.allMyLocalSprites) do
            localSprite:moveTo(self.mySprite.x + localSprite.localX, self.mySprite.y + localSprite.localY)
        end
end

function Receipt:add()
    self.mySprite:add()
        for _, localSprite in pairs(self.allMyLocalSprites) do
            localSprite:add()
        end
end

function Receipt:remove()
   self.mySprite:remove()
        for _, localSprite in pairs(self.allMyLocalSprites) do
            localSprite:remove()
        end
end

function Receipt.__index(tab, key)
    return Receipt[key]
end