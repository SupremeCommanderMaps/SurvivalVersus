local function multiplyUnitHealth(unit, multiplier)
    unit:SetMaxHealth(unit:GetMaxHealth() * multiplier)
    unit:SetHealth(unit, unit:GetMaxHealth())
end

local function newTimeBasedHealthMultiplier(increasePerHundredSeconds, hpIncreaseDelay)
    local this = {}

    local function computeMultiplier()
        local secondsSinceStartOfIncrease = GetGameTimeSeconds() - hpIncreaseDelay
        secondsSinceStartOfIncrease = secondsSinceStartOfIncrease >= 0 and secondsSinceStartOfIncrease or 0

        return 1 + increasePerHundredSeconds * secondsSinceStartOfIncrease / 100
    end

    this.multiplyHealth = function(unitGroup)
        local multiplier = computeMultiplier()

        if multiplier <= 0 then return end

        for _, unit in unitGroup do
            multiplyUnitHealth(unit, multiplier)
        end
    end

    return this
end

newInstance = function(difficultyMultiplier)
    return {
        increaseHealth = function(unitGroup, hpIncreaseDelay)
            local healhMultiplier = newTimeBasedHealthMultiplier(difficultyMultiplier, hpIncreaseDelay)
            healhMultiplier.multiplyHealth(unitGroup)
        end
    }
end
