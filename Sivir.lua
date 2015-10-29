--[[ TODO:
-Laneclear/Jungleclear
-Auto E
]]

if GetObjectName(GetMyHero()) ~= "Sivir" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end

local SivirMenu = MenuConfig("Sivir", "Sivir")
SivirMenu:Menu("Combo", "Combo")
SivirMenu.Combo:Boolean("Q", "Use Q", true)
SivirMenu.Combo:Slider("QMana", "Q if Mana % >", 30, 0, 80, 1)
SivirMenu.Combo:Boolean("W", "Use W", true)
SivirMenu.Combo:Boolean("R", "Use R", true)
SivirMenu.Combo:Slider("Rmin", "Minimum Enemies in Range", 2, 1, 5, 1)
SivirMenu.Combo:Slider("RMana", "R if Mana % >", 30, 0, 80, 1)
SivirMenu.Combo:Boolean("Items", "Use Items", true)
SivirMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
SivirMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
SivirMenu.Combo:Boolean("QSS", "Use QSS", true)
SivirMenu.Combo:Slider("QSSHP", "if My Health % <", 75, 0, 100, 1)

SivirMenu:Menu("Harass", "Harass")
SivirMenu.Harass:Boolean("Q", "Use Q", true)
SivirMenu.Harass:Boolean("W", "Use W", true)
SivirMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

SivirMenu:Menu("Killsteal", "Killsteal")
SivirMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)

SivirMenu:Menu("Misc", "Misc")
SivirMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true)
SivirMenu.Misc:Boolean("Autolvl", "Auto level", true)
SivirMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E", "E-Q-W"})

SivirMenu:Menu("Drawings", "Drawings")
SivirMenu.Drawings:Boolean("Q", "Draw Q Range", true)
Menu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

OnDraw(function(myHero)
if SivirMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),1075,1,0,0xff00ff00) end
end)

OnTick(function(myHero)
 if IOW:Mode() == "Combo" then
	
	local target = GetCurrentTarget()
 
	if IsReady(_Q) and ValidTarget(target, 1075) and SivirMenu.Combo.Q:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= SivirMenu.Combo.QMana:Value() then
        Cast(_Q,target)
        end
		
	if GetItemSlot(myHero,3140) > 0 and SivirMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < SivirMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3140))
        end

        if GetItemSlot(myHero,3139) > 0 and SivirMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < SivirMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3139))
        end
		
	if IsReady(_R) and ValidTarget(target, 600) and SivirMenu.Combo.R:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= SivirMenu.Combo.RMana:Value() and EnemiesAround(myHeroPos(), 600) >= SivirMenu.Combo.Rmin:Value() then
	CastSpell(_R)
	end

 end

 if IOW:Mode() == "Harass" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= SivirMenu.Harass.Mana:Value() then
 
        local target = GetCurrentTarget()
  
	if IsReady(_Q) and ValidTarget(target, 1075) and SivirMenu.Harass.Q:Value() then
        Cast(_Q,target)
        end

 end
 
 for i,enemy in pairs(GetEnemyHeroes()) do
	
	if IOW:Mode() == "Combo" then	
	if GetItemSlot(myHero,3153) > 0 and SivirMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < SivirMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > SivirMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, GetItemSlot(myHero,3153))
        end

        if GetItemSlot(myHero,3144) > 0 and SivirMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < SivirMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > SivirMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, GetItemSlot(myHero,3144))
        end

        if GetItemSlot(myHero,3142) > 0 and SivirMenu.Combo.Items:Value() and ValidTarget(enemy, 600) then
        CastTargetSpell(myHero, GetItemSlot(myHero,3142))
        end
        end
        
	if Ignite and SivirMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
	end
	
	if IsReady(_Q) and ValidTarget(enemy, 1075) and SivirMenu.Killsteal.Q:Value() and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 20*GetCastLevel(myHero,_Q)+5+(0.6+0.1*GetCastLevel(myHero, _Q))*(GetBaseDamage(myHero)+GetBonusDmg(myHero)) + 0.5*GetBonusAP(myHero), 0) then 
Cast(_Q,enemy)
	end
		
end
  
if SivirMenu.Misc.Autolvl:Value() then
      if SivirMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_W, _Q, _E, _Q, _Q , _R, _Q , _W, _Q , _W, _R, _W, _W, _E, _E, _R, _E, _E}
      elseif SivirMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
      elseif SivirMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_W, _Q, _E, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
      end
DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
end

end)

OnProcessSpell(function(unit, spell)
    local target = GetCurrentTarget()
    if unit and spell and spell.name then
      if unit == myHero then
        if spell.name:lower():find("attack") then 
	        DelayAction(function() 

                                 if IOW:Mode() == "Combo" and ValidTarget(target, 600) and CanUseSpell(myHero, _W) == READY and SivirMenu.Combo.W:Value() then	  
                                 CastSpell(_W)		
 			         end
                                                
                                 if IOW:Mode() == "Harass" and ValidTarget(target, 600) and CanUseSpell(myHero, _W) == READY and SivirMenu.Harass.W:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= SivirMenu.Harass.Mana:Value() then	  
                                 CastSpell(_W)
                                 end
                       
                end, GetWindUp(myHero)*1000)
            end
      end
  end
end)
