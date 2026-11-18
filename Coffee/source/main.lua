import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

import "scripts/states/Grinder"
import "scripts/states/MainMenu"
import "scripts/states/BeanChoice"
import "scripts/states/TestImage"
import "scripts/states/OrderState"
import "scripts/states/PistonState"
import "scripts/states/EditOrder"
import "scripts/Order"
import "scripts/Receipt"
import "scripts/Fonts"
import "scripts/Product"
--fonts
FontAmmonite = gfx.font.new("fonts/ammonite")


-- milliseconds between each shake
local shakeInterval = 1

--possible states
--"main menu"
--"grinder"
--"bean choice"

local StateSwitchingCoroutine

local grinderState = Grinder.new()
local mainmenuState = MainMenu.new()
local beanChoiceState = BeanChoice.new()
local testImageState = TestImage.new()
local orderState = OrderState.new()
local piston = PistonState.new()
local editOrder = EditOrder.new()

-- local TestImage = gfx.image.new("images/test")
-- local testSprite = gfx.sprite.new(TestImage)
-- testSprite:setZIndex(200)
-- testSprite:moveTo(200,120)
-- testSprite:add()

--I want the current order to persist between states, so I might just locate it here
local currentAskedOrder
currentAskedReceipt = Receipt:new(100, -120, 30, Order:new(nil,nil,0,0,0))   
local currentMakingOrder
currentMakingReceipt = Receipt:new(300, -120, 30, Order:new(nil,nil,0,0,0))
local orderPreviewCoroutine = nil
local orderPreviewRoutineRunning = false
local orderShown = false

local transitionImage = gfx.image.new("images/fullBlack")
local transitionSprite = gfx.sprite.new(transitionImage)
transitionSprite:setZIndex(100)
transitionAnimator = nil
local currentProduct

local allMySprites = {currentAskedReceipt,
                        currentMakingReceipt}
                        
function pd.update()
    if CurrentState ~= nil then
        if orderShown == false then
            CurrentState:update()
        end
    end

    UpdateCoroutine(StateSwitchingCoroutine)
    UpdateCoroutine(orderPreviewCoroutine)

    --draw the sprites
    print("update the sprites")
    gfx.sprite.update()
    
    --draw text after sprites so it's on top
    if CurrentState ~= nil then
        CurrentState:DrawAfterSprites()
    end 

    playdate.timer.updateTimers()
end

function pd.AButtonDown()
    if  orderShown == false then
        CurrentState:OnAButtonDown()
    end
end
function pd.AButtonUp()
    if  orderShown == false then
        CurrentState:OnAButtonUp()
    end
end
function pd.BButtonUp()
    if  orderShown == false then
        CurrentState:OnBButtonUp()
    end
end
function pd.BButtonDown()
    if  orderShown == false then
        CurrentState:OnBButtonDown()
    end
end


function pd.upButtonDown()
    if (orderPreviewCoroutine == nil or coroutine.status(orderPreviewCoroutine) == "dead") then
            orderPreviewCoroutine = coroutine.create(  function()
                                                                ShowOrderPreview()
                                                                end)
    end
    if  orderShown == false then
        CurrentState:OnUpButtonDown()
    end
end
function pd.downButtonDown()
    if  orderShown == false then
        CurrentState:OnDownButtonDown()
    end
end

function pd.leftButtonDown()
    if  orderShown == false then
        CurrentState:OnLeftButtonDown()
    end
end

function pd.rightButtonDown()
    if  orderShown == false then
        CurrentState:OnRightButtonDown()
    end
end
function ShowOrderPreview()
    print(orderPreviewRoutineRunning)
    if orderPreviewRoutineRunning == true then
        return
    end
    local askedCoroutine 
    local makingCoroutine
    if orderShown == false then
        --show what the customer ordered, and what the state is of what you're making right now
        askedCoroutine = coroutine.create(  function()
                                                            MoveSprite(currentAskedReceipt, 100, -120, 100, 120, 0.05, true)
                                                        end)
        makingCoroutine = coroutine.create(  function()
                                                            MoveSprite(currentMakingReceipt, 300, -120, 300, 120, 0.05, true)
                                                        end)
        orderShown = true
    else
        askedCoroutine = coroutine.create(  function()
                                                            MoveSprite(currentAskedReceipt, 100, 120, 100, -120, 0.05, true)
                                                        end)
        makingCoroutine = coroutine.create(  function()
                                                            MoveSprite(currentMakingReceipt, 300, 120, 300, -120, 0.05, true)
                                                        end)
        orderShown = false
    end

    orderPreviewRoutineRunning = true

    while  (askedCoroutine ~= nil and coroutine.status(askedCoroutine) ~= "dead") or (makingCoroutine ~= nil and coroutine.status(makingCoroutine) ~= "dead") do
        if makingCoroutine ~= nil and coroutine.status(makingCoroutine) ~= "dead" then
            UpdateCoroutine(makingCoroutine)
        end
        if askedCoroutine ~= nil and coroutine.status(askedCoroutine) ~= "dead" then
            UpdateCoroutine(askedCoroutine)
        end
            coroutine.yield()
    end
    orderPreviewRoutineRunning = false
