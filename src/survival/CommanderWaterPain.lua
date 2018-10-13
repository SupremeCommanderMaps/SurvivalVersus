newInstance = function(playerArmies, textPrinter)
    local function unitIsInTheWater(unit)
        local layer = unit:GetCurrentLayer()
        return layer == "Water" or layer == "Seabed" or layer == "Sub"
    end

    local function shouldHurtUnit(unit)
        return unit and unitIsInTheWater(unit) and not unit:IsDead()
    end

    local function announceDrowning(unit)
        textPrinter.print(
            GetArmyBrain(unit:GetArmy()).Nickname .. " is drowning!   ",
            {size = 17, duration = 0.9, location = "rightcenter"}
        )
    end

    local function hurtUnit(unit)
        unit:SetHealth(unit, unit:GetHealth() - unit:GetMaxHealth() / 20)
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
        local CAN_BE_IDLE = false
        local NEEDS_TO_BE_BUILD = true

        while true do
            WaitSeconds(1)

            for armyIndex in playerArmies.getIndexToNameMap() do
                killUnitsInTheWater(
                    ArmyBrains[armyIndex]:GetListOfUnits(categories.COMMAND, CAN_BE_IDLE, NEEDS_TO_BE_BUILD)
                )
            end
        end
    end

    return {
        runThread = function()
            ForkThread(waterPainThread)
        end
    }
end