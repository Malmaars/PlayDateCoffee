import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "CoroutineManager"

   TestImage = {}

    local pd = playdate
    local gfx = pd.graphics

    local allMySprites

    function TestImage.new()
        local self = setmetatable({}, TestImage)    

        self.backgroundImage = gfx.image.new("images/TestImage")
        self.backgroundSprite = gfx.sprite.new(self.backgroundImage)
        self.backgroundSprite:setZIndex(-2)
        self.backgroundSprite:moveTo(200,120)

        allMySprites = {self.backgroundSprite}
      return self
    end
    
    function TestImage:DrawAfterSprites()
    end
    function TestImage:OnDownButtonDown()
    end
    function TestImage:OnUpButtonDown()
    end
    function TestImage:OnLeftButtonDown()
    end
    function TestImage:OnRightButtonDown()
    end
    function TestImage:OnAButtonDown()
    end
    function TestImage:OnBButtonDown()
    end  
    
    
    function TestImage:onStateExit()
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
    end

    function TestImage:onStateEnter()
        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end

    end
    
    function TestImage.__index(tab, key)
        return TestImage[key]
    end
