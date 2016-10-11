PlayerArmies = {}

function PlayerArmies:new(armies)
    self._armies = armies
    return self
end

function PlayerArmies:getNameForIndex(armyIndex)
    return self._armies[armyIndex]
end

function PlayerArmies:getIndexToNameMap()
    return self._armies
end


describe("ArmyList", function()

    describe("getNameForIndex", function()

        local armies = PlayerArmies:new({[1] = "ARMY_1", [2] = "ARMY_2"})

        it("Given known army index, army name is returned", function()
            assert.are.equal("ARMY_2", armies:getNameForIndex(2))
        end)

        it("Given unknown army index, army nil is returned", function()
            assert.is.is_nil(armies:getNameForIndex(3))
        end)

    end)

    describe("getIndexToNameMap", function()

        it("Given empty collection, empty map is returned", function()
            assert.are.same({}, PlayerArmies:new({}):getIndexToNameMap())
        end)

        it("Given map in constructor, same map is returned", function()
            local armyMap = {[1] = "ARMY_1", [2] = "ARMY_2"}
            assert.are.same(armyMap, PlayerArmies:new(armyMap):getIndexToNameMap())
        end)

    end)

end)
