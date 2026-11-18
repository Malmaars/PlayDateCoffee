import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "../CoroutineManager"

   --This state is for showing how you influence the coffee order between every choice you make
   EditOrder = {}

    local pd = playdate
    local gfx = pd.graphics

    local allMySprites

    local editOrderAnimationRoutine

    function EditOrder.new()
        local self = setmetatable({}, EditOrder)    

        self.backgroundImage = gfx.image.new("images/fullBlack")
        self.backgroundSprite = gfx.sprite.new(self.backgroundImage)
        self.backgroundSprite:setZIndex(-2)
        self.backgroundSprite:moveTo(200,120)

        self.stampImage = gfx.image.new("images/stamp")
        self.stampSprite = gfx.sprite.new(self.stampImage)
        self.stampSprite:setZIndex(40)
        self.stampSprite:moveTo(-200,0)

        allMySprites = {self.backgroundSprite,
                        self.stampSprite}
      return self
    end

    function EditOrder:update()
        UpdateCoroutine(editOrderAnimationRoutine)
    end
    function EditOrder:DrawAfterSprites()
    end
    function EditOrder:OnDownButtonDown()
    end
    function EditOrder:OnUpButtonDown()
    end
    function EditOrder:OnLeftButtonDown()
    end
    function EditOrder:OnRightButtonDown()
    end
    function EditOrder:OnAButtonDown()
        --pressing A will just transition to the next state, this whole state is just visuals to show what happened
    end
    function EditOrder:OnBButtonDown()
    end      
    function EditOrder:OnAButtonUp()
    end
    function EditOrder:OnBButtonUp()
    end  
    
    function EditOrder:onStateExit()
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
    end

    function EditOrder:onStateEnter()
        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end
        editOrderAnimationRoutine = coroutine.create(   function()
                                                            self:EditOrderAnimation()
                                                        end)
    end

    function EditOrder:EditOrderAnimation()
        while transitionAnimator ~= nil and transitionAnimator:ended() == false do
            --wait
            print("waiting...")
            coroutine.yield()
        end
        local currentCoroutine = coroutine.create(  function()
                                                    MoveSprite(currentMakingReceipt, 200, -120, 200, 120, 0.05, true)
                                                end)

        while  (currentCoroutine ~= nil and coroutine.status(currentCoroutine) ~= "dead") do
            UpdateCoroutine(currentCoroutine)
            coroutine.yield()
        end                  
        
        
        currentCoroutine = coroutine.create(  function()
                                                    MoveSprite(self.stampSprite, -100, -100, 145, 155, 0.05, false)
                                                end)
        local shakeCoroutine = coroutine.create(function()
                                                ShakeSprite(self.stampSprite, 500)
                                            end)
         
        local delay = 11
        while  (currentCoroutine ~= nil and coroutine.status(currentCoroutine) ~= "dead") or (shakeCoroutine ~= nil and coroutine.status(shakeCoroutine) ~= "dead")  do
            UpdateCoroutine(currentCoroutine)
            if delay > 0 then
                delay = delay - 1
            else
                UpdateCoroutine(shakeCoroutine)
            end
            coroutine.yield()
        end

        --stamp the order
    end
    
    function EditOrder.__index(tab, key)
        return EditOrder[key]
    end
