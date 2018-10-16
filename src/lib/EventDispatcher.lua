local EventDispatcher = {}

function EventDispatcher:new()
    self.__index = self
    return setmetatable({_callbacks = {}}, self)
end

local function test(self)
    require 'pl.pretty'.dump(self._callbacks)
end

function EventDispatcher:on(eventName, callback)
    if self._callbacks[eventName] == nil then
        self._callbacks[eventName] = {}
    end

    table.insert(self._callbacks[eventName], callback)
end

function EventDispatcher:fire(eventName, ...)
    if self._callbacks[eventName] == nil then
        return
    end

    for _, callback in pairs(self._callbacks[eventName]) do
        callback(...)
    end
end

return EventDispatcher