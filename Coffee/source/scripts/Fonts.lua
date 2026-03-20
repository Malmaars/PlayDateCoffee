local pd = playdate
local gfx = pd.graphics

--fonts
FontAmmolite = gfx.font.new("fonts/ammolite_10_filled")
FontAmmoliteLarge = gfx.font.new("fonts/ammolite_20_filled")

Fonts = {}

local activeFonts

function Fonts:new()
    local o = {}   
    setmetatable(o, self)
    
    return o
end

function Fonts:update()
    --draw all text
end 

function Fonts:AddText(textClass)
    table.insert(activeFonts, textClass)
end

function Fonts:RemoveText()
    table.remove(activeFonts, textClass)
end

function Fonts.__index(tab, key)
    return Fonts[key]
end
