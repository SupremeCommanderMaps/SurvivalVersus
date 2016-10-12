import('/lua/SimSync.lua');
import('/lua/SimPlayerQuery.lua');

local createCentralCivilians
local playerArmies

local DestroyMid = function()
    PrintText("Clearing Mid in 10 Seconds. Please clear the area.", 20, "ffffffff", 5, 'center');
    WaitSeconds(10)

    local ExplosionCount = 0
    while ExplosionCount < Random(10, 20) do
        local killit = CreateUnitHPR("ual0001", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0, 0, 0)
        killit:Kill()
        WaitSeconds(Random(1, 3))
        ExplosionCount = ExplosionCount + 1
    end

    LOG("Boom")
    WaitSeconds(5)
    createCentralCivilians()
end

local paragonTimer = function(paragon, armyName)
    PrintText("Player " ..  GetArmyBrain(armyName).Nickname .. " has a Paragon for 60 Seconds", 20, "ffffffff", 5, 'center');

    WaitSeconds(60)
    paragon:Destroy()
    PrintText("Paragon Removed", 20, "ffffffff", 5, 'center');

    ForkThread(DestroyMid)
    WaitSeconds(10)
end

local createParagon = function(owningArmy)
    local armyName = playerArmies.getNameForIndex(owningArmy)
    local randomLowerBound = playerArmies.isBottomSideArmy() and 312 or 20
    local randomUpperBound = playerArmies.isBottomSideArmy() and 492 or 200

    local paragon = CreateUnitHPR(
        "xab1401",
        armyName,
        Random(randomLowerBound, randomUpperBound),
        25.984375,
        Random(randomLowerBound, randomUpperBound),
        0,0,0
    )

    paragon:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)

    paragon.OnCaptured = function(self, captor)
    end

    ForkThread(paragonTimer, paragon, armyName)
end

local createT1pd = function()
    local T1DefenceCount = 0

    while T1DefenceCount < Random(8,16) do
        CreateUnitHPR("uab2101", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T1 PD
        T1DefenceCount = T1DefenceCount + 1
    end
end

local createT2pd = function()
    local T2DefenceCount = 0

    while T2DefenceCount < Random(8,16) do
        CreateUnitHPR("uab2301", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T2 PD
        T2DefenceCount = T2DefenceCount + 1
    end
end

local createAA = function()
    local T3DefenceAACount = 0

    while T3DefenceAACount < Random(8,16) do
        CreateUnitHPR("ueb2304", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T3 Anti Air
        T3DefenceAACount = T3DefenceAACount + 1
    end
end

local createShields = function()
    local T3DefenceShieldCount = 0

    while T3DefenceShieldCount < Random(2,4) do
        CreateUnitHPR("uab4301", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T3 Shield
        T3DefenceShieldCount = T3DefenceShieldCount + 1
    end
end

local createPower = function()
    local T3PowerCount = 0

    while T3PowerCount < Random(2,4) do
        CreateUnitHPR("uab1301", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0)  --T3 Power
        T3PowerCount = T3PowerCount + 1
    end
end

local createRadar = function()
    CreateUnitHPR("uab3104", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --Radar
end

local createParagonActivator = function()
    local paragonActivator = CreateUnitHPR("uac1901", "NEUTRAL_CIVILIAN", Random(245,265), 25.984375, Random(245,265), 0,0,0) --Paragon Activator
    paragonActivator:SetReclaimable(false);
    paragonActivator:SetCanTakeDamage(false);
    paragonActivator:SetDoNotTarget(true);

    paragonActivator.OldOnCaptured = paragonActivator.OnCaptured;

    paragonActivator.OnCaptured = function(self, captor)
        ChangeUnitArmy(self,captor:GetArmy())
        ForkThread(createParagon,captor:GetArmy())
    end
end

createCentralCivilians = function()
    createT1pd()
    createT2pd()
    createAA()
    createShields()
    createPower()
    createRadar()
    createParagonActivator()
end

local setCivilianAlliance = function()
    for armyName in playerArmies.getNameToIndexMap() do
        SetAlliance("NEUTRAL_CIVILIAN", armyName, "Enemy")
    end
end

function setUp(playerArmyList)
    playerArmies = playerArmyList
    setCivilianAlliance()
    createCentralCivilians()
end