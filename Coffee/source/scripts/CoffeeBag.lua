import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

CoffeeBag = {}

local moveSpeed = 0.1;
local myBeanType
--35 per index
--local targetXPosition
--250 down, 215 up
--local targetYposition

--index is an integer, beantype is an instance of class CoffeeBean
function CoffeeBag:new(index, beanType)
    local o = {}   
    setmetatable(o, self)
    o.bagIndex = index;
    o.myBeanType = beanType
    o.myImage = gfx.image.new("images/CoffeeBag"..beanType.BeanName)
    o.mySprite = gfx.sprite.new(o.myImage)
    o.mySprite:setZIndex(10)
    o.mySprite:moveTo(index * 50 - 300, 250)
    o.selected = false

    o.targetXPosition = index * 50- 300
    o.targetYposition = 250
    o.mySprite:moveTo(o.targetXPosition, o.targetYposition)
    
    return o
end

function CoffeeBag:update()
    if self.picked then
        self.targetYposition = -100    
    elseif self.selected then
        self.targetYposition = 205
    else
        self.targetYposition = 250
    end

    self.targetXPosition = self.bagIndex * 50 - 300

    self.mySprite:setZIndex(self.bagIndex)
    self.mySprite:moveTo(
        playdate.math.lerp(self.mySprite.x, self.targetXPosition, moveSpeed), 
        playdate.math.lerp(self.mySprite.y, self.targetYposition, moveSpeed))
end

function CoffeeBag:SetIndex(index)
    self.bagIndex = index
    if self.bagIndex > 20 then
        self.bagIndex = 0
        self.targetXPosition = self.bagIndex * 50 - 300
        self.targetYposition = 250
        self.mySprite:moveTo(self.targetXPosition, self.targetYposition)
    end

    if self.bagIndex < 0 then
        self.bagIndex = 20
        self.targetXPosition = self.bagIndex * 50 - 300
        self.targetYposition = 250
        self.mySprite:moveTo(self.targetXPosition, self.targetYposition)
    end


end
function CoffeeBag:GetIndex()
    return self.bagIndex
end
function CoffeeBag:SetSelected(bool)
    self.selected = bool
end

function CoffeeBag:SetPicked(bool)
    self.picked = bool
end

function CoffeeBag:activate()
    self.mySprite:add()
    self.mySprite:moveTo(self.bagIndex * 50 - 300, 250)
end

function CoffeeBag:destroy()
   self.mySprite:remove()
end

function CoffeeBag.__index(tab, key)
    return CoffeeBag[key]
end