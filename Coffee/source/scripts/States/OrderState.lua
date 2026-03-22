import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "../CoroutineManager"

   OrderState = {}

    local pd = playdate
    local gfx = pd.graphics

    local allMySprites

    local customerMoveInCoroutine
    --1. Customer walks in
    --2. Customer lists what they want,
    --3. You get the receipt With the order

    function OrderState.new()
        local self = setmetatable({}, OrderState)    

        self.backgroundImage = gfx.image.new("images/fullBlack")
        self.backgroundSprite = gfx.sprite.new(self.backgroundImage)
        self.backgroundSprite:setZIndex(-2)
        self.backgroundSprite:moveTo(200,120)

        self.orderTableImage = gfx.image.new("images/OrderTable")
        self.orderTableSprite = gfx.sprite.new(self.orderTableImage)
        self.orderTableSprite:setZIndex(2)
        self.orderTableSprite:moveTo(200,120)

        self.cashRegisterImage = gfx.image.new("images/CashRegister")
        self.cashRegisterTableSprite = gfx.sprite.new(self.cashRegisterImage)
        self.cashRegisterTableSprite:setZIndex(4)
        self.cashRegisterTableSprite:moveTo(310,172)        

        self.customerImage = gfx.image.new("images/Customer")
        self.customerSprite = gfx.sprite.new(self.customerImage)
        self.customerSprite:setZIndex(1)
        self.customerSprite:moveTo(100,152)        

        allMySprites = {self.backgroundSprite, self.orderTableSprite, self.cashRegisterTableSprite, self.customerSprite}
      return self
    end

    function OrderState:update()
        UpdateCoroutine(customerMoveInCoroutine)
    end

    function OrderState:DrawAfterSprites()
    end
    function OrderState:OnDownButtonDown()
    end
    function OrderState:OnUpButtonDown()
    end
    function OrderState:OnLeftButtonDown()
    end
    function OrderState:OnRightButtonDown()
    end
    function OrderState:OnAButtonDown()
    end
    function OrderState:OnBButtonDown()
    end  
    
    function OrderState:onStateExit()
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
    end

    function OrderState:onStateEnter()
        customerMoveInCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.customerSprite, -100, 150, 100, 150, 0.005)
                                                    end)

        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end

    end
    
    function OrderState.__index(tab, key)
        return OrderState[key]
    end
