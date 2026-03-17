import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

CoffeeBean = {}

local BeanName
--these all have values from 0-10
local Acidity = 0
local Aroma = 0
local Body = 0

--coffeeType is a string
function CoffeeBean:new(coffeeType)
    local o = {}   
    setmetatable(o, self)
    o.BeanName = coffeeType

    if coffeeType == "Peru" then
        o.Acidity = 3
        o.Aroma = 6
        o.Body = 9
    end

    return o
end
function CoffeeBean.__index(tab, key)
    return CoffeeBean[key]
end