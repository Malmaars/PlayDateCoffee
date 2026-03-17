import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "CoroutineManager"

   Grinder = {}

    local pd = playdate
    local gfx = pd.graphics

    local currentGrinderIndex = 1
    local grinderShakeTimer = pd.timer.new(0)
    local grinderShakeTimerLength = 1
    local grinderShakeCoroutine

    local moveDownCoroutine
    local moveUpCoroutine

    local cursorMin = 220
    local cursorMax = 20

    local allMySprites

    function Grinder.new()
        local self = setmetatable({}, Grinder)    
        
        self.grinder = playdate.graphics.imagetable.new("images/grinder")
        self.mp = playdate.graphics.tilemap.new()
        self.mp:setImageTable(self.grinder)
        self.grinderSprite = playdate.graphics.sprite.new(self.mp)
        self.grinderSprite:moveTo(120,120)

        self.backgroundImage = gfx.image.new("images/transition")
        self.backgroundSprite = gfx.sprite.new(self.backgroundImage)
        self.backgroundSprite:setZIndex(-2)
        self.backgroundSprite:moveTo(200,120)

        self.BarImage = gfx.image.new("images/FillBar")
        self.BarSprite = gfx.sprite.new(self.BarImage)
        self.BarSprite:setZIndex(1)
        self.BarSprite:moveTo(290, 120)

        self.cursorImage = gfx.image.new("images/cursor")
        self.cursorSprite = gfx.sprite.new(self.cursorImage)
        self.cursorSprite:setZIndex(2)
        self.cursorSprite:moveTo(330,120)


        self.BarAlignImage = gfx.image.new("images/BarAlign")
        self.BarAlignSprite = gfx.sprite.new(self.BarAlignImage)
        self.BarAlignSprite:setZIndex(2)
        self.BarAlignSprite:moveTo(290,120)


        allMySprites = {self.grinderSprite, self.backgroundSprite, self.BarSprite, self.BarAlignSprite, self.cursorSprite}
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

            if currentGrinderIndex ~= grinderTableIndex and (grinderShakeCoroutine == nil or coroutine.status(grinderShakeCoroutine) == "dead") and coroutine.status(moveUpCoroutine) == "dead" and coroutine.status(moveDownCoroutine) == "dead" then
                grinderShakeCoroutine = coroutine.create(   function()
                                                                ShakeSprite(self.grinderSprite, 500)
                                                             end)
            end

            if currentGrinderIndex ~= grinderTableIndex then
                self:CheckGrinderHit()
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

    function Grinder:CheckGrinderHit()
        if (self.cursorSprite.y > self.BarAlignSprite.y + 1 and self.cursorSprite.y < self.BarAlignSprite.y + 12) or (self.cursorSprite.y < self.BarAlignSprite.y - 1 and self.cursorSprite.y > self.BarAlignSprite.y - 12) then
            --Good!           
        elseif(self.cursorSprite.y > self.BarAlignSprite.y - 1 and self.cursorSprite.y < self.BarAlignSprite.y + 1) then
            --Near Miss!
        elseif(self.cursorSprite.y == self.BarAlignSprite.y - 12 or self.cursorSprite.y == self.BarAlignSprite.y + 12) then
            --Perfect!
        else
            --Miss!
        end

    end

    
    function Grinder:onStateExit()
        if moveUpCoroutine then
            coroutine.close(moveUpCoroutine)
        end
        moveDownCoroutine = coroutine.create(  function()
                                                        MoveSprite(self.grinderSprite, 140, 360, 0.05)
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
                                                        MoveSprite(self.grinderSprite, 140, 120, 0.05)
                                                    end)
        for _, mySprite in pairs(allMySprites) do
            mySprite:add()
        end
    end

    function Grinder:OnDownButtonDown()
    end
    function Grinder:OnUpButtonDown()
        StartStateSwitch("bean choice")
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
