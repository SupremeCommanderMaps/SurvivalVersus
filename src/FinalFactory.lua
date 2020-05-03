-- Top level factory / state holder

local mapPath = '/maps/final_rush_pro_5.v0022/'

local entropyLib = import(mapPath .. 'vendor/EntropyLib/src/EntropyLib.lua').newInstance(mapPath .. 'vendor/EntropyLib/')
local notifier

local function localImport(fileName)
    return import(mapPath .. 'src/' .. fileName)
end

function getEntropyLib()
    return entropyLib
end

function getNotifier()
    if notifier == nil then
        notifier = entropyLib.newNotifier()
        notifier.setWarningColor("ffffd4d4")
    end

    return notifier
end

