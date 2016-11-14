import('/lua/SimSync.lua');
import('/lua/SimPlayerQuery.lua');

newInstance = function()
    local function print(str, options)
        options = options or {}
        options.size = options.size or 20
        options.color = options.color or "ffffffff"
        options.duration = options.duration or 5
        options.location = options.location or "center"

        PrintText(str, options.size, options.color, options.duration, options.location);
    end

    return {
        print = print,
        printBlankLine = function(options)
            print(" ", options)
        end
    }
end