end

function MakeNewProduct()
    currentProduct = Product:new()
end

function UpdateCurrentProduct(beans, fluid, cup)
    if beans ~= nil then
        currentProduct:SetCoffeeBeans(beans)
    end
    if fluid ~= nil then
        currentProduct:SetFluidType(fluid)
    end
    if cup ~= nil then
        currentProduct:SetCupType(cup)
    end
end

function SetAskedOrder(newOrder)
    currentAskedOrder = newOrder
    currentAskedReceipt:edit("fullOrder", newOrder)  
end

function ResetMakingOrder()
    currentMakingOrder = Order:new(nil, nil, 0, 0, 0)
    currentMakingReceipt:edit("body", 0)
    currentMakingReceipt:edit("aroma", 0)
    currentMakingReceipt:edit("acidity", 0)
end

function EditMakingOrder()
end


function StartStateSwitch(newState)
    if StateSwitchingCoroutine == nil or coroutine.status(StateSwitchingCoroutine) == "dead" or coroutine.status(StateSwitchingCoroutine) == "suspended" then     
        StateSwitchingCoroutine = coroutine.create( function()
                                                        SwitchState(newState)
                                                    end)
    end
end

function SwitchState(newState)
    --do nothing if you want to switch to the same state
    if GameState==newState then
        return
    end
    
    transitionSprite:add()
    transitionAnimator = gfx.animator.new(2000, -160, 400, pd.easingFunctions.inOutCubic)
    local stateSwitch = false

    while transitionAnimator:ended()==false do

        local animatorValue = transitionAnimator:currentValue()

        transitionSprite:moveTo(200, animatorValue)

        local newStateVariable
        if stateSwitch==false and transitionAnimator:currentValue() >= 120 then
            stateSwitch = true
            --run exitstate function

            if CurrentState ~= nil then
                CurrentState:onStateExit()
            end
            
            --run enter state function
            if newState=="grinder" then
                newStateVariable = grinderState
            elseif newState=="main menu" then
                newStateVariable = mainmenuState
            elseif newState=="bean choice" then
                newStateVariable = beanChoiceState
            elseif newState=="TestImage" then
                newStateVariable = testImageState
            elseif newState=="piston" then
                newStateVariable = piston
            elseif newState=="order" then
                newStateVariable = orderState
            elseif newState=="editOrder" then
                newStateVariable = editOrder
            end
            newStateVariable:onStateEnter()

            GameState = newState
            CurrentState = newStateVariable
            

        end

        coroutine.yield()
    end
    transitionSprite:remove()
end

function ShakeSprite(sprite, duration)

    local originalPosX = sprite.x
    local originalPosY = sprite.y

    local posXOffset = 0
    local posYOffset = 0
    local ShakeTimer = pd.timer.new(duration)    

    local shakeIntervalTimer = pd.timer.new(0)

    while ShakeTimer.active do
        if shakeIntervalTimer.active==false  then
            shakeIntervalTimer = pd.timer.new(shakeInterval)
            posXOffset = math.random(-5,5)
            posYOffset = math.random(-5,5)
        end

        sprite:moveTo(originalPosX + posXOffset, originalPosY + posYOffset)
        coroutine.yield()
    end

    sprite:moveTo(originalPosX, originalPosY)
end

function MoveSprite(sprite, startX, startY, targetX, targetY, speed, parentSprite)
    local startPosX = startX
    local startPosY = startY
    sprite:moveTo(startPosX, startPosY)
    local transition = 0;

    while transition < 1 do
        transition = transition + speed      

       -- Move the sprite.
       -- You can also easily replace lerp with one of the easingFunctions.
       if parentSprite ~= nil and parentSprite == true then
        sprite:moveTo(
            playdate.math.lerp(sprite.mySprite.x, targetX, transition), 
            playdate.math.lerp(sprite.mySprite.y, targetY, transition)
       )
       else
       sprite:moveTo(
            playdate.math.lerp(sprite.x, targetX, transition), 
            playdate.math.lerp(sprite.y, targetY, transition)
       )
       end
       coroutine.yield()
    end
end

function ShowButtonPrompt(inputType, promptText)
    
end

for _, mySprite in pairs(allMySprites) do
    mySprite:add()
end
StateSwitchingCoroutine = coroutine.create( function() 
                                                SwitchState("editOrder")  
                                                end)