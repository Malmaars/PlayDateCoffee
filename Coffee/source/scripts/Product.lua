import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

--script for the completed products: Coffee bean, extra fluid type (milk, water, oil, slime etc), cup type

Product = {}

local myCoffeeBeans
local aroma
local acidity
local body
local myFluidType
local myCupType

function Product:new()
    local o = {}   
    setmetatable(o, self)
    
    return o
end

function Product:update()

end 

function Product:SetCoffeeBeans(coffeeBeans)
    myCoffeeBeans = coffeeBeans
end

function Product:SetFluidType(fluidType)
    myFluidType = fluidType
end

function Product:SetCupType(cupType)
    myCupType = cupType
end

function Product:activate()
    self.mySprite:add()
end

function Product:destroy()
   self.mySprite:remove()
end

function Product.__index(tab, key)
    return Product[key]
end