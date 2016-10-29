newInstance = function(ScenarioInfo, ScenarioFramework, healthMultiplier, removeWreckage, getRandomPlayer, killUnitsOnceExpired, spawnOutEffect, TransportDestinations)
    local spawnerClass = import('/maps/Final Rush Pro 5/src/SurvivalUnitSpawner.lua')

    return {
        newSpawner = function(hpIncreaseDelayInSeconds)
            return spawnerClass.newInstance(
                ScenarioInfo, ScenarioFramework, healthMultiplier, removeWreckage,
                getRandomPlayer, killUnitsOnceExpired, spawnOutEffect, TransportDestinations, hpIncreaseDelayInSeconds
            )
        end
    }
end

