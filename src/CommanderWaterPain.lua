newInstance = function(getAllUnits, textPrinter)
    local function unitIsInTheWater(unit)
        local layer = unit:GetCurrentLayer()
        return layer == "Water" or layer == "Seabed" or layer == "Sub"
    end

    local function shouldHurtUnit(unit)
        return EntityCategoryContains(categories.COMMAND, unit) and unitIsInTheWater(unit) and unit and not unit:IsDead()
    end

    local function announceDrowning(unit)
        textPrinter.print(
            GetArmyBrain(unit:GetArmy()).Nickname .. " is drowning!",
            {size = 15, duration = 2}
        )
    end

    local function hurtUnit(unit)
        unit:SetHealth(unit ,unit:GetHealth() - (unit:GetMaxHealth() / 10))
        if unit:GetHealth() < 10 then
            unit:Kill()
        end
    end

    local killCommandUnitsOnLayer = function()
        local units = getAllUnits()
        if units and table.getn(units) > 0 then
            for _, unit in units do
                if shouldHurtUnit(unit) then
                    announceDrowning(unit)
                    hurtUnit(unit)
                end
            end
        end
    end

    local function waterPainThread()
        while true do
            WaitSeconds(2)
            killCommandUnitsOnLayer()
        end
    end

    return {
        runThread = function()
            ForkThread(waterPainThread)
        end
    }
end