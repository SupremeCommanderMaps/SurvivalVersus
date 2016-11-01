describe("PlayerArmies", function()

    local PlayerArmies = require 'PlayerArmies'

    describe("getNameForIndex", function()
        local armies = PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_2"})

        it("returns army name when the index is known", function()
            assert.are.equal("ARMY_2", armies.getNameForIndex(2))
        end)

        it("returns nil when the index is unknown", function()
            assert.is_nil(armies.getNameForIndex(3))
        end)
    end)

    describe("getIndexToNameMap", function()
        it("returns empty map when there are no armies", function()
            assert.are.same({}, PlayerArmies({}).getIndexToNameMap())
        end)

        it("returns the same armies as the constructor got", function()
            local armyMap = {[1] = "ARMY_1", [2] = "ARMY_2"}
            assert.are.same(armyMap, PlayerArmies(armyMap).getIndexToNameMap())
        end)
    end)

    describe("getIndexForName", function()
        it("returns nil when the army name is not known", function()
            assert.is_nil(PlayerArmies({}).getIndexForName("ARMY_1"))
        end)

        it("returns the index of known armies", function()
            assert.is.equal(
                2,
                PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_5"}).getIndexForName("ARMY_5")
            )
        end)
    end)

    describe("isBottomSideArmy", function()
        it("returns true for bottom side ARMY_ names", function()
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_1"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_2"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_3"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_4"))
        end)

        it("returns false for top side ARMY_ names", function()
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_5"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_6"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_7"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_8"))
        end)

        it("returns false for non-player ARMY_ names", function()
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_9"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("NEUTRAL_CIVILIAN"))
        end)

        local armies = {
            [1] = "ARMY_1",
            [2] = "ARMY_3",
            [3] = "ARMY_6",
            [4] = "ARMY_7",
        }

        it("returns true for bottom side army indexes", function()
            assert.is_true(PlayerArmies(armies).isBottomSideArmy(1))
            assert.is_true(PlayerArmies(armies).isBottomSideArmy(2))
        end)

        it("returns false for top side army indexes", function()
            assert.is_false(PlayerArmies(armies).isBottomSideArmy(3))
            assert.is_false(PlayerArmies(armies).isBottomSideArmy(4))
        end)

        it("returns false for unknown army indexes", function()
            assert.is_false(PlayerArmies(armies).isBottomSideArmy(42))
        end)
    end)

    describe("getNameToIndexMap", function()
        it("returns an empty map when there are no armies", function()
            assert.are.same({}, PlayerArmies({}).getNameToIndexMap())
        end)

        it("returns reversed constructor map", function()
            assert.are.same(
                {ARMY_2 = 1, ARMY_7 = 2},
                PlayerArmies({[1] = "ARMY_2", [2] = "ARMY_7"}).getNameToIndexMap()
            )
        end)
    end)

    describe("constructor", function()
        it("filters out non-player armies", function()
            assert.are.same(
                {[1] = "ARMY_2", [3] = "ARMY_7"},
                PlayerArmies({[1] = "ARMY_2", [2] = "NEUTRAL_CIVILIAN", [3] = "ARMY_7", [4] = "ARMY_9"}).getIndexToNameMap()
            )
        end)
    end)

    describe("table.getn", function()
        it("works on the return value of getIndexToNameMap", function()
            assert.are.same(
                3,
                table.getn(PlayerArmies({[1] = "ARMY_2", [2] = "ARMY_7", [3] = "ARMY_8"}).getIndexToNameMap())
            )
        end)
    end)

    describe("getBottomSideArmies", function()
        it("returns an empty table when there are only top side armies", function()
            local allArmies = PlayerArmies({[1] = "ARMY_5", [2] = "ARMY_6", [3] = "ARMY_8"})

            assert.are.same(
                {},
                allArmies.getBottomSideArmies().getIndexToNameMap()
            )
        end)

        it("returns only top side armies when there are on both sides", function()
            local allArmies = PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_4", [3] = "ARMY_5", [4] = "ARMY_8"})
            local bottomArmies = PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_4"})

            assert.are.same(
                bottomArmies.getIndexToNameMap(),
                allArmies.getBottomSideArmies().getIndexToNameMap()
            )
        end)
    end)

    describe("getTopSideArmies", function()
        it("returns an empty table when there are only bottom side armies", function()
            local allArmies = PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_2", [3] = "ARMY_4"})

            assert.are.same(
                {},
                allArmies.getTopSideArmies().getIndexToNameMap()
            )
        end)

        it("returns only top side armies when there are on both sides", function()
            local allArmies = PlayerArmies({[1] = "ARMY_1", [2] = "ARMY_4", [3] = "ARMY_5", [4] = "ARMY_8"})
            local topArmies = PlayerArmies({[3] = "ARMY_5", [4] = "ARMY_8"})

            assert.are.same(
                topArmies.getIndexToNameMap(),
                allArmies.getTopSideArmies().getIndexToNameMap()
            )
        end)
    end)

end)
