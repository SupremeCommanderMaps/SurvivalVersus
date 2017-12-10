newInstance = function(textPrinter, unitSpawnerFactory)
    local Round1 = function(survivalUnitSpanwer)
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

    local Round2 = function(survivalUnitSpanwer)
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

    local Round3 = function(survivalUnitSpanwer)
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

    local Round4 = function(survivalUnitSpanwer)
        survivalUnitSpanwer.spawnWithTransports(
            {
                "url0402",
                "ual0401",
            },
            "xea0306"
        )
    end

    local function createRoundSpawner(initialDelayInSeconds, frequencyInSeconds, spawnEndInSeconds, initialMessage, spawnFunction)
        return function()
            WaitSeconds(initialDelayInSeconds)
            textPrinter.print(initialMessage, {duration = 3.5})

            local transportSpawner = unitSpawnerFactory.newTransportSpawner(initialDelayInSeconds)

            while spawnEndInSeconds == nil or GetGameTimeSeconds() < spawnEndInSeconds do
                ForkThread(spawnFunction, transportSpawner)
                WaitSeconds(frequencyInSeconds)
            end
        end
    end

    return {
        start = function(options)
            ForkThread(createRoundSpawner(
                options.T1.initialDelayInSeconds,
                options.T1.frequencyInSeconds,
                options.T1.spawnEndInSeconds,
                "And so it begins! Tech 1 inbound",
                Round1
            ))
            ForkThread(createRoundSpawner(
                options.T2.initialDelayInSeconds,
                options.T2.frequencyInSeconds,
                options.T2.spawnEndInSeconds,
                "Tech 2 inbound",
                Round2
            ))
            ForkThread(createRoundSpawner(
                options.T3.initialDelayInSeconds,
                options.T3.frequencyInSeconds,
                options.T3.spawnEndInSeconds,
                "Tech 3 inbound",
                Round3
            ))
            ForkThread(createRoundSpawner(
                options.T4.initialDelayInSeconds,
                options.T4.frequencyInSeconds,
                options.T4.spawnEndInSeconds,
                "Experimentals inbound",
                Round4
            ))
        end
    }
end
