local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua');
local ScenarioFramework = import('/lua/ScenarioFramework.lua');
local Utilities = import('/lua/utilities.lua');
local Entity = import('/lua/sim/Entity.lua').Entity;
local GameCommon = import('/lua/ui/game/gamecommon.lua');

local AttackLocations = {
	Team1 = {
		Player1 = VECTOR3( 305.5, 25.9844, 451.5 ),
		Player2 = VECTOR3( 375.5, 25.9844, 435.5 ),
		Player3 = VECTOR3( 435.5, 25.9844, 375.5 ),
		Player4 = VECTOR3( 451.5, 25.9844, 305.5 )
	},
	Team2 = {
		Player1 = VECTOR3( 206.5, 25.9844, 60.5 ),
		Player2 = VECTOR3( 132.5, 25.9922, 71.5 ),
		Player3 = VECTOR3( 71.5, 25.9922, 132.5 ),
		Player4 = VECTOR3( 68.5, 25.9844, 214.5 )
	}
}

local TransportDestinations = {
	SouthernAttackerEnd = VECTOR3(500,80,10),
	NorthernAttackerEnd = VECTOR3(10,80,500)
}

local StartingPlayersExistance = {
	ARMY_1 = false,
	ARMY_2 = false,
	ARMY_3 = false,
	ARMY_4 = false,
	ARMY_5 = false,
	ARMY_6 = false,
	ARMY_7 = false,
	ARMY_8 = false
}

function FinalRushLog(m, o)
	if type(o) == "table" then
		for k, v in o do
			LOG("FinalRush: " .. m .. ": " .. k .. " = " .. tostring(v))
		end
	else
		LOG("FinalRush: " .. m .. ": " .. o)
	end
end

local buildRestrictor

function OnPopulate()
	ScenarioUtils.InitializeArmies()
	if (ScenarioInfo.Options.opt_gamemode == nil) then
		ScenarioInfo.Options.opt_gamemode = 2;
	end
	if (ScenarioInfo.Options.opt_tents == nil) then
		ScenarioInfo.Options.opt_tents = 9;
	end
	if (ScenarioInfo.Options.opt_AutoReclaim == nil) then
		ScenarioInfo.Options.opt_AutoReclaim = 50;
	end
	if (ScenarioInfo.Options.opt_FinalRushSpawnDelay == nil) then
		ScenarioInfo.Options.opt_FinalRushSpawnDelay = 0;
	end
	if (ScenarioInfo.Options.opt_FinalRushAggression == nil) then
		ScenarioInfo.Options.opt_FinalRushAggression = 1;
	end
	if (ScenarioInfo.Options.opt_FinalRushAir == nil) then
		ScenarioInfo.Options.opt_FinalRushAir = 0;
	end
	if (ScenarioInfo.Options.opt_timeunlocked == nil) then
		ScenarioInfo.Options.opt_timeunlocked = 0;
	end
	if (ScenarioInfo.Options.opt_t2tml == nil) then
		ScenarioInfo.Options.opt_t2tml = 0;
	end
	if (ScenarioInfo.Options.opt_t3arty == nil) then
		ScenarioInfo.Options.opt_t3arty = 0;
	end
	if (ScenarioInfo.Options.opt_snipers == nil) then
		ScenarioInfo.Options.opt_snipers = 0;
	end

	CreateStartingPlayersExistance()

	local textPrinter = import('/maps/Final Rush Pro 5/src/TextPrinter.lua').newInstance()

	local playerArmies = import('/maps/Final Rush Pro 5/src/PlayerArmies.lua').newInstance(ListArmies())
	buildRestrictor = import('/maps/Final Rush Pro 5/src/BuildRestrictor.lua').newInstance(playerArmies, ScenarioInfo)

	buildRestrictor.resetToStartingRestrictions()

	if ScenarioInfo.Options.opt_tents > 0 then
		local tents = import('/maps/Final Rush Pro 5/src/PrebuildTents.lua').newInstance(playerArmies);
		LOG("Spawning " .. ScenarioInfo.Options.opt_tents .. " tents")
		tents.spawn(ScenarioInfo.Options.opt_tents)
	end

	import('/maps/Final Rush Pro 5/src/CivilianLighthouses.lua').newInstance().spawn();

	if (ScenarioInfo.Options.opt_timeunlocked ~= 0) then
		local techRestrictor = import('/maps/Final Rush Pro 5/src/TechRestrictor.lua').newInstance(
			buildRestrictor,
			textPrinter,
			playerArmies,
			ScenarioInfo.Options.opt_timeunlocked
		);

		techRestrictor.startRestrictedTechCascade()
	end

	if ScenarioInfo.Options.opt_gamemode == 1 then
		local paragonWars = import('/maps/Final Rush Pro 5/src/ParagonWars.lua').newInstance(playerArmies)
		paragonWars.setUp()
	end

	if ScenarioInfo.Options.opt_gamemode > 1 then
		Survival()
		ForkThread(RunBattle, textPrinter, playerArmies)
	end

	if (ScenarioInfo.Options.opt_Teleport == 1) then
		ScenarioFramework.RestrictEnhancements({'Teleporter'})
	end

	if ScenarioInfo.Options.opt_AutoReclaim > 0 then
		ForkThread(import('/maps/Final Rush Pro 5/src/AutoReclaim.lua').AutoResourceThread)
	end
