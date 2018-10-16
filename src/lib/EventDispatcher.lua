function newEventDispatcher()
    local callbacks = {}

    return {
        on = function(eventName, callback)
            if callbacks[eventName] == nil then
                callbacks[eventName] = {}
            end

            table.insert(callbacks[eventName], callback)
        end,
        fire = function(eventName, ...)
            if callbacks[eventName] == nil then
               return
            end

            for _, callback in callbacks[eventName] do
                callback(...)
            end
        end
    }
end