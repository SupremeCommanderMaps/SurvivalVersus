newInstance = function(resourceCreator, playerArmies)
    local spawnHydroFunctionsByArmyName = {
        ARMY_BOTTOM_LEFT = function()
            resourceCreator.createHydro(VECTOR3(295.5, 25.9844, 443.5))
            resourceCreator.createHydro(VECTOR3(313.5, 25.9844, 443.5))
            resourceCreator.createHydro(VECTOR3(313.5, 25.9844, 461.5))
        end,
        ARMY_BOTTOM_LMID = function()
            resourceCreator.createHydro(VECTOR3(367.5, 25.9844, 427.5))
            resourceCreator.createHydro(VECTOR3(385.5, 25.9844, 427.5))
            resourceCreator.createHydro(VECTOR3(367.5, 25.9844, 445.5))
        end,
        ARMY_BOTTOM_RMID = function()
            resourceCreator.createHydro(VECTOR3(427.5, 25.9844, 367.5))
            resourceCreator.createHydro(VECTOR3(445.5, 25.9844, 367.5))
            resourceCreator.createHydro(VECTOR3(427.5, 25.9844, 385.5))
        end,
        ARMY_BOTTOM_RIGHT = function()
            resourceCreator.createHydro(VECTOR3(443.5, 25.9844, 295.5))
            resourceCreator.createHydro(VECTOR3(461.5, 25.9844, 313.5))
            resourceCreator.createHydro(VECTOR3(443.5, 25.9844, 313.5))
        end,

        ARMY_TOP_LEFT = function()
            resourceCreator.createHydro(VECTOR3(50.5, 25.9844, 198.5))
            resourceCreator.createHydro(VECTOR3(68.5, 25.9844, 198.5))
            resourceCreator.createHydro(VECTOR3(68.5, 25.9844, 216.5))
        end,
        ARMY_TOP_LMID = function()
            resourceCreator.createHydro(VECTOR3(61.5, 25.9922, 140.5))
            resourceCreator.createHydro(VECTOR3(79.5, 25.9922, 122.5))
            resourceCreator.createHydro(VECTOR3(61.5, 25.9922, 140.5))
        end,
        ARMY_TOP_RMID = function()
            resourceCreator.createHydro(VECTOR3(122.5, 25.9922, 79.5))
            resourceCreator.createHydro(VECTOR3(140.5, 25.9922, 61.5))
            resourceCreator.createHydro(VECTOR3(140.5, 25.9922, 79.5))
        end,
        ARMY_TOP_RIGHT = function()
            resourceCreator.createHydro(VECTOR3(198.5, 25.9844, 50.5))
            resourceCreator.createHydro(VECTOR3(216.5, 25.9844, 68.5))
            resourceCreator.createHydro(VECTOR3(198.5, 25.9844, 68.5))
        end,
    }

    return {
        spawnResources = function()
            for armyName in playerArmies.getNameToIndexMap() do
                spawnHydroFunctionsByArmyName[armyName]()
            end
        end
    }
end