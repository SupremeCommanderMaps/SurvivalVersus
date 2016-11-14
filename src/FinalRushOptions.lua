-- This function works around the FAF lobby not correctly defaulting the options
function defaultOptions(scenarioOptions)
    local defaults = {
        opt_gamemode = 0,
        opt_FinalRushDifficulty = 2,
        opt_tents = 9,
        opt_AutoReclaim = 50,
        opt_FinalRushRandomEvents = -1,
        opt_FinalRushSpawnDelay = -1,
        opt_FinalRushT1Frequency = -1,
        opt_FinalRushT2Delay = -1,
        opt_FinalRushT2Frequency = -1,
        opt_FinalRushT3Delay = -1,
        opt_FinalRushT3Frequency = -1,
        opt_FinalRushT4Delay = -1,
        opt_FinalRushT4Frequency = -1,
        opt_FinalRushHunterDelay = -1,
        opt_FinalRushHunters = -1,
        opt_FinalRushHealthIncrease = -1,
        opt_FinalRushAggression = -1,
        opt_FinalRushAir = 0,
        opt_timeunlocked = 0,
        opt_t2tml = 0,
        opt_t3arty = 0,
        opt_snipers = 0,
    }

    for optionName, defaultValue in pairs(defaults) do
        if (scenarioOptions[optionName] == nil) then
            scenarioOptions[optionName] = defaultValue
        end
    end

    return scenarioOptions
end

function applyPresets(scenarioOptions)
    local difficultyPreset = {
        opt_FinalRushSpawnDelay = {
            [1] = 180,
            [2] = 10,
            [3] = 10,
            [4] = 0,
            [5] = 0,
        },
        opt_FinalRushAggression = {
            [1] = 0,
            [2] = 1,
            [3] = 1,
            [4] = 1,
            [5] = 1,
        },
        opt_FinalRushRandomEvents = {
            [1] = 600,
            [2] = 90,
            [3] = 70,
            [4] = 50,
            [5] = 30,
        },
        opt_FinalRushHunters = {
            [1] = 0,
            [2] = 480,
            [3] = 300,
            [4] = 240,
            [5] = 120,
        },
        opt_FinalRushHunterDelay = {
            [1] = 0,
            [2] = 24 * 60,
            [3] = 22 * 60,
            [4] = 18 * 60,
            [5] = 16 * 60,
        },
        opt_FinalRushT1Frequency = {
            [1] = 6,
            [2] = 6,
            [3] = 6,
            [4] = 6,
            [5] = 6,
        },
        opt_FinalRushT2Frequency = {
            [1] = 6,
            [2] = 6,
            [3] = 6,
            [4] = 6,
            [5] = 6,
        },
        opt_FinalRushT3Frequency = {
            [1] = 10,
            [2] = 10,
            [3] = 10,
            [4] = 10,
            [5] = 10,
        },
        opt_FinalRushT4Frequency = {
            [1] = 12,
            [2] = 10,
            [3] = 10,
            [4] = 10,
            [5] = 8,
        },
        opt_FinalRushT2Delay = {
            [1] = 8 * 60,
            [2] = 6 * 60,
            [3] = 6 * 60,
            [4] = 5 * 60,
            [5] = 4 * 60,
        },
        opt_FinalRushT3Delay = {
            [1] = 16 * 60,
            [2] = 12 * 60,
            [3] = 12 * 60,
            [4] = 10 * 60,
            [5] = 8 * 60,
        },
        opt_FinalRushT4Delay = {
            [1] = 24 * 60,
            [2] = 18 * 60,
            [3] = 18 * 60,
            [4] = 16 * 60,
            [5] = 14 * 60,
        },
        opt_FinalRushHealthIncrease = {
            [1] = 0,
            [2] = 1 / 9,
            [3] = 0.25,
            [4] = 1,
            [5] = 2,
        }
    }

    for optionName, defaultValues in pairs(difficultyPreset) do
        if (scenarioOptions[optionName] == -1) then
            scenarioOptions[optionName] = defaultValues[scenarioOptions.opt_FinalRushDifficulty]
        end
    end

    return scenarioOptions
end

return {
    defaultOptions = defaultOptions,
    applyPresets = applyPresets
}
