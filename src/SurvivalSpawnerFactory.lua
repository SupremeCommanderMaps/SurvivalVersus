newInstance = function(ScenarioInfo, ScenarioFramework, healthMultiplier, removeWreckage, getRandomPlayer,
                        killUnitsOnceExpired, spawnOutEffect, TransportDestinations, StartingPlayersExistance, AttackLocations)

    local transportSpawnerClass = import('/maps/Final Rush Pro 5/src/SurvivalTransportSpawner.lua')
    local unitSpawnerClass = import('/maps/Final Rush Pro 5/src/SurvivalUnitSpawner.lua')

    return {
        newTransportSpawner = function(hpIncreaseDelayInSeconds)
            return transportSpawnerClass.newInstance(
                ScenarioInfo, healthMultiplier, removeWreckage, getRandomPlayer, killUnitsOnceExpired, hpIncreaseDelayInSeconds,
                ScenarioFramework, spawnOutEffect, TransportDestinations
            )
        end,
        newUnitSpawner = function(hpIncreaseDelayInSeconds)
            return unitSpawnerClass.newInstance(
                ScenarioInfo, healthMultiplier, removeWreckage, getRandomPlayer, killUnitsOnceExpired, hpIncreaseDelayInSeconds,
                StartingPlayersExistance, AttackLocations
            )
        end
    }
end

