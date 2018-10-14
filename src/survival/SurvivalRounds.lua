newInstance = function(ScenarioInfo, textPrinter, unitSpawnerFactory, options, unitAmountMultiplier, survivalVictory)
    local Objectives = import('/lua/ScenarioFramework.lua').Objectives

    local T2_TRANSPORT = "ura0107"
    local T3_TRANSPORT = "xea0306"

    local T4_TRANSPORT_LVL1 = {
        blueprintName = "uaa0107",
        baseHealth = 8500
    }

    local T4_TRANSPORT_LVL2 = {
        blueprintName = "uaa0107",
        baseHealth = 13337,
        speedMultiplier = 2
    }

    local transportSpawner = unitSpawnerFactory.newTransportSpawner({hpIncrease = true})
    local unitSpawner = unitSpawnerFactory.newUnitSpawner({hpIncrease = true})

    local function printMessage(message)
        textPrinter.print(
            message,
            {
                duration = 4.5,
                size = 25,
                color = "ffffd4d4"
            }
        )
    end

    local spawnGcAndMonkey = function()
        transportSpawner.spawnWithTransports(
            {
                "ual0401", -- GC
            },
            T4_TRANSPORT_LVL1
        )
        WaitSeconds(2)
        transportSpawner.spawnWithTransports(
            {
                "url0402", -- Monkey
            },
            T4_TRANSPORT_LVL1
        )
    end

    local spawnBugAndArty = function()
        if options.shouldSpawnT3Arty() then
            local units = {
                "dal0310", --Aeon T3 Shield Disruptor: Absolver
            }

            if Random(1, 2) == 1 then
                table.insert(units, "url0304") --Cybran T3 Mobile Heavy Artillery: Trebuchet
            end

            transportSpawner.spawnWithTransports(
                units,
                T3_TRANSPORT
            )
        end

        unitSpawner.spawnUnits( {
            {
                blueprintName = "ura0401", -- Bug
                baseHealth = 25000,
            }
        } )
    end

    local spawnMegaYthothaAndSattelite = function()
        if Random(1, 3) == 1 then
            unitSpawner.spawnUnits( {
                "xea0002" -- Sattelite
            } )
        end

        transportSpawner.spawnWithTransports(
            {
                "xrl0403", -- Mega
            },
            T4_TRANSPORT_LVL2
        )
        WaitSeconds(2)
        transportSpawner.spawnWithTransports(
            {
                "xsl0401", -- Ythotha
            },
            T4_TRANSPORT_LVL2
        )
    end

    local spawnBattyMonkeyBomberAndCzar = function()
        if options.shouldSpawnT3Arty() then
            transportSpawner.spawnWithTransports(
                { "uel0401" }, --Fatboy
                T4_TRANSPORT_LVL2
            )
        end

        transportSpawner.spawnWithTransports(
            { "url0402" }, --Monkey
            T4_TRANSPORT_LVL2
        )

        unitSpawner.spawnUnits( {
            {
                blueprintName = "xsa0402", -- T4 bomber
                baseHealth = 25000,
            }
        } )
        WaitSeconds(2)
        unitSpawner.spawnUnits( {
            {
                blueprintName = "uaa0310", -- CZAR
                baseHealth = 25000,
            }
        } )
    end

    local function spawnT3Land()
        local units = {
            "url0303", --Cybran T3 Siege Assault Bot: Loyalist
            "xel0305", --UEF T3 Armored Assault Bot: Percival
            "uel0303", --UEF T3 Heavy Assault Bot: Titan
            "ual0303", --Aeon T3 Heavy Assault Bot: Harbinger Mark IV
            "xrl0305", --Cybran T3 Armored Assault Bot: The Brick
            "uel0303", --UEF T3 Heavy Assault Bot: Titan
            "ual0303", --Aeon T3 Heavy Assault Bot: Harbinger Mark IV
            "xsl0303", --Seraphim T3 Siege Tank: Othuum
            "xsl0307", --Seraphim T3 Mobile Shield Generator: Athanah
        }

        if options.shouldSpawnT3Arty() then
            table.insert(units, "dal0310") --Aeon T3 Shield Disruptor: Absolver
        end

        transportSpawner.spawnWithTransports(
            units,
            T3_TRANSPORT
        )
    end

    local function startStage(params)
        printMessage(params.message)

        local objective = Objectives.Timer(
            'primary',
            'incomplete',
            params.title,
            params.description,
            {
                Timer = params.duration,
                ExpireResult = 'complete',
            }
        )

        objective:AddResultCallback(
            function(result)
                if result and params.onComplete ~= nil then
                    params.onComplete()
                end
            end
        )

        local frequencyInSeconds = params.frequency / unitAmountMultiplier

        ForkThread(function()
            while objective.Active do
                ForkThread(params.spawnFunction)
                WaitSeconds(frequencyInSeconds)
            end
        end)
    end

    local function startStage7()
        startStage({
            frequency = 13,
            message = "Stage 7: Fatboys and stronger air",
            title = "Survive stage 7",
            description = "Stage 7 consists of high tier T4 land units, high tier T4 air units, T3 mobile arty and the occasional Sattelite",
            duration = ScenarioInfo.Options.opt_FinalRushEscalationSpeed,
            spawnFunction = function()
                spawnBattyMonkeyBomberAndCzar()
                spawnMegaYthothaAndSattelite()
            end,
            onComplete = function()
                ForkThread(function()
                    survivalVictory.finalStageComplete()

                    while true do
                        ForkThread(function()
                            spawnBattyMonkeyBomberAndCzar()
                            spawnMegaYthothaAndSattelite()
                        end)
                        WaitSeconds(11 / unitAmountMultiplier)
                    end
                end)
            end
        })
    end

    local function startStage6()
        startStage({
            frequency = 13,
            message = "Stage 6: Megas, Chickens and Sattelites",
            title = "Survive stage 6",
            description = "Stage 6 consists of high tier T4 land units, Bugs, T3 mobile arty and the occasional Sattelite",
            duration = ScenarioInfo.Options.opt_FinalRushEscalationSpeed,
            spawnFunction = function()
                spawnBugAndArty()
                spawnMegaYthothaAndSattelite()
            end,
            onComplete = startStage7
        })
    end

    local function startStage5()
        startStage({
            frequency = 13,
            message = "Stage 5: Bugs replace T3",
            title = "Survive stage 5",
            description = "Stage 5 consists of T4 land units, Bugs and T3 mobile arty",
            duration = ScenarioInfo.Options.opt_FinalRushEscalationSpeed,
            spawnFunction = function()
                spawnGcAndMonkey()
                spawnBugAndArty()
            end,
            onComplete = startStage6
        })
    end

    local function startStage4()
        startStage({
            frequency = 13,
            message = "Stage 4: Experimentals inbound",
            title = "Survive stage 4",
            description = "Stage 4 consists of T3 and T4 land units",
            duration = ScenarioInfo.Options.opt_FinalRushEscalationSpeed,
            spawnFunction = function()
                spawnT3Land()
                spawnGcAndMonkey()
            end,
            onComplete = startStage5
        })
    end

    local function startStage3()
        startStage({
            frequency = 10,
            message = "Tech 3 inbound",
            title = "Survive stage 3",
            description = "Stage 2 consists of T3 land units and random events with T3 air units and Salemns",
            duration = ScenarioInfo.Options.opt_FinalRushEscalationSpeed,
            spawnFunction = spawnT3Land,
            onComplete = startStage4
        })
    end

    local function startStage2()
        startStage({
            frequency = 7,
            message = "Tech 2 inbound",
            title = "Survive stage 2",
            description = "Stage 2 consists of T2 land units and random events with T2 air units",
            duration = ScenarioInfo.Options.opt_FinalRushEscalationSpeed,
            spawnFunction = function()
                local units = {
                    "url0202", --Cybran T2 Heavy Tank: Rhino
                    "ual0202", --Aeon T2 Heavy Tank: Obsidian
                    "uel0202", --UEF T2 Heavy Tank: Pillar
                    "del0204", --UEF T2 Gatling Bot: Mongoose
                    "uel0203", --UEF Riptide
                    "drl0204", --Cybran T2 Rocket Bot
                    "xsl0202", --Seraphim T2 Assault Bot: Ilshavoh
                    "xal0203", --Aeon T2 Assault Tank: Blaze
                }

                if options.shouldSpawnMML() then
                    table.insert(units, "uel0111") --UEF T2 Mobile Missile Launcher
                    table.insert(units, "url0111") --Cybran T2 Mobile Missile Launcher
                end

                transportSpawner.spawnWithTransports(
                    units,
                    T3_TRANSPORT
                )
            end,
            onComplete = startStage3
        })
    end

    local function startStage1()
        startStage({
            frequency = 6,
            message = "And so it begins! Tech 1 inbound",
            title = "Survive stage 1",
            description = "Stage 1 consists of T1 land units and random events with T1 air units",
            duration = ScenarioInfo.Options.opt_FinalRushEscalationSpeed,
            spawnFunction = function()
                transportSpawner.spawnWithTransports(
                    {
                        "url0103", --Cybran T1 Mobile Light Artillery: Medusa
                        "uel0103", --UEF T1 Mobile Light Artillery: Lobo
                        "xsl0201", --Seraphim T1 Medium Tank: Thaam
                        "url0107", --Cybran T1 Assault Bot: Mantis
                        "uel0201", --UEF T1 Medium Tank: MA12 Striker
                        "ual0201", --Aeon T1 Light Tank: Aurora
                    },
                    T2_TRANSPORT
                )
            end,
            onComplete = startStage2
        })
    end

    return {
        start = function()
            ScenarioInfo.Options.Victory = 'sandbox'
            survivalVictory.watchForTeamDeath()

            ForkThread(function()
                WaitSeconds(ScenarioInfo.Options.opt_FinalRushSpawnDelay)
                startStage1()
            end)
        end
    }
end
