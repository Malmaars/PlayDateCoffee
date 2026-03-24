import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

local myProduct
local beanType
local aroma
local body
local acidity


Order = {}


function Order:new(_product, _beanType, _aroma, _body, _acidity)
    local o = {}   
    setmetatable(o, self)
    
    o.myProduct = _product
    o.beanType = _beanType
    o.aroma = _aroma
    o.body = _body
    o.acidity = _acidity

    return o
end

function Order:update()
end

function Order:CheckProduct(product)
    if myProduct ~= nil then
        if myProduct.fluidType ~= nil and myProduct.fluidType ~= product.fluidType then
            return false
        end
        if myProduct.cupType ~= nil and myProduct.cupType ~= product.cupType then
            return false
        end
    end 

    if beanType ~= nil and beanType.BeanName ~= product.myCoffeeBeans.BeanName then
        return false
    end

    if aroma ~= nil and aroma ~= product.aroma then
        return false
    end
    
    if acidity ~= nil and acidity ~= product.acidity then
        return false
    end
    
    if body ~= nil and body ~= product.body then
        return false
    end
    
    return true
end

function Order.__index(tab, key)
    return Order[key]
end