end

function OnStart(self)
end

--given a player returns a proper username
getUsername = function(army)
	return GetArmyBrain(army).Nickname;
end

allUnits = function()
	local xmapsize = ScenarioInfo.size[1]
	local ymapsize = ScenarioInfo.size[2]
	local mapRect = {x0 = 0, x1 = xmapsize, y0 = 0, y1 = ymapsize}
	return GetUnitsInRect(mapRect)
end

function disableWalls()
	for armyIndex, armyName in ListArmies() do
		AddBuildRestriction(armyIndex, categories.WALL)
	end
end

Survival = function()
	disableWalls()

	if ScenarioInfo.Options.opt_gamemode == 2 then  --versus survival
		local tblArmies = ListArmies()
		for index, name in tblArmies do
			if name == "ARMY_5" or name == "ARMY_6" or name == "ARMY_7" or name == "ARMY_8" then
				SetAlliance(index, "NEUTRAL_CIVILIAN", 'Enemy')
				SetAlliance(index, "ARMY_9", 'Ally')
			elseif name == "ARMY_1" or name == "ARMY_2" or name == "ARMY_3" or name == "ARMY_4" then
				SetAlliance(index, "ARMY_9", 'Enemy')
				SetAlliance(index, "NEUTRAL_CIVILIAN", 'Ally')
			end
		end

		SetAlliance("ARMY_9", "NEUTRAL_CIVILIAN", 'Ally')
	end

	local survivalStructures = import('/maps/Final Rush Pro 5/src/SurvivalStructures.lua').newInstance()

	if ScenarioInfo.Options.opt_gamemode > 2 then  --easy, normal, hard and insane survival
		local tblArmies = ListArmies()
		for index, name in tblArmies do
			SetAlliance(index, "NEUTRAL_CIVILIAN", 'Enemy')
			SetAlliance(index, "ARMY_9", 'Enemy')
		end
		SetAlliance("ARMY_9", "NEUTRAL_CIVILIAN", 'Ally')

		local commanderWaterPain = import('/maps/Final Rush Pro 5/src/CommanderWaterPain.lua').newInstance(allUnits)
		commanderWaterPain.runThread()

		survivalStructures.createHillGuards()
	end

	survivalStructures.createParagons()
	survivalStructures.createRadars()
end

