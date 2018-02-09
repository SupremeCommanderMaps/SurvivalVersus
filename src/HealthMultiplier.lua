local function multiplyUnitHealth(unit, multiplier)
    unit:SetMaxHealth(unit:GetMaxHealth() * multiplier)
    unit:SetHealth(unit, unit:GetMaxHealth() * multiplier)
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
            unit:SetVeterancy(5)
            multiplyUnitHealth(unit, multiplier)
        end
    end

    return this
end

local function newTeamBonusHealthMultiplier(playerArmies, balanceBonus)
    local function getArmyMultiplier(armyName)
        local bonusIsForTopTeam = balanceBonus > 0

        if bonusIsForTopTeam ~= ( armyName == "NEUTRAL_CIVILIAN" ) then
            return 1
        end

        return 1 - math.abs(balanceBonus) / 100
    end

    local function constructHealthMultiplicationFunction()
        if balanceBonus == 0 then
            return function() end
        end

        return function(unitGroup)
            for _, unit in unitGroup do
                multiplyUnitHealth(unit, getArmyMultiplier(unit:GetAIBrain().Name))
            end
        end
    end

    return {
        multiplyHealth = constructHealthMultiplicationFunction()
    }
end

newInstance = function(playerArmies, difficultyMultiplier, balanceBonus)
    local bonusHealthMultiplier = newTeamBonusHealthMultiplier(playerArmies, balanceBonus)

    return {
        increaseHealth = function(unitGroup, hpIncreaseDelay)
            local healhMultiplier = newTimeBasedHealthMultiplier(difficultyMultiplier, hpIncreaseDelay)
            healhMultiplier.multiplyHealth(unitGroup)
            bonusHealthMultiplier.multiplyHealth(unitGroup)
        end
    }
end
