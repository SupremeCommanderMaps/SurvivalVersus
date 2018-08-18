local function setupAutoReclaim(unitCreator, ScenarioInfo)
    if ScenarioInfo.Options.opt_AutoReclaim > 0 then
        unitCreator.onUnitCreated(function(unit, unitInfo)
            if unitInfo.isSurvivalSpawned then
                unit.CreateWreckage = function() end
            end
        end)
    end
end

local function setupUnitTimeouts(unitCreator, spawnOutEffect)
    unitCreator.onUnitCreated(function(unit, unitInfo)
        if unitInfo.isSurvivalSpawned then
            ForkThread(function()
                WaitSeconds(60*5)
                if not unit:IsDead() then
                    spawnOutEffect(unit)
                end
            end)
        end
    end)
end

local function setupTeamBalanceBonus(unitCreator, ScenarioInfo)
    if ScenarioInfo.Options.opt_FinalRushTeamBonusHP ~= 0 then
        local hpMultiplier = import('/maps/final_rush_pro_5.v0014/src/survival/TeamBonusHealthMultiplier.lua').newInstance(
            ScenarioInfo.Options.opt_FinalRushTeamBonusHP
        )

        unitCreator.onUnitCreated(function(unit, unitInfo)
            if unitInfo.isSurvivalSpawned or unitInfo.isTransport then
                hpMultiplier.multiplyHealth(unit)
            end
        end)
    end
end

local function setupHealthMultiplication(unitCreator, ScenarioInfo, options)
    if ScenarioInfo.Options.opt_FinalRushHealthIncrease ~= 0 then
        local healthMultiplier = import('/maps/final_rush_pro_5.v0014/src/survival/HealthMultiplier.lua').newInstance(
            ScenarioInfo.Options.opt_FinalRushHealthIncrease
        )

        unitCreator.onUnitCreated(function(unit, unitInfo)
            if unitInfo.hpIncrease ~= nil then
                local hpIncreaseDelays = {
                    [categories.TECH1] = options.getT1spawnDelay(),
                    [categories.TECH2] = options.getT2spawnDelay(),
                    [categories.TECH3] = options.getT3spawnDelay(),
                    [categories.EXPERIMENTAL] = options.getT4spawnDelay(),
                }

                if unitInfo.hpIncrease == true then
                    for techCategory, hpIncreaseDelay in hpIncreaseDelays do
                        if EntityCategoryContains(techCategory, unit) then
                            healthMultiplier.increaseHealth({unit}, hpIncreaseDelay)
                            break
                        end
                    end
                elseif hpIncreaseDelays[unitInfo.hpIncrease] ~= nil then
                    healthMultiplier.increaseHealth({unit}, hpIncreaseDelays[unitInfo.hpIncrease])
                end

            elseif unitInfo.hpIncreaseDelay ~= nil then
                healthMultiplier.increaseHealth({unit}, unitInfo.hpIncreaseDelay)
            end
        end)
    end
end

function newUnitCreator(ScenarioInfo, options, spawnOutEffect)
    local unitCreator = import('/maps/final_rush_pro_5.v0014/src/lib/UnitCreator.lua').newUnitCreator()

    setupAutoReclaim(unitCreator, ScenarioInfo)
    setupUnitTimeouts(unitCreator, spawnOutEffect)
    setupTeamBalanceBonus(unitCreator, ScenarioInfo)
    setupHealthMultiplication(unitCreator, ScenarioInfo, options)

    return unitCreator
end