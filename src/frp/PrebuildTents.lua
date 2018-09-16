newInstance = function(playerArmies)
    local function getTentLocationsForArmy(armyName)
        local tentLocations = {
            ARMY_BOTTOM_LEFT = {x = 309.500000, y = 445.500000},
            ARMY_BOTTOM_LMID = {x = 375.500000, y = 429.500000},
            ARMY_BOTTOM_RMID = {x = 435.500000, y = 369.500000},
            ARMY_BOTTOM_RIGHT = {x = 445.500000, y = 309.500000},
            ARMY_TOP_RIGHT = {x = 206.500000, y = 70.500000},
            ARMY_TOP_RMID = {x = 136.500000, y = 81.500000},
            ARMY_TOP_LMID = {x = 75.500000, y = 142.500000},
            ARMY_TOP_LEFT = {x = 70.500000, y = 206.500000},
        }

        local tentLocation = tentLocations[armyName]

        return {
            {x = tentLocation.x - 0, y = tentLocation.y - 0},
            {x = tentLocation.x - 0, y = tentLocation.y - 2},
            {x = tentLocation.x - 0, y = tentLocation.y - 4},
            {x = tentLocation.x - 2, y = tentLocation.y - 0},
            {x = tentLocation.x - 2, y = tentLocation.y - 2},
            {x = tentLocation.x - 2, y = tentLocation.y - 4},
            {x = tentLocation.x - 4, y = tentLocation.y - 0},
            {x = tentLocation.x - 4, y = tentLocation.y - 2},
            {x = tentLocation.x - 4, y = tentLocation.y - 4},
        }
    end

    local function spawnTentsForArmy(armyName, tentCount)
        local tentLocations = getTentLocationsForArmy(armyName)

        for tentIndex = 1, tentCount do
            CreateUnitHPR( "xrb0304", armyName, tentLocations[tentIndex].x, 25.984375 , tentLocations[tentIndex].y , 0,0,0)
        end
    end

    return {
        spawn = function(tentCount)
            for armyName in playerArmies.getNameToIndexMap() do
                spawnTentsForArmy(armyName, tentCount)
            end
        end
    }
end

