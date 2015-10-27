--[[ TODO :
-E Humanizer
-more R logic
-R Anti-Gapclose/Interrupt
]]

if GetObjectName(GetMyHero()) ~= "Cassiopeia" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end

local CassiopeiaMenu = MenuConfig("Cassiopeia", "Cassiopeia")
CassiopeiaMenu:Menu("Combo", "Combo")
CassiopeiaMenu.Combo:Boolean("Q", "Use Q", true)
CassiopeiaMenu.Combo:Boolean("W", "Use W", true)
CassiopeiaMenu.Combo:Boolean("E", "Use E", true)
CassiopeiaMenu.Combo:Boolean("R", "Use R", true)

CassiopeiaMenu:Menu("Harass", "Harass")
CassiopeiaMenu.Harass:Boolean("Q", "Use Q", true)
CassiopeiaMenu.Harass:Boolean("W", "Use W", true)
CassiopeiaMenu.Harass:Boolean("E", "Use E", true)

CassiopeiaMenu:Menu("Killsteal", "Killsteal")
CassiopeiaMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
CassiopeiaMenu.Killsteal:Boolean("W", "Killsteal with W", true)
CassiopeiaMenu.Killsteal:Boolean("E", "Killsteal with E", true)

CassiopeiaMenu:Menu("Misc", "Misc")
if Ignite ~= nil then CassiopeiaMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
CassiopeiaMenu.Misc:Boolean("Autolvl", "Auto level", true)
CassiopeiaMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"E-Q-W", "Q-E-W", "W-E-Q"})

CassiopeiaMenu:Menu("Farm", "Farm")
CassiopeiaMenu.Misc:Boolean("AutoE", "Auto E if pois", true)
CassiopeiaMenu.Farm:Menu("LastHit2", "LastHit with E")
CassiopeiaMenu.Farm.LastHit2:Boolean("EX", "Enabled", true)
CassiopeiaMenu.Farm.LastHit2:Boolean("EXP", "Only if pois", true)
CassiopeiaMenu.Farm:Menu("LaneClear", "LaneClear")
CassiopeiaMenu.Farm.LaneClear:Boolean("Q", "Use Q", true)
CassiopeiaMenu.Farm.LaneClear:Boolean("W", "Use W", true)
CassiopeiaMenu.Farm.LaneClear:Boolean("E", "Use E", true)
CassiopeiaMenu.Farm.LaneClear:Slider("Mana", "Min Mana %", 30, 1, 100, 1)

CassiopeiaMenu:Menu("JungleClear", "JungleClear")
CassiopeiaMenu.JungleClear:Boolean("Q", "Use Q", true)
CassiopeiaMenu.JungleClear:Boolean("W", "Use W", true)
CassiopeiaMenu.JungleClear:Boolean("E", "Use E", true)
CassiopeiaMenu.JungleClear:Slider("Mana", "Min Mana %", 30, 1, 100, 1)

CassiopeiaMenu:Menu("Drawings", "Drawings")
CassiopeiaMenu.Drawings:Boolean("Q", "Draw Q Range", true)
CassiopeiaMenu.Drawings:Boolean("W", "Draw W Range", true)
CassiopeiaMenu.Drawings:Boolean("E", "Draw E Range", true)
CassiopeiaMenu.Drawings:Boolean("R", "Draw R Range", true)
CassiopeiaMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

OnDraw(function(myHero)
local col = CassiopeiaMenu.Drawings.color:Value()
if CassiopeiaMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),850,1,0,col) end
if CassiopeiaMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),925,1,0,col) end
if CassiopeiaMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),700,1,0,col) end
if CassiopeiaMenu.Drawings.R:Value() then DrawCircle(myHeroPos(),825,1,0,col) end
end)

local poisoned = {}

OnUpdateBuff(function(unit,buff)
  if GetTeam(unit) ~= GetTeam(myHero) and buff.Name:find("poison") then
  poisoned[GetNetworkID(unit)] = buff.Count
  end
end)

OnRemoveBuff(function(unit,buff)
  if GetTeam(unit) ~= GetTeam(myHero) and buff.Name:find("poison") then
  poisoned[GetNetworkID(unit)] = 0
  end
end)

function IsPoisoned(unit)
   return (poisoned[GetNetworkID(unit)] or 0) > 0
end

