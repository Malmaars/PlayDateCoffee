import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "CoffeeBag"
import "CoffeeBean"

local pd = playdate
local gfx = pd.graphics

BeanChoice = {}

local allMySprites

local backgroundImage = gfx.image.new("images/transition")
local backgroundSprite = gfx.sprite.new(backgroundImage)
backgroundSprite:setZIndex(-2)
backgroundSprite:moveTo(200,120)

local coffeeBags

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
                    CoffeeBag:new(11, CoffeeBean:new("Peru")),
                    CoffeeBag:new(12, CoffeeBean:new("Peru")),
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
    
    self.WorldMapImage = gfx.image.new("images/WorldMap")
    self.WorldMapSprite = gfx.sprite.new(self.WorldMapImage)
    self.WorldMapSprite:setZIndex(3)
    self.WorldMapSprite:moveTo(306,68)
    
    allMySprites = {backgroundSprite, self.BeanInfoSprite, self.WorldMapSprite}

    return self
end

function BeanChoice.update()
    for _, bag in pairs(coffeeBags) do
            bag:update()
    end
end

function BeanChoice:OnDownButtonDown()
    StartStateSwitch("grinder")
end
function BeanChoice:OnUpButtonDown()
    StartStateSwitch("bean choice")
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
    print(coffeeBagReference.myBeanType.BeanName)
    if coffeeBagReference.myBeanType.BeanName == "Moon" then
            self.WorldMapImage = gfx.image.new("images/MoonMap")
    else
            self.WorldMapImage = gfx.image.new("images/WorldMap")
    end
end

function BeanChoice:OnAButtonDown()
end

function BeanChoice:OnBButtonDown()
end

function BeanChoice:onStateExit()
        for _, bag in pairs(coffeeBags) do
            bag:destroy()
            bag:SetSelected(false)
        end
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
end

function BeanChoice:onStateEnter()
        for _, bag in pairs(coffeeBags) do
            bag:activate()
            if bag:GetIndex() == 10 then
                bag:SetSelected(true)
            end            
        end
        backgroundSprite:add()
        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end
end

function BeanChoice.__index(tab, key)
    return BeanChoice[key]
end