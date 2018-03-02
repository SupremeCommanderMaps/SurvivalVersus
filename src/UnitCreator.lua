

function newUnitCreator()
    local this = {
        onUnitCreated = {}
    }

    local function runOnUnitCreated()
        for _, hook in this.onUnitCreated do
            hook()
        end
    end

    this.createUnit = function(unitInfo)
        unitInfo.yawInRadians = unitInfo.yawInRadians or 0

        local unit = CreateUnitHPR(
            unitInfo.blueprintName,
            unitInfo.armyName,
            x,
            25.9844,
            y,
            0,
            yawInRadians,
            0
        )

        runOnUnitCreated()

        return unit
    end

    return this
end

