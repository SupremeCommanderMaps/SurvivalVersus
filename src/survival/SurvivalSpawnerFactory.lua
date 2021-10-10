newInstance = function(options, ScenarioFramework, unitCreator, playerArmies, positions,
                        spawnOutEffect, TransportDestinations)

    local transportSpawnerClass = import('/maps/survival_versus.v0024/src/survival/SurvivalTransportSpawner.lua')
    local unitSpawnerClass = import('/maps/survival_versus.v0024/src/survival/SurvivalUnitSpawner.lua')

    local AttackLocations = positions.AttackLocations

    -- TODO: this is misplaced
    local getRandomPlayer = function(team)
        local randomNumber = Random(1, 4)

        if team == 1 then
            if randomNumber == 1 then
                return AttackLocations.Team1.Player1
            elseif randomNumber == 2 then
                return AttackLocations.Team1.Player2
            elseif randomNumber == 3 then
                return AttackLocations.Team1.Player3
            elseif randomNumber == 4 then
                return AttackLocations.Team1.Player4
            end
        elseif team == 2 then
            if randomNumber == 1 then
                return AttackLocations.Team2.Player1
            elseif randomNumber == 2 then
                return AttackLocations.Team2.Player2
            elseif randomNumber == 3 then
                return AttackLocations.Team2.Player3
            elseif randomNumber == 4 then
                return AttackLocations.Team2.Player4
            end
        end
    end

    return {
        newTransportSpawner = function(unitInfo)
            return transportSpawnerClass.newInstance(
                options, unitCreator, getRandomPlayer, unitInfo,
                ScenarioFramework, spawnOutEffect, TransportDestinations
            )
        end,
        newUnitSpawner = function(unitInfo)
            return unitSpawnerClass.newInstance(
                unitCreator, playerArmies, getRandomPlayer, unitInfo
            )
        end
    }
end
