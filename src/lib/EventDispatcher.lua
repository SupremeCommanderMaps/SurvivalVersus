local EventDispatcher = {}

function EventDispatcher:new()
    self.__index = self
    return setmetatable({_listeners = {}}, self)
end

local function test(self)
    require 'pl.pretty'.dump(self._listeners)
end


function EventDispatcher:on(eventName, callback)
    self:_addListener(
        eventName,
        {
            callback = callback,
            callOnce = false
        }
    )
end

function EventDispatcher:_addListener(eventName, listener)
    if self._listeners[eventName] == nil then
        self._listeners[eventName] = {}
    end

    listener.isActive = true

    table.insert(
        self._listeners[eventName],
        listener
    )
end

function EventDispatcher:fire(eventName, ...)
    if self._listeners[eventName] == nil then
        return
    end

    for _, listener in pairs(self._listeners[eventName]) do
        if listener.isActive then
            self:_callListener(listener, eventName, ...)
        end

    end
end

function EventDispatcher:_callListener(listener, eventName, ...)
    if listener.callOnce then
        listener.isActive = false
    end

    listener.callback(
        {
            name = eventName,
            target = listener.callback,
            source = self
        },
        ...
    )
end

function EventDispatcher:once(eventName, callback)
    self:_addListener(
        eventName,
        {
            callback = callback,
            callOnce = true
        }
    )
end

return EventDispatcher