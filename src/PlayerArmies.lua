newInstance = function(fullIndexToNameMap)
    local function isPlayerArmyName(armyName)
        local names = {
            ["ARMY_1"] = true,  ["ARMY_2"] = true, ["ARMY_3"] = true, ["ARMY_4"] = true,
            ["ARMY_5"] = true,  ["ARMY_6"] = true, ["ARMY_7"] = true, ["ARMY_8"] = true,
        }

        return names[armyName] or false
    end

    local function getMapWithOnlyPlayerArmies(allArmies)
        local map = {}

        for armyIndex, armyName in pairs(allArmies) do
            if isPlayerArmyName(armyName) then map[armyIndex] = armyName end
        end

        return map
    end

    local this = {}
    local indexToNameMap = getMapWithOnlyPlayerArmies(fullIndexToNameMap)
    local nameToIndexMap

    this.getNameForIndex = function(armyIndex)
        return indexToNameMap[armyIndex]
    end

    this.getIndexToNameMap = function()
        return indexToNameMap
    end

    local function buildNameToIndexMap()
        if nameToIndexMap == nil then
            nameToIndexMap = {}

            for armyIndex, armyName in pairs(indexToNameMap) do
                nameToIndexMap[armyName] = armyIndex
            end
        end
    end

    this.getNameToIndexMap = function()
        buildNameToIndexMap()
        return nameToIndexMap
    end

    this.getIndexForName = function(armyName)
        buildNameToIndexMap()
        return nameToIndexMap[armyName]
    end

    this.isBottomSideArmy = function(armyNameOrIndex)
        local bottomArmies = {
            ["ARMY_1"] = true,
            ["ARMY_2"] = true,
            ["ARMY_3"] = true,
            ["ARMY_4"] = true,
        }

        local armyName = tonumber(armyNameOrIndex) and indexToNameMap[armyNameOrIndex] or armyNameOrIndex
        return bottomArmies[armyName] or false
    end

    return this
end

return newInstance