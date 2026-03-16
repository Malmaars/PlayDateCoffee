import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

MainMenu = {}

function MainMenu.new()
    local self = setmetatable({}, MainMenu)    
    return self
end

function MainMenu.update()
end

function MainMenu:onStateExit()
end

function MainMenu:onStateEnter()
end

function MainMenu.__index(tab, key)
    return MainMenu[key]
end