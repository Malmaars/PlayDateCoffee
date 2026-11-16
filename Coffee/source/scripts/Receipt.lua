import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "ParentedSprite"
import "Fonts"

local pd = playdate
local gfx = pd.graphics

Receipt = {}

function Receipt:new(startPosX, startPosY, zIndex, _order)
    local o = {}   
    setmetatable(o, self)
    local bigReceiptImage = gfx.image.new("images/BigReceipt")

    o.mySprite = gfx.sprite.new(bigReceiptImage)
    o.mySprite:setZIndex(zIndex)
    o.mySprite:moveTo(startPosX,startPosY)

    local OrderNumber = TextClass:new("ORDER #01", 0, 0, zIndex + 1, FontAmmoliteLarge, nil)
    o.OrderNumberText = ParentedSprite:new(OrderNumber, 0, -80)
    

    local OrderType = TextClass:new("LATTE MACHIATTO", 0, 0, zIndex + 1, FontAmmolite, nil)
    o.OrderTypeText = ParentedSprite:new(OrderType, 0, -55)
    
    
    o.CoffeeStatsBar = playdate.graphics.imagetable.new("images/SmallCoffeeStatsBar")
    local barMP = playdate.graphics.tilemap.new()
    barMP:setImageTable(o.CoffeeStatsBar)
    o.AcidityBarSprite = playdate.graphics.sprite.new(barMP)
    o.AcidityBarSprite:setZIndex(zIndex + 1)
    o.AcidityBarSprite:setImage(o.CoffeeStatsBar:getImage(_order.acidity + 1))
    o.AcidityBar = ParentedSprite:new(o.AcidityBarSprite, 46, -33)

    local AcidityBarText = TextClass:new("ACIDITY", 102, 22, zIndex + 1, FontAmmolite, "left")
    o.AcidityText = ParentedSprite:new(AcidityBarText, -80, -33)
    
    
    o.AromaBarSprite = playdate.graphics.sprite.new(barMP)
    o.AromaBarSprite:setZIndex(zIndex + 1)
    o.AromaBarSprite:setImage(o.CoffeeStatsBar:getImage(_order.aroma + 1))
    o.AromaBar = ParentedSprite:new(o.AromaBarSprite, 46, -17)

    local AromaBarText = TextClass:new("AROMA", 102, 22, zIndex + 1, FontAmmolite, "left")
    o.AromaText = ParentedSprite:new(AromaBarText, -80, -17)
    
    o.BodyBarSprite = playdate.graphics.sprite.new(barMP)
    o.BodyBarSprite:setZIndex(zIndex + 1)
    o.BodyBarSprite:setImage(o.CoffeeStatsBar:getImage(_order.body + 1))
    o.BodyBar = ParentedSprite:new(o.BodyBarSprite, 46, -1)

    local BodyBarText = TextClass:new("BODY", 102, 22, zIndex + 1, FontAmmolite, "left")
    o.BodyText = ParentedSprite:new(BodyBarText, -80, -1)
    
    o.allMyLocalSprites = {o.AcidityBar, o.AcidityText, o.AromaBar, o.AromaText, o.BodyBar, o.BodyText, o.OrderTypeText, o.OrderNumberText}
    o:moveTo(startPosX, startPosY)
    
    return o
end

function Receipt:update()

end 

function Receipt:edit(whatToEdit, value)
    if whatToEdit == "aroma" then
        self.AromaBarSprite:setImage(self.CoffeeStatsBar:getImage(value + 1))
        
    elseif whatToEdit == "body" then
        self.BodyBarSprite:setImage(self.CoffeeStatsBar:getImage(value + 1))

    elseif whatToEdit == "acidity" then
        self.AcidityBarSprite:setImage(self.CoffeeStatsBar:getImage(value + 1))
    elseif whatToEdit == "beanType" then
    elseif whatToEdit == "orderNumber" then
    elseif whatToEdit == "orderType" then
    elseif whatToEdit == "fullOrder" then
        self.AromaBarSprite:setImage(self.CoffeeStatsBar:getImage(value.aroma + 1))
        self.BodyBarSprite:setImage(self.CoffeeStatsBar:getImage(value.body + 1))
        self.AcidityBarSprite:setImage(self.CoffeeStatsBar:getImage(value.acidity + 1))
    end
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