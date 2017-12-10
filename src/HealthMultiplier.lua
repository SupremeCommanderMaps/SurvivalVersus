newInstance = function(gameDifficulty, difficultyMultiplier, totalVeterancyIsEnabled)
    local function getVeterancyLevel()
        local levels = {
            [1] = 1,
            [2] = 1,
            [3] = 3,
            [4] = 4,
            [5] = 5,
        }

        return levels[gameDifficulty]
    end

    local function getHealthMultiplier(hpIncreaseDelay)
        local secondsAfterStart = GetGameTimeSeconds() - hpIncreaseDelay
        secondsAfterStart = secondsAfterStart >= 0 and secondsAfterStart or 0

        return 1 + difficultyMultiplier * secondsAfterStart / 100
    end

    local function increaseHealthNormally(unitGroup, hpIncreaseDelay)
        if difficultyMultiplier <= 0 then return end

        local hp_multi = getHealthMultiplier(hpIncreaseDelay)
        local vetLevel = getVeterancyLevel()

        for _, value in unitGroup do
            value:SetVeterancy(vetLevel)
            value:SetMaxHealth(value:GetMaxHealth() * hp_multi)
            value:SetHealth(value ,value:GetMaxHealth() * hp_multi)
        end
    end

    local function incraseHealthForTotalVeterancy(unitGroup, hpIncreaseDelay)
        local hp_multi = getHealthMultiplier(hpIncreaseDelay)
        local TVGlevel = math.floor((current_time - (hpIncreaseDelay / 2)) / 30 * difficulty_multi)

        for _, value in unitGroup do
            value:AddLevels(TVGlevel)
            value:SetMaxHealth(value:GetMaxHealth() * hp_multi)
            value:SetHealth(value ,value:GetMaxHealth() * hp_multi)
        end
    end

    return {
        increaseHealth = function(unitGroup, hpIncreaseDelay)
            if totalVeterancyIsEnabled then
                incraseHealthForTotalVeterancy(unitGroup, hpIncreaseDelay)
            else
                increaseHealthNormally(unitGroup, hpIncreaseDelay)
            end
        end
    }
end
