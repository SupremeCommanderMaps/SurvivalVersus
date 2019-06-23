describe("PlayerArmies", function()

    local PlayerArmies = require 'src/PlayerArmies'

    describe("getNameForIndex", function()
        local armies = PlayerArmies({[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_BOTTOM_LMID"})

        it("returns army name when the index is known", function()
            assert.are.equal("ARMY_BOTTOM_LMID", armies.getNameForIndex(2))
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
            local armyMap = {[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_BOTTOM_LMID"}
            assert.are.same(armyMap, PlayerArmies(armyMap).getIndexToNameMap())
        end)
    end)

    describe("getIndexForName", function()
        it("returns nil when the army name is not known", function()
            assert.is_nil(PlayerArmies({}).getIndexForName("ARMY_BOTTOM_LEFT"))
        end)

        it("returns the index of known armies", function()
            assert.is.equal(
                2,
                PlayerArmies({[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_TOP_RIGHT"}).getIndexForName("ARMY_TOP_RIGHT")
            )
        end)
    end)

    describe("isBottomSideArmy", function()
        it("returns true for bottom side ARMY_ names", function()
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_BOTTOM_LEFT"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_BOTTOM_LMID"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_BOTTOM_RMID"))
            assert.is_true(PlayerArmies({}).isBottomSideArmy("ARMY_BOTTOM_RIGHT"))
        end)

        it("returns false for top side ARMY_ names", function()
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_TOP_RIGHT"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_TOP_RMID"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_TOP_LMID"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("ARMY_TOP_LEFT"))
        end)

        it("returns false for non-player ARMY_ names", function()
            assert.is_false(PlayerArmies({}).isBottomSideArmy("BOTTOM_BOT"))
            assert.is_false(PlayerArmies({}).isBottomSideArmy("TOP_BOT"))
        end)

        local armies = {
            [1] = "ARMY_BOTTOM_LEFT",
            [2] = "ARMY_BOTTOM_RMID",
            [3] = "ARMY_TOP_RMID",
            [4] = "ARMY_TOP_LMID",
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
                {ARMY_BOTTOM_LMID = 1, ARMY_TOP_LMID = 2},
                PlayerArmies({[1] = "ARMY_BOTTOM_LMID", [2] = "ARMY_TOP_LMID"}).getNameToIndexMap()
            )
        end)
    end)

    describe("constructor", function()
        it("filters out non-player armies", function()
            assert.are.same(
                {[1] = "ARMY_BOTTOM_LMID", [3] = "ARMY_TOP_LMID"},
                PlayerArmies({[1] = "ARMY_BOTTOM_LMID", [2] = "TOP_BOT", [3] = "ARMY_TOP_LMID", [4] = "BOTTOM_BOT"}).getIndexToNameMap()
            )
        end)
    end)

    describe("table.getn", function()
        it("works on the return value of getIndexToNameMap", function()
            assert.are.equal(
                3,
                table.getn(PlayerArmies({[1] = "ARMY_BOTTOM_LMID", [2] = "ARMY_TOP_LMID", [3] = "ARMY_TOP_LEFT"}).getIndexToNameMap())
            )
        end)
    end)

    describe("getBottomSideArmies", function()
        it("returns no armies when there are only top side armies", function()
            local allArmies = PlayerArmies({[1] = "ARMY_TOP_RIGHT", [2] = "ARMY_TOP_RMID", [3] = "ARMY_TOP_LEFT"})

            assert.are.same(
                {},
                allArmies.getBottomSideArmies().getIndexToNameMap()
            )
        end)

        it("returns only top side armies when there are on both sides", function()
            local allArmies = PlayerArmies({[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_BOTTOM_RIGHT", [3] = "ARMY_TOP_RIGHT", [4] = "ARMY_TOP_LEFT"})
            local bottomArmies = PlayerArmies({[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_BOTTOM_RIGHT"})

            assert.are.same(
                bottomArmies.getIndexToNameMap(),
                allArmies.getBottomSideArmies().getIndexToNameMap()
            )
        end)
    end)

    describe("getTopSideArmies", function()
        it("returns no armies when there are only bottom side armies", function()
            local allArmies = PlayerArmies({[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_BOTTOM_LMID", [3] = "ARMY_BOTTOM_RIGHT"})

            assert.are.same(
                {},
                allArmies.getTopSideArmies().getIndexToNameMap()
            )
        end)

        it("returns only top side armies when there are on both sides", function()
            local allArmies = PlayerArmies({[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_BOTTOM_RIGHT", [3] = "ARMY_TOP_RIGHT", [4] = "ARMY_TOP_LEFT"})
            local topArmies = PlayerArmies({[3] = "ARMY_TOP_RIGHT", [4] = "ARMY_TOP_LEFT"})

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
                allArmies.getTargetsForArmy("TOP_BOT").getIndexToNameMap()
            )
        end)

        it("returns all TOP_BOT armies when there are only armies for TOP_BOT", function()
            local allArmies = PlayerArmies({"ARMY_TOP_RIGHT", "ARMY_TOP_RMID", "ARMY_TOP_LEFT"})

            assert.are.same(
                {"ARMY_TOP_RIGHT", "ARMY_TOP_RMID", "ARMY_TOP_LEFT"},
                allArmies.getTargetsForArmy("TOP_BOT").getIndexToNameMap()
            )
        end)

        it("returns all BOTTOM_BOT armies when there are only armies for BOTTOM_BOT", function()
            local allArmies = PlayerArmies({"ARMY_BOTTOM_LEFT", "ARMY_BOTTOM_RMID", "ARMY_BOTTOM_RIGHT"})

            assert.are.same(
                {"ARMY_BOTTOM_LEFT", "ARMY_BOTTOM_RMID", "ARMY_BOTTOM_RIGHT"},
                allArmies.getTargetsForArmy("BOTTOM_BOT").getIndexToNameMap()
            )
        end)

        it("returns no TOP_BOT armies when there are only BOTTOM_BOT armies", function()
            local allArmies = PlayerArmies({"ARMY_BOTTOM_LEFT", "ARMY_BOTTOM_RMID", "ARMY_BOTTOM_RIGHT"})

            assert.are.same(
                {},
                allArmies.getTargetsForArmy("TOP_BOT").getIndexToNameMap()
            )
        end)

        it("returns no BOTTOM_BOT armies when there are only TOP_BOT armies", function()
            local allArmies = PlayerArmies({"ARMY_TOP_RIGHT", "ARMY_TOP_RMID", "ARMY_TOP_LEFT"})

            assert.are.same(
                {},
                allArmies.getTargetsForArmy("BOTTOM_BOT").getIndexToNameMap()
            )
        end)

        it("returns no armies for invalid army name", function()
            local allArmies = PlayerArmies({"ARMY_BOTTOM_LEFT", "ARMY_TOP_RIGHT"})

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
            local armies = PlayerArmies({"ARMY_TOP_RIGHT"})

            assert.is.equal("ARMY_TOP_RIGHT", armies.getRandomArmyName())
        end)

        it("returns one of the armies if there are multiple", function()
            local armies = PlayerArmies({"ARMY_BOTTOM_LEFT", "ARMY_TOP_RIGHT"})
            local randomArmyName = armies.getRandomArmyName()

            assert.is_true(randomArmyName == "ARMY_BOTTOM_LEFT" or randomArmyName == "ARMY_TOP_RIGHT")
        end)

        it("works when there is no army with key 1", function()
            local armies = PlayerArmies({[2] = "ARMY_TOP_RIGHT"})

            assert.is.equal("ARMY_TOP_RIGHT", armies.getRandomArmyName())
        end)
    end)

    describe("filterByName", function()
        it("returns only elements matching the filter function", function()
            local armies = PlayerArmies({"ARMY_BOTTOM_LEFT", "ARMY_TOP_RIGHT", "ARMY_TOP_RMID", "ARMY_TOP_LEFT"})

            assert.are.same(
                {[2] = "ARMY_TOP_RIGHT", [3] = "ARMY_TOP_RMID"},
                armies.filterByName(function(armyName)
                    return armyName == "ARMY_TOP_RIGHT" or armyName == "ARMY_TOP_RMID"
                end).getIndexToNameMap()
            )
        end)
    end)



end)
