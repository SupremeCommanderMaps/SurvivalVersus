newInstance = function(ScenarioInfo, textPrinter, getAllUnits, isSurvivalUnit, survivalSpawnerFactory, beetleEvent)

    local T3_TRANSPORT = "xea0306"

    local EXPERIMENTAL_TRANSPORT = {
        blueprintName = "uaa0107",
        baseHealth = 8500
    }

    local survivalUnitSpawner = survivalSpawnerFactory.newUnitSpawner({hpIncrease = true})
    local survivalTransportSpawner = survivalSpawnerFactory.newTransportSpawner({hpIncrease = true})

    local function printText(text)
        textPrinter.print(text, {duration = 3})
    end
    
    local function spawnBombers()
        printText("T1 bombers detected")

        survivalUnitSpawner.spawnUnits(
            {
                "uea0103",
                "uea0103",
                "uea0103",
                "uea0103",
                "uea0103",
            }
        )
    end

    local function spawnT1Gunships()
        printText("T1 gunships detected")

        survivalUnitSpawner.spawnUnits(
            {
                "xra0105",
                "xra0105",
                "xra0105",
            }
        )
    end

    local function spawnT2Bombers()
        printText("T2 bombers detected")

        survivalUnitSpawner.spawnUnits(
            {
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
                "dra0202",
            }
        )
    end

    local SpawnT2Gunships = function()
        printText("T2 gunships detected")

        survivalUnitSpawner.spawnUnits(
            {
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
                "uea0203",
            }
        )
    end

    local function spawnT2Rangebots()
        printText("Rangebots detected")

        local x = 1

        repeat
            survivalTransportSpawner.spawnWithTransports(
                {
                    "del0204",
                    "del0204",
                    "del0204",
                    "del0204",
                    "del0204",
                },
                T3_TRANSPORT
            )

            WaitSeconds(1)
            x = x + 1
        until (x > 5)
    end

    local function spawnT3Bombers()
        printText("T3 bombers detected")

        survivalUnitSpawner.spawnUnits(
            {
                "uea0304",
                "uea0304",
                "uea0304",
            }
        )

        WaitSeconds(5)

        survivalUnitSpawner.spawnUnits(
            {
                "uea0304",
                "uea0304",
                "uea0304",
            }
        )

        WaitSeconds(5)

        survivalUnitSpawner.spawnUnits(
            {
                "uea0304",
                "uea0304",
                "uea0304",
                "uea0304",
            }
        )
    end

    local SpawnT3Gunships = function()
        printText("T3 gunships detected")

        survivalUnitSpawner.spawnUnits(
            {
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
                "uea0305",
            }
        )
    end

    local SpawnT2Destroyers = function()
        printText("Destroyers detected")

        survivalSpawnerFactory.newUnitSpawner({hpIncrease = categories.TECH3}).spawnUnits(
            {
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
                "urs0201",
            }
        )
    end

    local function spawnBeetles()
        printText("Beetles detected")
        beetleEvent.spawn()
    end

    local function spawnT3Arty()
        printText("T3 mobile artillery detected")

        survivalTransportSpawner.spawnWithTransports(
            {
                "url0304", --Cybran T3 Mobile Heavy Artillery: Trebuchet
                "url0304",
                "url0304",
                "url0304",
                "uel0304", --UEF T3 Mobile Heavy Artillery: Demolisher
                "uel0304",
                "uel0304",
                "uel0304",
            },
            T3_TRANSPORT
        )
    end

    local function spawnYthotha()
        printText("Ythotha detected")

        survivalTransportSpawner.spawnWithTransports(
            {
                "xsl0401",
            },
            EXPERIMENTAL_TRANSPORT
        )
    end

    local function spawnFatboy()
        printText("Fatboy detected")

        survivalTransportSpawner.spawnWithTransports(
            {
                "uel0401",
            },
            EXPERIMENTAL_TRANSPORT
        )
    end

    local SpeedCurrentUnits = function()
        printText("Current unit speed boosted")

        for _, unit in getAllUnits() do
            if EntityCategoryContains(categories.LAND + categories.NAVAL, unit) and isSurvivalUnit(unit) then
                unit:SetSpeedMult(2)
            end
        end
    end

    local function getPossibleEvents(elapsedTimeInSeconds, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        local possibleEvents = {}

        if elapsedTimeInSeconds > t1spawndelay + 1 and elapsedTimeInSeconds <= t2spawndelay then
            table.insert(possibleEvents, {spawnBombers})
            table.insert(possibleEvents, {spawnT1Gunships})
        end

        if elapsedTimeInSeconds > t2spawndelay and elapsedTimeInSeconds <= t3spawndelay then
            table.insert(possibleEvents, {spawnT2Bombers})
            table.insert(possibleEvents, {SpawnT2Gunships})
            table.insert(possibleEvents, {spawnT2Rangebots})
        end

        if elapsedTimeInSeconds > t3spawndelay then
            table.insert(possibleEvents, {SpawnT2Destroyers})
            table.insert(possibleEvents, {spawnT3Bombers})
            table.insert(possibleEvents, {SpawnT3Gunships})

            if (ScenarioInfo.Options.opt_t3arty == 0) then
                table.insert(possibleEvents, {spawnT3Arty})
            end
        end

        if elapsedTimeInSeconds > t3spawndelay and elapsedTimeInSeconds <= t4spawndelay then
            table.insert(possibleEvents, {spawnBeetles})
        end

        if elapsedTimeInSeconds > t4spawndelay then
            table.insert(possibleEvents, {spawnYthotha})

            if Random(1, 2) == 1 then
                table.insert(possibleEvents, {spawnFatboy})
            end
        end

        return possibleEvents
    end

    local function runEvent(eventCallable)
        if eventCallable ~= nil then
            ForkThread(eventCallable[1], eventCallable[2])
        end
    end

    local function runRandomEvents(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        local elapsedTimeInSeconds = GetGameTimeSeconds()

        local possibleEvents = getPossibleEvents(elapsedTimeInSeconds, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)

        runEvent(possibleEvents[Random(1, table.getn(possibleEvents))])

        if elapsedTimeInSeconds >= t4spawndelay then
            runEvent(possibleEvents[Random(1, table.getn(possibleEvents))])
        end

        if elapsedTimeInSeconds >= t1spawndelay and Random(1, 5) == 1 then
            ForkThread(SpeedCurrentUnits)
        end
    end

    local randomEventsThread = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
--        survivalTransportSpawner.spawnWithTransports(
--            {
--                "xab1401",
--            },
--            EXPERIMENTAL_TRANSPORT
--        )

        while true do
            runRandomEvents(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
            WaitSeconds(RandomFrequency)
        end
    end

    return {
        start = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
            ForkThread(randomEventsThread, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
        end
    }
end