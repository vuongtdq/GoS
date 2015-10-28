--[[
	Spell Damage Library
	by eXtragoZ Ported And Updated by Deftsu
	
Version = 1.0.0.0
		
		Is designed to calculate the damage of the skills to champions, although most of the calculations
		work for creeps
			
-------------------------------------------------------	
	Usage:

		local target = GetCurrentTarget()
		local damage =getdmg("R",target,Source,3)	
-------------------------------------------------------
	Full function:
		getdmg("SKILL",target,myHero,stagedmg,spelllvl)
		
	Returns:
		damage

		Skill:			(in capitals!)
			"P"				-Passive
			"Q"
			"W"
			"E"
			"R"
			"QM"			-Q in melee form (Jayce, Nidalee and Elise only)
			"WM"			-W in melee form (Jayce, Nidalee and Elise only)
			"EM"			-E in melee form (Jayce, Nidalee and Elise only)
			
		Stagedmg:
			nil	Active or first instance of dmg
			1	Active or first instance of dmg
			2	Passive or second instance of dmg
			3	Max damage or third instance of dmg
			
		-Returns the damage they will do "Source" to "target" with the "skill"
		-With some skills returns a percentage of increased damage
		-Many skills GetArmor(myHero) shown per second, hit and other
		-Use spelllvl only if you want to specify the level of skill
		
]]--

