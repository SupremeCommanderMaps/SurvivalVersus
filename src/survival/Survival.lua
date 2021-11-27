newInstance = function(ScenarioInfo, localImport, options, textPrinter, playerArmies)
    local ScenarioFramework = import('/lua/ScenarioFramework.lua')

    local factory = localImport('FinalFactory.lua')

    local spawnEffect = function(unit)
        unit:PlayUnitSound('TeleportStart')
        unit:PlayUnitAmbientSound('TeleportLoop')
        WaitSeconds( 0.1 )
        unit:PlayTeleportInEffects()
        WaitSeconds( 0.1 )
        unit:StopUnitAmbientSound('TeleportLoop')
        unit:PlayUnitSound('TeleportEnd')
    end

    local spawnOutEffect = function(unit)
        unit:PlayUnitSound('TeleportStart')
        unit:PlayUnitAmbientSound('TeleportLoop')
        WaitSeconds( 0.1 )
        unit:PlayTeleportInEffects()
        WaitSeconds( 0.1 )
        unit:StopUnitAmbientSound('TeleportLoop')
        unit:PlayUnitSound('TeleportEnd')
        unit:Destroy()
    end

    local unitCreator = localImport('survival/SurvivalUnitCreator.lua').newUnitCreator(
        ScenarioInfo,
        options,
        spawnOutEffect
    )

    local positions = localImport('Positions.lua')

    local function disableWalls()
        for armyIndex in ListArmies() do
            AddBuildRestriction(armyIndex, categories.WALL)
        end
    end

    local function setSurvivalVersusAlliances()
        for armyIndex in ListArmies() do
            SetAlliance(armyIndex, "FRIENDLY_BOT", 'Ally')
        end

        local topArmies = playerArmies.getTopSideArmies().getNameToIndexMap()

        for armyName in topArmies do
            SetAlliance(armyName, "TOP_BOT", 'Enemy')
            SetAlliance(armyName, "BOTTOM_BOT", 'Ally')
            SetAlliance(armyName, "HOSTILE_BOT", 'Enemy')

            for otherArmyName in topArmies do
                if armyName ~= otherArmyName then
                    SetAlliance(armyName, otherArmyName, 'Ally')
                end
            end
        end

        local bottomArmies = playerArmies.getBottomSideArmies().getNameToIndexMap()

        for armyName in bottomArmies do
            SetAlliance(armyName, "TOP_BOT", 'Ally')
            SetAlliance(armyName, "BOTTOM_BOT", 'Enemy')
            SetAlliance(armyName, "HOSTILE_BOT", 'Enemy')

            for otherArmyName in bottomArmies do
                if armyName ~= otherArmyName then
                    SetAlliance(armyName, otherArmyName, 'Ally')
                end
            end
        end
    end

    local function colorBots()
        SetArmyColor("BOTTOM_BOT", 110, 90, 90)
        SetArmyColor("TOP_BOT", 150, 170, 150)
    end

    local function allyBotsWithEachOther()
        SetAlliance("BOTTOM_BOT", "TOP_BOT", 'Ally')
        SetAlliance("HOSTILE_BOT", "TOP_BOT", 'Ally')
        SetAlliance("HOSTILE_BOT", "BOTTOM_BOT", 'Ally')

        SetAlliance("FRIENDLY_BOT", "TOP_BOT", 'Ally')
        SetAlliance("FRIENDLY_BOT", "BOTTOM_BOT", 'Ally')
        SetAlliance("FRIENDLY_BOT", "HOSTILE_BOT", 'Ally')
    end

    local function giveStorage(armyName)
        local brain = GetArmyBrain(armyName)
        brain:GiveStorage('MASS', 4242)
        brain:GiveStorage('ENERGY', 4242)
    end

    local function giveBotsStorage()
        giveStorage("BOTTOM_BOT")
        giveStorage("TOP_BOT")
        giveStorage("HOSTILE_BOT")
        giveStorage("FRIENDLY_BOT")
    end

    local function disableBotResourceOverflow()
        GetArmyBrain("HOSTILE_BOT"):SetResourceSharing(false)
        GetArmyBrain("FRIENDLY_BOT"):SetResourceSharing(false)
    end

    local function createSurvivalStructures()
        local survivalStructures = localImport('survival/SurvivalStructures.lua').newInstance()

        survivalStructures.createTopParagon("BOTTOM_BOT")
        survivalStructures.createTopOmni("HOSTILE_BOT")
        survivalStructures.createTopRadar("FRIENDLY_BOT")

        survivalStructures.createBottomParagon("TOP_BOT")
        survivalStructures.createBottomOmni("HOSTILE_BOT")
        survivalStructures.createBottomRadar("FRIENDLY_BOT")

        localImport('survival/IslandBases.lua').newInstance().spawn()
    end

    local setUp = function()
        disableWalls()

        setSurvivalVersusAlliances()

        colorBots()
        allyBotsWithEachOther()
        giveBotsStorage()
        disableBotResourceOverflow()

        createSurvivalStructures()

        if options.waterKillsAcu() then
            localImport('survival/CommanderWaterPain.lua')
                .newInstance(playerArmies, textPrinter).runThread()

            localImport('HillGuards.lua').newInstance().createHillGuards()
        end

        localImport('survival/ParagonEvent.lua').newInstance(
            ScenarioFramework,
            unitCreator,
            import('/maps/survival_versus.v0028/vendor/EntropyLib/src/UnitRevealer.lua').newInstance(
                playerArmies.getIndexToNameMap()
            ),
            playerArmies,
            positions,
            import('/maps/survival_versus.v0028/vendor/EntropyLib/src/UnitCreationCallbacks.lua').newInstance(ScenarioInfo),
            textPrinter
        ).setUp()
    end

    local runBattle = function(textPrinter, playerArmies)
        local unitSpanwerFactory = localImport('survival/SurvivalSpawnerFactory.lua').newInstance(
            options,
            ScenarioFramework,
            unitCreator,
            playerArmies,
            positions,
            spawnOutEffect,
            positions.TransportDestinations
        )

        local SpawnMulti = ScenarioInfo.Options.opt_FinalRushUnitCount * table.getn(playerArmies.getIndexToNameMap()) / 8

        local function runSurvivalRounds()
            local rounds = localImport('survival/SurvivalRounds.lua').newInstance(
                ScenarioInfo,
                factory.getNotifier(),
                unitSpanwerFactory,
                options,
                SpawnMulti,
                localImport('survival/SurvivalVictory.lua').newInstance(
                    options,
                    textPrinter,
                    playerArmies,
                    factory.getNotifier()
                )
            )

            rounds.start()
        end

        local function getEventTextPrinter()
            return ScenarioInfo.Options.opt_FinalRushEventNotifications == 1 and textPrinter
                    or vendorImport('NullTextPrinter.lua').newInstance()
        end

        local function runRandomEvents()
            if ScenarioInfo.Options.opt_FinalRushRandomEvents > 0 then
                local randomEvents = localImport('survival/RandomEvents.lua').newInstance(
                    ScenarioInfo,
                    getEventTextPrinter(),
                    unitSpanwerFactory,
                    localImport('survival/BeetleEvent.lua').newInstance(unitCreator, spawnEffect)
                )

                randomEvents.start(
                    options,
                    ScenarioInfo.Options.opt_FinalRushRandomEvents
                )
            end
        end

        local function IsBLackOpsAcusEnabled()
            local bobp = GetUnitBlueprintByName("eal0001")
            return bobp.Economy.BuildTime  ~= nil
        end

        local function runBountyHunters()
            if ScenarioInfo.Options.opt_FinalRushHunters > 0 then
                local hunters = localImport('survival/Hunters.lua').newInstance(
                    ScenarioInfo.Options.opt_FinalRushSpawnDelay + ScenarioInfo.Options.opt_FinalRushHunterDelay,
                    unitCreator,
                    getEventTextPrinter(),
                    playerArmies,
                    IsBLackOpsAcusEnabled(),
                    spawnOutEffect,
                    spawnEffect
                )

                ForkThread(
                    hunters.hunterSpanwer,
                    ScenarioInfo.Options.opt_FinalRushHunters / SpawnMulti
                )
            end
        end

        runSurvivalRounds()
        runRandomEvents()
        runBountyHunters()
    end

    return {
        start = function()
            setUp()
            ForkThread(runBattle, textPrinter, playerArmies)
        end
    }
end