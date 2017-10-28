newInstance = function(fullIndexToNameMap)
    local function isPlayerArmyName(armyName)
        local names = {
            ARMY_1 = true,
            ARMY_2 = true,
            ARMY_3 = true,
            ARMY_4 = true,
            ARMY_5 = true,
            ARMY_6 = true,
            ARMY_7 = true,
            ARMY_8 = true,
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

    local indexToNameMap = getMapWithOnlyPlayerArmies(fullIndexToNameMap)
    local nameToIndexMap

    local function buildNameToIndexMap()
        if nameToIndexMap == nil then
            nameToIndexMap = {}

            for armyIndex, armyName in pairs(indexToNameMap) do
                nameToIndexMap[armyName] = armyIndex
            end
        end
    end

    local function isBottomSideArmy(armyNameOrIndex)
        local bottomArmies = {
            ARMY_1 = true,
            ARMY_2 = true,
            ARMY_3 = true,
            ARMY_4 = true,
        }

        local armyName = tonumber(armyNameOrIndex) and indexToNameMap[armyNameOrIndex] or armyNameOrIndex
        return bottomArmies[armyName] or false
    end

    local function isTopSideArmy(armyNameOrIndex)
        local bottomArmies = {
            ARMY_5 = true,
            ARMY_6 = true,
            ARMY_7 = true,
            ARMY_8 = true,
        }

        local armyName = tonumber(armyNameOrIndex) and indexToNameMap[armyNameOrIndex] or armyNameOrIndex
        return bottomArmies[armyName] or false
    end

    local function filter(filterFunction)
        local filtered = {}

        for armyIndex, armyName in pairs(indexToNameMap) do
            if filterFunction(armyName) then
                filtered[armyIndex] = armyName
            end
        end

        return newInstance(filtered)
    end

    local function newFilterMethod(filterFunction)
        return function()
            return filter(filterFunction)
        end
    end

    local getBottomSideArmies = newFilterMethod(isBottomSideArmy)
    local getTopSideArmies = newFilterMethod(isTopSideArmy)

    local function getTargetsForArmy(hunterArmyName)
        if hunterArmyName == "NEUTRAL_CIVILIAN" then
            return getTopSideArmies()
        end

        if hunterArmyName == "ARMY_9" then
            return getBottomSideArmies()
        end

        return newInstance({})
    end

    local function getTableKeys(theTable)
        local keyset = {}

        for key in pairs(theTable) do
            table.insert(keyset, key)
        end

        return keyset
    end

    local function getRandomArmyName()
        local keyset = getTableKeys(indexToNameMap)
        local randomFunction = Random or math.random
        return indexToNameMap[keyset[randomFunction(1, table.getn(keyset))]]
    end

    return {
        getNameForIndex = function(armyIndex)
            return indexToNameMap[armyIndex]
        end,
        getIndexToNameMap = function()
            return indexToNameMap
        end,
        getNameToIndexMap = function()
            buildNameToIndexMap()
            return nameToIndexMap
        end,
        getIndexForName = function(armyName)
            buildNameToIndexMap()
            return nameToIndexMap[armyName]
        end,
        isBottomSideArmy = isBottomSideArmy,
        isTopSideArmy = isTopSideArmy,
        getBottomSideArmies = getBottomSideArmies,
        getTopSideArmies = getTopSideArmies,
        getTargetsForArmy = getTargetsForArmy,
        getRandomArmyName = getRandomArmyName,
        filterByName = filter
    }
end

return newInstance