describe("UnitCreator", function()

    local PlayerArmies = require 'src/lib/UnitCreator'

    describe("getNameForIndex", function()
        local armies = PlayerArmies({[1] = "ARMY_BOTTOM_LEFT", [2] = "ARMY_BOTTOM_LMID"})

        it("returns army name when the index is known", function()
            assert.are.equal("ARMY_BOTTOM_LMID", armies.getNameForIndex(2))
        end)

        it("returns nil when the index is unknown", function()
            assert.is_nil(armies.getNameForIndex(3))
        end)
    end)

end)