function CreateStartingPlayersExistance()
	if not ScenarioInfo.ArmySetup["ARMY_1"] == false then
		StartingPlayersExistance.ARMY_1 = true
	end
	if not ScenarioInfo.ArmySetup["ARMY_2"] == false then
		StartingPlayersExistance.ARMY_2 = true
	end
	if not ScenarioInfo.ArmySetup["ARMY_3"] == false then
		StartingPlayersExistance.ARMY_3 = true
	end
	if not ScenarioInfo.ArmySetup["ARMY_4"] == false then
		StartingPlayersExistance.ARMY_4 = true
	end
	if not ScenarioInfo.ArmySetup["ARMY_5"] == false then
		StartingPlayersExistance.ARMY_5 = true
	end
	if not ScenarioInfo.ArmySetup["ARMY_6"] == false then
		StartingPlayersExistance.ARMY_6 = true
	end
	if not ScenarioInfo.ArmySetup["ARMY_7"] == false then
		StartingPlayersExistance.ARMY_7 = true
	end
	if not ScenarioInfo.ArmySetup["ARMY_8"] == false then
		StartingPlayersExistance.ARMY_8 = true
	end
end

local healthMultiplier

RunBattle = function(textPrinter, playerArmies)
	healthMultiplier = import('/maps/Final Rush Pro 5/src/HealthMultiplier.lua').newInstance(
		ScenarioInfo.Options.opt_gamemode,
		IsTotalVetEnabled()
	)

	local SpawnMulti = table.getn(playerArmies.getIndexToNameMap()) / 8

	local t1spawndelay = 0
	local t2spawndelay = 0
	local t3spawndelay = 0
	local t4spawndelay = 0
	local hunterdelay = 0

	local t1frequency = 0
	local t2frequency = 0
	local t3frequency = 0
	local t4frequency = 0
	local hunterfrequency = 0
	local RandomFrequency = 0

	if ScenarioInfo.Options.opt_gamemode < 4 then
		LOG("Survival Easy or Versus")
		t1spawndelay = 0
		t2spawndelay = 6  * 60
		t3spawndelay = 12 * 60
		t4spawndelay = 18 * 60
		hunterdelay  = 24 * 60
		t1frequency = 6
		t2frequency = 6
		t3frequency = 10
		t4frequency = 30
		hunterfrequency = 4 * 60
		RandomFrequency = 90
	elseif ScenarioInfo.Options.opt_gamemode == 4 then
		LOG("Survival Normal")
		t1spawndelay = 0
		t2spawndelay = 6  * 60
		t3spawndelay = 12 * 60
		t4spawndelay = 18 * 60
		hunterdelay  = 22 * 60
		t1frequency = 6
		t2frequency = 6
		t3frequency = 10
		t4frequency = 10
		hunterfrequency = 3 * 60
		RandomFrequency = 70
	elseif ScenarioInfo.Options.opt_gamemode == 5 then
		LOG("Survival Hard")
		t1spawndelay = 0
		t2spawndelay = 5  * 60
		t3spawndelay = 10 * 60
		t4spawndelay = 16 * 60
		hunterdelay  = 18 * 60
		t1frequency = 6
		t2frequency = 6
		t3frequency = 10
		t4frequency = 10
		hunterfrequency = 2 * 60
		RandomFrequency = 50
	elseif ScenarioInfo.Options.opt_gamemode == 6 then
		LOG("Survival Insane")
		t1spawndelay = 0
		t2spawndelay = 4 * 60
		t3spawndelay = 8 * 60
		t4spawndelay = 14 * 60
		hunterdelay  = 16 * 60
		t1frequency = 6
		t2frequency = 6
		t3frequency = 10
		t4frequency = 8
		hunterfrequency = 90
		RandomFrequency = 30
	end

	t1spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t1spawndelay
	t2spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t2spawndelay
	t3spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t3spawndelay
	t4spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t4spawndelay
	hunterdelay  = ScenarioInfo.Options.opt_FinalRushSpawnDelay + hunterdelay

	if ScenarioInfo.Options.opt_FinalRushAggression == 1 then
		local randomUnits = import('/maps/Final Rush Pro 5/src/RandomUnits.lua').newInstance(ScenarioInfo, ScenarioFramework)
		local agressionSpawner = import('/maps/Final Rush Pro 5/src/AggressionSpawner.lua').newInstance(
			StartingPlayersExistance,
			randomUnits,
			AttackLocations,
			TransportDestinations,
			ScenarioInfo,
			ScenarioFramework,
			GetRandomPlayer,
			Killgroup,
			RemoveWreckage,
			spawnOutEffect,
			healthMultiplier
		)

		agressionSpawner.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end

	ForkThread(SpawnerGroup1,t1spawndelay,t1frequency / SpawnMulti,t2spawndelay)
	ForkThread(SpawnerGroup2,t2spawndelay,t2frequency / SpawnMulti)
	ForkThread(SpawnerGroup3,t3spawndelay,t3frequency / SpawnMulti)
	ForkThread(SpawnerGroup4,t4spawndelay,t4frequency / SpawnMulti)

	local randomEvents = import('/maps/Final Rush Pro 5/src/RandomEvents.lua').newInstance(
		ScenarioInfo,
		textPrinter,
		healthMultiplier,
		RemoveWreckage,
		StartingPlayersExistance,
		AttackLocations,
		allUnits,
		GetRandomPlayer,
		Killgroup,
		ListArmies,
		spawnOutEffect
	)

	randomEvents.start(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)

	local hunters = import('/maps/Final Rush Pro 5/src/Hunters.lua').newInstance(
		textPrinter,
		healthMultiplier,
		IsBLackOpsAcusEnabled(),
		spawnOutEffect
	)

	ForkThread(hunters.hunterSpanwer, hunterdelay, hunterfrequency / SpawnMulti)
