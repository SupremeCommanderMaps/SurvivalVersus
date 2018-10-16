newInstance = function(options, unitCreator, getRandomPlayer, extraUnitInfo, ScenarioFramework, spawnOutEffect, TransportDestinations)
    local spawnForTop = true
    local spawnForBottom = true

    local transportDetails = {
        BOTTOM_BOT = {
            spawnPosition = {
                x = 500,
                y = 10
            },
            finalDestination = TransportDestinations.SouthernAttackerEnd
        },
        TOP_BOT = {
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
        if attackingArmyName == "BOTTOM_BOT" then
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

            -- TODO
            -- cmd = IssueMove()
            -- IsCommandDone(cmd)
            while unit:IsUnitState('Moving') do
                WaitSeconds(0.5)
            end

            spawnOutEffect(unit)
        end)
    end

    local function spawnTransport(armyName, transportOptions)
        if type(transportOptions) == "string" then
            transportOptions = {
                blueprintName = transportOptions
            }
        end

        local spawnPosition = transportDetails[armyName].spawnPosition

        local unitInfo = {
            armyName = armyName,
            blueprintName = transportOptions.blueprintName,
            baseHealth = transportOptions.baseHealth,
            speedMultiplier = transportOptions.speedMultiplier,
            x = spawnPosition.x,
            y = spawnPosition.y,
            z = 80,
            isTransport = true
        }

        return unitCreator.create(unitInfo)
    end

    local function createTransport(armyName, transportOptions)
        local transport = spawnTransport(armyName, transportOptions)

        if not options.canKillTransports() then
            transport:SetReclaimable(false)
            transport:SetCanTakeDamage(false)
            transport:SetDoNotTarget(true)
            transport:SetCanBeKilled(false)
        end

        return transport
    end

    local function spawnUnitsForArmy(units, armyName, transport)
        local transports = { transport }

        ScenarioFramework.AttachUnitsToTransports(units, transports)

        for _, unit in units do
            if EntityCategoryContains(categories.SHIELD + categories.uel0401, unit) then
                unit:EnableShield()
            end
        end

        IssueTransportUnload(transports, VECTOR3(Random(220, 290), 0, Random(220, 290)))

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
        -- transportOptions: either string blueprint name or map with blueprintName key
        spawnWithTransports = function(unitNames, transportOptions)
            if spawnForBottom then
                spawnUnitsForArmy(
                    spawnUnitsFromName(unitNames, "BOTTOM_BOT"),
                    "BOTTOM_BOT",
                    createTransport("BOTTOM_BOT", transportOptions)
                )
            end

            if spawnForTop then
                spawnUnitsForArmy(
                    spawnUnitsFromName(unitNames, "TOP_BOT"),
                    "TOP_BOT",
                    createTransport("TOP_BOT", transportOptions)
                )
            end
        end,
        stopSpawningForTop = function()
            spawnForTop = false
        end,
        stopSpawningForBottom = function()
            spawnForBottom = false
        end
    }
end