OnTick(function(myHero)

    if IOW:Mode() == "Combo" then

		local target = GetCurrentTarget()
	     
		if IsReady(_R) and IsFacing(target, 825) and ValidTarget(target, 825) and CassiopeiaMenu.Combo.R:Value() and 100*GetCurrentHP(target)/GetMaxHP(target) <= 50 and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= 30 then
		Cast(_R,target)
		end

	        if IsReady(_E) and IsPoisoned(target) and CassiopeiaMenu.Combo.E:Value() and ValidTarget(target, 700) then
		CastTargetSpell(target, _E)
		end
			
		if IsReady(_Q) and CassiopeiaMenu.Combo.Q:Value() and ValidTarget(target, 850) then
		Cast(_Q,target)
		end
		
		if IsReady(_W) and CassiopeiaMenu.Combo.W:Value() and ValidTarget(target, 925) and not IsPoisoned(target) then
		Cast(_W,target)
		end
		
    end

    if IOW:Mode() == "Harass" then
	
		local target = GetCurrentTarget()

	        if IsReady(_E) and IsPoisoned(target) and CassiopeiaMenu.Harass.E:Value() and ValidTarget(target, 700) then
		CastTargetSpell(target, _E)
		end
			
		if IsReady(_Q) and CassiopeiaMenu.Harass.Q:Value() and ValidTarget(target, 850) then
	        Cast(_Q,target)
		end
		
		if IsReady(_W) and CassiopeiaMenu.Harass.W:Value() and ValidTarget(target, 925) then
		Cast(_W,target)
		end
		
    end

	for i,enemy in pairs(GetEnemyHeroes()) do
		
		if Ignite and CassiopeiaMenu.Misc.AutoIgnite:Value() then
                  if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
                  CastTargetSpell(enemy, Ignite)
                  end
		end
		
		if IsReady(_Q) and ValidTarget(enemy, 850) and CassiopeiaMenu.Killsteal.Q:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 40*GetCastLevel(myHero,_Q)+35+.45*GetBonusAP(myHero) + Ludens()) then 
		Cast(_Q,enemy)
		elseif IsReady(_E) and ValidTarget(enemy, 700) and CassiopeiaMenu.Killsteal.E:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + Ludens()) then
		CastTargetSpell(enemy, _E)
		elseif IsReady(_W) and ValidTarget(enemy, 850) and CassiopeiaMenu.Killsteal.W:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 15*GetCastLevel(myHero,_W)+15+0.3*GetBonusAP(myHero) + Ludens()) then
		Cast(_W,enemy)
		end
		
	end

if CassiopeiaMenu.Misc.Autolvl:Value() then    
   if CassiopeiaMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _E, _W, _E, _E, _R, _E, _Q, _E , _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
   elseif CassiopeiaMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
   elseif CassiopeiaMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_Q, _E, _W, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q}
   end
DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
end

for i=1, IOW.mobs.maxObjects do
               local minion = IOW.mobs.objects[i]
       
               if IOW:Mode() == "LaneClear" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= CassiopeiaMenu.Farm.LaneClear.Mana:Value() then
        	
		  if IsReady(_E) and IsPoisoned(minion) and CassiopeiaMenu.Farm.LaneClear.E:Value() and ValidTarget(minion, 700) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + Ludens()) then
		  CastTargetSpell(minion, _E)
                  end
          
                  if IsReady(_Q) and CassiopeiaMenu.Farm.LaneClear.Q:Value() then
                    local BestPos, BestHit = GetFarmPosition(850, 100)
                    if BestPos and BestHit > 0 then 
                    CastSkillShot(_Q, BestPos.x, BestPos.y, BestPos.z)
                    end
	          end
	          
	          if IsReady(_W) and CassiopeiaMenu.Farm.LaneClear.W:Value() then
                    local BestPos, BestHit = GetFarmPosition(925, 90)
                    if BestPos and BestHit > 0 then 
                    CastSkillShot(_W, BestPos.x, BestPos.y, BestPos.z)
                    end
	          end
	        
	        end
          
                if IOW:Mode() == "LastHit" then
	          if IsReady(_E) and IsPoisoned(minion) and CassiopeiaMenu.Farm.LastHit2.EX:Value() and CassiopeiaMenu.Farm.LastHit2.EXP:Value() and ValidTarget(minion, 700) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + Ludens()) then
		  CastTargetSpell(minion, _E)
		  elseif IsReady(_E) and CassiopeiaMenu.Farm.LastHit2.EX:Value() and not CassiopeiaMenu.Farm.LastHit2.EXP:Value() and ValidTarget(minion, 700) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + Ludens()) then
		  CastTargetSpell(minion, _E)
		  end
	        end
	
	        if CassiopeiaMenu.Misc.AutoE:Value() then
	          if IsReady(_E) and IsPoisoned(minion) and ValidTarget(minion, 700) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+30+0.55*GetBonusAP(myHero) + Ludens()) and IOW:Mode() ~= "Combo" and IOW:Mode() ~= "Harass" then
	          CastTargetSpell(minion, _E)
	          end
	        end
	
end

for _,mob in pairs(minionManager.objects) do
	
       if GetTeam(mob) == 300 and IOW:Mode() == "LaneClear" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= CassiopeiaMenu.JungleClear.Mana:Value() then
	        if IsReady(_E) and IsPoisoned(mob) and CassiopeiaMenu.JungleClear.E:Value() and IsInDistance(mob, 700) then
		CastTargetSpell(mob, _E)
		end
			
		if IsReady(_Q) and CassiopeiaMenu.JungleClear.Q:Value() and IsInDistance(mob, 850) then
		  local BestPos, BestHit = GetJFarmPosition(850, 100)
                  if BestPos and BestHit > 0 then 
                  CastSkillShot(_Q, BestPos.x, BestPos.y, BestPos.z)
		  end
		end

		if IsReady(_W) and CassiopeiaMenu.JungleClear.W:Value() and IsInDistance(mob, 925) then
		  local BestPos, BestHit = GetJFarmPosition(925, 90)
                  if BestPos and BestHit > 0 then 
                  CastSkillShot(_W, BestPos.x, BestPos.y, BestPos.z)
		  end
                end
       end
end

end)