end

SpawnerGroup1 = function(delay,frequency,spawnend)
	WaitSeconds(delay)
	while GetGameTimeSeconds() < spawnend do
		ForkThread(Round1,delay)
		WaitSeconds(frequency)
	end
end

SpawnerGroup2 = function(delay,frequency)
	WaitSeconds(delay)
	PrintText("Tech 2 inbound", 20, "ffffffff", 5, 'center')
	while true do
		ForkThread(Round2,delay)
		WaitSeconds(frequency)
	end
end

SpawnerGroup3 = function(delay,frequency)
	WaitSeconds(delay)
	PrintText("Tech 3 inbound", 20, "ffffffff", 5, 'center')
	while true do
		ForkThread(Round3,delay)
		WaitSeconds(frequency)
	end
end

SpawnerGroup4 = function(delay,frequency)
	WaitSeconds(delay)
	PrintText("Experimentals inbound", 20, "ffffffff", 5, 'center')
	while true do
		ForkThread(Round4,delay)
		WaitSeconds(frequency)
	end
end

GetRandomPlayer = function(team)
	local selectplayertoattack = Random(1,4)
	local Units_FinalFight
	local try = 0

	if team == 1 then
		if selectplayertoattack == 1 then
			Units_FinalFight = AttackLocations.Team1.Player1
		elseif selectplayertoattack == 2 then
			Units_FinalFight = AttackLocations.Team1.Player2
		elseif selectplayertoattack == 3 then
			Units_FinalFight = AttackLocations.Team1.Player3
		elseif selectplayertoattack == 4 then
			Units_FinalFight = AttackLocations.Team1.Player4
		end
	elseif team == 2 then
		if selectplayertoattack == 1 then
			Units_FinalFight = AttackLocations.Team2.Player1
		elseif selectplayertoattack == 2 then
			Units_FinalFight = AttackLocations.Team2.Player2
		elseif selectplayertoattack == 3 then
			Units_FinalFight = AttackLocations.Team2.Player3
		elseif selectplayertoattack == 4 then
			Units_FinalFight = AttackLocations.Team2.Player4
		end
	end
	return Units_FinalFight
end



GetNearestCommander = function(unitgroup,range)
	local comdistable = {}
	local unitattackerpos
	local unit_pos
	local dist
	local CommandersInRange
	local commandertoattack = false

	for index,unitattacker in unitgroup do
		if not unitattacker:IsDead() then
			unitattackerpos = unitattacker:GetPosition()
			local brain = unitattacker:GetAIBrain()
			CommandersInRange = brain:GetUnitsAroundPoint( categories.COMMAND, unitattackerpos, range, 'Enemy' )
		end
	end
	if CommandersInRange then
		for num, unit in CommandersInRange do
			unit_pos = unit:GetPosition()
			dist = VDist2(unitattackerpos.x,unitattackerpos.z,unit_pos.x,unit_pos.z)
			commandertoattack = unit
		end
	end
	return commandertoattack
