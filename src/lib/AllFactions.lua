local UEF = 1
local AEON = 2
local CYBRAN = 3
local SERA = 4

local UEF_ACU = "UEL0001"
local AEON_ACU = "UAL0001"
local CYBRAN_ACU = "URL0001"
local SERA_ACU = "XSL0001"

local function getExtraAcus(factionIndex)
    local extraACUs = {}

    if factionIndex ~= UEF then
        table.insert(extraACUs, UEF_ACU)
    end
    if factionIndex ~= AEON then
        table.insert(extraACUs, AEON_ACU)
    end
    if factionIndex ~= CYBRAN then
        table.insert(extraACUs, CYBRAN_ACU)
    end
    if factionIndex ~= SERA then
        table.insert(extraACUs, SERA_ACU)
    end

    return extraACUs
end

function spawnExtraAcus(armyBrain)
    local posX, posY = armyBrain:GetArmyStartPos()

    for _, acu in getExtraAcus(armyBrain:GetFactionIndex()) do
        armyBrain:CreateUnitNearSpot(acu, posX, posY)
    end
end