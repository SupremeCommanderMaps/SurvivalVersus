

function newUnitCreator()
    local this = {}
    local onUnitCreated = {}

    local function runOnUnitCreated()
        for _, callback in onUnitCreated do
            callback()
        end
    end

    this.create = function(unitInfo)
        unitInfo.blueprintName = unitInfo.blueprintName or unitInfo[1]
        unitInfo.armyName = unitInfo.armyName or unitInfo[2]
        unitInfo.z = unitInfo.z or 25.9844
        unitInfo.yawInRadians = unitInfo.yawInRadians or 0

        local unit = CreateUnitHPR(
            unitInfo.blueprintName,
            unitInfo.armyName,
            unitInfo.x,
            unitInfo.z,
            unitInfo.y,
            0,
            unitInfo.yawInRadians,
            0
        )

        runOnUnitCreated()

        return unit
    end

    this.onUnitCreated = function(callback)
        table.insert(onUnitCreated, callback)
    end

    return this
end

