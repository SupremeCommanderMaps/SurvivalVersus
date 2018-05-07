newInstance = function(StartingPlayersExistance, randomUnits, AttackLocations, TransportDestinations, ScenarioInfo, ScenarioFramework, getRandomPlayer, spawnOutEffect, unitCreator)
    local Aggression = import('/maps/final_rush_pro_5.11.v0001/lua/Aggression.lua');
    -- TODO: user survival transport spawner

    local Aggro = {
        Team1 = {
            Player1 = 0,
            Player2 = 0,
            Player3 = 0,
            Player4 = 0
        },
        Team2 = {
            Player1 = 0,
            Player2 = 0,
            Player3 = 0,
            Player4 = 0
        }
    }

    local function ArmyToPlayerTeam(army)
        local data = {}
        if army == "ARMY_1" then
            data = { Team = 1, Player = 1 }
        elseif army == "ARMY_2" then
            data = { Team = 1, Player = 2 }
        elseif army == "ARMY_3" then
            data = { Team = 1, Player = 3 }
        elseif army == "ARMY_4" then
            data = { Team = 1, Player = 4 }
        elseif army == "ARMY_5" then
            data = { Team = 2, Player = 1 }
        elseif army == "ARMY_6" then
            data = { Team = 2, Player = 2 }
        elseif army == "ARMY_7" then
            data = { Team = 2, Player = 3 }
        elseif army == "ARMY_8" then
            data = { Team = 2, Player = 4 }
        end
        return data
    end

    local function ArmyToAggro(army)
        if army == "ARMY_1" then
            return Aggro.Team1.Player1
        elseif army == "ARMY_2" then
            return Aggro.Team1.Player2
        elseif army == "ARMY_3" then
            return Aggro.Team1.Player3
        elseif army == "ARMY_4" then
            return Aggro.Team1.Player4
        elseif army == "ARMY_5" then
            return Aggro.Team2.Player1
        elseif army == "ARMY_6" then
            return Aggro.Team2.Player2
        elseif army == "ARMY_7" then
            return Aggro.Team2.Player3
        elseif army == "ARMY_8" then
            return Aggro.Team2.Player4
        end
    end

    local function AgressionTimer(aggrolevel)
        local timenum = 1
        if aggrolevel < 10 then
            timenum = 30
        elseif aggrolevel < 20 then
            timenum = 28
        elseif aggrolevel < 30 then
            timenum = 26
        elseif aggrolevel < 40 then
            timenum = 24
        elseif aggrolevel < 50 then
            timenum = 22
        elseif aggrolevel < 60 then
            timenum = 20
        elseif aggrolevel < 70 then
            timenum = 18
        elseif aggrolevel < 80 then
            timenum = 14
        elseif aggrolevel < 90 then
            timenum = 10
        elseif aggrolevel < 100 then
            timenum = 8
        elseif aggrolevel > 100 then
            timenum = 6
        end
        return timenum
    end

    local function PlayerToLoc(team, player)
        if team == 1 then
            if player == 1 then
                return AttackLocations.Team1.Player1
            elseif player == 2 then
                return AttackLocations.Team1.Player2
            elseif player == 3 then
                return AttackLocations.Team1.Player3
            elseif player == 4 then
                return AttackLocations.Team1.Player4
            end
        elseif team == 2 then
            if player == 1 then
                return AttackLocations.Team2.Player1
            elseif player == 2 then
                return AttackLocations.Team2.Player2
            elseif player == 3 then
                return AttackLocations.Team2.Player3
            elseif player == 4 then
                return AttackLocations.Team2.Player4
            end
        end
    end

    local SendUnitsToPlayer = function(unit, team, player)
        local AttackerARMY
        local TeamToAttack = team
        local TransportEnd
        local transport

        if TeamToAttack == 1 then
            TransportEnd = TransportDestinations.SouthernAttackerEnd
            AttackerARMY = "ARMY_9"
            transport = CreateUnitHPR("xea0306", AttackerARMY, 500, 80, 10, 0,0,0)
        elseif TeamToAttack == 2 then
            TransportEnd = TransportDestinations.NorthernAttackerEnd
            AttackerARMY = "NEUTRAL_CIVILIAN"
            transport = CreateUnitHPR("xea0306", AttackerARMY, 10, 80, 500, 0,0,0)
        end


        local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

        if ScenarioInfo.Options.opt_gamemode == 1 then
            -- classic survival
            transport:SetCanTakeDamage(false);
        end

        local units = {}

        for i=1, 8 do
            table.insert(
                units,
                unitCreator.spawnSurvivalUnit({
                    blueprintName = unit,
                    armyName = AttackerARMY,
                    x = 255.5,
                    y = 255.5,
                    hpIncrease = true
                })
            )
        end

        local transports = {transport}

        ScenarioFramework.AttachUnitsToTransports(units, transports)
        IssueTransportUnload(transports, TransportTo)

        IssueAggressiveMove(units, PlayerToLoc(team, player))
        IssueAggressiveMove(units, getRandomPlayer(TeamToAttack))
        IssueAggressiveMove(units, getRandomPlayer(TeamToAttack))
        IssueMove(transports,TransportEnd)

        WaitSeconds(50)

        for _, transport in transports do
            spawnOutEffect(transport)
        end
    end

    local function AggressionWatcher(army,t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        local teamplayer = ArmyToPlayerTeam(army)
        local unit
        local timewait
        local aggropercent
        local counter = 0

        while not ArmyIsOutOfGame(army) do
            aggropercent = ArmyToAggro(army)
            timewait = AgressionTimer(aggropercent)
            if counter > timewait and aggropercent > 5 then
                if GetGameTimeSeconds() > t4spawndelay then
                    if aggropercent > 100 then
                        unit = randomUnits.getRandomUnit(4)
                    else
                        unit = randomUnits.getRandomUnit(3)
                    end
                elseif GetGameTimeSeconds() > t3spawndelay then
                    if aggropercent > 100 then
                        unit = randomUnits.getRandomUnit(4)
                    else
                        unit = randomUnits.getRandomUnit(3)
                    end
                elseif GetGameTimeSeconds() > t2spawndelay then
                    unit = randomUnits.getRandomUnit(2)
                else
                    unit = randomUnits.getRandomUnit(1)
                end
                ForkThread(SendUnitsToPlayer,unit,teamplayer.Team,teamplayer.Player)
                counter = 0
            end
            WaitSeconds(2)
            counter = counter + 2
        end
    end

    local function CompileAggression()
        Aggro.Team1.Player1 = Aggression.ReturnAggro(1, 1)
        Aggro.Team1.Player2 = Aggression.ReturnAggro(1, 2)
        Aggro.Team1.Player3 = Aggression.ReturnAggro(1, 3)
        Aggro.Team1.Player4 = Aggression.ReturnAggro(1, 4)
        Aggro.Team2.Player1 = Aggression.ReturnAggro(2, 1)
        Aggro.Team2.Player2 = Aggression.ReturnAggro(2, 2)
        Aggro.Team2.Player3 = Aggression.ReturnAggro(2, 3)
        Aggro.Team2.Player4 = Aggression.ReturnAggro(2, 4)
    end

    local function AggressionSpawner(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        if StartingPlayersExistance.ARMY_1 then
            ForkThread(AggressionWatcher,"ARMY_1",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
        if StartingPlayersExistance.ARMY_2 then
            ForkThread(AggressionWatcher,"ARMY_2",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
        if StartingPlayersExistance.ARMY_3 then
            ForkThread(AggressionWatcher,"ARMY_3",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
        if StartingPlayersExistance.ARMY_4 then
            ForkThread(AggressionWatcher,"ARMY_4",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
        if StartingPlayersExistance.ARMY_5 then
            ForkThread(AggressionWatcher,"ARMY_5",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
        if StartingPlayersExistance.ARMY_6 then
            ForkThread(AggressionWatcher,"ARMY_6",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
        if StartingPlayersExistance.ARMY_7 then
            ForkThread(AggressionWatcher,"ARMY_7",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
        if StartingPlayersExistance.ARMY_8 then
            ForkThread(AggressionWatcher,"ARMY_8",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
    end

    local AggressionCheck = function()
        while true do
            CompileAggression()
            WaitSeconds(2)
        end
    end

    return {
        start = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
            ForkThread(Aggression.Aggression)
            ForkThread(AggressionCheck)

            -- TODO: only start spawning stuff once t1spawndelay has passed
            AggressionSpawner(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
        end
    }
end