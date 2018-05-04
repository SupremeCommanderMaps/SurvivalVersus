newInstance = function(options, unitCreator, getRandomPlayer, extraUnitInfo, ScenarioFramework, spawnOutEffect, TransportDestinations)
    local transportDetails = {
        ARMY_9 = {
            spawnPosition = {
                x = 500,
                y = 10
            },
            finalDestination = TransportDestinations.SouthernAttackerEnd
        },
        NEUTRAL_CIVILIAN = {
            spawnPosition = {
                x = 10,
                y = 500
            },
            finalDestination = TransportDestinations.NorthernAttackerEnd
        }
    }

    local GetNearestCommander = function(unitgroup, range)
        local unitattackerpos
        local unit_pos
        local dist
        local CommandersInRange
        local commandertoattack = false

        for _, unitattacker in unitgroup do
            if not unitattacker:IsDead() then
                unitattackerpos = unitattacker:GetPosition()
                local brain = unitattacker:GetAIBrain()
                CommandersInRange = brain:GetUnitsAroundPoint(categories.COMMAND, unitattackerpos, range, 'Enemy')
            end
        end

        if CommandersInRange then
            for _, unit in CommandersInRange do
                unit_pos = unit:GetPosition()
                dist = VDist2(unitattackerpos.x, unitattackerpos.z, unit_pos.x, unit_pos.z)
                commandertoattack = unit
            end
        end

        return commandertoattack
    end

    local function issueAttackCommands(attackingArmyName, unitgroup)
        if attackingArmyName == "ARMY_9" then
            IssueAggressiveMove(unitgroup, getRandomPlayer(1))
            IssueAggressiveMove(unitgroup, getRandomPlayer(1))
        else
            IssueAggressiveMove(unitgroup, getRandomPlayer(2))
            IssueAggressiveMove(unitgroup, getRandomPlayer(2))
        end

        WaitSeconds(90)
        local range = 50
        while GetNearestCommander(unitgroup, range) == false and range < 400 do
            range = range + 50
            WaitSeconds(1)
        end

        local nearestCommander = GetNearestCommander(unitgroup, range)

        if nearestCommander ~= false then
            IssueAttack(unitgroup, nearestCommander)
        end
    end

    local function spawnOutOnceNotMoving(unit)
        ForkThread(function()
            WaitSeconds(5)

            while unit:IsUnitState('Moving') do
                WaitSeconds(0.5)
            end

            spawnOutEffect(unit)
        end)
    end

    local function spawnTransport(armyName, transportName)
        local spawnPosition = transportDetails[armyName].spawnPosition

        local unitInfo = {
            blueprintName = transportName,
            armyName = armyName,
            x = spawnPosition.x,
            y = spawnPosition.y,
            z = 80,
            isTransport = true
        }

        return unitCreator.create(unitInfo)
    end

    local function spawnUnitsForArmy(units, armyName, transportDesination, transportName)
        local transport = spawnTransport(armyName, transportName)

        if not options.canKillTransports() then
            transport:SetReclaimable(false)
            transport:SetCanTakeDamage(false)
            transport:SetDoNotTarget(true)
            transport:SetCanBeKilled(false)
        end

        local transports = { transport }

        ScenarioFramework.AttachUnitsToTransports(units, transports)

        IssueTransportUnload(transports, transportDesination)

        ForkThread(issueAttackCommands, armyName, units)

        IssueMove(transports, transportDetails[armyName].finalDestination)

        spawnOutOnceNotMoving(transport)
    end

    local function getUnitInfo(unitName, armyName)
        local unitInfo = {
            blueprintName = unitName,
            armyName = armyName,
            x = 255.5,
            y = 255.5,
        }

        for key, value in extraUnitInfo do
            unitInfo[key] = value
        end

        return unitInfo
    end

    local function spawnUnitsFromName(unitNames, armyName)
        local units = {}

        for _, unitName in unitNames do
            table.insert(units, unitCreator.spawnSurvivalUnit(getUnitInfo(unitName, armyName)))
        end

        return units
    end

    return {
        spawnWithTransports = function(unitNames, transportName)
            local transportDesination = VECTOR3(Random(220, 290), 80, Random(220, 290))

            spawnUnitsForArmy(
                spawnUnitsFromName(unitNames, "ARMY_9"),
                "ARMY_9",
                transportDesination,
                transportName
            )

            spawnUnitsForArmy(
                spawnUnitsFromName(unitNames, "NEUTRAL_CIVILIAN"),
                "NEUTRAL_CIVILIAN",
                transportDesination,
                transportName
            )
        end
    }
end

