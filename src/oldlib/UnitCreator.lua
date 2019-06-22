
-- Creates a new unit and invokes the set callbacks (event handlers) such as "on unit created"
-- Units are constructed from an unitInfo map and callbacks are invoked with the constructed unit and this map.
-- The map can contain flags and info for the callbacks, so the callbacks know if they should run and how to run.
function newUnitCreator()
    local this = {}
    local onUnitCreated = {}

    local function runOnUnitCreated(unit, unitInfo)
        for _, callback in onUnitCreated do
            callback(unit, unitInfo)
        end
    end

    -- General creation function. Use a more specific one (below) if possible
    this.create = function(unitInfo)
        unitInfo.blueprintName = unitInfo.blueprintName or unitInfo[1]
        unitInfo.armyName = unitInfo.armyName or unitInfo[2]
        unitInfo.x = unitInfo.x or 0
        unitInfo.y = unitInfo.y or 0
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

        unit:SetVeterancy(5)

        if unitInfo.baseHealth then
            unit:SetMaxHealth(unitInfo.baseHealth)
            unit:SetHealth(unit, unitInfo.baseHealth)
        end

        if unitInfo.speedMultiplier then
            unit:SetSpeedMult(unitInfo.speedMultiplier)
        end

        runOnUnitCreated(unit, unitInfo)

        return unit
    end

    this.onUnitCreated = function(callback)
        table.insert(onUnitCreated, callback)
    end

    return this
end

