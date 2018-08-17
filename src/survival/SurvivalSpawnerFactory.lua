newInstance = function(options, ScenarioFramework, unitCreator, playerArmies, getRandomPlayer,
                        spawnOutEffect, TransportDestinations, getAllUnits)

    local transportSpawnerClass = import('/maps/final_rush_pro_5.v0013/src/survival/SurvivalTransportSpawner.lua')
    local unitSpawnerClass = import('/maps/final_rush_pro_5.v0013/src/survival/SurvivalUnitSpawner.lua')

    return {
        newTransportSpawner = function(unitInfo)
            return transportSpawnerClass.newInstance(
                options, unitCreator, getRandomPlayer, unitInfo,
                ScenarioFramework, spawnOutEffect, TransportDestinations
            )
        end,
        newUnitSpawner = function(unitInfo)
            return unitSpawnerClass.newInstance(
                unitCreator, playerArmies, getRandomPlayer, getAllUnits, unitInfo
            )
        end
    }
end
