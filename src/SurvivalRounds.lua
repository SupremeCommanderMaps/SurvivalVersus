newInstance = function(ScenarioInfo, TransportDestinations, GetRandomPlayer, healthMultiplier, RemoveWreckage, spawnOutEffect, Killgroup, ScenarioFramework, textPrinter)
    local GetNearestCommander = function(unitgroup,range)
        local unitattackerpos
        local unit_pos
        local dist
        local CommandersInRange
        local commandertoattack = false

        for _,unitattacker in unitgroup do
            if not unitattacker:IsDead() then
                unitattackerpos = unitattacker:GetPosition()
                local brain = unitattacker:GetAIBrain()
                CommandersInRange = brain:GetUnitsAroundPoint( categories.COMMAND, unitattackerpos, range, 'Enemy' )
            end
        end

        if CommandersInRange then
            for _, unit in CommandersInRange do
                unit_pos = unit:GetPosition()
                dist = VDist2(unitattackerpos.x,unitattackerpos.z,unit_pos.x,unit_pos.z)
                commandertoattack = unit
            end
        end

        return commandertoattack
    end

    local ArmyAttackTarget = function(attackarmy,unitgroup)
        if attackarmy == "army9" then
            IssueAggressiveMove(unitgroup, GetRandomPlayer(1))
            IssueAggressiveMove(unitgroup, GetRandomPlayer(1))
        elseif attackarmy == "civ" then
            IssueAggressiveMove(unitgroup, GetRandomPlayer(2))
            IssueAggressiveMove(unitgroup, GetRandomPlayer(2))
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

        ForkThread(Killgroup, unitgroup)
    end

    local Round1 = function(hpincreasedelay)
        local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))
        local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
        local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

        local transport_AMY9 = CreateUnitHPR("ura0107", "ARMY_9", 500, 80, 10, 0,0,0) -- 6 max

        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_AMY9:SetCanTakeDamage(false);
        end

        local unit1_ARMY9 = CreateUnitHPR("url0103", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Mobile Light Artillery: Medusa
        local unit2_ARMY9 = CreateUnitHPR("uel0103", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Mobile Light Artillery: Lobo
        local unit3_ARMY9 = CreateUnitHPR("xsl0201", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Seraphim T1 Medium Tank: Thaam
        local unit4_ARMY9 = CreateUnitHPR("url0107", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Assault Bot: Mantis
        local unit5_ARMY9 = CreateUnitHPR("uel0201", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Medium Tank: MA12 Striker
        local unit6_ARMY9 = CreateUnitHPR("ual0201", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Aeon T1 Light Tank: Aurora
        local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9,unit3_ARMY9,unit4_ARMY9,unit5_ARMY9,unit6_ARMY9}

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
        end


        local transports_ARMY9 = {transport_AMY9}

        local transport_Civilian = CreateUnitHPR("uea0107", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0)
        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_Civilian:SetCanTakeDamage(false);
        end
        local unit1_Civilian = CreateUnitHPR("url0103", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Mobile Light Artillery: Medusa
        local unit2_Civilian = CreateUnitHPR("uel0103", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Mobile Light Artillery: Lobo
        local unit3_Civilian = CreateUnitHPR("xsl0201", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Seraphim T1 Medium Tank: Thaam
        local unit4_Civilian = CreateUnitHPR("url0107", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Assault Bot: Mantis
        local unit5_Civilian = CreateUnitHPR("uel0201", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Medium Tank: MA12 Striker
        local unit6_Civilian = CreateUnitHPR("ual0201", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Aeon T1 Light Tank: Aurora
        local transports_Civilian = {transport_Civilian}
        local units_Civilian = {unit1_Civilian,unit2_Civilian,unit3_Civilian,unit4_Civilian,unit5_Civilian,unit6_Civilian}

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
        end

        RemoveWreckage(units_ARMY9)
        RemoveWreckage(units_Civilian)

        ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)
        ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

        IssueTransportUnload(transports_ARMY9, TransportTo)
        IssueTransportUnload(transports_Civilian, TransportTo)

        ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
        ForkThread(ArmyAttackTarget,"civ",units_Civilian)

        IssueMove(transports_ARMY9,TransportEnd_ARMY9)
        IssueMove(transports_Civilian,TransportEnd_Civilian)

        WaitSeconds(50)

        for _, transport in transports_ARMY9 do
            spawnOutEffect(transport)
        end

        for _, transport in transports_Civilian do
            spawnOutEffect(transport)
        end
    end

    local Round2 = function(hpincreasedelay)
        local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

        local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
        local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

        local transport_AMY9a
        local transport_AMY9b
        local transport_Civiliana
        local transport_Civilianb

        local transport_AMY9 = CreateUnitHPR("xea0306", "ARMY_9", 500, 80, 10, 0,0,0) --uef t3

        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_AMY9:SetCanTakeDamage(false);
        end

        local unit1_ARMY9 = CreateUnitHPR("url0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T2 Heavy Tank: Rhino
        local unit2_ARMY9 = CreateUnitHPR("ual0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T2 Heavy Tank: Obsidian
        local unit3_ARMY9 = CreateUnitHPR("uel0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Heavy Tank: Pillar
        local unit4_ARMY9 = CreateUnitHPR("del0204", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Gatling Bot: Mongoose
        local unit5_ARMY9 = CreateUnitHPR("url0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --missile  Edit! Changed to: Cybran T2 Heavy Tank: Rhino
        local unit6_ARMY9 = CreateUnitHPR("del0204", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --
        local unit7_ARMY9 = CreateUnitHPR("xsl0203", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  -- Edit! Changed to: Sera t2 HoverTank
        local unit8_ARMY9 = CreateUnitHPR("url0203", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --wagner
        local unit9_ARMY9 = CreateUnitHPR("xsl0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Seraphim T2 Assault Bot: Ilshavoh
        local unit10_ARMY9 = CreateUnitHPR("xal0203", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T2 Assault Tank: Blaze

        local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9,unit3_ARMY9,unit4_ARMY9,unit5_ARMY9,unit6_ARMY9,unit7_ARMY9,unit8_ARMY9,unit9_ARMY9,unit10_ARMY9}
        ForkThread(Killgroup,units_ARMY9)
        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
        end
        local transports_ARMY9 = {transport_AMY9}
        ForkThread(Killgroup,transports_ARMY9)
        ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)

        local transport_Civilian = CreateUnitHPR("xea0306", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0) --uef t3

        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_Civilian:SetCanTakeDamage(false);
        end

        local unit1_Civilian = CreateUnitHPR("url0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T2 Heavy Tank: Rhino
        local unit2_Civilian = CreateUnitHPR("ual0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T2 Heavy Tank: Obsidian
        local unit3_Civilian = CreateUnitHPR("uel0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Heavy Tank: Pillar
        local unit4_Civilian = CreateUnitHPR("del0204", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Gatling Bot: Mongoose
        local unit5_Civilian = CreateUnitHPR("uel0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Mobile Missile Launcher: Flapjack Edit! Changed to: UEF T2 Heavy Tank: Pillar
        local unit6_Civilian = CreateUnitHPR("uel0307", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --shield Edit: Changed to Uef t2 Shield
        local unit7_Civilian = CreateUnitHPR("xsl0203", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --stealth Edit! Changed to: Sera t2 HoverTank
        local unit8_Civilian = CreateUnitHPR("url0306", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --wagner
        local unit9_Civilian = CreateUnitHPR("xsl0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --Seraphim T2 Assault Bot: Ilshavoh
        local unit10_Civilian = CreateUnitHPR("xal0203", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Aeon T2 Assault Tank: Blaze
        local transports_Civilian = {transport_Civilian}
        ForkThread(Killgroup,transports_Civilian)
        local units_Civilian = {unit1_Civilian,unit2_Civilian,unit3_Civilian,unit4_Civilian,unit5_Civilian,unit6_Civilian,unit7_Civilian,unit8_Civilian,unit9_Civilian,unit10_Civilian}
        ForkThread(Killgroup,units_Civilian)

        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
        end

        RemoveWreckage(units_ARMY9)
        RemoveWreckage(units_Civilian)

        ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

        IssueTransportUnload(transports_ARMY9, TransportTo)
        IssueTransportUnload(transports_Civilian, TransportTo)

        ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
        ForkThread(ArmyAttackTarget,"civ",units_Civilian)

        IssueMove(transports_ARMY9,TransportEnd_ARMY9)
        IssueMove(transports_Civilian,TransportEnd_Civilian)

        WaitSeconds(50)

        for _, transport in transports_ARMY9 do
            spawnOutEffect(transport)
        end

        for _, transport in transports_Civilian do
            spawnOutEffect(transport)
        end
    end

    local Round3 = function(hpincreasedelay)
        local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

        local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
        local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

        local transport_AMY9 = CreateUnitHPR("xea0306", "ARMY_9", 500, 80, 10, 0,0,0)
        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_AMY9:SetCanTakeDamage(false);
        end

        local unit1_ARMY9 = CreateUnitHPR("url0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Siege Assault Bot: Loyalist
        local unit2_ARMY9 = CreateUnitHPR("xel0305", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Armored Assault Bot: Percival
        local unit3_ARMY9 = CreateUnitHPR("uel0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
        local unit4_ARMY9 = CreateUnitHPR("ual0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
        local unit5_ARMY9 = CreateUnitHPR("xrl0305", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Armored Assault Bot: The Brick
        local unit6_ARMY9 = CreateUnitHPR("uel0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Heavy Assault Bot: Titan
        local unit7_ARMY9 = CreateUnitHPR("ual0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T3 Heavy Assault Bot: Harbinger Mark IV
        local unit8_ARMY9 = CreateUnitHPR("dal0310", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T3 Shield Disruptor: Absolver
        local unit9_ARMY9 = CreateUnitHPR("xsl0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Seraphim T3 Siege Tank: Othuum
        local unit10_ARMY9 = CreateUnitHPR("xsl0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Seraphim T3 Mobile Shield Generator: Athanah

        local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9,unit3_ARMY9,unit4_ARMY9,unit5_ARMY9,unit6_ARMY9,unit7_ARMY9,unit8_ARMY9,unit9_ARMY9,unit10_ARMY9}
        ForkThread(Killgroup,units_ARMY9)
        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
        end

        local transports_ARMY9 = {transport_AMY9}
        ForkThread(Killgroup,transports_ARMY9)
        ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)

        local transport_Civilian = CreateUnitHPR("xea0306", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0) --uef t3 air
        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_Civilian:SetCanTakeDamage(false);
        end

        local unit1_Civilian = CreateUnitHPR("url0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit2_Civilian = CreateUnitHPR("xel0305", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit3_Civilian = CreateUnitHPR("uel0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit4_Civilian = CreateUnitHPR("ual0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit5_Civilian = CreateUnitHPR("xrl0305", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit6_Civilian = CreateUnitHPR("uel0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit7_Civilian = CreateUnitHPR("ual0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit8_Civilian = CreateUnitHPR("dal0310", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit9_Civilian = CreateUnitHPR("xsl0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
        local unit10_Civilian = CreateUnitHPR("xsl0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)

        local transports_Civilian = {transport_Civilian}
        ForkThread(Killgroup,transports_Civilian)
        local units_Civilian = {unit1_Civilian,unit2_Civilian,unit3_Civilian,unit4_Civilian,unit5_Civilian,unit6_Civilian,unit7_Civilian,unit8_Civilian,unit9_Civilian,unit10_Civilian}
        ForkThread(Killgroup,units_Civilian)
        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
        end

        RemoveWreckage(units_ARMY9)
        RemoveWreckage(units_Civilian)

        ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

        IssueTransportUnload(transports_ARMY9, TransportTo)
        IssueTransportUnload(transports_Civilian, TransportTo)

        ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
        ForkThread(ArmyAttackTarget,"civ",units_Civilian)

        IssueMove(transports_ARMY9,TransportEnd_ARMY9)
        IssueMove(transports_Civilian,TransportEnd_Civilian)

        WaitSeconds(50)

        for _, transport in transports_ARMY9 do
            spawnOutEffect(transport)
        end

        for _, transport in transports_Civilian do
            spawnOutEffect(transport)
        end

    end

    local Round4 = function(hpincreasedelay)
        local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

        local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
        local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

        local transport_AMY9 = CreateUnitHPR("xea0306", "ARMY_9", 500, 80, 10, 0,0,0)
        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_AMY9:SetCanTakeDamage(false);
        end

        local unit1_ARMY9 = CreateUnitHPR("url0402", "ARMY_9", 500,20,10,0,0,0)
        local unit2_ARMY9 = CreateUnitHPR("ual0401", "ARMY_9", 500,20,10,0,0,0)
        local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9}
        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
        end

        local transports_ARMY9 = {transport_AMY9}
        ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)

        local transport_Civilian = CreateUnitHPR("xea0306", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0)
        if ScenarioInfo.Options.opt_gamemode > 2 then
            transport_Civilian:SetCanTakeDamage(false);
        end

        local unit1_Civilian = CreateUnitHPR("url0402", "NEUTRAL_CIVILIAN", 20,20,20,0,0,0)
        local unit2_Civilian = CreateUnitHPR("ual0401", "NEUTRAL_CIVILIAN", 20,20,20,0,0,0)
        local transports_Civilian = {transport_Civilian}
        local units_Civilian = {unit1_Civilian,unit2_Civilian}
        if ScenarioInfo.Options.opt_gamemode > 3 then
            healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
        end

        RemoveWreckage(units_ARMY9)
        RemoveWreckage(units_Civilian)

        ForkThread(Killgroup,transports_Civilian)
        ForkThread(Killgroup,transports_ARMY9)

        ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

        IssueTransportUnload(transports_ARMY9, TransportTo)
        IssueTransportUnload(transports_Civilian, TransportTo)

        ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
        ForkThread(ArmyAttackTarget,"civ",units_Civilian)

        IssueMove(transports_ARMY9,TransportEnd_ARMY9)
        IssueMove(transports_Civilian,TransportEnd_Civilian)

        WaitSeconds(50)

        for _, transport in transports_ARMY9 do
            spawnOutEffect(transport)
        end

        for _, transport in transports_Civilian do
            spawnOutEffect(transport)
        end
    end

    local SpawnerGroup1 = function(delay,frequency,spawnend)
        WaitSeconds(delay)
        while GetGameTimeSeconds() < spawnend do
            ForkThread(Round1,delay)
            WaitSeconds(frequency)
        end
    end

    local SpawnerGroup2 = function(delay,frequency)
        WaitSeconds(delay)
        textPrinter.print("Tech 2 inbound")
        while true do
            ForkThread(Round2,delay)
            WaitSeconds(frequency)
        end
    end

    local SpawnerGroup3 = function(delay,frequency)
        WaitSeconds(delay)
        textPrinter.print("Tech 3 inbound")
        while true do
            ForkThread(Round3,delay)
            WaitSeconds(frequency)
        end
    end

    local SpawnerGroup4 = function(delay,frequency)
        WaitSeconds(delay)
        textPrinter.print("Experimentals inbound")
        while true do
            ForkThread(Round4,delay)
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
