local function newAutoReclaimer(playerArmies, balanceBonus)
	local previousMass = {}
	local previousEnergy = {}
	local armyMultipliers = {}

	local this = {}

	local function getArmyMultiplier(armyName)
		if balanceBonus == 0 then
			return 1
		end

		local bonusIsForTopTeam = balanceBonus > 0

		if bonusIsForTopTeam ~= playerArmies.isTopSideArmy(armyName) then
			return 1
		end

		return 1 + math.abs(balanceBonus) / 100
	end

	this.setup = function()
		for _, armyName in playerArmies.getIndexToNameMap() do
			previousMass[armyName] = 0
			previousEnergy[armyName] = 0
			armyMultipliers[armyName] = getArmyMultiplier(armyName)
		end
	end

	this.autoReclaim = function(massMultiplier, energyMultiplier)
		for armyIndex, armyName in playerArmies.getIndexToNameMap() do
			if ArmyIsOutOfGame(armyName) == false then
				local brain = ArmyBrains[armyIndex]

				local mass = brain:GetArmyStat("Enemies_MassValue_Destroyed",0.0).Value
				local energy = brain:GetArmyStat("Enemies_EnergyValue_Destroyed",0.0).Value

				brain:GiveResource('MASS', (mass - previousMass[armyName]) * massMultiplier * armyMultipliers[armyName])
				brain:GiveResource('ENERGY', (energy - previousEnergy[armyName]) * energyMultiplier)

				previousMass[armyName] = mass
				previousEnergy[armyName] = energy
			end
		end
	end

	return this
end

function AutoReclaimThread(options, playerArmies)
	local reclaimer = newAutoReclaimer(playerArmies, options.getRawOptions().opt_FinalRushTeamBonusReclaim)
	reclaimer.setup()

	local massMultiplier = options.getRawOptions().opt_AutoReclaim / 100
	local energyMultiplier = massMultiplier

	while true do
		WaitSeconds(0.1)
		reclaimer.autoReclaim(massMultiplier, energyMultiplier)
	end
end