end

Round1 = function(hpincreasedelay)
	local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))
	local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
	local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

	local transport_AMY9 = CreateUnitHPR("ura0107", "ARMY_9", 500, 80, 10, 0,0,0) -- 6 max

	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_AMY9:SetCanTakeDamage(false);
	end

	local unit1_ARMY9 = CreateUnitHPR("url0103", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Mobile Light Artillery: Medusa
	local unit2_ARMY9 = CreateUnitHPR("uel0103", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Mobile Light Artillery: Lobo
	local unit3_ARMY9 = CreateUnitHPR("xsl0201", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Seraphim T1 Medium Tank: Thaam
	local unit4_ARMY9 = CreateUnitHPR("url0107", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Assault Bot: Mantis
	local unit5_ARMY9 = CreateUnitHPR("uel0201", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Medium Tank: MA12 Striker
	local unit6_ARMY9 = CreateUnitHPR("ual0201", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Aeon T1 Light Tank: Aurora
	local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9,unit3_ARMY9,unit4_ARMY9,unit5_ARMY9,unit6_ARMY9}

	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
	end


	local transports_ARMY9 = {transport_AMY9}

	local transport_Civilian = CreateUnitHPR("uea0107", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0)
	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_Civilian:SetCanTakeDamage(false);
	end
	local unit1_Civilian = CreateUnitHPR("url0103", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Mobile Light Artillery: Medusa
	local unit2_Civilian = CreateUnitHPR("uel0103", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Mobile Light Artillery: Lobo
	local unit3_Civilian = CreateUnitHPR("xsl0201", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Seraphim T1 Medium Tank: Thaam
	local unit4_Civilian = CreateUnitHPR("url0107", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Cybran T1 Assault Bot: Mantis
	local unit5_Civilian = CreateUnitHPR("uel0201", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --UEF T1 Medium Tank: MA12 Striker
	local unit6_Civilian = CreateUnitHPR("ual0201", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Aeon T1 Light Tank: Aurora
	local transports_Civilian = {transport_Civilian}
	local units_Civilian = {unit1_Civilian,unit2_Civilian,unit3_Civilian,unit4_Civilian,unit5_Civilian,unit6_Civilian}

	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
	end

	RemoveWreckage(units_ARMY9)
	RemoveWreckage(units_Civilian)

	ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)
	ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

	IssueTransportUnload(transports_ARMY9, TransportTo)
	IssueTransportUnload(transports_Civilian, TransportTo)

	ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
	ForkThread(ArmyAttackTarget,"civ",units_Civilian)

	IssueMove(transports_ARMY9,TransportEnd_ARMY9)
	IssueMove(transports_Civilian,TransportEnd_Civilian)

	WaitSeconds(50)

	for index, transport in transports_ARMY9 do
		spawnOutEffect(transport)
	end

	for index, transport in transports_Civilian do
		spawnOutEffect(transport)
	end
end

Round2 = function(hpincreasedelay)
	local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

	local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
	local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

	local transport_AMY9a
	local transport_AMY9b
	local transport_Civiliana
	local transport_Civilianb

	local transport_AMY9 = CreateUnitHPR("xea0306", "ARMY_9", 500, 80, 10, 0,0,0) --uef t3

	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_AMY9:SetCanTakeDamage(false);
	end

	local unit1_ARMY9 = CreateUnitHPR("url0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T2 Heavy Tank: Rhino
	local unit2_ARMY9 = CreateUnitHPR("ual0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T2 Heavy Tank: Obsidian
	local unit3_ARMY9 = CreateUnitHPR("uel0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Heavy Tank: Pillar
	local unit4_ARMY9 = CreateUnitHPR("del0204", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Gatling Bot: Mongoose
	local unit5_ARMY9 = CreateUnitHPR("url0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --missile  Edit! Changed to: Cybran T2 Heavy Tank: Rhino
	local unit6_ARMY9 = CreateUnitHPR("del0204", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --
	local unit7_ARMY9 = CreateUnitHPR("xsl0203", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  -- Edit! Changed to: Sera t2 HoverTank
	local unit8_ARMY9 = CreateUnitHPR("url0203", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --wagner
	local unit9_ARMY9 = CreateUnitHPR("xsl0202", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Seraphim T2 Assault Bot: Ilshavoh
	local unit10_ARMY9 = CreateUnitHPR("xal0203", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T2 Assault Tank: Blaze

	local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9,unit3_ARMY9,unit4_ARMY9,unit5_ARMY9,unit6_ARMY9,unit7_ARMY9,unit8_ARMY9,unit9_ARMY9,unit10_ARMY9}
	ForkThread(Killgroup,units_ARMY9)
	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
	end
	local transports_ARMY9 = {transport_AMY9}
	ForkThread(Killgroup,transports_ARMY9)
	ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)

	local transport_Civilian = CreateUnitHPR("xea0306", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0) --uef t3



	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_Civilian:SetCanTakeDamage(false);
	end

	local unit1_Civilian = CreateUnitHPR("url0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T2 Heavy Tank: Rhino
	local unit2_Civilian = CreateUnitHPR("ual0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T2 Heavy Tank: Obsidian
	local unit3_Civilian = CreateUnitHPR("uel0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Heavy Tank: Pillar
	local unit4_Civilian = CreateUnitHPR("del0204", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Gatling Bot: Mongoose
	local unit5_Civilian = CreateUnitHPR("uel0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --UEF T2 Mobile Missile Launcher: Flapjack Edit! Changed to: UEF T2 Heavy Tank: Pillar
	local unit6_Civilian = CreateUnitHPR("uel0307", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --shield Edit: Changed to Uef t2 Shield
	local unit7_Civilian = CreateUnitHPR("xsl0203", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --stealth Edit! Changed to: Sera t2 HoverTank
	local unit8_Civilian = CreateUnitHPR("url0306", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --wagner
	local unit9_Civilian = CreateUnitHPR("xsl0202", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)  --Seraphim T2 Assault Bot: Ilshavoh
	local unit10_Civilian = CreateUnitHPR("xal0203", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0) --Aeon T2 Assault Tank: Blaze
	local transports_Civilian = {transport_Civilian}
	ForkThread(Killgroup,transports_Civilian)
	local units_Civilian = {unit1_Civilian,unit2_Civilian,unit3_Civilian,unit4_Civilian,unit5_Civilian,unit6_Civilian,unit7_Civilian,unit8_Civilian,unit9_Civilian,unit10_Civilian}
	ForkThread(Killgroup,units_Civilian)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
	end

	RemoveWreckage(units_ARMY9)
	RemoveWreckage(units_Civilian)

	ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

	IssueTransportUnload(transports_ARMY9, TransportTo)
	IssueTransportUnload(transports_Civilian, TransportTo)

	ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
	ForkThread(ArmyAttackTarget,"civ",units_Civilian)

	IssueMove(transports_ARMY9,TransportEnd_ARMY9)
	IssueMove(transports_Civilian,TransportEnd_Civilian)

	WaitSeconds(50)

	for index, transport in transports_ARMY9 do
		spawnOutEffect(transport)
	end

	for index, transport in transports_Civilian do
		spawnOutEffect(transport)
	end
end

Round3 = function(hpincreasedelay)
	local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

	local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
	local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

	local transport_AMY9 = CreateUnitHPR("xea0306", "ARMY_9", 500, 80, 10, 0,0,0)
	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_AMY9:SetCanTakeDamage(false);
	end

	local unit1_ARMY9 = CreateUnitHPR("url0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Siege Assault Bot: Loyalist
	local unit2_ARMY9 = CreateUnitHPR("xel0305", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Armored Assault Bot: Percival
	local unit3_ARMY9 = CreateUnitHPR("uel0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit4_ARMY9 = CreateUnitHPR("ual0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit5_ARMY9 = CreateUnitHPR("xrl0305", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Armored Assault Bot: The Brick
	local unit6_ARMY9 = CreateUnitHPR("uel0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Heavy Assault Bot: Titan
	local unit7_ARMY9 = CreateUnitHPR("ual0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T3 Heavy Assault Bot: Harbinger Mark IV
	local unit8_ARMY9 = CreateUnitHPR("dal0310", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Aeon T3 Shield Disruptor: Absolver
	local unit9_ARMY9 = CreateUnitHPR("xsl0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0)  --Seraphim T3 Siege Tank: Othuum
	local unit10_ARMY9 = CreateUnitHPR("xsl0303", "ARMY_9", 255.5, 25.9844, 255.5,0,0,0) --Seraphim T3 Mobile Shield Generator: Athanah

	local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9,unit3_ARMY9,unit4_ARMY9,unit5_ARMY9,unit6_ARMY9,unit7_ARMY9,unit8_ARMY9,unit9_ARMY9,unit10_ARMY9}
	ForkThread(Killgroup,units_ARMY9)
	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
	end

	local transports_ARMY9 = {transport_AMY9}
	ForkThread(Killgroup,transports_ARMY9)
	ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)

	local transport_Civilian = CreateUnitHPR("xea0306", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0) --uef t3 air
	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_Civilian:SetCanTakeDamage(false);
	end

	local unit1_Civilian = CreateUnitHPR("url0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit2_Civilian = CreateUnitHPR("xel0305", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit3_Civilian = CreateUnitHPR("uel0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit4_Civilian = CreateUnitHPR("ual0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit5_Civilian = CreateUnitHPR("xrl0305", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit6_Civilian = CreateUnitHPR("uel0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit7_Civilian = CreateUnitHPR("ual0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit8_Civilian = CreateUnitHPR("dal0310", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit9_Civilian = CreateUnitHPR("xsl0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)
	local unit10_Civilian = CreateUnitHPR("xsl0303", "NEUTRAL_CIVILIAN", 255.5, 25.9844, 255.5,0,0,0)

	local transports_Civilian = {transport_Civilian}
	ForkThread(Killgroup,transports_Civilian)
	local units_Civilian = {unit1_Civilian,unit2_Civilian,unit3_Civilian,unit4_Civilian,unit5_Civilian,unit6_Civilian,unit7_Civilian,unit8_Civilian,unit9_Civilian,unit10_Civilian}
	ForkThread(Killgroup,units_Civilian)
	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
	end

	RemoveWreckage(units_ARMY9)
	RemoveWreckage(units_Civilian)

	ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

	IssueTransportUnload(transports_ARMY9, TransportTo)
	IssueTransportUnload(transports_Civilian, TransportTo)

	ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
	ForkThread(ArmyAttackTarget,"civ",units_Civilian)

	IssueMove(transports_ARMY9,TransportEnd_ARMY9)
	IssueMove(transports_Civilian,TransportEnd_Civilian)

	WaitSeconds(50)

	for index, transport in transports_ARMY9 do
		spawnOutEffect(transport)
	end

	for index, transport in transports_Civilian do
		spawnOutEffect(transport)
	end

end

Round4 = function(hpincreasedelay)
	local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

	local TransportEnd_ARMY9 = TransportDestinations.SouthernAttackerEnd
	local TransportEnd_Civilian = TransportDestinations.NorthernAttackerEnd

	local transport_AMY9 = CreateUnitHPR("xea0306", "ARMY_9", 500, 80, 10, 0,0,0)
	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_AMY9:SetCanTakeDamage(false);
	end

	local unit1_ARMY9 = CreateUnitHPR("url0402", "ARMY_9", 500,20,10,0,0,0)
	local unit2_ARMY9 = CreateUnitHPR("ual0401", "ARMY_9", 500,20,10,0,0,0)
	local units_ARMY9 = {unit1_ARMY9,unit2_ARMY9}
	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_ARMY9,hpincreasedelay)
	end

	local transports_ARMY9 = {transport_AMY9}
	ScenarioFramework.AttachUnitsToTransports(units_ARMY9, transports_ARMY9)

	local transport_Civilian = CreateUnitHPR("xea0306", "NEUTRAL_CIVILIAN", 10, 80, 500, 0,0,0)
	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport_Civilian:SetCanTakeDamage(false);
	end

	local unit1_Civilian = CreateUnitHPR("url0402", "NEUTRAL_CIVILIAN", 20,20,20,0,0,0)
	local unit2_Civilian = CreateUnitHPR("ual0401", "NEUTRAL_CIVILIAN", 20,20,20,0,0,0)
	local transports_Civilian = {transport_Civilian}
	local units_Civilian = {unit1_Civilian,unit2_Civilian}
	if ScenarioInfo.Options.opt_gamemode > 3 then
		healthMultiplier.increaseHealth(units_Civilian,hpincreasedelay)
	end

	RemoveWreckage(units_ARMY9)
	RemoveWreckage(units_Civilian)

	ForkThread(Killgroup,transports_Civilian)
	ForkThread(Killgroup,transports_ARMY9)

	ScenarioFramework.AttachUnitsToTransports(units_Civilian, transports_Civilian)

	IssueTransportUnload(transports_ARMY9, TransportTo)
	IssueTransportUnload(transports_Civilian, TransportTo)

	ForkThread(ArmyAttackTarget,"army9",units_ARMY9)
	ForkThread(ArmyAttackTarget,"civ",units_Civilian)

	IssueMove(transports_ARMY9,TransportEnd_ARMY9)
	IssueMove(transports_Civilian,TransportEnd_Civilian)

	WaitSeconds(50)

	for index, transport in transports_ARMY9 do
		spawnOutEffect(transport)
	end

	for index, transport in transports_Civilian do
		spawnOutEffect(transport)
	end

end

ArmyAttackTarget = function(attackarmy,unitgroup)
	if attackarmy == "army9" then
		IssueAggressiveMove(unitgroup, GetRandomPlayer(1))
		IssueAggressiveMove(unitgroup, GetRandomPlayer(1))
	elseif attackarmy == "civ" then
		IssueAggressiveMove(unitgroup, GetRandomPlayer(2))
		IssueAggressiveMove(unitgroup, GetRandomPlayer(2))
	end

	WaitSeconds(90)
	local range = 50
	while GetNearestCommander(unitgroup, range) == false and range < 400 do
		range = range + 50
		WaitSeconds(1)
	end

	local nearestCommander = GetNearestCommander(unitgroup, range)

	if nearestCommander ~= false then
		IssueAttack(unitgroup, nearestCommander)
	end

	ForkThread(Killgroup, unitgroup)
end

Killgroup = function(unitgroup)
	WaitSeconds(60*5)
	for key, value in unitgroup do
		if not value:IsDead() then
			spawnOutEffect(value)
		end
	end
end

spawnEffect = function(unit)
	unit:PlayUnitSound('TeleportStart')
	unit:PlayUnitAmbientSound('TeleportLoop')
	WaitSeconds( 0.1 )
	unit:PlayTeleportInEffects()
	WaitSeconds( 0.1 )
	unit:StopUnitAmbientSound('TeleportLoop')
	unit:PlayUnitSound('TeleportEnd')
end

spawnOutEffect = function(unit)
	unit:PlayUnitSound('TeleportStart')
	unit:PlayUnitAmbientSound('TeleportLoop')
	WaitSeconds( 0.1 )
	unit:PlayTeleportInEffects()
	WaitSeconds( 0.1 )
	unit:StopUnitAmbientSound('TeleportLoop')
	unit:PlayUnitSound('TeleportEnd')
	unit:Destroy()
end

function IsTotalVetEnabled()
	local ai = GetArmyBrain("ARMY_9")
	for k,unit  in ai:GetListOfUnits( categories.STRUCTURE, false ) do
		if unit:GetBlueprint().Economy.xpValue == nil then
			LOG('TVG Disabled')
			return false
		else
			LOG('TVG Enabled')
			return true
		end
	end
end

function IsBLackOpsAcusEnabled()
	local bobp = GetUnitBlueprintByName("eal0001")
	if bobp.Economy.BuildTime  == nil then
		LOG('Blackops Disabled')
		return false
	else
		LOG('Blackops Enabled')
		return true
	end
end

function RemoveWreckage(unitgroup)
	local bp
	if (ScenarioInfo.Options.opt_AutoReclaim > 0) then
		for key, unit in unitgroup do
			bp = unit:GetBlueprint()
			bp.Wreckage = nil
		end
	end
end
