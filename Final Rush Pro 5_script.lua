local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua');
local ScenarioFramework = import('/lua/ScenarioFramework.lua');
local Utilities = import('/lua/utilities.lua');
local Entity = import('/lua/sim/Entity.lua').Entity;
local GameCommon = import('/lua/ui/game/gamecommon.lua');
local Aggression = import('/maps/Final Rush Pro 5/lua/Aggression.lua');
local PrebuildTents = import('/maps/Final Rush Pro 5/lua/PrebuildTents.lua');
-- Global Mod Check
local tvEn =  false	--Total Veterancy
local acuEn	= false --Blackops Adv Command Units.

local bp = GetUnitBlueprintByName("urc1901")

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

local Team1Count
local Team2Count

local Aggro = {
	Team1 = {
		Player1 = 0,
		Player2 = 0,
		Player3 = 0,
		Player4 = 0
	},
	Team2 = {
		Player1 = 0,
		Player2 = 0,
		Player3 = 0,
		Player4 = 0
	}
}

local TableUnitID = {
	Tech1 = { "ual0201", "ual0103", "url0107", "url0103", "uel0201", "uel0103", "xsl0201", "xsl0103" },
	Tech2 = { "xal0203", "ual0202", "ual0111", "url0203", "url0202", "url0111", "drl0204", "uel0203", "del0204", "uel0202", "uel0111", "uel0303", "xsl0202", "xsl0203"},
	Tech2NoTml = { "xal0203", "ual0202", "ual0103", "url0203", "url0202", "xsl0203", "drl0204", "uel0203", "del0204", "uel0202", "uel0307", "uel0303", "xsl0202", "xsl0203", "uel0203"},
	Tech3 = { "ual0303", "xal0305", "xrl0305", "url0303", "xel0305", "xsl0303", "xsl0305"},
	Tech3NoSniper = { "ual0303", "xrl0305", "url0303", "xel0305", "xsl0303", "uel0303", "url0303", "xsl0202"},
	Aggro = { "ual0304", "url0304", "uel0304", "xsl0304", "dal0310" },
	AggroNoArty = { "ual0303", "xrl0305", "url0303", "xel0305", "dal0310" }
}

bp.Intel.VisionRadius = 290
bp.Economy.BuildTime = 800

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
	GetTeamSize()
	ResetStartingRestrictions()
	transportscoutonly()
	PrebuildTents.spawn(ScenarioInfo.Options.opt_tents, StartingPlayersExistance)
	spawnlighthouse()
	unlockovertime()
	createmiddleciv()
	Survival()
	applyPlayerAirRestriction()
	TeleportCheck()
	ForkThread(Info)

	if ScenarioInfo.Options.opt_AutoReclaim > 0 then
		ForkThread(import('/maps/Final Rush Pro 5/lua/AutoReclaim.lua').AutoResourceThread)
	end
	if ScenarioInfo.Options.opt_gamemode > 1 then
		ForkThread(import('/maps/Final Rush Pro 5/lua/SyncData.lua').CollectDataSync)
	end

	if ScenarioInfo.Options.opt_FinalRushAggression == 1 then
		-- This looks like it is not needed; no side effects in file appart from local declarations
		ForkThread(import('/maps/Final Rush Pro 5/lua/Aggression.lua').Aggression)
	end
end

function OnStart(self)
end

--spawns the civilian lighthouse
spawnlighthouse = function()
	local light1 = CreateUnitHPR( "urc1901", "NEUTRAL_CIVILIAN", 13.816323, 25.730654, 500.078125, 0,0,0)
	local light2 = CreateUnitHPR( "urc1901", "ARMY_9", 498.060150, 25.724628, 12.122614, 0,0,0)
	light1:SetReclaimable(false);
	light1:SetCanTakeDamage(false);
	light1:SetDoNotTarget(true);
	light1:SetCanBeKilled(false);
	light2:SetReclaimable(false);
	light2:SetCanTakeDamage(false);
	light2:SetDoNotTarget(true);
	light2:SetCanBeKilled(false);

	light2:SetCustomName("Vision Center")
	light1:SetCustomName("Vision Center")

	light1.OldOnCaptured = light1.OnCaptured;
	light1.OnCaptured = function(self, captor)
		local newunit = ChangeUnitArmy(self,captor:GetArmy())
		newunit:SetReclaimable(false);
		newunit:SetCanTakeDamage(false);
		newunit:SetDoNotTarget(true);
	end

	light2.OldOnCaptured = light2.OnCaptured;
	light2.OnCaptured = function(self, captor)
		local newunit = ChangeUnitArmy(self,captor:GetArmy())
		newunit:SetReclaimable(false);
		newunit:SetCanTakeDamage(false);
		newunit:SetDoNotTarget(true);
	end

end

--given a player returns a proper username
getUsername = function(army)
	return GetArmyBrain(army).Nickname;
end

transportscoutonly = function()
	if (ScenarioInfo.Options.opt_FinalRushAir == 1) then
		local tblArmies = ListArmies()
		for index, name in tblArmies do
			RemoveBuildRestriction(index, categories.AIR)
			AddBuildRestriction(index, categories.uea0103) --UEF T1 Attack Bomber: Scorcher
			AddBuildRestriction(index, categories.uea0102) --UEF T1 Interceptor: Cyclone
			AddBuildRestriction(index, categories.dea0202) --UEF T2 Fighter/Bomber: Janus
			AddBuildRestriction(index, categories.uea0203) --UEF T2 Gunship: Stinger
			AddBuildRestriction(index, categories.uea0204) --UEF T2 Torpedo Bomber: Stork
			AddBuildRestriction(index, categories.uea0304) --UEF T3 Strategic Bomber: Ambassador
			AddBuildRestriction(index, categories.uea0305) --UEF T3 Heavy Gunship: Broadsword
			AddBuildRestriction(index, categories.uea0303) --UEF T3 Air-Superiority Fighter: Wasp

			AddBuildRestriction(index, categories.xsa0103) --Seraphim T1 Attack Bomber: Sinnve
			AddBuildRestriction(index, categories.xsa0102) --Seraphim T1 Interceptor: Ia-atha
			AddBuildRestriction(index, categories.xsa0202) --Seraphim T2 Fighter/Bomber: Notha
			AddBuildRestriction(index, categories.xsa0203) --Seraphim T2 Gunship: Vulthoo
			AddBuildRestriction(index, categories.xsa0204) --Seraphim T2 Torpedo Bomber: Uosioz
			AddBuildRestriction(index, categories.xsa0303) --Seraphim T3 Air-Superiority Fighter: Iazyne
			AddBuildRestriction(index, categories.xsa0304) --Seraphim T3 Strategic Bomber: Sinntha
			AddBuildRestriction(index, categories.xsa0402) --Seraphim EX Experimental Bomber: Ahwassa

			AddBuildRestriction(index, categories.ura0103) --Cybran T1 Attack Bomber: Zeus
			AddBuildRestriction(index, categories.ura0102) --Cybran T1 Interceptor: Prowler
			AddBuildRestriction(index, categories.xra0105) --Cybran T1 Light Gunship: Jester
			AddBuildRestriction(index, categories.dra0202) --Cybran T2 Fighter/Bomber: Corsair
			AddBuildRestriction(index, categories.ura0203) --Cybran T2 Gunship: Renegade
			AddBuildRestriction(index, categories.ura0204) --Cybran T2 Torpedo Bomber: Cormorant
			AddBuildRestriction(index, categories.ura0303) --Cybran T3 Air Superiority Fighter: Gemini
			AddBuildRestriction(index, categories.xra0305) --Cybran T3 Heavy Gunship: Wailer
			AddBuildRestriction(index, categories.ura0304) --Cybran T3 Strategic Bomber: Revenant
			AddBuildRestriction(index, categories.ura0401) --Cybran EX Experimental Gunship: Soul Ripper

			AddBuildRestriction(index, categories.uaa0103) --Aeon T1 Attack Bomber: Shimmer
			AddBuildRestriction(index, categories.uaa0102) --Aeon T1 Interceptor: Conservator
			AddBuildRestriction(index, categories.xaa0202) --Aeon T2 Combat Fighter: Swift Wind
			AddBuildRestriction(index, categories.daa0206) --Aeon T2 Guided Missile: Mercy
			AddBuildRestriction(index, categories.uaa0203) --Aeon T2 Gunship: Specter
			AddBuildRestriction(index, categories.uaa0204) --Aeon T2 Torpedo Bomber: Skimmer
			AddBuildRestriction(index, categories.xaa0305) --Aeon T3 AA Gunship: Restorer
			AddBuildRestriction(index, categories.uaa0303) --Aeon T3 Air-Superiority Fighter: Corona
			AddBuildRestriction(index, categories.uaa0304) --Aeon T3 Strategic Bomber: Shocker
			AddBuildRestriction(index, categories.xaa0306) --Aeon T3 Torpedo Bomber: Solace
			AddBuildRestriction(index, categories.uaa0310) --Aeon EX Experimental Aircraft Carrier: CZAR
		end
	end
