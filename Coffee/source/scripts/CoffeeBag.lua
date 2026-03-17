import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

CoffeeBag = {}

local moveSpeed = 0.1;

--35 per index
--local targetXPosition
--250 down, 215 up
--local targetYposition

--index is an integer, beantype is an instance of class CoffeeBean
function CoffeeBag:new(index, beanType)
    local o = {}   
    setmetatable(o, self)
    o.bagIndex = index;
    o.myImage = gfx.image.new("images/CoffeeBagThick")
    o.mySprite = gfx.sprite.new(o.myImage)
    o.mySprite:setZIndex(10)
    o.mySprite:moveTo(o.bagIndex * 35, 250)
    o.selected = false

    o.targetXPosition = index * 50- 300
    o.targetYposition = 250
    o.mySprite:moveTo(o.targetXPosition, o.targetYposition)
    
    return o
end

function CoffeeBag:update()
    if self.selected then
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

function CoffeeBag:activate()
    self.mySprite:add()
end

function CoffeeBag:destroy()
   self.mySprite:remove()
end

function CoffeeBag.__index(tab, key)
    return CoffeeBag[key]
end