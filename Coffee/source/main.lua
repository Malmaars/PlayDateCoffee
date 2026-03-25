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

-- local TestImage = gfx.image.new("images/test")
-- local testSprite = gfx.sprite.new(TestImage)
-- testSprite:setZIndex(200)
-- testSprite:moveTo(200,120)
-- testSprite:add()

local transitionImage = gfx.image.new("images/fullBlack")
local transitionSprite = gfx.sprite.new(transitionImage)
transitionSprite:setZIndex(100)
local transitionAnimator
local currentProduct

function pd.update()
    if CurrentState ~= nil then
        CurrentState:update()
    end

    UpdateCoroutine(StateSwitchingCoroutine)

    --draw the sprites
    gfx.sprite.update()
    
    --draw text after sprites so it's on top
    if CurrentState ~= nil then
        CurrentState:DrawAfterSprites()
    end 

    playdate.timer.updateTimers()
end

function pd.AButtonDown()
    CurrentState:OnAButtonDown()
end
function pd.AButtonUp()
    CurrentState:OnAButtonUp()
end
function pd.BButtonUp()
    CurrentState:OnBButtonUp()
end
function pd.BButtonDown()
    CurrentState:OnBButtonDown()
end

function pd.upButtonDown()
    CurrentState:OnUpButtonDown()
end
function pd.downButtonDown()
    CurrentState:OnDownButtonDown()
end

function pd.leftButtonDown()
    CurrentState:OnLeftButtonDown()
end

function pd.rightButtonDown()
    CurrentState:OnRightButtonDown()
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


function StartStateSwitch(newState)

    

    if StateSwitchingCoroutine == nil or coroutine.status(StateSwitchingCoroutine) == "dead" then     
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

StateSwitchingCoroutine = coroutine.create( function() 
                                                SwitchState("piston")  
                                                end)