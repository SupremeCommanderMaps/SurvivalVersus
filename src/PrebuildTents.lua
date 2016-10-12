newInstance = function(StartingPlayersExistance)
    local TentsLocation = {
        Team1 = {
            Player1 = {TentX = 309.500000, TentY = 445.500000},
            Player2 = {TentX = 371.500000, TentY = 429.500000},
            Player3 = {TentX = 431.500000, TentY = 369.500000},
            Player4 = {TentX = 441.500000, TentY = 309.500000}
        },
        Team2 = {
            Player1 = {TentX = 202.500000, TentY = 70.500000},
            Player2 = {TentX = 136.500000, TentY = 81.500000},
            Player3 = {TentX = 75.500000,  TentY = 142.500000},
            Player4 = {TentX = 66.500000,  TentY = 202.500000}
        }
    }

    --spawns tents, checks if army exists before inserting, otherwise
    local spawn = function(tentnum)
        local tent = "xrb0304"

        if(StartingPlayersExistance.ARMY_1 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX, 25.984375 , TentsLocation.Team1.Player1.TentY , 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX, 25.984375, TentsLocation.Team1.Player1.TentY - 2, 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX, 25.984375, TentsLocation.Team1.Player1.TentY - 4, 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX - 2, 25.984375, TentsLocation.Team1.Player1.TentY, 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX - 2, 25.984375, TentsLocation.Team1.Player1.TentY - 2, 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX - 2, 25.984375, TentsLocation.Team1.Player1.TentY - 4, 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX - 4, 25.984375, TentsLocation.Team1.Player1.TentY, 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX - 4, 25.984375, TentsLocation.Team1.Player1.TentY - 2, 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_1", TentsLocation.Team1.Player1.TentX - 4, 25.984375, TentsLocation.Team1.Player1.TentY - 4, 0,0,0)
            end
        end
        if(StartingPlayersExistance.ARMY_2 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX, 25.984375, TentsLocation.Team1.Player2.TentY, 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX, 25.984375, TentsLocation.Team1.Player2.TentY - 2, 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX, 25.984375, TentsLocation.Team1.Player2.TentY - 4, 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX + 2, 25.984375, TentsLocation.Team1.Player2.TentY, 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX + 2, 25.984375, TentsLocation.Team1.Player2.TentY - 2, 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX + 2, 25.984375, TentsLocation.Team1.Player2.TentY - 4, 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX + 4, 25.984375, TentsLocation.Team1.Player2.TentY, 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX + 4, 25.984375, TentsLocation.Team1.Player2.TentY - 2, 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_2", TentsLocation.Team1.Player2.TentX + 4, 25.984375, TentsLocation.Team1.Player2.TentY - 4, 0,0,0)
            end
        end
        if(StartingPlayersExistance.ARMY_3 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX, 25.984375, TentsLocation.Team1.Player3.TentY, 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX, 25.984375, TentsLocation.Team1.Player3.TentY - 2, 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX, 25.984375, TentsLocation.Team1.Player3.TentY - 4, 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX + 2, 25.984375, TentsLocation.Team1.Player3.TentY, 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX + 2, 25.984375, TentsLocation.Team1.Player3.TentY - 2, 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX + 2, 25.984375, TentsLocation.Team1.Player3.TentY - 4, 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX + 4, 25.984375, TentsLocation.Team1.Player3.TentY, 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX + 4, 25.984375, TentsLocation.Team1.Player3.TentY - 2, 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_3", TentsLocation.Team1.Player3.TentX + 4, 25.984375, TentsLocation.Team1.Player3.TentY - 4, 0,0,0)
            end
        end
        if(StartingPlayersExistance.ARMY_4 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX, 25.984375, TentsLocation.Team1.Player4.TentY, 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX + 2, 25.984375, TentsLocation.Team1.Player4.TentY, 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX + 4, 25.984375, TentsLocation.Team1.Player4.TentY, 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX, 25.984375, TentsLocation.Team1.Player4.TentY - 2, 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX + 2, 25.984375, TentsLocation.Team1.Player4.TentY - 2, 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX + 4, 25.984375, TentsLocation.Team1.Player4.TentY - 2, 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX, 25.984375, TentsLocation.Team1.Player4.TentY - 4, 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX + 2, 25.984375, TentsLocation.Team1.Player4.TentY - 4, 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_4", TentsLocation.Team1.Player4.TentX + 4, 25.984375, TentsLocation.Team1.Player4.TentY - 4, 0,0,0)
            end
        end
        if(StartingPlayersExistance.ARMY_5 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX, 25.984375, TentsLocation.Team2.Player1.TentY , 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX, 25.984375, TentsLocation.Team2.Player1.TentY - 2 , 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX, 25.984375, TentsLocation.Team2.Player1.TentY - 4 , 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX + 2, 25.984375, TentsLocation.Team2.Player1.TentY , 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX + 2, 25.984375, TentsLocation.Team2.Player1.TentY - 2 , 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX + 2, 25.984375, TentsLocation.Team2.Player1.TentY - 4 , 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX + 4, 25.984375, TentsLocation.Team2.Player1.TentY , 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX + 4, 25.984375, TentsLocation.Team2.Player1.TentY - 2 , 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_5", TentsLocation.Team2.Player1.TentX + 4, 25.984375, TentsLocation.Team2.Player1.TentY - 4 , 0,0,0)
            end
        end
        if(StartingPlayersExistance.ARMY_6 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX, 25.992188, TentsLocation.Team2.Player2.TentY  , 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX, 25.992188, TentsLocation.Team2.Player2.TentY - 2  , 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX, 25.992188, TentsLocation.Team2.Player2.TentY - 4  , 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX - 2, 25.992188, TentsLocation.Team2.Player2.TentY  , 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX - 2, 25.992188, TentsLocation.Team2.Player2.TentY - 2  , 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX - 2, 25.992188, TentsLocation.Team2.Player2.TentY - 4  , 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX - 4, 25.992188, TentsLocation.Team2.Player2.TentY  , 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX - 4, 25.992188, TentsLocation.Team2.Player2.TentY - 2  , 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_6", TentsLocation.Team2.Player2.TentX - 4, 25.992188, TentsLocation.Team2.Player2.TentY - 4  , 0,0,0)
            end
        end
        if(StartingPlayersExistance.ARMY_7 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX, 25.992188, TentsLocation.Team2.Player3.TentY  , 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX, 25.992188, TentsLocation.Team2.Player3.TentY - 2 , 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX, 25.992188, TentsLocation.Team2.Player3.TentY - 4  , 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX - 2, 25.992188, TentsLocation.Team2.Player3.TentY  , 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX - 2, 25.992188, TentsLocation.Team2.Player3.TentY - 2  , 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX - 2, 25.992188, TentsLocation.Team2.Player3.TentY - 4  , 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX - 4, 25.992188, TentsLocation.Team2.Player3.TentY  , 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX - 4, 25.992188, TentsLocation.Team2.Player3.TentY - 2  , 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_7", TentsLocation.Team2.Player3.TentX - 4, 25.992188, TentsLocation.Team2.Player3.TentY - 4  , 0,0,0)
            end
        end
        if(StartingPlayersExistance.ARMY_8 == true) then
            if tentnum > 0 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX, 25.984375, TentsLocation.Team2.Player4.TentY , 0,0,0)
            end
            if tentnum > 1 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX + 2, 25.984375, TentsLocation.Team2.Player4.TentY , 0,0,0)
            end
            if tentnum > 2 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX + 4, 25.984375, TentsLocation.Team2.Player4.TentY, 0,0,0)
            end
            if tentnum > 3 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX , 25.984375, TentsLocation.Team2.Player4.TentY + 2, 0,0,0)
            end
            if tentnum > 4 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX + 2, 25.984375, TentsLocation.Team2.Player4.TentY + 2 , 0,0,0)
            end
            if tentnum > 5 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX + 4, 25.984375, TentsLocation.Team2.Player4.TentY + 2 , 0,0,0)
            end
            if tentnum > 6 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX, 25.984375, TentsLocation.Team2.Player4.TentY + 4, 0,0,0)
            end
            if tentnum > 7 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX + 2, 25.984375, TentsLocation.Team2.Player4.TentY + 4 , 0,0,0)
            end
            if tentnum > 8 then
                CreateUnitHPR( tent, "ARMY_8", TentsLocation.Team2.Player4.TentX + 4, 25.984375, TentsLocation.Team2.Player4.TentY + 4 , 0,0,0)
            end
        end
    end

    return {spawn = spawn}
end

