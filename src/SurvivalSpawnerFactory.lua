newInstance = function(options, ScenarioFramework, unitCreator, playerArmies, healthMultiplier, getRandomPlayer,
                        spawnOutEffect, TransportDestinations, getAllUnits)

    local transportSpawnerClass = import('/maps/final_rush_pro_5.7.v0001/src/SurvivalTransportSpawner.lua')
    local unitSpawnerClass = import('/maps/final_rush_pro_5.7.v0001/src/SurvivalUnitSpawner.lua')

    return {
        newTransportSpawner = function(hpIncreaseDelayInSeconds)
            return transportSpawnerClass.newInstance(
                options, unitCreator, healthMultiplier, getRandomPlayer, hpIncreaseDelayInSeconds,
                ScenarioFramework, spawnOutEffect, TransportDestinations
            )
        end,
        newUnitSpawner = function(hpIncreaseDelayInSeconds)
            return unitSpawnerClass.newInstance(
                unitCreator, playerArmies, healthMultiplier, getRandomPlayer, hpIncreaseDelayInSeconds, getAllUnits
            )
        end
    }
end
