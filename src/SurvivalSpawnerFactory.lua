newInstance = function(ScenarioInfo, ScenarioFramework, playerArmies, healthMultiplier, removeWreckage, getRandomPlayer,
                        killUnitsOnceExpired, spawnOutEffect, TransportDestinations, getAllUnits)

    local transportSpawnerClass = import('/maps/Final_Rush_Pro_5.v0001/src/SurvivalTransportSpawner.lua')
    local unitSpawnerClass = import('/maps/Final_Rush_Pro_5.v0001/src/SurvivalUnitSpawner.lua')

    return {
        newTransportSpawner = function(hpIncreaseDelayInSeconds)
            return transportSpawnerClass.newInstance(
                ScenarioInfo, healthMultiplier, removeWreckage, getRandomPlayer, killUnitsOnceExpired, hpIncreaseDelayInSeconds,
                ScenarioFramework, spawnOutEffect, TransportDestinations
            )
        end,
        newUnitSpawner = function(hpIncreaseDelayInSeconds)
            return unitSpawnerClass.newInstance(
                playerArmies, healthMultiplier, removeWreckage, getRandomPlayer, killUnitsOnceExpired, hpIncreaseDelayInSeconds, getAllUnits
            )
        end
    }
end
