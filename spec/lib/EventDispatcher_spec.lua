describe("EventDispatcher", function()

    local EventDispatcher = require "src/lib/EventDispatcher"

    it("passes arguments given to fire", function()
        local events = EventDispatcher:new{}

        local callback = spy.new(function() end)

        events:on("EventName", callback)
        events:fire("EventName", "first", "second")

        assert.spy(callback).was.called()
        assert.spy(callback).was_called_with("first", "second")
    end)

    it("calls all bound callbacks", function()
        local events = EventDispatcher:new{}

        local callbackOne = spy.new(function() end)
        local callbackTwo = spy.new(function() end)

        events:on("EventName", callbackOne)
        events:on("EventName", callbackTwo)
        events:fire("EventName")

        assert.spy(callbackOne).was.called()
        assert.spy(callbackTwo).was.called()
    end)

    it("calls callbacks once per fire", function()
        local events = EventDispatcher:new{}

        local callback = spy.new(function() end)

        events:on("EventName", callback)
        events:fire("EventName")
        events:fire("EventName")
        events:fire("EventName")

        assert.spy(callback).was.called(3)
    end)

end)
