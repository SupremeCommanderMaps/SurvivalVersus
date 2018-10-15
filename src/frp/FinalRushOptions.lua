local SURVIVAL_VERSUS = 0
local SURVIVAL_CLASSIC = 1
local PARAGON_WARS = 2

local VERY_EASY = 1
local EASIER = 2
local EASY = 3
local NORMAL = 4
local HARD = 5
local HARDER = 6
local VERY_HARD = 7
local INSANE = 8

local SET_BY_PRESET = -1337

local defaults = {
    RestrictedCategories = {},
    opt_gamemode = SURVIVAL_VERSUS,
    opt_FinalRushDifficulty = NORMAL,
    opt_FinalRushTeamBonusReclaim = 0,
    opt_FinalRushTeamBonusHP = 0,
    opt_tents = 9,
    opt_FinalRushAutoReclaim = SET_BY_PRESET,
    opt_FinalRushAir = 0,
    opt_timeunlocked = 0,
    opt_t2tml = SET_BY_PRESET,
    opt_t3arty = SET_BY_PRESET,
    opt_FinalRushEventNotifications = 1,
    opt_FinalRushKillableTransports = 0,
    opt_FinalRushWaterKillsACUs = 2,
    opt_FinalRushNukesAndArty = 0,
    opt_FinalRushRandomEvents = SET_BY_PRESET,
    opt_FinalRushSpawnDelay = SET_BY_PRESET,
    opt_FinalRushEscalationSpeed = SET_BY_PRESET,
    opt_FinalRushUnitCount = SET_BY_PRESET,
    opt_FinalRushHunterDelay = SET_BY_PRESET,
    opt_FinalRushHunters = SET_BY_PRESET,
    opt_FinalRushHealthIncrease = SET_BY_PRESET,
}

local optionsThatGotDefaulted = {}

-- This function works around the FAF lobby not correctly defaulting the options
local function defaultOptions(scenarioOptions)
    for optionName, defaultValue in pairs(defaults) do
        if (scenarioOptions[optionName] == nil) then
            scenarioOptions[optionName] = defaultValue
            optionsThatGotDefaulted[optionName] = true
        end
    end

    return scenarioOptions
end

local function applyPresets(scenarioOptions)
    local difficultyPreset = {
        opt_FinalRushSpawnDelay = {
            [VERY_EASY] = 180,
            [EASIER] = 10,
            [EASY] = 10,
            [NORMAL] = 10,
            [HARD] = 10,
            [HARDER] = 10,
            [VERY_HARD] = 0,
            [INSANE] = 0,
        },
        opt_FinalRushEscalationSpeed = {
            [VERY_EASY] = 8 * 60,
            [EASIER] = 7 * 60,
            [EASY] = 6 * 60,
            [NORMAL] = 6 * 60,
            [HARD] = 6 * 60,
            [HARDER] = 5.5 * 60,
            [VERY_HARD] = 5 * 60,
            [INSANE] = 4.5 * 60,
        },
        opt_FinalRushUnitCount = {
            [VERY_EASY] = 0.7,
            [EASIER] = 0.85,
            [EASY] = 1,
            [NORMAL] = 1,
            [HARD] = 1.05,
            [HARDER] = 1.15,
            [VERY_HARD] = 1.3,
            [INSANE] = 1.5,
        },
        opt_FinalRushRandomEvents = {
            [VERY_EASY] = 600,
            [EASIER] = 90,
            [EASY] = 80,
            [NORMAL] = 70,
            [HARD] = 70,
            [HARDER] = 60,
            [VERY_HARD] = 50,
            [INSANE] = 30,
        },
        opt_FinalRushHunters = {
            [VERY_EASY] = 0,
            [EASIER] = 480,
            [EASY] = 420,
            [NORMAL] = 360,
            [HARD] = 300,
            [HARDER] = 270,
            [VERY_HARD] = 240,
            [INSANE] = 120,
        },
        opt_FinalRushHunterDelay = {
            [VERY_EASY] = 0,
            [EASIER] = 35 * 60,
            [EASY] = 30 * 60,
            [NORMAL] = 25 * 60,
            [HARD] = 22 * 60,
            [HARDER] = 20 * 60,
            [VERY_HARD] = 17 * 60,
            [INSANE] = 15 * 60,
        },
        opt_FinalRushHealthIncrease = {
            [VERY_EASY] = 0,
            [EASIER] = 0.1,
            [EASY] = 0.14,
            [NORMAL] = 0.18,
            [HARD] = 0.22,
            [HARDER] = 0.25,
            [VERY_HARD] = 0.75,
            [INSANE] = 2,
        },
        opt_FinalRushAutoReclaim = {
            [VERY_EASY] = 50,
            [EASIER] = -100,
            [EASY] = -50,
            [NORMAL] = -50,
            [HARD] = -50,
            [HARDER] = -50,
            [VERY_HARD] = -50,
            [INSANE] = -50,
        },
        opt_t2tml = {
            [VERY_EASY] = 1,
            [EASIER] = 1,
            [EASY] = 0,
            [NORMAL] = 0,
            [HARD] = 0,
            [HARDER] = 0,
            [VERY_HARD] = 0,
            [INSANE] = 0,
        },
        opt_t3arty = {
            [VERY_EASY] = 1,
            [EASIER] = 0,
            [EASY] = 0,
            [NORMAL] = 0,
            [HARD] = 0,
            [HARDER] = 0,
            [VERY_HARD] = 0,
            [INSANE] = 0,
        }
    }

    for optionName, defaultValues in pairs(difficultyPreset) do
        if (scenarioOptions[optionName] == SET_BY_PRESET) then
            scenarioOptions[optionName] = defaultValues[scenarioOptions.opt_FinalRushDifficulty]
        end
    end

    return scenarioOptions
