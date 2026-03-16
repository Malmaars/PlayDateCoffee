import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "CoffeeBag"

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
    coffeeBags = {  CoffeeBag:new(0), 
                    CoffeeBag:new(1),
                    CoffeeBag:new(2),
                    CoffeeBag:new(3),
                    CoffeeBag:new(4),
                    CoffeeBag:new(5),
                    CoffeeBag:new(6),
                    CoffeeBag:new(7),
                    CoffeeBag:new(8),
                    CoffeeBag:new(9),
                    CoffeeBag:new(10),
                    CoffeeBag:new(11),
                    CoffeeBag:new(12),
                    CoffeeBag:new(13),
                    CoffeeBag:new(14),
                    CoffeeBag:new(15),
                    CoffeeBag:new(16),
                    CoffeeBag:new(17),
                    CoffeeBag:new(18),
                    CoffeeBag:new(19),
                    CoffeeBag:new(20)}

    self.BeanInfoImage = gfx.image.new("images/CoffeeInfoHeader")
    self.BeanInfoSprite = gfx.sprite.new(self.BeanInfoImage)
    self.BeanInfoSprite:setZIndex(4)
    self.BeanInfoSprite:moveTo(200,120)
    
    self.WorldMapImage = gfx.image.new("images/WorldMap")
    self.WorldMapSprite = gfx.sprite.new(self.WorldMapImage)
    self.WorldMapSprite:setZIndex(3)
    self.WorldMapSprite:moveTo(200,120)
    
    allMySprites = {backgroundSprite, self.BeanInfoSprite, self.WorldMapSprite}

    return self
end

function BeanChoice.update()
    for _, bag in pairs(coffeeBags) do
            bag:update()
    end
end

function BeanChoice:OnLeftButtonDown()
    if GameState ~= "bean choice" then
        return
    end

    for _, bag in pairs(coffeeBags) do
            bag:SetIndex(bag:GetIndex() + 1)
            if bag:GetIndex() == 10 then
                bag:SetSelected(true)
            else
                bag:SetSelected(false)
            end
    end
end

function BeanChoice:OnRightButtonDown()
    if GameState ~= "bean choice" then
        return
    end
    print(#coffeeBags)
    for _, bag in pairs(coffeeBags) do
            bag:SetIndex(bag:GetIndex() - 1)
            if bag:GetIndex() == 10 then
                bag:SetSelected(true)
            else
                bag:SetSelected(false)
            end
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