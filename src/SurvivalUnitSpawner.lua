newInstance = function(ScenarioInfo, healthMultiplier, removeWreckage, getRandomPlayer, killUnitsOnceExpired, hpIncreaseDelayInSeconds, StartingPlayersExistance, AttackLocations)
    local airSpawnZones = {
        ARMY_9 = {
            minX = 500,
            maxX = 512,
            minY = 0,
            maxY = 10,
        },
        NEUTRAL_CIVILIAN = {
            minX = 0,
            maxX = 10,
            minY = 500,
            maxY = 512,
        },
    }

    local function GetRandomPlayerExisted(team)
        local Units_FinalFight = false
        local selectplayertoattack

        while Units_FinalFight == false do
            selectplayertoattack = Random(1,4)

            if team == 1 then

                if selectplayertoattack == 1 and StartingPlayersExistance.ARMY_1 then
                    Units_FinalFight = AttackLocations.Team1.Player1
                elseif selectplayertoattack == 2 and StartingPlayersExistance.ARMY_2 then
                    Units_FinalFight = AttackLocations.Team1.Player2
                elseif selectplayertoattack == 3 and StartingPlayersExistance.ARMY_3 then
                    Units_FinalFight = AttackLocations.Team1.Player3
                elseif selectplayertoattack == 4 and StartingPlayersExistance.ARMY_4 then
                    Units_FinalFight = AttackLocations.Team1.Player4
                end
            elseif team == 2 then

                if selectplayertoattack == 1 and StartingPlayersExistance.ARMY_5 then
                    Units_FinalFight = AttackLocations.Team2.Player1
                elseif selectplayertoattack == 2 and StartingPlayersExistance.ARMY_6 then
                    Units_FinalFight = AttackLocations.Team2.Player2
                elseif selectplayertoattack == 3 and StartingPlayersExistance.ARMY_7 then
                    Units_FinalFight = AttackLocations.Team2.Player3
                elseif selectplayertoattack == 4 and StartingPlayersExistance.ARMY_8 then
                    Units_FinalFight = AttackLocations.Team2.Player4
                end
            end
            WaitSeconds(0.1)
        end
        return Units_FinalFight
    end

    local function spawnAirUnitsFromName(unitNames, armyName)
        local spawnZone = airSpawnZones[armyName]
        local units = {}

        for _, unitName in unitNames do
            table.insert(
                units,
                CreateUnitHPR(
                    unitName,
                    armyName,
                    Random(spawnZone.minX, spawnZone.maxX),
                    25.9844,
                    Random(spawnZone.minY, spawnZone.maxY),
                    0, 0, 0
                )
            )
        end

        return units
    end

    local function sendAirUnitsInForAttack(units, owningArmyName)
        IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

        local teamIndex = owningArmyName == "ARMY_9" and 1 or 2

        IssueAggressiveMove(units, GetRandomPlayerExisted(teamIndex))
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
        IssueAggressiveMove(units, getRandomPlayer(teamIndex))
    end

    local function spawnAirUnitsForArmy(unitNames, armyName)
        local units = spawnAirUnitsFromName(unitNames, armyName)

        removeWreckage(units)

        -- TODO: always inject properly configured table with method increaseHealth(units)
        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units, hpIncreaseDelayInSeconds)
        end

        ForkThread(sendAirUnitsInForAttack, units, armyName)
        ForkThread(killUnitsOnceExpired, units)
    end

    return {
        spawnAirUnits = function(unitNames)
            spawnAirUnitsForArmy(unitNames, "ARMY_9")
            spawnAirUnitsForArmy(unitNames, "NEUTRAL_CIVILIAN")
        end
    }
end

