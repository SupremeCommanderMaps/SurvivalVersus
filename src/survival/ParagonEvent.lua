function newInstance(ScenarioFramework, unitCreator, unitRevealer, playerArmies, positions, unitCreation, textPrinter)
    local BASE_HEALTH = 7500
    local OUTER_SHIELD_HP = 7500
    local INNER_SHIELD_HP = 10000

    local function spawnTransport(botArmyName)
        local spawnPosition = positions.transports[botArmyName].spawnPosition

        local transport = unitCreator.create({
            armyName = botArmyName,
            blueprintName = "uaa0107",
            baseHealth = BASE_HEALTH,
            x = spawnPosition.x,
            y = spawnPosition.y,
            z = 80,
            isTransport = true
        })

        transport:SetSpeedMult(1.75)
        transport:SetCustomName("I heard you like Paragons")
        transport.CreateWreckage = function() end

        return transport
    end

--    local function getParagonPosition(armyBrain)
--        local CAN_BE_IDLE = false
--        local NEEDS_TO_BE_BUILD = true
--        local paragon = armyBrain:GetListOfUnits(categories.xab1401, CAN_BE_IDLE, NEEDS_TO_BE_BUILD)[1]
--        return paragon:GetPosition()
--    end

    local function createParagon(armyName)
        local paragon = unitCreator.create({
            armyName = armyName,
            blueprintName = "xab1401",
            baseHealth = BASE_HEALTH,
        })

        paragon.CreateWreckage = function() end
        paragon:SetDoNotTarget(true)

        return paragon
    end

    local function addSingleUseShieldToTransport(transport)
        transport:CreateShield({
            ImpactEffects="SeraphimShieldHit01",
            ImpactMesh="/effects/entities/ShieldSection01/ShieldSection01_mesh",
            Mesh="/effects/entities/AeonShield01/AeonShield01_mesh",
            MeshZ="/effects/entities/Shield01/Shield01z_mesh",
            RegenAssistMult=60,
            ShieldEnergyDrainRechargeTime=5,
            ShieldMaxHealth=INNER_SHIELD_HP,
            ShieldRechargeTime=45,
            ShieldRegenRate=133,
            ShieldRegenStartTime=3,
            ShieldSize=12,
            ShieldSpillOverDamageMod=0,
            ShieldVerticalOffset=-3,
            TransportShield = true
        })
    end

    local function createMobileShield(armyName)
        local shieldGenerator = unitCreator.spawnSurvivalUnit({
            armyName = armyName,
            blueprintName = "xsl0307"
        })

        shieldGenerator.CreateWreckage = function() end
        shieldGenerator.MyShield:SetRechargeTime(30)
        shieldGenerator.MyShield.SpillOverDmgMod = 0
        shieldGenerator.MyShield:SetMaxHealth(OUTER_SHIELD_HP)
        shieldGenerator.MyShield:SetHealth(shieldGenerator.MyShield, OUTER_SHIELD_HP)

        return shieldGenerator
    end

    local function loadParagonIntoTransports(transports, armyName)
        local outerShield = createMobileShield(armyName)

        ScenarioFramework.AttachUnitsToTransports(
            {
                createParagon(armyName),
                outerShield
            },
            transports
        )

        outerShield:EnableShield()

        addSingleUseShieldToTransport(transports[1])
    end

    local function onParagonBuild(paragon)
        textPrinter.print("Paragon detected! Ready AA!", {color = "ffffd4d4", size = 24})

        local botArmyName = playerArmies.isTopSideArmy(paragon:GetArmy()) and "TOP_BOT" or "BOTTOM_BOT"

        local transports = {spawnTransport(botArmyName)}

        loadParagonIntoTransports(transports, botArmyName)

        IssueMove(transports, positions.mapCenter)
        IssueMove(transports, paragon:GetPosition())
        IssueKillSelf(transports)

        unitRevealer.revealUnit(transports[1], 18)
    end

    local function isPlayerParagon(unit)
        return EntityCategoryContains(categories.xab1401, unit) and playerArmies.getIndexToNameMap()[unit:GetArmy()]
    end

    local function setUp()
        unitCreation.addCallback(function(unit)
            if isPlayerParagon(unit) then
                onParagonBuild(unit)
            end
        end)
    end

    return {
        setUp = function()
            ForkThread(function()
                setUp()
            end)
        end
    }
end