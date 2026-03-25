import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "../CoffeeBag"
import "../CoffeeBean"
import "../MapPin"
import "../TextClass"
import "../Fonts"

local pd = playdate
local gfx = pd.graphics

BeanChoice = {}

local allMySprites

local backgroundImage = gfx.image.new("images/fullBlack")
local backgroundSprite = gfx.sprite.new(backgroundImage)
backgroundSprite:setZIndex(-2)
backgroundSprite:moveTo(200,120)

local coffeeBags

local currentCrankAngle

function BeanChoice.new()
    local self = setmetatable({}, BeanChoice)
    coffeeBags = {  CoffeeBag:new(0, CoffeeBean:new("Peru")),
                    CoffeeBag:new(1, CoffeeBean:new("Brazil")),
                    CoffeeBag:new(2, CoffeeBean:new("Moon")),
                    CoffeeBag:new(3, CoffeeBean:new("Peru")),
                    CoffeeBag:new(4, CoffeeBean:new("Peru")),
                    CoffeeBag:new(5, CoffeeBean:new("Peru")),
                    CoffeeBag:new(6, CoffeeBean:new("Peru")),
                    CoffeeBag:new(7, CoffeeBean:new("Peru")),
                    CoffeeBag:new(8, CoffeeBean:new("Peru")),
                    CoffeeBag:new(9, CoffeeBean:new("Peru")),
                    CoffeeBag:new(10, CoffeeBean:new("Peru")),
                    CoffeeBag:new(11, CoffeeBean:new("Brazil")),
                    CoffeeBag:new(12, CoffeeBean:new("Moon")),
                    CoffeeBag:new(13, CoffeeBean:new("Peru")),
                    CoffeeBag:new(14, CoffeeBean:new("Peru")),
                    CoffeeBag:new(15, CoffeeBean:new("Peru")),
                    CoffeeBag:new(16, CoffeeBean:new("Peru")),
                    CoffeeBag:new(17, CoffeeBean:new("Peru")),
                    CoffeeBag:new(18, CoffeeBean:new("Peru")),
                    CoffeeBag:new(19, CoffeeBean:new("Peru")),
                    CoffeeBag:new(20, CoffeeBean:new("Peru"))}

    self.BeanInfoImage = gfx.image.new("images/CoffeeInfoHeader")
    self.BeanInfoSprite = gfx.sprite.new(self.BeanInfoImage)
    self.BeanInfoSprite:setZIndex(4)
    self.BeanInfoSprite:moveTo(200,120)
    
    --Image of map    
    self.WorldMap = playdate.graphics.imagetable.new("images/CoffeeMapTable")
    self.MapMp = playdate.graphics.tilemap.new()
    self.MapMp:setImageTable(self.WorldMap)
    self.WorldMapSprite = playdate.graphics.sprite.new(self.MapMp)
    self.WorldMapSprite:setZIndex(3)
    self.WorldMapSprite:moveTo(306,68)

    --pin on the map
    pinOnMap = MapPin:new()

    --images of the bars for coffee stats
    self.CoffeeStatsBar = playdate.graphics.imagetable.new("images/CoffeeStatsBar")
    self.barMP = playdate.graphics.tilemap.new()
    self.barMP:setImageTable(self.CoffeeStatsBar)
    self.AcidityBarSprite = playdate.graphics.sprite.new(self.barMP)
    self.AcidityBarSprite:setZIndex(5)
    self.AcidityBarSprite:moveTo(165, 38)
    self.AcidityBarText = TextClass:new("ACIDITY", 102, 22, 5, FontAmmolite,"left")
    
    self.AromaBarSprite = playdate.graphics.sprite.new(self.barMP)
    self.AromaBarSprite:setZIndex(5)
    self.AromaBarSprite:moveTo(165, 73)
    self.AromaBarText = TextClass:new("AROMA", 102, 57, 5, FontAmmolite,"left")
    
    self.BodyBarSprite = playdate.graphics.sprite.new(self.barMP)
    self.BodyBarSprite:setZIndex(5)
    self.BodyBarSprite:moveTo(165, 108)
    self.BodyBarText = TextClass:new("BODY", 102, 92, 5, FontAmmolite,"left")


    self:ChangeDataVisual(coffeeBags[10])
    allMySprites = {backgroundSprite, self.BeanInfoSprite, self.WorldMapSprite, self.AcidityBarSprite, self.AromaBarSprite, self.BodyBarSprite}

    return self
end

function BeanChoice:update()
    for _, bag in pairs(coffeeBags) do
            bag:update()
    end
    pinOnMap:update()

    local tempCrankAngle = currentCrankAngle
    self:GetCrankAngle()
    if tempCrankAngle ~= currentCrankAngle then
        if (currentCrankAngle == 8 and tempCrankAngle == 1) or (currentCrankAngle < tempCrankAngle and (currentCrankAngle ~= 1 or tempCrankAngle ~= 8)) then
            for _, bag in pairs(coffeeBags) do
                bag:SetIndex(bag:GetIndex() + 1)
                if bag:GetIndex() == 10 then
                    bag:SetSelected(true)
                    self:ChangeDataVisual(bag)
                else
                    bag:SetSelected(false)
                end
            end
        else
            for _, bag in pairs(coffeeBags) do
                bag:SetIndex(bag:GetIndex() - 1)
                if bag:GetIndex() == 10 then
                    bag:SetSelected(true)
                    self:ChangeDataVisual(bag)
                else
                    bag:SetSelected(false)
                end
            end
        end
    end
