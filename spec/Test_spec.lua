describe("PlayerArmies", function()

    local PlayerArmies = require 'PlayerArmies'

    describe("getNameForIndex", function()
        local armies = PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_2"})

        it("Given known army index, army name is returned", function()
            assert.are.equal("ARMY_2", armies.getNameForIndex(2))
        end)

        it("Given unknown army index, nil is returned", function()
            assert.is.is_nil(armies.getNameForIndex(3))
        end)
    end)

    describe("getIndexToNameMap", function()
        it("Given empty collection, empty map is returned", function()
            assert.are.same({}, PlayerArmies({}).getIndexToNameMap())
        end)

        it("Given map in constructor, same map is returned", function()
            local armyMap = {[1] = "ARMY_1", [2] = "ARMY_2"}
            assert.are.same(armyMap, PlayerArmies(armyMap).getIndexToNameMap())
        end)
    end)

    describe("getIndexForName", function()
        it("Given unknown army name, nil is returned", function()
            assert.is.is_nil(PlayerArmies({}).getIndexForName("ARMY_1"))
        end)

        it("Given known army name, its index is returned", function()
            assert.is.equal(
                2,
                PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_5"}).getIndexForName("ARMY_5")
            )
        end)
    end)

end)