function getdmg(spellname,target,Source,stagedmg,spelllvl)
        local Source = Source or GetMyHero()
	local Qlvl = spelllvl and spelllvl or GetCastLevel(Source,_Q)
	local Wlvl = spelllvl and spelllvl or GetCastLevel(Source,_W)
	local Elvl = spelllvl and spelllvl or GetCastLevel(Source,_E)
	local Rlvl = spelllvl and spelllvl or GetCastLevel(Source,_R)
	local stagedmg1,stagedmg2,stagedmg3 = 1,0,0
	if stagedmg == 2 then stagedmg1,stagedmg2,stagedmg3 = 0,1,0
	elseif stagedmg == 3 then stagedmg1,stagedmg2,stagedmg3 = 0,0,1 end
	TrueDmg = 0
	if ((spellname == "Q" or spellname == "QM") and Qlvl == 0) or ((spellname == "W" or spellname == "WM") and Wlvl == 0) or ((spellname == "E" or spellname == "EM") and Elvl == 0) or (spellname == "R" and Rlvl == 0) then
		TrueDmg = 0
	elseif spellname == "Q" or spellname == "W" or spellname == "E" or spellname == "R" or spellname == "P" or spellname == "QM" or spellname == "WM" or spellname == "EM" then
		local apdmg = 0
		local addmg = 0
		local dmg = 0
		if GetObjectName(Source) == "Aatrox" then
			if spellname == "Q" then addmg = 45*Qlvl+25+.6*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "W" then addmg = (35*Wlvl+25+(GetBonusDmg(Source)+GetBaseDamage(Source)))*(stagedmg1+stagedmg3) 
			elseif spellname == "E" then apdmg = 35*Elvl+40+.6*GetBonusAP(Source)+.6*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then apdmg = 100*Rlvl+100+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Ahri" then
			if spellname == "Q" then apdmg = (25*Qlvl+15+.35*GetBonusAP(Source))*(stagedmg1+stagedmg3) dmg = (25*Qlvl+15+.35*GetBonusAP(Source))*(stagedmg2+stagedmg3) -- stage1:Initial. stage2:way back. stage3:total.
			elseif spellname == "W" then apdmg = math.max(25*Wlvl+15+.4*GetBonusAP(Source),(25*Wlvl+15+.4*GetBonusAP(Source))*1.6*stagedmg3) -- xfox-fires ,  30% damage from each additional fox-fire beyond the first. stage3: Max damage
			elseif spellname == "E" then apdmg = 35*Elvl+25+.5*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 40*Rlvl+30+.3*GetBonusAP(Source) -- per dash
			end
		elseif GetObjectName(Source) == "Akali" then
			if spellname == "P" then apdmg = (6+GetBonusAP(Source)/6)*(GetBonusDmg(Source)+GetBaseDamage(Source))/100
			elseif spellname == "Q" then apdmg = math.max((20*Qlvl+15+.4*GetBonusAP(Source))*stagedmg1,(25*Qlvl+20+.5*GetBonusAP(Source))*stagedmg2,(45*Qlvl+35+.9*GetBonusAP(Source))*stagedmg3) --stage1:Initial. stage2:Detonation. stage3:Max damage
			elseif spellname == "E" then addmg = 25*Elvl+5+.4*GetBonusAP(Source)+.6*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then apdmg = 75*Rlvl+25+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Alistar" then
			if spellname == "P" then apdmg = math.max(6+GetLevel(Source)+.1*GetBonusAP(Source),(6+GetLevel(Source)+.1*GetBonusAP(Source))*3*stagedmg3)
			elseif spellname == "Q" then apdmg = 45*Qlvl+15+.5*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 55*Wlvl+.7*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Amumu" then
			if spellname == "Q" then apdmg = 50*Qlvl+30+.7*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = ((.5*Wlvl+.5+.01*GetBonusAP(Source))*GetMaxHP(target)/100)+4*Wlvl+4 --xsec
			elseif spellname == "E" then apdmg = 25*Elvl+50+.5*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.8*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Anivia" then
			if spellname == "Q" then apdmg = math.max(30*Qlvl+30+.5*GetBonusAP(Source),(30*Qlvl+30+.5*GetBonusAP(Source))*2*stagedmg3) -- x2 if it detonates. stage3: Max damage
			elseif spellname == "E" then apdmg = math.max(30*Elvl+25+.5*GetBonusAP(Source),(30*Elvl+25+.5*GetBonusAP(Source))*2*stagedmg3) -- x2  If the target has been chilled. stage3: Max damage
			elseif spellname == "R" then apdmg = 40*Rlvl+40+.25*GetBonusAP(Source) --xsec
			end
		elseif GetObjectName(Source) == "Annie" then
			if spellname == "Q" then apdmg = 35*Qlvl+45+.8*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 45*Wlvl+25+.85*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 10*Elvl+10+.2*GetBonusAP(Source) --x each attack suffered
			elseif spellname == "R" then apdmg = math.max((125*Rlvl+50+.8*GetBonusAP(Source))*stagedmg1,(10*Rlevel+10+.2*GetBonusAP(Source))*stagedmg2,(125*Rlvl+50+.8*GetBonusAP(Source))*stagedmg3) addmg = (25*Rlvl+55)*stagedmg2 --stage1:Summon Tibbers . stage2:Aura AoE xsec + 1 Tibbers Attack. stage3:Summon Tibbers
			end
		elseif GetObjectName(Source) == "Ashe" then  -- script doesn't calculate autos and therefore doesn't take Ashe's crit mechanic on slowed targets into effect
			if spellname == "Q" then addmg = (.05*Qlvl+.1)*(GetBonusDmg(Source)+GetBaseDamage(Source))  --xhit (bonus)
			elseif spellname == "W" then addmg = 15*Wlvl+5+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then apdmg = 175*Rlvl+75+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Azir" then
			if spellname == "Q" then apdmg = 20*Qlvl+45+.5*GetBonusAP(Source) --beyond the first will deal only 25% damage
			elseif spellname == "W" then apdmg = math.max(5*GetLevel(Source)+45,10*GetLevel(Source)-10)+.6*GetBonusAP(Source)--after the first deals 25% damage
			elseif spellname == "E" then apdmg = 30*Qlvl+30+.4*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 75*Rlvl+75+.6*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Bard" then
			if spellname == "P" then apdmg = 30+.3*GetBonusAP(Source)  --I don't know how to check Meep count to calculate damage
			elseif spellname == "Q" then apdmg = 45*Qlevel+35+.65*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Blitzcrank" then
			if spellname == "Q" then apdmg = 55*Qlvl+25+GetBonusAP(Source)
			elseif spellname == "E" then addmg = (GetBonusDmg(Source)+GetBaseDamage(Source)) 
			elseif spellname == "R" then apdmg = math.max((125*Rlvl+125+GetBonusAP(Source))*stagedmg1,(100*Rlvl+.2*GetBonusAP(Source))*stagedmg2,(125*Rlvl+125+GetBonusAP(Source))*stagedmg3) --stage1:the active. stage2:the passive. stage3:the active
			end
		elseif GetObjectName(Source) == "Brand" then
			if spellname == "P" then apdmg = math.max(2*GetMaxHP(target)/100,(2*GetMaxHP(target)/100)*4*stagedmg3) --xsec (4sec). stage3: Max damage
			elseif spellname == "Q" then apdmg = 40*Qlvl+40+.65*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max(45*Wlvl+30+.6*GetBonusAP(Source),(45*Wlvl+30+.6*GetBonusAP(Source))*1.25*stagedmg3) --125% for units that are ablaze. stage3: Max damage
			elseif spellname == "E" then apdmg = 35*Elvl+35+.55*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max(100*Rlvl+50+.5*GetBonusAP(Source),(100*Rlvl+50+.5*GetBonusAP(Source))*3*stagedmg3) --xbounce (can hit the same enemy up to three times). stage3: Max damage
			end
		elseif GetObjectName(Source) == "Braum" then
			if spellname == "P" then apdmg = math.max((8*GetLevel(Source)+32)*(stagedmg1+stagedmg3),(2*GetLevel(Source)+12)*stagedmg2) --stage1-stage3:Stun. stage2:bonus damage.
			elseif spellname == "Q" then apdmg = 45*Qlvl+25+.025*GetMaxHP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.6*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Caitlyn" then
			if spellname == "P" then addmg = .5*(GetBonusDmg(Source)+GetBaseDamage(Source))*1.5  --xheadshot (bonus)
			elseif spellname == "Q" then addmg = 40*Qlvl-20+1.3*(GetBonusDmg(Source)+GetBaseDamage(Source)) --deal 10% less damage for each subsequent target hit, down to a minimum of 50%
			elseif spellname == "W" then apdmg = 50*Wlvl+30+.6*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 50*Elvl+30+.8*GetBonusAP(Source)
			elseif spellname == "R" then addmg = 225*Rlvl+25+2*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Cassiopeia" then
			if spellname == "Q" then apdmg = 40*Qlvl+35+.45*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 5*Wlvl+5+.1*GetBonusAP(Source) --xsec
			elseif spellname == "E" then apdmg = 25*Elvl+30+.55*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Chogath" then
			if spellname == "Q" then apdmg = 56.25*Qlvl+23.75+GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 50*Wlvl+25+.7*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 15*Elvl+5+.3*GetBonusAP(Source)  --xhit (bonus)
			elseif spellname == "R" then dmg = 175*Rlvl+125+.7*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Corki" then
			if spellname == "P" then dmg = .1*(GetBonusDmg(Source)+GetBaseDamage(Source))  --xhit (bonus)
			elseif spellname == "Q" then apdmg = 50*Qlvl+30+.5*(GetBonusDmg(Source)+GetBaseDamage(Source))+.5*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 30*Wlvl+30+.4*GetBonusAP(Source) --xsec (2.5 sec)
			elseif spellname == "E" then addmg = 12*Elvl+8+.4*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xsec (4 sec)
			elseif spellname == "R" then apdmg = math.max(70*Rlvl+50+.3*GetBonusAP(Source)+(.1*Rlvl+.1)*(GetBonusDmg(Source)+GetBaseDamage(Source)),(70*Rlvl+50+.3*GetBonusAP(Source)+(.1*Rlvl+.1)*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.5*stagedmg3) --150% the big one. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Darius" then
			if spellname == "P" then apdmg = (-.75)*((-1)^GetLevel(Source)-2*GetLevel(Source)-13)+.3*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xstack over 5 sec
			elseif spellname == "Q" then addmg = math.max(35*Qlvl+35+.7*(GetBonusDmg(Source)+GetBaseDamage(Source)),(35*Qlvl+35+.7*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.5*stagedmg3) --150% Champions in the outer half. stage3: Max damage
			elseif spellname == "W" then addmg = .2*Wlvl*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "R" then dmg = math.max(90*Rlvl+70+.75*(GetBonusDmg(Source)+GetBaseDamage(Source)),(90*Rlvl+70+.75*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --xstack of Hemorrhage deals an additional 20% damage. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Diana" then
			if spellname == "P" then apdmg = math.max(5*GetLevel(Source)+15,10*GetLevel(Source)-10,15*GetLevel(Source)-60,20*GetLevel(Source)-125,25*GetLevel(Source)-200)+.8*GetBonusAP(Source)  -- (bonus)
			elseif spellname == "Q" then apdmg = 35*Qlvl+25+.7*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max(12*Wlvl+10+.2*GetBonusAP(Source),(12*Wlvl+10+.2*GetBonusAP(Source))*3*stagedmg3) --xOrb (3 orbs). stage3: Max damage
			elseif spellname == "R" then apdmg = 60*Rlvl+40+.6*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "DrMundo" then
			if spellname == "Q" then apdmg = math.max((2.5*Qlvl+12.5)*GetCurrentHP(target)/100,50*Qlvl+30)
			elseif spellname == "W" then apdmg = 15*Wlvl+20+.2*GetBonusAP(Source) --xsec
			end
		elseif GetObjectName(Source) == "Draven" then
			if spellname == "Q" then addmg = (.1*Qlvl+.35)*(GetBonusDmg(Source)+GetBaseDamage(Source))  --xhit (bonus)
			elseif spellname == "E" then addmg = 35*Elvl+35+.5*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then addmg = 100*Rlvl+75+1.1*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xhit (max 2 hits), deals 8% less damage for each unit hit, down to a minimum of 40%
			end
		elseif GetObjectName(Source) == "Ekko" then
		    if spellname == "P" then apdmg = 10+10*GetLevel(Source)+.8*GetBonusAP(Source)
			elseif spellname == "Q" then apdmg = (15*Qlvl+45+.1*GetBonusAP(Source))+(25*Qlvl+35+.6*GetBonusAP(Source))
			elseif spellname == "E" then apdmg = 30*Elvl+20+.2*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 150*Rlvl+50+1.3*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Elise" then
			if spellname == "P" then apdmg = 10*Rlvl+.1*GetBonusAP(Source) --xhit Spiderling Damage
			elseif spellname == "Q" then apdmg = 35*Qlvl+5+(4+.03*GetBonusAP(Source))*GetCurrentHP(target)/100
			elseif spellname == "QM" then apdmg = 40*Qlvl+20+(8+.03*GetBonusAP(Source))*(GetMaxHP(target)-GetCurrentHP(target))/100
			elseif spellname == "W" then apdmg = 50*Wlvl+25+.8*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 10*Rlvl+.3*GetBonusAP(Source)  --xhit (bonus)
			end
		elseif GetObjectName(Source) == "Evelynn" then
			if spellname == "Q" then apdmg = 10*Qlvl+30+(.05*Qlvl+.3)*GetBonusAP(Source)+(.05*Qlvl+.45)*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then addmg = 40*Elvl+30+GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)) --total
			elseif spellname == "R" then apdmg = (5*Rlvl+10+.01*GetBonusAP(Source))*GetCurrentHP(target)/100
			end
		elseif GetObjectName(Source) == "Ezreal" then
			if spellname == "Q" then addmg = 20*Qlvl+15+.4*GetBonusAP(Source)+.1*(GetBonusDmg(Source)+GetBaseDamage(Source))  -- (bonus)
			elseif spellname == "W" then apdmg = 45*Wlvl+25+.7*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 50*Elvl+25+.75*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 150*Rlvl+200+.9*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)) --deal 10% less damage for each subsequent target hit, down to a minimum of 30%
			end
		elseif GetObjectName(Source) == "FiddleSticks" then
			if spellname == "W" then apdmg = math.max(30*Wlvl+30+.45*GetBonusAP(Source),(30*Wlvl+30+.45*GetBonusAP(Source))*5*stagedmg3) --xsec (5 sec). stage3: Max damage
			elseif spellname == "E" then apdmg = math.max(20*Elvl+45+.45*GetBonusAP(Source),(20*Elvl+45+.45*GetBonusAP(Source))*3*stagedmg3) --xbounce. stage3: Max damage
			elseif spellname == "R" then apdmg = math.max(100*Rlvl+25+.45*GetBonusAP(Source),(100*Rlvl+25+.45*GetBonusAP(Source))*5*stagedmg3) --xsec (5 sec). stage3: Max damage
			end
		elseif GetObjectName(Source) == "Fiora" then
			if spellname == "Q" then addmg = 10*Qlvl+55+((15*Qlvl+40)*GetBonusDmg(Source))/100
			elseif spellname == "W" then apdmg = 40*Wlvl+50+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Fizz" then
			if spellname == "Q" then apdmg = 15*Qlvl-5+.3*GetBonusAP(Source)  -- (bonus)
			elseif spellname == "W" then apdmg = math.max(((20*Wlvl+10+.7*GetBonusAP(Source))+(Wlvl+3)*(GetMaxHP(target)-GetCurrentHP(target))/100)*(stagedmg1+stagedmg3),((10*Wlvl+10+.35*GetBonusAP(Source))+(Wlvl+3)*(GetMaxHP(target)-GetCurrentHP(target))/100)*stagedmg2)  --stage1:when its active. stage2:Passive. stage3:when its active
			elseif spellname == "E" then apdmg = 50*Elvl+20+.75*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 125*Rlvl+75+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Galio" then
			if spellname == "Q" then apdmg = 55*Qlvl+25+.6*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 45*Elvl+15+.5*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max(100*Rlvl+100+.6*GetBonusAP(Source),(100*Rlvl+100+.6*GetBonusAP(Source))*1.8*stagedmg3) --additional 5% damage for each attack suffered while channeling and capping at 40%. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Gangplank" then
			if spellname == "P" then addmg = 10+GetLevel(Source)+20+1.2*GetBonusDmg(Source)  --xstack
			elseif spellname == "Q" then addmg = 25*Qlvl-5*(GetBonusDmg(Source)+GetBaseDamage(Source))  --without counting on-hit effects
			elseif spellname == "R" then apdmg = 20*Rlvl+30+.1*GetBonusAP(Source) --xSec (7 sec)
			end
		elseif GetObjectName(Source) == "Garen" then
			if spellname == "Q" then addmg = 25*Qlvl+5+.4*(GetBonusDmg(Source)+GetBaseDamage(Source))  -- (bonus)
			elseif spellname == "E" then addmg = math.max(25*Elvl-5+(.1*Elvl+.6)*(GetBonusDmg(Source)+GetBaseDamage(Source)),(25*Elvl-5+(.1*Elvl+.6)*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2.5*stagedmg3) --xsec (2.5 sec). stage3: Max damage
			elseif spellname == "R" then apdmg = 175*Rlvl+(GetMaxHP(target)-GetCurrentHP(target))/((8-Rlvl)/2)
			end
		elseif GetObjectName(Source) == "Gnar" then
			if spellname == "Q" then addmg = 30*Qlvl-25+1.15*(GetBonusDmg(Source)+GetBaseDamage(Source)) -- 50% damage beyond the first
			elseif spellname == "QM" then addmg = 40*Qlvl-35+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "W" then apdmg = 10*Wlvl+GetBonusAP(Source)+(2*Wlvl+4)*GetMaxHP(target)/100
			elseif spellname == "WM" then addmg = 20*Wlvl+5+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then addmg = 40*Elvl-20+6*GetMaxHP(Source)/100
			elseif spellname == "EM" then addmg = 40*Elvl-20+6*GetMaxHP(Source)/100
			elseif spellname == "R" then addmg = math.max(100*Rlvl+100+.2*(GetBonusDmg(Source)+GetBaseDamage(Source))+.5*GetBonusAP(Source),(100*Rlvl+100+.2*(GetBonusDmg(Source)+GetBaseDamage(Source))+.5*GetBonusAP(Source))*1.5*stagedmg3) --x1.5 If collide with terrain. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Gragas" then
			if spellname == "Q" then apdmg = math.max(40*Qlvl+40+.6*GetBonusAP(Source),(40*Qlvl+40+.6*GetBonusAP(Source))*1.5*stagedmg3) --Damage increase by up to 50% over 2 seconds. stage3: Max damage
			elseif spellname == "W" then apdmg = 30*Wlvl-10+.3*GetBonusAP(Source)+(.01*Wlvl+.07)*GetMaxHP(target)  -- (bonus)
			elseif spellname == "E" then apdmg = 50*Elvl+30+.6*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+100+.7*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Graves" then
			if spellname == "Q" then addmg = math.max(30*Qlvl+30+.75*(GetBonusDmg(Source)+GetBaseDamage(Source)),(30*Qlvl+30+.75*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --xbullet , 50% damage xeach bullet beyond the first. stage3: Max damage
			elseif spellname == "W" then apdmg = 50*Wlvl+10+.6*GetBonusAP(Source)
			elseif spellname == "R" then addmg = math.max((150*Rlvl+100+1.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(stagedmg1+stagedmg3),(120*Rlvl+80+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg2) --stage1-3:Initial. stage2:Explosion.
			end
		elseif GetObjectName(Source) == "Hecarim" then
			if spellname == "Q" then addmg = 35*Qlvl+25+.6*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "W" then apdmg = math.max(11.25*Wlvl+8.75+.2*GetBonusAP(Source),(11.25*Wlvl+8.75+.2*GetBonusAP(Source))*4*stagedmg3) --xsec (4 sec). stage3: Max damage
			elseif spellname == "E" then addmg = math.max(35*Elvl+5+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)),(35*Elvl+5+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --Minimum , 200% Maximum (bonus). stage3: Max damage
			elseif spellname == "R" then apdmg = 100*Rlvl+50+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Heimerdinger" then
			if spellname == "Q" then apdmg = math.max((5.5*Qlvl+6.5+.15*GetBonusAP(Source))*stagedmg1,(math.max(20*Qlvl+20,25*Qlvl+5)+.55*GetBonusAP(Source))*stagedmg2,(60*Rlvl+120+.7*GetBonusAP(Source))*stagedmg3) --stage1:x Turrets attack. stage2:Beam. stage3:UPGRADE Beam
			elseif spellname == "W" then apdmg = 30*Wlvl+30+.45*GetBonusAP(Source) --x Rocket, 20% magic damage for each rocket beyond the first
			elseif spellname == "E" then apdmg = 40*Elvl+20+.6*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max((20*Rlvl+50+.3*GetBonusAP(Source))*stagedmg1,(45*Rlvl+90+.45*GetBonusAP(Source))*stagedmg2,(50*Rlvl+100+.6*GetBonusAP(Source))*stagedmg3) --stage1:x Turrets attack. stage2:x Rocket, 20% magic damage for each rocket beyond the first. stage3:x Bounce
			end
		elseif GetObjectName(Source) == "Irelia" then
			if spellname == "Q" then addmg = 30*Qlvl-10  -- (bonus)
			elseif spellname == "W" then dmg = 15*Wlvl  --xhit (bonus)
			elseif spellname == "E" then apdmg = 40*Elvl+40+.5*GetBonusAP(Source)
			elseif spellname == "R" then addmg = 40*Rlvl+40+.5*GetBonusAP(Source)+.6*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xbl(GetBonusDmg(Source)+GetBaseDamage(Source))e
			end
		elseif GetObjectName(Source) == "Janna" then
			if spellname == "Q" then apdmg = math.max((25*Qlvl+35+.35*GetBonusAP(Source))*stagedmg1,(5*Qlvl+10+.1*GetBonusAP(Source))*stagedmg2,(25*Qlvl+35+.35*GetBonusAP(Source)+(5*Qlvl+10+.1*GetBonusAP(Source))*3)*stagedmg3) --stage1:Initial. stage2:(GetBonusDmg(Source)+GetBaseDamage(Source))ditional Damage xsec (3 sec). stage3:Max damage
			elseif spellname == "W" then apdmg = 55*Wlvl+5+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "JarvanIV" then
			if spellname == "P" then addmg = math.min(.01*GetMaxHP(target),400) 
			elseif spellname == "Q" then addmg = 45*Qlvl+25+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then apdmg = 45*Elvl+15+.8*GetBonusAP(Source)
			elseif spellname == "R" then addmg = 125*Rlvl+75+1.5*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Jax" then
			if spellname == "Q" then addmg = 40*Qlvl+30+.6*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "W" then apdmg = 35*Wlvl+5+.6*GetBonusAP(Source) 
			elseif spellname == "E" then addmg = math.max(25*Elvl+25+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)),(25*Elvl+25+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --deals 20% (GetBonusDmg(Source)+GetBaseDamage(Source))ditional damage for each attack dodged to a maximum of 100%. stage3: Max damage
			elseif spellname == "R" then apdmg = 60*Rlvl+40+.7*GetBonusAP(Source)  --every third basic attack (bonus)
			end
		elseif GetObjectName(Source) == "Jayce" then
			if spellname == "Q" then addmg = math.max(50*Qlvl+20+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)),(50*Qlvl+20+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.4*stagedmg3) --If its fired through an Acceleration Gate damage will increase by 40%. stage3: Max damage
			elseif spellname == "QM" then addmg = 40*Qlvl-10+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "W" then dmg = 8*Wlvl+62 --% damage
			elseif spellname == "WM" then apdmg = math.max(15*Wlvl+10+.25*GetBonusAP(Source),(15*Wlvl+10+.25*GetBonusAP(Source))*4*stagedmg3) --xsec (4 sec). stage3: Max damage
			elseif spellname == "EM" then apdmg = (GetBonusDmg(Source)+GetBaseDamage(Source))+((2.4*Elvl+6)*GetMaxHP(target)/100)
			elseif spellname == "R" then apdmg = 40*Rlvl-20 
			end
		elseif GetObjectName(Source) == "Jinx" then
			if spellname == "Q" then addmg = .1*(GetBonusDmg(Source)+GetBaseDamage(Source)) 
			elseif spellname == "W" then addmg = 50*Wlvl-40+1.4*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then apdmg = 55*Elvl+25+GetBonusAP(Source) -- per Chomper
			elseif spellname == "R" then addmg = math.max(((50*Rlvl+75+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2+(0.05*Rlvl+0.2)*(GetMaxHP(target)-GetCurrentHP(target)))*stagedmg1,(10*Rlvl+15+.1*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg2,(0.05*Rlvl+0.2)*(GetMaxHP(target)-GetCurrentHP(target))*stagedmg3) --stage1:Maximum (after 1500 units)+(GetBonusDmg(Source)+GetBaseDamage(Source))ditional Damage. stage2:Minimum Base (Maximum = x2). stage3: (GetBonusDmg(Source)+GetBaseDamage(Source))ditional Damage
			end
		elseif GetObjectName(Source) == "Kalista" then
			if spellname == "Q" then addmg = 60*Qlvl-50+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "W" then apdmg = (2*Wlvl+10)*GetCurrentHP(target)/100
			elseif spellname == "E" then addmg = math.max((10*Elvl+10+.6*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(stagedmg1+stagedmg3),((10*Elvl+10+.6*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(5*Elvl+20)/100)*stagedmg2) --stage1,3:Base. stage2:xSpeGetArmor(Source).
			end
		elseif GetObjectName(Source) == "Karma" then
			if spellname == "Q" then apdmg = math.max((45*Qlvl+35+.6*GetBonusAP(Source))*stagedmg1,(50*Rlvl-25+.3*GetBonusAP(Source))*stagedmg2,(100*Rlvl-50+.6*GetBonusAP(Source))*stagedmg3) --stage1:Initial. stage2:Bonus (R). stage3: Detonation (R)
			elseif spellname == "W" then apdmg = 50*Wlvl+10+.9*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Karthus" then
			if spellname == "Q" then apdmg = 40*Qlvl+40+.6*GetBonusAP(Source) --50% damage if it hits multiple units
			elseif spellname == "E" then apdmg = 20*Elvl+10+.2*GetBonusAP(Source) --xsec
			elseif spellname == "R" then apdmg = 150*Rlvl+100+.6*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Kassadin" then
			if spellname == "Q" then apdmg = 25*Qlvl+45+.7*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max((25*Wlvl+15+.6*GetBonusAP(Source))*(stagedmg1+stagedmg3),(20+.1*GetBonusAP(Source))*stagedmg2)  -- stage1-3:Active. stage2: Pasive.
			elseif spellname == "E" then apdmg = 25*Elvl+55+.7*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max((20*Rlvl+60+.2*GetBonusAP(Source)+.02*GetMaxMana(Source))*(stagedmg1+stagedmg3),(10*Rlvl+30+.1*GetBonusAP(Source)+.01*GetMaxMana(Source))*stagedmg2) --stage1-3:Initial. stage2:additional xstack (4 stack).
			end
		elseif GetObjectName(Source) == "Katarina" then
			if spellname == "Q" then apdmg = math.max((25*Qlvl+35+.45*GetBonusAP(Source))*stagedmg1,(15*Qlvl+.15*GetBonusAP(Source))*stagedmg2,(40*Qlvl+35+.6*GetBonusAP(Source))*stagedmg3) --stage1:Dagger, Each subsequent hit deals 10% less damage. stage2:On-hit. stage3: Max damage
			elseif spellname == "W" then apdmg = 35*Wlvl+5+.25*GetBonusAP(Source)+.6*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then apdmg = 30*Elvl+10+.25*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max(20*Rlvl+15+.25*GetBonusAP(Source)+.375*(GetBonusDmg(Source)+GetBaseDamage(Source)),(20*Rlvl+15+.25*GetBonusAP(Source)+.375*(GetBonusDmg(Source)+GetBaseDamage(Source)))*10*stagedmg3) --xdagger (champion can be hit by a maximum of 10 daggers (2 sec)). stage3: Max damage
			end
		elseif GetObjectName(Source) == "Kayle" then
			if spellname == "Q" then apdmg = 50*Qlvl+10+.6*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then apdmg = 10*Elvl+10+.25*GetBonusAP(Source)  --xhit (bonus)
			end
		elseif GetObjectName(Source) == "Kennen" then
			if spellname == "Q" then apdmg = 40*Qlvl+35+.75*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max((30*Wlvl+35+.55*GetBonusAP(Source))*(stagedmg1+stagedmg3),(.1*Wlvl+.3)*(GetBonusDmg(Source)+GetBaseDamage(Source))*stagedmg2)  --stage1:Active. stage2:On-hit. stage3: stage1
			elseif spellname == "E" then apdmg = 40*Elvl+45+.6*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max(65*Rlvl+15+.4*GetBonusAP(Source),(65*Rlvl+15+.4*GetBonusAP(Source))*3*stagedmg3) --xbolt (max 3 bolts). stage3: Max damage
			end
		elseif GetObjectName(Source) == "Khazix" then
			if spellname == "P" then apdmg = math.max(5*GetLevel(Source)+10,10*GetLevel(Source)-5,15*GetLevel(Source)-55)-math.max(0,5*(GetLevel(Source)-13))+.5*GetBonusAP(Source)  -- (bonus)
			elseif spellname == "Q" then addmg = math.max((25*Qlvl+45+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(25*Qlvl+45+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.3*stagedmg2,((25*Qlvl+45+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.3+10*GetLevel(Source)+1.04*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg3) --stage1:Normal. stage2:to Isolated. stage3:Evolved to Isolated.
			elseif spellname == "W" then addmg = 30*Wlvl+50+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then addmg = 35*Elvl+30+.2*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "KogMaw" then
			if spellname == "P" then dmg = 100+25*GetLevel(Source)
			elseif spellname == "Q" then apdmg = 50*Qlvl+30+.5*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = (Wlvl+1+.01*GetBonusAP(Source))*GetMaxHP(target)/100  --xhit (bonus)
			elseif spellname == "E" then apdmg = 50*Elvl+10+.7*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 80*Rlvl+80+.3*GetBonusAP(Source)+.5*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Leblanc" then
			if spellname == "Q" then apdmg = math.max(25*Qlvl+30+.4*GetBonusAP(Source),(25*Qlvl+30+.4*GetBonusAP(Source))*2*stagedmg3) --Initial or mark. stage3: Max damage
			elseif spellname == "W" then apdmg = 40*Wlvl+45+.6*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = math.max(25*Qlvl+15+.5*GetBonusAP(Source),(25*Qlvl+15+.5*GetBonusAP(Source))*2*stagedmg3) --Initial or Delayed. stage3: Max damage
			elseif spellname == "R" then apdmg = math.max((100*Rlvl+.6*GetBonusAP(Source))*stagedmg1,(150*Rlvl+.9*GetBonusAP(Source))*stagedmg2,(100*Rlvl+.6*GetBonusAP(Source))*stagedmg3) --stage1:Q Initial or mark. stage2:W. stage3:E Initial or Delayed
			end
		elseif GetObjectName(Source) == "LeeSin" then
			if spellname == "Q" then addmg = math.max((30*Qlvl+20+.9*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(30*Qlvl+20+.9*(GetBonusDmg(Source)+GetBaseDamage(Source))+8*(GetMaxHP(target)-GetCurrentHP(target))/100)*stagedmg2,(60*Qlvl+40+1.8*(GetBonusDmg(Source)+GetBaseDamage(Source))+8*(GetMaxHP(target)-GetCurrentHP(target))/100)*stagedmg3) --stage1:Sonic Wave. stage2:Resonating Strike. stage3: Max damage
			elseif spellname == "E" then apdmg = 35*Qlvl+25+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then addmg = 200*Rlvl+2*(GetBonusDmg(Source)+GetBaseDamage(Source))*stagedmg1,(200*Rlvl+2*(GetBonusDmg(Source)+GetBaseDamage(Source))+(3*GetCastLevel(Source,_R)+12)*GetMaxHP(target)/100)
			end
		elseif GetObjectName(Source) == "Leona" then
			if spellname == "P" then apdmg = (-1.25)*(3*(-1)^GetLevel(Source)-6*GetLevel(Source)-7)
			elseif spellname == "Q" then apdmg = 30*Qlvl+10+.3*GetBonusAP(Source)  -- (bonus)
			elseif spellname == "W" then apdmg = 50*Wlvl+10+.4*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 40*Elvl+20+.4*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.8*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Lissandra" then
			if spellname == "Q" then apdmg = 30*Qlvl+40+.65*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 40*Wlvl+30+.4*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 45*Elvl+25+.6*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.7*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Lucian" then
			if spellname == "P" then addmg = (.3+.1*math.floor((GetLevel(Source)-1)/5))*(GetBonusDmg(Source)+GetBaseDamage(Source)) 
			elseif spellname == "Q" then addmg = 30*Qlvl+50+(15*Qlvl+45)*(GetBonusDmg(Source)+GetBaseDamage(Source))/100
			elseif spellname == "W" then apdmg = 40*Wlvl+20+.9*GetBonusAP(Source)
			elseif spellname == "R" then addmg = 10*Rlvl+30+.1*GetBonusAP(Source)+.3*(GetBonusDmg(Source)+GetBaseDamage(Source)) --per shot
			end
		elseif GetObjectName(Source) == "Lulu" then
			if spellname == "P" then apdmg = math.max(4*math.floor(GetLevel(Source)/2+.5)-1+.15*GetBonusAP(Source),(4*math.floor(GetLevel(Source)/2+.5)-1+.15*GetBonusAP(Source))*3*stagedmg3) --xbolt (3 bolts). stage: Max damage
			elseif spellname == "Q" then apdmg = 45*Qlvl+35+.5*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 30*Elvl+50+.4*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Lux" then
			if spellname == "P" then apdmg = 8*GetLevel(Source)+10+.2*GetBonusAP(Source)
			elseif spellname == "Q" then apdmg = 50*Qlvl+10+.7*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 45*Elvl+15+.6*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+200+.75*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Malphite" then
			if spellname == "Q" then apdmg = 50*Qlvl+20+.6*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 15*Wlvl+.1*GetBonusAP(Source)+.1*GetArmor(Source)
			elseif spellname == "E" then apdmg = 40*Elvl+20+.2*GetBonusAP(Source)+.3*GetArmor(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+100+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Malzahar" then
			if spellname == "P" then addmg = 20+5*GetLevel(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)) --Voidling xhit
			elseif spellname == "Q" then apdmg = 55*Qlvl+25+.8*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = (Wlvl+3+.01*GetBonusAP(Source))*GetMaxHP(target)/100 --xsec (5 sec)
			elseif spellname == "E" then apdmg = 60*Elvl+20+.8*GetBonusAP(Source) --over 4 sec
			elseif spellname == "R" then apdmg = 150*Rlvl+100+1.3*GetBonusAP(Source) --over 2.5 sec
			end
		elseif GetObjectName(Source) == "Maokai" then
			if spellname == "Q" then apdmg = 45*Qlvl+25+.4*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = (1*Wlvl+8+.03*GetBonusAP(Source))*GetMaxHP(target)/100
			elseif spellname == "E" then apdmg = math.max((20*Elvl+20+.4*GetBonusAP(Source))*stagedmg1,(40*Elvl+40+.6*GetBonusAP(Source))*stagedmg2,(60*Elvl+60+GetBonusAP(Source))*stagedmg3) --stage1:Impact. stage2:Explosion. stage3: Max damage
			elseif spellname == "R" then apdmg = 50*Rlvl+50+.5*GetBonusAP(Source)+(50*Rlvl+150)*stagedmg3 -- +2 per point of damage absorbed (max 100/150/200). stage3: Max damage
			end
		elseif GetObjectName(Source) == "MasterYi" then
			if spellname == "P" then addmg = .5*(GetBonusDmg(Source)+GetBaseDamage(Source)) 
			elseif spellname == "Q" then addmg = math.max((35*Qlvl-10+(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(.6*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg2,(35*Qlvl-10+1.6*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg3) --stage1:normal. stage2:critically strike (bonus). stage3: critically strike
			elseif spellname == "E" then dmg = 5*Elvl+5+((5/2)*Elvl+15/2)*(GetBonusDmg(Source)+GetBaseDamage(Source))/100
			end
		elseif GetObjectName(Source) == "MissFortune" then
			if spellname == "Q" then addmg = math.max((15*Qlvl+5+.85*(GetBonusDmg(Source)+GetBaseDamage(Source))+.35*GetBonusAP(Source))*(stagedmg1+stagedmg3),(30*Qlvl+10+(GetBonusDmg(Source)+GetBaseDamage(Source))+.5*GetBonusAP(Source))*stagedmg2) --stage1-stage3:1st target. stage2:2nd target.
			elseif spellname == "W" then apdmg = .06*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xstack (max 5+Rlvl stacks) (bonus)
			elseif spellname == "E" then apdmg = 55*Elvl+35+.8*GetBonusAP(Source) --over 3 seconds
			elseif spellname == "R" then addmg = math.max(25*Rlvl+25,50*Rlvl-25)+.2*GetBonusAP(Source) --xwave (8 waves) GetBonusAP(Source)plies a stack of Impure Shots
			end
		elseif GetObjectName(Source) == "Mordekaiser" then
			if spellname == "Q" then apdmg = math.max(30*Qlvl+50+.4*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)),(30*Qlvl+50+.4*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.65*stagedmg3) --If the target is alone, the ability deals 65% more damage. stage3: Max damage
			elseif spellname == "W" then apdmg = math.max(12*Wlvl+8+.15*GetBonusAP(Source),(12*Wlvl+8+.15*GetBonusAP(Source))*6*stagedmg3) --xsec (6 sec). stage3: Max damage
			elseif spellname == "E" then apdmg = 45*Elvl+25+.6*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = (5*Rlvl+19+.04*GetBonusAP(Source))*GetMaxHP(target)/100 --half Initial and half over 10 sec
			end
		elseif GetObjectName(Source) == "Morgana" then
			if spellname == "Q" then apdmg = 55*Qlvl+25+.6*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = (8*Wlvl+.11*GetBonusAP(Source))*(1+.5*(1-GetCurrentHP(target)/GetMaxHP(target))) --x 1/2 sec (5 sec)
			elseif spellname == "R" then apdmg = math.max(75*Rlvl+75+.7*GetBonusAP(Source),(75*Rlvl+75+.7*GetBonusAP(Source))*2*stagedmg3) --x2 If the target stay in range for the full duration. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Nami" then
			if spellname == "Q" then apdmg = 55*Qlvl+20+.5*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 40*Wlvl+30+.5*GetBonusAP(Source) --The percentage power of later bounces now scales. Each bounce gains 0.75% more power per 10 GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 15*Elvl+10+.2*GetBonusAP(Source)  --xhit (max 3 hits)
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.6*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Nasus" then
			if spellname == "Q" then addmg = 20*Qlvl+10  --+3 per enemy killed by Siphoning Strike (bonus)
			elseif spellname == "E" then apdmg = math.max((80*Elvl+30+1.2*GetBonusAP(Source))/5,(80*Elvl+30+1.2*GetBonusAP(Source))*stagedmg3) --xsec (5 sec). stage3: Max damage
			elseif spellname == "R" then apdmg = (Rlvl+2+.01*GetBonusAP(Source))*GetMaxHP(target)/100 --xsec (15 sec)
			end
		elseif GetObjectName(Source) == "Nautilus" then
			if spellname == "P" then addmg = 2+6*GetLevel(Source) 
			elseif spellname == "Q" then apdmg = 45*Qlvl+15+.75*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 10*Wlvl+20+.4*GetBonusAP(Source)  --xhit (bonus)
			elseif spellname == "E" then apdmg = math.max(35*Elvl+25+.5*GetBonusAP(Source),(35*Elvl+25+.5*GetBonusAP(Source))*2*stagedmg3) --xexplosions , 50% less damage from additional explosions. stage3: Max damage
			elseif spellname == "R" then apdmg = 125*Rlvl+75+.8*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Nidalee" then
			if spellname == "Q" then apdmg = 20*Qlvl+30+.4*GetBonusAP(Source) --deals 300% damage the further away the target is, gains damage from 525 units until 1300 units
			elseif spellname == "QM" then apdmg = (math.max(4,30*Rlvl-40,40*Rlvl-70)+.75*(GetBonusDmg(Source)+GetBaseDamage(Source))+.36*GetBonusAP(Source))*(1+1.5*(GetMaxHP(target)-GetCurrentHP(target))/GetMaxHP(target)) --Deals 33% increased damage against Hunted
			elseif spellname == "W" then apdmg = 40*Qlvl+.4*GetBonusAP(Source) -- over 4 sec
			elseif spellname == "WM" then apdmg = 50*Rlvl+.3*GetBonusAP(Source)
			elseif spellname == "EM" then apdmg = 60*Rlvl+10+.45*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Nocturne" then
			if spellname == "P" then addmg = .2*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "Q" then addmg = 45*Qlvl+15+.75*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then apdmg = 40*Elvl+40+GetBonusAP(Source)
			elseif spellname == "R" then addmg = 100*Rlvl+50+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Nunu" then
			if spellname == "Q" then apdmg = .01*GetMaxHP(Source) --xhit Ornery Monster Tails passive
			elseif spellname == "E" then apdmg = 37.5*Elvl+47.5+GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 250*Rlvl+375+2.5*GetBonusAP(Source) --After 3 sec
			end
		elseif GetObjectName(Source) == "Olaf" then
			if spellname == "Q" then addmg = 45*Qlvl+25+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then dmg =45*Elvl+25+.4*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Orianna" then
			if spellname == "P" then apdmg = 8*math.floor((GetLevel(Source)+2)/3)+2+0.15*GetBonusAP(Source) --xhit subsequent attack deals 20% more dmg up to 40%
			elseif spellname == "Q" then apdmg = 30*Qlvl+30+.5*GetBonusAP(Source) --10% less damage for each subsequent target hit down to a minimum of 40%
			elseif spellname == "W" then apdmg = 45*Wlvl+25+.7*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 30*Elvl+30+.3*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 75*Rlvl+75+.7*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Pantheon" then
			if spellname == "Q" then addmg = (40*Qlvl+25+1.4*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(1+math.floor((GetMaxHP(target)-GetCurrentHP(target))/(GetMaxHP(target)*0.85)))
			elseif spellname == "W" then apdmg = 25*Wlvl+25+GetBonusAP(Source)
			elseif spellname == "E" then addmg = math.max(20*Elvl+6+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)),(20*Elvl+6+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source)))*3*stagedmg3) --xStrike (3 strikes). stage3: Max damage
			elseif spellname == "R" then apdmg = 300*Rlvl+100+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Poppy" then
			if spellname == "Q" then apdmg = 25*Qlvl+.6*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source))+math.min(0.08*GetMaxHP(target),75*Qlvl) --(applies on hit) 
			elseif spellname == "E" then apdmg = math.max((25*Elvl+25+.4*GetBonusAP(Source))*stagedmg1,(50*Elvl+25+.4*GetBonusAP(Source))*stagedmg2,(75*Elvl+50+.8*GetBonusAP(Source))*stagedmg3) --stage1:initial. stage2:Collision. stage3: Max damage
			elseif spellname == "R" then dmg =10*Rlvl+10 --% Increased Damage
			end
		elseif GetObjectName(Source) == "Quinn" then
			if spellname == "P" then addmg = math.max(10*GetLevel(Source)+15,15*GetLevel(Source)-55)+.5*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "Q" then addmg = 40*Qlvl+30+.65*(GetBonusDmg(Source)+GetBaseDamage(Source))+.5*GetBonusAP(Source)
			elseif spellname == "E" then addmg = 30*Elvl+10+.2*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then addmg = (50*Rlvl+70+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(2-GetCurrentHP(target)/GetMaxHP(target))
			end
		elseif GetObjectName(Source) == "Rammus" then
			if spellname == "Q" then apdmg = 50*Qlvl+50+GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 10*Wlvl+15+.1*GetArmor(Source) --x each attack suffered
			elseif spellname == "R" then apdmg = 65*Rlvl+.3*GetBonusAP(Source) --xsec (8 sec)
			end
		elseif GetObjectName(Source) == "RekSai" then
			if spellname == "Q" then addmg = 10*Qlvl+5+.2*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "QM" then apdmg = 30*Qlvl+30+.7*GetBonusAP(Source)
			elseif spellname == "WM" then addmg = 40*Wlvl+.4*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then addmg = (.1*Elvl+.7)*(GetBonusDmg(Source)+GetBaseDamage(Source))*(1+GetCurrentMana(Source)/GetMaxMana(Source))*(1-math.floor(GetCurrentMana(Source)/GetMaxMana(Source))) dmg =(.1*Elvl+.7)*(GetBonusDmg(Source)+GetBaseDamage(Source))*2*math.floor(GetCurrentMana(Source)/GetMaxMana(Source))
			end
		elseif GetObjectName(Source) == "Renekton" then
			if spellname == "Q" then addmg = math.max(30*Qlvl+30+.8*(GetBonusDmg(Source)+GetBaseDamage(Source)),(30*Qlvl+30+.8*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.5*stagedmg3) --stage1:with 50 fury deals 50% additional damage. stage3: Max damage
			elseif spellname == "W" then addmg = math.max(20*Wlvl-10+1.5*(GetBonusDmg(Source)+GetBaseDamage(Source)),(20*Wlvl-10+1.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.5*stagedmg3) --stage1:with 50 fury deals 50% additional damage. stage3: Max damage -- on hit x2 or x3
			elseif spellname == "E" then addmg = math.max(30*Elvl+.9*(GetBonusDmg(Source)+GetBaseDamage(Source)),(30*Elvl+.9*(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.5*stagedmg3) --stage1:Slice or Dice , with 50 fury Dice deals 50% additional damage. stage3: Max damage of Dice
			elseif spellname == "R" then apdmg = math.max(30*Rlvl,60*Rlvl-60)+.1*GetBonusAP(Source) --xsec (15 sec)
			end
		elseif GetObjectName(Source) == "Rengar" then
			if spellname == "Q" then addmg = math.max((30*Qlvl+(.05*Qlvl-.05)*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(math.min(15*GetLevel(Source)+15,10*GetLevel(Source)+60)+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(stagedmg2+stagedmg3))  --stage1:Savagery. stage2-stage3:Empowered Savagery.
			elseif spellname == "W" then apdmg = math.max((30*Wlvl+20+.8*GetBonusAP(Source))*stagedmg1,(math.min(15*GetLevel(Source)+25,math.max(145,10*GetLevel(Source)+60))+.8*GetBonusAP(Source))*(stagedmg2+stagedmg3)) --stage1:Battle Roar. stage2-stage3:Empowered Battle Roar.
			elseif spellname == "E" then addmg = math.max((50*Elvl+.7*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(math.min(25*GetLevel(Source)+25,10*GetLevel(Source)+160)+.7*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(stagedmg2+stagedmg3))
			end
		elseif GetObjectName(Source) == "Riven" then
			if spellname == "P" then addmg = 5+math.max(5*math.floor((GetLevel(Source)+2)/3)+10,10*math.floor((GetLevel(Source)+2)/3)-15)*(GetBonusDmg(Source)+GetBaseDamage(Source))/100 --xcharge
			elseif spellname == "Q" then addmg = 20*Qlvl-10+(.05*Qlvl+.35)*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xstrike (3 strikes)
			elseif spellname == "W" then addmg = 30*Wlvl+20+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then addmg = math.min((40*Rlvl+40+.6*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(1+(100-25)/100*8/3),120*Rlvl+120+1.8*(GetBonusDmg(Source)+GetBaseDamage(Source)))
			end
		elseif GetObjectName(Source) == "Rumble" then
			if spellname == "P" then apdmg = 20+5*GetLevel(Source)+.25*GetBonusAP(Source)  --xhit
			elseif spellname == "Q" then apdmg = math.max(20*Qlvl+5+.33*GetBonusAP(Source),(20*Qlvl+5+.33*GetBonusAP(Source))*3*stagedmg3) --xsec (3 sec) , with 50 heat deals 150% damage. stage3: Max damage , with 50 heat deals 150% damage
			elseif spellname == "E" then apdmg = 25*Elvl+20+.4*GetBonusAP(Source) --xshoot (2 shoots) , with 50 heat deals 150% damage
			elseif spellname == "R" then apdmg = math.max(55*Rlvl+75+.3*GetBonusAP(Source),(55*Rlvl+75+.3*GetBonusAP(Source))*5*stagedmg3) --stage1: xsec (5 sec). stage3: Max damage
			end
		elseif GetObjectName(Source) == "Ryze" then
			if spellname == "Q" then apdmg = 25*Qlvl+35+.55*GetBonusAP(Source)+(0.05*Qlvl+0.15)*GetMaxMana(Source)
			elseif spellname == "W" then apdmg = 20*Wlvl+60+.4*GetBonusAP(Source)+.025*GetMaxMana(Source)
			elseif spellname == "E" then apdmg = math.max(16*Elvl+20+.2*GetBonusAP(Source)+.02*GetMaxMana(Source),(16*Elvl+34+.3*GetBonusAP(Source)+.02*GetMaxMana(Source))*4*stagedmg3) --xbounce. stage3: Max damage = initial damage + 6 * 1/2 initial damage = 4 initial damage
			end
		elseif GetObjectName(Source) == "Sejuani" then
			if spellname == "Q" then apdmg = 45*Qlvl+35+.4*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max(((.5*Wlvl+3.5+.03*GetBonusAP(Source))*GetMaxHP(target)/100)*stagedmg1,(30*Wlvl+10+.6*GetBonusAP(Source)+(.5*Wlvl+3.5)*GetMaxHP(Source)/100)/4*(stagedmg2+stagedmg3))  --stage1: bonus. stage2-3: xsec (4 sec)
			elseif spellname == "E" then apdmg = 30*Elvl+30+.5*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.8*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Shaco" then
			if spellname == "Q" then addmg = (.2*Qlvl+.2)*(GetBonusDmg(Source)+GetBaseDamage(Source)) --(bonus)
			elseif spellname == "W" then apdmg = 15*Wlvl+20+.2*GetBonusAP(Source) --xhit
			elseif spellname == "E" then apdmg = 40*Elvl+10+GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then apdmg = 150*Rlvl+150+GetBonusAP(Source) --The clone deals 75% of Shaco's damage
			end
		elseif GetObjectName(Source) == "Shen" then
			if spellname == "P" then apdmg = 4+4*GetLevel(Source)+(GetMaxHP(Source)-(428+85*GetLevel(Source)))*.1  --(bonus)
			elseif spellname == "Q" then apdmg = 40*Qlvl+20+.6*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 35*Elvl+15+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Shyvana" then
			if spellname == "Q" then addmg = (.05*Qlvl+.75)*(GetBonusDmg(Source)+GetBaseDamage(Source))  --Second Strike
			elseif spellname == "W" then apdmg = 13*Wlvl+7+.2*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xsec (3 sec + 4 extra sec)
			elseif spellname == "E" then apdmg = math.max((40*Elvl+20+.6*GetBonusAP(Source))*(stagedmg1+stagedmg3),(2.5*GetMaxHP(target)/100)*stagedmg2) --stage1-3:Active. stage2:Each autoattack that hits debuffed targets
			elseif spellname == "R" then apdmg = 125*Rlvl+50+.7*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Singed" then
			if spellname == "Q" then apdmg = 12*Qlvl+10+.3*GetBonusAP(Source) --xsec
			elseif spellname == "E" then apdmg = 15*Elvl+35+.75*GetBonusAP(Source)+((0.5*Elvl+5.5)*GetMaxHP(target)/100)
			end
		elseif GetObjectName(Source) == "Sion" then
			if spellname == "P" then addmg = 10*GetMaxHP(target)/100 
			elseif spellname == "Q" then addmg = 20*Qlvl+.65*(GetBonusDmg(Source)+GetBaseDamage(Source)) --Minimum, x3 over 2 sec
			elseif spellname == "W" then apdmg = 25*Wlvl+15+.4*GetBonusAP(Source)+(Wlvl+9)*GetMaxHP(target)/100
			elseif spellname == "E" then apdmg = math.max(35*Wlvl+35+.4*GetBonusAP(Source),(35*Wlvl+35+.4*GetBonusAP(Source))*1.3*stagedmg3) --Minimum. stage3: x1.3 if hits a minion
			elseif spellname == "R" then addmg = 150*Qlvl+.4*(GetBonusDmg(Source)+GetBaseDamage(Source)) --Minimum, x2 over 1.75 sec
			end
		elseif GetObjectName(Source) == "Sivir" then
			if spellname == "Q" then addmg = 20*Qlvl+5+.5*GetBonusAP(Source)+(.1*Qlvl+.6)*(GetBonusDmg(Source)+GetBaseDamage(Source)) --x2 , 15% reduced damage to each subsequent target
			elseif spellname == "W" then addmg = (.05*Wlvl+.45)*(GetBonusDmg(Source)+GetBaseDamage(Source))*stagedmg2  --stage1:bonus to attack target. stage2: Bounce Damage
			end
		elseif GetObjectName(Source) == "Skarner" then
			if spellname == "P" then apdmg = 5*GetLevel(Source)+15 
			elseif spellname == "Q" then addmg = (10*Qlvl+10+.4*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(stagedmg1+stagedmg3) Qapdmg = (10*Qlvl+10+.2*GetBonusAP(Source))*(stagedmg2+stagedmg3) --stage1:basic. stage2: chGetArmor(Source)ge bonus. stage2: total
			elseif spellname == "E" then apdmg = 35*Elvl+5+.4*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max((100*Rlvl+100+GetBonusAP(Source))*(stagedmg1+stagedmg3),(25*Rlvl+25)*stagedmg2)--stage1-3:basic. stage2: per stacks of Crystal Venom.
			end
		elseif GetObjectName(Source) == "Sona" then
			if spellname == "P" then apdmg = (math.max(7*GetLevel(Source)+6,8*GetLevel(Source)+3,9*GetLevel(Source)-2,10*GetLevel(Source)-8,15*GetLevel(Source)-78)+.2*GetBonusAP(Source))*(1+stagedmg1)  --stage1: Staccato. stage2:Diminuendo or Tempo
			elseif spellname == "Q" then apdmg = math.max((40*Qlvl+.5*GetBonusAP(Source))*(stagedmg1+stagedmg3),(10*Qlvl+30+.2*GetBonusAP(Source)+10*Rlvl)*stagedmg2) --stage1-3: Active. stage2:On-hit
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Soraka" then
			if spellname == "Q" then apdmg = math.max(40*Qlvl+30+.35*GetBonusAP(Source),(40*Qlvl+30+.35*GetBonusAP(Source))*1.5*stagedmg3) --stage1: border. stage3: center
			elseif spellname == "E" then apdmg = 40*Elvl+30+.4*GetBonusAP(Source) --Initial or SecondGetArmor(Source)y
			end
		elseif GetObjectName(Source) == "Swain" then
			if spellname == "Q" then apdmg = math.max(15*Qlvl+10+.3*GetBonusAP(Source),(15*Qlvl+10+.3*GetBonusAP(Source))*3*stagedmg3) --xsec (3 sec). stage3: Max damage
			elseif spellname == "W" then apdmg = 40*Wlvl+40+.7*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = (40*Elvl+35+.8*GetBonusAP(Source))*(stagedmg1+stagedmg3) dmg =(3*Elvl+5)*stagedmg2 --stage1-3:Active.  stage2:% Extra Damage.
			elseif spellname == "R" then apdmg = 20*Rlvl+30+.2*GetBonusAP(Source) --xstrike (1 strike x sec)
			end
		elseif GetObjectName(Source) == "Syndra" then
			if spellname == "Q" then apdmg = math.max(45*Qlvl+5+.6*GetBonusAP(Source),(45*Qlvl+5+.6*GetBonusAP(Source))*1.15*(Qlvl-4))
			elseif spellname == "W" then apdmg = 40*Wlvl+40+.7*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 45*Elvl+25+.4*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max(45*Rlvl+45+.2*GetBonusAP(Source),(45*Rlvl+45+.2*GetBonusAP(Source))*7*stagedmg3) --stage1:xSphere (Minimum 3). stage3:7 Spheres
			end
		elseif GetObjectName(Source) == "TahmKench" then
		    if spellname == "Q" then apdmg = 45*Qlvl+35+.7*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 50*Wlvl+50+.6*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Talon" then
			if spellname == "Q" then addmg = 40*Qlvl+1.3*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "W" then addmg = math.max(25*Wlvl+5+.6*(GetBonusDmg(Source)+GetBaseDamage(Source)),(25*Wlvl+5+.6*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --x2 if the target is hit twice. stage3: Max damage
			elseif spellname == "E" then dmg =3*Elvl --% Damage Amplification
			elseif spellname == "R" then addmg = math.max(50*Rlvl+70+.75*(GetBonusDmg(Source)+GetBaseDamage(Source)),(50*Rlvl+70+.75*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --x2 if the target is hit twice. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Taric" then
			if spellname == "P" then apdmg = .2*GetArmor(Source)  --(bonus)
			elseif spellname == "W" then apdmg = 40*Wlvl+.2*GetArmor(Source)
			elseif spellname == "E" then apdmg = math.max(30*Elvl+10+.2*GetBonusAP(Source),(30*Elvl+10+.2*GetBonusAP(Source))*2*stagedmg3) --min (lower damage the farther the target is) up to 200%. stage3: Max damage
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Teemo" then
			if spellname == "Q" then apdmg = 45*Qlvl+35+.8*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = math.max((10*Elvl+.3*GetBonusAP(Source))*stagedmg1,(6*Elvl+.1*GetBonusAP(Source))*stagedmg2,(34*Elvl+.7*GetBonusAP(Source))*stagedmg3) --stage1:Hit (bonus). stage2:poison xsec (4 sec). stage3:Hit+poison for 4 sec
			elseif spellname == "R" then apdmg = 125*Rlvl+75+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Thresh" then
			if spellname == "Q" then apdmg = 40*Qlvl+40+.5*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = math.max((40*Elvl+25+.4*GetBonusAP(Source))*(stagedmg1+stagedmg3),((.3*Qlvl+.5)*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg2) --stage1:Active. stage2:Passive (+ Souls). stage3:stage1
			elseif spellname == "R" then apdmg = 150*Rlvl+100+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Tristana" then
			if spellname == "W" then apdmg = 25*Wlvl+55+.5*GetBonusAP(Source), (25*Wlvl+55+.5*GetBonusAP(Source))*2 --max damage, jumping onto max stack explosive charge
			elseif spellname == "E" then addmg = 10*Elvl+50+(.15*Elvl+.35)*(GetBonusDmg(Source)+GetBaseDamage(Source))+.5*GetBonusAP(Source),(10*Elvl+50+(.15*Elvl+.35)*(GetBonusDmg(Source)+GetBaseDamage(Source))+.5*GetBonusAP(Source))*2.2*stagedmg3	--stage3: Max damage/4 auto attack stacks
			elseif spellname == "R" then apdmg = 100*Rlvl+200+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Trundle" then
			if spellname == "Q" then addmg = 20*Qlvl+(5*Qlvl+95)*(GetBonusDmg(Source)+GetBaseDamage(Source))/100  --(bonus)
			elseif spellname == "R" then apdmg = (2*Rlvl+18+.02*GetBonusAP(Source))*GetMaxHP(target)/100 --over 4 sec
			end
		elseif GetObjectName(Source) == "Tryndamere" then
			if spellname == "E" then addmg = 30*Elvl+40+GetBonusAP(Source)+1.2*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "TwistedFate" then
			if spellname == "Q" then apdmg = 50*Qlvl+10+.65*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max((7.5*Wlvl+7.5+.5*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(15*Wlvl+15+.5*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg2,(20*Wlvl+20+.5*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg3) --stage1:Gold Card.  stage2:Red Card.  stage3:Blue Card
			elseif spellname == "E" then apdmg = 25*Elvl+30+.5*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Twitch" then
			if spellname == "P" then dmg = math.floor((GetLevel(Source)+3)/4 + 1) --xstack xsec (6 stack 6 sec)
			elseif spellname == "E" then addmg = math.max((5*Elvl+10+.2*GetBonusAP(Source)+.25*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(15*Elvl+5)*stagedmg2,((5*Elvl+10+.2*GetBonusAP(Source)+.25*(GetBonusDmg(Source)+GetBaseDamage(Source)))*6+15*Elvl+5)*stagedmg3) --stage1:xstack (6 stack). stage2:Base. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Udyr" then
			if spellname == "Q" then addmg = math.max((50*Qlvl-20+(.1*Qlvl+1.1)*(GetBonusDmg(Source)+GetBaseDamage(Source)))*(stagedmg2+stagedmg3),(.15*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1)  --stage1:persistent effect. stage2:(bonus). stage3:stage2
			elseif spellname == "W" then 
			elseif spellname == "E" then 
			elseif spellname == "R" then apdmg = math.max((40*Rlvl+.45*GetBonusAP(Source))*stagedmg2,(10*Rlvl+5+.25*GetBonusAP(Source))*stagedmg3)  --stage1:0. stage2:xThird Attack. stage3:x wave (5 waves)
			end
		elseif GetObjectName(Source) == "Urgot" then
			if spellname == "Q" then addmg = 30*Qlvl-20+.85*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "E" then addmg = 55*Elvl+20+.6*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Varus" then
			if spellname == "Q" then addmg = math.max(.625*(55*Qlvl-40+1.6*(GetBonusDmg(Source)+GetBaseDamage(Source))),(55*Qlvl-40+1.6*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg3) --stage1:min. stage3:max. reduced by 15% per enemy hit (minimum 33%)
			elseif spellname == "W" then apdmg = math.max((4*Wlvl+6+.25*GetBonusAP(Source))*stagedmg1,((.0075*Wlvl+.0125+.02*GetBonusAP(Source))*GetMaxHP(target)/100)*stagedmg2,((.0075*Wlvl+.0125+.02*GetBonusAP(Source))*GetMaxHP(target)/100)*3*stagedmg3) --stage1:xhit. stage2:xstack (3 stacks). stage3: 3 stacks
			elseif spellname == "E" then addmg = 35*Elvl+30+.6*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then apdmg = 100*Rlvl+50+GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Vayne" then
			if spellname == "Q" then addmg = (.05*Qlvl+.25)*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "W" then dmg = 10*Wlvl+10+((1*Wlvl+3)*GetMaxHP(target)/100)
			elseif spellname == "E" then addmg = math.max(35*Elvl+10+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)),(35*Elvl+10+.5*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --x2 If they collide with terrain. stage3: Max damage
			elseif spellname == "R" then 
			end
		elseif GetObjectName(Source) == "Veigar" then
			if spellname == "Q" then apdmg = 45*Qlvl+35+.6*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 50*Wlvl+70+GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 125*Rlvl+125+GetBonusAP(Source)+.8*GetBonusGetBonusAP(Source)(target)
			end
		elseif GetObjectName(Source) == "Velkoz" then
			if spellname == "P" then dmg = 10*GetLevel(Source)+25
			elseif spellname == "Q" then apdmg = 40*Qlvl+40+.6*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max(20*Wlvl+10+.25*GetBonusAP(Source),(20*Wlvl+10+.25*GetBonusAP(Source))*1.5*stagedmg2) --stage1-3:Initial. stage2:Detonation.
			elseif spellname == "E" then apdmg = 30*Elvl+40+.5*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 20*Rlvl+30+.6*GetBonusAP(Source) --every 0.25 sec (2.5 sec), Organic Deconstruction every 0.5 sec
			end
		elseif GetObjectName(Source) == "Vi" then
			if spellname == "Q" then addmg = math.max(25*Qlvl+25+.8*(GetBonusDmg(Source)+GetBaseDamage(Source)),(25*Qlvl+25+.8*(GetBonusDmg(Source)+GetBaseDamage(Source)))*2*stagedmg3) --x2 If charging up to 1.5 seconds. stage3: Max damage
			elseif spellname == "W" then addmg = ((3/2)*Wlvl+5/2+(1/35)*(GetBonusDmg(Source)+GetBaseDamage(Source)))*GetCurrentHP(target)/100
			elseif spellname == "E" then addmg = 15*Elvl-10+.15*(GetBonusDmg(Source)+GetBaseDamage(Source))+.7*GetBonusAP(Source)  --(Bonus)
			elseif spellname == "R" then addmg = 150*Rlvl+1.4*(GetBonusDmg(Source)+GetBaseDamage(Source)) --deals 75% damage to enemies in her way
			end
		elseif GetObjectName(Source) == "Viktor" then
			if spellname == "Q" then apdmg = math.max((20*Qlvl+20+.2*GetBonusAP(Source))*(stagedmg1+stagedmg3),(math.max(5*GetLevel(Source)+15,10*GetLevel(Source)-30,20*GetLevel(Source)-150)+.5*GetBonusAP(Source)+(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg2) --stage1-3:Initial. stage2:basic attack.
			elseif spellname == "E" then apdmg = math.max(45*Elvl+25+.7*GetBonusAP(Source),(45*Elvl+25+.7*GetBonusAP(Source))*1.4*stagedmg3) --Initial or Aftershock. stage3: Max damage
			elseif spellname == "R" then apdmg = math.max((100*Rlvl+50+.55*GetBonusAP(Source))*stagedmg1,(15*Rlvl+.1*GetBonusAP(Source))*stagedmg2,(100*Rlvl+50+.55*GetBonusAP(Source)+(15*Rlvl+.1*GetBonusAP(Source))*7)*stagedmg3) --stage1:initial. stage2: xsec (7 sec). stage3: Max damage
			end
		elseif GetObjectName(Source) == "Vladimir" then
			if spellname == "Q" then apdmg = 35*Qlvl+55+.6*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 55*Wlvl+25+(GetMaxHP(Source)-(400+85*GetLevel(Source)))*.15 --(2 sec)
			elseif spellname == "E" then apdmg = math.max((25*Elvl+35+.45*GetBonusAP(Source))*stagedmg1,((25*Elvl+35)*0.25)*stagedmg2,((25*Elvl+35)*2+.45*GetBonusAP(Source))*stagedmg3) --stage1:25% more base damage x stack. stage2:+x stack. stage3: Max damage
			elseif spellname == "R" then apdmg = 100*Rlvl+50+.7*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Volibear" then
			if spellname == "Q" then addmg = 30*Qlvl  --(bonus)
			elseif spellname == "W" then addmg = ((Wlvl-1)*45+80+(GetMaxHP(Source)-(440+GetLevel(Source)*86))*.15)*(1+(GetMaxHP(target)-GetCurrentHP(target))/GetMaxHP(target))
			elseif spellname == "E" then apdmg = 45*Elvl+15+.6*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 80*Rlvl-5+.3*GetBonusAP(Source)  --xhit
			end
		elseif GetObjectName(Source) == "Warwick" then
			if spellname == "P" then apdmg = math.max(.5*GetLevel(Source)+2.5,(.5*GetLevel(Source)+2.5)*3*stagedmg3) --xstack (3 stacks). stage3: Max damage
			elseif spellname == "Q" then apdmg = 50*Qlvl+25+GetBonusAP(Source)+((2*Qlvl+6)*GetMaxHP(target)/100)
			elseif spellname == "R" then apdmg = math.max((100*Rlvl+50+2*(GetBonusDmg(Source)+GetBaseDamage(Source)))/5,(100*Rlvl+50+2*(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg3) --xstrike (5 strikes) , without counting on-hit effects. stage3: Max damage
			end
		elseif GetObjectName(Source) == "MonkeyKing" then
			if spellname == "Q" then addmg = 30*Qlvl+.1*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "W" then apdmg = 45*Wlvl+25+.6*GetBonusAP(Source)
			elseif spellname == "E" then addmg = 45*Elvl+15+.8*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then addmg = math.max(90*Rlvl-70+1.1*(GetBonusDmg(Source)+GetBaseDamage(Source)),(90*Rlvl-70+1.1*(GetBonusDmg(Source)+GetBaseDamage(Source)))*4*stagedmg3) --xsec (4 sec). stage3: Max damage
			end
		elseif GetObjectName(Source) == "Xerath" then
			if spellname == "Q" then apdmg = 40*Qlvl+40+.75*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = math.max((30*Qlvl+30+.6*GetBonusAP(Source))*1.5*(stagedmg1+stagedmg3),(30*Qlvl+30+.6*GetBonusAP(Source))*stagedmg2) --stage1,3: Center. stage2: Border
			elseif spellname == "E" then apdmg = 30*Elvl+50+.45*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 55*Rlvl+135+.43*GetBonusAP(Source) --xcast (3 cast)
			end
		elseif GetObjectName(Source) == "XinZhao" then
			if spellname == "Q" then addmg = 15*Qlvl+.2*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus x hit)
			elseif spellname == "E" then apdmg = 40*Elvl+30+.6*GetBonusAP(Source)
			elseif spellname == "R" then addmg = 100*Rlvl-25+(GetBonusDmg(Source)+GetBaseDamage(Source))+15*GetCurrentHP(target)/100
			end
		elseif GetObjectName(Source) == "Yasuo" then
			if spellname == "Q" then addmg = 20*Qlvl  -- can critically strike, dealing X% ad
			elseif spellname == "E" then apdmg = 20*Elvl+50+.6*GetBonusAP(Source) --Each cast increases the next dash's base damage by 25%, up to 50% bonus damage
			elseif spellname == "R" then addmg = 100*Rlvl+100+1.5*(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Yorick" then
			if spellname == "P" then addmg = .35*(GetBonusDmg(Source)+GetBaseDamage(Source)) --xhit of ghouls
			elseif spellname == "Q" then addmg = 30*Qlvl+.2*(GetBonusDmg(Source)+GetBaseDamage(Source))  --(bonus)
			elseif spellname == "W" then apdmg = 35*Wlvl+25+GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 30*Elvl+25+(GetBonusDmg(Source)+GetBaseDamage(Source))
			end
		elseif GetObjectName(Source) == "Zac" then
			if spellname == "Q" then apdmg = 40*Qlvl+30+.5*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 15*Wlvl+25+((1*Wlvl+3+.02*GetBonusAP(Source))*GetMaxHP(target)/100)
			elseif spellname == "E" then apdmg = 50*Elvl+30+.7*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = math.max(70*Rlvl+70+.4*GetBonusAP(Source),(70*Rlvl+70+.4*GetBonusAP(Source))*2.5*stagedmg3) -- stage1:Enemies hit more than once take half damage. stage3: Max damage
			end
		elseif GetObjectName(Source) == "Zed" then
			if spellname == "P" then apdmg = (6+2*(math.floor((GetLevel(Source)-1)/6)))*GetMaxHP(target)/100 
			elseif spellname == "Q" then addmg = math.max((40*Qlvl+35+(GetBonusDmg(Source)+GetBaseDamage(Source)))*stagedmg1,(40*Qlvl+35+(GetBonusDmg(Source)+GetBaseDamage(Source)))*.6*stagedmg2,(40*Qlvl+35+(GetBonusDmg(Source)+GetBaseDamage(Source)))*1.5*stagedmg3)  --stage1:multiple shurikens deal 50% damage. stage2:Secondary targets. stage3: Max damage
			elseif spellname == "E" then addmg = 30*Elvl+30+.8*(GetBonusDmg(Source)+GetBaseDamage(Source))
			elseif spellname == "R" then addmg = (GetBonusDmg(Source)+GetBaseDamage(Source))*(stagedmg1+stagedmg3) dmg =(15*Rlvl+5)*stagedmg2 --stage1-3:100% of Zed attack damage. stage2:% of damage dealt.
			end
		elseif GetObjectName(Source) == "Ziggs" then
			if spellname == "P" then apdmg = math.max(4*GetLevel(Source)+16,8*GetLevel(Source)-8,12*GetLevel(Source)-56)+(.2+.05*math.floor((GetLevel(Source)+5)/6))*GetBonusAP(Source) 
			elseif spellname == "Q" then apdmg = 45*Qlvl+30+.65*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 35*Wlvl+35+.35*GetBonusAP(Source)
			elseif spellname == "E" then apdmg = 25*Elvl+15+.3*GetBonusAP(Source) --xmine , 40% damage from additional mines
			elseif spellname == "R" then apdmg = 125*Rlvl+125+.9*GetBonusAP(Source) --enemies away from the primGetArmor(Source)y blast zone will take 80% damage
			end
		elseif GetObjectName(Source) == "Zilean" then
			if spellname == "Q" then apdmg = 40*Qlvl+35+.9*GetBonusAP(Source)
			end
		elseif GetObjectName(Source) == "Zyra" then
			if spellname == "P" then dmg = 80+20*GetLevel(Source)
			elseif spellname == "Q" then apdmg = 35*Qlvl+35+.65*GetBonusAP(Source)
			elseif spellname == "W" then apdmg = 23+6.5*GetLevel(Source)+.2*GetBonusAP(Source) --xstrike Extra plants striking the same target deal 50% less damage
			elseif spellname == "E" then apdmg = 35*Elvl+25+.5*GetBonusAP(Source)
			elseif spellname == "R" then apdmg = 85*Rlvl+95+.7*GetBonusAP(Source)
			end
		end
		
		if apdmg > 0 then apdmg = CalcDamage(Source, target, 0, apdmg) end
		if addmg > 0 then addmg = CalcDamage(Source, target, addmg) end
		TrueDmg = apdmg+addmg+dmg
        else
               PrintChat("Error spellDmg "..GetObjectName(Source).." "..spellname)
                TrueDmg = 0
        end
        return TrueDmg
end
