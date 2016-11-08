describe("FinalRushOptions", function()

    local FinalRushOptions = require 'FinalRushOptions'

    describe("defaultGameOptions", function()
        it("returns defaulted options when given an empty table", function()
            local defaultedOptions = FinalRushOptions.defaultOptions({})

            assert.are.equal(0, defaultedOptions.opt_gamemode)
            assert.are.equal(50, defaultedOptions.opt_AutoReclaim)
            assert.are.equal(-1, defaultedOptions.opt_FinalRushRandomEvents)
        end)

        it("does not default options present in the table", function()
            local defaultedOptions = FinalRushOptions.defaultOptions({
                opt_AutoReclaim = 42,
                opt_FinalRushRandomEvents = 1
            })

            assert.are.equal(42, defaultedOptions.opt_AutoReclaim)
            assert.are.equal(1, defaultedOptions.opt_FinalRushRandomEvents)
        end)
    end)

    describe("applyPresets", function()
        it("sets defaults for very easy", function()
            local inputOptions = FinalRushOptions.defaultOptions({
                opt_FinalRushDifficulty = 1
            })

            local returnedOptions = FinalRushOptions.applyPresets(inputOptions)

            assert.are.equal(180, returnedOptions.opt_FinalRushSpawnDelay)
            assert.are.equal(0, returnedOptions.opt_FinalRushAggression)
            assert.are.equal(600, returnedOptions.opt_FinalRushRandomEvents)
            assert.are.equal(0, returnedOptions.opt_FinalRushHunters)
        end)

        it("sets defaults for easy", function()
            local inputOptions = FinalRushOptions.defaultOptions({
                opt_FinalRushDifficulty = 2
            })

            local returnedOptions = FinalRushOptions.applyPresets(inputOptions)

            assert.are.equal(0, returnedOptions.opt_FinalRushSpawnDelay)
            assert.are.equal(1, returnedOptions.opt_FinalRushAggression)
            assert.are.equal(90, returnedOptions.opt_FinalRushRandomEvents)
            assert.are.equal(480, returnedOptions.opt_FinalRushHunters)
        end)
    end)

end)