end

function newInstance(ScenarioInfoOptions)
    local rawOptions = applyPresets(defaultOptions(ScenarioInfoOptions))

    local this = {}

    this.getRawOptions = function()
        return rawOptions
    end

    this.isSurvivalGame = function()
        return rawOptions.opt_gamemode == SURVIVAL_VERSUS or rawOptions.opt_gamemode == SURVIVAL_CLASSIC
    end

    this.isSurvivalVersus = function()
        return rawOptions.opt_gamemode == SURVIVAL_VERSUS
    end

    this.isSurvivalClassic = function()
        return rawOptions.opt_gamemode == SURVIVAL_CLASSIC
    end

    this.isParagonWars = function()
        return rawOptions.opt_gamemode == PARAGON_WARS
    end

    this.canKillTransports = function()
        if rawOptions.opt_FinalRushKillableTransports == 0 then
            return this.isSurvivalVersus()
        else
            return rawOptions.opt_FinalRushKillableTransports == 2
        end
    end

    this.waterKillsAcu = function()
        if rawOptions.opt_FinalRushWaterKillsACUs == 0 then
            return this.isSurvivalClassic()
        else
            return rawOptions.opt_FinalRushWaterKillsACUs == 2
        end
    end

    this.isNonDefault = function(optionName)
        return optionsThatGotDefaulted[optionName] or false
    end

    this.shouldSpawnMML = function()
        return rawOptions.opt_t2tml == 0
    end

    this.shouldSpawnT3Arty = function()
        return rawOptions.opt_t3arty == 0
    end

    this.getT1spawnDelay = function()
        return ScenarioInfo.Options.opt_FinalRushSpawnDelay
    end

    this.getT2spawnDelay = function()
        return ScenarioInfo.Options.opt_FinalRushSpawnDelay + 1 * ScenarioInfo.Options.opt_FinalRushEscalationSpeed
    end

    this.getT3spawnDelay = function()
        return ScenarioInfo.Options.opt_FinalRushSpawnDelay + 2 * ScenarioInfo.Options.opt_FinalRushEscalationSpeed
    end

    this.getT4spawnDelay = function()
        return ScenarioInfo.Options.opt_FinalRushSpawnDelay + 3 * ScenarioInfo.Options.opt_FinalRushEscalationSpeed
    end

    this.getStage6StartTime = function()
        return ScenarioInfo.Options.opt_FinalRushSpawnDelay + 5 * ScenarioInfo.Options.opt_FinalRushEscalationSpeed
    end

    this.shouldDisableNukesAndArty = function()
        return rawOptions.opt_FinalRushNukesAndArty == 0
    end

    this.shouldDisableWreckages = function()
        return rawOptions.opt_FinalRushAutoReclaim ~= 0
    end

    this.getAutoReclaimPercentage = function()
        return math.abs(rawOptions.opt_FinalRushAutoReclaim)
    end

    this.autoRelciamDeclines = function()
        return rawOptions.opt_FinalRushAutoReclaim < 0
    end

    return this
end

return newInstance
