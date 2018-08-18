function newInstance(getAllUnits)
    local callbacks = {}
    local knownEntityIds = {}

    local function runCallbacks(unit)
        for _, callback in callbacks do
            callback(unit)
        end
    end

    local function findNewUnits()
        for _, unit in getAllUnits() do
            if unit and not unit:IsDead()and not knownEntityIds[unit:GetEntityId()] then
                knownEntityIds[unit:GetEntityId()] = true
                runCallbacks(unit)
            end
        end
    end

    local function cleanDeadEntityIds()
        local cleanedKnownEntityIds = {}

        for entityId in knownEntityIds do
            if GetEntityById(entityId) then
                cleanedKnownEntityIds[entityId] = true
            end
        end

        knownEntityIds = cleanedKnownEntityIds
    end

    ForkThread(function()
        while true do
            for i = 1, 50  do
                findNewUnits()
                WaitTicks(1)
            end

            cleanDeadEntityIds()
        end
    end)

    return {
        -- Add a callback function that gets called whenever a unit is created. It is called with the unit.
        addCallback = function(callback)
            table.insert(callbacks, callback)
        end
    }
end


