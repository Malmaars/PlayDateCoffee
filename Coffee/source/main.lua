import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

local pd = playdate
local gfx = pd.graphics

import "scripts/Grinder"
import "scripts/MainMenu"
import "scripts/BeanChoice"
import "scripts/TestImage"


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

-- local TestImage = gfx.image.new("images/test")
-- local testSprite = gfx.sprite.new(TestImage)
-- testSprite:setZIndex(200)
-- testSprite:moveTo(200,120)
-- testSprite:add()

local transitionImage = gfx.image.new("images/transition")
local transitionSprite = gfx.sprite.new(transitionImage)
transitionSprite:setZIndex(100)
local transitionAnimator

function pd.update()
    
    grinderState:update()
    beanChoiceState.update()

    UpdateCoroutine(StateSwitchingCoroutine)

    gfx.sprite.update()
    playdate.timer.updateTimers()
end

function pd.AButtonDown()
    StartStateSwitch("bean choice")                                                
end

function pd.BButtonDown()
    StartStateSwitch("TestImage")                                                
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

    while transitionAnimator:ended()==false do

        local animatorValue = transitionAnimator:currentValue()

        transitionSprite:moveTo(200, animatorValue)
        local stateSwitch = false

        local newStateVariable
        if stateSwitch==false and transitionAnimator:currentValue() >= 120 then
            stateSwitch = true
            --run exitstate function
            if GameState=="grinder" then
                grinderState:onStateExit()
                newStateVariable = grinderState
            elseif GameState=="main menu" then
                mainmenuState:onStateExit()
                newStateVariable = mainmenuState
            elseif GameState=="bean choice" then
                beanChoiceState:onStateExit()
                newStateVariable = beanChoiceState
            elseif GameState=="TestImage" then
                testImageState.onStateExit()
            end

            --run enter state function
            if newState=="grinder" then
                grinderState:onStateEnter()
                newStateVariable = grinderState
            elseif newState=="main menu" then
                mainmenuState:onStateEnter()
                newStateVariable = mainmenuState
            elseif newState=="bean choice" then
                beanChoiceState:onStateEnter()
                newStateVariable = beanChoiceState
            elseif newState=="TestImage" then
                testImageState.onStateEnter()
                newStateVariable = testImageState
            end

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

function MoveSprite(sprite, targetX, targetY, speed)

    local startPosX = sprite.x
    local startPosY = sprite.y

    local transition = 0;

    while transition < 1 do
        transition = math.min(transition + speed, 1.0)      

       -- Move the sprite.
       -- You can also easily replace lerp with one of the easingFunctions.
       sprite:moveTo(
            playdate.math.lerp(startPosX, targetX, transition), 
            playdate.math.lerp(startPosY, targetY, transition)
       )
       coroutine.yield()
    end
end

StateSwitchingCoroutine = coroutine.create( function() 
                                                SwitchState("grinder")  
                                                end)