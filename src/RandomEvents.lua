newInstance = function(ScenarioInfo, textPrinter, healthMultiplier, removeWreckage, StartingPlayersExistance, AttackLocations, allUnits, GetRandomPlayer, Killgroup, ListArmies, spawnOutEffect)

    --given an army index returns an army
    local indexToArmy = function(armyIndex)
        local army = ListArmies()[armyIndex]
        return army
    end

    --given a unit returns the army
    local scnArmy = function(unit)
        local armyIndex = unit:GetArmy()
        return indexToArmy(armyIndex)
    end

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

    local SpawnARTY = function(hpincreasedelay)
        textPrinter.print("T3 Mobile Arty Detected");
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local TransportEnd
        local transport

        if TeamToAttack == 1 then --ARMY_9
        TransportEnd = TransportDestinations.SouthernAttackerEnd
        AttackerARMY = "ARMY_9"
        transport = CreateUnitHPR("xea0306", AttackerARMY, 500, 80, 10, 0,0,0)
        elseif TeamToAttack == 2 then
            TransportEnd = TransportDestinations.NorthernAttackerEnd
            AttackerARMY = "NEUTRAL_CIVILIAN"
            transport = CreateUnitHPR("xea0306", AttackerARMY, 10, 80, 500, 0,0,0)
        end


        local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport:SetCanTakeDamage(false);
        end

        local unit1 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
        local unit2 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
        local unit3 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
        local unit4 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
        local unit5 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
        local unit6 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
        local unit7 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
        local unit8 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher

        local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
        local transports = {transport}

        ForkThread(Killgroup,units)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        removeWreckage(units)

        ScenarioFramework.AttachUnitsToTransports(units, transports)
        IssueTransportUnload(transports, TransportTo)

        IssueAggressiveMove(units,GetRandomPlayer(TeamToAttack))
        IssueMove(transports,TransportEnd)

        WaitSeconds(50)

        for index, transport in transports do
            spawnOutEffect(transport)
        end
    end

    local SpawnYthotha = function(hpincreasedelay)
        textPrinter.print("Ythotha Detected");
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local TransportEnd
        local transport

        if TeamToAttack == 1 then --ARMY_9
        TransportEnd = TransportDestinations.SouthernAttackerEnd
        AttackerARMY = "ARMY_9"
        transport = CreateUnitHPR("xea0306", AttackerARMY, 500, 80, 10, 0,0,0)
        elseif TeamToAttack == 2 then
            TransportEnd = TransportDestinations.NorthernAttackerEnd
            AttackerARMY = "NEUTRAL_CIVILIAN"
            transport = CreateUnitHPR("xea0306", AttackerARMY, 10, 80, 500, 0,0,0)
        end


        local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport:SetCanTakeDamage(false);
        end

        local unit1 = CreateUnitHPR("xsl0401", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)

        local units = {unit1}
        local transports = {transport}

        ForkThread(Killgroup,units)
        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        removeWreckage(units)

        ScenarioFramework.AttachUnitsToTransports(units, transports)
        IssueTransportUnload(transports, TransportTo)

        IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))

        IssueMove(transports,TransportEnd)

        WaitSeconds(50)

        for index, transport in transports do
            spawnOutEffect(transport)
        end
    end

    local SpawnBombers = function(hpincreasedelay)
        textPrinter.print("T1 Bombers Detected");
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local Telepoint
        local unit1
        local unit2
        local unit3
        local unit4
        local unit5
        local unit6
        local unit7
        local unit8

        if TeamToAttack == 1 then --ARMY_9
        AttackerARMY = "ARMY_9"
        unit1 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit2 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit3 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit4 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit5 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit6 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit7 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit8 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        elseif TeamToAttack == 2 then
            AttackerARMY = "NEUTRAL_CIVILIAN"
            unit1 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit2 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit3 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit4 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit5 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit6 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit7 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit8 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
        end

        local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
        removeWreckage(units)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

        IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        ForkThread(Killgroup,units)
    end

    local SpawnT1Gunships = function(hpincreasedelay)
        textPrinter.print("T1 Gunships Detected");
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local Telepoint
        local unit1
        local unit2
        local unit3
        local unit4
        local unit5
        local unit6
        local unit7
        local unit8

        if TeamToAttack == 1 then --ARMY_9
        AttackerARMY = "ARMY_9"
        unit1 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit2 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit3 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit4 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit5 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit6 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit7 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit8 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        elseif TeamToAttack == 2 then
            AttackerARMY = "NEUTRAL_CIVILIAN"
            unit1 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit2 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit3 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit4 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit5 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit6 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit7 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit8 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
        end

        local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
        removeWreckage(units)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

        IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        ForkThread(Killgroup,units)
    end

    local SpawnT2Bombers = function(hpincreasedelay)
        textPrinter.print("T2 Bombers Detected");
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local Telepoint
        local unit1
        local unit2
        local unit3
        local unit4
        local unit5
        local unit6
        local unit7
        local unit8

        if TeamToAttack == 1 then --ARMY_9
        AttackerARMY = "ARMY_9"
        unit1 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit2 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit3 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit4 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit5 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit6 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit7 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit8 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        elseif TeamToAttack == 2 then
            AttackerARMY = "NEUTRAL_CIVILIAN"
            unit1 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit2 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit3 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit4 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit5 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit6 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit7 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit8 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
        end

        local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
        removeWreckage(units)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

        IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        ForkThread(Killgroup,units)
    end

    local SpawnT3Bombers = function(hpincreasedelay)
        textPrinter.print("T3 Bombers Detected");
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local Telepoint
        local unit1
        local unit2
        local unit3
        local unit4
        local unit5
        local unit6
        local unit7
        local unit8

        if TeamToAttack == 1 then --ARMY_9
        AttackerARMY = "ARMY_9"
        unit1 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit2 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit3 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit4 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit5 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit6 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit7 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit8 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        elseif TeamToAttack == 2 then
            AttackerARMY = "NEUTRAL_CIVILIAN"
            unit1 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit2 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit3 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit4 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit5 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit6 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit7 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit8 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
        end

        local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
        removeWreckage(units)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

        IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        ForkThread(Killgroup,units)
    end

    local SpawnT3Gunships = function(hpincreasedelay)
        textPrinter.print("T3 Gunships Detected");
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local Telepoint
        local unit1
        local unit2
        local unit3
        local unit4
        local unit5
        local unit6
        local unit7
        local unit8

        if TeamToAttack == 1 then --ARMY_9
        AttackerARMY = "ARMY_9"
        unit1 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit2 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit3 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit4 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit5 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit6 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit7 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        unit8 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
        elseif TeamToAttack == 2 then
            AttackerARMY = "NEUTRAL_CIVILIAN"
            unit1 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit2 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit3 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit4 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit5 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit6 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit7 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
            unit8 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
        end

        local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
        removeWreckage(units)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

        IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        ForkThread(Killgroup,units)
    end

    local SpawnT2Destroyers = function(hpincreasedelay)
        textPrinter.print("Destroyers Detected");
        local unit1_ARMY9 = CreateUnitHPR("urs0201", "ARMY_9", Random(20,30), 25.9844, Random(480,490) ,0,0,0)
        local AttackerARMY
        local TeamToAttack = Random(1,2)
        local Telepoint
        local unit1
        local unit2
        local unit3
        local unit4
        local unit5
        local unit6
        local unit7
        local unit8

        if TeamToAttack == 1 then
            AttackerARMY = "ARMY_9"
            unit1 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
            unit2 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
            unit3 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
            unit4 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
            unit5 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
            unit6 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
            unit7 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
            unit8 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
        elseif TeamToAttack == 2 then
            AttackerARMY = "NEUTRAL_CIVILIAN"
            unit1 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
            unit2 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
            unit3 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
            unit4 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
            unit5 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
            unit6 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
            unit7 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
            unit8 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
        end

        local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
        removeWreckage(units)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units,hpincreasedelay)
        end

        IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

        IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
        ForkThread(Killgroup,units)
    end

    local SpeedCurrentUnits = function()
        textPrinter.print("Current Units Speed Boosted");
        local units = allUnits()
        for index,unit in units do
            if EntityCategoryContains(categories.LAND + categories.NAVAL, unit) and scnArmy(unit) ==  "ARMY_9" or scnArmy(unit) == "NEUTRAL_CIVILIAN" then
                unit:SetSpeedMult(2)
            end
        end
    end

    local randomEventsThread = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
        while true do
            --T2 Section
            if GetGameTimeSeconds() - t2spawndelay > 0 then
                local RandomEvent = Random(1,3)
                if RandomEvent == 1 then
                    ForkThread(SpawnBombers,t2spawndelay)
                elseif RandomEvent == 2 then
                    ForkThread(SpawnT1Gunships, t3spawndelay)
                elseif RandomEvent == 3 then
                    ForkThread(SpeedCurrentUnits)
                end
            end

            --T3 Section
            if GetGameTimeSeconds() - t3spawndelay > 0 then
                local RandomEvent = Random(1,4)
                if RandomEvent == 1 then
                    if (ScenarioInfo.Options.opt_t3arty == 0) then
                        ForkThread(SpawnARTY, t3spawndelay)
                    else
                        ForkThread(SpawnT3Bombers, t4spawndelay)
                    end
                elseif RandomEvent == 2 then
                    ForkThread(SpawnT2Bombers, t3spawndelay)
                elseif RandomEvent == 3 then
                    ForkThread(SpawnT3Gunships, t3spawndelay)
                elseif RandomEvent == 4 then
                    ForkThread(SpawnT2Destroyers, t3spawndelay)
                end
            end

            --T4 Section
            if GetGameTimeSeconds() - t4spawndelay > 0 then
                local RandomEvent = Random(1,2)
                if RandomEvent == 1 then
                    ForkThread(SpawnYthotha, t4spawndelay)
                elseif RandomEvent == 2 then
                    ForkThread(SpawnT3Bombers, t4spawndelay)
                end
            end

            WaitSeconds(RandomFrequency)
        end
    end

    return {
        start = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
            ForkThread(randomEventsThread, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
        end
    }
end