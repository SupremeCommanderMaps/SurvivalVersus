newInstance = function(options, ScenarioFramework, unitCreator, playerArmies, getRandomPlayer,
                        spawnOutEffect, TransportDestinations, getAllUnits)

    local transportSpawnerClass = import('/maps/final_rush_pro_5.8.v0001/src/survival/SurvivalTransportSpawner.lua')
    local unitSpawnerClass = import('/maps/final_rush_pro_5.8.v0001/src/survival/SurvivalUnitSpawner.lua')

    return {
        newTransportSpawner = function(hpIncreaseDelayInSeconds)
            return transportSpawnerClass.newInstance(
                options, unitCreator, getRandomPlayer, hpIncreaseDelayInSeconds,
                ScenarioFramework, spawnOutEffect, TransportDestinations
            )
        end,
        newUnitSpawner = function(hpIncreaseDelayInSeconds)
            return unitSpawnerClass.newInstance(
                unitCreator, playerArmies, getRandomPlayer, hpIncreaseDelayInSeconds, getAllUnits
            )
        end
    }
end
