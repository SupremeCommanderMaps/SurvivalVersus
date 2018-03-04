local function multiplyUnitHealth(unit, multiplier)
    unit:SetMaxHealth(unit:GetMaxHealth() * multiplier)
    unit:SetHealth(unit, unit:GetMaxHealth())
end

function newInstance(balanceBonus)
    local function getArmyMultiplier(armyName)
        local bonusIsForTopTeam = balanceBonus > 0

        if bonusIsForTopTeam ~= ( armyName == "NEUTRAL_CIVILIAN" ) then
            return 1
        end

        return 1 - math.abs(balanceBonus) / 100
    end

    return {
        multiplyHealth = function(unit)
            multiplyUnitHealth(unit, getArmyMultiplier(unit:GetAIBrain().Name))
        end
    }
end