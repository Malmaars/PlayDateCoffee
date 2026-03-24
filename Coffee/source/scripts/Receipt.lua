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

    local OrderNumber = TextClass:new("ORDER #67", 0, 0, zIndex + 1, FontAmmoliteLarge, nil)
    o.OrderNumberText = ParentedSprite:new(OrderNumber, 0, -80)
    

    local OrderType = TextClass:new("LATTE MACHIATTO", 0, 0, zIndex + 1, FontAmmolite, nil)
    o.OrderTypeText = ParentedSprite:new(OrderType, 0, -55)
    
    
    o.CoffeeStatsBar = playdate.graphics.imagetable.new("images/SmallCoffeeStatsBar")
    local barMP = playdate.graphics.tilemap.new()
    barMP:setImageTable(o.CoffeeStatsBar)
    local AcidityBarSprite = playdate.graphics.sprite.new(barMP)
    AcidityBarSprite:setZIndex(zIndex + 1)
    AcidityBarSprite:setImage(o.CoffeeStatsBar:getImage(6))
    o.AcidityBar = ParentedSprite:new(AcidityBarSprite, 46, -33)

    local AcidityBarText = TextClass:new("ACIDITY", 102, 22, zIndex + 1, FontAmmolite, "left")
    o.AcidityText = ParentedSprite:new(AcidityBarText, -80, -33)
    
    
    local AromaBarSprite = playdate.graphics.sprite.new(barMP)
    AromaBarSprite:setZIndex(zIndex + 1)
    AromaBarSprite:setImage(o.CoffeeStatsBar:getImage(8))
    o.AromaBar = ParentedSprite:new(AromaBarSprite, 46, -17)

    local AromaBarText = TextClass:new("AROMA", 102, 22, zIndex + 1, FontAmmolite, "left")
    o.AromaText = ParentedSprite:new(AromaBarText, -80, -17)
    
    local BodyBarSprite = playdate.graphics.sprite.new(barMP)
    BodyBarSprite:setZIndex(zIndex + 1)
    BodyBarSprite:setImage(o.CoffeeStatsBar:getImage(3))
    o.BodyBar = ParentedSprite:new(BodyBarSprite, 46, -1)

    local BodyBarText = TextClass:new("BODY", 102, 22, zIndex + 1, FontAmmolite, "left")
    o.BodyText = ParentedSprite:new(BodyBarText, -80, -1)
    
    o.allMyLocalSprites = {o.AcidityBar, o.AcidityText, o.AromaBar, o.AromaText, o.BodyBar, o.BodyText, o.OrderTypeText, o.OrderNumberText}
    
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