--[[ Todo :
- Q logic : Combo/LaneClear/JungleClear/
- E logic ??
]]

if GetObjectName(GetMyHero()) ~= "Jinx" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end
if not pcall( require, "Deftlib" ) then PrintChat("You are missing Deftlib.lua - Go download it and save it in Common!") return end

local JinxMenu = MenuConfig("Jinx", "Jinx")
JinxMenu:Menu("Combo", "Combo")
JinxMenu.Combo:Boolean("Q", "Use Q", true)
JinxMenu.Combo:Boolean("W", "Use W", true)
JinxMenu.Combo:Boolean("E", "Use E", true)
JinxMenu.Combo:Boolean("ECC", "Auto E on CCed", true)
JinxMenu.Combo:Boolean("R", "Use R (Finisher)", true)
JinxMenu.Combo:Boolean("Items", "Use Items", true)
JinxMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
JinxMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
JinxMenu.Combo:Boolean("QSS", "Use QSS", true)
JinxMenu.Combo:Slider("QSSHP", "if My Health % <", 75, 0, 100, 1)

JinxMenu:Menu("Harass", "Harass")
JinxMenu.Harass:Boolean("Q", "Use Q", true)
JinxMenu.Harass:Boolean("W", "Use W", true)
JinxMenu.Harass:Boolean("E", "Use E", true)
JinxMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

JinxMenu:Menu("Killsteal", "Killsteal")
JinxMenu.Killsteal:Boolean("W", "Killsteal with W", true)
JinxMenu.Killsteal:Boolean("R", "Killsteal with R", true)

JinxMenu:Menu("Misc", "Misc")
if Ignite ~= nil then JinxMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true) end
JinxMenu.Misc:Boolean("Autolvl", "Auto level", true)
JinxMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-W-E", "W-Q-E"})
	
JinxMenu:Menu("Lasthit", "Lasthit")
JinxMenu.Lasthit:Boolean("Farm", "Always Switch To Minigun", true)

JinxMenu:Menu("LaneClear", "LaneClear")
JinxMenu.LaneClear:Boolean("Farm", "Always Switch To Minigun", true)

JinxMenu:Menu("Drawings", "Drawings")
JinxMenu.Drawings:Boolean("W", "Draw W Range", true)
JinxMenu.Drawings:Boolean("E", "Draw E Range", true)
JinxMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})

OnDraw(function(myHero)
local col = JinxMenu.Drawings.color:Value()
if JinxMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),1500,1,0,col) end
if JinxMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),920,1,0,col) end
end)

local IsMinigun = true

OnUpdateBuff(function(unit,buff)
  if unit == myHero and buff.Name == "jinxqicon" then
  IsMinigun = true
  end
end)

OnRemoveBuff(function(unit,buff)
  if unit == myHero and buff.Name == "jinxqicon" then
  IsMinigun = false
  end
end)