end

function BeanChoice:DrawAfterSprites()

end

function BeanChoice:OnDownButtonDown()
    StartStateSwitch("order")
end
function BeanChoice:OnUpButtonDown()
    StartStateSwitch("grinder")
end

function BeanChoice:OnLeftButtonDown()
    if GameState ~= "bean choice" then
        return
    end

    for _, bag in pairs(coffeeBags) do
            bag:SetIndex(bag:GetIndex() + 1)
            if bag:GetIndex() == 10 then
                bag:SetSelected(true)
                self:ChangeDataVisual(bag)
            else
                bag:SetSelected(false)
            end
    end
end

function BeanChoice:OnRightButtonDown()
    if GameState ~= "bean choice" then
        return
    end
    for _, bag in pairs(coffeeBags) do
            bag:SetIndex(bag:GetIndex() - 1)
            if bag:GetIndex() == 10 then
                bag:SetSelected(true)
                self:ChangeDataVisual(bag)
            else
                bag:SetSelected(false)
            end
    end
end

function BeanChoice:ChangeDataVisual(coffeeBagReference)
    --change the visuals like the map and the bars for the acidity, aroma and body
    if coffeeBagReference.myBeanType.BeanName == "Moon" then
            self.WorldMapSprite:setImage(self.WorldMap:getImage(1))    
    else
            self.WorldMapSprite:setImage(self.WorldMap:getImage(2))    
    end

    --change the location of the map pin, with a cool animation
    if coffeeBagReference.myBeanType.BeanName == "Moon" then
        pinOnMap:SetNewLocation(350,40)
    elseif coffeeBagReference.myBeanType.BeanName == "Peru" then
        pinOnMap:SetNewLocation(265,70)    
    elseif coffeeBagReference.myBeanType.BeanName == "Brazil" then
        pinOnMap:SetNewLocation(275,65)    
    end
    

    self.AcidityBarSprite:setImage(self.CoffeeStatsBar:getImage(coffeeBagReference.myBeanType.Acidity + 1))
    self.AromaBarSprite:setImage(self.CoffeeStatsBar:getImage(coffeeBagReference.myBeanType.Aroma + 1))
    self.BodyBarSprite:setImage(self.CoffeeStatsBar:getImage(coffeeBagReference.myBeanType.Body + 1))
end

function BeanChoice:OnAButtonDown()
    --pick the specific bag, and trigger an open animation
    for _, bag in pairs(coffeeBags) do
        if bag:GetIndex() == 10 then
            bag:SetPicked(true)
            UpdateCurrentProduct(bag.myBeanType, nil, nil)
        end
    end
    StartStateSwitch("grinder")
end

function BeanChoice:OnBButtonDown()
end
function BeanChoice:OnAButtonUp()
end
function BeanChoice:OnBButtonUp()
end  
    

function BeanChoice:GetCrankAngle()
    local crankAngle = pd.getCrankPosition()
        
    currentCrankAngle = 1;
    if crankAngle > 22.5 and crankAngle <= 67.5 then
        currentCrankAngle = 2
    elseif crankAngle > 67.5 and crankAngle <= 112.5 then
        currentCrankAngle = 3
    elseif crankAngle > 112.5 and crankAngle <= 157.5 then
        currentCrankAngle = 4
    elseif crankAngle > 157.5 and crankAngle <= 202.5 then
        currentCrankAngle = 5
    elseif crankAngle > 202.5 and crankAngle <= 247.5 then
        currentCrankAngle = 6
    elseif crankAngle > 247.5 and crankAngle <= 292.5 then
        currentCrankAngle = 7
    elseif crankAngle > 292.5 and crankAngle <= 337.5 then
        currentCrankAngle = 8
    end
end

function BeanChoice:onStateExit()
        for _, bag in pairs(coffeeBags) do
            bag:destroy()
            bag:SetSelected(false)
        end
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
        self.AcidityBarText:remove()
        self.AromaBarText:remove()
        self.BodyBarText:remove()
        pinOnMap:destroy()
end

function BeanChoice:onStateEnter()
        for _, bag in pairs(coffeeBags) do
            bag:activate()
            bag:SetPicked(false)
            if bag:GetIndex() == 10 then
                bag:SetSelected(true)
            end            
        end
    print("test")

        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end
        pinOnMap:activate()
        self.AcidityBarText:add()
        self.AromaBarText:add()
        self.BodyBarText:add()
        self:ChangeDataVisual(coffeeBags[10])
        self:GetCrankAngle()
        MakeNewProduct()      
end

function BeanChoice.__index(tab, key)
    return BeanChoice[key]
end