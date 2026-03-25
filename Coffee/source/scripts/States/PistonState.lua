import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "../CoroutineManager"

   PistonState = {}

    local pd = playdate
    local gfx = pd.graphics

    local allMySprites
    local currentPistonAngleIndex
    local pistonLocked
    local pistonLockCoroutine
    local lockPosition = 13

    local pistonClicked

    function PistonState.new()
        local self = setmetatable({}, PistonState)    

        self.backgroundImage = gfx.image.new("images/FullBlack")
        self.backgroundSprite = gfx.sprite.new(self.backgroundImage)
        self.backgroundSprite:setZIndex(-2)
        self.backgroundSprite:moveTo(200,120)

        self.piston = playdate.graphics.imagetable.new("images/piston")
        self.mp = playdate.graphics.tilemap.new()
        self.mp:setImageTable(self.piston)
        self.pistonSprite = playdate.graphics.sprite.new(self.mp)
        self.pistonSprite:setZIndex(1)

        local espressoMachineImage = gfx.image.new("images/EspressoMachine")
        self.espressoMachineSprite = gfx.sprite.new(espressoMachineImage)
        self.espressoMachineSprite:setZIndex(5)
        self.espressoMachineSprite:moveTo(200,120)

        local PistonClickImage = gfx.imagetable.new("images/PistonClickIn")
        self.pistonClickLoop = gfx.animation.loop.new(20, PistonClickImage, false)
        self.pistonClickSprite = gfx.sprite.new(self.pistonClickLoop:image())
        self.pistonClickSprite:setZIndex(6)
        self.pistonClickSprite:moveTo(200,120)

        self.buttonImage = gfx.image.new("images/EspressoButton")
        self.buttonPressedImage = gfx.image.new("images/EspressoButtonPressed")

        self.leftButton = gfx.sprite.new(self.buttonImage)
        self.leftButton:moveTo(140,67)
        self.leftButton:setZIndex(6)
        self.leftButtonText = TextClass:new("B", 140, 68, 7, FontAmmoliteLarge,nil)


        self.rightButton = gfx.sprite.new(self.buttonImage)
        self.rightButton:moveTo(244,67)
        self.rightButton:setZIndex(6)
        self.rightButtonText = TextClass:new("A", 244, 67, 7, FontAmmoliteLarge,nil)

        allMySprites = {self.backgroundSprite, self.pistonSprite, self.espressoMachineSprite, self.pistonClickSprite, 
        self.leftButton, self.leftButtonText, self.rightButton, self.rightButtonText}
      return self
    end
    
    function PistonState:update()
        self:AnimatePiston()
        UpdateCoroutine(pistonLockCoroutine)
        self.pistonClickSprite:setImage(self.pistonClickLoop:image())
    end
    function PistonState:DrawAfterSprites()
    end

    function PistonState:AnimatePiston()
        local crankAngle = pd.getCrankPosition()

        if pistonClicked == false then
            --index 1 should be at 270, end should be at 180
            if currentPistonAngleIndex == nil then
                currentPistonAngleIndex = 14;
            end

            --only change the position of the piston based on the current index position
            if crankAngle >= 268  and crankAngle < 272 then--and currentPistonAngleIndex == 2 then
                currentPistonAngleIndex = 13

            elseif crankAngle < 268 and crankAngle > 260 then--and (currentPistonAngleIndex == 11 or currentPistonAngleIndex == 13) then
                currentPistonAngleIndex = 12
            elseif crankAngle <= 260 and crankAngle > 252 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 10 or currentPistonAngleIndex == 12) then
                currentPistonAngleIndex = 11
            elseif crankAngle <= 252 and crankAngle > 244 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 9 or currentPistonAngleIndex == 11) then
                currentPistonAngleIndex = 10
            elseif crankAngle <= 244 and crankAngle > 236 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 8 or currentPistonAngleIndex == 10) then
                currentPistonAngleIndex = 9
            elseif crankAngle <= 236 and crankAngle > 228 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 7 or currentPistonAngleIndex == 9) then
                currentPistonAngleIndex = 8
            elseif crankAngle <= 228 and crankAngle > 220 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 6 or currentPistonAngleIndex == 8) then
                currentPistonAngleIndex = 7
            elseif crankAngle <= 220 and crankAngle > 212 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 5 or currentPistonAngleIndex == 7) then
                currentPistonAngleIndex = 6
            elseif crankAngle <= 212 and crankAngle > 204 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 4 or currentPistonAngleIndex == 6) then
                currentPistonAngleIndex = 5
            elseif crankAngle <= 204 and crankAngle > 196 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 3 or currentPistonAngleIndex == 5) then
                currentPistonAngleIndex = 4
            elseif crankAngle <= 196 and crankAngle > 188 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 2 or currentPistonAngleIndex == 4) then
                currentPistonAngleIndex = 3
            elseif crankAngle <= 188 and crankAngle > 180 and currentPistonAngleIndex ~= 14 then--and (currentPistonAngleIndex == 1 or currentPistonAngleIndex == 3) then
                currentPistonAngleIndex = 2
            elseif crankAngle <= 180 and currentPistonAngleIndex ~= 14 then--and currentPistonAngleIndex == 2 then
                currentPistonAngleIndex = 1
                if pistonLocked == true then
                    self.pistonClickLoop.frame = 1
                    pistonClicked = true
                end
            else
                currentPistonAngleIndex = 14
            end
        end
        if pistonLocked == false and currentPistonAngleIndex == lockPosition then
                -- lock it in, move the sprite up
                pistonLockCoroutine = coroutine.create(  function()
                                                MoveSprite(self.pistonSprite, 200, 145, 200, 133, 0.2, false)
                                            end)
                pistonLocked = true
            end


            self.pistonSprite:setImage(self.piston:getImage(currentPistonAngleIndex))    


    end
    function PistonState:OnDownButtonDown()
        StartStateSwitch("grinder")
    end
    function PistonState:OnUpButtonDown()
        StartStateSwitch("order")
    end
    function PistonState:OnLeftButtonDown()
        self:onStateEnter()
    end
    function PistonState:OnRightButtonDown()
    end
    function PistonState:OnAButtonDown()
        self.rightButton:setImage(self.buttonPressedImage)
    end
    function PistonState:OnBButtonDown()
        self.leftButton:setImage(self.buttonPressedImage)
    end  
    function PistonState:OnAButtonUp()
        self.rightButton:setImage(self.buttonImage)
    end
    function PistonState:OnBButtonUp()
        self.leftButton:setImage(self.buttonImage)
    end    
    function PistonState:onStateExit()
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
    end

    function PistonState:onStateEnter()
        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end
        pistonLocked = false
        lockPosition = math.random(10,13)
        pistonClicked = false
        self.pistonSprite:moveTo(200,145)
        currentPistonAngleIndex = 14;
        self.rightButton:setImage(self.buttonImage)
        self.leftButton:setImage(self.buttonImage)
    end
    
    function PistonState.__index(tab, key)
        return PistonState[key]
    end
