describe("PlayerArmies", function()

    local PlayerArmies = require 'frp/PlayerArmies'

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
            assert.are.equal(
                3,
                table.getn(PlayerArmies({[1] = "ARMY_2", [2] = "ARMY_7", [3] = "ARMY_8"}).getIndexToNameMap())
            )
        end)
    end)

    describe("getBottomSideArmies", function()
        it("returns no armies when there are only top side armies", function()
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
        it("returns no armies when there are only bottom side armies", function()
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

    describe("getTargetsForArmy", function()
        it("returns no armies when there are no armies", function()
            local allArmies = PlayerArmies({})

            assert.are.same(
                {},
                allArmies.getTargetsForArmy("NEUTRAL_CIVILIAN").getIndexToNameMap()
            )
        end)

        it("returns all NEUTRAL_CIVILIAN armies when there are only armies for NEUTRAL_CIVILIAN", function()
            local allArmies = PlayerArmies({"ARMY_5", "ARMY_6", "ARMY_8"})

            assert.are.same(
                {"ARMY_5", "ARMY_6", "ARMY_8"},
                allArmies.getTargetsForArmy("NEUTRAL_CIVILIAN").getIndexToNameMap()
            )
        end)

        it("returns all ARMY_9 armies when there are only armies for ARMY_9", function()
            local allArmies = PlayerArmies({"ARMY_1", "ARMY_3", "ARMY_4"})

            assert.are.same(
                {"ARMY_1", "ARMY_3", "ARMY_4"},
                allArmies.getTargetsForArmy("ARMY_9").getIndexToNameMap()
            )
        end)

        it("returns no NEUTRAL_CIVILIAN armies when there are only ARMY_9 armies", function()
            local allArmies = PlayerArmies({"ARMY_1", "ARMY_3", "ARMY_4"})

            assert.are.same(
                {},
                allArmies.getTargetsForArmy("NEUTRAL_CIVILIAN").getIndexToNameMap()
            )
        end)

        it("returns no ARMY_9 armies when there are only NEUTRAL_CIVILIAN armies", function()
            local allArmies = PlayerArmies({"ARMY_5", "ARMY_6", "ARMY_8"})

            assert.are.same(
                {},
                allArmies.getTargetsForArmy("ARMY_9").getIndexToNameMap()
            )
        end)

        it("returns no armies for invalid army name", function()
            local allArmies = PlayerArmies({"ARMY_1", "ARMY_5"})

            assert.are.same(
                {},
                allArmies.getTargetsForArmy("Pink_fluffy_unicorns").getIndexToNameMap()
            )
        end)
    end)

    describe("getRandomArmyName", function()
        it("returns nil when there are no armies", function()
            local armies = PlayerArmies({})

            assert.is_nil(armies.getRandomArmyName())
        end)

        it("returns the army when there is only one army", function()
            local armies = PlayerArmies({"ARMY_5"})

            assert.is.equal("ARMY_5", armies.getRandomArmyName())
        end)

        it("returns one of the armies if there are multiple", function()
            local armies = PlayerArmies({"ARMY_1", "ARMY_5"})
            local randomArmyName = armies.getRandomArmyName()

            assert.is_true(randomArmyName == "ARMY_1" or randomArmyName == "ARMY_5")
        end)

        it("works when there is no army with key 1", function()
            local armies = PlayerArmies({[2] = "ARMY_5"})

            assert.is.equal("ARMY_5", armies.getRandomArmyName())
        end)
    end)

    describe("filterByName", function()
        it("returns only elements matching the filter function", function()
            local armies = PlayerArmies({"ARMY_1", "ARMY_5", "ARMY_6", "ARMY_8"})

            assert.are.same(
                {[2] = "ARMY_5", [3] = "ARMY_6"},
                armies.filterByName(function(armyName)
                    return armyName == "ARMY_5" or armyName == "ARMY_6"
                end).getIndexToNameMap()
            )
        end)
    end)



end)
