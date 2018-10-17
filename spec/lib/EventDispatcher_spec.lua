describe("EventDispatcher", function()

    local EventDispatcher = require "src/lib/EventDispatcher"

    it("passes arguments given to fire", function()
        local events = EventDispatcher:new{}

        local callback = spy.new(function() end)

        events:on("EventName", callback)
        events:fire("EventName", "first", "second")

        assert.spy(callback).was_called_with(
            {
                name = "EventName",
                target = callback,
                source = events
            },
            "first",
            "second"
        )
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

    it("once callbacks only get called once", function()
        local events = EventDispatcher:new{}

        local callback = spy.new(function() end)

        events:once("EventName", callback)
        events:fire("EventName")
        events:fire("EventName")

        assert.spy(callback).was.called(1)
    end)

    it("different instances do not share callback state", function()
        local eventsOne = EventDispatcher:new{}
        local eventsTwo = EventDispatcher:new{}

        local callback = spy.new(function() end)

        eventsOne:on("EventName", callback)
        eventsTwo:fire("EventName")

        assert.spy(callback).was.called(0)
    end)

    it("multiple callbacks", function()
        local events = EventDispatcher:new{}

        local eventOneCallback = spy.new(function() end)
        local eventTwoCallback = spy.new(function() end)
        local eventThreeCallback = spy.new(function() end)

        events:on("EventOne", eventOneCallback)
        events:on("EventTwo", eventTwoCallback)
        events:on("EventThree", eventThreeCallback)

        events:fire("EventTwo")
        events:fire("EventTwo")
        events:fire("EventThree")

        assert.spy(eventOneCallback).was.called(0)
        assert.spy(eventTwoCallback).was.called(2)
        assert.spy(eventThreeCallback).was.called(1)
    end)

    it("binding once callbacks does not affect normal bound callbacks", function()
        local events = EventDispatcher:new{}

        local normalCallback = spy.new(function() end)
        local onceCallback = spy.new(function() end)

        events:on("EventName", normalCallback)
        events:once("EventName", onceCallback)
        events:fire("EventName")
        events:fire("EventName")

        assert.spy(onceCallback).was.called(1)
        assert.spy(normalCallback).was.called(2)
    end)

end)
