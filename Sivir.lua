if GetObjectName(GetMyHero()) ~= "Sivir" then return end

require('Inspired')
require('DeftLib')
require('DamageLib')

AutoUpdate("/D3ftsu/GoS/master/Sivir.lua","/D3ftsu/GoS/master/Sivir.version","Sivir.lua",1)

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
	
SivirMenu:Menu("LaneClear", "LaneClear")
SivirMenu.LaneClear:Boolean("Q", "Use Q", true)
--SivirMenu.LaneClear:Boolean("W", "Use W", false)
SivirMenu.LaneClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

SivirMenu:Menu("JungleClear", "JungleClear")
SivirMenu.JungleClear:Boolean("Q", "Use Q", true)
--SivirMenu.JungleClear:Boolean("W", "Use W", true)
SivirMenu.JungleClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

SivirMenu:Menu("Drawings", "Drawings")
SivirMenu.Drawings:Boolean("Q", "Draw Q Range", true)

OnDraw(function(myHero)
if SivirMenu.Drawings.Q:Value() then DrawCircle(GetOrigin(myHero),1075,1,25,GoS.Pink) end
end)

IOW:AddCallback(AFTER_ATTACK, function(target, mode)
  if IsReady(_W) then 
    if mode == "Combo" and target ~= nil and SivirMenu.Combo.W:Value() then
    CastSpell(_W)
    end
    
    if mode == "Combo" and target ~= nil and SivirMenu.Harass.W:Value() and GetPercentMP(myHero) >= SivirMenu.Harass.Mana:Value() then
    CastSpell(_W)
    end
  end
end)

local target1 = TargetSelector(1125,TARGET_LESS_CAST_PRIORITY,DAMAGE_PHYSICAL,true,false)
local lastlevel = GetLevel(myHero)-1

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local QSS = GetItemSlot(myHero,3140) > 0 and GetItemSlot(myHero,3140) or GetItemSlot(myHero,3139) > 0 and GetItemSlot(myHero,3139) or nil
    local BRK = GetItemSlot(myHero,3153) > 0 and GetItemSlot(myHero,3153) or GetItemSlot(myHero,3144) > 0 and GetItemSlot(myHero,3144) or nil
    local YMG = GetItemSlot(myHero,3142) > 0 and GetItemSlot(myHero,3142) or nil
    local Qtarget = target1:GetTarget()
    
    if IOW:Mode() == "Combo" then

	if IsReady(_Q) and SivirMenu.Combo.Q:Value() and GetPercentMP(myHero) >= SivirMenu.Combo.QMana:Value() and not IOW.isWindingUp then
        Cast(_Q,target)
        end
		
	if IsReady(_R) and ValidTarget(target, 600) and SivirMenu.Combo.R:Value() and GetPercentMP(myHero) >= SivirMenu.Combo.RMana:Value() and EnemiesAround(GetOrigin(myHero), 600) >= SivirMenu.Combo.Rmin:Value() then
	CastSpell(_R)
        end

        if QSS and IsReady(QSS) and SivirMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and GetPercentHP(myHero) < SivirMenu.Combo.QSSHP:Value() then
        CastSpell(QSS)
        end

    end

    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= SivirMenu.Harass.Mana:Value() then

	if IsReady(_Q) and SivirMenu.Harass.Q:Value() then
        Cast(_Q,target)
        end

    end
 
    for i,enemy in pairs(GetEnemyHeroes()) do
	
      if IOW:Mode() == "Combo" then	
	if BRK and IsReady(BRK) and SivirMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and GetPercentHP(myHero) < SivirMenu.Combo.myHP:Value() and GetPercentHP(enemy) > SivirMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, BRK)
        end

        if YMG and IsReady(YMG) and SivirMenu.Combo.Items:Value() and ValidTarget(enemy, 600) then
        CastSpell(YMG)
        end	
      end
        
      if Ignite and SivirMenu.Misc.AutoIgnite:Value() then
        if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
        CastTargetSpell(enemy, Ignite)
        end
      end
	
      if IsReady(_Q) and ValidTarget(enemy, 1125) and SivirMenu.Killsteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then 
      Cast(_Q,enemy)
      end
		
    end

    if IOW:Mode() == "LaneClear" then
 
      if GetPercentMP(myHero) >= SivirMenu.LaneClear.Mana:Value() then
        if IsReady(_Q) and SivirMenu.LaneClear.Q:Value() then
          local BestPos, BestHit = GetLineFarmPosition(1075, 85, MINION_ENEMY)
          if BestPos and BestHit > 2 then 
          CastSkillShot(_Q, BestPos)
          end
	end
      end

    end
         
    for i,mobs in pairs(minionManager.objects) do
      if IOW:Mode() == "LaneClear" and GetTeam(mobs) == 300 and GetPercentMP(myHero) >= SivirMenu.JungleClear.Mana:Value() then
        if IsReady(_Q) and SivirMenu.JungleClear.Q:Value() and ValidTarget(mobs, 1075) then
        CastSkillShot(_Q,GetOrigin(mobs))
	end
      end
    end

if SivirMenu.Misc.Autolvl:Value() then
  if GetLevel(myHero) > lastlevel then
    if SivirMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_W, _Q, _E, _Q, _Q , _R, _Q , _W, _Q , _W, _R, _W, _W, _E, _E, _R, _E, _E}
    elseif SivirMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
    elseif SivirMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_W, _Q, _E, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
    end
    DelayAction(function() LevelSpell(leveltable[GetLevel(myHero)]) end, math.random(1000,3000))
    lastlevel = GetLevel(myHero)
  end
end

end)
