import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"
import "CoreLibs/animation"
import "CoreLibs/ui"

import "../CoroutineManager"

   Grinder = {}

    local pd = playdate
    local gfx = pd.graphics

    local currentGrinderIndex = 1
    local grinderShakeCoroutine

    local moveDownCoroutine
    local moveUpCoroutine

    local cursorMin = 220
    local cursorMax = 20

    local allMySprites
    local performanceTimer
    local correctlyHitGrinds = 0


    function Grinder.new()
        local self = setmetatable({}, Grinder)    
        
        self.grinder = playdate.graphics.imagetable.new("images/grinder")
        self.mp = playdate.graphics.tilemap.new()
        self.mp:setImageTable(self.grinder)
        self.grinderSprite = playdate.graphics.sprite.new(self.mp)
        self.grinderSprite:moveTo(120,120)

        self.backgroundImage = gfx.image.new("images/fullBlack")
        self.backgroundSprite = gfx.sprite.new(self.backgroundImage)
        self.backgroundSprite:setZIndex(-2)
        self.backgroundSprite:moveTo(200,120)

        self.BarImage = gfx.image.new("images/FillBar")
        self.BarSprite = gfx.sprite.new(self.BarImage)
        self.BarSprite:setZIndex(1)
        self.BarSprite:moveTo(340, 120)
        
        self.BarAlignImage = gfx.image.new("images/BarAlign")
        self.BarAlignSprite = gfx.sprite.new(self.BarAlignImage)
        self.BarAlignSprite:setZIndex(2)
        self.BarAlignSprite:moveTo(340,120)

        self.cursorImage = gfx.image.new("images/cursor")
        self.cursorSprite = gfx.sprite.new(self.cursorImage)
        self.cursorSprite:setZIndex(2)
        self.cursorSprite:moveTo(380,120)

        self.perfectAnimationImage = gfx.imagetable.new("images/perfect")
        self.perfectAnimationLoop = gfx.animation.loop.new(40, self.perfectAnimationImage, false)
        self.perfectAnimationSprite = gfx.sprite.new(self.perfectAnimationLoop:image())
        self.perfectAnimationSprite:setZIndex(6)
        self.perfectAnimationSprite:moveTo(260,120)

        self.greatAnimationImage = gfx.imagetable.new("images/great")
        self.greatAnimationLoop = gfx.animation.loop.new(40, self.greatAnimationImage, false)
        self.greatAnimationSprite = gfx.sprite.new(self.greatAnimationLoop:image())
        self.greatAnimationSprite:setZIndex(6)
        self.greatAnimationSprite:moveTo(260,120)

        self.fasterAnimationImage = gfx.imagetable.new("images/faster")
        self.fasterAnimationLoop = gfx.animation.loop.new(40, self.fasterAnimationImage, false)
        self.fasterAnimationSprite = gfx.sprite.new(self.fasterAnimationLoop:image())
        self.fasterAnimationSprite:setZIndex(6)
        self.fasterAnimationSprite:moveTo(260,120)

        self.slowerAnimationImage = gfx.imagetable.new("images/slower")
        self.slowerAnimationLoop = gfx.animation.loop.new(40, self.slowerAnimationImage, false)
        self.slowerAnimationSprite = gfx.sprite.new(self.slowerAnimationLoop:image())
        self.slowerAnimationSprite:setZIndex(6)
        self.slowerAnimationSprite:moveTo(260,120)

        performanceTimer = pd.timer.new(700, function() CheckGrinderHit(self, performanceTimer) end)

        allMySprites = {self.grinderSprite, self.backgroundSprite, self.BarSprite, self.BarAlignSprite, self.cursorSprite, 
                        self.perfectAnimationSprite, self.greatAnimationSprite, self.fasterAnimationSprite, self.slowerAnimationSprite}
      return self
    end

    function Grinder:update()
        if GameState=="grinder"then
            self:AnimateGrinder()
        end

        self:MoveCursor()

        UpdateCoroutine(grinderShakeCoroutine)
        UpdateCoroutine(moveDownCoroutine)
        UpdateCoroutine(moveUpCoroutine)

        self.perfectAnimationSprite:setImage(self.perfectAnimationLoop:image())
        self.greatAnimationSprite:setImage(self.greatAnimationLoop:image())
        self.slowerAnimationSprite:setImage(self.slowerAnimationLoop:image())
        self.fasterAnimationSprite:setImage(self.fasterAnimationLoop:image())
    end

    function Grinder:AnimateGrinder()
        local crankAngle = pd.getCrankPosition()

        
        local grinderTableIndex = 1;
        if crankAngle > 22.5 and crankAngle <= 67.5 then
            grinderTableIndex = 2
        elseif crankAngle > 67.5 and crankAngle <= 112.5 then
            grinderTableIndex = 3
        elseif crankAngle > 112.5 and crankAngle <= 157.5 then
            grinderTableIndex = 4
        elseif crankAngle > 157.5 and crankAngle <= 202.5 then
            grinderTableIndex = 5
        elseif crankAngle > 202.5 and crankAngle <= 247.5 then
            grinderTableIndex = 6
        elseif crankAngle > 247.5 and crankAngle <= 292.5 then
            grinderTableIndex = 7
        elseif crankAngle > 292.5 and crankAngle <= 337.5 then
            grinderTableIndex = 8
        end
            self.grinderSprite:setImage(self.grinder:getImage(grinderTableIndex))    

            if currentGrinderIndex ~= grinderTableIndex and (grinderShakeCoroutine == nil or coroutine.status(grinderShakeCoroutine) == "dead") and (moveUpCoroutine == nil or coroutine.status(moveUpCoroutine) == "dead") and (moveDownCoroutine == nil or coroutine.status(moveDownCoroutine) == "dead") then
                grinderShakeCoroutine = coroutine.create(   function()
                                                                ShakeSprite(self.grinderSprite, 500)
                                                             end)
            end

            if currentGrinderIndex ~= grinderTableIndex then
                --self:CheckGrinderHit()
            end
            currentGrinderIndex = grinderTableIndex

    end

    function Grinder:MoveCursor()
        local change, acceleratedChange = playdate.getCrankChange()
        local crankChange = change
        if crankChange < 0 then
            crankChange = 0
        end 
        if crankChange > 15.4 then
            crankChange = 15.4
        end

        
        crankChange = math.floor(crankChange + 0.5)

        local targetCursorPosition = cursorMin - ((cursorMin - cursorMax) / 15 * crankChange)
        
        self.cursorSprite:moveTo(
        self.cursorSprite.x,
        playdate.math.lerp(self.cursorSprite.y, targetCursorPosition, 0.02))
    end

    function CheckGrinderHit(grinder, timer)
        if grinder.cursorSprite.y >= 119 and grinder.cursorSprite.y <= 121 then
            grinder.perfectAnimationLoop.frame = 1
            correctlyHitGrinds += 1
        elseif (grinder.cursorSprite.y > 121 and grinder.cursorSprite.y <= 132) or (grinder.cursorSprite.y < 119 and grinder.cursorSprite.y >= 108) then
            grinder.greatAnimationLoop.frame = 1
            correctlyHitGrinds += 1
        elseif grinder.cursorSprite.y < 108 then
            grinder.slowerAnimationLoop.frame = 1
        elseif grinder.cursorSprite.y > 132 then
            grinder.fasterAnimationLoop.frame = 1
        end
        performanceTimer = pd.timer.new(700, function() CheckGrinderHit(grinder, performanceTimer) end)
    end

    
    function Grinder:onStateExit()
        if moveUpCoroutine then
            coroutine.close(moveUpCoroutine)
        end
        moveDownCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.grinderSprite, self.grinderSprite.x, self.grinderSprite.y, 140, 360, 0.05, false)
                                                    end)
        for _, mySprite in pairs(allMySprites) do
            mySprite:remove()
        end
    end

    function Grinder:onStateEnter()
        if moveDownCoroutine then
            coroutine.close(moveDownCoroutine)
        end
        moveUpCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.grinderSprite, 140, 400, 140, 130, 0.05, false)
                                                    end)
        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end

        correctlyHitGrinds = 0
    end
    function Grinder:DrawAfterSprites()
        if pd.isCrankDocked() then
            pd.ui.crankIndicator:draw(0,0)
        end
    end
    function Grinder:OnDownButtonDown()
        StartStateSwitch("bean choice")
    end
    function Grinder:OnUpButtonDown()
    end
    function Grinder:OnLeftButtonDown()
    end
    function Grinder:OnRightButtonDown()
    end
    function Grinder:OnAButtonDown()
    end
    function Grinder:OnBButtonDown()
    end

    function Grinder.__index(tab, key)
        return Grinder[key]
    end
