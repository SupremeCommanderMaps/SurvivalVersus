import('/lua/SimSync.lua');
import('/lua/SimPlayerQuery.lua');

newInstance = function(playerArmies, textPrinter)
    local createCentralCivilians

    local DestroyMid = function()
        textPrinter.print("Clearing Mid in 10 Seconds. Please clear the area.");
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
        textPrinter.print("Player " ..  GetArmyBrain(armyName).Nickname .. " has a Paragon for 60 Seconds");

        WaitSeconds(60)
        paragon:Destroy()
        textPrinter.print("Paragon Removed");

        ForkThread(DestroyMid)
        WaitSeconds(10)
    end

    local createParagon = function(owningArmy)
        local armyName = playerArmies.getNameForIndex(owningArmy)
        local randomLowerBound = playerArmies.isBottomSideArmy(owningArmy) and 312 or 20
        local randomUpperBound = playerArmies.isBottomSideArmy(owningArmy) and 492 or 200

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

    local newUnitSpanwer = function()
        local wtfIsThisValue = 25.984375

        return {
            spawnUnit = function(blueprintName, armyName, x, y)
                return CreateUnitHPR(blueprintName, armyName, x, wtfIsThisValue, y, 0,0,0)
            end
        }
    end

    local newBaseSpanwer = function(unitSpanwer, baseCenter, baseOwnerName)
        local x = baseCenter.x
        local y = baseCenter.y

        local function spawnAround(blueprintName, options)
            local radius = options.distance
            local anglePerElement = 360 / options.numberOfPoints
            local pointFilter = options.pointFilter or function() return true end

            for pointNumber=1, options.numberOfPoints do
                if pointFilter(pointNumber) then
                    local angle = math.rad(anglePerElement * pointNumber)

                    unitSpanwer.spawnUnit(
                        blueprintName,
                        baseOwnerName,
                        x + radius * math.sin(angle),
                        y + radius * math.cos(angle)
                    )
                end
            end
        end

        local function spawnAroundDiagonally(blueprintName, options)
            spawnAround(
                blueprintName,
                {
                    distance = options.distance,
                    numberOfPoints = options.numberOfPoints or 8,
                    pointFilter = function(pointNumber)
                        return math.mod(pointNumber, 2) == 1
                    end
                }
            )
        end

        local function spawnAroundStraight(blueprintName, options)
            spawnAround(
                blueprintName,
                {
                    distance = options.distance,
                    numberOfPoints = options.numberOfPoints or 8,
                    pointFilter = function(pointNumber)
                        return math.mod(pointNumber, 2) == 0
                    end
                }
            )
        end

        return {
            spawnCentralStructure = function(blueprintName)
                return unitSpanwer.spawnUnit(blueprintName, baseOwnerName, x, y)
            end,
            spawnAroundDiagonally = spawnAroundDiagonally,
            spawnAroundStraight = spawnAroundStraight,
            spawnAround = spawnAround
        }
    end

    local mapCenter = {
        x = 255,
        y = 255
    }

    local baseSpawner = newBaseSpanwer(newUnitSpanwer(), mapCenter, "NEUTRAL_CIVILIAN")

    local createParagonActivator = function()
        local paragonActivator = baseSpawner.spawnCentralStructure("uac1901")
        paragonActivator:SetReclaimable(false);
        paragonActivator:SetCanTakeDamage(false);
        paragonActivator:SetDoNotTarget(true);
        paragonActivator:SetCustomName("Paragon Activator")

        paragonActivator.OldOnCaptured = paragonActivator.OnCaptured;

        paragonActivator.OnCaptured = function(self, captor)
            ChangeUnitArmy(self,captor:GetArmy())
            ForkThread(createParagon,captor:GetArmy())
        end
    end

    createCentralCivilians = function()
        baseSpawner.spawnAroundStraight("uab1301", {distance = 6}) -- Power
        baseSpawner.spawnAroundDiagonally("uab4301", {distance = 8}) -- Shields
        baseSpawner.spawnAroundDiagonally("uab3104", {distance = 8}) -- Radar (inside the shields)

        baseSpawner.spawnAroundStraight("uab2304", {distance = 12, numberOfPoints = 16}) -- T3 AA
        baseSpawner.spawnAroundDiagonally("uab4201", {distance = 12, numberOfPoints = 16}) -- TMD
        baseSpawner.spawnAround("uab2301", {distance = 16, numberOfPoints = 16}) -- T2 PD
        baseSpawner.spawnAround("uab2101", {distance = 19, numberOfPoints = 24}) -- T1 PD

        createParagonActivator()
    end

    local setCivilianAlliance = function()
        for armyName in playerArmies.getNameToIndexMap() do
            SetAlliance("NEUTRAL_CIVILIAN", armyName, "Enemy")
        end
    end

    local this = {}

    this.setUp = function()
        setCivilianAlliance()
        createCentralCivilians()
    end

    return this
end

