newInstance = function(textPrinter, unitSpawnerFactory, options)

    local T2_TRANSPORT = "ura0107"
    local T3_TRANSPORT = "xea0306"

    local EXPERIMENTAL_TRANSPORT = {
        blueprintName = "uaa0107",
        baseHealth = 8500
    }

    local transportSpawner = unitSpawnerFactory.newTransportSpawner({hpIncrease = true})
    local unitSpawner = unitSpawnerFactory.newUnitSpawner({})

    local function printMessage(message)
        textPrinter.print(message, {duration = 4, 24})
    end

    local spawnTierOneWave = function()
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
    end

    local spawnTierTwoWave = function()
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
    end

    local spawnTierThreeWave = function()
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

    local spawnTierFourWave = function()
        transportSpawner.spawnWithTransports(
            {
                "ual0401",
            },
            EXPERIMENTAL_TRANSPORT
        )
        WaitSeconds(2)
        transportSpawner.spawnWithTransports(
            {
                "url0402",
            },
            EXPERIMENTAL_TRANSPORT
        )
    end

    local spawnTierFourStageTwoWave = function()
        if options.shouldSpawnT3Arty() then
            local units = {
                "dal0310", --Aeon T3 Shield Disruptor: Absolver
                "url0304", --Cybran T3 Mobile Heavy Artillery: Trebuchet
                "uel0304", --UEF T3 Mobile Heavy Artillery: Demolisher
            }

            transportSpawner.spawnWithTransports(
                units,
                T3_TRANSPORT
            )
        end

        unitSpawner.spawnUnits( {
            "ura0401"
        } )
    end

    local spawnTierFourStageThreeWave = function()
        if Random(1, 3) == 1 then
            unitSpawner.spawnUnits( {
                "xea0002"
            } )
        end

        transportSpawner.spawnWithTransports(
            {
                "xrl0403",
            },
            EXPERIMENTAL_TRANSPORT
        )
        WaitSeconds(2)
        transportSpawner.spawnWithTransports(
            {
                "xsl0401",
            },
            EXPERIMENTAL_TRANSPORT
        )
    end

    local function createRoundSpawner(initialDelayInSeconds, frequencyInSeconds, spawnEndInSeconds, initialMessage, spawnFunction)
        return function()
            WaitSeconds(initialDelayInSeconds)
            printMessage(initialMessage)

            while spawnEndInSeconds == nil or GetGameTimeSeconds() < spawnEndInSeconds do
                ForkThread(spawnFunction)
                WaitSeconds(frequencyInSeconds)
            end
        end
    end

    return {
        start = function(spawnOptions)
            ForkThread(createRoundSpawner(
                spawnOptions.T1.initialDelayInSeconds,
                spawnOptions.T1.frequencyInSeconds,
                spawnOptions.T1.spawnEndInSeconds,
                "And so it begins! Tech 1 inbound",
                spawnTierOneWave
            ))

            ForkThread(createRoundSpawner(
                spawnOptions.T2.initialDelayInSeconds,
                spawnOptions.T2.frequencyInSeconds,
                spawnOptions.T2.spawnEndInSeconds,
                "Tech 2 inbound",
                spawnTierTwoWave
            ))

            ForkThread(createRoundSpawner(
                spawnOptions.T3.initialDelayInSeconds,
                spawnOptions.T3.frequencyInSeconds,
                spawnOptions.T3.spawnEndInSeconds,
                "Tech 3 inbound",
                spawnTierThreeWave
            ))

            ForkThread(createRoundSpawner(
                spawnOptions.T4.initialDelayInSeconds,
                spawnOptions.T4.frequencyInSeconds,
                spawnOptions.T4.spawnEndInSeconds,
                "Experimentals inbound",
                spawnTierFourWave
            ))

            ForkThread(createRoundSpawner(
                spawnOptions.T42.initialDelayInSeconds,
                spawnOptions.T42.frequencyInSeconds,
                spawnOptions.T42.spawnEndInSeconds,
                "Tier 4 stage 2 inbound",
                spawnTierFourStageTwoWave
            ))

            ForkThread(createRoundSpawner(
                spawnOptions.T43.initialDelayInSeconds,
                spawnOptions.T43.frequencyInSeconds,
                spawnOptions.T43.spawnEndInSeconds,
                "Tier 4 stage 3 inbound",
                spawnTierFourStageThreeWave
            ))
        end
    }
end
