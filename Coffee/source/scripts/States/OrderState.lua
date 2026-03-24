import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "../CoroutineManager"
import "../Receipt"

   OrderState = {}

    local pd = playdate
    local gfx = pd.graphics

    local allMySprites

    local customerMoveInCoroutine
    local printReceiptCoroutine
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

        self.smallReceiptImage = gfx.image.new("images/SmallReceipt")
        self.smallReceiptSprite = gfx.sprite.new(self.smallReceiptImage)
        self.smallReceiptSprite:setZIndex(3)
        self.smallReceiptSprite:moveTo(313,150)    

        self.bigReceipt = Receipt:new(300, -120, 6)

        allMySprites = {self.backgroundSprite, self.orderTableSprite, self.cashRegisterTableSprite, self.customerSprite, 
                        self.smallReceiptSprite, self.bigReceipt}
      return self
    end

    function OrderState:update()
        UpdateCoroutine(customerMoveInCoroutine)
        UpdateCoroutine(printReceiptCoroutine)
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
        if printReceiptCoroutine == nil or coroutine.status(printReceiptCoroutine) == "dead" then
            printReceiptCoroutine = coroutine.create(  function()
                                                                self:PrintReceipt()
                                                                end)
        end
    end
    function OrderState:OnBButtonDown()
    end
    
    function OrderState:PrintReceipt()
        --set the small and large receipt at the starting positions
        self.smallReceiptSprite:moveTo(313,150)
        self.bigReceipt:moveTo(300, -120)
        print("printing receipt")
        --move the small receipt up
        --Y: 115, then 110, then 100
        local currentCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.smallReceiptSprite, 313, 150, 313, 115, 0.05, false)
                                                    end)
        while currentCoroutine ~= nil and coroutine.status(currentCoroutine) ~= "dead" do
            UpdateCoroutine(currentCoroutine)
            coroutine.yield()
        end
        local currentCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.smallReceiptSprite, 313, 115, 313, 108, 0.05, false)
                                                    end)
        while currentCoroutine ~= nil and coroutine.status(currentCoroutine) ~= "dead" do
            UpdateCoroutine(currentCoroutine)
            coroutine.yield()
        end
        local currentCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.smallReceiptSprite, 313, 110, 313, 100, 0.05, false)
                                                    end)
        
        while currentCoroutine ~= nil and coroutine.status(currentCoroutine) ~= "dead" do
            UpdateCoroutine(currentCoroutine)
            coroutine.yield()
        end
        local currentCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.smallReceiptSprite, 313, 100, 313, -150, 0.05, false)
                                                    end)
        
        while currentCoroutine ~= nil and coroutine.status(currentCoroutine) ~= "dead" do
            UpdateCoroutine(currentCoroutine)
            coroutine.yield()
        end
        
        local currentCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.bigReceipt, 300, -120, 300, 120, 0.05, true)
                                                    end)
        
        while currentCoroutine ~= nil and coroutine.status(currentCoroutine) ~= "dead" do
            UpdateCoroutine(currentCoroutine)
            coroutine.yield()
        end

        --move the large receipt down
        --start: (300, -120) destination: (300,120)
    end
    
    function OrderState:onStateExit()
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
    end

    function OrderState:onStateEnter()
        customerMoveInCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.customerSprite, -100, 150, 100, 150, 0.01)
                                                    end)

        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end
        self.bigReceipt:moveTo(300,-120)        

    end
    
    function OrderState.__index(tab, key)
        return OrderState[key]
    end