OnTick(function(myHero)
    local target = GetCurrentTarget()

    if IOW:Mode() == "Combo" then
	
	local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1750,1200,920,60,false,true)
		
	if GetItemSlot(myHero,3140) > 0 and IsReady(GetItemSlot(myHero,3140)) and JinxMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and GetPercentHP(myHero) < JinxMenu.Combo.QSSHP:Value() then
        CastSpell(GetItemSlot(myHero,3140))
        end

        if GetItemSlot(myHero,3139) > 0 and IsReady(GetItemSlot(myHero,3139)) and JinxMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and GetPercentHP(myHero) < JinxMenu.Combo.QSSHP:Value() then
        CastSpell(GetItemSlot(myHero,3139))
        end
		
	if IsReady(_Q) and JinxMenu.Combo.Q:Value() and ValidTarget(target, 800) then
          if GetDistance(target) >= 570 and IsMinigun then
          CastSpell(_Q)
          elseif GetDistance(target) <= 525 and not IsMinigun then
          CastSpell(_Q)
          end
        end
	
	if IsReady(_W) and ValidTarget(target, 1500) and GetDistance(target) > 525 and JinxMenu.Combo.W:Value() then
        Cast(_W,target)
        end
	
	if IsReady(_E) and EPred.HitChance == 1 and ValidTarget(target, 920) and IsFacing(target, 920) and JinxMenu.Combo.E:Value() then
        CastSkillShot(_E,EPred.PredPos.x-100,EPred.PredPos.y-100,EPred.PredPos.z-100)
        elseif IsReady(_E) and EPred.HitChance == 1 and ValidTarget(target, 920) and JinxMenu.Combo.E:Value() then
        CastSkillShot(_E,EPred.PredPos.x+100,EPred.PredPos.y+100,EPred.PredPos.z+100)
        end
	
	if IsReady(_R) and ValidTarget(target, 3000) and JinxMenu.Combo.R:Value() and GetCurrentHP(target) < CalcDamage(myHero, target, (GetMaxHP(target)-GetCurrentHP(target))*(0.2+0.05*GetCastLevel(myHero, _R))+(150+100*GetCastLevel(myHero, _R)+GetBonusDmg(myHero))*math.max(0.1, math.min(1, GetDistance(target)/1700))) then
        Cast(_R,target)
        end

  end

    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= JinxMenu.Harass.Mana:Value() then
	
	local EPred = GetPredictionForPlayer(myHeroPos(),target,GetMoveSpeed(target),1750,1200,920,60,false,true)
		
	if IsReady(_Q) and JinxMenu.Harass.Q:Value() and ValidTarget(target, 700) then
          if GetDistance(target) >= 570 and IsMinigun then
          CastSpell(_Q)
          elseif GetDistance(target) <= 525 and not IsMinigun then
          CastSpell(_Q)
          end
        end
	
	if IsReady(_W) and ValidTarget(target, 1500) and GetDistance(target) > 525 and JinxMenu.Harass.W:Value() then
        Cast(_W,target)
        end
	
	if IsReady(_E) and EPred.HitChance == 1 and ValidTarget(target, 920) and IsFacing(target, 920) and JinxMenu.Harass.E:Value() then
        CastSkillShot(_E,EPred.PredPos.x-100,EPred.PredPos.y-100,EPred.PredPos.z-100)
        elseif IsReady(_E) and EPred.HitChance == 1 and ValidTarget(target, 920) and JinxMenu.Harass.E:Value() then
        CastSkillShot(_E,EPred.PredPos.x+100,EPred.PredPos.y+100,EPred.PredPos.z+100)
        end
		
	end

if IsReady(_E) and ValidTarget(target, 920) then
  if IsImmobile(target) then
  CastSkillShot(_E, GetOrigin(target))
  end
end

if IOW:Mode() == "LastHit" and not IsMinigun and JinxMenu.Lasthit.Farm:Value() then
  CastSpell(_Q)
end
  
if IOW:Mode() == "LaneClear" and not IsMinigun and JinxMenu.LaneClear.Farm:Value() then
  CastSpell(_Q)
end
  
    for i,enemy in pairs(GetEnemyHeroes()) do
	
	if IOW:Mode() == "Combo" then	
	if GetItemSlot(myHero,3153) > 0 and IsReady(GetItemSlot(myHero,3153)) and JinxMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and GetPercentHP(myHero) < JinxMenu.Combo.myHP:Value() and GetPercentHP(enemy) > JinxMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, GetItemSlot(myHero,3153))
        end

        if GetItemSlot(myHero,3144) > 0 and IsReady(GetItemSlot(myHero,3144)) and JinxMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and GetPercentHP(myHero) < JinxMenu.Combo.myHP:Value() and GetPercentHP(enemy) > JinxMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, GetItemSlot(myHero,3144))
        end

        if GetItemSlot(myHero,3142) > 0 and IsReady(GetItemSlot(myHero,3142)) and JinxMenu.Combo.Items:Value() and ValidTarget(enemy, 600) then
        CastSpell(GetItemSlot(myHero,3142))
        end
        end
		
	if Ignite and JinxMenu.Misc.AutoIgnite:Value() then
          if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
          CastTargetSpell(enemy, Ignite)
          end
        end
		
        if IsReady(_W) and ValidTarget(enemy, 1500) and JinxMenu.Killsteal.W:Value() and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 50*GetCastLevel(myHero,_Q) - 40 + 1.4*GetBaseDamage(myHero)) then  
        Cast(_W,enemy)
	elseif IsReady(_R) and ValidTarget(enemy, 3000) and GetDistance(myHero, enemy) > 400 and JinxMenu.Killsteal.R:Value() and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, (GetMaxHP(enemy)-GetCurrentHP(enemy))*(0.2+0.05*GetCastLevel(myHero, _R))+(150+100*GetCastLevel(myHero, _R)+GetBonusDmg(myHero))*math.max(0.1, math.min(1, GetDistance(enemy)/1700))) then 
        Cast(_R,enemy)
        end
    end

if JinxMenu.Misc.Autolvl:Value() then
    if JinxMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif JinxMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    end
DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
end

end)

AddGapcloseEvent(_E, 0, false)
