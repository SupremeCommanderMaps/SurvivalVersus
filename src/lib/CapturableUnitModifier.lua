function newInstance()
    return {
        modify = function(unit, modificationFunction)
            modificationFunction(unit)

            local onCapturedFunction

            onCapturedFunction = function(self, captor)
                local newUnit = ChangeUnitArmy(self, captor:GetArmy())
                modificationFunction(newUnit)
                newUnit.OnCaptured = onCapturedFunction
            end

            unit.OnCaptured = onCapturedFunction
        end
    }
end