end

unlockovertime = function()
	if (ScenarioInfo.Options.opt_timeunlocked == 0) then
	else
		local tblArmies = ListArmies()
		for index, name in tblArmies do
			AddBuildRestriction(index, categories.TECH3)
			AddBuildRestriction(index, categories.TECH2)
			AddBuildRestriction(index, categories.EXPERIMENTAL)
		end

		ForkThread(enableT2)
		ForkThread(enableT3)
		ForkThread(enableEXP)
	end
end

enableT2 = function()
	LOG("Waiting for T2 - ", ScenarioInfo.Options.opt_timeunlocked)
	WaitSeconds(ScenarioInfo.Options.opt_timeunlocked)
	local tblArmies = ListArmies()
	for index, name in tblArmies do
		RemoveBuildRestriction(index, categories.TECH2)
	end
	transportscoutonly()
	ResetStartingRestrictions()
	PrintText("Tech 2 Enabled", 20, "ffffffff", 5, 'center');
end

enableT3 = function()
	LOG("Waiting for t3 - ", ScenarioInfo.Options.opt_timeunlocked * 2)
	WaitSeconds(ScenarioInfo.Options.opt_timeunlocked * 2)
	local tblArmies = ListArmies()
	for index, name in tblArmies do
		RemoveBuildRestriction(index, categories.TECH3)
	end
	transportscoutonly()
	ResetStartingRestrictions()
	PrintText("Tech 3 Enabled", 20, "ffffffff", 5, 'center');
end

enableEXP = function()
	LOG("Waiting for t4 - ", ScenarioInfo.Options.opt_timeunlocked * 3)
	WaitSeconds(ScenarioInfo.Options.opt_timeunlocked * 3)
	local tblArmies = ListArmies()
	for index, name in tblArmies do
		RemoveBuildRestriction(index, categories.EXPERIMENTAL)
	end
	transportscoutonly()
	ResetStartingRestrictions()
	PrintText("Experimentals Enabled", 20, "ffffffff", 5, 'center');
end

