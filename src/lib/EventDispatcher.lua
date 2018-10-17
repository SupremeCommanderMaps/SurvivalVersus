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

    table.insert(
        self._listeners[eventName],
        listener
    )
end

function EventDispatcher:fire(eventName, ...)
    if self._listeners[eventName] == nil then
        return
    end

    for key, listener in pairs(self._listeners[eventName]) do
        self:_callListener(listener, eventName, ...)

        if listener.callOnce then
            table.remove(self._listeners[eventName], key)
        end
    end
end

function EventDispatcher:_callListener(listener, eventName, ...)
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