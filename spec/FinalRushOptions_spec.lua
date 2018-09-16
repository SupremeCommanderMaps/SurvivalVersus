describe("FinalRushOptions", function()

    local FinalRushOptions = require 'frp/FinalRushOptions'

    describe("defaultGameOptions", function()
        it("returns defaulted options when given an empty table", function()
            local options = FinalRushOptions({}).getRawOptions()

            assert.are.equal(0, options.opt_gamemode)
            assert.are.equal(50, options.opt_AutoReclaim)
            assert.are.equal(70, options.opt_FinalRushRandomEvents)
        end)

        it("does not default options present in the table", function()
            local options = FinalRushOptions({
                opt_AutoReclaim = 42,
                opt_FinalRushRandomEvents = 1
            }).getRawOptions()

            assert.are.equal(42, options.opt_AutoReclaim)
            assert.are.equal(1, options.opt_FinalRushRandomEvents)
        end)
    end)

    describe("applyPresets", function()
        it("sets defaults for very easy", function()
            local options = FinalRushOptions({
                opt_FinalRushDifficulty = 1
            }).getRawOptions()

            assert.are.equal(180, options.opt_FinalRushSpawnDelay)
            assert.are.equal(0, options.opt_FinalRushAggression)
            assert.are.equal(600, options.opt_FinalRushRandomEvents)
            assert.are.equal(0, options.opt_FinalRushHunters)
        end)

        it("sets defaults for easy", function()
            local options = FinalRushOptions({
                opt_FinalRushDifficulty = 2
            }).getRawOptions()

            assert.are.equal(10, options.opt_FinalRushSpawnDelay)
            assert.are.equal(0, options.opt_FinalRushAggression)
            assert.are.equal(90, options.opt_FinalRushRandomEvents)
            assert.are.equal(480, options.opt_FinalRushHunters)
        end)
    end)

end)
