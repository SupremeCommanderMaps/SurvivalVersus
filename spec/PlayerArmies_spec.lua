describe("PlayerArmies", function()

    local PlayerArmies = require 'PlayerArmies'

    describe("getNameForIndex", function()
        local armies = PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_2"})

        it("Given known army index, army name is returned", function()
            assert.are.equal("ARMY_2", armies.getNameForIndex(2))
        end)

        it("Given unknown army index, nil is returned", function()
            assert.is_nil(armies.getNameForIndex(3))
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
            assert.is_nil(PlayerArmies({}).getIndexForName("ARMY_1"))
        end)

        it("Given known army name, its index is returned", function()
            assert.is.equal(
                2,
                PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_5"}).getIndexForName("ARMY_5")
            )
        end)
    end)

    describe("isBottomSideArmy", function()
        it("Given bottom side ARMY_, true is returned", function()
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_1"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_2"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_3"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_4"))
        end)

        it("Given top side ARMY_, false is returned", function()
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_5"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_6"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_7"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_8"))
        end)

        it("Given top non-player ARMY_, false is returned", function()
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_9"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("NEUTRAL_CIVILIAN"))
        end)

        local armies = {
            [1] = "ARMY_1",
            [2] = "ARMY_3",
            [3] = "ARMY_6",
            [4] = "ARMY_7",
        }

        it("Given bottom side army index, true is returned", function()
            assert.is_true(require 'PlayerArmies'(armies).isBottomSideArmy(1))
            assert.is_true(require 'PlayerArmies'(armies).isBottomSideArmy(2))
        end)

        it("Given top side army index, false is returned", function()
            assert.is_false(require 'PlayerArmies'(armies).isBottomSideArmy(3))
            assert.is_false(require 'PlayerArmies'(armies).isBottomSideArmy(4))
        end)

        it("Given top unknown army index, false is returned", function()
            assert.is_false(require 'PlayerArmies'(armies).isBottomSideArmy(42))
        end)
    end)

    describe("getNameToIndexMap", function()
        it("Given empty collection, empty map is returned", function()
            assert.are.same({}, PlayerArmies({}).getNameToIndexMap())
        end)

        it("Given map in constructor, it is reversed", function()
            assert.are.same(
                {["ARMY_2"] = 1, ["ARMY_7"] = 2},
                PlayerArmies({[1] = "ARMY_2", [2] = "ARMY_7"}).getNameToIndexMap()
            )
        end)
    end)

end)
