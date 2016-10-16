newInstance = function(gameMode, totalVeterancyIsEnabled)
    local function getVeterancyLevel()
        local levels = {
            [4] = 1, --normal
            [5] = 3, --hard
            [6] = 5, --insane
        }

        return levels[gameMode]
    end

    local function getHealthMultiplier(hpIncreaseDelay)
        local difficultyMultiplier = {
            [4] = 0.25, --normal
            [5] = 1, --hard
            [6] = 4, --insane
        }

        local secondsAfterStart = GetGameTimeSeconds() - hpIncreaseDelay
        secondsAfterStart = secondsAfterStart >= 0 and secondsAfterStart or 0
        return 1 + difficultyMultiplier[gameMode] * secondsAfterStart / 100
    end

    local function increaseHealthNormally(unitGroup, hpIncreaseDelay)
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
