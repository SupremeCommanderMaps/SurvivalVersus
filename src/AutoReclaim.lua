function AutoResourceThread()
	local massMultiplier = ScenarioInfo.Options.opt_AutoReclaim / 100
	local energyMultiplier = ScenarioInfo.Options.opt_AutoReclaim / 100

	local previousMass = {}
	local previousEnergy = {}

	while true do
		WaitSeconds(0.1)
		for army, brain in ArmyBrains do
			if ArmyIsOutOfGame(army) == false then
				local mass = brain:GetArmyStat("Enemies_MassValue_Destroyed",0.0).Value
				local energy = brain:GetArmyStat("Enemies_EnergyValue_Destroyed",0.0).Value

				if previousMass[army] > 0 then
					brain:GiveResource('MASS', (mass - previousMass[army]) * massMultiplier)
					brain:GiveResource('ENERGY', (energy - previousEnergy[army]) * energyMultiplier)
				end

				previousMass[army] = mass
				previousEnergy[army] = energy
			end
		end
	end
end
