newInstance = function(ScenarioInfo, TransportDestinations, GetRandomPlayer, healthMultiplier, RemoveWreckage, spawnOutEffect, Killgroup, ScenarioFramework, textPrinter)
    local Round1 = function(hpincreasedelay)
        local survivalUnitSpanwer = import('/maps/Final Rush Pro 5/src/SurvivalUnitSpawner.lua').newInstance(
            ScenarioInfo, ScenarioFramework, healthMultiplier, hpincreasedelay, RemoveWreckage,
            GetRandomPlayer, Killgroup, spawnOutEffect, TransportDestinations
        )

        survivalUnitSpanwer.spawnWithTransports(
            {
                "url0103", --Cybran T1 Mobile Light Artillery: Medusa
                "uel0103", --UEF T1 Mobile Light Artillery: Lobo
                "xsl0201", --Seraphim T1 Medium Tank: Thaam
                "url0107", --Cybran T1 Assault Bot: Mantis
                "uel0201", --UEF T1 Medium Tank: MA12 Striker
                "ual0201", --Aeon T1 Light Tank: Aurora
            },
            "ura0107"
        )
    end

    local Round2 = function(hpincreasedelay)
        local survivalUnitSpanwer = import('/maps/Final Rush Pro 5/src/SurvivalUnitSpawner.lua').newInstance(
            ScenarioInfo, ScenarioFramework, healthMultiplier, hpincreasedelay, RemoveWreckage,
            GetRandomPlayer, Killgroup, spawnOutEffect, TransportDestinations
        )

        survivalUnitSpanwer.spawnWithTransports(
            {
                "url0202", --Cybran T2 Heavy Tank: Rhino
                "ual0202", --Aeon T2 Heavy Tank: Obsidian
                "uel0202", --UEF T2 Heavy Tank: Pillar
                "del0204", --UEF T2 Gatling Bot: Mongoose
                "url0202", --missile  Edit! Changed to: Cybran T2 Heavy Tank: Rhino
                "del0204", --
                "xsl0203", -- Edit! Changed to: Sera t2 HoverTank
                "url0203", --wagner
                "xsl0202", --Seraphim T2 Assault Bot: Ilshavoh
                "xal0203", --Aeon T2 Assault Tank: Blaze
            },
            "xea0306"
        )
    end

    local Round3 = function(hpincreasedelay)
        local survivalUnitSpanwer = import('/maps/Final Rush Pro 5/src/SurvivalUnitSpawner.lua').newInstance(
            ScenarioInfo, ScenarioFramework, healthMultiplier, hpincreasedelay, RemoveWreckage,
            GetRandomPlayer, Killgroup, spawnOutEffect, TransportDestinations
        )

        survivalUnitSpanwer.spawnWithTransports(
            {
                "url0303", --Cybran T3 Siege Assault Bot: Loyalist
                "xel0305", --UEF T3 Armored Assault Bot: Percival
                "uel0303", --Cybran T3 Mobile Heavy Artillery: Trebuchet
                "ual0303", --Cybran T3 Mobile Heavy Artillery: Trebuchet
                "xrl0305",--Cybran T3 Armored Assault Bot: The Brick
                "uel0303", --UEF T3 Heavy Assault Bot: Titan
                "ual0303", --Aeon T3 Heavy Assault Bot: Harbinger Mark IV
                "dal0310", --Aeon T3 Shield Disruptor: Absolver
                "xsl0303", --Seraphim T3 Siege Tank: Othuum
                "xsl0303", --Seraphim T3 Mobile Shield Generator: Athanah
            },
            "xea0306"
        )
    end

    local Round4 = function(hpincreasedelay)
        local survivalUnitSpanwer = import('/maps/Final Rush Pro 5/src/SurvivalUnitSpawner.lua').newInstance(
            ScenarioInfo, ScenarioFramework, healthMultiplier, hpincreasedelay, RemoveWreckage,
            GetRandomPlayer, Killgroup, spawnOutEffect, TransportDestinations
        )

        survivalUnitSpanwer.spawnWithTransports(
            {
                "url0402",
                "ual0401",
            },
            "xea0306"
        )
    end

    local SpawnerGroup1 = function(delay, frequency, spawnend)
        WaitSeconds(delay)
        while GetGameTimeSeconds() < spawnend do
            ForkThread(Round1, delay)
            WaitSeconds(frequency)
        end
    end

    local SpawnerGroup2 = function(delay, frequency)
        WaitSeconds(delay)
        textPrinter.print("Tech 2 inbound")
        while true do
            ForkThread(Round2, delay)
            WaitSeconds(frequency)
        end
    end

    local SpawnerGroup3 = function(delay, frequency)
        WaitSeconds(delay)
        textPrinter.print("Tech 3 inbound")
        while true do
            ForkThread(Round3, delay)
            WaitSeconds(frequency)
        end
    end

    local SpawnerGroup4 = function(delay, frequency)
        WaitSeconds(delay)
        textPrinter.print("Experimentals inbound")
        while true do
            ForkThread(Round4, delay)
            WaitSeconds(frequency)
        end
    end

    return {
        startT1Thread = function(spawnDelay, spawnFrequency, spawnEnd)
            ForkThread(SpawnerGroup1, spawnDelay, spawnFrequency, spawnEnd)
        end,
        startT2Thread = function(spawnDelay, spawnFrequency)
            ForkThread(SpawnerGroup2, spawnDelay, spawnFrequency)
        end,
        startT3Thread = function(spawnDelay, spawnFrequency)
            ForkThread(SpawnerGroup3, spawnDelay, spawnFrequency)
        end,
        startT4Thread = function(spawnDelay, spawnFrequency)
            ForkThread(SpawnerGroup4, spawnDelay, spawnFrequency)
        end
    }
end
