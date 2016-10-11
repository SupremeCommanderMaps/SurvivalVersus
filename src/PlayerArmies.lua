return function(armies)
    local this = {}

    this.getNameForIndex = function(armyIndex)
        return armies[armyIndex]
    end

    this.getIndexToNameMap = function()
        return armies
    end

    return this
end