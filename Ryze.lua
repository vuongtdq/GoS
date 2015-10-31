if GetObjectName(GetMyHero()) ~= "Ryze" then return end
	
if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end

local RyzeMenu = MenuConfig("Ryze", "Ryze")
RyzeMenu:Menu("Combo", "Combo")
RyzeMenu.Combo:Boolean("Q", "Use Q", true)
RyzeMenu.Combo:Boolean("W", "Use W", true)
RyzeMenu.Combo:Boolean("E", "Use E", true)
RyzeMenu.Combo:Boolean("R", "Use R", true)

RyzeMenu:Menu("Harass", "Harass")
RyzeMenu.Harass:Boolean("Q", "Use Q", true)
RyzeMenu.Harass:Boolean("W", "Use W", true)
RyzeMenu.Harass:Boolean("E", "Use E", true)
RyzeMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

RyzeMenu:Menu("Killsteal", "Killsteal")
RyzeMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
RyzeMenu.Killsteal:Boolean("W", "Killsteal with W", true)
RyzeMenu.Killsteal:Boolean("E", "Killsteal with E", true)

RyzeMenu:Menu("Misc", "Misc")
RyzeMenu.Misc:Boolean("Autoignite", "Auto Ignite", true)
RyzeMenu.Misc:Boolean("Autolvl", "Auto level", true)
RyzeMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E", "Q-E-W"})

RyzeMenu:Menu("JungleClear", "JungleClear")
RyzeMenu.JungleClear:Boolean("Q", "Use Q", true)
RyzeMenu.JungleClear:Boolean("W", "Use W", true)
RyzeMenu.JungleClear:Boolean("E", "Use E", true)
RyzeMenu.JungleClear:Boolean("R", "Use R", false)

RyzeMenu:Menu("Drawings", "Drawings")
RyzeMenu.Drawings:Boolean("Q", "Draw Q Range", true)
RyzeMenu.Drawings:Boolean("W", "Draw W Range", true)
RyzeMenu.Drawings:Boolean("E", "Draw E Range", true)
RyzeMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

OnDraw(function(myHero)
local col = RyzeMenu.Drawings.color:Value()
if RyzeMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),900,1,0,col) end
if RyzeMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),600,1,0,col) end
if RyzeMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),600,1,0,col) end
end)
	
OnTick(function(myHero)
  if IOW:Mode() == "Combo" then
	
        local target = GetCurrentTarget()
	local Q2Pred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,900,55,false,true)

	if CanUseSpell(myHero, _R) == READY and ValidTarget(target, 700) and RyzeMenu.Combo.R:Value() and GotBuff(myHero, "ryzepassivestack") == 4 then
        CastSpell(_R)
	end  
	  
	if CanUseSpell(myHero, _W) == READY and ValidTarget(target, 600) and RyzeMenu.Combo.W:Value() then
        CastTargetSpell(target, _W)
	end
		
        if CanUseSpell(myHero, _E) == READY and ValidTarget(target, 600) and RyzeMenu.Combo.E:Value() then
        CastTargetSpell(target, _E)
	end
	
	if CanUseSpell(myHero, _Q) == READY and Q2Pred.HitChance == 1 and GotBuff(myHero, "ryzepassivestack") > 3 or GotBuff(myHero, "ryzepassivecharged") > 0 and RyzeMenu.Combo.Q:Value() and ValidTarget(target, 900) then
	CastSkillShot(_Q,Q2Pred.PredPos.x,Q2Pred.PredPos.y,Q2Pred.PredPos.z)
        elseif CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and RyzeMenu.Combo.Q:Value() and ValidTarget(target, 900) then
        Cast(_Q,target)
	end				
		
  end

  if IOW:Mode() == "Harass" then
	
	local target = GetCurrentTarget()
	local QPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,900,55,true,true)
	local Q2Pred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1400,250,900,55,false,true)
	 	  
	if CanUseSpell(myHero, _W) == READY and ValidTarget(target, 600) and RyzeMenu.Harass.W:Value() then
        CastTargetSpell(target, _W)
	end
      
	if CanUseSpell(myHero, _E) == READY and ValidTarget(target, 600) and RyzeMenu.Harass.E:Value() then
        CastTargetSpell(target, _E)
	end
	
	if CanUseSpell(myHero, _Q) == READY and Q2Pred.Hitchance == 1 and RyzeMenu.Harass.Q:Value() and ValidTarget(target, 900) then
	CastSkillShot(_Q,Q2Pred.PredPos.x,Q2Pred.PredPos.y,Q2Pred.PredPos.z)
        elseif CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and RyzeMenu.Harass.Q:Value() and ValidTarget(target, 900) then
	CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
	end
	
  end 

	for i,enemy in pairs(GetEnemyHeroes()) do
	
	        local QPred = GetPredictionForPlayer(myHeroPos(),enemy,GetMoveSpeed(enemy),1400,250,900,55,true,true)
		local ExtraDmg = 0
		if GotBuff(myHero, "itemmagicshankcharge") == 100 then
		ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
		end
		
		if Ignite and RyzeMenu.Misc.Autoignite:Value() then
                  if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
                  CastTargetSpell(enemy, Ignite)
                  end
                end
		
		if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and ValidTarget(enemy, 900) and RyzeMenu.Killsteal.Q:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 25*GetCastLevel(myHero,_Q)+35+.55*GetBonusAP(myHero)+0.015*GetMaxMana(myHero)+0.005*GetCastLevel(myHero,_Q)*GetMaxMana(myHero) + ExtraDmg) then 
		CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		elseif CanUseSpell(myHero, _W) == READY and ValidTarget(enemy, 600) and RyzeMenu.Killsteal.W:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 60+20*GetCastLevel(myHero,_W)+0.4*GetBonusAP(myHero)+0.025*GetMaxMana(myHero) + ExtraDmg) then
		CastTargetSpell(enemy, _W)
		elseif CanUseSpell(myHero, _E) == READY and ValidTarget(enemy, 600) and RyzeMenu.Killsteal.E:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 20+16*GetCastLevel(myHero,_E)+0.2*GetBonusAP(myHero)+0.02*GetMaxMana(myHero) + ExtraDmg) then
		CastTargetSpell(enemy, _E)
		end
		
	end

for _,mob in pairs(minionManager.objects) do
		
        if GetTeam(mob) == 300 and IOW:Mode() == "LaneClear" then
		local mobPos = GetOrigin(mob)
		
		if CanUseSpell(myHero, _R) == READY and RyzeMenu.JungleClear.R:Value() and GotBuff(myHero, "ryzepassivestack") == 4 and ValidTarget(mob, 900) then
		CastSpell(_R)
		end
		
		if CanUseSpell(myHero, _W) == READY and RyzeMenu.JungleClear.W:Value() and ValidTarget(mob, 600) then
		CastTargetSpell(mob, _W)
		end
		
		if CanUseSpell(myHero, _Q) == READY and RyzeMenu.JungleClear.Q:Value() and ValidTarget(mob, 900) then
		CastSkillShot(_Q, mobPos.x, mobPos.y, mobPos.z)
		end
		
	        if CanUseSpell(myHero, _E) == READY and RyzeMenu.JungleClear.E:Value() and ValidTarget(mob, 600) then
		CastTargetSpell(mob, _E)
		end
		
        end
end

if RyzeMenu.Misc.Autolvl:Value() then
   if RyzeMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
   elseif RyzeMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
   elseif RyzeMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
   end
LevelSpell(leveltable[GetLevel(myHero)])
end

end)	

AddGapcloseEvent(_W, 600, true)