createmiddleciv = function()
	if (ScenarioInfo.Options.opt_gamemode == 1) then
		local T2DefenceCount = 0
		local T1DefenceCount = 0
		local T3DefenceAACount = 0
		local T3DefenceShieldCount = 0
		local T3PowerCount = 0

		--uab1301 AEON T3 POWER
		--uab2301 AEON T2 PD
		--uab2101 AEON T1 PD
		--uab4301 AEON T3 shield
		--uac1901 paragon activator
		--ueb2304 aeon t3 aa
		--uab3104 aeon t3 radar

		while T2DefenceCount < Random(8,16) do
			CreateUnitHPR("uab2301", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T2 PD
			T2DefenceCount = T2DefenceCount + 1
		end
		while T1DefenceCount < Random(8,16) do
			CreateUnitHPR("uab2101", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T1 PD
			T1DefenceCount = T1DefenceCount + 1
		end
		while T3DefenceAACount < Random(8,16) do
			CreateUnitHPR("ueb2304", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T3 Anti Air
			T3DefenceAACount = T3DefenceAACount + 1
		end
		while T3DefenceShieldCount < Random(2,4) do
			CreateUnitHPR("uab4301", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --T3 Shield
			T3DefenceShieldCount = T3DefenceShieldCount + 1
		end
		while T3PowerCount < Random(2,4) do
			CreateUnitHPR("uab1301", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0)  --T3 Power
			T3PowerCount = T3PowerCount + 1
		end
		CreateUnitHPR("uab3104", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0) --Radar

		local paraactivator = CreateUnitHPR("uac1901", "NEUTRAL_CIVILIAN", Random(245,265), 25.984375, Random(245,265), 0,0,0) --Paragon Activator
		paraactivator:SetReclaimable(false);
		paraactivator:SetCanTakeDamage(false);

		paraactivator.OldOnCaptured = paraactivator.OnCaptured;

		paraactivator.OnCaptured = function(self, captor)
			local newunit = ChangeUnitArmy(self,captor:GetArmy())
			ForkThread(createparagon,captor:GetArmy())
		end
		if(StartingPlayersExistance.ARMY_1 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_1","Enemy")
		end
		if(StartingPlayersExistance.ARMY_2 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_2","Enemy")
		end
		if(StartingPlayersExistance.ARMY_3 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_3","Enemy")
		end
		if(StartingPlayersExistance.ARMY_4 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_4","Enemy")
		end
		if(StartingPlayersExistance.ARMY_5 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_5","Enemy")
		end
		if(StartingPlayersExistance.ARMY_6 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_6","Enemy")
		end
		if(StartingPlayersExistance.ARMY_7 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_7","Enemy")
		end
		if(StartingPlayersExistance.ARMY_8 == true) then
			SetAlliance("NEUTRAL_CIVILIAN","ARMY_8","Enemy")
		end
	end
end

createparagon = function(paragonarmy)
	if paragonarmy == 1 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_1", Random(312,492), 25.984375, Random(312,492), 0,0,0)   --army 1-4
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_1")
	elseif paragonarmy == 2 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_2", Random(312,492), 25.984375, Random(312,492), 0,0,0)   --army 1-4
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_2")
	elseif paragonarmy == 3 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_3", Random(312,492), 25.984375, Random(312,492), 0,0,0)   --army 1-4
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_3")
	elseif paragonarmy == 4 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_4", Random(312,492), 25.984375, Random(312,492), 0,0,0)   --army 1-4
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_4")
	elseif paragonarmy == 5 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_5", Random(20,200), 25.984375, Random(20,200), 0,0,0)   --arny 5-8
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_5")
	elseif paragonarmy == 6 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_6", Random(20,200), 25.984375, Random(20,200), 0,0,0)   --arny 5-8
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_6")
	elseif paragonarmy == 7 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_7", Random(20,200), 25.984375, Random(20,200), 0,0,0)   --arny 5-8
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_7")
	elseif paragonarmy == 8 then
		local thetemppara = CreateUnitHPR("xab1401", "ARMY_8", Random(20,200), 25.984375, Random(20,200), 0,0,0)   --arny 5-8
		thetemppara:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		thetemppara.OnCaptured = function(self, captor)
		end
		ForkThread(paragontimer,thetemppara,"ARMY_8")
	else
		LOG("WTF")
	end
end

paragontimer = function(paraunit,paraowner)
	local paraname = getUsername(paraowner)
	PrintText(paraname .. " has a Paragon for 60 Seconds", 20, "ffffffff", 5, 'center');

	WaitSeconds(60)
	paraunit:Destroy()
	PrintText("Paragon Removed", 20, "ffffffff", 5, 'center');

	ForkThread(DestroyMid)
	WaitSeconds(10)
end

DestroyMid = function()
	PrintText("Clearing Mid in 10 Seconds. Please clear the area.", 20, "ffffffff", 5, 'center');
	WaitSeconds(10)

	local ExplosionCount = 0
	while ExplosionCount< Random(10,20) do
		local killit = CreateUnitHPR("ual0001", "NEUTRAL_CIVILIAN", Random(230,280), 25.984375, Random(230,280), 0,0,0)
		killit:Kill()
		WaitSeconds(Random(1,3))
		ExplosionCount = ExplosionCount + 1
	end
	LOG("Boom")
	WaitSeconds(5)
	createmiddleciv()
end

ResetStartingRestrictions = function()
	if ScenarioInfo.Options.RestrictedCategories == nil then
		LOG("No Build Restrictions")
	else
		for key, value in ScenarioInfo.Options.RestrictedCategories do
			local tblArmies = ListArmies()
			for index, name in tblArmies do
				if value == "PRODSC1" then
					AddBuildRestriction(index, categories.PRODUCTSC1)
				elseif value == "PRODFA" then
					AddBuildRestriction(index, categories.PRODUCTFA)
				elseif value == "PRODDL" then
					-- AddBuildRestriction(index, categories.PRODUCTDL)
				elseif value == "UEF" then
					AddBuildRestriction(index, categories.UEF)
				elseif value == "CYBRAN" then
					AddBuildRestriction(index, categories.CYBRAN)
				elseif value == "AEON" then
					AddBuildRestriction(index, categories.AEON)
				elseif value == "SERAPHIM" then
					AddBuildRestriction(index, categories.SERAPHIM)
				elseif value == "T1" then
					AddBuildRestriction(index, categories.TECH1)
				elseif value == "T2" then
					AddBuildRestriction(index, categories.TECH2)
				elseif value == "T3" then
					AddBuildRestriction(index, categories.TECH3)
				elseif value == "EXPERIMENTAL" then
					AddBuildRestriction(index, categories.EXPERIMENTAL)
				elseif value == "NAVAL" then
					AddBuildRestriction(index, categories.NAVAL)
				elseif value == "LAND" then
					AddBuildRestriction(index, categories.LAND)
				elseif value == "AIR" then
					AddBuildRestriction(index, categories.AIR)
				elseif value == "NUKE" then
					AddBuildRestriction(index, categories.NUKE)
					AddBuildRestriction(index, categories.ues0304) --UEF T3 Strategic Missile Submarine: Ace
					AddBuildRestriction(index, categories.urs0304) --Cybran T3 Strategic Missile Submarine: Plan B
					AddBuildRestriction(index, categories.uas0304) --Aeon T3 Strategic Missile Submarine: Silencer
					AddBuildRestriction(index, categories.xsa0402) --Seraphim EX Experimental Bomber: Ahwassa
					AddBuildRestriction(index, categories.xsb2401) --Seraphim EX Experimental Missile Launcher: Yolona Oss
				elseif value == "GAMEENDERS" then
					AddBuildRestriction(index, categories.uab2305)
					AddBuildRestriction(index, categories.ueb2305)
					AddBuildRestriction(index, categories.urb2305)
					AddBuildRestriction(index, categories.xsb2305)
					AddBuildRestriction(index, categories.xab2307)
					AddBuildRestriction(index, categories.ueb2302)
					AddBuildRestriction(index, categories.uab2302)
					AddBuildRestriction(index, categories.urb2302)
					AddBuildRestriction(index, categories.xsb2302)
					AddBuildRestriction(index, categories.ues0304) --UEF T3 Strategic Missile Submarine: Ace
					AddBuildRestriction(index, categories.urs0304) --Cybran T3 Strategic Missile Submarine: Plan B
					AddBuildRestriction(index, categories.uas0304) --Aeon T3 Strategic Missile Submarine: Silencer
					AddBuildRestriction(index, categories.xsa0402) --Seraphim EX Experimental Bomber: Ahwassa
					AddBuildRestriction(index, categories.ueb2401) --UEF EX Experimental Artillery: Mavor
					AddBuildRestriction(index, categories.url0401) --Cybran EX Experimental Mobile Rapid-Fire Artillery: Scathis
					AddBuildRestriction(index, categories.xsb2401) --Seraphim EX Experimental Missile Launcher: Yolona Oss
				elseif value == "BUBBLES" then
					AddBuildRestriction(index, categories.SHIELD)
				elseif value == "INTEL" then
					AddBuildRestriction(index, categories.INTELLIGENCE)
				elseif value == "SUPCOM" then
					AddBuildRestriction(index, categories.SUBCOMMANDER)
				elseif value == "FABS" then
					AddBuildRestriction(index, categories.MASSFABRICATION)
				end
			end
		end
	end
end

createcivpararadar = function()
	local para1 = CreateUnitHPR("xab1401", "ARMY_9", 0, 0, 0, 0,0,0)
	local para2 = CreateUnitHPR("xab1401", "NEUTRAL_CIVILIAN", 512, 0, 512, 0,0,0)
	local radar1 = CreateUnitHPR("uab3104", "ARMY_9", 0, 0, 0, 0,0,0)
	local radar2 = CreateUnitHPR("uab3104", "NEUTRAL_CIVILIAN", 512, 0, 512, 0,0,0)

	canttouchthis(para1)
	canttouchthis(para2)
	canttouchthis(radar1)
	canttouchthis(radar2)
end

canttouchthis = function(unit)
	unit:SetReclaimable(false);
	unit:SetCanTakeDamage(false);
	unit:SetDoNotTarget(true);
	unit:SetCanBeKilled(false);
	unit:SetCapturable(false);
	unit:SetReclaimable(false);
end

function disableWalls()
	for armyIndex, armyName in ListArmies() do
		AddBuildRestriction(armyIndex, categories.WALL)
	end
end

function applyPlayerAirRestriction()
	if (ScenarioInfo.Options.opt_FinalRushAir == 0) then
		for armyIndex, armyName in ListArmies() do
			AddBuildRestriction(armyIndex, categories.AIR)
		end
	end

	transportscoutonly()
end

Survival = function()
	if ScenarioInfo.Options.opt_gamemode > 1 then  --all survival
		disableWalls()
	end

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
		createcivpararadar()
		ForkThread(RunBattle)
	end

	if ScenarioInfo.Options.opt_gamemode > 2 then  --easy, normal, hard and insane survival
		local tblArmies = ListArmies()
		for index, name in tblArmies do
			SetAlliance(index, "NEUTRAL_CIVILIAN", 'Enemy')
			SetAlliance(index, "ARMY_9", 'Enemy')
		end
		SetAlliance("ARMY_9", "NEUTRAL_CIVILIAN", 'Ally')
		createcivpararadar()
		ForkThread(RunBattle)
		ForkThread(CommanderWaterPain)
		ForkThread(NoHillsClimbingBitches)
	end
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

RunBattle = function()
	tvEn  = 	IsTotalVetEnabled() 	--Total Veterancy
	acuEn = 	IsBLackOpsAcusEnabled() --Blackops Adv Command Units.

	local SpawnMulti = (Team1Count + Team2Count) / 8

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
	else
		LOG("Survival... WTF, who broke it")
	end

	t1spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t1spawndelay
	t2spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t2spawndelay
	t3spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t3spawndelay
	t4spawndelay = ScenarioInfo.Options.opt_FinalRushSpawnDelay + t4spawndelay
	hunterdelay  = ScenarioInfo.Options.opt_FinalRushSpawnDelay + hunterdelay

	if ScenarioInfo.Options.opt_FinalRushAggression == 1 then
		ForkThread(AggressionCheck)
		AggressionSpawner(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end

	ForkThread(SpawnerGroup1,t1spawndelay,t1frequency / SpawnMulti,t2spawndelay)
	ForkThread(SpawnerGroup2,t2spawndelay,t2frequency / SpawnMulti)
	ForkThread(SpawnerGroup3,t3spawndelay,t3frequency / SpawnMulti)
	ForkThread(SpawnerGroup4,t4spawndelay,t4frequency / SpawnMulti)
	ForkThread(SpawnerHunters, hunterdelay,hunterfrequency / SpawnMulti)
	ForkThread(RandomEvents, t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
end

AggressionCheck = function()
	while true do
		CompileAggression()
		WaitSeconds(2)
	end
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
	while true do  --never gonna stop
	ForkThread(Round2,delay)
	WaitSeconds(frequency)
	end
end

SpawnerGroup3 = function(delay,frequency)
	WaitSeconds(delay)
	PrintText("Tech 3 inbound", 20, "ffffffff", 5, 'center')
	while true do  --never gonna stop
	ForkThread(Round3,delay)
	WaitSeconds(frequency)
	end
end

SpawnerGroup4 = function(delay,frequency)
	WaitSeconds(delay)
	PrintText("Experimentals inbound", 20, "ffffffff", 5, 'center')
	while true do  --never gonna stop
	ForkThread(Round4,delay)
	WaitSeconds(frequency)
	end
end

SpawnerHunters = function(delay,frequency)
	WaitSeconds(delay)
	PrintText("Hunters inbound", 20, "ffffffff", 5, 'center')
	while true do  --never gonna stop
	ForkThread(Hunters,delay)
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

function GetRandomPlayerExisted(team)
	local Units_FinalFight = false
	local selectplayertoattack
	while Units_FinalFight == false do
		selectplayertoattack = Random(1,4)

		if team == 1 then

			if selectplayertoattack == 1 and StartingPlayersExistance.ARMY_1 then
				Units_FinalFight = AttackLocations.Team1.Player1
			elseif selectplayertoattack == 2 and StartingPlayersExistance.ARMY_2 then
				Units_FinalFight = AttackLocations.Team1.Player2
			elseif selectplayertoattack == 3 and StartingPlayersExistance.ARMY_3 then
				Units_FinalFight = AttackLocations.Team1.Player3
			elseif selectplayertoattack == 4 and StartingPlayersExistance.ARMY_4 then
				Units_FinalFight = AttackLocations.Team1.Player4
			end
		elseif team == 2 then

			if selectplayertoattack == 1 and StartingPlayersExistance.ARMY_5 then
				Units_FinalFight = AttackLocations.Team2.Player1
			elseif selectplayertoattack == 2 and StartingPlayersExistance.ARMY_6 then
				Units_FinalFight = AttackLocations.Team2.Player2
			elseif selectplayertoattack == 3 and StartingPlayersExistance.ARMY_7 then
				Units_FinalFight = AttackLocations.Team2.Player3
			elseif selectplayertoattack == 4 and StartingPlayersExistance.ARMY_8 then
				Units_FinalFight = AttackLocations.Team2.Player4
			end
		end
		WaitSeconds(0.1)
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
		HeathMulti(units_ARMY9,hpincreasedelay)
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
		HeathMulti(units_Civilian,hpincreasedelay)
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
		HeathMulti(units_ARMY9,hpincreasedelay)
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
		HeathMulti(units_Civilian,hpincreasedelay)
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
		HeathMulti(units_ARMY9,hpincreasedelay)
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
		HeathMulti(units_Civilian,hpincreasedelay)
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
		HeathMulti(units_ARMY9,hpincreasedelay)
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
		HeathMulti(units_Civilian,hpincreasedelay)
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

SpawnARTY = function(hpincreasedelay)
	PrintText("T3 Mobile Arty Detected" , 20, "ffffffff", 5, 'center');
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local TransportEnd
	local transport

	if TeamToAttack == 1 then --ARMY_9
	TransportEnd = TransportDestinations.SouthernAttackerEnd
	AttackerARMY = "ARMY_9"
	transport = CreateUnitHPR("xea0306", AttackerARMY, 500, 80, 10, 0,0,0)
	elseif TeamToAttack == 2 then
		TransportEnd = TransportDestinations.NorthernAttackerEnd
		AttackerARMY = "NEUTRAL_CIVILIAN"
		transport = CreateUnitHPR("xea0306", AttackerARMY, 10, 80, 500, 0,0,0)
	end


	local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport:SetCanTakeDamage(false);
	end

	local unit1 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit2 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
	local unit3 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit4 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
	local unit5 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit6 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
	local unit7 = CreateUnitHPR("url0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit8 = CreateUnitHPR("uel0304", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	local transports = {transport}

	ForkThread(Killgroup,units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	RemoveWreckage(units)

	ScenarioFramework.AttachUnitsToTransports(units, transports)
	IssueTransportUnload(transports, TransportTo)

	IssueAggressiveMove(units,GetRandomPlayer(TeamToAttack))
	IssueMove(transports,TransportEnd)

	WaitSeconds(50)

	for index, transport in transports do
		spawnOutEffect(transport)
	end
end

SpawnYthotha = function(hpincreasedelay)
	PrintText("Ythotha Detected" , 20, "ffffffff", 5, 'center');
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local TransportEnd
	local transport

	if TeamToAttack == 1 then --ARMY_9
	TransportEnd = TransportDestinations.SouthernAttackerEnd
	AttackerARMY = "ARMY_9"
	transport = CreateUnitHPR("xea0306", AttackerARMY, 500, 80, 10, 0,0,0)
	elseif TeamToAttack == 2 then
		TransportEnd = TransportDestinations.NorthernAttackerEnd
		AttackerARMY = "NEUTRAL_CIVILIAN"
		transport = CreateUnitHPR("xea0306", AttackerARMY, 10, 80, 500, 0,0,0)
	end


	local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport:SetCanTakeDamage(false);
	end

	local unit1 = CreateUnitHPR("xsl0401", AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)

	local units = {unit1}
	local transports = {transport}

	ForkThread(Killgroup,units)
	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	RemoveWreckage(units)

	ScenarioFramework.AttachUnitsToTransports(units, transports)
	IssueTransportUnload(transports, TransportTo)

	IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))

	IssueMove(transports,TransportEnd)

	WaitSeconds(50)

	for index, transport in transports do
		spawnOutEffect(transport)
	end
end

SpawnBombers = function(hpincreasedelay)
	PrintText("T1 Bombers Detected" , 20, "ffffffff", 5, 'center');
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local Telepoint
	local unit1
	local unit2
	local unit3
	local unit4
	local unit5
	local unit6
	local unit7
	local unit8

	if TeamToAttack == 1 then --ARMY_9
	AttackerARMY = "ARMY_9"
	unit1 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit2 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit3 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit4 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit5 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit6 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit7 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit8 = CreateUnitHPR("uea0103", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	elseif TeamToAttack == 2 then
		AttackerARMY = "NEUTRAL_CIVILIAN"
		unit1 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit2 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit3 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit4 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit5 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit6 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit7 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit8 = CreateUnitHPR("uea0103", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
	end

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	RemoveWreckage(units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

	IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	ForkThread(Killgroup,units)
end

SpawnT1Gunships = function(hpincreasedelay)
	PrintText("T1 Gunships Detected" , 20, "ffffffff", 5, 'center');
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local Telepoint
	local unit1
	local unit2
	local unit3
	local unit4
	local unit5
	local unit6
	local unit7
	local unit8

	if TeamToAttack == 1 then --ARMY_9
	AttackerARMY = "ARMY_9"
	unit1 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit2 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit3 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit4 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit5 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit6 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit7 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit8 = CreateUnitHPR("xra0105", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	elseif TeamToAttack == 2 then
		AttackerARMY = "NEUTRAL_CIVILIAN"
		unit1 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit2 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit3 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit4 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit5 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit6 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit7 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit8 = CreateUnitHPR("xra0105", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
	end

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	RemoveWreckage(units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

	IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	ForkThread(Killgroup,units)
end

SpawnT2Bombers = function(hpincreasedelay)
	PrintText("T2 Bombers Detected" , 20, "ffffffff", 5, 'center');
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local Telepoint
	local unit1
	local unit2
	local unit3
	local unit4
	local unit5
	local unit6
	local unit7
	local unit8

	if TeamToAttack == 1 then --ARMY_9
	AttackerARMY = "ARMY_9"
	unit1 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit2 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit3 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit4 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit5 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit6 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit7 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit8 = CreateUnitHPR("dea0202", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	elseif TeamToAttack == 2 then
		AttackerARMY = "NEUTRAL_CIVILIAN"
		unit1 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit2 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit3 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit4 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit5 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit6 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit7 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit8 = CreateUnitHPR("dea0202", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
	end

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	RemoveWreckage(units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

	IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	ForkThread(Killgroup,units)
end

SpawnT3Bombers = function(hpincreasedelay)
	PrintText("T3 Bombers Detected" , 20, "ffffffff", 5, 'center');
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local Telepoint
	local unit1
	local unit2
	local unit3
	local unit4
	local unit5
	local unit6
	local unit7
	local unit8

	if TeamToAttack == 1 then --ARMY_9
	AttackerARMY = "ARMY_9"
	unit1 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit2 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit3 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit4 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit5 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit6 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit7 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit8 = CreateUnitHPR("uea0304", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	elseif TeamToAttack == 2 then
		AttackerARMY = "NEUTRAL_CIVILIAN"
		unit1 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit2 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit3 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit4 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit5 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit6 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit7 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit8 = CreateUnitHPR("uea0304", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
	end

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	RemoveWreckage(units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

	IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	ForkThread(Killgroup,units)
end

SpawnT3Gunships = function(hpincreasedelay)
	PrintText("T3 Gunships Detected" , 20, "ffffffff", 5, 'center');
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local Telepoint
	local unit1
	local unit2
	local unit3
	local unit4
	local unit5
	local unit6
	local unit7
	local unit8

	if TeamToAttack == 1 then --ARMY_9
	AttackerARMY = "ARMY_9"
	unit1 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit2 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit3 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit4 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit5 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit6 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit7 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	unit8 = CreateUnitHPR("uea0305", AttackerARMY, Random(500,512), 25.9844, Random(0,10),0,0,0)
	elseif TeamToAttack == 2 then
		AttackerARMY = "NEUTRAL_CIVILIAN"
		unit1 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit2 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit3 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit4 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit5 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit6 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit7 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
		unit8 = CreateUnitHPR("uea0305", AttackerARMY, Random(0,10), 25.9844, Random(500,512),0,0,0)
	end

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	RemoveWreckage(units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

	IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	ForkThread(Killgroup,units)
end

SpawnT2Destroyers = function(hpincreasedelay)
	PrintText("Destroyers Detected" , 20, "ffffffff", 5, 'center');
	local unit1_ARMY9 = CreateUnitHPR("urs0201", "ARMY_9", Random(20,30), 25.9844, Random(480,490) ,0,0,0)
	local AttackerARMY
	local TeamToAttack = Random(1,2)
	local Telepoint
	local unit1
	local unit2
	local unit3
	local unit4
	local unit5
	local unit6
	local unit7
	local unit8

	if TeamToAttack == 1 then --ARMY_9
	AttackerARMY = "ARMY_9"
	unit1 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	unit2 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	unit3 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	unit4 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	unit5 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	unit6 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	unit7 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	unit8 = CreateUnitHPR("urs0201", AttackerARMY, Random(480,490), 25.9844, Random(20,30),0,0,0)
	elseif TeamToAttack == 2 then
		AttackerARMY = "NEUTRAL_CIVILIAN"
		unit1 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
		unit2 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
		unit3 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
		unit4 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
		unit5 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
		unit6 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
		unit7 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
		unit8 = CreateUnitHPR("urs0201", AttackerARMY, Random(20,30), 25.9844, Random(480,490),0,0,0)
	end

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	RemoveWreckage(units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	IssueMove(units, VECTOR3( Random(220,290), 80, Random(220,290)))

	IssueAggressiveMove(units, GetRandomPlayerExisted(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	ForkThread(Killgroup,units)
end

SpeedCurrentUnits = function()
	PrintText("Current Units Speed Boosted" , 20, "ffffffff", 5, 'center');
	local units = allUnits()
	for index,unit in units do
		if EntityCategoryContains(categories.LAND + categories.NAVAL, unit) and scnArmy(unit) ==  "ARMY_9" or scnArmy(unit) == "NEUTRAL_CIVILIAN" then
			unit:SetSpeedMult(2)
		end
	end
end

RandomEvents = function(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay, RandomFrequency)
	while true do
		--T2 Section
		if (GetGameTimeSeconds() - t2spawndelay) > 0 then
			local RandomEvent = Random(1,3)
			if RandomEvent == 1 then
				ForkThread(SpawnBombers,t2spawndelay)
			elseif RandomEvent == 2 then
				ForkThread(SpawnT1Gunships, t3spawndelay)
			elseif RandomEvent == 3 then
				ForkThread(SpeedCurrentUnits)
			end
		end

		--T3 Section
		if (GetGameTimeSeconds() - t3spawndelay) > 0 then
			local RandomEvent = Random(1,4)
			if RandomEvent == 1 then
				if (ScenarioInfo.Options.opt_t3arty == 0) then
					ForkThread(SpawnARTY, t3spawndelay)
				else
					ForkThread(SpawnT3Bombers, t4spawndelay)
				end
			elseif RandomEvent == 2 then
				ForkThread(SpawnT2Bombers, t3spawndelay)
			elseif RandomEvent == 3 then
				ForkThread(SpawnT3Gunships, t3spawndelay)
			elseif RandomEvent == 4 then
				ForkThread(SpawnT2Destroyers, t3spawndelay)
			end
		end

		--T4 Section
		if (GetGameTimeSeconds() - t4spawndelay) > 0 then
			local RandomEvent = Random(1,2)
			if RandomEvent == 1 then
				ForkThread(SpawnYthotha, t4spawndelay)
			elseif RandomEvent == 2 then
				ForkThread(SpawnT3Bombers, t4spawndelay)
			end
		end

		WaitSeconds(RandomFrequency)
	end
end

Hunters = function(hpincreasedelay)
	local AttackTeam = GetRandomCommander() --returns army ie. ARMY_1
	local AttackCommander = GetArmyCommander(AttackTeam)
	local Leader
	local spawnrandomcommander = Random(1,4)


	local acu_cyran
	local acu_uef
	local acu_aeon
	local acu_seraphim

	if acuEn == false then
		acu_cyran	 =	"url0001"
		acu_uef		 =	"uel0001"
		acu_aeon	 =	"ual0001"
		acu_seraphim =	"xsl0001"
	elseif acuEn == true then
		acu_cyran	 =	"erl0001"
		acu_uef		 =	"eel0001"
		acu_aeon	 =	"eal0001"
		acu_seraphim =	"esl0001"
	end

	if spawnrandomcommander == 1 then
		Leader = CreateUnitHPR(acu_aeon, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Aeon Armored Command Unit
	elseif spawnrandomcommander == 2 then
		Leader = CreateUnitHPR(acu_cyran, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Cybran Armored Command Unit
	elseif spawnrandomcommander == 3 then
		Leader = CreateUnitHPR(acu_uef, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --UEF Armored Command Unit
	elseif spawnrandomcommander == 4 then
		Leader = CreateUnitHPR(acu_seraphim, "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Seraphim Armored Command Unit
	end
	Leader:SetCustomName("Bounty Hunter = Target: " .. getUsername(AttackTeam))
	local unit_aeon  = CreateUnitHPR("ual0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Aeon T3 Support Armored Command Unit
	local unit_cyran = CreateUnitHPR("url0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Cybran T3 Support Armored Command Unit
	local unit_uef   = CreateUnitHPR("uel0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --UEF T3 Support Armored Command Unit
	local unit_sera  = CreateUnitHPR("xsl0301", "NEUTRAL_CIVILIAN", Random(250,260), 25.9844, Random(250,260),0,0,0)  --Seraphim T3 Support Armored Command Unit

	local unit_list = {Leader,unit_aeon,unit_cyran,unit_uef,unit_sera}

	for index,spawnunit in unit_list do
		ForkThread(spawnEffect,spawnunit)
		ForkThread(CommanderUpgrades,spawnunit)
	end

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(unit_list,hpincreasedelay)
	end

	if AttackCommander == false then --team has no commander
	WaitSeconds(3)
	for index, unit in unit_list do
		ForkThread(spawnOutEffect,unit)
	end
	else
		IssueAttack(unit_list,AttackCommander)


		while not AttackCommander:IsDead() do
			WaitSeconds(3)
		end
		PrintText("Bounty " .. getUsername(AttackTeam) .. " Collected" , 20, "ffffffff", 5, 'center');
		WaitSeconds(6)
		for index, unit in unit_list do
			ForkThread(spawnOutEffect,unit)
		end
	end
end

CommanderUpgrades = function(unit)
	local unitid = unit:GetUnitId()
	if unitid == "ual0001" then 							--Aeon Armored Command Unit
	unit:CreateEnhancement("Shield")
	unit:CreateEnhancement("ShieldHeavy")
	unit:CreateEnhancement("HeatSink")
	unit:CreateEnhancement("CrysalisBeam")
	elseif unitid == "url0001" then 						--Cybran Armored Command Unit
	unit:CreateEnhancement("StealthGenerator")
	unit:CreateEnhancement("CloakingGenerator")
	unit:CreateEnhancement("CoolingUpgrade")
	unit:CreateEnhancement("MicrowaveLaserGenerator")
	elseif unitid == "uel0001" then 						--UEF Armored Command Unit
	unit:CreateEnhancement("DamageStablization")
	unit:CreateEnhancement("HeavyAntiMatterCannon")
	unit:CreateEnhancement("Shield")
	elseif unitid == "xsl0001" then 						--Seraphim Armored Command Unit
	unit:CreateEnhancement("BlastAttack")
	unit:CreateEnhancement("DamageStabilization")
	unit:CreateEnhancement("DamageStabilizationAdvanced")
	unit:CreateEnhancement("RateOfFire")
	elseif unitid == "eal0001" then 						--Aeon Blackops Armored Command Unit
	unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
	unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
	unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
	unit:CreateEnhancement("EXBeamPhason")
	unit:CreateEnhancement("EXImprovedCoolingSystem")
	unit:CreateEnhancement("EXPowerBooster")
	unit:CreateEnhancement("EXShieldBattery")
	unit:CreateEnhancement("EXActiveShielding")
	unit:CreateEnhancement("EXImprovedShieldBattery")
	elseif unitid == "erl0001" then 						--Cybran Blackops Armored Command Unit
	unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
	unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
	unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
	unit:CreateEnhancement("EXMasor")
	unit:CreateEnhancement("EXImprovedCoolingSystem")
	unit:CreateEnhancement("EXAdvancedEmitterArray")
	unit:CreateEnhancement("EXArmorPlating")
	unit:CreateEnhancement("EXStructuralIntegrity")
	unit:CreateEnhancement("EXCompositeMaterials")
	elseif unitid == "eel0001" then 						--UEF Blackops Armored Command Unit
	unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
	unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
	unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
	unit:CreateEnhancement("EXAntiMatterCannon")
	unit:CreateEnhancement("EXImprovedContainmentBottle")
	unit:CreateEnhancement("EXPowerBooster")
	unit:CreateEnhancement("EXShieldBattery")
	unit:CreateEnhancement("EXActiveShielding")
	unit:CreateEnhancement("EXImprovedShieldBattery")
	elseif unitid == "esl0001" then 						--Seraphim Blackops Armored Command Unit
	unit:CreateEnhancement("EXCombatEngineering")  		--combat t2
	unit:CreateEnhancement("EXAssaultEngineering")		--combat t3
	unit:CreateEnhancement("EXApocolypticEngineering")	--combat t4
	unit:CreateEnhancement("EXCannonBigBall")
	unit:CreateEnhancement("EXImprovedContainmentBottle")
	unit:CreateEnhancement("EXPowerBooster")
	unit:CreateEnhancement("EXL1Lambda")
	unit:CreateEnhancement("EXL2Lambda")
	unit:CreateEnhancement("EXL3Lambda")
	elseif unitid == "ual0301" then 						--Aeon T3 Support Armored Command Unit
	unit:CreateEnhancement("Shield") 	 					--back
	unit:CreateEnhancement("ShieldHeavy") 	 				--back
	unit:CreateEnhancement("StabilitySuppressant")  		--right
	unit:CreateEnhancement("EngineeringFocusingModule")  	--left
	elseif unitid == "url0301" then --Cybran T3 Support Armored Command Unit
	unit:CreateEnhancement("StealthGenerator")  			--back
	unit:CreateEnhancement("CloakingGenerator")  			--back
	unit:CreateEnhancement("EMPCharge")						--left
	unit:CreateEnhancement("FocusConvertor")				--right
	elseif unitid == "uel0301" then --UEF T3 Support Armored Command Unit
	unit:CreateEnhancement("AdvancedCoolingUpgrade")		--left
	unit:CreateEnhancement("HighExplosiveOrdnance")			--right
	unit:CreateEnhancement("Shield")						--back
	elseif unitid == "xsl0301" then --Seraphim T3 Support Armored Command Unit
	unit:CreateEnhancement("DamageStabilization")			--left
	unit:CreateEnhancement("Shield")						--back
	unit:CreateEnhancement("Overcharge")					--right
	end
end

ArmyAttackTarget = function(attackarmy,unitgroup)
	if attackarmy == "army9" then
		IssueAggressiveMove(unitgroup,GetRandomPlayer(1))
		IssueAggressiveMove(unitgroup,GetRandomPlayer(1))
	elseif attackarmy == "civ" then
		IssueAggressiveMove(unitgroup,GetRandomPlayer(2))
		IssueAggressiveMove(unitgroup,GetRandomPlayer(2))
	end

	WaitSeconds(90)
	local range = 50
	while GetNearestCommander(unitgroup,range) == false and range < 400 do
		range = range + 50
		WaitSeconds(1)
	end
	IssueAttack(unitgroup,GetNearestCommander(unitgroup,range))
	ForkThread(Killgroup,unitgroup)
end

Killgroup = function(unitgroup)
	WaitSeconds(60*5)
	for key, value in unitgroup do
		if not value:IsDead() then
			spawnOutEffect(value)
		end
	end
end

HeathMulti = function(unitgroup,hpincreasedelay)
	local current_time = GetGameTimeSeconds()
	local hp_multi
	local TVGlevel
	local difficulty_multi
	local vetlevel


	if ScenarioInfo.Options.opt_gamemode == 4 then --normal
	difficulty_multi = 0.25
	vetlevel = 1
	elseif ScenarioInfo.Options.opt_gamemode == 5 then --hard
	difficulty_multi = 1
	vetlevel = 3
	elseif ScenarioInfo.Options.opt_gamemode == 6 then --insane
	difficulty_multi = 4
	vetlevel = 5
	end

	if tvEn == false then
		hp_multi = (current_time - hpincreasedelay) / 100 * difficulty_multi
		for key, value in unitgroup do
			value:SetVeterancy(vetlevel)
			value:SetMaxHealth(value:GetMaxHealth() * (hp_multi + 1))
			value:SetHealth(value ,value:GetMaxHealth() * (hp_multi + 1))
		end
	elseif tvEn == true then
		hp_multi = ((current_time - hpincreasedelay) / 100 * difficulty_multi)
		TVGlevel = math.floor((current_time - (hpincreasedelay / 2)) / 30 * difficulty_multi)
		for key, value in unitgroup do
			value:AddLevels(TVGlevel)
			value:SetMaxHealth(value:GetMaxHealth() * (hp_multi + 1))
			value:SetHealth(value ,value:GetMaxHealth() * (hp_multi + 1))
		end
	end
end

allUnits = function()
	local xmapsize = ScenarioInfo.size[1]
	local ymapsize = ScenarioInfo.size[2]
	local mapRect = {x0 = 0, x1 = xmapsize, y0 = 0, y1 = ymapsize}
	return GetUnitsInRect(mapRect)
end

killUnitsOnLayer = function(layers)
	--get all units on the map
	local units = allUnits()
	--if there are units on the map
	if units and table.getn(units) > 0 then
		for index,unit in units do
			local delete = false

			--is the unit on one of the specified layers?
			for index,layer in layers do
				if unit:GetCurrentLayer() == layer and EntityCategoryContains(categories.COMMAND, unit) then
					delete = true
				end
			end

			if  delete == true then
				if unit and not unit:IsDead() then
					local pos = unit:GetPosition()
					unit:SetHealth(unit ,unit:GetHealth() - (unit:GetMaxHealth() / 10))
					if unit:GetHealth() < 10 then
						unit:Kill()
					end
				end
			end
		end
	end
end

CommanderWaterPain = function()
	while true do
		WaitSeconds(2)
		killUnitsOnLayer({'Water','Seabed','Sub'})
	end
end

GetRandomCommander = function()
	local army = false
	local randomnum
	while army == false do
		randomnum = Random(1,8)
		if randomnum == 1 and StartingPlayersExistance.ARMY_1 and ArmyIsOutOfGame("ARMY_1") == false then
			army = "ARMY_1"
		elseif randomnum == 2 and StartingPlayersExistance.ARMY_2 and ArmyIsOutOfGame("ARMY_2") == false then
			army = "ARMY_2"
		elseif randomnum == 3 and StartingPlayersExistance.ARMY_3 and ArmyIsOutOfGame("ARMY_3") == false then
			army = "ARMY_3"
		elseif randomnum == 4 and StartingPlayersExistance.ARMY_4 and ArmyIsOutOfGame("ARMY_4") == false then
			army = "ARMY_4"
		elseif randomnum == 5 and StartingPlayersExistance.ARMY_5 and ArmyIsOutOfGame("ARMY_5") == false then
			army = "ARMY_5"
		elseif randomnum == 6 and StartingPlayersExistance.ARMY_6 and ArmyIsOutOfGame("ARMY_6") == false then
			army = "ARMY_6"
		elseif randomnum == 7 and StartingPlayersExistance.ARMY_7 and ArmyIsOutOfGame("ARMY_7") == false then
			army = "ARMY_7"
		elseif randomnum == 8 and StartingPlayersExistance.ARMY_8 and ArmyIsOutOfGame("ARMY_8") == false then
			army = "ARMY_8"
		else
			army = false
		end
	end
	PrintText("Hunters are targeting " .. getUsername(army), 20, "ffffffff", 5, 'center');
	return army
end

GetArmyCommander = function(army)
	local units = allUnits()
	local commander = false
	for index,unit in units do
		if EntityCategoryContains(categories.COMMAND, unit) and scnArmy(unit) ==  army then
			commander = unit
		end
	end
	return commander
end

--given a unit returns the army
scnArmy = function(unit)
	local armyIndex = unit:GetArmy()
	return indexToArmy(armyIndex)
end

--given an army index returns an army
indexToArmy = function(armyIndex)
	local army = ListArmies()[armyIndex]
	return army
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

function NoHillsClimbingBitches()
	local police1 = CreateUnitHPR( "ual0401", "NEUTRAL_CIVILIAN", 493.739227, 65.536545, 493.537750, 0.000000, 0.671952, 0.000000)
	local police2 = CreateUnitHPR( "ual0401", "NEUTRAL_CIVILIAN", 477.215668, 65.875885, 477.170502, 0.000000, 0.733038, 0.000000)
	local police3 = CreateUnitHPR( "ual0401", "NEUTRAL_CIVILIAN", 438.233734, 63.601822, 494.937134, 0.000000, -0.497419, 0.000000)
	local police4 = CreateUnitHPR( "ual0401", "NEUTRAL_CIVILIAN", 495.536011, 62.919582, 438.201752, 0.000000, 2.487095, 0.000000)

	local police5 = CreateUnitHPR( "ual0401", "ARMY_9", 17.379473, 65.951057, 17.682734, 0.000000, -2.417280, 0.000000)
	local police6 = CreateUnitHPR( "ual0401", "ARMY_9", 35.684875, 65.957329, 35.915600, 0.000000, 0.654499, 0.000000)
	local police7 = CreateUnitHPR( "ual0401", "ARMY_9", 15.666634, 62.922352, 72.599403, 0.000000, 0.000000, 0.000000)
	local police8 = CreateUnitHPR( "ual0401", "ARMY_9", 74.871712, 63.439056, 16.922817, 0.000000, 1.439896, 0.000000)

	canttouchthis(police1)
	canttouchthis(police2)
	canttouchthis(police3)
	canttouchthis(police4)
	canttouchthis(police5)
	canttouchthis(police6)
	canttouchthis(police7)
	canttouchthis(police8)

	police1:SetCustomName("Hill Guards")
	police2:SetCustomName("Hill Guards")
	police3:SetCustomName("Hill Guards")
	police4:SetCustomName("Hill Guards")
	police5:SetCustomName("Hill Guards")
	police6:SetCustomName("Hill Guards")
	police7:SetCustomName("Hill Guards")
	police8:SetCustomName("Hill Guards")
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

function TeleportCheck()
	if (ScenarioInfo.Options.opt_Teleport == 1) then
		ScenarioFramework.RestrictEnhancements({'Teleporter'})
	end
end

function GetTeamSize()
	local Team1Num = 0
	local Team2Num = 0

	if StartingPlayersExistance.ARMY_1 then
		Team1Num = Team1Num + 1
	end
	if StartingPlayersExistance.ARMY_2 then
		Team1Num = Team1Num + 1
	end
	if StartingPlayersExistance.ARMY_3 then
		Team1Num = Team1Num + 1
	end
	if StartingPlayersExistance.ARMY_4 then
		Team1Num = Team1Num + 1
	end
	if StartingPlayersExistance.ARMY_5 then
		Team2Num = Team2Num + 1
	end
	if StartingPlayersExistance.ARMY_6 then
		Team2Num = Team2Num + 1
	end
	if StartingPlayersExistance.ARMY_7 then
		Team2Num = Team2Num + 1
	end
	if StartingPlayersExistance.ARMY_8 then
		Team2Num = Team2Num + 1
	end

	Team1Count = Team1Num
	Team2Count = Team2Num
end

function CompileAggression()
	Aggro.Team1.Player1 = Aggression.ReturnAggro(1,1)
	Aggro.Team1.Player2 = Aggression.ReturnAggro(1,2)
	Aggro.Team1.Player3 = Aggression.ReturnAggro(1,3)
	Aggro.Team1.Player4 = Aggression.ReturnAggro(1,4)
	Aggro.Team2.Player1 = Aggression.ReturnAggro(2,1)
	Aggro.Team2.Player2 = Aggression.ReturnAggro(2,2)
	Aggro.Team2.Player3 = Aggression.ReturnAggro(2,3)
	Aggro.Team2.Player4 = Aggression.ReturnAggro(2,4)
end

SendUnitsToPlayer = function(unit, team, player, hpincreasedelay)
	local AttackerARMY
	local TeamToAttack = team
	local TransportEnd
	local transport

	if TeamToAttack == 1 then --ARMY_9
	TransportEnd = TransportDestinations.SouthernAttackerEnd
	AttackerARMY = "ARMY_9"
	transport = CreateUnitHPR("xea0306", AttackerARMY, 500, 80, 10, 0,0,0)
	elseif TeamToAttack == 2 then
		TransportEnd = TransportDestinations.NorthernAttackerEnd
		AttackerARMY = "NEUTRAL_CIVILIAN"
		transport = CreateUnitHPR("xea0306", AttackerARMY, 10, 80, 500, 0,0,0)
	end


	local TransportTo = VECTOR3( Random(220,290), 80, Random(220,290))

	if ScenarioInfo.Options.opt_gamemode > 2 then
		transport:SetCanTakeDamage(false);
	end

	local unit1 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit2 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
	local unit3 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit4 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
	local unit5 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit6 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher
	local unit7 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --Cybran T3 Mobile Heavy Artillery: Trebuchet
	local unit8 = CreateUnitHPR(unit, AttackerARMY, 255.5, 25.9844, 255.5,0,0,0)  --UEF T3 Mobile Heavy Artillery: Demolisher

	local units = {unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8}
	local transports = {transport}

	ForkThread(Killgroup,units)

	if ScenarioInfo.Options.opt_gamemode > 3 then
		HeathMulti(units,hpincreasedelay)
	end

	RemoveWreckage(units)

	ScenarioFramework.AttachUnitsToTransports(units, transports)
	IssueTransportUnload(transports, TransportTo)

	IssueAggressiveMove(units, PlayerToLoc(team, player))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueAggressiveMove(units, GetRandomPlayer(TeamToAttack))
	IssueMove(transports,TransportEnd)

	WaitSeconds(50)

	for index, transport in transports do
		spawnOutEffect(transport)
	end
end

function PlayerToLoc(team, player)
	if team == 1 then
		if player == 1 then
			return AttackLocations.Team1.Player1
		elseif player == 2 then
			return AttackLocations.Team1.Player2
		elseif player == 3 then
			return AttackLocations.Team1.Player3
		elseif player == 4 then
			return AttackLocations.Team1.Player4
		end
	elseif team == 2 then
		if player == 1 then
			return AttackLocations.Team2.Player1
		elseif player == 2 then
			return AttackLocations.Team2.Player2
		elseif player == 3 then
			return AttackLocations.Team2.Player3
		elseif player == 4 then
			return AttackLocations.Team2.Player4
		end
	end
end

function AggressionSpawner(t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	if StartingPlayersExistance.ARMY_1 then
		ForkThread(AggressionWatcher,"ARMY_1",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
	if StartingPlayersExistance.ARMY_2 then
		ForkThread(AggressionWatcher,"ARMY_2",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
	if StartingPlayersExistance.ARMY_3 then
		ForkThread(AggressionWatcher,"ARMY_3",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
	if StartingPlayersExistance.ARMY_4 then
		ForkThread(AggressionWatcher,"ARMY_4",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
	if StartingPlayersExistance.ARMY_5 then
		ForkThread(AggressionWatcher,"ARMY_5",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
	if StartingPlayersExistance.ARMY_6 then
		ForkThread(AggressionWatcher,"ARMY_6",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
	if StartingPlayersExistance.ARMY_7 then
		ForkThread(AggressionWatcher,"ARMY_7",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
	if StartingPlayersExistance.ARMY_8 then
		ForkThread(AggressionWatcher,"ARMY_8",t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	end
end

function AggressionWatcher(army,t1spawndelay, t2spawndelay, t3spawndelay, t4spawndelay)
	local teamplayer = ArmyToPlayerTeam(army)
	local unit
	local hpincreasedelay
	local timewait
	local aggropercent
	local counter = 0

	while not ArmyIsOutOfGame(army) do
		aggropercent = ArmyToAggro(army)
		timewait = AgressionTimer(aggropercent)
		if counter > timewait and aggropercent > 5 then
			if GetGameTimeSeconds() > t4spawndelay then
				if aggropercent > 100 then
					hpincreasedelay = 0
					unit = GetRandomUnit(4)
				else
					hpincreasedelay = t3spawndelay
					unit = GetRandomUnit(3)
				end
			elseif GetGameTimeSeconds() > t3spawndelay then
				if aggropercent > 100 then
					hpincreasedelay = 0
					unit = GetRandomUnit(4)
				else
					hpincreasedelay = t3spawndelay
					unit = GetRandomUnit(3)
				end
			elseif GetGameTimeSeconds() > t2spawndelay then
				unit = GetRandomUnit(2)
				hpincreasedelay = t2spawndelay
			else
				unit = GetRandomUnit(1)
				hpincreasedelay = t1spawndelay
			end
			ForkThread(SendUnitsToPlayer,unit,teamplayer.Team,teamplayer.Player, hpincreasedelay)
			counter = 0
		end
		WaitSeconds(2)
		counter = counter + 2
	end
end


function ArmyToAggro(army)
	if army == "ARMY_1" then
		return Aggro.Team1.Player1
	elseif army == "ARMY_2" then
		return Aggro.Team1.Player2
	elseif army == "ARMY_3" then
		return Aggro.Team1.Player3
	elseif army == "ARMY_4" then
		return Aggro.Team1.Player4
	elseif army == "ARMY_5" then
		return Aggro.Team2.Player1
	elseif army == "ARMY_6" then
		return Aggro.Team2.Player2
	elseif army == "ARMY_7" then
		return Aggro.Team2.Player3
	elseif army == "ARMY_8" then
		return Aggro.Team2.Player4
	end
end

function AgressionTimer(aggrolevel)
	local timenum = 1
	if aggrolevel < 10 then
		timenum = 30
	elseif aggrolevel < 20 then
		timenum = 28
	elseif aggrolevel < 30 then
		timenum = 26
	elseif aggrolevel < 40 then
		timenum = 24
	elseif aggrolevel < 50 then
		timenum = 22
	elseif aggrolevel < 60 then
		timenum = 20
	elseif aggrolevel < 70 then
		timenum = 18
	elseif aggrolevel < 80 then
		timenum = 14
	elseif aggrolevel < 90 then
		timenum = 10
	elseif aggrolevel < 100 then
		timenum = 8
	elseif aggrolevel > 100 then
		timenum = 6
	end
	return timenum
end

function ArmyToPlayerTeam(army)
	local data = {}
	if army == "ARMY_1" then
		data = { Team = 1, Player = 1 }
	elseif army == "ARMY_2" then
		data = { Team = 1, Player = 2 }
	elseif army == "ARMY_3" then
		data = { Team = 1, Player = 3 }
	elseif army == "ARMY_4" then
		data = { Team = 1, Player = 4 }
	elseif army == "ARMY_5" then
		data = { Team = 2, Player = 1 }
	elseif army == "ARMY_6" then
		data = { Team = 2, Player = 2 }
	elseif army == "ARMY_7" then
		data = { Team = 2, Player = 3 }
	elseif army == "ARMY_8" then
		data = { Team = 2, Player = 4 }
	end
	return data
end

function GetRandomUnit(tech)
	if tech == 1 then
		return ScenarioFramework.GetRandomEntry(TableUnitID.Tech1)
	elseif tech == 2 then
		if (ScenarioInfo.Options.opt_t2tml == 0) then
			return ScenarioFramework.GetRandomEntry(TableUnitID.Tech2)
		else
			return ScenarioFramework.GetRandomEntry(TableUnitID.Tech2NoTml)
		end
	elseif tech == 3 then
		if (ScenarioInfo.Options.opt_snipers == 0) then
			return ScenarioFramework.GetRandomEntry(TableUnitID.Tech3)
		else
			return ScenarioFramework.GetRandomEntry(TableUnitID.Tech3NoSniper)
		end
	elseif tech == 4 then
		if (ScenarioInfo.Options.opt_t3arty == 0) then
			return ScenarioFramework.GetRandomEntry(TableUnitID.Aggro)
		else
			return ScenarioFramework.GetRandomEntry(TableUnitID.AggroNoArty)
		end
	end
end




