newInstance = function(indexToNameMap)
    local this = {}
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