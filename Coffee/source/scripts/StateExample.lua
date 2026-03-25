import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "CoroutineManager"

   StateExample = {}

    local pd = playdate
    local gfx = pd.graphics

    local allMySprites

    function StateExample.new()
        local self = setmetatable({}, StateExample)    

        self.backgroundImage = gfx.image.new("images/TestImage")
        self.backgroundSprite = gfx.sprite.new(self.backgroundImage)
        self.backgroundSprite:setZIndex(-2)
        self.backgroundSprite:moveTo(200,120)

        allMySprites = {self.backgroundSprite}
      return self
    end

    function StateExample:update()
    end
    function StateExample:DrawAfterSprites()
    end
    function StateExample:OnDownButtonDown()
    end
    function StateExample:OnUpButtonDown()
    end
    function StateExample:OnLeftButtonDown()
    end
    function StateExample:OnRightButtonDown()
    end
    function StateExample:OnAButtonDown()
    end
    function StateExample:OnBButtonDown()
    end      
    function StateExample:OnAButtonUp()
    end
    function StateExample:OnBButtonUp()
    end  
    
    function StateExample:onStateExit()
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
    end

    function StateExample:onStateEnter()
        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end

    end
    
    function StateExample.__index(tab, key)
        return StateExample[key]
    end
