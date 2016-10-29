newInstance = function(ScenarioInfo, textPrinter, playerArmies)
    local ScenarioFramework = import('/lua/ScenarioFramework.lua');

    local TransportDestinations = {
        SouthernAttackerEnd = VECTOR3(500,80,10),
        NorthernAttackerEnd = VECTOR3(10,80,500)
    }

    local AttackLocations = {
        Team1 = {
            Player1 = VECTOR3( 305.5, 25.9844, 451.5 ),
            Player2 = VECTOR3( 375.5, 25.9844, 435.5 ),
            Player3 = VECTOR3( 435.5, 25.9844, 375.5 ),
            Player4 = VECTOR3( 451.5, 25.9844, 305.5 )
        },
        Team2 = {
            Player1 = VECTOR3( 206.5, 25.9844, 60.5 ),
            Player2 = VECTOR3( 132.5, 25.9922, 71.5 ),
            Player3 = VECTOR3( 71.5, 25.9922, 132.5 ),
            Player4 = VECTOR3( 68.5, 25.9844, 214.5 )
        }
    }

    local StartingPlayersExistance = {
        ARMY_1 = false,
        ARMY_2 = false,
        ARMY_3 = false,
        ARMY_4 = false,
        ARMY_5 = false,
        ARMY_6 = false,
        ARMY_7 = false,
        ARMY_8 = false
    }

    local function createStartingPlayersExistance()
        if not ScenarioInfo.ArmySetup["ARMY_1"] == false then
            StartingPlayersExistance.ARMY_1 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_2"] == false then
            StartingPlayersExistance.ARMY_2 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_3"] == false then
            StartingPlayersExistance.ARMY_3 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_4"] == false then
            StartingPlayersExistance.ARMY_4 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_5"] == false then
            StartingPlayersExistance.ARMY_5 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_6"] == false then
            StartingPlayersExistance.ARMY_6 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_7"] == false then
            StartingPlayersExistance.ARMY_7 = true
        end
        if not ScenarioInfo.ArmySetup["ARMY_8"] == false then
            StartingPlayersExistance.ARMY_8 = true
        end
    end

    local function IsTotalVetEnabled()
        local ai = GetArmyBrain("ARMY_9")
        for _,unit  in ai:GetListOfUnits( categories.STRUCTURE, false ) do
            if unit:GetBlueprint().Economy.xpValue == nil then
                LOG('TVG Disabled')
                return false
            else
                LOG('TVG Enabled')
                return true
            end
        end
    end

    local function IsBLackOpsAcusEnabled()
        local bobp = GetUnitBlueprintByName("eal0001")
        if bobp.Economy.BuildTime  == nil then
            LOG('Blackops Disabled')
            return false
        else
            LOG('Blackops Enabled')
            return true
        end
    end

    local allUnits = function()
        return GetUnitsInRect({x0 = 0, x1 = ScenarioInfo.size[1], y0 = 0, y1 = ScenarioInfo.size[2]})
    end

    local GetRandomPlayer = function(team)
        local selectplayertoattack = Random(1,4)
        local Units_FinalFight

        if team == 1 then
            if selectplayertoattack == 1 then
                Units_FinalFight = AttackLocations.Team1.Player1
            elseif selectplayertoattack == 2 then
                Units_FinalFight = AttackLocations.Team1.Player2
            elseif selectplayertoattack == 3 then
                Units_FinalFight = AttackLocations.Team1.Player3
            elseif selectplayertoattack == 4 then
                Units_FinalFight = AttackLocations.Team1.Player4
            end
        elseif team == 2 then
            if selectplayertoattack == 1 then
                Units_FinalFight = AttackLocations.Team2.Player1
            elseif selectplayertoattack == 2 then
                Units_FinalFight = AttackLocations.Team2.Player2
            elseif selectplayertoattack == 3 then
                Units_FinalFight = AttackLocations.Team2.Player3
            elseif selectplayertoattack == 4 then
                Units_FinalFight = AttackLocations.Team2.Player4
            end
        end
        return Units_FinalFight
    end

    local function RemoveWreckage(unitgroup)
        local bp
        if (ScenarioInfo.Options.opt_AutoReclaim > 0) then
            for _, unit in unitgroup do
                bp = unit:GetBlueprint()
                bp.Wreckage = nil
            end
        end
    end

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

    local Killgroup = function(unitgroup)
        WaitSeconds(60*5)
        for _, value in unitgroup do
            if not value:IsDead() then
                spawnOutEffect(value)
            end
        end
    end

    local function disableWalls()
        for armyIndex in ListArmies() do
            AddBuildRestriction(armyIndex, categories.WALL)
        end
    end

    local setUp = function()
        disableWalls()

        if ScenarioInfo.Options.opt_gamemode == 2 then  --versus survival
        local tblArmies = ListArmies()
        for index, name in tblArmies do
            if name == "ARMY_5" or name == "ARMY_6" or name == "ARMY_7" or name == "ARMY_8" then
                SetAlliance(index, "NEUTRAL_CIVILIAN", 'Enemy')
                SetAlliance(index, "ARMY_9", 'Ally')
            elseif name == "ARMY_1" or name == "ARMY_2" or name == "ARMY_3" or name == "ARMY_4" then
                SetAlliance(index, "ARMY_9", 'Enemy')
                SetAlliance(index, "NEUTRAL_CIVILIAN", 'Ally')
            end
        end

        SetAlliance("ARMY_9", "NEUTRAL_CIVILIAN", 'Ally')
        end

        local survivalStructures = import('/maps/Final Rush Pro 5/src/SurvivalStructures.lua').newInstance()

        if ScenarioInfo.Options.opt_gamemode > 2 then  --easy, normal, hard and insane survival
        local tblArmies = ListArmies()
        for index in tblArmies do
            SetAlliance(index, "NEUTRAL_CIVILIAN", 'Enemy')
            SetAlliance(index, "ARMY_9", 'Enemy')
        end
        SetAlliance("ARMY_9", "NEUTRAL_CIVILIAN", 'Ally')

        local commanderWaterPain = import('/maps/Final Rush Pro 5/src/CommanderWaterPain.lua').newInstance(allUnits)
        commanderWaterPain.runThread()

        survivalStructures.createHillGuards()
        end

        survivalStructures.createParagons()
        survivalStructures.createRadars()
    end

    local runBattle = function(textPrinter, playerArmies)
        local healthMultiplier = import('/maps/Final Rush Pro 5/src/HealthMultiplier.lua').newInstance(
            ScenarioInfo.Options.opt_gamemode,
            IsTotalVetEnabled()
        )

        local SpawnMulti = table.getn(playerArmies.getIndexToNameMap()) / 8

        local t1spawndelay = 0
        local t2spawndelay = 0
        local t3spawndelay = 0
        local t4spawndelay = 0
        local hunterdelay = 0

        local t1frequency = 0
        local t2frequency = 0
        local t3frequency = 0
        local t4frequency = 0
        local hunterfrequency = 0
        local RandomFrequency = 0

        if ScenarioInfo.Options.opt_gamemode < 4 then
            LOG("Survival Easy or Versus")
            t1spawndelay = 0
            t2spawndelay = 6  * 60
            t3spawndelay = 12 * 60
            t4spawndelay = 18 * 60
            hunterdelay  = 24 * 60
            t1frequency = 6
            t2frequency = 6
            t3frequency = 10
            t4frequency = 30
            hunterfrequency = 4 * 60
            RandomFrequency = 90
        elseif ScenarioInfo.Options.opt_gamemode == 4 then
            LOG("Survival Normal")
            t1spawndelay = 0
            t2spawndelay = 6  * 60
            t3spawndelay = 12 * 60
            t4spawndelay = 18 * 60
            hunterdelay  = 22 * 60
            t1frequency = 6
            t2frequency = 6
            t3frequency = 10
            t4frequency = 10
            hunterfrequency = 3 * 60
            RandomFrequency = 70
        elseif ScenarioInfo.Options.opt_gamemode == 5 then
            LOG("Survival Hard")
            t1spawndelay = 0
            t2spawndelay = 5  * 60
            t3spawndelay = 10 * 60
            t4spawndelay = 16 * 60
            hunterdelay  = 18 * 60
            t1frequency = 6
            t2frequency = 6
            t3frequency = 10
            t4frequency = 10
            hunterfrequency = 2 * 60
            RandomFrequency = 50
        elseif ScenarioInfo.Options.opt_gamemode == 6 then
            LOG("Survival Insane")
            t1spawndelay = 0
            t2spawndelay = 4 * 60
            t3spawndelay = 8 * 60
            t4spawndelay = 14 * 60
            hunterdelay  = 16 * 60
            t1frequency = 6
            t2frequency = 6
            t3frequency = 10
            t4frequency = 8
            hunterfrequency = 90
            RandomFrequency = 30
        end

        t1spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t1spawndelay
        t2spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t2spawndelay
        t3spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t3spawndelay
        t4spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t4spawndelay
        hunterdelay  = ScenarioInfo.Options.opt_FinalRushSpawnDelay + hunterdelay

        if ScenarioInfo.Options.opt_FinalRushAggression == 1 then
            local agressionSpawner = import('/maps/Final Rush Pro 5/src/AggressionSpawner.lua').newInstance(
                StartingPlayersExistance,
                import('/maps/Final Rush Pro 5/src/RandomUnits.lua').newInstance(ScenarioInfo, ScenarioFramework),
                AttackLocations,
                TransportDestinations,
                ScenarioInfo,
                ScenarioFramework,
                GetRandomPlayer,
                Killgroup,
                RemoveWreckage,
                spawnOutEffect,
                healthMultiplier
            )

            agressionSpawner.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end

        local rounds = import('/maps/Final Rush Pro 5/src/SurvivalRounds.lua').newInstance(
            textPrinter,
            import('/maps/Final Rush Pro 5/src/SurvivalUnitSpawnerFactory.lua').newInstance(
                ScenarioInfo,
                ScenarioFramework,
                healthMultiplier,
                RemoveWreckage,
                GetRandomPlayer,
                Killgroup,
                spawnOutEffect,
                TransportDestinations
            )
        )

        rounds.start({
            T1 = {
                initialDelayInSeconds = t1spawndelay,
                frequencyInSeconds = t1frequency / SpawnMulti,
                spawnEndInSeconds = t2spawndelay,
            },
            T2 = {
                initialDelayInSeconds = t2spawndelay,
                frequencyInSeconds = t2frequency / SpawnMulti,
                spawnEndInSeconds = nil,
            },
            T3 = {
                initialDelayInSeconds = t3spawndelay,
                frequencyInSeconds = t3frequency / SpawnMulti,
                spawnEndInSeconds = nil,
            },
            T4 = {
                initialDelayInSeconds = t4spawndelay,
                frequencyInSeconds = t4frequency / SpawnMulti,
                spawnEndInSeconds = nil,
            },
        })

        local randomEvents = import('/maps/Final Rush Pro 5/src/RandomEvents.lua').newInstance(
            ScenarioInfo,
            textPrinter,
            healthMultiplier,
            RemoveWreckage,
            StartingPlayersExistance,
            AttackLocations,
            allUnits,
            GetRandomPlayer,
            Killgroup,
            ListArmies,
            spawnOutEffect,
            TransportDestinations
        )

        randomEvents.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)

        local hunters = import('/maps/Final Rush Pro 5/src/Hunters.lua').newInstance(
            textPrinter,
            healthMultiplier,
            playerArmies,
            IsBLackOpsAcusEnabled(),
            spawnOutEffect,
            allUnits,
            spawnEffect
        )

        ForkThread(hunters.hunterSpanwer, hunterdelay, hunterfrequency / SpawnMulti)
    end

    return {
        start = function()
            createStartingPlayersExistance()
            setUp()
            ForkThread(runBattle, textPrinter, playerArmies)
        end
    }
end