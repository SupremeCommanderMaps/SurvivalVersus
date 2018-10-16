newInstance = function(playerArmies, textPrinter)
    local function unitIsInTheWater(unit)
        local layer = unit:GetCurrentLayer()
        return layer == "Water" or layer == "Seabed" or layer == "Sub"
    end

    local function shouldHurtUnit(unit)
        return unit and unitIsInTheWater(unit) and not unit:IsDead()
    end

    local function announceDrowning(unit)
        local armyBrain = GetArmyBrain(unit:GetArmy())
        armyBrain:OnPlayCommanderUnderAttackVO()
        textPrinter.print(
            armyBrain.Nickname .. " is drowning!   ",
            {size = 17, duration = 0.9, location = "rightcenter"}
        )
    end

    local function hurtUnit(unit)
        unit:AdjustHealth(unit, unit:GetMaxHealth() / -20)

        if unit:GetHealth() < 0.5 then
            unit:Kill()
        end
    end

    local killUnitsInTheWater = function(units)
        for _, unit in units do
            if shouldHurtUnit(unit) then
                announceDrowning(unit)
                hurtUnit(unit)
            end
        end
    end

    local function waterPainThread()
        while true do
            WaitSeconds(1)
            killUnitsInTheWater(playerArmies.getUnitsInCategory(categories.COMMAND))
        end
    end

    return {
        runThread = function()
            ForkThread(waterPainThread)
        end
    }
end