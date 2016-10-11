return function(indexToNameMap)
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

    this.getIndexForName = function(armyName)
        buildNameToIndexMap()
        return nameToIndexMap[armyName]
    end

    return this
end